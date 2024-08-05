#include 'protheus.ch'
#INCLUDE "topconn.ch"
#include 'parmtype.ch'

User function BRG014()
Private _Op := ""
Private _total := 0
Private cPerg       := PADR("BRG014",Len(SX1->X1_GRUPO))
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

oReport  := TReport():New("BRG014",cTitulo,"BRG014",{|oReport| PrintReport1(oReport)},cTitulo)
//oReport:SetLandscape() // Paisagem
oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio De OP"," ", NIL, .F., .T.)
TRCell():New(oSection, "CEL01_OP"        , "SD3", "Num. OP"        ,PesqPict("SD3","D3_OP"        ),14                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection, "CEL02_PRODUTO"   , "SB1", "Produto"        ,PesqPict("SB1","B1_DESC"      ),40                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_QUANT"     , "SC2", "Quantidade"     ,PesqPict("SC2","C2_QUANT"     ),12                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_EMISSAO"   , "SC2", "Emissใo"        ,PesqPict("SC2","C2_DATPRI"    ),14                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_VALOR"     , "SD3", "Custo"          ,PesqPict("SD3","D3_CUSTO1"    ),12                  , /*lPixel*/, /* Formula*/)

oSection2:= TRSection():New(oReport, "Itens Antendimentos da OP", {"TEMP"}, NIL, .F., .T.) 
TRCell():New(oSection2, "CEL01_OP"       , "SD3", "Num. OP"        ,PesqPict("SD3","D3_OP"        ),14                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL02_CODPRO"   , "SD3", "Produto"        ,PesqPict("SD3","D3_COD"       ),15                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL03_DESCRI"   , "SB1", "Descri็ใo"      ,PesqPict("SB1","B1_DESC"      ),30                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL04_QUANT"    , "SD3", "Quant"          ,PesqPict("SD3","D3_QUANT"     ),12                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection2, "CEL05_VALOR"    , "SD3", "Custo Unit"     ,PesqPict("SD3","D3_CUSTO1"    ),12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL06_TOTAL"    , "SD3", "Total Custo"    ,PesqPict("SD3","D3_CUSTO1"    ),12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL07_DOCUM"    , "SD3", "Documento"      ,PesqPict("SD3","D3_DOC"       ),10                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL08_EMISSAO"  , "SD3", "Emissใo"        ,PesqPict("SD3","D3_EMISSAO"   ),12                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL09_SOLIC"    , "SD3", "Solicita็ใo"    ,PesqPict("SD3","D3_NUMSA"     ),06                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL10_LOTE"     , "SD3", "Lote"           ,PesqPict("SD3","D3_LOTECTL"   ),20                  , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection2, "CEL11_PORCPI"   , "SD3", "Porc PI(%)"     , 							   ,08                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection2, "CEL12_PORCPA"   , "SD3", "Porc PA(%)"     , 							   ,08                  , /*lPixel*/, /* Formula*/)
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReportบAutor  ณ rICARDO     บ Data ณ  28/05/2013 บฑฑ
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
Local _nTotDev := 0
Local _nTotPi := 0
Local CustoPi := 0

Private _Prod    := " "
Private aDados[05]     
Private aDados2[12] 
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
oSection:Cell("CEL05_VALOR"    ):SetBlock( { || aDados[05]})   

oSection2:Cell("CEL01_OP"      ):SetBlock( { || aDados2[01]})
oSection2:Cell("CEL02_CODPRO"  ):SetBlock( { || aDados2[02]})
oSection2:Cell("CEL03_DESCRI"  ):SetBlock( { || aDados2[03]})
oSection2:Cell("CEL04_QUANT"   ):SetBlock( { || aDados2[04]})
oSection2:Cell("CEL05_VALOR"   ):SetBlock( { || aDados2[05]})
oSection2:Cell("CEL06_TOTAL"   ):SetBlock( { || aDados2[06]})
oSection2:Cell("CEL07_DOCUM"   ):SetBlock( { || aDados2[07]})
oSection2:Cell("CEL08_EMISSAO" ):SetBlock( { || aDados2[08]})
oSection2:Cell("CEL09_SOLIC"   ):SetBlock( { || aDados2[09]})
oSection2:Cell("CEL10_LOTE"    ):SetBlock( { || aDados2[10]})
oSection2:Cell("CEL11_PORCPI"  ):SetBlock( { || aDados2[11]})
oSection2:Cell("CEL12_PORCPA"  ):SetBlock( { || aDados2[12]})


oBreak := TRBreak():New(oSection2,oSection2:Cell("CEL01_OP"),,.F.)
TRFunction():New(oSection2:Cell("CEL06_TOTAL") ,"TOT","SUM",oBreak,"","@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection2:Cell("CEL11_PORCPI") ,"TOT","SUM",oBreak,"","@E 999.999",,.F.,.F.)  
TRFunction():New(oSection2:Cell("CEL12_PORCPA") ,"TOT","SUM",oBreak,"","@E 999.999",,.F.,.F.) 

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := " "
_cQry += "SELECT DISTINCT D3_FILIAL, D3_CF,D3_TM, D3_COD, B1_DESC, D3_TIPO,D3_UM, D3_OP,C2_PRODUTO,C2_QUANT,C2_DATPRI, D3_DOC,D3_LOTECTL,D3_LOCAL, D3_NUMSA,D3_EMISSAO,D3_QUANT, D3_CUSTO1, ROUND((D3_CUSTO1/D3_QUANT),2) Custo "
_cQry += "FROM " + retsqlname("SD3")+" SD3 "
_cQry += "LEFT JOIN " + retsqlname("SC2")+ " SC2 ON D3_FILIAL = C2_FILIAL AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ <> '*' "   
_cQry += "LEFT JOIN " + retsqlname("SB1")+ " SB1 ON D3_COD = B1_COD AND SB1.D_E_L_E_T_ <> '*' "    
_cQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
_cQry += "AND D3_CF IN ('RE6','DE0','DE6','RE0') "   
_cQry += "AND D3_ESTORNO <> 'S' "  
_cQry += "AND B1_FILIAL = '" + substr(cFilAnt,1,2)+ "' " 
_cQry += "AND SD3.D3_OP BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "ORDER BY  D3_OP, D3_TM,D3_COD "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"       

dbselectarea("TMP")
TMP->(DBGOTOP())
DO WHILE !TMP->(EOF())
	
	If oReport:Cancel()
		Exit
	EndIf        

	//oSection:init()
    _Op := TMP->D3_OP  
    _DESC := POSICIONE("SB1",1,XFILIAL("SB1")+TMP->C2_PRODUTO,"B1_DESC") 
    _Qtde := POSICIONE("SC2",1,XFILIAL("SC2")+TMP->D3_OP,"C2_QUANT")
          
   aDados[01] := TMP->D3_OP   
   aDados[02] := ALLTRIM(TMP->C2_PRODUTO)  +" / "+ _DESC
   aDados[03] := _Qtde  
   aDados[04] := CVALTOCHAR(STOD(TMP->C2_DATPRI))
   If SUBSTR(TMP->D3_OP,7,5) = "01001"          
   //   CustoPi := TotOpPi() TotOpPri() - TotGerD()
      aDados[05] := TotGerC() - TotGerD() //AllTrim(Transform((SCUSTO()), "@ze 9,999,999,999,999.99"))  //SCUSTO()  
   Else
      aDados[05] := SCUSTO() - SCUSTD() //AllTrim(Transform((SCUSTO()), "@ze 9,999,999,999,999.99"))  //SCUSTO()       
   EndIf                                    
   
   oSection:Printline()
   oSection:Finish()
    
   oSection2:Init()  
      
 DO WHILE TMP->D3_OP == _Op .AND. XFILIAL("SD3") == TMP->D3_FILIAL
           
          _Prod := TMP->D3_COD
          
          //If TMP->D3_TM = "003" 
          //  TMP->(dbskip())
		  // 	LOOP 		
          //EndIF
          //If SUBSTR(TMP->D3_OP,7,5) = "01001"
          If TMP->D3_CF $ "RE0/RE6" .and. SUBSTR(TMP->D3_OP,7,5) = "01001" //.and. TMP->D3_TIPO = "PI"   
            _nTot      := _nTot + TMP->D3_CUSTO1 
          ELSEIf TMP->D3_CF $ "RE0/RE6" .and. SUBSTR(TMP->D3_OP,7,5) <> "01001"   
            _nTotPi    := _nTotPi + TMP->D3_CUSTO1 
          ELSEIf TMP->D3_CF $ "DE0/DE6"
            _nTotDev   := _nTotDev + TMP->D3_CUSTO1 
          EndIf
  		           
  		  aDados2[01] := TMP->D3_OP
          aDados2[02] := TMP->D3_COD          
          aDados2[03] := TMP->B1_DESC  
          aDados2[04] := IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_QUANT*-1), TMP->D3_QUANT)         
          aDados2[05] := TMP->CUSTO  
          aDados2[06] := IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_CUSTO1*-1), TMP->D3_CUSTO1)                  
          aDados2[07] := TMP->D3_DOC          
          aDados2[08] := CVALTOCHAR(STOD(TMP->D3_EMISSAO))          
          aDados2[09] := TMP->D3_NUMSA
          aDados2[10] := TMP->D3_LOTECTL
          aDados2[11] := ROUND((IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_CUSTO1*-1), TMP->D3_CUSTO1)*100)/( SCUSTO() - SCUSTD()),6) 
          If SUBSTR(TMP->D3_OP,7,5) = "01001"   
             aDados2[12] := ROUND((IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_CUSTO1*-1), TMP->D3_CUSTO1)*100)/( SCUSTO() - SCUSTD()),6)                
          Else
             aDados2[12] := ROUND((IF(TMP->D3_CF $ "DE0/DE6",(TMP->D3_CUSTO1*-1), TMP->D3_CUSTO1)*100)/( TotGerC() - TotGerD()),6) 
          EndIf                                                     
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

