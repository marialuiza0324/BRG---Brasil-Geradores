#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT100TOK
 Esse Ponto de Entrada � chamado 2 vezes dentro da rotina A103Tudok().
 Para o controle do n�mero de vezes em que ele � chamado foi criada a 
 vari�vel l�gica lMT100TOK, que quando for definida como (.F.) 
 o ponto de entrada ser� chamado somente uma vez.
 Valida inclus�o de NF.
@type  Function
@author Maria Luiza
@since 05/09/2024 */

User Function MT100TOK()

    Local lRet := .T.
    Local lMT100TOK := .F. 

    Local cRateio := "" // Vari�vel que vai armazenar o rateio
    Local cCentroCusto := "" // Vari�vel para o centro de custo

    // Obtendo o centro de custo e o rateio
    cCentroCusto := ACOLS[1][16] 
    cRateio := ACOLS[1][57] 

    // Verificando se o centro de custo est� vazio e se o rateio est� informado
    If Empty(cCentroCusto) .and. cRateio == "1"
        // Se o centro de custo est� vazio e h� rateio, permite a confirma��o
        lRet := .T. // Permite continuar sem erro
    ElseIf Empty(cCentroCusto) .and. cRateio == "2"
        // Se ambos est�o vazios, bloqueia a grava��o e exibe uma mensagem
        FWAlertInfo("Informe um centro de custo ou rateio.", "Aten��o!!!")
        lRet := .F. // Bloqueia a confirma��o
    EndIf

Return lRet 
