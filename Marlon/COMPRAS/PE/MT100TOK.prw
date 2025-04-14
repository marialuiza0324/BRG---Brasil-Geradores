#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT100TOK
 Esse Ponto de Entrada é chamado 2 vezes dentro da rotina A103Tudok().
 Para o controle do número de vezes em que ele é chamado foi criada a 
 variável lógica lMT100TOK, que quando for definida como (.F.) 
 o ponto de entrada será chamado somente uma vez.
 Valida inclusão de NF.
@type  Function
@author Maria Luiza
@since 05/09/2024 */

User Function MT100TOK()

    Local lRet := .T.
    Local lMT100TOK := .F. 

    Local cRateio := "" // Variável que vai armazenar o rateio
    Local cCentroCusto := "" // Variável para o centro de custo
    Local aArea := FWGetArea()
    Local cCond   := ""
    Local nVIPI   := 0
    Local nValTot := 0
    Local dData
    Local nVSol   := 0
    Local _Venc   := CtoD("  /  /  ")
    Local _Total  := 0
    Local _Parc   := " "
    Local i := 1
    Local nX := 1
    Local lAchou:= .f.
    Local cTipo := "PR"
    Local cQuery := ""
    Local aDelet := {}
    Local nTotal := 0
    Local lMsErroAuto := .F.
    Local cNumPC  := ""
    Local cItemPc := ""
    Local lMsg :=.F.
    Local nLinha := 0
    Local lRastro := .T.
    

    If !FWIsInCallStack("A103Devol") //só entra na validação caso não esteja selecionada a opção de retornar NF
        cCentroCusto := ACOLS[1][16] // Obtendo o centro de custo e o rateio
        cRateio := ACOLS[1][57] 

        // Verificando se o centro de custo está vazio e se o rateio está informado
        If Empty(cCentroCusto) .and. cRateio == "1"
            // Se o centro de custo está vazio e há rateio, permite a confirmação
            lRet := .T. // Permite continuar sem erro
        ElseIf Empty(cCentroCusto) .and. cRateio == "2"
            // Se ambos estão vazios, bloqueia a gravação e exibe uma mensagem
            FWAlertInfo("Informe um centro de custo ou rateio.", "Atenção!!!")
            lRet := .F. // Bloqueia a confirmação
        EndIf
  

        For nX := 1 To Len(ACOLS) //percorre todas as linhas da pré-nota

        IF dbSeek(xFilial("SB1")+ACOLS[nX][2])//busca produto na SB1
            If SB1->B1_RASTRO == "L" .AND. Empty(ACOLS[nX][7])//se produto possuir ratreabilidade e lote estiver vazio
                lRet  := .F. //não permite inclusão do doc 
                lRastro := .F.
                FWAlertInfo("Item com Rastreabilidade, informe o Lote"," Atenção!!!")
                Return
            EndIf
        EndIf


	  // Verifica se o lote já foi usado em outra linha
        For nLinha := 1 To Len(Acols)
            If nLinha != n // Ignora a linha atual
                If Upper(AllTrim(Acols[nLinha, nPosLoteCtl])) == Upper(AllTrim(Acols[n, nPosLoteCtl])) .And. !Empty(Acols[n, nPosLoteCtl])
                    FWAlertInfo("O lote '" + Alltrim(Acols[n, nPosLoteCtl]) + "' já foi utilizado em outro item. Corrija para prosseguir.", "Lote Duplicado!")
                    lRet := .F.
                    Return
                EndIf
            EndIf
        Next



        cNumPC := ACOLS[nX][35] //Num Pc
        cItemPc := ACOLS[nX][36] //Item Pc 

        If Select("TSC7") > 0
            TSC7->(dbCloseArea())
        EndIf

        _cQry := "SELECT DISTINCT C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO,C7_FORNECE, C7_DATPRF, SUM(C7_TOTAL) TOTAL, SUM(C7_VALIPI) VALIPI, SUM(C7_VALSOL) VALSOL "
        _cQry += "FROM " + retsqlname("SC7")+" SC7 "
        _cQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
        _cQry += "AND   SC7.C7_FILIAL   = '" + cFilAnt  + "' "
        _cQry += "AND   SC7.C7_NUM	= '" + cNumPC  + "' "
        //_cQry += "AND   SC7.C7_ITEM = '" + cItemPc + "' "
        _cQry += "AND   SC7.C7_ENCER = '' "
        _cQry += "AND   SC7.C7_QUJE <  SC7.C7_QUANT "
        _cQry += "GROUP BY C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF,C7_FORNECE "
        _cQry += "ORDER BY C7_FILIAL, C7_NUM , C7_DATPRF "

        DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TSC7",.T.,.T.) //filtrando pedido na SC7

            dData :=  stod(TSC7->C7_DATPRF)
            _Forn   := AllTrim(TSC7->C7_FORNECE)
            cCond   := TSC7->C7_COND //Condição de pagamento
            nValTot := TSC7->TOTAL + TSC7->VALIPI + TSC7->VALSOL //somando valor total do PC
            aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol)

        For i:= 1 to Len(aParc)  //laço de repetição de acordo com a quantidade de parcelas
            _Venc  := Lastday(aParc[i,1],3) //vencimento
            _Total := aParc[i,2] //valor da parcela
            _Parc  := cvaltochar(i) //Nº da parcela

            aDelet := { { "E2_PREFIXO" , "PRV" , NIL },; //Array de exclusão do título
            { "E2_NUM" , PadR(AllTrim(cNumPC+"/"+substr(cItemPc,3,4)),TamSx3("E2_NUM")[1])  , NIL },; //Validando tamanho do campo na SX3
            { "E2_PARCELA" , PadR(AllTrim(_Parc),TamSx3("E2_PARCELA")[1])   , NIL },;
            { "E2_TIPO" , PadR(AllTrim(cTipo),TamSx3("E2_TIPO")[1])  , NIL },;
            { "E2_NATUREZ" , PadR(AllTrim("202010058"),TamSx3("E2_NATUREZ")[1])  , NIL }}

            If Select("TSE2") > 0
                TSE2->(dbCloseArea())
            EndIf

            cQuery := " SELECT * FROM " + retsqlname("SE2") + " "
            cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND E2_PREFIXO = 'PRV' "
            cQuery += " AND E2_NUM = '"+cNumPC+"/"+substr(cItemPc,3,4)+"' AND E2_PARCELA = '"+_Parc+"'
            cQuery += " AND E2_TIPO = '" +cTipo+"' AND D_E_L_E_T_ <> '*' "

            DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TSE2",.T.,.T.)

            DbSelectArea("TSE2") //query retorna se existe título na SE2 com chave informada

            TSE2->( dbGoTop() )
            Count To nTotal

            If  nTotal > 0
                lAchou := .T.
            EndIf

            TSE2->(DbCloseArea())

            Begin Transaction

                If lAchou //se achar título na query acima, deleta ele
                    MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aDelet,, 5) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

                    If lMsErroAuto //se der erro cancela exclusão e mostra erro
                        FWAlertInfo("Sistema não conseguiu excluir o título, refaça o processo","Atenção!!!")
                        MostraErro()
                        DisarmTransaction()
                        lMsg := .F.
                    Else
                        lMsErroAuto:= .F.
                        lRet := .T.
                        lMsg := .T.
                    Endif
                Else 
                lRet := .T.
                EndIf

            End Transaction

            lAchou := .F. // zera variável
        Next i

    Next nX

            SB1->(DbCloseArea())
            FwRestArea(aArea)

           
		If lRastro = .F. 
			lRet := .F.
		EndIf

		If lMsg = .T. .AND. lRastro = .T.
			FWAlertInfo("Título financeiro excluído com sucesso.","Atenção!!!")
		EndIf 

    Else

        For nX := 1 To Len(ACOLS) //percorre todas as linhas da pré-nota

    cNumPC := ACOLS[nX][25] //Num Pc
    cItemPc := ACOLS[nX][1] //Item Pc 

        If Select("TSC7") > 0
            TSC7->(dbCloseArea())
        EndIf

        _cQry := "SELECT DISTINCT C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO,C7_FORNECE, C7_DATPRF, SUM(C7_TOTAL) TOTAL, SUM(C7_VALIPI) VALIPI, SUM(C7_VALSOL) VALSOL "
        _cQry += "FROM " + retsqlname("SC7")+" SC7 "
        _cQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
        _cQry += "AND   SC7.C7_FILIAL   = '" + cFilAnt  + "' "
        _cQry += "AND   SC7.C7_NUM	= '" + cNumPC  + "' "
        //_cQry += "AND   SC7.C7_ITEM = '" + cItemPc + "' "
        _cQry += "AND   SC7.C7_ENCER = '' "
        _cQry += "AND   SC7.C7_QUJE <  SC7.C7_QUANT "
        _cQry += "GROUP BY C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF,C7_FORNECE "
        _cQry += "ORDER BY C7_FILIAL, C7_NUM , C7_DATPRF "

        DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TSC7",.T.,.T.) //filtrando pedido na SC7

            dData :=  stod(TSC7->C7_DATPRF)
            _Forn   := AllTrim(TSC7->C7_FORNECE)
            cCond   := TSC7->C7_COND //Condição de pagamento
            nValTot := TSC7->TOTAL + TSC7->VALIPI + TSC7->VALSOL //somando valor total do PC
            aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol)

        For i:= 1 to Len(aParc)  //laço de repetição de acordo com a quantidade de parcelas
            _Venc  := Lastday(aParc[i,1],3) //vencimento
            _Total := aParc[i,2] //valor da parcela
            _Parc  := cvaltochar(i) //Nº da parcela

            aDelet := { { "E2_PREFIXO" , "PRV" , NIL },; //Array de exclusão do título
            { "E2_NUM" , PadR(AllTrim(cNumPC+"/"+substr(cItemPc,3,4)),TamSx3("E2_NUM")[1])  , NIL },; //Validando tamanho do campo na SX3
            { "E2_PARCELA" , PadR(AllTrim(_Parc),TamSx3("E2_PARCELA")[1])   , NIL },;
            { "E2_TIPO" , PadR(AllTrim(cTipo),TamSx3("E2_TIPO")[1])  , NIL },;
            { "E2_NATUREZ" , PadR(AllTrim("202010058"),TamSx3("E2_NATUREZ")[1])  , NIL }}

            If Select("TSE2") > 0
                TSE2->(dbCloseArea())
            EndIf

            cQuery := " SELECT * FROM " + retsqlname("SE2") + " "
            cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND E2_PREFIXO = 'PRV' "
            cQuery += " AND E2_NUM = '"+cNumPC+"/"+substr(cItemPc,3,4)+"' AND E2_PARCELA = '"+_Parc+"'
            cQuery += " AND E2_TIPO = '" +cTipo+"' AND D_E_L_E_T_ <> '*' "

            DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TSE2",.T.,.T.)

            DbSelectArea("TSE2") //query retorna se existe título na SE2 com chave informada

            TSE2->( dbGoTop() )
            Count To nTotal

            If  nTotal > 0
                lAchou := .T.
            EndIf

            TSE2->(DbCloseArea())

            Begin Transaction

                If lAchou //se achar título na query acima, deleta ele
                    MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aDelet,, 5) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

                    If lMsErroAuto //se der erro cancela exclusão e mostra erro
                        FWAlertInfo("Sistema não conseguiu excluir o título, refaça o processo","Atenção!!!")
                        MostraErro()
                        DisarmTransaction()
                        lMsg := .F.
                    Else
                        lMsErroAuto:= .F.
                        lRet := .T.
                        lMsg := .T.
                    Endif
                Else 
                lRet := .T.
                EndIf

            End Transaction

            lAchou := .F. // zera variável
        Next i

    Next nX

            SB1->(DbCloseArea())
            FwRestArea(aArea)

            If lMsg = .T. 
                FWAlertInfo("Título financeiro excluído com sucesso.","Atenção!!!")
            EndIf 
      EndIf

Return lRet 
