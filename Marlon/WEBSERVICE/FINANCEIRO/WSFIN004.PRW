//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSFIN004
Serviço rest para manipulação do título do contas a pagar    
@author Maria Luiza
@since 27/04/2026
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSFIN004 DESCRIPTION 'Serviço rest para manipulação dos títulos VEXPENSES tipo PA e RDV'
    //Métodos
    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSFIN004/new'                               PATH 'new'           PRODUCES APPLICATION_JSON

END WSRESTFUL

/*/{Protheus.doc} WSMETHOD POST NEW
Cria um novo registro na tabela
@author Maria Luiza
@since 27/04/2026
@version 1.0
@type method
@obs Codigo gerado automaticamente pelo Autumn Code Maker

    Abaixo um exemplo do JSON que deverá vir no body
    * 1: Para campos do tipo Numérico, informe o valor sem usar as aspas
    * 2: Para campos do tipo Data, informe uma string no padrão 'YYYY-MM-DD'

    {
        "tipo": "conteudo",
        "prefixo": "conteudo",
        "fornece": "conteudo",
        "nomefor": "conteudo",
        "naturez": "conteudo",
        "valor": "conteudo",
        "num": "conteudo",
        "hist": "conteudo",
        "ccusto": "conteudo"
    }
/*/

WSMETHOD POST NEW WSRECEIVE WSSERVICE WSFIN004
    Local lRet              := .T.
    Local aDados            := {}
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
    Local dHoje             := Date()
    Local nDia              := Day(dHoje)
    Local cMes              := Month2Str(dHoje)
    Local nAno              := Year(dHoje)
    Local dDtMes             := Date()
    Local dVenc             := dHoje
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
		DbSelectArea(cAliasWS)
       
		//Adiciona os dados do ExecAuto
		aAdd(aDados, {'E2_PREFIXO',   jJson:GetJsonObject('prefixo'),   Nil})
		aAdd(aDados, {'E2_NUM',   jJson:GetJsonObject('num'),   Nil})
		aAdd(aDados, {'E2_TIPO',   jJson:GetJsonObject('tipo'),   Nil})
		aAdd(aDados, {'E2_NATUREZ',   jJson:GetJsonObject('naturez'),   Nil})
		aAdd(aDados, {'E2_FORNECE',   jJson:GetJsonObject('fornece'),   Nil})
        // Data de emissão = hoje
        aAdd(aDados, {'E2_EMISSAO',   dHoje,   Nil})

        // Regra de vencimento:
        // se dia atual entre 1 e 15 -> vencimento dia 20 do mesmo mês
        // se dia atual entre 16 e 31 -> vencimento dia 05 do próximo mês

        If nDia <= 15
            // mesmo mês, dia 20
            dVenc := Stod(cValToChar(nAno) + cMes + "20")
        Else
            // próximo mês, dia 5
            If cMes == "12"
                cMes := "01"
                nAno := nAno + 1
            Else
                dDtMes := MonthSum(dHoje,1)
                cMes := Substr(cvaltochar(dDtMes),4,2)
            EndIf
            dVenc := Stod(cValToChar(nAno) + cMes + "05")
        EndIf

        aAdd(aDados, {'E2_VENCTO',   DataValida(dVenc,.F.),   Nil})
        aAdd(aDados, {'E2_VENCREA',   DataValida(dVenc,.F.),   Nil})
		aAdd(aDados, {'E2_VALOR',   jJson:GetJsonObject('valor'),   Nil})
		aAdd(aDados, {'E2_HIST',   jJson:GetJsonObject('hist'),   Nil})
		aAdd(aDados, {'E2_CCUSTO',   jJson:GetJsonObject('ccusto'),   Nil})
        If jJson:GetJsonObject('tipo') == "PA"
            aAdd(aDados, {'AUTBANCO',   "341",   Nil})
            aAdd(aDados, {'AUTAGENCIA',   "0208",   Nil})
            aAdd(aDados, {'AUTCONTA',   "54002",   Nil})
            aAdd(aDados, {'AUTCHEQUE',  jJson:GetJsonObject('num'),   Nil})
        EndIf
	
		//Chama a inclusão automática
		MsExecAuto({|x, y| FINA050(x, y)}, aDados, 3)

		//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
		If lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSFIN004_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
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
			jResponse['note']     := 'Registro incluido com sucesso'
		EndIf

    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
    
Return lRet
