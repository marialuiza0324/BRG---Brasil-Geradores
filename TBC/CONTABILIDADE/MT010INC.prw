//Bibliotecasxsa
#include "rwmake.ch"
#Include "TOTVS.ch"
#INCLUDE "topconn.ch"
#include "fwmvcdef.ch"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT010INC   ¦ Autor ¦ Claudio Ferreira   ¦ Data ¦ 08/05/2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada apos a inclusao do produto                ¦¦¦
¦¦¦          ¦ Utilizado para avisar a CTB                                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MT010INC()

	Local aFilial := {}
	Local cFil := SuperGetMV("MV_FILREPL", ,"")
	Local nX
	Local aArea := GetArea()
	Local aAreaB1 := SB1->(GetArea())
	Static cTabelaAux := ''
	Static cChaveAux  := ''
	Static cFilAtuAux := ''
	Static cCodAtuAux := ''
	Static cCodNovAux := ''
	Static cFilNovAux:= ''
	Static cDestino := SuperGetMV("MV_RELFROM", ,"")
	Static aFiliaisCopiadas := {}

/*
	Tabela
	Campo Chave
	Filial Atual
	Chave Atual
	Filial Nova
	Chave Nova
	*/
	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))

	If SBM->(MsSeek(FWxFilial("SBM") + SB1->B1_GRUPO)) // busca grupo na tabela SBM

		If SBM->BM_XREPLIC = "1" // Verifica se grupo se enquadra na réplica do produto

			aFilial:= StrTokArr(cFil, ",") //Transforma conteúdo do parâmetro em array

			cTabelaAux := 'SB1'
			cChaveAux  := 'B1_COD'
			cFilAtuAux := FWCodEmp()
			cCodAtuAux := SB1->B1_COD
			cCodNovAux := SB1->B1_COD
			For nX:=1 to Len(aFilial) //Percorre a estrutura
				cFilNovAux:= aFilial[nX]

				// Validação para ignorar a filial logada
				If cFilNovAux <> FWCodEmp()
					Processa({|| fCopia()},'Replicando Registo...')
					aAdd(aFiliaisCopiadas, cFilNovAux) // Adiciona à lista de copiadas
				EndIf
			Next

			FwAlertInfo("Cópia concluída.", "Atenção")
			EnviarEmailProduto(cDestino, SB1->B1_COD, SB1->B1_DESC, aFiliaisCopiadas)

		EndIf
	EndIF

	SBM->(DbCloseArea())
	RestArea(aAreaB1)
	RestArea(aArea)

Return

Static Function fCopia()

	Local aArea     := GetArea()
	Local aEstru    := {}
	Local aConteu   := {}
	Local nPosFil   := 0
	Local cCampoFil := ""
	Local cQryAux   := ""
	Local nAtual    := 0

	DbSelectArea(cTabelaAux)

	//Pega a estrutura da tabela
	aEstru := (cTabelaAux)->(DbStruct())

	//Encontra o campo filial
	nPosFil   := aScan(aEstru, {|x| "FILIAL" $ AllTrim(Upper(x[1]))})
	cCampoFil := aEstru[nPosFil][1]

	//Faz uma consulta sql trazendo o RECNO
	cQryAux := " SELECT "
	cQryAux += "     R_E_C_N_O_ AS DADREC "
	cQryAux += " FROM "
	cQryAux += "     "+RetSQLName(cTabelaAux)+" "
	cQryAux += " WHERE "
	cQryAux += "     "+cCampoFil+" = '"+cFilAtuAux+"' "
	cQryAux += "     AND "+cChaveAux+" = '"+cCodAtuAux+"' "
	cQryAux += "     AND D_E_L_E_T_ = ' ' "
	TCQuery cQryAux New Alias "QRY_AUX"

	//Caso exista registro
	If ! QRY_AUX->(EoF())
		//Posiciona nesse recno
		(cTabelaAux)->(DbGoTo(QRY_AUX->DADREC))

		//Percorre a estrutura
		ProcRegua(Len(aEstru))
		For nAtual := 1 To Len(aEstru)
			IncProc("Adicionando valores ("+cValToChar(nAtual)+" de "+cValToChar(Len(aEstru))+")...")

			//Se for campo filial
			If Alltrim(aEstru[nAtual][1]) == Alltrim(cCampoFil)
				aAdd(aConteu, cFilNovAux)

				//Se for o campo de código
			ElseIf Alltrim(aEstru[nAtual][1]) == Alltrim(cChaveAux)
				aAdd(aConteu, cCodNovAux)

				//Se não, adiciona
			Else
				aAdd(aConteu, &(cTabelaAux+"->"+aEstru[nAtual][1]))
			EndIf
		Next

		IncProc("Criando o registro...")
		//Faz um RecLock
		RecLock(cTabelaAux, .T.)
		//Percorre a estrutura
		For nAtual := 1 To Len(aEstru)
			//Grava o novo valor
			&(aEstru[nAtual][1]) := aConteu[nAtual]
		Next
		(cTabelaAux)->(MsUnlock())

	EndIf
	QRY_AUX->(DbCloseArea())

	RestArea(aArea)
