/*/
�����������������������������������������������������������������������������
����������������������������f������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT103BCLA      � Autor � Ricardo         � Data �  26/04/18  ���
�������������������������������������������������������������������������͹��
���Descricao � Valida a quantidade a ser digitada na solicita��o          ���
�������������������������������������������������������������������������͹��
���Uso       � BRG Geradores                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//Vetor com os campos que poder�o ser alterados. Se retornar um vetor vazio, todos os campos ficar�o bloqueados.

User Function MT103BCLA()

Local aRet := {}   

AADD(aRet,"D1_TES")
AADD(aRet,"D1_OPER") 
AADD(aRet,"D1_CONTA")
AADD(aRet,"D1_CC") 
AADD(aRet,"D1_VALIPI") 
AADD(aRet,"D1_VALICM")
AADD(aRet,"D1_IPI") 
AADD(aRet,"D1_PICM") 
AADD(aRet,"D1_ITEMCTA")  
AADD(aRet,"D1_PEDIDO")
AADD(aRet,"D1_ITEMPC") 
AADD(aRet,"D1_NFORI")
AADD(aRet,"D1_SERIORI") 
AADD(aRet,"D1_ITEMORI")
AADD(aRet,"D1_BASEICM")
AADD(aRet,"D1_BASEIPI") 
AADD(aRet,"D1_CLASFIS")
AADD(aRet,"D1_DESPESA") 
AADD(aRet,"D1_BASEIRR") 
AADD(aRet,"D1_ALIQIRR") 
AADD(aRet,"D1_VALIRR") 
AADD(aRet,"D1_BASEISS") 
AADD(aRet,"D1_ALIQISS") 
AADD(aRet,"D1_VALISS") 
AADD(aRet,"D1_BASEINS") 
AADD(aRet,"D1_ALIQINS") 
AADD(aRet,"D1_VALINS") 
AADD(aRet,"D1_CODISS") 

Return aRet