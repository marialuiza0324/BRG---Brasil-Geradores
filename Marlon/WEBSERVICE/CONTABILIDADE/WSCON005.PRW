//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSCON005
Serviço REST para exclusão de rateio externo (CTJ)
@author Maria Luiza
@since 18/08/2026
@version 3.0
@type wsrestful

    Complementa o WSCON002 (consulta de rateios), utilizando exatamente
    a mesma tabela, os mesmos campos e a mesma chave logica:

        CTJ_FILIAL + CTJ_RATEIO + CTJ_SEQUEN

    ESCOPO DA EXCLUSAO
    ------------------
    Este servico exclui SEMPRE O RATEIO INTEIRO: todas as faixas do
    codigo de rateio na filial. A sequencia nao e recebida.

    Nao e possivel excluir uma faixa isolada por aqui - e proposital.
    Remover uma faixa deixaria o rateio somando menos de 100%, quebrando
    a mesma regra que o WSCON003 e o WSCON004 exigem. Para remover uma
    faixa, utilize o WSCON004 enviando o estado final ja rebalanceado:
    a faixa ausente do array e excluida e os percentuais das demais sao
    informados na mesma requisicao, de forma atomica.

    A exclusao segue o padrao de escrita direta ja adotado no projeto
    (WSFIN003): localizacao por query retornando R_E_C_N_O_,
    posicionamento com DbGoTo e exclusao com RecLock / DbDelete /
    MsUnlock.

    CONCORRENCIA E ATOMICIDADE
    --------------------------
    A exclusao ocorre dentro do mesmo semaforo exclusivo (LockByName) por
    empresa + filial utilizado pelo WSCON003 e pelo WSCON004, e dentro de
    um Begin Transaction. Assim nenhuma faixa e removida enquanto outra
    requisicao esta montando ou alterando o rateio, e a falha em qualquer
    faixa desfaz toda a exclusao - o rateio nunca fica parcialmente
    excluido.
/*/

WSRESTFUL WSCON005 DESCRIPTION 'Servico REST para exclusao de rateio externo'

	//Atributos
	WSDATA      filial        AS STRING
	WSDATA      rateio        AS STRING

	//Métodos
	WSMETHOD DELETE ERASE  DESCRIPTION 'Exclusao de rateio externo'    WSSYNTAX '/WSCON005/erase'                             PATH 'erase'         PRODUCES APPLICATION_JSON

END WSRESTFUL

/*/{Protheus.doc} WSMETHOD DELETE ERASE
Exclui um rateio externo inteiro da tabela CTJ
@author Maria Luiza
@since 18/08/2026
@version 3.0
@type method

    Abaixo um exemplo do JSON que deverá vir no body
    * 1: filial e rateio sao obrigatorios
    * 2: NAO informe sequencia - este servico exclui o rateio inteiro

    {
        "filial": "0101",
        "rateio": "000035"
    }

    Para remover apenas UMA faixa, use o WSCON004 enviando o estado final
    do rateio. No exemplo abaixo a faixa 002 e excluida e os percentuais
    ficam concentrados na faixa 001:

    {
        "filial": "0101",
        "rateio": "000035",
        "rateios": [
            { "sequencia": "001", "percentual": 100 }
        ]
    }
