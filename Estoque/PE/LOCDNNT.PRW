//BRG Geradores
//24/11/2019
//Valida o Tratamento para n�o fazer solicita��es nos locais da NNT
//3rl Solu��es

#include 'protheus.ch'
#include 'parmtype.ch'

User function LOCDNNT() //U_LOCDNNT()

Local lRet := .T.
//Local cBlq28 := SuperGetMV("MV_USER28", ," ") // Usu�rios AUTORIZADO A GERAR SOLITA��O DE TRANFERENCIA NO LOCAL 28 000027;000000;000032                                                                                                                                                                                                                                      
Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 13
//Local cBlqAll := SuperGetMV("MV_USERALL", ," ") //  
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario

If !(cCodUser $ cBlq13)  // se o usuario logado estiver dentro do paramerto, 
   If M->NNT_LOCLD == "13"
      lRet:=.F.  
      MSGINFO("Usu�rio n�o autorizado para gerar Transferencia no Almoxarifado 13."," Aten��o ") 
   EndIf    
EndIf
/*
If cCodUser $ cBlq13 .and. SCP->CP_LOCAL <> "13"
   lRet:=.F.  
   MSGINFO("Usu�rio n�o autorizado para gerar Pre Requisi��o no Almoxarifado 13."," Aten��o ") 
EndIf

If cCodUser $ cBlqAll .and. SCP->CP_LOCAL $ "13/28"
   lRet:=.F.  
   MSGINFO("Usu�rio n�o autorizado para gerar Pre Requisi��o nesse Almoxarifado."," Aten��o ") 
EndIf
*/	
Return lRet
	
