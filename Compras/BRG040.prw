#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���AUTOR     � MARLON     02/04/2024                                      ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                             ��
                                                                           ��
   Fun��o para nao deixar comprar produtos do tipo OI                      ��
                                                                           ��
                                                                           ��
                                                                           ��                                                                 
�������������������������������������������������������������������������͹��
���Uso       � BRG GERADORES                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BRG040()

Local cRet := .F.
Local aArea		:= GetArea()
local cTipo := ""
Local cMvTipo := Getmv("MV_TIPOPRO")

DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1")+M->C1_PRODUTO)
   cTipo := SB1->B1_TIPO

   If cTipo $ cMvTipo
      FWAlertError("Produto com TIPO 'OI' N�o permitido!!! "+CHR(13)+"Tipo de Produto informado no parametro MV_TIPOPRO", "Alerta - Erro")
      cRet := .F. 
   EndIf
EndIf

RestArea(aArea)
Return cRet 
