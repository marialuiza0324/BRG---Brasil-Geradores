#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} FINA010
Réplica automática de Naturezas Financeiras

@author  Maria Luiza
@since   29/05/2026
@version 1.0

Parâmetro:
MV_NATREPL

Exemplo:
01,02,03

/*/

User Function FINA010()

	Local aParam    := PARAMIXB
	Local xRet      := .T.
	Local oObjForm  := NIL
	Local cIdExec   := ""
	Local cIdForm   := ""

	Local cFiliais  := ""
	Local aFiliais  := {}
	Local nX        := 0

	//---------------------------------------------------
	// Valida parâmetros MVC
	//---------------------------------------------------
	If aParam == NIL
		Return xRet
	EndIf

	oObjForm := aParam[1]
	cIdExec  := aParam[2]
	cIdForm  := aParam[3]

	//---------------------------------------------------
	// Antes do commit
	//---------------------------------------------------
	If cIdExec == "FORMCOMMITTTSPRE"

		//---------------------------------------------------
		// Apenas inclusão
		//---------------------------------------------------
		If oObjForm:GetOperation() == MODEL_OPERATION_INSERT

			cFiliais := SuperGetMV("MV_NATREPL ", .F., "")

			If Empty(AllTrim(cFiliais))
				Return xRet
			EndIf

			//---------------------------------------------------
			// Confirma réplica
			//---------------------------------------------------
			If MsgYesNo("Deseja replicar esta Natureza para as demais filiais?", "Replicação de Natureza")

				aFiliais := StrTokArr(cFiliais, ",")

				ProcRegua(Len(aFiliais))

				//---------------------------------------------------
				// Replica nas demais filiais
				//---------------------------------------------------
				For nX := 1 To Len(aFiliais)

					IncProc("Replicando filial " + aFiliais[nX] + "...")

					fReplicaSED(;
						oObjForm, ;
						AllTrim(aFiliais[nX]) )

				Next nX

				//---------------------------------------------------
				// Aviso final
				//---------------------------------------------------
				FwAlertInfo("Natureza replicada com sucesso para as demais filiais.", "Replicação Finalizada")

			EndIf

		EndIf


	EndIf

Return xRet


/*-------------------------------------------------------------------*
 | Replica Natureza Financeira                                      |
 *-------------------------------------------------------------------*/
Static Function fReplicaSED(oObjForm, cFilDest)

	Local aArea      := GetArea()
	Local aStruct    := {}
	Local nCampo     := 0
	Local cCampo     := ""
	Local xValor     := NIL
	Local cNatureza  := ""
	Local cFilOrig   := ""
	Local lExiste    := .F.
	Local nRecno     := 0
	Local cQuery     := ""

	DbSelectArea("SED")

	aStruct := SED->(DbStruct())

	//---------------------------------------------------
	// Dados do model MVC
	//---------------------------------------------------
	cNatureza := AllTrim(oObjForm:GetValue("ED_CODIGO"))

	//---------------------------------------------------
	// Filial origem correta
	//---------------------------------------------------
	cFilOrig := xFilial("SED")

	//---------------------------------------------------
	// Padding correto da filial
	//---------------------------------------------------
	cFilDest := PadR(;
		AllTrim(cFilDest), ;
		TamSX3("ED_FILIAL")[1])

	//---------------------------------------------------
	// Ignora filial origem
	//---------------------------------------------------
	If cFilDest == cFilOrig

		RestArea(aArea)
		Return

	EndIf

	//---------------------------------------------------
	// Verifica existência
	//---------------------------------------------------
	cQuery := ""
	cQuery += " SELECT R_E_C_N_O_ RECNO "
	cQuery += " FROM " + RetSQLName("SED")
	cQuery += " WHERE ED_FILIAL = '" + cFilDest + "' "
	cQuery += " AND ED_CODIGO = '" + cNatureza + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)

	TcQuery cQuery New Alias "QRYSED"

	If !QRYSED->(Eof())

		lExiste := .T.
		nRecno  := QRYSED->RECNO

	EndIf

	QRYSED->(DbCloseArea())

	//---------------------------------------------------
	// UPDATE
	//---------------------------------------------------
	If lExiste

		SED->(DbGoTo(nRecno))

		If !RecLock("SED", .F.)
			RestArea(aArea)
			Return
		EndIf

	//---------------------------------------------------
	// INSERT
	//---------------------------------------------------
	Else

		If !RecLock("SED", .T.)
			RestArea(aArea)
			Return
		EndIf

	EndIf

	//---------------------------------------------------
	// Replica campos do model MVC
	//---------------------------------------------------
	For nCampo := 1 To Len(aStruct)

		cCampo := aStruct[nCampo][1]

		//---------------------------------------------------
		// Ignora campos de controle
		//---------------------------------------------------
		If cCampo $ "R_E_C_N_O_|R_E_C_D_E_L_|D_E_L_E_T_"
			Loop
		EndIf

		Do Case

			//------------------------------------------------
			// Filial destino
			//------------------------------------------------
			Case cCampo == "ED_FILIAL"

				FieldPut(nCampo, cFilDest)

			//------------------------------------------------
			// Campos existentes no MVC
			//------------------------------------------------
			Otherwise

				If oObjForm:HasField(cCampo)

					xValor := oObjForm:GetValue(cCampo)

					If xValor != NIL
						FieldPut(nCampo, xValor)
					EndIf

				EndIf

		EndCase

	Next nCampo

	MsUnlock()

	RestArea(aArea)

Return
