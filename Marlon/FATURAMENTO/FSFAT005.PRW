//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"

//Posições do Array do CSV
Static nPosCodig := 1
Static nPosPreco := 2
Static nPosTpOper := 3   // Renomeado para ficar mais claro

/*/{Protheus.doc} FSFAT005
Função para importar itens da tabela de preço (DA1)
@author Maria Luiza
@since 30/01/2026
@version 1.1
@type function
@obs Ajustado para respeitar regras de negócio de DA1_TPOPER, limite de 2 tipos por produto,
     performance (sem SELECT dentro de loop) e integridade de dados.
     Mantida a estrutura original do programa.
     Uso exclusivo de RecLock + Begin Transaction.
**/

User Function FSFAT005()

    Local aArea     := GetArea()
    Local aPergs    := {}
    Local cMsg      := ""
    Private cTabPrc := Space(TamSX3('DA0_CODTAB')[1])
    Private cArqOri := GetTempPath() + Space(100)

    //Mensagem de orientação ao usuário
    cMsg := "Essa importação de registros para a tabela de preço (DA1), faz as seguintes manipulações: " + CRLF
    cMsg += " - Se não existir o produto com o mesmo Tipo de Operação (DA1_TPOPER), será criado" + CRLF
    cMsg += " - Se já existir com o mesmo Tipo de Operação:" + CRLF
    cMsg += "    • Preço igual     ? Ignora (log)" + CRLF
    cMsg += "    • Preço diferente ? Atualiza (log)" + CRLF
    cMsg += " " + CRLF
    cMsg += "Regras importantes:" + CRLF
    cMsg += " - Cada produto pode ter no máximo 2 tipos de operação diferentes na DA1." + CRLF
    cMsg += " - Nunca sobrescreve registros de outros tipos de operação." + CRLF
    cMsg += " " + CRLF
    cMsg += "Formato CSV (separador ;):" + CRLF
    cMsg += "Código;Preço;TipoOperacao" + CRLF
    cMsg += "000001;10,50;1" + CRLF
    cMsg += "000101;20,80;2" + CRLF

    Aviso("Atenção - Importação Tabela de Preço", cMsg, {"OK"}, 3)

    //Parâmetros
    aAdd(aPergs, {1, "Tabela de Preço"     , cTabPrc, "", "ExistCpo('DA0', &(ReadVar()))", "DA0", ".T.", 50, .T.})
    aAdd(aPergs, {6, "Arquivo CSV"         , cArqOri, "", "", "", 80, .T., "Arquivos com separadores (*.csv) |*.csv"})

    If ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)
        cTabPrc := AllTrim(MV_PAR01)
        cArqOri := AllTrim(MV_PAR02)

        Processa({|| fImporta() }, "Importando dados para DA1...")
    EndIf

    RestArea(aArea)
Return

/*-------------------------------------------------------------------------------*
 | Func:  fImporta                                                               |
 | Desc:  Função que processa a importação respeitando todas as regras de negócio |
 *-------------------------------------------------------------------------------*/

