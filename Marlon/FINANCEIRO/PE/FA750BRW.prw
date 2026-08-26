#Include "TOTVS.CH"

User Function FA750BRW() As Array

	Local aPEOpcoes := {}

	AAdd(aPEOpcoes,{"Alterar Vencimento PA","U_AlteraPA()",0,4})

Return aPEOpcoes


User Function AlteraPA()

	Local dNovoVen := CTOD("")
	Local cUsuario := AllTrim(__cUserID)
	Local cUserAlt := AllTrim(SuperGetMv("MV_XUALTPA",,)) // Usuários autorizados a alterar vencimento

	// Usuários autorizados
	If !(cUsuario $ cUserAlt)
		MsgStop("Usuário sem permissão para alterar vencimento.")
		Return
	EndIf

	// Posiciona no título selecionado
	DbSelectArea("SE1")

	// Valida se é título PA
	If Alltrim(SE2->E2_TIPO) <> "PA"
		MsgAlert("Esta funcionalidade é permitida apenas para títulos do tipo PA.")
		Return
	EndIf

	If !Empty(SE2->E2_BAIXA)
		MsgAlert("Não é possível alterar vencimento de títulos baixados.")
		Return
	EndIf

	// Solicita nova data
	dNovoVen := FWInputBox("Informe a nova data de vencimento:", ;
		DTOC(SE2->E2_VENCREA))

	If Empty(dNovoVen)
		Return
	EndIf

	dNovoVen := CTOD(dNovoVen)

	If dNovoVen == CTOD("")
		MsgAlert("Data inválida.")
		Return
	EndIf

	// Confirma alteração
	If MsgYesNo("Confirma alteração do vencimento para " + DTOC(dNovoVen) + "?")

		DbSelectArea("SE2")
		SE2->(DBSetOrder(1))
		If SE2->(DbSeek(xFilial("SE2") + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA))
			RecLock("SE2", .F.)

				E2_VENCREA := Lastday(dNovoVen,3)
				E2_VENCTO  := dNovoVen
				

			SE2->(MsUnlock())

		EndIf

		MsgInfo("Vencimento alterado com sucesso.")

		DbCommit()

	EndIf

Return
