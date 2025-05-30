#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc}
Valida bloqueio de todas as TES 
EXCETO as que estiverem no par�metro MV_TESALM
para os usu�rios contidos no par�metro MV_USERALM
@type  Function
@author Maria Luiza
@since 02/11/2024 */

User Function FSFAT003()

Local cUser := SupergetMv("MV_USERALM", , ) //Par�metro que controla acesso � TES
Local cUser_Id := RetCodUsr()
Local cTesAlm  := SupergetMv("MV_TESALM", , ) //Par�metro que controla as TES que ser�o LIBERADAS para usu�rios do almoxarifado
Local lRet  := .T.

    If !(M->C6_TES $ cTesAlm ).AND. cUser_Id $ cUser //valida TES e usu�rio
        Help(, ,"AVISO#0002", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para utilizar TES selecionada",1, 0, , , , , , {"Utilize a(s) TES : " +cTesAlm})
        lRet := .F.
    EndIf


Return lRet
