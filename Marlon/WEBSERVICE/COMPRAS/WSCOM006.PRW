//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSCOM006
Serviço rest para consulta de Solicitação de compras
@author Maria Luiza
@since 22/07/2026
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSCOM006 DESCRIPTION 'Serviço rest para consulta de Solicitação de compras'
	//Atributos
	WSDATA updated_at AS STRING
	WSDATA limit      AS INTEGER
	WSDATA page       AS INTEGER
	WSDATA filial     AS STRING
	WSDATA num        AS STRING

	//Métodos
	WSMETHOD GET    ID   DESCRIPTION 'Retorna o registro específico'    WSSYNTAX '/WSCOM006/get_id?{filial,num}' PATH 'get_id'       PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD GET ID
Busca o registro específico através de filial e número
@author Maria Luiza
@since 22/07/2026
@version 1.0
@type method
@param updated_at, Caractere, Data de alteração no formato string 'YYYY-MM-DD' (somente se tiver o campo USERLGA / USERGA na tabela)
@param limit, Numérico, Limite de registros que irá vir (por exemplo trazer apenas 100 registros)
@param page, Numérico, Número da página que irá buscar (se existir 1000 registros dividido por 100 terá 10 páginas de pesquisa)
@param filial, String, Filial do registro que irá buscar
@param num, String, Número do registro que irá buscar

    Poderia ser usado o FWAdapterBaseV2(), mas em algumas versões antigas não existe essa funcionalidade
    então a paginação foi feita manualmente

    O retorno traz, por item da SC:
      xobmemo ..... C1_XOBMEMO   Observacao da SC (memo, lido pela workarea)
      vunit ....... C1_VUNIT     Preco estimado / preco unitario estimado
      xurgen ...... C1_XURGEN    Urgencia no formato codigo-descricao: 1-Sim / 2-Nao
      xurgencod ... C1_XURGEN    Urgencia com o conteudo exato da SC1: 1 / 2
    Acompanham os campos gravados pelo WSCOM001 (inclusao) e pelo
    WSCOM005 (alteracao). Quando nao preenchidos na SC1 voltam
    vazios ('', 0 e ''), sem omitir a propriedade do JSON.

    O C1_XURGEN sai em duas propriedades de proposito: o "xurgen"
    preserva o formato codigo-descricao ja consumido e o "xurgencod"
    expoe o valor cru gravado na tabela, sem tratamento.
