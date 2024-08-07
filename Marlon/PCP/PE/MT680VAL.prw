#INCLUDE 'totvs.ch'
#INCLUDE 'protheus.ch'


/*/{Protheus.doc} MT681AIN 

MT680VAL - Inclus�o das Produ��es
� chamado na confirma��o da inclus�o das produ��es PCP, modelo I e II (fun��o A680TudoOk()).
� utilizado para validar a inclus�o do apontamento das produ��es PCP.
Para verificar de qual programa esta chamando a fun��o, utilize as vari�veis Private l680,l681,l682 e l250 a partir da vers�o 6.09.

Tipo de Retorno:
lRet(logico)
Em caso de retorno afirmativo (.T.), permite incluir o apontamento.
Em caso de retorno negativo (.F.), nao permite incluir o apontamento.

Observa��es:
Caso for utilizada a rotina autom�tica do MATA241 - Movimenta��o Interna, pelo ponto de entrada MT680VAL, dever�o ser declaradas as seguintes vari�veis do tipo Private: Private l250, l240, l241 . Conforme exemplo abaixo.


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
			FWAlertInfo("Os campos N� de s�rie do GRUPO, ALTERNADOR e MOTOR s�o obrigat�rios quando selecionada a opera��o M1.", "Aten��o!")
			lRet := .F.
			Exit
		Else
			lRet := .T.
			Exit
		EndIf

	EndDo

	While cOper == "Z1"

		if Empty(cLote) .AND. cLoteCtl ==  "L"
			FWAlertInfo("Preencher o campo LOTE, pois produto possui restreabilidade.","Aten��o!")
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
		FWAlertInfo("Lote j� cadastrado na tabela de saldos","Aten��o!")
		Return .F.
	Else
		Return .T.
	EndIf
Return

/*
Validar apontamento de OP
*/



