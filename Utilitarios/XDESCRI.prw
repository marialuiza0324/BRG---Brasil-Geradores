User Function XDESCRI()     //U_XDESCRI()  

Local  Desc := " " 

DbSelectArea("SD1")  
SD1->(DBSetOrder(1))	
SD1->(DbGoTop())
While SD1->(!eof())

Desc  := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC")
 
 SD1->(RECLOCK("SD1",.F.))
 SD1->D1_XDESCPR := Desc
 SD1->(MSUNLOCK())     
 SD1->(dbskip())
EndDo  

Alert("fim")
Return 


