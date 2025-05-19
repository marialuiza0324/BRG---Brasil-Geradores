#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} GERREMC5
Inserir campos no SC5 ao gerar pedido de vendas
@author Maria Luiza
@since 24/02/2025 */

User Function GERREMC5() 

LOCAL aCampos := PARAMIXB[1]

// Adicionando os campos com a ordem correta conforme SX3
IF !Empty(FQ2->FQ2_XVENLO)
    AAdd(aCampos, {"C5_VEND1", AllTrim(FQ2->FQ2_XVENLO), "15"})  // Ordem do SX3
ENDIF

IF !Empty(FQ2->FQ2_NUM)
    AAdd(aCampos, {"C5_XPROPOS", AllTrim(FQ2->FQ2_NUM), "BC"})  // Ordem do SX3
ENDIF

Return AClone(aCampos)
