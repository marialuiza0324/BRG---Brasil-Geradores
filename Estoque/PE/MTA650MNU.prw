#include 'protheus.ch'
#include 'parmtype.ch'

//BRG
//Encerra uma OP ja iniciada
//14/04/2020

User function MTA650MNU()

AAdd(aRotina, { "Encerrar OP", "U_ENCERRA", 0, 5 } )

Return (aRotina)    

User Function ENCERRA()

If MsgYesNo("Deseja Realmente Encerrar a OP.","ATENÇÃO") 

   SC2->(RECLOCK("SC2",.F.))
   SC2->C2_DATRF   := DDATABASE  
   SC2->C2_STATUS  := "U"
   SC2->(MSUNLOCK())	   

   MSGINFO("Op Iniciada Encerrada."," Atenção ")
EndIf

Return