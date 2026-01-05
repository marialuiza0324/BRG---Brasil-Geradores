//BRG Geradores
//24/11/2019
//Valida o Tratamento para não fazer solicitações nos locais da NNT
//3rl Soluções

#include 'protheus.ch'
#include 'parmtype.ch'

User function LOCNNT()  //u_ LOCNNT()

Local lRet := .T.
Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 13
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario

If !(cCodUser $ cBlq13) 
    If M->NNT_LOCAL == "13" 
      lRet:=.F.  
      MSGINFO("Usuário não autorizado para gerar Transferencia no Almoxarifado 13."," Atenção ") 
    EndIf
EndIf

Return lRet
	
