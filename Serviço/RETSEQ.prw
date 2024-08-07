#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � RETSEQ  � Autor � RICARDO MOREIRA        � Data � 18/12/18潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna a sequencia automatica do numero de atendimento    潮�
北�          � 					                   						   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � BRG				                           			        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function RETSEQ()

Local RetSal := " "

If Select("TMP8") > 0
   TMP8->(DbCloseArea())
EndIf
		
cQry := " "
cQry += "SELECT TOP 1 ABF_SEQRC "
cQry += "FROM " + retsqlname("ABF")+" ABF "
cQry += "WHERE ABF.D_E_L_E_T_ <> '*' "
cQry += "AND ABF_FILIAL = '" + cFilAnt + "' "
cQry += "AND ABF_NUMOS = '" + M->ABF_NUMOS + "' "
cQry += "AND ABF_ITEMOS = '" + M->ABF_ITEMOS + "' "
cQry += "ORDER BY ABF_SEQRC DESC "
		
DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP8",.T.,.T.)
	
RetSal := Cvaltochar(STRZERO((Val(TMP8->ABF_SEQRC) + 1),2))

Return RetSal