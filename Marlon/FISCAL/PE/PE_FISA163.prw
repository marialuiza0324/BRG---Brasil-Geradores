#Include 'Protheus.ch'

/*/{Protheus.doc} FISA163
    Ponto de Entrada da rotina FISA163
    @type function
    @version 12.1.2410
    @author Luis Fernando Montes [montes.luis@totvs.com.br]
    @since 01/01/2026
/*/
User Function FISA163()
	Local aArea := fwGetArea() as array
	Local lRetorno := .T. as Logical

	If lRetorno .And. FindFunction('tbcagro.fiscal.configurador_tributo.u_ponto_entrada')
		lRetorno := tbcagro.fiscal.configurador_tributo.u_ponto_entrada()
	EndIf

	fwRestArea(aArea)
Return lRetorno
