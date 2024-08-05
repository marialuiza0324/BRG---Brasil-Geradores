#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'


/*/{Protheus.doc} FSCOM004
    (Função para alterar a data 
    de entrega do pedido de compra)
    @type  Function
    @author Maria Luiza
    @since 01/07/2024
    /*/


User Function FSCOM004()

	Local oButton1
	Local oGet1
	Local oGet2
	Local oGet3
	Local oGet4
	Local oGet5
	Local oGet6
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Static oDlg
	Static lRet := .T.
	Private cGet1 := SC7->C7_NUM //Nº do Pedido de Compra
	Private cGet2 :=  SC7->C7_XDTPRF
	Private cGet3 := CtoD("  /  /  ") //Nova Data de Entrega
	Private cGet4 := Space(210) //Justificativa da alteração
	Private cGet5 := SC7->C7_ITEM //Item do pedido
	Private cGet6 := SC7->C7_DATPRF //Data de entrega permanente 

	/*
	DT LEAD TIME - NAO ALTERA
	ULTIMA ALTERAÇÃO - NAO ALTERA
	NOVA DATA - ALTERA
	*/

	//validação para exibir tela de alteração apenas quando o pedido for aprovado (legenda verde)
	If SC7->C7_QUJE = 0 .AND. SC7->C7_QTDACLA = 0 .AND. SC7->C7_CONAPRO <> "B" .AND. SC7->C7_TIPO = 1 .AND. SC7->C7_RESIDUO = " " .AND. SC7->C7_CONAPRO <> "R" .AND. SC7->C7_CONTRA = " "

		DEFINE MSDIALOG oDlg TITLE "Alterar Data de Entrega do Pedido" FROM 000, 000  TO 500, 600 COLORS 0, 16777215 PIXEL

		@ 027, 023 SAY oSay1 PROMPT "Nº do Pedido : " SIZE 043, 009 OF oDlg COLORS 0, 16777215 PIXEL
		@ 026, 078 MSGET oGet1 VAR cGet1 WHEN .F. SIZE 060, 012 OF oDlg COLORS 0, 16777215 PIXEL
		@ 086, 076 SAY oSay2 PROMPT "Última Alteração :" SIZE 068, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 111, 076 SAY oSay3 PROMPT "Nova Data de Entrega :" SIZE 064, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 085, 175 MSGET oGet2 VAR cGet2 WHEN .F. SIZE 061, 014 OF oDlg COLORS 0, 16777215 PIXEL
		@ 109, 175 MSGET oGet3 VAR cGet3 SIZE 061, 014 OF oDlg COLORS 0, 16777215 PIXEL
		@ 224, 129 BUTTON oButton1 PROMPT "Alterar" SIZE 037, 012 OF oDlg ACTION AlteraDt() PIXEL
		@ 154, 023 SAY oSay4 PROMPT "Justificativa : " SIZE 044, 012 OF oDlg COLORS 0, 16777215 PIXEL
		@ 154, 072 MSGET oGet4 VAR cGet4 SIZE 210, 014 OF oDlg COLORS 0, 16777215 PIXEL
		@ 027, 150 SAY oSay5 PROMPT "Item : " SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 027, 179 MSGET oGet5 VAR cGet5 WHEN .F.  SIZE 060, 012 OF oDlg COLORS 0, 16777215 PIXEL
		@ 065, 078 SAY oSay6 PROMPT "Data Lead Time :" SIZE 054, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 063, 175 MSGET oGet6 VAR cGet6 WHEN .F.  SIZE 061, 014 OF oDlg COLORS 0, 16777215 PIXEL


		ACTIVATE MSDIALOG oDlg CENTERED
	Else

		FWAlertInfo("Pedido não pode ser alterado.","Atenção!!!")
		Return

	EndIf
Return


Static Function AlteraDt()

	Local cUser   := UsrRetName(RetCodUsr()) //Nome do usuário corrente
	Local cData   := DTOC(Date()) //data corrente
	Local cHora   := SUBSTR(Time(),1,5) //hora corrente
	Private cNovaDt := cGet3


	If Empty(cGet4) //valida se o campo de justificativa esta vazio

		FWAlertInfo("Preencha a justificativa para alteração da data do pedido","Atenção!!!")
		lRet := .F.

		ElseIf Len(Alltrim(cGet4)) < 30 //valida se justificativa tem menos de 30 caracteres

		FWAlertInfo("Justificativa deve conter mais informações.","Atenção!!!")
		lRet := .F.

	ElseIf cGet3 < CtoD(cData) //Valida se data à ser alterada é retroativa

		lRet := .F.
		FWAlertInfo("Data não pode ser anterior à data de hoje","Atenção!!!")

	Else

		DbSelectArea('SC7')
		SC7->(DbSetOrder(1))

		If SC7->(DBSeek(xFilial("SC7")+cGet1+cGet5)) //Localiza registro na SC7 para alterar data de entrega

			RecLock('SC7', .F.) //altera data de entrega
			SC7->C7_XDTPRF := cNovaDt
			SC7->(MsUnlock())

		EndIF

		SC7->(DbCloseArea())

		RecLock('Z11', .T.) //grava os dados de log na tabela auxiliar

		Z11->Z11_FILIAL := SC7->C7_FILIAL
		Z11->Z11_PEDIDO := cGet1
		Z11->Z11_DTANTI := cGet2
		Z11->Z11_DTNOVA := cNovaDt
		Z11->Z11_USER   := cUser
		Z11->Z11_REGIST := cData + " - " + cHora + "h"
		Z11->Z11_JUSTIF := cGet4

		Z11->(MsUnlock())

		FWAlertInfo("Data alterada com sucesso.","Atenção!!!")

		(oDlg:End())

		U_FSFIN002() //função contas a pagar

	EndIf

Return lRet

