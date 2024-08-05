//Bibliotecas
#Include "TOTVS.ch"

/*
    ### ATUALIZAÇÕES MARLON ###

    29/05/2023
        Criação do fonte que grava as movimentações bancárias dos cartões

    05/07/2023
        Atualização do fonte para inclusão do centro de custo que se tornou obrigatorio com a atualização e implantação do contábil

*/

/*/{Protheus.doc} User Function zVid0040
Função que realiza a leitura de um XLS convertendo ele para CSV para importar os dados (como se fosse um CSV)
@type  Function
@author Atilio
@since 01/09/2022
@obs Pessoal, essa função é um paliativo de exemplo, para ler um XLS transformando ele em CSV
    Caso você queira se aprofundar, ou ver uma classe que vai além, com opção de leitura e
    escrita, eu recomendo que você conheça a YExcel, que é um projeto excelente do Saulo Martins
 
    + Link para download: https://github.com/saulogm/advpl-excel/blob/master/src/YEXCEL.prw
    + Link de exemplo:    https://github.com/saulogm/advpl-excel/blob/master/exemplo/tstyexcel.prw
    + Documentação:       https://github.com/saulogm/advpl-excel
/*/
// Definições de Tipos de mensagem
#Define MT_TDEFAULT 0 // Adiciona somente o botão default "Fechar"
#Define MT_TYESNO   1 // Adiciona os botões "Sim" e "Não", focando no "Sim"
#Define MT_TNOYES   2 // Adiciona os botões "Não" e "Sim", focando no "Não"

// Definições de Ícones da mensagem
#Define MT_ISUCCES  "FWSKIN_SUCCES_ICO.PNG" // Ícone Default Sucesso
#Define MT_IALERT   "FWSKIN_ALERT_ICO.PNG"  // Ícone Default Alerta
#Define MT_IERROR   "FWSKIN_ERROR_ICO.PNG"  // Ícone Default Erro
#Define MT_IINFO    "FWSKIN_INFO_ICO.PNG"   // Ícone Default Informação

 
User Function FSFIN001()
    Local aArea     := FWGetArea()
    Local cTemp     := GetTempPath()
    Local cDirIni   := substr(cTemp,1,AT("\AppData",cTemp)) //GetTempPath()
    Local cDesktop  := cDirIni + "desktop\"
    Local cTipArq   := 'Arquivos Excel (*.xlsx) | Arquivos Excel 97-2003 (*.xls)'
    Local cTitulo   := 'Seleção de Arquivos para Processamento'
    Local lSalvar   := .F.
    Local lArqOK    := .F.
    Local cArqSel   := ''
    Local cNatureza  := ''
    Local cMovimento := 'N'

    Private cArqCSV := ""
  
    //Se não estiver sendo executado via job
    If ! IsBlind()
  
        //Chama a função para buscar arquivos
        cArqSel := tFileDialog(;
            cTipArq,;  // Filtragem de tipos de arquivos que serão selecionados
            cTitulo,;  // Título da Janela para seleção dos arquivos
            ,;         // Compatibilidade
            cDesktop,;  // Diretório inicial da busca de arquivos
            lSalvar,;  // Se for .T., será uma Save Dialog, senão será Open Dialog
            ;          // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possível pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possível selecionar o diretório
        )
 
        //Se tiver o arquivo selecionado e ele existir
        If ! Empty(cArqSel) .And. File(cArqSel)
            //Faz a conversão de XLS para CSV
            cArqCSV := fXLStoCSV(cArqSel)
            cNatureza := FwInputBox("Para qual natureza deseja fazer a importação?", cNatureza)
            
            IF MSGYESNO("Essa planilha é para importar os acertos?", "Acertos" )                
                cMovimento := 'S'
            ENDIF

            IF cNatureza <> ''
                MsgTimer(5, "Aguarde a Criação do arquivo CSV", "Validador", MT_ISUCCES, MT_TDEFAULT)
                                
                //Se o arquivo XLS existir
                If File(cArqCSV) 
                    Processa({|| fImporta(cArqCSV,cNatureza,cMovimento) }, 'Importando...')
                EndIf
            ENDIF
        EndIf
    EndIf
     
    FWRestArea(aArea)
Return
     
