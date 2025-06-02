#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*/{Protheus.doc} MA020TOK 

    @type  Function
    Função de Validação da digitação, na inclusão, alteração ou exclusão do Fornecedor.
    Nas validações após a confirmação, antes da gravação do fornecedor, deve ser utilizado
    para validações adicionais para a INCLUSÃO do fornecedor.
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

				Help(, ,"AVISO#0020", ,"Divergência de informações.",1, 0, , , , , , {"Preencher os seguintes campos no cadastro deste fornecedor : " + CHR(13) + " 1-Banco" + CHR(13) + "2-Agência" + CHR(13) + "3-Dígito verificador da agência" + CHR(13) + "4-Número da conta" + CHR(13) + "5-Dígito verificador da conta"})
				lRet := .F.
			Else
				lRet := .T.
			EndIf
		EndIF
	EndIf


Return lRet
