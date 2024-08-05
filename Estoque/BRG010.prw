#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BRG010.PRWบ Autor ณ Ricardo Fiuza    บ Data ณ  27/11/18    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio da Ficha de Producใo da OP				          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 3rl Solu็๕es - Ricardo                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BRG010()  // U_BRG010() 

Private _total := 0
Private cPerg       := PADR("BRG010",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio De OP - " + CVALTOCHAR(MV_PAR01) + " a " +CVALTOCHAR(MV_PAR02)

oReport  := TReport():New("BRG010",cTitulo,"BRG010",{|oReport| PrintReport1(oReport)},cTitulo)
//oReport:SetLandscape() // Paisagem
oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio De OP"," ", NIL, .F., .T.)
TRCell():New(oSection, "CEL01_OP"        , "SCP", "Num. OP"        ,PesqPict("SCP","CP_OP"        ),14                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection, "CEL02_PRODUTO"   , "SB1", "Produto"        ,PesqPict("SB1","B1_DESC"      ),30                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_QUANT"     , "SC2", "Quantidade"     ,PesqPict("SC2","C2_QUANT"     ),12                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_EMISSAO"   , "SC2", "Emissใo"        ,PesqPict("SC2","C2_DATPRI"    ),14                  , /*lPixel*/, /* Formula*/)

oSection2:= TRSection():New(oReport, "Itens Antendimentos da OP", {"TEMP"}, NIL, .F., .T.) 
TRCell():New(oSection2, "CEL01_CODPRO"   , "SCP", "Produto"        ,PesqPict("SCP","CP_PRODUTO"   ),15                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL02_DESCRI"   , "SCP", "Descri็ใo"      ,PesqPict("SB1","B1_DESC"      ),30                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL03_QUANT"    , "SCP", "Quant"          ,PesqPict("SCP","CP_QUANT"     ),12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL04_QTENTR"   , "SCP", "Quant Entregue" ,PesqPict("SCP","CP_QUJE"      ),12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL05_VALOR"    , "SB2", "Custo Medio"    ,PesqPict("SB2","B2_CM1"       ),12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL06_TOTAL"    , "SCP", "Total Custo"    ,PesqPict("SCP","CP_QUANT"     ),12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL07_ALICMS"   , "   ", "Aliq Icms(%)"   , 						       ,05                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL08_ICMS"     , "   ", "Icms"           ,                               ,12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL09_ALIPI"    , "   ", "Aliq Ipi(%)"    , 						       ,05                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL10_IPI"      , "   ", "Ipi"            ,                               ,12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL11_OP"       , "SCP", "Num. OP"        ,PesqPict("SCP","CP_OP"        ),14                  , /*lPixel*/, /* Formula*/) 
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
Local _nTot   := 0
Local _nIpi   := 0
Local _nIcm   := 0  

Private _Prod    := " "
Private aDados[04]     
Private aDados2[11] 
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {} 


oSection:Cell("CEL01_OP"       ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_PRODUTO"  ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_QUANT"    ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_EMISSAO"  ):SetBlock( { || aDados[04]})   

oSection2:Cell("CEL01_CODPRO"  ):SetBlock( { || aDados2[01]})
oSection2:Cell("CEL02_DESCRI"  ):SetBlock( { || aDados2[02]})
oSection2:Cell("CEL03_QUANT"   ):SetBlock( { || aDados2[03]})
oSection2:Cell("CEL04_QTENTR"  ):SetBlock( { || aDados2[04]})
oSection2:Cell("CEL05_VALOR"   ):SetBlock( { || aDados2[05]})
oSection2:Cell("CEL06_TOTAL"   ):SetBlock( { || aDados2[06]})
oSection2:Cell("CEL07_ALICMS"  ):SetBlock( { || aDados2[07]})
oSection2:Cell("CEL08_ICMS"    ):SetBlock( { || aDados2[08]})
oSection2:Cell("CEL09_ALIPI"   ):SetBlock( { || aDados2[09]})
oSection2:Cell("CEL10_IPI"     ):SetBlock( { || aDados2[10]})
oSection2:Cell("CEL11_OP"      ):SetBlock( { || aDados2[11]})

oBreak := TRBreak():New(oSection2,oSection2:Cell("CEL11_OP"),,.F.)
TRFunction():New(oSection2:Cell("CEL08_ICMS")  ,"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.) 
TRFunction():New(oSection2:Cell("CEL10_IPI")   ,"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection2:Cell("CEL06_TOTAL") ,"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.) 
 

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := " "
_cQry += "SELECT DISTINCT CP_FILIAL, CP_PRODUTO, CP_DESCRI, CP_UM, CP_OP,C2_PRODUTO,C2_QUANT,C2_DATPRI, CP_LOCAL, CP_EMISSAO,CP_QUANT,CP_QUJE,B2_CM1, ROUND((CP_QUJE*B2_CM1),2) Total "
_cQry += "FROM " + retsqlname("SCP")+" SCP "
_cQry += "INNER JOIN " + retsqlname("SB2")+ " SB2 ON CP_FILIAL = B2_FILIAL AND CP_PRODUTO = B2_COD AND CP_LOCAL = B2_LOCAL AND SB2.D_E_L_E_T_ <> '*' "
_cQry += "INNER JOIN " + retsqlname("SC2")+ " SC2 ON CP_FILIAL = C2_FILIAL AND CP_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ <> '*' "     
_cQry += "WHERE SCP.D_E_L_E_T_ <> '*' "   
_cQry += "AND   SCP.CP_OP BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "ORDER BY  CP_OP,CP_DESCRI "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"       

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf        

	oSection:init()
   
    _DESC := POSICIONE("SB1",1,XFILIAL("SB1")+TMP->C2_PRODUTO,"B1_DESC") 
    _Qtde := POSICIONE("SC2",1,XFILIAL("SC2")+TMP->CP_OP,"C2_QUANT")
          
   aDados[01] := TMP->CP_OP   
   aDados[02] := ALLTRIM(TMP->C2_PRODUTO)  +" / "+ _DESC
   aDados[03] := _Qtde  
   aDados[04] := CVALTOCHAR(STOD(TMP->C2_DATPRI))
       
   _Op := TMP->CP_OP                                       
   
   oSection:Printline()
   oSection:Finish()
    
   oSection2:Init()  
      
 DO WHILE ! EOF() .AND. TMP->CP_OP == _Op
           
          _Prod := TMP->CP_PRODUTO
          _nTot   := _nTot + TMP->Total 
  		  _nIcm   := _nIcm + ROUND(((TMP->B2_CM1/(1-(RtAlICM()/100))))*(RtAlICM()/100),2)
          _nIpi   := _nIpi + ROUND((TMP->B2_CM1/(1-(RtAlIPI()/100))*(RtAlIPI()/100)),2)    
          
  		  _DESCIT := POSICIONE("SB1",1,XFILIAL("SB1")+TMP->CP_PRODUTO,"B1_DESC")   
  		 
          aDados2[01] := TMP->CP_PRODUTO          
          aDados2[02] := _DESCIT   
          aDados2[03] := TMP->CP_QUANT
          aDados2[04] := TMP->CP_QUJE
          aDados2[05] := TMP->B2_CM1  
          aDados2[06] := TMP->Total          
          aDados2[07] := RtAlICM() //
          aDados2[08] := ROUND(((TMP->B2_CM1/(1-(RtAlICM()/100))))*(RtAlICM()/100),2) // 
          aDados2[09] := RtAlIPI() //
          aDados2[10] := ROUND((TMP->B2_CM1/(1-(RtAlIPI()/100))*(RtAlIPI()/100)),2)  
          aDados2[11] := TMP->CP_OP
                                                               
          oSection2:PrintLine()  // Imprime linha de detalhe                           
          aFill(aDados,nil)     // Limpa o array a dados

         dbselectarea("TMP")
         TMP->(dbSkip())
       ENDDO
         
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

oReport:SkipLine(2) 
oReport:Say(oReport:Row(),10,"Valor Total : " + AllTrim(Transform(_nTot, "@ze 9,999,999,999,999.99"))) 
oReport:SkipLine(2) 
oReport:Say(oReport:Row(),10,"Valor Total ICMS : " + AllTrim(Transform(_nIcm, "@ze 9,999,999,999,999.99")))
oReport:SkipLine(2) 
oReport:Say(oReport:Row(),10,"Valor Total IPI: " + AllTrim(Transform(_nIpi, "@ze 9,999,999,999,999.99")))

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

aAdd(aRegs,{cPerg,"01","OS De         ?","","","mv_ch1","C",14,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SC2"}) 
aAdd(aRegs,{cPerg,"02","OS Ate        ?","","","mv_ch2","C",14,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SC2"})   

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
			AADD(aHelpPor,"OS De  ?              ")
		ElseIf i==2
			AADD(aHelpPor,"OS Ate ?              ")			
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
