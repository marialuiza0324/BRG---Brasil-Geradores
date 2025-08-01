#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*/{Protheus.doc} MT161OK

    @type  Function
    O ponto de entrada MT161OK � usado para 
    validar as propostas dos fornecedores no momento 
    da grava��o da an�lise da cota��o, ap�s o fechamento 
    da tela. Se .T. finaliza o processo. Se .F., interrompe o processo.
    @author Maria Luiza
    @since 29/05/2025
    /*/


User Function MT161OK()

	Local lRetPE  := .T.
	/*Local cFormPag := ""
	Local cPagamento := SupergetMv("MV_FORMPAG", , )
	Local cBanco := ""
	Local cAgencia := ""
	Local cDigitVerCon  := ""
	Local cConta := ""
	Local cEmpresa := SupergetMv("MV_EMPPAG", , )
	Local cCodEmp := FWCodEmp()


	If cCodEmp $ cEmpresa //verifica se a empresa � a mesma da MV
		//obt�m informa��es do cadastro de fornecedores
		cFormPag := Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,'A2_FORMPAG')
		cBanco := Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,'A2_BANCO')
		cAgencia := Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,'A2_AGENCIA')
		cDigitVerCon  := Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,'A2_DVCTA')
		cConta := Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,'A2_NUMCON')

		If Empty(cFormPag)//se o fornecedor n�o tiver nenhuma forma de pagamento cadastrada, exibe alerta e n�o permite a inclus�o do documento
			Help(, ,"AVISO#0019", ,"Fornecedor n�o possui forma de pagamento cadastrada.",1, 0, , , , , , {"Preencher o campo Forma de Pagamento no cadastro desse fornecedor."})
			lRetPE := .F.
		Else
			If cFormPag $ cPagamento
				If Empty(cBanco) .OR. Empty(cAgencia) .OR. Empty(cDigitVerCon) .OR. Empty(cConta)

					Help(, ,"AVISO#0020", ,"Diverg�ncia de informa��es.",1, 0, , , , , , {"Preencher os seguintes campos no cadastro deste fornecedor : " + CHR(13) + " 1-Banco" + CHR(13) + "2-Ag�ncia" + CHR(13) + "3-D�gito verificador da ag�ncia" + CHR(13) + "4-N�mero da conta" + CHR(13) + "5-D�gito verificador da conta"})
					lRetPE := .F.
				Else
					lRetPE := .T.
				EndIf
			EndIF
		EndIf
	EndIf*/

Return lRetPE
