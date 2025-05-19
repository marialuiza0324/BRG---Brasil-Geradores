//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFUL.CH"


WSRESTFUL WSRESTPROD DESCRIPTION "Serviço rest para manipulação de produtos"

	WSDATA CODPRODUTO AS String

	WSMETHOD GET buscarproduto DESCRIPTION "Retorna dados do Produto" WSSYNTAX "/buscarproduto" PATH "buscarproduto" PRODUCES APPLICATION_JSON

ENDWSRESTFUL

WSMETHOD GET buscarproduto WSRECEIVE CODPRODUTO WSREST WSRESTPROD

    Local lRet := .T.
    Local cCodProd := Self:CODPRODUTO
    Local aArea := GetArea()
    Local oJson := JsonObject():New()
    Local cJson :=  ""
    Local oReturn
    Local cReturn
    Local aProd := {}
    Local cStatus := ""
    Local cGrupo  := ""

    SB1->(DbSelectArea("SB1"))
    SB1->(DbSetOrder(1))

    If SB1->(dbSeek(xFilial("SB1")+cCodProd))

        cStatus := IIF(SB1->B1_MSBLQL == "1","Bloqueado","Desbloqueado")
        cGrupo  := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,'BM_DESC')

        AAdd(aProd,JsonObject():New())
        aProd[1]['prodcode']        := Alltrim(SB1->B1_COD)
        aProd[1]['proddesc']        := Alltrim(SB1->B1_DESC)
        aProd[1]['produm']          := Alltrim(SB1->B1_UM)
        aProd[1]['prodtipo']        := Alltrim(SB1->B1_TIPO)
        aProd[1]['prodncm']         := Alltrim(SB1->POSIPI)
        aProd[1]['prodgrupo']       := cGrupo
        aProd[1]['prodstatus']      := cStatus

        oReturn := JsonObject():New()
        oReturn['cRet'] := "200"
        oReturn['cmessage']:= "Produto encontrado com sucesso!"
        cReturn := FwJsonSerialize(oReturn)
        oJson["produtos"] := aProd

        cJson := FwJsonSerialize(oJson)

        ::SetResponse(cJson)

    Else

        oReturn := JsonObject():New()
        oReturn['prodcod'] := cCodProd
        oReturn['cmessage'] := "Código do produto não encontrado na base de dados"

    EndIf

    SB1->(DbCloseArea())

    RestArea(aArea)

    FreeObj(oJson)
    FreeObj(oReturn)

RETURN lRet
