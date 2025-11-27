#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#include 'TBICONN.CH'
#include 'PRTOPDEF.CH'

/*/{Protheus.doc} FA050B01
    Será executado após a confirmação da exclusão 
    e antes da própria exclusão de contabilização.
    Utilizado para estornar baixa do titulo tipo NF
    quando for realizada a exclusão do título tipo FAT
    (criado pela API do Coutinho).
    @type  Function
    @author Maria Luiza
    @since 24/11/2025
    /*/

User Function FA050B01()

	Local cTipo := "NF"
	Local cNum := M->E2_NUM
	Local cParcela := M->E2_PARCELA
	Local cQry := ""
	Local lMsErroAuto := .F.
	Local nTotal := 0
	Local cFil  := ""
	Local cPrefixo := ""
	Local cFornece := ""
	Local cLoja := ""
	Local cNaturez := ""
	Local aBaixa := {}
	Local dBaixa 
	Local nValor := 0.0

	If Select("TSE2") > 0
		TSE2->(dbCloseArea())
	EndIf


	cQry := "SELECT * "
	cQry += "FROM " + retsqlname("SE2") + " SE2 "
	cQry += "WHERE SE2.D_E_L_E_T_ <> '*' "
	cQry += "AND SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
	cQry += "AND SE2.E2_TIPO = '" + cTipo + "' "
	cQry += "AND SE2.E2_NUM = '" + cNum + "' "
	cQry += "AND SE2.E2_PARCELA = '" + cParcela + "' "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TSE2",.T.,.T.) //filtrando titulo na SE2

	DbSelectArea("TSE2")

	cFil := TSE2->E2_FILIAL
	cPrefixo := TSE2->E2_PREFIXO
	cNum := TSE2->E2_NUM
	cParcela := TSE2->E2_PARCELA
	cTipo := TSE2->E2_TIPO
	cFornece := TSE2->E2_FORNECE
	cLoja := TSE2->E2_LOJA
	cNaturez := TSE2->E2_NATUREZ
	dBaixa := stod(TSE2->E2_BAIXA)
	nValor := TSE2->E2_VALOR

	Count To nTotal

	If nTotal > 0

		aBaixa := {}

		Aadd(aBaixa, {"E2_FILIAL", cFil  , nil})
		aadd(aBaixa, {"E2_PREFIXO", cPrefixo, nil})
		aadd(aBaixa, {"E2_NUM"    , cNum    , nil})
		aadd(aBaixa, {"E2_PARCELA", cParcela, nil})
		aadd(aBaixa, {"E2_TIPO"   , cTipo   , nil})
		aadd(aBaixa, {"E2_FORNECE", cFornece, nil})
		aadd(aBaixa, {"E2_LOJA"   , cLoja   , nil})
		aadd(aBaixa, {"E2_NATUREZ" , cNaturez , nil})
		aadd(aBaixa, {"AUTMOTBX"  , "NOR"          , nil})
		aadd(aBaixa, {"AUTBANCO"  , ""          , nil})
		aadd(aBaixa, {"AUTAGENCIA", ""        , nil})
		aadd(aBaixa, {"AUTCONTA"  , ""      , nil})
		aadd(aBaixa, {"AUTDTBAIXA", dBaixa      , nil})
		aadd(aBaixa, {"AUTDTDEB"  , dBaixa      , nil})
		aadd(aBaixa, {"AUTHIST"   , "FATURA EMITIDA S/ TITULO" , nil})
		aadd(aBaixa, {"AUTTXMOEDA", 0       , nil})
		aadd(aBaixa, {"AUTVLRPG"  , nValor , nil})


		//Chama a execauto da rotina de baixa manual (FINA080)
		MsExecAuto({|x, y| FINA080(x, y)}, aBaixa, 5) //Operação 5 = Estorno de baixa

		If lMsErroAuto
			MostraErro()
		EndIf
	EndIf
Return
