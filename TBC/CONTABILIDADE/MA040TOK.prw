#include "rwmake.ch"  
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MA040TOK   ¦ Autor ¦ Claudio Ferreira    ¦ Data ¦ 29/04/15 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada apos a inclusao do vendedor preenche      ¦¦¦
¦¦¦          ¦ a tabela CTD - Item Contabil                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MA040TOK()                       

// Inclusao no Item Contabil. //Vendedor
Dbselectarea("CTD")
Dbsetorder(1)
IF CTD->(Dbseek(xFilial("CTD")+"V"+SA3->A3_COD))
	_lGrv :=.f.
ELSE
	_lGrv :=.t.
ENDIF

If RecLock("CTD",_lGrv)
	CTD->CTD_FILIAL := xFilial("CTD")
	CTD->CTD_ITEM   := "V"+SA3->A3_COD
	CTD->CTD_DESC01 := SA3->A3_NOME
	CTD->CTD_CLASSE := "2"
	CTD->CTD_NORMAL := "2"
	CTD->CTD_BLOQ   := "2"
	CTD->CTD_DTEXIS := CtoD("01/01/2012")
	CTD->CTD_ITLP   := CTD->CTD_ITEM
	CTD->CTD_CLOBRG := "2"
	CTD->CTD_ACCLVL := "1"
	CTD->CTD_BOOK   := "AUTO2"
	MsUnlock("CTD")
EndIf

Return