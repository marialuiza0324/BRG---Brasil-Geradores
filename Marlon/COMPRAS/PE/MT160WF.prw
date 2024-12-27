#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function MT160WF()

	Local lRet          := .F.
	Local nItemPed      := 1
	Local nOpc          := 4
	Local cDoc          := ""
	Local aCabec        := {}
	Local aLinha        := {}
	Local aItens        := {}
	Local lMsErroAuto   := .F.
	Local cUser := ""
	Local cGrupo := ""


	DbSelectArea('SC7')
	SC7->(DbSetOrder(1)) // Filial + Código
	SC7->(dbSeek(FWxFilial("SC7")+SC8->C8_NUMPED))

	DO WHILE ! SC7->(Eof())
		// Verificar se o item do pedido na SC7 é o mesmo da SC8

		nItemPed := PadL(CVALTOCHAR(nItemPed), 4, '0')

		cUser := Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"SC1->C1_USER")
		cGrupo := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"SB1->B1_GRUPO")

		DbSelectArea('SC8')
		SC8->(DbSetOrder(1)) // Filial + Código
		SC8->(dbSeek(FWxFilial("SC8")+SC7->C7_NUMCOT))

		//DO WHILE ! SC8->(Eof())
			If SC7->C7_NUM == SC8->C8_NUMPED .AND. SC7->C7_ITEM == SC8->C8_ITEMPED .AND. SC7->C7_PRODUTO == SC8->C8_PRODUTO .AND. RTRIM(SC7->C7_GRUPO) == ""

				RecLock("SC7", .F.)

				SC7->C7_CODSOL := cUser
				SC7->C7_GRUPO  := cGrupo

				SC7->(MsUnlock())
			EndIf
			//SC8->(DbSkip())
		//ENDDO

		if nItemPed == "0001"
			//Teste de alteração
			nOpc := 4
			cDoc := SC7->C7_NUM //Informar PC ou AE (Alteração / Exclusão)

			aadd(aCabec,{"C7_NUM" ,SC7->C7_NUM})
			aadd(aCabec,{"C7_EMISSAO" ,SC7->C7_EMISSAO})
			aadd(aCabec,{"C7_FORNECE" ,SC7->C7_FORNECE})
			aadd(aCabec,{"C7_LOJA" ,SC7->C7_LOJA})
			aadd(aCabec,{"C7_COND" ,SC7->C7_COND}) // Condição de pagamento que permite adiantamento
			aadd(aCabec,{"C7_CONTATO" ,SC7->C7_CONTATO})
			aadd(aCabec,{"C7_FILENT" ,SC7->C7_FILENT})

			aLinha := {}

			// Alterar item existente
			aadd(aLinha,{"C7_ITEM" ,SC7->C7_ITEM ,Nil})
			aadd(aLinha,{"C7_PRODUTO" ,SC7->C7_PRODUTO,Nil})
			aAdd(aLinha,{"LINPOS","C7_ITEM" ,"0001"})
			aAdd(aLinha,{"AUTDELETA","N" ,Nil})
			aadd(aLinha,{"C7_CODSOL" ,SC7->C7_CODSOL ,Nil})
			aadd(aLinha,{"C7_GRUPO" ,SC7->C7_GRUPO ,Nil})
		endif

		SC7->(DbSkip())
	ENDDO

	MSExecAuto({|a,b,c,d,e,f,g,h| MATA120(a,b,c,d,e,f,g,h)},1,aCabec,aItens,nOpc,.F.,,)

	If !lMsErroAuto
		lRet := .T.
		ConOut("Alterado PC: "+cDoc)
	Else
		MostraErro()
	EndIf


Return lRet





