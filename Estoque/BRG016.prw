#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRG016 บ Autor ณ Ricardo Moreira     บ Data ณ  04/05/20    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de OP's ainda Pendentes para apontamento (VALOR) บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BRG GERADORES		              			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BRG016 //U_BRG016

Private cPerg       := PADR("BRG016",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio OP's Abertas com Insumos"

oReport  := TReport():New("BRG016",cTitulo,"BRG016",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  
//oReport:SetPortrait()    // Retrato
oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio OP's Abertas com Insumos",{""})
TRCell():New(oSection, "CEL01_FILIAL"          , "SD3", "Produto"                ,PesqPict("SD3","D3_FILIAL"   ),05                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_PRODUTO"         , "SC2", "Produto"                ,PesqPict("SC2","C2_PRODUTO"  ),12                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_DESC"            , "SB1", "Descricao"              ,PesqPict("SB1","B1_DESC"     ),50				      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_OP"              , "SD3", "Op"                     ,PesqPict("SD3","D3_OP"       ),20 				  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_QTDTOT"          , "SC2", "Qtde Total"  			 ,PesqPict("SC2","C2_QUANT"    ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_QTDENTR"         , "SC2", "Qtde Entregue"  		 ,PesqPict("SC2","C2_QUJE"     ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_QTDABER"         , "SC2", "Qtde Aberto"  			 ,PesqPict("SC2","C2_QUANT"    ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_DATA"            , "SC2", "Data da OP"             ,PesqPict("SC2","C2_DATPRI"   ),15                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_CUSTTOT"         , "SD3", "Total Custo"            ,PesqPict("SD3","D3_CUSTO1"   ),15	    			  , /*lPixel*/, /* Formula*/)

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
Private aDados[09]

oSection:Cell("CEL01_FILIAL"  ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_PRODUTO" ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_DESC"    ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_OP"      ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_QTDTOT"  ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_QTDENTR" ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_QTDABER" ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_DATA"    ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_CUSTTOT" ):SetBlock( { || aDados[09]})


oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FILIAL"),,.F.)
TRFunction():New(oSection:Cell("CEL05_QTDTOT"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.999",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL06_QTDENTR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.999",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL07_QTDABER"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.999",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL09_CUSTTOT"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.9999",,.F.,.F.)

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := "SELECT DISTINCT D3_FILIAL, C2_PRODUTO, B1_DESC, D3_OP,C2_DATPRI,C2_PRODUTO,C2_QUANT,C2_QUJE, SUM(D3_CUSTO1) CUSTO_TOTAL  "
_cQry += "FROM " + retsqlname("SC2")+" SC2 "  
_cQry += " LEFT JOIN " + retsqlname("SD3")+" SD3 ON D3_FILIAL = C2_FILIAL AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SD3.D_E_L_E_T_ <> '*' "	
_cQry += " LEFT JOIN " + retsqlname("SB1")+" SB1 ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ <> '*' "	
_cQry += "WHERE SC2.D_E_L_E_T_ <> '*' " 
_cQry += "AND   D3_ESTORNO <> 'S' "
_cQry += "AND   D3_CF IN ('RE6','RE0') "   
_cQry += "AND   B1_FILIAL = '" + substr(cFilAnt,1,2) + "' "
_cQry += "AND   C2_DATRF = '' "
_cQry += "AND   C2_FILIAL   BETWEEN '" + cFilAnt  + "' AND '" + cFilAnt  + "' "
_cQry += "AND   C2_DATPRI 	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "AND   D3_OP	BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "GROUP BY D3_FILIAL, C2_PRODUTO, B1_DESC, D3_OP,C2_DATPRI,C2_PRODUTO,C2_QUANT,C2_QUJE "
_cQry += "ORDER BY D3_FILIAL,D3_OP "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE !TMP->(EOF())
	
	If oReport:Cancel()
		Exit
	EndIf
	aDados[01] := TMP->D3_FILIAL	
	aDados[02] := TMP->C2_PRODUTO 
	aDados[03] := TMP->B1_DESC
	aDados[04] := TMP->D3_OP	
	aDados[05] := TMP->C2_QUANT
	aDados[06] := TMP->C2_QUJE
	aDados[07] := TMP->C2_QUANT - TMP->C2_QUJE 
	aDados[08] := CVALTOCHAR(STOD(TMP->C2_DATPRI))
	aDados[09] := (TMP->CUSTO_TOTAL/TMP->C2_QUANT)*IF(TMP->C2_QUANT>TMP->C2_QUJE,TMP->C2_QUANT-TMP->C2_QUJE,1) - DEVCUSTO()	   
	
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

aAdd(aRegs,{cPerg,"01","Op de      		  ?","","","mv_ch1","C",14,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SC2"})
aAdd(aRegs,{cPerg,"02","Op Ate     		  ?","","","mv_ch2","C",14,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SC2"})
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
			AADD(aHelpPor,"Informe a Op Inicial.             ")
		ElseIf i==2                                            
			AADD(aHelpPor,"Informe a Op Final.               ")	 
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

//Retorna o VAlor da Op

Static Function DEVCUSTO()
//Verifica se o arquivo TMP estแ em uso

Local _Custo := ""

	If Select("TTMP") > 0
	   TTMP->(DbCloseArea())
	EndIf
	
cQry := "SELECT DISTINCT D3_FILIAL,D3_OP, SUM(D3_CUSTO1) CUSTO_DEV  "
cQry += "FROM " + retsqlname("SD3")+" SD3 "  
cQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
cQry += "AND   D3_ESTORNO <> 'S' "
cQry += "AND   D3_CF IN ('DE0','DE6') "   
cQry += "AND   D3_FILIAL   BETWEEN '" + cFilAnt  + "' AND '" + cFilAnt  + "' "
cQry += "AND   D3_OP	BETWEEN '" + TMP->D3_OP  + "' AND '" + TMP->D3_OP  + "' "
cQry += "GROUP BY D3_FILIAL,  D3_OP  "

	
DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TTMP",.T.,.T.) 

_Custo := TTMP->CUSTO_DEV
	
Return _Custo
