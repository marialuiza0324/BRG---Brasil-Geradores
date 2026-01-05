//BRG Geradores
//24/11/2019
//Valida o Tratamento para não fazer solicitações nos locais da NNT
//3rl Soluções

#include 'protheus.ch'
#include 'parmtype.ch'

User function LOCDNNT() //U_LOCDNNT()

Local lRet := .T.
Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 13
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario

If !(cCodUser $ cBlq13)  // se o usuario logado estiver dentro do paramerto, 
   If M->NNT_LOCLD == "13"
      lRet:=.F.  
      MSGINFO("Usuário não autorizado para gerar Transferencia no Almoxarifado 13."," Atenção ") 
   EndIf    
EndIf

Return lRet
	
