#include "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

/*
P.E.:  MT410INC
                                                                                      |
 | Desc: Este ponto de entrada pertence à rotina de pedidos de venda, 
 MATA410(). Está localizado na rotina de alteração do pedido, 
 A410INCLUI(). É executado após a gravação das informações.                              |
 |
*/

User Function MT410INC()

	Local cUserId := RetCodUsr()
	Local cNome := UsrFullName(cUserID)
	Local cPedido := M->C5_NUM
	Local cLoja   := M->C5_LOJACLI
	Local cCliente := M->C5_CLIENTE

	If Funname() <> "LOCA001"

		DbSelectArea("SC5")
		SC5->(DbSetOrder(3))
		SC5->(DbGoTop())

		If SC5->(MsSeek(FWxFilial("SC5")+cCliente+cLoja+cPedido))
			Reclock("SC5", .F.)
			SC5->C5_XUSER := cNome
			SC5->(MsUnlock())
		EndIf

		SC5->(DbCloseArea())
	EndIf
	
Return
