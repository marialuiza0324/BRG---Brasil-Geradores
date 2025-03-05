#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT110LOK
O ponto se encontra no final da função e deve ser utilizado 
para validações se for .F. o processo será interrompido 
e se .T. será validado.
Responsável pela validação de cada linha
do GetDados da Solicitação de Compras .
@type  Function
@author Maria Luiza
@since 03/09/2024 */

User Function MT110LOK() 

Local lRet := .T. // Retorno padrão .T. para seguir o fluxo normal
Local cRateio := "" // Variável que vai armazenar o rateio
Local cCentroCusto := "" // Variável para o centro de custo
Local nPosCC     := AScan(aHeader, {|x| Alltrim(x[2]) == "C1_CC"})
Local nPosRateio := AScan(aHeader, {|x| Alltrim(x[2]) == "C1_RATEIO"})

   If FunName() == "MATA161"
        cCentroCusto := Posicione("SC1",1,xFilial("SC1")+SC8->C8_NUM+SC8->C8_ITEM,"C1_CC")
        cRateio := Posicione("SC1",1,xFilial("SC1")+SC8->C8_NUM+SC8->C8_ITEM,"C1_RATEIO")
    Else
        // Obtendo o centro de custo e o rateio
        cCentroCusto := ACOLS[n,nPosCC] 
        cRateio := ACOLS[n, nPosRateio]
    Endif

   // Verificando se o centro de custo está vazio e se o rateio está informado
    If Empty(cCentroCusto) .and. cRateio == "1"
        // Se o centro de custo está vazio e há rateio, permite a confirmação
        lRet := .T. // Permite continuar sem erro
    ElseIf Empty(cCentroCusto) .and. cRateio == "2"
        // Se ambos estão vazios, bloqueia a gravação e exibe uma mensagem
        FWAlertInfo("Informe um centro de custo ou rateio", "Atenção!!!")
        lRet := .F. // Bloqueia a confirmação
    ElseIf !Empty(cCentroCusto) .and. cRateio == "1"
        FWAlertInfo("O campo de Centro de Custo e rateio estão preenchidos, preencha somente um", "Atenção!!!")
        lRet := .F. // Bloqueia a confirmação
    EndIf

Return lRet
