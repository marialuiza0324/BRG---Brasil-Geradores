#INCLUDE "Protheus.ch"
#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � CT270RFA   � Autor � Claudio Ferreira    � Data � 15/07/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para alterar o % base para rateio         ���
���                                                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � TBC-GO                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CT270RFA()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {} 
Local cPerg:='CTB270'
//Cria pergunta
PutSx1( cPerg,"03","% Base","% Base","% Base","mv_ch3",;
"N",6,2,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)
if ValType(mv_par03) == "N"
  if mv_par03>0
     RecLock("CTQ",.F.)
     CTQ->CTQ_PERBAS:=mv_par03
     MsUnlock()
  endif   
endif
Return
