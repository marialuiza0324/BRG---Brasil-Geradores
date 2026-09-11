//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSCOM005
Serviço REST para Alteração de Solicitação de Compra
@author Maria Luiza
@since 20/07/2026
@version 2.0
@type wsrestful

    A alteracao da Solicitacao de Compras e feita pela rotina automatica
    MATA110 (opcao 4), com o rateio no 6o parametro - mesma abordagem do
    WSCOM001. A rotina automatica controla transacao e bloqueio dos
    registros, por isso nao ha RecLock manual nem Begin Transaction.

    CAMPOS QUE PODEM SER ALTERADOS
    ------------------------------
    CHAVE - identificam o registro e NUNCA sao alterados:
      id (query string) ...... C1_NUM
      cabecalho.filial ....... C1_FILIAL
      itens[].itemC1 ......... C1_ITEM

    CABECALHO - alteravel:
      solicit ................ C1_SOLICIT   Solicitante
      xurgen ................. C1_XURGEN    Urgencia: 1 = Sim / 2 = Nao - vale para todos os itens

    ITEM - alteraveis:
      produto ................ C1_PRODUTO   Codigo do produto
      quant .................. C1_QUANT     Quantidade
      local .................. C1_LOCAL     Armazem
      dtentrega .............. C1_DATPRF    Data de necessidade
      rateio ................. C1_RATEIO    1 = rateado / 2 = centro de custo unico
      ccusto ................. C1_CC        Centro de custo (somente quando rateio = 2)
      xurgen ................. C1_XURGEN    Urgencia: 1 = Sim / 2 = Nao - sobrepoe o cabecalho
      xobmemo ................ C1_XOBMEMO   Observacao da SC - aceita tambem como "C1_XOBMEMO"
      vunit .................. C1_VUNIT     Preco estimado   - aceita tambem como "C1_VUNIT"

    RATEIO (SCX) - alteraveis quando rateio = 1:
      rateioCX[].perc ........ CX_PERC      Percentual
      rateioCX[].cc .......... CX_CC        Centro de custo

    Quando informado, o "rateioCX" SUBSTITUI integralmente o rateio do
    item. Quando omitido, o rateio gravado na SCX e relido e reenviado
    sem alteracao.

    NAO ALTERAVEIS por este servico, por serem campos de controle do
    Protheus: C1_EMISSAO, C1_APROV, C1_APROVC, C1_PEDIDO, C1_QUJE,
    C1_USER, C1_ORIGEM, C1_FOIBLQ e demais campos de aprovacao.

    CAMPOS OPCIONAIS
    ----------------
    O array do cabecalho e o de cada item vao SEMPRE completos para a
    MATA110: a rotina padrao faz AScan pelos campos e indexa o resultado
    direto, entao um array incompleto faz a A110ALTERA estourar com
    "array out of bounds".

    O efeito de "campo opcional" e obtido de outra forma - lendo o
    conteudo ATUAL do registro e sobrepondo apenas o que veio no JSON.
    Assim alterar somente a quantidade nao apaga produto, armazem, data,
    rateio ou centro de custo, e o ExecAuto continua recebendo todos os
    campos que espera.

    A mesma regra vale para o rateio: quando o "rateioCX" nao vem no
    JSON, as linhas da SCX sao relidas e reenviadas iguais (C5RatAtu).
