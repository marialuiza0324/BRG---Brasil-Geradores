#INCLUDE 'totvs.ch'
#INCLUDE 'protheus.ch'


/*/{Protheus.doc} MT681AIN 

MT680VAL - Inclusão das Produções
É chamado na confirmação da inclusão das produções PCP, modelo I e II (função A680TudoOk()).
É utilizado para validar a inclusão do apontamento das produções PCP.
Para verificar de qual programa esta chamando a função, utilize as variáveis Private l680,l681,l682 e l250 a partir da versão 6.09.

Tipo de Retorno:
lRet(logico)
Em caso de retorno afirmativo (.T.), permite incluir o apontamento.
Em caso de retorno negativo (.F.), nao permite incluir o apontamento.

Observações:
Caso for utilizada a rotina automática do MATA241 - Movimentação Interna, pelo ponto de entrada MT680VAL, deverão ser declaradas as seguintes variáveis do tipo Private: Private l250, l240, l241 . Conforme exemplo abaixo.


@type user function
@author Maria Luiza
@since 05/06/2024
@version 0.0001
@example
(examples)
@see (
    https://tdn.totvs.com/pages/releaseview.action?pageId=330837624
)
/*/
User Function MT680VAL()

	Local lRet      := .T.
	Local cOper     := M->H6_OPERAC
	Local cGrupo    := Alltrim(M->H6_XGRUPO)
	Local cAlter    := Alltrim(M->H6_XALTERN)
	Local cMotor    := Alltrim(M->H6_XMOTOR)
	Local cLoteCtl  := Posicione('SB1', 1, FWxFilial('SB1') + M->H6_PRODUTO, 'B1_RASTRO')
	Local cLote     := M->H6_LOTECTL

	While  cOper == 'M1'

		IF empty(cGrupo) .OR. empty(cAlter) .OR. empty(cMotor)
			FWAlertInfo("Os campos Nº de série do GRUPO, ALTERNADOR e MOTOR são obrigatórios quando selecionada a operação M1.", "Atenção!")
			lRet := .F.
			Exit
		Else
			lRet := .T.
			Exit
		EndIf

	EndDo

	While cOper == "Z1"

		if Empty(cLote) .AND. cLoteCtl ==  "L"
			FWAlertInfo("Preencher o campo LOTE, pois produto possui restreabilidade.","Atenção!")
			lRet := .F.
			Exit
		Else
			lRet := .T.
			Exit
		Endif
	EndDo


Return lRet

User Function ValidaLote()  

	Local cProduto  := M->H6_PRODUTO
	Local cLote    := M->H6_LOTECTL

	//Abrindo a e posicionando no topo
	DbSelectArea("SB8")
	SB8->(DbSetOrder(5))
	SB8->(DbGoTop())

	If SB8->(MsSeek(FWxFilial("SB8")+ cProduto + clote))
		FWAlertInfo("Lote já cadastrado na tabela de saldos","Atenção!")
		Return .F.
	Else
		Return .T.
	EndIf
Return

/*
Validar apontamento de OP
*/



