//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"

//Posições do Array
Static nPosCodig := 1
Static nPosPreco := 2
Static nPosEstado := 3

/*/{Protheus.doc} FSFAT005
Função para importar os itens da tabela de preço
@author Maria Luiza
@since 30/01/2026
@version 1.0
@type function
@obs O ideal é sempre fazer via MsExecAuto inclusões, porém como a tabela de preço, em alguns lugares pode passar de
    5.000 registros, foi feito utilizando RecLock para não perder a performance, o ideal é avaliar o cenário no cliente
/*/

User Function FSFAT005()
    Local aArea     := GetArea()
    Local aPergs    := {}
    Local cMsg      := ""
    Private cTabPrc := Space(TamSX3('DA0_CODTAB')[1])
    Private cArqOri := GetTempPath() + Space(100)

    //Mostra a mensagem de como deve ser realizada a importação
    cMsg := "Essa importação de registros para a tabela de preço (DA1), faz as seguintes manipulações: " + CRLF
    cMsg += " Se não existir o produto na tabela de preço, será criado " + CRLF
    cMsg += " Se já existir o produto, o preço de venda será alterado " + CRLF
    cMsg += " " + CRLF
    cMsg += "O Arquivo csv, deve ter apenas três colunas, a de código, a de preço e a de estado, sendo que a primeira linha, pode ser descritiva apenas, por exemplo: " + CRLF
    cMsg += " " + CRLF
    cMsg += "Código;Preço;Estado " + CRLF
    cMsg += "000001;10,50;SP " + CRLF
    cMsg += "000101;20,80;RJ " + CRLF
    cMsg += "000201;15,99;MG " + CRLF
    cMsg += "000301;23,35;RS " + CRLF
    Aviso("Atenção", cMsg, {"OK"}, 3)

    //Adiciona os parâmetros que serão exibidos na pergunta
    aAdd(aPergs, {1, "Tabela de Preço", cTabPrc, "", "ExistCpo('DA0', &(ReadVar()))", "DA0", ".T.", 50, .T.})
    aAdd(aPergs, {6, "Arquivo CSV", cArqOri, "", "", "", 80, .T., "Arquivos com separadores (*.csv) |*.csv"})

    //Se a pergunta for confirmada
    If ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)
        cTabPrc := MV_PAR01
        cArqOri := Alltrim(MV_PAR02)

        Processa({|| fImporta() }, "Importando...")
    EndIf

    RestArea(aArea)
Return

/*-------------------------------------------------------------------------------*
 | Func:  fImporta                                                               |
 | Desc:  Função que importa os dados                                            |
 *-------------------------------------------------------------------------------*/

