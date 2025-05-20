#include "rwmake.ch"
#Include "TOTVS.ch"
// #Include "PRTOPDEF.CH" // Removido pois arquivo não encontrado ou não necessário
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
	Local cFil := SuperGetMV("MV_FILREPL", ,"")
	Local nX
	Local aArea := GetArea()
	Local aAreaB1 := SB1->(GetArea())
	Local i
	Local cQuery := " "
	Private cTabelaAux := ''
	Private cChaveAux  := ''
	Private cFilAtuAux := ''
	Private cCodAtuAux := ''
	Private cCodNovAux := ''
	Private cFilNovAux := ''
	Private cDestino := SuperGetMV("MV_DESTINO")
	Private aFiliaisCopiadas := {}
	Private cTitulo := 'Inclusão de novo Produto'
	Private xHTM := ""
	Private aFilial := {}
	Private aEditedData := {}

	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))

	If SBM->(MsSeek(FWxFilial("SBM") + SB1->B1_GRUPO))
		If SBM->BM_XREPLIC = "1"
			aFilial := StrTokArr(cFil, ",")

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

			EndIf
		EndIf
	EndIf

	SBM->(DbCloseArea())
	RestArea(aAreaB1)
	RestArea(aArea)
Return


Static Function fCopia()

	Local nX
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

	// Monta o cabeçalho
	AAdd(aHeadSB1, {"Filial",       "FILIAL",    "@!", 4,  0, "", "", "C", "", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .F.})
	AAdd(aHeadSB1, {"Tipo",         "TIPO",      "@!", 2,  0, "", "", "C", "02", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .T.})
	AAdd(aHeadSB1, {"Grupo",        "B1_GRUPO",  "@!", 4,  0, "", "", "C", "SBM", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .F.})
	AAdd(aHeadSB1, {"Código",       "B1_COD",    "@!", 15, 0, "", "", "C", "", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .F.})
	AAdd(aHeadSB1,{"Descrição",    "B1_DESC",    "@!", 20, 0, "", "", "C", "", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .F.})
	AAdd(aHeadSB1, {"Unidade",      "B1_UM",     "@!", 2,  0, "", "", "C", "SAH", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .F.})
	AAdd(aHeadSB1, {"Armazém",      "B1_LOCPAD", "@!", 2,  0, "", "", "C", "NNR", NIL, NIL, NIL, NIL, NIL, NIL, NIL, .T.})

	// Monta os dados para cada filial
	For nX := 1 to Len(aFilial)
		If aFilial[nX] <> FWCodEmp()
			AAdd(aColsSB1, {aFilial[nX], SB1->B1_TIPO, SB1->B1_GRUPO, SB1->B1_COD,SB1->B1_DESC, SB1->B1_UM, SB1->B1_LOCPAD, .F.})
		EndIf
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
	"AllwaysTrue()",; // Validação da linha (após edição do campo)
	,; // Validação geral (simplificada)
	"",; // cIniCpos
	{"TIPO","B1_LOCPAD"},; // Campos editáveis
	,; // nFreeze
	9999,; // nMax
	,; // cFieldOK
	,; // cSuperDel
	,; // cDelOk
	oDlgPvt,; // oWnd
	aHeadSB1,; // aHeader
	aColsSB1) // aCols

	FwAlertInfo("Atenção: Caso a tela seja cancelada, será gravado apenas o registro da filial corrente. Para replicar o produto nas demais filiais, clique em Salvar.", "Aviso")

	ACTIVATE MSDIALOG oDlgPvt CENTERED

	RestArea(aArea)
