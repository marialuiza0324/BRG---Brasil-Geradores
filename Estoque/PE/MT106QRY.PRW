#include 'protheus.ch'
#include 'parmtype.ch'




/*User Function MT106QRY()
    Local cFiltro := ''
    Local cBlq01 := SuperGetMV("MV_USER01", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 01 

    If !(cCodUser $ cBlq01)
        cFiltro :=  " AND CP_LOCAL <> '01' " 
    EndIf 

Return (cFiltro)
*/
