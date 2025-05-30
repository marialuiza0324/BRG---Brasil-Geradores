//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function zTstObj
Fun��o que imprime uma tela, detalhando o pedido de compra que esta para aprova��o.
@type  Function
@author Maria Luiza
@since 20/06/2024
@version version
/*/

User Function FSCOM003()

	Local cQuery    := ""
	Local nTotal    := 0
	Local nXi       := 0
	Local nY         := 0
	Static nLinhas   := 0
	Static _CRLF     := CHR(13)+CHR(13)
	Static cTxtLinha := ""
	Static cMensagem := ""
	Static cDescCc   := ""
	Static cQry      := ""
	Static dData     := Date()
	Static nValor    := 0
	Static cUser     := RetCodUsr()
	Static nLimite   := 0
	Static nLimDisp  := 0
	Static cTipo     := ""
	Static dData     := Date()
	Static dPriDia
	Static dUltDia
	Static aSaldo   := {}
	Private nLin    := 0
	Private nTraco := "_______________________________________________________________________________________________________________________________________________________________________________________________"
	Private aDados   := {}


	If Select("TMP1") > 0
		TMP1->(DbCloseArea())
	EndIf

	cQuery := " SELECT SCR.CR_NUM, "
	cQuery += " SCR.CR_APROV, "
	cQuery += " SC7.C7_ITEM,"
	cQuery += " SC7.C7_PRODUTO, "
	cQuery += " SC7.C7_DESCRI, "
	cQuery += " SC1.C1_NUM, "
	cQuery += " SC1.C1_ITEM, "
	cQuery += " C1_NUM,C1_ITEM,ISNULL(CAST(CAST(C1_XOBMEMO AS VARBINARY(8000)) AS VARCHAR(8000)),'') C1_XOBMEMO, "
	cQuery += " SC7.C7_GRUPO, "
	cQuery += " SC7.C7_CODSOL, "
	cQuery += " SC1.C1_SOLICIT, "
	cQuery += " SC1.C1_COTACAO, "
	cQuery += " SC7.C7_CC "
	cQuery += " FROM " + retsqlname("SCR") +" SCR "
	cQuery += " INNER JOIN SC7010 SC7 ON SC7.C7_NUM = SCR.CR_NUM "
	cQuery += " AND SC7.D_E_L_E_T_ <> '*' "
	cQuery += " INNER JOIN SC1010 SC1 ON SC7.C7_NUM = SC1.C1_PEDIDO "
	cQuery += " AND SC1.C1_PRODUTO = SC7.C7_PRODUTO "
	cQuery += " AND SC1.C1_ITEM = SC7.C7_ITEMSC "
	cQuery += " AND SC7.C7_NUMSC = SC1.C1_NUM "
	cQuery += " AND SC1.D_E_L_E_T_ <> '*' "
	cQuery += " WHERE SCR.D_E_L_E_T_ <> '*' "
	cQuery += " AND CR_USER = '" + RetCodUsr() + "' "
	cQuery += " AND CR_NUM = '" + RTRIM(SCR->CR_NUM) + "' "
	cQuery += " ORDER BY SC7.C7_ITEM "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMP1",.T.,.T.)

	DBSELECTAREA("TMP1")


	TMP1->( dbGoTop() )
	Count To nTotal
	TMP1->( dbGoTop() )

	While TMP1->(!EOF())

		nLinhas := MLCount(TMP1->C1_XOBMEMO,70)
		For nXi:= 1 To nLinhas
			cTxtLinha := MemoLine(TMP1->C1_XOBMEMO,70,nXi)
			If !Empty(alltrim(cTxtLinha))
				cMensagem := cTxtLinha  + _CRLF
			EndIf
		Next nXi

		cDescCc := 	Posicione("CTT", 1, FWxFilial("CTT")+TMP1->C7_CC, "CTT_DESC01")

		aAdd(aDados,{TMP1->CR_NUM,TMP1->CR_APROV,TMP1->C7_PRODUTO,TMP1->C7_DESCRI,TMP1->C1_NUM,TMP1->C7_ITEM,TMP1->C1_XOBMEMO,TMP1->C7_GRUPO,TMP1->C1_SOLICIT,TMP1->C1_COTACAO,TMP1->C7_CC,cDescCc})

		TMP1->(DbSkip())

	EndDo

	//se a query retornar registro cria a dialog
	MV_PAR01 := nTotal

	nLimite := Posicione("SAK",2,FWxFilial("SAK")+cUser,'AK_LIMITE')
	cTipo := Posicione("SAK",2,FWxFilial("SAK")+cUser,'AK_TIPO')

	If cTipo == 'D'

		If Posicione("SCS",1,FWxFilial("SCS")+cUser+DTOS(dData),'CS_SALDO') = 0
			nLimDisp := nLimite
		Else
			nLimDisp := Posicione("SCS",1,FWxFilial("SCS")+cUser+DTOS(dData),'CS_SALDO')
		Endif

	ElseIf cTipo == 'M'

		//Busca o primeiro dia
		dPriDia := FirstDate(dData)
		//Busca o �ltimo dia
		dUltDia := LastDate(dData)

		if Select("TMP2") > 0
			TMP2->(dbCloseArea())
		Endif

		//"SELECT MAX(b1_cod) as NSEQUEN

		cQry := "SELECT MAX(CS_SALDO) ULTSALDO FROM " + retsqlname("SCS") +" SCS "
		cQry += "WHERE D_E_L_E_T_ = '' "
		cQry += "AND CS_DATA BETWEEN '"+dTos(dPriDia)+"' AND '"+dTos(dUltDia)+"' "
		cQry += "AND CS_COD = '"+cUser+"' "

		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP2",.T.,.T.)

		DBSELECTAREA("TMP2")
		TMP2->( dbGoTop() )

		If TMP2->ULTSALDO > 0
			nLimDisp := TMP2->ULTSALDO
		Else
			nLimDisp := nLimite
		EndIf


		/*While TMP2->(!EOF())

			Aadd(aSaldo,TMP2->ULTSALDO)

			TMP2->(DbSkip())

		EndDo

		Count To nTotal
		If nTotal >= 1
			For nY := 1 To Len(aSaldo)

				nLimDisp += nLimDisp + aSaldo[nY]

			Next
		Else
			nLimDisp := nLimite
		EndIf*/

	EndIf

	If MV_PAR01 > 0
		fCriaTela()
	EndIf

