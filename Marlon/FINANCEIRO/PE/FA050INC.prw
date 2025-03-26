#include 'totvs.ch'

/*/{Protheus.doc} FA050INC()
 
    A finalidade do ponto de entrada FA050INC � permitir valida��es de usu�rio
    na inclus�o do Contas a Pagar (FINA050), localizado no TudoOK da rotina.
 
    @return lRet - l�gico, .T. valida a inclus�o e continua o processo,
        caso contr�rio .F. e interrompe o processo.
/*/
User Function FA050INC()

	Local lRet := .T.

	If Alltrim(M->E2_TIPO) == "PA" .AND. Empty(M->E2_XJUSTIF)
		FwAlertInfo("Para pagamentos do tipo PA, o campo JUSTIFICATIVA deve ser preenchido","Anten��o!!!")
		lRet := .F.
	Elseif Len(Alltrim(M->E2_XJUSTIF)) < 30 .AND. Alltrim(M->E2_TIPO) == "PA"
		FwAlertInfo("O campo de justificativa deve conter no m�nimo 20 caracteres","Anten��o!!!")
		lRet := .F.
	EndIf


Return lRet
