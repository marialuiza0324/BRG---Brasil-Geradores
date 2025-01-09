#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"
#Include "FWMVCDef.ch"

/*/{Protheus.doc}
Função para limpeza de FLAGs
da contabilidade
@type  Function
@author Maria Luiza
@since 05/11/2024 */
 
User Function FSCON001()

	Static oButton1
	Static oButton2
	Static oGet1
	Static cGet1 := CTOD("/ /")
	Static oGet2
	Static cGet2 := CTOD("/ /")
	Static oGet3
	Static nGet3 := SPACE(30)
	Static oGet4
	Static nGet4 := SPACE(30)
	Static oGet5
	Static cGet5 := SPACE(50)
	Static oComboBo1
	Static cComboBo1 := ""
	Static oSay1
	Static oSay2
	Static oSay3
	Static oSay4
	Static oSay5
	Static oSay6
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Filtro para limpeza de FLAGs" FROM 000, 000  TO 550, 650 COLORS 0, 16777215 PIXEL

	@ 022, 045 SAY oSay1 PROMPT "Selecione a Tabela" SIZE 056, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 039, 045 MSCOMBOBOX oComboBo1 VAR cComboBo1 ITEMS {"SE1","SE2","SE5","SEF","SF1","SF2","SRZ"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 072, 045 SAY oSay2 PROMPT "De Data :" SIZE 025, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 088, 045 MSGET oGet1 VAR cGet1 SIZE 072, 015 OF oDlg COLORS 0, 16777215 PIXEL
	@ 072, 191 SAY oSay3 PROMPT "Até Data :" SIZE 028, 009 OF oDlg COLORS 0, 16777215 PIXEL
	@ 088, 191 MSGET oGet2 VAR cGet2 SIZE 072, 015 OF oDlg COLORS 0, 16777215 PIXEL
	@ 122, 045 SAY oSay4 PROMPT "De Valor :" SIZE 027, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 142, 045 MSGET oGet3 VAR nGet3 SIZE 072, 015 OF oDlg COLORS 0, 16777215 PIXEL
	@ 122, 191 SAY oSay5 PROMPT "Até Valor :" SIZE 028, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 142, 191 MSGET oGet4 VAR nGet4 SIZE 072, 015 OF oDlg COLORS 0, 16777215 PIXEL
	@ 179, 045 SAY oSay6 PROMPT "Nº do Documento :" SIZE 050, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 195, 045 MSGET oGet5 VAR cGet5 SIZE 100, 015 OF oDlg COLORS 0, 16777215 PIXEL
	@ 250, 270 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oDlg ACTION fMontaTela() PIXEL
	@ 250, 020 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION (oDlg:End()) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED
Return

/*/{Protheus.doc} fMontaTela
Monta a tela com a marcação de dados
@author Maria Luiza
@since 08/11/2024
@version 1.0
@type function
/*/

Static Function fMontaTela()

	Local aArea         := GetArea()
	Local aCampos := {}
	Local oTempTable := Nil
	Local aColunas := {}
	Local cFontPad    := 'Tahoma'
	Local oFontGrid   := TFont():New(cFontPad, /*uPar2*/, -14)
	Local _cQry
	//Janela e componentes
	Static oDlgMark
	Static oPanGrid
	Static oMarkBrowse
	Static cAliasTmp := GetNextAlias()
	Static aRotina   := MenuDef()
	//Tamanho da janela
	Static aTamanho := MsAdvSize()
	Static nJanLarg := aTamanho[5]
	Static nJanAltu := aTamanho[6]
	Static xPar1
	Static xPar2
	Static xPar3
	Static xPar4
	Static xPar5
	Static xPar6
	Static xPar7
	Static xPar8
	Static xPar9
	Static xPar10
	Static xPar11
	Static xPar12

	If cComboBo1 = "SE1"

		xPar1 := "E1_FILIAL "
		xPar2 := "E1_PREFIXO "
		xPar3 := "E1_NUM "
		xPar4 := "E1_TIPO "
		xPar5 := "E1_PARCELA "
		xPar6 := "E1_VALOR "
		xPar7 := "E1_EMISSAO "
		xPar8 := "E1_CLIENTE "
		xPar9 := "E1_NOMCLI "
		xPar10 := "E1_LOJA "
		xPar11 := "SE1"
		xPar12 := "E1_LA"

	ElseIf cComboBo1 = "SE2"

		xPar1 := "E2_FILIAL "
		xPar2 := "E2_PREFIXO "
		xPar3 := "E2_NUM "
		xPar4 := "E2_TIPO "
		xPar5 := "E2_PARCELA "
		xPar6 := "E2_VALOR "
		xPar7 := "E2_EMISSAO "
		xPar8 := "E2_FORNECE "
		xPar9 := "E2_NOMFOR "
		xPar10 := "E2_LOJA "
		xPar11 := "SE2"
		xPar12 := "E2_LA"

	ElseIf cComboBo1 = "SE5"

		xPar1 := "E5_FILIAL "
		xPar2 := "E5_PREFIXO "
		xPar3 := "E5_NUMERO "
		xPar4 := "E5_TIPO "
		xPar5 := "E5_PARCELA "
		xPar6 := "E5_VALOR "
		xPar7 := "E5_DATA "
		xPar8 := "E5_CLIENTE "
		xPar9 := "E5_FORNECE "
		xPar10 := "E5_LOJA "
		xPar11 := "SE5"
		xPar12 := "E5_LA"

	ElseIf cComboBo1 = "SEF"

		xPar1 := "EF_FILIAL "
		xPar2 := "EF_PREFIXO "
		xPar3 := "EF_TITULO "
		xPar4 := "EF_TIPO "
		xPar5 := "EF_PARCELA "
		xPar6 := "EF_VALOR "
		xPar7 := "EF_DATA "
		xPar8 := "EF_CLIENTE "
		xPar9 := "EF_FORNECE "
		xPar10 := "EF_LOJA "
		xPar11 := "SEF"
		xPar12 := "EF_LA"

	ElseIf cComboBo1 = "SF1"

		xPar1 := "F1_FILIAL "
		xPar2 := "F1_DOC "
		xPar3 := "F1_SERIE "
		xPar4 := "F1_DUPL "
		xPar5 := "F1_COND "
		xPar6 := "F1_VALBRUT "
		xPar7 := "F1_EMISSAO "
		xPar8 := "F1_FORNECE "
		xPar9 := "F1_NOME "
		xPar10 := "F1_LOJA "
		xPar11 := "SF1"
		xPar12 := "F1_DTLANC"

	ElseIf cComboBo1 = "SF2"

		xPar1 := "F2_FILIAL "
		xPar2 := "F2_DOC "
		xPar3 := "F2_SERIE "
		xPar4 := "F2_DUPL "
		xPar5 := "F2_COND "
		xPar6 := "F2_VALBRUT "
		xPar7 := "F2_EMISSAO "
		xPar8 := "F2_CLIENTE "
		xPar9 := "F2_XNOMCLI "
		xPar10 := "F2_LOJA "
		xPar11 := "SF2"
		xPar12 := "F2_DTLANC"

	Else //SRZ

		_cQry := "DELETE FROM " +RetSqlname("SRZ") "

		TcSqlExec(_cQry)

		FWAlertInfo("Processado com sucesso","Atenção!!!")

		(oDlg:End())

		Return

	EndIf

	//Adiciona as colunas que serão criadas na temporária
	aAdd(aCampos, { 'OK', 'C', 2, 0}) //Flag para marcação
	aAdd(aCampos, { xPar1, 'C', 4, 0}) //Filial
	aAdd(aCampos, { xPar2, 'C', 3, 0}) //Prefixo
	aAdd(aCampos, { xPar3, 'C', 9, 0}) //Nº Título
	aAdd(aCampos, { xPar4, 'C', 3, 0}) //Tipo
	aAdd(aCampos, { xPar5, 'C', 2, 0}) //Parcela
	aAdd(aCampos, { xPar6, 'N', 12, 2}) //Valor Título
	aAdd(aCampos, { xPar7, 'D', 8, 0}) //Vencimento
	aAdd(aCampos, { xPar8, 'C', 9, 0}) //Cliente / Fornecedor
	aAdd(aCampos, { xPar9, 'C', 20, 0}) //Nome Cliente / Fornecedor
	aAdd(aCampos, { xPar10, 'C', 4, 0}) //Loja

	//Cria a tabela temporária
	oTempTable:= FWTemporaryTable():New(cAliasTmp)
	oTempTable:SetFields( aCampos )
	oTempTable:Create()

	//Popula a tabela temporária
	Processa({|| fPopula()}, 'Processando...')

	//Adiciona as colunas que serão exibidas no FWMarkBrowse
	aColunas := fCriaCols()

	//Criando a janela
	DEFINE MSDIALOG oDlgMark TITLE 'Tela para Marcação de dados' FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
	//Dados
	oPanGrid := tPanel():New(001, 001, '', oDlgMark, /*oFont*/, /*lCentered*/, /*uParam7*/, RGB(000,000,000), RGB(254,254,254), (nJanLarg/2) - 1, (nJanAltu/2) - 1)
	oMarkBrowse := FWMarkBrowse():New()
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:SetDescription('Limpeza de FLAGS')
	oMarkBrowse:DisableFilter()
	oMarkBrowse:DisableConfig()
	oMarkBrowse:DisableSeek()
	oMarkBrowse:DisableSaveConfig()
	oMarkBrowse:SetFontBrowse(oFontGrid)
	oMarkBrowse:SetFieldMark('OK')
	oMarkBrowse:SetTemporary(.T.)
	oMarkBrowse:SetColumns(aColunas)
	//oMarkBrowse:AllMark()
	oMarkBrowse:SetOwner(oPanGrid)
	oMarkBrowse:Activate()
	ACTIVATE MsDialog oDlgMark CENTERED

	//Deleta a temporária e desativa a tela de marcação
	oTempTable:Delete()
	oMarkBrowse:DeActivate()

	RestArea(aArea)
Return

/*/{Protheus.doc} MenuDef
Botões usados no Browse
@author Maria Luiza
@since 08/11/2024
@version 1.0
@type function
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Criação das opções
	ADD OPTION aRotina TITLE 'Continuar'  ACTION 'U_FILTROFLAG()'     OPERATION 2 ACCESS 0


Return aRotina

/*/{Protheus.doc} fPopula
Executa a query SQL e popula essa informação na tabela temporária usada no browse
@author Maria Luiza
@since 08/11/2024
@version 1.0
@type function
/*/

Static Function fPopula()
	Local cQryDados := ''
	Local nTotal := 0
	Local nAtual := 0

	//Monta a consulta
	cQryDados := "SELECT * FROM " + retsqlname( xPar11 ) "
	cQryDados += " WHERE D_E_L_E_T_ = '' "
	cQryDados += " AND " +xPar1+ " = '"+xFilial(xPar11)+"' "
	If !Empty(cGet1) .AND. !Empty(cGet2)
		cQryDados += " AND " +xPar7+"BETWEEN '"+Dtos(cGet1)+"' AND '"+Dtos(cGet2)+"' "
	EndIf
	If !Empty(PadR(AllTrim(nGet3),TamSx3(xPar6)[1])) .AND. !Empty(PadR(AllTrim(nGet4),TamSx3(xPar6)[1])) .AND. xPar11 = 'SE1' .OR. xPar11 = 'SE2' .OR. xPar11 = 'SE5' .OR. xPar11 = 'SEF'
		cQryDados += " AND " +xPar6+" BETWEEN '"+PadR(AllTrim(nGet3),TamSx3(xPar6)[1])+"' AND '"+PadR(AllTrim(nGet4),TamSx3(xPar6)[1])+"' "
	/*If !Empty(PadR(AllTrim(nGet3),TamSx3(xPar6)[1])) .AND. !Empty(PadR(AllTrim(nGet4),TamSx3(xPar6)[1])) .AND. xPar11 = 'SE1' .OR. xPar11 = 'SE2' .OR. xPar11 = 'SE5' .OR. xPar11 = 'SEF'
		cQryDados += " AND " +xPar6+" BETWEEN '"+Alltrim(Transform( nGet3, "@E 9,999,999,999,999.99"))+"' AND '"+Alltrim(Transform( nGet4, "@E 9,999,999,999,999.99"))+"' "
	ElseIf !Empty(PadR(AllTrim(nGet3),TamSx3(xPar6)[1])) .AND. !Empty(PadR(AllTrim(nGet4),TamSx3(xPar6)[1])) .AND. xPar11 = 'SF1'
		cQryDados += " AND " +xPar6+" BETWEEN '"+Alltrim(Transform( nGet3, "@E 999,999,999.99"))+"' AND '"+Alltrim(Transform( nGet4, "@E 999,999,999.99"))+"' "
	ElseIf !Empty(PadR(AllTrim(nGet3),TamSx3(xPar6)[1])) .AND. !Empty(PadR(AllTrim(nGet4),TamSx3(xPar6)[1])) .AND. xPar = 'SF2'
		cQryDados += " AND " +xPar6+" BETWEEN '"+Alltrim(Transform( nGet3, "@E 999,999,999.9999"))+"' AND '"+Alltrim(Transform( nGet4, "@E 999,999,999.9999"))+"' "*/
	EndIf
	If !Empty(cGet5)
		cQryDados += " AND " +xPar2+" = '"+Alltrim(cGet5)+"' "
	EndIf
	PLSQuery(cQryDados, 'QRYDADTMP')

	//Definindo o tamanho da régua
	DbSelectArea('QRYDADTMP')
	Count to nTotal
	ProcRegua(nTotal)
	QRYDADTMP->(DbGoTop())

	// Enquanto houver registros, adiciona na temporária
	While !QRYDADTMP->(EoF())
		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		RecLock(cAliasTmp, .T.)

		If xPar11 == "SE1"
			(cAliasTmp)->OK := Space(2)
			(cAliasTmp)->E1_FILIAL := QRYDADTMP->E1_FILIAL
			(cAliasTmp)->E1_PREFIXO := QRYDADTMP->E1_PREFIXO
			(cAliasTmp)->E1_NUM := QRYDADTMP->E1_NUM
			(cAliasTmp)->E1_TIPO := QRYDADTMP->E1_TIPO
			(cAliasTmp)->E1_PARCELA := QRYDADTMP->E1_PARCELA
			(cAliasTmp)->E1_VALOR := QRYDADTMP->E1_VALOR
			(cAliasTmp)->E1_EMISSAO := QRYDADTMP->E1_EMISSAO
			(cAliasTmp)->E1_CLIENTE := QRYDADTMP->E1_CLIENTE
			(cAliasTmp)->E1_NOMCLI := QRYDADTMP->E1_NOMCLI
			(cAliasTmp)->E1_LOJA := QRYDADTMP->E1_LOJA

		ElseIf xPar11 == "SE2"
			(cAliasTmp)->OK := Space(2)
			(cAliasTmp)->E2_FILIAL := QRYDADTMP->E2_FILIAL
			(cAliasTmp)->E2_PREFIXO := QRYDADTMP->E2_PREFIXO
			(cAliasTmp)->E2_NUM := QRYDADTMP->E2_NUM
			(cAliasTmp)->E2_TIPO := QRYDADTMP->E2_TIPO
			(cAliasTmp)->E2_PARCELA := QRYDADTMP->E2_PARCELA
			(cAliasTmp)->E2_VALOR := QRYDADTMP->E2_VALOR
			(cAliasTmp)->E2_EMISSAO := QRYDADTMP->E2_EMISSAO
			(cAliasTmp)->E2_FORNECE := QRYDADTMP->E2_FORNECE
			(cAliasTmp)->E2_NOMFOR := QRYDADTMP->E2_NOMFOR
			(cAliasTmp)->E2_LOJA := QRYDADTMP->E2_LOJA

		ElseIf xPar11 == "SE5"
			(cAliasTmp)->OK := Space(2)
			(cAliasTmp)->E5_FILIAL := QRYDADTMP->E5_FILIAL
			(cAliasTmp)->E5_PREFIXO := QRYDADTMP->E5_PREFIXO
			(cAliasTmp)->E5_NUMERO := QRYDADTMP->E5_NUMERO
			(cAliasTmp)->E5_TIPO := QRYDADTMP->E5_TIPO
			(cAliasTmp)->E5_PARCELA := QRYDADTMP->E5_PARCELA
			(cAliasTmp)->E5_VALOR := QRYDADTMP->E5_VALOR
			(cAliasTmp)->E5_DATA := QRYDADTMP->E5_DATA
			//(cAliasTmp)->E5_CLIENTE := QRYDADTMP->E5_CLIENTE
			//(cAliasTmp)->E5_FORNECE := QRYDADTMP->E5_FORNECE
			(cAliasTmp)->E5_LOJA := QRYDADTMP->E5_LOJA

		ElseIf xPar11 == "SEF"
			(cAliasTmp)->OK := Space(2)
			(cAliasTmp)->EF_FILIAL := QRYDADTMP->EF_FILIAL
			(cAliasTmp)->EF_PREFIXO := QRYDADTMP->EF_PREFIXO
			(cAliasTmp)->EF_TITULO := QRYDADTMP->EF_TITULO
			(cAliasTmp)->EF_TIPO := QRYDADTMP->EF_TIPO
			(cAliasTmp)->EF_PARCELA := QRYDADTMP->EF_PARCELA
			(cAliasTmp)->EF_VALOR := QRYDADTMP->EF_VALOR
			(cAliasTmp)->EF_DATA := QRYDADTMP->EF_DATA
			//(cAliasTmp)->EF_CLIENTE := QRYDADTMP->EF_CLIENTE
			//(cAliasTmp)->EF_FORNECE := QRYDADTMP->EF_FORNECE
			(cAliasTmp)->EF_LOJA := QRYDADTMP->EF_LOJA

		ElseIf xPar11 == "SF1"
			(cAliasTmp)->OK := Space(2)
			(cAliasTmp)->F1_FILIAL := QRYDADTMP->F1_FILIAL
			(cAliasTmp)->F1_DOC := QRYDADTMP->F1_DOC
			(cAliasTmp)->F1_SERIE := QRYDADTMP->F1_SERIE
			(cAliasTmp)->F1_DUPL := QRYDADTMP->F1_DUPL
			(cAliasTmp)->F1_COND := QRYDADTMP->F1_COND
			(cAliasTmp)->F1_VALBRUT := QRYDADTMP->F1_VALBRUT
			(cAliasTmp)->F1_EMISSAO := QRYDADTMP->F1_EMISSAO
			(cAliasTmp)->F1_FORNECE := QRYDADTMP->F1_FORNECE
			//(cAliasTmp)->F1_NOME := QRYDADTMP->F1_NOME
			(cAliasTmp)->F1_LOJA := QRYDADTMP->F1_LOJA

		ElseIf xPar11 == "SF2"
			(cAliasTmp)->OK := Space(2)
			(cAliasTmp)->F2_FILIAL := QRYDADTMP->F2_FILIAL
			(cAliasTmp)->F2_DOC := QRYDADTMP->F2_DOC
			(cAliasTmp)->F2_SERIE := QRYDADTMP->F2_SERIE
			(cAliasTmp)->F2_DUPL := QRYDADTMP->F2_DUPL
			(cAliasTmp)->F2_COND := QRYDADTMP->F2_COND
			(cAliasTmp)->F2_VALBRUT := QRYDADTMP->F2_VALBRUT
			(cAliasTmp)->F2_EMISSAO := QRYDADTMP->F2_EMISSAO
			(cAliasTmp)->F2_CLIENTE := QRYDADTMP->F2_CLIENTE
			//(cAliasTmp)->F2_XNOMCLI := QRYDADTMP->F2_XNOMCLI
			(cAliasTmp)->F2_LOJA := QRYDADTMP->F2_LOJA
		EndIf

		(cAliasTmp)->(MsUnlock())

		QRYDADTMP->(DbSkip())
	EndDo

	QRYDADTMP->(DbCloseArea())
	(cAliasTmp)->(DbGoTop())

Return

/*/{Protheus.doc} fCriaCols
Função que gera as colunas usadas no browse (similar ao antigo aHeader)
@author Maria Luiza
@since 08/11/2024
@version 1.0
@type function
/*/

Static Function fCriaCols()
	Local nAtual       := 0
	Local aColunas := {}
	Local aEstrut  := {}
	Local oColumn

	//Adicionando campos que serão mostrados na tela
	//[1] - Campo da Temporaria
	//[2] - Titulo
	//[3] - Tipo
	//[4] - Tamanho
	//[5] - Decimais
	//[6] - Máscara

	If cComboBo1 = "SE5" .OR. cComboBo1 = "SEF"
		aAdd(aEstrut, { xPar1, 'Filial', 'C', 4, 0, ''})
		aAdd(aEstrut, { xPar2, 'Prefixo', 'C', 3, 0, ''})
		aAdd(aEstrut, { xPar3, 'Nº Título', 'C', 9, 0, ''})
		aAdd(aEstrut, { xPar4, 'Tipo', 'C', 3, 0, ''})
		aAdd(aEstrut, { xPar5, 'Parcela ', 'C', 2, 0, ''})
		aAdd(aEstrut, { xPar6, 'Valor Título', 'N', 12, 2, ''})
		aAdd(aEstrut, { xPar7, 'Emissão ', 'D', 8, 0, ''})
		//aAdd(aEstrut, { xPar8, 'Cliente/Fornecedor', 'C', 9, 0, ''})
		//aAdd(aEstrut, { xPar9, 'Nome', 'C', 20, 0, ''})
		aAdd(aEstrut, { xPar10, 'Loja', 'C', 4, 0, ''})

	ElseIf  cComboBo1 = "SE1" .OR.  cComboBo1 = "SF1"
		aAdd(aEstrut, { xPar1, 'Filial', 'C', 4, 0, ''})
		aAdd(aEstrut, { xPar2, 'Prefixo', 'C', 3, 0, ''})
		aAdd(aEstrut, { xPar3, 'Nº Título', 'C', 9, 0, ''})
		aAdd(aEstrut, { xPar4, 'Tipo', 'C', 3, 0, ''})
		aAdd(aEstrut, { xPar5, 'Parcela ', 'C', 2, 0, ''})
		aAdd(aEstrut, { xPar6, 'Valor Título', 'N', 12, 2, ''})
		aAdd(aEstrut, { xPar7, 'Emissão ', 'D', 8, 0, ''})
		aAdd(aEstrut, { xPar8, 'Cliente', 'C', 9, 0, ''})
		aAdd(aEstrut, { xPar9, 'Nome', 'C', 20, 0, ''})
		aAdd(aEstrut, { xPar10, 'Loja', 'C', 4, 0, ''})

	Elseif cComboBo1 = "SE2" .OR. cComboBo1 = "SF2"
		aAdd(aEstrut, { xPar1, 'Filial', 'C', 4, 0, ''})
		aAdd(aEstrut, { xPar2, 'Nº Documento', 'C', 9, 0, ''})
		aAdd(aEstrut, { xPar3, 'Série', 'C', 3, 0, ''})
		aAdd(aEstrut, { xPar4, 'Nº Título', 'C', 9, 0, ''})
		aAdd(aEstrut, { xPar5, 'Cond. Pagamento ', 'C', 3, 0, ''})
		aAdd(aEstrut, { xPar6, 'Valor', 'N', 12, 2, ''})
		aAdd(aEstrut, { xPar7, 'Emissão', 'D', 8, 0, ''})
		aAdd(aEstrut, { xPar8, 'Fornecedor', 'C', 9, 0, ''})
		aAdd(aEstrut, { xPar9, 'Nome', 'C', 20, 0, ''})
		aAdd(aEstrut, { xPar10, 'Loja', 'C', 4, 0, ''})
	EndIf

	//Percorrendo todos os campos da estrutura
	For nAtual := 1 To Len(aEstrut)
		//Cria a coluna
		oColumn := FWBrwColumn():New()
		oColumn:SetData(&('{|| ' + cAliasTmp + '->' + aEstrut[nAtual][1] +'}'))
		oColumn:SetTitle(aEstrut[nAtual][2])
		oColumn:SetType(aEstrut[nAtual][3])
		oColumn:SetSize(aEstrut[nAtual][4])
		oColumn:SetDecimal(aEstrut[nAtual][5])
		oColumn:SetPicture(aEstrut[nAtual][6])

		//Muda o alinhamento conforme o tipo, Data será Centralizado
		If aEstrut[nAtual][3] == 'D'
			oColumn:nAlign := 0

			//Numérico, direita
		ElseIf aEstrut[nAtual][3] == 'N'
			oColumn:nAlign := 2

			//Senão, esquerda (caractere)
		Else
			oColumn:nAlign := 1
		EndIf

		//Adiciona a coluna
		aAdd(aColunas, oColumn)
	Next
Return aColunas

/*/{Protheus.doc} User Function FILTRO
Função acionada pelo botão continuar da rotina
@author Maria Luiza
@since 08/11/2024
@version 1.0
@type function
/*/

User Function FILTROFLAG()

	Processa({|| fProcessa()}, 'Processando...')
Return

/*/{Protheus.doc} fProcessa
Função que percorre os registros da tela
@author Maria Luiza
@since 08/11/2024
@version 1.0
@type function
/*/

Static Function fProcessa()
	Local aArea     := FWGetArea()
	Local cMarca    := oMarkBrowse:Mark()
	Local nAtual    := 0
	Local nTotal    := 0
	Local nTotMarc := 0
	Local cQry := ""
	Local nX := 1
	Local aPar := {}
	Local cPar1
	Local cPar2
	Local cPar3
	Local cPar4
	Local cPar5
	Local cPar6
	Local cPar7
	Local cPar8
	//Monta a consulta
	cQry := "SELECT " + xPar2 + " XPAR2, " + xPar3 + "XPAR3," + xPar4 + "XPAR4," + xPar5 + "XPAR5," + xPar8 + " XPAR8," + xPar10 + " XPAR10," +xPar12+ " XPAR12  , R_E_C_N_O_ xPar13  FROM " + retsqlname( xPar11 )"
	cQry += " WHERE D_E_L_E_T_ = '' "
	cQry += "AND " +xPar1+ " = '"+xFilial(xPar11)+"' "
	If !Empty(cGet1) .AND. !Empty(cGet2)
		cQry += "AND " +xPar7+"BETWEEN '"+Dtos(cGet1)+"' AND '"+Dtos(cGet2)+"' "
	EndIf
	If !Empty(PadR(AllTrim(nGet3),TamSx3(xPar6)[1])) .AND. !Empty(PadR(AllTrim(nGet4),TamSx3(xPar6)[1])) .AND. xPar11 = 'SE1' .OR. xPar11 = 'SE2' .OR. xPar11 = 'SE5' .OR. xPar11 = 'SEF'
		cQry += " AND " +xPar6+" BETWEEN '"+PadR(AllTrim(nGet3),TamSx3(xPar6)[1])+"' AND '"+PadR(AllTrim(nGet4),TamSx3(xPar6)[1])+"' "
	/*If !Empty(PadR(AllTrim(nGet3),TamSx3(xPar6)[1])) .AND. !Empty(PadR(AllTrim(nGet4),TamSx3(xPar6)[1])) .AND. xPar11 = 'SE1' .OR. xPar11 = 'SE2' .OR. xPar11 = 'SE5' .OR. xPar11 = 'SEF'
		cQryDados += " AND " +xPar6+" BETWEEN '"+Alltrim(Transform( nGet3, "@E 9,999,999,999,999.99"))+"' AND '"+Alltrim(Transform( nGet4, "@E 9,999,999,999,999.99"))+"' "
	ElseIf !Empty(PadR(AllTrim(nGet3),TamSx3(xPar6)[1])) .AND. !Empty(PadR(AllTrim(nGet4),TamSx3(xPar6)[1])) .AND. xPar11 = 'SF1'
		cQryDados += " AND " +xPar6+" BETWEEN '"+Alltrim(Transform( nGet3, "@E 999,999,999.99"))+"' AND '"+Alltrim(Transform( nGet4, "@E 999,999,999.99"))+"' "
	ElseIf !Empty(PadR(AllTrim(nGet3),TamSx3(xPar6)[1])) .AND. !Empty(PadR(AllTrim(nGet4),TamSx3(xPar6)[1])) .AND. xPar = 'SF2'
		cQryDados += " AND " +xPar6+" BETWEEN '"+Alltrim(Transform( nGet3, "@E 999,999,999.9999"))+"' AND '"+Alltrim(Transform( nGet4, "@E 999,999,999.9999"))+"' "*/
	EndIf
	If !Empty(cGet5)
		cQry += "AND " +xPar2+" = '"+Alltrim(cGet5)+"' "
	EndIf
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP1",.T.,.T.)

	//Coleta informações dos registros encontrados na query
	DbSelectArea("TMP1")
	While TMP1->(!EOF())

		Aadd(aPar,{TMP1->XPAR2,TMP1->XPAR3,TMP1->XPAR4,TMP1->XPAR5,TMP1->XPAR8,TMP1->XPAR10,TMP1->XPAR12,TMP1->XPAR13}) //Informações para encontrar registros na tabela e limpar campo de flag

		TMP1->(DbSkip())
	ENDDO

	//Define o tamanho da régua
	Count To nTotal
	ProcRegua(nTotal)

	For nX := 1 To nTotal //percorre os registros

		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		cPar2 := aPar[nX][1] //Prefixo / Doc
		cPar3 := aPar[nX][2] //Título / série
		cPar4 := aPar[nX][3] //Tipo /dupl
		cPar5 := aPar[nX][4] //Parcela
		cPar6 := aPar[nX][5] //Fornecedor/cliente
		cPar7 := aPar[nX][6] //loja
		cPar1 := aPar[nX][7]
		cPar8 := aPar[nX][8] //Valor

		//Caso esteja marcado
		If oMarkBrowse:IsMark(cMarca)
			nTotMarc++

			//Posiciona nas tabelas, encontra registro e realiza a limpeza do campo através do Reclock
			If xPar11 == "SE1" .OR. xPar11 == "SE2"
				If xPar11 == "SE1"
					DbSelectArea("SE1")
					SE1->(DbSetOrder(1))
					If cPar8 != 0
						SE1->(DbGoTo(cPar8))
						RecLock("SE1", .F.)
						SE1->E1_LA  := " "
						SE1->(MsUnlock())
					EndIf
				ElseIf xPar11 == "SE2"
					DbSelectArea("SE2")
					SE2->(DbSetOrder(1))
					If cPar8 != 0
						SE2->(DbGoTo(cPar8))
						RecLock("SE2", .F.)
						SE2->E2_LA  := " "
						SE2->(MsUnlock())
					EndIf
				EndIf
			ElseIf xPar11 == "SE5"
				DbSelectArea("SE5")
				SE5->(DbSetOrder(2))
				If cPar8 != 0
					SE5->(DbGoTo(cPar8))
					RecLock("SE5", .F.)
					SE5->E5_LA := " "
					SE5->(MsUnlock())
				EndIf
			ElseIF xPar11 == "SF1" .OR. xPar11 == "SF2"
				If xPar11 == "SF1"
					DbSelectArea("SF1")
					SF1->(DbSetOrder(1))
					If cPar8 != 0
						SF1->(DbGoTo(cPar8))
						RecLock("SF1", .F.)
						SF1->F1_DTLANC := CTOD("/ /")
						SF1->(MsUnlock())
					EndIf
				ElseIF xPar11 == "SF2"
					DbSelectArea("SF2")
					SF2->(DbSetOrder(1))
					If cPar8 != 0
						SF2->(DbGoTo(cPar8))
						RecLock("SF2", .F.)
						SF2->F2_DTLANC := CTOD("/ /")
						SF2->(MsUnlock())
					EndIf
				EndIf
			ElseIf xPar11 == "SEF"
				DbSelectArea("SEF")
				SEF->(DbSetOrder(3))
				If cPar8 != 0
					SEF->(DbGoTo(cPar8))
					RecLock("SEF", .F.)
					SEF->EF_LA := " "
					SEF->(MsUnlock())
				EndIf
			EndIf
		EndIf
	Next

	SE1->(DbCloseArea())
	SE2->(DbCloseArea())
	SE5->(DbCloseArea())
	SF1->(DbCloseArea())
	SF2->(DbCloseArea())
	SEF->(DbCloseArea())
	TMP1->(DbCloseArea())

//Mostra a mensagem de término e caso queria fechar a dialog, basta usar o método End()
	FWAlertInfo('Dos [' + cValToChar(nTotal) + '] registros, foram processados [' + cValToChar(nTotMarc) + '] registros', 'Atenção')
	oDlgMark:End()

	FWRestArea(aArea)
Return
