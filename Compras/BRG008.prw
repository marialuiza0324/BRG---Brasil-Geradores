#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BRG008 � Autor � Ricardo Moreira     � Data �  06/09/18    ���
�������������������������������������������������������������������������͹��
������������������������������������ͱ�����������������������������������͹��
���Descricao � Retorna o Ultimo Pre�o 						              ���
�������������������������������������������������������������������������͹��
���Uso       � BRG                             			             	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BRG008()   
Local _Valor := ""
Local _uRet := .T.

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := "SELECT TOP 1 D1_COD, D1_QUANT, D1_VUNIT  "
_cQry += "FROM " + retsqlname("SD1")+" SD1 "  
_cQry += "WHERE SD1.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SD1.D1_COD = '" + M->C7_PRODUTO + "' "
_cQry += "AND   SD1.D1_TIPO = 'N' "
_cQry += "ORDER BY D1_DTDIGIT DESC "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP" 

 _Valor   := TMP->D1_VUNIT
       
MSGINFO("�ltimo pre�o do Item R$:" + cvaltochar(_Valor)+" ","Aten��o")

Return _uRet