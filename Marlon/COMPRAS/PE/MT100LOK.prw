#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT100LOK 
 Função de Validação ( linha OK da Getdados) para 
 Inclusão/Alteração do item .
 Função de Validação da LinhaOk.
 Valida inclusão de linha na NF.
@type  Function
@author Maria Luiza
@since 05/09/2024 */

User Function MT100LOK()

Local ExpL1 := .T.
Local cRateio := "" // Variável que vai armazenar o rateio
Local cCentroCusto := "" // Variável para o centro de custo
local nPosCod        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"})
local nPosLoteCtl    := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_LOTECTL"})
local nCentroC       := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_CC"})
local nRateio        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_RATEIO"})
Local nLinha

If Funname() <> "LOCA001" .AND. Funname() <> "MATA461"

    If !FWIsInCallStack("A103Devol") //só entra na validação caso não esteja selecionada a opção de retornar NF

        DbSelectArea("SB1")
        DbSetOrder(1)   

        IF dbSeek(xFilial("SB1")+Acols[n, nPosCod])//busca produto na SB1
            If SB1->B1_RASTRO == "L" .AND. Empty(Acols[n, nPosLoteCtl])//se produto possuir ratreabilidade e lote estiver vazio
                ExpL1  := .F. //não permite inclusão do doc 
                FWAlertInfo("Item com Rastreabilidade, informe o Lote"," Atenção!!!")
                Return
            EndIf
        EndIf


        // Verifica se o lote já foi usado em outra linha
            For nLinha := 1 To Len(Acols)
                If nLinha != n // Ignora a linha atual
                    If Upper(AllTrim(Acols[nLinha, nPosLoteCtl])) == Upper(AllTrim(Acols[n, nPosLoteCtl])) .And. !Empty(Acols[n, nPosLoteCtl])
                        FWAlertInfo("O lote '" + Alltrim(Acols[n, nPosLoteCtl]) + "' já foi utilizado em outro item. Corrija para prosseguir.", "Lote Duplicado!")
                        ExpL1 := .F.
                        Return
                    EndIf
                EndIf
            Next

        // Obtendo o centro de custo e o rateio
        cCentroCusto := ACOLS[n][nCentroC] 
        cRateio := ACOLS[n][nRateio] 

        // Verificando se o centro de custo está vazio e se o rateio está informado
        If Empty(cCentroCusto) .and. cRateio == "1"
            // Se o centro de custo está vazio e há rateio, permite a confirmação
            ExpL1 := .T. // Permite continuar sem erro
        ElseIf Empty(cCentroCusto) .and. cRateio == "2"
            // Se ambos estão vazios, bloqueia a gravação e exibe uma mensagem
            FWAlertInfo("Informe um centro de custo ou rateio", "Atenção!!!")
            ExpL1 := .F. // Bloqueia a confirmação
        EndIf
    EndIf
EndIf

Return ExpL1
