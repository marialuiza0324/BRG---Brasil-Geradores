//Bibliotecas
#Include "TOTVS.ch"
#INCLUDE "topconn.ch"
#include "fwmvcdef.ch"

/*/{Protheus.doc} User Function MT410ALT
Este ponto de entrada pertence � rotina de pedidos de venda, MATA410().
Est� localizado na rotina de altera��o do pedido, A410ALTERA().
� executado ap�s a grava��o das altera��es.
@type  Function
@author Maria Luiza
@since 14/11/2024
/*/

User Function MT410ALT()

	Local cUserId := RetCodUsr()
	Local cNome := UsrFullName(cUserID)
	Local cPedido := M->C5_NUM
	Local cLoja   := M->C5_LOJACLI
	Local cCliente := M->C5_CLIENTE

	DbSelectArea("SC5")
	SC5->(DbSetOrder(3))
	SC5->(DbGoTop())

	If SC5->(MsSeek(FWxFilial("SC5")+cCliente+cLoja+cPedido))
		Reclock("SC5", .F.)
		SC5->C5_XUSER := cNome
		SC5->(MsUnlock())
	EndIf

	SC5->(DbCloseArea())


Return 
