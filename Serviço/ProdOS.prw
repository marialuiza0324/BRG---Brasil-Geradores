//BRG Geradores
//14/11/2018
//
//3rl Soluções

#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"
#Include "PROTHEUS.CH"

User Function ProdOS()  //ProdOS
Local  _desc := " "

DbSelectArea("AB7")
DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
dbSeek(xFilial("AB7")+AB6->AB6_NUMOS)

_desc := Posicione("SB1",1,xFilial("SB1")+AB7->AB7_CODPRO,"B1_DESC")                                   

Return _desc 


