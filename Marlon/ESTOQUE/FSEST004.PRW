#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/* 
   Função: FSEST004
   Objetivo: Retorna o endereço com maior saldo disponível que consiga atender 
             a quantidade solicitada de uma única vez (ou o mais próximo possível)
   Parâmetros:
      cProduto   - Código do produto (B1_COD)
      cArmazem   - Armazém desejado (ex: "01")
      nQtdSolic  - Quantidade solicitada na SA / baixa / separação
   Retorno:
      String com o endereço (BF_LOCALIZ) ou vazio se não encontrar nenhum com saldo suficiente
*/
User Function FSEST004( cProduto, cArmazem, nQtdSolic )

	Local aArea      := GetArea()
	Local cQuery     := ""
	Local cEndRet    := ""
	Local nMaiorQtd  := 0

	If Funname() <> "MNTA420"

		If Empty(cArmazem)
			cArmazem := "01"

		EndIf

		If nQtdSolic == 0
			nQtdSolic := 0
		EndIf

		If Empty(cProduto) .Or. nQtdSolic <= 0
			RestArea(aArea)
			Return ""
		EndIf


		If Select("TSBF") > 0
			TSBF->(DbCloseArea())
		EndIf

		cQuery := "SELECT TOP 1 BF_LOCALIZ, BF_QUANT "
		cQuery += "FROM " + RetSqlName("SBF") + " SBF "
		cQuery += "WHERE SBF.D_E_L_E_T_ = '' "
		cQuery += "  AND SBF.BF_FILIAL  = '" + xFilial("SBF") + "' "
		cQuery += "  AND SBF.BF_PRODUTO = '" +cProduto + "' "
		cQuery += "  AND SBF.BF_LOCAL   = '" + cArmazem + "' "
		cQuery += "  AND SBF.BF_QUANT   >= '" + cValtoChar(nQtdSolic) + "' "
		cQuery += "ORDER BY SBF.BF_QUANT DESC "

		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TSBF",.T.,.T.)

		If TSBF->(!Eof())
			cEndRet   := TSBF->BF_LOCALIZ
			nMaiorQtd := TSBF->BF_QUANT
		EndIf

		TSBF->(DbCloseArea())

		// Caso não tenha encontrado endereço com saldo >= solicitado,
		// você pode decidir se quer buscar o de maior saldo mesmo assim (opcional)
		If Empty(cEndRet)

			If Select("TSBF") > 0
				TSBF->(DbCloseArea())
			EndIf

			cQuery := "SELECT TOP 1 BF_LOCALIZ, BF_QUANT "
			cQuery += "FROM " + RetSqlName("SBF") + " SBF "
			cQuery += "WHERE SBF.D_E_L_E_T_ = '' "
			cQuery += "  AND SBF.BF_FILIAL  = '" + xFilial("SBF") + "' "
			cQuery += "  AND SBF.BF_PRODUTO = '" + PadR(cProduto, TamSX3("B1_COD")[1]) + "' "
			cQuery += "  AND SBF.BF_LOCAL   = '" + PadR(cArmazem, TamSX3("BF_LOCAL")[1]) + "' "
			cQuery += "  AND SBF.BF_QUANT   > 0 "
			cQuery += "ORDER BY SBF.BF_QUANT DESC "

			DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TSBF",.T.,.T.)

			If TSBF->(!Eof())
				cEndRet := TSBF->BF_LOCALIZ
			EndIf

			TSBF->(DbCloseArea())
		EndIf

		RestArea(aArea)
	EndIF

Return cEndRet
