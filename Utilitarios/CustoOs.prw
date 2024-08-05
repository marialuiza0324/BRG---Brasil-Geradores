User Function CustoOs()     //U_CustoOs()  

Local  _Valor := 0

DbSelectArea("AB8")  
AB8->(DBSetOrder(4))	
AB8->(DbGoTop())
While AB8->(!eof())

_Valor  := Posicione("SB2",1,xFilial("SB2")+AB8->AB8_CODPRO,"B2_CM1")
 
 AB8->(RECLOCK("AB8",.F.))
 AB8->AB8_VUNIT := _Valor
 AB8->(MSUNLOCK())     
 AB8->(dbskip())
EndDo  

Alert("finalizou")
Return 


