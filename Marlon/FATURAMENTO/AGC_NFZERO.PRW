
#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �AGC_NFZERO�Autor �TOTVS		        � Data � 30/01/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     � PROGRAMA COMPLETAR NUMERO DA NF DE ENTRA A ESQUERDA        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Compilar este fonte e                                      ���
���			 � Colocar no X3_VLDUSER do campo F1_DOC --> U_AGC_NFZERO(9)  ���
���			 � Revisado por Adriano Costa                U_AGC_SRZERO(3)  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/   

User Function AGC_NFZERO(ntam)
	CNFISCAL := STRZERO(VAL(CNFISCAL),ntam)
Return(.T.)

/*
Notas de Transferencia Filial //
*/
User Function FTRANSF(CTes)
	cTransf := Posicione("SF4",1,xFilial("SF4")+cTes,"F4_TRANSFIL")
	CNFISCAL := substr(CNFISCAL3,6)
Return(.T.)

/*
Notas de Transferencia Filial //
*/
User Function AGC_SRZERO(ntam)
	If CSERIE <> "U"
		CSERIE := STRZERO(VAL(CSERIE),ntam)
	EndIf
Return(.T.)



