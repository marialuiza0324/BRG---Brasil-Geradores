#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT140LOK 
Este ponto de entrada tem o objetivo de 
validar as informa��es preenchidas no aCols 
de cada item do pr�-documento de entrada.
@type  Function
@author Maria Luiza
@since 05/09/2024 */

User Function MT140LOK()

Local lRet := .T. 
Local cRateio := "" // Vari�vel que vai armazenar o rateio
Local cCentroCusto := "" // Vari�vel para o centro de custo
Local lRastro := .T.
local nPosCod        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"})
local nCentroC       := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_CC"})
local nRateio        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_RATEIO"})
local nPosLoteCtl    := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_LOTECTL"})
Local nLinha

If Funname() <> "LOCA001"

       DbSelectArea("SB1")
       DbSetOrder(1)   

    IF dbSeek(xFilial("SB1")+Acols[n,nPosCod])//busca produto na SB1
        If SB1->B1_RASTRO == "L" .AND. Empty(Acols[n,nPosLoteCtl])//se produto possuir ratreabilidade e lote estiver vazio
            lRet  := .F. //n�o permite inclus�o do doc 
            lRastro := .F.
            FWAlertInfo("Item com Rastreabilidade, informe o Lote"," Aten��o!!!")
            Return
        EndIf
    EndIf

        // Verifica se o lote j� foi usado em outra linha
        For nLinha := 1 To Len(Acols)
            If nLinha != n // Ignora a linha atual
                If Upper(AllTrim(Acols[nLinha, nPosLoteCtl])) == Upper(AllTrim(Acols[n, nPosLoteCtl])) .And. !Empty(Acols[n, nPosLoteCtl])
                    FWAlertInfo("O lote '" + Alltrim(Acols[n, nPosLoteCtl]) + "' j� foi utilizado em outro item. Corrija para prosseguir.", "Lote Duplicado!")
                    lRet := .F.
                    Return
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
