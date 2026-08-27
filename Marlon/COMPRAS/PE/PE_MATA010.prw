#Include 'Protheus.ch'

/*/{Protheus.doc} ITEM
    Ponto de Entrada da rotina ITEM
    @type function
    @version 12.1.2410
    @author Luis Fernando Montes [montes.luis@totvs.com.br]
    @since 01/01/2026
/*/
User Function ITEM()
	Local aArea := fwGetArea() as array
	Local lRetorno := .T. as Logical

	If lRetorno .And. FindFunction('tbcagro.fiscal.configurador_tributo.u_ponto_entrada')
		lRetorno := tbcagro.fiscal.configurador_tributo.u_ponto_entrada()
	EndIf

	fwRestArea(aArea)
Return lRetorno
