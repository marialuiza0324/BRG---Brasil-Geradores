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

If !FWIsInCallStack("A103Devol") //só entra na validação caso não esteja selecionada a opção de retornar NF
    // Obtendo o centro de custo e o rateio
    cCentroCusto := ACOLS[1][16] 
    cRateio := ACOLS[1][57] 

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

Return ExpL1
