//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSPCP001
Serviço rest para consulta de OP's de Produção
@author Maria Luiza
@since 22/06/2026
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSPCP001 DESCRIPTION "Serviço rest para consulta de OP's de Produção"
	//Atributos
	WSDATA updated_at AS STRING
	WSDATA limit      AS INTEGER
	WSDATA page       AS INTEGER

	//Métodos
	WSMETHOD GET ALL DESCRIPTION "Retorna todos os registros" WSSYNTAX "/WSPCP001/get_all?{updated_at, limit, page}" PATH "get_all" PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD GET ALL
Busca todos os registros através de paginação
@author Maria Luiza
@since 22/06/2026
@version 1.0
@type method
@param updated_at, Caractere, Data de alteração no formato string 'YYYY-MM-DD' (somente se tiver o campo USERLGA / USERGA na tabela)
@param limit, Numérico, Limite de registros que irá vir (por exemplo trazer apenas 100 registros)
@param page, Numérico, Número da página que irá buscar (se existir 1000 registros dividido por 100 terá 10 páginas de pesquisa)
@obs Codigo gerado automaticamente pelo Autumn Code Maker

    Poderia ser usado o FWAdapterBaseV2(), mas em algumas versões antigas não existe essa funcionalidade
    então a paginação foi feita manualmente
