#INCLUDE "RWMAKE.CH"
#INCLUDE "Protheus.CH"
#INCLUDE "TopConn.CH"

//Brg Geradores
//06/10/2020
//valida o número de serie da Nota a ser Gerada

User Function SX5NOTA     

Local lRet:= .T.

If cfilAnt == "0501"
   If SC5->C5_TPDOC == "F" .AND. SX5->X5_CHAVE $ "X/Y"
     lRet := .F.
   Endif
Endif
Return lRet
