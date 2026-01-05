//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSRESTDOCENT
Serviço rest para manipulação do  Documento de Entrada
@author Maria Luiza
@since 26/08/2025
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSRESTDOCENT DESCRIPTION 'Serviço rest para manipulação do  Documento de Entrada'

    WSDATA tipo     AS STRING   
    WSDATA formul   AS STRING
    WSDATA doc      AS STRING       
    WSDATA serie    AS STRING
    WSDATA loja     AS STRING
    WSDATA especie  AS STRING
    WSDATA cond     AS STRING
    WSDATA despesa  AS NUMERIC
    WSDATA descont  AS NUMERIC
    WSDATA seguro   AS NUMERIC
    WSDATA frete    AS NUMERIC
    WSDATA moeda    AS NUMERIC
    WSDATA txmoeda  AS NUMERIC
    WSDATA status   AS STRING
    WSDATA chave    AS STRING
    WSDATA cliente  AS STRING
    WSDATA item     AS STRING
    WSDATA cod      AS STRING
    WSDATA um       AS STRING
    WSDATA armazem  AS STRING
    WSDATA quant    AS NUMERIC
    WSDATA vunit    AS NUMERIC
    WSDATA total    AS NUMERIC
    WSDATA tes      AS STRING
    WSDATA rateio   AS STRING

    //Métodos
    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSRESTDOCENT/new'                               PATH 'new'           PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD POST NEW
