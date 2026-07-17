#Include "Protheus.ch"
  
//-------------------------------------------------------------------
/*/{Protheus.doc} MNTA420X
Permite customizar dados da OS.
@author  Maria Luiza
@since   10/07/2026
/*/
//-------------------------------------------------------------------
User Function MNTA420X()
  
    Local cOrdem  := PARAMIXB[ 1 ]
    Local cFilSC2 := xFilial("SC2")
    Local aArea   := SC2->(GetArea())
    Local lRet    := .T.
  
    If M->TJ_SITUACA == 'L' .And. Inclui 
        dbSelectArea("SC2")
        dbSetOrder(1) //C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN
        If dbSeek(cFilSC2+cOrdem+"OS")
            Reclock("SC2", .F.)
            SC2->C2_TPOP := "F"
            SC2->(MsUnlock())
        ElseIf !dbSeek(cFilSC2+cOrdem+"OS")
            lRet := .F.
            MsgInfo("Ordem de Produção não encontrada.")
        EndIf
    EndIf
  
    RestArea(aArea)
  
Return lRet
