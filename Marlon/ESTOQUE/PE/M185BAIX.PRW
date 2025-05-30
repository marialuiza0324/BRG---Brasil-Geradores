#Include "TOTVS.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} MT185FIL  
Trava a baixa de requisi��es de OP's previstas
permitindo baixa apenas para OP's firmes
@type  Function
@author Seu Nome
@since 22/05/2025 
*/
User Function M185BAIX()

Local lRet := .T.
Local cTipoOp := Posicione("SC2", 1, xFilial("SC2") + SUBSTR(SCP->CP_OP,1,6) + SUBSTR(SCP->CP_OP,7,2) + SUBSTR(SCP->CP_OP,9,3) , "C2_TPOP")
Local cUserTpOp := SuperGetMV("MV_USRTPOP", , )
Local cUserId := RetCodUsr()

If cUserId $ cUserTpOp
    If cTipoOp == "P"
        lRet := .F.
        Help(, ,"AVISO#0023", ,"N�o � poss�vel realizar a baixa: a requisi��o est� vinculada a uma OP prevista.", 1, 0, , , , , , {"Para efetuar a baixa, a OP vinculada deve estar com status FIRME."})
    EndIf
Else
    lRet := .T.
EndIf

Return lRet



