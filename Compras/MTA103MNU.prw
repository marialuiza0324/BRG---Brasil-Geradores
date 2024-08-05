#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA103MNU   º Autor ³ 3rl Solucoes    º Data ³  04/03/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Visualizar Cond de Pag dos Pedidos                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BRG                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTA103MNU() //.Customizações do cliente 

aAdd(aRotina,{ "Cond Pag do Pedido", "U_VisCp", 0 , 3, 0, .F.})
 
Return aRotina 

 User Function VisCp()

Local oButton1
Local oGet1
Local cGet1 := space(15)
Local oMultiGe1
Local cMultiGe1 := ""
Local oSay1
Static oDlg


If Select("TMP4") > 0
	TMP4->(dbCloseArea())
EndIf
	
_cQry := " "
_cQry += "SELECT  D1_FILIAL, D1_DOC, D1_SERIE, D1_PEDIDO, C7_COND  "
_cQry += "FROM " + retsqlname("SD1")+" SD1 "
_cQry += "LEFT JOIN " + retsqlname("SC7")+ " SC7 ON C7_FILIAL = D1_FILIAL AND C7_NUM = D1_PEDIDO AND SC7.D_E_L_E_T_ <> '*' "    
_cQry += "WHERE SD1.D_E_L_E_T_ <> '*' "
_cQry += "AND D1_FILIAL = '" + cFilAnt + "'
_cQry += "AND D1_DOC = '" + SF1->F1_DOC + "'
_cQry += "AND D1_SERIE = '" + SF1->F1_SERIE + "'
_cQry += "AND D1_FORNECE = '" + SF1->F1_FORNECE + "'
_cQry += "AND D1_LOJA = '" + SF1->F1_LOJA + "'
	
_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP4"  

cGet1 := TMP4->D1_DOC+"/"+ TMP4->D1_SERIE

If empty(TMP4->D1_PEDIDO)
   MsgInfo("Nota fiscal sem Pedido de Compra !!","Atenção - Pedido de Compra ")
   RETURN
ENDIF

TMP4->(DBGOTOP())
Do While !TMP4->(EOF())
	IF !AllTrim(TMP4->C7_COND) $ cMultiGe1
		cMultiGe1 += "Condição:"+ alltrim(TMP4->C7_COND)+"- Descrição: "+Posicione("SE4",1,xFilial("SE4")+TMP4->C7_COND,"E4_DESCRI")
	EndIf
	TMP4->(DBSKIP())
EndDo

  DEFINE MSDIALOG oDlg TITLE "Visualiza Condição Pagamento" FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL

    @ 026, 001 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 200, 065 COLORS 0, 16777215 HSCROLL PIXEL
    @ 010, 005 SAY oSay1 PROMPT "Nota/Serie:" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 009, 038 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 105, 148 BUTTON oButton1 PROMPT "Fechar" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return
