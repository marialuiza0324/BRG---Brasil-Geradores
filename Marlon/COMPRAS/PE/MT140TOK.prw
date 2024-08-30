#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT140TOK 
   Este P.E é executado pós o destravamento de todas as tabelas envolvidas 
   na gravação do documento de entrada, depois de fechar
   a operação realizada neste.
   É utilizado para realizar a exclusão do título 
   no contas a pagar após a gravação da NFE.
    @type  Function
    @author Maria Luiza
    @since 23/07/2024*/

User Function MT140TOK() 

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
Local lRet := .F. 

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
				Else
					lMsErroAuto:= .F.
					lRet := .T.
				Endif
			Else 
			lRet := .T.
            EndIf

        End Transaction

           lAchou := .F. // zera variável
		   
    Next i

Next nX
        FwRestArea(aArea)

		FWAlertInfo("Título financeiro excluído com sucesso.","Atenção!!!")

Return lRet
