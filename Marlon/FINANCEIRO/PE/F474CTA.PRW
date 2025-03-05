#INCLUDE 'TOTVS.CH'
#INCLUDE "PROTHEUS.CH"
  
/*/{Protheus.doc} F474CTA
Ajustar informações bancárias para a busca dos registros a conciliar
@type       Function
@author     TOTVS
@since      31/08/2023
@return     Nil
/*/
User Function F474CTA()

    Local cBanco := paramixb[1]
    Local cAgencia := paramixb[2]
    Local cConta := paramixb[3]
    Local aRet := {}
     
    aRet := {cBanco, MV_PAR03, MV_PAR04}
 
Return aRet
