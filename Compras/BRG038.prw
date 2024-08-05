#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRG038 บ Autor ณ Ricardo Moreira     บ Data ณ  31/05/2021  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio Valores por centro de custo                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BRG                              			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BRG038 //U_PHA005()

Private cPerg       := PADR("BRG038",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio de Entradas por Centro de Custo - " + CVALTOCHAR(MV_PAR03) + " a " +CVALTOCHAR(MV_PAR04)

oReport  := TReport():New("BRG038",cTitulo,"BRG038",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  

oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio de Contas a Pagar - Por Vencimento",{""})
TRCell():New(oSection, "CEL01_FILIAL"         , "SD1", "Filial"             ,PesqPict("SD1","D1_FILIAL"   ),05                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_NUM"            , "SD1", "Documento"          ,PesqPict("SD1","D1_DOC"      ),10                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_PREF"           , "SD1", "Pref"               ,PesqPict("SD1","D1_SERIE"    ),04				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_ITEM"       	  , "SD1", "Item"               ,PesqPict("SD1","D1_ITEM"     ),04	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_COD"       	  , "SD1", "Cod"                ,PesqPict("SD1","D1_COD"      ),04	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_UM"             , "SD1", "UM"         	    ,PesqPict("SD1","D1_UM"       ),25                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_DESCPRO"        , "SB1", "Descricao"   		,PesqPict("SB1","B1_DESC"     ),40	  			     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_VALOR"          , "SD1", "Valor"      	    ,PesqPict("SD1","D1_TOTAL"    ),16					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_CC"             , "SD1", "Centro de Custo"    ,PesqPict("SD1","D1_CC"       ),15					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_DESCCC"         , "CTT", "Descricao"          ,PesqPict("CTT","CTT_DESC01"  ),30					 , /*lPixel*/, /* Formula*/)

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
LOCAL _DESC := ""
Private aDados[10]
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {}


oSection:Cell("CEL01_FILIAL"  ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_NUM"     ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_PREF"    ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_ITEM"    ):SetBlock( { || aDados[04]}) 
oSection:Cell("CEL05_COD"     ):SetBlock( { || aDados[05]}) 
oSection:Cell("CEL06_UM"      ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_DESCPRO" ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_VALOR"   ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_CC"      ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_DESCCC"  ):SetBlock( { || aDados[10]})

//Faturamento por UF
//If mv_par09 == 2
// 	oBreak := TRBreak():New(oSection,oSection:Cell("CEL05_EST"),,.F.)
//	TRFunction():New(oSection:Cell("CEL07_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)

oBreak := TRBreak():New(oSection,oSection:Cell("CEL09_CC"),,.F.)
TRFunction():New(oSection:Cell("CEL08_VALOR"),"TOT","SUM"  ,oBreak,"Total","@E 999,999,999.99",,.F.,.T.)
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

_cQry := " SELECT DISTINCT DE_FILIAL FILIAL, DE_DOC DOC, DE_SERIE SERIE , DE_ITEMNF ITEM, D1_COD CODIGO, D1_UM UM, DE_CUSTO1 VALOR ,DE_CC CC, CTT_DESC01 DESC_CC "
_cQry += " FROM " + retsqlname("SDE")+" SDE "  
_cQry += " LEFT JOIN " + retsqlname("SD1")+" SD1 ON DE_FILIAL = D1_FILIAL AND DE_DOC = D1_DOC  AND DE_SERIE = D1_SERIE AND D1_FORNECE = DE_FORNECE AND D1_LOJA = DE_LOJA  AND D1_ITEM =  DE_ITEMNF AND SD1.D_E_L_E_T_ <> '*'  "	
_cQry += " LEFT JOIN " + retsqlname("CTT")+" CTT ON DE_FILIAL = CTT_FILIAL AND DE_CC = CTT_CUSTO  AND CTT.D_E_L_E_T_ <> '*' "	
_cQry += " WHERE SDE.D_E_L_E_T_ <> '*' " 
_cQry += " AND   D1_CC = '' "
_cQry += " AND   D1_FILIAL   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += " AND   D1_DTDIGIT	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "

_cQry += " UNION "

_cQry += " SELECT DISTINCT D1_FILIAL FILIAL, D1_DOC DOC, D1_SERIE SERIE ,D1_ITEM ITEM, D1_COD CODIGO, D1_UM UM,  D1_TOTAL VALOR, D1_CC CC, CTT_DESC01 DESC_CC "
_cQry += " FROM " + retsqlname("SD1")+" SD1 "  
_cQry += " LEFT JOIN " + retsqlname("CTT")+" CTT ON D1_FILIAL = CTT_FILIAL AND D1_CC = CTT_CUSTO  AND CTT.D_E_L_E_T_ <> '*' "	
_cQry += " WHERE SD1.D_E_L_E_T_ <> '*' " 
_cQry += " AND D1_CC <> '' "
_cQry += " AND   D1_FILIAL   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += " AND   D1_DTDIGIT	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += " ORDER BY FILIAL, CC "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf	

    _DESC := POSICIONE("SB1",1,XFILIAL("SB1")+TMP->CODIGO,"B1_DESC") 

	aDados[01] := TMP->FILIAL
	aDados[02] := TMP->DOC
	aDados[03] := TMP->SERIE
	aDados[04] := TMP->ITEM
	aDados[05] := TMP->CODIGO
	aDados[06] := TMP->UM
	aDados[07] := _DESC
	aDados[08] := TMP->VALOR
	aDados[09] := TMP->CC
	aDados[10] := TMP->DESC_CC
	
	
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
 
aAdd(aRegs,{cPerg,"01","Filial de           ?","","","mv_ch1","C",04,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"02","Filial Ate          ?","","","mv_ch2","C",04,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"03","Data Entrada de     ?","","","mv_ch3","D",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"04","Data Entrada Ate    ?","","","mv_ch4","D",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})


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
			AADD(aHelpPor,"Informe a Data Entrada Inicial.       ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe a Data Entrada Final.         ")		
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return
