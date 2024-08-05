#include "PROTHEUS.CH"
#include "topconn.ch"
//Tratamento de Status apos a Conciliação do Acerto  
//09/09/2021
//3RL Soluções

User Function F380GRV

_Acert := ALLTRIM(SE5->E5_DOCUMEN)
_Cart  := SUBSTR(SE5->E5_BENEF,10,4) 

DbSelectArea("ZPX")
DbSetOrder(1)
ZPX->( DbGoTop() )
If DbSeek(xFilial("ZPX")+_Acert+_Cart)
   DO WHILE ZPX->(!EOF()) .AND. xFilial("ZPX") == ZPX->ZPX_FILIAL .AND. _Acert == ZPX->ZPX_ACERTO .AND. _Cart == ALLTRIM(ZPX->ZPX_CARTAO)
      ZPX->(RECLOCK("ZPX",.F.))
	  ZPX->ZPX_STATUS := "4"
 	  ZPX->(MSUNLOCK())
	  ZPX->(dbSkip())
   EndDo
EndIf

Return Nil
