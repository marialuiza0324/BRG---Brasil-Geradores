#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RETSEQ  ³ Autor ³ RICARDO MOREIRA        ³ Data ³ 18/12/18³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a sequencia automatica do numero de atendimento    ³±±
±±³          ³ 					                   						   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BRG				                           			        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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