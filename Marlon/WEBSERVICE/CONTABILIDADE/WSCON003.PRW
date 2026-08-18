//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSCON003
Serviço REST para inclusão de rateio externo (CTJ)
@author Maria Luiza
@since 18/08/2026
@version 2.0
@type wsrestful

    Complementa o WSCON002 (consulta de rateios), utilizando exatamente
    a mesma tabela, os mesmos campos e a mesma chave logica:

        CTJ_FILIAL + CTJ_RATEIO + CTJ_SEQUEN

    A gravacao segue o padrao de escrita direta ja adotado no projeto
    (WSFIN003): gravacao com RecLock / MsUnlock e localizacao por query
    retornando R_E_C_N_O_.

    INCLUSAO EM LOTE
    ----------------
    O servico recebe o rateio COMPLETO em uma unica requisicao: um
    cabecalho e o array "rateios" com todas as faixas. Todas as linhas
    sao gravadas ou nenhuma e gravada.

    CODIGO DO RATEIO (CTJ_RATEIO)
    -----------------------------
    Este servico ABRE SEMPRE UM RATEIO NOVO. O codigo nunca e recebido no
    JSON: o backend gera o proximo codigo da filial (maior codigo + 1) e
    as sequencias comecam do inicio.

    Para acrescentar faixas a um rateio JA EXISTENTE utilize o WSCON004,
    enviando a faixa sem o campo "sequencia".

    SEQUENCIA (CTJ_SEQUEN)
    ----------------------
    Nunca e recebida no JSON. E sempre calculada pelo backend e atribuida
    na ordem em que as faixas aparecem no array.

    REGRA DOS 100%
    --------------
    A soma dos percentuais das faixas enviadas precisa fechar exatamente
    100%. A verificacao ocorre ANTES de qualquer gravacao.

    CONCORRENCIA E ATOMICIDADE
    --------------------------
    A geracao do codigo, a geracao das sequencias e a gravacao ocorrem
    dentro de um semaforo exclusivo (LockByName) por empresa + filial. O
    semaforo e por filial - e nao por codigo de rateio - porque o codigo
    pode ainda nao existir no momento em que o bloqueio precisa ser
    obtido. A gravacao das linhas fica dentro de Begin Transaction, de
    modo que a falha em qualquer faixa desfaz as anteriores.

    CAMPOS OPCIONAIS
    ----------------
    No cabecalho apenas "filial" e o array "rateios" sao exigidos. Em
    cada faixa apenas "percentual" e exigido. Os demais campos so sao
    gravados quando efetivamente informados, e as validacoes de CTT / CT1
    so ocorrem para os campos que vierem preenchidos.
/*/

WSRESTFUL WSCON003 DESCRIPTION 'Servico REST para inclusao de rateio externo'

	//Atributos
	WSDATA      filial        AS STRING
	WSDATA      descricao     AS STRING

	//Métodos
	WSMETHOD POST   NEW    DESCRIPTION 'Inclusao de rateio externo'    WSSYNTAX '/WSCON003/new'                               PATH 'new'           PRODUCES APPLICATION_JSON

END WSRESTFUL

/*/{Protheus.doc} WSMETHOD POST NEW
Inclui um rateio externo completo na tabela CTJ
@author Maria Luiza
@since 18/08/2026
@version 2.0
@type method

    Abaixo um exemplo do JSON que deverá vir no body
    * 1: Para campos do tipo Numérico, informe o valor sem usar as aspas
    * 2: NAO informe sequencia - ela e sempre gerada automaticamente
    * 3: Cabecalho - obrigatorios: filial e o array rateios
    * 4: Cabecalho - opcional: descricao
    *    NAO informe rateio - o codigo e sempre gerado pelo backend
    * 5: Faixa - obrigatorio: percentual e ao menos um destino contabil
    * 6: Faixa - opcionais: descricao, ccdebito, cccredito, contadebito
         e contacredito. A descricao da faixa sobrepoe a do cabecalho
    * 7: A soma dos percentuais precisa fechar exatamente 100%

    {
        "filial": "0101",
        "descricao": "Rateio administrativo",
        "rateios": [
            { "percentual": 40, "ccdebito": "20010006", "contadebito": "31101001" },
            { "percentual": 35, "ccdebito": "20010007" },
            { "percentual": 25, "ccdebito": "20010008", "cccredito": "20010009" }
        ]
    }
