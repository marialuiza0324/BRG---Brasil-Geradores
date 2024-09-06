#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT110TOK
O ponto se encontra no final da fun��o e deve ser utilizado 
para valida��es especificas do usuario onde ser� controlada 
pelo retorno do ponto de entrada o qual 
se for .F. o processo ser� interrompido e se .T. ser� validado.
@author Maria Luiza
@since 03/09/2024 */

User Function MT110TOK() 

 Local lRetorno := .T. // Retorno padr�o .T. para seguir o fluxo normal
 Local cRateio := "" // Vari�vel que vai armazenar o rateio
 Local cCentroCusto := "" // Vari�vel para o centro de custo

    // Obtendo o centro de custo e o rateio
    cCentroCusto := ACOLS[1][6] 
    cRateio := ACOLS[1][46] 

    // Verificando se o centro de custo est� vazio e se o rateio est� informado
    If Empty(cCentroCusto) .and. cRateio == "1"
        // Se o centro de custo est� vazio e h� rateio, permite a confirma��o
        lRetorno := .T. // Permite continuar sem erro
    ElseIf Empty(cCentroCusto) .and. cRateio == "2"
        // Se ambos est�o vazios, bloqueia a grava��o e exibe uma mensagem
        FWAlertInfo("Informe um centro de custo ou rateio", "Aten��o!!!")
        lRetorno := .F. // Bloqueia a confirma��o
    EndIf


Return lRetorno

