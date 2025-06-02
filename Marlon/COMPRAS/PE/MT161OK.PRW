#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*/{Protheus.doc} MT161OK

    @type  Function
    O ponto de entrada MT161OK é usado para 
    validar as propostas dos fornecedores no momento 
    da gravação da análise da cotação, após o fechamento 
    da tela. Se .T. finaliza o processo. Se .F., interrompe o processo.
    @author Maria Luiza
    @since 29/05/2025
    /*/


User Function MT161OK()

	Local lRetPE  := .T.
	Local cFormPag := ""
	Local cPagamento := SupergetMv("MV_FORMPAG", , )
	Local cBanco := ""
	Local cAgencia := ""
	Local cDigitVerCon  := ""
	Local cConta := ""
	Local cEmpresa := SupergetMv("MV_EMPPAG", , )
	Local cCodEmp := FWCodEmp()


	If cCodEmp $ cEmpresa //verifica se a empresa é a mesma da MV
		//obtém informações do cadastro de fornecedores
		cFormPag := Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,'A2_FORMPAG')
		cBanco := Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,'A2_BANCO')
		cAgencia := Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,'A2_AGENCIA')
		cDigitVerCon  := Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,'A2_DVCTA')
		cConta := Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,'A2_NUMCON')

		If Empty(cFormPag)//se o fornecedor não tiver nenhuma forma de pagamento cadastrada, exibe alerta e não permite a inclusão do documento
			Help(, ,"AVISO#0019", ,"Fornecedor não possui forma de pagamento cadastrada.",1, 0, , , , , , {"Preencher o campo Forma de Pagamento no cadastro desse fornecedor."})
			lRetPE := .F.
		Else
			If cFormPag $ cPagamento
				If Empty(cBanco) .OR. Empty(cAgencia) .OR. Empty(cDigitVerCon) .OR. Empty(cConta)

					Help(, ,"AVISO#0020", ,"Divergência de informações.",1, 0, , , , , , {"Preencher os seguintes campos no cadastro deste fornecedor : " + CHR(13) + " 1-Banco" + CHR(13) + "2-Agência" + CHR(13) + "3-Dígito verificador da agência" + CHR(13) + "4-Número da conta" + CHR(13) + "5-Dígito verificador da conta"})
					lRetPE := .F.
				Else
					lRetPE := .T.
				EndIf
			EndIF
		EndIf
	EndIf

Return lRetPE
