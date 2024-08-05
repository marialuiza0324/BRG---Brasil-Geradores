#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

//Retorna o Valor do titulos descontando as retenções
//3rl Solucoes 29/09/2020
//BRG Geradores

User Function BRG019()
Local cValor := ""
Local _ImpRet := 0

IF SE1->E1_VRETIRF > 10 
   _ImpRet := SE1->E1_VRETIRF
Else
   _ImpRet := 0
EndIf  

cValor := STRZERO(ROUND(((SE1->E1_SALDO+SE1->E1_ACRESC)-(SE1->E1_INSS+SE1->E1_CSLL+SE1->E1_COFINS+SE1->E1_PIS+SE1->E1_DECRESC+_ImpRet))*100,2),13)
    
Return cValor
