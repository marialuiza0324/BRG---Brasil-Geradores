#INCLUDE "Protheus.ch"     
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CodFor     ºAutor  ³Microsiga           º Data ³  01/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preenche codigo do Fornecedor                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CodFor()
    
	Local cCodFor := ""
	Local aArea := GetArea()
	
	if Inclui
		IF M->A2_CGC == "00000000000000" .OR. M->A2_CGC == "00000000000"   // Eh estrangeiro.
			cCodFor := "EX" + SeqSA2() 
			M->A2_TIPO := "X"                             
			M->A2_EST  := "EX"
		else
		 	cCodFor := iif(LEN(ALLTRIM(M->A2_CGC)) == 14,SubStr(M->A2_CGC,1,8),SubStr(M->A2_CGC,1,9))
	 	endif
	Endif
	
	RestArea(aArea)
	
Return cCodFor 
              
/*
Retorna a sequencia, quando estrangeiro
*/                              
Static Function SeqSA2() 
	
	Local cRet := ""
	Local _cQry := ""
	Local _nNum := 0                       
	Local nTamAux := TamSX3("A2_COD")[1]-2

	_cQry := " SELECT MAX(SUBSTRING(A2_COD,3,"+Alltrim(Str(nTamAux))+")) CODIGO "
	_cQry += " FROM "+RetSqlName("SA2")+" SA2 "
	_cQry += " WHERE D_E_L_E_T_ <> '*'"
	_cQry += "  AND A2_TIPO = 'X'" //exportaçao
	_cQry += "  AND SUBSTRING(A2_COD,1,2) = 'EX' "
	
	_cQry := ChangeQuery(_cQry) //comando para evitar erros de incompatibilidade de bancos
	
	if Select("QUERY") > 0
		QUERY->(dbCloseArea())
	endif
	                                                                               
	TCQUERY _cQry NEW ALIAS "QUERY"
	
	dbSelectArea("QUERY") 
	QUERY->(dbGoTop())
	
	_nNum := val(QUERY->CODIGO) + 1                                         
	
	QUERY->(dbCloseArea())
	
	cRet := StrZero(_nNum,nTamAux)
	
Return cRet