Return

Static Function EnviarEmailProduto(cDestino, cCodProduto, cDescProduto, aFiliaisCopiadas)

	Local cAviso:='Inclusão de novo Produto'
	Local xHTM := ""
	Local cFiliais := ArrTokStr(aFiliaisCopiadas, ",")

	if !empty(cDestino)
		//Envia email de Aviso
		xHTM := '<HTML><BODY>'
		xHTM += '<hr>'
		xHTM += '<p  style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
		xHTM += '<b><font face="Verdana" SIZE=3>'+cAviso+' &nbsp; '+dtoc(date())+'&nbsp;&nbsp;&nbsp;'+time()+'</b></p>'
		xHTM += '<hr>'
		xHTM += '<br>'
		xHTM += '<br>'
		xHTM += 'Foi incluido um novo Produto <BR><BR>-Código <b>'  +cCodProduto+' - '+cDescProduto+'</b> <BR>-Usuario <b>'+UsrRetName(RetCodUsr())+'</b> <br><br>'
		xHTM += '<b>Filiais onde o produto foi replicado:</b><BR>'
		xHTM += '<ul>'
		xHTM += '<li>' + cFiliais + '</li>'
		xHTM += '</ul>'
		xHTM += '<BR>'
		xHTM += 'Ação: Verifique os cadastros nas filiais listadas e valide os dados.<br><br>'
		xHTM += '</BODY></HTML>'

		//Parametros necessarios para a rotina
		// MV_RELACNT - Conta a ser utilizada no envio de E-Mail
		// MV_RELFROM - E-mail utilizado no campo FROM no envio
		// MV_RELSERV - Nome do Servidor de Envio de E-mail utilizado no envio
		// MV_RELAUTH - Determina se o Servidor de Email necessita de Autenticação
		// MV_RELAUSR - Usuário para Autenticação no Servidor de Email
		// MV_RELAPSW - Senha para Autenticação no Servidor de Email

		oMail := SendMail():new()

		oMail:SetTo(cDestino)
		//oMail:SetCc('') // (opc)
		oMail:SetFrom(Alltrim(GetMv("MV_RELFROM",," ")))
		//oMail:SetAttachment('\system\siga.txt') //Anexo (opc)
		oMail:SetSubject('Aviso - '+cAviso)
		oMail:SetBody(xHTM)
		oMail:SetShedule(.f.) //(opc) Default .f. - define modo Schedule
		oMail:SetEchoMsg(.f.) //(opc) Default .t. - define se exibe mensagens automaticamente na Tela (Schedule .f.) / Console (Schedule .t.)
		oMail:Send()
	endif


Return
