//Bibliotecas
#Include "TOTVS.ch"
#INCLUDE "topconn.ch"
#include "fwmvcdef.ch"

/*/{Protheus.doc} User Function MTA410I
Está localizado na rotina de gravação do pedido, A410GRAVA(). 
É executado durante a gravação do pedido, após a atualização de cada item.
@type  Function
@author Maria Luiza
@since 12/11/2024
/*/

User Function MTA410I()

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
