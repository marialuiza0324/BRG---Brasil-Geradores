#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AviVenc บ Autor ณ Ricardo Moreira     บ Data ณ  07/01/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio Titulos a Vencer (email)                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BRG                     			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AviAVenc //U_AviAVenc()

Private cPerg       := PADR("AviAVenc",Len(SX1->X1_GRUPO))
//Chama relatorio personalizado
//ValidPerg1()
//pergunte(cPerg,.F.)    // sem tela de pergunta

oReport := ReportDef1() // Chama a funcao personalizado onde deve buscar as informacoes
oReport:PrintDialog()  // Cria a tela de parametros no modo personalizado apos buscar as informacoes

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ Ricardo      บ Data ณ  28/07/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA funcao estatica ReportDef devera ser criada para todos os บฑฑ
ฑฑบ          ณrelatorios que poderao ser agendados pelo usuario.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef1() //Cria o Cabe็alho em excel

Local oReport, oSection, oBreak

cTitulo := "Relatorio dos titulos enviados por email (Aviso de ม Vencimento)"

oReport  := TReport():New("AviAVenc",cTitulo,"AviAVenc",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  

oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio dos titulos enviados por email (Aviso de ม Vencimento)",{""})
TRCell():New(oSection, "CEL01_FILIAL"         , "SE1", "Filial"              ,PesqPict("SE1","E1_FILIAL"   ),06                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_PREF"           , "SE1", "Pref"                ,PesqPict("SE1","E1_PREFIXO"  ),04				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_NUM"            , "SE1", "Titulo"              ,PesqPict("SE1","E1_NUM"      ),10                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_PARC"       	  , "SE1", "Parc"                ,PesqPict("SE1","E1_PARCELA"  ),04	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_TIPO"       	  , "SE1", "Tipo"                ,PesqPict("SE1","E1_TIPO"     ),04	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_CLIENTE"        , "SE1", "Cliente"   		     ,PesqPict("SE1","E1_CLIENTE"  ),10	  			     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_NOMCLI"         , "SA1", "RazaoSocial"      	 ,PesqPict("SA1","A1_NOME"     ),45					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_EMISS"          , "SE1", "Emissao"             ,PesqPict("SE1","E1_EMISSAO"  ),16					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_VENC"           , "SE1", "Vencimento"          ,PesqPict("SE1","E1_VENCREA"  ),16					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_SALDO"          , "SE1", "Saldo"               ,PesqPict("SE1","E1_SALDO"    ),16					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_EMAIL"          , "SE1", "Email"               ," "                           ,60					 , /*lPixel*/, /* Formula*/)
 
//aAdd(oSection:Cell("E1_VALOR"):aFormatCond, {"E1_VALOR > 100 .and. E1_VALOR < 1000" ,,CLR_GREEN})
//aAdd(oSection:Cell("CEL09_VALOR"):aFormatCond, {"E1_VENCREA < date()",,CLR_RED})

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
Local dDtaVenc  := DaySum(DDATABASE, 1)
Private aDados[11]
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
oSection:Cell("CEL05_TIPO"    ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_CLIENTE" ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_NOMCLI"  ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_EMISS"   ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_VENC"    ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_SALDO"   ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_EMAIL"   ):SetBlock( { || aDados[11]})

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := "SELECT E1_FILIAL, E1_PREFIXO, E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,A1_NOME,A1_EMAIL,A1_ENVCOB "
_cQry += ",E1_EMISSAO,E1_VENCREA,E1_SALDO "
_cQry += "FROM " + retsqlname("SE1")+" SE1 "  
_cQry += " INNER JOIN " + retsqlname("SA1")+" SA1 ON E1_CLIENTE  = A1_COD AND E1_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ <> '*' "
_cQry += "WHERE SE1.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SE1.E1_SALDO > 0 "
//_cQry += "AND   SE1.E1_CLIENTE = '016475581' "
_cQry += "AND   SA1.A1_ENVCOB <> 'N' "  
_cQry += "AND   SE1.E1_TIPO = 'NF' "   //33845322 
_cQry += "AND   SE1.E1_FILIAL  BETWEEN '" + xFilial("SE1")  + "' AND '" + xFilial("SE1")  + "' "
_cQry += "AND   SE1.E1_VENCREA = '" + DTOS(dDtaVenc)+ "' "
_cQry += "ORDER BY SE1.E1_FILIAL,SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	aDados[01] := xFilial("SE1")
	aDados[02] := TMP->E1_PREFIXO
	aDados[03] := TMP->E1_NUM
	aDados[04] := TMP->E1_PARCELA
    aDados[05] := TMP->E1_TIPO		
	aDados[06] := TMP->E1_CLIENTE
	aDados[07] := TMP->A1_NOME	
	aDados[08] := CVALTOCHAR(STOD(TMP->E1_EMISSAO))	
	aDados[09] := CVALTOCHAR(STOD(TMP->E1_VENCREA))	 
	aDados[10] := TMP->E1_SALDO 
	aDados[11] := TMP->A1_EMAIL
	 
		
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

aAdd(aRegs,{cPerg,"01","Filial de      ?","","","mv_ch1","C",06,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"02","Filial Ate     ?","","","mv_ch2","C",06,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"03","Emissใo de     ?","","","mv_ch3","D",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"04","Emissใo Ate    ?","","","mv_ch4","D",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"05","Vencimento de  ?","","","mv_ch5","D",10,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"06","Vencimento Ate ?","","","mv_ch6","D",10,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"07","Cliente    de  ?","","","mv_ch7","C",06,0,0,"G","","mv_par07",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"08","Cliente    Ate ?","","","mv_ch8","C",06,0,0,"G","","mv_par08",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA1"})


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
			AADD(aHelpPor,"Informe o Cliente Final.              ")			
		ElseIf i==8                                        
			AADD(aHelpPor,"Informe o Cliente Final.              ")		
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return
