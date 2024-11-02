#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc}
Valida bloqueio de todas as TES 
libera apenas 530, 591 nas filiais 0501 1001 
e 530, 590 na filial 0101 
para o usuário Locação.
@type  Function
@author Maria Luiza
@since 28/10/2024 */

User Function FSFAT002()

Local cUser := SupergetMv("MV_USERLOC", , ) //Parâmetro que controla acesso à TES
Local cUser_Id := RetCodUsr()
Local cTesLoc  := SupergetMv("MV_TESLOC", , ) //Parâmetro que controla as TES que serão LIBERADAS para usuário de locação
Local lRet  := .T.


If cFilAnt == "0501" .OR. cFilAnt == "1001" //valida filial
    If !(M->C6_TES $ cTesLoc ).AND. cUser_Id $ cUser //valida TES e usuário
        Help(, ,"AVISO#0001", ,"Usuário " +cUserName+ " não tem permissão para utilizar TES selecionada",1, 0, , , , , , {"Para esta filial, utilize a(s) TES : " +cTesLoc})
        lRet := .F.
    EndIf
ElseIf  cFilAnt == "0101" //valida filial
    If !(M->C6_TES $ cTesLoc) .AND. cUser_Id $ cUser //valida TES e usuário
        Help(, ,"AVISO#0001", ,"Usuário " +cUserName+ " não tem permissão para utilizar TES selecionada",1, 0, , , , , , {"Para esta filial, utilize a(s) TES : " +cTesLoc})
        lRet := .F.
    EndIf
EndIf

Return lRet
