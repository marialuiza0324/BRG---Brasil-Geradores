//Bibliotecasxsa
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
¦¦¦Descriçào ¦ Réplica cadastro de produtos                               ¦¦¦
¦¦¦          ¦                             								  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ BRG-Brasil Geradores                                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MT010INC()

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
	Static cFilNovAux:= ''
	Static cDestino := SuperGetMV("MV_DESTINO")
	Static aFiliaisCopiadas := {}
	Static cTitulo:='Inclusão de novo Produto'
	Static xHTM := ""
	Static aFilial := {}

/*
	Tabela
	Campo Chave
	Filial Atual
	Chave Atual
	Filial Nova
	Chave Nova
	*/
	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))

	If SBM->(MsSeek(FWxFilial("SBM") + SB1->B1_GRUPO)) // busca grupo na tabela SBM

		If SBM->BM_XREPLIC = "1" // Verifica se grupo se enquadra na réplica do produto

			aFilial:= StrTokArr(cFil, ",") //Transforma conteúdo do parâmetro em array

			cTabelaAux := 'SB1'
			cChaveAux  := 'B1_COD'
			cFilAtuAux := FWCodEmp()
			cCodAtuAux := SB1->B1_COD
			cCodNovAux := SB1->B1_COD
			For nX := 1 to Len(aFilial)
				cFilNovAux := aFilial[nX]
				If cFilNovAux <> FWCodEmp()
					Processa({|| fCopia()}, 'Replicando Registro...')
					aAdd(aFiliaisCopiadas, cFilNovAux)
					Exit // Sai do loop após chamar fCopia(), pois a tela será exibida e o usuário ajustará os dados
				EndIf
			Next
			FwAlertInfo("Cópia concluída.", "Atenção")

			if !empty(cDestino)
				//Envia email de Aviso
				xHTM := '<HTML><BODY>'
				xHTM += '<hr>'
				xHTM += '<p  style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
				xHTM += '<b><font face="Verdana" SIZE=3>'+cTitulo+' &nbsp; '+dtoc(date())+'&nbsp;&nbsp;&nbsp;'+GetRmtTime()+'</b></p>'
				xHTM += '<hr>'
				xHTM += '<br>'
				xHTM += '<br>'
				xHTM += 'Foi incluido um novo Produto <BR><BR>-Produto <b>'   +SB1->B1_COD+' - '+SB1->B1_DESC+'</b> <BR>-Usuario <b>'+UsrRetName(RetCodUsr())+'</b> <br><br>'
				xHTM += '<b>Empresas onde o produto foi replicado:</b><BR>'
				xHTM += '<ul>'
				For i := 1 To Len(aFiliaisCopiadas)

					If Select("TMP") > 0
						TMP->(dbCloseArea())
					EndIf

					cQuery := "SELECT * FROM SYS_COMPANY "
					cQuery += "WHERE D_E_L_E_T_ = ' ' "
					cQuery += "AND M0_CODFIL = '"+aFiliaisCopiadas[i]+"01' "
					cQuery += "AND M0_NOMECOM <> '' "

					cQuery := ChangeQuery(cQuery)
					TcQuery cQuery New Alias "TMP"

					xHTM += '<li>' + aFiliaisCopiadas[i] + " - " + Alltrim(TMP->M0_NOMECOM) + '</li>' +CHR(13)+CHR(10)

				Next i

				xHTM += '</ul>'
				xHTM += '<BR>'
				xHTM += 'Ação: Verifique os cadastros nas empresas listadas e valide os dados.<br><br>'
				xHTM += '</BODY></HTML>'
			EndIf

		EndIf
	EndIF

	SBM->(DbCloseArea())
	RestArea(aAreaB1)
	RestArea(aArea)

Return

