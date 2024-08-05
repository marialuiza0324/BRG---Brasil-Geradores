#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MA650TOK  ³ Autor ³ Ricardo Moreira       ³ Data ³ 10/12/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  Ao Abrir uma Op nao deixar se tiver algum item bloqueado da estrutura   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para BRG      								 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User function MA650TOK()

Local _Prod := M->C2_PRODUTO   //G0010021       
Local _Comp := ""
Local  lRet := .T.
Local _Bloq := ""

DbSelectArea("SG1")
DbSetOrder(1)   
If dbSeek(xFilial("SG1")+_Prod)
  DO WHILE SG1->(!EOF()) .AND. SG1->G1_COD = _Prod 
   _Comp := SG1->G1_COMP 

   If Select("QSG1") > 0
	  QSG1->(DbCloseArea())
   EndIf

   _cQry := " "
   _cQry += "SELECT G1_COD, B1_MSBLQL, G1_COMP, B1_DESC  "
   _cQry += "FROM " + retsqlname("SG1")+" SG1 "
   _cQry += "INNER JOIN " + retsqlname("SB1") + " SB1 ON  B1_COD = G1_COMP "
   _cQry += "WHERE SG1.D_E_L_E_T_ <> '*' "
   _cQry += "AND SB1.D_E_L_E_T_ <> '*' "
   _cQry += "AND B1_FILIAL = '" + substr(cFilAnt,1,2)+ "' "
   _cQry += "AND G1_FILIAL = '" + cFilAnt + "' "
   _cQry += "AND G1_COD = '" + _Comp + "' "
   _cQry += "AND B1_MSBLQL = '1' "
   
   DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"QSG1",.T.,.T.)

   DO WHILE QSG1->(!EOF())
       lRet := .F.	  
       _Bloq += "Produto: "+ QSG1->G1_COMP+ " / "+QSG1->B1_DESC + Chr(13) + Chr(10)        
       QSG1->(dbSkip())
   EndDo
      
   SG1->(dbSkip())	  
 EndDo
 If !lRet
    AVISO("Produtos Bloqueados !!!!!", _Bloq, {"Fechar"}, 2)  
 End
EndIf
Return lRet
