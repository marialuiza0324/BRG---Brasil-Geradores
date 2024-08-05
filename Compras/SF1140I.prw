#include 'protheus.ch'
#include 'parmtype.ch'

User function SF1140I()
Local aArea := GetArea()

RecLock("SF1",.F.)   
SF1->F1_USERCOM := ComputerName()                  
MsUnlock()

RestArea(aArea)
Return Nil