Return

Static Function fCriaTela()

	Local bInit := {|| fCriaObj() }
	//Tamanho da janela
	Local nJanLarg := 1200
	Local nJanAltu := 800
	//Inicio e fim do la�o de repeti��o
	Local nAtual := 0
	Local nQtdObj := 700
	//Objetos
	Private oDlgTst
	Private oPanel
	Private oPanel1
	Private oScroll
	Private oScroll1
	Private cSayObj := "oSay"
	Private cGetObj := "oGet"
	Private cGetCon := "cGet"
	Private coBox := "oBox"

	//Cria as vari�veis em mem�ria (aqui mais um pulo do gato, � colocado o +1, para garantir que crie um a mais na mem�ria e n�o d� erro ao instanciar os objetos)
	For nAtual := 1 To nQtdObj
		SetPrvt(cSayObj + cValToChar(nAtual))
		SetPrvt(cGetObj + cValToChar(nAtual))
		SetPrvt(cGetCon + cValToChar(nAtual))
		SetPrvt(coBox + cValToChar(nAtual))
	Next

	//Cria a janela
	oDlgTst := TDialog():New(0, 0, nJanAltu, nJanLarg, 'Dados do Pedido de Compra', , , , , CLR_BLACK, RGB(250, 250, 250), , , .T.)

	// Cria objeto Scroll
	oScroll := TScrollArea():New(oDlgTst,01,01,100,100)
	oScroll:Align := CONTROL_ALIGN_ALLCLIENT

	// Cria painel
	@ nLin,000 MSPANEL oPanel OF oScroll SIZE 600,800 COLOR CLR_GRAY

	// Cria painel
	@ nLin,000 MSPANEL oPanel1 SIZE 595,060 OF oDlgTst COLORS 0, 16777215 LOWERED RAISED

	// Define objeto painel como filho do scroll
	oScroll:SetFrame( oPanel )

	//Ativa e exibe a janela
	oDlgTst:Activate(, , , .T., {|| .T.}, , bInit )
Return

