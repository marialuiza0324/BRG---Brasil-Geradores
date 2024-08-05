#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


User function BRG041()

Private cPerg       := PADR("BRG041",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio de Faturamento Sint้tico por CFOP"

oReport  := TReport():New("BRG041",cTitulo,"BRG041",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  

oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio Faturamento Sintetico - Por CFOP",{""})
TRCell():New(oSection, "CEL01_FILIAL"         , "SD2", "Filial"              ,PesqPict("SD2","D2_FILIAL"   ),05                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_NF"             , "SD2", "Nota Fiscal"         ,PesqPict("SD2","D2_DOC"      ),10				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_SERIE"          , "SD2", "Serie"               ,PesqPict("SD2","D2_SERIE"    ),02                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_CODCLI"         , "SA1", "Codigo"              ,PesqPict("SA1","A1_COD"      ),12	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_LOJA"           , "SA1", "Loja"         	     ,PesqPict("SA1","A1_LOJA"     ),04                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_DESCCLI"        , "SA1", "Razao Social"   	 ,PesqPict("SA1","A1_NOME"     ),45	  			     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_EMISSAO"        , "SD2", "Emissใo"   	         ,PesqPict("SD2","D2_EMISSAO"  ),12	  			     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_VALOR"          , "SD2", "Valor"      	     ,PesqPict("SD2","D2_TOTAL"    ),16					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_CFOP"           , "SD2", "CFOP"          		 ,PesqPict("SD2","D2_CF"       ),16				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_BASEICM"        , "SD2", "Base Icms"           ,PesqPict("SD2","D2_BASEICM"  ),14				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_VLRICM"         , "SD2", "Valor Icms"          ,PesqPict("SD2","D2_VALICM"   ),14				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL12_BASEIPI"        , "SD2", "Base Ipi"          	 ,PesqPict("SD2","D2_BASEIPI"  ),14				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL13_VLRIPI"         , "SD2", "Valor Ipi"           ,PesqPict("SD2","D2_VALIPI"   ),14				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL14_BASEISS"        , "SD2", "Base Iss"          	 ,PesqPict("SD2","D2_BASEISS"  ),14				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL15_VLRISS"         , "SD2", "Valor Iss"           ,PesqPict("SD2","D2_VALISS"   ),14				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL16_BASECOF"        , "SD2", "Base Cofins"         ,PesqPict("SD2","D2_BASIMP5"  ),14				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL17_VLRCOF"         , "SD2", "Valor Cofins"        ,PesqPict("SD2","D2_VALIMP5"  ),14				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL18_BASEPIS"        , "SD2", "Base Pis"          	 ,PesqPict("SD2","D2_BASIMP6"  ),14				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL19_VLRPIS"         , "SD2", "Valor Pis"           ,PesqPict("SD2","D2_VALIMP6"  ),14				     , /*lPixel*/, /* Formula*/)


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
Private aDados[19]
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {}


oSection:Cell("CEL01_FILIAL"  ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_NF"      ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_SERIE"   ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_CODCLI"  ):SetBlock( { || aDados[04]}) 
oSection:Cell("CEL05_LOJA"    ):SetBlock( { || aDados[05]}) 
oSection:Cell("CEL06_DESCCLI" ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_EMISSAO" ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_VALOR"   ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_CFOP"    ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_BASEICM"   ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_VLRICM"  ):SetBlock( { || aDados[11]}) 
oSection:Cell("CEL12_BASEIPI"    ):SetBlock( { || aDados[12]}) 
oSection:Cell("CEL13_VLRIPI" ):SetBlock( { || aDados[13]})
oSection:Cell("CEL14_BASEISS" ):SetBlock( { || aDados[14]})
oSection:Cell("CEL15_VLRISS"   ):SetBlock( { || aDados[15]})
oSection:Cell("CEL16_BASECOF"    ):SetBlock( { || aDados[16]})
oSection:Cell("CEL17_VLRCOF" ):SetBlock( { || aDados[17]})
oSection:Cell("CEL18_BASEPIS"   ):SetBlock( { || aDados[18]})
oSection:Cell("CEL19_VLRPIS"    ):SetBlock( { || aDados[19]})
 
 


//Faturamento por UF
//If mv_par09 == 2
// 	oBreak := TRBreak():New(oSection,oSection:Cell("CEL05_EST"),,.F.)
//	TRFunction():New(oSection:Cell("CEL07_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)

oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FILIAL"),,.F.)
oBreak := TRBreak():New(oSection,oSection:Cell("CEL09_CFOP"),,.F.)
oBreak := TRBreak():New(oSection,oSection:Cell("CEL02_NF"),,.F.)

TRFunction():New(oSection:Cell("CEL08_VALOR"),"TOT","SUM"   ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL10_BASEICM"),"TOT","SUM" ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL11_VLRICM"),"TOT","SUM"  ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL12_BASEIPI"),"TOT","SUM" ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL13_VLRIPI"),"TOT","SUM"  ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL14_BASEISS"),"TOT","SUM" ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL15_VLRISS"),"TOT","SUM"  ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL16_BASECOF"),"TOT","SUM" ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL17_VLRCOF"),"TOT","SUM"  ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL18_BASEPIS"),"TOT","SUM" ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection:Cell("CEL19_VLRPIS"),"TOT","SUM"  ,oBreak,"Total Original","@E 999,999,999.99",,.F.,.F.)
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

If MV_PAR05 = 1

_cQry := "SELECT D2_FILIAL Filial , D2_DOC Doc,D2_TIPO Tipo ,D2_SERIE Serie , D2_CLIENTE Cli_For , D2_LOJA Loja , A1_NOME Nome, D2_EMISSAO Data_ , D2_CF CFOP,SUM(D2_VALICM) Vlr_Icms,SUM(D2_BASEICM) Base_Icms, "
_cQry += "SUM(D2_BASEIPI) Base_Ipi, SUM(D2_VALIPI) Vlr_Ipi,SUM(D2_BASEISS) Base_Iss, SUM(D2_VALISS) Vlr_Iss ,SUM(D2_BASIMP5) Base_Cof, SUM(D2_VALIMP5) Vlr_Cof ,SUM(D2_BASIMP6) Base_Pis, SUM(D2_VALIMP6) Vlr_Pis ,SUM(D2_TOTAL) Total "
_cQry += "FROM " + retsqlname("SD2")+" SD2 "  
_cQry += " LEFT JOIN " + retsqlname("SA1")+" SA1 ON D2_CLIENTE = A1_COD  AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_  <> '*' "
_cQry += "WHERE   SD2.D_E_L_E_T_ <> '*' "
_cQry += "AND   D2_FILIAL    BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   D2_EMISSAO   BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' " 
_cQry += "GROUP BY D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, A1_NOME, D2_EMISSAO , D2_CF, D2_TIPO "
_cQry += "ORDER BY D2_FILIAL, D2_DOC, D2_SERIE "
else
_cQry := "SELECT D1_FILIAL Filial , D1_DOC Doc, D1_TIPO Tipo,D1_SERIE Serie , D1_FORNECE Cli_For , D1_LOJA Loja , A2_NOME Nome, D1_DTDIGIT Data_ , D1_CF CFOP, SUM(D1_VALICM) Vlr_Icms,SUM(D1_BASEICM) Base_Icms, "
_cQry += "SUM(D1_BASEIPI) Base_Ipi, SUM(D1_VALIPI) Vlr_Ipi, SUM(D1_BASEISS) Base_Iss, SUM(D1_VALISS) Vlr_Iss ,SUM(D1_BASIMP5) Base_Cof, SUM(D1_VALIMP5) Vlr_Cof ,SUM(D1_BASIMP6) Base_Pis, SUM(D1_VALIMP6) Vlr_Pis, SUM(D1_TOTAL + D1_DESPESA + D1_VALIPI - D1_VALDESC) Total "
_cQry += "FROM " + retsqlname("SD1")+" SD1 "  
_cQry += " LEFT JOIN " + retsqlname("SA2")+" SA2 ON D1_FORNECE = A2_COD  AND D1_LOJA = A2_LOJA AND SA2.D_E_L_E_T_  <> '*' "
_cQry += "WHERE   SD1.D_E_L_E_T_ <> '*' "
_cQry += "AND   D1_FILIAL    BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   D1_DTDIGIT   BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' " 
_cQry += "GROUP BY D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, A2_NOME, D1_DTDIGIT , D1_CF, D1_TIPO "
_cQry += "ORDER BY D1_FILIAL, D1_DOC, D1_SERIE "
 
EndIf    

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf

    iF TMP->Tipo = "D" 
       _Desc     := Posicione("SA1",1,xFilial("SA1")+TMP->Cli_For+TMP->Loja,"A1_NOME") 
       If  empty(_Desc)
           _Desc     := Posicione("SA2",1,xFilial("SA2")+TMP->Cli_For+TMP->Loja,"A2_NOME") 
       EndIf
    EndIf

	aDados[01] := TMP->Filial
	aDados[02] := TMP->Doc
	aDados[03] := TMP->Serie
	aDados[04] := TMP->Cli_For
	aDados[05] := TMP->Loja	
	aDados[06] := iF(TMP->Tipo = "D",_Desc,TMP->Nome)
	aDados[07] := STOD(TMP->Data_) 
	aDados[08] := TMP->Total	
	aDados[09] := TMP->CFOP	
    aDados[10] := TMP->Base_Icms	
	aDados[11] := TMP->Vlr_Icms
    aDados[12] := TMP->Base_Ipi	
	aDados[13] := TMP->Vlr_Ipi
    aDados[14] := TMP->Base_Iss	
	aDados[15] := TMP->Vlr_Iss
    aDados[16] := TMP->Base_Cof	
	aDados[17] := TMP->Vlr_Cof
    aDados[18] := TMP->Base_Pis	
	aDados[19] := TMP->Vlr_Pis
		
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

aAdd(aRegs,{cPerg,"01","Filial de         ?","","","mv_ch1","C",04,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"02","Filial Ate        ?","","","mv_ch2","C",04,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"03","Emissใo de        ?","","","mv_ch3","D",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"04","Emissใo Ate       ?","","","mv_ch4","D",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"05","Saidas/Entradas   ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Saidas"  ,"","","","","Entradas"	      ,"","","","","","","","","","","","","","","","","","","   "})

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
			AADD(aHelpPor,"Entrada/Saida                         ")			
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return