oReport:SkipLine(2) //TotOpPri() - TotGerD()    //CustoPi   TotOpPri() - TotGerD()
oReport:Say(oReport:Row(),10,"Valor Total Requisi็๕es...: " + AllTrim(Transform((_nTot), "@ze 9,999,999,999,999.99"))) 
oReport:SkipLine(2) 
oReport:Say(oReport:Row(),10,"Valor Total Devolu็๕es....: " + AllTrim(Transform(_nTotDev, "@ze 9,999,999,999,999.99")))
oReport:SkipLine(2) 
oReport:Say(oReport:Row(),10,"Valor Total (-Devolu็๕es).: " + AllTrim(Transform((_nTot-_nTotDev), "@ze 9,999,999,999,999.99"))) 
/*
IF CustoPi = 0 
oReport:Say(oReport:Row(),10,"Valor Total Requisi็๕es...: " + AllTrim(Transform(TotOpReq(), "@ze 9,999,999,999,999.99"))) 
Else
oReport:Say(oReport:Row(),10,"Valor Total Requisi็๕es...: " + AllTrim(Transform(TotOpPi(), "@ze 9,999,999,999,999.99"))) 
EndIf

oReport:SkipLine(2) 
oReport:Say(oReport:Row(),10,"Valor Total Devolu็๕es....: " + AllTrim(Transform(TotGerD(), "@ze 9,999,999,999,999.99")))
oReport:SkipLine(2)
IF CustoPi = 0  
oReport:Say(oReport:Row(),10,"Valor Total (-Devolu็๕es).: " + AllTrim(Transform((TotOpReq() - TotGerD()), "@ze 9,999,999,999,999.99"))) 
Else
oReport:Say(oReport:Row(),10,"Valor Total (-Devolu็๕es).: " + AllTrim(Transform((TotOpPi() - TotGerD()), "@ze 9,999,999,999,999.99"))) 
EndIf
*/
Return


