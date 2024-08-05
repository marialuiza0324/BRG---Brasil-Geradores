#Include "PROTHEUS.CH"  
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
//--------------------------------------------------------------
/*/{Protheus.doc} 
Description

@param xParam Atualizar a SD3
@return xRet Perlen
@author  -
@since 27/08/2019
/*/
//--------------------------------------------------------------

User Function AtuaSD3() //U_AtuaSD3()
//Local dData    :=  ParamIxb[1]
//Local dDataFec :=  ParamIxb[2] 
Local dDataFec :=  dDatabase

IF __cUserID <> "000000"
   MSGINFO("Usuário não Autorizado !!!!!"," Atenção ") 
   Return
EndIf

If Select("QSD3") > 0
	QSD3->(dbCloseArea())
EndIf

cQry := "SELECT D3_FILIAL, D3_TM, D3_COD, D3_UM, D3_QUANT, B9_CM1,D3_LOCAL, D3_CUSTO1, D3_EMISSAO, D3_DOC, D3_NUMSEQ "
cQry += "(ISNULL((SELECT ISNULL(SUM(D1_CUSTO),0) FROM " + retsqlname("SD1")+" SD1 WHERE D3_FILIAL = D1_FILIAL  AND D1_COD = D3_COD AND YEAR(D1_DTDIGIT) = '2021' AND MONTH(D1_DTDIGIT) = '05' AND SD1.D_E_L_E_T_ <> '*'),0)) AS Custo_Total, "
cQry += "(ISNULL((SELECT ISNULL(SUM(D1_QUANT),0) FROM " + retsqlname("SD1")+" SD1 WHERE D3_FILIAL = D1_FILIAL  AND D1_COD = D3_COD AND YEAR(D1_DTDIGIT) = '2021' AND MONTH(D1_DTDIGIT) = '05' AND SD1.D_E_L_E_T_ <> '*'),0)) AS  Quant"
cQry += "FROM " + retsqlname("SD3")+" SD3 " 
cQry += "LEFT JOIN " + retsqlname("SB9")+" SB9 ON B9_FILIAL = D3_FILIAL AND B9_COD = D3_COD AND B9_LOCAL = D3_LOCAL AND YEAR(B9_DATA) = '2021' AND MONTH(B9_DATA) = '04' AND SB9.D_E_L_E_T_ <> '*' "  
cQry += "WHERE SD3.D_E_L_E_T_ <> '*' "
cQry += "AND   SD3.D3_FILIAL = '" + cFilAnt + "' "
cQry += "AND   SD3.D3_EMISSAO BETWEEN '20210531' AND '20210501' "    
cQry += "AND   SD3.D3_COD = 'D0000198' "
cQry += "ORDER BY D3_FILIAL,D3_COD,D3_UM,D3_LOCAL,D3_TM, D3_EMISSAO "  //D0000198       

cQry := ChangeQuery(cQry)
TcQuery cQry New Alias "QSD3"

ProcRegua(QSD3->(RecCount()))
DbSelectArea("QSD3")
DBGOTOP()
DO WHILE QSD3->(!EOF())
/*
	IncProc()    	
	DbSelectArea("SD3")
	DbSetOrder(3)  
	If DbSeek(xFilial("SD3")+QSD3->D3_COD+QSD3->D3_LOCAL+QSD3->D3_NUMSEQ)
		SD3->(RECLOCK("SD3",.F.))
		SD3->D3_CUSTO1  := ROUND((QSD3->B9_CM1*SD3->D3_QUANT),4) 
		SD3->(MSUNLOCK())
		SD3->(dbSkip())
	EndIF  
*/
	QSD3->(dbSkip())
ENDDO 
MSGINFO("Alteração feita na SD3 "," Atenção ") 

Return    
