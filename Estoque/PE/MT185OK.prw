#include 'protheus.ch'
#include 'parmtype.ch'

//BRG
//Valida a baixa da Pre Requisição
//14/04/2020

User function MT185OK()

	Local lRet := .T.
	Local cBlq28 := SuperGetMV("MV_USER28", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 28
	Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 13
	Local cBlqAll := SuperGetMV("MV_USERALL", ," ") //
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cBlq01  := SupergetMv("MV_USER01", ,)// Usuários que somente irão gerar e baixar requisições no almoxarifado 13
	Local cBlq05  := SupergetMv("MV_USER05", ,)// Usuários que somente irão gerar e baixar requisições no almoxarifado 05

	If cCodUser $ cBlq28 .and. SCP->CP_LOCAL <> "28"
		lRet:=.F.
		MSGINFO("Usuário não autorizado para gerar Pre Requisição neste Almoxarifado, utilize o almoxarifado 28."," Atenção ")
	EndIf

	If cCodUser $ cBlq13 .and. SCP->CP_LOCAL <> "13"
		Help(, ,"AVISO#0016", ,"Usuário não pode movimentar neste armazém",1, 0, , , , , , {"Utilize o armazém 13"})
		lRet:=.F.
	EndIf

	If cCodUser $ cBlqAll .and. SCP->CP_LOCAL $ "13/28"
		lRet:=.F.
		MSGINFO("Usuário não autorizado para gerar Pre Requisição nesse Almoxarifado."," Atenção ")
	EndIf

		/*Validação para que usuário do José Carlos só consiga movimentar no armazém 05
	Solicitado pela Giu - Maria Luiza - 16/01/2024*/

	If cCodUser $ cBlq05 .and. SCP->CP_LOCAL <> "05"
		Help(, ,"AVISO#0017", ,"Usuário não pode movimentar neste armazém",1, 0, , , , , , {"Utilize o armazém 05"})
		lRet:=.F.
	EndIf


	/*Validações para que o usuário Levy consiga realizar baixa de OS somente no armazém 01 na GRID
	  Solicitado pela Giu - Maria Luiza - 18/12/2024*/

	If cFilAnt == "0501"
		If cCodUser $ cBlq01 .AND. FunName() <> "MATA241"//valida se usuário está usando TM que não está contida no parâmetro, só entra na validação na rotina MATA185
			If SCP->CP_LOCAL <> "01"
				Help(, ,"AVISO#0012", ,"Usuário " +cUserName+ " não autorizado a baixar Pre Requisição nesse Almoxarifado",1, 0, , , , , , {"Realize baixa no almoxarifado 01"})
				lRet:=.F.
			EndIf
			If Empty(_Os)
				Help(, ,"AVISO#0013", ,"Campo de OS vazio",1, 0, , , , , , {"Preencha o campo da OS"})
				lRet:=.F.
			EndIf
		EndIf
	EndIf



Return lRet

