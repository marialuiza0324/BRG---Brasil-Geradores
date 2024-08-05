#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "topconn.ch"

/*
Funcao      : Relatório de Despesas Acerto de Viagem
Objetivos   : Relatório 
Programa    : BRG024
*/

User function BRG024()
	
Private cPerg       := PADR("BRG024",Len(SX1->X1_GRUPO))
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

cTitulo := "Relação Despesas - Cartão: " + CVALTOCHAR(MV_PAR01)
 
oReport  := TReport():New("BRG024",cTitulo,"BRG024",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  
//oReport:SetPortrait()    // Retrato
oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relação Despesas Viagem",{""})
TRCell():New(oSection, "CEL01_FILIAL"          , "ZPX", "Filial"              ,PesqPict("ZPX","ZPX_FILIAL"   ),04                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_DATA"            , "ZPX", "Data"                ,PesqPict("ZPX","ZPX_DATA"     ),15                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_CLASS"           , "ZPX", "Classificação"       ,PesqPict("ZPX","ZPX_CLAS"     ),25				    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_DESC"            , "ZPX", "Descrição"           ,PesqPict("ZPX","ZPX_DESC"     ),60 				    , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_MODAL"           , "ZPX", "Modalidade"  		  ,PesqPict("ZPX","ZPX_MODAL"    ),25                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_VALOR"           , "ZPX", "Valor"  	          ,PesqPict("ZPX","ZPX_VALOR"    ),16                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_APLIC"           , "ZPX", "Aplicação"  	      ,PesqPict("ZPX","ZPX_APLIC"    ),60                   , /*lPixel*/, /* Formula*/)

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
Local _nTot     := 0
Local _nTotCart := 0
Local _nTotFat  := 0
Local _nTotAcer := 0
Local _nTotSaq  := 0
Local _nReemb   := 0
Private aDados[7]

oSection:Cell("CEL01_FILIAL"  ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_DATA"    ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_CLASS"   ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_DESC"    ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_MODAL"   ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_VALOR"   ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_APLIC"   ):SetBlock( { || aDados[07]})

//oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FILIAL"),,.F.)
//TRFunction():New(oSection:Cell("CEL06_VALOR"),"TOT","SUM"  ,oBreak,"Custo Total da Viagem","@E 999,999,999.99",,.F.,.T.)
 
oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := "SELECT ZPX_FILIAL, ZPX_ACERTO,ZPX_CARTAO,ZPX_DATA,ZPX_ITEM,ZPX_DESC,ZPX_VALOR,ZPX_APLIC,ZPX_TRANSP,  "
_cQry += "CASE ZPX_CLAS "
_cQry += "WHEN 1 THEN 'Diária' "
_cQry += "WHEN 2 THEN 'Combústivel' "
_cQry += "WHEN 3 THEN 'Peças' "
_cQry += "WHEN 4 THEN 'Passagem' "
_cQry += "WHEN 5 THEN 'Hospedagem' "
_cQry += "WHEN 6 THEN 'Refeição' "
_cQry += "WHEN 7 THEN 'Outros' "
_cQry += "END AS Classificacao, "
_cQry += "CASE ZPX_MODAL "
_cQry += "WHEN 1 THEN 'Cartão Empresa' "
_cQry += "WHEN 2 THEN 'Faturado' "
_cQry += "WHEN 3 THEN 'Acerto' "
_cQry += "WHEN 4 THEN 'Saque' "
_cQry += "END AS Modalidade "
_cQry += "FROM " + retsqlname("ZPX")+" ZPX "
_cQry += "WHERE ZPX.D_E_L_E_T_ <> '*' "   
_cQry += "AND   ZPX_CARTAO = '" + mv_par01  + "'  "
_cQry += "AND   ZPX_DATA 	BETWEEN '" + DTOS(mv_par02)  + "' AND '" + DTOS(mv_par03)  + "' "   // EMISSAO
_cQry += "ORDER BY ZPX_ACERTO,ZPX_CARTAO,ZPX_ITEM,ZPX_DATA "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TMP",.T.,.T.)      


dbselectarea("TMP")
DBGOTOP()
DO WHILE !TMP->(EOF())
	
	If oReport:Cancel()
		Exit
	EndIf
    aDados[01] := TMP->ZPX_FILIAL
	aDados[02] := CVALTOCHAR(STOD(TMP->ZPX_DATA))	
	aDados[03] := TMP->Classificacao 
	aDados[04] := TMP->ZPX_DESC
	aDados[05] := TMP->Modalidade
	aDados[06] := TMP->ZPX_VALOR	
    aDados[07] := TMP->ZPX_APLIC	
	
	oSection:PrintLine()  // Imprime linha de detalhe
	
	aFill(aDados,nil)     // Limpa o array a dados


	_nTot:= _nTot + TMP->ZPX_VALOR

	IF TMP->Modalidade = 'Cartão Empresa'
	   _nTotCart := _nTotCart + TMP->ZPX_VALOR
    EndIf
	IF TMP->Modalidade = 'Faturado'
	   _nTotFat := _nTotFat + TMP->ZPX_VALOR
    EndIf
	IF TMP->Modalidade = 'Acerto'
	   _nTotAcer := _nTotAcer + TMP->ZPX_VALOR
    EndIf
	IF TMP->Modalidade = 'Saque'
	   _nTotSaq := _nTotSaq + TMP->ZPX_VALOR
    EndIf
	
	dbselectarea("TMP")
	skip
	
ENDDO

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf
oReport:SkipLine(3)
oReport:FatLine( )
//oReport:SkipLine(2) //TotOpPri() - TotGerD()    //CustoPi   TotOpPri() - TotGerD()
oReport:SkipLine(3)
oReport:Say(oReport:Row(),100,"Custo Total da Viagem...: " + AllTrim(Transform((_nTot), "@ze 9,999,999,999,999.99"))) 
oReport:SkipLine(2) 
oReport:Say(oReport:Row(),100,"Total Cartão Empresa....: " + AllTrim(Transform(_nTotCart, "@ze 9,999,999,999,999.99")))
oReport:SkipLine(2) 
oReport:Say(oReport:Row(),100,"Total Faturado..........: " + AllTrim(Transform(_nTotFat, "@ze 9,999,999,999,999.99")))
oReport:SkipLine(2) 
oReport:Say(oReport:Row(),100,"Total Saque.............: " + AllTrim(Transform((_nTotSaq), "@ze 9,999,999,999,999.99"))) 
oReport:SkipLine(2) 
oReport:Say(oReport:Row(),100,"Total Acerto............: " + AllTrim(Transform((_nTotAcer), "@ze 9,999,999,999,999.99"))) 
oReport:SkipLine(2) 
_nReemb := (_nTotCart+_nTotSaq+_nTotAcer) - _nTot

If _nReemb < 0
   _nReemb := 0 
   oReport:Say(oReport:Row(),100,"Reembolso P/ Funcionário: " + AllTrim(Transform((_nReemb), "@ze 9,999,999,999,999.99"))) 
Else
   oReport:Say(oReport:Row(),100,"Reembolso P/ Funcionário: " + AllTrim(Transform((_nReemb), "@ze 9,999,999,999,999.99"))) 
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

aAdd(aRegs,{cPerg,"01","Cartao     		  ?","","","mv_ch1","C",05,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA6CR"})
aAdd(aRegs,{cPerg,"02","Data de   	      ?","","","mv_ch2","D",10,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"03","Data Ate          ?","","","mv_ch3","D",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})

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
			AADD(aHelpPor,"Informe o Cartão             ")
		ElseIf i==2                                            
			AADD(aHelpPor,"Informe a Data Inicial.               ")	 
		ElseIf i==3
			AADD(aHelpPor,"Informe a Data Final.            ")		
		EndIf
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return     

