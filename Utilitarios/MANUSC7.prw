//BRG Geradores
//02/09/2021
//Manuten豫o na ZPX
//3rl Solu寤es

#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"
#Include "PROTHEUS.CH"

User Function MANUSC7() //U_MANUTSD3() 

Private _Doc :=  "" 
Private _Seri := ""
Private _Cli  := ""
Private _Ser  := ""

If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf

cQry := " "
cQry += "SELECT C7_FILIAL, C7_ITEM, C7_PRODUTO, C7_NUM, B1_GRUPO "
cQry += "FROM " + retsqlname("SC7")+" SC7 "
cQry += " LEFT JOIN " + retsqlname("SB1")+" SB1 ON B1_COD = C7_PRODUTO AND B1_FILIAL ='01'  AND  SB1.D_E_L_E_T_ <> '*' "   
cQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
cQry += "AND C7_ENCER =  '' "
cQry += "AND C7_FILIAL = '" + cFilAnt+ "' "
cQry += "ORDER BY C7_FILIAL, C7_NUM, C7_ITEM "

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
      DbSelectArea("SC7")
      DbSetOrder(1)  
      IF dbSeek(xFilial("SC7")+TMP1->C7_NUM+TMP1->C7_ITEM)          
	     SC7->(RECLOCK("SC7",.F.))	        
         SC7->C7_GRUPO := TMP1->B1_GRUPO
         SC7->(MSUNLOCK())
         SC7->(dbSkip())                 		
	  EndIf	  
	  TMP1->(dbSkip())
EndDo
MSGINFO("Finalizado"," Aten豫o ")  	
Return Nil

 