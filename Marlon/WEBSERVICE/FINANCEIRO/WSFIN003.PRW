//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSFIN003
Serviço rest para manipulação do cadastro de cliente
@author Maria Luiza
@since 29/10/2025
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSFIN003 DESCRIPTION 'Serviço rest para manipulação do cadastro de cliente'

	WSDATA id     AS STRING
	WSDATA loja   AS STRING
	WSDATA msblql AS STRING
	WSDATA risco  AS STRING
	WSDATA lc     AS NUMERIC
	WSDATA filial AS STRING

	//Métodos
	WSMETHOD PUT    UPDATE DESCRIPTION 'Atualização de registro'       WSSYNTAX '/WSFIN003/update'                            PATH 'update'        PRODUCES APPLICATION_JSON

END WSRESTFUL

/*/{Protheus.doc} WSMETHOD PUT UPDATE
Atualiza o registro na tabela
@author Maria Luiza
@since 29/10/2025
@version 1.0
@type method
@param id, Caractere, String que será pesquisada através do MsSee

    Abaixo um exemplo do JSON que deverá vir no body
    * 1: Para campos do tipo Numérico, informe o valor sem usar as aspas
    * 2: Para campos do tipo Data, informe uma string no padrão 'YYYY-MM-DD'

    {
        "msblql": "conteudo" - Para bloqueio do cliente
        "loja": "conteudo",
        "filial": "conteudo"   
    }
        
        
    {
        "risco": "conteudo", - Para alteração do risco e limite de crédito do cliente
        "lc": "conteudo",
        "loja": "conteudo",
        "filial": "conteudo"   
    }
/*/

WSMETHOD PUT UPDATE WSRECEIVE id WSSERVICE WSFIN003

	Local lRet              := .T.
	Local jJson             := Nil
	Local cJson             := Self:GetContent()
	Local jResponse         := JsonObject():New()
	Local cMsblql           := ''
	Local cRisco            := ''
	Local nLc               := 0
	Local cLoja             := ''
	Local cFilcliente       := ''
	LOCAL cQry              := ''
	Local nRecno            := 0


	//Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
	Self:SetContentType('application/json')
	jJson  := JsonObject():New()
	cError := jJson:FromJson(cJson)

	//Obtém os campos do JSON
	cMsblql := jJson:GetJsonObject('msblql')
	cRisco  := jJson:GetJsonObject('risco')
	nLc     := jJson:GetJsonObject('lc')
	cLoja   := jJson:GetJsonObject('loja')
	cFilcliente := jJson:GetJsonObject('filial')

	//Se o id estiver vazio
	If Empty(::id)
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'UPD006'
		jResponse['error']    := 'ID vazio'
		jResponse['solution'] := 'Informe o ID'
	Else
		If Select("TMP1") > 0
			TMP1->(DbCloseArea())
		EndIf

		cQry := "SELECT R_E_C_N_O_ AS RECNO FROM " + RetSqlName("SA1") + " "
		cQry += "WHERE D_E_L_E_T_ = '' "
		cQry += "AND A1_FILIAL = '" + cValToChar(cFilcliente) + "' "
		cQry += "AND A1_COD = '" + AllTrim(cValToChar(::id)) + "' "
		cQry += "AND A1_LOJA = '" + cValToChar(cLoja) + "' "

		DbUseArea(.T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TMP1", .T., .T.)
		DbSelectArea("TMP1")

		nRecno := TMP1->RECNO

		Count to nTotal

		//Se não encontrar o registro
		If nTotal == 0

			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'UPD007'
			jResponse['error']    := 'ID não encontrado'
			jResponse['solution'] := 'Código ID não encontrado na tabela '
		Else

			//Se tiver algum erro no Parse, encerra a execução
			If ! Empty(cError)
				//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
				Self:setStatus(500)
				jResponse['errorId']  := 'UPD008'
				jResponse['error']    := 'Parse do JSON'
				jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

			Else
				DbSelectArea("SA1")
				SA1->(DbGoTo(nRecno))
				If !Empty(cMsblql)
					RecLock("SA1",.F.)
					SA1->A1_MSBLQL := cMsblql
					SA1->(MsUnLock())
				Else
					RecLock("SA1",.F.)
					SA1->A1_RISCO := cRisco
					SA1->A1_LC    := nLc
					SA1->(MsUnLock())
				EndIf

				jResponse['note']     := 'Registro alterado com sucesso'
			EndIf

		EndIf
	EndIf
	TMP1->(DbCloseArea())
	SA1->(DbCloseArea())

//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet
