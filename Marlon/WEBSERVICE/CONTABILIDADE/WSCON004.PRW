//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSCON004
Serviço REST para alteração de rateio externo (CTJ)
@author Maria Luiza
@since 18/08/2026
@version 2.0
@type wsrestful

    Complementa o WSCON002 (consulta de rateios), utilizando exatamente
    a mesma tabela, os mesmos campos e a mesma chave logica:

        CTJ_FILIAL + CTJ_RATEIO + CTJ_SEQUEN

    ALTERACAO EM LOTE
    -----------------
    O servico recebe o ESTADO COMPLETO do rateio em uma unica
    requisicao. O array "rateios" descreve como o codigo de rateio deve
    ficar depois da operacao:

      - Faixa com "sequencia" que existe ...: e ALTERADA
      - Faixa sem "sequencia" ..............: e INCLUIDA com nova sequencia
      - Sequencia existente ausente do array: e EXCLUIDA

    Essa e a semantica de PUT: o corpo define o estado final. Uma faixa
    que hoje existe e nao aparece no array SERA REMOVIDA. O resumo da
    operacao volta na resposta em "resumo".

    REGRA DOS 100%
    --------------
    A soma dos percentuais do estado final precisa fechar exatamente
    100%. A verificacao ocorre ANTES de qualquer gravacao.

    ALTERACAO PARCIAL DA FAIXA
    --------------------------
    Dentro de uma faixa que esta sendo alterada, so os campos enviados E
    preenchidos sao gravados. Campo ausente - ou enviado vazio - preserva
    o conteudo atual do registro. Os campos da chave nunca sao alterados.

    CONCORRENCIA E ATOMICIDADE
    --------------------------
    Exclusoes, alteracoes e inclusoes ocorrem dentro de um semaforo
    exclusivo (LockByName) por empresa + filial, e dentro de um mesmo
    Begin Transaction. A falha em qualquer faixa desfaz toda a operacao.
/*/

WSRESTFUL WSCON004 DESCRIPTION 'Servico REST para alteracao de rateio externo'

	//Atributos
	WSDATA      filial        AS STRING
	WSDATA      rateio        AS STRING
	WSDATA      descricao     AS STRING

	//Métodos
	WSMETHOD PUT    UPDATE DESCRIPTION 'Alteracao de rateio externo'   WSSYNTAX '/WSCON004/update'                            PATH 'update'        PRODUCES APPLICATION_JSON

END WSRESTFUL

/*/{Protheus.doc} WSMETHOD PUT UPDATE
Substitui o estado completo de um rateio externo na tabela CTJ
@author Maria Luiza
@since 18/08/2026
@version 2.0
@type method

    Abaixo um exemplo do JSON que deverá vir no body
    * 1: Para campos do tipo Numérico, informe o valor sem usar as aspas
    * 2: Cabecalho - obrigatorios: filial, rateio e o array rateios
    * 3: Faixa COM sequencia = altera a faixa existente
    * 4: Faixa SEM sequencia = inclui uma nova faixa
    * 5: Sequencia existente que nao aparecer no array SERA EXCLUIDA
    * 6: Numa faixa alterada, campo ausente ou vazio preserva o atual
    * 7: A soma dos percentuais do estado final deve fechar 100%

    Redistribui um rateio de 3 faixas para 2 (a faixa 003 e excluida):

    {
        "filial": "0101",
        "rateio": "000007",
        "rateios": [
            { "sequencia": "001", "percentual": 50 },
            { "sequencia": "002", "percentual": 50 }
        ]
    }

    Altera duas faixas e acrescenta uma terceira:

    {
        "filial": "0101",
        "rateio": "000007",
        "rateios": [
            { "sequencia": "001", "percentual": 40 },
            { "sequencia": "002", "percentual": 35, "ccdebito": "20010007" },
            { "percentual": 25, "ccdebito": "20010008" }
        ]
    }
/*/

WSMETHOD PUT UPDATE WSSERVICE WSCON004
	Local lRet              := .T.
	Local lOk               := .T.
	Local jJson             := Nil
	Local cJson             := Self:GetContent()
	Local cError            := ''
	Local jResponse         := JsonObject():New()
	Local jData             := Nil
	Local jResumo           := Nil
	Local aItens            := Nil
	Local oItem             := Nil
	Local aLinhas           := {}
	Local aAtual            := {}
	Local aExcluir          := {}
	Local aJsonRat          := {}
	Local cFilCTJ           := ''
	Local cRateio           := ''
	Local cDescCab          := ''
	Local cSequen           := ''
	Local cDescr            := ''
	Local cCCD              := ''
	Local cCCC              := ''
	Local cDebito           := ''
	Local cCredit           := ''
	Local nPercen           := 0
	Local lTemSeq           := .F.
	Local lTemPerc          := .F.
	Local lTemDesc          := .F.
	Local lTemCCD           := .F.
	Local lTemCCC           := .F.
	Local lTemDeb           := .F.
	Local lTemCre           := .F.
	Local cSemaf            := ''
	Local nSomaFin          := 0
	Local nAltera           := 0
	Local nInclui           := 0
	Local nTamSeq           := 0
	Local nSeqIni           := 0
	Local nNovas            := 0
	Local nPos              := 0
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
		Return CN4Fault(Self, 400, 'UPD419', 'Body vazio', 'A requisicao chegou sem body. Confirme o envio do JSON e o header Content-Type: application/json')
	EndIf

	//Se tiver algum erro no Parse, encerra a execução
	If ! Empty(cError)
		Return CN4Fault(Self, 400, 'UPD401', 'Parse do JSON', 'Erro no Parse do JSON: ' + AllTrim(cValToChar(cError)) + ' | bytes recebidos: ' + AllTrim(Str(Len(cJson))))
	EndIf

	nTamSeq := TamSX3("CTJ_SEQUEN")[1]

	//Leitura do cabecalho
	cFilCTJ  := CN4Limpa(CN4GetC(jJson, 'filial'))
	cRateio  := CN4Limpa(CN4GetC(jJson, 'rateio'))
	cDescCab := CN4Limpa(CN4GetC(jJson, 'descricao'))

	//Validação dos campos obrigatórios do cabecalho
	If Empty(cFilCTJ) .Or. Empty(cRateio)
		Return CN4Fault(Self, 400, 'UPD402', 'Campos obrigatorios', 'Os campos filial e rateio sao obrigatorios')
	EndIf

	//O array de faixas do rateio e obrigatorio
	aItens := jJson:GetJsonObject('rateios')

	If ValType(aItens) <> 'A' .Or. Len(aItens) == 0
		Return CN4Fault(Self, 400, 'UPD414', 'Estrutura do JSON', 'O JSON deve conter o array "rateios" com pelo menos uma faixa de rateio')
	EndIf

	//Ajusta os tamanhos conforme o dicionário de dados
	cFilCTJ := PadR(cFilCTJ, TamSX3("CTJ_FILIAL")[1])
	cRateio := PadR(cRateio, TamSX3("CTJ_RATEIO")[1])

	/*
	    Le e valida cada faixa do array antes de qualquer gravacao.
	    Layout de aLinhas:
	      [1] sequencia (vazio = incluir)   [2] percentual   [3] descricao
	      [4] ccdebito   [5] cccredito   [6] contadebito   [7] contacredito
	      [8] tem percentual   [9] tem descricao   [10] tem ccdebito
	      [11] tem cccredito   [12] tem contadebito   [13] tem contacredito
	      [14] recno (0 = incluir)   [15] percentual final para a soma
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
			Return CN4Fault(Self, 400, 'UPD415', 'Estrutura do JSON', 'A faixa ' + AllTrim(Str(nX)) + ' do array "rateios" nao e um objeto valido')
		EndIf

		cSequen := CN4Limpa(CN4GetC(oItem, 'sequencia'))
		nPercen := CN4GetN(oItem, 'percentual')
		cDescr  := CN4Limpa(CN4GetC(oItem, 'descricao'))
		cCCD    := CN4Limpa(CN4GetC(oItem, 'ccdebito'))
		cCCC    := CN4Limpa(CN4GetC(oItem, 'cccredito'))
		cDebito := CN4Limpa(CN4GetC(oItem, 'contadebito'))
		cCredit := CN4Limpa(CN4GetC(oItem, 'contacredito'))

		//Um campo opcional so e considerado quando foi enviado E esta preenchido
		lTemSeq  := CN4Tem(oItem, 'sequencia')    .And. ! Empty(cSequen)
		lTemPerc := CN4Tem(oItem, 'percentual')   .And. nPercen <> 0
		lTemDesc := CN4Tem(oItem, 'descricao')    .And. ! Empty(cDescr)
		lTemCCD  := CN4Tem(oItem, 'ccdebito')     .And. ! Empty(cCCD)
		lTemCCC  := CN4Tem(oItem, 'cccredito')    .And. ! Empty(cCCC)
		lTemDeb  := CN4Tem(oItem, 'contadebito')  .And. ! Empty(cDebito)
		lTemCre  := CN4Tem(oItem, 'contacredito') .And. ! Empty(cCredit)

		If lTemSeq
			cSequen := CN4PadIt(cSequen, nTamSeq)
		EndIf

		//A descricao do cabecalho vale como padrao para a faixa
		If ! lTemDesc .And. ! Empty(cDescCab)
			cDescr   := cDescCab
			lTemDesc := .T.
		EndIf

		//Validação do percentual quando informado
		If lTemPerc .And. (nPercen <= 0 .Or. nPercen > 100)
			Return CN4Fault(Self, 400, 'UPD404', 'Percentual invalido', 'O percentual da faixa ' + AllTrim(Str(nX)) + ' deve ser maior que zero e menor ou igual a 100')
		EndIf

		//Faixa nova exige percentual e ao menos um destino contabil
		If ! lTemSeq
			If ! lTemPerc
				Return CN4Fault(Self, 400, 'UPD416', 'Percentual obrigatorio', 'A faixa ' + AllTrim(Str(nX)) + ' nao informou sequencia, portanto sera incluida e o percentual e obrigatorio')
			EndIf

			If ! lTemCCD .And. ! lTemCCC .And. ! lTemDeb .And. ! lTemCre
				Return CN4Fault(Self, 400, 'UPD403', 'Destino do rateio nao informado', 'Na faixa ' + AllTrim(Str(nX)) + ', que sera incluida, informe ao menos um entre ccdebito, cccredito, contadebito ou contacredito')
			EndIf
		EndIf

		//Impede a mesma sequencia repetida no array
		If lTemSeq
			For nY := 1 To Len(aLinhas)
				If aLinhas[nY][1] == cSequen
					Return CN4Fault(Self, 409, 'UPD417', 'Sequencia repetida no lote', 'A sequencia ' + AllTrim(cSequen) + ' aparece mais de uma vez no array "rateios"')
				EndIf
			Next nY
		EndIf

		//Validação dos Centros de Custo - somente os que vierem informados
		If lTemCCD .And. ! CN4Ctt(cFilCTJ, cCCD)
			Return CN4Fault(Self, 400, 'UPD406', 'Centro de custo invalido', 'Faixa ' + AllTrim(Str(nX)) + ': centro de custo de debito ' + AllTrim(cCCD) + ' nao cadastrado ou bloqueado na tabela CTT')
		EndIf

		If lTemCCC .And. ! CN4Ctt(cFilCTJ, cCCC)
			Return CN4Fault(Self, 400, 'UPD407', 'Centro de custo invalido', 'Faixa ' + AllTrim(Str(nX)) + ': centro de custo de credito ' + AllTrim(cCCC) + ' nao cadastrado ou bloqueado na tabela CTT')
		EndIf

		//Validação das Contas Contábeis - somente as que vierem informadas
		If lTemDeb .And. ! CN4Ct1(cFilCTJ, cDebito)
			Return CN4Fault(Self, 400, 'UPD408', 'Conta contabil invalida', 'Faixa ' + AllTrim(Str(nX)) + ': conta de debito ' + AllTrim(cDebito) + ' nao cadastrada ou bloqueada na tabela CT1')
		EndIf

		If lTemCre .And. ! CN4Ct1(cFilCTJ, cCredit)
			Return CN4Fault(Self, 400, 'UPD409', 'Conta contabil invalida', 'Faixa ' + AllTrim(Str(nX)) + ': conta de credito ' + AllTrim(cCredit) + ' nao cadastrada ou bloqueada na tabela CT1')
		EndIf

		AAdd(aLinhas, {cSequen, nPercen, cDescr, cCCD, cCCC, cDebito, cCredit, ;
		               lTemPerc, lTemDesc, lTemCCD, lTemCCC, lTemDeb, lTemCre, ;
		               0, 0})
	Next nX

	/*
	    Inicio da secao critica. O semaforo e o mesmo utilizado pelo
	    WSCON003 - exclusivo por empresa + filial - de modo que inclusao e
	    alteracao nao disputam a geracao de sequencias entre si.
	*/
	cSemaf := 'CTJINC' + AllTrim(cEmpAnt) + AllTrim(cFilCTJ)

	If ! LockByName(cSemaf, .F., .F., .F.)
		Return CN4Fault(Self, 503, 'UPD413', 'Filial em uso', 'Outra requisicao esta manipulando rateio na filial ' + AllTrim(cFilCTJ) + '. Tente novamente em instantes')
	EndIf

	//Carrega o estado atual do rateio
	aAtual := CN4Atual(cFilCTJ, cRateio)

	Do Case
		//O rateio precisa existir para ser alterado
		Case Len(aAtual) == 0
			lOk     := .F.
			nErrSt  := 404
			cErrId  := 'UPD405'
			cErrTit := 'Rateio nao encontrado'
			cErrMsg := 'Nao existe o rateio ' + AllTrim(cRateio) + ' na filial ' + AllTrim(cFilCTJ)

		Otherwise
			//Casa cada faixa do array com o registro existente
			nSeqIni := Val(CN4NxSeq(aAtual, nTamSeq))
			nNovas  := 0

			For nX := 1 To Len(aLinhas)
				If Empty(aLinhas[nX][1])
					//Faixa sem sequencia: sera incluida com nova sequencia
					aLinhas[nX][1]  := StrZero(nSeqIni + nNovas, nTamSeq)
					aLinhas[nX][14] := 0
					aLinhas[nX][15] := aLinhas[nX][2]
					nNovas++
					nInclui++
				Else
					nPos := AScan(aAtual, {|x| x[1] == aLinhas[nX][1]})

					If nPos == 0
						lOk     := .F.
						nErrSt  := 404
						cErrId  := 'UPD418'
						cErrTit := 'Sequencia nao encontrada'
						cErrMsg := 'A sequencia ' + AllTrim(aLinhas[nX][1]) + ' nao existe no rateio ' + AllTrim(cRateio) + '. Para incluir uma faixa nova, omita o campo sequencia'
						Exit
					EndIf

					aLinhas[nX][14] := aAtual[nPos][2]

					//Percentual nao informado preserva o valor atual
					If aLinhas[nX][8]
						aLinhas[nX][15] := aLinhas[nX][2]
					Else
						aLinhas[nX][15] := aAtual[nPos][3]
					EndIf

					nAltera++
				EndIf
			Next nX
	EndCase

	//Apura o estado final e o que sera excluido
	If lOk
		nSomaFin := 0

		For nX := 1 To Len(aLinhas)
			nSomaFin += aLinhas[nX][15]
		Next nX

		//Sequencias existentes que nao vieram no array serao excluidas
		For nX := 1 To Len(aAtual)
			If AScan(aLinhas, {|x| x[1] == aAtual[nX][1]}) == 0
				AAdd(aExcluir, aAtual[nX][2])
			EndIf
		Next nX

		//A soma do estado final precisa fechar exatamente 100%
		If Abs(nSomaFin - 100) > 0.01
			lOk     := .F.
			nErrSt  := 409
			cErrId  := 'UPD410'
			cErrTit := 'Soma dos percentuais invalida'
			cErrMsg := 'O estado final do rateio ' + AllTrim(cRateio) + ' somaria ' + AllTrim(Str(nSomaFin, 12, 2)) + '%. O total deve ser exatamente 100%'
		EndIf
	EndIf

	//Executa exclusoes, alteracoes e inclusoes numa unica transacao
	If lOk
		DbSelectArea("CTJ")

		Begin Transaction
			//Exclui as faixas que sairam do rateio
			For nX := 1 To Len(aExcluir)
				CTJ->(DbGoTo(aExcluir[nX]))

				If ! RecLock("CTJ", .F.)
					lOk     := .F.
					nErrSt  := 500
					cErrId  := 'UPD412'
					cErrTit := 'Erro na exclusao'
					cErrMsg := 'Nao foi possivel obter o bloqueio para excluir uma faixa do rateio ' + AllTrim(cRateio)
					DisarmTransaction()
					Break
				EndIf

				CTJ->(DbDelete())
				CTJ->(MsUnLock())
			Next nX

			//Altera as faixas existentes e inclui as novas
			For nX := 1 To Len(aLinhas)
				If aLinhas[nX][14] > 0
					CTJ->(DbGoTo(aLinhas[nX][14]))

					If ! RecLock("CTJ", .F.)
						lOk     := .F.
						nErrSt  := 500
						cErrId  := 'UPD412'
						cErrTit := 'Erro na alteracao'
						cErrMsg := 'Nao foi possivel obter o bloqueio para alterar a sequencia ' + AllTrim(aLinhas[nX][1]) + ' do rateio ' + AllTrim(cRateio)
						DisarmTransaction()
						Break
					EndIf
				Else
					If ! RecLock("CTJ", .T.)
						lOk     := .F.
						nErrSt  := 500
						cErrId  := 'UPD412'
						cErrTit := 'Erro na inclusao'
						cErrMsg := 'Nao foi possivel obter o bloqueio para incluir a sequencia ' + AllTrim(aLinhas[nX][1]) + ' do rateio ' + AllTrim(cRateio)
						DisarmTransaction()
						Break
					EndIf

					//Chave gravada apenas na inclusao
					CTJ->CTJ_FILIAL := cFilCTJ
					CTJ->CTJ_RATEIO := cRateio
					CTJ->CTJ_SEQUEN := aLinhas[nX][1]
				EndIf

				//Percentual: na inclusao sempre; na alteracao so se informado
				If aLinhas[nX][14] == 0 .Or. aLinhas[nX][8]
					CTJ->CTJ_PERCEN := aLinhas[nX][15]
				EndIf

				//Os demais campos so sao gravados quando informados
				If aLinhas[nX][9]
					CTJ->CTJ_DESC := aLinhas[nX][3]
				EndIf

				If aLinhas[nX][10]
					CTJ->CTJ_CCD := aLinhas[nX][4]
				EndIf

				If aLinhas[nX][11]
					CTJ->CTJ_CCC := aLinhas[nX][5]
				EndIf

				If aLinhas[nX][12]
					CTJ->CTJ_DEBITO := aLinhas[nX][6]
				EndIf

				If aLinhas[nX][13]
					CTJ->CTJ_CREDIT := aLinhas[nX][7]
				EndIf

				CTJ->(MsUnLock())
			Next nX
		End Transaction
	EndIf

	//Libera o semaforo em qualquer cenario antes de responder
	UnLockByName(cSemaf, .F., .F., .F.)

	If ! lOk
		Return CN4Fault(Self, nErrSt, cErrId, cErrTit, cErrMsg)
	EndIf

	//Monta o retorno com o estado final do rateio
	aAtual := CN4Atual(cFilCTJ, cRateio)

	For nX := 1 To Len(aAtual)
		AAdd(aJsonRat, CN4Json(aAtual[nX][2]))
	Next nX

	jData := JsonObject():New()
	jData['Filial']    := AllTrim(cFilCTJ)
	jData['CodRateio'] := AllTrim(cRateio)
	jData['Descricao'] := AllTrim(cDescCab)

	jResumo := JsonObject():New()
	jResumo['alteradas'] := nAltera
	jResumo['incluidas'] := nInclui
	jResumo['excluidas'] := Len(aExcluir)

	Self:SetStatus(200)
	jResponse['success'] := .T.
	jResponse['message'] := 'Rateio externo atualizado com sucesso.'
	jResponse['note']    := 'Rateio externo atualizado com sucesso.'
	jResponse['data']    := jData
	jResponse['resumo']  := jResumo
	jResponse['total_percentual'] := CN4Soma(cFilCTJ, cRateio)
	jResponse['rateios'] := aJsonRat

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

/*/{Protheus.doc} CN4Fault
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
Static Function CN4Fault(oSelf, nStatus, cCodigo, cErro, cSolucao)
	Local jResp := JsonObject():New()

	oSelf:SetStatus(nStatus)

	jResp['success']  := .F.
	jResp['message']  := cSolucao
	jResp['errorId']  := cCodigo
	jResp['error']    := cErro
	jResp['solution'] := cSolucao

	oSelf:SetResponse(EncodeUTF8(jResp:ToJson()))
Return .F.

/*/{Protheus.doc} CN4Tem
Indica se a chave existe no objeto JSON recebido
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param jObj, Objeto, Objeto JSON de entrada
@param cCampo, Caractere, Nome do campo
@return Logico, .T. se o campo foi enviado
/*/
Static Function CN4Tem(jObj, cCampo)
Return (ValType(jObj:GetJsonObject(cCampo)) <> 'U')

/*/{Protheus.doc} CN4GetC
Le um campo do JSON devolvendo sempre caractere
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param jObj, Objeto, Objeto JSON de entrada
@param cCampo, Caractere, Nome do campo
@return Caractere, Conteudo do campo
/*/
Static Function CN4GetC(jObj, cCampo)
	Local xVal := jObj:GetJsonObject(cCampo)
	Local cRet := ''

	If ValType(xVal) == 'C'
		cRet := AllTrim(xVal)
	ElseIf ValType(xVal) == 'N'
		cRet := AllTrim(Str(xVal))
	EndIf
Return cRet

/*/{Protheus.doc} CN4GetN
Le um campo do JSON devolvendo sempre numerico
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param jObj, Objeto, Objeto JSON de entrada
@param cCampo, Caractere, Nome do campo
@return Numerico, Conteudo do campo
/*/
Static Function CN4GetN(jObj, cCampo)
	Local xVal := jObj:GetJsonObject(cCampo)
	Local nRet := 0

	If ValType(xVal) == 'N'
		nRet := xVal
	ElseIf ValType(xVal) == 'C'
		nRet := Val(StrTran(AllTrim(xVal), ',', '.'))
	EndIf
Return nRet

/*/{Protheus.doc} CN4Limpa
Remove caracteres que permitem injecao de SQL no conteudo recebido
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cVal, Caractere, Conteudo recebido no JSON
@return Caractere, Conteudo higienizado
/*/
Static Function CN4Limpa(cVal)
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

/*/{Protheus.doc} CN4PadIt
Ajusta o conteudo ao tamanho do dicionario, zerando a esquerda quando numerico
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cVal, Caractere, Conteudo a ser ajustado
@param nTam, Numerico, Tamanho do campo no dicionario
@return Caractere, Conteudo ajustado
/*/
Static Function CN4PadIt(cVal, nTam)
	Local cRet := AllTrim(cVal)

	If ! Empty(cRet) .And. Len(cRet) < nTam .And. IsDigit(SubStr(cRet, 1, 1)) .And. Val(cRet) > 0
		cRet := StrZero(Val(cRet), nTam)
	Else
		cRet := PadR(cRet, nTam)
	EndIf
Return cRet

/*/{Protheus.doc} CN4Ctt
Valida a existencia e o bloqueio do centro de custo na tabela CTT
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cFil, Caractere, Filial do centro de custo
@param cCusto, Caractere, Codigo do centro de custo
@return Logico, .T. se o centro de custo e valido
/*/
Static Function CN4Ctt(cFil, cCusto)
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

/*/{Protheus.doc} CN4Ct1
Valida a existencia e o bloqueio da conta contabil na tabela CT1
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cFil, Caractere, Filial da conta contabil
@param cConta, Caractere, Codigo da conta contabil
@return Logico, .T. se a conta contabil e valida
/*/
Static Function CN4Ct1(cFil, cConta)
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

/*/{Protheus.doc} CN4Atual
Carrega o estado atual de um codigo de rateio na CTJ
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cFil, Caractere, Filial do rateio
@param cRat, Caractere, Codigo do rateio
@return Array, Faixas no formato {CTJ_SEQUEN, Recno, CTJ_PERCEN, CTJ_CCD, CTJ_CCC, CTJ_DEBITO, CTJ_CREDIT}
/*/
Static Function CN4Atual(cFil, cRat)
	Local aRet   := {}
	Local cQuery := ''

	cQuery := "SELECT CTJ_SEQUEN, CTJ_PERCEN, CTJ_CCD, CTJ_CCC, CTJ_DEBITO, CTJ_CREDIT, " + CRLF
	cQuery += "R_E_C_N_O_ AS RECNO " + CRLF
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
		AAdd(aRet, {QRY_ATU->CTJ_SEQUEN, QRY_ATU->RECNO, QRY_ATU->CTJ_PERCEN, ;
		            QRY_ATU->CTJ_CCD, QRY_ATU->CTJ_CCC, QRY_ATU->CTJ_DEBITO, QRY_ATU->CTJ_CREDIT})
		QRY_ATU->(DbSkip())
	EndDo

	QRY_ATU->(DbCloseArea())
Return aRet

/*/{Protheus.doc} CN4NxSeq
Devolve a proxima sequencia livre a partir do estado atual do rateio
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param aAtual, Array, Estado atual devolvido por CN4Atual
@param nTam, Numerico, Tamanho do campo CTJ_SEQUEN
@return Caractere, Proxima sequencia
/*/
Static Function CN4NxSeq(aAtual, nTam)
	Local nMaior := 0
	Local nX     := 0

	For nX := 1 To Len(aAtual)
		If Val(aAtual[nX][1]) > nMaior
			nMaior := Val(aAtual[nX][1])
		EndIf
	Next nX
Return StrZero(nMaior + 1, nTam)

/*/{Protheus.doc} CN4Soma
Soma os percentuais gravados para um codigo de rateio
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param cFil, Caractere, Filial do rateio
@param cRat, Caractere, Codigo do rateio
@return Numerico, Somatorio dos percentuais
/*/
Static Function CN4Soma(cFil, cRat)
	Local nRet   := 0
	Local aAtual := CN4Atual(cFil, cRat)
	Local nX     := 0

	For nX := 1 To Len(aAtual)
		nRet += aAtual[nX][3]
	Next nX
Return nRet

/*/{Protheus.doc} CN4Json
Monta o JSON de um registro da CTJ no mesmo layout devolvido pelo WSCON002
@author Maria Luiza
@since 18/08/2026
@version 1.0
@type function
@param nRecno, Numerico, Recno do registro na CTJ
@return Objeto, JsonObject com os dados do rateio
/*/
Static Function CN4Json(nRecno)
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