//Retorna o VAlor da Op

Static Function SCUSTO()
//Verifica se o arquivo TMP estแ em uso

Local _Custo := ""
	If Select("TTMP") > 0
	   TTMP->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL, D3_OP,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
	ccQry += "AND  D3_CF IN ('RE6','RE0') "    //D3_CF IN ('RE6','DE0','DE6','RE0')
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "  	 
	ccQry += "AND  D3_OP = '" + _Op + "' "
	ccQry += "GROUP BY D3_FILIAL, D3_OP " 
	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTMP",.T.,.T.) 
	
	_Custo := TTMP->Custo1
	
Return _Custo


Static Function SCUSTD()
//Verifica se o arquivo TMP estแ em uso

Local _CustoD := ""
	If Select("QTMP") > 0
	   QTMP->(DbCloseArea())
	EndIf
	cQry := " "
	cQry += "SELECT D3_FILIAL, D3_OP,SUM(D3_CUSTO1) Custo2 "
	cQry += "FROM " + retsqlname("SD3")+" SD3 "
	cQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
	cQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	cQry += "AND  D3_CF IN ('DE0','DE6') "
	cQry += "AND  D3_ESTORNO <> 'S' "  	 
	cQry += "AND  D3_OP = '" + _Op + "' "
	cQry += "GROUP BY D3_FILIAL, D3_OP " 
	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"QTMP",.T.,.T.) 
	
	_CustoD := QTMP->Custo2
	