/*/

WSMETHOD DELETE ERASE WSSERVICE WSCON005
	Local lRet              := .T.
	Local lOk               := .T.
	Local jJson             := Nil
	Local cJson             := Self:GetContent()
	Local cError            := ''
	Local jResponse         := JsonObject():New()
	Local jData             := Nil
	Local jResumo           := Nil
	Local aAtual            := {}
	Local aJsonRat          := {}
	Local cFilCTJ           := ''
	Local cRateio           := ''
	Local cSemaf            := ''
	Local nX                := 0
	Local cErrId            := ''
	Local cErrTit           := ''
	Local cErrMsg           := ''
	Local nErrSt            := 500

	//Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
	Self:SetContentType('application/json')
	jJson  := JsonObject():New()
	cError := jJson:FromJson(cJson)

	//O body precisa chegar ao servico
	If Empty(cJson)
		Return CN5Fault(Self, 400, 'DEL507', 'Body vazio', 'A requisicao chegou sem body. Confirme o envio do JSON e o header Content-Type: application/json')
	EndIf

	//Se tiver algum erro no Parse, encerra a execução
	If ! Empty(cError)
		Return CN5Fault(Self, 400, 'DEL501', 'Parse do JSON', 'Erro no Parse do JSON: ' + AllTrim(cValToChar(cError)) + ' | bytes recebidos: ' + AllTrim(Str(Len(cJson))))
	EndIf

	//Leitura dos parâmetros recebidos
	cFilCTJ := CN5Limpa(CN5GetC(jJson, 'filial'))
	cRateio := CN5Limpa(CN5GetC(jJson, 'rateio'))

	//Validação dos campos obrigatórios
	If Empty(cFilCTJ) .Or. Empty(cRateio)
		Return CN5Fault(Self, 400, 'DEL502', 'Campos obrigatorios', 'Os campos filial e rateio sao obrigatorios')
	EndIf

	//Rejeita a sequencia para nao dar a impressao de que ela seria considerada
	If CN5Tem(jJson, 'sequencia')
		Return CN5Fault(Self, 400, 'DEL510', 'Sequencia nao aceita', 'Este servico exclui o rateio inteiro e nao aceita o campo sequencia. Para remover apenas uma faixa, utilize o WSCON004 enviando o estado final do rateio')
	EndIf

	//Ajusta os tamanhos conforme o dicionário de dados
	cFilCTJ := PadR(cFilCTJ, TamSX3("CTJ_FILIAL")[1])
	cRateio := PadR(cRateio, TamSX3("CTJ_RATEIO")[1])

	/*
	    Inicio da secao critica. O semaforo e o mesmo utilizado pelo
	    WSCON003 e pelo WSCON004, de modo que nenhuma faixa e removida
	    enquanto outra requisicao esta montando ou alterando o rateio.
	*/
	cSemaf := 'CTJINC' + AllTrim(cEmpAnt) + AllTrim(cFilCTJ)

	If ! LockByName(cSemaf, .F., .F., .F.)
		Return CN5Fault(Self, 503, 'DEL508', 'Filial em uso', 'Outra requisicao esta manipulando rateio na filial ' + AllTrim(cFilCTJ) + '. Tente novamente em instantes')
	EndIf

	//Carrega todas as faixas do rateio
	aAtual := CN5Atual(cFilCTJ, cRateio)

	If Len(aAtual) == 0
		lOk     := .F.
		nErrSt  := 404
		cErrId  := 'DEL503'
		cErrTit := 'Rateio nao encontrado'
		cErrMsg := 'Nao existe o rateio ' + AllTrim(cRateio) + ' na filial ' + AllTrim(cFilCTJ)
	Else
		//Guarda os dados das faixas antes de remove-las
		For nX := 1 To Len(aAtual)
			AAdd(aJsonRat, CN5Json(aAtual[nX][2]))
		Next nX

		DbSelectArea("CTJ")

		Begin Transaction
			For nX := 1 To Len(aAtual)
				CTJ->(DbGoTo(aAtual[nX][2]))

				//Confere se o registro posicionado e realmente o solicitado
				If CTJ->(Eof()) .Or. CTJ->CTJ_FILIAL <> cFilCTJ .Or. CTJ->CTJ_RATEIO <> cRateio .Or. CTJ->CTJ_SEQUEN <> aAtual[nX][1]
					lOk     := .F.
					nErrSt  := 409
					cErrId  := 'DEL505'
					cErrTit := 'Registro divergente'
					cErrMsg := 'O registro posicionado na CTJ nao corresponde a sequencia ' + AllTrim(aAtual[nX][1]) + ' do rateio ' + AllTrim(cRateio) + '. Exclusao cancelada por seguranca'
					DisarmTransaction()
					Break
				EndIf

				If ! RecLock("CTJ", .F.)
					lOk     := .F.
					nErrSt  := 500
					cErrId  := 'DEL506'
					cErrTit := 'Erro na exclusao'
					cErrMsg := 'Nao foi possivel obter o bloqueio para excluir a sequencia ' + AllTrim(aAtual[nX][1]) + ' do rateio ' + AllTrim(cRateio)
					DisarmTransaction()
					Break
				EndIf

				CTJ->(DbDelete())
				CTJ->(MsUnLock())
			Next nX
		End Transaction
	EndIf

	//Libera o semaforo em qualquer cenario antes de responder
	UnLockByName(cSemaf, .F., .F., .F.)

	If ! lOk
		Return CN5Fault(Self, nErrSt, cErrId, cErrTit, cErrMsg)
	EndIf

	//Confere se o rateio foi efetivamente removido por completo
	aAtual := CN5Atual(cFilCTJ, cRateio)

	If Len(aAtual) > 0
		Return CN5Fault(Self, 500, 'DEL509', 'Rateio nao excluido', 'O rateio ' + AllTrim(cRateio) + ' ainda possui ' + AllTrim(Str(Len(aAtual))) + ' faixa(s) na CTJ apos a exclusao')
	EndIf

	//Retorno do resultado da operacao
	jData := JsonObject():New()
	jData['Filial']    := AllTrim(cFilCTJ)
	jData['CodRateio'] := AllTrim(cRateio)

	jResumo := JsonObject():New()
	jResumo['excluidas'] := Len(aJsonRat)

	Self:SetStatus(200)
	jResponse['success'] := .T.
	jResponse['message'] := 'Rateio externo excluido com sucesso.'
	jResponse['note']    := 'Rateio externo excluido com sucesso.'
	jResponse['data']    := jData
	jResponse['resumo']  := jResumo
	jResponse['rateios_excluidos'] := aJsonRat

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

