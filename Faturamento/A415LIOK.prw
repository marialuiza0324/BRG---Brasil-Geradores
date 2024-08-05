#Include "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
//--------------------------------------------------------------
/*/{Protheus.doc}
Description

@param xParam Valida linha ORçamento
@return xRet BRG
@author  -
@since 25/03/2019
/*/
//--------------------------------------------------------------
User Function A415LIOK() 
Local aCols  := {}
Local lRetorno := .T.  
Local aArea    := GetArea()

   //aheader
//If Acols[n,cLocal] <> "13" .and. __cUserID = "000033" 
//If tmp1->ck_local <> "13" .and. __cUserID = "000033"
//   MSGINFO("Amoxarifado Inválido"," Atenção ")
////   lRetorno     := .T.
//EndIf                       //tmp1->ck_local

RestArea(aArea)
Return(lRetorno)