/*/{Protheus.doc} fImporta
Função que processa o arquivo e realiza a importação para o sistema
@author Daniel Atilio
@since 16/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/
 
Static Function fImporta(cArqSel,cNatu,nMov)
    Local cDirTmp    := GetTempPath()
    Local cArqLog    := 'importacao_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
    Local nTotLinhas := 0
    Local cLinAtu    := ''
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local cPastaErro := '\x_logs\'
    Local cNomeErro  := ''
    Local cTextoErro := ''
    Local aLogErro   := {}
    Local nLinhaErro := 0
    Local cLog       := ''
    Local nRecPag    := ''
    Local cDocment   := ''
    //Variáveis do ExecAuto
    Private aDados         := {}
    Private lMSHelpAuto    := .T.
    Private lAutoErrNoFile := .T.
    Private lMsErroAuto    := .F.
    //Variáveis da Importação
    Private cAliasImp  := 'SE5'
    Private cSeparador := ','
 
    //Abre as tabelas que serão usadas
    DbSelectArea(cAliasImp)
    (cAliasImp)->(DbSetOrder(1))
    (cAliasImp)->(DbGoTop())
 
    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cArqSel)
 
    //Se o arquivo pode ser aberto
    If (oArquivo:Open())
 
        //Se não for fim do arquivo
        If ! (oArquivo:EoF())
 
            //Definindo o tamanho da régua
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
 
            //Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
            oArquivo:Close()
            oArquivo := FWFileReader():New(cArqSel)
            oArquivo:Open()

            cDocment := "IMPORTADOR-"+DTOS(Date())+CVALTOCHAR(Time())
            //Iniciando controle de transação
            Begin Transaction
 
                //Enquanto tiver linhas
                While (oArquivo:HasLine())
 
                    //Incrementa na tela a mensagem
                    nLinhaAtu++
                    IncProc('Analisando linha ' + cValToChar(nLinhaAtu) + ' de ' + cValToChar(nTotLinhas) + '...')
                    
                    //Pegando a linha atual e transformando em array
                    cLinAtu := oArquivo:GetLine()
                    aLinha  := Separa(cLinAtu, cSeparador)
 
                    //Se houver posições no array
                    If Len(aLinha) > 0
                        aDados := {}
                        IF nMov <> 'S'
                            IF CVALTOCHAR(aLinha[9]) == 'P'
                                nRecPag := 3
                                aAdd(aDados, {'E5_CCD',     '0102'                              ,Nil})
                                aAdd(aDados, {'E5_BENEF', cDocment                              ,Nil})
                                aAdd(aDados, {'E5_DOCUMEN', CVALTOCHAR(aLinha[8])               ,Nil})
                            ELSE
                                nRecPag := 4
                                aAdd(aDados, {'E5_CCC',     '0102'                              ,Nil})
                                aAdd(aDados, {'E5_BENEF', cDocment                              ,Nil})
                                aAdd(aDados, {'E5_DOCUMEN', CVALTOCHAR(aLinha[8])               ,Nil})
                            ENDIF
                        ELSE
                            nRecPag := 3
                            aAdd(aDados, {'E5_CCD',     '0102'                              ,Nil})
                            aAdd(aDados, {'E5_BENEF', "IMP-CARTÃO N. "+CVALTOCHAR(aLinha[6])    ,Nil})
                            aAdd(aDados, {'E5_DOCUMEN', CVALTOCHAR(aLinha[8])               ,Nil})
                        ENDIF

                        aAdd(aDados, {'E5_DATA',    STOD(aLinha[1]),                       Nil})
                        aAdd(aDados, {'E5_MOEDA',   CVALTOCHAR(aLinha[2]),                 Nil})
                        aAdd(aDados, {'E5_VALOR',   VAL(aLinha[3]),                        Nil})
                        aAdd(aDados, {'E5_NATUREZ', cNatu,                                 Nil})
                        aAdd(aDados, {'E5_BANCO',   CVALTOCHAR(aLinha[5]),                 Nil})
                        aAdd(aDados, {'E5_AGENCIA', CVALTOCHAR(aLinha[6]),                 Nil})
                        aAdd(aDados, {'E5_CONTA',   CVALTOCHAR(aLinha[7]),                 Nil})
                        aAdd(aDados, {'E5_HISTOR',  SUBSTR(CVALTOCHAR(aLinha[10]), 0, 39), Nil})
                        

                        lMsErroAuto := .F.
                        MSExecAuto({|x,y,z| FinA100(x,y,z)},0, aDados, nRecPag)
                        

                        //Se houve erro, gera o log
                        If lMsErroAuto                        
                            cPastaErro  := '\x_logs\'
                            cNomeErro  := 'erro_' + cAliasImp + '_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.txt'
 
                            //Se a pasta de erro não existir, cria ela
                            If ! ExistDir(cPastaErro)
                                MakeDir(cPastaErro)
                            EndIf
 
                            //Pegando log do ExecAuto, percorrendo e incrementando o texto
                            aLogErro := GetAutoGRLog()
                            For nLinhaErro := 1 To Len(aLogErro)
                                cTextoErro += aLogErro[nLinhaErro] + CRLF
                            Next
 
                            //Criando o arquivo txt e incrementa o log
                            MemoWrite(cPastaErro + cNomeErro, cTextoErro)
                            cLog += '- Falha ao incluir registro, linha [' + cValToChar(nLinhaAtu) + '], arquivo de log em ' + cPastaErro + cNomeErro + CRLF
                        Else
                            cLog += '+ Sucesso no Execauto na linha ' + cValToChar(nLinhaAtu) + ';' + CRLF
                        EndIf
                    
                    EndIf
 
                EndDo
            End Transaction
 
            //Se tiver log, mostra ele
            If ! Empty(cLog)
                MemoWrite(cDirTmp + cArqLog, cLog)
                ShellExecute('OPEN', cArqLog, '', cDirTmp, 1)
            EndIf
 
        Else
            MsgStop('Arquivo não tem conteúdo!', 'Atenção')
        EndIf
 
        //Fecha o arquivo
        oArquivo:Close()
        IF FERASE(cArqSel) <> -1
            FWAlertWarning("Arquivo CSV Deletado", "Aviso")
        ELSE
            FWAlertError("Algo deu errado na exclusão do arquivo. Se possível delete manualmente", "Erro")
        RETURN NIL

        ENDIF
    Else
        MsgStop('Arquivo não pode ser aberto!', 'Atenção')
    EndIf
 
Return
 
 //Essa função foi baseada como referência no seguinte link: https://stackoverflow.com/questions/1858195/convert-xls-to-csv-on-command-line
Static Function fXLStoCSV(cArqXLS)
    Local cArqCSV    := ""
    Local cDirTemp   := GetTempPath()
    Local cArqScript := cDirTemp + "XlsToCsv.vbs"
    Local cScript    := ""
    Local cDrive     := ""
    Local cDiretorio := ""
    Local cNome      := ""
    Local cExtensao  := ""
 
    //Monta o Script para converter
    cScript := 'if WScript.Arguments.Count < 2 Then' + CRLF
    cScript += '    WScript.Echo "Error! Please specify the source path and the destination. Usage: XlsToCsv SourcePath.xls Destination.csv"' + CRLF
    cScript += '    Wscript.Quit' + CRLF
    cScript += 'End If' + CRLF
    cScript += 'Dim oExcel' + CRLF
    cScript += 'Set oExcel = CreateObject("Excel.Application")' + CRLF
    cScript += 'Dim oBook' + CRLF
    cScript += 'Set oBook = oExcel.Workbooks.Open(Wscript.Arguments.Item(0))' + CRLF 
    cScript += 'oBook.SaveAs WScript.Arguments.Item(1), 6' + CRLF
    cScript += 'oBook.Close False' + CRLF
    cScript += 'oExcel.Quit' + CRLF
    MemoWrite(cArqScript, cScript)
 
    //Pega os detalhes do arquivo original em XLS
    SplitPath(cArqXLS, @cDrive, @cDiretorio, @cNome, @cExtensao)
 
    //Monta o nome do CSV, conforme os detalhes do XLS
    cArqCSV := cDrive + cDiretorio + cNome + ".csv"
 
    //Executa a conversão, exemplo: 
    //   c:\totvs\Testes\XlsToCsv.vbs "C:\Users\danat\Downloads\tste2.xls" "C:\Users\danat\Downloads\tst2_csv.csv"
    ShellExecute("OPEN", cArqScript, ' "' + cArqXLS + '" "' + cArqCSV + '"', cDirTemp, 0 )
 
Return cArqCSV

Static Function MsgTimer(nSeconds, cMensagem, cTitulo, cIcone, nTipo)

	Local xRet := Nil
	Local nCountEnter := 0

	Local cTipo := ""
	Local cDesIcone := ""
	Local cTimeIni := ""

	Local oTFont := TFont():New('Arial Black',,-16,,.T.)
	Local oTFont2 := TFont():New('Arial',,-12,,.F.)

	Private cTimeLeft := ""
	Private lClosedByTimer := .F. // Define que a mensagem foi fechada pelo Timer.

	Default nSeconds := 0
	Default nTipo := MT_TDEFAULT
	Default cIcone := MT_IINFO
	Default cTitulo := ""
	Default cMensagem := ""

	// Caso esteja executando sem interface, não constroi os diálogos.
	If IsBlind()

		// Trata a descrição dos tipos de mensagem (botões)
		Do Case
			Case nTipo == MT_TDEFAULT
				cTipo := "DEFAULT"
			Case nTipo == MT_TNOYES
				cTipo := "NOYES"
			Case nTipo == MT_TYESNO
				cTipo := "YESNO"
		EndCase

		// Trata a descrição dos ícones das mensagens
		Do Case
			Case cIcone == MT_ISUCCES
				cDesIcone := "Success"
			Case cIcone == MT_IALERT
				cDesIcone := "Alert"
			Case cIcone == MT_IERROR
				cDesIcone := "Error"
			Case cIcone == MT_IINFO
				cDesIcone := "Info"
		EndCase

		// Mostra a mensagem no console
		ConOut(DToC(Date()) + " - " + Time() + " - MsgTimer | " + cDesIcone + " | " + cTipo + " -> " + AllTrim(cMensagem))

		// Trata os retornos em caso de modo Blind, para não deixar a Thread travada esperando uma resposta
		Do Case
			// Botão default ("Fechar")
			Case nTipo == MT_TDEFAULT
				Return Nil

			// Botão "NÃO" e "SIM" (Focado no Não)
			Case nTipo == MT_TNOYES
				Return .F.

			// Botão "SIM" e "NÃO" (Focado no Sim)
			Case nTipo == MT_TYESNO
				Return .T.

			// Botão default ("Fechar")
			Otherwise
				Return Nil
		EndCase

	EndIf

	// Só calcula e apresenta o contador caso os segundos tenham sido informados
	If nSeconds > 0
		// Acrescenta os segundos informados no tempo atual para que o tempo seja contado de forma decrescente
		cTimeIni := IncTime(Time(), 0, 0, nSeconds)
		cTimeLeft := ElapTime(Time(), cTimeIni)
	EndIf

	// ---------------------------------------------------------------------------------------------------------
	// Calcula a altura estimada para as mensagens, relativo a quantidade de caracteres.
	// Obs.: Este cálculo não é preciso, portanto dependendo da quantidade de quebras ou se for usado
	//  HTML, algumas partes do texto podem ser cortadas.
	// ---------------------------------------------------------------------------------------------------------
	nTextWidth := Int(GetTextWidth(0, cTitulo))
	nHeightTit := ((IIF(nTextWidth <= 0, 200, nTextWidth) / 200) * 012) + 012
	nCountEnter:= Len(Strtokarr2(cTitulo, Chr(13), .F.)) -1
	nCountEnter+= Len(Strtokarr2(cTitulo, "<br>", .F.)) -1
	nHeightTit += (nCountEnter * 012)

	nTextWidth := Int(GetTextWidth(0, cMensagem))
	nHeightMsg := ((IIF(nTextWidth <= 0, 200, nTextWidth) / 200) * 006) + 006
	nCountEnter:= Len(Strtokarr2(cMensagem, Chr(13), .F.))
	nCountEnter+= Len(Strtokarr2(cMensagem, "<br>", .F.))
	nHeightMsg += (nCountEnter * 006)
	// ---------------------------------------------------------------------------------------------------------

	oModal  := FWDialogModal():New()
	oModal:SetEscClose(.F.)    // Não permite fechar com ESC
	oModal:SetCloseButton(.F.) // Não permite fechar a tela com o "X"
	oModal:SetBackground(.T.)  // Escurece o fundo da janela

	// Seta a largura e altura da janela em pixel
	If (nHeightTit + nHeightMsg) <= 57 // Caso a altura das mensagens não corresponda ao tamanho mínimo da janela, seta as dimensões default.
		oModal:setSize(97, 253)
	Else
		oModal:setSize(040 + nHeightTit + nHeightMsg, 253)
	EndIf

	oModal:createDialog()

	// ---------------------------------------------------------------------------------------------------------
	// Adiciona os botões da mensagem conforme parâmetro definido pelo usuário.
	// ---------------------------------------------------------------------------------------------------------
	Do Case
		// Botão default ("Fechar")
		Case nTipo == MT_TDEFAULT
			//oModal:addCloseButton(nil, "Fechar")

		// Botão "NÃO" e "SIM" (Focado no Não)
		Case nTipo == MT_TNOYES
			oModal:addNoYesButton()

		// Botão "SIM" e "NÃO" (Focado no Sim)
		Case nTipo == MT_TYESNO
			oModal:addYesNoButton()

		// Botão default ("Fechar")
		Otherwise
			oModal:addCloseButton(nil, "Fechar")
	EndCase
	// ---------------------------------------------------------------------------------------------------------

	// Apresenta o ícone da mensagem (resource compilado no RPO)
	If !Empty(cIcone)
		oIcone := TBitmap():New(10,10,025,025,,cIcone,.T.,oModal:getPanelMain(),{||Nil},,.F.,.F.,,,.F.,,.T.,,.F.)
		oIcone:lAutoSize := .T.
	EndIf

	oTitulo := TSay():New(10, 45, {|| cTitulo }, oModal:getPanelMain(),, oTFont,,,, .T., RGB(105,105,105),/*CLR_BLACK*/, 200, nHeightTit,,,,,, .T.)
	oTitulo:lWordWrap = .T.

	oMensagem := TSay():New(10 + nHeightTit, 45, {|| cMensagem }, oModal:getPanelMain(),, oTFont2,,,, .T., RGB(105,105,105),/*CLR_RED*/, 200, nHeightMsg,,,,,, .T.)
	oMensagem:lWordWrap = .T.

	// Só calcula e apresenta o contador caso os segundos tenham sido informados
	If nSeconds > 0
		// A cada segundo Calcula o tempo decorrido, Atualiza o Say de contador, Verifica se o tempo zerou, caso zere fecha a janela repassando o valor default.
		oModal:SetTimer(1, {|| cTimeLeft := ElapTime(Time(), cTimeIni), oTimeMsg:CtrlRefresh(), IIF(cTimeLeft == "00:00:00", (oModal:oOwner:End(), lClosedByTimer := .T.), Nil) })

		oTimeMsg := TSay():New(04, 10,{|| "Fecha em:" }, oModal:oFormBar:oOwner,, oTFont2,,,, .T., RGB(105,105,105),/*CLR_BLUE*/, 035, 006,,,,,, .T.)
		oTimeMsg:lTransparent = .T.

		oTimeMsg := TSay():New(10, 12, {|| cTimeLeft }, oModal:oFormBar:oOwner,, oTFont2,,,, .T., RGB(105,105,105),/*CLR_BLUE*/, 030, 006,,,,,, .T.)
		oTimeMsg:lTransparent = .T.
	EndIf

	oModal:Activate()

	// ---------------------------------------------------------------------------------------------------------
	// Trata o retorno dos botões
	//	- MT_TNOYES: Caso a mensagem seja fechada pelo Timer, retorna "NÃO" como Default.
	//	- MT_TYESNO: Caso a mensagem seja fechada pelo Timer, retorna "SIM" como Default.
	//	- MT_TYESNO ou MT_TNOYES: Caso a opção tenha sido escolhida pelo usuário retorna o que foi selecionado.
	// ---------------------------------------------------------------------------------------------------------
	If nTipo == MT_TNOYES .OR. nTipo == MT_TYESNO

		If lClosedByTimer

			Do Case
				Case nTipo == MT_TNOYES
					xRet := .F.

				Case nTipo == MT_TYESNO
					xRet := .T.
			EndCase

		Else
			// getButtonSelected() -> 1=Sim, 2=Não
			xRet := IIF(oModal:getButtonSelected() == 1, .T., .F.)
		EndIf

	EndIf

	FwFreeVar(oModal)

Return xRet
