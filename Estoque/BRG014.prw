#include 'protheus.ch'
#INCLUDE "topconn.ch"
#include 'parmtype.ch'
#Include "RwMake.CH"
#INCLUDE "TBICONN.CH"


User function BRG014()

	Private _Op := ""
	Private _total := 0
	Private cPerg       := PADR("BRG014",Len(SX1->X1_GRUPO))
	Private aFilho   := {}
	//Private cMsg1   := "Produtos que estão selecionados na OP e possuem estrutura "
	Private cMsg1   := "Produtos que estão selecionados na OP e não possuem estrutura: "
	Private cMsg2   := "Produtos que possuem estrutura e não estão selecionados na OP: "
	Private aObs   := {}
//Chama relatorio personalizado
	ValidPerg1()
	pergunte(cPerg,.T.)    // sem tela de pergunta

	oReport := ReportDef1() // Chama a funcao personalizado onde deve buscar as informacoes
	oReport:PrintDialog()  // Cria a tela de parametros no modo personalizado apos buscar as informacoes

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³ Ricardo Fiuza      º Data ³  28/07/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³A funcao estatica ReportDef devera ser criada para todos os º±±
±±º          ³relatorios que poderao ser agendados pelo usuario.          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef1() //Cria o Cabeçalho em excel

	Local oReport, oSection, oBreak, oSection2

	cTitulo := "Relatorio De OP - " + CVALTOCHAR(MV_PAR01) + " a " +CVALTOCHAR(MV_PAR02)

	oReport  := TReport():New("BRG014",cTitulo,"BRG014",{|oReport| PrintReport1(oReport)},cTitulo)
