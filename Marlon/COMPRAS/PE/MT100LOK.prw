#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT100LOK 
 Fun��o de Valida��o ( linha OK da Getdados) para 
 Inclus�o/Altera��o do item .
 Fun��o de Valida��o da LinhaOk.
 Valida inclus�o de linha na NF.
@type  Function
@author Maria Luiza
@since 05/09/2024 */

User Function MT100LOK()

Local ExpL1 := .T.
Local cRateio := "" // Vari�vel que vai armazenar o rateio
Local cCentroCusto := "" // Vari�vel para o centro de custo

If !FWIsInCallStack("A103Devol") //s� entra na valida��o caso n�o esteja selecionada a op��o de retornar NF
    // Obtendo o centro de custo e o rateio
    cCentroCusto := ACOLS[1][16] 
    cRateio := ACOLS[1][57] 

    // Verificando se o centro de custo est� vazio e se o rateio est� informado
    If Empty(cCentroCusto) .and. cRateio == "1"
        // Se o centro de custo est� vazio e h� rateio, permite a confirma��o
        ExpL1 := .T. // Permite continuar sem erro
    ElseIf Empty(cCentroCusto) .and. cRateio == "2"
        // Se ambos est�o vazios, bloqueia a grava��o e exibe uma mensagem
        FWAlertInfo("Informe um centro de custo ou rateio", "Aten��o!!!")
        ExpL1 := .F. // Bloqueia a confirma��o
    EndIf
EndIf

Return ExpL1
