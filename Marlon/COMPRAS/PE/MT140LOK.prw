#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT140LOK 
Este ponto de entrada tem o objetivo de 
validar as informa��es preenchidas no aCols 
de cada item do pr�-documento de entrada.
@type  Function
@author Maria Luiza
@since 05/09/2024 */

User Function MT140LOK()

Local lRet := .T. 
Local cRateio := "" // Vari�vel que vai armazenar o rateio
Local cCentroCusto := "" // Vari�vel para o centro de custo

    // Obtendo o centro de custo e o rateio
    cCentroCusto := ACOLS[1][13] 
    cRateio := ACOLS[1][41] 

    // Verificando se o centro de custo est� vazio e se o rateio est� informado
    If Empty(cCentroCusto) .and. cRateio == "1"
        // Se o centro de custo est� vazio e h� rateio, permite a confirma��o
        lRet := .T. // Permite continuar sem erro
    ElseIf Empty(cCentroCusto) .and. cRateio == "2"
        // Se ambos est�o vazios, bloqueia a grava��o e exibe uma mensagem
        FWAlertInfo("Informe um centro de custo ou rateio.", "Aten��o!!!")
        lRet := .F. // Bloqueia a confirma��o
    ElseIf !Empty(cCentroCusto) .and. cRateio == "1"
        FWAlertInfo("Os campos de Centro de Custo e rateio est�o preenchidos, preencha somente um", "Aten��o!!!")
        lRet := .F. // Bloqueia a confirma��o
    EndIf

Return lRet
