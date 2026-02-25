#Include "Totvs.ch"
#Include "Protheus.ch"

/*/{Protheus.doc} User Function FSMNT001
    Integração Horímetros BRG ? Atualiza T9_CONTACU.
    @author Maria Luiza
    @since Fevereiro/2026
    @version 1.0
    @obs Executar via schedule ou manualmente. API pública GET only.
    @see https://api.brggeradores.com.br/api/v2/public/integracao/horimetros
/*/
User Function FSMNT001()

	Local aArea      := GetArea()
	Local oRest      := FWRest():New("https://api.brggeradores.com.br")
	Local aHeader    := {}
	Local cJson      := ""
	Local oJson      := Nil
	Local nAtualiz   := 0
	Local nIgnorados := 0
	Local nNaoEnc    := 0
	Local cLog       := "Integração Horímetros BRG - " + dToC(dDataBase) + " " + Time() + CRLF + CRLF
	Local cErro      := ""
	Local aHorim 	:= {}
	Local nX     	:= 0
	Local nPos 		:= 0
	Local cLote 	:= ''
	Local cHorim 	:= ''
	Local cDados 	:= ''
	Local aPares 	:= {}
	Local i  		:= 0
	Local cQry   	:= ''
	Local cSerie 	:= ''

	// Cabeçalho simples e funcional
	aAdd(aHeader, "User-Agent: Protheus Integracao/12.x")
	aAdd(aHeader, "Accept: application/json")

	oRest:SetPath("/api/v2/public/integracao/horimetros")

	If oRest:Get(aHeader)
		cJson := oRest:GetResult()

		If !Empty(cJson)
			oJson := JsonObject():New()
			oJson:FromJson(cJson)

			aHorim := strtokarr(cJson, ",") //transforma os dados da string em um array

			For nX := 1 To Len(aHorim) //Percorre o array

				cDados := Alltrim(aHorim[nX]) //Posiciona no registro

				// Remover aspas extras e caracteres esperiais
				cDados := StrTran(cDados, '"', '')
				cDados := StrTran(cDados, "{", "")

				// Localizar a posição dos dois pontos
				nPos := At(':', cDados)

				// Separar o lote e horímetro
				cLote := AllTrim(SubStr(cDados, 1, nPos - 1))  // Obtém Lote
				cHorim := AllTrim(SubStr(cDados, nPos + 1))     // Obtém Horímetro
				cHorim := StrTran(cHorim, '"', '')
				cHorim := StrTran(cHorim, "}", "")

				// Adicionar Lote e Horímetro ao novo array com posições separadas
				aAdd(aPares, {cLote, cHorim})

			Next nX
			For i := 1 To Len(aPares) // percorre array de lote e horímetro

				cSerie := aPares[i][1] //número do lote
				// Verifica se a área TMP1 está em uso e fecha-a, se necessário
				If Select("TMP1") > 0
					TMP1->(DbCloseArea())  // Fecha a área de trabalho se estiver aberta
				EndIf

				cQry := "SELECT ST9.T9_CODBEM,ST9.T9_DTULTAC,ST9.T9_CCUSTO,ST9.T9_CENTRAB,ST9.T9_VARDIA,ST9.T9_CONTACU,ST9.T9_VIRADAS,ST9.R_E_C_N_O_ AS RECNOST9 "
				cQry += "FROM " + retsqlname("ST9")+" ST9 "
				cQry += "WHERE ST9.T9_SERIE LIKE '"+cSerie+"' "
				cQry += "AND ST9.D_E_L_E_T_ <> '*' "
				cQry += "AND ST9.T9_SITBEM = 'A'" // Somente bem ativo
				cQry += "ORDER BY ST9.T9_CODBEM,ST9.T9_DTULTAC,ST9.T9_CCUSTO,ST9.T9_CENTRAB,ST9.T9_VARDIA,ST9.T9_CONTACU,ST9.T9_VIRADAS "

				DbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), "TMP1", .T., .T.)


				If TMP1->(!EOF())

					DbSelectArea("ST9")
					ST9->(DbSetOrder(1))          // Ajuste se o índice principal for outro (ex: filial + código)
					ST9->(DbGoTo(TMP1->RECNOST9))

					RecLock("ST9", .F.)
					ST9->T9_CONTACU := GetdToVal(aPares[i][2]) // Atualiza o campo de horímetro com o valor da API
					ST9->T9_DTULTAC := dDataBase
					ST9->(MsUnLock())

					cLog += "Atualizado: Equipamento " + AllTrim(TMP1->T9_CODBEM) + ;
						" | Lote " + cSerie + " | Horímetro: " + cValToChar(aPares[i][2]) + " h" + CRLF
					nAtualiz++
				Else
					nIgnorados++
				EndIf
			Next i
		Else
			// Equipamento sem lote BRG ? ignora silenciosamente ou loga se quiser
			nIgnorados++
		EndIf


		cLog += CRLF + Replicate("-", 60) + CRLF
		cLog += "Equipamentos atualizados.....: " + cValToChar(nAtualiz) + CRLF
		cLog += "Horas iguais (sem alteração): " + cValToChar(nIgnorados) + CRLF
		cLog += "Não encontrados na API......: " + cValToChar(nNaoEnc) + CRLF
		cLog += "Total processado............: " + cValToChar(nAtualiz + nIgnorados + nNaoEnc) + CRLF

		// Mostra log (ou grave em arquivo/tabela/envie e-mail)
		ShowLog(cLog)
		// Exemplo: U_GravaLog("HorimetrosBRG", cLog)  // se tiver função custom

		RestArea(aArea)
		oJson := Nil
	Else
		cErro := "Erro na requisição: " + oRest:GetError()
		ShowLog(cErro)
		// Exemplo: U_GravaLog("HorimetrosBRG", cErro)
	EndIf

Return Nil