/*/

WSRESTFUL WSCOM005 DESCRIPTION 'Serviço REST para Alteração de Solicitação de Compra '

	//Dados
	WSDATA      id          AS STRING
	WSDATA 		filial      AS STRING
	WSDATA      solicit     AS STRING
	WSDATA      itemC1      AS STRING
	WSDATA      produto     AS STRING
	WSDATA      quant       AS NUMERIC
	WSDATA      local       AS STRING
	WSDATA      dtentrega   AS STRING
	WSDATA      rateio      AS STRING
	WSDATA      ccusto      AS STRING
	WSDATA      perc        AS NUMERIC
	WSDATA      cc          AS STRING
	WSDATA      xurgen      AS STRING
	WSDATA      xobmemo     AS STRING
	WSDATA      vunit       AS NUMERIC

	//Métodos
	WSMETHOD PUT    UPDATE DESCRIPTION 'Atualização de registro'       WSSYNTAX '/WSCOM005/update'                            PATH 'update'        PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD PUT UPDATE
Atualiza a Solicitacao de Compras e o rateio dos itens
@author Maria Luiza
@since 20/07/2026
@version 2.0
@type method
@param id, Caractere, Numero da Solicitacao de Compras (C1_NUM)

    Abaixo um exemplo do JSON que deverá vir no body
    * 1: Para campos do tipo Numérico, informe o valor sem usar as aspas
    * 2: Para campos do tipo Data, informe uma string no padrão 'YYYY-MM-DD'
    * 3: No item, somente "itemC1" e obrigatorio - ele identifica a linha.
         Os demais campos sao opcionais e o que nao vier permanece como esta
    * 4: O "rateioCX" tambem e opcional. Se o item for rateado (rateio=1)
         e o "rateioCX" nao vier, o rateio atual da SCX e mantido
    * 5: "ccusto" so e considerado quando "rateio" = "2"
    * 6: "xurgen" (C1_XURGEN) e a urgencia da SC: "1" = Sim / "2" = Nao.
         Pode vir no cabecalho, valendo para todos os itens enviados,
         ou no item, sobrepondo o cabecalho. Omitido, o valor gravado
         no registro e mantido
    * 7: "C1_XOBMEMO" (observacao) e "C1_VUNIT" (preco estimado) sao
         OPCIONAIS. Aceitam o nome do campo da SC1 ou o alias curto
         "xobmemo" / "vunit" e sao procurados no item, no cabecalho e
         na raiz do JSON - nessa ordem. Omitidos, nao sao enviados ao
         ExecAuto e o conteudo gravado na SC1 permanece inalterado

    {
        "cabecalho": {
            "filial": "0101",
            "solicit": "000001",
            "xurgen": "1"
        },
        "itens": [
            {
                "itemC1": "01",
                "produto": "PROD001",
                "quant": 15,
                "local": "01",
                "dtentrega": "2026-09-30",
                "rateio": "2",
                "ccusto": "20010006",
                "xurgen": "2",
                "C1_XOBMEMO": "Observacao da solicitacao",
                "C1_VUNIT": 1500.00
            },
            {
                "itemC1": "02",
                "rateio": "1",
                "rateioCX": [
                    { "perc": 60, "cc": "20010006" },
                    { "perc": 40, "cc": "20010007" }
                ]
            }
        ]
    }

    Alterando SOMENTE a quantidade do item 01 - os demais campos do item
    permanecem exatamente como estao na base:

    {
        "cabecalho": { "filial": "0101" },
        "itens": [
            { "itemC1": "01", "quant": 15 }
        ]
    }
/*/

