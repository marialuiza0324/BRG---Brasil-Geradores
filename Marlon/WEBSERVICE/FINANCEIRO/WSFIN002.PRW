//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSFIN002
Serviço REST para baixa de título do contas a pagar
@author Maria Luiza
@since 23/10/2025
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSFIN002 DESCRIPTION 'Serviço REST para baixa de título do contas a pagar'

	WSDATA prefixo  AS STRING
	WSDATA num      AS STRING
	WSDATA parcela  AS STRING
	WSDATA tipo     AS STRING
	WSDATA fornece  AS STRING
	WSDATA loja     AS STRING
	WSDATA motivo    AS STRING
	WSDATA banco AS STRING
	WSDATA agencia AS STRING
	WSDATA conta AS STRING
	WSDATA historico AS STRING
	WSDATA valor     AS NUMERIC

	//Métodos
	WSMETHOD PUT UPDATE DESCRIPTION 'Baixa de título existente' WSSYNTAX '/WSFIN002/update' PATH 'update' PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD PUT UPDATE
Realiza a baixa de um título existente na tabela SE2
@author Maria Luiza
@since 23/10/2025
@version 1.0
@type method
@param JSON com os dados do título a ser baixado
    Exemplo do JSON que deverá vir no body:
{
    "prefixo": "FIN",
    "num": "000123458",
    "tipo": "NFS",
    "fornece": "21118267",
    "loja": "0001",
    "motivo": "NOR",
    "banco": "001",
    "agencia": "00001",
    "conta": "0000000001",
    "historico": "BAIXA TESTE",
    "valor": 1000.00
}
/*/

WSMETHOD PUT UPDATE WSSERVICE WSFIN002

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
	Local cAliasWS          := 'SE2'
	Local cPrefixo          := ''
	Local cNumTit           := ''
	Local cTipoTit          := ''
	Local cFornece          := ''
	Local cLoja             := ''
	Local nValor            := 0.0
	Local cMotivo           := ''
	Local dDataBase         := Date()
	Local cBanco            := ''
	Local cAgencia          := ''
	Local cConta            := ''
	Local cHist             := ''
	Local cParcela          := ''
	Local dBaixa            := Date()
    Local aDados            := {}
	Private lMsErroAuto     := .F.
	Private lMsHelpAuto     := .T.
	Private lAutoErrNoFile  := .T.

	//Se não existir a pasta de logs, cria
	IF ! ExistDir(cDirLog)
		MakeDir(cDirLog)
	EndIF

	//Definindo o conteúdo como JSON
	Self:SetContentType('application/json')
	jJson := JsonObject():New()
	cError := jJson:FromJson(cJson)

	//Valida o parse do JSON
	If !Empty(cError)
		Self:SetStatus(500)
		jResponse['errorId']  := 'UPD008'
		jResponse['error']    := 'Erro ao fazer o parse do JSON'
		jResponse['solution'] := 'Verifique a estrutura do JSON enviado'
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	//Obtém os campos do JSON
	cPrefixo := Padr(jJson:GetJsonObject('prefixo'),tamsx3('E2_PREFIXO')[1])
	cNumTit  := jJson:GetJsonObject('num')
	cTipoTit := jJson:GetJsonObject('tipo')
	cFornece := jJson:GetJsonObject('fornece')
	cLoja    := jJson:GetJsonObject('loja')
	nValor   := jJson:GetJsonObject('valor')
	cBanco   := jJson:GetJsonObject('banco')
	cAgencia := jJson:GetJsonObject('agencia')
	cConta   := jJson:GetJsonObject('conta')
	cHist    := jJson:GetJsonObject('historico')
	cMotivo  := jJson:GetJsonObject('motivo')
	cParcela := jJson:GetJsonObject('parcela')


	//Valida se os campos obrigatórios foram informados
	If Empty(cPrefixo) .Or. Empty(cNumTit) .Or. Empty(cTipoTit) .Or. Empty(cFornece) .Or. Empty(cLoja) 
		Self:SetStatus(500)
		jResponse['errorId']  := 'UPD006'
		jResponse['error']    := 'Campos obrigatórios não informados'
		jResponse['solution'] := 'Informe os campos prefixo, num, tipo, fornece e loja'
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	//Valida a existência do título na SE2
	DbSelectArea(cAliasWS)
	SE2->(DbSetOrder(1)) //E2_FILIAL + E2_PREFIXO + E2_NUM
	If !SE2->(MsSeek(FWxFilial(cAliasWS) + cPrefixo + cNumTit + cParcela))
		Self:SetStatus(500)
		jResponse['errorId']  := 'UPD007'
		jResponse['error']    := 'Título não encontrado'
		jResponse['solution'] := 'O título ' + cNumTit + ' não existe na base de dados'
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

	//Verifica se o título já está baixado
	dBaixa :=  Posicione("SE2",1, FWxFilial(cAliasWS) + cPrefixo + cNumTit + cParcela,"E2_BAIXA")
	If !Empty(dBaixa)
		Self:SetStatus(500)
		jResponse['errorId']  := 'UPD013'
		jResponse['error']    := 'Título já baixado'
		jResponse['solution'] := 'O título ' + cNumTit + ' já possui uma data de baixa (' + DToC(dBaixa) + ')'
		Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
		Return .F.
	EndIf

			//Monta o array de dados para a baixa via FINA070
			aAdd(aDados, {'E2_FILIAL',    FWxFilial('SE2'),                      Nil})
			aAdd(aDados, {'E2_PREFIXO',   cPrefixo,                              Nil})
			aAdd(aDados, {'E2_NUM',       cNumTit,                               Nil})
			aAdd(aDados, {'E2_PARCELA',   cParcela,                              Nil})
			aAdd(aDados, {"AUTMOTBX",     cMotivo,                                 Nil})
			aAdd(aDados, {'E2_FORBCO',     cBanco,                                Nil})
			aAdd(aDados, {'E2_FORAGE',   cAgencia,                              Nil})
			aAdd(aDados, {'E2_FORCTA',     cConta,                         Nil})
			aAdd(aDados, {'AUTDTBAIXA',   dDataBase,                            Nil})
			aAdd(aDados, {'AUTDTDEB',     dDataBase,                            Nil})
			aAdd(aDados, {'E2_HIST',      cHist,                        Nil})
			aAdd(aDados, {"E2_VALOR"  ,   nValor         ,                     Nil})


			//Chama a rotina de baixa automática
			MsExecAuto({|x, y| FINA080(x, y)}, aDados, 3) //Operação 3 = Baixa


	If lMsErroAuto
		cErrorLog := ''
		aLogAuto := GetAutoGrLog()
		For nLinha := 1 To Len(aLogAuto)
			cErrorLog += aLogAuto[nLinha] + CRLF
		Next nLinha

		//Grava o arquivo de log
		cArqLog := 'WSFIN002_Baixa_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
		MemoWrite(cDirLog + cArqLog, cErrorLog)

		//Define o retorno para o WebService
		Self:SetStatus(500)
		jResponse['errorId']  := 'UPD009'
		jResponse['error']    := 'Erro na baixa do título'
		jResponse['solution'] := 'Não foi possível realizar a baixa do título, foi gerado um arquivo de log em ' + cDirLog + cArqLog
		lRet := .F.
	Else
		jResponse['note'] := 'Título baixado com sucesso na data ' + DToC(dDataBase)
	EndIf

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))

Return lRet
