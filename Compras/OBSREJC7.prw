#include 'protheus.ch'
#include 'parmtype.ch'

//22/02/2023
//Tela de recusa de Pedido de compra
//BRG

User Function OBSREJC7()

Local oButton1
Local oSay1
Static oDlg
Private oMultiGe1
Private cMultiGe1 := ""
Private cCnUM

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7")+SC7->C7_NUM)
cCnUM :=SC7->C7_NUM

Do While ! EOF() .AND. SC7->C7_NUM == cCnUM .AND. SC7->C7_FILIAL = xFilial("SC7")
   cMultiGe1+= SC7->C7_XOBSBLQ
   SC7->(dbSkip())
EndDo

DEFINE MSDIALOG oDlg TITLE "Estornar/Reprovar" FROM 000, 000  TO 400, 650 COLORS 0, 16777215 PIXEL

    @ 025, 003 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 320, 120 COLORS 0, 16777215 PIXEL   ///HSCROLL
    @ 010, 015 SAY oSay1 PROMPT "Observação de Estorno/Reprovação" SIZE 160, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 165, 250 BUTTON oButton1 PROMPT "OK" SIZE 037, 012 OF oDlg PIXEL ACTION BLqSC7() PIXEL
 
ACTIVATE MSDIALOG oDlg CENTERED

Return 

//grava o campo memo 

Static Function BLqSC7()


DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7")+cCnUM)
 RecLock("SC7",.F.)
 SC7->C7_XOBSBLQ := cMultiGe1
 MsUnlock()
 MsgInfo("Observação Gravada !!","Pedido de Compra ") 

 oDlg:End()

Return