WSMETHOD PUT UPDATE WSRECEIVE id WSSERVICE WSCOM005
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
	Local oItem
	Local aItensJson        := {}
	Local nY                := 0
	Local nZ                := 0
	Local nPosRat           := 0
	Local aRateioCX         := {}
	Local cRateio           := ''
	Local aRatJson          := {}
	Local aLinhaCX          := {}
	Local cFilSC            := ''
	Local cSolicit          := ''
	Local cItemC1           := ''
	Local cDtEnt            := ''
	Local dDtEnt            := CToD('')
	Local nPerc             := 0
	Local cSolicAtu         := ''
	Local cProduto          := ''
	Local nQuant            := 0
	Local cLocal            := ''
	Local dDatPrf           := CToD('')
	Local cCCusto           := ''
	Local lRatJson          := .F.
	Local cUrgen            := ''
	Local cUrgCab           := ''
	Local lUrgCab           := .F.
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

	//O body precisa chegar ao servico
	If Empty(cJson)
		Return C5Fault(Self, 400, 'UPD005', 'Body vazio', 'A requisicao chegou sem body. Confirme o envio do JSON e o header Content-Type: application/json')
	EndIf

	//Se tiver algum erro no Parse, encerra a execução antes de tocar na base
	If ! Empty(cError)
		Return C5Fault(Self, 400, 'UPD008', 'Parse do JSON', 'Erro no Parse do JSON: ' + AllTrim(cValToChar(cError)) + ' | bytes recebidos: ' + AllTrim(Str(Len(cJson))))
	EndIf

	//Se o id estiver vazio
	If Empty(::id)
		Return C5Fault(Self, 400, 'UPD006', 'ID vazio', 'Informe o ID (numero da Solicitacao de Compras) na query string')
	EndIf

	// Obtém o objeto cabecalho
	oCabecalho := jJson:GetJsonObject('cabecalho')

	If ValType(oCabecalho) $ 'CNDLUA'
		Return C5Fault(Self, 400, 'UPD010', 'Estrutura do JSON', 'O JSON deve conter o objeto "cabecalho"')
	EndIf

	// Obtém o array de itens
	aItensJson := jJson:GetJsonObject('itens')

	If ValType(aItensJson) <> 'A' .Or. Len(aItensJson) == 0
		Return C5Fault(Self, 400, 'NEW007', 'Estrutura do JSON', 'O JSON deve conter o array "itens" com pelo menos um item')
	EndIf

	/*
	    A filial usada para localizar a SC precisa ser a mesma enviada ao
	    ExecAuto, senao a validacao ocorre em uma filial e a gravacao em
	    outra. Quando o cabecalho nao informa filial, assume a do ambiente.
	*/
	cFilSC   := C5GetC(oCabecalho, 'filial')
	cSolicit := C5GetC(oCabecalho, 'solicit')

	If Empty(cFilSC)
		cFilSC := FWxFilial(cAliasWS)
	Else
		cFilSC := PadR(cFilSC, TamSX3("C1_FILIAL")[1])
	EndIf

	//A rotina automatica opera na filial corrente do ambiente
	If cFilSC <> FWxFilial(cAliasWS)
		Return C5Fault(Self, 409, 'UPD011', 'Filial divergente', 'A filial informada (' + AllTrim(cFilSC) + ') e diferente da filial do ambiente (' + AllTrim(FWxFilial(cAliasWS)) + '). Nao e possivel alterar Solicitacao de Compras de outra filial')
	EndIf

	/*
	    Urgencia da Solicitacao de Compras (C1_XURGEN): 1 = Sim / 2 = Nao.
	    O campo e opcional. Informado no cabecalho vale para todos os itens
	    enviados e informado no item sobrepoe o cabecalho. Quando nao vem
	    no JSON, o valor gravado no registro e mantido.
	*/
	If C5Tem(oCabecalho, 'xurgen') .And. ! Empty(C5GetC(oCabecalho, 'xurgen'))
		cUrgCab := C5GetC(oCabecalho, 'xurgen')

		If cUrgCab <> '1' .And. cUrgCab <> '2'
			Return C5Fault(Self, 400, 'NEW017', 'Urgencia invalida', 'O campo "xurgen" do cabecalho deve ser "1" (Sim) ou "2" (Nao)')
		EndIf

		lUrgCab := .T.
	EndIf

	DbSelectArea(cAliasWS)
	(cAliasWS)->(DbSetOrder(1))

	//Se não encontrar o registro
	If ! (cAliasWS)->(MsSeek(cFilSC + ::id))
		Return C5Fault(Self, 404, 'UPD007', 'ID nao encontrado', 'Solicitacao de Compras ' + AllTrim(::id) + ' nao encontrada na filial ' + AllTrim(cFilSC))
	EndIf

	/*
	    O cabecalho precisa ir COMPLETO para a MATA110. A rotina padrao faz
	    AScan pelos campos no array e indexa o resultado direto - se o campo
	    nao estiver presente o AScan devolve 0 e a A110ALTERA estoura com
	    "array out of bounds". Campos nao informados no JSON sao preenchidos
	    com o conteudo atual do registro, mesmo padrao do WSCOM007.
	*/
	cSolicAtu := SC1->C1_SOLICIT

	If ! Empty(cSolicit)
		cSolicAtu := cSolicit
	EndIf

	aAdd(aCabSC, {'C1_NUM',     ::id,            Nil})
	aAdd(aCabSC, {'C1_FILIAL',  cFilSC,          Nil})
	aAdd(aCabSC, {'C1_SOLICIT', cSolicAtu,       Nil})
	aAdd(aCabSC, {'C1_EMISSAO', SC1->C1_EMISSAO, Nil})

	For nY := 1 To Len(aItensJson)
		oItem := aItensJson[nY]

		If ValType(oItem) $ 'CNDLUA'
			Return C5Fault(Self, 400, 'NEW009', 'Estrutura do JSON', 'O item ' + AllTrim(Str(nY)) + ' do array "itens" nao e um objeto valido')
		EndIf

		//O item da SC identifica a linha e por isso e obrigatorio
		cItemC1 := C5GetC(oItem, 'itemC1')

		If Empty(cItemC1)
			Return C5Fault(Self, 400, 'NEW010', 'Campo obrigatorio', 'O campo "itemC1" e obrigatorio no item ' + AllTrim(Str(nY)) + ' - e ele que identifica a linha da SC a ser alterada')
		EndIf

		//Confere se o item existe na SC antes de mandar para o ExecAuto
		If ! (cAliasWS)->(MsSeek(cFilSC + ::id + PadR(cItemC1, TamSX3("C1_ITEM")[1])))
			Return C5Fault(Self, 404, 'NEW012', 'Item nao encontrado', 'O item ' + AllTrim(cItemC1) + ' nao existe na Solicitacao de Compras ' + AllTrim(::id))
		EndIf

		/*
		    O item tambem precisa ir COMPLETO para a MATA110, pelo mesmo
		    motivo do cabecalho. O efeito de "campo opcional" e obtido
		    lendo o conteudo ATUAL do registro (a SC1 ja esta posicionada
		    no item pelo MsSeek acima) e sobrepondo apenas o que veio no
		    JSON - assim alterar so a quantidade nao apaga os demais campos
		    e o array continua com todos os campos que a rotina espera.
		*/
		cProduto := SC1->C1_PRODUTO
		nQuant   := SC1->C1_QUANT
		cLocal   := SC1->C1_LOCAL
		dDatPrf  := SC1->C1_DATPRF
		cRateio  := SC1->C1_RATEIO
		cCCusto  := SC1->C1_CC
		cUrgen   := SC1->C1_XURGEN

		If C5Tem(oItem, 'produto')
			cProduto := C5GetC(oItem, 'produto')
		EndIf

		If C5Tem(oItem, 'quant')
			nQuant := C5GetN(oItem, 'quant')
		EndIf

		If C5Tem(oItem, 'local')
			cLocal := C5GetC(oItem, 'local')
		EndIf

		//Data de necessidade recebida como string 'YYYY-MM-DD'
		If C5Tem(oItem, 'dtentrega')
			cDtEnt := C5GetC(oItem, 'dtentrega')

			If ! Empty(cDtEnt)
				dDtEnt := SToD(StrTran(cDtEnt, '-', ''))

				If Empty(dDtEnt)
					Return C5Fault(Self, 400, 'NEW013', 'Data invalida', 'A data "' + AllTrim(cDtEnt) + '" informada em "dtentrega" no item ' + AllTrim(cItemC1) + ' e invalida. Utilize o formato YYYY-MM-DD')
				EndIf

				dDatPrf := dDtEnt
			EndIf
		EndIf

		/*
		    A regra original limpa C1_CC quando o item nao e de centro de
		    custo unico (rateio <> 2), pois nesse caso o CC vem da SCX.
		    A regra foi preservada e so e aplicada quando "rateio" vier no
		    JSON - senao o rateio e o centro de custo atuais sao mantidos.
		*/
		If C5Tem(oItem, 'rateio') .And. ! Empty(C5GetC(oItem, 'rateio'))
			cRateio := C5GetC(oItem, 'rateio')

			If cRateio <> "1" .And. cRateio <> "2"
				Return C5Fault(Self, 400, 'NEW014', 'Rateio invalido', 'O campo "rateio" do item ' + AllTrim(cItemC1) + ' deve ser "1" (rateado) ou "2" (centro de custo unico)')
			EndIf

			If cRateio == "2"
				cCCusto := C5GetC(oItem, 'ccusto')
			Else
				cCCusto := ''
			EndIf
		EndIf

		//Urgencia: o cabecalho sobrepoe o gravado e o item sobrepoe o cabecalho
		If lUrgCab
			cUrgen := cUrgCab
		EndIf

		If C5Tem(oItem, 'xurgen') .And. ! Empty(C5GetC(oItem, 'xurgen'))
			cUrgen := C5GetC(oItem, 'xurgen')

			If cUrgen <> '1' .And. cUrgen <> '2'
				Return C5Fault(Self, 400, 'NEW017', 'Urgencia invalida', 'O campo "xurgen" do item ' + AllTrim(cItemC1) + ' deve ser "1" (Sim) ou "2" (Nao)')
			EndIf
		EndIf

		aLinhaC1 := {}
		aAdd(aLinhaC1, {'C1_ITEM',    cItemC1,  Nil})
		aAdd(aLinhaC1, {'C1_PRODUTO', cProduto, Nil})
		aAdd(aLinhaC1, {'C1_QUANT',   nQuant,   Nil})
		aAdd(aLinhaC1, {'C1_LOCAL',   cLocal,   Nil})
		aAdd(aLinhaC1, {'C1_DATPRF',  dDatPrf,  Nil})
		aAdd(aLinhaC1, {'C1_RATEIO',  cRateio,  Nil})
		aAdd(aLinhaC1, {'C1_CC',      cCCusto,  Nil})

		//So envia a urgencia quando ha conteudo, para nao gravar branco em registro antigo
		If ! Empty(cUrgen)
			aAdd(aLinhaC1, {'C1_XURGEN', cUrgen,   Nil})
		EndIf

		/*
		    Observacao (C1_XOBMEMO) e preco estimado (C1_VUNIT) sao
		    campos OPCIONAIS: procurados no item, no cabecalho e na raiz
		    do JSON, nessa ordem. Diferente dos campos padrao acima, eles
		    so entram no array quando vierem no JSON - assim a ausencia da
		    propriedade nao gera erro e nunca sobrepoe o que esta gravado
		    na SC1, ja que a MATA110 mantem o conteudo dos campos que nao
		    recebe. Mesmo tratamento dado ao C1_XURGEN.
		*/
		xObMemo := C5Get({oItem, oCabecalho, jJson}, 'xobmemo', 'C1_XOBMEMO')

		/*
		    O body JSON chega em UTF-8 e a resposta e devolvida com
		    EncodeUTF8, mas o conteudo lido precisa ser convertido para o
		    encoding do Protheus (CP1252) antes de gravar na SC1 - sem isso
		    a observacao fica gravada com os bytes crus do UTF-8 e aparece
		    como "ObservaAcAo" na tela. Os demais campos de caractere sao
		    codigos ASCII, onde a conversao nao tem efeito.
		*/
		If ValType(xObMemo) <> 'U'
			aAdd(aLinhaC1, {'C1_XOBMEMO', DecodeUTF8(C5ToC(xObMemo)), Nil})
		EndIf

		xVUnit := C5Get({oItem, oCabecalho, jJson}, 'vunit', 'C1_VUNIT')

		If ValType(xVUnit) <> 'U'
			aAdd(aLinhaC1, {'C1_VUNIT', Round(C5ToN(xVUnit), TamSX3("C1_VUNIT")[2]), Nil})
		EndIf

		aadd(aItensSC, aLinhaC1)

		// Dentro do loop nY
		If cRateio == "1"

			/*
			    O "rateioCX" segue a mesma regra dos demais campos: e opcional.
			    Quando ele NAO vem no JSON o rateio atual da SCX e relido e
			    reenviado igual, para que uma alteracao parcial (so a
			    quantidade, por exemplo) nao apague o rateio ja gravado.
			    Quando ele VEM no JSON substitui integralmente o rateio do item.
			*/
			lRatJson := .F.
			aRatJson := {}

			If C5Tem(oItem, 'rateioCX')
				aRatJson := oItem:GetJsonObject('rateioCX')

				If ValType(aRatJson) <> 'A' .Or. Len(aRatJson) == 0
					Return C5Fault(Self, 400, 'NEW008', 'Estrutura do JSON', 'Quando informado, o "rateioCX" do item ' + AllTrim(cItemC1) + ' deve ser um array com pelo menos uma linha. Para manter o rateio atual, omita o campo')
				EndIf

				lRatJson := .T.
			EndIf

			/*
			    Acumula o rateio de CADA item rateado. Na versao anterior o
			    array era reiniciado dentro do laco e o indice era fixo em
			    [1], de modo que apenas o ultimo item rateado da SC tinha o
			    rateio gravado na SCX.
			*/
			aAdd(aRateioCX, Array(2))
			nPosRat := Len(aRateioCX)
			aRateioCX[nPosRat][1] := cItemC1
			aRateioCX[nPosRat][2] := {}

			If ! lRatJson

				//Mantem o rateio ja gravado na SCX
				If ! C5RatAtu(cFilSC, ::id, cItemC1, aRateioCX[nPosRat][2])
					Return C5Fault(Self, 400, 'NEW016', 'Rateio inexistente', 'O item ' + AllTrim(cItemC1) + ' esta marcado como rateado (rateio=1) e nao possui rateio gravado na SCX. Informe o array "rateioCX" para este item')
				EndIf

				//Reposiciona a SC1, a consulta acima trocou a area corrente
				DbSelectArea(cAliasWS)
				(cAliasWS)->(MsSeek(cFilSC + ::id + PadR(cItemC1, TamSX3("C1_ITEM")[1])))
			EndIf

			For nZ := 1 To Len(aRatJson)

				If ValType(aRatJson[nZ]) $ 'CNDLUA'
					Return C5Fault(Self, 400, 'NEW011', 'Estrutura do JSON', 'A linha ' + AllTrim(Str(nZ)) + ' do "rateioCX" do item ' + AllTrim(cItemC1) + ' nao e um objeto valido')
				EndIf

				nPerc := C5GetN(aRatJson[nZ], 'perc')

				If nPerc <= 0 .Or. nPerc > 100
					Return C5Fault(Self, 400, 'NEW015', 'Percentual invalido', 'O percentual da linha ' + AllTrim(Str(nZ)) + ' do rateio do item ' + AllTrim(cItemC1) + ' deve ser maior que zero e menor ou igual a 100')
				EndIf

				aLinhaCX := {}

				aAdd(aLinhaCX, {"CX_ITEM", StrZero(nZ,TamSX3("CX_ITEM")[1]), Nil})
				aAdd(aLinhaCX, {"CX_PERC", nPerc, Nil})
				aAdd(aLinhaCX, {"CX_CC",   C5GetC(aRatJson[nZ], 'cc'), Nil})

				aAdd(aRateioCX[nPosRat][2], aLinhaCX)

			Next

		EndIf
	Next nY

	//Reposiciona no primeiro item da SC antes da rotina automatica
	(cAliasWS)->(MsSeek(cFilSC + ::id))

	//Chama a atualização automática
	MSExecAuto({|w,x,y,z| MATA110(w,x,y,,,z)}, aCabSC, aItensSC, 4, aRateioCX)

	//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
	If lMsErroAuto
		//Monta o texto do Error Log que será salvo
		cErrorLog   := ''
		aLogAuto    := GetAutoGrLog()
		For nLinha := 1 To Len(aLogAuto)
			cErrorLog += aLogAuto[nLinha] + CRLF
		Next nLinha

		//Grava o arquivo de log
		cArqLog := 'WSCOM005_Upd_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
		MemoWrite(cDirLog + cArqLog, cErrorLog)

		ConOut(cErrorLog)

		//Define o retorno para o WebService
		Return C5Fault(Self, 500, 'UPD009', 'Erro na atualizacao do registro', 'Nao foi possivel alterar a Solicitacao de Compras ' + AllTrim(::id) + '. Foi gerado um arquivo de log em ' + cDirLog + cArqLog)
	EndIf

	//Senão, define o retorno
	Self:SetStatus(200)
	jResponse['success']       := .T.
	jResponse['message']       := 'Solicitacao de Compras alterada com sucesso.'
	jResponse['note']          := 'Registro alterado com sucesso'
	jResponse['num']           := AllTrim(::id)
	jResponse['filial']        := AllTrim(cFilSC)
	jResponse['itensAlterados']:= Len(aItensSC)

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

