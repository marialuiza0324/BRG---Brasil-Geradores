#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT110APV º Autor ³ Ricardo Moreira     º Data ³  15/05/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍ¹±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Somente Deixa usuarios Autorizados a Aprovar SC's          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BRG                                 			              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT110APV 

Local cParam1:=ParamIxb[1]
Local nParam2:=ParamIxb[2]
Local lRet:=.F.
Local cCodUser  := RetCodUsr() //Retorna o Codigo do Usuario
Local xCompra   := SuperGetMV("MV_XCOMPRA", ," ") // Parametro contendo os compradores
Local xSMaster  := SuperGetMV("MV_XSHMAS", ," ") // Parametro contendo senha master
Local xExcGrp   := SuperGetMV("MV_XEXGRP", ," ") // Criado para q o Luciano aprove como primeiro aprovador, sendo q ele esta colocado tb no parametro de comprador

//C1_USER -> Usuário q Solicitação 
//C1_GRPRD -> GRUPO DE PRODUT

If (cCodUser $ xCompra) .and. Empty(SC1->C1_NOMAPRO)  .and. !(SC1->C1_GRPRD$xExcGrp)  //!(SC1->C1_GRPRD$xExcGrp) CRIADO ESPECIFICAMENTE PARA O LUCIANO POR ESTA COM O ID NO PARAMETRO DO COMPRAS MV_XCOMPRAS
   FWAlertError("Aguardando aprovação do Aprovador do Solicitante !!! ", "Alerta - Erro")
   Return lRet
elseif (cCodUser $ xCompra) .and. !Empty(SC1->C1_NOMAPRO)
   lRet:=.T.
   Return lRet    
else
   DbSelectArea("SAI")
   DbSetOrder(2)
   If DbSeek(xFilial("SAI")+SC1->C1_USER)
      Do While ! EOF() .AND. SAI->AI_USER == SC1->C1_USER .AND. SAI->AI_FILIAL = xFilial("SAI")
         If cCodUser $ xSMaster //Parametro da SEnha master, colocando a senha da PAula MV_XSHMAS  cLEITO 
            lRet := .T.           
         ElseIf SAI->AI_XAPROV = cCodUser .and. SAI->AI_GRUPO = SC1->C1_GRPRD
            lRet := .T.
         EndIF 
         SAI->(dbSkip())
      EndDo
      If !lRet
         FWAlertError("Grupo não permitido para Aprovação !!! ", "Alerta - Erro")
      EndIf
    Else
    FWAlertError("Solicitande sem regra de aprovação !!! ", "Alerta - Erro")
    EndIf      
EndIF

Return lRet
