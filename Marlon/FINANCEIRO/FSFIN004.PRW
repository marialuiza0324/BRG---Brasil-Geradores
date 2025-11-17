#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

//Posições do Array
Static nPosTipo     := 1  //Coluna A no Excel (E4_TIPO)
Static nPosCond     := 2  //Coluna B no Excel (E4_COND)
Static nPosDescri   := 3  //Coluna C no Excel (E4_DESCRI)
Static nPosItem     := 4  //Coluna D no Excel (EC_ITEM)
Static nPosTipoAux  := 5  //Coluna E no Excel (EC_TIPO)
Static nPosCondAux  := 6  //Coluna F no Excel (EC_COND)
Static nPosIpi      := 7  //Coluna G no Excel (EC_IPI)
Static nPosDDD      := 8  //Coluna H no Excel (EC_DDD)
Static nPosSolid    := 9  //Coluna I no Excel (EC_SOLID)
Static nPosRateio   := 10 //Coluna J no Excel (EC_RATEIO)

/*/{Protheus.doc} FSFIN004
Função para importar informações via csv
@author Maria Luiza
@since 11/09/2025
@version 1.0
@type function
/*/

User Function FSFIN004()
    Local aArea     := GetArea()
    Private cArqOri := ""

    //Mostra o Prompt para selecionar arquivos
    cArqOri := tFileDialog("CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )

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
    Local aCabecalho    := {}
    Local aItens        := {}
    Local cTipo         := ""
    Local cCond         := ""
    Local cDescri       := ""
    Local cItem         := ""
    Local cTipoAux      := ""
    Local cCondAux      := ""
    Local cIpi          := ""
    Local cDDD          := ""
    Local cSolid        := ""
    Local nRateio       := 0
    Local nTotLinhas    := 0
    Local cLinAtu       := ""
    Local nLinhaAtu     := 0
    Local aLinha        := {}
    Local oArquivo
    Local aLinhas
    Local cArqLog       := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local cChaveAnt     := ""  // Chave para agrupamento (Tipo + Cond + Descri)
    Local cChaveAtu     := ""
    Private cDirLog     := GetTempPath() + "x_importacao\"
    Private cLog        := ""
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

            //Enquanto tiver linhas
            While (oArquivo:HasLine())
                //Incrementa na tela a mensagem
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")

                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")

                //Se não for o cabeçalho (encontrar o texto "Código" na linha atual, mas como não tem "Código", assume primeira linha é header)
                If nLinhaAtu <> 1
                    //Zera as variaveis
                    cTipo       := PadR(AllTrim(aLinha[nPosTipo]), TamSX3("E4_TIPO")[1])
                    cCond       := PadR(AllTrim(aLinha[nPosCond]), TamSX3("E4_COND")[1])
                    cDescri     := PadR(AllTrim(aLinha[nPosDescri]), TamSX3("E4_DESCRI")[1])
                    cItem       := IIf(Len(aLinha) >= nPosItem .And. !Empty(aLinha[nPosItem]), PadR(AllTrim(aLinha[nPosItem]), TamSX3("EC_ITEM")[1]), "")
                    cTipoAux    := IIf(Len(aLinha) >= nPosTipoAux .And. !Empty(aLinha[nPosTipoAux]), PadR(AllTrim(aLinha[nPosTipoAux]), TamSX3("EC_TIPO")[1]), "")
                    cCondAux    := IIf(Len(aLinha) >= nPosCondAux .And. !Empty(aLinha[nPosCondAux]), PadR(AllTrim(aLinha[nPosCondAux]), TamSX3("EC_COND")[1]), "")
                    cIpi        := IIf(Len(aLinha) >= nPosIpi .And. !Empty(aLinha[nPosIpi]), PadR(AllTrim(aLinha[nPosIpi]), TamSX3("EC_IPI")[1]), "")
                    cDDD        := IIf(Len(aLinha) >= nPosDDD .And. !Empty(aLinha[nPosDDD]), PadR(AllTrim(aLinha[nPosDDD]), TamSX3("EC_DDD")[1]), "")
                    cSolid      := IIf(Len(aLinha) >= nPosSolid .And. !Empty(aLinha[nPosSolid]), PadR(AllTrim(aLinha[nPosSolid]), TamSX3("EC_SOLID")[1]), "")
                    nRateio     := IIf(Len(aLinha) >= nPosRateio .And. !Empty(aLinha[nPosRateio]), Val(aLinha[nPosRateio]), 0)

                    // Monta chave de agrupamento (campos do cabeçalho)
                    cChaveAtu := cTipo + cCond + cDescri

                    // Se mudou a chave ou é a primeira, processa o grupo anterior
                    If (!Empty(cChaveAnt) .And. cChaveAtu != cChaveAnt) .Or. (nLinhaAtu == nTotLinhas + 1) // +1 para processar último no final, mas ajusta abaixo
                        // Processa o grupo anterior
                        fProcessaGrupo(@aCabecalho, @aItens)
                        // Reseta arrays para novo grupo
                        aCabecalho := {}
                        aItens     := {}
                    EndIf

                    // Se é o cabeçalho (primeira linha do grupo ou sem item, mas adiciona só uma vez por grupo)
                    If Empty(cChaveAnt) .Or. cChaveAtu != cChaveAnt
                        // Gera código único para o grupo
                        cCod := GetSxeNum("SE4", "E4_CODIGO")
                        // Popula Cabeçalho (apenas uma vez por grupo)
                        aAdd(aCabecalho, {"E4_CODIGO", cCod, Nil})
                        aAdd(aCabecalho, {"E4_TIPO", cTipo, Nil})
                        aAdd(aCabecalho, {"E4_COND", cCond, Nil})
                        aAdd(aCabecalho, {"E4_DESCRI", cDescri, Nil})
                        // Se houver item na primeira linha, adiciona abaixo
                    EndIf

                    // Se tem item auxiliar (desmembramento), adiciona ao aItens
                    If !Empty(cItem)
                        aItemAux := {}
                        aAdd(aItemAux, {"EC_ITEM", cItem, Nil})
                        aAdd(aItemAux, {"EC_TIPO", cTipoAux, Nil})
                        aAdd(aItemAux, {"EC_COND", cCondAux, Nil})
                        aAdd(aItemAux, {"EC_IPI", cIpi, Nil})
                        aAdd(aItemAux, {"EC_DDD", cDDD, Nil})
                        aAdd(aItemAux, {"EC_SOLID", cSolid, Nil})
                        aAdd(aItemAux, {"EC_RATEIO", nRateio, Nil})
                        aAdd(aItens, aItemAux)
                    EndIf

                    // Atualiza chave anterior
                    cChaveAnt := cChaveAtu

                EndIf
            EndDo

            // Processa o último grupo após o loop
            If !Empty(aCabecalho)
                fProcessaGrupo(@aCabecalho, @aItens)
            EndIf

            //Se tiver log, mostra ele
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            Else 
                FWAlertSuccess("Transferência realizada com sucesso!!!", "Sucesso")
            EndIf
        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf

        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
Return

/*/{Protheus.doc} fProcessaGrupo
Função auxiliar para processar um grupo (uma condição de pagamento)
@type Static Function
/*/
Static Function fProcessaGrupo(aCab, aIts)
    Local lTemItens := Len(aIts) > 0

    // Se tem itens, força tipo 'B' e cond '0' se necessário (ajuste conforme regras do sistema)
    If lTemItens
        aCab[2][2] := "B"  // E4_TIPO = 'B'
        aCab[3][2] := "0"  // E4_COND = '0' para desmembramento
    EndIf

    Private lMsHelpAuto := .T.
    Private lMsErroAuto := .F.
    Private lAutoErrNoFile := .T.

    // Chamando rotina automática de inclusão
    If lTemItens
        MSExecAuto({|x,y,z| Mata360(x,y,z)}, aCab, aIts, 3)
    Else
        MSExecAuto({|x,y| Mata360(x,y)}, aCab, 3)
    EndIf

    // Verificando status da rotina executada
    If !lMsErroAuto
        ConOut("Incluido com sucesso: " + aCab[1][2])
        RollBackSXe()  // Confirma o número sequencial
    Else
        MostraErro()
        ConOut("Erro na inclusão: " + aCab[1][2])
        cLog += "Erro na linha do código " + aCab[1][2] + ": Verifique o erro mostrado." + CRLF
    EndIf
Return
