#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc}
Função para amarrar tabela de preço 
ao cliente da filial logada.
@type  Function
@author Maria Luiza
@since 25/02/2026*/

User Function FSFAT006()

Local cTabela := ""
Local cTabCli := ""

If !Empty(M->C5_CLIENTE) .AND. !Empty(M->C5_LOJACLI)
    cTabCli := Posicione("SA1",1,FWxFilial('SA1') + M->C5_CLIENTE + M->C5_LOJACLI, "A1_TABELA")
ElseIf !Empty(M->CJ_CLIENTE) .AND. !Empty(M->CJ_LOJA)
    cTabCli := Posicione("SA1",1,FWxFilial('SA1') + M->CJ_CLIENTE + M->CJ_LOJA, "A1_TABELA")
EndIf

If Empty(cTabCli) .AND. Substr(cFilAnt,1,2) $ ("01,05")
    Alert("Cliente não possui tabela de preço amarrada. Favor amarrar uma tabela de preço para o cliente !!!")
Else
    cTabela := Posicione("DA0",1,cFilAnt + cTabCli, "DA0_CODTAB")

EndIf

Return cTabela
