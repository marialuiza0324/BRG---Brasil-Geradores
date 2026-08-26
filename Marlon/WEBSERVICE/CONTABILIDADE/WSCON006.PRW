//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSCON006
Servico rest para inclusao de orcamento contabil
@author Maria Luiza
@since 21/08/2026
@version 3.0
@type wsrestful
/*/

WSRESTFUL WSCON006 DESCRIPTION 'Servico rest para inclusao de orcamento contabil'

	//Dados
	WSDATA      filial      AS STRING
	WSDATA      descricao   AS STRING
	WSDATA      calendario  AS STRING
	WSDATA      moeda       AS STRING
	WSDATA      revisao     AS STRING
	WSDATA      exercicio   AS STRING
	WSDATA      conta       AS STRING
	WSDATA      ccusto      AS STRING
	WSDATA      clvl        AS STRING

	//Metodos
	WSMETHOD POST   NEW    DESCRIPTION 'Inclusao de registro'          WSSYNTAX '/WSCON006/new'                               PATH 'new'           PRODUCES APPLICATION_JSON

END WSRESTFUL

/*/{Protheus.doc} WSMETHOD POST NEW
Cria um novo orcamento na CV2 e os periodos de cada item na CV1
@author Maria Luiza
@since 21/08/2026
@version 3.0
@type method

    Versao rest da rotina ATUCTB001, que importa orcamento por arquivo CSV.
    Mesma regra de negocio: cada item gera 12 registros na CV1, um por
    periodo do exercicio.

    Abaixo um exemplo do JSON que devera vir no body
    * 1: Para campos do tipo Numerico, informe o valor sem usar as aspas
    * 2: NAO informe o numero do orcamento - ele e gerado pelo Protheus
    * 3: O array valores tem 12 posicoes, uma por periodo. valores[1] = Jan
    * 4: ccusto e obrigatorio quando a conta tem CT1_INDNAT = '4'

        {
            "cabecalho": {
                "filial": "0101",
                "descricao": "19010001 - CONSELHO ADMINISTRATIVO",
                "calendario": "003",
                "moeda": "01",
                "revisao": "001",
                "exercicio": "2026"
            },
            "itens": [
                {
                    "conta": "3302010036",
                    "ccusto": "19010001",
                    "clvl": "",
                    "valores": [3833.33, 3833.33, 3833.33, 3833.33, 3833.33, 3833.33,
                                3833.33, 3833.33, 3833.33, 3833.33, 3833.33, 3833.33]
                }
            ]
        }
