//BRG Geradores
//24/11/2019
//Valida o Tratamento para não fazer solicitações nos locais da NNT
//3rl Soluções

#include 'protheus.ch'
#include 'parmtype.ch'

User function LOCDNNT() //U_LOCDNNT()

Local lRet := .T.
//Local cBlq28 := SuperGetMV("MV_USER28", ," ") // Usuários AUTORIZADO A GERAR SOLITAÇÃO DE TRANFERENCIA NO LOCAL 28 000027;000000;000032                                                                                                                                                                                                                                      
Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 13
//Local cBlqAll := SuperGetMV("MV_USERALL", ," ") //  
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario

If !(cCodUser $ cBlq13)  // se o usuario logado estiver dentro do paramerto, 
   If M->NNT_LOCLD == "13"
      lRet:=.F.  
      MSGINFO("Usuário não autorizado para gerar Transferencia no Almoxarifado 13."," Atenção ") 
   EndIf    
EndIf
/*
If cCodUser $ cBlq13 .and. SCP->CP_LOCAL <> "13"
   lRet:=.F.  
   MSGINFO("Usuário não autorizado para gerar Pre Requisição no Almoxarifado 13."," Atenção ") 
EndIf

If cCodUser $ cBlqAll .and. SCP->CP_LOCAL $ "13/28"
   lRet:=.F.  
   MSGINFO("Usuário não autorizado para gerar Pre Requisição nesse Almoxarifado."," Atenção ") 
EndIf
*/	
Return lRet
	
