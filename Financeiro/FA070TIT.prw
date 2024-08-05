//BRG Geradores
//10/07/2018
//Abre uma tela para digitar a senha para liberar ou não a baixa por Dação
//3rl Soluções

#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#Include "PROTHEUS.CH"

User Function FA070TIT()

Private URET := .F.  

If cmotbx = "DACAO"
  U_LibBx()
Else
  URET := .T.
EndIf

Return URET 

//Tela para digitar a senha

User Function LibBx()
Local oButton1
Local oButton2
Private oGet1
Private cGet1 := space(6)
Private oSay1
Private _Senha := GETMV("MV_BXREC")
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Liberação Baixa Dação" FROM 000, 000  TO 100, 300 COLORS 0, 16777215 PIXEL

    @ 014, 014 SAY oSay1 PROMPT "Digite a Senha" SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 013, 053 MSGET oGet1 VAR cGet1 SIZE 045, 010 OF oDlg COLORS 0, 16777215 PASSWORD PIXEL
    @ 032, 070 BUTTON oButton1 PROMPT "Cancela" SIZE 030, 012 OF oDlg ACTION Canc() PIXEL
    @ 032, 110 BUTTON oButton2 PROMPT "OK" SIZE 030, 012 OF oDlg ACTION Baixa() PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return        

Static Function Baixa()  

If cGet1 == _Senha // 1a2b2c
  URET := .T.
  oDlg:End() 
Else
  MSGINFO("Senha Incorreta"," Atenção ")  
EndIF     

Return URET 

Static Function Canc()  

oDlg:End()
URET := .F.

Return URET       
