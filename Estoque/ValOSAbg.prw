/*/
�����������������������������������������������������������������������������
����������������������������f������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VALESTCP      � Autor � Ricardo         � Data �  26/04/18  ���
�������������������������������������������������������������������������͹��
���Descricao � Valida a quantidade a ser digitada na solicita��o          ���
�������������������������������������������������������������������������͹��
���Uso       � BRG Geradores                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function VALOSABG() //U_VALOSABG  

Local lRet := .T.
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="ABG_CODPRO"})
//Local nPLocal	:= aScan(aHeader,{|x| AllTrim(x[2])=="ABG_CP_LOCAL"})
Local nPQuant   := aScan(aHeader,{|x| AllTrim(x[2])=="ABG_QUANT"}) 
//Local Quant := 0

Quant := M->ABG_QUANT //acols[n,nPQuant]
//If cLocalAux = ""

//End

DbSelectArea("SB2")
DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
IF dbSeek(xFilial("SB2")+acols[n,nPProduto]+cLocalAux)
 _Saldo := SB2->B2_QATU
  IF Quant > SB2->B2_QATU     //acols[n,nPQuant]
     lRet := .F.
     Alert("Saldo Insuficiente - Saldo Atual: "+ cvaltochar(_Saldo)+" #")
  EndIF 
EndIf
Return lRet

