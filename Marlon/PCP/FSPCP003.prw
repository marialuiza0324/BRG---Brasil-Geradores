//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} User Function FSPCP003
Função para importar estrutura de produto via csv
@author Maria Luiza
@since 19/01/2026
@version 1.0
@type function
/*/

User Function FSPCP003()

	Local aArea     := GetArea()
	Private cArqOri := ""

	//Mostra o Prompt para selecionar arquivos
	cArqOri := cGetFile('Arquivos CSV|*.csv','Seleção de Arquivos',0,'C:\',.T.,,.F.) //tFileDialog("CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )

	//Se tiver o arquivo de origem
	If ! Empty(cArqOri)
		//Somente se existir o arquivo e for com a extensão CSV
		If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
			Processa({|| fImporta() }, "Importando...")
		Else
			MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
		EndIf
	EndIf

	RestArea(aArea)
Return

/*/{Protheus.doc} fImporta
Função que processa o arquivo e realiza a importação para o sistema
@author Maria Luiza
@since 19/01/2026
@version 1.0
@type function
/*/

Static Function fImporta()

	Local cDirTmp    := GetTempPath()
	Local cArqLog    := 'importacao_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
	Local nTotLinhas := 0
	Local cLinAtu    := ''
	Local aLinha     := {}
	Local oArquivo
	Local cLog       := ''
	Local cPastaErro := '\x_logs\'
	Local cNomeErro  := ''
	Local cTextoErro := ''
	Local aLogErro   := {}
	Local nLinhaErro := 0
	Local nI, nJ
	//Variáveis do ExecAuto
	Private aCab         := {}
	Private aItem         := {}
	Private lMsErroAuto    := .F.
	Private cSeparador := ';'
	Private aDadosCSV   := {}          // Array com todas as linhas válidas: { {pai, comp, quant}, ... }
	Private aPais       := {}          // Array de pais únicos
	Private cPaiAtual
	Private aLinhaItem
	Private lPrimeiraLinha := .T.

	// 1. Ler TODO o arquivo e armazenar dados válidos
	oArquivo := FWFileReader():New(cArqOri)
	If !oArquivo:Open()
		FWAlertError('Não foi possível abrir o arquivo!', 'Erro')
		Return
	EndIf

	While oArquivo:HasLine()
		cLinAtu := oArquivo:GetLine()
		aLinha  := Separa(cLinAtu, cSeparador)

		If lPrimeiraLinha
			lPrimeiraLinha := .F.
			Loop  // Pula cabeçalho
		EndIf

		If Len(aLinha) >= 3 .And. !Empty(aLinha[1]) .And. !Empty(aLinha[2])
			aLinha[1] := AvKey(AllTrim(aLinha[1]), 'G1_COD')
			aLinha[2] := AvKey(AllTrim(aLinha[2]), 'G1_COMP')

			aLinha[3] := StrTran(aLinha[3], '.', '')
			aLinha[3] := StrTran(aLinha[3], ',', '.')
			aLinha[3] := Val(aLinha[3])

			aAdd(aDadosCSV, {aLinha[1], aLinha[2], aLinha[3]})
		EndIf
	EndDo
	oArquivo:Close()

	nTotLinhas := Len(aDadosCSV)
	If nTotLinhas == 0
		FWAlertError('Nenhuma linha válida encontrada no CSV!', 'Atenção')
		Return
	EndIf

	ProcRegua(nTotLinhas)  // A régua agora é por linhas processadas, mas gravamos por pai

	// 2. Agrupar por pai
	For nI := 1 To nTotLinhas
		cPaiAtual := aDadosCSV[nI][1]

		// Verifica se o pai já está na lista
		nPos := aScan(aPais, {|x| x[1] == cPaiAtual})
		If nPos == 0
			aAdd(aPais, {cPaiAtual, {}})  // {pai, array de componentes}
			nPos := Len(aPais)
		EndIf

		// Adiciona o componente ao pai
		aAdd(aPais[nPos][2], {aDadosCSV[nI][2], aDadosCSV[nI][3]})
	Next

	// 3. Processar cada pai (uma inclusão por pai)
	For nI := 1 To Len(aPais)
		cPaiAtual := aPais[nI][1]
		IncProc('Gravando estrutura do produto ' + cPaiAtual + ' (' + cValToChar(nI) + ' de ' + cValToChar(Len(aPais)) + ')')

		// Cabeçalho (igual para todos)
		aCab := {;
			{"G1_COD"    , cPaiAtual , Nil},;
			{"G1_QUANT"  , 1         , Nil},;
			{"ATUREVSB1" , "N"       , Nil},;
			{"NIVALT"    , "S"       , Nil};
			}

		// Itens: todos os componentes desse pai
		aItem := {}
		For nJ := 1 To Len(aPais[nI][2])
			aLinhaItem := {}
			aAdd(aLinhaItem, {"G1_COD"   , cPaiAtual                  , Nil})
			aAdd(aLinhaItem, {"G1_COMP"  , aPais[nI][2][nJ][1]        , Nil})  // componente
			aAdd(aLinhaItem, {"G1_TRT"   , Space(3)                   , Nil})  // ou deixe "" para auto-sequência
			aAdd(aLinhaItem, {"G1_QUANT" , aPais[nI][2][nJ][2]        , Nil})  // quantidade
			aAdd(aLinhaItem, {"G1_INI"   , dDataBase                  , Nil})
			aAdd(aLinhaItem, {"G1_FIM"   , CTOD("31/12/49")           , Nil})
			aAdd(aLinhaItem, {"G1_PERDA" , 0                          , Nil})

			aAdd(aItem, aLinhaItem)
		Next

		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| PCPA200(x,y,z)}, aCab, aItem, 3)

		If lMsErroAuto
			// Seu bloco de log de erro (copie o que já tem)
			aLogErro := GetAutoGRLog()
			cTextoErro := ""
			For nLinhaErro := 1 To Len(aLogErro)
				cTextoErro += aLogErro[nLinhaErro] + CRLF
			Next
			cNomeErro := 'erro_SG1_' + cPaiAtual + '_' + DTOS(Date()) + '_' + StrTran(Time(),':','-') + '.txt'
			If !ExistDir(cPastaErro); MakeDir(cPastaErro); EndIf
				MemoWrite(cPastaErro + cNomeErro, cTextoErro)
				cLog += '- ERRO ao importar estrutura do produto: ' + cPaiAtual + CRLF
			Else
				cLog += '- Sucesso na importação da estrutura do produto : ' + cPaiAtual + ' (' + cValToChar(Len(aItem)) + ' componentes)' + CRLF
			EndIf
		Next

//Se tiver log, mostra ele
If ! Empty(cLog)
	MemoWrite(cDirTmp + cArqLog, cLog)
	ShellExecute('OPEN', cArqLog, '', cDirTmp, 1)
EndIf

Return
