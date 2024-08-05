#INCLUDE "rwmake.ch"

/////////////////////////////////////////////////////////////////////////////
// Programa...: ADCTPSER                                                   //
// Autor......: RICARDO MOREIRA						                           //
// Data.......: 07/02/2022                                                 //
// Descrição..: Função realiza calculo da assiduidade, quando naõ tem falta// 
//                                                                         //    
// Posicao....: 00411         // Linha do Roteiro                          //
////////////////////////////////////////////////////////////////////////////

User Function GERAASSI 
Local nVal       :=  0 

IF SRA->RA_XASSIDU = "1"
   IF !(fLocaliaPd("440") > 0)
      nVal:= (SRA->RA_SALARIO*POSICIONE("RCE",1,XFILIAL("RCE")+SRA->RA_SINDICA,"RCE_XASSID")/100)/30*Diastrab    
      FGERAVERBA("090",nVal,Diastrab,,,,"I",,,,.F.) 
   Endif
Endif 
	
Return 