/*/

WSMETHOD POST NEW WSRECEIVE WSSERVICE WSCON003
	Local lRet              := .T.
	Local lOk               := .T.
	Local jJson             := Nil
	Local cJson             := Self:GetContent()
	Local cError            := ''
	Local jResponse         := JsonObject():New()
	Local jData             := Nil
	Local aItens            := Nil
	Local oItem             := Nil
	Local aLinhas           := {}
	Local aRecnos           := {}
	Local aJsonRat          := {}
	Local cFilCTJ           := ''
	Local cRateio           := ''
	Local cDescCab          := ''
	Local cDescr            := ''
	Local cCCD              := ''
	Local cCCC              := ''
	Local cDebito           := ''
	Local cCredit           := ''
	Local cSeqAtu           := ''
	Local nPercen           := 0
	Local lTemDesc          := .F.
	Local lTemCCD           := .F.
	Local lTemCCC           := .F.
	Local lTemDeb           := .F.
	Local lTemCre           := .F.
	Local cSemaf            := ''
	Local nSomaLote         := 0
	Local nSeqIni           := 0
	Local nTamSeq           := 0
	Local nTamRat           := 0
	Local nX                := 0
	Local nY                := 0
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
		Return CN3Fault(Self, 400, 'NEW318', 'Body vazio', 'A requisicao chegou sem body. Confirme o envio do JSON e o header Content-Type: application/json')
	EndIf

	//Se tiver algum erro no Parse, encerra a execução
	If ! Empty(cError)
		Return CN3Fault(Self, 400, 'NEW301', 'Parse do JSON', 'Erro no Parse do JSON: ' + AllTrim(cValToChar(cError)) + ' | bytes recebidos: ' + AllTrim(Str(Len(cJson))))
	EndIf

	nTamSeq := TamSX3("CTJ_SEQUEN")[1]
	nTamRat := TamSX3("CTJ_RATEIO")[1]

	//Leitura do cabecalho
	cFilCTJ  := CN3Limpa(CN3GetC(jJson, 'filial'))
	cDescCab := CN3Limpa(CN3GetC(jJson, 'descricao'))

	//Validação dos campos obrigatórios do cabecalho
	If Empty(cFilCTJ)
		Return CN3Fault(Self, 400, 'NEW302', 'Campos obrigatorios', 'O campo filial e obrigatorio')
	EndIf

	//O array de faixas do rateio e obrigatorio
	aItens := jJson:GetJsonObject('rateios')

	If ValType(aItens) <> 'A' .Or. Len(aItens) == 0
		Return CN3Fault(Self, 400, 'NEW314', 'Estrutura do JSON', 'O JSON deve conter o array "rateios" com pelo menos uma faixa de rateio')
	EndIf

	//Ajusta os tamanhos conforme o dicionário de dados
	cFilCTJ := PadR(cFilCTJ, TamSX3("CTJ_FILIAL")[1])

	/*
	    Le e valida cada faixa do array antes de qualquer gravacao.
	    Layout de aLinhas:
	      [1] percentual   [2] descricao   [3] ccdebito   [4] cccredito
	      [5] contadebito  [6] contacredito
	      [7] tem descricao   [8] tem ccdebito   [9] tem cccredito
	      [10] tem contadebito   [11] tem contacredito
	*/
	For nX := 1 To Len(aItens)
		oItem := aItens[nX]

		/*
		    O ValType de um JsonObject varia conforme o build do Protheus:
		    pode vir como 'J' (json) ou 'O' (objeto). Por isso a validacao
		    rejeita apenas os tipos que comprovadamente NAO sao objeto, em
		    vez de exigir uma letra especifica.
		*/
		If ValType(oItem) $ 'CNDLUA'
			Return CN3Fault(Self, 400, 'NEW315', 'Estrutura do JSON', 'A faixa ' + AllTrim(Str(nX)) + ' do array "rateios" nao e um objeto valido')
		EndIf

		nPercen := CN3GetN(oItem, 'percentual')
		cDescr  := CN3Limpa(CN3GetC(oItem, 'descricao'))
		cCCD    := CN3Limpa(CN3GetC(oItem, 'ccdebito'))
		cCCC    := CN3Limpa(CN3GetC(oItem, 'cccredito'))
		cDebito := CN3Limpa(CN3GetC(oItem, 'contadebito'))
		cCredit := CN3Limpa(CN3GetC(oItem, 'contacredito'))

		//Um campo opcional so e considerado quando foi enviado E esta preenchido
		lTemDesc := CN3Tem(oItem, 'descricao')    .And. ! Empty(cDescr)
		lTemCCD  := CN3Tem(oItem, 'ccdebito')     .And. ! Empty(cCCD)
		lTemCCC  := CN3Tem(oItem, 'cccredito')    .And. ! Empty(cCCC)
		lTemDeb  := CN3Tem(oItem, 'contadebito')  .And. ! Empty(cDebito)
		lTemCre  := CN3Tem(oItem, 'contacredito') .And. ! Empty(cCredit)

		//A descricao do cabecalho vale como padrao para a faixa
		If ! lTemDesc .And. ! Empty(cDescCab)
			cDescr   := cDescCab
			lTemDesc := .T.
		EndIf

		//Validação do percentual da faixa
		If nPercen <= 0 .Or. nPercen > 100
			Return CN3Fault(Self, 400, 'NEW304', 'Percentual invalido', 'O percentual da faixa ' + AllTrim(Str(nX)) + ' deve ser maior que zero e menor ou igual a 100')
		EndIf

		//A faixa precisa de ao menos um destino contabil para ter significado
		If ! lTemCCD .And. ! lTemCCC .And. ! lTemDeb .And. ! lTemCre
			Return CN3Fault(Self, 400, 'NEW303', 'Destino do rateio nao informado', 'Na faixa ' + AllTrim(Str(nX)) + ' informe ao menos um entre ccdebito, cccredito, contadebito ou contacredito')
		EndIf

		//Validação dos Centros de Custo - somente os que vierem informados
		If lTemCCD .And. ! CN3Ctt(cFilCTJ, cCCD)
			Return CN3Fault(Self, 400, 'NEW305', 'Centro de custo invalido', 'Faixa ' + AllTrim(Str(nX)) + ': centro de custo de debito ' + AllTrim(cCCD) + ' nao cadastrado ou bloqueado na tabela CTT')
		EndIf

		If lTemCCC .And. ! CN3Ctt(cFilCTJ, cCCC)
			Return CN3Fault(Self, 400, 'NEW306', 'Centro de custo invalido', 'Faixa ' + AllTrim(Str(nX)) + ': centro de custo de credito ' + AllTrim(cCCC) + ' nao cadastrado ou bloqueado na tabela CTT')
		EndIf

		//Validação das Contas Contábeis - somente as que vierem informadas
		If lTemDeb .And. ! CN3Ct1(cFilCTJ, cDebito)
			Return CN3Fault(Self, 400, 'NEW307', 'Conta contabil invalida', 'Faixa ' + AllTrim(Str(nX)) + ': conta de debito ' + AllTrim(cDebito) + ' nao cadastrada ou bloqueada na tabela CT1')
		EndIf

		If lTemCre .And. ! CN3Ct1(cFilCTJ, cCredit)
			Return CN3Fault(Self, 400, 'NEW308', 'Conta contabil invalida', 'Faixa ' + AllTrim(Str(nX)) + ': conta de credito ' + AllTrim(cCredit) + ' nao cadastrada ou bloqueada na tabela CT1')
		EndIf

		//Impede duas faixas do lote com o mesmo destino contabil
		For nY := 1 To Len(aLinhas)
			If AllTrim(aLinhas[nY][3]) == AllTrim(cCCD) .And. ;
			   AllTrim(aLinhas[nY][4]) == AllTrim(cCCC) .And. ;
			   AllTrim(aLinhas[nY][5]) == AllTrim(cDebito) .And. ;
			   AllTrim(aLinhas[nY][6]) == AllTrim(cCredit)
				Return CN3Fault(Self, 409, 'NEW316', 'Faixa duplicada no lote', 'As faixas ' + AllTrim(Str(nY)) + ' e ' + AllTrim(Str(nX)) + ' possuem a mesma combinacao de centros de custo e contas contabeis')
			EndIf
		Next nY

		AAdd(aLinhas, {nPercen, cDescr, cCCD, cCCC, cDebito, cCredit, ;
		               lTemDesc, lTemCCD, lTemCCC, lTemDeb, lTemCre})

		nSomaLote += nPercen
	Next nX

	/*
	    Inicio da secao critica: geracao do codigo do rateio, geracao das
	    sequencias e gravacao.

	    O semaforo e exclusivo e nomeado por empresa + filial. Nao pode ser
	    nomeado pelo codigo do rateio porque, quando o codigo e gerado pelo
	    backend, ele ainda nao existe no momento em que o bloqueio precisa
	    ser obtido. Serializar por filial elimina qualquer disputa entre
	    geracao de codigo novo e inclusao em codigo existente.
	*/
	cSemaf := 'CTJINC' + AllTrim(cEmpAnt) + AllTrim(cFilCTJ)

	If ! LockByName(cSemaf, .F., .F., .F.)
		Return CN3Fault(Self, 503, 'NEW313', 'Filial em uso', 'Outra requisicao esta incluindo rateio na filial ' + AllTrim(cFilCTJ) + '. Tente novamente em instantes')
	EndIf

	//O codigo do rateio e sempre gerado por este servico
	cRateio := CN3NxRat(cFilCTJ, nTamRat)

	//Rateio novo comeca sempre na primeira sequencia
	nSeqIni := Val(CN3Next(cFilCTJ, cRateio, nTamSeq))

	Do Case
		//A soma das faixas enviadas precisa fechar exatamente 100%
		Case Abs(nSomaLote - 100) > 0.01
			lOk     := .F.
			nErrSt  := 409
			cErrId  := 'NEW310'
			cErrTit := 'Soma dos percentuais invalida'
			cErrMsg := 'A soma dos percentuais das faixas enviadas e ' + AllTrim(Str(nSomaLote, 12, 2)) + '%. O total deve ser exatamente 100%'

		//Protecao adicional: o codigo gerado nao pode ja estar em uso
		Case CN3Rec(cFilCTJ, cRateio, StrZero(nSeqIni, nTamSeq)) > 0
			lOk     := .F.
			nErrSt  := 409
			cErrId  := 'NEW309'
			cErrTit := 'Codigo de rateio em uso'
			cErrMsg := 'O codigo de rateio gerado (' + AllTrim(cRateio) + ') ja possui a sequencia ' + AllTrim(StrZero(nSeqIni, nTamSeq)) + ' na filial ' + AllTrim(cFilCTJ)

		Otherwise
			DbSelectArea("CTJ")

			/*
			    Todas as faixas sao gravadas dentro da mesma transacao.
			    A falha em qualquer uma desfaz as anteriores.
			*/
			Begin Transaction
				For nX := 1 To Len(aLinhas)
					cSeqAtu := StrZero(nSeqIni + nX - 1, nTamSeq)

					If ! RecLock("CTJ", .T.)
						lOk     := .F.
						nErrSt  := 500
						cErrId  := 'NEW311'
						cErrTit := 'Erro na gravacao'
						cErrMsg := 'Nao foi possivel obter o bloqueio para incluir a sequencia ' + AllTrim(cSeqAtu) + ' do rateio ' + AllTrim(cRateio)
						DisarmTransaction()
						Break
					EndIf

					//Chave e percentual sao sempre gravados
					CTJ->CTJ_FILIAL := cFilCTJ
					CTJ->CTJ_RATEIO := cRateio
					CTJ->CTJ_SEQUEN := cSeqAtu
					CTJ->CTJ_PERCEN := aLinhas[nX][1]

					//Os demais campos so sao gravados quando informados,
					//preservando o conteudo padrao do Protheus nos demais casos
					If aLinhas[nX][7]
						CTJ->CTJ_DESC := aLinhas[nX][2]
					EndIf

					If aLinhas[nX][8]
						CTJ->CTJ_CCD := aLinhas[nX][3]
					EndIf

					If aLinhas[nX][9]
						CTJ->CTJ_CCC := aLinhas[nX][4]
					EndIf

					If aLinhas[nX][10]
						CTJ->CTJ_DEBITO := aLinhas[nX][5]
					EndIf

					If aLinhas[nX][11]
						CTJ->CTJ_CREDIT := aLinhas[nX][6]
					EndIf

					CTJ->(MsUnLock())

					AAdd(aRecnos, CTJ->(Recno()))
				Next nX
			End Transaction
	EndCase

	//Libera o semaforo em qualquer cenario antes de responder
	UnLockByName(cSemaf, .F., .F., .F.)

	If ! lOk
		Return CN3Fault(Self, nErrSt, cErrId, cErrTit, cErrMsg)
	EndIf

	//Confere se todas as faixas foram efetivamente gravadas
	If Len(aRecnos) <> Len(aLinhas)
		Return CN3Fault(Self, 500, 'NEW312', 'Gravacao incompleta', 'Foram gravadas ' + AllTrim(Str(Len(aRecnos))) + ' de ' + AllTrim(Str(Len(aLinhas))) + ' faixas do rateio ' + AllTrim(cRateio))
	EndIf

	//Monta o retorno com todas as faixas gravadas
	For nX := 1 To Len(aRecnos)
		AAdd(aJsonRat, CN3Json(aRecnos[nX]))
	Next nX

	jData := JsonObject():New()
	jData['Filial']    := AllTrim(cFilCTJ)
	jData['CodRateio'] := AllTrim(cRateio)
	jData['Descricao'] := AllTrim(cDescCab)

	Self:SetStatus(201)
	jResponse['success'] := .T.
	jResponse['message'] := 'Rateio externo incluido com sucesso.'
	jResponse['note']    := 'Rateio externo incluido com sucesso.'
	jResponse['data']    := jData
	jResponse['total_percentual'] := CN3Soma(cFilCTJ, cRateio, '')
	jResponse['rateios'] := aJsonRat

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

