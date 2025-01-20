#include 'protheus.ch'
#include 'parmtype.ch'

//BRG
//Valida a baixa da Pre Requisi��o
//14/04/2020

User function MT185OK()

	Local lRet := .T.
	Local cBlq28 := SuperGetMV("MV_USER28", ," ") // Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 28
	Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 13
	Local cBlqAll := SuperGetMV("MV_USERALL", ," ") //
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cBlq01  := SupergetMv("MV_USER01", ,)// Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 13
	Local cBlq05  := SupergetMv("MV_USER05", ,)// Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 05

	If cCodUser $ cBlq28 .and. SCP->CP_LOCAL <> "28"
		lRet:=.F.
		MSGINFO("Usu�rio n�o autorizado para gerar Pre Requisi��o neste Almoxarifado, utilize o almoxarifado 28."," Aten��o ")
	EndIf

	If cCodUser $ cBlq13 .and. SCP->CP_LOCAL <> "13"
		Help(, ,"AVISO#0016", ,"Usu�rio n�o pode movimentar neste armaz�m",1, 0, , , , , , {"Utilize o armaz�m 13"})
		lRet:=.F.
	EndIf

	If cCodUser $ cBlqAll .and. SCP->CP_LOCAL $ "13/28"
		lRet:=.F.
		MSGINFO("Usu�rio n�o autorizado para gerar Pre Requisi��o nesse Almoxarifado."," Aten��o ")
	EndIf

		/*Valida��o para que usu�rio do Jos� Carlos s� consiga movimentar no armaz�m 05
	Solicitado pela Giu - Maria Luiza - 16/01/2024*/

	If cCodUser $ cBlq05 .and. SCP->CP_LOCAL <> "05"
		Help(, ,"AVISO#0017", ,"Usu�rio n�o pode movimentar neste armaz�m",1, 0, , , , , , {"Utilize o armaz�m 05"})
		lRet:=.F.
	EndIf


	/*Valida��es para que o usu�rio Levy consiga realizar baixa de OS somente no armaz�m 01 na GRID
	  Solicitado pela Giu - Maria Luiza - 18/12/2024*/

	If cFilAnt == "0501"
		If cCodUser $ cBlq01 .AND. FunName() <> "MATA241"//valida se usu�rio est� usando TM que n�o est� contida no par�metro, s� entra na valida��o na rotina MATA185
			If SCP->CP_LOCAL <> "01"
				Help(, ,"AVISO#0012", ,"Usu�rio " +cUserName+ " n�o autorizado a baixar Pre Requisi��o nesse Almoxarifado",1, 0, , , , , , {"Realize baixa no almoxarifado 01"})
				lRet:=.F.
			EndIf
			If Empty(_Os)
				Help(, ,"AVISO#0013", ,"Campo de OS vazio",1, 0, , , , , , {"Preencha o campo da OS"})
				lRet:=.F.
			EndIf
		EndIf
	EndIf



Return lRet

