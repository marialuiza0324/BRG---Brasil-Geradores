#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT120LOK  
Responsável pela validação de cada 
linha do GetDados do Pedido de 
Compras / Autorização de Entrega.
@type  Function
@author Maria Luiza
@since 04/09/2024 */

User Function MT120LOK() 

 Local lRetorno := .T. // Retorno padrão .T. para seguir o fluxo normal
 Local cRateio := "" // Variável que vai armazenar o rateio
 Local cCentroCusto := "" // Variável para o centro de custo

    // Obtendo o centro de custo e o rateio
    cCentroCusto := ACOLS[1][23] 
    cRateio := ACOLS[1][62] 

        // Verificando se o centro de custo está vazio e se o rateio está informado
        If Empty(cCentroCusto) .and. cRateio == "1"
            // Se o centro de custo está vazio e há rateio, permite a confirmação
            lRetorno := .T. // Permite continuar sem erro
        ElseIf Empty(cCentroCusto) .and. cRateio == "2"
            // Se ambos estão vazios, bloqueia a gravação e exibe uma mensagem
            FWAlertInfo("Informe um centro de custo ou rateio", "Atenção!!!")
            lRetorno := .F. // Bloqueia a confirmação
        EndIf

Return lRetorno
