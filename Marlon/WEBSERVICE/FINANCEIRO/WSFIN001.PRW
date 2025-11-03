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
WSDATA vencto   AS DATE
WSDATA vencrea  AS DATE
WSDATA valor    AS NUMERIC

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
        "vencto": "conteudo",
        "vencrea": "conteudo",
        "valor": "conteudo"
    }
/*/

WSMETHOD POST NEW WSRECEIVE WSSERVICE WSFIN001

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
    Local nCampo            := 0
    Local jResponse         := JsonObject():New()
    Local cAliasWS          := 'SE2'
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
		aAdd(aDados, {'E2_PARCELA',   jJson:GetJsonObject('parcela'),   Nil})
		aAdd(aDados, {'E2_TIPO',   jJson:GetJsonObject('tipo'),   Nil})
		aAdd(aDados, {'E2_NATUREZ',   jJson:GetJsonObject('naturez'),   Nil})
		aAdd(aDados, {'E2_FORNECE',   jJson:GetJsonObject('fornece'),   Nil})
		aAdd(aDados, {'E2_LOJA',   jJson:GetJsonObject('loja'),   Nil})
		aAdd(aDados, {'E2_EMISSAO',   dtos(dDataBase),   Nil})
		aAdd(aDados, {'E2_VENCTO',   jJson:GetJsonObject('vencto'),   Nil})
		aAdd(aDados, {'E2_VENCREA',   jJson:GetJsonObject('vencrea'),   Nil})
		aAdd(aDados, {'E2_VALOR',   jJson:GetJsonObject('valor'),   Nil})
		
		//Percorre os dados do execauto
		For nCampo := 1 To Len(aDados)
			//Se o campo for data, retira os hifens e faz a conversão
			If GetSX3Cache(aDados[nCampo][1], 'X3_TIPO') == 'D'
				aDados[nCampo][2] := StrTran(aDados[nCampo][2], '-', '')
				aDados[nCampo][2] := sToD(aDados[nCampo][2])
			EndIf
		Next

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
			jResponse['note']     := 'Registro incluido com sucesso'
		EndIf

    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet
