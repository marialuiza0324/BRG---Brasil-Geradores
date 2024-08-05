/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FA050UPD  � Autor � Ricardo Moreira� 	  Data � 01/03/2023���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada PARA N�O DELETAR TITULO PA                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para BRG                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#INCLUDE "topconn.ch"

User Function FA050UPD()

Local Uret := .T.

IF !(INCLUI) .and. !(ALTERA)
   If SE2->E2_TIPO = "PA " .AND. SE2->E2_EMISSAO <> DDATABASE
      Uret := .F.
      MSGINFO("Exclus�o de PA n�o permitida, esta fora da Data Base Correta ! "," Aten��o ") 
   EndIf
EndIf

Return Uret
