#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

//Retorna o Valor do titulos descontando as retenções
//3rl Solucoes 29/09/2020
//BRG Geradores

User Function BRG019()
Local cValor := ""
Local _ImpRet := 0
Local nVlrIss  := 0
Local aAreaSA1 := SA1->(GetArea())

IF SE1->E1_VRETIRF > 10 
   _ImpRet := SE1->E1_VRETIRF
Else
   _ImpRet := 0
EndIf  

//Cliente com retencao de ISS: deduz o ISS retido do valor enviado ao banco,
//usando o mesmo criterio do boleto impresso (BltItau), para o registro bancario
//nao divergir do valor emitido no sistema.
SA1->(DbSetOrder(1))
If SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
   If SA1->A1_RECISS $ "1"
      nVlrIss := SE1->E1_ISS
   EndIf
EndIf

cValor := STRZERO(ROUND(((SE1->E1_SALDO+SE1->E1_ACRESC)-(SE1->E1_INSS+SE1->E1_CSLL+SE1->E1_COFINS+SE1->E1_PIS+SE1->E1_DECRESC+_ImpRet+nVlrIss))*100,2),13)
    
RestArea(aAreaSA1)

Return cValor
