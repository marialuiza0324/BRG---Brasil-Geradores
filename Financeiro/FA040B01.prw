/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � CTA100MNU  � Autor � Ricardo Moreira� 	  Data � 01/03/2023���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada para NAO DELETAR TITULO RA                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para BRG                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#INCLUDE "topconn.ch"

User Function FA040B01()

Local Uret := .T.
//alert("teste")

IF !(INCLUI) .and. !(ALTERA)
   If SE1->E1_TIPO = "RA " .AND. SE1->E1_EMISSAO <> DDATABASE
      Uret := .F.
      MSGINFO("Exclus�o de RA n�o permitida, esta fora da Data Base Correta ! "," Aten��o ") 
   EndIf
EndIf

Return Uret
