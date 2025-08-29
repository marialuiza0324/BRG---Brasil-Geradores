#INCLUDE 'totvs.ch'
#INCLUDE 'protheus.ch'


/*/{Protheus.doc} MT681AIN 

MT680VAL - Inclus�o das Produ��es
� chamado na confirma��o da inclus�o das produ��es PCP, modelo I e II (fun��o A680TudoOk()).
� utilizado para validar a inclus�o do apontamento das produ��es PCP.
Para verificar de qual programa esta chamando a fun��o, utilize as vari�veis Private l680,l681,l682 e l250 a partir da vers�o 6.09.

Tipo de Retorno:
lRet(logico)
Em caso de retorno afirmativo (.T.), permite incluir o apontamento.
Em caso de retorno negativo (.F.), nao permite incluir o apontamento.

Observa��es:
Caso for utilizada a rotina autom�tica do MATA241 - Movimenta��o Interna, pelo ponto de entrada MT680VAL, dever�o ser declaradas as seguintes vari�veis do tipo Private: Private l250, l240, l241 . Conforme exemplo abaixo.


@type user function
@author Maria Luiza
@since 05/06/2024
@version 0.0001
@example
(examples)
)
/*/

/*Ajuste 07/08/2024 - Autora: Maria Luiza - Solicitante: Bruno Martins 
- se houver pend�ncia de baixa de produtos n�o pode ser permitido apontamento;
- em caso de devolu��o de produto (via movimenta��o m�ltipla), o produto s� 
deve ser movimentado ap�s confirma��o de que ele realmente est� dentro da OP.*/

