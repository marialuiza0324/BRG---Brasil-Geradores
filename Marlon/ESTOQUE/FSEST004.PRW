#include 'TOPCONN.CH'
#Include "TOTVS.ch"

//Posições do Array
Static nPosProd     := 1  //Coluna A no Excel
Static nPosItem     := 2  //Coluna B no Excel
Static nPosLocaliz  := 3  //Coluna C no Excel
Static nPosQuant    := 4  //Coluna D no Excel
Static nPosQtdOri   := 5  //Coluna E no Excel
Static nPosSaldo    := 6  //Coluna F no Excel
Static nPosQtSegum  := 7  //Coluna G no Excel
Static nPosQtdOri2  := 8  //Coluna H no Excel
Static nPosFilial   := 9  //Coluna I no Excel
Static nPosArmazem  := 10 //Coluna J no Excel

/*/{Protheus.doc} FSEST004
    Função que realiza o endereçamento de saldos
    importando via planilha.
    @type  Function
    @author Maria Luiza
    @since 26/09/2025
    /*/

User Function FSEST004()

	Local aArea     := GetArea()
    Local cDirIni := GetTempPath()
    Local lSalvar := .F.
    Local cTipArq := "Todas extensões (*.*) | Arquivos texto (*.txt) | Arquivos com separações (*.csv)"
    Local cTitulo := "Seleção de Arquivos para Processamento"
	Private cArqOri := ""

	//Mostra o Prompt para selecionar arquivos
     cArqOri := tFileDialog(;
            cTipArq,;  // Filtragem de tipos de arquivos que serão selecionados
            cTitulo,;  // Título da Janela para seleção dos arquivos
            ,;         // Compatibilidade
            cDirIni,;  // Diretório inicial da busca de arquivos
            lSalvar,;  // Se for .T., será uma Save Dialog, senão será Open Dialog
            ;          // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possível pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possível selecionar o diretório
        )

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

/*/{Protheus.doc} fImporta() 
   Função utilizada para realizar o lançamento
   automático de condição de pagamento via planilha.
    @type  Function
    @author Maria Luiza
    @since 11/09/2025*/

Static Function fImporta()
    //DEFININDO variáveis
    Local aCabSDA      := {} //Array do cabeçalho (SE4)
    Local aItSDB       := {} //Array que irá conter os itens (SEC)
    Local _aItensSDB   := {} //Array que irá conter os itens (SEC)
    Local cProd        := " "
    Local cNumSeq      := " "
    Local cItem        := " "
    Local cEstorno     := " "
    Local cLocaliz     := ""
    Local nQuant       := 0
    Local nQtdOri      := 0 
    Local nSaldo       := 0 
    Local nQtSegum     := 0 
    Local nQtdOri2     := 0 
    Local cFilEnderec  := ""
    Local cArmazem     := ""
    Local nTotLinhas   := 0
    Local cLinAtu      := ""
    Local nLinhaAtu    := 0
    Local aLinha       := {}
    Local oArquivo
    Local aLinhas
    Private cDirLog    := GetTempPath() + "x_importacao\"
    Private cArqLog    := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Private cLog       := ""
    Private lMsErroAuto := .F. //Indicador do status pós chamada

    //Se a pasta de log não existir, cria ela
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf

    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cArqOri)

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
            oArquivo := FWFileReader():New(cArqOri)
            oArquivo:Open()

            While (oArquivo:HasLine())
                //Incrementa na tela a mensagem
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")

                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")

                //Se não for o cabeçalho (encontrar o texto "Código" na linha atual)
                If nLinhaAtu <> 1
                    // Zera todas as variáveis
                    cProd       := ""
                    cItem       := ""
                    cLocaliz    := ""
                    nQuant      := 0
                    nQtdOri     := 0
                    nSaldo      := 0
                    nQtSegum    := 0
                    nQtdOri2    := 0
                    cEstorno    := ""
                    cFilEnderec := ""
                    cArmazem    := ""
                    cNumSeq     := ""

                    // Preenche com AllTrim e PadR
                    cProd       := PadR(AllTrim(aLinha[nPosProd]), TamSX3("DA_PRODUTO")[1])
                    cItem       := PadL(AllTrim(aLinha[nPosItem]), TamSX3("DB_ITEM")[1], "0")
                    cLocaliz    := PadR(AllTrim(aLinha[nPosLocaliz]), TamSX3("DB_LOCALIZ")[1])
                    nQuant      := Val(AllTrim(aLinha[nPosQuant]))
                    nQtdOri     := Val(AllTrim(aLinha[nPosQtdOri]))
                    nSaldo      := Val(AllTrim(aLinha[nPosSaldo]))
                    nQtSegum    := Val(AllTrim(aLinha[nPosQtSegum]))
                    nQtdOri2    := Val(AllTrim(aLinha[nPosQtdOri2]))
                    cEstorno    := " "
                    cFilEnderec := PadR(AllTrim(aLinha[nPosFilial]), TamSX3("DA_FILIAL")[1])
                    cArmazem    := PadR(AllTrim(aLinha[nPosArmazem]), TamSX3("DA_LOCAL")[1])

                    cNumSeq := Posicione("SDA",1,cFilEnderec+ cProd+ cArmazem, 'DA_NUMSEQ')

                    aCabSDA := {} //Zera o array
                    // Cabecalho com a informação do item, NumSeq e os campos adicionais que serão endereçados.
                    aCabSDA := {{"DA_PRODUTO" ,cProd,Nil},;
                                {"DA_NUMSEQ"  ,cNumSeq,Nil},;
                                {"DA_QTDORI"  ,nQtdOri,Nil},;
                                {"DA_SALDO"   ,nSaldo,Nil},;
                                {"DA_QTSEGUM" ,nQtSegum,Nil},;
                                {"DA_QTDORI2" ,nQtdOri2,Nil}}

                    _aItensSDB := {} //Zera o array
                    aItSDB := {} //Zera o array
                    // Dados do item que será endereçado
                    aItSDB := {{"DB_ITEM"     ,cItem     ,Nil},;
                               {"DB_ESTORNO"  ,cEstorno      ,Nil},;
                               {"DB_LOCALIZ"  ,cLocaliz    ,Nil},;
                               {"DB_DATA"     ,dDataBase   ,Nil},;
                               {"DB_QUANT"    ,nQuant      ,Nil}}
                    aadd(_aItensSDB,aItSDB)
                 EndIf
                EndDo
                
                    // Executa o endereçamento do item
                    MSExecAuto({|x,y,z| mata265(x,y,z)},aCabSDA,_aItensSDB,3)
                    //Se houve erro, mostra a mensagem
                    If lMsErroAuto 
                        MostraErro()
                        cLog += "Linha " + cValToChar(nLinhaAtu) + " Produto "+Alltrim(cProd)+ "        NÃO PROCESSADO " + CRLF
                        DisarmTransaction()
                        lLogError := .T.
                    //Se deu tudo certo, efetiva a numeração
                    Else
                        cLog += "Linha " + cValToChar(nLinhaAtu) + " Produto "+Alltrim(cProd)+ "         PROCESSADO COM SUCESSO " + CRLF
                        ConfirmSX8()
                    EndIf
               
            // Gera o log ao final do processamento
            //Se tiver log, mostra ele
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            Else 
                FWAlertSuccess("Endereçamentos realizados com sucesso", "Sucesso!!!")
            EndIf
        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf
                //Fecha o arquivo
            oArquivo:Close()
    Else
        MsgStop("Arquivo não tem conteúdo!", "Atenção")
    EndIf

    
Return
