#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CodFor     �Autor  �Microsiga           � Data �  01/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Preenche codigo do Cliente	                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CodCli()
    
    Local aArea := GetArea()
	Local cCodCli := ""
	
	if Inclui
		IF M->A1_CGC == "00000000000000" .OR. M->A1_CGC == "00000000000"   // Eh estrangeiro.
			cCodCli := "EX" + SeqSA1() 
			M->A1_TIPO := "X"                             
			M->A1_EST  := "EX"
		else
			cCodCli := iif(LEN(ALLTRIM(M->A1_CGC)) == 14,SubStr(M->A1_CGC,1,8),SubStr(M->A1_CGC,1,9))
		endif
	Endif

	RestArea(aArea)
	
Return cCodCli 


/*
Retorna a sequencia, quando estrangeiro
*/                              
Static Function SeqSA1() 
	
	Local cRet := ""
	Local _cQry := ""
	Local _nNum := 0                       
	Local nTamAux := TamSX3("A1_COD")[1]-2

	_cQry := " SELECT MAX(SUBSTRING(A1_COD,3,"+Alltrim(Str(nTamAux))+")) CODIGO "
	_cQry += " FROM "+RetSqlName("SA1")+" SA1 "
	_cQry += " WHERE D_E_L_E_T_ <> '*'"
	_cQry += "  AND A1_TIPO = 'X'" //exporta�ao
	_cQry += "  AND SUBSTRING(A1_COD,1,2) = 'EX' "
	
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
