//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSCOM002
Serviço REST para consulta do cadastro de produtos
@author Maria Luiza
@since 16/07/2026
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSCOM002 DESCRIPTION 'Serviço REST para consulta do cadastro de produtos'
    //Atributos
    WSDATA updated_at AS STRING
    WSDATA limit      AS INTEGER
    WSDATA page       AS INTEGER
 
    //Métodos
    WSMETHOD GET    ALL    DESCRIPTION 'Retorna todos os registros'    WSSYNTAX '/WSCOM002/get_all?{updated_at, limit, page}' PATH 'get_all'       PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD GET ALL
Busca todos os registros através de paginação
@author Maria Luiza
@since 16/07/2026
@version 1.0
@type method
@param updated_at, Caractere, Data de alteração no formato string 'YYYY-MM-DD' (somente se tiver o campo USERLGA / USERGA na tabela)
@param limit, Numérico, Limite de registros que irá vir (por exemplo trazer apenas 100 registros)
@param page, Numérico, Número da página que irá buscar (se existir 1000 registros dividido por 100 terá 10 páginas de pesquisa)
@obs Codigo gerado automaticamente pelo Autumn Code Maker

    Poderia ser usado o FWAdapterBaseV2(), mas em algumas versões antigas não existe essa funcionalidade
    então a paginação foi feita manualmente
