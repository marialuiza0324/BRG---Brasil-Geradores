#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*/{Protheus.doc} FSCOM007

    @type  Function
    Fun��o que verifica se fornecedor possui
    condi��o de pagamento cadastrada.
    @author Maria Luiza
    @since 07/05/2025
    /*/


User Function FSCOM007()

	Local lRetorno := .T.
	/*Local cFormPag := ""
	Local cPagamento := SupergetMv("MV_FORMPAG", , )
	Local cBanco := ""
	Local cAgencia := ""
	Local cDigitVerCon  := ""
	Local cConta := ""
	Local cEmpresa := SupergetMv("MV_EMPPAG", , )
	Local cCodEmp := FWCodEmp()

	If cCodEmp $ cEmpresa
	
		cFormPag := Posicione("SA2",1,xFilial("SA2")+M->CPW_CODIGO+M->CPW_LOJA,'A2_FORMPAG')
		cBanco := Posicione("SA2",1,xFilial("SA2")+M->CPW_CODIGO+M->CPW_LOJA,'A2_BANCO')
		cAgencia := Posicione("SA2",1,xFilial("SA2")+M->CPW_CODIGO+M->CPW_LOJA,'A2_AGENCIA')
		cDigitVerCon  := Posicione("SA2",1,xFilial("SA2")+M->CPW_CODIGO+M->CPW_LOJA,'A2_DVCTA')
		cConta := Posicione("SA2",1,xFilial("SA2")+M->CPW_CODIGO+M->CPW_LOJA,'A2_NUMCON')

		If Empty(cFormPag)
			Help(, ,"AVISO#0019", ,"Fornecedor n�o possui forma de pagamento cadastrada.",1, 0, , , , , , {"Preencher o campo Forma de Pagamento no cadastro desse fornecedor."})
			lRetorno := .F.
		Else
			If cFormPag $ cPagamento
				If Empty(cBanco) .OR. Empty(cAgencia) .OR. Empty(cDigitVerCon) .OR. Empty(cConta)

					Help(, ,"AVISO#0020", ,"Diverg�ncia de informa��es.",1, 0, , , , , , {"Preencher os seguintes campos no cadastro deste fornecedor : " + CHR(13) + " 1-Banco" + CHR(13) + "2-Ag�ncia" + CHR(13) + "3-D�gito verificador da ag�ncia" + CHR(13) + "4-N�mero da conta" + CHR(13) + "5-D�gito verificador da conta"})
					lRetorno := .F.
				Else
					lRetorno := .T.
				EndIf
			EndIF
		EndIf
	EndIf*/

Return lRetorno
