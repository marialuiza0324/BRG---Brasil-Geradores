//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSRESTPEDVEN
Serviço rest para manipulação do pedido de venda
@author Maria Luiza
@since 14/08/2025
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSRESTPEDVEN DESCRIPTION 'Serviço rest para inclusão do pedido de venda'
    /* Abaixo um exemplo do JSON que deverá vir no body
    {
        "cabecalho": {
            "tipo": "N",
            "cliente": "27379581",
            "lojacli": "0001",
            "lojaent": "0001",
            "condpag": "001",
            "xforpg": "TB",
            "naturez": "101010006"
        },
        "itens": [
            {
                "item": "01",
                "produto": "B0010046",
                "qtdven": 1,
                "prcven": 10148.6640,
                "prunit": 0,
                "valor": 10148.6640,
                "tes": "526",
                "local": "02",
                "rateio": "2",
                "numop": "010034"
            }
        ]
    }
    * 1: Para campos do tipo Numérico, informe o valor sem usar aspas
    * 2: Para campos do tipo Data, informe uma string no padrão 'YYYY-MM-DD'*/

    // Mantemos os WSDATA apenas para compatibilidade, mas não são estritamente necessários
    WSDATA tipo     AS STRING
    WSDATA cliente  AS STRING
    WSDATA lojacli  AS STRING
    WSDATA lojaent  AS STRING
    WSDATA condpag  AS STRING
    WSDATA xforpg   AS STRING
    WSDATA naturez  AS STRING
    WSDATA item     AS STRING
    WSDATA produto  AS STRING
    WSDATA qtdven   AS NUMERIC
    WSDATA prcven   AS NUMERIC
    WSDATA prunit   AS NUMERIC
    WSDATA valor    AS NUMERIC
    WSDATA tes      AS STRING
    WSDATA armazem  AS STRING
    WSDATA rateio   AS STRING
    WSDATA numop    AS STRING

    //Métodos
    WSMETHOD POST NEW DESCRIPTION 'Inclusão de registro' WSSYNTAX '/WSRESTPEDVEN/new' PATH 'new' PRODUCES APPLICATION_JSON

END WSRESTFUL

/*/{Protheus.doc} WSMETHOD POST NEW
Cria um novo registro nas tabelas SC5 e SC6
@author Maria Luiza
@since 14/08/2025
@version 1.0
@type method
/*/

WSMETHOD POST NEW WSRECEIVE WSSERVICE WSRESTPEDVEN

    Local lRet              := .T.
    Local aCabec            := {} // Array para o cabeçalho (SC5)
    Local aItens            := {} // Array para os itens (SC6)
    Local aLinha            := {} // Array para cada item
    Local oJson             
    Local cJson             := Self:GetContent()
    Local cError            := ''
    Local cErrorLog         := ''
    Local aLogAuto          := {}
    Local jResponse         := JsonObject():New()
    Local oCabecalho        := Nil
    Local aItensJson        := {}
    Local nI                := 0
    Static cPedVen          := ""
    Private lMsErroAuto     := .F.
    Private lMsHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.

    // Definindo o conteúdo como JSON
    Self:SetContentType('application/json')

    // Log do JSON recebido para depuração
    ConOut("JSON Recebido: " + cJson)

    // Faz o parse do JSON
    oJson  := JsonObject():New()
    cError := oJson:FromJson(cJson)

    // Verifica se houve erro no parse
    If !Empty(cError)
        ConOut("Erro no parse do JSON: " + cError)
        Self:SetStatus(500)
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON: ' + cError
        lRet := .F.
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return lRet
    EndIf

    // Obtém o objeto cabecalho
    oCabecalho := oJson:GetJsonObject('cabecalho')

    // Obtém o array de itens
    aItensJson := oJson:GetJsonObject('itens')
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

    // Número do pedido gerado
    cPedVen := GetSx8Num("SC5", "C5_NUM")

    // Cabeçalho (SC5)
    aAdd(aCabec, {'C5_NUM',     cPedVen,                      Nil})
    aAdd(aCabec, {'C5_TIPO',    oCabecalho:GetJsonObject('tipo'),     Nil})
    aAdd(aCabec, {'C5_CLIENTE', oCabecalho:GetJsonObject('cliente'), Nil})
    aAdd(aCabec, {'C5_LOJACLI', oCabecalho:GetJsonObject('lojacli'), Nil})
    aAdd(aCabec, {'C5_LOJAENT', oCabecalho:GetJsonObject('lojaent'), Nil})
    aAdd(aCabec, {'C5_CONDPAG', oCabecalho:GetJsonObject('condpag'), Nil})
    aAdd(aCabec, {'C5_XFORPG',  oCabecalho:GetJsonObject('xforpg'),  Nil})
    aAdd(aCabec, {'C5_NATUREZ', oCabecalho:GetJsonObject('naturez'), Nil})
    aAdd(aCabec, {'C5_EMISSAO', dDataBase,                    Nil})

   // Itens (SC6)
    For nI := 1 To Len(aItensJson)
        aLinha := {}
        aAdd(aLinha, {'C6_ITEM',    aItensJson[nI]:GetJsonObject('item'),     Nil})
        aAdd(aLinha, {'C6_PRODUTO', aItensJson[nI]:GetJsonObject('produto'), Nil})
        aAdd(aLinha, {'C6_QTDVEN',  aItensJson[nI]:GetJsonObject('qtdven'), Nil})
        aAdd(aLinha, {'C6_PRCVEN',  aItensJson[nI]:GetJsonObject('prcven'), Nil})
        aAdd(aLinha, {'C6_PRUNIT',  aItensJson[nI]:GetJsonObject('prunit'), Nil})
        aAdd(aLinha, {'C6_VALOR',   aItensJson[nI]:GetJsonObject('valor'),  Nil})
        aAdd(aLinha, {'C6_TES',     aItensJson[nI]:GetJsonObject('tes'),      Nil})
        aAdd(aLinha, {'C6_LOCAL',   aItensJson[nI]:GetJsonObject('local'),    Nil})
        aAdd(aLinha, {'C6_RATEIO',  aItensJson[nI]:GetJsonObject('rateio'),   Nil})
        aAdd(aLinha, {'C6_NUMOP',   aItensJson[nI]:GetJsonObject('numop'),    Nil})
        aAdd(aItens, aLinha)
    Next nI
    lMsErroAuto := .F.

    // Chama a inclusão automática
    MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, 3, .F.)

    // Se houve erro, gera um arquivo de log dentro do diretório da Protheus Data
    If lMsErroAuto
        // Monta o texto do Error Log que será salvo
        cErrorLog   := ''
        aLogAuto    := GetAutoGrLog()
        For nI := 1 To Len(aLogAuto)
            cErrorLog += aLogAuto[nI] + CRLF
        Next nI

        // Define o retorno para o WebService
        Self:SetStatus(500)
        jResponse['errorId']  := 'NEW005'
        jResponse['error']    := 'Erro na inclusão do registro'
        jResponse['solution'] := 'Não foi possível incluir o registro: ' + cErrorLog
        lRet := .F.
        ConOut("Erro na inclusão do registro: " + cErrorLog)
    Else
        // Confirma o número do pedido
        ConfirmSX8()
        jResponse['pedido'] := cPedVen + " incluído com sucesso"
    EndIf

    // Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
    
Return lRet
