//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSRESTDOC
Serviço rest para manipulação do  Documento de Saída
@author Maria Luiza
@since 25/08/2025
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSRESTDOC DESCRIPTION 'Serviço rest para manipulação do  Documento de Saída'


    /*Abaixo um exemplo do JSON que deverá vir no body
    * 1: Para campos do tipo Numérico, informe o valor sem usar as aspas
    * 2: Para campos do tipo Data, informe uma string no padrão 'YYYY-MM-DD'

    {
        "pedido": "conteudo",
        "item": "conteudo",
        "sequen": "conteudo",
        "qtdlib": "conteudo",
        "prcven": "conteudo",
        "produto": "conteudo",
        "recno": "conteudo",
        "recno": "conteudo",
        "recno": "conteudo",
        "recno": "conteudo",
        "recno": "conteudo",
        "recno": "conteudo",
        "recno": "conteudo"
    }*/

    WSDATA pedido   AS STRING
    WSDATA item     AS STRING
    WSDATA sequen   AS STRING
    WSDATA qtdlib   AS NUMERIC
    WSDATA prcven   AS NUMERIC
    WSDATA produto  AS STRING
    WSDATA c9recno  AS NUMERIC
    WSDATA c5recno  AS NUMERIC
    WSDATA c6_recno AS NUMERIC
    WSDATA e4recno  AS NUMERIC
    WSDATA b1recno  AS NUMERIC
    WSDATA b2recno  AS NUMERIC
    WSDATA f4recno  AS NUMERIC
   

    //Métodos
    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSRESTDOC/new'                               PATH 'new'           PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD POST NEW
Cria um novo registro na tabela
@author Maria Luiza
@since 25/08/2025
@version 1.0
@type method
/*/


WSMETHOD POST NEW WSRECEIVE WSSERVICE WSRESTDOC

    Local lRet              := .T.
    Local jJson             := Nil
    Local cJson             := Self:GetContent()
    Local cError            := ''
    Local jResponse         := JsonObject():New()
    Local aPvlDocS  := {}
    Local cDocument := ""
    Local cSerie    := "1"
    Local lAbortar
    Local aItensJson := {}
    Local nI              := 0
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

    Else

    // Obtém o array de itens
    aItensJson := jJson:GetJsonObject('retorno_pv')
    If ValType(aItensJson) <> 'A' .Or. Len(aItensJson) == 0
        ConOut("Erro: Campo 'itens' não encontrado, inválido ou vazio no JSON")
        Self:SetStatus(400)
        jResponse['errorId']  := 'NEW007'
        jResponse['error']    := 'Estrutura do JSON'
        jResponse['solution'] := 'O JSON deve conter o array "retorno_pv" com pelo menos um pedido'
        lRet := .F.
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return lRet
        
    EndIf

     For nI := 1 To Len(aItensJson)
             SC9->(DbSetOrder(1))
         If SC9->(MsSeek(xFilial("SC9") + aItensJson[nI]:GetJsonObject('pedido') + aItensJson[nI]:GetJsonObject('item')))
                //Se tiver liberado o BLEST e BLCRED
                If Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
               
                    aAdd(aPvlDocS, { ;
                        aItensJson[nI]:GetJsonObject('pedido'), ;
                        aItensJson[nI]:GetJsonObject('item'), ;
                        aItensJson[nI]:GetJsonObject('sequen'), ;
                        aItensJson[nI]:GetJsonObject('qtdlib'), ;
                        aItensJson[nI]:GetJsonObject('prcven'), ;
                        aItensJson[nI]:GetJsonObject('produto'), ;
                        .F., ;
                        aItensJson[nI]:GetJsonObject('c9recno'), ;
                        aItensJson[nI]:GetJsonObject('c5recno'), ;
                        aItensJson[nI]:GetJsonObject('c6recno'), ;
                        aItensJson[nI]:GetJsonObject('e4recno'), ;
                        aItensJson[nI]:GetJsonObject('b1recno'), ;
                        aItensJson[nI]:GetJsonObject('b2recno'), ;
                        aItensJson[nI]:GetJsonObject('f4recno') ;
                    })
                Else 
                    ConOut("Erro: Produto " + aItensJson[nI]:GetJsonObject('produto') + " está bloqueado para faturamento ou crédito.")
                    Self:SetStatus(400)
                    jResponse['errorId']  := 'NEW006'
                    jResponse['error']    := 'Pedido ' +aItensJson[nI]:GetJsonObject('pedido')+ 'bloqueado'
                    jResponse['solution'] := 'O Produto ' + aItensJson[nI]:GetJsonObject('produto') + 'possui bloqueio de faturamento ou crédito.'
                    lRet := .F.
                    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
                    Return lRet
                EndIf
            EndIf
         Next nI
		
        If Len(aPvlDocS) > 0
                cDocument := MaPvlNfs(;
                    aPvlDocS,;  // 01 - aPvlNfs      - Array com os itens a serem gerados
                    cSerie,;    // 02 - cSerieNFS   - Serie da Nota Fiscal
                    .F.,;       // 03 - lMostraCtb   - Mostra Lançamento Contábil
                    .F.,;       // 04 - lAglutCtb    - Aglutina Lançamento Contábil
                    .F.,;       // 05 - lCtbOnLine   - Contabiliza On-Line
                    .T.,;       // 06 - lCtbCusto    - Contabiliza Custo On-Line
                    .F.,;       // 07 - lReajuste    - Reajuste de preço na Nota Fiscal
                    0,;         // 08 - nCalAcrs     - Tipo de Acréscimo Financeiro
                    0,;         // 09 - nArredPrcLis - Tipo de Arredondamento
                    .T.,;       // 10 - lAtuSA7      - Atualiza Amarração Cliente x Produto
                    .F.,;       // 11 - lECF         - Cupom Fiscal
                    "",;        // 12 - cEmbExp      - Número do Embarque de Exportação
                    {||},;      // 13 - bAtuFin      - Bloco de Código para complemento de atualização dos títulos financeiros
                    {||},;      // 14 - bAtuPGerNF   - Bloco de Código para complemento de atualização dos dados após a geração da Nota Fiscal
                    {||},;      // 15 - bAtuPvl      - Bloco de Código de atualização do Pedido de Venda antes da geração da Nota Fiscal
                    {|| .T. },; // 16 - bFatSE1      - Bloco de Código para indicar se o valor do Titulo a Receber será gravado no campo F2_VALFAT quando o parâmetro MV_TMSMFAT estiver com o valor igual a "2".
                    Date(),;    // 17 - dDataMoe     - Data da cotação para conversão dos valores da Moeda do Pedido de Venda para a Moeda Forte
                    .F.;        // 18 - lJunta       - Aglutina Pedido Iguais
                )
                 
                If Empty(cDocument)
                    lAbortar := .T.
                Else
                    jResponse['Documento:']  :=  cDocument 
                    jResponse['Serie:']     := cSerie
                EndIf
            Else
                lAbortar := .T.
            EndIf
        EndIf
 
        If lAbortar
             Self:setStatus(500) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['solution'] := 'Nao foi possivel incluir o registro'
			lRet := .F.

        EndIf

    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))

Return lRet