//oReport:SetLandscape() // Paisagem
	oReport:SetPortrait()    // Retrato
	oSection := TRSection():New(oReport,"Relatorio De OP"," ", NIL, .F., .T.)
	TRCell():New(oSection, "CEL01_OP"        , "SD3", "Num. OP"        ,PesqPict("SD3","D3_OP"        ),15                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection, "CEL02_PRODUTO"   , "SB1", "Produto"        ,PesqPict("SB1","B1_DESC"      ),40                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection, "CEL03_QUANT"     , "SC2", "Quantidade"     ,PesqPict("SC2","C2_QUANT"     ),12                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection, "CEL04_EMISSAO"   , "SC2", "Emissão"        ,PesqPict("SC2","C2_DATPRI"    ),14                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection, "CEL05_VALOR"     , "SD3", "Custo"          ,PesqPict("SD3","D3_CUSTO1"    ),12                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection, "CEL06_HORA"      , "SH6",  "Horas"         ,PesqPict("SH6","H6_TEMPO"     ),12                  , /*lPixel*/, /* Formula*/)

	oSection2:= TRSection():New(oReport, "Itens Antendimentos da OP", {"TEMP"}, NIL, .F., .T.)
	TRCell():New(oSection2, "CEL01_OP"       , "SD3", "Num. OP"        ,PesqPict("SD3","D3_OP"        ),14                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL02_CODPRO"   , "SD3", "Produto"        ,PesqPict("SD3","D3_COD"       ),10                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL03_DESCRI"   , "SB1", "Descrição"      ,PesqPict("SB1","B1_DESC"      ),30                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL04_QUANT"    , "SD3", "Quant"          ,PesqPict("SD3","D3_QUANT"     ),12                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL05_VALOR"    , "SD3", "Custo Unit"     ,PesqPict("SD3","D3_CUSTO1"    ),12                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL06_TOTAL"    , "SD3", "Total Custo"    ,PesqPict("SD3","D3_CUSTO1"    ),12                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL07_DOCUM"    , "SD3", "Documento"      ,PesqPict("SD3","D3_DOC"       ),10                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL08_EMISSAO"  , "SD3", "Emissão"        ,PesqPict("SD3","D3_EMISSAO"   ),12                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL09_SOLIC"    , "SD3", "Solicitação"    ,PesqPict("SD3","D3_NUMSA"     ),06                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL10_LOTE"     , "SD3", "Lote"           ,PesqPict("SD3","D3_LOTECTL"   ),15                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL11_PORCPI"   , "SD3", "Porc PI(%)"     , 							   ,08                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL12_PORCPA"   , "SD3", "Porc PA(%)"     , 							   ,08                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection2, "CEL13_CODPAI"   , "SG1", "Produto Pai"    ,                               ,15                 , /*lPixel*/, /* Formula*/)


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrintReportºAutor  ³ rICARDO     º Data ³  28/05/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³A funcao estatica PrintReport realiza a impressao do relato-º±±
±±º          ³rio                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrintReport1(oReport)

	Local oSection := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local _nTot   := 0
	Local _nTotDev := 0
	Local _nTotPi := 0
	Local nX
	Local nY
	Local cFilho := ""
	LOCAL nTotalMinutos := 0
	LOCAL cTempoItem := ""
	LOCAL nHoras := 0
	LOCAL nMinutos := 0
	LOCAL nTotalHoras := 0
	LOCAL nTotalMinutosRestantes := 0
	LOCAL nPosSeparador := 0

	Private _Prod    := " "
	Private aDados[06]
	Private aDados2[14]
	Private aDados3[05]
	Private wLin      := 0
	Private aDet      := {}
	Private aTot      := {}
	Private aPvTot    := {}
	Private aDeTot    := {}
	Private aBaTot    := {}
	Private _cObs     := ""
	Private cQuery    := ""
	Private aQuant    := {}
	Private aDtEmiss  := {}
	Private aCusto    := {}
	Private _cQry     := ""
	Private aCod      := {}
	Private _cCod     := ""
	Private aCodValid := {}
	Private _cComp    := ""
	Private aCod2     := {}
	Private cProduto  := ''
	Private cQry      := ''
	Private cHoraini  := ''
	Private cHorafim  := ''
	Private cHora     := ''
	Private cTempo    := ''

	oSection:Cell("CEL01_OP"       ):SetBlock( { || aDados[01]})
	oSection:Cell("CEL02_PRODUTO"  ):SetBlock( { || aDados[02]})
	oSection:Cell("CEL03_QUANT"    ):SetBlock( { || aDados[03]})
	oSection:Cell("CEL04_EMISSAO"  ):SetBlock( { || aDados[04]})
	oSection:Cell("CEL05_VALOR"    ):SetBlock( { || aDados[05]})
	oSection:Cell("CEL06_HORA"     ):SetBlock( { || aDados[06]})

	oSection2:Cell("CEL01_OP"      ):SetBlock( { || aDados2[01]})
	oSection2:Cell("CEL02_CODPRO"  ):SetBlock( { || aDados2[02]})
	oSection2:Cell("CEL03_DESCRI"  ):SetBlock( { || aDados2[03]})
	oSection2:Cell("CEL04_QUANT"   ):SetBlock( { || aDados2[04]})
	oSection2:Cell("CEL05_VALOR"   ):SetBlock( { || aDados2[05]})
	oSection2:Cell("CEL06_TOTAL"   ):SetBlock( { || aDados2[06]})
	oSection2:Cell("CEL07_DOCUM"   ):SetBlock( { || aDados2[07]})
	oSection2:Cell("CEL08_EMISSAO" ):SetBlock( { || aDados2[08]})
	oSection2:Cell("CEL09_SOLIC"   ):SetBlock( { || aDados2[09]})
	oSection2:Cell("CEL10_LOTE"    ):SetBlock( { || aDados2[10]})
	oSection2:Cell("CEL11_PORCPI"  ):SetBlock( { || aDados2[11]})
	oSection2:Cell("CEL12_PORCPA"  ):SetBlock( { || aDados2[12]})
	oSection2:Cell("CEL13_CODPAI"  ):SetBlock( { || aDados2[13]})

	oBreak := TRBreak():New(oSection2,oSection2:Cell("CEL01_OP"),,.F.)
	TRFunction():New(oSection2:Cell("CEL06_TOTAL") ,"TOT","SUM",oBreak,"","@E 999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection2:Cell("CEL11_PORCPI") ,"TOT","SUM",oBreak,"","@E 999.999",,.F.,.F.)
	TRFunction():New(oSection2:Cell("CEL12_PORCPA") ,"TOT","SUM",oBreak,"","@E 999.999",,.F.,.F.)

	oReport:IncMeter()
	oReport:NoUserFilter()
	oSection:Init()

	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf

	cQuery := " "
	cQuery += "SELECT DISTINCT D3_FILIAL, D3_CF,D3_TM, D3_COD, B1_DESC, D3_TIPO,D3_UM, D3_OP,C2_PRODUTO,C2_QUANT,C2_DATPRI, D3_DOC,D3_LOTECTL,D3_LOCAL, D3_NUMSA,D3_EMISSAO,D3_QUANT, D3_CUSTO1, ROUND((D3_CUSTO1/D3_QUANT),2) Custo "
	cQuery += "FROM " + retsqlname("SD3")+" SD3 "
	cQuery += "LEFT JOIN " + retsqlname("SC2")+ " SC2 ON D3_FILIAL = C2_FILIAL AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ <> '*' "
	cQuery += "LEFT JOIN " + retsqlname("SB1")+ " SB1 ON D3_COD = B1_COD AND SB1.D_E_L_E_T_ <> '*' "
	cQuery += "WHERE SD3.D_E_L_E_T_ <> '*' "
	cQuery += "AND D3_CF IN ('RE6','DE0','DE6','RE0') "
	cQuery += "AND D3_ESTORNO <> 'S' "
	cQuery += "AND B1_FILIAL = '" + substr(cFilAnt,1,2)+ "' "
	cQuery += "AND SD3.D3_OP BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
	cQuery += "ORDER BY  D3_OP, D3_TM,D3_COD "

	cQuery := ChangeQuery(cQuery)
	TcQuery cQuery New Alias "TMP"

	If Select("TSH6") > 0
		TSH6->(dbCloseArea())
	EndIf

	cQry := "SELECT * FROM "+retsqlname("SH6")+" SH6 "
	cQry += "WHERE H6_OP BETWEEN '" +mv_par01+ "' AND '" +mv_par02+ "' "
	cQry += "AND D_E_L_E_T_ <> '*' "

	cQry := ChangeQuery(cQry)
	TcQuery cQry New Alias "TSH6" //consulta SH6 para descobrir horas gastas na produção da OP

	dbselectarea("TSH6")
	TSH6->(DBGOTOP())
	Do While !TSH6->(EOF())
		// Capturar o valor do campo H6_TEMPO
		cTempoItem := TSH6->H6_TEMPO

		// Encontrar a posição do separador ":"
		nPosSeparador := At(":", cTempoItem)

		// Separar horas e minutos
		nHoras := Val(SubStr(cTempoItem, 1, nPosSeparador - 1))
		nMinutos := Val(SubStr(cTempoItem, nPosSeparador + 1, 2))

		// Converter tudo para minutos
		nTotalMinutos += (nHoras * 60) + nMinutos

		TSH6->(DbSkip())
	EndDo

	//Converte para horas
	nTotalHoras := Int(nTotalMinutos / 60)
	nTotalMinutosRestantes := nTotalMinutos % 60

	TSH6->(DbCloseArea())

	dbselectarea("TMP")
	TMP->(DBGOTOP())
	DO WHILE !TMP->(EOF())

		If oReport:Cancel()
			Exit
		EndIf

		//oSection:init()
		_Op := TMP->D3_OP
		_DESC := POSICIONE("SB1",1,XFILIAL("SB1")+TMP->C2_PRODUTO,"B1_DESC")
		_Qtde := POSICIONE("SC2",1,XFILIAL("SC2")+TMP->D3_OP,"C2_QUANT")

		aDados[01] := TMP->D3_OP
		aDados[02] := ALLTRIM(TMP->C2_PRODUTO)  +" / "+ _DESC
		aDados[03] := _Qtde
		aDados[04] := CVALTOCHAR(STOD(TMP->C2_DATPRI))
		If SUBSTR(TMP->D3_OP,7,5) = "01001"
			//   CustoPi := TotOpPi() TotOpPri() - TotGerD()
			aDados[05] := TotGerC() - TotGerD() //AllTrim(Transform((SCUSTO()), "@ze 9,999,999,999,999.99"))  //SCUSTO()
		Else
			aDados[05] := SCUSTO() - SCUSTD() //AllTrim(Transform((SCUSTO()), "@ze 9,999,999,999,999.99"))  //SCUSTO()
		EndIf

		cProduto := ALLTRIM(TMP->C2_PRODUTO)

		aDados[06] := StrZero(nTotalHoras, 3) + ":" + StrZero(nTotalMinutosRestantes, 2)//horas gastas para produzir OP

		oSection:Printline()
		oSection:Finish()



		oSection2:Init()

		If Select("TMP2") > 0
			TMP2->(dbCloseArea())
		EndIf

		cQuery := "SELECT DISTINCT SG1.G1_FILIAL, SG1.G1_COD, SG1.G1_COMP "
		cQuery += "FROM " + retsqlname("SG1")+" SG1 "
		cQuery += "LEFT JOIN " + retsqlname("SC2")+ " SC2 ON C2_FILIAL = G1_FILIAL AND C2_PRODUTO = G1_COD AND SC2.D_E_L_E_T_ = '' "
		cQuery += "WHERE SG1.D_E_L_E_T_= '' "
		cQuery += "AND G1_COD = '"+cProduto+"' "
		cQuery += "GROUP BY SG1.G1_FILIAL, SG1.G1_COD, SG1.G1_COMP "

		cQuery := ChangeQuery(cQuery)
		TcQuery cQuery New Alias "TMP2"//filtra todos os produtos e seus complementos

		dbselectarea("TMP2")
		TMP2->(DBGOTOP())
		Do While !TMP2->(EOF())//percorre toda tabela e adiciona os complementos no array
			aAdd(aFilho,TMP2->G1_COMP)
			TMP2->(DbSkip())
		EndDo

		cFilho := ArrTokStr(aFilho, ";") //realiza quebra do array

		TMP2->(DbCloseArea())

		DO WHILE TMP->D3_OP == _Op .AND. XFILIAL("SD3") == TMP->D3_FILIAL

			_Prod := TMP->D3_COD

			//If TMP->D3_TM = "003"
			//  TMP->(dbskip())
			// 	LOOP
			//EndIF
			//If SUBSTR(TMP->D3_OP,7,5) = "01001"
			If TMP->D3_CF $ "RE0/RE6" .and. SUBSTR(TMP->D3_OP,7,5) = "01001" //.and. TMP->D3_TIPO = "PI"
				_nTot      := _nTot + TMP->D3_CUSTO1
			ELSEIf TMP->D3_CF $ "RE0/RE6" .and. SUBSTR(TMP->D3_OP,7,5) <> "01001"
				_nTotPi    := _nTotPi + TMP->D3_CUSTO1
			ELSEIf TMP->D3_CF $ "DE0/DE6"
				_nTotDev   := _nTotDev + TMP->D3_CUSTO1
			EndIf

			aDados2[01] := TMP->D3_OP
			aDados2[02] := TMP->D3_COD
			aDados2[03] := TMP->B1_DESC
			aDados2[04] := IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_QUANT*-1), TMP->D3_QUANT)
			aDados2[05] := TMP->CUSTO
			aDados2[06] := IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_CUSTO1*-1), TMP->D3_CUSTO1)
			aDados2[07] := TMP->D3_DOC
			aDados2[08] := CVALTOCHAR(STOD(TMP->D3_EMISSAO))
			aDados2[09] := TMP->D3_NUMSA
			aDados2[10] := TMP->D3_LOTECTL
			aDados2[11] := ROUND((IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_CUSTO1*-1), TMP->D3_CUSTO1)*100)/( SCUSTO() - SCUSTD()),6)
			If SUBSTR(TMP->D3_OP,7,5) = "01001"
				aDados2[12] := ROUND((IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_CUSTO1*-1), TMP->D3_CUSTO1)*100)/( SCUSTO() - SCUSTD()),6)
			Else
				aDados2[12] := ROUND((IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_CUSTO1*-1), TMP->D3_CUSTO1)*100)/( TotGerC() - TotGerD()),6)
			EndIf

			If !Empty(cFilho) .AND. TMP->D3_COD $ cFilho//se o array não estiver vazio e o códio estiver contido na estrutura, imprime o produto na coluna cod. pai
				aDados2[13] := TMP->C2_PRODUTO
				aAdd(aCod,TMP->D3_COD) //adiciona todos os códigos de produto ao array
			Else //se o código não estiver no array significa que não pertence a estrutura
				aDados2[13] := "--------"
				aAdd(aObs,Alltrim(TMP->D3_COD))
				aAdd(aQuant,IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_QUANT*-1), TMP->D3_QUANT))
				aAdd(aDtEmiss,CVALTOCHAR(STOD(TMP->D3_EMISSAO)))
				aAdd(aCusto,IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_CUSTO1*-1), TMP->D3_CUSTO1)) //grava os dados pra imprimir no final
			EndIf

			oSection2:PrintLine()  // Imprime linha de detalhe
			aFill(aDados,nil)     // Limpa o array a dados

			dbselectarea("TMP")
			TMP->(dbSkip())
		ENDDO

		oSection2:Finish()
		oReport:SkipLine()
		oReport:IncMeter()
	ENDDO

	oSection:Finish()
	oReport:SkipLine()
	oReport:IncMeter()

	_cObs := ArrTokStr(aObs, ";") //realiza quebra do array
	_cCod := ArrTokStr(aCod, ";") //realiza quebra do array

	oReport:SkipLine(2) //TotOpPri() - TotGerD()    //CustoPi   TotOpPri() - TotGerD()
	oReport:Say(oReport:Row(),10,"Valor Total Requisições...: " + AllTrim(Transform((_nTot), "@ze 9,999,999,999,999.99")))
	oReport:SkipLine(2)
	oReport:Say(oReport:Row(),10,"Valor Total Devoluções....: " + AllTrim(Transform(_nTotDev, "@ze 9,999,999,999,999.99")))
	oReport:SkipLine(2)
	oReport:Say(oReport:Row(),10,"Valor Total (-Devoluções).: " + AllTrim(Transform((_nTot-_nTotDev), "@ze 9,999,999,999,999.99")))

	oReport:SkipLine(5)

	If !(Empty(cMsg1)) .AND. _cObs <> "" //se existir produtos sem estrutura, imprime observações

		oReport:Say(oReport:Row(),10,"Observações: ")
		oReport:SkipLine(3)
		oReport:Say(oReport:Row(),10, cMsg1 )
		oReport:SkipLine(2)
	Else
		oReport:Say(oReport:Row(),10,"")
		oReport:SkipLine(2)
	EndIf

	oReport:SetPortrait()    // colunas da observação referente à estrutura
	oSection := TRSection():New(oReport,"Relatorio De OP"," ", NIL, .F., .T.)
	TRCell():New(oSection, "CEL01_OP"        , "SD3", "Num. OP"        ,PesqPict("SD3","D3_OP"        ),14                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection, "CEL02_PRODUTO"   , "SB1", "Produto"        ,PesqPict("SB1","B1_DESC"      ),40                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection, "CEL03_QUANT"     , "SC2", "Quantidade"     ,PesqPict("SC2","C2_QUANT"     ),12                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection, "CEL04_EMISSAO"   , "SC2", "Emissão"        ,PesqPict("SC2","C2_DATPRI"    ),14                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection, "CEL05_VALOR"     , "SD3", "Custo"          ,PesqPict("SD3","D3_CUSTO1"    ),12                  , /*lPixel*/, /* Formula*/)

	oSection:Cell("CEL01_OP"       ):SetBlock( { || aDados3[01]})
	oSection:Cell("CEL02_PRODUTO"  ):SetBlock( { || aDados3[02]})
	oSection:Cell("CEL03_QUANT"    ):SetBlock( { || aDados3[03]})
	oSection:Cell("CEL04_EMISSAO"  ):SetBlock( { || aDados3[04]})
	oSection:Cell("CEL05_VALOR"    ):SetBlock( { || aDados3[05]})

	oReport:IncMeter()
	oReport:NoUserFilter()
	oSection:Init()

	dbselectarea("TMP")
	TMP->(DBGOTOP())
	DO WHILE !TMP->(EOF()) //percorre a tabela temporária até encontrar registros sem estrutura
		If Alltrim(TMP->D3_COD) $ _cObs //se encontrar, printa a informações contidas nos array's alimentados na query anterior 
			For nX := 1 To Len(aObs) //códigos que não pertencem a estrutura 
				_DESC := POSICIONE("SB1",1,XFILIAL("SB1")+aObs[nX],"B1_DESC")
				aDados3[01] := TMP->D3_OP
				aDados3[02] := aObs[nX] +" / "+ _DESC
				aDados3[03] := aQuant[nX]
				aDados3[04] := aDtEmiss[nX]
				aDados3[05] := aCusto[nX]

				oSection:Printline()
			Next
			Exit //após executar todos os itens dos array's, sai do while
		EndIf
		TMP->(dbSkip()) //while só é necessário até encontrar um produto sem estrutura, após encontrar entra no FOR e executa todos os produtos sem estrutura
	EndDo


	oSection:Finish()
	oReport:SkipLine()
	oReport:IncMeter()

	oReport:SkipLine(5)

	If !(Empty(cMsg2)) .AND. _cCod <> "" //se existir produtos com estrutura que não estão na OP, imprime observações

		oReport:Say(oReport:Row(),10, cMsg2 )
		oReport:SkipLine(2)
	Else
		oReport:Say(oReport:Row(),10,"")
		oReport:SkipLine(2)
	EndIf

	oReport:SetPortrait()    // colunas da observação referente à estrutura
	oSection := TRSection():New(oReport,"Relatorio De OP"," ", NIL, .F., .T.)
	TRCell():New(oSection, "CEL01_PRODUTO PAI"   , "SB1", "Produto Pai"        ,PesqPict("SB1","B1_DESC"      ),12                  , /*lPixel*/, /* Formula*/)
	TRCell():New(oSection, "CEL02_COMPLEMENTO"     , "SB1", "Produto"          ,PesqPict("SB1","B1_DESC"      ),40                  , /*lPixel*/, /* Formula*/)

	oSection:Cell("CEL01_PRODUTO PAI"  ):SetBlock( { || aDados[01]})
	oSection:Cell("CEL02_COMPLEMENTO"  ):SetBlock( { || aDados[02]})

	oReport:IncMeter()
	oReport:NoUserFilter()
	oSection:Init()

	If Select("TMP1") > 0
		TMP1->(dbCloseArea())
	EndIf

	_cQry:= ""
	_cQry += "SELECT DISTINCT D3_FILIAL, D3_CF,D3_TM, D3_COD,ISNULL(G1_COMP,'')G1_COMP, B1_DESC, D3_TIPO,D3_UM, D3_OP,C2_PRODUTO,C2_QUANT,C2_DATPRI, D3_DOC,D3_LOTECTL,D3_LOCAL, D3_NUMSA,D3_EMISSAO,D3_QUANT, D3_CUSTO1, ROUND((D3_CUSTO1/D3_QUANT),2) Custo "
	_cQry += "FROM " + retsqlname("SD3")+" SD3 "
	_cQry += "LEFT JOIN " + retsqlname("SC2")+ " SC2 ON D3_FILIAL = C2_FILIAL AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ <> '*' "
	_cQry += "LEFT JOIN " + retsqlname("SB1")+ " SB1 ON D3_COD = B1_COD AND SB1.D_E_L_E_T_ <> '*' "
	_cQry += "LEFT JOIN SG1010 SG1 ON D3_COD = G1_COD AND SG1.D_E_L_E_T_ <> '*' "
	_cQry += "WHERE SD3.D_E_L_E_T_ <> '*' "
	_cQry += "AND D3_CF IN ('RE6','DE0','DE6','RE0') "
	_cQry += "AND D3_ESTORNO <> 'S' "
	_cQry += "AND B1_FILIAL = '" + substr(cFilAnt,1,2)+ "' "
	_cQry += "AND SD3.D3_OP BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
	_cQry += "AND G1_COMP <> '' "
	_cQry += "ORDER BY  D3_OP, D3_TM,D3_COD "

	_cQry := ChangeQuery(_cQry)
	TcQuery _cQry New Alias "TMP1" //busca todos os complementos da OP de acordo com a estrutura dos produtos 

	dbselectarea("TMP1")
	TMP1->(DBGOTOP())
	DO WHILE !TMP1->(EOF())
		If !(TMP1->G1_COMP $ _cCod)  //valida se complementos filtrados na G1 estão na OP detalhada, caso não estejam serão impressos
			aAdd(aCodValid,TMP1->G1_COMP)//complementos
			aAdd(aCod2,TMP1->D3_COD)//produto pai
		EndIf

		TMP1->(dbSkip())
	EndDo

	_cComp := ArrTokStr(aCodValid, ";") //realiza quebra do array

	dbselectarea("TMP1")
	TMP1->(DBGOTOP())
	DO WHILE !TMP1->(EOF()) //percorre a tabela temporária
		For nY := 1 To Len(aCodValid) //todos os complementos que pertencem a estrutura e não estão na OP
			_DESC := POSICIONE("SB1",1,XFILIAL("SB1")+aCodValid[nY],"B1_DESC")
			aDados[01] := aCod2[nY]
			aDados[02] := Alltrim(aCodValid[nY]) +" / "+ _DESC

			oSection:Printline()
		Next
		Exit //após executar todos os itens dos array's, sai do while
		TMP1->(dbSkip()) //while só é necessário até encontrar um produto sem estrutura, após encontrar entra no FOR e executa todos os produtos sem estrutura
	EndDo

	oSection:Finish()
	oReport:SkipLine()
	oReport:IncMeter()

	If Select("TMP1") > 0
		TMP1->(dbCloseArea())
	EndIf