User Function MT680VAL()

	Local lRet      := .T.
	Local cOper     := H6_OPERAC
	Local cGrupo    := Alltrim(H6_XGRUPO)
	//Local cAlter    := Alltrim(M->H6_XALTERN)
	//Local cMotor    := Alltrim(M->H6_XMOTOR)
	Local cLoteCtl  := Posicione('SB1', 1, FWxFilial('SB1') + ALLTRIM(H6_PRODUTO), 'B1_RASTRO')
	Local cLote     := H6_LOTECTL
	Local cOp       := Alltrim(H6_OP)
	Local cQuery    := ""
	//Local cQry      := ""
	Local cMensagem := ""
	Local nTotal1   := 0
	Local nTotal2   := 0
	Local nValid    := 0
	Local lCampo := .T.
	Local lLote  := .T.
    Local nQtdReq   := 0   // Quantidade total requisitada
	Local cPara    := SuperGetMV("MV_EMAILOP", ,"") // Par�metro para destinat�rios do e-mail de apontamento de OP
	Local cAssunto := "Aten��o: OP sem Baixa de mat�ria-prima"
	Local xHTM     := ""
	Local aAnexos  := {}
	Local lObrig   := .T.
	Local cHoraIni := H6_HORAINI
	Local cHoraFim := H6_HORAFIN
	Local cOperador := H6_OPERADO


		If empty(cHoraFim) .OR. empty(cHoraIni) .OR. empty(cOperador)
				Help(, ,"AVISO#0032", ,"Preencha os campos Hora Inicial,Hora Final e Operador pois s�o obrigat�rios.",1, 0, , , , , , {" "})
				lObrig := .F.
				lRet := .F.
		Else
				lObrig := .T.
				lRet := .T.
		EndIf


		While  cOper == 'M1'

			IF empty(cGrupo) //.OR. empty(cAlter) .OR. empty(cMotor)
			 Help(, ,"AVISO#0029", ,"Preencha o campo N� de s�rie do Grupo, pois ele � obrigat�rio para opera��o M1.",1, 0, , , , , , {" "})
				lCampo := .F.
				lRet := .F.
				Exit
			Else
				lCampo := .T.
				Exit
			EndIf

			If empty(cHoraFim) .OR. empty(cHoraIni) .OR. empty(cOperador)
				Help(, ,"AVISO#0032", ,"Preencha os campos Hora Inicial,Hora Final e Operador pois s�o obrigat�rios.",1, 0, , , , , , {" "})
				lObrig := .F.
				Exit
			Else
				lCampo := .T.
				Exit
			EndIf

		EndDo

	If cOper == "Z1"  .AND. M->H6_PT = "T"

					If Select("TSCP") > 0
						TSCP->(dbCloseArea())
					EndIf

					cQuery := "SELECT COUNT(CP_FILIAL) AS TOTAL_SA FROM SCP010 SCP "
					cQuery += "WHERE SCP.D_E_L_E_T_ <> '*' "
					cQuery += "AND SCP.CP_PREREQU = 'S' "
					cQuery += "AND SCP.CP_STATUS <> 'E' "
					cQuery += "AND SCP.CP_QUANT <> SCP.CP_QUJE "
					cQuery += "AND SCP.CP_OP = '"+cOp+"' "

					DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TSCP",.T.,.T.)

					DbSelectArea("TSCP") 

					nTotal1 := TSCP->TOTAL_SA

					If  nTotal1 > 0
						nValid += nTotal1
						cMensagem += '<font color="red"><b>'+cValtochar(nTotal1)+'</b></font> Solicita��es manuais ou geradas por firmamento de OP pendentes de baixa!!!' +CHR(13)
					EndIf

					TSCP->(DbCloseArea())

					/*If Select("TSD4") > 0
						TSD4->(dbCloseArea())
					EndIf

					cQry := "SELECT COUNT(D4_FILIAL) AS TOTAL FROM SD4010 SD4 "
					cQry += "WHERE SD4.D_E_L_E_T_ <> '*' "
					cQry += "AND SD4.D4_OP = '"+cOp+"' "
					cQry += "AND SD4.D4_QUANT > 0 "

					DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TSD4",.T.,.T.)

					DbSelectArea("TSD4") 

					nTotal2 := TSD4->TOTAL

					If  nTotal2 > 0
						nValid += nTotal2
						cMensagem += 'Ordem de Produ��o possui <font color="red"><b>'+cValtochar(nTotal2)+'</b></font> empenhos em aberto ou Parcialmente Baixado!!!' +CHR(13)
					EndIf

					TSD4->(DbCloseArea())*/

					If Empty(cLote) .AND. cLoteCtl ==  "L"
						Help(, ,"AVISO#0030", ,"Preencher o campo LOTE, pois produto possui restreabilidade.",1, 0, , , , , , {" "})
						lLote := .F.
						lRet := .F.
					Else
						lLote := .T.
					Endif

					If cMensagem <> ""
						Help(, ,"AVISO#0031", ,cMensagem,1, 0, , , , , , {"Corrija as pend�ncias para prosseguir cpom o apontamento."})
					EndIf

					If empty(cHoraFim) .OR. empty(cHoraIni) .OR. empty(cOperador)
						Help(, ,"AVISO#0032", ,"Preencha os campos Hora Inicial,Hora Final e Operador pois s�o obrigat�rios.",1, 0, , , , , , {" "})
						lObrig := .F.
					Else
						lObrig := .T.
					EndIf

					If nTotal1 > 0 .OR. nTotal2 > 0 .OR. !lCampo .OR. !lLote .OR. !lObrig
						lRet := .F.
					Else
						lRet := .T.
					EndIf



				/*Verifica��o e disparo de e-mail  
				quando n�o houver nenhuma requisi��o dentro da OP.
				Solicitante: Matheus Souza - #GLPI 9463 e Kathlen Tainan #GLPI 10152
				Ajuste: 07/08/2024 - Maria Luiza
				*/

				// Executa a query
				If Select("TSD3") > 0
					TSD3->(DbCloseArea())
				EndIf

				// Monta a query para verificar se h� requisi��es na tabela SD3 para a OP
				cQuery := "SELECT SUM(D3_QUANT) AS QTDREQ "
				cQuery += "FROM " + RetSQLName("SD3") + " SD3 "
				cQuery += "WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' "
				cQuery += "AND SD3.D3_OP = '" + cOP + "' "
				cQuery += "AND SD3.D_E_L_E_T_ = ' '"


				DbUseArea(.T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "TSD3", .T., .T.)

				// Verifica o resultado
				If !TSD3->(Eof())
					nQtdReq := TSD3->QTDREQ
				EndIf

				// Fecha o alias tempor�rio
				DbSelectArea("TSD3")
				TSD3->(DbCloseArea())

				// Valida��o: bloqueia se n�o houver requisi��es
				If nQtdReq <= 0

					// Monta o corpo do e-mail para aus�ncia de requisi��es de mat�ria-prima
					xHTM := "<html><body>" + CRLF
					xHTM += "<p>Informamos que o usu�rio <b>" + AllTrim(UsrFullName(RetCodUsr())) + " (" + AllTrim(RetCodUsr()) + ")</b> realizou o apontamento da Ordem de Produ��o <b>" + cOp + "</b>.<br>" + CRLF
					xHTM += "Contudo, n�o foram identificadas baixas de mat�ria-prima associadas a esta OP.</p>" + CRLF
					xHTM += "<p>Solicitamos, por gentileza, a verifica��o do apontamento de produ��o para garantir a conformidade do processo.</p>" + CRLF
					xHTM += "<p>Atenciosamente,</p>" + CRLF
					xHTM += "</body></html>"

					// Envia e-mail informando aus�ncia de requisi��es de mat�ria-prima para a OP
					U_zEnvMail(cPara, cAssunto, xHTM, aAnexos)
				EndIf

			ElseIF cOper == "Z1" .AND. M->H6_PT = "P"

											/*Verifica��o e disparo de e-mail  
											quando n�o houver nenhuma requisi��o dentro da OP.
											Solicitante: Matheus Souza - #GLPI 9463 e Kathlen Tainan #GLPI 10152
											Ajuste: 07/08/2024 - Maria Luiza
											*/

				// Executa a query
				If Select("TSD3") > 0
					TSD3->(DbCloseArea())
				EndIf

				// Monta a query para verificar se h� requisi��es na tabela SD3 para a OP
				cQuery := "SELECT SUM(D3_QUANT) AS QTDREQ "
				cQuery += "FROM " + RetSQLName("SD3") + " SD3 "
				cQuery += "WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' "
				cQuery += "AND SD3.D3_OP = '" + cOP + "' "
				cQuery += "AND SD3.D_E_L_E_T_ = ' '"


				DbUseArea(.T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "TSD3", .T., .T.)

				// Verifica o resultado
				If !TSD3->(Eof())
					nQtdReq := TSD3->QTDREQ
				EndIf

				// Fecha o alias tempor�rio
				DbSelectArea("TSD3")
				TSD3->(DbCloseArea())

				// Valida��o: bloqueia se n�o houver requisi��es
				If nQtdReq <= 0

					// Monta o corpo do e-mail para aus�ncia de requisi��es de mat�ria-prima
					xHTM := "<html><body>" + CRLF
					xHTM += "<p>Informamos que o usu�rio <b>" + AllTrim(UsrFullName(RetCodUsr())) + " (" + AllTrim(RetCodUsr()) + ")</b> realizou o apontamento Parcial da Ordem de Produ��o <b>" + cOp + "</b>.<br>" + CRLF
					xHTM += "Contudo, n�o foram identificadas baixas de mat�ria-prima associadas a esta OP.</p>" + CRLF
					xHTM += "<p>Solicitamos, por gentileza, a verifica��o do apontamento de produ��o para garantir a conformidade do processo.</p>" + CRLF
					xHTM += "<p>Atenciosamente,</p>" + CRLF
					xHTM += "</body></html>"

					// Envia e-mail informando aus�ncia de requisi��es de mat�ria-prima para a OP
					U_zEnvMail(cPara, cAssunto, xHTM, aAnexos)
				EndIf

					If empty(cHoraFim) .OR. empty(cHoraIni) .OR. empty(cOperador)
						Help(, ,"AVISO#0032", ,"Preencha os campos Hora Inicial,Hora Final e Operador pois s�o obrigat�rios.",1, 0, , , , , , {" "})
						lRet := .F.
					Else
						lRet := .T.
					EndIf

			EndIf // Fim do cOper == "Z1" .AND. M->H6_PT = "T"

Return lRet


