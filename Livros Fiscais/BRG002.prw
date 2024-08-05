#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRG002 บ Autor ณ Ricardo Moreira     บ Data ณ  03/04/18    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Livros Fiscais                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BRG GERADORES		              			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BRG002 //U_BRG002

Private cPerg       := PADR("BRG002",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio de Registros Entradas/Saidas"

oReport  := TReport():New("BRG002",cTitulo,"BRG002",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  
//oReport:SetPortrait()    // Retrato
oreport:nfontbody:=5
oreport:cfontbody:= "Courier New" //"Arial"
//SELECT F3_FILIAL, F3_ENTRADA,FT_TIPOMOV, F3_ESPECIE,F3_NFISCAL, F3_SERIE,F3_EMISSAO, A2_CGC ,A2_INSCR, F3_CFO, F3_ESTADO ,
//F3_ALIQICM, F3_VALCONT, F3_BASEICM,F3_VALICM, F3_BASEIPI, F3_VALIPI, F3_OBSERV  
//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio de Registros Entradas/Saidas",{""})
TRCell():New(oSection, "CEL01_FILIAL"     , "SF3", "Filial"            ,PesqPict("SF3","F3_FILIAL"   ),05                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_ENTRADA"    , "SF3", "Entrada"           ,PesqPict("SF3","F3_ENTRADA"  ),16				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_ESPECIE"    , "SF3", "Especie"           ,PesqPict("SF3","F3_ESPECIE"  ),04                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_NFISCAL"    , "SF3", "Documento"         ,PesqPict("SF3","F3_NFISCAL"  ),12                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_SERIE"      , "SF3", "Serie"             ,PesqPict("SF3","F3_SERIE"    ),05	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_EMISSAO"    , "SF3", "Emissao"       	   ,PesqPict("SF3","F3_EMISSAO"  ),16	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_CGC"        , "SA2", "CGC"               ,PesqPict("SA2","A2_CGC"      ),24                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_INSCR"      , "SA2", "IE"                ,PesqPict("SA2","A2_INSCR"    ),22                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_CFO"        , "SF3", "CFO"               ,PesqPict("SF3","F3_CFO"      ),08                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_EST"        , "SF3", "UF"                ,PesqPict("SF3","F3_ESTADO"   ),04                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_VALCONT"    , "SF3", "Valor"       	   ,PesqPict("SF3","F3_VALCONT"  ),15	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL12_BASEICM"    , "SF3", "Base ICMS"         ,PesqPict("SF3","F3_BASEICM"  ),15                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL13_ALIQICM"    , "SF3", "Aliq ICMS"         ,PesqPict("SF3","F3_ALIQICM"  ),15	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL14_VALICM"     , "SF3", "Valor ICMS"        ,PesqPict("SF3","F3_VALICM"   ),15                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL15_BASEIPI"    , "SF3", "Base IPI"          ,PesqPict("SF3","F3_BASEIPI"  ),15                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL16_ALIQIPI"    , "SF3", "Aliq IPI"          ,PesqPict("SF3","F3_ALIQIPI"  ),15	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL17_VALIPI"     , "SF3", "Val IPI"           ,PesqPict("SF3","F3_VALIPI"   ),15                    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL18_OBSERV"     , "SF3", "Observ"            ,PesqPict("SF3","F3_OBSERV"   ),32                    , /*lPixel*/, /* Formula*/)

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
Private aDados[18]


oSection:Cell("CEL01_FILIAL"  ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_ENTRADA" ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_ESPECIE" ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_NFISCAL" ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_SERIE"   ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_EMISSAO" ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_CGC"     ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_INSCR"   ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_CFO"     ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_EST"     ):SetBlock( { || aDados[10]})  
oSection:Cell("CEL11_VALCONT" ):SetBlock( { || aDados[11]})
oSection:Cell("CEL12_BASEICM" ):SetBlock( { || aDados[12]})
oSection:Cell("CEL13_ALIQICM" ):SetBlock( { || aDados[13]})
oSection:Cell("CEL14_VALICM"  ):SetBlock( { || aDados[14]})
oSection:Cell("CEL15_BASEIPI" ):SetBlock( { || aDados[15]})
oSection:Cell("CEL16_ALIQIPI" ):SetBlock( { || aDados[16]})
oSection:Cell("CEL17_VALIPI"  ):SetBlock( { || aDados[17]})
oSection:Cell("CEL18_OBSERV"  ):SetBlock( { || aDados[18]})

oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FILIAL"),,.F.) 
oBreak := TRBreak():New(oSection,oSection:Cell("CEL02_ENTRADA"),,.F.)
TRFunction():New(oSection:Cell("CEL11_VALCONT"),"TOT","SUM"  ,oBreak,"Total do Saldo","@E 999,999,999.99",,.F.,.T.)  
TRFunction():New(oSection:Cell("CEL14_VALICM"),"TOT","SUM"   ,oBreak,"Total do Saldo","@E 999,999,999.99",,.F.,.T.)
TRFunction():New(oSection:Cell("CEL17_VALIPI"),"TOT","SUM"   ,oBreak,"Total do Saldo","@E 999,999,999.99",,.F.,.T.)


//oBreak := TRBreak():New(oSection,oSection:Cell("CEL09_FILIAL"),,.F.)
//TRFunction():New(oSection:Cell("CEL06_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf                                          //cast(F3_NFISCAL as numeric)
IF MV_PAR05 = 1 //Entrada
	_cQry := "SELECT DISTINCT F3_FILIAL, F3_ENTRADA,FT_TIPOMOV, F3_ESPECIE,cast(F3_NFISCAL as numeric) NOTA, F3_SERIE,F3_EMISSAO, A2_CGC CGC ,A2_INSCR INSCR, F3_CFO, F3_ESTADO , F3_ALIQICM, F3_VALCONT, F3_BASEICM,F3_VALICM, F3_BASEIPI,F3_ALIQIPI,F3_VALIPI, F3_OBSERV  "
Else
	_cQry := "SELECT DISTINCT F3_FILIAL, F3_ENTRADA,FT_TIPOMOV, F3_ESPECIE,cast(F3_NFISCAL as numeric) NOTA, F3_SERIE,F3_EMISSAO, A1_CGC CGC ,A1_INSCR INSCR, F3_CFO, F3_ESTADO , F3_ALIQICM, F3_VALCONT, F3_BASEICM,F3_VALICM, F3_BASEIPI,F3_ALIQIPI, F3_VALIPI, F3_OBSERV  "
EndIf
_cQry += "FROM " + retsqlname("SF3")+" SF3 "  
_cQry += " LEFT JOIN " + retsqlname("SFT")+" SFT ON F3_FILIAL = FT_FILIAL AND FT_NFISCAL = F3_NFISCAL AND F3_SERIE = FT_SERIE AND F3_CLIEFOR = FT_CLIEFOR AND F3_LOJA = FT_LOJA AND SFT.D_E_L_E_T_ <> '*' "	
IF MV_PAR05 = 1 //Entrada
	_cQry += " LEFT JOIN " + retsqlname("SA2")+" SA2  ON A2_COD = F3_CLIEFOR AND A2_LOJA = F3_LOJA AND SA2.D_E_L_E_T_ <> '*' "	
Else
	_cQry += " LEFT JOIN " + retsqlname("SA1")+" SA1  ON A1_COD = F3_CLIEFOR AND A1_LOJA = F3_LOJA AND SA1.D_E_L_E_T_ <> '*' "
EndIf
_cQry += "WHERE SF3.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SF3.F3_FILIAL   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   SF3.F3_ENTRADA 	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "AND   SF3.F3_ESPECIE NOT IN ('RPS','FATLO') " 

IF MV_PAR05 = 1  //Entrada
	_cQry += "AND SFT.FT_TIPOMOV = 'E' " 
Else
	_cQry += "AND SFT.FT_TIPOMOV = 'S' " 
EndIf
_cQry += "ORDER BY 1,3,2,5 "     //F3_FILIAL,FT_TIPOMOV, F3_ENTRADA, F3_NFISCAL, F3_SERIE

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf	
	aDados[01] := TMP->F3_FILIAL
	aDados[02] := CVALTOCHAR(STOD(TMP->F3_ENTRADA))
	aDados[03] := TMP->F3_ESPECIE
	aDados[04] := TMP->NOTA
	aDados[05] := TMP->F3_SERIE
	aDados[06] := CVALTOCHAR(STOD(TMP->F3_EMISSAO))
	aDados[07] := TMP->CGC
	aDados[08] := TMP->INSCR
	aDados[09] := TMP->F3_CFO
    aDados[10] := TMP->F3_ESTADO
    aDados[11] := TMP->F3_VALCONT
	aDados[12] := TMP->F3_BASEICM
	aDados[13] := TMP->F3_ALIQICM
	aDados[14] := TMP->F3_VALICM
	aDados[15] := TMP->F3_BASEIPI
	aDados[16] := TMP->F3_ALIQIPI
	aDados[17] := TMP->F3_VALIPI
	aDados[18] := TMP->F3_OBSERV
	
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
aAdd(aRegs,{cPerg,"03","Data Entrada de       ?","","","mv_ch3","D",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"04","Data Entrada Ate      ?","","","mv_ch4","D",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"05","Entrada/Saida         ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Entrada"  ,"","","","","Saida"	      ,"","","","","","","","","","","","","","","","","","","   "})

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
			AADD(aHelpPor,"Informe a Filial Inicial.       ")
		ElseIf i==2                                            
			AADD(aHelpPor,"Informe a Filial Final.         ")	 
		ElseIf i==3
			AADD(aHelpPor,"Informe a Data Inicial.         ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe a Data Final.           ")		
		ElseIf i==5
			AADD(aHelpPor,"Entrada/Saida.                  ") 
		EndIf
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return     
