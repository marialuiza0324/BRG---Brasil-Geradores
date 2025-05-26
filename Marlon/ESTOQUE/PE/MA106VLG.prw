#Include "TOTVS.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} MA106VLG  
Trava a geração de requisições com OP's previstas
permitindo gerar requisições apenas para 
solicitações que tenham OP's firmes
@type  Function
@author Seu Nome
@since 22/05/2025 
*/
User Function MA106VLG()

Local lRet := .T.
Local cUserTpOp := SuperGetMV("MV_USRTPOP", , )
Local cUserId := RetCodUsr()
Local cTipoOp := ""
Local nI,n
Local cMsg := ""

    Local aDiverg := {}

    If cUserId $ cUserTpOp
        // Percorre apenas os registros marcados em ACHECKDES
        For nI := 1 To Len(ACHECKDES)
            nRecNo := ACHECKDES[nI][1][1]
            If nRecNo > 0
                SCP->(DbGoTo(nRecNo))
                cTipoOp := Posicione("SC2", 1, xFilial("SC2") + SUBSTR(SCP->CP_OP,1,6) + SUBSTR(SCP->CP_OP,7,2) + SUBSTR(SCP->CP_OP,9,3), "C2_TPOP")
                If cTipoOp == "P"
                    // Guarda informações para exibir ao usuário
                    AAdd(aDiverg, SCP->CP_NUM + " - " + SCP->CP_OP)
                EndIf
            EndIf
        Next

        If Len(aDiverg) > 0
            lRet := .F.
            If Len(aDiverg) == 1
                cMsg := "Não é possível gerar requisição: a seguinte solicitação está vinculada à OP prevista: " + ;
                        CRLF + CRLF + aDiverg[1]
            Else
                cMsg := "Não é possível gerar requisição: as seguintes solicitações estão vinculadas às OPs previstas: " + ;
                        CRLF + CRLF + ""
                For n := 1 To Len(aDiverg)
                    cMsg += aDiverg[n] + CRLF
                Next
            EndIf
            Help(, ,"AVISO#0024", ,cMsg,1, 0, , , , , , ;
                {"Para gerar a requisição, todas as OPs vinculadas devem estar com status FIRME. Desmarque as solicitações acima."})
        EndIf
    EndIf

Return lRet
