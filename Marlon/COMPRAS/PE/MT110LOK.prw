#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT110LOK
O ponto se encontra no final da fun��o e deve ser utilizado 
para valida��es se for .F. o processo ser� interrompido 
e se .T. ser� validado.
Respons�vel pela valida��o de cada linha
do GetDados da Solicita��o de Compras .
@type  Function
@author Maria Luiza
@since 03/09/2024 */

User Function MT110LOK() 

Local lRet := .T. // Retorno padr�o .T. para seguir o fluxo normal
Local cRateio := "" // Vari�vel que vai armazenar o rateio
Local cCentroCusto := "" // Vari�vel para o centro de custo
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

   // Verificando se o centro de custo est� vazio e se o rateio est� informado
    If Empty(cCentroCusto) .and. cRateio == "1"
        // Se o centro de custo est� vazio e h� rateio, permite a confirma��o
        lRet := .T. // Permite continuar sem erro
    ElseIf Empty(cCentroCusto) .and. cRateio == "2"
        // Se ambos est�o vazios, bloqueia a grava��o e exibe uma mensagem
        FWAlertInfo("Informe um centro de custo ou rateio", "Aten��o!!!")
        lRet := .F. // Bloqueia a confirma��o
    ElseIf !Empty(cCentroCusto) .and. cRateio == "1"
        FWAlertInfo("O campo de Centro de Custo e rateio est�o preenchidos, preencha somente um", "Aten��o!!!")
        lRet := .F. // Bloqueia a confirma��o
    EndIf

Return lRet
