#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc}
Valida bloqueio de todas as TES 
EXCETO as que estiverem no parâmetro MV_TESALM
para os usuários contidos no parâmetro MV_USERALM
@type  Function
@author Maria Luiza
@since 02/11/2024 */

User Function FSFAT003()

Local cUser := SupergetMv("MV_USERALM", , ) //Parâmetro que controla acesso à TES
Local cUser_Id := RetCodUsr()
Local cTesAlm  := SupergetMv("MV_TESALM", , ) //Parâmetro que controla as TES que serão LIBERADAS para usuário de locação
Local lRet  := .T.

    If !(M->C6_TES $ cTesAlm ).AND. cUser_Id $ cUser //valida TES e usuário
        Help(, ,"AVISO#0002", ,"Usuário " +cUserName+ " não tem permissão para utilizar TES selecionada",1, 0, , , , , , {"Utilize a(s) TES : " +cTesAlm})
        lRet := .F.
    EndIf


Return lRet
