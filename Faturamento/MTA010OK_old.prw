#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MTA010OK   ¦ Autor ¦ Totvs - GO		    ¦ Data ¦ 11/07/08 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na validacao da inclusao do produto       ¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
 
User Function MTA010OK()

	Local _aGrvProd := {}
	Private lMsErroAuto := .F.

	if inclui .AND. Alltrim(M->B1_TIPO) <> "OI"
	
		U_RETCODPRO(M->B1_GRUPO,@M->B1_COD)
	
	EndIf

Return(.t.)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ RETCODPRO  ¦ Autor ¦ Totvs - GO		    ¦ Data ¦ 11/07/08 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Funcao para determinar qual será o proximo numero do produ-¦¦¦
¦¦¦          ¦ to para o grupo informado                                  ¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/   

User Function RETCODPRO(cGrupo,cRetorno)

	Local cAlias := Alias()
	Local cQuery := ''
	Local QAux, nSeq, cRetorno, _cTMS
	Local _nTam, _nTamGrupo  := 0

	_nTam      := 4
	_nTamGrupo := Len(AllTrim(cGrupo))  //TamSX3("B1_GRUPO")[1]//Len(AllTrim(cGrupo))+1
         
	cQuery := "SELECT MAX(b1_cod) as NSEQUEN "
	cQuery += " FROM "+RetSqlName('SB1')
	cQuery += " WHERE "
	cQuery +=        "D_E_L_E_T_ <> '*' "
	cQuery +=   " AND B1_FILIAL  =  '"+xfilial("SB1")+"'"
	cQuery +=   " AND B1_GRUPO   =  '"+cGrupo+"'"
	cQuery +=   " AND B1_TIPO   <>  'OI' "
 
	cQuery := Changequery(cQuery)
 
	TCQUERY cQuery NEW ALIAS "QAux"
 
	nSeq := Soma1(substr(QAux->NSEQUEN,_nTamGrupo+1,_nTam))

	QAux->(dbCloseArea())
 
	cRetorno := AllTrim(cGrupo)+PADL(nSeq,_nTam,"0")
    
	dbselectarea(cAlias)

 
Return(cRetorno)