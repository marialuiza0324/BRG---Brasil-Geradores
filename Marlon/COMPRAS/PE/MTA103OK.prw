#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MTA103OK  
Rotina de valida��o da LinhaOk. 
Esse ponto permite a altera��o do resultado da valida��o padr�o
para inclus�o/altera��o de registros de entrada
Utilizado para valida��es no Retorno da NF
@type  Function
@author Maria Luiza
@since 21/01/2025 */



User Function MTA103OK()

Local lRet := .T. 
Local cRateio := "" // Vari�vel que vai armazenar o rateio
Local cCentroCusto := "" // Vari�vel para o centro de custo
Local lRastro := .T.
local nPosCod        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"})
local nCentroC       := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_CC"})
local nRateio        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_RATEIO"})
local nPosLoteCtl    := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_LOTECTL"})
Local nLinha

    If !FWIsInCallStack("A103Devol") //s� entra na valida��o caso n�o esteja selecionada a op��o de retornar NF

            DbSelectArea("SB1")
            DbSetOrder(1)   

            IF dbSeek(xFilial("SB1")+Acols[n,nPosCod])//busca produto na SB1
                If SB1->B1_RASTRO == "L" .AND. Empty(Acols[n,nPosLoteCtl])//se produto possuir ratreabilidade e lote estiver vazio
                    FWAlertInfo("Item com Rastreabilidade, informe o Lote"," Aten��o!!!")
                    lRet  := .F. //n�o permite inclus�o do doc 
                    lRastro := .F.
                EndIf
            EndIf

                // Verifica se o lote j� foi usado em outra linha
                For nLinha := 1 To Len(Acols)
                    If nLinha != n // Ignora a linha atual
                        If Upper(AllTrim(Acols[nLinha, nPosLoteCtl])) == Upper(AllTrim(Acols[n, nPosLoteCtl])) .And. !Empty(Acols[n, nPosLoteCtl])
                            FWAlertInfo("O lote '" + Alltrim(Acols[n, nPosLoteCtl]) + "' j� foi utilizado em outro item. Corrija para prosseguir.", "Lote Duplicado!")
                            lRet := .F.
                        EndIf
                    EndIf
                Next


            SB1->(DbCloseArea())

                // Obtendo o centro de custo e o rateio
                cCentroCusto := ACOLS[n][nCentroC] 
                cRateio := ACOLS[n][nRateio] 


            // Verificando se o centro de custo est� vazio e se o rateio est� informado
            If Empty(cCentroCusto) .and. cRateio == "1" .AND. lRastro = .T.
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
    EndIf
    
Return lRet
