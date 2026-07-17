//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSCOM004
Serviço REST para consulta de Solicitantes
@author Maria Luiza
@since 17/07/2026
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSCOM004 DESCRIPTION 'Serviço REST para consulta de Solicitantes'
	//Atributos
	WSDATA updated_at AS STRING
	WSDATA limit      AS INTEGER
	WSDATA page       AS INTEGER

	//Métodos
	WSMETHOD GET    ALL    DESCRIPTION 'Retorna todos os registros'    WSSYNTAX '/WSCOM004/get_all?{updated_at, limit, page}' PATH 'get_all'       PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD GET ALL
Busca todos os registros através de paginação
@author Maria Luiza
@since 17/07/2026
@version 1.0
@type method
@param updated_at, Caractere, Data de alteração no formato string 'YYYY-MM-DD' (somente se tiver o campo USERLGA / USERGA na tabela)
@param limit, Numérico, Limite de registros que irá vir (por exemplo trazer apenas 100 registros)
@param page, Numérico, Número da página que irá buscar (se existir 1000 registros dividido por 100 terá 10 páginas de pesquisa)
@obs Codigo gerado automaticamente pelo Autumn Code Maker

    Poderia ser usado o FWAdapterBaseV2(), mas em algumas versões antigas não existe essa funcionalidade
    então a paginação foi feita manualmente
/*/

WSMETHOD GET ALL WSRECEIVE updated_at, limit, page WSSERVICE WSCOM004
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	Local cQueryTab  := ''
	Local nTamanho   := 10
	Local nTotal     := 0
	Local nPags      := 0
	Local nPagina    := 0
	Local nAtual     := 0
	Local oRegistro
	Local jJsonMeta


	cQueryTab := " SELECT " + CRLF
	cQueryTab += " SAI.AI_FILIAL AS Filial, " + CRLF
	cQueryTab += " Concat(SAI.AI_USER, '-' , SYS.USR_CODIGO) AS Usuario, " + CRLF
	cQueryTab += " SAI.AI_ITEM AS Item, " + CRLF
	cQueryTab += " SAI.AI_GRUPO as Grupo " + CRLF
	cQueryTab += " FROM SAI010 AS SAI " + CRLF
	cQueryTab += " INNER JOIN SYS_USR AS SYS " + CRLF
	cQueryTab += " ON SYS.USR_ID = SAI.AI_USER " + CRLF
	cQueryTab += " WHERE SAI.D_E_L_E_T_ = '' " + CRLF
	cQueryTab += " AND SAI.AI_FILIAL IN ('0101', '0501') " + CRLF
	cQueryTab += " AND SYS.USR_MSBLQL = '2' " + CRLF
	cQueryTab += " ORDER BY " + CRLF
	cQueryTab += " SAI.AI_FILIAL,  " + CRLF
	cQueryTab += " SAI.AI_USER;  " + CRLF

	TCQuery cQueryTab New Alias 'QRY_TAB'

	//Se não encontrar registros
	If QRY_TAB->(EoF())
		//SetRestFault(500, 'Falha ao consultar registros') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'ALL003'
		jResponse['error']    := 'Registro(s) não encontrado(s)'
		jResponse['solution'] := 'A consulta de registros não retornou nenhuma informação'
	Else
		jResponse['objects'] := {}

		//Conta o total de registros
		Count To nTotal
		QRY_TAB->(DbGoTop())

		 /*
            Regra:
            - Se vier limit informado, pagina normalmente
            - Se não vier limit, retorna todos os registros
        */
		If !Empty(::limit) .And. ::limit > 0
			nTamanho := ::limit
		Else
			nTamanho := nTotal
		EndIf

		If nTamanho <= 0
			nTamanho := 1
		EndIf

		//Calcula total de páginas
		nPags := Int(nTotal / nTamanho)
		nPags += Iif(nTotal % nTamanho <> 0, 1, 0)

		If nPags <= 0
			nPags := 1
		EndIf

        /*
            Só pagina se limit foi informado.
            Sem limit, retorna tudo.
        */
		If !Empty(::limit) .And. ::limit > 0
			If !Empty(::page)
				nPagina := ::page
			EndIf

			If nPagina <= 0 .Or. nPagina > nPags
				nPagina := 1
			EndIf

			If nPagina <> 1
				QRY_TAB->(DbSkip((nPagina - 1) * nTamanho))
			EndIf
		Else
			nPagina := 1
		EndIf

		//Adiciona os dados para a meta
		jJsonMeta := JsonObject():New()
		jJsonMeta['total']         := nTotal
		jJsonMeta['current_page']  := nPagina
		jJsonMeta['total_page']    := nPags
		jJsonMeta['total_items']   := nTamanho
		jResponse['meta'] := jJsonMeta

		//Percorre os registros
		While ! QRY_TAB->(EoF())
			nAtual++

			//Se ultrapassar o limite, encerra o laço
			If nAtual > nTamanho
				Exit
			EndIf

			oRegistro := JsonObject():New()
			oRegistro['Filial '] := AllTrim(QRY_TAB->Filial)
			oRegistro['Usuario'] := AllTrim(QRY_TAB->Usuario)
			oRegistro['Item '] := AllTrim(QRY_TAB->Item)
			oRegistro['Grupo'] := AllTrim(QRY_TAB->Grupo)
			aAdd(jResponse['objects'], oRegistro)

			QRY_TAB->(DbSkip())
		EndDo
	EndIf
	QRY_TAB->(DbCloseArea())

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))

Return lRet
