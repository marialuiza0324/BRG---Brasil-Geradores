#INCLUDE 'totvs.ch'
#INCLUDE 'protheus.ch'

/*Valida se lote digitado está cadastrado e 
possui saldo na tabela SB8
Função chamada pelo campo H6_LOTECTL

@type user function
@author Maria Luiza
@since 03/08/2024 */


User Function ValidaLote()

	Local cProduto  := M->H6_PRODUTO
	Local cLote    := M->H6_LOTECTL

	//Abrindo a e posicionando no topo
	DbSelectArea("SB8")
	SB8->(DbSetOrder(5))
	SB8->(DbGoTop())

	If SB8->(MsSeek(FWxFilial("SB8")+ cProduto + clote)) .AND. SB8->B8_SALDO > 0 //Valida se lote cadastrado na SB8 possui saldo 
		FWAlertInfo("Lote já cadastrado na tabela de saldos","Atenção!")
		Return .F.
	Else
		Return .T.
	EndIf
Return
