#include "rwmake.ch"      
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ M020INC    ¦ Autor ¦ Walter Junior	   ¦ Data ¦ 14/02/2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada apos a inclusao do fornecedor preenche    ¦¦¦
¦¦¦          ¦ a tabela CTD - Item Contabil                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ SGL                                                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function M020INC()          

// Inclusao no Item Contabil. //Fornecedor
 
   Dbselectarea("CTD")
   Dbsetorder(1) 
    IF !ctd->(dbseek(xfilial("CTD")+"F"+SA2->(A2_COD+A2_LOJA)))
       RecLock("CTD",.T.)
	   CTD->CTD_FILIAL := xfilial("CTD")
	   CTD->CTD_ITEM   := "F"+SA2->(A2_COD+A2_LOJA)
	   CTD->CTD_DESC01 := SA2->A2_NOME
	   CTD->CTD_CLASSE := "2"
	   CTD->CTD_NORMAL := "1"
	   CTD->CTD_BLOQ   := "2"
	   CTD->CTD_DTEXIS := CtoD("01/01/2010")
	   CTD->CTD_ITLP   := CTD->CTD_ITEM
	   CTD->CTD_CLOBRG := "2"
	   CTD->CTD_ACCLVL := "1"  
	   CTD->CTD_BOOK   := "AUTO"
	   MsUnlock("CTD")
    EndIf

//log de cadastro 

//Somente para a MIX

If cfilant = "0801"
	Dbselectarea("ZA2")
    Dbsetorder(1) 
    IF !ZA2->(dbseek(xfilial("ZA2")+SA2->(A2_COD+A2_LOJA)))
       RecLock("ZA2",.T.)
	   ZA2->ZA2_FILIAL := xfilial("ZA2")
	   ZA2->ZA2_COD    := SA2->A2_COD 
	   ZA2->ZA2_LOJA   := SA2->A2_LOJA
	   ZA2->ZA2_USER   := cusername
	   ZA2->ZA2_DATA   := DDATABASE    
	   MsUnlock("ZA2")
    EndIf
EndIf
 
Return
