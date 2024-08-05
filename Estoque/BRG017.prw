#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "topconn.ch"

user function BRG017()
	
Private cPerg       := PADR("BRG017",Len(SX1->X1_GRUPO))
Private nSaldo := 0
//Chama relatorio personalizado
ValidPerg1()
pergunte(cPerg,.F.)    // sem tela de pergunta

oReport := ReportDef1() // Chama a funcao personalizado onde deve buscar as informacoes
oReport:PrintDialog()  // Cria a tela de parametros no modo personalizado apos buscar as informacoes

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³ Ricardo Fiuza      º Data ³  28/07/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³A funcao estatica ReportDef devera ser criada para todos os º±±
±±º          ³relatorios que poderao ser agendados pelo usuario.          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef1() //Cria o Cabeçalho em excel

Local oReport, oSection, oBreak

cTitulo := "Relatorio de Material Produção - Necessidade : " + CVALTOCHAR(MV_PAR05) + " a " +CVALTOCHAR(MV_PAR06)+ " Tipo:" + If(MV_PAR09 = 1, "FIRME", "PREVISTA")
 
oReport  := TReport():New("BRG017",cTitulo,"BRG017",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  
//oReport:SetPortrait()    // Retrato
oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio de Material Produção",{""})
TRCell():New(oSection, "CEL01_PRODUTO"         , "SCP", "Produto"            ,PesqPict("SCP","CP_PRODUTO"  ),12                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_DESC"            , "SB1", "Descricao"          ,PesqPict("SB1","B1_DESC"     ),50				      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_UNID"            , "SCP", "Unid"               ,PesqPict("SCP","CP_UM"       ),05 				  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_ALMOX"           , "SCP", "Local"  			 ,PesqPict("SCP","CP_LOCAL"    ),05                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_QTDSOLIC"        , "SCP", "Qtde Solicitada"  	 ,PesqPict("SCP","CP_QUANT"    ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_QTDDISP"         , "SC2", "Qtde Disponível"  	 ,PesqPict("SCP","CP_QUANT"    ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_ENDERE"          , "SCP", "Endereço"           ,PesqPict("SCP","CP_XENDERE"  ),15                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_DATAEMIS"        , "SCP", "Emissão"            ,PesqPict("SCP","CP_EMISSAO"  ),15	    		      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_OP"              , "SCP", "Op"                 ,PesqPict("SCP","CP_OP"       ),15                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_MANUAL"          , "SCP", "Manual"             ,PesqPict("SCP","CP_MANUAL"   ),05	    		      , /*lPixel*/, /* Formula*/)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrintReportºAutor  ³ Ricardo Moreira   º Data ³  28/05/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³A funcao estatica PrintReport realiza a impressao do relato-º±±
±±º          ³rio                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrintReport1(oReport)

Local oSection := oReport:Section(1)
Private aDados[10]

oSection:Cell("CEL01_PRODUTO"  ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_DESC"     ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_UNID"     ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_ALMOX"    ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_QTDSOLIC" ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_QTDDISP"  ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_ENDERE"   ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_DATAEMIS" ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_OP"       ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_MANUAL"   ):SetBlock( { || aDados[10]})

oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_PRODUTO"),,.F.)
TRFunction():New(oSection:Cell("CEL05_QTDSOLIC"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.999",,.F.,.T.)
 
oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := " "
_cQry += "SELECT DISTINCT CP_FILIAL, CP_PRODUTO, CP_DESCRI, CP_UM, CP_OP,C2_PRODUTO,C2_QUANT,C2_DATPRI, C2_TPOP,CP_LOCAL, CP_XENDERE,CP_EMISSAO,CP_QUANT,CP_MANUAL "
_cQry += "FROM " + retsqlname("SCP")+" SCP "
_cQry += "INNER JOIN " + retsqlname("SC2")+ " SC2 ON CP_FILIAL = C2_FILIAL AND CP_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ <> '*' "     
_cQry += "WHERE SCP.D_E_L_E_T_ <> '*' "   
_cQry += "AND   CP_OP BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   CP_EMISSAO 	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "   // EMISSAO
_cQry += "AND   CP_DATPRF 	BETWEEN '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06)  + "' "   // NECESSIDADE
_cQry += "AND   CP_PRODUTO 	BETWEEN '" + mv_par07  + "' AND '" + mv_par08  + "' "   // EMISSAO
IF MV_PAR09 = 1
  _cQry += "AND C2_TPOP = 'F' "
Else
  _cQry += "AND C2_TPOP = 'P' "
EndIf
_cQry += "ORDER BY  CP_FILIAL, CP_PRODUTO "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TMP",.T.,.T.)      


dbselectarea("TMP")
DBGOTOP()
DO WHILE !TMP->(EOF())

dbSelectArea("SB2")
dbSeek(xFilial("SB2") + TMP->CP_PRODUTO + TMP->CP_LOCAL)
nSaldo :=  SaldoSb2() 
	
	If oReport:Cancel()
		Exit
	EndIf
	aDados[01] := TMP->CP_PRODUTO	
	aDados[02] := TMP->CP_DESCRI 
	aDados[03] := TMP->CP_UM
	aDados[04] := TMP->CP_LOCAL	
	aDados[05] := TMP->CP_QUANT
	aDados[06] := nSaldo
	aDados[07] := TMP->CP_XENDERE 
	aDados[08] := CVALTOCHAR(STOD(TMP->CP_EMISSAO))	 
	aDados[09] := TMP->CP_OP
	aDados[10] := TMP->CP_MANUAL 
	
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao das perguntas dos parametros                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
aAdd(aRegs,{cPerg,"03","Emissao de   	  ?","","","mv_ch3","D",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"04","Emissao Ate       ?","","","mv_ch4","D",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"05","Necessidade de    ?","","","mv_ch5","D",10,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"06","Necessidade Ate   ?","","","mv_ch6","D",10,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"07","Produto de    	  ?","","","mv_ch7","C",10,0,0,"G","","mv_par07",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"08","Produto Ate   	  ?","","","mv_ch8","C",10,0,0,"G","","mv_par08",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"09","Tipo              ?","","","mv_ch9","N",01,0,0,"C","","mv_par09","Firme"    ,"","","","","Prevista","","","","","","","","","","","","","","","","","","","  "})
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
			AADD(aHelpPor,"Informe a Emissão Inicial.            ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe a Emissão Final.              ")
		ElseIf i==3
			AADD(aHelpPor,"Informe a Necessidade Inicial.            ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe a Necessidade Final.              ")
		ElseIf i==3
			AADD(aHelpPor,"Informe a Produto Inicial.            ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe a Produto Final.              ")
		ElseIf i==4
			AADD(aHelpPor,"Informe o Tipo.              ")
		EndIf
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return     

