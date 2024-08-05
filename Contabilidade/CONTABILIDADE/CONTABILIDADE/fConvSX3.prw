#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "Protheus.ch"
#Include "ParmType.ch"

Static cEol := Chr(13)+Chr(10)

/*Exemplos:
u_fConvSX3("SA1",)
u_fConvSX3(,"('A1_COD',A1_LOJA)")
u_fConvSX3("SA1","('A1_COD',A1_LOJA)")*/

User Function fConvSX3(cTabela,cCampos)

	Local cQry := ""
	Default cTabela := ""
	Default cCampos := ""

	cQry += " SELECT 										" + cEol
	cQry += " X3_ARQUIVO 	AS ARQUIVO,						" + cEol
	cQry += " X3_ORDEM 		AS ORDEM,						" + cEol
	cQry += " X3_TITULO 	AS TITULO, 						" + cEol
	cQry += " X3_CAMPO 		AS CAMPO, 						" + cEol
	cQry += " X3_PICTURE 	AS PICTURE, 					" + cEol
	cQry += " X3_TAMANHO 	AS TAMANHO, 					" + cEol
	cQry += " X3_DECIMAL 	AS XDECIMAL,					" + cEol
	cQry += " X3_VALID 		AS XVALID, 						" + cEol
	cQry += " X3_USADO 		AS USADO, 						" + cEol
	cQry += " X3_TIPO 		AS TIPO, 						" + cEol
	cQry += " X3_F3 		AS F3, 							" + cEol
	cQry += " X3_CONTEXT 	AS CONTEXT, 					" + cEol
	cQry += " X3_CBOX 		AS CBOX, 						" + cEol
	cQry += " X3_NIVEL 		AS NIVEL, 						" + cEol
	cQry += " X3_RELACAO 	AS RELACAO						" + cEol
	cQry += " FROM " + RetSqlName("SX3") + " TBL 			" + cEol
	cQry += " WHERE TBL.D_E_L_E_T_ = ' ' 					" + cEol

	if !Empty(AllTrim(cTabela))

		cQry += " AND X3_ARQUIVO = '"+AllTrim(cTabela)+"'	" + cEol

	endif

	if !Empty(AllTrim(cCampos))

		cQry += " AND X3_CAMPO IN "+AllTrim(cCampos)+"	 	" + cEol

	endif

	cQry += " ORDER BY X3_ORDEM 							" + cEol

	if Select("TRB") > 0

		TRB->(DbCloseArea())

	endif

	TcQuery cQry New Alias "TRB"

	TRB->(DbSelectArea("TRB"))
	TRB->(DbGoTop())

Return(!TRB->(Eof()))

User Function ULogMsg(cMsg)

	Default cMsg 	:= ""

	LogMsg(FunName(), 22, 5, 1, '', '', cMsg)

Return()

User Function fConvSX1(cGrupo)
	
	Local cQry 		:= ""
	Default cGrupo  := ""
	
	cQry += " SELECT 									" + cEol
	cQry += " X1_GRUPO AS GRUPO ,						" + cEol
	cQry += " X1_VAR01 AS XVAR							" + cEol
	cQry += " FROM " + RetSqlName("SX1") + " TBL 		" + cEol
	cQry += " WHERE TBL.D_E_L_E_T_ = ' ' 				" + cEol
	
	if !Empty(AllTrim(cGrupo))
	
		cQry += " AND X1_GRUPO = '"+AllTrim(cGrupo)+"' 	" + cEol
	
	endif
	
	cQry += " ORDER BY X1_ORDEM 						" + cEol	
	
	if Select("TRB") > 0

		TRB->(DbCloseArea())

	endif

	TcQuery cQry New Alias "TRB"

	TRB->(DbSelectArea("TRB"))
	TRB->(DbGoTop())
	
Return(!TRB->(Eof()))

User Function fConvSIX(cTabela)
	
	Local cQry 		:= ""
	Default cTabela := ""

	cQry += " SELECT * 									" + cEol
	cQry += " FROM " + RetSqlName("SIX") + " TBL 		" + cEol
	cQry += " WHERE TBL.D_E_L_E_T_ = ' ' 				" + cEol
	
	if !Empty(AllTrim(cTabela))
	
		cQry += " AND INDICE = '"+AllTrim(cTabela)+"' 	" + cEol
	
	endif
	
	cQry += " ORDER BY ORDEM 							" + cEol	
	
	if Select("TRB") > 0

		TRB->(DbCloseArea())

	endif

	TcQuery cQry New Alias "TRB"

	TRB->(DbSelectArea("TRB"))
	TRB->(DbGoTop())
	
Return(!TRB->(Eof()))

User Function fConvSX5(cTabela,cChave)
	
	Local cQry 		:= ""
	Default cTabela := ""
	Default cChave 	:= ""

	cQry += " SELECT 										" + cEol
	cQry += " X5_TABELA AS TABELA ,							" + cEol
	cQry += " X5_CHAVE 	AS CHAVE ,							" + cEol 
	cQry += " X5_DESCRI AS DESCRICAO 						" + cEol
	cQry += " FROM " + RetSqlName("SX5") + " TBL 			" + cEol
	cQry += " WHERE TBL.D_E_L_E_T_ = ' ' 					" + cEol
	cQry += " AND X5_FILIAL = '"+xFilial("SX5")+"' 			" + cEol
	
	if !Empty(AllTrim(cTabela))
	
		cQry += " AND X5_TABELA = '"+AllTrim(cTabela)+"' 	" + cEol
	
	endif
	
	if !Empty(AllTrim(cChave))
	
		cQry += " AND X5_CHAVE = '"+AllTrim(cChave)+"' 		" + cEol
	
	endif
	
	cQry += " ORDER BY X5_CHAVE 							" + cEol	
	
	if Select("TRB") > 0

		TRB->(DbCloseArea())

	endif

	TcQuery cQry New Alias "TRB"

	TRB->(DbSelectArea("TRB"))
	TRB->(DbGoTop())
	
Return(!TRB->(Eof()))