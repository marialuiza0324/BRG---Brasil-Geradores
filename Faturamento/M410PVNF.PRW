#Include "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
//--------------------------------------------------------------
/*/{Protheus.doc}
Description

@param xParam Ponto de Entrada para Gerar ou não a Nota
@return xRet BRG
@author  -
@since 25/03/2019
/*/
//--------------------------------------------------------------

User function M410PVNF()

Local lRet := .T.
Local cPedido := SC5->C5_NUM 
  
If CFILANT == "0101"
   dbSelectArea("SC6")
   dbSetOrder(1)
   If dbSeek(xFilial("SC6")+cPedido)
      While !Eof() .And. C6_FILIAL = xFilial("SC6") .And. C6_NUM == cPedido   
            If SC6->C6_LOCAL <> "13" .and. __cUserID = "000033"
               MSGINFO("Amoxarifado Inválido"," Atenção ") 
               lRet     := .F.
               Return lRet   
            EndIf
           SC6->(dbskip())
      EndDo
   EndIF
ENDIF
Return lRet
