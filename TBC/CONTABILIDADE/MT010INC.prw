#include "rwmake.ch"
#Include "TOTVS.ch"
#INCLUDE "topconn.ch"
#include "fwmvcdef.ch"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT010INC   ¦ Autor ¦ Maria Luiza        ¦ Data ¦ 25/11/2024¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Réplica cadastro de produtos com edição por filial         ¦¦¦
¦¦¦          ¦                             								  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ BRG-Brasil Geradores                                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MT010INC()
	Local aFilial := {}
	Local cFil := SuperGetMV("MV_FILREPL", ,"")
	Local nX
	Local aArea := GetArea()
	Local aAreaB1 := SB1->(GetArea())
	Local i
	Local cQuery := " "
	Static cTabelaAux := ''
	Static cChaveAux  := ''
	Static cFilAtuAux := ''
	Static cCodAtuAux := ''
	Static cCodNovAux := ''
	Static cFilNovAux := ''
	Static cDestino := SuperGetMV("MV_DESTINO")
	Static aFiliaisCopiadas := {}
	Static cTitulo := 'Inclusão de novo Produto'
	Static xHTM := ""
	Static aEditedData := {}

	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))

	If SBM->(MsSeek(FWxFilial("SBM") + SB1->B1_GRUPO))
		If SBM->BM_XREPLIC = "1"
			aFilial := StrTokArr(cFil, ",")

			If fShowEditScreen(aFilial, @aEditedData)
				cTabelaAux := 'SB1'
				cChaveAux  := 'B1_COD'
				cFilAtuAux := FWCodEmp()
				cCodAtuAux := SB1->B1_COD
				cCodNovAux := SB1->B1_COD

				For nX := 1 to Len(aFilial)
					cFilNovAux := aFilial[nX]
					If cFilNovAux <> FWCodEmp()
						Processa({|| fCopia(aEditedData[nX], cFilNovAux)}, 'Replicando Registro...')
						aAdd(aFiliaisCopiadas, cFilNovAux)
					EndIf
				Next

				FwAlertInfo("Cópia concluída.", "Atenção")

				If !Empty(cDestino)
					xHTM := '<HTML><BODY>'
					xHTM += '<hr>'
					xHTM += '<p style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
					xHTM += '<b><font face="Verdana" SIZE=3>' + cTitulo + '   ' + DToC(Date()) + '   ' + GetRmtTime() + '</b></p>'
					xHTM += '<hr>'
					xHTM += '<br>'
					xHTM += '<br>'
					xHTM += 'Foi incluído um novo Produto <BR><BR>-Produto <b>' + SB1->B1_COD + ' - ' + SB1->B1_DESC + '</b> <BR>-Usuário <b>' + UsrRetName(RetCodUsr()) + '</b> <br><br>'
					xHTM += '<b>Empresas onde o produto foi replicado:</b><BR>'
					xHTM += '<ul>'
					For i := 1 To Len(aFiliaisCopiadas)
						If Select("TMP") > 0
							TMP->(DbCloseArea())
						EndIf
						cQuery := "SELECT * FROM SYS_COMPANY "
						cQuery += "WHERE D_E_L_E_T_ = ' ' "
						cQuery += "AND M0_CODFIL = '" + aFiliaisCopiadas[i] + "01' "
						cQuery += "AND M0_NOMECOM <> '' "
						cQuery := ChangeQuery(cQuery)
						TcQuery cQuery New Alias "TMP"
						xHTM += '<li>' + aFiliaisCopiadas[i] + " - " + AllTrim(TMP->M0_NOMECOM) + '</li>' + CHR(13) + CHR(10)
					Next i
					xHTM += '</ul>'
					xHTM += '<BR>'
					xHTM += 'Ação: Verifique os cadastros nas empresas listadas e valide os dados.<br><br>'
					xHTM += '</BODY></HTML>'
					U_zEnvMail(cDestino, cTitulo, xHTM, {})
				EndIf
			EndIf
		EndIf
	EndIf

	SBM->(DbCloseArea())
	RestArea(aAreaB1)
	RestArea(aArea)
Return

