#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "topconn.ch"

user function BRG037()
	
Private cPerg       := PADR("BRG037",Len(SX1->X1_GRUPO))
Private nSaldo := 0
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

Local oReport, oSection, oBreak,oSection2

cTitulo := "Controle de Remessa"
 
oReport  := TReport():New("BRG037",cTitulo,"BRG037",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  
//oReport:SetPortrait()    // Retrato
oreport:nfontbody:=6
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Controle de Remessa",{""}, NIL, .F., .T.) 
TRCell():New(oSection, "CEL01_EMISSAO"          , "ZLC", "Emissใo"            ,PesqPict("ZLC","ZLC_EMIS"    ),14                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_DOC"              , "ZLC", "Nota"               ,PesqPict("ZLC","ZLC_NOTA"    ),12				  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_SERIE"            , "ZLC", "Serie"              ,PesqPict("ZLC","ZLC_SERIE"   ),05 				  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_CLIENT"           , "ZLC", "Cliente"  		  ,PesqPict("ZLC","ZLC_CLIENT"  ),12                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_LOJA"             , "ZLC", "Loja"  	          ,PesqPict("ZLC","ZLC_LOJA"    ),05                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_NOMCLI"           , "SA1", "Nome Cliente"  	  ,PesqPict("SA1","A1_NOME"     ),45                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_CODPROD"          , "ZLI", "Cod Produto"        ,PesqPict("ZLI","ZLI_PROD"    ),12	    		  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_DESCPRO"          , "ZLI", "Descri็ใo Produto"  ,PesqPict("ZLI","ZLI_DESCPR"  ),45	    		  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_NFDEV"            , "ZLI", "Nota Devolu็ใo"     ,PesqPict("ZLI","ZLI_NOTRET"  ),12                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_SERDEV"           , "ZLI", "Serie Devolu็ใo"    ,PesqPict("ZLI","ZLI_SERRET"  ),12                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_DATADEV"          , "ZLI", "Data Devolu็ใo"     ,PesqPict("ZLI","ZLI_DATRET"  ),14	    		  , /*lPixel*/, /* Formula*/)

oSection2:= TRSection():New(oReport, "Faturas", {"TEMP"}, NIL, .F., .T.) 
TRCell():New(oSection2, "CEL01_MES"             , "   ", "M๊s/Ano"            ," "                           ,15                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL02_DATA"            , "SC5", "Data"               ,PesqPict("SC5","C5_EMISSAO"  ),15                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL03_PEDIDO"          , "SC5", "Pedido"             ,PesqPict("SC5","C5_NUM"      ),15                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL04_FATURA"          , "SC5", "Fatura"             ,PesqPict("SC5","C5_NOTA"     ),15                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL05_SERIE"           , "SC5", "Serie"              ,PesqPict("SC5","C5_SERIE"    ),05                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL06_VALOR"           , "SF2", "Valor"              ,PesqPict("SF2","F2_VALBRUT"  ),16                  , /*lPixel*/, /* Formula*/) 
//TRCell():New(oSection2, "CEL07_TIPO"            , "SC5", "Tipo"               ," "                           ,12                  , /*lPixel*/, /* Formula*/) 
//TRCell():New(oSection2, "CEL08_BAIXA"           , "SC5", "Baixa"              ," "                           ,12                  , /*lPixel*/, /* Formula*/) 

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
Local oSection2 := oReport:Section(2)
Private aDados[11]
Private aDados2[06]

oSection:Cell("CEL01_EMISSAO"   ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_DOC"       ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_SERIE"     ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_CLIENT"    ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_LOJA"      ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_NOMCLI"    ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_CODPROD"   ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_DESCPRO"   ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_NFDEV"     ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_SERDEV"    ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_DATADEV"   ):SetBlock( { || aDados[11]})

oSection2:Cell("CEL01_MES"       ):SetBlock( { || aDados2[01]})
oSection2:Cell("CEL02_DATA"      ):SetBlock( { || aDados2[02]})
oSection2:Cell("CEL03_PEDIDO"    ):SetBlock( { || aDados2[03]})
oSection2:Cell("CEL04_FATURA"    ):SetBlock( { || aDados2[04]})
oSection2:Cell("CEL05_SERIE"     ):SetBlock( { || aDados2[05]})
oSection2:Cell("CEL06_VALOR"     ):SetBlock( { || aDados2[06]})
 
oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := " "
_cQry += "SELECT * "
_cQry += "FROM " + retsqlname("ZLI")+" ZLI "
_cQry += "LEFT JOIN " + retsqlname("ZLC")+ " ZLC ON ZLC_FILIAL = ZLI_FILIAL AND ZLC_NOTA = ZLI_NOTA AND ZLC_SERIE = ZLI_SERIE AND ZLC.D_E_L_E_T_ <> '*' "     
_cQry += "WHERE ZLI.D_E_L_E_T_ <> '*' " 
_cQry += " AND   ZLC_FILIAL BETWEEN '" + mv_par07  + "' AND '" + mv_par08  + "' "
_cQry += " AND   ZLC_EMIS	BETWEEN '" + DTOS(mv_par01)  + "' AND '" + DTOS(mv_par02)  + "' "
_cQry += " AND   ZLI_PROD BETWEEN '" + mv_par03  + "' AND '" + mv_par04  + "' "
_cQry += " AND   ZLC_CLIENT   BETWEEN '" + mv_par05  + "' AND '" + mv_par06  + "' "
//_cQry += "AND ZLC_NOTA = '000001135' " 
_cQry += "ORDER BY ZLI_FILIAL , ZLI_NOTA, ZLI_SERIE,ZLI_ITEM "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TMP",.T.,.T.)      


dbselectarea("TMP")
DBGOTOP()
DO WHILE !TMP->(EOF())

cNotaR := TMP->ZLC_NOTA 

DO WHILE !TMP->(EOF()) .AND. TMP->ZLC_NOTA = cNotaR
	
	If oReport:Cancel()
		Exit
	EndIf

	oSection:init()

	aDados[01] := CVALTOCHAR(STOD(TMP->ZLC_EMIS))
	aDados[02] := TMP->ZLC_NOTA 
	aDados[03] := TMP->ZLC_SERIE
	aDados[04] := TMP->ZLC_CLIENT	
	aDados[05] := TMP->ZLC_LOJA
	aDados[06] := Posicione("SA1",1,xFilial("SA1")+TMP->ZLC_CLIENT+TMP->ZLC_LOJA,"A1_NOME") 
	aDados[07] := TMP->ZLI_PROD 
	aDados[08] := TMP->ZLI_DESCPR 
	aDados[09] := TMP->ZLI_NOTRET
	aDados[10] := TMP->ZLI_SERRET 
    aDados[11] := CVALTOCHAR(STOD(TMP->ZLI_DATRET)) 

    _Nota := TMP->ZLC_NOTA 
    _Ser  := TMP->ZLC_SERIE
	_Cli  := TMP->ZLC_CLIENT
	_Lj   := TMP->ZLC_LOJA

    oSection:Printline()
       
    //oSection2:Init()

	TMP->(dbSkip())

	ENDDO
    oSection:Finish()
	//oReport:SkipLine()
    //oReport:IncMeter()
	
    If Select("TMP1") > 0
	   TMP1->(dbCloseArea())
    EndIf

    _cQryy := " "
    _cQryy += "SELECT C5_FILIAL,C5_NOTA, C5_SERIE, C5_NUM ,F2_EMISSAO,F2_VALBRUT,C5_NFREM,C5_SERREM,F2_CLIENTE,F2_LOJA  "
    _cQryy += "FROM " + retsqlname("SC5")+" SC5 "
    _cQryy += "LEFT JOIN " + retsqlname("SF2")+ " SF2 ON F2_FILIAL = C5_FILIAL AND F2_DOC = C5_NOTA AND F2_SERIE = C5_SERIE AND C5_CLIENTE = F2_CLIENTE AND C5_LOJACLI = F2_LOJA AND SF2.D_E_L_E_T_ <> '*' "      
    _cQryy += "WHERE SC5.D_E_L_E_T_ <> '*' " 
	_cQryy += "AND C5_NFREM IN  ('" + _Nota  + "') "
	_cQryy += "AND C5_SERREM =  '" + _Ser  + "' "  
    _cQryy += "ORDER BY C5_FILIAL, C5_NOTA, C5_SERIE, F2_CLIENTE,F2_LOJA "
	   
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQryy)),"TMP1",.T.,.T.) 
 

    dbselectarea("TMP1")
    DBGOTOP()                                                     //_Nota == ALLTRIM(TMP1->C5_NFREM)  //_Nota == "("+ALLTRIM(TMP1->C5_NFREM)+")"
    DO WHILE ! EOF() .AND. TMP1->C5_FILIAL == xFilial("SC5") .AND. _Nota $ "("+ALLTRIM(TMP1->C5_NFREM)+")" .AND. TMP1->C5_SERREM == _Ser .AND.  TMP1->F2_CLIENTE == _Cli .AND. TMP1->F2_LOJA == _Lj

	   oSection2:init()

	   aDados2[01] := MesExtenso(Month(STOD(TMP1->F2_EMISSAO))) 
	   aDados2[02] := CVALTOCHAR(STOD(TMP1->F2_EMISSAO))
	   aDados2[03] := TMP1->C5_NUM
	   aDados2[04] := TMP1->C5_NOTA	
	   aDados2[05] := TMP1->C5_SERIE
	   aDados2[06] := TMP1->F2_VALBRUT
	                                                     
       oSection2:PrintLine()  // Imprime linha de detalhe                           
       aFill(aDados,nil)   
	
	   //dbselectarea("TMP1")
	   TMP1->(dbSkip())
	
    ENDDO
     //TMP->(dbSkip())  
    oSection2:Finish()
    oReport:SkipLine()
    oReport:IncMeter() 
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