//Foi necess�rio criar essa fun��o no bInit, pois assim a tela j� est� "pr�-criada" na mem�ria, sen�o com TGet dava inconsist�ncias na montagem dos dados
Static Function fCriaObj()


	//Inicio e fim do la�o de repeti��o
	Local nAtual := 1
	Local nAtual1 := 1
	Local nFinal := MV_PAR01
	Local cMensagem := ""



	//Cria o TSay
	//Num Pedido de Compra
	&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=14, 012, {|| }, oPanel1, , , , , , .T., CLR_BLACK, , 075, 010, , , , , , .T.)
	&(cSayObj + cValToChar(nAtual1)):SetText("N� do Pedido de Compra: ")
	&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

	nAtual1+=1

	//Cria o TGet
	//Num Pedido de Compra
	&(cGetCon + cValToChar(nAtual1)) := cValToChar(Alltrim(aDados[1][1]))
	&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin,95, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel1, 060, 010, , , , , , , , .T., , , , , , ,.T. , , , , , , , , , , , , , , , , )

	nAtual1+=1

	//Cria o TSay
	//Limite di�rio
	&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin, 310, {|| }, oPanel1, , , , , , .T., CLR_BLACK, , 075, 012, , , , , , .T.)
	&(cSayObj + cValToChar(nAtual1)):SetText("Limite Total de Aprova��o: ")
	&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

	nAtual1+=1

	//Cria o TGet
	//Limite Di�rio
	&(cGetCon + cValToChar(nAtual1)) := cValToChar(Transform(nLimite, "@E 999,999,999.99"))
	&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin,378, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel1, 060, 010, , , , , , , , .T., , , , , , ,.T. , , , , , , , , , , , , , , , , )


	nAtual1+=1

	//Cria o TSay
	//Num Cota��o
	&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=10, 012, {|| }, oPanel1, , , , , , .T., CLR_BLACK, , 052, 007, , , , , , .T.)
	&(cSayObj + cValToChar(nAtual1)):SetText("N� da Cota��o: ")
	&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

	nAtual1+=1

	//Cria o TGet
	//Num Cota��o
	&(cGetCon + cValToChar(nAtual1)) := cValToChar(Alltrim(aDados[1][10]))
	&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin+=2,95, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel1, 060, 010, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )

	nAtual1+=1

	//Cria o TSay
	//Limite dispon�vel
	&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin, 310, {|| }, oPanel1, , , , , , .T., CLR_BLACK, , 075, 012, , , , , , .T.)
	&(cSayObj + cValToChar(nAtual1)):SetText("Limite dispon�vel para Aprova��o: ")
	&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

	nAtual1+=1

	//Cria o TGet
	//Limite Dispon�vel
	&(cGetCon + cValToChar(nAtual1)) := cValToChar(Transform(nLimDisp, "@E 999,999,999.99"))
	&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin,378, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel1, 060, 010, , , , , , , , .T., , , , , , ,.T. , , , , , , , , , , , , , , , , )




	nAtual1+=1
	nLin += 5

	//Cria o TSay
	//Linha que separa itens
	&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=22, 005, {|| }, oPanel1, , , , , , .T., CLR_GRAY, , 1100, 012, , , , , , .T.)
	&(cSayObj + cValToChar(nAtual1)):SetText(nTraco)
	&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

	nAtual1+=1
	nLin+=15

	//Percorrendo de 1 at� a posi��o digitada no par�metro

	For nAtual := 1 To nFinal

		nAtual1+=1

		//Cria o TGet
		//Solicitante
		&(cGetCon + cValToChar(nAtual1)) := cValToChar(aDados[nAtual][9])
		&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin,378, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel, 060, 010, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )

		nAtual1  += 1

		//Cria o TSay
		//Num SC
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=3, 012, {|| }, oPanel, , , , , , .T., CLR_BLACK, , 076, 010, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText("N� da Solicita��o de Compra: ")
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

		nAtual1  += 1

		//Cria o TSay
		//Solicitante
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin, 320, {|| }, oPanel, , , , , , .T., CLR_BLACK, , 035, 010, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText("Solicitante: ")
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

		nAtual1  += 1

		//Cria o TGet
		//Num SC
		&(cGetCon + cValToChar(nAtual1)) := cValToChar(aDados[nAtual][5])
		&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin+=1,115, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel, 060, 010, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )

		nAtual1  += 1

		//Cria o TGet
		//Observa��o da SC
		//&(cGetCon + cValToChar(nAtual1)) := aDados[nAtual][7]
		//&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin+=8,378,{|| &(cGetCon + cValToChar(nAtual1))}, oPanel, 191, 040, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )
		//&(cGetObj + cValToChar(nAtual1)) := TMultiGet():New(nLin+=8, 378, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel, 191, 040, , , , , , .T., , , , , ,.T., , , , .F., .T.)
		cMensagem := aDados[nAtual][7]

		&(coBox + cValToChar(nAtual1)):= TScrollBox():New(oPanel,nLin+=8,378,040,191,.T.,.F.,.T.)

		&(cSayObj + cValToChar(nAtual1)) := TSay():New(005, 005, {||},&(coBox + cValToChar(nAtual1)) , , , , , , .T., CLR_BLACK, , 191, 100, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText(cMensagem)
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.


		//@ nLin+=8,378 MSPANEL (coPanel + cValToChar(nAtual1)) PROMPT aDados[nAtual][7] SIZE 160,040 OF oPanel COLORS 0, 16777215 RAISED LOWERED
		//@ nLin+=8, 378 SCROLLBOX (coPanel + cValToChar(nAtual1)) HORIZONTAL VERTICAL aDados[nAtual][7] SIZE 040, 160 OF oPanel BORDER


		nAtual1  += 1

		//Cria o TGet
		//Item do pedido
		&(cGetCon + cValToChar(nAtual1)) := cValToChar(aDados[nAtual][6])
		&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin+=4,115, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel, 060, 010, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )



		nAtual1  += 1

		//Cria o TSay
		//Item do pedido
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=2, 012, {|| }, oPanel, , , , , , .T., CLR_BLACK, , 083, 010, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText("Item do Pedido de Compra: ")
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.


		nAtual1  += 1

		//Cria o TSay
		//Observa��o da SC
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=2, 320, {|| }, oPanel, , , , , , .T., CLR_BLACK, , 054, 010, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText("Observa��es da SC: ")
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

		nAtual1  += 1

		//Cria o TGet
		//C�digo do Produto
		&(cGetCon + cValToChar(nAtual1)) := cValToChar(aDados[nAtual][3])
		&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin+=8,115, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel, 060, 010, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )

		nAtual1  += 1

		//Cria o TSay
		//C�digo do Produto
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=3, 012, {|| }, oPanel, , , , , , .T., CLR_BLACK, , 063, 010, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText("C�digo do Produto: ")
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

		nAtual1  += 1

		//Cria o TGet
		//Descri��o do Produto
		&(cGetCon + cValToChar(nAtual1)) := cValToChar(aDados[nAtual][4])
		&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin+=8,115, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel, 132, 010, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )

		nAtual1  += 1

		//Cria o TSay
		//Descri��o do Produto
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=4, 012, {|| }, oPanel, , , , , , .T., CLR_BLACK, , 063, 012, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText("Descri��o do Produto: ")
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

		nAtual1+=1

		//Cria o TGet
		//Centro de Custo
		&(cGetCon + cValToChar(nAtual1)) := cValToChar(aDados[nAtual][11])
		&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin+=7,115, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel, 132, 010, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )

		nAtual1+=1

		//Cria o TSay
		//Centro de Custo
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=4, 012, {|| }, oPanel, , , , , , .T., CLR_BLACK, , 063, 012, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText("Centro de Custo: ")
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

		nAtual1  += 1

		//Cria o TGet
		//Descri��o do Centro de Custo
		&(cGetCon + cValToChar(nAtual1)) := cValToChar(aDados[nAtual][12])
		&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin+=8,115, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel, 132, 010, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )

		nAtual1  += 1

		//Cria o TSay
		//Descri��o do Centro de Custo
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=3, 012, {|| }, oPanel, , , , , , .T., CLR_BLACK, , 063, 012, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText("Descri��o do Centro de Custo: ")
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

		nAtual1+=1
		nLin += 5

		//Cria o TSay
		//Linha que separa itens
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=10, 005, {|| }, oPanel, , , , , , .T., CLR_GRAY, , 1100, 012, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText(nTraco)
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

		nAtual1+=1
		nLin += 15

	Next

	TMP1->(DbCloseArea())

Return
