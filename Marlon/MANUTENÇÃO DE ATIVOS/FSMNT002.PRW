//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} User Function FSMNT002
Serviço REST para atualização dos Horímetros
/*/

User Function FSMNT002()

	Local aArea       := FWGetArea()
	Local cResultado  := ''
	Local cErro       := ''
	Local aHeader     := {}
	Local oRestClient := FWRest():New("https://api.brggeradores.com.br")
	Local cBody       := ''

	Local cCodEquip := AllTrim(Posicione("ST9",1,FWxFilial('ST9') + M->TJ_CODBEM, 'T9_SERIE'))

	Local cData := SubStr(DTOS(M->TJ_DTMRFIM),1,4) + "-" + ;
	               SubStr(DTOS(M->TJ_DTMRFIM),5,2) + "-" + ;
	               SubStr(DTOS(M->TJ_DTMRFIM),7,2)

	Local cToken := "qazpKAd7XUY1RR6mr2PEuxOfKcir2RlmsPSd9rRrJI0w8TzkvvMQ5YMKtdZErhYY"

	// Headers
	AAdd(aHeader, "Content-Type: application/json")
	AAdd(aHeader, "Accept: application/json")
	AAdd(aHeader, "User-Agent: Protheus")

	// Endpoint
	oRestClient:SetPath("/api/v2/integracao/public/horimetro_proteus")

	// Body JSON
	cBody := ;
	'{' + ;
	'"data_manutencao":"' + cData + '",' + ;
	'"cod_equipamento":"' + cCodEquip + '",' + ;
	'"token":"' + cToken + '"' + ;
	'}'

	oRestClient:SetPostParams(cBody)

	// POST
	If oRestClient:Post(aHeader)

		cResultado := oRestClient:GetResult()

		ShowLog("Sucesso integração: " + cResultado)

	Else

		cErro := oRestClient:GetLastError()

		ShowLog("Erro integração: " + cErro)

	EndIf

	FWRestArea(aArea)

Return cResultado
