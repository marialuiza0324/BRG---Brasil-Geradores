#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRG018 บ Autor ณ Ricardo Moreira     บ Data ณ  29/09/20    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de GEradores vendidos no periodo com lote        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BRG GERADORES		              			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BRG018 //U_BRG018

Private cPerg       := PADR("BRG018",Len(SX1->X1_GRUPO))
//Chama relatorio personalizado
ValidPerg1()
pergunte(cPerg,.F.)    // sem tela de pergunta

oReport := ReportDef1() // Chama a funcao personalizado onde deve buscar as informacoes
oReport:PrintDialog()  // Cria a tela de parametros no modo personalizado apos buscar as informacoes

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ Ricardo Fiuza      บ Data ณ  28/07/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA funcao estatica ReportDef devera ser criada para todos os บฑฑ
ฑฑบ          ณrelatorios que poderao ser agendados pelo usuario.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef1() //Cria o Cabe็alho em excel

Local oReport, oSection, oBreak

cTitulo := "Relat๓rio de Geradores Vendidos - Periodo " + CVALTOCHAR(MV_PAR03) + "a" + CVALTOCHAR(MV_PAR04)
 
oReport  := TReport():New("BRG018",cTitulo,"BRG018",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  
//oReport:SetPortrait()    // Retrato
oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relat๓rio de Geradores Vendidos",{""})
TRCell():New(oSection, "CEL01_FILIAL"          , "SD2", "Filial"             ,PesqPict("SD2","D2_FILIAL"   ),05                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_PRODUTO"         , "SD2", "Produto"            ,PesqPict("SD2","D2_COD"      ),12                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_DESC"            , "SB1", "Descricao"          ,PesqPict("SB1","B1_DESC"     ),55				      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_QTD"             , "SD2", "Quantidade"         ,PesqPict("SD2","D2_QUANT"    ),20                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_VALOR"           , "SD2", "Valor"              ,PesqPict("SB1","B1_DESC"     ),45				      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_CLIENTE"         , "SA1", "Cliente"            ,PesqPict("SA1","A1_NOME"     ),45                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_CNPJ"            , "SA1", "CNPJ/CPF"           ,PesqPict("SA1","A1_CGC"      ),20                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_LOTE"            , "SD2", "Lote"               ,PesqPict("SD2","D2_LOTECTL"  ),20				      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_DATA"            , "SD2", "Data"               ,PesqPict("SD2","D2_EMISSAO"  ),20                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_TES"             , "SD2", "Tes"                ,PesqPict("SD2","D2_TES"      ),05                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_CF"              , "SD1", "CF"                 ,PesqPict("SD2","D2_CF"       ),05				      , /*lPixel*/, /* Formula*/)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReportบAutor  ณ Ricardo Moreira   บ Data ณ  28/05/2013 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA funcao estatica PrintReport realiza a impressao do relato-บฑฑ
ฑฑบ          ณrio                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport1(oReport)

Local oSection := oReport:Section(1)
Private aDados[11]

oSection:Cell("CEL01_FILIAL"  ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_PRODUTO" ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_DESC"    ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_QTD"     ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_VALOR"   ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_CLIENTE" ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_CNPJ"    ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_LOTE"    ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_DATA"    ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_TES"     ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_CF"      ):SetBlock( { || aDados[11]})

oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FILIAL"),,.F.)
TRFunction():New(oSection:Cell("CEL05_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := "SELECT DISTINCT D2_FILIAL, D2_COD,B1_DESC,D2_QUANT, D2_TOTAL,D2_CLIENTE, D2_LOJA, A1_CGC,A1_NOME, D2_LOTECTL, D2_EMISSAO, D2_TES, D2_CF  "
_cQry += "FROM " + retsqlname("SD2")+" SD2 "  
_cQry += " LEFT JOIN " + retsqlname("SA1")+" SA1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ <> '*' "	
_cQry += " LEFT JOIN " + retsqlname("SB1")+" SB1 ON D2_COD = B1_COD AND B1_FILIAL = '" + substr(cFilAnt,1,2) + "' AND SB1.D_E_L_E_T_ <> '*' "	
_cQry += " LEFT JOIN " + retsqlname("SF4")+" SF4 ON F4_FILIAL = D2_FILIAL AND D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ <> '*' "	
_cQry += "WHERE SD2.D_E_L_E_T_ <> '*' " 
_cQry += "AND   B1_DESC LIKE 'GERADOR%' " 
_cQry += "AND   B1_TIPO  = 'PA' "
_cQry += "AND   F4_ESTOQUE  = 'S' "
_cQry += "AND   D2_CLIENTE   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   D2_EMISSAO 	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "ORDER BY D2_FILIAL,D2_COD, D2_LOTECTL "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE !TMP->(EOF())
	
	If oReport:Cancel()
		Exit
	EndIf	

    aDados[01] := TMP->D2_FILIAL 
	aDados[02] := TMP->D2_COD 
	aDados[03] := TMP->B1_DESC
	aDados[04] := TMP->D2_QUANT
    aDados[05] := Transform((TMP->D2_TOTAL),"@E 999,999,999.99") //TMP->D2_TOTAL
    aDados[06] := TMP->A1_NOME 
    aDados[07] := TMP->A1_CGC
    aDados[08] := TMP->D2_LOTECTL  
	aDados[09] := CVALTOCHAR(STOD(TMP->D2_EMISSAO))
	aDados[10] := TMP->D2_TES 
    aDados[11] := TMP->D2_CF  
	
	oSection:PrintLine()  // Imprime linha de detalhe
	
	aFill(aDados,nil)     // Limpa o array a dados
	
	dbselectarea("TMP")
	skip
	
ENDDO

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

oSection:Finish()
oReport:SkipLine()
oReport:IncMeter()
Return

//FIM FUNCOES PARA IMPRESSAO - EXCEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criacao das perguntas dos parametros                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function ValidPerg1
Local aArea    := GetArea()
Local aRegs    := {}
Local i	       := 0
Local j        := 0
Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}

aAdd(aRegs,{cPerg,"01","Cliente de        ?","","","mv_ch1","C",14,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"02","Cliente Ate       ?","","","mv_ch2","C",14,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"03","Data de   		  ?","","","mv_ch3","D",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"04","Data Ate          ?","","","mv_ch4","D",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})

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
			AADD(aHelpPor,"Informe o Cliente Inicial.             ")
		ElseIf i==2                                            
			AADD(aHelpPor,"Informe o Cliente Final.               ")	 
		ElseIf i==3
			AADD(aHelpPor,"Informe a Data Inicial.            ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe a Data Final.              ")
		EndIf
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return     
