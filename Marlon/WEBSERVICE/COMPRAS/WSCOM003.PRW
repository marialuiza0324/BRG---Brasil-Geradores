//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSCOM003
Serviço REST para consulta de usuários
@author Maria Luiza
@since 17/07/2026
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSCOM003 DESCRIPTION 'Serviço REST para consulta de usuários'
    //Atributos
    WSDATA updated_at AS STRING
    WSDATA limit      AS INTEGER
    WSDATA page       AS INTEGER
 
    //Métodos
    WSMETHOD GET    ALL    DESCRIPTION 'Retorna todos os registros'    WSSYNTAX '/WSCOM003/get_all?{updated_at, limit, page}' PATH 'get_all'       PRODUCES APPLICATION_JSON
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

    Poderia ser usado o FWAdapterBaseV2(), mas em algumas versões antigas não existe essa funcionalidade
    então a paginação foi feita manualmente
/*/

WSMETHOD GET ALL WSRECEIVE updated_at, limit, page WSSERVICE WSCOM003
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
    cQueryTab += " RTRIM(RA.RA_MAT) AS MATRICULA, " + CRLF
    cQueryTab += " RTRIM(RA.RA_NOME) AS NOME, " + CRLF
    cQueryTab += " RTRIM(RA.RA_CIC) AS CPF, " + CRLF
    cQueryTab += " CAST(RA.RA_NASC AS DATE) AS DATA_NASC, " + CRLF
    cQueryTab += " CASE " + CRLF
    cQueryTab += "     WHEN TRIM(RA.RA_DDDCELU) + REPLACE(REPLACE(TRIM(RA.RA_NUMCELU), ' ', ''), '-', '') = '' THEN 'SEM CONTATO' " + CRLF
    cQueryTab += "     WHEN TRIM(RA.RA_DDDCELU) = '' THEN 'SEM DDD' " + CRLF
    cQueryTab += "     WHEN REPLACE(REPLACE(TRIM(RA.RA_NUMCELU), ' ', ''), '-', '') = '' THEN 'SEM CONTATO (APENAS DDD)' " + CRLF
    cQueryTab += "     ELSE TRIM(RA.RA_DDDCELU) + REPLACE(REPLACE(TRIM(RA.RA_NUMCELU), ' ', ''), '-', '') " + CRLF
    cQueryTab += " END AS CELULAR, " + CRLF
    cQueryTab += " QB.QB_DEPSUP AS COD_DEPTO_SUP, " + CRLF
    cQueryTab += " RTRIM(RA.RA_DEPTO) AS COD_DEPTO, " + CRLF
    cQueryTab += " TRIM(QB.QB_DESCRIC) AS DEPTO, " + CRLF
    cQueryTab += " CASE " + CRLF
    cQueryTab += "     WHEN RA.RA_MAT = QB.QB_MATRESP THEN RTRIM(QB_SUP.QB_MATRESP) -- Se for gestor do próprio setor, pega o gestor do setor superior " + CRLF
    cQueryTab += "     ELSE RTRIM(QB.QB_MATRESP) -- Caso contrário, pega o gestor do seu próprio setor " + CRLF
    cQueryTab += " END AS MAT_GESTOR, " + CRLF
    cQueryTab += " RTRIM(GESTOR.RA_NOME) AS NOME_GESTOR " + CRLF
    cQueryTab += " FROM SRA010 RA " + CRLF
    cQueryTab += " LEFT JOIN SQB010 QB " + CRLF
    cQueryTab += " ON RA.RA_DEPTO = QB.QB_DEPTO " + CRLF 
    cQueryTab += " AND SUBSTRING(RA.RA_FILIAL, 1, 2) = QB.QB_FILIAL " + CRLF
    cQueryTab += " AND QB.D_E_L_E_T_ <> '*' " + CRLF
    cQueryTab += " LEFT JOIN SQB010 QB_SUP " + CRLF
    cQueryTab += " ON QB.QB_DEPSUP = QB_SUP.QB_DEPTO " + CRLF
    cQueryTab += " AND QB.QB_FILIAL = QB_SUP.QB_FILIAL " + CRLF
    cQueryTab += " AND QB_SUP.D_E_L_E_T_ <> '*' " + CRLF
    cQueryTab += " LEFT JOIN SRA010 GESTOR " + CRLF
    cQueryTab += " ON GESTOR.RA_MAT = CASE " + CRLF
    cQueryTab += "     WHEN RA.RA_MAT = QB.QB_MATRESP THEN QB_SUP.QB_MATRESP " + CRLF
    cQueryTab += "     ELSE QB.QB_MATRESP " + CRLF
    cQueryTab += " END " + CRLF
    cQueryTab += " AND SUBSTRING(GESTOR.RA_FILIAL, 1, 2) = QB.QB_FILIAL -- Garante a mesma raiz de filial " + CRLF
    cQueryTab += " AND GESTOR.D_E_L_E_T_ = '' " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     RA.D_E_L_E_T_ = '' -- retira os deletados " + CRLF
    cQueryTab += "     AND TRIM(RA.RA_FILIAL) = '0101' " + CRLF
    cQueryTab += "     AND TRIM(RA.RA_DEMISSA) = '' -- retira os demitidos " + CRLF
    cQueryTab += " ORDER BY " + CRLF
    cQueryTab += "     RA.RA_BITMAP DESC " + CRLF
    
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
            oRegistro['Matricula'] := AllTrim(QRY_TAB->MATRICULA)
            oRegistro['Nome'] := AllTrim(QRY_TAB->NOME)
            oRegistro['CodDepto'] := AllTrim(QRY_TAB->COD_DEPTO)
            oRegistro['Depto'] := AllTrim(QRY_TAB->DEPTO)
            oRegistro['Matricula Gestor'] := AllTrim(QRY_TAB->MAT_GESTOR)
            oRegistro['Nome Gestor'] := AllTrim(QRY_TAB->NOME_GESTOR)
            oRegistro['Depto Gestor'] := AllTrim(QRY_TAB->COD_DEPTO_SUP)
            aAdd(jResponse['objects'], oRegistro)

            QRY_TAB->(DbSkip())
        EndDo
    EndIf
    QRY_TAB->(DbCloseArea())

    //Define o retorno
    Self:SetContentType('application/json')
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet
