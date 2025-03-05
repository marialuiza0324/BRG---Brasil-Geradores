#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MTA103OK  
Rotina de validação da LinhaOk. 
Esse ponto permite a alteração do resultado da validação padrão
para inclusão/alteração de registros de entrada
Utilizado para validações no Retorno da NF
@type  Function
@author Maria Luiza
@since 21/01/2025 */



User Function MTA103OK()

Local lRet := .T. 
Local cRateio := "" // Variável que vai armazenar o rateio
Local cCentroCusto := "" // Variável para o centro de custo
Local lRastro := .T.
local nPosCod        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"})
local nCentroC       := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_CC"})
local nRateio        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_RATEIO"})
local nPosLoteCtl    := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_LOTECTL"})
Local nLinha

    If !FWIsInCallStack("A103Devol") //só entra na validação caso não esteja selecionada a opção de retornar NF

            DbSelectArea("SB1")
            DbSetOrder(1)   

            IF dbSeek(xFilial("SB1")+Acols[n,nPosCod])//busca produto na SB1
                If SB1->B1_RASTRO == "L" .AND. Empty(Acols[n,nPosLoteCtl])//se produto possuir ratreabilidade e lote estiver vazio
                    FWAlertInfo("Item com Rastreabilidade, informe o Lote"," Atenção!!!")
                    lRet  := .F. //não permite inclusão do doc 
                    lRastro := .F.
                EndIf
            EndIf

                // Verifica se o lote já foi usado em outra linha
                For nLinha := 1 To Len(Acols)
                    If nLinha != n // Ignora a linha atual
                        If Upper(AllTrim(Acols[nLinha, nPosLoteCtl])) == Upper(AllTrim(Acols[n, nPosLoteCtl])) .And. !Empty(Acols[n, nPosLoteCtl])
                            FWAlertInfo("O lote '" + Alltrim(Acols[n, nPosLoteCtl]) + "' já foi utilizado em outro item. Corrija para prosseguir.", "Lote Duplicado!")
                            lRet := .F.
                        EndIf
                    EndIf
                Next


            SB1->(DbCloseArea())

                // Obtendo o centro de custo e o rateio
                cCentroCusto := ACOLS[n][nCentroC] 
                cRateio := ACOLS[n][nRateio] 


            // Verificando se o centro de custo está vazio e se o rateio está informado
            If Empty(cCentroCusto) .and. cRateio == "1" .AND. lRastro = .T.
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
    EndIf
    
Return lRet
