#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT100LOK  � Autor � RICARDO MOREIRA       � Data � 04/10/18���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada para validar a n�o digita��o do lote      ���
���          � na entrada da nota					                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para PHARMA                                     ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

User Function A261TOK()

Local lRet := .T.
local nPosLot     := AScan(aHeader, {|x| Alltrim(x[1]) == "Lote"})
local nPosLotDes  := AScan(aHeader, {|x| Alltrim(x[1]) == "Lote Destino"})
local nPosPrd     := AScan(aHeader, {|x| Alltrim(x[1]) == "Prod.Orig."})
local nPosPrdDes  := AScan(aHeader, {|x| Alltrim(x[1]) == "Prod.Destino"})
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local cTransf  := SuperGetMV("MV_USETRAN", ," ")  

If  !(cCodUser $ cTransf) // NO DIA 18/11/21 GUILHERME PEDIU PARA MARLON LIBERAR A SENHA DELE (ZAP ZAP) obs. VAI DAR BODE
   If (Acols[n,nPosLot]) <> (Acols[n,nPosLotDes])  
      lRet := .F.
      MSGINFO("Lotes divergentes !!"," Aten��o ")
   EndIf

   If (Acols[n,nPosPrd]) <> (Acols[n,nPosPrdDes])  
      lRet := .F.
      MSGINFO("Produtos divergentes !!"," Aten��o ")
   EndIf
EndIf

Return lRet