/*/{Protheus.doc} C5Fault
Monta e devolve a resposta de erro no padrao do projeto
@author Maria Luiza
@since 20/07/2026
@version 1.0
@type function
@param oSelf, Objeto, Instancia do WSRESTFUL
@param nStatus, Numerico, Status HTTP de retorno
@param cCodigo, Caractere, Identificador do erro
@param cErro, Caractere, Descricao do erro
@param cSolucao, Caractere, Orientacao para solucao
@return Logico, Sempre .F.
/*/
Static Function C5Fault(oSelf, nStatus, cCodigo, cErro, cSolucao)
	Local jResp := JsonObject():New()

	oSelf:SetStatus(nStatus)

	jResp['success']  := .F.
	jResp['message']  := cSolucao
	jResp['errorId']  := cCodigo
	jResp['error']    := cErro
	jResp['solution'] := cSolucao

	oSelf:SetResponse(EncodeUTF8(jResp:ToJson()))
Return .F.

/*/{Protheus.doc} C5Tem
Indica se a chave existe no objeto JSON recebido
@author Maria Luiza
@since 20/07/2026
@version 1.0
@type function
@param jObj, Objeto, Objeto JSON de entrada
@param cCampo, Caractere, Nome do campo
@return Logico, .T. se o campo foi enviado
/*/
Static Function C5Tem(jObj, cCampo)
Return (ValType(jObj:GetJsonObject(cCampo)) <> 'U')

