#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*/{Protheus.doc} MA020TOK 

    @type  Function
    Fun��o de Valida��o da digita��o, na inclus�o, altera��o ou exclus�o do Fornecedor.
    Nas valida��es ap�s a confirma��o, antes da grava��o do fornecedor, deve ser utilizado
    para valida��es adicionais para a INCLUS�O do fornecedor.
    @author Maria Luiza
    @since 07/05/2025
    /*/

User Function MA020TOK()

	Local cPagamento := SupergetMv("MV_FORMPAG", , )
	Local cEmpresa := SupergetMv("MV_EMPPAG", , )
	Local cCodEmp := FWCodEmp()
	Local lRet := .T.


	If cCodEmp $ cEmpresa
		If M->A2_FORMPAG $ cPagamento
			If Empty(M->A2_BANCO) .OR. Empty(M->A2_AGENCIA) .OR. Empty(M->A2_DVCTA) .OR. Empty(M->A2_NUMCON)

				Help(, ,"AVISO#0020", ,"Diverg�ncia de informa��es.",1, 0, , , , , , {"Preencher os seguintes campos no cadastro deste fornecedor : " + CHR(13) + " 1-Banco" + CHR(13) + "2-Ag�ncia" + CHR(13) + "3-D�gito verificador da ag�ncia" + CHR(13) + "4-N�mero da conta" + CHR(13) + "5-D�gito verificador da conta"})
				lRet := .F.
			Else
				lRet := .T.
			EndIf
		EndIF
	EndIf


Return lRet
