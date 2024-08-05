#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BRG003   º Autor ³ 3RL Soluções       º Data ³  20/06/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão do Documento de Transferência Local              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BRG GERADORES			                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BRG003() //U_BRG003()

	Private oSay1
	Private oSay2
	Private oGet1
	Private cGet1 := space(10)
	Private oGet2
	Private cGet2 := space(10)
	Private oGet3
	Private oGet5
	Private cGet3 := space(9)
	Private cGet4 := space(4)
	Private cGet5 := space(40)
	Private _cFilDoc :=""
	Private nLinH := 0
	Private nLinV := 0
//MV_USETRAN  PARAMETRO PARA VERIFICAR QUAIS USUÁRIOS TRANSFERIR PARA ASSISTENCIA
	Static _oQcr

	_cOP := space(13)
	@ 023,090 To 200,620 Dialog _oQcr Title OemToAnsi("Impressão de Tranferência")
	@ 015, 010 SAY oSay1 PROMPT "Transferência De :" SIZE 088, 007 OF _oQcr COLORS 0, 16777215 PIXEL
	@ 015, 075 MSGET oGet1 VAR cGet1 SIZE 045, 010 OF _oQcr COLORS 0, 16777215 F3 "NNS" PIXEL
	@ 035, 010 SAY oSay2 PROMPT "Transferência Ate:" SIZE 088, 007 OF _oQcr COLORS 0, 16777215 PIXEL
	@ 035, 075 MSGET oGet2 VAR cGet2 SIZE 045, 010 OF _oQcr COLORS 0, 16777215 F3 "NNS" PIXEL
	@ 055, 010 SAY oSay3 PROMPT "Cliente/Loja:" SIZE 088, 007 OF _oQcr COLORS 0, 16777215 PIXEL
	@ 055, 075 MSGET oGet3 VAR cGet3 VALID CLITRAN() SIZE 045, 010 OF _oQcr COLORS 0, 16777215 F3 "SA1" PIXEL
	@ 055, 120 MSGET oGet4 VAR cGet4 SIZE 020, 010 OF _oQcr COLORS 0, 16777215 READONLY PIXEL
	@ 055, 145 MSGET oGet5 VAR cGet5 SIZE 120, 010 OF _oQcr COLORS 0, 16777215 READONLY PIXEL

	@ 009,200 BmpButton Type 1 ACTION U_ImpTran(cGet1,cGet2)
	@ 025,200 BmpButton Type 2 ACTION CLOSE(_oQcr)
	Activate Dialog _oQcr Centered

Return (.t.)

User Function ImpTran()

	Local aArea   			:= GetArea()
	Local aOrd  			:= {}
	Local cDesc1 			:= "Este programa tem como objetivo imprimir "
	Local cDesc2 			:= "as tranferência de produtos entre Locais."
	Local cDesc3 			:= ""
	Private _Doc            := ""
	Private nomeprog 		:= "IMPTRAN"
	Private cPerg    		:= "IMPTRAN"
//aReturn[4] 1- Retrato, 2- Paisagem
//aReturn[5] 1- Em Disco, 2- Via Spool, 3- Direto na Porta, 4- Email
	Private aReturn  		:= {"Zebrado", 1,"Administracao", 1, 1, "1", "",1 }	//"Zebrado"###"Administracao"
	Private nTamanho		:= "M"
	Private wnrel        	:= "IMPTRAN"            //Nome Default do relatorio em Disco
	Private cString     	:= "NNS"
	Private titulo 			:= "Impressão de Tranferência"
	Private nPage			:= 1
	Private oFont6		:= TFONT():New("Courier new",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
	Private oFont6N 	:= TFONT():New("Courier new",7,6,,.T.,,,,.T.,.F.) ///Fonte 6 Negrito
	Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
	Private oFont8N 	:= TFONT():New("ARIAL",8,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
	Private oFont9    	:= TFONT():New("ARIAL",10,9,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 9 Normal
	Private oFont9N 	:= TFONT():New("ARIAL",9,9,,.T.,,,,.T.,.F.) ///Fonte 9 Negrito
	Private oFont10    	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 10 Normal
	Private oFont10S	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.T.) ///Fonte 10 Sublinhando
	Private oFont10N 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.F.) ///Fonte 10 Negrito
	Private oFont12		:= TFONT():New("Courier new",12,12,,.F.,,,,.T.,.F.) ///Fonte 12 Normal
	Private oFont12NS	:= TFONT():New("Courier new",12,12,,.T.,,,,.T.,.T.) ///Fonte 12 Negrito e Sublinhado
	Private oFont12N	:= TFONT():New("Courier new",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito
	Private oFont14		:= TFONT():New("ARIAL",14,14,,.F.,,,,.T.,.F.) ///Fonte 14 Normal
	Private oFont14NS	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.T.) ///Fonte 14 Negrito e Sublinhado
	Private oFont14N	:= TFONT():New("Courier new",14,14,,.T.,,,,.T.,.F.) ///Fonte 14 Negrito
	Private oFont16  	:= TFONT():New("ARIAL",16,16,,.F.,,,,.T.,.F.) ///Fonte 16 Normal
	Private oFont16N	:= TFONT():New("Courier new",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
	Private oFont16NS	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.T.) ///Fonte 16 Negrito e Sublinhado
	Private oFont20N	:= TFONT():New("ARIAL",20,20,,.T.,,,,.T.,.F.) ///Fonte 20 Negrito
	Private oFont22N	:= TFONT():New("ARIAL",22,22,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito
	Private cCodUser := RetCodUsr()
	Private cUseTran := SuperGetMV("MV_USETRAN", ," ")  //
	Private nLin 			:= 0
	Private _Obs			:= " "
	Private _Cli    := ""
	Private _Soli    := ""
	Private _Lj     := ""
	private _cli1   := ""
	private _Lj1    := ""
	private _Desc1  := ""
	Private numRpa := 0
	Public _oPrint
	Private cLogoD
	Private  cStartPath := GETPVPROFSTRING(GETENVSERVER(),"StartPath","ERROR",GETADV97())
	cStartPath += IF(RIGHT(cStartPath,1) <> "\","\","")
	//   cLogoD     := cStartPath + "LGRL" + cFilAnt + ".IBMP"
	//    cLogoD     :=  "\system\DANFE01" + cFilAnt+ ".bmp"

	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho )

	//nOrdem :=  aReturn[8]
//	GeraX1(cPerg)
	//If(Pergunte(cPerg, .T.,"Parametros do Relatório",.F.),Nil,Nil) aBRE OS PARAMETROS DUAS VEZES
	//	SetDefault(aReturn,cString,,,nTamanho,,)   ABRE A TELA DO DIRETORIO PRA SALVAR SE É PREVIEW NAÕ TEM NECESSIDADE
	If nLastKey==27
		dbClearFilter()
		Return
	Endif
	RptStatus({|lEnd| lPrint(@lEnd,wnRel)},Titulo)  // Chamada do Relatorio
	If !Empty(aArea)
		RestArea(aArea)
		//	aArea
	EndIf
return nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Layout do Relatorio                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Static Function lPrint(lEnd,WnRel)

	oPrint := TMSPrinter():New()
	oPrint:SetPortrait()
	//oPrint:SetLandscape() // Paisagem
	getHeader(@nPage)
	oPrint:EndPage()
	//TMP->(DbCloseArea())
	oPrint:Preview()
	//Libera o arquivo do relatório
	MS_FLUSH()
Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho do relatorio                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Static Function getHeader(nPage)

	Dados()
	cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
	cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")

	If empty(cGet3) .And. empty(TMP1->NNS_CSOLIC)
		MSGINFO("Obrigatório o Cliente !!!!!"," Atenção ")
		Return
	EndIf

	_Doc := TMP1->NNS_COD
	While TMP1->(!EOF())
		oPrint:StartPage()
		nLin+=20
		oPrint:Say(nLin,600,"TRANSFERENCIA DE PRODUTO", oFont16N)
		nLin+=100
		oPrint:Say(nLin,050,"Documento: "+TMP1->NNS_COD, oFont12)

		_Soli   := TMP1->NNS_SOLIC
		_cli1   := TMP1->NNS_CSOLIC
		_Lj1    := TMP1->NNS_LOJA
		_Desc1  := TMP1->NNS_DESCCL

		//Grava o Cliente digitado na Tela

		if !EMPTY(cGet3)
			DbSelectArea("NNS")
			DBGOTOP()
			DbSetOrder(1)  // D1_FILIAL +  D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA
			If DbSeek(xFilial("NNS")+TMP1->NNS_COD)
				_Cli := cGet3
				_Lj  := cGet4
				NNS->(RECLOCK("NNS",.F.))
				NNS->NNS_CSOLIC := cGet3
				NNS->NNS_LOJA   := cGet4
				NNS->NNS_DESCCL := cGet5
				NNS->(MSUNLOCK())
				NNS->(dbSkip())
			EndiF
		ENDiF
		NNS->(dbCloseArea())

		oPrint:Say(nLin,800,"Data: "+CVALTOCHAR(STOD(TMP1->NNS_DATA)), oFont12)
		oPrint:Say(nLin,1400,"Solicitante: "+UsrRetName(TMP1->NNS_SOLICT), oFont12)

		_Obs := TMP1->NNS_XOBS


		nLin+=100
		oPrint:Line(nLin,010,nLin,2100)
		nLin+=70

		//oPrint:Say(nLin,080,"LOTE SEKOYA: "+TMP1->C2_NUM, oFont12N)
		oPrint:Say(nLin,050,"Produto", oFont9N)
		oPrint:Say(nLin,300,"Un", oFont9N)
		oPrint:Say(nLin,400,"Quantidade", oFont9N)
		oPrint:Say(nLin,700,"Descrição", oFont9N)
		oPrint:Say(nLin,1400,"Local Orig.", oFont9N)
		oPrint:Say(nLin,1600,"Local Dest.", oFont9N)
		oPrint:Say(nLin,1800,"Endereço", oFont9N)
		oPrint:Say(nLin,2000,"Lote", oFont9N)

		While !TMP1->(eof()) .AND. _Doc = TMP1->NNS_COD
			nLin+=70
			_End := Posicione("SB1",1,xFilial("SB1")+TMP1->NNT_PROD,"B1_XENDERE")

			oPrint:Say(nLin,050,TMP1->NNT_PROD, oFont9N)
			oPrint:Say(nLin,300,TMP1->NNT_UM, oFont9N)
			oPrint:Say(nLin,400,Transform(TMP1->NNT_QUANT, "@e 999,999.999"), oFont9N)
			oPrint:Say(nLin,700,TMP1->B1_DESC, oFont9N)
			oPrint:Say(nLin,1400,TMP1->NNT_LOCAL, oFont9N)
			oPrint:Say(nLin,1600,TMP1->NNT_LOCLD, oFont9N)
			oPrint:Say(nLin,1800,_End, oFont9N)
			oPrint:Say(nLin,2000,TMP1->NNT_LOTECT, oFont9N)

			TMP1->(dbskip())
		EndDo
		nLin+=150
		oPrint:Say(nLin,050,"Observações: "+_Obs, oFont9N)
		nLin+=150

		//If cCodUser $ cUseTran
		If !EMPTY(cGet3)
			_Client :=   Posicione("SA1",1,xFilial("SA1")+_Cli+_Lj,"A1_NOME")
			oPrint:Say(nLin,050,"Cliente: "+ALLTRIM(_Cli)+"/"+_Lj+'-'+_Client , oFont8N)
		else
			oPrint:Say(nLin,050,"Cliente: "+_cli1 +"/"+_Lj1 +'-'+_Desc1, oFont8N)
		ENDiF

		nLin+=150
		//EndIf

		oPrint:Say(nLin,050,"Solicitante: " +_Soli, oFont8N)
		nLin+=150
		oPrint:Line(nLin,010,nLin,800)
		oPrint:Line(nLin,1000,nLin,1800)
		nLin+=15
		oPrint:Say(nLin,050,"Responsável pela Entrega", oFont8N)
		oPrint:Say(nLin,1400,"Responsável pela Devolução", oFont8N)
		nLin+=150
		oPrint:Line(nLin,010,nLin,800)
		oPrint:Line(nLin,1000,nLin,1800)
		nLin+=15
		oPrint:Say(nLin,050,"Responsável pela Retirada", oFont8N)
		oPrint:Say(nLin,1400,"Data da Devolução", oFont8N)
		nLin+=150
		oPrint:Line(nLin,010,nLin,800)
		oPrint:Line(nLin,1000,nLin,1800)
		nLin+=15
		oPrint:Say(nLin,050,"Data da Retirada", oFont8N)
		oPrint:Say(nLin,1400,"Responsável pela Conferencia", oFont8N)
		nLin+=150
		oPrint:Say(nLin,1000,"[ ] Total  [ ] Parcial ", oFont8N)
		nLin+=150
		oPrint:Say(nLin,1000,"Observações_________________________________________________________________", oFont8N)


		nLin+=15

		nLin+=50
		_Doc = TMP1->NNS_COD
		// If nLin >= 2350 // veja o tamanho adequado da página que este numero pode variar
		oPrint:EndPage() // Finaliza a página
		//oPrint:StartPage()
		//nLin := 070
		//  Endif

		nLin:= 0
	Enddo
	CLOSE(_oQcr)
Return Nil

Static Function Dados()
//Verifica se o arquivo TMP está em uso
	If Select("TMP1") > 0
		TMP1->(DbCloseArea())
	EndIf
	cQry := " "
	cQry += "SELECT * "
	cQry += "FROM " + retsqlname("NNT")+" NNT "
	cQry += "INNER JOIN " + retsqlname("NNS") + " NNS ON  NNT_FILIAL = NNS_FILIAL AND NNT_COD = NNS_COD AND NNS.D_E_L_E_T_ <> '*' "
	cQry += "INNER JOIN " + retsqlname("SB1") + " SB1 ON  NNT_PROD = B1_COD AND SB1.D_E_L_E_T_ <> '*' "
	cQry += "WHERE NNT.D_E_L_E_T_ <> '*' "
	cQry += "AND NNS_COD   BETWEEN '" + cGet1  + "' AND '" + cGet2  + "' "
	cQry += "AND B1_FILIAL = '" + substr(cFilAnt,1,2)+ "' "
	cQry += "AND NNT_FILIAL = '" +cFilAnt+ "' "
	cQry += "ORDER BY NNT_FILIAL,NNS_COD,NNT_PROD "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP1",.T.,.T.)
Return Nil


//Preencha o nome do cliente
//12/05/2021
//BRG Geradores

Static Function CLITRAN()
	Local _ret := .T.

	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+cGet3+cGet4)
		cGet5 := SA1->A1_NOME
		oGet5:Refresh()
	EndiF

Return _ret
