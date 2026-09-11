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
	WSDATA      dtentrega   AS DATE
	WSDATA      xurgen      AS STRING
	WSDATA      xobmemo     AS STRING
	WSDATA      vunit       AS NUMERIC

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
				"filial": "conteudo",
				"xurgen": "1"
            },
            "itens": [
                {
                    "itemC1": "conteudo",
                    "produto": "conteudo",
                    "quant": "conteudo",
                    "rateio": "2",
                    "ccusto": "conteudo",
                    "dtentrega": "2023-10-01",
                    "xurgen": "2",
                    "C1_XOBMEMO": "Observacao da solicitacao",
                    "C1_VUNIT": 1500.00
                },
                {
                    "itemC1": "conteudo",
                    "produto": "conteudo",
                    "quant": "conteudo",
                    "rateio": "1",
                    "dtentrega": "2023-10-01",
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

    O campo "xurgen" (C1_XURGEN) indica se a Solicitacao de Compras
    e urgente: "1" = Sim / "2" = Nao. E opcional - informado no
    cabecalho vale para todos os itens e informado no item sobrepoe
    o cabecalho. Quando nao informado, o campo fica com o conteudo
    padrao do dicionario.

    Os campos "C1_XOBMEMO" (observacao da SC) e "C1_VUNIT" (preco
    estimado) sao OPCIONAIS. Aceitam o nome do campo da SC1 ou o
    alias curto "xobmemo" / "vunit" e sao procurados no item, no
    cabecalho e na raiz do JSON - nessa ordem de precedencia.
    Quando nao informados em nenhum deles o campo nao e enviado ao
    ExecAuto e fica com o conteudo padrao do dicionario, sem erro.
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
	Local nPosRat           := 0
	Local cDoc              := ''
	Local aRateioCX           := {}
	Local cRateio           := ''
	Local aRatJson          := {}
	Local aLinhaCX          := {}
	Local cUrgCab           := ''
	Local cUrgen            := ''
	Local xObMemo           := Nil
	Local xVUnit            := Nil
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

	/*
	    Urgencia da Solicitacao de Compras (C1_XURGEN): 1 = Sim / 2 = Nao.
	    O campo e opcional. Informado no cabecalho vale para todos os itens
	    e informado no item sobrepoe o cabecalho.
	*/
	cUrgCab := W1Urgen(oCabecalho)

	If ! Empty(cUrgCab) .And. cUrgCab <> '1' .And. cUrgCab <> '2'
		Self:SetStatus(400)
		jResponse['errorId']  := 'NEW017'
		jResponse['error']    := 'Urgencia invalida'
		jResponse['solution'] := 'O campo "xurgen" do cabecalho deve ser "1" (Sim) ou "2" (Nao)'
		lRet := .F.
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return lRet
	EndIf

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
		aAdd(aLinhaC1, {'C1_DATPRF',  STOD(StrTran(aItensJson[nY]:GetJsonObject('dtentrega'), '-', '')) ,    Nil})

		cRateio := aItensJson[nY]:GetJsonObject('rateio')
		aAdd(aLinhaC1, {'C1_RATEIO', cRateio, Nil})

		If cRateio == "2"
			aAdd(aLinhaC1, {'C1_CC', aItensJson[nY]:GetJsonObject('ccusto'), Nil})
		Else
			aAdd(aLinhaC1, {'C1_CC', '', Nil})
		EndIf

		//Urgencia: o item sobrepoe o cabecalho
		cUrgen := W1Urgen(aItensJson[nY])

		If Empty(cUrgen)
			cUrgen := cUrgCab
		EndIf

		If ! Empty(cUrgen)
			If cUrgen <> '1' .And. cUrgen <> '2'
				Self:SetStatus(400)
				jResponse['errorId']  := 'NEW017'
				jResponse['error']    := 'Urgencia invalida'
				jResponse['solution'] := 'O campo "xurgen" do item ' + AllTrim(Str(nY)) + ' deve ser "1" (Sim) ou "2" (Nao)'
				lRet := .F.
				RollBackSX8()
				Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
				Return lRet
			EndIf

			aAdd(aLinhaC1, {'C1_XURGEN', cUrgen, Nil})
		EndIf

		/*
		    Observacao (C1_XOBMEMO) e preco estimado (C1_VUNIT) sao
		    campos OPCIONAIS: procurados no item, no cabecalho e na raiz
		    do JSON, nessa ordem. Quando nao vem em nenhum deles o campo
		    nao e enviado ao ExecAuto e segue o comportamento padrao dos
		    campos nao preenchidos, sem gerar erro.
		*/
		xObMemo := W1Get({aItensJson[nY], oCabecalho, jJson}, 'xobmemo', 'C1_XOBMEMO')

		/*
		    O body JSON chega em UTF-8 e a resposta e devolvida com
		    EncodeUTF8, mas o conteudo lido precisa ser convertido para o
		    encoding do Protheus (CP1252) antes de gravar na SC1 - sem isso
		    a observacao fica gravada com os bytes crus do UTF-8 e aparece
		    como "ObservaAcAo" na tela. Os demais campos de caractere sao
		    codigos ASCII, onde a conversao nao tem efeito.
		*/
		If ValType(xObMemo) <> 'U'
			aAdd(aLinhaC1, {'C1_XOBMEMO', DecodeUTF8(W1ToC(xObMemo)), Nil})
		EndIf

		xVUnit := W1Get({aItensJson[nY], oCabecalho, jJson}, 'vunit', 'C1_VUNIT')

		If ValType(xVUnit) <> 'U'
			aAdd(aLinhaC1, {'C1_VUNIT', Round(W1ToN(xVUnit), TamSX3("C1_VUNIT")[2]), Nil})
		EndIf

		aadd(aItensSC, aLinhaC1)

		// Dentro do loop nY
		If cRateio == "1" .And. !Empty(aItensJson[nY]:GetJsonObject('rateioCX'))
			aRatJson := aItensJson[nY]:GetJsonObject('rateioCX')

			If ValType(aRatJson) == 'A' .And. Len(aRatJson) > 0

				/*
				    Acumula o rateio de CADA item rateado. Zerar o array aqui
				    e usar o indice fixo [1] fazia com que apenas o ULTIMO
				    item rateado da SC tivesse o rateio gravado na SCX - os
				    anteriores ficavam sem faixa nenhuma.
				*/
				aAdd(aRateioCX, Array(2))
				nPosRat := Len(aRateioCX)
				aRateioCX[nPosRat][1] := aItensJson[nY]:GetJsonObject('itemC1')
				aRateioCX[nPosRat][2] := {}

				For nZ := 1 To Len(aRatJson)

					aLinhaCX := {}

					aAdd(aLinhaCX, {"CX_ITEM", StrZero(nZ,TamSX3("CX_ITEM")[1]), Nil})
					aAdd(aLinhaCX, {"CX_PERC", aRatJson[nZ]:GetJsonObject('perc'), Nil})
					aAdd(aLinhaCX, {"CX_CC",   aRatJson[nZ]:GetJsonObject('cc'), Nil})

					aAdd(aRateioCX[nPosRat][2], aLinhaCX)

				Next

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
	MSExecAuto({|w,x,y,z| MATA110(w,x,y,,,z)}, aCabSC, aItensSC, 3, aRateioCX)

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
		jResponse['error']    :=  cErrorLog
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

/*/{Protheus.doc} W1Urgen
Le o campo de urgencia (xurgen) do objeto JSON devolvendo sempre caractere
@author Maria Luiza
@since 08/09/2026
@version 1.0
@type function
@param jObj, Objeto, Objeto JSON de entrada (cabecalho ou item)
@return Caractere, Conteudo do campo, vazio quando nao informado
/*/
Static Function W1Urgen(jObj)
Return W1ToC(W1Get({jObj}, 'xurgen', 'C1_XURGEN'))

/*/{Protheus.doc} W1Get
Le um campo opcional do JSON procurando nos objetos recebidos, na
ordem de precedencia, aceitando o alias curto ou o nome do campo
@author Maria Luiza
@since 08/09/2026
@version 1.0
@type function

    Devolve Nil (ValType 'U') quando a propriedade nao existe em
    nenhum dos objetos, permitindo ao chamador distinguir 'campo nao
    informado' de 'campo informado vazio'. Objeto ausente ou invalido
    apenas nao contribui com o valor, por isso a leitura nunca gera
    erro quando o cabecalho ou o item nao trazem o campo.

@param aObjs, Array, Objetos JSON na ordem de precedencia
@param cAlias, Caractere, Nome curto aceito no JSON
@param cCampo, Caractere, Nome do campo da SC1 aceito no JSON
@return Indefinido, Conteudo encontrado ou Nil quando nao informado
/*/
Static Function W1Get(aObjs, cAlias, cCampo)
	Local nI   := 0
	Local nJ   := 0
	Local aChv := {cAlias, cCampo}
	Local xVal := Nil

	For nI := 1 To Len(aObjs)

		If ! (ValType(aObjs[nI]) $ 'CNDLUA')

			For nJ := 1 To Len(aChv)
				xVal := aObjs[nI]:GetJsonObject(aChv[nJ])

				If ValType(xVal) <> 'U'
					Return xVal
				EndIf
			Next nJ
		EndIf
	Next nI
Return Nil

/*/{Protheus.doc} W1ToC
Converte o conteudo lido do JSON para caractere
@author Maria Luiza
@since 08/09/2026
@version 1.0
@type function
@param xVal, Indefinido, Conteudo lido do JSON
@return Caractere, Conteudo convertido, vazio quando nao informado
/*/
Static Function W1ToC(xVal)
	Local cRet := ''

	If ValType(xVal) == 'C'
		cRet := AllTrim(xVal)
	ElseIf ValType(xVal) == 'N'
		cRet := AllTrim(Str(xVal))
	EndIf
Return cRet

/*/{Protheus.doc} W1ToN
Converte o conteudo lido do JSON para numerico
@author Maria Luiza
@since 08/09/2026
@version 1.0
@type function

    Trata os dois formatos que o consumidor pode enviar: numero puro
    (1500.00) ou string ("1500.00" / "1500,00").

@param xVal, Indefinido, Conteudo lido do JSON
@return Numerico, Conteudo convertido, zero quando nao informado
/*/
Static Function W1ToN(xVal)
	Local nRet := 0

	If ValType(xVal) == 'N'
		nRet := xVal
	ElseIf ValType(xVal) == 'C'
		nRet := Val(StrTran(AllTrim(xVal), ',', '.'))
	EndIf
Return nRet
