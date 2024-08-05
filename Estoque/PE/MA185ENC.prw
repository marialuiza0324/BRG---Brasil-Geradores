#include 'protheus.ch'
#include 'parmtype.ch'

//BRG GERADORES
//DATA 17/09/2019
//3RL Solu��es - Ricardo Moreira
//Quando faz o Encerramento de uma requisi��o a quantidade de itens solicitados � gerada, para n�o gerar o Registro TM 999

User Function MA185ENC()
DbSelectArea("SD4")
DbSetOrder(2) 
IF dbSeek(xFilial("SCP")+SCP->CP_OP+SCP->CP_PRODUTO+SCP->CP_LOCAL)   
   SD4->(RECLOCK("SD4",.F.))
   SD4->D4_QUANT     := 0	   
   SD4->(MSUNLOCK())
EndIf  
	
Return nil