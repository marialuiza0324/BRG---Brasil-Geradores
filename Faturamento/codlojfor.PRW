#include "Protheus.ch"

User Function codloj()

Local nCount := 00
Local cCodLoj := ""
Local cCod := M->A2_COD
Local cTipo := M->A2_TIPO
Local nRecNo   := SA2->( Recno() )
Local aAreaSA2 := SA2->(GetArea())

Dbselectarea ("SA2")
Dbsetorder(1)

If cTipo == "F" .AND. SA2->(DbSeek( xFilial("SA2")+cCod ))
	
	While SA2->(!EOF() ) .AND. SA2->A2_FILIAL+SA2->A2_COD == xFilial("SA2")+cCod
		
	    nCount++
	    		
		SA2->(dbSkip())
		
	Enddo                       
		
	cCodLoj := StrZero(++nCount, TamSX3("A2_LOJA")[1])

Else
	
	cCodLoj := StrZero(01, TamSX3("A2_LOJA")[1] )
	
	If cTipo == "J" .AND. !empty(M->A2_CGC)
		
		//cCodLoj:=IIF(LEN(ALLTRIM(M->A2_CGC)) == 14, SUBSTR(ALLTRIM(M->A2_CGC),13,2),SUBSTR(ALLTRIM(M->A2_CGC),10,2))
		cCodLoj:= SubStr(M->A2_CGC,9,4)
		
	Endif
	
Endif

DbGoTop()

RestArea(aAreaSA2)

Return(cCodLoj)



