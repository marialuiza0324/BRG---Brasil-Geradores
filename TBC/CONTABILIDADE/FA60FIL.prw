#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ FA60FIL      ¦ Autor ¦ Claudio Ferreira¦ Data ¦ 02/01/2019 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de entrada na seleção da Transf de titulos a receber ¦¦¦
¦¦¦          ¦                                							  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ CTB   		                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function FA60FIL()
Private oObj
Private _cRet   	:= "(.t.)"
Private _lCheck1	:= .f.
Private _lCheck2	:= .f. 
Private _lCheck3	:= .f.  

Private nDias       := SuperGetMV("MV_XDIACOB", ,60)

@ 100,136 To 250,400 Dialog oObj Title OemToAnsi("Filtragem no bordero")
@ 010,010 CHECKBOX "Filtrar apenas titulos p/ PCLD " VAR _lCheck1
@ 020,010 CHECKBOX "Filtrar apenas titulos venc. acima "+StrZero(nDias,2)+" dias" VAR _lCheck2  
@ 030,010 CHECKBOX "Filtro  personalizado " VAR _lCheck3 
@ 060,058 BmpButton Type 1 Action Close(oObj)
Activate Dialog oObj Centered


//Testar se aplica o filtro para PCLD
// https://www.jornalcontabil.com.br/pddpcld-provisao-de-perda-para-credito-de-liquidacao-duvidosa/#.XCyY91xKiM8
If _lCheck1
   _cRet := "( ( ((DDATABASE-SE1->E1_VENCREA) >= 180 .AND. SE1->E1_VALOR<=15000) .OR. ((DDATABASE-SE1->E1_VENCREA) >= 365) ) )  "
End If	
If _lCheck2
   _cRet := "( ( (DDATABASE-SE1->E1_VENCREA) >= "+StrZero(nDias,2)+")  .AND. SE1->E1_XTPCLI<>'10' )  "     //10 - Venda Funcionário
End If	
If _lCheck3
   	_cRet := FilterExpr("SE1")
	If Empty(_cRet)
		_cRet := ".T."
	EndIf
End If	


Return(_cRet)