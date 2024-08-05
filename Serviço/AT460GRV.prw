//BRG Geradores
//08/11/2018
//Atualiza o Custo do Item Requisitado
//3rl Soluções

#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"
#Include "PROTHEUS.CH"

User Function AT460GRV  //AT460GRV  

Local _NumOs := AB6->AB6_NUMOS 
Local _Client:= AB6->AB6_CODCLI 
Local _Loja  := AB6->AB6_LOJA 
Local _Codpr := AB7->AB7_CODPRO
Local _Lote  := AB7->AB7_NUMSER
Local _Tipo  := AB7->AB7_TIPO
Local _Tec   := ABA->ABA_CODTEC
Local _Seq   := ABA->ABA_SEQ
Local _Valor := 0

DbSelectArea("ABA")
DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
IF !dbSeek(xFilial("ABA")+_NumOs+_Tec+_Seq)
   DO WHILE ABA->(!EOF()) .AND. _NumOs = ABA->ABA_NUMOS .AND.  _Tec = ABA->ABA_CODTEC  .AND. _Seq = ABA->ABA_SEQ
       
      _Valor  := Posicione("SB2",1,xFilial("SB2")+ABA->ABA_CODPRO,"B2_CM1")
      //_Desc   := Posicione("SB1",1,xFilial("SB1")+ABA->ABA_CODPRO,"B1_DESC")
 
      AB8->(RECLOCK("AB8",.T.))
      AB8->AB8_FILIAL := xFilial("AB8")
      AB8->AB8_NUMOS  := _NumOs
      AB8->AB8_ITEM   := ABA->ABA_SEQ
      AB8->AB8_SUBITE := ABA->ABA_ITEM
      AB8->AB8_CODPRO := ABA->ABA_CODPRO
      AB8->AB8_DESPRO := ABA->ABA_DESCRI
      AB8->AB8_CODSER := ABA->ABA_CODSER
      AB8->AB8_QUANT  := ABA->ABA_QUANT
      AB8->AB8_VUNIT  := _Valor
      AB8->AB8_TOTAL  := Round((AB8->AB8_QUANT*_Valor),2)
      AB8->AB8_ENTREG := DDATABASE
      AB8->AB8_PRCLIS := _Valor
      AB8->AB8_CODCLI := _Client
      AB8->AB8_LOJA   := _Loja
      AB8->AB8_CODPRD := _Codpr
      AB8->AB8_NUMSER := _Lote
      AB8->AB8_TIPO   := _Tipo
      AB8->AB8_LOCAL  := "01"
      AB8->(MSUNLOCK())  

      ABA->(dbSkip())
   EndDo
EndIf

DbSelectArea("AB8")
DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
IF dbSeek(xFilial("AB8")+_NumOs)  
   DO WHILE AB8->(!EOF()) .AND. _NumOs = AB8->AB8_NUMOS
       
      _Valor  := Posicione("SB2",1,xFilial("SB2")+AB8->AB8_CODPRO,"B2_CM1")
 
      AB8->(RECLOCK("AB8",.F.))
      AB8->AB8_VUNIT  := _Valor
      AB8->AB8_TOTAL  := Round((AB8->AB8_QUANT*_Valor),2)
      AB8->AB8_PRCLIS := _Valor
      AB8->(MSUNLOCK())  

      AB8->(dbSkip())
   EndDo
EndIf

Return Nil
