#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT120F
Responsável pela gravação do Pedido 
de Compras e Autorização de Entrega
Valida a gravação do grupo do produto 
e do solicitante 
@type  Function
@author Maria Luiza
@since 10/01/2025 */

User Function MT120F() 

Local cPedido  :=  PARAMIXB
Local cUser := ""
Local cGrupo := ""
Local cUserWeb := ""


    dBselectArea('SC7') 
    dbSetOrder(1)

    If SC7->(MsSeek(cPedido))

        cUserWeb := Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"C1_XSOLWEB")
        cUser := Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"SC1->C1_USER")
        cGrupo := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"SB1->B1_GRUPO")

            If !Empty(cUserWeb)
                    RecLock("SC7", .F.)

                    SC7->C7_CODSOL := cUserWeb
                    SC7->C7_GRUPO  := cGrupo

                    SC7->(MsUnlock())

                ElseIf !Empty(cUser)
                    RecLock("SC7", .F.)

                    SC7->C7_CODSOL := cUser
                    SC7->C7_GRUPO  := cGrupo

                    SC7->(MsUnlock())
                Else 
                    RecLock("SC7", .F.)

                    SC7->C7_CODSOL := RetCodUsr()
                    SC7->C7_GRUPO  := cGrupo

                    SC7->(MsUnlock())

                EndIf
    
    EndIf

Return