Static Function fImporta()
    Local cDirLog    := GetTempPath()
    Local cArqLog    := "zImpDA1_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local cLog       := ""
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 1
    Local aLinha     := {}
    Local cUltItem   := StrTran(Space(TamSX3('DA1_ITEM')[01]), ' ', '0')
    Local cQryUlt    := ""
    Local oArquivo
    Local aLinhas
    Local cCodProd   := ""
    Local nPrcProd   := 0
    Local cEstado    := ""
    Local lAchouMesmoEstado := .F.
    Local lAchouGenerico    := .F.
    Local lAtualizou        := .F.
    Local cEstadoDA1        := ""

    //Abre as tabelas que serão usadas
    DbSelectArea('DA0')
    DA0->(DbSetOrder(1))
    DA0->(DbGoTop())
    DbSelectArea('DA1')
    DA1->(DbSetOrder(1))
    DA1->(DbGoTop())
    DbSelectArea('SB1')
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())

    //Se existir a tabela de preço
    If DA0->(DbSeek(FWxFilial('DA0') + cTabPrc))

        //Se o arquivo for CSV
        If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'

            //Busca o último item da tabela de preço
            cQryUlt := " SELECT " + CRLF
            cQryUlt += " 	ISNULL(MAX(DA1_ITEM), '" + cUltItem + "') AS ULTIMO " + CRLF
            cQryUlt += " FROM " + CRLF
            cQryUlt += " 	" + RetSQLName('DA1') + " DA1 " + CRLF
            cQryUlt += " WHERE  " + CRLF
            cQryUlt += " 	DA1_FILIAL = '" + FWxFilial('DA1') + "' " + CRLF
            cQryUlt += " 	AND DA1_CODTAB = '" + cTabPrc + "' " + CRLF
            TCQuery cQryUlt New Alias "QRY_AUX"
            cUltItem := QRY_AUX->ULTIMO
            QRY_AUX->(DbCloseArea())

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

                    //Método GoTop não funciona, deve fechar e abrir novamente o arquivo
                    oArquivo:Close()
                    oArquivo := FWFileReader():New(cArqOri)
                    oArquivo:Open()

                    //Iniciando controle de transação
                    Begin Transaction

                        //Enquanto tiver linhas
                        While (oArquivo:HasLine())

                            //Incrementa na tela a mensagem
                            nLinhaAtu++
                            IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")

                            // ================= LEITURA =================
                            cLinAtu := oArquivo:GetLine()
                            aLinha  := StrTokArr(cLinAtu, ";")

                            // ?? IGNORA CABEÇALHO (SEMPRE PRIMEIRA LINHA)
                            If nLinhaAtu == 2
                                Loop
                            EndIf

                            If Len(aLinha) < 2
                                cLog += "- Linha " + cValToChar(nLinhaAtu) + " ignorada (inválida)" + CRLF
                                Loop
                            EndIf

                            cCodProd := AllTrim(aLinha[nPosCodig])
                            nPrcProd := Val(StrTran(StrTran(aLinha[nPosPreco], ".", ""), ",", "."))

                            // ?? LIMPEZA FORTE DO ESTADO (CR/LF + espaços)
                            cEstado := ""
                            If Len(aLinha) >= 3
                                cEstado := AllTrim(StrTran(StrTran(aLinha[nPosEstado], Chr(13), ""), Chr(10), ""))
                            EndIf

                            // ================= BUSCA =================
                            cChaveSeek := FWxFilial('DA1') + cTabPrc + cCodProd

                            If DA1->(DbSeek(cChaveSeek))

                                While DA1->(!Eof()) .AND. ;
                                    Alltrim(DA1->DA1_FILIAL) == Alltrim(FWxFilial('DA1')) .AND. ;
                                    Alltrim(DA1->DA1_CODTAB) == Alltrim(cTabPrc) .AND. ;
                                    Alltrim(DA1->DA1_CODPRO) == Alltrim(cCodProd)

                                    cEstadoDA1 := AllTrim(DA1->DA1_ESTADO)

                                    // ?? GENÉRICO
                                    If Empty(cEstadoDA1)
                                        lAchouGenerico := .T.
                                    EndIf

                                    // ================= MESMO ESTADO =================
                                    If cEstadoDA1 == cEstado

                                        lAchouMesmoEstado := .T.

                                        // ?? MESMO PREÇO ? IGNORA
                                        If DA1->DA1_PRCVEN == nPrcProd
                                            cLog += "- Linha " + cValToChar(nLinhaAtu) + ;
                                                    ": Produto " + cCodProd + ;
                                                    " | Estado [" + cEstado + ;
                                                    "] já possui o mesmo preço. Ignorado." + CRLF

                                            lAtualizou := .T.
                                            Exit
                                        EndIf

                                        // ?? ATUALIZA PREÇO
                                        RecLock("DA1", .F.)
                                            DA1->DA1_PRCVEN := nPrcProd
                                        DA1->(MsUnlock())

                                        cLog += "- Linha " + cValToChar(nLinhaAtu) + ;
                                                ": Produto " + cCodProd + ;
                                                " | Estado [" + cEstado + ;
                                                "] | Preço atualizado para " + Transform(nPrcProd,"@E 999,999.99") + CRLF

                                        lAtualizou := .T.
                                        Exit
                                    EndIf

                                    DA1->(DbSkip()) 
                                EndDo

                            EndIf

                            // ================= DECISÃO =================

                            // ?? CSV SEM ESTADO (GENÉRICO)
                            If Empty(cEstado)

                                If lAchouMesmoEstado
                                    // já tratado
                                ElseIf lAchouGenerico
                                    // segurança (não deveria cair)
                                Else
                                    lAtualizou := .F.
                                EndIf

                            Else // ?? CSV COM ESTADO

                                If lAchouMesmoEstado
                                    // já tratado
                                Else
                                    lAtualizou := .F.
                                EndIf

                            EndIf

                            // ================= INCLUSÃO =================
                            If !lAtualizou

                                If !SB1->(DbSeek(FWxFilial('SB1') + cCodProd))

                                    cLog += "- Linha " + cValToChar(nLinhaAtu) + ;
                                            ": Produto " + cCodProd + " não encontrado no SB1" + CRLF

                                Else

                                    cUltItem := Soma1(cUltItem)

                                    RecLock("DA1", .T.)
                                        DA1_FILIAL := FWxFilial('DA1')
                                        DA1_ITEM   := cUltItem
                                        DA1_CODTAB := cTabPrc
                                        DA1_CODPRO := cCodProd
                                        DA1_PRCVEN := nPrcProd
                                        DA1_ESTADO := cEstado
                                        DA1_ATIVO  := '1'
                                        DA1_TPOPER := '4'
                                        DA1_QTDLOT := 999999.99
                                        DA1_DATVIG := STOD("20990101")
                                    DA1->(MsUnlock())

                                    cLog += "- Linha " + cValToChar(nLinhaAtu) + ;
                                            ": Produto " + cCodProd + ;
                                            " | Estado [" + cEstado + ;
                                            "] | Novo registro criado (item " + cUltItem + ")" + CRLF
                                EndIf

                            EndIf

                        EndDo

                    End Transaction

                    //Se tiver log, mostra ele
                    If ! Empty(cLog)
                        MemoWrite(cDirLog + cArqLog, cLog)
                        ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
                    EndIf

                Else
                    MsgStop("Arquivo não tem conteúdo!", "Atenção")
                EndIf

                //Fecha o arquivo
                oArquivo:Close()
            Else
                MsgStop("Arquivo não pode ser aberto!", "Atenção")
            EndIf

        Else
            MsgStop("Arquivo inválido! Somente extensão CSV pode ser importada", "Atenção")
        EndIf

    Else
        MsgStop("Tabela de Preço não encontrada!", "Atenção")
    EndIf
Return
