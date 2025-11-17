//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSCOM001
Serviço rest para criação de solicitação de compra
@author Maria Luiza
@since 03/11/2025
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSCOM001 DESCRIPTION 'Serviço rest para criação de solicitação de compra'

	//Dados
	WSDATA 		filial      AS STRING
	WSDATA      solicit     AS STRING
	WSDATA      itemC1      AS STRING
	WSDATA      produto     AS STRING
	WSDATA      quant       AS NUMERIC
	WSDATA      rateio      AS STRING
	WSDATA      ccusto      AS STRING
	WSDATA      perc        AS NUMERIC
	WSDATA      cc          AS STRING

	//Métodos
	WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSCOM001/new'                               PATH 'new'           PRODUCES APPLICATION_JSON

END WSRESTFUL

/*/{Protheus.doc} WSMETHOD POST NEW
Cria um novo registro na tabela
@author Maria Luiza
@since 03/11/2025
@version 1.0
@type method

    Abaixo um exemplo do JSON que deverá vir no body
    * 1: Para campos do tipo Numérico, informe o valor sem usar as aspas
    * 2: Para campos do tipo Data, informe uma string no padrão 'YYYY-MM-DD'

        {
            "cabecalho": {
                "solicit": "conteudo",
				"filial": "conteudo"
            },
            "itens": [
                {
                    "itemC1": "conteudo",
                    "produto": "conteudo",
                    "quant": "conteudo",
                    "rateio": "2",
                    "ccusto": "conteudo"
                },
                {
                    "itemC1": "conteudo",
                    "produto": "conteudo",
                    "quant": "conteudo",
                    "rateio": "1",
                    "rateioCX": [
                        {
                            "item": "conteudo",
                            "perc": "conteudo",
                            "cc": "conteudo"
                        },
                        {
                            "item": "conteudo",
                            "perc": "conteudo",
                            "cc": "conteudo"
                        }
                    ]
                }
            ]
        }
/*/

WSMETHOD POST NEW WSRECEIVE WSSERVICE WSCOM001

	Local lRet              := .T.
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
	Local aCabSC            := {}
	Local aLinhaC1          := {}
	Local aItensSC          := {}
	Local oCabecalho
	Local aItensJson        := {}
	Local nY                := 0
	Local nZ                := 0
	Local cDoc              := ''
	Local aRateio           := {}
	Local cRateio           := ''
	Local aRatJson          := {}
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

	//Se tiver algum erro no Parse, encerra a execução
	IF ! Empty(cError)
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW004'
		jResponse['error']    := 'Parse do JSON'
		jResponse['solution'] := 'Erro ao fazer o Parse do JSON'
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	// Obtém o objeto cabecalho
	oCabecalho := jJson:GetJsonObject('cabecalho')

	// Obtém o array de itens
	aItensJson := jJson:GetJsonObject('itens')
	If ValType(aItensJson) <> 'A' .Or. Len(aItensJson) == 0
		ConOut("Erro: Campo 'itens' não encontrado, inválido ou vazio no JSON")
		Self:SetStatus(400)
		jResponse['errorId']  := 'NEW007'
		jResponse['error']    := 'Estrutura do JSON'
		jResponse['solution'] := 'O JSON deve conter o array "itens" com pelo menos um item'
		lRet := .F.
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return lRet
	EndIf

	DbSelectArea(cAliasWS)
	cDoc := GetSXENum("SC1","C1_NUM")
	SC1->(dbSetOrder(1))
	While SC1->(dbSeek(xFilial("SC1")+cDoc))
		RollBackSX8()
		cDoc := GetSXENum("SC1","C1_NUM")
	EndDo

	//Adiciona os dados do ExecAuto
	aAdd(aCabSC, {'C1_NUM',   cDoc,   Nil})
	aAdd(aCabSC, {'C1_FILIAL',   oCabecalho:GetJsonObject('filial'),   Nil})
	aAdd(aCabSC, {'C1_SOLICIT',   oCabecalho:GetJsonObject('solicit'),   Nil})
	aAdd(aCabSC, {'C1_EMISSAO',   dDataBase,   Nil})

	For nY := 1 To Len(aItensJson)
		aLinhaC1 := {}
		aAdd(aLinhaC1, {'C1_ITEM',  aItensJson[nY]:GetJsonObject('itemC1') ,   Nil})
		aAdd(aLinhaC1, {'C1_PRODUTO',   aItensJson[nY]:GetJsonObject('produto'),   Nil})
		aAdd(aLinhaC1, {'C1_QUANT',     aItensJson[nY]:GetJsonObject('quant'),     Nil})

		cRateio := aItensJson[nY]:GetJsonObject('rateio')
		aAdd(aLinhaC1, {'C1_RATEIO', cRateio, Nil})

		If cRateio == "2"
			aAdd(aLinhaC1, {'C1_CC', aItensJson[nY]:GetJsonObject('ccusto'), Nil})
		Else
			aAdd(aLinhaC1, {'C1_CC', '', Nil})
		EndIf

		aadd(aItensSC, aLinhaC1)

		// Dentro do loop nY
		If cRateio == "1" .And. !Empty(aItensJson[nY]:GetJsonObject('rateioCX'))
			aRatJson := aItensJson[nY]:GetJsonObject('rateioCX')

			If ValType(aRatJson) == 'A' .And. Len(aRatJson) > 0

				aRateio := {}
				aAdd(aRateio, Array(2))
				aRateio[1][1] := aItensJson[nY]:GetJsonObject('itemC1')
				aRateio[1][2] := {}
				
				For nZ := 1 To Len(aRatJson)
					
					aLinhaCX := {}

					aAdd(aLinhaCX, {"CX_ITEM",   StrZero(nZ, TamSX3("CX_ITEM")[1]), NIL})
					aAdd(aLinhaCX, {"CX_PERC",   aRatJson[nZ]:GetJsonObject('perc'), NIL})
					aAdd(aLinhaCX, {"CX_CC",     aRatJson[nZ]:GetJsonObject('cc'), NIL})

					aAdd(aRateio[1][2], aLinhaCX)
				Next nZ

			Else
				ConOut("Erro: Campo 'rateioCX' inválido ou vazio para item com rateio=1")
				Self:SetStatus(400)
				jResponse['errorId']  := 'NEW008'
				jResponse['error']    := 'Estrutura do JSON'
				jResponse['solution'] := 'Para itens com rateio=1, o array "rateioCX" deve ser válido e conter pelo menos um item'
				lRet := .F.
				Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
				Return lRet
			EndIf
		EndIf
	Next nY

//Chama a inclusão automática
	MSExecAuto({|w,x,y,z| MATA110(w,x,y,z)}, aCabSC, aItensSC, 3, aRateio)

//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
	If lMsErroAuto
		//Monta o texto do Error Log que será salvo
		cErrorLog   := ''
		aLogAuto    := GetAutoGrLog()
		For nLinha := 1 To Len(aLogAuto)
			cErrorLog += aLogAuto[nLinha] + CRLF
		Next nLinha

		//Grava o arquivo de log
		cArqLog := 'WSCOM001_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
		MemoWrite(cDirLog + cArqLog, cErrorLog)

		//Define o retorno para o WebService
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW005'
		jResponse['error']    := 'Erro na inclusão do registro'
		jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
		lRet := .F.

		RollBackSX8()
	Else
		ConfirmSX8()
		jResponse['note']     := 'Sc ' +cDoc+ ' incluída com sucesso'
	EndIf

//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))

Return lRet
