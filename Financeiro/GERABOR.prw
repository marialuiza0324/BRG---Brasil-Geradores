#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#include "tbiconn.ch"
#INCLUDE "TOPCONN.CH"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BLTCDBB  ³ Autor ³ Microsiga             ³ Data ³ 20/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCO BRASIL COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes PREMIER - Adaptado po TRADE       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                         
//--------------------------------------------------------------
User Function TELABOR()                        
Local oButton1
Local oButton2
Private oGet1
Private cGet1 := space(3)
Private oGet2
Private cGet2 := space(5)
Private oGet3
Private cGet3 := space(10)
Private oSay1
Private oSay2
Private oSay3
Private oSay4
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Banco do Borderô" FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL

    @ 010, 015 SAY oSay1 PROMPT "Selecione o Banco/Agencia/Conta" SIZE 054, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 033, 075 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 F3 "BANCOS" PIXEL
    @ 051, 075 MSGET oGet2 VAR cGet2 SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 069, 075 MSGET oGet3 VAR cGet3 SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 035, 045 SAY oSay2 PROMPT "Banco:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 053, 045 SAY oSay3 PROMPT "Agencia:" SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 070, 045 SAY oSay4 PROMPT "Conta:" SIZE 021, 011 OF oDlg COLORS 0, 16777215 PIXEL
    @ 099, 089 BUTTON oButton1 PROMPT "OK" SIZE 037, 012 OF oDlg ACTION Processa({|| GERABOR()},"Aguarde...") PIXEL
    @ 099, 141 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg Action oDlg:End() PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return

Static function GERABOR()

Local aArea    := GetArea()
//Local cBanco := "341"
//Local cAgencia := "0208"
//Local cConta := "54002"
Local cSituaca := "1"
Local cBordero := ""
Local dDataMov := ""

If MsgYesNo("Deseja Gerar o Bordero Banco Itau ?","ATENÇÃO")

   If Select("TMP") > 0
	   TMP->(dbCloseArea())
   EndIf

   _cQry := "SELECT SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PORTADO,SE1.E1_AGEDEP,SE1.E1_CONTA,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_CLIENTE,SE1.E1_EMISSAO,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_SALDO "
   _cQry += "FROM " + retsqlname("SE1")+" SE1 "  
   _cQry += "WHERE SE1.D_E_L_E_T_ <> '*' " 
   _cQry += "AND   SE1.E1_SALDO > 0 "
   _cQry += "AND   SE1.E1_TIPO IN ('NF','FT') "  
   _cQry += "AND   SE1.E1_NUMBOR = ' ' "
   _cQry += "AND   SE1.E1_PORTADO = '" + cGet1  + "'"
   _cQry += "AND   SE1.E1_AGEDEP  = '" + cGet2  + "'"
   _cQry += "AND   SE1.E1_CONTA   = '" + cGet3  + "'"
   _cQry += "AND   SE1.E1_FILIAL  BETWEEN '" + xFilial("SE1")  + "' AND '" + xFilial("SE1")  + "' "
   _cQry += "AND   SE1.E1_EMISSAO	BETWEEN '" + DTOS(DDATABASE)  + "' AND '" + DTOS(DDATABASE)  + "' "
   _cQry += "ORDER BY SE1.E1_FILIAL,SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA "

   _cQry := ChangeQuery(_cQry)
   TcQuery _cQry New Alias "TMP"
 
   Count to nCount
   
   If nCount > 0

      cBordero   := GetMV("MV_NUMBORR")
      cBordero   := StrZero(Val(cBordero)+1,6) 
 
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0101" // USER "admin" 

      dDataMov := DDATABASE //Ctod("19/04/2019")
 
      dbselectarea("TMP")
      DBGOTOP()
      DO WHILE TMP->(!EOF())
      DbSelectArea("SE1")
      DbSetOrder(1)
      IF DbSeek(xFilial("SE1")+TMP->E1_PREFIXO+TMP->E1_NUM+TMP->E1_PARCELA+TMP->E1_TIPO)
         Reclock("SE1",.F.)
         SE1->E1_NUMBOR  := cBordero
         SE1->E1_DATABOR := dDataMov
         SE1->E1_MOVIMEN := dDataMov
         SE1->E1_SITUACA := cSituaca
         SE1->(MsUnlock())

         Reclock("SEA",.T.)
         SEA->EA_FILIAL  := xFilial("SEA")
         SEA->EA_PREFIXO := TMP->E1_PREFIXO
         SEA->EA_NUM     := TMP->E1_NUM
         SEA->EA_PARCELA := TMP->E1_PARCELA
         SEA->EA_PORTADO := TMP->E1_PORTADO 
         SEA->EA_AGEDEP  := TMP->E1_AGEDEP
         SEA->EA_NUMBOR  := cBordero
         SEA->EA_DATABOR := dDataMov
         SEA->EA_TIPO    := TMP->E1_TIPO
         SEA->EA_CART    := "R"
         SEA->EA_NUMCON  := TMP->E1_CONTA
         SEA->EA_TRANSF  := ""
         SEA->EA_SITUACA := cSituaca
         SEA->EA_SITUANT := "0"
         SEA->EA_SALDO   := 0
         SEA->EA_FILORIG := xFilial("SEA")
         SEA->(MsUnlock())   
      EndIf   
      TMP->(dbskip())
      ENDDO

   MSGINFO("Bordero Gerado com Sucesso !! N." + cvaltochar(cBordero)+" ","Atenção") 
   PutMV("MV_NUMBORR",strzero(val(cBordero),6))
Else
      MSGINFO("Não existe Títulos para gerar Bordero !! ","Atenção")  
      Return   
   EndIf
EndIf 
oDlg:End()
RestArea(aArea)
Return
