#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'


/*/{Protheus.doc} FSCOM005
    Valida se lote já está
    cadastrado e possui saldo
    na tabela SB8
    @type  Function
    @author Maria Luiza
    @since 16/09/2024
    /*/


User Function FSCOM005()

	Local nPosCod        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"})
	Local cProduto  := Acols[n,nPosCod]
	Local cLote    := Alltrim(M->D1_LOTECTL)
	Local cLocal   := SD1->D1_LOCAL
	Local lRet     := .T.

	//Abrindo a e posicionando no topo
	DbSelectArea("SB8")
	SB8->(DbSetOrder(3))
	SB8->(DbGoTop())

	If SB8->(MsSeek(FWxFilial("SB8")+cProduto+cLocal+ clote))
		If SB8->B8_SALDO > 0 //Valida se lote cadastrado na SB8 possui saldo
			FWAlertInfo("Lote já cadastrado na tabela de saldos","Atenção!")
			lRet :=  .F.
		Else
			lRet := .T.
		EndIf
	EndIf

Return lRet
