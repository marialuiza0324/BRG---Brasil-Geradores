#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT140LOK 
Este ponto de entrada tem o objetivo de 
validar as informações preenchidas no aCols 
de cada item do pré-documento de entrada.
@type  Function
@author Maria Luiza
@since 05/09/2024 */

User Function MT140LOK()

Local lRet := .T. 
Local cRateio := "" // Variável que vai armazenar o rateio
Local cCentroCusto := "" // Variável para o centro de custo

    // Obtendo o centro de custo e o rateio
    cCentroCusto := ACOLS[1][13] 
    cRateio := ACOLS[1][41] 

    // Verificando se o centro de custo está vazio e se o rateio está informado
    If Empty(cCentroCusto) .and. cRateio == "1"
        // Se o centro de custo está vazio e há rateio, permite a confirmação
        lRet := .T. // Permite continuar sem erro
    ElseIf Empty(cCentroCusto) .and. cRateio == "2"
        // Se ambos estão vazios, bloqueia a gravação e exibe uma mensagem
        FWAlertInfo("Informe um centro de custo ou rateio.", "Atenção!!!")
        lRet := .F. // Bloqueia a confirmação
    ElseIf !Empty(cCentroCusto) .and. cRateio == "1"
        FWAlertInfo("Os campos de Centro de Custo e rateio estão preenchidos, preencha somente um", "Atenção!!!")
        lRet := .F. // Bloqueia a confirmação
    EndIf

Return lRet