/*
IF CustoPi = 0 
oReport:Say(oReport:Row(),10,"Valor Total Requisições...: " + AllTrim(Transform(TotOpReq(), "@ze 9,999,999,999,999.99"))) 
Else
oReport:Say(oReport:Row(),10,"Valor Total Requisições...: " + AllTrim(Transform(TotOpPi(), "@ze 9,999,999,999,999.99"))) 
EndIf

oReport:SkipLine(2) 
oReport:Say(oReport:Row(),10,"Valor Total Devoluções....: " + AllTrim(Transform(TotGerD(), "@ze 9,999,999,999,999.99")))
oReport:SkipLine(2)
IF CustoPi = 0  
oReport:Say(oReport:Row(),10,"Valor Total (-Devoluções).: " + AllTrim(Transform((TotOpReq() - TotGerD()), "@ze 9,999,999,999,999.99"))) 
Else
oReport:Say(oReport:Row(),10,"Valor Total (-Devoluções).: " + AllTrim(Transform((TotOpPi() - TotGerD()), "@ze 9,999,999,999,999.99"))) 
EndIf
*/
Return



//Retorna o VAlor da Op

Static Function SCUSTO()
//Verifica se o arquivo TMP está em uso

	Local _Custo := ""
	If Select("TTMP") > 0
		TTMP->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL, D3_OP,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' "
	ccQry += "AND  D3_CF IN ('RE6','RE0') "    //D3_CF IN ('RE6','DE0','DE6','RE0')
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "
	ccQry += "AND  D3_OP = '" + _Op + "' "
	ccQry += "GROUP BY D3_FILIAL, D3_OP "


	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTMP",.T.,.T.)

	_Custo := TTMP->Custo1

