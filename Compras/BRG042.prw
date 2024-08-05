#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


//BRG GERADORES
//DATA 08/02/2023
//3RL Soluções - Ricardo Moreira
//Gera contas a Pagar

User Function BRG042()
	Local aArea    := GetArea()
//Local nOpcao := PARAMIXB[1]
//Local nOpcA   := PARAMIXB[3] // // Indica se a ação foi Cancelada = 0  ou Confirmada = 1
	Local cCond   := SC7->C7_COND
	Local _Forn   := SC7->C7_FORNECE
	Local _Lj     := SC7->C7_LOJA
	Local nVIPI   := 0
	Local nValTot := 0
	Local dData   := CtoD("  /  /  ") //SC7->C7_DATPRF //SC7->C7_EMISSAO
	Local nVSol   := 0
	Local _Venc   := CtoD("  /  /  ")
	Local _Total  := 0
	Local _Parc   := " "
	Local i := 1
	Local cont := 1
	Private lMsErroAuto := .F.
	Private cNumPC := SC7->C7_NUM

//IF (nOpcao == 3 .and. nOpcA == 1) .or. (nOpcao == 9 .and. nOpcA == 1) .or. (nOpcao == 4 .and. nOpcA == 1)
	cont := 1
	CPedAp()
	//DbSelectArea("TSC7")
	//DBGOTOP()
	DO WHILE TSC7->(!EOF())
		dData :=  stod(TSC7->C7_DATPRF)
		nValTot := TSC7->TOTAL + TSC7->VALIPI + TSC7->VALSOL
		aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol)

		For i:= 1 to Len(aParc)
			//DO WHILE TMP->(!EOF())
			_Venc  := aParc[i,1]
			_Total := aParc[i,2]   // CtoD("28/06/2018")
			_Parc  := cvaltochar(i)

			aArray := { { "E2_PREFIXO" , "PRV" , NIL },;
				{ "E2_NUM" , cNumPC+"/"+_Parc , NIL },;
				{ "E2_PARCELA" , _Parc , NIL },;
				{ "E2_TIPO" , "PR" , NIL },;
				{ "E2_NATUREZ" , "202010058" , NIL },;  //Cadastrar uma natureza com titulo provisoriao
			{ "E2_FORNECE" , _Forn , NIL },;
				{ "E2_LOJA" , _Lj , NIL },;
				{ "E2_EMISSAO" , dData, NIL },;
				{ "E2_VENCTO" ,_Venc, NIL },;
				{ "E2_VENCREA" ,_Venc, NIL },;
				{ "E2_VALOR" ,_Total, NIL } }

			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	
			If lMsErroAuto
				Alert("Erro")
				MostraErro()
			Endif
			//IncRegua()
		Next i
		cont++

		//Alert("TESTE")
		//DbSelectArea("TMP")

		TSC7->(dbSkip())
	ENDDO

	MsgInfo( 'Provisão de Pagamento Gerada!!', 'Provisão CPAG' )

	SC7->(DBSetOrder(1))
	SC7->(DbGoTop())
	SC7->(dbSeek( xFilial("SC7")+cNumPC))
	While !SC7->(Eof()) .and. xFilial("SC7")==SC7->C7_FILIAL .and. cNumPC == SC7->C7_NUM
		SC7->(RECLOCK("SC7",.F.))
		SC7->C7_GERSE2 := "X"
		SC7->(MSUNLOCK())

		//GRAVA A DATA DE PREVISÃO DE ENTREGA NA SOLICITAÇAÕ DE COMPRA, VINDO DO PEDIDO DE COMPRA -  16/11/2022 - Inicio
		DbSelectArea("SC1")
		DbSetOrder(1)
		If DbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC)
			SC1->(RECLOCK("SC1",.F.))
			SC1->C1_XDTENT := SC7->C7_DTPREV  // ALTERADO DE DATPRV PARA DTPREV ... CRISTIANO 06/12/2022
			SC1->(MSUNLOCK())
		EndIF

		//GRAVA A DATA DE PREVISÃO DE ENTREGA NA SOLICITAÇAÕ DE COMPRA, VINDO DO PEDIDO DE COMPRA -  16/11/2022 - Fim
		SC7->( DbSkip() )
	EndDo


//EndIF
	RestArea(aArea)
Return

//Query Retorno

Static Function CPedAp() //U_DevExt

	If Select("TSC7") > 0
		TSC7->(dbCloseArea())
	EndIf

	_cQry := "SELECT DISTINCT C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF, SUM(C7_TOTAL) TOTAL, SUM(C7_VALIPI) VALIPI, SUM(C7_VALSOL) VALSOL "
	_cQry += "FROM " + retsqlname("SC7")+" SC7 "
	_cQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
	_cQry += "AND   SC7.C7_FILIAL   = '" + cfilant  + "' "
	_cQry += "AND   SC7.C7_NUM	= '" + cNumPC  + "' "
	_cQry += "AND   SC7.C7_ENCER = '' "
	_cQry += "AND   SC7.C7_QUJE <  SC7.C7_QUANT "
	_cQry += "GROUP BY C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF "
	_cQry += "ORDER BY C7_FILIAL, C7_NUM , C7_DATPRF "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TSC7",.T.,.T.)

Return