aAdd(aRegs,{cPerg,"01","Emissao de   	  ?","","","mv_ch1","D",10,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"02","Emissao Ate       ?","","","mv_ch2","D",10,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"03","Produto de    	  ?","","","mv_ch3","C",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"04","Produto Ate   	  ?","","","mv_ch4","C",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"05","Cliente de    	  ?","","","mv_ch5","C",10,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"06","Cliente Ate   	  ?","","","mv_ch6","C",10,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"07","Filial de    	  ?","","","mv_ch7","C",04,0,0,"G","","mv_par07",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})
aAdd(aRegs,{cPerg,"08","Filial Ate   	  ?","","","mv_ch8","C",04,0,0,"G","","mv_par08",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})

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
			AADD(aHelpPor,"Informe a Emissใo Inicial.            ")
		ElseIf i==2                                            
			AADD(aHelpPor,"Informe a Emissใo Final.              ")	 
		ElseIf i==3
			AADD(aHelpPor,"Informe a Produto Inicial.            ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe a Produto Final.              ")
		ElseIf i==5
			AADD(aHelpPor,"Informe o Cliente Inicial.            ")		
		ElseIf i==6
			AADD(aHelpPor,"Informe a Cliente Final.              ")	
		ElseIf i==7
			AADD(aHelpPor,"Informe a Filial Inicial.             ")		
		ElseIf i==8
			AADD(aHelpPor,"Informe a Filial Final.              ")	
		EndIf
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return     