/*/{Protheus.doc} CN3Fault
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
Static Function CN3Fault(oSelf, nStatus, cCodigo, cErro, cSolucao)
	Local jResp := JsonObject():New()

	oSelf:SetStatus(nStatus)

	jResp['success']  := .F.
	jResp['message']  := cSolucao
	jResp['errorId']  := cCodigo
	jResp['error']    := cErro
	jResp['solution'] := cSolucao

	oSelf:SetResponse(EncodeUTF8(jResp:ToJson()))
Return .F.

/*/{Protheus.doc} CN3Tem
Indica se a chave existe no objeto JSON recebido
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param jObj, Objeto, Objeto JSON de entrada
@param cCampo, Caractere, Nome do campo
@return Logico, .T. se o campo foi enviado
/*/
Static Function CN3Tem(jObj, cCampo)
Return (ValType(jObj:GetJsonObject(cCampo)) <> 'U')

/*/{Protheus.doc} CN3GetC
Le um campo do JSON devolvendo sempre caractere
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param jObj, Objeto, Objeto JSON de entrada
@param cCampo, Caractere, Nome do campo
@return Caractere, Conteudo do campo
/*/
Static Function CN3GetC(jObj, cCampo)
	Local xVal := jObj:GetJsonObject(cCampo)
	Local cRet := ''

	If ValType(xVal) == 'C'
		cRet := AllTrim(xVal)
	ElseIf ValType(xVal) == 'N'
		cRet := AllTrim(Str(xVal))
	EndIf
Return cRet

/*/{Protheus.doc} CN3GetN
Le um campo do JSON devolvendo sempre numerico
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param jObj, Objeto, Objeto JSON de entrada
@param cCampo, Caractere, Nome do campo
@return Numerico, Conteudo do campo
/*/
Static Function CN3GetN(jObj, cCampo)
	Local xVal := jObj:GetJsonObject(cCampo)
	Local nRet := 0

	If ValType(xVal) == 'N'
		nRet := xVal
	ElseIf ValType(xVal) == 'C'
		nRet := Val(StrTran(AllTrim(xVal), ',', '.'))
	EndIf
Return nRet

/*/{Protheus.doc} CN3Limpa
Remove caracteres que permitem injecao de SQL no conteudo recebido
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cVal, Caractere, Conteudo recebido no JSON
@return Caractere, Conteudo higienizado
/*/
Static Function CN3Limpa(cVal)
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

/*/{Protheus.doc} CN3Ctt
Valida a existencia e o bloqueio do centro de custo na tabela CTT
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cFil, Caractere, Filial do centro de custo
@param cCusto, Caractere, Codigo do centro de custo
@return Logico, .T. se o centro de custo e valido
/*/
Static Function CN3Ctt(cFil, cCusto)
	Local lOk    := .F.
	Local cQuery := ''

	cQuery := "SELECT CTT_BLOQ " + CRLF
	cQuery += "FROM " + RetSqlName("CTT") + " CTT " + CRLF
	cQuery += "WHERE CTT.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "AND CTT.CTT_FILIAL = '" + cFil + "' " + CRLF
	cQuery += "AND CTT.CTT_CUSTO = '" + PadR(cCusto, TamSX3("CTT_CUSTO")[1]) + "' " + CRLF

	cQuery := ChangeQuery(cQuery)

	If Select("QRY_CTT") > 0
		QRY_CTT->(DbCloseArea())
	EndIf

	TCQuery cQuery New Alias "QRY_CTT"

	If ! QRY_CTT->(Eof())
		lOk := (QRY_CTT->CTT_BLOQ <> "1")
	EndIf

	QRY_CTT->(DbCloseArea())
Return lOk

/*/{Protheus.doc} CN3Ct1
Valida a existencia e o bloqueio da conta contabil na tabela CT1
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cFil, Caractere, Filial da conta contabil
@param cConta, Caractere, Codigo da conta contabil
@return Logico, .T. se a conta contabil e valida
/*/
Static Function CN3Ct1(cFil, cConta)
	Local lOk    := .F.
	Local cQuery := ''

	cQuery := "SELECT CT1_BLOQ " + CRLF
	cQuery += "FROM " + RetSqlName("CT1") + " CT1 " + CRLF
	cQuery += "WHERE CT1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "AND CT1.CT1_FILIAL = '" + cFil + "' " + CRLF
	cQuery += "AND CT1.CT1_CONTA = '" + PadR(cConta, TamSX3("CT1_CONTA")[1]) + "' " + CRLF

	cQuery := ChangeQuery(cQuery)

	If Select("QRY_CT1") > 0
		QRY_CT1->(DbCloseArea())
	EndIf

	TCQuery cQuery New Alias "QRY_CT1"

	If ! QRY_CT1->(Eof())
		lOk := (QRY_CT1->CT1_BLOQ <> "1")
	EndIf

	QRY_CT1->(DbCloseArea())
Return lOk

/*/{Protheus.doc} CN3Rec
Localiza o R_E_C_N_O_ de um rateio externo pela chave logica da CTJ
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cFil, Caractere, Filial do rateio
@param cRat, Caractere, Codigo do rateio
@param cSeq, Caractere, Sequencia do rateio
@return Numerico, Recno do registro ou zero quando nao encontrado
/*/
Static Function CN3Rec(cFil, cRat, cSeq)
	Local nRet   := 0
	Local cQuery := ''

	cQuery := "SELECT R_E_C_N_O_ AS RECNO " + CRLF
	cQuery += "FROM " + RetSqlName("CTJ") + " CTJ " + CRLF
	cQuery += "WHERE CTJ.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "AND CTJ.CTJ_FILIAL = '" + cFil + "' " + CRLF
	cQuery += "AND CTJ.CTJ_RATEIO = '" + cRat + "' " + CRLF
	cQuery += "AND CTJ.CTJ_SEQUEN = '" + cSeq + "' " + CRLF

	cQuery := ChangeQuery(cQuery)

	If Select("QRY_REC") > 0
		QRY_REC->(DbCloseArea())
	EndIf

	TCQuery cQuery New Alias "QRY_REC"

	If ! QRY_REC->(Eof())
		nRet := QRY_REC->RECNO
	EndIf

	QRY_REC->(DbCloseArea())
Return nRet

/*/{Protheus.doc} CN3Soma
Soma os percentuais ja gravados para um codigo de rateio
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cFil, Caractere, Filial do rateio
@param cRat, Caractere, Codigo do rateio
@param cSeqExc, Caractere, Sequencia a ser desconsiderada na soma
@return Numerico, Somatorio dos percentuais
/*/
Static Function CN3Soma(cFil, cRat, cSeqExc)
	Local nRet   := 0
	Local cQuery := ''

	cQuery := "SELECT CTJ_PERCEN " + CRLF
	cQuery += "FROM " + RetSqlName("CTJ") + " CTJ " + CRLF
	cQuery += "WHERE CTJ.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "AND CTJ.CTJ_FILIAL = '" + cFil + "' " + CRLF
	cQuery += "AND CTJ.CTJ_RATEIO = '" + cRat + "' " + CRLF

	If ! Empty(cSeqExc)
		cQuery += "AND CTJ.CTJ_SEQUEN <> '" + cSeqExc + "' " + CRLF
	EndIf

	cQuery := ChangeQuery(cQuery)

	If Select("QRY_SUM") > 0
		QRY_SUM->(DbCloseArea())
	EndIf

	TCQuery cQuery New Alias "QRY_SUM"

	While ! QRY_SUM->(Eof())
		nRet += QRY_SUM->CTJ_PERCEN
		QRY_SUM->(DbSkip())
	EndDo

	QRY_SUM->(DbCloseArea())
Return nRet

/*/{Protheus.doc} CN3NxRat
Gera o proximo codigo de rateio da filial
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function

    Le os codigos de rateio ja gravados na filial e apura o maior em
    AdvPL, no mesmo estilo de leitura usado pelo WSCON002 (TCQuery +
    laco), sem depender de MAX() no banco nem de indice da CTJ.
    Deve ser chamada dentro do semaforo da filial.

