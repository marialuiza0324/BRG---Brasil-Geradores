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
	Local i
	Static cTabelaAux := ''
	Static cChaveAux  := ''
	Static cFilAtuAux := ''
	Static cCodAtuAux := ''
	Static cCodNovAux := ''
	Static cFilNovAux:= ''
	Static cDestino := "maria.luiza@brggeradores.com.br"
	Static aFiliaisCopiadas := {}
	Static cTitulo:='Inclusão de novo Produto'
	Static xHTM := ""

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

			if !empty(cDestino)
				//Envia email de Aviso
				xHTM := '<HTML><BODY>'
				xHTM += '<hr>'
				xHTM += '<p  style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
				xHTM += '<b><font face="Verdana" SIZE=3>'+cTitulo+' &nbsp; '+dtoc(date())+'&nbsp;&nbsp;&nbsp;'+time()+'</b></p>'
				xHTM += '<hr>'
				xHTM += '<br>'
				xHTM += '<br>'
				xHTM += 'Foi incluido um novo Produto <BR><BR>-Código <b>'   +SB1->B1_COD+' - '+SB1->B1_DESC+'</b> <BR>-Usuario <b>'+UsrRetName(RetCodUsr())+'</b> <br><br>'
				xHTM += '<b>Empresas onde o produto foi replicado:</b><BR>'
				xHTM += '<ul>'
				For i := 1 To Len(aFiliaisCopiadas)
					// Seleciona a tabela SM0 para buscar a descrição da filial
					DbSelectArea("SM0")
					SM0->(DbSetOrder(1)) // Certifique-se de que o índice está ordenando pela filial
					If SM0->(MsSeek(aFiliaisCopiadas[i])) // Busca pela filial
						xHTM += '<li>' + aFiliaisCopiadas[i] + " - " + Alltrim(SM0->M0_NOMECOM) + '</li>' +CHR(13)+CHR(10)
					Else
						xHTM += '<li>' + aFiliaisCopiadas[i] + " - Descrição não encontrada" + '</li>' + CHR(13) + CHR(10)
					EndIf
				Next i
				xHTM += '</ul>'
				xHTM += '<BR>'
				xHTM += 'Ação: Verifique os cadastros nas empresas listadas e valide os dados.<br><br>'
				xHTM += '</BODY></HTML>'
			EndIf

			//Chama o disparo do e-Mail
			U_zEnvMail(cDestino, cTitulo, xHTM, {})


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

User Function zEnvMail(cPara, cAssunto, xHTM, aAnexos)

	Local aArea    := GetArea()
	Local lEnvioOK := .F.

	lEnvioOK := GPEMail(cAssunto, xHTM, cPara, aAnexos)

	RestArea(aArea)
Return lEnvioOK

