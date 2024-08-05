#include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CODLOJCLI ºAutor  ³Microsiga           º Data ³  12/16/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ faz preenchimento do campo loja a partir do CGC.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function codloj2()

Local nCount := 00
Local cCodLoj := ""
Local cCod := M->A1_COD
Local cTipo := M->A1_PESSOA
Local nRecNo   := SA1->( Recno() )
Local aAreaSA1 := SA1->(GetArea())

if INCLUI
    
	if empty(M->A1_COD)
		cCodLoj := "  "
	else
	
		Dbselectarea ("SA1")
		Dbsetorder(1)
		
		if M->A1_TIPO == "X" //se estrangeiro
			cCodLoj := StrZero(01, TamSX3("A1_LOJA")[1] ) //sempre 01
		else
			If cTipo == "F" .AND. SA1->(DbSeek( xFilial("SA1")+cCod ))
				
				While SA1->(!EOF() ) .AND. SA1->A1_FILIAL+SA1->A1_COD == xFilial("SA1")+cCod
				    nCount++
					SA1->(dbSkip())
				Enddo                       
					
				cCodLoj := StrZero(++nCount, TamSX3("A1_LOJA")[1])
			
			Else
				
				cCodLoj := StrZero(01, TamSX3("A1_LOJA")[1] )
				
				If cTipo == "J" .AND. !empty(M->A1_CGC)
					//cCodLoj:=IIF(LEN(ALLTRIM(M->A1_CGC)) == 14, SUBSTR(ALLTRIM(M->A1_CGC),13,2),SUBSTR(ALLTRIM(M->A1_CGC),10,2))
					cCodLoj:= SubStr(M->A1_CGC,9,4) 
				Endif
				
			Endif
		endif
		
	endif
endif

SA1->(DbGoTop())

RestArea(aAreaSA1)

Return(cCodLoj)



