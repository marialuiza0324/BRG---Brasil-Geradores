#INCLUDE "RWMAKE.CH"
#DEFINE ENTER Chr(13)+Chr(10)
/*
//*******************************************************************************
Rotina: MATA120
ExecBlock: MT120BRW
Ponto: Antes da chamada da função de Browse.
Observações: Utilizado para o tratamento de dados a serem apresentados. no Browse.
Retorno Esperado: Nenhum.
//*******************************************************************************
*/ 
User Function MT120BRW

	aadd(aRotina, {OemToAnsi("Altera Fornecedor"), "U_XALTFOR", 0 , 2} )

Return

//*******************************************************************************
//*
//*******************************************************************************
User Function XALTFOR()
	Local nQUJE := 0
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cCompr   := SuperGetMV("MV_XCOMPRA", ," ") // Parametro dos Id's dos Compradores
	Private cPerg := PADR('XALTFOR',10)

	If !(cCodUser $ cCompr) //Criar o parametro 	Filtro para os Compradores (somente o tem para aprovar)
		APMSGALERT( "Você não tem permissão para usar essa rotina !!!","ATENÇÃO")
		RETURN
	ENDIF


	CriaSx1()
//+
//| Disponibiliza para usuario digitar os parametros
//+
	MV_PAR01  := SC7->C7_FORNECE
	MV_PAR02  := ""

	IF !Pergunte(cPerg,.T.)
		RETURN
	ENDIF
	cMsg := "PEDIDO: "+SC7->C7_NUM+ENTER
	cMsg += "**DE:"+ENTER+SC7->C7_FORNECE+"/"+SC7->C7_LOJA+" - "+Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")+ENTER
	cMsg += "**PARA:"+ENTER+MV_PAR01+"/"+MV_PAR02+" - "+Posicione("SA2",1,xFilial("SA2")+MV_PAR01+MV_PAR02,"A2_NOME")+ENTER
	cMsg += ENTER+"ATENÇÃO: ESSA MODIFICAÇÃO NÃO TEM COMO RETORNAR !!!"
	IF (Aviso("ATENÇÃO",cMsg,{"Sim","Nao"},3,"De/Para")) == 1

		cQuery := "SELECT SUM(C7_QUJE) QTDE FROM "+RetSqlname("SC7")+ENTER
		cQuery += " WHERE C7_FILIAL='"+xFilial("SC7")+"' AND "
		cQuery += " C7_NUM = "+VALTOSQL(SC7->C7_NUM)+" AND C7_FORNECE = "+VALTOSQL(SC7->C7_FORNECE)+" AND C7_LOJA = "+VALTOSQL(SC7->C7_LOJA)+ENTER
		cQuery += " AND D_E_L_E_T_=' ' "+ENTER
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
		nQUJE := TRB->QTDE
		TRB->(dbCloseArea())

//Valida a Exitencia do Fornecedor q esta digitando - Inicio
		DbSelectArea("SA2")
		DbSetOrder(1)
		If !dbSeek(xFilial("SA2")+SC7->C7_FORNECE+MV_PAR02)
			ApMsgInfo("Fornecedor Inexistente, Por Favor Cadastrar !!!")
			Return
		EndIf
//Valida a Exitencia do Fornecedor q esta digitando - Fim

		IF nQUJE == 0
			cQuery := "UPDATE "+RetSqlname("SC7")+ENTER
			cQuery += " SET "+ENTER
			cQuery += " C7_XALTFOR = 'S' "
			cQuery += " ,C7_LOJA = "+VALTOSQL(MV_PAR02)+ENTER
			cQuery += " FROM "+RetSqlname("SC7")+ENTER
			cQuery += " WHERE C7_FILIAL='"+xFilial("SC7")+"' AND "
			cQuery += " C7_NUM = "+VALTOSQL(SC7->C7_NUM)+" AND C7_FORNECE = "+VALTOSQL(SC7->C7_FORNECE)+" AND C7_LOJA = "+VALTOSQL(SC7->C7_LOJA)
			cQuery += " AND D_E_L_E_T_=' ' "
			//Memowrite("c:\siga\XALTFOR.sql",cQuery)
			TcSqlExec(cQuery)

			//Alterar na SC8
			cQuery := "UPDATE "+RetSqlname("SC8")+ENTER
			cQuery += " SET "+ENTER
			cQuery += " C8_LOJA = "+VALTOSQL(MV_PAR02)+ENTER
			cQuery += " FROM "+RetSqlname("SC8")+ENTER
			cQuery += " WHERE C8_FILIAL='"+xFilial("SC8")+"' AND "
			cQuery += " C8_NUM = "+VALTOSQL(SC7->C7_NUMCOT) +" AND C8_FORNECE = "+VALTOSQL(SC7->C7_FORNECE)
			cQuery += " AND D_E_L_E_T_=' ' "
			//Memowrite("c:\siga\XALTFOR.sql",cQuery)
			TcSqlExec(cQuery)

			CriaPRV()


			//Alteração para gerar novamente



		ELSE
			ALERT("ROTINA CANCELADA !!! Já teve entrega para esse pedido !!!")
		ENDIF

	ENDIF
