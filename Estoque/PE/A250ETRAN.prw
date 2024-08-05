#Include "PROTHEUS.CH"  
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

//--------------------------------------------------------------
/*/{Protheus.doc} A250ETRAN
Description

@param xParam Ponto de Entrada para valorizar o Custo do Produto no Apontamento de Produção D3_CUSTO1  
@return xRet BRG
@author  -
@since 28/04/2020
/*/
//--------------------------------------------------------------

User Function A250ETRAN()

Private _OP := SD3->D3_OP
Private _Quant:= SD3->D3_QUANT

RECLOCK("SD3",.F.)
 SD3->D3_CUSTO1 := (SomaVl()/QtdSC2())* _Quant
MSUNLOCK()

Return NIL


Static Function SomaVl()
 
//Verifica se o arquivo TMP está em uso

Local _Custo := ""

If Select("TSDD") > 0
   TSDD->(DbCloseArea())
EndIf
ccQry := " "
ccQry += "SELECT D3_FILIAL, D3_OP, SUM(D3_CUSTO1) Custo "
ccQry += "FROM " + retsqlname("SD3")+" SD3 "
ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
ccQry += "AND D3_FILIAL = '"+xFilial("SD3")+"' "
ccQry += "AND D3_OP = '" + _OP + "' "
ccQry += "AND D3_CF IN ('RE6','RE0') "
ccQry += "AND D3_ESTORNO = '' "
ccQry += "GROUP BY D3_FILIAL, D3_OP "
	
DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TSDD",.T.,.T.) 
	
_Custo := TSDD->Custo	
	
Return _Custo 

Static Function QtdSC2()
 
//Verifica se o arquivo TMP está em uso

Local _QtdSc2 := ""

If Select("TSC2") > 0
   TSC2->(DbCloseArea())
EndIf

cQry := " "
cQry += "SELECT C2_FILIAL, C2_NUM,C2_ITEM, C2_SEQUEN, C2_QUANT "
cQry += "FROM " + retsqlname("SC2")+" SC2 "
cQry += "WHERE SC2.D_E_L_E_T_ <> '*' " 
cQry += "AND C2_FILIAL = '"+xFilial("SC2")+"' "
cQry += "AND C2_NUM = '" + SUBSTR(_OP,1,6) + "' "
cQry += "AND C2_ITEM = '" + SUBSTR(_OP,7,2) + "' "
cQry += "AND C2_SEQUEN = '" + SUBSTR(_OP,9,3) + "' "
 	
DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TSC2",.T.,.T.) 
	
_QtdSc2 := TSC2->C2_QUANT	
	
Return _QtdSc2 
 
 