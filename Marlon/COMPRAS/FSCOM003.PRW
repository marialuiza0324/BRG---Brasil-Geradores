//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function zTstObj
Função que imprime uma tela, detalhando o pedido de compra que esta para aprovação.
@type  Function
@author Maria Luiza
@since 20/06/2024
@version version
/*/

User Function FSCOM003()

	Local cQuery    := ""
	Local nTotal    := 0
	Local nXi       := 0
	Static nLinhas   := 0
	Static _CRLF     := CHR(13)+CHR(13)
	Static cTxtLinha := ""
	Static cMensagem := ""
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
	cQuery += " SC1.C1_COTACAO "
	cQuery += " FROM SCR010 SCR "
	cQuery += " INNER JOIN SC7010 SC7 ON SC7.C7_NUM = SCR.CR_NUM "
	cQuery += " AND SC7.D_E_L_E_T_ <> '*' "
	cQuery += " INNER JOIN SC1010 SC1 ON SC7.C7_NUM = SC1.C1_PEDIDO "
	cQuery += " AND SC1.C1_PRODUTO = SC7.C7_PRODUTO "
	cQuery += " AND SC1.C1_ITEM = SC7.C7_ITEMSC "
	cQuery += " AND SC7.C7_NUMSC = SC1.C1_NUM "
	cQuery += " AND SC1.D_E_L_E_T_ <> '*' "
	cQuery += " WHERE SCR.D_E_L_E_T_ <> '*' "
	cQuery += " AND CR_USER = " + RetCodUsr() + " "
	cQuery += " AND CR_NUM = " + RTRIM(SCR->CR_NUM) + " "
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

		aAdd(aDados,{TMP1->CR_NUM,TMP1->CR_APROV,TMP1->C7_PRODUTO,TMP1->C7_DESCRI,TMP1->C1_NUM,TMP1->C7_ITEM,TMP1->C1_XOBMEMO,TMP1->C7_GRUPO,TMP1->C1_SOLICIT,TMP1->C1_COTACAO})

		TMP1->(DbSkip())

	EndDo

	//se a query retornar registro cria a dialog
	MV_PAR01 := nTotal

	If MV_PAR01 > 0
		fCriaTela()
	EndIf

Return

Static Function fCriaTela()

	Local bInit := {|| fCriaObj() }
	//Tamanho da janela
	Local nJanLarg := 1200
	Local nJanAltu := 800
	//Inicio e fim do laço de repetição
	Local nAtual := 0
	Local nFinal := MV_PAR01
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

	//Cria as variáveis em memória (aqui mais um pulo do gato, é colocado o +1, para garantir que crie um a mais na memória e não dê erro ao instanciar os objetos)
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

//Foi necessário criar essa função no bInit, pois assim a tela já está "pré-criada" na memória, senão com TGet dava inconsistências na montagem dos dados
Static Function fCriaObj()


	//Inicio e fim do laço de repetição
	Local nAtual := 1
	Local nAtual1 := 1
	Local nFinal := MV_PAR01
	Local cMensagem := ""



	//Cria o TSay
	//Num Pedido de Compra
	&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=14, 012, {|| }, oPanel1, , , , , , .T., CLR_BLACK, , 075, 010, , , , , , .T.)
	&(cSayObj + cValToChar(nAtual1)):SetText("Nº do Pedido de Compra: ")
	&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

	nAtual1+=1

	//Cria o TGet
	//Num Pedido de Compra
	&(cGetCon + cValToChar(nAtual1)) := cValToChar(Alltrim(aDados[1][1]))
	&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin,95, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel1, 060, 010, , , , , , , , .T., , , , , , ,.T. , , , , , , , , , , , , , , , , )

	nAtual1+=1

	//Cria o TSay
	//Num Cotação
	&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=10, 012, {|| }, oPanel1, , , , , , .T., CLR_BLACK, , 052, 007, , , , , , .T.)
	&(cSayObj + cValToChar(nAtual1)):SetText("Nº da Cotação: ")
	&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

	nAtual1+=1

	//Cria o TGet
	//Num Cotação
	&(cGetCon + cValToChar(nAtual1)) := cValToChar(Alltrim(aDados[1][10]))
	&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin+=2,95, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel1, 060, 010, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )

	nAtual1+=1
	nLin += 5

	//Cria o TSay
	//Linha que separa itens
	&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=22, 005, {|| }, oPanel1, , , , , , .T., CLR_GRAY, , 1100, 012, , , , , , .T.)
	&(cSayObj + cValToChar(nAtual1)):SetText(nTraco)
	&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

	nAtual1+=1
	nLin+=15

	//Percorrendo de 1 até a posição digitada no parâmetro

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
		&(cSayObj + cValToChar(nAtual1)):SetText("Nº da Solicitação de Compra: ")
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
		//Observação da SC
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
		//Observação da SC
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=2, 320, {|| }, oPanel, , , , , , .T., CLR_BLACK, , 054, 010, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText("Observações da SC: ")
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

		nAtual1  += 1

		//Cria o TGet
		//Código do Produto
		&(cGetCon + cValToChar(nAtual1)) := cValToChar(aDados[nAtual][3])
		&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin+=8,115, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel, 060, 010, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )

		nAtual1  += 1

		//Cria o TSay
		//Código do Produto
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=3, 012, {|| }, oPanel, , , , , , .T., CLR_BLACK, , 063, 010, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText("Código do Produto: ")
		&(cSayObj + cValToChar(nAtual1)):lTransparent := .T.

		nAtual1  += 1

		//Cria o TGet
		//Descrição do Produto
		&(cGetCon + cValToChar(nAtual1)) := cValToChar(aDados[nAtual][4])
		&(cGetObj + cValToChar(nAtual1)) := TGet():New(nLin+=9,115, {|| &(cGetCon + cValToChar(nAtual1))}, oPanel, 132, 010, , , , , , , , .T., , , , , , , .T., , , , , , , , , , , , , , , , )

		nAtual1  += 1

		//Cria o TSay
		//Descrição do Produto
		&(cSayObj + cValToChar(nAtual1)) := TSay():New(nLin+=4, 012, {|| }, oPanel, , , , , , .T., CLR_BLACK, , 063, 012, , , , , , .T.)
		&(cSayObj + cValToChar(nAtual1)):SetText("Descrição do Produto: ")
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
