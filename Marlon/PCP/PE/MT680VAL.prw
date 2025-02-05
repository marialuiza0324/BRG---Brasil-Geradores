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
)
/*/

/*Ajuste 07/08/2024 - Autora: Maria Luiza - Solicitante: Bruno Martins 
- se houver pend�ncia de baixa de produtos n�o pode ser permitido apontamento;
- em caso de devolu��o de produto (via movimenta��o m�ltipla), o produto s� 
deve ser movimentado ap�s confirma��o de que ele realmente est� dentro da OP.*/

User Function MT680VAL()

	Local lRet      := .T.
	Local cOper     := M->H6_OPERAC
	Local cGrupo    := Alltrim(M->H6_XGRUPO)
	//Local cAlter    := Alltrim(M->H6_XALTERN)
	//Local cMotor    := Alltrim(M->H6_XMOTOR)
	Local cLoteCtl  := Posicione('SB1', 1, FWxFilial('SB1') + M->H6_PRODUTO, 'B1_RASTRO')
	Local cLote     := M->H6_LOTECTL
	Local cOp       := Alltrim(M->H6_OP)
	Local cQuery    := ""
	Local cQry      := ""
	Local cMensagem := ""
	Local nTotal1   := 0
	Local nTotal2   := 0
	Local nValid    := 0
	Local lCampo := .T.
	Local lLote  := .T.


		While  cOper == 'M1'

			IF empty(cGrupo) //.OR. empty(cAlter) .OR. empty(cMotor)
				FWAlertInfo("O campo N� de s�rie do GRUPO � obrigat�rio quando selecionada a opera��o M1.", "Aten��o!")
				lCampo := .F.
				lRet := .F.
				Exit
			Else
				lCampo := .T.
				Exit
			EndIf

		EndDo

	If cOper == "Z1"  .AND. M->H6_PT = "T"

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

		DbSelectArea("TSCP") 

		nTotal1 := TSCP->TOTAL_SA

		If  nTotal1 > 0
			nValid += nTotal1
			cMensagem += '<font color="red"><b>'+cValtochar(nTotal1)+'</b></font> Solicita��es manuais ou geradas por firmamento de OP pendentes de baixa!!!' +CHR(13)
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

		DbSelectArea("TSD4") 

		nTotal2 := TSD4->TOTAL

		If  nTotal2 > 0
			nValid += nTotal2
			cMensagem += 'Ordem de Produ��o possui <font color="red"><b>'+cValtochar(nTotal2)+'</b></font> empenhos em aberto ou Parcialmente Baixado!!!' +CHR(13)
		EndIf

		TSD4->(DbCloseArea())

		If Empty(cLote) .AND. cLoteCtl ==  "L"
			FWAlertInfo("Preencher o campo LOTE, pois produto possui restreabilidade", "Aten��o !!!")
			lLote := .F.
			lRet := .F.
		Else
			lLote := .T.
		Endif

		If cMensagem <> ""
			FWAlertInfo(cMensagem,"Aten��o!!!")
		EndIf
	EndIf

	If nTotal1 > 0 .OR. nTotal2 > 0 .OR. !lCampo .OR. !lLote 
			lRet := .F.
	Else
			lRet := .T.
	EndIf

Return lRet

/*
Validar apontamento de OP (Testando envio de informa��es simultaneas com a Maria) Teste
*/


