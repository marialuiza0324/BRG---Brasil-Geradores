#include 'protheus.ch'
#include 'parmtype.ch'

User function MA651GRV()
	
Local aArea    := GetArea()
Local _Item := 1
Local _Nsa := " "
Local _Op := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
Local _Desc := ""  
Local cNomeSolic :=Lower(Alltrim(UsrRetName(__CUSERID)))

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
 
 	_Nsa  := val(RetNSol()) + 1
	_Item := 1
	_Op   := TMP1->D4_OP
	
	DO WHILE TMP1->(!EOF()) .AND. _Op = TMP1->D4_OP
	
	   _Desc := POSICIONE("SB1",1,XFILIAL("SB1")+TMP1->D4_COD,"B1_DESC") 
	   _Um := POSICIONE("SB1",1,XFILIAL("SB1")+TMP1->D4_COD,"B1_UM")
	
	   //Não deixa gerar o empenho no campo B2_QEMP - INICIO 16/06/2020
	   DbSelectArea("SB2")
      DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
      IF dbSeek(xFilial("SB2")+TMP1->D4_COD+TMP1->D4_LOCAL)    
         SB2->(RECLOCK("SB2",.F.))
	      SB2->B2_QEMP  := SB2->B2_QEMP - TMP1->D4_QUANT                            
         SB2->(MSUNLOCK())
         SB2->(DbCloseArea())
      EndIf

      If TMP1->C2_TPOP = 'F'          
          DbSelectArea("SB1")
          DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
          IF dbSeek(xFilial("SB1")+TMP1->D4_PRODUTO)            
               IF (SB1->B1_REQ == "N") .AND. VAL(TMP1->C2_SEQPAI) > 1   // .OR. !EMPTY(TMP1->C2_SEQPAI)) //.OR.    //IF (SB1->B1_REQ == "N") .AND. (!EMPTY(TMP1->C2_SEQPAI)
                   DBGOTOP()                
                   DbSelectArea("SD4")
                   DbSetOrder(2)   
                   IF dbSeek(xFilial("SD4")+TMP1->D4_OP+TMP1->D4_COD)
	                  RecLock("SD4",.F.)
                      SD4->( dbDelete() )
                      msUnlock()
	                EndIF	               
	               //Deleta as OP's de Carenagem - INICIO
	                DBGOTOP()                
                   DbSelectArea("SC2")
                   DbSetOrder(1)   
                   IF dbSeek(xFilial("SC2")+TMP1->D4_OP )                      
	                      RecLock("SC2",.F.)
                         SC2->( dbDelete() )
                         msUnlock()                      
	                EndIF
               Else
                  Item := strzero(_Item,2)

                   DbSelectArea("SCP")
                   DbSetOrder(5)  // Z42_FILIAL +  Z42_NUM
                   IF !dbSeek(xFilial("SCP")+TMP1->D4_OP+TMP1->D4_COD)    
	                   SCP->(RECLOCK("SCP",.T.))
	                   SCP->CP_FILIAL  := TMP1->D4_FILIAL
	                   SCP->CP_NUM     := strzero(_Nsa,6)
	                   SCP->CP_ITEM    := Item
	                   SCP->CP_PRODUTO := TMP1->D4_COD
	                   SCP->CP_DESCRI  := _Desc
	                   SCP->CP_XENDERE := TMP1->B1_XENDERE
	                   SCP->CP_UM      := _Um
	                   SCP->CP_QUANT   := TMP1->D4_QTDEORI
	                   SCP->CP_OP      := TMP1->D4_OP
                      SCP->CP_LOCAL   := TMP1->D4_LOCAL //B1_LOCPAD
                      SCP->CP_EMISSAO := stod(TMP1->D4_DATA)
                      SCP->CP_DATPRF  := stod(TMP1->D4_DATA)
                      SCP->CP_CODSOLI := __CUSERID
                      SCP->CP_SOLICIT := cNomeSolic 
                      SCP->CP_USER	 :=  __CUSERID
                      SCP->CP_RATEIO  := "2"
                      SCP->CP_CONSEST := "1"
                      SCP->(MSUNLOCK())	     
	                   _Item++		         
	                EndIf	         
               EndIf
          EndIf    
      Else
         DbSelectArea("SB1")
         DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
         IF dbSeek(xFilial("SB1")+TMP1->D4_PRODUTO)            
            IF (SB1->B1_REQ == "N") .AND. VAL(TMP1->C2_SEQPAI) > 1   // .OR. !EMPTY(TMP1->C2_SEQPAI)) //.OR.    //IF (SB1->B1_REQ == "N") .AND. (!EMPTY(TMP1->C2_SEQPAI)
                DBGOTOP()                
                DbSelectArea("SD4")
                DbSetOrder(2)   
                IF dbSeek(xFilial("SD4")+TMP1->D4_OP+TMP1->D4_COD)
	                RecLock("SD4",.F.)
                   SD4->( dbDelete() )
                   msUnlock()
	             EndIF	               
	               //Deleta as OP's de Carenagem - INICIO
	             DBGOTOP()                
                DbSelectArea("SC2")
                DbSetOrder(1)   
                IF dbSeek(xFilial("SC2")+TMP1->D4_OP )
	                RecLock("SC2",.F.)
                   SC2->( dbDelete() )
                   msUnlock()
	             EndIF
            EndIf    
         EndIf
      EndIf
	   TMP1->(dbSkip())
   EndDo
	
EndDo

RestArea(aArea)
 
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ RetNSol   º Autor ³ Ricardo Moreira    º Data ³ 26/04/2017 º±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna o Número da Proxima Solicitação a ser gravada      o±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RetNSol()
//Verifica se o arquivo TMP está em uso

Local _Num := ""
If Select("QTMP") > 0
	QTMP->(DbCloseArea())
EndIf
_cQry := " "
_cQry += "SELECT TOP 1 CP_NUM "
_cQry += "FROM " + retsqlname("SCP")+" SCP "
_cQry += "WHERE SCP.D_E_L_E_T_ <> '*' "
_cQry += "AND CP_FILIAL = '" + cFilAnt + "' "
_cQry += "ORDER BY CP_NUM DESC "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"QTMP",.T.,.T.)

_Num:= QTMP->CP_NUM

Return _Num