/*/

WSMETHOD POST NEW WSRECEIVE WSSERVICE WSCON006

	Local lRet              := .T.
	Local jJson             := Nil
	Local cJson             := Self:GetContent()
	Local cError            := ''
	Local jResponse         := JsonObject():New()
	Local oCabecalho
	Local aItensJson        := {}
	Local aVals             := {}
	Local aAlias            := {'CV1','CV2','CT1','CTT','CTO','CTG','CTE'}
	Local cFilial           := ''
	Local cDescri           := ''
	Local cCalend           := ''
	Local cMoeda            := ''
	Local cRevisa           := ''
	Local cExerc            := ''
	Local cConta            := ''
	Local cCCusto           := ''
	Local cClVl             := ''
	Local cDoc              := ''
	Local cFalta            := ''
	Local cMens             := ''
	Local dDtIni            := CToD('')
	Local nValor            := 0
	Local nRegs             := 0
	Local nY                := 0
	Local nZ                := 0

	//Definindo o conteudo como JSON, e pegando o content e dando um parse para ver se a estrutura esta ok
	Self:SetContentType('application/json')
	jJson  := JsonObject():New()
	cError := jJson:FromJson(cJson)

	//Se tiver algum erro no Parse, encerra a execucao
	If ! Empty(cError)
		Self:setStatus(400)
		jResponse['errorId']  := 'NEW001'
		jResponse['error']    := 'Parse do JSON'
		jResponse['solution'] := 'Erro ao fazer o Parse do JSON'
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	//A thread do servico rest nao herda as tabelas abertas de um modulo
	For nY := 1 To Len(aAlias)
		If Select(aAlias[nY]) == 0 .And. ! ChkFile(aAlias[nY])
			cFalta += aAlias[nY] + ' '
		EndIf
	Next nY

	If ! Empty(cFalta)
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW002'
		jResponse['error']    := 'Tabela indisponivel'
		jResponse['solution'] := 'Nao foi possivel abrir as tabelas: ' + AllTrim(cFalta)
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	//Obtem o objeto cabecalho
	oCabecalho := jJson:GetJsonObject('cabecalho')

	If ValType(oCabecalho) $ 'CNDLUA'
		Self:setStatus(400)
		jResponse['errorId']  := 'NEW003'
		jResponse['error']    := 'Estrutura do JSON'
		jResponse['solution'] := 'O JSON deve conter o objeto "cabecalho"'
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	//Obtem o array de itens
	aItensJson := jJson:GetJsonObject('itens')

	If ValType(aItensJson) <> 'A' .Or. Len(aItensJson) == 0
		Self:setStatus(400)
		jResponse['errorId']  := 'NEW004'
		jResponse['error']    := 'Estrutura do JSON'
		jResponse['solution'] := 'O JSON deve conter o array "itens" com pelo menos um item'
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	cFilial := AllTrim(cValToChar(oCabecalho:GetJsonObject('filial')))
	cDescri := AllTrim(cValToChar(oCabecalho:GetJsonObject('descricao')))
	cCalend := AllTrim(cValToChar(oCabecalho:GetJsonObject('calendario')))
	cMoeda  := AllTrim(cValToChar(oCabecalho:GetJsonObject('moeda')))
	cRevisa := AllTrim(cValToChar(oCabecalho:GetJsonObject('revisao')))
	cExerc  := AllTrim(cValToChar(oCabecalho:GetJsonObject('exercicio')))

	If Empty(cFilial) .Or. Empty(cDescri) .Or. Empty(cCalend) .Or. Empty(cMoeda) .Or. Empty(cRevisa)
		Self:setStatus(400)
		jResponse['errorId']  := 'NEW005'
		jResponse['error']    := 'Campos obrigatorios'
		jResponse['solution'] := 'Informe filial, descricao, calendario, moeda e revisao no cabecalho'
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	//O exercicio monta as datas dos periodos, entao precisa do ano completo
	If Len(cExerc) <> 4 .Or. Val(cExerc) <= 0
		Self:setStatus(400)
		jResponse['errorId']  := 'NEW006'
		jResponse['error']    := 'Exercicio invalido'
		jResponse['solution'] := 'Informe o exercicio com 4 digitos, por exemplo 2026'
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	cRevisa := StrZero(Val(cRevisa), CN6Tam("CV2_REVISA", 3))

	//Moeda contabil
	CTO->(dbSetOrder(1))

	If ! CTO->(dbSeek(xFilial("CTO") + PadR(cMoeda, CN6Tam("CTO_MOEDA", Len(cMoeda)))))
		cMens += 'Moeda ' + cMoeda + ' nao encontrada. '
	EndIf

	//Calendario contabil - os 12 periodos do exercicio
	CTG->(dbSetOrder(1))

	For nY := 1 To 12
		If ! CTG->(dbSeek(xFilial("CTG") + PadR(cCalend, CN6Tam("CTG_CALEND", Len(cCalend))) + PadR(cExerc, CN6Tam("CTG_EXERC", Len(cExerc))) + StrZero(nY, 2)))
			cMens += 'Calendario ' + cCalend + ' periodo ' + StrZero(nY, 2) + ' nao encontrado. '
		EndIf
	Next nY

	//Amarracao calendario x moeda
	CTE->(dbSetOrder(1))

	If ! CTE->(dbSeek(xFilial("CTE") + PadR(cMoeda, CN6Tam("CTE_MOEDA", Len(cMoeda))) + PadR(cCalend, CN6Tam("CTE_CALEND", Len(cCalend)))))
		cMens += 'Amarracao da moeda ' + cMoeda + ' x calendario ' + cCalend + ' nao encontrada. '
	EndIf

	//Contas e centros de custo dos itens
	CT1->(dbSetOrder(1))
	CTT->(dbSetOrder(1))

	For nY := 1 To Len(aItensJson)
		cConta  := AllTrim(cValToChar(aItensJson[nY]:GetJsonObject('conta')))
		cCCusto := AllTrim(cValToChar(aItensJson[nY]:GetJsonObject('ccusto')))
		aVals   := aItensJson[nY]:GetJsonObject('valores')

		If Empty(cConta)
			cMens += 'Item ' + AllTrim(Str(nY)) + ': conta nao informada. '
			Loop
		EndIf

		//Um valor por periodo, igual as 12 colunas do arquivo
		If ValType(aVals) <> 'A' .Or. Len(aVals) <> 12
			cMens += 'Item ' + AllTrim(Str(nY)) + ': o array valores deve ter 12 posicoes. '
			Loop
		EndIf

		If ! CT1->(dbSeek(xFilial("CT1") + PadR(cConta, CN6Tam("CT1_CONTA", Len(cConta)))))
			cMens += 'Item ' + AllTrim(Str(nY)) + ': conta ' + cConta + ' nao cadastrada. '
		ElseIf CT1->CT1_BLOQ == '1'
			cMens += 'Item ' + AllTrim(Str(nY)) + ': conta ' + cConta + ' bloqueada. '
		ElseIf CT1->CT1_CLASSE == '1'
			cMens += 'Item ' + AllTrim(Str(nY)) + ': conta ' + cConta + ' e sintetica. '
		ElseIf CT1->CT1_INDNAT == '4' .And. Empty(cCCusto)
			cMens += 'Item ' + AllTrim(Str(nY)) + ': conta ' + cConta + ' e de despesa/custo, informe o centro de custo. '
		EndIf

		If ! Empty(cCCusto)
			If ! CTT->(dbSeek(xFilial("CTT") + PadR(cCCusto, CN6Tam("CTT_CUSTO", Len(cCCusto)))))
				cMens += 'Item ' + AllTrim(Str(nY)) + ': centro de custo ' + cCCusto + ' nao cadastrado. '
			ElseIf CTT->CTT_BLOQ == '1'
				cMens += 'Item ' + AllTrim(Str(nY)) + ': centro de custo ' + cCCusto + ' bloqueado. '
			EndIf
		EndIf
	Next nY

	//Todas as criticas voltam juntas, como no dialogo da ATUCTB001
	If ! Empty(cMens)
		Self:setStatus(422)
		jResponse['errorId']  := 'NEW008'
		jResponse['error']    := 'Validacao do orcamento'
		jResponse['solution'] := AllTrim(cMens)
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	//O numero do orcamento e sempre gerado pelo servico
	DbSelectArea("CV2")
	cDoc := GetSXENum("CV2","CV2_ORCMTO")
	CV2->(dbSetOrder(1))
	While CV2->(dbSeek(xFilial("CV2") + cDoc))
		ConfirmSX8()
		cDoc := GetSXENum("CV2","CV2_ORCMTO")
	EndDo

	/*
	    Cabecalho e itens na mesma transacao. A falha em qualquer ponto
	    desfaz o que ja foi gravado - a ATUCTB001 passou a fazer o mesmo
	    para nao deixar orcamento pela metade.
	*/
	Begin Transaction

		If ! RecLock("CV2", .T.)
			cMens := 'Nao foi possivel obter o bloqueio para incluir o cabecalho'
			DisarmTransaction()
			Break
		EndIf

		CV2->CV2_FILIAL := xFilial("CV2")
		CV2->CV2_ORCMTO := cDoc
		CV2->CV2_DESCRI := cDescri
		CV2->CV2_STATUS := '1'
		CV2->CV2_CALEND := cCalend
		CV2->CV2_MOEDA  := cMoeda
		CV2->CV2_REVISA := cRevisa
		CV2->CV2_APROVA := cUserName
		CV2->CV2_STATSL := ' '
		CV2->(MsUnLock())

		DbSelectArea("CV1")

		For nY := 1 To Len(aItensJson)
			cConta  := AllTrim(cValToChar(aItensJson[nY]:GetJsonObject('conta')))
			cCCusto := AllTrim(cValToChar(aItensJson[nY]:GetJsonObject('ccusto')))
			cClVl   := AllTrim(cValToChar(aItensJson[nY]:GetJsonObject('clvl')))
			aVals   := aItensJson[nY]:GetJsonObject('valores')

			//Cada item gera 12 registros, um por periodo do exercicio
			For nZ := 1 To 12

				If ! RecLock("CV1", .T.)
					cMens := 'Nao foi possivel obter o bloqueio para incluir o periodo ' + StrZero(nZ, 2)
					DisarmTransaction()
					Break
				EndIf

				dDtIni := SToD(cExerc + StrZero(nZ, 2) + '01')

				//Aceita numero e tambem texto no formato brasileiro (1.234,56)
				If ValType(aVals[nZ]) == 'C'
					nValor := Val(StrTran(StrTran(AllTrim(aVals[nZ]), '.', ''), ',', '.'))
				Else
					nValor := aVals[nZ]
				EndIf

				CV1->CV1_FILIAL := xFilial("CV1")
				CV1->CV1_ORCMTO := cDoc
				CV1->CV1_DESCRI := cDescri
				CV1->CV1_STATUS := '1'
				CV1->CV1_CALEND := cCalend
				CV1->CV1_MOEDA  := cMoeda
				CV1->CV1_REVISA := cRevisa
				CV1->CV1_SEQUEN := StrZero(nY, CN6Tam("CV1_SEQUEN", 4))
				CV1->CV1_CT1INI := cConta
				CV1->CV1_CT1FIM := cConta
				CV1->CV1_CTTINI := cCCusto
				CV1->CV1_CTTFIM := cCCusto
				CV1->CV1_CTDINI := ' '
				CV1->CV1_CTDFIM := ' '
				CV1->CV1_CTHINI := cClVl
				CV1->CV1_CTHFIM := cClVl
				CV1->CV1_PERIOD := StrZero(nZ, 2)
				CV1->CV1_DTINI  := FirstDate(dDtIni)
				CV1->CV1_DTFIM  := LastDate(dDtIni)
				CV1->CV1_VALOR  := nValor
				CV1->CV1_APROVA := cUserName
				CV1->(MsUnLock())

				nRegs++
			Next nZ
		Next nY

	End Transaction

	//Se a gravacao nao fechou, devolve a numeracao reservada
	If nRegs <> Len(aItensJson) * 12
		RollBackSX8()
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW009'
		jResponse['error']    := 'Erro na gravacao'
		jResponse['solution'] := AllTrim(cMens) + ' Nenhum registro foi mantido.'
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	ConfirmSX8()

	Self:setStatus(201)
	jResponse['note']      := 'Orcamento ' + AllTrim(cDoc) + ' incluido com sucesso'
	jResponse['orcamento'] := AllTrim(cDoc)
	jResponse['filial']    := cFilial
	jResponse['revisao']   := cRevisa
	jResponse['itens']     := Len(aItensJson)
	jResponse['periodos']  := nRegs

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))

Return lRet

/*/{Protheus.doc} CN6Tam
Devolve o tamanho do campo no dicionario
@author Maria Luiza
@since 25/08/2026
@version 1.0
@type function
@param cCampo, Caractere, Nome do campo
@param nDefault, Numerico, Tamanho assumido quando o campo nao consta no dicionario
@return Numerico, Tamanho do campo

    TamSX3 devolve array vazio para campo inexistente e o acesso direto a
    posicao 1 derruba a thread. O tamanho do proprio valor serve de
    alternativa segura para montar a chave.
/*/
Static Function CN6Tam(cCampo, nDefault)
	Local aTam := TamSX3(cCampo)
	Local nRet := nDefault

	If ValType(aTam) == 'A' .And. Len(aTam) > 0
		nRet := aTam[1]
	EndIf
Return nRet
