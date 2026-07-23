//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSCOM007
Serviço REST para exclusão da Solicitação de compras
@author Maria Luiza
@since 22/07/2026
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSCOM007 DESCRIPTION 'Serviço REST para exclusão da Solicitação de compras'
	//Métodos
	WSMETHOD DELETE ERASE  DESCRIPTION 'Exclusão de registro'          WSSYNTAX '/WSCOM007/erase'                             PATH 'erase'         PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD DELETE ERASE
Apaga o registro na tabela
@author Maria Luiza
@since 22/07/2026
@version 1.0
@type method
@param id, Caractere, String que será pesquisada através do MsSeek

    Abaixo um exemplo do JSON que deverá vir no body
    * 1: Para campos do tipo Numérico, informe o valor sem usar as aspas
    * 2: Para campos do tipo Data, informe uma string no padrão 'YYYY-MM-DD'

    {
        "num": "conteudo",
        "filial": "conteudo"
    }
/*/

WSMETHOD DELETE ERASE WSSERVICE WSCOM007
	Local lRet              := .T.
	Local aCabSc            := {}
	Local aItensSC          := {}
	Local jJson             := Nil
	Local cJson             := Self:GetContent()
	Local cError            := ''
	Local nLinha            := 0
	Local cDirLog           := '\x_logs\'
	Local cArqLog           := ''
	Local cErrorLog         := ''
	Local aLogAuto          := {}
	Local jResponse         := JsonObject():New()
	Local cAliasWS          := 'SC1'
	Private lMsErroAuto     := .F.
	Private lMsHelpAuto     := .T.
	Private lAutoErrNoFile  := .T.

	//Se não existir a pasta de logs, cria
	IF ! ExistDir(cDirLog)
		MakeDir(cDirLog)
	EndIF

	//Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
	Self:SetContentType('application/json')
	jJson  := JsonObject():New()
	cError := jJson:FromJson(cJson)

	If Empty(jJson:GetJsonObject("filial")) .Or. Empty(jJson:GetJsonObject("num"))
		Self:SetStatus(400)
		jResponse["error"] := "Filial e número são obrigatórios"
		Self:SetResponse(EncodeUTF8(jResponse:ToJson()))
	EndIf

	DbSelectArea(cAliasWS)
	(cAliasWS)->(DbSetOrder(1))

	//Se não encontrar o registro
	If ! (cAliasWS)->(MsSeek(jJson:GetJsonObject('filial') + jJson:GetJsonObject('num')))
		//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'DEL011'
		jResponse['error']    := 'SC não encontrada'
		jResponse['solution'] := 'SC não encontrada na tabela ' + cAliasWS
	Else

		//Se tiver algum erro no Parse, encerra a execução
		If ! Empty(cError)
			//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'DEL012'
			jResponse['error']    := 'Parse do JSON'
			jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		Else
			DbSelectArea(cAliasWS)

			//Adiciona os dados do ExecAuto
			AAdd(aCabSc, {"C1_FILIAL",  jJson:GetJsonObject("filial"), Nil})
			AAdd(aCabSc, {"C1_NUM",     jJson:GetJsonObject("num"),    Nil})
			AAdd(aCabSc, {"C1_SOLICIT", SC1->C1_SOLICIT,               Nil})
			AAdd(aCabSc, {"C1_EMISSAO", SC1->C1_EMISSAO,               Nil})

			aItensSC := {}

			//Chama a exclusão automática
			MSExecAuto({|x,y| mata110(x,y,5)},aCabSC,aItensSC)

			//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
			If lMsErroAuto
				//Monta o texto do Error Log que será salvo
				cErrorLog   := ''
				aLogAuto    := GetAutoGrLog()
				For nLinha := 1 To Len(aLogAuto)
					cErrorLog += aLogAuto[nLinha] + CRLF
				Next nLinha

				//Grava o arquivo de log
				cArqLog := 'WSCOM007_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
				MemoWrite(cDirLog + cArqLog, cErrorLog)

				ConOut(cErrorLog)

				//Define o retorno para o WebService
				//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
				Self:setStatus(500)
				jResponse['errorId']  := 'DEL013'
				jResponse['error']    := cErrorLog
				jResponse['solution'] := 'Nao foi possivel excluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
				lRet := .F.

				//Senão, define o retorno
			Else
				jResponse['note']     := 'Registro excluido com sucesso'
			EndIf

		EndIf
	EndIf


	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet
