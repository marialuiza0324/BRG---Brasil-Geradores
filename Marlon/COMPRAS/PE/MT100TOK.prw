#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT100TOK
 Esse Ponto de Entrada é chamado 2 vezes dentro da rotina A103Tudok().
 Para o controle do número de vezes em que ele é chamado foi criada a 
 variável lógica lMT100TOK, que quando for definida como (.F.) 
 o ponto de entrada será chamado somente uma vez.
 Valida inclusão de NF.
@type  Function
@author Maria Luiza
@since 05/09/2024 */

User Function MT100TOK()

    Local lRet := .T.
    Local lMT100TOK := .F. 

    Local cRateio := "" // Variável que vai armazenar o rateio
    Local cCentroCusto := "" // Variável para o centro de custo

    // Obtendo o centro de custo e o rateio
    cCentroCusto := ACOLS[1][16] 
    cRateio := ACOLS[1][57] 

    // Verificando se o centro de custo está vazio e se o rateio está informado
    If Empty(cCentroCusto) .and. cRateio == "1"
        // Se o centro de custo está vazio e há rateio, permite a confirmação
        lRet := .T. // Permite continuar sem erro
    ElseIf Empty(cCentroCusto) .and. cRateio == "2"
        // Se ambos estão vazios, bloqueia a gravação e exibe uma mensagem
        FWAlertInfo("Informe um centro de custo ou rateio.", "Atenção!!!")
        lRet := .F. // Bloqueia a confirmação
    EndIf

Return lRet 
