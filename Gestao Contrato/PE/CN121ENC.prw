#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} CN121ENC 
Possibilita ao desenvolvedor realizar opera��es 
ap�s o encerramento da medi��o.
Executado uma vez ao fim do encerramento ainda dentro 
da transa��o e mais uma vez ap�s o fim da transa��o..
Utilizado para incluir t�tulo financeiro na tabela SE2
@type  Function
@author Maria Luiza
@since 25/07/2024*/


User Function CN121ENC()

    Local lInTrans:= PARAMIXB[1] //Verdadeiro caso seja dentro da transa��o, Falso fora da transa��o
    //Local lResult := PARAMIXB[2] //Verdadeiro caso encerramento tenha ocorrido com sucesso, falso caso tenha falhado por algum motivo. 
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
    Local cTipo := "PR"
    Local cNumPC  := ""
	Local _Forn   := ""
	Local _Lj     := ""
    Local lAchou := .F.
    Local cQuery := ""
    Local aDelet := {}
    Local nTotal := 0
    Local nTot   := 0 
    Local lMsg   := .F.
    Local cItemPc := ""
    Private lMsErroAuto := .F. 
 
      cNumPC := SC7->C7_NUM
      cItemPc := SC7->C7_ITEM //Item Pc
	 _Forn   := AllTrim(SC7->C7_FORNECE)
	 _Lj     := SC7->C7_LOJA

        If Select("TSC7") > 0
            TSC7->(dbCloseArea())
        EndIf

       _cQry := "SELECT DISTINCT C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO,C7_FORNECE, C7_DATPRF,C7_XDTPRF, SUM(C7_TOTAL) TOTAL, SUM(C7_VALIPI) VALIPI, SUM(C7_VALSOL) VALSOL "
	_cQry += "FROM " + retsqlname("SC7")+" SC7 "
	_cQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
	_cQry += "AND   SC7.C7_FILIAL   = '" + cFilAnt  + "' "
	_cQry += "AND   SC7.C7_NUM	= '" + cNumPC  + "' "
	_cQry += "AND   SC7.C7_ENCER = '' "
	_cQry += "AND   SC7.C7_QUJE <  SC7.C7_QUANT "
	_cQry += "GROUP BY C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF,C7_FORNECE,C7_XDTPRF "
	_cQry += "ORDER BY C7_FILIAL, C7_NUM , C7_DATPRF,C7_XDTPRF "
        DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TSC7",.T.,.T.) //Filtra pedido na SC7

       DbSelectArea("TSC7")

	TSC7->(DbGoTop())

	WHILE TSC7->(!EOF()) //somando valor total do PC

		nTot += TSC7->TOTAL + TSC7->VALIPI + TSC7->VALSOL//valor total
		cCond   := TSC7->C7_COND //Condi��o de pagamento
		 If Empty(TSC7->C7_XDTPRF)

	    	dData :=  stod(TSC7->C7_DATPRF)

		Else

			dData :=  stod(TSC7->C7_XDTPRF)

		EndIf

		TSC7->(DbSkip())

	Enddo

	nValTot := nTot 
	aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol) //calcula a quantidade de parcelas de acordo com a condi��o de pagamento

	TSC7->(DbCloseArea())

        For i:= 1 to Len(aParc)  //la�o de repeti��o de acordo com a quantidade de parcelas
            _Venc  := Lastday(aParc[i,1],3) //vencimento
            _Total := aParc[i,2] //valor da parcela
            _Parc  := cvaltochar(i) //N� da parcela

        aArray := { { "E2_PREFIXO" , "PRV" , NIL },; //Array de inclus�o do t�tulo
            { "E2_NUM" , PadR(AllTrim(cNumPC+"/"+substr(cItemPc,3,4)),TamSx3("E2_NUM")[1])  , NIL },; //Validando tamanho do campo na SX3
            { "E2_PARCELA" , PadR(AllTrim(_Parc),TamSx3("E2_PARCELA")[1])   , NIL },;
                { "E2_TIPO" , PadR(AllTrim(cTipo),TamSx3("E2_TIPO")[1])  , NIL },;
                { "E2_NATUREZ" , PadR(AllTrim("202010058"),TamSx3("E2_NATUREZ")[1])  , NIL },;
                { "E2_FORNECE" , _Forn , NIL },;
                { "E2_LOJA" , _Lj , NIL },;
                { "E2_EMISSAO" , dData, NIL },;
                { "E2_VENCTO" ,_Venc, NIL },;
                { "E2_VENCREA" ,_Venc, NIL },;
                { "E2_VALOR" ,_Total, NIL }}

            aDelet := { { "E2_PREFIXO" , "PRV" , NIL },; //Array de exclus�o do t�tulo
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

            DbSelectArea("TSE2") //query retorna se existe t�tulo na SE2 com chave informada

            TSE2->( dbGoTop() )
            Count To nTotal

            If  nTotal > 0
                lAchou := .T.
            EndIf

            TSE2->(DbCloseArea())

            Begin Transaction

                If lAchou //se achar t�tulo na query acima, deleta ele
                    MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aDelet,, 5) // 3 - Inclusao, 4 - Altera��o, 5 - Exclus�o

                    If lMsErroAuto //se der erro cancela exclus�o e mostra erro
                        FWAlertInfo("Sistema n�o conseguiu excluir o t�tulo, refa�a o processo","Aten��o!!!")
                        MostraErro()
                        DisarmTransaction()
                        lMsg:= .F.
                        Return
                    Else
                        lMsErroAuto:= .F.
                        lMsg := .T.
                    Endif

                EndIf
                
                    MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3) // 3 - Inclusao, 4 - Altera��o, 5 - Exclus�o

                    If lMsErroAuto //se der erro cancela inclus�o e mostra erro
                        FWAlertInfo("N�o foi poss�vel incluir o titulo, verifique","Aten��o!!!")
                        MostraErro()
                        DisarmTransaction()
                        lMsg := .F.
                        Return
                    Else
                        lMsErroAuto:= .F.
                        lMsg := .T.
                    Endif
        
            End Transaction

            lAchou := .F. //zera vari�vel
        
        Next i

           FwRestArea(aArea)

If  lInTrans = .F.  .AND. lMsErroAuto = .F. .AND. lMsg = .T.// repetir mensagem apenas 1 vez

		FWAlertInfo("T�tulo financeiro criado com sucesso.","Aten��o!!!")

    EndIf

Return
