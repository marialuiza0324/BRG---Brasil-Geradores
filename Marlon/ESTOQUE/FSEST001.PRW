#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'


/*/{Protheus.doc} nomeFunction
    (Função para alterar o parâmetro 
     MV_DBLQMOV - Data de Bloqueio de movimentos
	 por filial)
    @type  Function
    @author Maria Luiza
    @since 27/06/24
    /*/

User Function FSEST001()

	Local oButton1
	Local oGet1
	Local cGet1 := SuperGetMv("MV_DBLQMOV", , )
	Local oSay1
	Local oSay2
	Local cUserId := RetCodUsr()
	Local lRet := .T.
	Local cUser := SupergetMv("MV_USERPER", , ) //Parâmetro que controla acesso à rotina
	Static oDlg
	Private cGet2 :=  CtoD("  /  /  ")

	If !cUserId $ cUser

		FWAlertInfo("Usuário não autorizado à acessar rotina", "Atenção!")

		lRet := .F.

	Else

		DEFINE MSDIALOG oDlg TITLE "ALTERA PARÂMETRO MV_DBLQMOV" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

		@ 039, 031 SAY oSay1 PROMPT "Data de Bloqueio Atual :"   SIZE 061, 009 OF oDlg COLORS 0, 16777215 PIXEL
		@ 066, 031 SAY oSay2 PROMPT "Nova Data de Bloqueio :" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 037, 110 MSGET oGet1 VAR cGet1 WHEN .F. SIZE 071, 014 OF oDlg COLORS 0, 16777215 PIXEL
		@ 064, 110 MSGET oGet2 VAR cGet2 SIZE 071, 014 OF oDlg COLORS 0, 16777215 PIXEL
		@ 124, 105 BUTTON oButton1 PROMPT "ALTERAR" SIZE 037, 012 OF oDlg ACTION Altera() PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED

	EndIf
Return lRet

Static Function Altera()

	Local cNovaDt

	cNovaDt := 	PutMvFil("MV_DBLQMOV",DTOS(cGet2),cFilAnt)

	FWAlertInfo("Data alterada com sucesso","Atenção!!!")

	(oDlg:End())

Return cNovaDt
