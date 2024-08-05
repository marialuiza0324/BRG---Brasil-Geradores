
/*#INCLUDE "RWMAKE.CH"
INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"
#Include "PROTHEUS.CH"

//BRG
//Na geração da Pre-Requisição, zera o salso do b2_qemp se for maior q 0
//29/10/2021

User Function MA106GER()

Local bFiltro := ParamIXB[1]  //Customizações do usuário
Local _Cnum := SCP->CP_NUM
 
/*
If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf
cQry := " "
cQry += "SELECT D4_FILIAL, D4_OP,D4_COD, B1_UM,D4_LOCAL,B1_LOCPAD,B1_DESC, D4_DATA,D4_QTDEORI, D4_QUANT,B1_XENDERE,D4_PRODUTO,C2_NUM,C2_TPOP, C2_PRODUTO,C2_SEQPAI,B1_REQ ,B1_COD "
cQry += "FROM " + retsqlname("SD4")+" SD4 "
cQry += "LEFT JOIN " + retsqlname("SB1") + " SB1 ON B1_COD = D4_PRODUTO  AND B1_FILIAL = '" + substr(cFilAnt,1,2) + "' AND SB1.D_E_L_E_T_ <> '*' "
cQry += "LEFT JOIN " + retsqlname("SC2") + " SC2 ON C2_FILIAL = D4_FILIAL AND C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP AND SC2.D_E_L_E_T_ <> '*' "
cQry += "WHERE SD4.D_E_L_E_T_ <> '*' "
//cQry += "AND D4_OPORIG = ' ' " //Vamos requisitar as PI's dentro da OP principal 12/12/2019
cQry += "AND D4_OP = '" + _Op + "' "
cQry += "AND D4_FILIAL = '" + cFilAnt+ "' "
cQry += "ORDER BY D4_FILIAL, D4_OP, D4_COD "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP1",.T.,.T.)


DO WHILE TMP1->(!EOF())


Endo

alert("teste")

DbSelectarea('SCP')
DbSetorder(1)
DbSeek(xFilial('SCP'))
Do While !EOF() .and. CP_FILIAL = xfilial('SCP')
   DbSelectarea('SB2')
   DbSetorder(1)
   DbSeek(xFilial('SB2'))+SCP->CP_PRODUTO+SCP->CP_LOCAL)
     If CP_PREREQU <> 'S' .and. CP_OK == ThisMark()
       SB2->(RECLOCK("SB2",.F.))
       SB2->B2_QEMP  := SB2->B2_QEMP - SD3->D3_QUANT                            
       SB2->(MSUNLOCK())	  
     EndIf
     DbSkip()
enddo
*/
/*
DbSelectarea('SCP')
DbSetorder(1)
If DbSeek(xFilial('SCP')+SCP->CP_NUM)
   Do While !EOF() .and. SCP->CP_FILIAL = xfilial('SCP') .and. SCP->CP_NUM = _Cnum
      If SCP->CP_PREREQU <> 'S' .and. SCP->CP_OK == ThisMark()
         DbSelectarea('SB2')
         DbSetorder(1)
         DbSeek(xFilial('SB2')+SCP->CP_PRODUTO+SCP->CP_LOCAL)
         If SB2->B2_QEMP > 0 
            SB2->(RECLOCK("SB2",.F.))
            SB2->B2_QEMP  := 0                          
            SB2->(MSUNLOCK())	
         EndIf   
      EndIf
    SCP->(DbSkip())
   Enddo
EndIf
*/
//Return Nil
