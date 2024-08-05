#INCLUDE 'PROTHEUS.CH'
User Function MT105FIM()
Local nOpcao := PARAMIXB  //1 -> Inclusão
Local _Solic := SCP->CP_NUM

If nOpcao = 1
   DbSelectArea("SCP")
   DbSetOrder(1)   
   SCP->(DbGoTop())
   IF dbSeek(xFilial("SCP")+_Solic)  
      DO WHILE SCP->(!EOF()) .AND. _Solic = SCP->CP_NUM 
        SCP->(RECLOCK("SCP",.F.))
        SCP->CP_MANUAL  := "S"                  
        SCP->(MSUNLOCK())

        SCP->( dbSkip())	
      EndDo
    EndIf
EndIf

Return 