@param cFil, Caractere, Filial do rateio
@param nTam, Numerico, Tamanho do campo CTJ_RATEIO
@return Caractere, Proximo codigo de rateio
/*/
Static Function CN3NxRat(cFil, nTam)
	Local nMaior := 0
	Local cQuery := ''

	cQuery := "SELECT DISTINCT CTJ_RATEIO " + CRLF
	cQuery += "FROM " + RetSqlName("CTJ") + " CTJ " + CRLF
	cQuery += "WHERE CTJ.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "AND CTJ.CTJ_FILIAL = '" + cFil + "' " + CRLF
	cQuery += "ORDER BY CTJ_RATEIO " + CRLF

	cQuery := ChangeQuery(cQuery)

	If Select("QRY_RAT") > 0
		QRY_RAT->(DbCloseArea())
	EndIf

	TCQuery cQuery New Alias "QRY_RAT"

	While ! QRY_RAT->(Eof())
		If Val(QRY_RAT->CTJ_RATEIO) > nMaior
			nMaior := Val(QRY_RAT->CTJ_RATEIO)
		EndIf
		QRY_RAT->(DbSkip())
	EndDo

	QRY_RAT->(DbCloseArea())
Return StrZero(nMaior + 1, nTam)

/*/{Protheus.doc} CN3Next
Gera a proxima sequencia disponivel para um codigo de rateio
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function

    Le as sequencias ja gravadas para CTJ_FILIAL + CTJ_RATEIO e apura a
    maior em AdvPL, no mesmo estilo de leitura usado pelo WSCON002
    (TCQuery + laco), sem depender de MAX() no banco nem de indice da CTJ.
    Deve ser chamada dentro do semaforo da filial. Rateio novo devolve a
    primeira sequencia.

