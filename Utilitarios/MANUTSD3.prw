//BRG Geradores
//24/07/2018
//Abre uma tela para digitar a senha para liberar ou não a baixa por Dação
//3rl Soluções

#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"
#Include "PROTHEUS.CH"

User Function MANUTSD3() //U_MANUTSD3() 

//SELECT D1_FILIAL, D1_ITEM, D1_COD, D1_UM , D1_QUANT, D1_VUNIT, D1_TOTAL, D1_TES, D1_CF, D1_FORNECE, D1_LOJA, D1_LOCAL, D1_DOC, D1_SERIE ,D1_EMISSAO, D1_DTDIGIT, D1_TIPO, D1_NFORI, D1_SERIORI, D1_ITEMORI, D2_DOC, D2_SERIE    FROM SD1010 SD1
//LEFT JOIN SD2010 SD2 ON D1_FILIAL = D2_FILIAL AND D1_COD = D2_COD AND D1_NFORI = D2_DOC AND D1_FORNECE = D2_CLIENTE AND D2_LOJA = D1_LOJA AND D1_SERIORI = D2_SERIE AND D1_ITEMORI = D2_ITEM 
//WHERE  SD1.D_E_L_E_T_ <> '*'
//AND D1_FILIAL = '0501'
//AND D1_SERIORI ='1'
//AND D1_TIPO = 'D'
//ORDER BY D1_FILIAL, D1_NFORI, D1_SERIORI


If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf
cQry := " "
cQry += " SELECT D1_FILIAL, D1_ITEM, D1_COD, D1_UM , D1_QUANT, D1_VUNIT, D1_TOTAL, D1_TES, D1_CF, D1_FORNECE, D1_LOJA, "
cQry += " D1_LOCAL, D1_DOC, D1_SERIE ,D1_EMISSAO, D1_DTDIGIT, D1_TIPO, D1_NFORI, D1_SERIORI, D1_ITEMORI, D2_DOC, D2_SERIE "
cQry += "FROM " + retsqlname("SD1")+" SD1 "
cQry += "LEFT JOIN " + retsqlname("SD2")+ " SD2 ON D1_FILIAL = D2_FILIAL AND D1_COD = D2_COD AND D1_NFORI = D2_DOC AND D1_FORNECE = D2_CLIENTE AND D2_LOJA = D1_LOJA AND D1_SERIORI = D2_SERIE AND D1_ITEMORI = D2_ITEM AND SD2.D_E_L_E_T_ <> '*' "    
cQry += "WHERE SD1.D_E_L_E_T_ <> '*' "
cQry += "AND D1_TIPO IN ('B','D')  "
if cfilant = "0401" //engenharia
   cQry += "AND D1_TES IN ('390','391','392','393') " 
ElseIf cfilant = "0501" //grid
   cQry += "AND D1_TES IN ('390','391','392') " 
EndIf
//cQry += "AND D1_NFORI ='000003733' "  
//cQry += "AND D1_SERIE <> '1' "  
cQry += "AND D1_FILIAL = '" +cFilAnt+ "' "
cQry += "ORDER BY D1_FILIAL, D1_NFORI, D1_SERIORI, D1_ITEMORI,D1_COD "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP1",.T.,.T.)

//------------------------//| Abertura do ambiente |//------------------------
/*
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST" TABLES "SCP","SB1"

dEMISSAO:= dDataBase
ConOut(Repl("-",80))
ConOut(PadC("Teste - SOLICITACAO AO ARMAZEM",80))
ConOut("Inicio: "+Time())
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Teste de Inclusao                                           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DO WHILE TMP1->(!EOF())
      DbSelectArea("ZLI")
      DbSetOrder(1)  
      IF dbSeek(xFilial("ZLI")+ TMP1->D1_NFORI+ TMP1->D1_SERIORI+ ALLTRIM(TMP1->D1_ITEMORI)+TMP1->D1_COD)
          IF Empty(ZLI->ZLI_NOTRET)
	          ZLI->(RECLOCK("ZLI",.F.))
	          ZLI->ZLI_NOTRET  := TMP1->D1_DOC
             ZLI->ZLI_SERRET  := TMP1->D1_SERIE
             ZLI->ZLI_DATRET  := STOD(TMP1->D1_EMISSAO)	    
             ZLI->(MSUNLOCK()) 
          ENDIF         		
	  EndIf	  
	  TMP1->(dbSkip())
EndDo
 MSGINFO("Finalizado"," Atenção ")  	
Return Nil