Return


///////////////////////////////////////////////////////////////////////////////////
//+
//
//| PROGRAMA | Relatorio_SQL.prw | AUTOR | | DATA | 18/01/2004 |//
//+
//
//| DESCRICAO | Funcao - CriaSX1() |//
//| | Fonte utilizado no curso oficina de programacao. |//
//| | Funcao que cria o grupo de perguntas se caso nao existir |//
//+
//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaSx1()
	Local j := 0
	Local nY := 0
	Local aAreaAnt := GetArea()
	Local aAreaSX1 := SX1->(GetArea())
	Local aReg := {}

	aAdd(aReg,{cPerg,"01","Fornecedor ? ","mv_ch1","C",9,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SA2"})
	aAdd(aReg,{cPerg,"02","Loja ? ","mv_ch2","C",4,0,0,"G","","","","","","","","","","","","","","","","","LJA2"})
	aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

	dbSelectArea("SX1")
	dbSetOrder(1)

	For ny:=1 to Len(aReg)-1
		If !dbSeek(aReg[ny,1]+aReg[ny,2])
			RecLock("SX1",.T.)
			For j:=1 to Len(aReg[ny])
				FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
			Next j
			MsUnlock()
		EndIf
	Next ny ?

	RestArea(aAreaSX1)
	RestArea(aAreaAnt)

Return Nil

Static Function CriaPRV()

	Local aArea := FWGetArea()
	Local cCond   := SC7->C7_COND
	Local _Forn   := AllTrim(SC7->C7_FORNECE)
	Local _Lj     := MV_PAR02
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
	Local cData   := DTOC(Date()) //data corrente
	Private lMsErroAuto := .F.
	Private cNumPC  := ""
	Private cItemPc := ""


	cNumPC := Alltrim(SC7->C7_NUM) //Num Pc
	cItemPc := SC7->C7_ITEM //Item PC

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

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TSC7",.T.,.T.) //filtrando pedido na SC7

	If Empty(TSC7->C7_XDTPRF)

		If SC7->C7_DATPRF < CtoD(cData) //Valida se data à ser alterada é retroativa

			dData := CtoD(cData) //se for retroativa, cria título com data corrente

		Else

			dData :=  stod(TSC7->C7_DATPRF)

		EndIf
	Else
		dData :=  stod(TSC7->C7_XDTPRF)

	EndIf

	_Forn   := AllTrim(TSC7->C7_FORNECE)
	cCond   := TSC7->C7_COND //Condição de pagamento
	nValTot := TSC7->TOTAL + TSC7->VALIPI + TSC7->VALSOL //somando valor total do PC
	aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol)//calculando o numero de parcelas

	For i:= 1 to Len(aParc)  //laço de repetição de acordo com a quantidade de parcelas
		_Venc  := aParc[i,1] //vencimento
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
					Return
				Else
					lMsErroAuto:= .F.
				Endif

			EndIf

			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

			If lMsErroAuto //se der erro cancela inclusão e mostra erro
				FWAlertInfo("Não foi possível incluir o titulo, verifique","Atenção!!!")
				MostraErro()
				DisarmTransaction()
				Return
			Else
				lMsErroAuto:= .F.
			Endif

		End Transaction

		lAchou := .F. //zera variável
	Next i

	ApMsgInfo("Alteração efetuada com sucesso !!!")

	FwRestArea(aArea)

Return