@param cFil, Caractere, Filial do rateio
@param cRat, Caractere, Codigo do rateio
@param nTam, Numerico, Tamanho do campo CTJ_SEQUEN
@return Caractere, Proxima sequencia
/*/
Static Function CN3Next(cFil, cRat, nTam)
	Local nMaior := 0
	Local cQuery := ''

	cQuery := "SELECT CTJ_SEQUEN " + CRLF
	cQuery += "FROM " + RetSqlName("CTJ") + " CTJ " + CRLF
	cQuery += "WHERE CTJ.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "AND CTJ.CTJ_FILIAL = '" + cFil + "' " + CRLF
	cQuery += "AND CTJ.CTJ_RATEIO = '" + cRat + "' " + CRLF
	cQuery += "ORDER BY CTJ.CTJ_SEQUEN " + CRLF

	cQuery := ChangeQuery(cQuery)

	If Select("QRY_SEQ") > 0
		QRY_SEQ->(DbCloseArea())
	EndIf

	TCQuery cQuery New Alias "QRY_SEQ"

	While ! QRY_SEQ->(Eof())
		If Val(QRY_SEQ->CTJ_SEQUEN) > nMaior
			nMaior := Val(QRY_SEQ->CTJ_SEQUEN)
		EndIf
		QRY_SEQ->(DbSkip())
	EndDo

	QRY_SEQ->(DbCloseArea())
Return StrZero(nMaior + 1, nTam)

/*/{Protheus.doc} CN3Json
Monta o JSON de um registro da CTJ no mesmo layout devolvido pelo WSCON002
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param nRecno, Numerico, Recno do registro na CTJ
@return Objeto, JsonObject com os dados do rateio
/*/
Static Function CN3Json(nRecno)
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
