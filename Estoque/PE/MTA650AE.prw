//BRG GERADORES
//DATA 16/08/2018
//3RL Soluções - Ricardo Moreira
//Gera contas a Pagar

User Function MTA650AE()
Local cNum  := PARAMIXB[1]
Local cItem := PARAMIXB[2]
Local cSeq  := PARAMIXB[3]

DbSelectArea("SCP")
DbSetOrder(1)  // SE2_FILIAL +  SE2_NUM
If dbSeek(xFilial("SCP")+"PRV"+cNum)
   Do While ! EOF() .AND. SE2->E2_FILIAL = xFilial("SE2") .AND. SE2->E2_PREFIXO = "PRV" .AND. SE2->E2_NUM = cNum 
     RecLock("SCP",.F.)
     SCP->( dbDelete() )
     msUnlock()
	 dbSkip()
   ENDDO
EndIf   


Return NIL