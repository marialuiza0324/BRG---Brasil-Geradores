#include "PROTHEUS.CH"
#include "topconn.ch"
//Valida a Exclusão da Nota Fiscal, mediante a autorização da Contabilidade  
//24/01/2023
//3RL Soluções
//BRG

User Function MT103EXC() 
Local lRet   := .T.
Local _Fil   := xFilial("SF1")
Local _Key   := xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
//Local _Entr  := SF1->F1_DTDIGIT
//Local _Fecha := GetMv("MV_ULMES")
//Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario

If Select("TMP1") > 0
	TMP1->(dbCloseArea())
EndIf

_cQry := " " 
_cQry += "SELECT  CT2_KEY  "  
_cQry += "FROM " + retsqlname("CT2")+" CT2 "
_cQry += "WHERE CT2.D_E_L_E_T_ <> '*' " 
_cQry += "AND CT2_FILIAL = '" + _Fil + "'
_cQry += "AND CT2_KEY LIKE '" + _Key + "%'

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP1"

If !Empty(TMP1->CT2_KEY)
   lRet := .F.     
  MsgAlert("Exclusão não Permitida, Procure a Contabilidade","ATENCAO")
EndIf  

Return lRet
