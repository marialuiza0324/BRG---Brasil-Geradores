#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} MT410TOK
 Este ponto de entrada � executado ao clicar no bot�o SALVAR
  da rotina de Manuten��o do Pedido de Venda, Ele deve ser 
  utilizado quando se desejar validar a confirma��o das opera��es de 
  inclus�o, altera��o, exclus�o e c�pia do Pedido de Venda.
  Utilizado para excluir amarra��o do PV X OP quando 
  Pedido de venda for exclu�do.
  @type  USER FUNCTION
  @author Maria Luiza
  @since 07/03/2025
/*/
USER FUNCTION MT410TOK()

	Local nOpc  := PARAMIXB[1]	//N�mero referente a op��o de manuten��o que est� sendo utilizada. Ex: 2-Visualiza��o, 3-Inclus�o, 4-Altera��o
	Local cQry := ""
	Local lRet := .T.

	If nOpc == 1

		If Select("TMP1") > 0
			TMP1->(dbCloseArea())
		EndIf

		cQry := "SELECT * FROM " +RetSqlName("SC6")+ " SC6 "
		cQry += "WHERE C6_NUM = " +SC5->C5_NUM+ " "
		cQry += "AND D_E_L_E_T_ = '' "

		DbUseArea(.T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TMP1", .T., .T.)

		DbSelectArea("TMP1")

		While TMP1->(!EOF())
			// Desfazendo a amarra��o na SC6
			dbSelectArea("Z10")
			dbsetorder(4)
			If Z10->(MsSeek(xFilial("Z10") + TMP1->C6_NUM + TMP1->C6_PRODUTO + TMP1->C6_ITEM))
				Reclock("Z10", .F.)
				DbDelete()
				Z10->(MsUnlock())
			EndIf
			TMP1->(DbSkip())
		EndDo

		TMP1->(DbCloseArea())

	EndIf
	

Return lRet