/*/

WSMETHOD GET ALL WSRECEIVE updated_at, limit, page WSSERVICE WSPCP001
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	Local jJsonMeta  := JsonObject():New()
	Local cQueryTab  := ""
	Local nTamanho   := 10
	Local nTotal     := 0
	Local nPags      := 0
	Local nPagina    := 1
	Local nAtual     := 0
	Local oRegistro

   cQuerytab := " SELECT DISTINCT "
   cQueryTab += " C2_FILIAL AS Filial, " + CRLF
   cQueryTab += " C2_PRODUTO AS NumeroProduto, " + CRLF
   cQueryTab += " B1_DESC AS DesProduto, " + CRLF
   cQueryTab += " B1_GRUPO AS Grupo, " + CRLF
   cQueryTab += " B1_GPRODBI AS GrupoCorrigido, " + CRLF
   cQueryTab += " CASE " + CRLF
   cQueryTab += " WHEN ISNULL(B1_GPRODBI, '') = '' THEN B1_GRUPO " + CRLF
   cQueryTab += " ELSE B1_GPRODBI " + CRLF
   cQueryTab += " END AS GrupoFinal, " + CRLF
   cQueryTab += " CASE " + CRLF
   cQueryTab += " WHEN ISNULL(B1_GPRODBI, '') = '' THEN SBM010.BM_DESC " + CRLF
   cQueryTab += " ELSE SBM2.BM_DESC " + CRLF
   cQueryTab += " END AS DesGrupo, " + CRLF
   cQueryTab += " C2_NUM + C2_ITEM + C2_SEQUEN AS OP, " + CRLF
   cQueryTab += " C2_DATPRI AS DT_Inicio, " + CRLF
   cQueryTab += " C2_PRODUTO AS Produto,  " + CRLF
   cQueryTab += " C2_QUANT AS Quantidade, " + CRLF
   cQueryTab += " C2_QUJE AS QTD_ENTREGUE, " + CRLF
   cQueryTab += " C2_TPOP, " + CRLF
   cQueryTab += " C2_DATRF AS DT_Fim, " + CRLF
   cQueryTab += " SUM(D3_CUSTO1) CUSTO_TOTAL, " + CRLF
   cQueryTab += " D3_LOTECTL, " + CRLF
   cQueryTab += " CASE C2_STATUS " + CRLF
   cQueryTab += " WHEN 'N' THEN 'Normal' " + CRLF
   cQueryTab += " WHEN 'U' THEN 'Suspensa' " + CRLF
   cQueryTab += " WHEN 'S' THEN 'Sacramentada' " + CRLF
   cQueryTab += " END AS CS_STATUS, " + CRLF
   cQueryTab += " (ISNULL " + CRLF
   cQueryTab += " (( " + CRLF
   cQueryTab += " SELECT ISNULL(SUM(SD33.D3_CUSTO1),0) " + CRLF
   cQueryTab += " FROM SD3010 SD33 " + CRLF
   cQueryTab += " WHERE SD33.D3_FILIAL = C2_FILIAL  " + CRLF
   cQueryTab += "AND SD33.D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN " + CRLF
   cQueryTab += " AND SD33.D3_CF IN ('RE6','RE0') " + CRLF
   cQueryTab += "AND SD33.D3_ESTORNO = ' ' " + CRLF
   cQueryTab += "AND SD33.D_E_L_E_T_ <> '*' " + CRLF
   cQueryTab += " ),0)) AS Cust_Tot, " + CRLF
   cQueryTab += " (ISNULL " + CRLF
   cQueryTab += " (( " + CRLF
   cQueryTab += " SELECT ISNULL(SUM(SD33.D3_CUSTO1),0) " + CRLF
   cQueryTab += " FROM SD3010 SD33 " + CRLF
   cQueryTab += " WHERE SD33.D3_FILIAL = C2_FILIAL " + CRLF
   cQueryTab += " AND SD33.D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN " + CRLF
   cQueryTab += " AND SD33.D3_CF IN ('DE0','DE6') " + CRLF
   cQueryTab += " AND SD33.D3_ESTORNO = ' ' " + CRLF
   cQueryTab += " AND SD33.D_E_L_E_T_ <> '*' " + CRLF
   cQueryTab += " ),0) " + CRLF
   cQueryTab += " ) AS Cust_Tot_DEV " + CRLF
   cQueryTab += " FROM SC2010 AS SC2 " + CRLF
   cQueryTab += " LEFT JOIN SD3010 ON D3_OP = C2_NUM + C2_ITEM + C2_SEQUEN " + CRLF
   cQueryTab += " AND D3_FILIAL = C2_FILIAL " + CRLF
   cQueryTab += " AND SD3010.D_E_L_E_T_ <> '*' " + CRLF
   cQueryTab += " LEFT JOIN SB1010 ON C2_PRODUTO = B1_COD  " + CRLF
   cQueryTab += " AND SUBSTRING(C2_FILIAL,1,2) = B1_FILIAL " + CRLF
   cQueryTab += " AND SB1010.D_E_L_E_T_ <> '*' " + CRLF
   cQueryTab += " LEFT JOIN SBM010 ON B1_GRUPO = BM_GRUPO " + CRLF
   cQueryTab += " AND SBM010.D_E_L_E_T_ <> '*' " + CRLF
   cQueryTab += " LEFT JOIN SBM010 AS SBM2 ON B1_GPRODBI = SBM2.BM_GRUPO " + CRLF
   cQueryTab += " AND SBM2.D_E_L_E_T_ <> '*' " + CRLF
   cQueryTab += " WHERE SC2.D_E_L_E_T_ <> '*' " + CRLF
   cQueryTab += " AND SC2.C2_FILIAL = '0101' " + CRLF
   cQueryTab += " AND SC2.C2_STATUS = 'N' " + CRLF
   cQueryTab += " AND C2_OBS NOT LIKE '%DESM%' " + CRLF
   cQueryTab += " AND C2_SEQUEN = '001' " + CRLF
   cQueryTab += "AND B1_GRUPO LIKE 'G%' " + CRLF
   cQueryTab += " GROUP BY  " + CRLF
   cQueryTab += " C2_PRODUTO, B1_DESC,C2_DATPRI,C2_PRODUTO,C2_QUANT,C2_QUJE,C2_DATRF, " + CRLF
   cQueryTab += " B1_GRUPO,SBM010.BM_DESC ,C2_TPOP,C2_FILIAL,C2_NUM + C2_ITEM + C2_SEQUEN, " + CRLF
   cQueryTab += " C2_STATUS, B1_GPRODBI, SBM2.BM_DESC,D3_LOTECTL " + CRLF

	TCQuery cQueryTab New Alias "QRY_TAB"

	//Se não encontrar registros
	If QRY_TAB->(EoF())
		Self:SetStatus(500)
		jResponse["errorId"]  := "ALL003"
		jResponse["error"]    := "Registro(s) não encontrado(s)"
		jResponse["solution"] := "A consulta de registros não retornou nenhuma informação"
	Else
		jResponse["objects"] := {}

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

		//Meta
		jJsonMeta["total"]        := nTotal
		jJsonMeta["current_page"] := nPagina
		jJsonMeta["total_page"]   := nPags
		jJsonMeta["total_items"]  := nTamanho
		jResponse["meta"]         := jJsonMeta

		//Percorre os registros
		While !QRY_TAB->(EoF())
			nAtual++

			If nAtual > nTamanho
				Exit
			EndIf

			//Monta o objeto diretamente da query
			oRegistro := JsonObject():New()
			oRegistro["filial"]          := AllTrim(QRY_TAB->FILIAL)
			oRegistro["numero_produto"]  := AllTrim(QRY_TAB->NUMEROPRODUTO)
			oRegistro["des_produto"]     := AllTrim(QRY_TAB->DESPRODUTO)
			oRegistro["grupo"]           := AllTrim(QRY_TAB->GRUPO)
			oRegistro["grupo_corrigido"] := AllTrim(QRY_TAB->GRUPOCORRIGIDO)
			oRegistro["grupo_final"]     := AllTrim(QRY_TAB->GRUPOFINAL)
			oRegistro["des_grupo"]       := AllTrim(QRY_TAB->DESGRUPO)
			oRegistro["op"]              := AllTrim(QRY_TAB->OP)
			oRegistro["dt_inicio"]       := QRY_TAB->DT_INICIO
			oRegistro["produto"]         := AllTrim(QRY_TAB->PRODUTO)
			oRegistro["quantidade"]      := QRY_TAB->QUANTIDADE
			oRegistro["qtd_entregue"]    := QRY_TAB->QTD_ENTREGUE
			oRegistro["c2_tpop"]         := AllTrim(QRY_TAB->C2_TPOP)
			oRegistro["dt_fim"]          := QRY_TAB->DT_FIM
			oRegistro["custo_total"]     := QRY_TAB->CUSTO_TOTAL
			oRegistro["lotectl"]         := AllTrim(QRY_TAB->D3_LOTECTL)
			oRegistro["cs_status"]       := AllTrim(QRY_TAB->CS_STATUS)
			oRegistro["cust_tot"]        := QRY_TAB->CUST_TOT
			oRegistro["cust_tot_dev"]    := QRY_TAB->CUST_TOT_DEV

			aAdd(jResponse["objects"], oRegistro)

			QRY_TAB->(DbSkip())
		EndDo
	EndIf

	QRY_TAB->(DbCloseArea())

	//Define o retorno
	Self:SetContentType("application/json")
	Self:SetResponse(EncodeUTF8(jResponse:ToJSON()))

Return lRet
