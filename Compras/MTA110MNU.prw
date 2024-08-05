#include 'protheus.ch'
#include 'parmtype.ch'

//02/09/2022
//Adiciona no Menu da Solicitação
//BRG

User Function MTA110MNU()
Local aArea    := GetArea()

aAdd(aRotina,{ "Observações", "U_ObsAprv", 0 , 3, 0, .F.})

 RestArea(aArea)
 
Return aRotina

//02/09/2022
//BRG
//Observações de Reprovação/Bloqueio

User Function OBSAPRV()

Local oButton1
Local oSay1
Static oDlg
Private oMultiGe1
Private cMultiGe1 := ""
Private cCnUM

DbSelectArea("SC1")
DbSetOrder(1)
DbSeek(xFilial("SC1")+SC1->C1_NUM)
cCnUM :=SC1->C1_NUM

Do While ! EOF() .AND. SC1->C1_NUM == cCnUM .AND. SC1->C1_FILIAL = xFilial("SC1")
   cMultiGe1+= SC1->C1_XOBSBLQ
   SC1->(dbSkip())
EndDo

DEFINE MSDIALOG oDlg TITLE "Bloqueada/Recusada" FROM 000, 000  TO 400, 650 COLORS 0, 16777215 PIXEL

    @ 025, 003 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 320, 120 COLORS 0, 16777215 PIXEL   ///HSCROLL
    @ 010, 015 SAY oSay1 PROMPT "Observação de Bloqueio/Recusa" SIZE 160, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 165, 250 BUTTON oButton1 PROMPT "OK" SIZE 037, 012 OF oDlg PIXEL ACTION GrvBLq() PIXEL
 
ACTIVATE MSDIALOG oDlg CENTERED

Return 

//grava o campo memo 

Static Function GrvBLq()


DbSelectArea("SC1")
DbSetOrder(1)
DbSeek(xFilial("SC1")+cCnUM)
 RecLock("SC1",.F.)
 SC1->C1_XOBSBLQ := cMultiGe1
 MsUnlock()
 MsgInfo("Observação Gravada !!","Solicitação de Compra ") 

 oDlg:End()

Return


