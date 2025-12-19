//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSFIN001
Serviço rest para manipulação do título a pagar
@author Maria Luiza
@since 22/10/2025
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSFIN001 DESCRIPTION 'Serviço rest para manipulação do título a pagar'

	WSDATA prefixo  AS STRING
	WSDATA num      AS STRING
	WSDATA parcela  AS STRING
	WSDATA tipo     AS STRING
	WSDATA naturez  AS STRING
	WSDATA fornece  AS STRING
	WSDATA loja     AS STRING
	WSDATA lojafat  AS STRING
	WSDATA emissao  AS DATE
	WSDATA valor    AS NUMERIC
	WSDATA nomforn  AS STRING

	//Métodos
	WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'    WSSYNTAX '/WSFIN001/new'      PATH 'new'           PRODUCES APPLICATION_JSON

END WSRESTFUL

/*/{Protheus.doc} WSMETHOD POST NEW
Cria um novo registro na tabela
@author Maria Luiza
@since 22/10/2025

    Abaixo um exemplo do JSON que deverá vir no body
    * 1: Para campos do tipo Numérico, informe o valor sem usar as aspas
    * 2: Para campos do tipo Data, informe uma string no padrão 'YYYY-MM-DD'

    {
        "prefixo": "conteudo",
        "num": "conteudo",
        "parcela": "conteudo",
        "tipo": "conteudo",
        "naturez": "conteudo",
        "fornece": "conteudo",
        "loja": "conteudo",
		"lojafat": "conteudo",
        "emissao": "conteudo",
        "valor": "conteudo",
		"nomforn": "conteudo"
    }
/*/

WSMETHOD POST NEW WSRECEIVE WSSERVICE WSFIN001

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
	Local aFatPag :={}
	Local aTits :={}
	Local nTamTit := TamSx3("E2_NUM")[1]
	Local nTamParc := TamSx3("E2_PARCELA")[1]
	Local nTamForn := TamSx3("E2_FORNECE")[1]
	Local nTamLoja := TamSx3("E2_LOJA")[1]
	Local nTamTipo := TamSx3("E2_TIPO")[1]
	Local cPrefixo := ""
	Local cNum    := ""
	Local cParcela := ""
	Local cTipo    := ""
	Local cNaturez := ""
	Local cFornece := ""
	Local cLoja    := ""
	Local cLojaFat := ""
	Local dEmissao
	Local nValor   := 0
	Local cNomForn := ""
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
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW004'
		jResponse['error']    := 'Parse do JSON'
		jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

	Else

		//Adiciona os dados do ExecAuto
		cPrefixo := jJson:GetJsonObject('prefixo')
		cNum     := jJson:GetJsonObject('num')
		cParcela := jJson:GetJsonObject('parcela')
		cTipo    := jJson:GetJsonObject('tipo')
		cNaturez := jJson:GetJsonObject('naturez')
		cFornece := jJson:GetJsonObject('fornece')
		cLoja    := jJson:GetJsonObject('loja')
		cLojaFat := jJson:GetJsonObject('lojafat')
		dEmissao := StrTran(jJson:GetJsonObject('emissao'), '-', '')
		dEmissao := Stod(dEmissao)
		nValor   := jJson:GetJsonObject('valor')
		cNomForn := jJson:GetJsonObject('nomforn')

		DbSelectArea("SE2")
		SE2->(DbSetOrder(1))
		If SE2->(MsSeek(FwXFilial()+cPrefixo+cNum+cParcela))
			//[13] - ARRAY com os titulos da fatura - Geradores (esses títulos devem existir na base)
			//[13,1] Prefixo
			//[13,2] Numero
			//[13,3] Parcela
			//[13,4] Tipo
			//[13,5] Título localizado na geracao de fatura (lógico). Iniciar com falso.
			//[13,6] Fornecedor
			//[13,7] Loja
			//[13,8] Filial (utilizada em fatura de títulos de diferentes filiais)
			aTits := {{ cPrefixo, PADR(cNum,nTamTit), PADR(cParcela,nTamParc), PADR(cTipo,nTamTipo), .f., PADR(cFornece,nTamForn),PADR(cLoja,nTamLoja), FwXFilial()}}

			//Descricao do Array aFatPag
			//[01] - Prefixo
			//[02] - Tipo
			//[03] - Numero da Fatura (se o numero estiver em branco obtem pelo FINA290)
			//[04] - Natureza
			//[05] - Data de
			//[06] - Data Ate
			//[07] - Fornecedor
			//[08] - Loja
			//[09] - Fornecedor para geracao
			//[10] - Loja do fornecedor para geracao
			//[11] - Condicao de pagto
			//[12] - Moeda
			//[13] - ARRAY com os titulos da fatura - Geradores
			//[14] - Valor de decrescimo
			//[15] - Valor de acrescimo
			aFatPag := { "FAT", PADR("FT",nTamTipo), PADR(cNum,nTamTit), cNaturez, dEmissao, dEmissao, PADR(cFornece,nTamForn), PADR(cLoja,nTamLoja), cFornece, cLojaFat, "001", 01, aTits ,0 ,0 }

			MsExecAuto( { |x,y| FINA290(x,y)}, 3, aFatPag )

			//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
			If lMsErroAuto
				//Monta o texto do Error Log que será salvo
				cErrorLog   := ''
				aLogAuto    := GetAutoGrLog()
				For nLinha := 1 To Len(aLogAuto)
					cErrorLog += aLogAuto[nLinha] + CRLF
				Next nLinha

				//Grava o arquivo de log
				cArqLog := 'WSFIN001_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
				MemoWrite(cDirLog + cArqLog, cErrorLog)

				//Define o retorno para o WebService
				//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
				Self:setStatus(500)
				jResponse['errorId']  := 'NEW005'
				jResponse['error']    := 'Erro na inclusão do registro'
				jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
				lRet := .F.

				//Senão, define o retorno
			Else
				If SE2->(MsSeek(FwXFilial()+"FAT"+cNum))
					Reclock("SE2",.F.)
					SE2->E2_NOMFOR := cNomForn
					SE2->(MsUnLock())
				EndIf
				jResponse['note']  := 'Registro incluido com sucesso'
			EndIf
		Else
			//SetRestFault(404, 'Registro não encontrado') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
			Self:setStatus(404)
			jResponse['errorId']  := 'NEW006'
			jResponse['error']    := 'Registro não encontrado'
			jResponse['solution'] := 'Não foi possível localizar o título informado para geração da fatura'
			lRet := .F.
		EndIf
		SE2->(DbCloseArea())
	EndIf

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet
