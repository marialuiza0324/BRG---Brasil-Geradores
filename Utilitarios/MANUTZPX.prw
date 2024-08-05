//BRG Geradores
//02/09/2021
//Manuten豫o na ZPX
//3rl Solu寤es

#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"
#Include "PROTHEUS.CH"

User Function MANUTZPX() //U_MANUTSD3() 

Private _Doc :=  "" 
Private _Seri := ""
Private _Cli  := ""
Private _Ser  := ""

If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf

cQry := " "
cQry += "SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_ITEM, D1_FORNECE, D1_LOJA "
cQry += "FROM " + retsqlname("SD1")+" SD1 "
cQry += "WHERE SD1.D_E_L_E_T_ <> '*' "
cQry += "AND D1_FILIAL = '" + cFilAnt+ "' "
cQry += "AND D1_CF IN ('1909','2909') " 
cQry += "AND D1_DTDIGIT BETWEEN '20220101' AND '20220930' " 
cQry += "ORDER BY D1_FILIAL, D1_DOC, D1_ITEM  "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP1",.T.,.T.)

//------------------------//| Abertura do ambiente |//------------------------
/*
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST" TABLES "SCP","SB1"

dEMISSAO:= dDataBase
ConOut(Repl("-",80))
ConOut(PadC("Teste - SOLICITACAO AO ARMAZEM",80))
ConOut("Inicio: "+Time())
*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//| Teste de Inclusao                                           |
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

DO WHILE TMP1->(!EOF())
      DbSelectArea("SF1")
      DbSetOrder(1)  
      IF dbSeek(xFilial("SF1")+TMP1->D1_DOC+TMP1->D1_SERIE+TMP1->D1_FORNECE+TMP1->D1_LOJA)          
	     SF1->(RECLOCK("SF1",.F.))	        
         SF1->F1_DTLANC  := CTOD("   /    /   ")
         SF1->(MSUNLOCK())
         SF1->(dbSkip())                 		
	  EndIf	  
	  TMP1->(dbSkip())
EndDo
MSGINFO("Finalizado"," Aten豫o ")  	
Return Nil

 