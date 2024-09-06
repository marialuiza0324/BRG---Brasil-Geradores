#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT120LOK  
Respons�vel pela valida��o de cada 
linha do GetDados do Pedido de 
Compras / Autoriza��o de Entrega.
@type  Function
@author Maria Luiza
@since 04/09/2024 */

User Function MT120LOK() 

 Local lRetorno := .T. // Retorno padr�o .T. para seguir o fluxo normal
 Local cRateio := "" // Vari�vel que vai armazenar o rateio
 Local cCentroCusto := "" // Vari�vel para o centro de custo

    // Obtendo o centro de custo e o rateio
    cCentroCusto := ACOLS[1][23] 
    cRateio := ACOLS[1][62] 

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