Static Function fImporta()
    Local cDirLog    := GetTempPath()
    Local cArqLog    := "zImpDA1_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local cLog       := ""
    Local nTotLinhas := 0
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local cLinAtu    := ""
    Local cUltItem   := StrTran(Space(TamSX3('DA1_ITEM')[1]), ' ', '0')
    Local oArquivo

    Local cCodProd   := ""
    Local nPrcProd   := 0
    Local cTpOper    := ""

    // Variáveis de controle por linha
    Local lAchouMesmoTipo := .F.
    Local nQtdTipos       := 0
    Local lProdutoSB1     := .F.
    Local lAtualizou      := .F.

    // Abre áreas e índices (fora do loop)
    DbSelectArea('DA0')
    DA0->(DbSetOrder(1))
    DbSelectArea('DA1')
    DA1->(DbSetOrder(1))          // DA1_FILIAL + DA1_CODTAB + DA1_CODPRO + DA1_INDLOT + DA1_ITEM
    DbSelectArea('SB1')
    SB1->(DbSetOrder(1))

    If !DA0->(DbSeek(FWxFilial('DA0') + cTabPrc))
        MsgStop("Tabela de Preço não encontrada!", "Atenção")
        Return
    EndIf

    If !File(cArqOri) .Or. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) != 'CSV'
        MsgStop("Arquivo inválido! Somente extensão CSV pode ser importada.", "Atenção")
        Return
    EndIf

    // Busca último item (uma única vez)
    cUltItem := Posicione("DA1", 3, FWxFilial('DA1') + cTabPrc + Repl('Z', TamSX3('DA1_ITEM')[1]), "DA1_ITEM")
    If Empty(cUltItem)
        cUltItem := StrTran(Space(TamSX3('DA1_ITEM')[1]), ' ', '0')
    EndIf

    oArquivo := FWFileReader():New(cArqOri)

    If oArquivo:Open()

        aLinhas := oArquivo:GetAllLines()   // Carrega tudo para definir régua
        nTotLinhas := Len(aLinhas)
        ProcRegua(nTotLinhas)

        oArquivo:Close()
        oArquivo := FWFileReader():New(cArqOri)
        oArquivo:Open()

        Begin Transaction

            While oArquivo:HasLine()

                nLinhaAtu++
                IncProc("Processando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")

                // Reset variáveis de controle
                lAchouMesmoTipo := .F.
                nQtdTipos       := 0
                lProdutoSB1     := .F.
                lAtualizou      := .F.

                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(AllTrim(cLinAtu), ";")

                // Ignora linha de cabeçalho (primeira linha)
                If nLinhaAtu == 1 .Or. Len(aLinha) < 2
                    Loop
                EndIf

                cCodProd := AllTrim(aLinha[nPosCodig])
                nPrcProd := Val(StrTran(StrTran(aLinha[nPosPreco], ".", ""), ",", "."))
                cTpOper  := If(Len(aLinha) >= nPosTpOper, AllTrim(aLinha[nPosTpOper]), "")

                // ================= VALIDAÇÕES =================
                If Empty(cCodProd)
                    cLog += "- Linha " + cValToChar(nLinhaAtu) + ": Código do produto obrigatório. Ignorado." + CRLF
                    Loop
                EndIf

                If nPrcProd <= 0
                    cLog += "- Linha " + cValToChar(nLinhaAtu) + ": Produto " + cCodProd + " - Preço deve ser maior que zero. Ignorado." + CRLF
                    Loop
                EndIf

                If Empty(cTpOper)
                    cLog += "- Linha " + cValToChar(nLinhaAtu) + ": Produto " + cCodProd + " - Tipo de Operação (DA1_TPOPER) obrigatório. Ignorado." + CRLF
                    Loop
                EndIf

                // Verifica se produto existe no SB1
                If SB1->(DbSeek(FWxFilial('SB1') + cCodProd))
                    lProdutoSB1 := .T.
                Else
                    cLog += "- Linha " + cValToChar(nLinhaAtu) + ": Produto " + cCodProd + " não encontrado no SB1." + CRLF
                    Loop
                EndIf

                               // ================= BUSCA EXISTENTE (DbSeek - sem query) =================
                // Usa índice 2: DA1_FILIAL + DA1_CODPRO + DA1_CODTAB + DA1_ITEM
                DbSelectArea("DA1")
                DA1->(DbSetOrder(1))
                 
                If DA1->(DbSeek(FWxFilial('DA1') + cTabPrc + cCodProd))

                    // Conta quantos tipos de operação diferentes já existem 
                    // e verifica se já tem o mesmo tipo
                    While DA1->(!Eof()) .And. DA1->DA1_FILIAL == FWxFilial('DA1') .And. ;
                          Alltrim(DA1->DA1_CODPRO) == cCodProd .And. DA1->DA1_CODTAB == cTabPrc

                        If AllTrim(DA1->DA1_TPOPER) == cTpOper
                            lAchouMesmoTipo := .T.

                            // Verifica se o preço é igual
                            If DA1->DA1_PRCVEN == nPrcProd
                                cLog += "- Linha " + cValToChar(nLinhaAtu) + ": Produto " + cCodProd + ;
                                        " | TpOper [" + cTpOper + "] | Preço igual. Ignorado." + CRLF
                            Else
                                // Atualiza o preço (mantém o mesmo registro)
                                RecLock("DA1", .F.)
                                    DA1->DA1_PRCVEN := nPrcProd
                                DA1->(MsUnlock())

                                cLog += "- Linha " + cValToChar(nLinhaAtu) + ": Produto " + cCodProd + ;
                                        " | TpOper [" + cTpOper + "] | Preço atualizado para " + ;
                                        Transform(nPrcProd, "@E 999,999,999.99") + CRLF
                            EndIf
                            Exit   // Sai do While assim que encontrar o tipo exato
                        EndIf

                        nQtdTipos++   // Conta tipos diferentes
                        DA1->(DbSkip())
                    EndDo

                    // Se não encontrou o mesmo tipo e já tem 2 tipos diferentes ? bloqueia inclusão
                    If !lAchouMesmoTipo .And. nQtdTipos >= 2
                        cLog += "- Linha " + cValToChar(nLinhaAtu) + ": Produto " + cCodProd + ;
                                " | Limite de 2 tipos de operação atingido. Inclusão não permitida." + CRLF
                    EndIf

                EndIf   // Fim da busca com índice 2

                // ================= INCLUSÃO (se necessário) =================
                If !lAchouMesmoTipo .And. nQtdTipos < 2 .And. lProdutoSB1

                    cUltItem := Soma1(cUltItem)

                    RecLock("DA1", .T.)
                        DA1->DA1_FILIAL := FWxFilial('DA1')
                        DA1->DA1_ITEM   := cUltItem
                        DA1->DA1_CODTAB := cTabPrc 
                        DA1->DA1_CODPRO := cCodProd
                        DA1->DA1_PRCVEN := nPrcProd
                        DA1->DA1_TPOPER := cTpOper
                        DA1->DA1_ATIVO  := '1'
                        DA1->DA1_QTDLOT := 999999.99
                        DA1->DA1_DATVIG := Date()
                        DA1->DA1_MOEDA  := 1
                    DA1->(MsUnlock())

                    cLog += "- Linha " + cValToChar(nLinhaAtu) + ": Produto " + cCodProd + ;
                            " | TpOper [" + cTpOper + "] | Novo registro criado (item " + cUltItem + ")" + CRLF
                EndIf

                DA1->(DbCloseArea())

            EndDo   // Fim While HasLine

        End Transaction

        oArquivo:Close()

        // Gera e abre LOG
        If !Empty(cLog)
            MemoWrite(cDirLog + cArqLog, cLog)
            ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
        Else
            MsgInfo("Importação finalizada sem registros para processar.", "Atenção")
        EndIf

    Else
        MsgStop("Não foi possível abrir o arquivo CSV!", "Atenção")
    EndIf

Return
