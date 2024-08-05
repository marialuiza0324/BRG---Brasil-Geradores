//Valida Natureza Bloqueada na Mov. Bancaria
//10/04/2018
//BRG

User Function ValNat()
Local _Nat := M->E5_NATUREZ 
Local _Ret := .T. 

DbSelectArea("SED")
DbSetOrder(1)
If DbSeek(xFilial("SED")+_Nat)
   IF SED->ED_MSBLQL = "1"
      _Ret := .F.
   EndIf
EndIf
Return _Ret