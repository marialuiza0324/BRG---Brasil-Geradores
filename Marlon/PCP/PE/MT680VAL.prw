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
)
/*/

/*Ajuste 07/08/2024 - Autora: Maria Luiza - Solicitante: Bruno Martins 
- se houver pendência de baixa de produtos não pode ser permitido apontamento;
- em caso de devolução de produto (via movimentação múltipla), o produto só 
deve ser movimentado após confirmação de que ele realmente está dentro da OP.*/

User Function MT680VAL()

	Local lRet      := .T.
	Local cOper     := M->H6_OPERAC
	Local cGrupo    := Alltrim(M->H6_XGRUPO)
	Local cAlter    := Alltrim(M->H6_XALTERN)
	Local cMotor    := Alltrim(M->H6_XMOTOR)
	Local cLoteCtl  := Posicione('SB1', 1, FWxFilial('SB1') + M->H6_PRODUTO, 'B1_RASTRO')
	Local cLote     := M->H6_LOTECTL
	Local cOp       := Alltrim(M->H6_OP)
	Local cQuery    := ""
	Local cQry      := ""
	Local cMensagem := ""
	Local nTotal1   := 0
	Local nTotal2   := 0
	Local nValid    := 0
	Local lValida   := .F.


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
		lValida := .T.
			Exit
		Else
			lRet := .T.
			Exit
		Endif
	EndDo

	If Select("TSCP") > 0
		TSCP->(dbCloseArea())
	EndIf

	cQuery := "SELECT COUNT(CP_FILIAL) AS TOTAL_SA FROM SCP010 SCP "
	cQuery += "WHERE SCP.D_E_L_E_T_ <> '*' "
	cQuery += "AND SCP.CP_PREREQU = 'S' "
	cQuery += "AND SCP.CP_STATUS <> 'E' "
	cQuery += "AND SCP.CP_QUANT <> SCP.CP_QUJE "
	cQuery += "AND SCP.CP_OP = '"+cOp+"' "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TSCP",.T.,.T.)

	DbSelectArea("TSCP") //query retorna se existe título na SE2 com chave informada

	nTotal1 := TSCP->TOTAL_SA

	If  nTotal1 > 0
		nValid += nTotal1
		cMensagem += '<font color="red"><b>'+cValtochar(nTotal1)+'</b></font> Solicitações manuais ou geradas por firmamento de OP pendentes de baixa!!!' +CHR(13)
	EndIf

	TSCP->(DbCloseArea())

	If Select("TSD4") > 0
		TSD4->(dbCloseArea())
	EndIf

	cQry := "SELECT COUNT(D4_FILIAL) AS TOTAL FROM SD4010 SD4 "
	cQry += "WHERE SD4.D_E_L_E_T_ <> '*' "
	cQry += "AND SD4.D4_OP = '"+cOp+"' "
	cQry += "AND SD4.D4_QUANT > 0 "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TSD4",.T.,.T.)

	DbSelectArea("TSD4") //query retorna se existe título na SE2 com chave informada

	nTotal2 := TSD4->TOTAL

	If  nTotal2 > 0
		nValid += nTotal2
		cMensagem += 'Ordem de Produção possui <font color="red"><b>'+cValtochar(nTotal2)+'</b></font> empenhos em aberto ou Parcialmente Baixado!!!' +CHR(13)
	EndIf

	TSD4->(DbCloseArea())


	If nValid > 0 
		lRet := .F.
	EndIf

	if lValida = .T. 
	cMensagem += 'Preencher o campo LOTE, pois produto possui restreabilidade.'
	lRet := .F.
	EndIf

	If cMensagem <> ""
		FWAlertInfo(cMensagem,"Atenção!!!")
	EndIf

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
Validar apontamento de OP (Testando envio de informações simultaneas com a Maria) Teste
*/


