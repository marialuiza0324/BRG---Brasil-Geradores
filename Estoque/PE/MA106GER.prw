
#include 'protheus.ch'
#include 'parmtype.ch'

//BRG
//Valida a baixa da Pre Requisição
//14/04/2020

User function MA106GER()

/*
PARAMIXB[1] := Filial
PARAMIXB[2] := Produto
PARAMIXB[3] := Local
PARAMIXB[4] := Quantidade Atual
PARAMIXB[5] := Reservas PV/OP
PARAMIXB[6] : = Qtd. Disponivel
PARAMIXB[7] := Numero da solicitação
PARAMIXB[8] := Saldo da Pre-Requisição
PARAMIXB[9] := Quantidade disponivel para entrega
PARAMIXB[10] := Quantidade em processo de compra
PARAMIXB[11] := Quantidade a Requisitar


*/

Local lRet := .T.
/*Local cBlq28 := SuperGetMV("MV_USER28", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 28
Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 13
Local cBlq01 := SuperGetMV("MV_USER01", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 01 
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

If !(cCodUser $ cBlq01) .and. SCP->CP_LOCAL == "01"
   lRet:=.F.  
   MSGINFO("Usuário não autorizado para gerar Pre Requisição nesse Almoxarifado."," Atenção ") 
EndIf*/

Return lRet
