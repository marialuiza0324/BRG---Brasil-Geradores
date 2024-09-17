#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"


/*/{Protheus.doc} FSFIN002
    (Função para verificar título 
    existente, excluir e gerar novo com 
    nova data de vencimento)
    OBS: complementa FSCOM004
    @type  Function
    @author Maria Luiza
    @since 09/07/2024
    /*/
User Function FSFIN002()

	Local aArea    := GetArea()
	Local cCond   := ""
	Local _Forn   := AllTrim(SC7->C7_FORNECE)
	Local _Lj     := SC7->C7_LOJA
	Local nVIPI   := 0
	Local nValTot := 0
	Local dData
	Local nVSol   := 0
	Local _Venc   := CtoD("  /  /  ")
	Local _Total  := 0
	Local _Parc   := " "
	Local i := 1
	Local lAchou:= .f.
	Local cTipo := "PR"
	Local cQuery := ""
	Local aDelet := {}
	Local nTotal := 0
	Local lMsg := .F.
	Private lMsErroAuto := .F.
	Private cNumPC  := ""
	Private cItemPc := ""
	Private dDataVld := ''

	cNumPC  := cGet1 //SC7->C7_NUM
	cItemPc := cGet5 //SC7->C7_ITEM

	If Select("TSC7") > 0
		TSC7->(dbCloseArea())
	EndIf

	_cQry := "SELECT DISTINCT C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO,C7_FORNECE, C7_DATPRF, C7_XDTPRF,C7_LOJA, SUM(C7_TOTAL) TOTAL, SUM(C7_VALIPI) VALIPI, SUM(C7_VALSOL) VALSOL,C7_NUMSC "
	_cQry += "FROM " + retsqlname("SC7")+" SC7 "
	_cQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
	_cQry += "AND   SC7.C7_FILIAL   = '" + cFilAnt  + "' "
	_cQry += "AND   SC7.C7_NUM	= '" + cNumPC  + "' "
	_cQry += "AND   SC7.C7_ITEM = '" + cItemPc + "' "
	_cQry += "AND   SC7.C7_ENCER = '' "
	_cQry += "AND   SC7.C7_QUJE <  SC7.C7_QUANT "
	_cQry += "GROUP BY C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF,C7_FORNECE,C7_XDTPRF,C7_LOJA,C7_NUMSC "
	_cQry += "ORDER BY C7_FILIAL, C7_NUM , C7_DATPRF,C7_XDTPRF,C7_LOJA "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TSC7",.T.,.T.) //filtrando pedido na SC7

	DbSelectArea("TSC7")

	If Empty(TSC7->C7_XDTPRF)

		dData :=  stod(TSC7->C7_DATPRF)

	Else

		dData :=  stod(TSC7->C7_XDTPRF)

	EndIf


	_Lj     := TSC7->C7_LOJA
	_Forn   := AllTrim(TSC7->C7_FORNECE)
	cCond   := TSC7->C7_COND //Condição de pagamento
	nValTot := TSC7->TOTAL + TSC7->VALIPI + TSC7->VALSOL //somando valor total do PC
	aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol)

	TSC7->(DbCloseArea())

	For i:= 1 to Len(aParc)  //laço de repetição de acordo com a quantidade de parcelas
		_Venc  := Lastday(aParc[i,1],3) //vencimento
		_Total := aParc[i,2] //valor da parcela
		_Parc  := cvaltochar(i) //Nº da parcela

		aArray := { { "E2_PREFIXO" , "PRV" , NIL },; //Array de inclusão do título
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

		aDelet := { { "E2_PREFIXO" , "PRV" , NIL },; //Array de exclusão do título
		{ "E2_NUM" , PadR(AllTrim(cNumPC+"/"+substr(cItemPc,3,4)),TamSx3("E2_NUM")[1])  , NIL },;//Validando tamanho do campo na SX3
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
					Return
				Else
					lMsErroAuto:= .F.
					lMsg := .T.
				Endif

			EndIf

			//se excluir título cria novo, se não existir cria do zero
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

			If lMsErroAuto //se der erro cancela inclusão e mostra erro
				FWAlertInfo("Não foi possível incluir o titulo, verifique","Atenção!!!")
				MostraErro()
				DisarmTransaction()
				lMsg := .F.
				Return
			Else
				lMsErroAuto:= .F.
				lMsg := .T.
			Endif

		End Transaction

		lAchou := .F. //zera variável

	Next i

	RestArea(aArea)

	If lMsg = .T.
		FWAlertInfo("Titulo financeiro criado com sucesso!","Atenção!!!")
	EndIf

Return
