#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'


/*/{Protheus.doc} nomeFunction
    Função que indica o tipo de OP
    na rotina de baixa de estoque
    @type  Function
    @author Maria Luiza
    @since 22/05/2025
    /*/

User Function FSEST003()

Local cRet := ""

cRet := Posicione("SC2", 1, xFilial("SC2") + SUBSTR(SCP->CP_OP,1,6) + SUBSTR(SCP->CP_OP,7,2) + SUBSTR(SCP->CP_OP,9,3) , "C2_TPOP")

Return cRet
