#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc}
Função para validar o modo de edção 
@type  Function
@author Maria Luiza
@since 14/07/2026*/

User Function FSFAT007()

    Local cFilPv := SuperGetMvar("MV_FILPV",,"")
    Local lRet := .T.

    If cFilAnt $ cFilPv

        If INCLUI 
            lRet := .T.
        Else
            lRet := .F.
        EndIf

    EndIf

    Return lRet
