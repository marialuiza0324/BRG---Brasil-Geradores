#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT100LOK  ³ Autor ³ RICARDO MOREIRA       ³ Data ³ 04/10/18³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada para validar a não digitação do lote      ³±±
±±³          ³ na entrada da nota					                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para PHARMA                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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
      MSGINFO("Lotes divergentes !!"," Atenção ")
   EndIf

   If (Acols[n,nPosPrd]) <> (Acols[n,nPosPrdDes])  
      lRet := .F.
      MSGINFO("Produtos divergentes !!"," Atenção ")
   EndIf
EndIf

Return lRet
