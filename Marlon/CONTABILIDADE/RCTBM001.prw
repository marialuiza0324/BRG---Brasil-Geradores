#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTBM001 บ Autor ณ Walter	        บ Data ณ  20/05/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa que refaz a tabela CTD - Item contabil, percorre aบฑฑ
ฑฑบ          ณ tabela de cliente e fornecedor incluindo os mesmos.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SGL/FAG                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
//ESPECIFICO SEMENTES GOIAS - WALTER 20/05/14

User Function RCTBM001()
Local cQry := ''

if msgyesno("Confirma o Reprocessamento dos Itens Contabeis?")
cQry := "DELETE FROM "+RetSqlName("CTD") + " Where CTD_BOOK  = 'AUTO' "
TCSqlExec(cQry)
TCSqlExec("commit")
Processa({|| RunItem() },"Processando item...")
endif
Return()

Static Function RunItem()
// Busca os codigos de Clientes e Fornecedores nas tabelas SA1 e SA2
//cQry := "SELECT DISTINCT 'B'||A6_COD AS CODIGO,"
cQry := "SELECT DISTINCT 'B'||A6_COD||A6_NUMCON AS CODIGO,"
cQry +=       " A6_NOME NOME,"
cQry +=       " 'SA6' XALIAS,"
cQry +=       " R_E_C_N_O_ XRECNO"
cQry +=  " FROM "+RetSqlName("SA6")
cQry += " WHERE A6_FILIAL  <> '  '"
cQry +=   " AND D_E_L_E_T_ = ' '"
cQry +=  "UNION "
cQry += "SELECT DISTINCT 'C'||A1_COD||A1_LOJA AS CODIGO,"
cQry +=       " A1_NOME NOME,"
cQry +=       " 'SA1' XALIAS,"
cQry +=       " R_E_C_N_O_ XRECNO"
cQry +=  " FROM "+RetSqlName("SA1")
cQry += " WHERE A1_FILIAL  <> '  '"
cQry +=   " AND D_E_L_E_T_ = ' '"
cQry +=  "UNION "
cQry += "SELECT DISTINCT 'F'||A2_COD||A2_LOJA AS CODIGO,"
cQry +=       " A2_NOME NOME,"
cQry +=       " 'SA2' XALIAS,"
cQry +=       " R_E_C_N_O_ XRECNO"
cQry +=  " FROM "+RetSqlName("SA2")
cQry += " WHERE A2_FILIAL  <> '  '"
cQry +=   " AND D_E_L_E_T_ = ' '"
cQry +=   " AND A2_COD NOT IN ('UNIAO','ESTADO','MUNIC','INPS','99999999')"
cQry += " ORDER BY CODIGO"        
cQry := ChangeQuery(cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'QRY', .F., .T.)
QRY->(dbGoTop())
CTD->(dbSetOrder(1))

While !QRY->(Eof())
    
	If !CTD->(dbSeek(xFilial('CTD')+QRY->CODIGO))      
		dbSelectArea("CTD")
		If RecLock("CTD",.T.)
			CTD->CTD_FILIAL := xFilial("CTD")
			CTD->CTD_ITEM   := SUBSTR(QRY->CODIGO,1,16)
			CTD->CTD_DESC01 := QRY->NOME
			CTD->CTD_CLASSE := "2"
			CTD->CTD_NORMAL := IF(SUBSTR(QRY->CODIGO,1,1)=="F","1","2")
			CTD->CTD_BLOQ   := "2"
			CTD->CTD_DTEXIS := CtoD("01/01/2008")
			CTD->CTD_ITLP   := CTD->CTD_ITEM
			CTD->CTD_CLOBRG := "2"
			CTD->CTD_ACCLVL := "1"
			CTD->CTD_BOOK   := "AUTO"
			MsUnlock("CTD")
		EndIf
	EndIf
	QRY->(dbSkip())
EndDo
  QRY->(dbCloseArea())
Return
