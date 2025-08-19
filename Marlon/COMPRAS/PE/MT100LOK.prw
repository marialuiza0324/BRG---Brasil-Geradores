#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT100LOK 
 Fun��o de Valida��o ( linha OK da Getdados) para 
 Inclus�o/Altera��o do item .
 Fun��o de Valida��o da LinhaOk.
 Valida inclus�o de linha na NF.
@type  Function
@author Maria Luiza
@since 05/09/2024 */

User Function MT100LOK()

Local ExpL1 := .T.
Local cRateio := "" // Vari�vel que vai armazenar o rateio
Local cCentroCusto := "" // Vari�vel para o centro de custo
local nPosCod        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"})
local nPosLoteCtl    := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_LOTECTL"})
local nCentroC       := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_CC"})
local nRateio        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_RATEIO"})
Local nLinha

If Funname() <> "LOCA001" .AND. Funname() <> "MATA461"

    If !FWIsInCallStack("A103Devol") //s� entra na valida��o caso n�o esteja selecionada a op��o de retornar NF

        DbSelectArea("SB1")
        DbSetOrder(1)   

        IF dbSeek(xFilial("SB1")+Acols[n, nPosCod])//busca produto na SB1
            If SB1->B1_RASTRO == "L" .AND. Empty(Acols[n, nPosLoteCtl])//se produto possuir ratreabilidade e lote estiver vazio
                ExpL1  := .F. //n�o permite inclus�o do doc 
                FWAlertInfo("Item com Rastreabilidade, informe o Lote"," Aten��o!!!")
                Return
            EndIf
        EndIf


        // Verifica se o lote j� foi usado em outra linha
            For nLinha := 1 To Len(Acols)
                If nLinha != n // Ignora a linha atual
                    If Upper(AllTrim(Acols[nLinha, nPosLoteCtl])) == Upper(AllTrim(Acols[n, nPosLoteCtl])) .And. !Empty(Acols[n, nPosLoteCtl])
                        FWAlertInfo("O lote '" + Alltrim(Acols[n, nPosLoteCtl]) + "' j� foi utilizado em outro item. Corrija para prosseguir.", "Lote Duplicado!")
                        ExpL1 := .F.
                        Return
                    EndIf
                EndIf
            Next

        // Obtendo o centro de custo e o rateio
        cCentroCusto := ACOLS[n][nCentroC] 
        cRateio := ACOLS[n][nRateio] 

        // Verificando se o centro de custo est� vazio e se o rateio est� informado
        If Empty(cCentroCusto) .and. cRateio == "1"
            // Se o centro de custo est� vazio e h� rateio, permite a confirma��o
            ExpL1 := .T. // Permite continuar sem erro
        ElseIf Empty(cCentroCusto) .and. cRateio == "2"
            // Se ambos est�o vazios, bloqueia a grava��o e exibe uma mensagem
            FWAlertInfo("Informe um centro de custo ou rateio", "Aten��o!!!")
            ExpL1 := .F. // Bloqueia a confirma��o
        EndIf
    EndIf
EndIf

Return ExpL1
