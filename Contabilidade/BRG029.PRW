#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "topconn.ch"

//--------------------------------------------------------------
/*/{Protheus.doc} PHA029
Description

@param xParam RelatпїЅrio de Conferencia apos o Fechamento Total  
@return xRet Perlen
@author  -
@since 20/05/2020
/*/
//--------------------------------------------------------------


User function BRG029()
	
Private cPerg       := PADR("BRG029",Len(SX1->X1_GRUPO))
 
//Chama relatorio personalizado
ValidPerg1()
pergunte(cPerg,.T.)    // sem tela de pergunta

oReport := ReportDef1() // Chama a funcao personalizado onde deve buscar as informacoes
oReport:PrintDialog()  // Cria a tela de parametros no modo personalizado apos buscar as informacoes

Return

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅReportDef пїЅAutor  пїЅ Ricardo 		     пїЅ Data пїЅ  28/07/2010 пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅA funcao estatica ReportDef devera ser criada para todos os пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅrelatorios que poderao ser agendados pelo usuario.          пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
Static Function ReportDef1() //Cria o CabeпїЅalho em excel

Local oReport, oSection, oBreak

cTitulo := "Relatуrio de Conferencia de Fechamento"

oReport  := TReport():New("BRG029",cTitulo,"BRG029",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  

oReport:nfontbody:=8
oReport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatуrio de Analise de Dados p/ Fechamento Contabil",{""})
TRCell():New(oSection, "CEL01_FILIAL"       , "SB2", "Filial"              ,PesqPict("SB2","B2_FILIAL"   ),04                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_PRODUTO"      , "SB2", "Produto"             ,PesqPict("SB2","B2_COD"      ),10				    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_LOCAL"        , "SB2", "Local"               ,PesqPict("SB2","B2_LOCAL"    ),02				    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_TIPO"         , "SB1", "Tipo"                ,PesqPict("SB1","B1_TIPO"     ),02				    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_DESC"         , "SB1", "Descriзгo"           ,PesqPict("SB1","B1_DESC"     ),45                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_QTDATU"       , "SB2", "Qtd Atual"           ,PesqPict("SB2","B2_QATU"     ),16                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_CM1"          , "SB2", "Custo Unit"          ,PesqPict("SB2","B2_CM1"      ),16                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_TOTATU"       , "SB2", "Custo Total"         ,PesqPict("SB2","B2_VATU1"    ),16                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_QTDFECH"      , "SB9", "Qtd Mкs Anterior"    ,PesqPict("SB9","B9_QINI"     ),16                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_CUSTFECH"     , "SB9", "Cust Mкs Anterior"   ,PesqPict("SB9","B9_CM1"      ),16                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_TOTCUSTFECH"  , "SB9", "Total Mкs Anterior"  ,PesqPict("SB9","B9_VINI1"    ),16                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL12_QTDENTRADA"   , "SFT", "Qtd Entrada"         ,PesqPict("SFT","FT_QUANT"    ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL13_VLUNITENT"    , "SFT", "Vlr Unit Entrada"    ,PesqPict("SFT","FT_VALCONT"  ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL14_TOTENTRADA"   , "SFT", "Total Entrada"       ,PesqPict("SFT","FT_VALCONT"  ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL15_QTDSAIDA"     , "SFT", "Qtd Saida"           ,PesqPict("SFT","FT_QUANT"    ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL16_VLUNITSAI"    , "SFT", "Vlr Unit Saida"      ,PesqPict("SFT","FT_VALCONT"  ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL17_TOTSAIDA"     , "SFT", "Total Saida"         ,PesqPict("SFT","FT_VALCONT"  ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL18_QTDPROCES"    , "SD3", "Qtd em Processo"     ,PesqPict("SD3","D3_QUANT"    ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL19_VLRPROCES"    , "SD3", "Vl Unit Processo"    ,PesqPict("SD3","D3_CUSTO1"   ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL20_TOTPROCES"    , "SD3", "Total em Processo"   ,PesqPict("SD3","D3_CUSTO1"   ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL21_QTDPROD"      , "SD3", "Qtd Producao"        ,PesqPict("SD3","D3_QUANT"    ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL22_VLRPROD"      , "SD3", "Valor Unit Producao" ,PesqPict("SD3","D3_CUSTO1"   ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL23_TOTPROD"      , "SD3", "Total Producao"      ,PesqPict("SD3","D3_CUSTO1"   ),14                   , /*lPixel*/, /* Formula*/)


Return oReport

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅPrintReportпїЅAutor  пїЅ Ricardo Moreira   пїЅ Data пїЅ  28/05/2013 пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅA funcao estatica PrintReport realiza a impressao do relato-пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅrio                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
Static Function PrintReport1(oReport)

Local oSection := oReport:Section(1)
Private aDados[24]
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {} 

oSection:Cell("CEL01_FILIAL"       ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_PRODUTO"      ):SetBlock( { || aDados[02]}) 
oSection:Cell("CEL03_LOCAL"        ):SetBlock( { || aDados[03]}) 
oSection:Cell("CEL04_TIPO"         ):SetBlock( { || aDados[04]}) 
oSection:Cell("CEL05_DESC"    	   ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_QTDATU"       ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_CM1"          ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_TOTATU"       ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_QTDFECH"      ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_CUSTFECH"     ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_TOTCUSTFECH"  ):SetBlock( { || aDados[11]})
oSection:Cell("CEL12_QTDENTRADA"   ):SetBlock( { || aDados[12]})
oSection:Cell("CEL13_VLUNITENT"    ):SetBlock( { || aDados[13]})  
oSection:Cell("CEL14_TOTENTRADA"   ):SetBlock( { || aDados[14]}) 
oSection:Cell("CEL15_QTDSAIDA"     ):SetBlock( { || aDados[15]})
oSection:Cell("CEL16_VLUNITSAI"    ):SetBlock( { || aDados[16]})  
oSection:Cell("CEL17_TOTSAIDA"     ):SetBlock( { || aDados[17]}) 
oSection:Cell("CEL18_QTDPROCES"    ):SetBlock( { || aDados[18]}) 
oSection:Cell("CEL19_VLRPROCES"    ):SetBlock( { || aDados[19]}) 
oSection:Cell("CEL20_TOTPROCES"    ):SetBlock( { || aDados[20]})
oSection:Cell("CEL21_QTDPROD"      ):SetBlock( { || aDados[21]})
oSection:Cell("CEL22_VLRPROD"      ):SetBlock( { || aDados[22]}) 
oSection:Cell("CEL23_TOTPROD"      ):SetBlock( { || aDados[23]}) 
 

//oBreak := TRBreak():New(oSection,oSection:Cell("CEL06_LOTECTL"),,.F.)
//TRFunction():New(oSection:Cell("CEL11_QT"),"TOT","SUM"  ,oBreak,"Total Quant","@E 999,999,999.9999",,.F.,.T.)
//TRFunction():New(oSection:Cell("CEL12_SALDO"),"TOT","SUM"  ,oBreak,"Total Valor","@E 999,999,999.9999",,.F.,.T.)


oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FILIAL"),,.F.)
TRFunction():New(oSection:Cell("CEL06_QTDATU") ,"TOT","SUM"  ,oBreak,"T. Qtd ProduГ§ГЈo","@E 999,999,999.9999",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL08_TOTATU") ,"TOT","SUM"  ,oBreak,"T. Valor ProduГ§ГЈo","@E 999,999,999.9999",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL09_QTDFECH"),"TOT","SUM"  ,oBreak,"T. Qtd Vendida","@E 999,999,999.9999",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL11_TOTCUSTFECH"),"TOT","SUM"  ,oBreak,"T. Valor Vendido","@E 999,999,999.9999",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL12_QTDENTRADA") ,"TOT","SUM"  ,oBreak,"T. Qtd Consumida","@E 999,999,999.9999",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL14_TOTENTRADA") ,"TOT","SUM"  ,oBreak,"T. Valor Consumido","@E 999,999,999.9999",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL15_QTDSAIDA") ,"TOT","SUM"  ,oBreak,"T. Qtd Devolvida","@E 999,999,999.9999",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL17_TOTSAIDA")  ,"TOT","SUM"  ,oBreak,"T. Valor Devolvido","@E 999,999,999.9999",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL18_QTDPROCES"),"TOT","SUM"  ,oBreak,"T. Qtd Prod Devolvida","@E 999,999,999.9999",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL20_TOTPROCES"),"TOT","SUM"  ,oBreak,"T. Valor Prod Devolvido","@E 999,999,999.9999",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL21_QTDPROD") ,"TOT","SUM"  ,oBreak,"T. Qtd MГЄs Atual","@E 999,999,999.9999",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL23_TOTPROD") ,"TOT","SUM"  ,oBreak,"T. Valor MГЄs Atual","@E 999,999,999.9999",,.F.,.T.)

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

/*
SELECT DISTINCT  B2_FILIAL , B2_COD, B1_TIPO, B2_LOCAL, B1_DESC,B2_QATU, B2_CM1,
ISNULL((SELECT ISNULL(SUM(SB9.B9_QINI),0) FROM SB9010 SB9 WHERE B2_FILIAL = B9_FILIAL AND B2_COD = B9_COD AND B2_LOCAL = B9_LOCAL AND  YEAR(B9_DATA) = '2020' AND  MONTH(B9_DATA) = '11'  AND SB9.D_E_L_E_T_ <> '*'),0)  QTD_FECHAMENTO ,   
ISNULL((SELECT ISNULL(SUM(SB9.B9_VINI1)/NULLIF(SUM(SB9.B9_QINI),0),0) FROM SB9010 SB9 WHERE B2_FILIAL =B9_FILIAL AND B2_COD = B9_COD AND B2_LOCAL = B9_LOCAL AND  YEAR(B9_DATA) = '2020' AND  MONTH(B9_DATA) = '11'  AND SB9.D_E_L_E_T_ <> '*'),0)  MED_UNI_FECHAMENTO,
ISNULL((SELECT ISNULL(SUM(SB9.B9_VINI1),0) FROM SB9010 SB9 WHERE B2_FILIAL = B9_FILIAL AND B2_COD = B9_COD AND B2_LOCAL = B9_LOCAL AND  YEAR(B9_DATA) = '2020' AND  MONTH(B9_DATA) = '11'  AND SB9.D_E_L_E_T_ <> '*'),0) TOTAL_FECHAMENTO,

ISNULL((SELECT ISNULL(SUM(SFT.FT_QUANT),0) FROM SFT010 SFT WHERE B2_FILIAL = SFT.FT_FILIAL AND B2_COD = SFT.FT_PRODUTO AND SFT.FT_ESTOQUE = 'S'  AND SFT.FT_TIPOMOV = 'E' AND  YEAR(SFT.FT_ENTRADA) = '2020' AND  MONTH(SFT.FT_ENTRADA) = '11'  AND SFT.D_E_L_E_T_ <> '*'),0)  QTD_ENTRADA ,   
ISNULL((SELECT ISNULL(SUM(SFT.FT_VALCONT)/NULLIF(SUM(SFT.FT_QUANT),0),0) FROM SFT010 SFT WHERE B2_FILIAL = SFT.FT_FILIAL AND B2_COD = SFT.FT_PRODUTO AND SFT.FT_ESTOQUE = 'S' AND SFT.FT_TIPOMOV = 'E'  AND  YEAR(SFT.FT_ENTRADA) = '2020' AND  MONTH(SFT.FT_ENTRADA) = '11'  AND SFT.D_E_L_E_T_ <> '*'),0)  MED_UNI_ENTRADA,
ISNULL((SELECT ISNULL(SUM(SFT.FT_VALCONT),0) FROM SFT010 SFT WHERE B2_FILIAL = SFT.FT_FILIAL AND B2_COD = SFT.FT_PRODUTO AND SFT.FT_ESTOQUE = 'S' AND SFT.FT_TIPOMOV = 'E' AND  YEAR(SFT.FT_ENTRADA) = '2020' AND  MONTH(SFT.FT_ENTRADA) = '11'  AND SFT.D_E_L_E_T_ <> '*'),0) TOTAL_ENTRADA,

ISNULL((SELECT ISNULL(SUM(SFTT.FT_QUANT),0) FROM SFT010 SFTT WHERE B2_FILIAL = SFTT.FT_FILIAL AND B2_COD = SFTT.FT_PRODUTO AND SFTT.FT_ESTOQUE = 'S'  AND SFTT.FT_TIPOMOV = 'S' AND  YEAR(SFTT.FT_ENTRADA) = '2020' AND  MONTH(SFTT.FT_ENTRADA) = '11'  AND SFTT.D_E_L_E_T_ <> '*'),0)  QTD_SAIDA ,   
ISNULL((SELECT ISNULL(SUM(SFTT.FT_VALCONT)/NULLIF(SUM(SFTT.FT_QUANT),0),0) FROM SFT010 SFTT WHERE B2_FILIAL = SFTT.FT_FILIAL AND B2_COD = SFTT.FT_PRODUTO AND SFTT.FT_ESTOQUE = 'S' AND SFTT.FT_TIPOMOV = 'S'  AND  YEAR(SFTT.FT_ENTRADA) = '2020' AND  MONTH(SFTT.FT_ENTRADA) = '11'  AND SFTT.D_E_L_E_T_ <> '*'),0)  MED_UNI_SAIDA,
ISNULL((SELECT ISNULL(SUM(SFTT.FT_VALCONT),0) FROM SFT010 SFTT WHERE B2_FILIAL =SFTT.FT_FILIAL AND B2_COD = SFTT.FT_PRODUTO AND SFTT.FT_ESTOQUE = 'S' AND SFTT.FT_TIPOMOV = 'S' AND  YEAR(SFTT.FT_ENTRADA) = '2020' AND  MONTH(SFTT.FT_ENTRADA) = '11'  AND SFTT.D_E_L_E_T_ <> '*'),0) TOTAL_SAIDA,

ISNULL((SELECT ISNULL(SUM(SD33.D3_QUANT),0) FROM SD3010 SD33  LEFT JOIN SC2010 SC2 ON C2_FILIAL = SD33.D3_FILIAL AND SC2.C2_DATRF = ' ' AND SC2.D_E_L_E_T_ <> '*'  WHERE B2_FILIAL = SD33.D3_FILIAL AND B2_COD = SD33.D3_COD AND B2_LOCAL = SD33.D3_LOCAL AND  YEAR(SD33.D3_EMISSAO) =  '2020'  AND  MONTH(SD33.D3_EMISSAO) = '10' AND SD33.D3_TM IN ('501') AND  SD33.D3_ESTORNO = ' ' AND SD33.D3_CF IN ('RE6') AND SD33.D3_OP <> ' ' AND SD33.D_E_L_E_T_ <> '*'),0)  Qtd_Processo,
ISNULL((SELECT ISNULL(SUM(SD33.D3_CUSTO1)/SUM(SD33.D3_QUANT),0)FROM SD3010 SD33  LEFT JOIN SC2010 SC2 ON C2_FILIAL = SD33.D3_FILIAL AND SC2.C2_DATRF = ' ' AND SC2.D_E_L_E_T_ <> '*'  WHERE B2_FILIAL = SD33.D3_FILIAL AND B2_COD = SD33.D3_COD AND B2_LOCAL = SD33.D3_LOCAL AND  YEAR(SD33.D3_EMISSAO) =  '2020'  AND  MONTH(SD33.D3_EMISSAO) = '10' AND SD33.D3_TM IN ('501') AND SD33.D3_ESTORNO = ' ' AND SD33.D3_CF IN ('RE6') AND SD33.D3_OP <> ' ' AND SD33.D_E_L_E_T_ <> '*'),0) Unit_Processo, 
ISNULL((SELECT ISNULL(SUM(SD33.D3_CUSTO1),0) FROM SD3010 SD33  LEFT JOIN SC2010 SC2 ON C2_FILIAL = SD33.D3_FILIAL AND SC2.C2_DATRF = ' ' AND SC2.D_E_L_E_T_ <> '*' WHERE B2_FILIAL = SD33.D3_FILIAL AND B2_COD = SD33.D3_COD AND B2_LOCAL = SD33.D3_LOCAL AND YEAR(SD33.D3_EMISSAO) =  '2020'  AND  MONTH(SD33.D3_EMISSAO) = '10' AND SD33.D3_TM IN ('501') AND SD33.D3_ESTORNO = ' ' AND SD33.D3_CF IN ('RE6') AND SD33.D3_OP <> ' ' AND SD33.D_E_L_E_T_ <> '*'),0)  Tot_Processo,
ISNULL((SELECT ISNULL(SUM(SD3.D3_QUANT),0) FROM SD3010 SD3 WHERE B2_FILIAL = SD3.D3_FILIAL AND B2_COD = SD3.D3_COD AND B2_LOCAL = SD3.D3_LOCAL AND  YEAR(SD3.D3_EMISSAO) =  '2020'  AND  MONTH(SD3.D3_EMISSAO) = '11' AND SD3.D3_TM IN ('003') AND  SD3.D3_ESTORNO = ' ' AND SD3.D3_CF IN ('PR0') AND SD3.D3_OP <> ' ' AND SD3.D_E_L_E_T_ <> '*'),0)  Qtd_Apont,
ISNULL((SELECT ISNULL(SUM(SD3.D3_CUSTO1)/SUM(SD3.D3_QUANT),0) FROM SD3010 SD3 WHERE B2_FILIAL = SD3.D3_FILIAL AND B2_COD = SD3.D3_COD AND B2_LOCAL = SD3.D3_LOCAL AND  YEAR(SD3.D3_EMISSAO) =  '2020'  AND  MONTH(SD3.D3_EMISSAO) = '11' AND SD3.D3_TM IN ('003') AND SD3.D3_ESTORNO = ' ' AND SD3.D3_CF IN ('PR0') AND SD3.D3_OP <> ' ' AND SD3.D_E_L_E_T_ <> '*'),0) Valor_Unit_Apon, 
ISNULL((SELECT ISNULL(SUM(SD3.D3_CUSTO1),0) FROM SD3010 SD3 WHERE B2_FILIAL = SD3.D3_FILIAL AND B2_COD = SD3.D3_COD AND B2_LOCAL = SD3.D3_LOCAL AND YEAR(SD3.D3_EMISSAO) =  '2020'  AND  MONTH(SD3.D3_EMISSAO) = '11' AND SD3.D3_TM IN ('003') AND SD3.D3_ESTORNO = ' ' AND SD3.D3_CF IN ('PR0') AND SD3.D3_OP <> ' ' AND SD3.D_E_L_E_T_ <> '*'),0)  Tot_Apont
FROM SB2010 SB2
LEFT JOIN SB1010 SB1 ON  B2_COD = B1_COD  AND B1_FILIAL = '01' AND SB1.D_E_L_E_T_ <> '*'
WHERE B2_QATU > 0
AND SB2.D_E_L_E_T_ <> '*'
ORDER BY B2_COD, B2_LOCAL

*/

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := " SELECT DISTINCT  B2_FILIAL , B2_COD, B1_TIPO, B2_LOCAL, B1_DESC,B2_QATU, B2_CM1, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SB9.B9_QINI),0) FROM "  + retsqlname("SB9")+" SB9 WHERE B2_FILIAL = B9_FILIAL AND B2_COD = B9_COD AND B2_LOCAL = B9_LOCAL AND  "
_cQry += " YEAR(B9_DATA) =  '" + substr(dtos(mv_par02),1,4)  + "'  AND  MONTH(B9_DATA) = '" + substr(dtos(mv_par02),5,2) + "'  AND SB9.D_E_L_E_T_ <> '*'),0)  QTD_FECHAMENTO, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SB9.B9_VINI1)/NULLIF(SUM(SB9.B9_QINI),0),0) FROM "  + retsqlname("SB9")+" SB9 WHERE B2_FILIAL = B9_FILIAL AND B2_COD = B9_COD AND B2_LOCAL = B9_LOCAL AND  "
_cQry += " YEAR(B9_DATA) =  '" + substr(dtos(mv_par02),1,4)  + "'  AND  MONTH(B9_DATA) = '" + substr(dtos(mv_par02),5,2) + "'  AND SB9.D_E_L_E_T_ <> '*'),0)  MED_UNI_FECH, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SB9.B9_VINI1),0) FROM "  + retsqlname("SB9")+" SB9 WHERE B2_FILIAL = B9_FILIAL AND B2_COD = B9_COD AND B2_LOCAL = B9_LOCAL AND  "
_cQry += " YEAR(B9_DATA) =  '" + substr(dtos(mv_par02),1,4)  + "'  AND  MONTH(B9_DATA) = '" + substr(dtos(mv_par02),5,2) + "'  AND SB9.D_E_L_E_T_ <> '*'),0)  TOTAL_FECH, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SFT.FT_QUANT),0) FROM " + retsqlname("SFT")+ " SFT WHERE B2_FILIAL = SFT.FT_FILIAL AND B2_COD = SFT.FT_PRODUTO AND SFT.FT_ESTOQUE = 'S'  AND " 
_cQry += " SFT.FT_TIPOMOV = 'E' AND  YEAR(SFT.FT_ENTRADA) = '" + substr(dtos(mv_par01),1,4)  + "'  AND  MONTH(SFT.FT_ENTRADA) = '" + substr(dtos(mv_par01),5,2) + "'  AND SFT.D_E_L_E_T_ <> '*'),0)  QTD_ENTRADA ,  " 
_cQry += " ISNULL((SELECT ISNULL(SUM(SFT.FT_VALCONT)/NULLIF(SUM(SFT.FT_QUANT),0),0) FROM " + retsqlname("SFT")+ " SFT WHERE B2_FILIAL = SFT.FT_FILIAL AND B2_COD = SFT.FT_PRODUTO AND SFT.FT_ESTOQUE = 'S' "
_cQry += " AND SFT.FT_TIPOMOV = 'E'  AND  YEAR(SFT.FT_ENTRADA) = '" + substr(dtos(mv_par01),1,4)  + "'  AND  MONTH(SFT.FT_ENTRADA) = '" + substr(dtos(mv_par01),5,2) + "'  AND SFT.D_E_L_E_T_ <> '*'),0)  MED_UNI_ENTRADA, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SFT.FT_VALCONT),0) FROM " + retsqlname("SFT")+ " SFT WHERE B2_FILIAL = SFT.FT_FILIAL AND B2_COD = SFT.FT_PRODUTO AND SFT.FT_ESTOQUE = 'S' AND SFT.FT_TIPOMOV = 'E' AND " 
_cQry += " YEAR(SFT.FT_ENTRADA) = '" + substr(dtos(mv_par01),1,4)  + "'  AND  MONTH(SFT.FT_ENTRADA) = '" + substr(dtos(mv_par01),5,2) + "'  AND SFT.D_E_L_E_T_ <> '*'),0) TOTAL_ENTRADA, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SFTT.FT_QUANT),0) FROM " + retsqlname("SFT")+ " SFTT WHERE B2_FILIAL = SFTT.FT_FILIAL AND B2_COD = SFTT.FT_PRODUTO AND SFTT.FT_ESTOQUE = 'S'  AND SFTT.FT_TIPOMOV = 'S' AND  "
_cQry += " YEAR(SFTT.FT_ENTRADA) = '" + substr(dtos(mv_par01),1,4)  + "' AND  MONTH(SFTT.FT_ENTRADA) = '" + substr(dtos(mv_par01),5,2) + "'   AND SFTT.D_E_L_E_T_ <> '*'),0)  QTD_SAIDA , "  
_cQry += " ISNULL((SELECT ISNULL(SUM(SFTT.FT_VALCONT)/NULLIF(SUM(SFTT.FT_QUANT),0),0) FROM " + retsqlname("SFT")+ " SFTT WHERE B2_FILIAL = SFTT.FT_FILIAL AND B2_COD = SFTT.FT_PRODUTO AND SFTT.FT_ESTOQUE = 'S' "
_cQry += " AND SFTT.FT_TIPOMOV = 'S'  AND  YEAR(SFTT.FT_ENTRADA) = '" + substr(dtos(mv_par01),1,4)  + "' AND  MONTH(SFTT.FT_ENTRADA) = '" + substr(dtos(mv_par01),5,2) + "'   AND SFTT.D_E_L_E_T_ <> '*'),0)  MED_UNI_SAIDA, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SFTT.FT_VALCONT),0) FROM " + retsqlname("SFT")+ " SFTT WHERE B2_FILIAL =SFTT.FT_FILIAL AND B2_COD = SFTT.FT_PRODUTO AND SFTT.FT_ESTOQUE = 'S' AND SFTT.FT_TIPOMOV = 'S' AND  "
_cQry += " YEAR(SFTT.FT_ENTRADA) = '" + substr(dtos(mv_par01),1,4)  + "' AND  MONTH(SFTT.FT_ENTRADA) = '" + substr(dtos(mv_par01),5,2) + "'   AND SFTT.D_E_L_E_T_ <> '*'),0) TOTAL_SAIDA, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SD33.D3_QUANT),0) FROM "  + retsqlname("SD3")+" SD33  LEFT JOIN SC2010 SC2 ON C2_FILIAL = SD33.D3_FILIAL AND SC2.C2_DATRF = ' ' AND SC2.D_E_L_E_T_ <> '*'  WHERE B2_FILIAL = SD33.D3_FILIAL "
_cQry += " AND B2_COD = SD33.D3_COD AND B2_LOCAL = SD33.D3_LOCAL AND  YEAR(SD33.D3_EMISSAO) =  '" + substr(dtos(mv_par02),1,4)  + "'  AND  MONTH(SD33.D3_EMISSAO) = '" + substr(dtos(mv_par02),5,2) + "' AND SD33.D3_TM IN ('501') "
_cQry += " AND  SD33.D3_ESTORNO = ' ' AND SD33.D3_CF IN ('RE6') AND SD33.D3_OP <> ' ' AND SD33.D_E_L_E_T_ <> '*'),0)  Qtd_Processo, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SD33.D3_CUSTO1)/SUM(SD33.D3_QUANT),0) FROM "  + retsqlname("SD3")+"  SD33  LEFT JOIN SC2010 SC2 ON C2_FILIAL = SD33.D3_FILIAL AND SC2.C2_DATRF = ' ' AND SC2.D_E_L_E_T_ <> '*' "
_cQry += " WHERE B2_FILIAL = SD33.D3_FILIAL AND B2_COD = SD33.D3_COD AND B2_LOCAL = SD33.D3_LOCAL AND  YEAR(SD33.D3_EMISSAO) =  '" + substr(dtos(mv_par02),1,4)  + "'   AND  MONTH(SD33.D3_EMISSAO) = '" + substr(dtos(mv_par02),5,2) + "' "
_cQry += " AND SD33.D3_TM IN ('501') AND SD33.D3_ESTORNO = ' ' AND SD33.D3_CF IN ('RE6') AND SD33.D3_OP <> ' ' AND SD33.D_E_L_E_T_ <> '*'),0) Unit_Processo, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SD33.D3_CUSTO1),0) FROM "  + retsqlname("SD3")+"  SD33  LEFT JOIN SC2010 SC2 ON C2_FILIAL = SD33.D3_FILIAL AND SC2.C2_DATRF = ' ' AND SC2.D_E_L_E_T_ <> '*' WHERE B2_FILIAL = SD33.D3_FILIAL "
_cQry += " AND B2_COD = SD33.D3_COD AND B2_LOCAL = SD33.D3_LOCAL AND YEAR(SD33.D3_EMISSAO) =  '" + substr(dtos(mv_par02),1,4)  + "'   AND  MONTH(SD33.D3_EMISSAO) = '" + substr(dtos(mv_par02),5,2) + "' AND SD33.D3_TM IN ('501') "
_cQry += " AND SD33.D3_ESTORNO = ' ' AND SD33.D3_CF IN ('RE6') AND SD33.D3_OP <> ' ' AND SD33.D_E_L_E_T_ <> '*'),0)  Tot_Processo, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SD3.D3_QUANT),0) FROM "  + retsqlname("SD3")+ "  SD3 WHERE B2_FILIAL = SD3.D3_FILIAL AND B2_COD = SD3.D3_COD AND B2_LOCAL = SD3.D3_LOCAL AND " 
_cQry += " YEAR(SD3.D3_EMISSAO) =  '" + substr(dtos(mv_par01),1,4)  + "'  AND  MONTH(SD3.D3_EMISSAO) = '" + substr(dtos(mv_par01),5,2) + "' AND SD3.D3_TM IN ('003') AND  SD3.D3_ESTORNO = ' ' AND SD3.D3_CF IN ('PR0') AND "
_cQry += " SD3.D3_OP <> ' ' AND SD3.D_E_L_E_T_ <> '*'),0)  Qtd_Apont, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SD3.D3_CUSTO1)/SUM(SD3.D3_QUANT),0) FROM "  + retsqlname("SD3")+"  SD3 WHERE B2_FILIAL = SD3.D3_FILIAL AND B2_COD = SD3.D3_COD AND B2_LOCAL = SD3.D3_LOCAL AND "
_cQry += " YEAR(SD3.D3_EMISSAO) =  '" + substr(dtos(mv_par01),1,4)  + "'  AND  MONTH(SD3.D3_EMISSAO) = '" + substr(dtos(mv_par01),5,2) + "' AND SD3.D3_TM IN ('003') AND SD3.D3_ESTORNO = ' ' AND SD3.D3_CF IN ('PR0') "
_cQry += " AND SD3.D3_OP <> ' ' AND SD3.D_E_L_E_T_ <> '*'),0) Valor_Unit_Apon, "
_cQry += " ISNULL((SELECT ISNULL(SUM(SD3.D3_CUSTO1),0) FROM "  + retsqlname("SD3")+ "  SD3 WHERE B2_FILIAL = SD3.D3_FILIAL AND B2_COD = SD3.D3_COD AND B2_LOCAL = SD3.D3_LOCAL AND " 
_cQry += " YEAR(SD3.D3_EMISSAO) =  '" + substr(dtos(mv_par01),1,4)  + "' AND  MONTH(SD3.D3_EMISSAO) = '" + substr(dtos(mv_par01),5,2) + "' AND SD3.D3_TM IN ('003') AND "
_cQry += " SD3.D3_ESTORNO = ' ' AND SD3.D3_CF IN ('PR0') AND SD3.D3_OP <> ' ' AND SD3.D_E_L_E_T_ <> '*'),0)  Tot_Apont "
_cQry += " FROM " + retsqlname("SB2")+" SB2 "
_cQry += " LEFT JOIN " + retsqlname("SB1")+" SB1 ON  B2_COD = B1_COD  AND B1_FILIAL = '" + SUBSTR(cFilAnt,1,2) + "' AND SB1.D_E_L_E_T_ <> '*' " 
_cQry += " WHERE SB2.D_E_L_E_T_ <> '*' "  
_cQry += " AND B2_COD IN (SELECT B1_COD FROM " + retsqlname("SB1")+" WHERE B1_FILIAL = '" + SUBSTR(cFilAnt,1,2) + "' AND B1_TIPO = '" + mv_par03  + "') "
_cQry += " AND B2_COD BETWEEN '" + mv_par04  + "' AND '" + mv_par05  + "' "	
_cQry += " AND B2_FILIAL BETWEEN '" + mv_par06  + "' AND '" + mv_par07  + "' "	
//_cQry += " AND B2_QATU > 0 " 
_cQry += " ORDER BY B2_COD, B2_LOCAL "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TMP",.T.,.T.)
 
dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
    	
	If oReport:Cancel()
		Exit
	EndIf
 		
	aDados[01] := TMP->B2_FILIAL
	aDados[02] := TMP->B2_COD
	aDados[03] := TMP->B2_LOCAL
	aDados[04] := TMP->B1_TIPO	
	aDados[05] := TMP->B1_DESC	
	aDados[06] := TMP->B2_QATU
	aDados[07] := TMP->B2_CM1
    aDados[08] := round(TMP->B2_QATU*TMP->B2_CM1,2)
	aDados[09] := TMP->QTD_FECHAMENTO   
	aDados[10] := TMP->MED_UNI_FECH
	aDados[11] := TMP->TOTAL_FECH
	aDados[12] := TMP->QTD_ENTRADA 
	aDados[13] := TMP->MED_UNI_ENTRADA
	aDados[14] := TMP->TOTAL_ENTRADA
	aDados[15] := TMP->QTD_SAIDA  	
	aDados[16] := TMP->MED_UNI_SAIDA   
	aDados[17] := TMP->TOTAL_SAIDA  
	aDados[18] := TMP->Qtd_Processo 
	aDados[19] := TMP->Unit_Processo  
	aDados[20] := TMP->Tot_Processo
	aDados[21] := TMP->Qtd_Apont 
	aDados[22] := TMP->Valor_Unit_Apon 	
	aDados[23] := TMP->Tot_Apont	
	
	oSection:PrintLine()  // Imprime linha de detalhe
	
	aFill(aDados,nil)     // Limpa o array a dados
	
	dbselectarea("TMP")
	 TMP->(dbSkip())
ENDDO

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

oSection:Finish()
oReport:SkipLine()
oReport:IncMeter()
Return

//FIM FUNCOES PARA IMPRESSAO - EXCEL

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Criacao das perguntas dos parametros                                пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Static Function ValidPerg1
Local aArea    := GetArea()
Local aRegs    := {}
Local i	       := 0
Local j        := 0
Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}

aAdd(aRegs,{cPerg,"01","Fechamento Atual	  ?","","","mv_ch1","D",10,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Fechamento Anterior   ?","","","mv_ch2","D",10,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Tipo                  ?","","","mv_ch3","C",02,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Produto de            ?","","","mv_ch4","C",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"05","Produto Ate           ?","","","mv_ch5","C",10,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"06","Filial de      		  ?","","","mv_ch6","C",04,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"07","Filial Ate     		  ?","","","mv_ch7","C",04,0,0,"G","","mv_par07",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})

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
			AADD(aHelpPor,"Informe o Fechamento Atual.      ")
		ElseIf i==2                                          
			AADD(aHelpPor,"Informe o Fechamento Anterior.   ")	 
		ElseIf i==3		
			AADD(aHelpPor,"Tipo.                            ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe o Produto Inicial.       ")			
		ElseIf i==5
			AADD(aHelpPor,"Informe o Produto Final.         ")	
        ElseIf i==6
			AADD(aHelpPor,"Informe a Filial Inicial.        ")			
		ElseIf i==7
			AADD(aHelpPor,"Informe a Filial Final.          ")		
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return  