/*/

WSMETHOD GET ID WSRECEIVE updated_at, limit, page, filial, num WSSERVICE WSCOM006
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	Local cQueryTab  := ''
	Local nTamanho   := 10
	Local nTotal     := 0
	Local nPags      := 0
	Local nPagina    := 0
	Local nAtual     := 0
	Local cObs       := ''
	Local nRecno	 := 0
	Local cRateio    := ''
	Local cUrgente   := ''
	Local aRateios   := {}
	Local oRegistro
	Local cQueryRateio := ""
	Local oRateio

	cQueryTab := " SELECT Concat(SC1.C1_FILIAL, '-' , SYS.M0_FILIAL) AS Filial, " + CRLF
	cQueryTab += " C1_NUM AS Num, " + CRLF
	cQueryTab += " C1_ITEM AS Item, " + CRLF
	cQueryTab += " Concat(trim(SC1.C1_PRODUTO), ' - ', trim(SC1.C1_DESCRI)) AS Produto, " + CRLF
	cQueryTab += " C1_LOCAL AS Armazem, " + CRLF
	cQueryTab += " C1_UM AS Unidade, " + CRLF
	cQueryTab += " C1_QUANT AS Quantidade, " + CRLF
	cQueryTab += " C1_VUNIT AS PrecoUnitario, " + CRLF
	cQueryTab += " C1_CC AS CentroCusto, " + CRLF
	cQueryTab += " SC1.R_E_C_N_O_ AS RECNO,  " + CRLF
	cQueryTab += " C1_EMISSAO AS DataEmissao , " + CRLF
	cQueryTab += " C1_DATPRF AS DataNecessidade, " + CRLF
	cQueryTab += " C1_SOLICIT AS Solicitante, " + CRLF
	cQueryTab += " C1_XURGEN AS Urgente, " + CRLF
	cQueryTab += " C1_RATEIO AS Rateio " + CRLF
	cQueryTab += " FROM SC1010 SC1 " + CRLF
	cQueryTab += " INNER JOIN SYS_COMPANY AS SYS " + CRLF
	cQueryTab += " ON SYS.M0_CODFIL = SC1.C1_FILIAL " + CRLF
	cQueryTab += " WHERE SC1.D_E_L_E_T_  = '' " + CRLF
	cQueryTab += " AND SYS.M0_CODIGO = '01' " + CRLF
	cQueryTab += " AND SC1.C1_FILIAL = '"+ ::filial + "' " + CRLF
	cQueryTab += " AND SC1.C1_NUM = '"+ ::num + "' " + CRLF
	cQueryTab += " ORDER BY SC1.C1_FILIAL,SC1.C1_NUM, SC1.C1_ITEM " + CRLF

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


			nRecno := QRY_TAB->RECNO
			cRateio := QRY_TAB->Rateio
			cUrgente := QRY_TAB->Urgente

			//Se ultrapassar o limite, encerra o laço
			If nAtual > nTamanho
				Exit
			EndIf

			oRegistro := JsonObject():New()

			oRegistro['filial'] := AllTrim(QRY_TAB->Filial)
			oRegistro['num'] := AllTrim(QRY_TAB->Num)
			oRegistro['item'] := AllTrim(QRY_TAB->Item)
			oRegistro['produto'] := AllTrim(QRY_TAB->Produto)
			oRegistro['local'] := AllTrim(QRY_TAB->Armazem)
			oRegistro['um'] := AllTrim(QRY_TAB->Unidade)
			oRegistro['quant'] := QRY_TAB->Quantidade
			//Preco estimado da SC (C1_VUNIT), mesmo campo gravado na inclusao/alteracao
			oRegistro['vunit'] := QRY_TAB->PrecoUnitario
			oRegistro['cc'] := AllTrim(QRY_TAB->CentroCusto)
			/*
			    O C1_XOBMEMO e campo memo, por isso e lido pela workarea e
			    nao pela query. O DbGoto PRECISA ser escopado no alias SC1:
			    sem o escopo ele posiciona a area corrente, que aqui e a
			    QRY_TAB, jogando o cursor da query para fora do resultado -
			    o que zerava os campos lidos depois deste ponto (emissao,
			    datprf e solicit) e encerrava o laco no primeiro item.
			*/
			SC1->(DbGoto(nRecno))
			cObs := SC1->C1_XOBMEMO
			cObs := StrTran(cObs, CRLF, " ")
			cObs := StrTran(cObs, Chr(13), " ")
			cObs := StrTran(cObs, Chr(10), " ")
			oRegistro['xobmemo'] := AllTrim(cObs)
			//Urgencia da SC no formato codigo-descricao: 1-Sim / 2-Não
			oRegistro['xurgen'] := W6Urgen(cUrgente)
			//Mesmo campo com o conteudo exato da SC1: 1 = Sim / 2 = Nao
			oRegistro['xurgencod'] := AllTrim(cUrgente)
			oRegistro['emissao'] := AllTrim(QRY_TAB->DataEmissao)
			oRegistro['datprf'] := AllTrim(QRY_TAB->DataNecessidade)
			oRegistro['solicit'] := AllTrim(QRY_TAB->Solicitante)

			aRateios := {}

			If cRateio == "1"

				cQueryRateio := "SELECT " + CRLF
				cQueryRateio += " CX_SOLICIT AS NumSolicitacao, " + CRLF
				cQueryRateio += " CX_ITEMSOL AS ItemSolicitacao , " + CRLF
				cQueryRateio += " CX_ITEM AS ItemRateio, " + CRLF
				cQueryRateio += " CX_PERC AS Percentual, " + CRLF
				cQueryRateio += " CX_CC AS CentroCusto " + CRLF
				cQueryRateio += "FROM SCX010 " + CRLF
				cQueryRateio += "WHERE D_E_L_E_T_ = '' " + CRLF
				cQueryRateio += "AND CX_FILIAL = '" + ::filial + "' " + CRLF
				cQueryRateio += "AND CX_SOLICIT = '" + ::num + "' " + CRLF
				cQueryRateio += "AND CX_ITEMSOL = '" + AllTrim(QRY_TAB->Item) + "' " + CRLF

				TCQuery cQueryRateio New Alias "QRY_SCX"

				QRY_SCX->(DbGoTop())

				While !QRY_SCX->(Eof())

					oRateio := JsonObject():New()

					oRateio["ItemSc"]    :=  AllTrim(QRY_SCX->ItemSolicitacao)
					oRateio["item"]        := AllTrim(QRY_SCX->ItemRateio)
					oRateio["percentual"]  := QRY_SCX->Percentual
					oRateio["cc"]          := AllTrim(QRY_SCX->CentroCusto)

					AAdd(aRateios, oRateio)

					QRY_SCX->(DbSkip())

				EndDo

				QRY_SCX->(DbCloseArea())

			Endif

			oRegistro["rateio"] := aRateios

			aAdd(jResponse['objects'], oRegistro)

			QRY_TAB->(DbSkip())
		EndDo
	EndIf
	QRY_TAB->(DbCloseArea())

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

/*/{Protheus.doc} W6Urgen
Devolve a urgencia da Solicitacao de Compras no formato codigo-descricao
@author Maria Luiza
@since 08/09/2026
@version 1.0
@type function
@param cUrgen, Caractere, Conteudo gravado no C1_XURGEN
@return Caractere, '1-Sim', '2-Não' ou o proprio conteudo quando nao mapeado
/*/
Static Function W6Urgen(cUrgen)
	Local cRet := AllTrim(cUrgen)

	Do Case
		Case cRet == '1'
			cRet := '1-Sim'
		Case cRet == '2'
			cRet := '2-Não'
	EndCase
Return cRet
