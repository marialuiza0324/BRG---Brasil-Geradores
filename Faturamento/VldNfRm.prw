//Valida o campo C5_NFREM
//Ricardo Moreira
//17/08/2021
User Function VldNfRm()    //u_VldNfRm()

Local _Ret := .T.
Local i
Local _NFRem := ALLTRIM(M->C5_NFREM)+"/"

If M->C5_TPDOC = "F"

   _QtsCar := len(_NFRem)  ///30 000001524/000004571/000001578/

   For i:= 10 to _QtsCar step 10
       If substr(_NFRem,i,1) = "/"
          _Ret := .T. 
       else
          MSGINFO("Preenchimento não validado, Preencha Corretamente !!!"," Atenção ")
          _Ret := .F. 
       EndIf    
   Next i
endIf

Return _Ret
