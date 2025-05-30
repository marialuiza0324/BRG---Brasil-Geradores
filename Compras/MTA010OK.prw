#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"
/*
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � MTA010OK   � Autor � Totvs - GO		    � Data � 11/07/08 ���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de Entrada na validacao da inclusao do produto       ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA010OK()

	//Local _aGrvProd := {}
	Private cRetorno := ""
	Private lMsErroAuto := .F.

	if inclui .AND. (Alltrim(M->B1_TIPO) <> "MO" .and. Alltrim(M->B1_TIPO) <> "OI")

		U_RETCODPRO(M->B1_GRUPO,@M->B1_COD)

	EndIf

Return(.t.)

/*
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � RETCODPRO  � Autor � Totvs - GO		    � Data � 11/07/08 ���
��+----------+------------------------------------------------------------���
���Descri��o � Funcao para determinar qual ser� o proximo numero do produ-���
���          � to para o grupo informado                                  ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/   

User Function RETCODPRO(cGrupo,cRetorno)

	Local cAlias := Alias()
	Local cQuery := ''
	Local QAux, nSeq, cRetorno, _cTMS
	Local _nTam, _nTamGrupo  := 0
	Local cCodProd := ''

	_nTam      := 4
	_nTamGrupo := Len(AllTrim(cGrupo))  //TamSX3("B1_GRUPO")[1]//Len(AllTrim(cGrupo))+1

	cQuery := "SELECT MAX(b1_cod) as NSEQUEN "
	cQuery += " FROM "+RetSqlName('SB1')
	cQuery += " WHERE "
	cQuery +=        "D_E_L_E_T_ <> '*' "
	//cQuery +=   " AND B1_FILIAL  =  '"+xfilial("SB1")+"'"
	cQuery +=   " AND B1_GRUPO   =  '"+cGrupo+"'"
	cQuery +=   " AND B1_TIPO NOT IN ('OI','MO') "

	cQuery := Changequery(cQuery)

	TCQUERY cQuery NEW ALIAS "QAux"

	nSeq := Soma1(substr(QAux->NSEQUEN,_nTamGrupo+1,_nTam))
	cCodProd := Alltrim(substr(QAux->NSEQUEN,1,4))
	cRetorno := AllTrim(cGrupo)+PADL(nSeq,_nTam,"0")

	DbSelectArea("SB1")
	DbSetOrder(1)

	While SB1->(!EOF()) .AND. SB1->(MsSeek(FWxFilial("SB1") + cRetorno))

		nSeq := Soma1(substr(cCodProd+nSeq,_nTamGrupo+1,_nTam))

		cRetorno := AllTrim(cGrupo)+PADL(nSeq,_nTam,"0")

		SB1->(DbSkip())
	EndDo

	dbselectarea(cAlias)

	QAux->(dbCloseArea())

	SB1->(DbCloseArea())

Return(cRetorno)