Static Function fCopia()
	Local i
	Local aArea := GetArea()
	Private oDlgPvt
	Private oMsGetSBM
	Private aHeadSB1 := {}
	Private aColsSB1 := {}
	Private oBtnSalv
	Private oBtnFech
	Private oBtnLege
	Private nJanLarg := 700
	Private nJanAltu := 500
	Private cFontUti := "Tahoma"
	Private oFontAno := TFont():New(cFontUti,,-38)
	Private oFontSub := TFont():New(cFontUti,,-20)
	Private oFontSubN := TFont():New(cFontUti,,-20,,.T.)
	Private oFontBtn := TFont():New(cFontUti,,-14)
	Private oBmpAuxactually
	Private cCodOrig := "" // Valor original do Código
	Private cGrpOrig := "" // Valor original do Grupo

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If !SB1->(MsSeek(FWxFilial("SB1") + cCodAtuAux))
		FwAlertError("Registro SB1 não encontrado para o código " + cCodAtuAux, "Erro")
		RestArea(aArea)
		Return
	EndIf

	// Armazena os valores originais
	cCodOrig := SB1->B1_COD
	cGrpOrig := SB1->B1_GRUPO

	// Cabeçalho da Grid
	aAdd(aHeadSB1, {"Filial", "B1_FILIAL", "", TamSX3("B1_FILIAL")[01], 0, ".F.", ".T.", "C", "", ""}) // Coluna 1
	aAdd(aHeadSB1, {"Tipo", "B1_TIPO", "", TamSX3("B1_TIPO")[01], 0, "U_TriggerLinha()", ".F.", "C", "", ""}) // Coluna 2 - Editável
	aAdd(aHeadSB1, {"Código", "B1_COD", "", TamSX3("B1_COD")[01], 0, ".F.", ".F.", "C", "", ""}) // Coluna 3 - Não editável
	aAdd(aHeadSB1, {"Grupo", "B1_GRUPO", "", TamSX3("B1_GRUPO")[01], 0, ".F.", ".F.", "C", "", ""}) // Coluna 4 - Não editável
	aAdd(aHeadSB1, {"Armazem Pad.", "B1_LOCPAD", "", TamSX3("B1_LOCPAD")[01], 0, "A010VLoc()", ".T.", "C", "", ""}) // Coluna 5 - Editável
	aAdd(aHeadSB1, {"Descrição", "B1_DESC", "", TamSX3("B1_DESC")[01], 0, ".F.", ".T.", "C", "", ""}) // Coluna 6
	aAdd(aHeadSB1, {"Unidade", "B1_UM", "", TamSX3("B1_UM")[01], 0, "ExistCpo('SAH')", ".T.", "C", "", ""}) // Coluna 7

	// Preenchendo o aColsSB1 com valores iniciais
	For i := 1 To Len(aFilial)
		aAdd(aColsSB1, {aFilial[i], SB1->B1_TIPO, SB1->B1_COD, SB1->B1_GRUPO, SB1->B1_LOCPAD, SB1->B1_DESC, SB1->B1_UM, .F.})
	Next

	DEFINE MSDIALOG oDlgPvt TITLE "Cadastro de Produto" FROM 000, 000 TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
	@ 004, 050 SAY "Listagem da Réplica" SIZE 200, 030 FONT oFontSub OF oDlgPvt COLORS RGB(031,073,125) PIXEL
	@ 014, 050 SAY "Do Cadastro de Produtos" SIZE 200, 030 FONT oFontSubN OF oDlgPvt COLORS RGB(031,073,125) PIXEL

	@ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech PROMPT "Fechar" SIZE 050, 018 OF oDlgPvt ACTION (oDlgPvt:End()) FONT oFontBtn PIXEL
	@ 006, (nJanLarg/2-001)-(0052*03) BUTTON oBtnSalv PROMPT "Salvar" SIZE 050, 018 OF oDlgPvt ACTION (fSalvar()) FONT oFontBtn PIXEL

	oMsGetSBM := MsNewGetDados():New(029,; // nTop
	003,; // nLeft
	(nJanAltu/2)-3,; // nBottom
	(nJanLarg/2)-3,; // nRight
	GD_UPDATE,; // Apenas edição
	"U_TriggerLinha()",; // Validação da linha (após edição do campo)
	"AllwaysTrue()",; // Validação geral (simplificada)
	"",; // cIniCpos
	{"B1_TIPO", "B1_LOCPAD"},; // Campos editáveis
	,; // nFreeze
	9999,; // nMax
	,; // cFieldOK
	,; // cSuperDel
	,; // cDelOk
	oDlgPvt,; // oWnd
	aHeadSB1,; // aHeader
	aColsSB1) // aCols

	ACTIVATE MSDIALOG oDlgPvt CENTERED

	RestArea(aArea)
