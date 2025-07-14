
#include 'protheus.ch'
#include 'parmtype.ch'

//BRG
//Valida a baixa da Pre Requisi��o
//14/04/2020

User function MA106GER()

/*
PARAMIXB[1] := Filial
PARAMIXB[2] := Produto
PARAMIXB[3] := Local
PARAMIXB[4] := Quantidade Atual
PARAMIXB[5] := Reservas PV/OP
PARAMIXB[6] : = Qtd. Disponivel
PARAMIXB[7] := Numero da solicita��o
PARAMIXB[8] := Saldo da Pre-Requisi��o
PARAMIXB[9] := Quantidade disponivel para entrega
PARAMIXB[10] := Quantidade em processo de compra
PARAMIXB[11] := Quantidade a Requisitar


*/

Local lRet := .T.
/*Local cBlq28 := SuperGetMV("MV_USER28", ," ") // Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 28
Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 13
Local cBlq01 := SuperGetMV("MV_USER01", ," ") // Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 01 
Local cBlqAll := SuperGetMV("MV_USERALL", ," ") //  
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario

If cCodUser $ cBlq28 .and. SCP->CP_LOCAL <> "28"
   lRet:=.F.  
   MSGINFO("Usu�rio n�o autorizado para gerar Pre Requisi��o no Almoxarifado 28."," Aten��o ") 
EndIf

If cCodUser $ cBlq13 .and. SCP->CP_LOCAL <> "13"
   lRet:=.F.  
   MSGINFO("Usu�rio n�o autorizado para gerar Pre Requisi��o no Almoxarifado 13."," Aten��o ") 
EndIf

If cCodUser $ cBlqAll .and. SCP->CP_LOCAL $ "13/28"
   lRet:=.F.  
   MSGINFO("Usu�rio n�o autorizado para gerar Pre Requisi��o nesse Almoxarifado."," Aten��o ") 
EndIf

If !(cCodUser $ cBlq01) .and. SCP->CP_LOCAL == "01"
   lRet:=.F.  
   MSGINFO("Usu�rio n�o autorizado para gerar Pre Requisi��o nesse Almoxarifado."," Aten��o ") 
EndIf*/

Return lRet