Return _Custo


Static Function SCUSTD()
//Verifica se o arquivo TMP está em uso

	Local _CustoD := ""
	If Select("QTMP") > 0
		QTMP->(DbCloseArea())
	EndIf
	cQry := " "
	cQry += "SELECT D3_FILIAL, D3_OP,SUM(D3_CUSTO1) Custo2 "
	cQry += "FROM " + retsqlname("SD3")+" SD3 "
	cQry += "WHERE SD3.D_E_L_E_T_ <> '*' "
	cQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	cQry += "AND  D3_CF IN ('DE0','DE6') "
	cQry += "AND  D3_ESTORNO <> 'S' "
	cQry += "AND  D3_OP = '" + _Op + "' "
	cQry += "GROUP BY D3_FILIAL, D3_OP "


	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"QTMP",.T.,.T.)

	_CustoD := QTMP->Custo2

Return _CustoD

//FIM FUNCOES PARA IMPRESSAO - EXCEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao das perguntas dos parametros                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ValidPerg1
	Local aArea    := GetArea()
	Local aRegs    := {}
	Local i	       := 0
	Local j        := 0
	Local aHelpPor := {}
	Local aHelpSpa := {}
	Local aHelpEng := {}

	aAdd(aRegs,{cPerg,"01","OS De         ?","","","mv_ch1","C",14,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SC2"})
	aAdd(aRegs,{cPerg,"02","OS Ate        ?","","","mv_ch2","C",14,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SC2"})

	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:=1 to Len(aRegs)
		If !DbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()

			aHelpPor := {} ; aHelpSpa := {} ; 	aHelpEng := {}
			If i==1
				AADD(aHelpPor,"OS De  ?              ")
			ElseIf i==2
				AADD(aHelpPor,"OS Ate ?              ")
			Endif
			PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
		EndIf
	Next

	RestArea(aArea)
Return

//Retorna o VAlor da Op

Static Function TotGerC()
//Verifica se o arquivo TMP está em uso

	Local _Custo := ""
	If Select("TTMP") > 0
		TTMP->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' "
	ccQry += "AND  D3_CF IN ('RE6','RE0') "    //D3_CF IN ('RE6','DE0','DE6','RE0')
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "
	//ccQry += "AND  D3_OP LIKE '" + substr(_Op,1,6) + "%' "
	ccQry += "AND  D3_OP = '" + _Op + "' "
	ccQry += "GROUP BY D3_FILIAL "


	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTMP",.T.,.T.)

	_Custo := TTMP->Custo1

	//
Return _Custo


Static Function TotGerD()
//Verifica se o arquivo TMP está em uso

	Local _CustoD := ""
	If Select("QTMP") > 0
		QTMP->(DbCloseArea())
	EndIf
	cQry := " "
	cQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo2 "
	cQry += "FROM " + retsqlname("SD3")+" SD3 "
	cQry += "WHERE SD3.D_E_L_E_T_ <> '*' "
	cQry += "AND  D3_CF IN ('DE0','DE6') "
	cQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	cQry += "AND  D3_ESTORNO <> 'S' "
	cQry += "AND  D3_OP LIKE'" + substr(_Op,1,6) + "%' "
	cQry += "GROUP BY D3_FILIAL "


	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"QTMP",.T.,.T.)

	_CustoD := QTMP->Custo2

Return _CustoD

Static Function TotOpPri()
//Verifica se o arquivo TMP está em uso

	Local _CPrinc := ""
	If Select("TTMM") > 0
		TTMM->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' "
	ccQry += "AND  D3_CF IN ('RE6','RE0') "    //D3_CF IN ('RE6','DE0','DE6','RE0')
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "
	ccQry += "AND  D3_TM ='501' "
	ccQry += "AND  D3_OP LIKE '" + substr(_Op,1,6) + "%' "
	//ccQry += "AND  D3_OP = '" + _Op + "' "
	ccQry += "GROUP BY D3_FILIAL "


	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTMM",.T.,.T.)

	_CPrinc := TTMM->Custo1

	//
Return _CPrinc

Static Function TotOpReq()
//Verifica se o arquivo TMP está em uso

	Local _CPReq := ""

	If Select("TTMR") > 0
		TTMR->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' "
	ccQry += "AND  D3_CF IN ('RE6','DE0','DE6','RE0') "    //D3_CF IN ('RE6','DE0','DE6','RE0')    //('RE6','RE0')
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "
	ccQry += "AND  D3_OP LIKE '" + substr(_Op,1,6) + "%' "
	//ccQry += "AND  D3_OP = '" + _Op + "' "
	ccQry += "GROUP BY D3_FILIAL "


	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTMR",.T.,.T.)

	_CPrinc := TTMR->Custo1

	//
Return _CPReq


Static Function TotOpPi()
//Verifica se o arquivo TMP está em uso

	Local _CPReqPi := ""

	If Select("TTPI") > 0
		TTPI->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' "
	ccQry += "AND  D3_CF IN ('RE6','RE0') "    //D3_CF IN ('RE6','DE0','DE6','RE0')    //('RE6','RE0')
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "
	ccQry += "AND  D3_TIPO = 'PI' "
	//ccQry += "AND  D3_OP LIKE '" + substr(_Op,1,6) + "%' "
	ccQry += "AND  D3_OP = '" + _Op + "' "
	ccQry += "GROUP BY D3_FILIAL "


	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTPI",.T.,.T.)

	_CPReqPi := TTPI->Custo1

	//
Return _CPReqPi