Return

User Function TriggerLinha()

	Local lRet      := .T.
	Local nLinha    := oMsGetSBM:nAt // Linha atual do grid
	Local cTipo     := oMsGetSBM:aCols[nLinha][2] // Coluna 2 = B1_TIPO
	Local cLoc      := oMsGetSBM:aCols[nLinha][5] // Coluna 5 = B1_LOCPAD
	Local cCodAtual := oMsGetSBM:aCols[nLinha][3] // Coluna 3 = B1_COD
	Local cGrpAtual := oMsGetSBM:aCols[nLinha][4] // Coluna 4 = B1_GRUPO

	// Validação do Tipo (após edição)
	If Empty(cTipo)
		MsgAlert("O campo Tipo não pode estar vazio!", "Atenção")
		lRet := .F.
	ElseIf !ExistCpo("SX5", "02" + cTipo)
		MsgAlert("Tipo inválido!", "Atenção")
		lRet := .F.
	EndIf

	// Validação do Armazém (após edição)
	If Empty(cLoc)
		MsgAlert("O campo Armazém não pode estar vazio!", "Atenção")
		lRet := .F.
	ElseIf !ExistCpo("NNR", cLoc) // Ajuste para a tabela de armazéns correta
		MsgAlert("Armazém inválido!", "Atenção")
		lRet := .F.
	EndIf

	// Preservação de Código e Grupo APÓS a alteração do Tipo
	If lRet
		// Se o código foi alterado ou apagado, restaura o original
		If Empty(cCodAtual) .Or. cCodAtual != cCodOrig
			oMsGetSBM:aCols[nLinha][3] := cCodOrig
		EndIf
		// Se o grupo foi alterado ou apagado, restaura o original
		If Empty(cGrpAtual) .Or. cGrpAtual != cGrpOrig
			oMsGetSBM:aCols[nLinha][4] := cGrpOrig
		EndIf
	EndIf

	//oMsGetSBM:Refresh()

Return lRet


User Function zEnvMail(cPara, cAssunto, xHTM, aAnexos)

	Local aArea    := GetArea()
	Local lEnvioOK := .F.

	lEnvioOK := GPEMail(cAssunto, xHTM, cPara, aAnexos)

	RestArea(aArea)
Return lEnvioOK


/*--------------------------------------------------------*
 | Func.: fSalvar                                         |
 | Desc.: Função que percorre as linhas e faz a gravação  |
 *--------------------------------------------------------*/
