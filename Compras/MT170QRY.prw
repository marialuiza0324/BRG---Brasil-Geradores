#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT170SB1 � Autor � Ricardo Moreira     � Data �  07/01/2021 ���
�������������������������������������������������������������������������͹��
������������������������������������ͱ�����������������������������������͹��
���Descricao � Deleta as Solicita��es geradas automaticamente             ���
�������������������������������������������������������������������������͹��
���Uso       � BRG                     			              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//User Function MT170SB1()

User Function MT170QRY( )
Local cNewQry := ParamIXB[1]//-- Manipula��o da query/filtro para condi��o do usu�rioReturn (cNewQry)

//Local cAlias := ParamIXB[1]   //-- Alias atribu�do � query.
//Local lRet := .T.

MSGINFO("Solicita��es geradas por Ponto de pedido n�o atendidas ser�o exclu�das !!!!!"," Aten��o ") 

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