Static Function fShowEditScreen(aFilial, aEditedData)
	Local aHeader := {}
	Local aCols   := {}
	Local oGet
	Local oDlg
	Local oButton1
	Local oButton2
	Local lOk := .F.
	Local aArea := GetArea()
	Local nX

	// Monta o cabeçalho
	AAdd(aHeader, {"Filial",       "FILIAL",    "@!", 4,  0, "", "", "C", "", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .F.})
	AAdd(aHeader, {"Tipo",         "TIPO",      "@!", 2,  0, "", "", "C", "02", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .T.})
	AAdd(aHeader, {"Grupo",        "B1_GRUPO",  "@!", 4,  0, "", "", "C", "SBM", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .F.})
	AAdd(aHeader, {"Código",       "B1_COD",    "@!", 15, 0, "", "", "C", "", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .F.})
	AAdd(aHeader,{"Descrição",    "B1_DESC",   "@!", 20, 0, "", "", "C", "", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .F.})
	AAdd(aHeader, {"Unidade",      "B1_UM",     "@!", 2,  0, "", "", "C", "SAH", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .F.})
	AAdd(aHeader, {"Armazém",      "B1_LOCPAD", "@!", 2,  0, "", "", "C", "NNR", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .T.})

	// Monta os dados para cada filial
	For nX := 1 to Len(aFilial)
		If aFilial[nX] <> FWCodEmp()
			AAdd(aCols, {aFilial[nX], SB1->B1_TIPO, SB1->B1_GRUPO, SB1->B1_COD,SB1->B1_DESC, SB1->B1_UM, SB1->B1_LOCPAD, .F.})
		EndIf
	Next

	aEditedData := aCols

	// Cria a janela de diálogo
	DEFINE MSDIALOG oDlg TITLE "Editar Tipo e Armazém por Filial" FROM 000,000 TO 320,650 OF oMainWnd PIXEL
	oGet := MsNewGetDados():New(10, 10, 130, 310, GD_UPDATE, .T., .T., Space(0), NIL, NIL, NIL, NIL, NIL, .T., oDlg, aHeader, aCols)
	// Botões
	@ 140, 210 BUTTON oButton1 PROMPT "Confirmar" SIZE 50, 15 ACTION fCopia() OF oDlg PIXEL
	@ 140, 270 BUTTON oButton2 PROMPT "Cancelar" SIZE 50, 15 ACTION oDlg:End() OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED


	RestArea(aArea)
Return lOk

Static Function fCopia(aEditedData, cFilNovAux)

	Local aArea     := GetArea()
	Local aEstru    := {}
	Local aConteu   := {}
	Local nPosFil   := 0
	Local cCampoFil := ""
	Local cQryAux   := ""
	Local nAtual    := 0
	Local cTabelaAux := 'SB1'
	Local cChaveAux  := 'B1_COD'
	Local cFilAtuAux := FWCodEmp()
	Local cCodAtuAux := SB1->B1_COD
	LocaL cCodNovAux := SB1->B1_COD

	DbSelectArea(cTabelaAux)
	aEstru := (cTabelaAux)->(DbStruct())
	nPosFil   := aScan(aEstru, {|x| "FILIAL" $ AllTrim(Upper(x[1]))})
	cCampoFil := aEstru[nPosFil][1]

	cQryAux := " SELECT "
	cQryAux += "     R_E_C_N_O_ AS DADREC "
	cQryAux += " FROM "
	cQryAux += "     " + RetSQLName(cTabelaAux) + " "
	cQryAux += " WHERE "
	cQryAux += "     " + cCampoFil + " = '" + cFilAtuAux + "' "
	cQryAux += "     AND " + cChaveAux + " = '" + cCodAtuAux + "' "
	cQryAux += "     AND D_E_L_E_T_ = ' ' "
	TCQuery cQryAux New Alias "QRY_AUX"

	If ! QRY_AUX->(EoF())
		(cTabelaAux)->(DbGoTo(QRY_AUX->DADREC))
		ProcRegua(Len(aEstru))
		For nAtual := 1 To Len(aEstru)
			IncProc("Adicionando valores (" + cValToChar(nAtual) + " de " + cValToChar(Len(aEstru)) + ")...")
			If AllTrim(aEstru[nAtual][1]) == AllTrim(cCampoFil)
				aAdd(aConteu, cFilNovAux)
			ElseIf AllTrim(aEstru[nAtual][1]) == AllTrim(cChaveAux)
				aAdd(aConteu, cCodNovAux)
			ElseIf AllTrim(aEstru[nAtual][1]) == "B1_TIPO"
				aAdd(aConteu, aEditedData[2])
			ElseIf AllTrim(aEstru[nAtual][1]) == "B1_LOCPAD"
				aAdd(aConteu, aEditedData[6])
			Else
				aAdd(aConteu, &(cTabelaAux + "->" + aEstru[nAtual][1]))
			EndIf
		Next
		IncProc("Criando o registro...")
		RecLock(cTabelaAux, .T.)
		For nAtual := 1 To Len(aEstru)
			&(aEstru[nAtual][1]) := aConteu[nAtual]
		Next
		(cTabelaAux)->(MsUnlock())
	EndIf
	QRY_AUX->(DbCloseArea())
	RestArea(aArea)
Return

User Function zEnvMail(cPara, cAssunto, xHTM, aAnexos)
	Local aArea    := GetArea()
	Local lEnvioOK := .F.
	lEnvioOK := GPEMail(cAssunto, xHTM, cPara, aAnexos)
	RestArea(aArea)
Return lEnvioOK
