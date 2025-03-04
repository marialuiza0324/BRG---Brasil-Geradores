#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MT100LOK  � Autor � RICARDO MOREIRA       � Data � 04/10/18潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada para validar a n鉶 digita玢o do lote      潮�
北�          � na entrada da nota					                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para PHARMA                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
      MSGINFO("Lotes divergentes !!"," Aten玢o ")
   EndIf

   If (Acols[n,nPosPrd]) <> (Acols[n,nPosPrdDes])  
      lRet := .F.
      MSGINFO("Produtos divergentes !!"," Aten玢o ")
   EndIf
EndIf

Return lRet
