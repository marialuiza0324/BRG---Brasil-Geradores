#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function MT160WF()

	Local lRet          := .F.
	Local nOpc          := 4
	Local cDoc          := ""
	Local aCabec        := {}
	Local aLinha        := {}
	Local aItens        := {}
	Local lMsErroAuto   := .F.
	Local cUser         := ""
	Local cGrupo        := ""
	Local cUserWeb      := ""
	Local _cQry
	Local aRateio       := {}
	Local cQuery        := " "
	Local aRatCC        := {}
	Local nY            // Variável para o loop interno do rateio

	If Select("TSC7") > 0
		TSC7->(dbCloseArea())
	EndIf

	_cQry := "SELECT * "
	_cQry += "FROM " + RetSqlName("SC7") + " SC7 "
	_cQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
	_cQry += "AND C7_NUM = '" + SC8->C8_NUMPED + "' "

	_cQry := ChangeQuery(_cQry)
	TcQuery _cQry New Alias "TSC7"

	DbSelectArea('TSC7')

	While TSC7->(!EOF())

		If SC7 ->(MsSeek(xFilial("SC7")+TSC7->C7_NUM+TSC7->C7_ITEM))

			nOpc := 4
			cDoc := TSC7->C7_NUM // Número do pedido

			// Rateio
			aRateio := {} // Reinicializa para cada item

			cQuery := "SELECT * FROM " + retsqlname("SCX")+" SCX "
			cQuery += "WHERE D_E_L_E_T_ = ' ' "
			cQuery += "AND CX_SOLICIT = '" +TSC7->C7_NUMSC+ "' "
			cQuery += "AND CX_ITEMSOL = '" +TSC7->C7_ITEMSC+ "'"

			cQuery := ChangeQuery(cQuery)
			TcQuery cQuery New Alias "TMP1"

			DbSelectArea('TMP1')

			While TMP1->(!Eof())
				Aadd(aRateio,{TMP1->CX_ITEM,TMP1->CX_PERC,TMP1->CX_CC})
				TMP1->(DbSkip())
			EndDo

			TMP1->(DbCloseArea())

			If !Empty(aRateio)
				// Monta aRatCC para cada item
				aRatCC := {}
				aAdd(aRatCC, Array(2))
				aRatCC[1][1] := TSC7->C7_ITEM
				aRatCC[1][2] := {}

				For nY := 1 To Len(aRateio)
					aLinha := {}
					aAdd(aLinha, {"CH_FILIAL" , PadR(AllTrim(xFilial("SCH")),TamSx3("CH_FILIAL")[1]) , Nil})
					aAdd(aLinha, {"CH_ITEM" , PadL(nY, TamSx3("CH_ITEM")[1], "0"), Nil})
					aAdd(aLinha, {"CH_PERC" , PadR(AllTrim(aRateio[nY,2]),TamSx3("CH_PERC")[1]) , Nil})
					aAdd(aLinha, {"CH_CC" , PadR(AllTrim(aRateio[nY,3]),TamSx3("CH_CC")[1]) , Nil})

					aAdd(aRatCC[1][2],aLinha)
				Next nY
			EndIf

			// Adiciona informações do cabeçalho apenas uma vez
			If Empty(aCabec)
				aadd(aCabec,{"C7_NUM" ,TSC7->C7_NUM})
				aadd(aCabec,{"C7_EMISSAO" ,TSC7->C7_EMISSAO})
				aadd(aCabec,{"C7_FORNECE" ,TSC7->C7_FORNECE})
				aadd(aCabec,{"C7_LOJA" ,TSC7->C7_LOJA})
				aadd(aCabec,{"C7_COND" ,TSC7->C7_COND})
				aadd(aCabec,{"C7_CONTATO" ,TSC7->C7_CONTATO})
				aadd(aCabec,{"C7_FILENT" ,TSC7->C7_FILENT})
			EndIf

			aLinha := {} // Reinicializa aLinha a cada iteração para evitar sobrescrita
			aItens := {}

			// Alterar item existente
			aadd(aLinha,{"C7_ITEM" ,PadR(AllTrim(TSC7->C7_ITEM),TamSx3("C7_ITEM")[1])  ,Nil})
			aadd(aLinha,{"C7_PRODUTO" ,PadR(AllTrim(TSC7->C7_PRODUTO),TamSx3("C7_PRODUTO")[1]) ,Nil})
			aadd(aLinha,{"C7_QUANT" ,PadR(AllTrim(TSC7->C7_QUANT),TamSx3("C7_QUANT")[1]) ,Nil})
			aadd(aLinha,{"C7_PRECO" ,PadR(AllTrim(TSC7->C7_PRECO),TamSx3("C7_PRECO")[1]) ,Nil})
			aadd(aLinha,{"C7_TOTAL" ,PadR(AllTrim(TSC7->C7_TOTAL ),TamSx3("C7_TOTAL")[1]) ,Nil})
			aAdd(aLinha,{"LINPOS","C7_ITEM" ,TSC7->C7_ITEM})
			aAdd(aLinha,{"AUTDELETA","N" ,Nil})

			cUserWeb := Posicione("SC1",1,xFilial("SC1")+TSC7->C7_NUMSC+TSC7->C7_ITEMSC,"C1_XSOLWEB")
			cUser := Posicione("SC1",1,xFilial("SC1")+TSC7->C7_NUMSC+TSC7->C7_ITEMSC,"SC1->C1_USER")
			cGrupo := Posicione("SB1",1,xFilial("SB1")+TSC7->C7_PRODUTO,"SB1->B1_GRUPO")

			If !Empty(cUserWeb)

				RecLock("SC7", .F.)
				SC7->C7_CODSOL := cUserWeb
				SC7->C7_GRUPO  := cGrupo
				SC7->(MsUnlock())

			ElseIf !Empty(cUser)

				RecLock("SC7", .F.)
				SC7->C7_CODSOL := cUser
				SC7->C7_GRUPO  := cGrupo
				SC7->(MsUnlock())

			Else
				RecLock("SC7", .F.)
				SC7->C7_CODSOL := RetCodUsr()
				SC7->C7_GRUPO  := cGrupo
				SC7->(MsUnlock())
			EndIf

			aadd(aLinha,{"C7_CODSOL",PadR(AllTrim(SC7->C7_CODSOL),TamSx3("C7_CODSOL")[1]) ,Nil })
			aadd(aLinha,{"C7_GRUPO" ,PadR(AllTrim(SC7->C7_GRUPO),TamSx3("C7_GRUPO")[1]) ,Nil })

			// Clona aLinha antes de adicionar ao array de itens
			aadd(aItens,aLinha)
		EndIf

		// Execução da alteração
		If !Empty(aRatCC)
			MSExecAuto({|a,b,c,d,e,f,g,h| MATA120(a,b,c,d,e,f,g,h)}, 1, aCabec, aItens, nOpc, .F., aRatCC , ,)
		Else
			MSExecAuto({|a,b,c,d,e,f,g,h| MATA120(a,b,c,d,e,f,g,h)}, 1, aCabec, aItens, nOpc, .F.,{}, ,)
		EndIf

		If !lMsErroAuto
			lRet := .T.
		Else
			MostraErro()
		EndIf

		TSC7->(DbSkip())
	Enddo


	TSC7->(DbCloseArea())
	SC7->(DbCloseArea())

	ConOut("Alterado PC: "+cDoc)

Return lRet
