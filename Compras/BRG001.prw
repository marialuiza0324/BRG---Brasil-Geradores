#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRG001 บ Autor ณ Ricardo Moreira     บ Data ณ  14/02/18    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Compras Diario                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BRG GERADORES		              			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BRG001 //U_BRG001

Private cPerg       := PADR("BRG001",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio de Compras Diario"

oReport  := TReport():New("BRG001",cTitulo,"BRG001",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  
//oReport:SetPortrait()    // Retrato
oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio de Movimenta็ใo de Palete",{""})
TRCell():New(oSection, "CEL01_DATA"         , "SD1", "Data Entrada"            ,PesqPict("SD1","D1_DTDIGIT"  ),12                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_ORD"          , "SD1", "Ordem de Compra"         ,PesqPict("SD1","D1_PEDIDO"   ),12				      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_FORNE"        , "SA2", "Fornecedor"              ,PesqPict("SA2","A2_NOME"     ),45                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_MATER"        , "SC7", "Material"                ,PesqPict("SC7","C7_DESCRI"   ),45                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_QUANT"        , "SD1", "Quantidade"              ,PesqPict("SD1","D1_QUANT"    ),14	    			  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_VALOR"        , "SD1", "Valor"       			   ,PesqPict("SD1","D1_TOTAL"    ),14	    			  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_APLICA"       , "SC7", "Aplicacใo"               ,PesqPict("SC7","C7_OBS"      ),45                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_USER"         , "SC7", "Solicita็ใo"             ,PesqPict("SC7","C7_USER"     ),20                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_FILIAL"       , "SD1", "Faturada Para"           ,PesqPict("SD1","D1_FILIAL"   ),05                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_PRAZO"        , "SE4", "Prazo"                   ,PesqPict("SE4","E4_COND"     ),25                    , /*lPixel*/, /* Formula*/)

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
Private aDados[10]


oSection:Cell("CEL01_DATA"    ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_ORD"     ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_FORNE"   ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_MATER"   ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_QUANT"   ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_VALOR"   ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_APLICA"  ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_USER"    ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_FILIAL"  ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_PRAZO"   ):SetBlock( { || aDados[10]})

oBreak := TRBreak():New(oSection,oSection:Cell("CEL09_FILIAL"),,.F.)
TRFunction():New(oSection:Cell("CEL06_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := "SELECT D1_PEDIDO, D1_ITEMPC, A2_NOME, C7_DESCRI , D1_QUANT , D1_TOTAL, C7_OBS, C7_USER, D1_FILIAL,C7_COND , D1_DTDIGIT  "
_cQry += "FROM " + retsqlname("SD1")+" SD1 "  
_cQry += " LEFT JOIN " + retsqlname("SC7")+" SC7 ON D1_FILIAL = C7_FILIAL AND C7_NUM = D1_PEDIDO AND C7_ITEM = D1_ITEM AND C7_LOCAL = D1_LOCAL AND SC7.D_E_L_E_T_ <> '*' "	
_cQry += " LEFT JOIN " + retsqlname("SA2")+" SA2 ON D1_FORNECE = A2_COD AND D1_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ <> '*'"	
_cQry += "WHERE SD1.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SD1.D1_FILIAL   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   SD1.D1_DTDIGIT	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "AND   SD1.D1_FORNECE	BETWEEN '" + mv_par05  + "' AND '" + mv_par06  + "' "
_cQry += "ORDER BY D1_FILIAL, D1_PEDIDO, D1_ITEMPC "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf	
	aDados[01] := CVALTOCHAR(STOD(TMP->D1_DTDIGIT))
	aDados[02] := TMP->D1_PEDIDO
	aDados[03] := TMP->A2_NOME
	aDados[04] := TMP->C7_DESCRI
	aDados[05] := TMP->D1_QUANT
	aDados[06] := TMP->D1_TOTAL
	aDados[07] := TMP->C7_OBS
	aDados[08] := UsrRetName(TMP->C7_USER)
	aDados[09] := TMP->D1_FILIAL
    aDados[10] := Posicione("SE4",1,xFilial("SE4")+TMP->C7_COND,"E4_COND")    
	
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

aAdd(aRegs,{cPerg,"01","Filial de      		  ?","","","mv_ch1","C",06,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"02","Filial Ate     		  ?","","","mv_ch2","C",06,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"03","Data de   		      ?","","","mv_ch3","D",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"04","Data Ate              ?","","","mv_ch4","D",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"05","Fornecedor de         ?","","","mv_ch5","C",09,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA2"})
aAdd(aRegs,{cPerg,"06","Fornecedor Ate        ?","","","mv_ch6","C",09,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA2"})

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
			AADD(aHelpPor,"Informe a Filial Inicial.             ")
		ElseIf i==2                                            
			AADD(aHelpPor,"Informe a Filial Final.               ")	 
		ElseIf i==3
			AADD(aHelpPor,"Informe a Data Inicial.            ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe a Data Final.              ")		
		ElseIf i==5
			AADD(aHelpPor,"Informe o Fornecedor Inicial.            ")		
		ElseIf i==6
			AADD(aHelpPor,"Informe o Fornecedor Final.              ")
		EndIf
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return     
