#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRG031 บ Autor ณ Ricardo Moreira     บ Data ณ  06/09/16    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Contas a Pagar - Agrupado Natureza            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BRG                             			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BRG031 //U_BRG006()

Private cPerg       := PADR("BRG031",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio de Contas Pagas - por Natureza " + CVALTOCHAR(MV_PAR05) + " a " + CVALTOCHAR(MV_PAR06)

oReport  := TReport():New("BRG031",cTitulo,"BRG031",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  

oreport:nfontbody:=6
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio de Contas Pagas - Agrupado por Natureza",{""})
TRCell():New(oSection, "CEL01_FILIAL"         , "SE2", "Filial"              ,PesqPict("SE2","E2_FILIAL"   ),06                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_CODIGO"         , "SED", "Codigo"         	 ,PesqPict("SED","ED_CODIGO"   ),12                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_NATUR"          , "SED", "Natureza"         	 ,PesqPict("SED","ED_DESCRIC"  ),30                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_SALDO"          , "SE2", "Saldo"               ,PesqPict("SE2","E2_SALDO"    ),20					 , /*lPixel*/, /* Formula*/)

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
Local _Solic := " "
Private aDados[04]
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {}


oSection:Cell("CEL01_FILIAL"  ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_CODIGO"  ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_NATUR"   ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_SALDO"   ):SetBlock( { || aDados[04]})
 
//Faturamento por UF
//If mv_par09 == 2
// 	oBreak := TRBreak():New(oSection,oSection:Cell("CEL05_EST"),,.F.)
//	TRFunction():New(oSection:Cell("CEL07_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)

oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FILIAL"),,.F.)
TRFunction():New(oSection:Cell("CEL04_SALDO"),"TOT","SUM"  ,oBreak,"Total do Saldo","@E 999,999,999.99",,.F.,.T.) 

 
 
//EndIf
//Faturamento por Cliente

//oBreak := TRBreak():New(oSection,oSection:Cell("CEL05_TRANS"),,.F.)
//TRFunction():New(oSection:Cell("CEL08_CUSTO"  ),"TOT","SUM"  ,oBreak,"",PesqPict("SZ6","Z6_VLPED")   ,,.F.,.F.)
//TRFunction():New(oSection:Cell("CEL09_TOT3"   ),"TOT","SUM"  ,oBreak,"",PesqPict("SZ6","Z6_TOT3")   ,,.F.,.F.)
//TRFunction():New(oSection:Cell("CEL13_VLBX"   ),"TOT","SUM"  ,oBreak,"",PesqPict("SZ6","Z6_VLPROD")       ,,.F.,.F.)

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := "SELECT DISTINCT E2_FILIAL, ED_CODIGO, ED_DESCRIC, SUM(E2_VALOR) Saldo,SUM(E2_ACRESC) Acres "
_cQry += "FROM " + retsqlname("SE2")+" SE2 "  
_cQry += " INNER JOIN " + retsqlname("SED")+" SED ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ <> '*'  "	  
_cQry += "WHERE SE2.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SE2.E2_SALDO = 0 "
_cQry += "AND   SE2.E2_FILIAL   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   SE2.E2_EMISSAO	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "AND   SE2.E2_BAIXA	BETWEEN '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06)  + "' "
_cQry += "AND   SE2.E2_FORNECE  BETWEEN '" + mv_par07  + "' AND '" + mv_par08  + "' "
_cQry += "GROUP BY E2_FILIAL, ED_CODIGO, ED_DESCRIC "
_cQry += "ORDER BY E2_FILIAL,ED_CODIGO "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf	 
	 
	aDados[01] := TMP->E2_FILIAL
	aDados[02] := TMP->ED_CODIGO	
	aDados[03] := TMP->ED_DESCRIC	
	aDados[04] := ROUND((TMP->Saldo + TMP->Acres),2)	
	
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

aAdd(aRegs,{cPerg,"01","Filial de      ?","","","mv_ch1","C",04,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"02","Filial Ate     ?","","","mv_ch2","C",04,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"03","Emissใo de     ?","","","mv_ch3","D",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"04","Emissใo Ate    ?","","","mv_ch4","D",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"05","Baixa de       ?","","","mv_ch5","D",10,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"06","Baixa Ate      ?","","","mv_ch6","D",10,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"07","Natureza de    ?","","","mv_ch7","C",10,0,0,"G","","mv_par07",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SED"})
aAdd(aRegs,{cPerg,"08","Natureza Ate ?","","","mv_ch8","C",10,0,0,"G","","mv_par08",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SED"})


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
			AADD(aHelpPor,"Informe a Emissใo Inicial.            ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe a Emissใo Final.              ")		
		ElseIf i==5
			AADD(aHelpPor,"Informe a Baixa Inicial.           ")		
		ElseIf i==6
			AADD(aHelpPor,"Informe a Baixa Final.           ")		
		ElseIf i==7
			AADD(aHelpPor,"Informe o Natureza Inicial.           ")			
		ElseIf i==8
			AADD(aHelpPor,"Informe o Natureza Final.           ")		
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return