/*/

WSMETHOD GET ALL WSRECEIVE updated_at, limit, page WSSERVICE WSCOM002

    Local lRet       := .T.
    Local jResponse  := JsonObject():New()
    Local cQueryTab  := ''
    Local nTamanho   := 10
    Local nTotal     := 0
    Local nPags      := 0
    Local nPagina    := 1
    Local nAtual     := 0
    Local oRegistro
    Local jJsonMeta

   cQueryTab := "WITH EstoqueBase AS ( " + CRLF
   cQueryTab := cQueryTab + "    SELECT" + CRLF
   cQueryTab := cQueryTab + "        M0_FILIAL," + CRLF
   cQueryTab := cQueryTab + "        B2_FILIAL, -- exposto para o join com a última compra" + CRLF
   cQueryTab := cQueryTab + "        B2_COD, " + CRLF
   cQueryTab := cQueryTab + "        B1_DESC," + CRLF
   cQueryTab := cQueryTab + "        B1_UM," + CRLF
   cQueryTab := cQueryTab + "        B1_MSBLQL," + CRLF
   cQueryTab := cQueryTab + "        B1_UCOM," + CRLF
   cQueryTab := cQueryTab + "        B2_LOCAL," + CRLF
   cQueryTab := cQueryTab + "        NNR_DESCRI," + CRLF
   cQueryTab := cQueryTab + "        B1_TIPO," + CRLF
   cQueryTab := cQueryTab + "        B1_GRUPO," + CRLF
   cQueryTab := cQueryTab + "        BM_DESC," + CRLF
   cQueryTab := cQueryTab + "        X5_DESCRI," + CRLF
   cQueryTab := cQueryTab + "        B2_CM1," + CRLF
   cQueryTab := cQueryTab + "        B2_USAI," + CRLF
   cQueryTab := cQueryTab + "        B2_QATU," + CRLF
   cQueryTab := cQueryTab + "        B2_QEMP," + CRLF
   cQueryTab := cQueryTab + "        B2_QEMPSA," + CRLF
   cQueryTab := cQueryTab + "        B2_RESERVA," + CRLF
   cQueryTab := cQueryTab + "        B2_VATU1," + CRLF
   cQueryTab := cQueryTab + "        B1_EMIN," + CRLF
   cQueryTab := cQueryTab + "        B8_LOTECTL," + CRLF
   cQueryTab := cQueryTab + "        B8_SALDO," + CRLF
   cQueryTab := cQueryTab + "        B1_RASTRO," + CRLF
   cQueryTab := cQueryTab + "        B2_QACLASS," + CRLF
   cQueryTab := cQueryTab + "        CASE " + CRLF
   cQueryTab := cQueryTab + "            WHEN B1_RASTRO = 'L' AND B8_SALDO > 0 AND B2_QATU > 0" + CRLF
   cQueryTab := cQueryTab + "                THEN ISNULL(" + CRLF
   cQueryTab := cQueryTab + "                    B2_QATU / NULLIF(COUNT(B8_LOTECTL) OVER (" + CRLF
   cQueryTab := cQueryTab + "                        PARTITION BY B8_PRODUTO, B8_LOCAL, B8_FILIAL" + CRLF
   cQueryTab := cQueryTab + "                    ), 0)," + CRLF
   cQueryTab := cQueryTab + "                0)" + CRLF
   cQueryTab := cQueryTab + "            ELSE B2_QATU" + CRLF
   cQueryTab := cQueryTab + "        END AS SaldoCalculado," + CRLF
   cQueryTab := cQueryTab + "        CASE " + CRLF
   cQueryTab := cQueryTab + "            WHEN B1_RASTRO = 'L' AND B8_SALDO > 0 AND B2_QATU > 0" + CRLF
   cQueryTab := cQueryTab + "                THEN ISNULL(" + CRLF
   cQueryTab := cQueryTab + "                    B2_QACLASS / NULLIF(COUNT(B8_LOTECTL) OVER (" + CRLF
   cQueryTab := cQueryTab + "                        PARTITION BY B8_PRODUTO, B8_LOCAL, B8_FILIAL" + CRLF
   cQueryTab := cQueryTab + "                    ), 0)," + CRLF
   cQueryTab := cQueryTab + "                0)" + CRLF
   cQueryTab := cQueryTab + "            ELSE B2_QACLASS" + CRLF
   cQueryTab := cQueryTab + "        END AS QaClassCalculado" + CRLF
   cQueryTab := cQueryTab + "    FROM SB2010" + CRLF
   cQueryTab := cQueryTab + "    LEFT JOIN SB1010" + CRLF
   cQueryTab := cQueryTab + "        ON B2_COD = B1_COD" + CRLF
   cQueryTab := cQueryTab + "        AND SB1010.D_E_L_E_T_ <> '*'" + CRLF
   cQueryTab := cQueryTab + "        AND SUBSTRING(B2_FILIAL, 1, 2) = B1_FILIAL" + CRLF
   cQueryTab := cQueryTab + "    LEFT JOIN SBM010" + CRLF
   cQueryTab := cQueryTab + "        ON B1_GRUPO = BM_GRUPO" + CRLF
   cQueryTab := cQueryTab + "        AND SBM010.D_E_L_E_T_ <> '*'" + CRLF
   cQueryTab := cQueryTab + "        AND BM_FILIAL = ' '" + CRLF
   cQueryTab := cQueryTab + "    LEFT JOIN SX5010" + CRLF
   cQueryTab := cQueryTab + "        ON X5_TABELA + X5_CHAVE = '02' + B1_TIPO" + CRLF
   cQueryTab := cQueryTab + "        AND B2_FILIAL = X5_FILIAL" + CRLF
   cQueryTab := cQueryTab + "        AND SX5010.D_E_L_E_T_ <> '*'" + CRLF
   cQueryTab := cQueryTab + "    LEFT JOIN NNR010" + CRLF
   cQueryTab := cQueryTab + "        ON NNR_CODIGO = B2_LOCAL" + CRLF
   cQueryTab := cQueryTab + "        AND NNR010.D_E_L_E_T_ <> '*'" + CRLF
   cQueryTab := cQueryTab + "        AND B2_FILIAL = NNR_FILIAL" + CRLF
   cQueryTab := cQueryTab + "    LEFT JOIN SYS_COMPANY" + CRLF
   cQueryTab := cQueryTab + "        ON B2_FILIAL = M0_CODFIL" + CRLF
   cQueryTab := cQueryTab + "        AND SYS_COMPANY.D_E_L_E_T_ = ''" + CRLF
   cQueryTab := cQueryTab + "        AND M0_NOME = 'BRG Geradores'" + CRLF
   cQueryTab := cQueryTab + "    LEFT JOIN SB8010" + CRLF
   cQueryTab := cQueryTab + "        ON B2_COD = B8_PRODUTO" + CRLF
   cQueryTab := cQueryTab + "        AND SB8010.D_E_L_E_T_ <> '*'" + CRLF
   cQueryTab := cQueryTab + "        AND B2_FILIAL = SB8010.B8_FILIAL" + CRLF
   cQueryTab := cQueryTab + "        AND B1_RASTRO = 'L'" + CRLF
   cQueryTab := cQueryTab + "        AND B8_SALDO  > 0" + CRLF
   cQueryTab := cQueryTab + "        AND B2_QATU   > 0" + CRLF
   cQueryTab := cQueryTab + "    WHERE" + CRLF
   cQueryTab := cQueryTab + "        SB2010.D_E_L_E_T_ <> '*'" + CRLF
   cQueryTab := cQueryTab + "        AND SB1010.D_E_L_E_T_ <> '*'" + CRLF
   cQueryTab := cQueryTab + "        AND B1_TIPO <> 'OI'" + CRLF
   cQueryTab := cQueryTab + "        AND B1_MSBLQL = '2'" + CRLF
   cQueryTab := cQueryTab + "        AND B2_FILIAL IN ('0101', '0501', '0502', '0503')" + CRLF
   cQueryTab := cQueryTab + " )," + CRLF
   cQueryTab := cQueryTab + " UltimaCompra AS (" + CRLF
   cQueryTab := cQueryTab + "    SELECT" + CRLF
   cQueryTab := cQueryTab + "        D1_FILIAL," + CRLF
   cQueryTab := cQueryTab + "        D1_COD," + CRLF
   cQueryTab := cQueryTab + "        D1_VUNIT," + CRLF
   cQueryTab := cQueryTab + "        D1_DTDIGIT," + CRLF
   cQueryTab := cQueryTab + "        ROW_NUMBER() OVER (" + CRLF
   cQueryTab := cQueryTab + "            PARTITION BY D1_FILIAL, D1_COD" + CRLF
   cQueryTab := cQueryTab + "            ORDER BY D1_DTDIGIT DESC, R_E_C_N_O_ DESC" + CRLF
   cQueryTab := cQueryTab + "        ) AS RN" + CRLF
   cQueryTab := cQueryTab + "    FROM SD1010" + CRLF
   cQueryTab := cQueryTab + "    WHERE D_E_L_E_T_ <> '*'" + CRLF
   cQueryTab := cQueryTab + "      AND D1_TIPO = 'N' -- somente compras (exclui devolucao 'D' e beneficiamento 'B')" + CRLF
   cQueryTab := cQueryTab + "      AND D1_FILIAL IN ('0101', '0501', '0502', '0503')" + CRLF
   cQueryTab := cQueryTab + " )" + CRLF
   cQueryTab := cQueryTab + " SELECT" + CRLF
   cQueryTab := cQueryTab + "    EB.M0_FILIAL AS Filial," + CRLF
   cQueryTab := cQueryTab + "    EB.B2_COD AS CodigoProduto," + CRLF
   cQueryTab := cQueryTab + "    EB.B1_DESC AS NomeProduto," + CRLF
   cQueryTab := cQueryTab + "    EB.B1_UM AS UM," + CRLF
   cQueryTab := cQueryTab + "    CASE" + CRLF
   cQueryTab := cQueryTab + "        WHEN EB.B1_MSBLQL = 1 THEN '1 - Sim'" + CRLF
   cQueryTab := cQueryTab + "        WHEN EB.B1_MSBLQL = 2 THEN '2 - Não'" + CRLF
   cQueryTab := cQueryTab + "        ELSE ' - '" + CRLF
   cQueryTab := cQueryTab + "    END AS Bloq," + CRLF
   cQueryTab := cQueryTab + "    CONCAT(EB.B2_LOCAL, '-', EB.NNR_DESCRI) AS DescArmazem," + CRLF
   cQueryTab := cQueryTab + "    EB.B2_LOCAL AS Armazem," + CRLF
   cQueryTab := cQueryTab + "    EB.B1_TIPO AS Tipo," + CRLF
   cQueryTab := cQueryTab + "    CONCAT(EB.B1_GRUPO, '-', EB.BM_DESC) AS DescGrupo," + CRLF
   cQueryTab := cQueryTab + "    EB.B1_GRUPO AS Grupo," + CRLF
   cQueryTab := cQueryTab + "    CONCAT(EB.B1_TIPO, '-', EB.X5_DESCRI) AS DescTipo," + CRLF
   cQueryTab := cQueryTab + "    EB.B2_CM1 AS ValorUni," + CRLF
   cQueryTab := cQueryTab + "    EB.B2_USAI AS DtUltimaSaida," + CRLF
   cQueryTab := cQueryTab + "    EB.SaldoCalculado AS SaldoEmEstoque," + CRLF
   cQueryTab := cQueryTab + "    EB.B2_QEMP + EB.B2_QEMPSA + EB.B2_RESERVA AS EmpenhoReqPvReserva," + CRLF
   cQueryTab := cQueryTab + "    CASE" + CRLF
   cQueryTab := cQueryTab + "        WHEN EB.B2_QEMP + EB.B2_QEMPSA + EB.B2_RESERVA > 0" + CRLF
   cQueryTab := cQueryTab + "            THEN EB.SaldoCalculado - (EB.B2_QEMP + EB.B2_QEMPSA + EB.B2_RESERVA)" + CRLF
   cQueryTab := cQueryTab + "        ELSE" + CRLF
   cQueryTab := cQueryTab + "            EB.SaldoCalculado + (EB.B2_QEMP + EB.B2_QEMPSA + EB.B2_RESERVA)" + CRLF
   cQueryTab := cQueryTab + "    END AS EstoqueDisponivel," + CRLF
   cQueryTab := cQueryTab + "    EB.SaldoCalculado * EB.B2_CM1 AS ValorEmEstoque," + CRLF
   cQueryTab := cQueryTab + "    EB.B2_CM1 * EB.B2_QEMP AS ValorEmpenhado," + CRLF
   cQueryTab := cQueryTab + "    EB.B1_EMIN AS EstoqueMinimo," + CRLF
   cQueryTab := cQueryTab + "    EB.B8_LOTECTL AS Lote," + CRLF
   cQueryTab := cQueryTab + "    EB.QaClassCalculado AS QtdAEnderecar," + CRLF
   cQueryTab := cQueryTab + "    UC.D1_VUNIT AS VlrUnitUltimaCompra, -- última compra (última entrada de NF na SD1)" + CRLF
   cQueryTab := cQueryTab + "    CASE" + CRLF
   cQueryTab := cQueryTab + "        WHEN UC.D1_DTDIGIT IS NOT NULL AND UC.D1_DTDIGIT <> ''" + CRLF
   cQueryTab := cQueryTab + "            THEN CONVERT(date, UC.D1_DTDIGIT)" + CRLF
   cQueryTab := cQueryTab + "        ELSE NULL" + CRLF
   cQueryTab := cQueryTab + "    END AS DtUltimaCompra" + CRLF
   cQueryTab := cQueryTab + " FROM EstoqueBase EB" + CRLF
   cQueryTab := cQueryTab + " LEFT JOIN UltimaCompra UC" + CRLF
   cQueryTab := cQueryTab + "    ON UC.D1_COD     = EB.B2_COD" + CRLF
   cQueryTab := cQueryTab + "    AND UC.D1_FILIAL = EB.B2_FILIAL" + CRLF
   cQueryTab := cQueryTab + "    AND UC.RN        = 1" + CRLF
   cQueryTab := cQueryTab + " ORDER BY EB.B2_COD" + CRLF
   
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
            oRegistro['filial'] := AllTrim(QRY_TAB->Filial)
            oRegistro['cod'] := AllTrim(QRY_TAB->CodigoProduto)
            oRegistro['desc'] := AllTrim(QRY_TAB->NomeProduto)
            oRegistro['um'] := AllTrim(QRY_TAB->UM)
            oRegistro['bloq'] := AllTrim(QRY_TAB->Bloq)
            oRegistro['local'] := AllTrim(QRY_TAB->DescArmazem)
            oRegistro['tipo'] := AllTrim(QRY_TAB->DescTipo)
            oRegistro['grupo'] := AllTrim(QRY_TAB->DescGrupo)
            oRegistro['valor'] := QRY_TAB->ValorUni
            oRegistro['saldoest'] := QRY_TAB->SaldoEmEstoque
            oRegistro['empres'] := QRY_TAB->EmpenhoReqPvReserva
            oRegistro['estoquedisponivel'] := QRY_TAB->EstoqueDisponivel
            oRegistro['lote'] := AllTrim(QRY_TAB->Lote)
            oRegistro['qtdenderecar'] := QRY_TAB->QtdAEnderecar
            oRegistro['valorUltCompra'] := QRY_TAB->VlrUnitUltimaCompra
            oRegistro['dtUltCompra'] := QRY_TAB->DtUltimaCompra
            aAdd(jResponse['objects'], oRegistro)

            QRY_TAB->(DbSkip())
        EndDo
    EndIf
    QRY_TAB->(DbCloseArea())

    //Define o retorno
    Self:SetContentType('application/json')
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))

Return lRet
