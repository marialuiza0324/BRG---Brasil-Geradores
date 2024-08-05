#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BRG030 º Autor ³ Ricardo Moreira     º Data ³  29/09/20    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍ¹±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Vendas por Tipo                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BRG GERADORES		              			              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BRG030 //U_BRG030

Private cPerg       := PADR("BRG030",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatório de Faturamento - Periodo " + CVALTOCHAR(MV_PAR03) + " a " + CVALTOCHAR(MV_PAR04)
 
oReport  := TReport():New("BRG030",cTitulo,"BRG030",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  
//oReport:SetTotalInLine(.F.) // Imprime o total em linhas
//oReport:SetPortrait()    // Retrato
oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatório de Faturamento",{""})
TRCell():New(oSection, "CEL01_FILIAL"          , "SD2", "Filial"             ,PesqPict("SD2","D2_FILIAL"   ),05                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_CLIENTE"         , "SD2", "Cliente"            ,PesqPict("SD2","D2_COD"      ),20                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_NOME"            , "SA1", "Nome Cliente"       ,PesqPict("SA1","A1_COD"      ),50                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_TIPO"            ,      , "Tipo"               ,                              ,45                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_TOTAL"           , "SD2", "Total"              ,                              ,20                   , /*lPixel*/, /* Formula*/)
//TRCell():New(oSection1,"_nValor"," ","Valor",PesqPict("SD2","D2_TOTAL"),15)
//oReport:Cell("CEL06_TOTAL"):SetPicture("@E 999,999,999.99")

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
Local xTpProd    := SuperGetMV("MV_TPPROD", ," ") // Parametro contendo TIPO PRODUTO
Local xTpLoc     := SuperGetMV("MV_TPLOC", ," ") // Parametro contendo TIPO LOCACAO
Local xTpMan     := SuperGetMV("MV_TPMNT", ," ") // Parametro contendo TIPO MANUTENÇAÕ
Local xTpAtiv    := SuperGetMV("MV_TPATIV", ," ") // Parametro contendo TIPO ATIVO IMOBILIZADO
Local xTpEnerg   := SuperGetMV("MV_TPENER", ," ") // Parametro contendo TIPO ENERGIA
Local xTpVend    := SuperGetMV("MV_TPVEND ", ," ") // Parametro contendo TIPO DE VENDA
Private aDados[05]

oSection:Cell("CEL01_FILIAL"  ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_CLIENTE" ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_NOME"    ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_TIPO"    ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_TOTAL"   ):SetBlock( { || aDados[05]})

oBreak := TRBreak():New(oSection,oSection:Cell("CEL04_TIPO"),,.F.)
 
TRFunction():New(oSection:Cell("CEL05_TOTAL"),"TOT","SUM"  ,oBreak,"Total ","@E 999,999,999.99",,.F.,.T.) //'@E@Z 999.99'
 

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := "SELECT DISTINCT  D2_FILIAL, D2_CLIENTE, A1_NREDUZ,'PRODUTO ACABADO' TIPO, SUM(D2_TOTAL) Total, SUM(D2_VALIPI) Ipi,SUM(D2_TOTAL+D2_VALIPI) Tot_Geral  "
_cQry += "FROM " + retsqlname("SD2")+" SD2 "  
_cQry += " INNER JOIN " + retsqlname("SA1")+" SA1 ON D2_CLIENTE  = A1_COD AND D2_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ <> '*'  "	
_cQry += " INNER JOIN " + retsqlname("SF4")+" SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES  = F4_CODIGO AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ <> '*'  "	
_cQry += "WHERE SD2.D_E_L_E_T_ <> '*' " 
_cQry += "AND  D2_CF IN ("+xTpProd+") " //Produto MV_TPPROD //('5101','6101','6107','6108','5405','6405','5252','6252')
//_cQry += "AND   B1_DESC LIKE 'GERADOR%' " 
_cQry += "AND   D2_CLIENTE   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   D2_EMISSAO 	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "AND D2_TIPO = 'N' "
_cQry += "GROUP BY D2_FILIAL, D2_CLIENTE, A1_NREDUZ "
 
_cQry += "UNION "

_cQry += "SELECT DISTINCT  D2_FILIAL, D2_CLIENTE, A1_NREDUZ,'LOCACAO' TIPO ,SUM(D2_TOTAL) Total, SUM(D2_VALIPI) Ipi,SUM(D2_TOTAL+D2_VALIPI) Tot_Geral  "
_cQry += "FROM " + retsqlname("SD2")+" SD2 "  
_cQry += " INNER JOIN " + retsqlname("SA1")+" SA1 ON D2_CLIENTE  = A1_COD AND D2_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ <> '*'  "	
_cQry += " INNER JOIN " + retsqlname("SF4")+" SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES  = F4_CODIGO AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ <> '*'  "	
_cQry += "WHERE SD2.D_E_L_E_T_ <> '*' " 
_cQry += "AND   D2_TES IN ("+xTpLoc+") " //Locação //MV_TPLOC //('530','535','531','532')
//_cQry += "AND   D2_CF IN ('5933','6933','0000') " //Locação
//_cQry += "AND   B1_DESC LIKE 'GERADOR%' " 
_cQry += "AND   D2_CLIENTE   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   D2_EMISSAO 	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "AND D2_TIPO = 'N' "
_cQry += "GROUP BY D2_FILIAL, D2_CLIENTE, A1_NREDUZ "

_cQry += "UNION "

_cQry += "SELECT DISTINCT  D2_FILIAL, D2_CLIENTE, A1_NREDUZ,'MANUTENCAO' TIPO ,SUM(D2_TOTAL) Total, SUM(D2_VALIPI) Ipi,SUM(D2_TOTAL+D2_VALIPI) Tot_Geral  "
_cQry += "FROM " + retsqlname("SD2")+" SD2 "  
_cQry += " INNER JOIN " + retsqlname("SA1")+" SA1 ON D2_CLIENTE  = A1_COD AND D2_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ <> '*'  "	
_cQry += " INNER JOIN " + retsqlname("SF4")+" SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES  = F4_CODIGO AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ <> '*'  "	
_cQry += "WHERE SD2.D_E_L_E_T_ <> '*' " 
_cQry += "AND   D2_TES IN ("+xTpMan+") " //Manutenção  //MV_TPMNT  //('510','515')
//_cQry += "AND   D2_CF IN ('5933','6933','0000') " //
//_cQry += "AND   B1_DESC LIKE 'GERADOR%' " 
_cQry += "AND   D2_CLIENTE   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   D2_EMISSAO 	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "AND D2_TIPO = 'N' "
_cQry += "GROUP BY D2_FILIAL, D2_CLIENTE, A1_NREDUZ "

_cQry += "UNION "

_cQry += "SELECT DISTINCT  D2_FILIAL, D2_CLIENTE, A1_NREDUZ,'ATIVO IMOBILIZADO' TIPO ,SUM(D2_TOTAL) Total, SUM(D2_VALIPI) Ipi,SUM(D2_TOTAL+D2_VALIPI) Tot_Geral  "
_cQry += "FROM " + retsqlname("SD2")+" SD2 "  
_cQry += " INNER JOIN " + retsqlname("SA1")+" SA1 ON D2_CLIENTE  = A1_COD AND D2_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ <> '*'  "	
_cQry += " INNER JOIN " + retsqlname("SF4")+" SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES  = F4_CODIGO AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ <> '*'  "	
_cQry += "WHERE SD2.D_E_L_E_T_ <> '*' " 
_cQry += "AND   D2_CF  IN ("+xTpAtiv+") " //Ativo Imobilizado  //MV_TPATIV   //('5551','6551')
_cQry += "AND   D2_CLIENTE   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   D2_EMISSAO 	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "AND D2_TIPO = 'N' "
_cQry += "GROUP BY D2_FILIAL, D2_CLIENTE, A1_NREDUZ "

_cQry += "UNION "

_cQry += "SELECT DISTINCT  D2_FILIAL, D2_CLIENTE, A1_NREDUZ,'ENERGIA' TIPO ,SUM(D2_TOTAL) Total, SUM(D2_VALIPI) Ipi,SUM(D2_TOTAL+D2_VALIPI) Tot_Geral  "
_cQry += "FROM " + retsqlname("SD2")+" SD2 "  
_cQry += " INNER JOIN " + retsqlname("SA1")+" SA1 ON D2_CLIENTE  = A1_COD AND D2_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ <> '*'  "	
_cQry += " INNER JOIN " + retsqlname("SF4")+" SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES  = F4_CODIGO AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ <> '*'  "	
_cQry += "WHERE SD2.D_E_L_E_T_ <> '*' " 
_cQry += "AND   D2_CF IN ("+xTpEnerg+") " //Energia Eletrica  //MV_TPENER  //('5551','6551')
_cQry += "AND   D2_CLIENTE   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   D2_EMISSAO 	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "AND D2_TIPO = 'N' "
_cQry += "GROUP BY D2_FILIAL, D2_CLIENTE, A1_NREDUZ "

_cQry += "UNION "

_cQry += "SELECT DISTINCT  D2_FILIAL, D2_CLIENTE, A1_NREDUZ,'VENDA PEÇAS' TIPO,SUM(D2_TOTAL) Total, SUM(D2_VALIPI) Ipi,SUM(D2_TOTAL+D2_VALIPI) Tot_Geral "
_cQry += "FROM " + retsqlname("SD2")+" SD2 "  
_cQry += " INNER JOIN " + retsqlname("SA1")+" SA1 ON D2_CLIENTE  = A1_COD AND D2_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ <> '*'  "	
_cQry += " INNER JOIN " + retsqlname("SF4")+" SF4 ON D2_FILIAL = F4_FILIAL AND D2_TES  = F4_CODIGO AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ <> '*'  "	
_cQry += "WHERE SD2.D_E_L_E_T_ <> '*' " 
_cQry += "AND   D2_CF IN ("+xTpVend+") " //Venda  MV_TPVEND//('5102','6102')
//_cQry += "AND   B1_DESC LIKE 'GERADOR%' " 
_cQry += "AND   D2_CLIENTE   BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "AND   D2_EMISSAO 	BETWEEN '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04)  + "' "
_cQry += "AND D2_TIPO = 'N' "
_cQry += "GROUP BY D2_FILIAL, D2_CLIENTE, A1_NREDUZ "
_cQry += "ORDER BY D2_FILIAL, TIPO,Tot_Geral,D2_CLIENTE"


_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE !TMP->(EOF())
	
	If oReport:Cancel()
		Exit
	EndIf	

    aDados[01] := TMP->D2_FILIAL 
	aDados[02] := TMP->D2_CLIENTE	
	aDados[03] := TMP->A1_NREDUZ
    aDados[04] := TMP->TIPO
    aDados[05] := Transform((TMP->Tot_Geral),"@E 999,999,999.99")  
	
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

aAdd(aRegs,{cPerg,"01","Cliente de        ?","","","mv_ch1","C",14,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"02","Cliente Ate       ?","","","mv_ch2","C",14,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA1"})
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
			AADD(aHelpPor,"Informe o Cliente Inicial.             ")
		ElseIf i==2                                            
			AADD(aHelpPor,"Informe o Cliente Final.               ")	 
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
