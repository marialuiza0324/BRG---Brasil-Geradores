#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRG009.PRWบ Autor ณ Ricardo Fiuza    บ Data ณ  22/11/18    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio da Ficha de Producใo da OS				          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 3rl Solu็๕es - Ricardo                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BRG009()  // U_BRG009() Chamado 004531

Private _total := 0
Private cPerg       := PADR("BRG009",Len(SX1->X1_GRUPO))
//Chama relatorio personalizado
ValidPerg1()
pergunte(cPerg,.T.)    // sem tela de pergunta

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

Local oReport, oSection, oBreak, oSection2

cTitulo := "Relatorio De OS - " + CVALTOCHAR(MV_PAR03) //+ " a " +CVALTOCHAR(MV_PAR04)

oReport  := TReport():New("BRG009",cTitulo,"BRG009",{|oReport| PrintReport1(oReport)},cTitulo)
//oReport:SetLandscape() // Paisagem
oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio De OS"," ", NIL, .F., .T.)
TRCell():New(oSection, "CEL01_OS"        , "AB7", "Num. OS"        ,PesqPict("AB7","AB7_NUMOS"    ),08                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_ITEM"      , "AB7", "Item"           ,PesqPict("AB7","AB7_ITEM"     ),03                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_CLIENTE"   , "SA1", "Cliente"        ,PesqPict("SA1","A1_NOME"      ),40                  , /*lPixel*/, /* Formula*/)   
TRCell():New(oSection, "CEL04_EMISSAO"   , "AB7", "Emissใo"        ,PesqPict("AB7","AB7_EMISSA"   ),14                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_PRODUTO"   , "SB1", "Produto"        ,PesqPict("SB1","B1_DESC"      ),30                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_IDUNIC"    , "AB7", "Lote"           ,PesqPict("AB7","AB7_NUMSER"   ),12                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_OCORREN"   , "AAG", "Ocorrencia"     ,PesqPict("AAG","AAG_DESCRI"   ),30                  , /*lPixel*/, /* Formula*/) //TABELA AAG


oSection2:= TRSection():New(oReport, "Itens Antendimentos da OS", {"TEMP"}, NIL, .F., .T.)
TRCell():New(oSection2, "CEL01_ITEM"     , "AB8", "Item"           ,PesqPict("AB8","AB8_ITEM"     ),03                  , /*lPixel*/, /* Formula*/)   
TRCell():New(oSection2, "CEL02_CODPRO"   , "AB8", "Produto"        ,PesqPict("AB8","AB8_DESPRO"   ),15                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL03_DESCRI"   , "AB8", "Descri็ใo"      ,PesqPict("AB8","AB8_DESPRO"   ),40                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL04_QUANT"    , "AB8", "Quantidade"     ,PesqPict("AB8","AB8_QUANT"    ),12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL05_VALOR"    , "AB8", "Custo Medio"    ,PesqPict("AB8","AB8_VUNIT"    ),12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL06_TOTAL"    , "AB8", "Total Custo"    ,PesqPict("AB8","AB8_TOTAL"    ),12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL07_ALICMS"   , "   ", "Aliq Icms(%)"   , 						       ,05                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL08_ICMS"     , "   ", "Icms"           ,                               ,12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL09_ALIPI"    , "   ", "Aliq Ipi(%)"    , 						       ,05                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL10_IPI"      , "   ", "Ipi"            ,                               ,12                  , /*lPixel*/, /* Formula*/) 

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReportบAutor  ณ Roberto Fiuza     บ Data ณ  28/05/2013 บฑฑ
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

Private _Prod    := " "
Private aDados[07]     
Private aDados2[10] 
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {} 

//cTitulo := "Relatorio Vendas por Representante - Periodo " + CVALTOCHAR(MV_PAR03)+ " a " +CVALTOCHAR(MV_PAR04)


oSection:Cell("CEL01_OS"       ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_ITEM"     ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_CLIENTE"  ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_EMISSAO"  ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_PRODUTO"  ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_IDUNIC"   ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_OCORREN"  ):SetBlock( { || aDados[07]})    

oSection2:Cell("CEL01_ITEM"    ):SetBlock( { || aDados2[01]})
oSection2:Cell("CEL02_CODPRO"  ):SetBlock( { || aDados2[02]})
oSection2:Cell("CEL03_DESCRI"  ):SetBlock( { || aDados2[03]})
oSection2:Cell("CEL04_QUANT"   ):SetBlock( { || aDados2[04]})
oSection2:Cell("CEL05_VALOR"   ):SetBlock( { || aDados2[05]})
oSection2:Cell("CEL06_TOTAL"   ):SetBlock( { || aDados2[06]})
oSection2:Cell("CEL07_ALICMS"  ):SetBlock( { || aDados2[07]})
oSection2:Cell("CEL08_ICMS"    ):SetBlock( { || aDados2[08]})
oSection2:Cell("CEL09_ALIPI"   ):SetBlock( { || aDados2[09]})
oSection2:Cell("CEL10_IPI"     ):SetBlock( { || aDados2[10]})

//oBreak := TRBreak():New(oSection2,oSection:Cell("CEL01_ITEM"),,.F.)
//TRFunction():New(oSection2:Cell("CEL04_QUANT"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.) 
//TRFunction():New(oSection2:Cell("CEL06_TOTAL"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.) 


oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := " "
_cQry += "SELECT AB7_FILIAL,AB7_NUMOS,AB7_EMISSA,AB7_CODPRB,AB7_CODCLI, A1_NOME,AB7_CODPRO, AB7_NUMSER,AB7_ITEM,AB8_ITEM,AB8_CODPRO, AB8_DESPRO, AB8_QUANT, AB8_VUNIT, AB8_TOTAL "
_cQry += "FROM " + retsqlname("AB8")+" AB8 "
_cQry += "INNER JOIN " + retsqlname("AB7")+ " AB7 ON AB8_FILIAL = AB7_FILIAL AND AB8_ITEM = AB7_ITEM AND AB8_NUMOS = AB7_NUMOS AND AB7.D_E_L_E_T_ <> '*'  "     
_cQry += "INNER JOIN " + retsqlname("SA1")+ " SA1 ON A1_COD = AB8_CODCLI  AND A1_LOJA = AB8_LOJA AND SA1.D_E_L_E_T_ <> '*' "   
_cQry += "WHERE AB8.D_E_L_E_T_ <> '*' "   
_cQry += "AND   AB7_NUMOS = '" + mv_par03 + "' "   
_cQry += "ORDER BY AB8_DESPRO "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"       

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf        

	oSection:init()
    _PROB := POSICIONE("AAG",1,XFILIAL("AAG")+TMP->AB7_CODPRB,"AAG_DESCRI") 
    _DESC := POSICIONE("SB1",1,XFILIAL("SB1")+TMP->AB7_CODPRO,"B1_DESC") 
          
   aDados[01] := TMP->AB7_NUMOS 
   aDados[02] := TMP->AB7_ITEM   
   aDados[03] := TMP->AB7_CODCLI +" / "+ TMP->A1_NOME
   aDados[04] := CVALTOCHAR(STOD(TMP->AB7_EMISSA))
   aDados[05] := ALLTRIM(TMP->AB7_CODPRO)  +" / "+ _DESC
   aDados[06] := TMP->AB7_NUMSER
   aDados[07] := ALLTRIM(TMP->AB7_CODPRB)  +" / "+ _PROB
       
   _Os := TMP->AB7_NUMOS                                       
   
   oSection:Printline()
   oSection:Finish()	 

   oSection2:Init()  
      
 DO WHILE ! EOF() .AND. TMP->AB7_NUMOS == _Os
          
          _Prod := TMP->AB8_CODPRO
 
          aDados2[01] := TMP->AB8_ITEM
          aDados2[02] := TMP->AB8_CODPRO          
          aDados2[03] := TMP->AB8_DESPRO   
          aDados2[04] := TMP->AB8_QUANT 
          aDados2[05] := TMP->AB8_VUNIT  
          aDados2[06] := TMP->AB8_TOTAL          
          aDados2[07] := RtAlICM() //
          aDados2[08] := ROUND(((TMP->AB8_VUNIT/(1-(RtAlICM()/100))))*(RtAlICM()/100),2) // 
          aDados2[09] := RtAlIPI() //
          aDados2[10] :=  ROUND((TMP->AB8_VUNIT/(1-(RtAlIPI()/100))*(RtAlIPI()/100)),2)  
                                                              
          oSection2:PrintLine()  // Imprime linha de detalhe                           
          aFill(aDados,nil)     // Limpa o array a dados

         dbselectarea("TMP")
         TMP->(dbSkip())
       ENDDO      
     oSection:Finish()
     oReport:ThinLine()
ENDDO

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf      
 
oSection:Finish()
oReport:SkipLine()
oReport:IncMeter() 

//oReport:SkipLine(2) /
//oReport:Say(oReport:Row(),10,"Valor Total : " + AllTrim(Transform(_total, "@ze 9,999,999,999,999.99")))

//oReport:SkipLine(3) 
//oReport:Say(oReport:Row(),10,"  Data:________/_______/__________        	  Data:________/_______/__________          		Data:________/_______/__________                 Data:________/_______/__________              Data:________/_______/__________ ") 


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

aAdd(aRegs,{cPerg,"01","Filial De         ?","","","mv_ch1","C",04,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"}) 
aAdd(aRegs,{cPerg,"02","Filial Ate        ?","","","mv_ch2","C",04,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})   
aAdd(aRegs,{cPerg,"03","OS De  			  ?","","","mv_ch3","C",06,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","AB6"}) 
//aAdd(aRegs,{cPerg,"04","O Ate ?","","","mv_ch4","C",06,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA3"})   

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
			AADD(aHelpPor,"Filial De  ?              ")
		ElseIf i==2
			AADD(aHelpPor,"Filial Ate ?              ")	
		ElseIf i==3
			AADD(aHelpPor,"OS De      ?              ")	
		Endif
	    PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return  

//Retorna a Aliquota de Icms Do item 
Static Function RtAlICM()   
Local _AliqICM := ""

If Select("TMP1") > 0
	TMP1->(dbCloseArea())
EndIf

_cQry := "SELECT TOP 1 D1_PICM  "
_cQry += "FROM " + retsqlname("SD1")+" SD1 "  
_cQry += "WHERE SD1.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SD1.D1_COD = '" + _Prod + "' "
_cQry += "AND   SD1.D1_TIPO = 'N' "
_cQry += "ORDER BY D1_DTDIGIT DESC "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP1" 

 _AliqICM   := TMP1->D1_PICM
       
Return _AliqICM  

//Retorna a Aliquota de IPI Do item 
Static Function RtAlIPI()   
Local _AliqIPI := ""

If Select("TMP2") > 0
	TMP2->(dbCloseArea())
EndIf

_cQry := "SELECT TOP 1 D1_IPI  "
_cQry += "FROM " + retsqlname("SD1")+" SD1 "  
_cQry += "WHERE SD1.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SD1.D1_COD = '" + _Prod + "' "
_cQry += "AND   SD1.D1_TIPO = 'N' "
_cQry += "ORDER BY D1_DTDIGIT DESC "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP2" 

 _AliqIPI   := TMP2->D1_IPI
       
Return _AliqIPI