/*/{Protheus.doc} C5GetC
Le um campo do JSON devolvendo sempre caractere
@author Maria Luiza
@since 20/07/2026
@version 1.0
@type function
@param jObj, Objeto, Objeto JSON de entrada
@param cCampo, Caractere, Nome do campo
@return Caractere, Conteudo do campo
/*/
Static Function C5GetC(jObj, cCampo)
Return C5ToC(jObj:GetJsonObject(cCampo))

/*/{Protheus.doc} C5GetN
Le um campo do JSON devolvendo sempre numerico
@author Maria Luiza
@since 20/07/2026
@version 1.0
@type function

    Trata os dois formatos que o consumidor pode enviar: numero puro
    (10.50) ou string ("10.50" / "10,50").

@param jObj, Objeto, Objeto JSON de entrada
@param cCampo, Caractere, Nome do campo
@return Numerico, Conteudo do campo
/*/
Static Function C5GetN(jObj, cCampo)
Return C5ToN(jObj:GetJsonObject(cCampo))

/*/{Protheus.doc} C5RatAtu
Le o rateio ja gravado na SCX para o item da SC e devolve no formato
esperado pela MATA110. Usado quando o JSON nao informa o "rateioCX",
para que a alteracao parcial nao apague o rateio existente.
@author Maria Luiza
@since 19/08/2026
@version 1.0
@type function
@param cFil, Caractere, Filial da Solicitacao de Compras
@param cNum, Caractere, Numero da Solicitacao de Compras
@param cItem, Caractere, Item da Solicitacao de Compras
@param aDest, Array, Array de destino, recebe as linhas do rateio
@return Logico, .T. quando encontrou pelo menos uma linha na SCX
/*/
Static Function C5RatAtu(cFil, cNum, cItem, aDest)
	Local cQry     := ''
	Local aLinha   := {}

	cQry := "SELECT CX_ITEM, CX_PERC, CX_CC " + CRLF
	cQry += "FROM " + RetSqlName("SCX") + " " + CRLF
	cQry += "WHERE D_E_L_E_T_ = ' ' " + CRLF
	cQry += "AND CX_FILIAL  = '" + cFil + "' " + CRLF
	cQry += "AND CX_SOLICIT = '" + cNum + "' " + CRLF
	cQry += "AND CX_ITEMSOL = '" + PadR(cItem, TamSX3("CX_ITEMSOL")[1]) + "' " + CRLF
	cQry += "ORDER BY CX_ITEM "

	TCQuery cQry New Alias "QRY_RATCX"

	QRY_RATCX->(DbGoTop())

	While ! QRY_RATCX->(Eof())

		aLinha := {}
		aAdd(aLinha, {"CX_ITEM", QRY_RATCX->CX_ITEM, Nil})
		aAdd(aLinha, {"CX_PERC", QRY_RATCX->CX_PERC, Nil})
		aAdd(aLinha, {"CX_CC",   QRY_RATCX->CX_CC,   Nil})

		aAdd(aDest, aLinha)

		QRY_RATCX->(DbSkip())
	EndDo

	QRY_RATCX->(DbCloseArea())

