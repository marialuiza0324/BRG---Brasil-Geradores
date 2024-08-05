#include 'protheus.ch'
#include 'parmtype.ch'

//Perlen
//Valida a baixa da Pre Requisição
//14/04/2020

User function M185MOD2()	
	
Local lRet := .T.
Local cBlq28 := SuperGetMV("MV_USER28", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 28
Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 13
Local cBlqAll := SuperGetMV("MV_USERALL", ," ") //  
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario

If cCodUser $ cBlq28 .and. SCP->CP_LOCAL <> "28"
   lRet:=.F.  
   MSGINFO("Usuário não autorizado para gerar Pre Requisição no Almoxarifado 28."," Atenção ") 
EndIf

If cCodUser $ cBlq13 .and. SCP->CP_LOCAL <> "13"
   lRet:=.F.  
   MSGINFO("Usuário não autorizado para gerar Pre Requisição no Almoxarifado 13."," Atenção ") 
EndIf

If cCodUser $ cBlqAll .and. SCP->CP_LOCAL $ "13/28"
   lRet:=.F.  
   MSGINFO("Usuário não autorizado para gerar Pre Requisição nesse Almoxarifado."," Atenção ") 
EndIf



	
Return lRet