Return _CustoD

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

//Retorna o VAlor da Op

Static Function TotGerC()
//Verifica se o arquivo TMP estแ em uso

Local _Custo := ""
	If Select("TTMP") > 0
	   TTMP->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
	ccQry += "AND  D3_CF IN ('RE6','RE0') "    //D3_CF IN ('RE6','DE0','DE6','RE0')
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "
	//ccQry += "AND  D3_OP LIKE '" + substr(_Op,1,6) + "%' "  	 
	ccQry += "AND  D3_OP = '" + _Op + "' "
	ccQry += "GROUP BY D3_FILIAL " 
	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTMP",.T.,.T.) 
	
	_Custo := TTMP->Custo1
	
	//
Return _Custo


Static Function TotGerD()
//Verifica se o arquivo TMP estแ em uso

Local _CustoD := ""
	If Select("QTMP") > 0
	   QTMP->(DbCloseArea())
	EndIf
	cQry := " "
	cQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo2 "
	cQry += "FROM " + retsqlname("SD3")+" SD3 "
	cQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
	cQry += "AND  D3_CF IN ('DE0','DE6') "
	cQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	cQry += "AND  D3_ESTORNO <> 'S' "  	 
	cQry += "AND  D3_OP LIKE'" + substr(_Op,1,6) + "%' "
	cQry += "GROUP BY D3_FILIAL " 
	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"QTMP",.T.,.T.) 
	
	_CustoD := QTMP->Custo2
	
Return _CustoD

Static Function TotOpPri()
//Verifica se o arquivo TMP estแ em uso

Local _CPrinc := ""
	If Select("TTMM") > 0
	   TTMM->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
	ccQry += "AND  D3_CF IN ('RE6','RE0') "    //D3_CF IN ('RE6','DE0','DE6','RE0')
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "
	ccQry += "AND  D3_TM ='501' "
	ccQry += "AND  D3_OP LIKE '" + substr(_Op,1,6) + "%' "  	 
	//ccQry += "AND  D3_OP = '" + _Op + "' "
	ccQry += "GROUP BY D3_FILIAL " 
	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTMM",.T.,.T.) 
	
	_CPrinc := TTMM->Custo1
	
	//
Return _CPrinc

Static Function TotOpReq()
//Verifica se o arquivo TMP estแ em uso

Local _CPReq := ""

	If Select("TTMR") > 0
	   TTMR->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
	ccQry += "AND  D3_CF IN ('RE6','DE0','DE6','RE0') "    //D3_CF IN ('RE6','DE0','DE6','RE0')    //('RE6','RE0')
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "
	ccQry += "AND  D3_OP LIKE '" + substr(_Op,1,6) + "%' "  	 
	//ccQry += "AND  D3_OP = '" + _Op + "' "
	ccQry += "GROUP BY D3_FILIAL " 
	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTMR",.T.,.T.) 
	
	_CPrinc := TTMR->Custo1
	
	//
Return _CPReq


Static Function TotOpPi()
//Verifica se o arquivo TMP estแ em uso

Local _CPReqPi := ""

	If Select("TTPI") > 0
	   TTPI->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
	ccQry += "AND  D3_CF IN ('RE6','RE0') "    //D3_CF IN ('RE6','DE0','DE6','RE0')    //('RE6','RE0')
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "
	ccQry += "AND  D3_TIPO = 'PI' "
	//ccQry += "AND  D3_OP LIKE '" + substr(_Op,1,6) + "%' "  	 
	ccQry += "AND  D3_OP = '" + _Op + "' "
	ccQry += "GROUP BY D3_FILIAL " 
	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTPI",.T.,.T.) 
	
	_CPReqPi := TTPI->Custo1
	
	//
Return _CPReqPi





