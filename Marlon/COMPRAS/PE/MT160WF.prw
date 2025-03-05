#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function MT160WF()

	Local nOpc          := 4
	Local aCabec        := {}
	Local aLinha        := {}
	Local aItens        := {}
	Local lMsErroAuto   := .F.
	Local _cQry
	Local nY
	Local lRet := .F.
	Local aRatCC := {}
	Local cDoc  := ""
	Local aRateio := {}
	
	If Select("TSC7") > 0
		TSC7->(dbCloseArea())
	EndIf

	_cQry := "SELECT * "
	_cQry += "FROM " + RetSqlName("SC7") + " SC7 "
	_cQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
	_cQry += "AND C7_NUM = '" + SC7->C7_NUM + "' "

	_cQry := ChangeQuery(_cQry)
	TcQuery _cQry New Alias "TSC7"

	DbSelectArea('TSC7')

	While TSC7->(!EOF())

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
			aadd(aCabec,{"C7_TPFRETE" ,TSC7->C7_TPFRETE})
			aadd(aCabec,{"C7_FRETE" ,TSC7->C7_FRETE})
		EndIf

		aLinha := {} // Reinicializa aLinha a cada iteração para evitar sobrescrita
		aItens := {}

		// Alterar item existente
		aadd(aLinha,{"C7_ITEM" ,PadR(AllTrim(TSC7->C7_ITEM),TamSx3("C7_ITEM")[1])  ,Nil})
		aadd(aLinha,{"C7_PRODUTO" ,PadR(AllTrim(TSC7->C7_PRODUTO),TamSx3("C7_PRODUTO")[1]) ,Nil})
		aadd(aLinha,{"C7_QUANT" ,PadR(AllTrim(TSC7->C7_QUANT),TamSx3("C7_QUANT")[1]) ,Nil})
		aadd(aLinha,{"C7_PRECO" ,PadR(AllTrim(TSC7->C7_PRECO),TamSx3("C7_PRECO")[1]) ,Nil})
		aadd(aLinha,{"C7_TOTAL" ,PadR(AllTrim(TSC7->C7_TOTAL),TamSx3("C7_TOTAL")[1]) ,Nil})

		// Clona aLinha antes de adicionar ao array de itens
		aadd(aItens,aLinha)

		Begin Transaction

			MSExecAuto({|a,b,c,d,e,f,g,h| MATA120(a,b,c,d,e,f,g,h)}, 1, aCabec, aItens, 4, .F., aRatCC , ,)

			If !lMsErroAuto
				lRet := .T.
			Else
				MostraErro()
			EndIf

		End Transaction

		TSC7->(DbSkip())
	Enddo


	ConOut("Alterado PC: "+cDoc)

Return lRet