/*/{Protheus.doc} CN5Fault
Monta e devolve a resposta de erro no padrao do WSCON002
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param oSelf, Objeto, Instancia do WSRESTFUL
@param nStatus, Numerico, Status HTTP de retorno
@param cCodigo, Caractere, Identificador do erro
@param cErro, Caractere, Descricao do erro
@param cSolucao, Caractere, Orientacao para solucao
@return Logico, Sempre .F.
/*/
Static Function CN5Fault(oSelf, nStatus, cCodigo, cErro, cSolucao)
	Local jResp := JsonObject():New()

	oSelf:SetStatus(nStatus)

	jResp['success']  := .F.
	jResp['message']  := cSolucao
	jResp['errorId']  := cCodigo
	jResp['error']    := cErro
	jResp['solution'] := cSolucao

	oSelf:SetResponse(EncodeUTF8(jResp:ToJson()))
Return .F.

/*/{Protheus.doc} CN5Tem
Indica se a chave existe no objeto JSON recebido
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param jObj, Objeto, Objeto JSON de entrada
@param cCampo, Caractere, Nome do campo
@return Logico, .T. se o campo foi enviado
/*/
Static Function CN5Tem(jObj, cCampo)
Return (ValType(jObj:GetJsonObject(cCampo)) <> 'U')

/*/{Protheus.doc} CN5GetC
Le um campo do JSON devolvendo sempre caractere
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param jObj, Objeto, Objeto JSON de entrada
@param cCampo, Caractere, Nome do campo
@return Caractere, Conteudo do campo
/*/
Static Function CN5GetC(jObj, cCampo)
	Local xVal := jObj:GetJsonObject(cCampo)
	Local cRet := ''

	If ValType(xVal) == 'C'
		cRet := AllTrim(xVal)
	ElseIf ValType(xVal) == 'N'
		cRet := AllTrim(Str(xVal))
	EndIf
Return cRet

/*/{Protheus.doc} CN5Limpa
Remove caracteres que permitem injecao de SQL no conteudo recebido
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cVal, Caractere, Conteudo recebido no JSON
@return Caractere, Conteudo higienizado
/*/
Static Function CN5Limpa(cVal)
	Local cRet := cVal

	If ValType(cRet) <> 'C'
		cRet := ''
	EndIf

	cRet := StrTran(cRet, "'", "")
	cRet := StrTran(cRet, '"', "")
	cRet := StrTran(cRet, ";", "")
	cRet := StrTran(cRet, "--", "")
	cRet := StrTran(cRet, Chr(13), "")
	cRet := StrTran(cRet, Chr(10), "")
Return AllTrim(cRet)

/*/{Protheus.doc} CN5Atual
Carrega todas as faixas de um codigo de rateio na CTJ
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cFil, Caractere, Filial do rateio
@param cRat, Caractere, Codigo do rateio
@return Array, Faixas no formato {CTJ_SEQUEN, Recno, CTJ_PERCEN}
/*/
Static Function CN5Atual(cFil, cRat)
	Local aRet   := {}
	Local cQuery := ''

	cQuery := "SELECT CTJ_SEQUEN, CTJ_PERCEN, R_E_C_N_O_ AS RECNO " + CRLF
	cQuery += "FROM " + RetSqlName("CTJ") + " CTJ " + CRLF
	cQuery += "WHERE CTJ.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "AND CTJ.CTJ_FILIAL = '" + cFil + "' " + CRLF
	cQuery += "AND CTJ.CTJ_RATEIO = '" + cRat + "' " + CRLF
	cQuery += "ORDER BY CTJ.CTJ_SEQUEN " + CRLF

	cQuery := ChangeQuery(cQuery)

	If Select("QRY_ATU") > 0
		QRY_ATU->(DbCloseArea())
	EndIf

	TCQuery cQuery New Alias "QRY_ATU"

	While ! QRY_ATU->(Eof())
		AAdd(aRet, {QRY_ATU->CTJ_SEQUEN, QRY_ATU->RECNO, QRY_ATU->CTJ_PERCEN})
		QRY_ATU->(DbSkip())
	EndDo

	QRY_ATU->(DbCloseArea())
Return aRet

/*/{Protheus.doc} CN5Json
Monta o JSON de um registro da CTJ no mesmo layout devolvido pelo WSCON002
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param nRecno, Numerico, Recno do registro na CTJ
@return Objeto, JsonObject com os dados do rateio
/*/
Static Function CN5Json(nRecno)
	Local oReg  := JsonObject():New()
	Local aArea := GetArea()

	DbSelectArea("CTJ")
	CTJ->(DbGoTo(nRecno))

	oReg['Filial']              := AllTrim(CTJ->CTJ_FILIAL)
	oReg['CodRateio']           := AllTrim(CTJ->CTJ_RATEIO)
	oReg['Sequencia']           := AllTrim(CTJ->CTJ_SEQUEN)
	oReg['Descricao']           := AllTrim(CTJ->CTJ_DESC)
	oReg['Percentual']          := CTJ->CTJ_PERCEN
	oReg['CentroCustoDebito']   := AllTrim(CTJ->CTJ_CCD)
	oReg['CentroCustoCredito']  := AllTrim(CTJ->CTJ_CCC)
	oReg['ContaDebito']         := AllTrim(CTJ->CTJ_DEBITO)
	oReg['ContaCredito']        := AllTrim(CTJ->CTJ_CREDIT)

	RestArea(aArea)
Return oReg
