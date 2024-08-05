#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT170SB1 º Autor ³ Ricardo Moreira     º Data ³  07/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍ¹±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Deleta as Solicitações geradas automaticamente             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BRG                     			              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//User Function MT170SB1()

User Function MT170QRY( )
Local cNewQry := ParamIXB[1]//-- Manipulação da query/filtro para condição do usuárioReturn (cNewQry)

//Local cAlias := ParamIXB[1]   //-- Alias atribuído à query.
//Local lRet := .T.

MSGINFO("Solicitações geradas por Ponto de pedido não atendidas serão excluídas !!!!!"," Atenção ") 

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := "SELECT C1_FILIAL, C1_NUM, C1_ITEM,C1_PRODUTO,C1_QUANT, C1_QUJE, C1_ORIGEM,C1_LOCAL "
_cQry += "FROM " + retsqlname("SC1")+" SC1 "  
_cQry += "WHERE SC1.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SC1.C1_QUJE = 0 "
_cQry += "AND   SC1.C1_ORIGEM = 'MATA170' "
_cQry += "ORDER BY  SC1.C1_NUM, SC1.C1_ITEM "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE !TMP->(EOF()) 

   DbSelectArea("SB2")
   DbSetOrder(1)   
   IF dbSeek(xFilial("SB2")+TMP->C1_PRODUTO+TMP->C1_LOCAL)
      _QtdSalPed := TMP->C1_QUANT - SB2->B2_SALPEDI
      RecLock("SB2",.F.)
      SB2->B2_SALPEDI   := _QtdSalPed         
      SB2->( MSUNLOCK() ) 
   EndIF

   DbSelectArea("SC1")
   DbSetOrder(1)   
   IF dbSeek(xFilial("SC1")+TMP->C1_NUM+TMP->C1_ITEM)
	   RecLock("SC1",.F.)
      SC1->( dbDelete() )
      msUnlock()
   EndIF
   TMP->(dbSkip())
ENDDO

Return (cNewQry)
//Return lRet