Return

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
	Local i        := 0
	Local lExiste   := .F.
	Local nRecno    := 0
	Local nX        := 0

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

		// Busca se já existe o produto na filial de destino
		cQryAux := " SELECT R_E_C_N_O_ AS DADREC "
		cQryAux += " FROM " + RetSQLName(cTabelaAux) + " "
		cQryAux += " WHERE " + cCampoFil + " = '" + aColsSB1[nX][1] + "' "
		cQryAux += " AND " + cChaveAux + " = '" + aColsSB1[nX][4] + "' "
		cQryAux += " AND D_E_L_E_T_ = ' ' "
		TCQuery cQryAux New Alias "QRY_AUX"

		lExiste := !QRY_AUX->(EoF())
		nRecno  := IIf(lExiste, QRY_AUX->DADREC, 0)
		QRY_AUX->(DbCloseArea())

		// Busca o produto da filial de origem (corrente)
		cQryAux := " SELECT R_E_C_N_O_ AS DADREC "
		cQryAux += " FROM " + RetSQLName(cTabelaAux) + " "
		cQryAux += " WHERE " + cCampoFil + " = '" + cFilAtuAux + "' "
		cQryAux += " AND " + cChaveAux + " = '" + cCodAtuAux + "' "
		cQryAux += " AND D_E_L_E_T_ = ' ' "
		TCQuery cQryAux New Alias "QRY_AUX"

		If !QRY_AUX->(EoF())
			(cTabelaAux)->(DbGoTo(QRY_AUX->DADREC))

			aConteu := {}
			For nAtual := 1 To Len(aEstru)
				If AllTrim(aEstru[nAtual][1]) == AllTrim(cCampoFil)
					aAdd(aConteu, aColsSB1[nX][1]) // filial de destino
				ElseIf AllTrim(aEstru[nAtual][1]) == AllTrim(cChaveAux)
					aAdd(aConteu, aColsSB1[nX][4]) // código do produto
				ElseIf AllTrim(aEstru[nAtual][1]) == AllTrim(cCampoTipo)
					aAdd(aConteu, aColsSB1[nX][2]) // tipo
				ElseIf AllTrim(aEstru[nAtual][1]) == "B1_GRUPO"
					aAdd(aConteu, aColsSB1[nX][3]) // grupo
				ElseIf AllTrim(aEstru[nAtual][1]) == AllTrim(cCampoLocal)
					aAdd(aConteu, aColsSB1[nX][7]) // local padrão (corrigido para pegar da coluna 7)
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

	if !empty(cDestino)
		// Monta o HTML do e-mail com as filiais da grid editada (aColsSB1)
		xHTM := '<HTML><BODY>'
		xHTM += '<hr>'
		xHTM += '<p style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
		xHTM += '<b><font face="Verdana" SIZE=3>' + cTitulo + ' &nbsp; ' + dtoc(date()) + '&nbsp;&nbsp;&nbsp;' + GetRmtTime() + '</font></b></p>'
		xHTM += '<hr>'
		xHTM += '<br>'
		xHTM += '<br>'
		xHTM += 'Foi incluído um novo Produto:<br><br>- Produto <b>' + cCodAtuAux + ' - ' + SB1->B1_DESC + '</b> <br>- Usuário <b>' + UsrRetName(RetCodUsr()) + '</b> <br><br>'
		xHTM += '<b>Empresas onde o produto foi replicado:</b><br>'
		xHTM += '<ul>'
		For i := 1 To Len(aColsSB1)
			If Select("TMP") > 0
				TMP->(dbCloseArea())
			EndIf

			cQuery := "SELECT * FROM SYS_COMPANY "
			cQuery += "WHERE D_E_L_E_T_ = ' ' "
			cQuery += "AND M0_CODFIL = '" + aColsSB1[i][1] + "01' "
			cQuery += "AND M0_NOMECOM <> '' "

			cQuery := ChangeQuery(cQuery)
			TcQuery cQuery New Alias "TMP"

			xHTM += '<li>' + aColsSB1[i][1] + " - " + Alltrim(TMP->M0_NOMECOM) + '</li>' + CHR(13) + CHR(10)
		Next i
		xHTM += '</ul>'
		xHTM += '<br>'
		xHTM += 'Ação: Verifique os cadastros nas empresas listadas e valide os dados.<br><br>'
		xHTM += '</BODY></HTML>'
	endif

		//Chama o disparo do e-Mail
			U_zEnvMail(cDestino, cTitulo, xHTM, {})

    oDlgPvt:End()
    RestArea(aArea)
Return

User Function zEnvMail(cPara, cAssunto, xHTM, aAnexos)

	Local aArea    := GetArea()
	Local lEnvioOK := .F.
	lEnvioOK := GPEMail(cAssunto, xHTM, cPara, aAnexos)
	RestArea(aArea)

Return lEnvioOK
