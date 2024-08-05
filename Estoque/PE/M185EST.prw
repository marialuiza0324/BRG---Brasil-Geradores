#include 'protheus.ch'
#include 'parmtype.ch'
//Limpa o Empenho no b2_qemp , quando estorna o item baixado
//BRG
//16/06/2020

User function M185EST()

DbSelectArea("SB2")
DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
IF dbSeek(xFilial("SB2")+SD3->D3_COD+SD3->D3_LOCAL)    
   SB2->(RECLOCK("SB2",.F.))
   SB2->B2_QEMP  := SB2->B2_QEMP - SD3->D3_QUANT                            
   SB2->(MSUNLOCK())	  
    
   SB2->(DbCloseArea())
EndIf

Return Nil
