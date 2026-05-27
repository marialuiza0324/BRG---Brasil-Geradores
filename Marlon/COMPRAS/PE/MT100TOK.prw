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
    local nPosLoteCtl := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_LOTECTL"})
    Local lPag := .T.
    local nCentroC       := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_CC"})
    local nRateio        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_RATEIO"})
    Local nProduto       := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"})
    Local nTes           := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_TES"})
    Local nDiasMin := 4
    Local dVencMin := Date() + nDiasMin
    Local cProduto       := " "
    Local cFilDoc  := SupergetMv("MV_FILDOCE", , ) // Parâmetro que controla filiais que irão sofrer o bloqueio de vencimento mínimo
    Local cTesDupl := ""
    local cAdiant  := ""
    Local nPosTes        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_TES"})
    Local cTes           := ""

 If Funname() <> "LOCA001" .AND. Funname() <> "MATA116" .AND. FunName() <> "RPC" .AND. Funname() <> "SPEDNFE"

 If cFilAnt $ cFilDoc //verifica se a filial do documento está na lista do parâmetro 

        cTesDupl := Posicione("SF4",1,xFilial("SF4")+acols[n][nTes],"F4_DUPLIC") //posiciona na SF4 para verificar se a TES gera duplicata
        cAdiant  := Posicione("SE4",1,xFilial("SE4")+CCONDICAO,"E4_CTRADT") //posiciona na SB1 para verificar se o produto é adiantamento

        If !Empty(cTesDupl) .AND. Alltrim(cTesDupl) == "S" .AND. cAdiant == "2" //só entra na validação caso a TES gere duplicata
            cProduto := ACOLS[n][nProduto] //pega o produto da linha atual do array

            If Alltrim(cProduto) == 'S0000018'
                dVencMin := Date() + 2
                // Se o vencimento mínimo cair no sábado ou domingo, ajusta para segunda-feira
                If Dow(dVencMin) == 7 // Sábado
                    dVencMin := dVencMin + 2
                ElseIf Dow(dVencMin) == 1 // Domingo
                    dVencMin := dVencMin + 1
                EndIf
            Else
                dVencMin := Date() + 7
                If Dow(Date()) == 5 // Quinta-feira
                    // Se o vencimento mínimo cair no sábado ou domingo, ajusta para segunda-feira
                    If Dow(dVencMin) == 7 // Sábado
                        dVencMin := dVencMin + 3
                    ElseIf Dow(dVencMin) == 1 // Domingo
                        dVencMin := dVencMin + 2
                    EndIf
                EndIf
            EndIf

            // Validação de vencimento: se DNEWVENC estiver vazio, valida DEMISOLD; senão, valida apenas DNEWVENC
            If Empty(DNEWVENC)
                If DDEMISSAO <= dVencMin .OR. DATE() >= dVencMin
                    If cProduto <> 'S0000018'
                        Help(, ,"AVISO#0028", ,"A data de vencimento do título é inválida. O vencimento mínimo permitido é " + DToC(Lastday(dVencMin,3)) + ".",1, 0, , , , , , {"Renegocie com o fornecedor e ajuste a data de vencimento do título."})
                        lRet := .F.
                        Return lRet
                    Else
                        Help(, ,"AVISO#0028", ,"A data de vencimento do título é inválida. O vencimento mínimo permitido é " + DToC(Lastday(dVencMin,3)) + ".",1, 0, , , , , , {"Renegocie com o fornecedor e ajuste a data de vencimento do título."})
                        lRet := .F.
                        Return lRet
                    EndIf
                EndIf
            ElseIf DNEWVENC < dVencMin .OR. DATE() >= dVencMin
                    If cProduto <> 'S0000018'
                        Help(, ,"AVISO#0028", ,"A data de vencimento do título é inválida. O vencimento mínimo permitido é " + DToC(Lastday(dVencMin,3)) + ".",1, 0, , , , , , {"Renegocie com o fornecedor e ajuste a data de vencimento do título."})
                        lRet := .F.
                        Return lRet
                    Else
                        Help(, ,"AVISO#0028", ,"A data de vencimento do título é inválida. O vencimento mínimo permitido é " + DToC(Lastday(dVencMin,3)) + ".",1, 0, , , , , , {"Renegocie com o fornecedor e ajuste a data de vencimento do título."})
                        lRet := .F.
                        Return lRet
                    EndIf
            EndIf
        Endif
    EndIf

        cCentroCusto := ACOLS[n][nCentroC] 
        cRateio := ACOLS[n][nRateio] 
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

        cTes:= Posicione("SF4",1,FwxFilial("SF4")+ACOLS[nX][nPosTes],'F4_ESTOQUE')
            DbSelectArea("SB1")
            DbSetOrder(1)   

            IF dbSeek(xFilial("SB1")+ACOLS[nX][2]) //busca produto na SB1
                If SB1->B1_RASTRO == "L" .AND. Empty(ACOLS[nX][7]) .AND. cTes == "S"//se produto possuir ratreabilidade e lote estiver vazio
                    lRet  := .F. //não permite inclusão do doc 
                    lRastro := .F.
                    FWAlertInfo("Item com Rastreabilidade, informe o Lote"," Atenção!!!")
                    Return lRet
                EndIf
            EndIf

            // Verifica se o lote já foi usado em outra linha
            For nLinha := 1 To Len(Acols)
                If nLinha != n // Ignora a linha atual
                    If Upper(AllTrim(Acols[nLinha, nPosLoteCtl])) == Upper(AllTrim(Acols[n, nPosLoteCtl])) .And. !Empty(Acols[n, nPosLoteCtl])
                        FWAlertInfo("O lote '" + Alltrim(Acols[n, nPosLoteCtl]) + "' já foi utilizado em outro item. Corrija para prosseguir.", "Lote Duplicado!")
                        lRet := .F.
                        Return lRet
                    EndIf
                EndIf
            Next

            cNumPC := ACOLS[nX][35] //Num Pc
            cItemPc := ACOLS[nX][36] //Item Pc 

            If !Empty(cNumPC) .And. !Empty(cItemPc) //se num pc e item pc estiverem preenchidos, entra na rotina de exclusão do título
                If Select("TSC7") > 0
                    TSC7->(dbCloseArea())
                EndIf

                _cQry := "SELECT DISTINCT C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO,C7_FORNECE,C7_LOJA, C7_DATPRF,C7_XDTPRF, SUM(C7_TOTAL) TOTAL, SUM(C7_VALIPI) VALIPI, SUM(C7_VALSOL) VALSOL "
                _cQry += "FROM " + retsqlname("SC7")+" SC7 "
                _cQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
                _cQry += "AND   SC7.C7_FILIAL   = '" + cFilAnt  + "' "
                _cQry += "AND   SC7.C7_NUM	= '" + cNumPC  + "' "
                _cQry += "AND   SC7.C7_ENCER = '' "
                _cQry += "AND   SC7.C7_QUJE <  SC7.C7_QUANT "
                _cQry += "GROUP BY C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF,C7_FORNECE,C7_LOJA,C7_XDTPRF "
                _cQry += "ORDER BY C7_FILIAL, C7_NUM , C7_DATPRF, C7_XDTPRF "

                DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TSC7",.T.,.T.) //filtrando pedido na SC7

                If Empty(TSC7->C7_XDTPRF)
                    dData :=  stod(TSC7->C7_DATPRF)
                Else
                    dData :=  stod(TSC7->C7_XDTPRF)
                EndIf
                _Forn   := AllTrim(TSC7->C7_FORNECE)
                cCond   := TSC7->C7_COND //Condição de pagamento
                nValTot := TSC7->TOTAL + TSC7->VALIPI + TSC7->VALSOL //somando valor total do PC
                aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol)//calculando o numero de parcelas

                For i:= 1 to Len(aParc)  //laço de repetição de acordo com a quantidade de parcelas
                    _Venc  := Lastday(aParc[i,1],3) //vencimento
                    _Total := aParc[i,2] //valor da parcela
                    _Parc  := cvaltochar(i) //Nº da parcela

                    aDelet := { { "E2_PREFIXO" , "PRV" , NIL },; //Array de exclusão do título
                                { "E2_NUM" , PadR(AllTrim(cNumPC+"/"+substr(cItemPc,3,4)),TamSx3("E2_NUM")[1])  , NIL },; //Validando tamanho do campo na SX3
                                { "E2_PARCELA" , PadR(AllTrim(_Parc),TamSx3("E2_PARCELA")[1])   , NIL },;
                                { "E2_TIPO" , PadR(AllTrim(cTipo),TamSx3("E2_TIPO")[1])  , NIL },;
                                { "E2_NATUREZ" , PadR(AllTrim("602030007"),TamSx3("E2_NATUREZ")[1])  , NIL }}

                    If Select("TSE2") > 0
                        TSE2->(dbCloseArea())
                    EndIf

                    cQuery := " SELECT * FROM " + retsqlname("SE2") + " "
                    cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND E2_PREFIXO = 'PRV' "
                    cQuery += " AND E2_NUM = '"+cNumPC+"/"+substr(cItemPc,3,4)+"' AND E2_PARCELA = '"+_Parc+"'"
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
                        If lAchou 
                            If lRastro = .F. .OR. lPag = .F.
                                lRet := .F.
                            Else //se não tiver pendência de lote nem de condição de pagamento, exclui o título
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
                            EndIf
                        Else 
                            lRet := .T.
                        EndIf
                    End Transaction

                    lAchou := .F. // zera variável
                Next i
            EndIf
        Next nX

        SB1->(DbCloseArea())
        FwRestArea(aArea)

        If lMsg = .T. .AND. lRastro = .T. .AND. lPag = .T. //se tiver tudo ok, exibe mensagem de sucesso
            FWAlertInfo("Título financeiro excluído com sucesso.","Atenção!!!")
        EndIf 
    Else
        For nX := 1 To Len(ACOLS) //percorre todas as linhas da pré-nota
            If !Empty(cNumPC) .And. !Empty(cItemPc) //se num pc e item pc estiverem preenchidos, entra na rotina de exclusão do título
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
                _cQry += "AND   SC7.C7_ENCER = '' "
                _cQry += "AND   SC7.C7_QUJE <  SC7.C7_QUANT "
                _cQry += "GROUP BY C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF,C7_FORNECE "
                _cQry += "ORDER BY C7_FILIAL, C7_NUM , C7_DATPRF "

                DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TSC7",.T.,.T.) //filtrando pedido na SC7

                dData :=  stod(TSC7->C7_DATPRF)
                _Forn   := AllTrim(TSC7->C7_FORNECE)
                cCond   := TSC7->C7_COND //Condição de pagamento
                nValTot := TSC7->TOTAL + TSC7->VALIPI + TSC7->VALSOL //somando valor total do PC
                aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol)//calculando o numero de parcelas

                For i:= 1 to Len(aParc)  //laço de repetição de acordo com a quantidade de parcelas
                    _Venc  := Lastday(aParc[i,1],3) //vencimento
                    _Total := aParc[i,2] //valor da parcela
                    _Parc  := cvaltochar(i) //Nº da parcela

                    aDelet := { { "E2_PREFIXO" , "PRV" , NIL },; //Array de exclusão do título
                                { "E2_NUM" , PadR(AllTrim(cNumPC+"/"+substr(cItemPc,3,4)),TamSx3("E2_NUM")[1])  , NIL },; //Validando tamanho do campo na SX3
                                { "E2_PARCELA" , PadR(AllTrim(_Parc),TamSx3("E2_PARCELA")[1])   , NIL },;
                                { "E2_TIPO" , PadR(AllTrim(cTipo),TamSx3("E2_TIPO")[1])  , NIL },;
                                { "E2_NATUREZ" , PadR(AllTrim("602030007"),TamSx3("E2_NATUREZ")[1])  , NIL }}

                    If Select("TSE2") > 0
                        TSE2->(dbCloseArea())
                    EndIf

                    cQuery := " SELECT * FROM " + retsqlname("SE2") + " "
                    cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND E2_PREFIXO = 'PRV' "
                    cQuery += " AND E2_NUM = '"+cNumPC+"/"+substr(cItemPc,3,4)+"' AND E2_PARCELA = '"+_Parc+"'"
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
            EndIf
        Next nX

            SB1->(DbCloseArea())
            FwRestArea(aArea)

            If lMsg = .T. //se estiver tudo ok, exibe mensagem de sucesso
                FWAlertInfo("Título financeiro excluído com sucesso.","Atenção!!!")
            EndIf 
    EndIf

Return lRet 
