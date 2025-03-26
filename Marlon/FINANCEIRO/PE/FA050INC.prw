#include 'totvs.ch'

/*/{Protheus.doc} FA050INC()
 
    A finalidade do ponto de entrada FA050INC é permitir validações de usuário
    na inclusão do Contas a Pagar (FINA050), localizado no TudoOK da rotina.
 
    @return lRet - lógico, .T. valida a inclusão e continua o processo,
        caso contrário .F. e interrompe o processo.
/*/
User Function FA050INC()

	Local lRet := .T.

	If Alltrim(M->E2_TIPO) == "PA" .AND. Empty(M->E2_XJUSTIF)
		FwAlertInfo("Para pagamentos do tipo PA, o campo JUSTIFICATIVA deve ser preenchido","Antenção!!!")
		lRet := .F.
	Elseif Len(Alltrim(M->E2_XJUSTIF)) < 30 .AND. Alltrim(M->E2_TIPO) == "PA"
		FwAlertInfo("O campo de justificativa deve conter no mínimo 20 caracteres","Antenção!!!")
		lRet := .F.
	EndIf


Return lRet
