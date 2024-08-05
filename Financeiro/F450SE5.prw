User Function F450SE5()

Local aArea := GetArea()

RecLock("SE5",.F.)      
  SE5->E5_HISTOR := "Compensação - " + alltrim(SE2->E2_PREFIXO) +" / "+ alltrim(SE2->E2_NUM) +" / "+ alltrim(SE2->E2_PARCELA)
MsUnlock()

DbSelectArea("SE5")
DbSetOrder(7)
If DbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
   RecLock("SE5",.F.)      
   SE5->E5_HISTOR := "Compensação - " + alltrim(SE1->E1_PREFIXO) +" / "+ alltrim(SE1->E1_NUM) +" / "+ alltrim(SE1->E1_PARCELA)
   MsUnlock()
EndIF

RestArea(aArea)

Return