Return (Len(aDest) > 0)

/*/{Protheus.doc} C5Get
Le um campo opcional do JSON procurando nos objetos recebidos, na
ordem de precedencia, aceitando o alias curto ou o nome do campo
@author Maria Luiza
@since 08/09/2026
@version 1.0
@type function

    Devolve Nil (ValType 'U') quando a propriedade nao existe em
    nenhum dos objetos, permitindo ao chamador distinguir 'campo nao
    informado' de 'campo informado vazio' - o que garante que a
    ausencia no body nao sobreponha o conteudo gravado na SC1.
    Objeto ausente ou invalido apenas nao contribui com o valor, por
    isso a leitura nunca gera erro.

@param aObjs, Array, Objetos JSON na ordem de precedencia
@param cAlias, Caractere, Nome curto aceito no JSON
@param cCampo, Caractere, Nome do campo da SC1 aceito no JSON
@return Indefinido, Conteudo encontrado ou Nil quando nao informado
/*/
Static Function C5Get(aObjs, cAlias, cCampo)
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

/*/{Protheus.doc} C5ToC
Converte o conteudo lido do JSON para caractere
@author Maria Luiza
@since 08/09/2026
@version 1.0
@type function
@param xVal, Indefinido, Conteudo lido do JSON
@return Caractere, Conteudo convertido, vazio quando nao informado
/*/
Static Function C5ToC(xVal)
	Local cRet := ''

	If ValType(xVal) == 'C'
		cRet := AllTrim(xVal)
	ElseIf ValType(xVal) == 'N'
		cRet := AllTrim(Str(xVal))
	EndIf
Return cRet

/*/{Protheus.doc} C5ToN
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
Static Function C5ToN(xVal)
	Local nRet := 0

	If ValType(xVal) == 'N'
		nRet := xVal
	ElseIf ValType(xVal) == 'C'
		nRet := Val(StrTran(AllTrim(xVal), ',', '.'))
	EndIf
Return nRet
