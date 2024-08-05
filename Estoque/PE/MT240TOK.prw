#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

//BRG GERADORES
//DATA 07/02/2018
//3RL Soluções - Ricardo Moreira
//Valida a o centro de custo conforme o parametro SF5 do centro de custo.

User Function MT240TOK()
Local lRet := .T.//-- Validações do usuário para inclusão do movimento 
Local _Tm  := M->D3_TM

DbSelectArea("SF5")
DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
dbSeek(xFilial("SF5")+_Tm)

IF SF5->F5_CC == "S"
   IF EMPTY(M->D3_CC) 
     Alert("Por Favor Preencher o Centro de Custo!!!")
     lRet := .F.
   EndIf
End

Return(lRet)