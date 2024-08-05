#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � RETSEQ  � Autor � RICARDO MOREIRA        � Data � 18/12/18���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna a sequencia automatica do numero de atendimento    ���
���          � 					                   						   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � BRG				                           			        ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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