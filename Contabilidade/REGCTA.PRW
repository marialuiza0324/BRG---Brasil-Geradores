
/*
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � RetCta   � Autor � TBC		     � Data �  09/04/2012 ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotina para retornar a cta cont�bil amarrada               ���
��+----------+------------------------------------------------------------���
��� Uso      � LP�s                                                       ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RetCta(cID) 
Local cRet
cRet:=Posicione('ZC1',1,xFilial('ZC1')+cID,'ZC1_CONTA')
If empty(cRet)
  cRet:='Cta vza id:'+cID
endif  
  
Return cRet