Static Function fSalvar()
    Local nAtual    := 0
    Local aArea     := GetArea()
    Local aEstru    := {}
    Local aConteu   := {}
    Local nPosFil   := 0
    Local nPosTipo  := 0
    Local nPosLocal := 0
    Local cCampoFil := ""
    Local cCampoTipo := ""
    Local cCampoLocal := ""
    Local cQryAux   := ""
    Local nX        := 0
    Local lExiste   := .F.
    Local nRecno    := 0

    // Sincroniza aColsSB1 com os valores editados na grid
    aColsSB1 := aClone(oMsGetSBM:aCols)

    DbSelectArea(cTabelaAux)
    aEstru := (cTabelaAux)->(DbStruct())

    nPosFil   := aScan(aEstru, {|x| "FILIAL" $ AllTrim(Upper(x[1]))})
    nPosTipo  := aScan(aEstru, {|x| "TIPO" $ AllTrim(Upper(x[1]))})
    nPosLocal := aScan(aEstru, {|x| "LOCPAD" $ AllTrim(Upper(x[1]))})

    cCampoFil   := aEstru[nPosFil][1]
    cCampoTipo  := aEstru[nPosTipo][1]
    cCampoLocal := aEstru[nPosLocal][1]

    ProcRegua(Len(aColsSB1))
    For nX := 1 To Len(aColsSB1)
        IncProc("Gravando filial " + aColsSB1[nX][1] + " (" + cValToChar(nX) + " de " + cValToChar(Len(aColsSB1)) + ")...")

        aConteu := {}

        // Depuração dos valores do grid
        Conout("Filial: " + aColsSB1[nX][1] + " Tipo: " + aColsSB1[nX][2] + " Código: " + aColsSB1[nX][3] + " Grupo: " + aColsSB1[nX][4] + " Armazém: " + aColsSB1[nX][5])

        cQryAux := " SELECT R_E_C_N_O_ AS DADREC "
        cQryAux += " FROM " + RetSQLName(cTabelaAux) + " "
        cQryAux += " WHERE " + cCampoFil + " = '" + aColsSB1[nX][1] + "' "
        cQryAux += " AND " + cChaveAux + " = '" + aColsSB1[nX][3] + "' "
        cQryAux += " AND D_E_L_E_T_ = ' ' "
        TCQuery cQryAux New Alias "QRY_AUX"

        lExiste := !QRY_AUX->(EoF())
        nRecno  := IIf(lExiste, QRY_AUX->DADREC, 0)
        QRY_AUX->(DbCloseArea())

        cQryAux := " SELECT R_E_C_N_O_ AS DADREC "
        cQryAux += " FROM " + RetSQLName(cTabelaAux) + " "
        cQryAux += " WHERE " + cCampoFil + " = '" + cFilAtuAux + "' "
        cQryAux += " AND " + cChaveAux + " = '" + cCodAtuAux + "' "
        cQryAux += " AND D_E_L_E_T_ = ' ' "
        TCQuery cQryAux New Alias "QRY_AUX"

        If !QRY_AUX->(EoF())
            (cTabelaAux)->(DbGoTo(QRY_AUX->DADREC))

            For nAtual := 1 To Len(aEstru)
                If AllTrim(aEstru[nAtual][1]) == AllTrim(cCampoFil)
                    aAdd(aConteu, aColsSB1[nX][1])
                ElseIf AllTrim(aEstru[nAtual][1]) == AllTrim(cChaveAux)
                    aAdd(aConteu, aColsSB1[nX][3])
                ElseIf AllTrim(aEstru[nAtual][1]) == AllTrim(cCampoTipo)
                    aAdd(aConteu, aColsSB1[nX][2])
                ElseIf AllTrim(aEstru[nAtual][1]) == "B1_GRUPO"
                    aAdd(aConteu, aColsSB1[nX][4])
                ElseIf AllTrim(aEstru[nAtual][1]) == AllTrim(cCampoLocal)
                    aAdd(aConteu, aColsSB1[nX][5])
                Else
                    aAdd(aConteu, &(cTabelaAux + "->" + aEstru[nAtual][1]))
                EndIf
            Next

            If lExiste
                (cTabelaAux)->(DbGoTo(nRecno))
                RecLock(cTabelaAux, .F.)
                For nAtual = 1 To Len(aEstru)
                    &(aEstru[nAtual][1]) := aConteu[nAtual]
                Next
                (cTabelaAux)->(MsUnlock())
            Else
                RecLock(cTabelaAux, .T.)
                For nAtual = 1 To Len(aEstru)
                    &(aEstru[nAtual][1]) := aConteu[nAtual]
                Next
                (cTabelaAux)->(MsUnlock())
            EndIf
        EndIf
        QRY_AUX->(DbCloseArea())
    Next

		//Chama o disparo do e-Mail
			U_zEnvMail(cDestino, cTitulo, xHTM, {})

    oDlgPvt:End()
    RestArea(aArea)
Return

// Função personalizada para validar o Tipo sem apagar outros campos
User Function ValidaTipo()

    Local lRet := .T.
    Local cTipo := M->B1_TIPO

    If Empty(cTipo)
        MsgAlert("O campo Tipo não pode estar vazio!", "Atenção")
        lRet := .F.
    ElseIf !ExistCpo("SX5", "02" + cTipo)
        MsgAlert("Tipo inválido!", "Atenção")
        lRet := .F.
    EndIf

	u_TriggerLinha()

Return lRet
