//BRG Geradores
//24/11/2019
//Tratamento para o Item opcional na Estrutura 
//3rl Soluções

#include 'protheus.ch'
#include 'parmtype.ch'

User function MTGRVEMP()
Local aArea    := GetArea()

//PARAMIXB[1] - Código do Produto que será gravado		
//PARAMIXB[2] - Armazém selecionado para o produto
//PARAMIXB[3] - Quantidade do produto a ser gravada no empenho 

If !empty(SB1->B1_ITEMOPC)
   DbSelectArea("SB2")
   DbSetOrder(1)  
   If dbSeek(xFilial("SB2")+PARAMIXB[1]+PARAMIXB[2])
      _QtdSb2 :=  (SB2->B2_QATU - SB2->B2_QEMP) //SaldoSb2()   
      If PARAMIXB[3] >_QtdSb2
         _Prod := SB1->B1_ITEMOPC
         IF dbSeek(xFilial("SB2")+_Prod+SB1->B1_LOCPAD)
            _QtdSb2Opc := (SB2->B2_QATU - SB2->B2_QEMP) //SaldoSb2()
            If PARAMIXB[3] < _QtdSb2Opc
               PARAMIXB[1] := SB1->B1_COD
            End
         End
      EndIf
   EndIf
EndIf
SB2->(DbCloseArea())

RestArea(aArea)        
Return Nil
