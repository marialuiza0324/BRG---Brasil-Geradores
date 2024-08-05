#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRG006 บ Autor ณ Ricardo Moreira     บ Data ณ  06/09/16    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Contas a Pagar - Por Vencimento               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BRG                             			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BRG006 //U_BRG006()

Private cPerg       := PADR("BRG006",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio de Contas a Pagar - Por Vencimento"

oReport  := TReport():New("BRG006",cTitulo,"BRG006",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  

oreport:nfontbody:=6
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio de Contas a Pagar - Por Vencimento",{""})
TRCell():New(oSection, "CEL01_FILIAL"         , "SE2", "Filial"              ,PesqPict("SE2","E2_FILIAL"   ),06                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_PREF"           , "SE2", "Pref"                ,PesqPict("SE2","E2_PREFIXO"  ),06				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_NUM"            , "SE2", "Titulo"              ,PesqPict("SE2","E2_NUM"      ),10                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_PARC"       	  , "SE2", "Parc"                ,PesqPict("SE2","E2_PARCELA"  ),06	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_PEDCOM"         , "SD1", "Pedido Compra"   	 ,PesqPict("SED","ED_DESCRIC"  ),20                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_SOLIC"          , "SED", "Solicitante"   		 ,PesqPict("SED","ED_DESCRIC"  ),25	  			     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_NATUR"          , "SED", "Natureza"         	 ,PesqPict("SED","ED_DESCRIC"  ),30                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_FORNEC"         , "SE2", "Fornecedor"   		 ,PesqPict("SE2","E2_FORNECE"  ),12	  			     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_NOMFOR"         , "SE2", "RazaoSocial"      	 ,PesqPict("SE2","E2_NOMFOR"   ),35					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_EMISS"          , "SE2", "Emissao"             ,PesqPict("SE2","E2_EMISSAO"  ),20					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_VENC"           , "SE2", "Vencimento"          ,PesqPict("SE2","E2_VENCREA"  ),20					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL12_VALOR"          , "SE2", "Valor"  		     ,PesqPict("SE2","E2_VALOR"    ),20					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL13_SALDO"          , "SE2", "Saldo"               ,PesqPict("SE2","E2_SALDO"    ),20					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL14_ACRES"          , "SE2", "Acrescimo"  		 ,PesqPict("SE2","E2_VALOR"    ),20					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL15_TOTAL"          , "SE2", "Total"               ,PesqPict("SE2","E2_SALDO"    ),20					 , /*lPixel*/, /* Formula*/)


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
Private aDados[15]
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {}


oSection:Cell("CEL01_FILIAL"  ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_PREF"    ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_NUM"     ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_PARC"    ):SetBlock( { || aDados[04]}) 
oSection:Cell("CEL05_PEDCOM"  ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_SOLIC"   ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_NATUR"   ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_FORNEC"  ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_NOMFOR"  ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_EMISS"   ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_VENC"    ):SetBlock( { || aDados[11]})
oSection:Cell("CEL12_VALOR"   ):SetBlock( { || aDados[12]})
oSection:Cell("CEL13_SALDO"   ):SetBlock( { || aDados[13]})
oSection:Cell("CEL14_ACRES"   ):SetBlock( { || aDados[14]})
oSection:Cell("CEL15_TOTAL"   ):SetBlock( { || aDados[15]})


//Faturamento por UF
//If mv_par09 == 2
// 	oBreak := TRBreak():New(oSection,oSection:Cell("CEL05_EST"),,.F.)
//	TRFunction():New(oSection:Cell("CEL07_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)

oBreak := TRBreak():New(oSection,oSection:Cell("CEL08_FORNEC"),,.F.)
TRFunction():New(oSection:Cell("CEL12_VALOR"),"TOT","SUM"  ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL13_SALDO"),"TOT","SUM"  ,oBreak,"Total do Saldo","@E 999,999,999.99",,.F.,.T.) 
TRFunction():New(oSection:Cell("CEL14_ACRES"),"TOT","SUM"  ,oBreak,"Total do Acres","@E 999,999,999.99",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL15_TOTAL"),"TOT","SUM"  ,oBreak,"Total Geral   ","@E 999,999,999.99",,.F.,.T.)
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

_cQry := "SELECT DISTINCT SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SD1.D1_PEDIDO,SE2.E2_PARCELA,SE2.E2_TIPO,SED.ED_DESCRIC,SE2.E2_FORNECE, SE2.E2_LOJA, "
_cQry += "SE2.E2_NOMFOR,SE2.E2_EMISSAO,SE2.E2_VENCREA,SE2.E2_VALOR,SE2.E2_SALDO,E2_ACRESC,E2_HIST "
_cQry += "FROM " + retsqlname("SE2")+" SE2 "  
_cQry += " INNER JOIN " + retsqlname("SED")+" SED ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ <> '*'  "	  
_cQry += " INNER JOIN " + retsqlname("SD1")+" SD1 ON E2_FILIAL = D1_FILIAL AND E2_PREFIXO = D1_SERIE AND E2_NUM = D1_DOC AND E2_FORNECE = D1_FORNECE AND E2_LOJA = D1_LOJA AND SD1.D_E_L_E_T_ <> '*' "	
_cQry += "WHERE SE2.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SE2.E2_SALDO > 0 "
_cQry += "AND   SE2.E2_FILIAL   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   SE2.E2_EMISSAO	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "AND   SE2.E2_VENCREA	BETWEEN '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06)  + "' "
_cQry += "AND   SE2.E2_FORNECE  BETWEEN '" + mv_par07  + "' AND '" + mv_par08  + "' "
_cQry += "ORDER BY SE2.E2_FILIAL, SE2.E2_FORNECE,SE2.E2_LOJA, SE2.E2_VENCREA,SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA  "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf	 
	  
    _Solic :=Posicione("SC7",1,xFilial("SC7")+TMP->D1_PEDIDO,"C7_USER")    

	aDados[01] := TMP->E2_FILIAL
	aDados[02] := TMP->E2_PREFIXO
	aDados[03] := TMP->E2_NUM
	aDados[04] := TMP->E2_PARCELA
	aDados[05] := TMP->D1_PEDIDO    //Pedido de Compra
	aDados[06] := UsrRetName(_Solic)	//Solicitante
	aDados[07] := TMP->ED_DESCRIC
	aDados[08] := TMP->E2_FORNECE
	aDados[09] := TMP->E2_NOMFOR
	aDados[10] := CVALTOCHAR(STOD(TMP->E2_EMISSAO))
	aDados[11] := CVALTOCHAR(STOD(TMP->E2_VENCREA)) 
	aDados[12] := TMP->E2_VALOR 
	aDados[13] := TMP->E2_SALDO 
	aDados[14] := TMP->E2_ACRESC
	aDados[15] := TMP->E2_ACRESC + TMP->E2_SALDO	
	
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
aAdd(aRegs,{cPerg,"05","Vencimento de  ?","","","mv_ch5","D",10,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"06","Vencimento Ate ?","","","mv_ch6","D",10,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"07","Fornecedor de  ?","","","mv_ch7","C",09,0,0,"G","","mv_par07",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA2"})
aAdd(aRegs,{cPerg,"08","Fornecedor Ate ?","","","mv_ch8","C",09,0,0,"G","","mv_par08",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA2"})


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
			AADD(aHelpPor,"Informe o Vencimento Final.           ")		
		ElseIf i==6
			AADD(aHelpPor,"Informe o Vencimento Final.           ")		
		ElseIf i==7
			AADD(aHelpPor,"Informe o Fornecedor Final.           ")			
		ElseIf i==8
			AADD(aHelpPor,"Informe o Fornecedor Final.           ")		
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return
