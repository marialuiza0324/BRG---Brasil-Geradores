#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MA650PBAT 
@type  Function
@author Maria Luiza
@since 17/09/2025 */

User Function MA650EMP()

Local cOp := alltrim(SD4->D4_OP)
Local cDescri := ""
Local cQuery := ""
Local nRecno := 0
Local cProduto := ""

If Select("TSC2") > 0
    TSC2->(dbCloseArea())
EndIf

cQuery := "SELECT R_E_C_N_O_ AS RECNO, C2_PRODUTO AS PRODUTO FROM " + Retsqlname("SC2") + " "
cQuery += "WHERE C2_FILIAL = '" + cFilAnt + "' AND C2_NUM = '" + Substr(cOp,1,6) + "' "
cQuery += "AND C2_ITEM = '" + Substr(cOp,7,2) + "'  "
cQuery += "AND C2_SEQUEN = '" + Substr(cOp,9,3) + "' "
cQuery += "AND D_E_L_E_T_ <> '*' "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TSC2", .F., .T.)

DbSelectArea("TSC2")

nRecno := TSC2->RECNO
cProduto := TSC2->PRODUTO

cDescri := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")   

            DbSelectArea("SC2")
            DbSetOrder(1)
            DbGoto(nRecno)                                                                                                                          
                RecLock("SC2",.F.)
                SC2->C2_XDESC := cDescri 
                SC2->(MsUnlock())

SC2->(DbCloseArea())
TSC2->(DbCloseArea())

Return
