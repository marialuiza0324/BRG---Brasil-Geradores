#include 'protheus.ch'
#include 'parmtype.ch'

//BRG
//Valida a baixa da Pre Requisição
//14/04/2020

User function M185MOD1()

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

/*
DbSelectArea("SB1")
DbSetOrder(1)  
IF dbSeek(xFilial("SB1")+_cProd)
   If SB1->B1_DEVOL = "S"
      U_DevSD3()      
   EndIF
*/

Return lRet

/*
User Function DevSD3()                        
Local oButton1
Private oGet1
Private cGet1 := space(20)
Private oSay1
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Devolução" FROM 000, 000  TO 070, 350 COLORS 0, 16777215 PIXEL

    @ 013, 010 SAY oSay1 PROMPT "Responsável:" SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 012, 045 MSGET oGet1 VAR cGet1 SIZE 079, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 011, 135 BUTTON oButton1 PROMPT "OK" SIZE 017, 014 OF oDlg ACTION Processa({|| GravRes()},"Aguarde...") PIXEL    

  ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function GravRes()

Return
/*
