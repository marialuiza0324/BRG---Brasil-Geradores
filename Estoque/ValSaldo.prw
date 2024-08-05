//BRG GERADORES
//DATA 29/10/2018
//3RL Soluções - Ricardo Moreira
//Valida o Saldo Disponivel na Solicitação de Transferencia
User Function ValSaldo() 

Local _Ret := .T.
Local _LocOrig := FwFldGet("NNT_LOCAL") 
Local _Prod    := FwFldGet("NNT_PROD") 
Local _LotD    := FwFldGet("NNT_LOTED")
Local _LotCt   := FwFldGet("NNT_LOTECT")                                                      

DbSelectArea("SB2")
DbSetOrder(1)  
IF dbSeek(xFilial("SB2")+_Prod+_LocOrig)	
	nSaldo := SaldoSb2()	
	IF M->NNT_QUANT > nSaldo
		MSGINFO("Saldo Indisponível"," Atenção ")
		_Ret := .F.
	EndIf
EndIf
Return _Ret

//BRG GERADORES
//DATA 18/02/2021
//3RL Soluções - Ricardo Moreira
//Valida o Lote distinto na operação

User Function ValLtNNT() 

Local _Ret := .T. 
Local _Prod    := FwFldGet("NNT_PROD") 
Local _LotD    := FwFldGet("NNT_LOTED") 
Local _LotCt    := FwFldGet("NNT_LOTECT") 

IF _LotCt <> _LotD
	MSGINFO("Lotes Distintos"," Atenção ")
	_Ret := .F.
EndIf
 
Return _Ret