Cria um novo registro na tabela
@author Maria Luiza
@since 26/08/2025
@version 1.0
@type method

    Abaixo um exemplo do JSON que deverá vir no body
    * 1: Para campos do tipo Numérico, informe o valor sem usar as aspas
    * 2: Para campos do tipo Data, informe uma string no padrão 'YYYY-MM-DD'

 {
    "cabecalho": {
        "filial": "01",
        "tipo": "N",
        "formul": "1",
        "doc": "123456789",
        "serie": "001",
        "emissao": "2025-08-27",
        "dtdigit": "2025-08-27",
        "fornece": "000001",
        "loja": "01",
        "especie": "NF",
        "cond": "001",
        "despesa": "0.00",
        "descont": "0.00",
        "seguro": "0.00",
        "frete": "0.00",
        "moeda": "1",
        "txmoeda": "1.00",
        "status": "A",
        "chave": "35150812345678901234560010000012345678901234"
    },
    "itens": [
        {
            "item": "0001",
            "cod": "PROD001",
            "um": "UN",
            "armazem": "01",
            "quant": 10.00,
            "vunit": 50.00,
            "total": 500.00,
            "tes": "501",
            "rateio": "N"
        },
        {
            "item": "0002",
            "cod": "PROD002",
            "um": "UN",
            "armazem": "01",
            "quant": 5.00,
            "vunit": 30.00",
            "total": 150.00,
            "tes": "502",
            "rateio": "2"
        }
    ]
}
/*/

WSMETHOD POST NEW WSRECEIVE WSSERVICE WSRESTDOCENT

    Local lRet              := .T.
    Local aCabec            := {}
    Local aItens            := {}
    Local aLinha            := {}
    Local jJson             := Nil
    Local cJson             := Self:GetContent()
    Local cError            := ''
    Local nLinha            := 0
    Local cErrorLog         := ''
    Local aLogAuto          := {}
    Local jResponse         := JsonObject():New()
    Local nI                := 0
    Local oCabecalho
    Local aItensJson        := {}
    Local cFilDest          := ""
    Private lMsErroAuto     := .F.
    Private lMsHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.
 

    //Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
    Self:SetContentType('application/json')
    jJson  := JsonObject():New()
    cError := jJson:FromJson(cJson)
 
    //Se tiver algum erro no Parse, encerra a execução
    IF ! Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'
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

                If oCabecalho:GetJsonObject('cliente') == "27379581"
                  cFilDest := "0501" // Grid
               Else
                  cFilDest := "1001" // Agrogera
               EndIf

		//Adiciona os dados do ExecAuto
		aAdd(aCabec, {'F1_FILIAL',   cFilDest,   Nil})
		aAdd(aCabec, {'F1_TIPO',   oCabecalho:GetJsonObject('tipo'),   Nil})
		aAdd(aCabec, {'F1_FORMUL',   oCabecalho:GetJsonObject('formul'),   Nil})
		aAdd(aCabec, {'F1_DOC',   oCabecalho:GetJsonObject('doc'),   Nil})
		aAdd(aCabec, {'F1_SERIE',   oCabecalho:GetJsonObject('serie'),   Nil})
		aAdd(aCabec, {'F1_EMISSAO',   dDataBase,   Nil})
		aAdd(aCabec, {'F1_DTDIGIT',   dDataBase,   Nil})
		aAdd(aCabec, {'F1_FORNECE',   "04675878 ",   Nil})
		aAdd(aCabec, {'F1_LOJA',   oCabecalho:GetJsonObject('loja'),   Nil})
		aAdd(aCabec, {'F1_ESPECIE',   oCabecalho:GetJsonObject('especie'),   Nil})
		aAdd(aCabec, {'F1_COND',   oCabecalho:GetJsonObject('cond'),   Nil})
		aAdd(aCabec, {'F1_DESPESA',   oCabecalho:GetJsonObject('despesa'),   Nil})
		aAdd(aCabec, {'F1_DESCONT',   oCabecalho:GetJsonObject('descont'),   Nil})
		aAdd(aCabec, {'F1_SEGURO',   oCabecalho:GetJsonObject('seguro'),   Nil})
		aAdd(aCabec, {'F1_FRETE',   oCabecalho:GetJsonObject('frete'),   Nil})
		aAdd(aCabec, {'F1_MOEDA',   oCabecalho:GetJsonObject('moeda'),   Nil})
		aAdd(aCabec, {'F1_TXMOEDA',   oCabecalho:GetJsonObject('txmoeda'),   Nil})
		aAdd(aCabec, {'F1_STATUS',   oCabecalho:GetJsonObject('status'),   Nil})
        aAdd(aCabec, {'F1_CHVNFE',   oCabecalho:GetJsonObject('chave'),   Nil})


        For nI := 1 To Len(aItensJson)
            aLinha := {}
            aAdd(aLinha, {'D1_ITEM',   aItensJson[nI]:GetJsonObject('item'),   Nil})
            aAdd(aLinha, {'D1_COD',     aItensJson[nI]:GetJsonObject('cod'),     Nil})
            aAdd(aLinha, {'D1_UM',      aItensJson[nI]:GetJsonObject('um'),      Nil})
            aAdd(aLinha, {'D1_LOCAL',   aItensJson[nI]:GetJsonObject('armazem'),   Nil})
            aAdd(aLinha, {'D1_QUANT',   aItensJson[nI]:GetJsonObject('quant'),   Nil})
            aAdd(aLinha, {'D1_VUNIT',   aItensJson[nI]:GetJsonObject('vunit'),   Nil})
            aAdd(aLinha, {'D1_TOTAL',   aItensJson[nI]:GetJsonObject('total'),   Nil})
            aAdd(aLinha, {'D1_TES',     aItensJson[nI]:GetJsonObject('tes'),     Nil})
            aAdd(aLinha, {'D1_RATEIO',  aItensJson[nI]:GetJsonObject('rateio'),  Nil})
            aAdd(aItens, aLinha)
        Next nI

		//Chama a inclusão automática
        MsExecAuto({|x, y, z| MATA103(x, y, z)}, aCabec, aItens, 3)

        // Sempre captura o log, mesmo sem erro
        cErrorLog := ''
        aLogAuto := GetAutoGrLog()
        For nLinha := 1 To Len(aLogAuto)
            cErrorLog += aLogAuto[nLinha] + CRLF
        Next nLinha

        // Grava o log para análise
        MemoWrite('WSRESTDOCENT_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log', cErrorLog)
        ConOut('Log gerado: ' + cErrorLog)

		//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
		If lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			ConOut('WSRESTDOCENT_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log')
			
			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['solution'] := 'Nao foi possivel incluir o registro: ' + cErrorLog
			lRet := .F.

		//Senão, define o retorno
		Else
            jResponse['Sucesso']  :=  oCabecalho:GetJsonObject('doc')
        EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet
