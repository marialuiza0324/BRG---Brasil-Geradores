/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BRG025  ³ Autor ³ Ricardo Moreira³ 		  Data ³ 21/02/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o Relatório Tecnico - Acerto de Viagens            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BRG                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH" 
#DEFINE CRLF Chr(13)+Chr(10) 

User Function BRG025()

Local cTransp :=  " "
Local cTec :=  " "
local cPlaca := " "
Local _aBmp := {}
Local _nTot := 0
Local _Total    := 0
Local _nTotCart := 0
Local _nTotComb := 0
Local _nTotFat  := 0
Local _nTotAbIn := 0
Local _nTotAcer := 0
Local _nTotSaq  := 0
Local _nReemb   := 0
Local _DescMod  := ""
Local _Litros := 0
Local _kmRod := 0
Local _nTotAdi := 0
Local _cResp  := SuperGetMV("MV_RESPON", ," ") // OK
Local _Diarias := DateDiffDay(ZPX->ZPX_DIAINI,ZPX->ZPX_DIAFIM)
 
Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal  //Times New Roman
Private oFont6N 	:= TFONT():New("ARIAL",7,6,,.T.,,,,.T.,.F.) ///Fonte 6 Negrito
Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
Private oFont8N 	:= TFONT():New("ARIAL",8,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito  
Private oFont10    	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 10 Normal
Private oFont10S	:= TFONT():New("Courier new",9,10,.T.,.F.,5,.T.,5,.T.,.T.) ///Fonte 10 Sublinhando
Private oFont10N 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.F.) ///Fonte 10 Negrito
Private oFont12		:= TFONT():New("Courier new",12,12,,.F.,,,,.T.,.F.) ///Fonte 12 Normal
Private oFont12NS	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.T.) ///Fonte 12 Negrito e Sublinhado
Private oFont12N	:= TFONT():New("Courier new",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito
Private oFont14		:= TFONT():New("Courier new",14,14,,.F.,,,,.T.,.F.) ///Fonte 14 Normal
Private oFont14NS	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.T.) ///Fonte 14 Negrito e Sublinhado
Private oFont14N	:= TFONT():New("Times New Roman",14,14,,.T.,,,,.T.,.F.) ///Fonte 14 Negrito
Private oFont16  	:= TFONT():New("ARIAL",16,16,,.F.,,,,.T.,.F.) ///Fonte 16 Normal
Private oFont16N	:= TFONT():New("Times New Roman",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
Private oFont16NS	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.T.) ///Fonte 16 Negrito e Sublinhado
Private oFont20N	:= TFONT():New("ARIAL",20,20,,.T.,,,,.T.,.F.) ///Fonte 20 Negrito
Private oFont22N	:= TFONT():New("ARIAL",22,22,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito
Private oFont36N	:= TFONT():New("ARIAL",36,36,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito

//³Variveis para impressão                                              ³

Private cStartPath
Private nLin 		:= 50
//FwMSPrinter
Private oPrint 
//Private oPrint      := FWMSPrinter():New("Acerto.rel")
//Private oPrint		:= TMSPRINTER():New("")
Private nPag		:= 1
Private _Emp
Private cPerg 		:= "ImpMPS"
Private nRepita // variavel que controla a quantidade de relatorios impressos
Private nContador // contador do for principal, que imprime o relatorio n vezes
Private nZ
Private nJ
Private cLogoD    
//Private	_Qtd    := " "
Private	_Local  := " "
Private	_LtCtl  := " " 
Private _Prod   := " " 
Private _NumSeq := " "

If oPrint == Nil

//oPrint:=FwMSPrinter():New("Laudo.rel")

oPrint:=FWMSPrinter():New("Acerto_"+ZPX->ZPX_ACERTO,6,.T.,,.T.)
oPrint:SetPortrait() 
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
oPrint:cPathPDF :="C:\ACERTOS\" 
//oPrint:Preview()  
//oPrint:cPathPDF := "c:\rel\"

//oPrint:SetParm( "-RFS")
 

//If oPrint:nLogPixelY() < 300
	//MsgInfo("Impressora com baixa resolução o modo de compatibilidade será acionado!")
//	oPrint:SetCurrentPrinterInUse()
EndIf

//Private _SomSbf := 0
//Private  cStartPath := GETPVPROFSTRING(GETENVSERVER(),"StartPath","ERROR",GETADV97())
//cStartPath += IF(RIGHT(cStartPath,1) <> "\","\","")
//         cLogoD     := cStartPath + "LGRL" + cFilAnt + ".BMP"
//cLogoD     :=  "LGRL" + cEmpAnt+ ".BMP"

//³Define Tamanho do Papel                                                  ³

//#define DMPAPER_A4 9 //Papel A4
//oPrint:setPaperSize( DMPAPER_A4 )

//////////oPrint:SetPortrait()///Define a orientacao da impressao como retrato
//oPrint:SetLandscape() ///Define a orientacao da impressao como paisagem
//³Monta Query com os dados que serão impressos no relatório            ³

oPrint:StartPage()
cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")  

aAdd(_aBmp,"\system\DANFE01" + cEmpAnt+ ".bmp")  

nLin+=100
  // oPrint:SayBitmap(nLin+010, 0160, _aBmp[1], 350, 220)
nLin+=150
//	oPrint:Say(nLin, 2100, "Pagina: " + strzero(nPag,3), oFont8N)
//_BPosicione("SA6",1,xFilial("SA6")+"999"+ZPX->ZPX_CARTAO,"A6_COD")

_Banco    := ""

If Posicione("SA6",1,xFilial("SA6"),"A6_COD") = '999'
	_Banco    := Posicione("SA6",1,xFilial("SA6")+"999"+ZPX->ZPX_CARTAO,"A6_NOME")
elseif Posicione("SA6",1,xFilial("SA6"),"A6_COD") = '748'
	_Banco    := Posicione("SA6",1,xFilial("SA6")+"748"+ZPX->ZPX_CARTAO,"A6_NOME")
elseif Posicione("SA6",1,xFilial("SA6"),"A6_COD") = '888'
	_Banco    := Posicione("SA6",1,xFilial("SA6")+"888"+ZPX->ZPX_CARTAO,"A6_NOME")
EndiF


_Desc     := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
_End      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_END")
_Bair     := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_BAIRRO") 
_Cid      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_MUN") 
_Uf       := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") 

oPrint:Say(nLin, 850,  ("Relatório Técnico - Acerto de Viagens     N.º "+ZPX->ZPX_ACERTO), oFont14NS)

nLin+=150
 
oPrint:Say(nLin, 120,  ("Funcionário/Terceirizado:"), oFont12)
oPrint:Say(nLin, 650,  ZPX->ZPX_CARTAO+"/"+_Banco+ if(!empty(ZPX->ZPX_TEC)," - "+ZPX->ZPX_TEC,""), oFont12N)
nLin+=50
oPrint:Say(nLin, 120,  ("Nome Circuito...........:"), oFont12)
oPrint:Say(nLin, 650,  ZPX->ZPX_CIRCUI, oFont12N)
nLin+=50
oPrint:Say(nLin, 120, ("Empresa de Registro.....:"), oFont12)  
oPrint:Say(nLin, 650,  SM0->M0_NOMECOM, oFont12N)
nLin+=50
oPrint:Say(nLin, 120, ("Período.................:"), oFont12)
oPrint:Say(nLin, 650,   CVALTOCHAR(ZPX->ZPX_DIAINI) + " de "+  CVALTOCHAR(ZPX->ZPX_DIAFIM)+ " - "+ cvaltochar(_Diarias)+" Diárias", oFont12N)
nLin+=100
oPrint:Say(nLin, 120,   ("Cliente"), oFont12N)
oPrint:Say(nLin, 920,   ("Cidade/Estado"), oFont12N)
oPrint:Say(nLin, 1350,  ("Tipo"), oFont12N)
oPrint:Say(nLin, 1750,  ("Observação"), oFont12N)
//nLin+=100

Dados()

nLin+=70
                                                                                                                                                           
dbselectarea("TMP")
DBGOTOP()
While TMP->(!EOF()) 
    _Total := _Total + TMP->Valor
	If !empty(TMP->ZPX_CLIENT) 
		
	   cEst := Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP->ZPX_CLIENT),"A1_EST")	
	   cMun := Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP->ZPX_CLIENT),"A1_MUN")
	   cTransp := TMP->ZPX_TRANSP 
	   cTec    := TMP->ZPX_TEC
	   cPlaca  := TMP->ZPX_PLACA
		
	   oPrint:Say(nLin, 150, TMP->ZPX_DESCLI, oFont10)				
	   oPrint:Say(nLin, 1000, ALLTRIM(cMun)+"/"+cEst, oFont10) 
       oPrint:Say(nLin, 1350, TMP->Tipo, oFont10)
	   //oPrint:Say(nLin, 1750, TMP->ZPX_DESC, oFont12)

	   oPrint:Line(nLin,0990,nLin,0990) // Vertical
  	   oPrint:Line(nLin,1340,nLin,1340) // Vertical
  	   oPrint:Line(nLin,1740,nLin,1740) // Vertical
	   oPrint:Line(nLin,100,nLin,2300) // Horizontal 
  	   nLin+=50 
       //oPrint:Line(nLinV,020,nLinV,2350) // Vertical
	   
    EndiF
    	      
   TMP->( dbSkip() ) 
   If nLin >= 2900 // veja o tamanho adequado da página que este numero pode variar
	  oPrint:EndPage() // Finaliza a página
	  oPrint:StartPage()
	  nLin := 50
   Endif		
Enddo 
TMP->(DbCloseArea())

nLin+=50 
 Dados1()
dbselectarea("TMP1")
DBGOTOP() 
While TMP1->(!EOF())

    IF ALLTRIM(TMP1->Classificacao) = 'COMBÚSTIVEL'
	   _nTotComb := _nTotComb + TMP1->ZPX_VALOR
    EndIf

	IF ALLTRIM(TMP1->Modalidade) = 'CARTAO EMPRESA'
	   _nTotCart := _nTotCart + TMP1->ZPX_VALOR
    EndIf
	IF ALLTRIM(TMP1->Modalidade) = 'FATURADO'
	   _nTotFat := _nTotFat + TMP1->ZPX_VALOR
    EndIf
	IF ALLTRIM(TMP1->Modalidade) = 'ACERTO' .or.  ALLTRIM(TMP1->Modalidade)= 'ACERTO AVULSO'
	   _nTotAcer := _nTotAcer + TMP1->ZPX_VALOR
    EndIf

	IF ALLTRIM(TMP1->Modalidade) = 'SAQUE'
	   _nTotSaq := _nTotSaq + TMP1->ZPX_VALOR
    EndIf
   //ABAST. INICIAL
    IF ALLTRIM(TMP1->Modalidade) = 'ABAST. INICIAL'
	   _nTotAbIn := _nTotAbIn + TMP1->ZPX_VALOR
    EndIf
	IF ALLTRIM(TMP1->Modalidade) = 'ADIANTAMENTO'
	   _nTotAdi := _nTotAdi + TMP1->ZPX_VALOR
    EndIf

	TMP1->( dbSkip() )
Enddo
//TMP1->(DbCloseArea())

Dados4()
dbselectarea("TMP8")
DBGOTOP() 
While TMP8->(!EOF())

	IF ALLTRIM(TMP8->Modalidade) = 'CARTAO EMPRESA'
	   _nTotCart := _nTotCart + TMP8->ZPY_VALOR
    EndIf
	IF ALLTRIM(TMP8->Modalidade) = 'FATURADO'
	   _nTotFat := _nTotFat + TMP8->ZPY_VALOR
    EndIf
	IF ALLTRIM(TMP8->Modalidade) = 'ACERTO' .or.  ALLTRIM(TMP8->Modalidade)= 'ACERTO AVULSO'
	   _nTotAcer := _nTotAcer + TMP8->ZPY_VALOR
    EndIf

	IF ALLTRIM(TMP8->Modalidade) = 'SAQUE'
	   _nTotSaq := _nTotSaq + TMP1->ZPY_VALOR
    EndIf
   //ABAST. INICIAL
    IF ALLTRIM(TMP8->Modalidade) = 'ABAST. INICIAL'
	   _nTotAbIn := _nTotAbIn + TMP1->ZPY_VALOR
    EndIf
	IF ALLTRIM(TMP8->Modalidade) = 'ADIANTAMENTO'
	   _nTotAdi := _nTotAdi + TMP1->ZPY_VALOR
    EndIf

	TMP8->( dbSkip() )
Enddo
TMP8->(DbCloseArea())


//nLin+=50
//oPrint:Line(nLin,100,nLin,2320) // Horizontal 

//nLin+=50 
oPrint:Say(nLin, 250,"Gasto da Viagem:" +Transform(_Total - _nTotSaq -_nTotAbIn-_nTotAdi, "@e 999,999,999.99"), oFont12N) 
oPrint:Say(nLin, 1400,"Transporte: " +cTransp + If(!EMPTY(cPlaca),"Placa: "+cPlaca,"" ), oFont12N) 
nLin+=50 

oPrint:Line(nLin,100,nLin,2300) // Horizontal 
nLin+=50  
	//oPrint:Say(nLin, 2250, Transform(SCK->CK_VALOR, "@e 999,999,999.99"), oFont8,,,,1)      //oFont8,,,,2) // centraliza 
oPrint:Say(nLin, 300,"Credito Acerto de Diárias/Outros:", oFont12N,100,,,1) 
//oPrint:Say(nLin,1300,alltrim(QSC2->C2_PRODUTO), oFont8N,100,,,1)  
oPrint:Say(nLin, 1000, Transform(_nTotAcer, "@e 999,999,999.99"), oFont12,,,,1)  //_nTotComb
oPrint:Say(nLin, 1400,"Total Valor Combústivel: ", oFont10N) 
oPrint:Say(nLin, 1750, Transform(_nTotComb, "@e 999,999,999.99"), oFont10N,,,,1)  //_nTotComb

nLin+=70 
oPrint:Say(nLin, 300,"Cartão Empresa:", oFont12N,100,,,1) 
oPrint:Say(nLin, 1000, Transform(_nTotCart, "@e 999,999,999.99"), oFont12,,,,1) 
nLin+=70 
oPrint:Say(nLin, 300,"Gastos Faturados:", oFont12N,100,,,1) 
oPrint:Say(nLin, 1000, Transform(_nTotFat, "@e 999,999,999.99"), oFont12,,,,1)
//_nReemb := (_nTotCart+_nTotSaq+_nTotAcer) - _Total
_nReemb := (_nTotAcer-_nTotSaq-_nTotAdi)

If _nReemb <= 0
   oPrint:Say(nLin, 1400,"Débito do Funcionário: ", oFont10N)  
   oPrint:Say(nLin, 1750, Transform(_nReemb*-1, "@e 999,999,999.99"), oFont10N,,,,1)  //_nTotComb
Else
   oPrint:Say(nLin, 1400,"Reembolso p/ Funcionário: ", oFont10N) 
   oPrint:Say(nLin, 1750, Transform(_nReemb, "@e 999,999,999.99"), oFont10N,,,,1)  //_nTotComb
EndIf 
nLin+=120
oPrint:Say(nLin, 150,_cResp, oFont10N) 
oPrint:Line(nLin -30,100,nLin - 30,450) // Horizontal 

oPrint:Say(nLin, 930,"Gerência", oFont10N) 
oPrint:Line(nLin - 30,850,nLin - 30,1200) // Horizontal 

oPrint:Say(nLin, 1600,cTec, oFont10N) 
oPrint:Line(nLin - 30,1550,nLin - 30,1900) // Horizontal 

nLin+=100
//oPrint:Line(nLin,100,nLin,2320) // Horizontal
//nLin+=010 
//oPrint:Line(nLin,100,nLin,2320) // Horizontal 

oBrush1 := TBrush():New( , CLR_BLACK ) 
oPrint:FillRect( {nLin, 100, nLin+10, 2300}, oBrush1 ) 
oBrush1:End()

If nLin >= 3000 // veja o tamanho adequado da página que este numero pode variar
	  oPrint:EndPage() // Finaliza a página
	  oPrint:StartPage()
	  nLin := 50
Endif	

nLin+=150
 TMP1->(DbCloseArea())
 Dados2()

While TMP5->(!EOF())  

      oPrint:Say(nLin, 100,"A B A S T E C I M E N T O", oFont14N,1400,CLR_HRED) 
      oPrint:Say(nLin, 650,"Km Inicial:" +Transform(TMP5->ZPY_KMINI, "@e 999,999,999.999"), oFont10N) 
      oPrint:Say(nLin, 1000,"Km Final:" +Transform(TMP5->ZPY_KMFIM, "@e 999,999,999.999"), oFont10N) 
	  oPrint:Say(nLin, 1300,"Placa:" +TMP5->ZPX_PLACA , oFont10N) 
	  oPrint:Say(nLin, 1600,"Retirada:" + CVALTOCHAR(STOD(TMP5->ZPY_DTRET)), oFont10)	
	  oPrint:Say(nLin, 1850,"Devolução:" +CVALTOCHAR(STOD(TMP5->ZPY_DTDEV)), oFont10)	
      nLin+=100 

      oPrint:Say(nLin, 100,   ("Data"), oFont12N)
      oPrint:Say(nLin, 300,   ("Odômetro"), oFont12N)
      oPrint:Say(nLin, 550,   ("Litros"), oFont12N)
      oPrint:Say(nLin, 800,  ("Km Rodado"), oFont12N)
      oPrint:Say(nLin, 1100,  ("Km/L"), oFont12N)
      oPrint:Say(nLin, 1350,  ("Valor"), oFont12N)
	  oPrint:Say(nLin, 1600,  ("Modalidade"), oFont12N)
	  oPrint:Say(nLin, 1950,  ("Posto"), oFont12N)
      nLin+=070
      //dbselectarea("TMP5")
      //DBGOTOP()
      _nKmInic:= TMP5->ZPY_KMINI
      cPlaca :=  TMP5->ZPX_PLACA
	  _kmRod  := 0
	  _Litros := 0
	  _TotVal := 0


      While TMP5->(!EOF()) .AND. cPlaca = TMP5->ZPY_PLACA 

            cEst := Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP5->ZPX_CLIENT),"A1_EST")	
	        cMun := Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP5->ZPX_CLIENT),"A1_MUN")

		    //oPrint:Say(nLin, 2250, Transform(SCK->CK_VALOR, "@e 999,999,999.99"), oFont8,,,,1)      //oFont8,,,,2) // centraliza 

			oPrint:Say(nLin, 100, CVALTOCHAR(STOD(TMP5->ZPY_DATA)), oFont10)	
    		oPrint:Say(nLin, 300, Transform(TMP5->ZPY_ODOME, "@e 999,999,999.999"), oFont10,,,,1) 
    		oPrint:Say(nLin, 550, Transform(TMP5->ZPY_LITRO, "@e 999,999,999.999"), oFont10,,,,1) //LITROS MARLON DISSE QUE É DIGITADO O LITRO
    		oPrint:Say(nLin, 800, Transform(TMP5->ZPY_ODOME-_nKmInic, "@e 999,999,999.999"), oFont10,,,,1) //KM RODADO  OK  CALULO PRIMEIRO
    		oPrint:Say(nLin, 1100, Transform(((TMP5->ZPY_ODOME-_nKmInic)/TMP5->ZPY_LITRO), "@e 999,999,999.999"), oFont10,,,,1)   //KM POR LITRO 
			oPrint:Say(nLin, 1350, Transform(TMP5->ZPY_VALOR, "@e 999,999,999.99"), oFont10,,,,1)  

            If TMP5->ZPY_MODAL == "1"
			   _DescMod := "ACERTO"
			ElseIf TMP5->ZPY_MODAL == "2"
			   _DescMod := "FATURADO"
			ElseIf TMP5->ZPY_MODAL == "3" 
			   _DescMod := "CARTAO EMPRESA"
			ElseIf TMP5->ZPY_MODAL == "4" 
			   _DescMod := "SAQUE"
			ElseIf TMP5->ZPY_MODAL == "5"
			   _DescMod := "ADIANTAMENTO" 
			ElseIf TMP5->ZPY_MODAL == "6"
			   _DescMod := "ABAST. INICIAL" 
			ElseIf TMP5->ZPY_MODAL == "7" 
			   _DescMod := "ACERTO AVULSO"
			EndIf

			oPrint:Say(nLin, 1600, _DescMod, oFont10)	
			oPrint:Say(nLin, 1950, TMP5->ZPY_DESC, oFont10)	

			IF ALLTRIM(TMP5->ZPX_MODAL) <> "6"
	   			_Litros := _litros + TMP5->ZPY_LITRO
    		EndIf
     
            _TotVal:= _TotVal+TMP5->ZPY_VALOR  //Valor de Abastecimento por Placa

			_kmRod := _kmRod + TMP5->ZPY_ODOME-_nKmInic
     
  			nLin+=70 
    		_nKmInic := TMP5->ZPY_ODOME
    		TMP5->( dbSkip() )
	        If nLin >= 2900 // veja o tamanho adequado da página que este numero pode variar
	           oPrint:EndPage() // Finaliza a página
	           oPrint:StartPage()
	           nLin := 200
            Endif	
      Enddo
      nLin+=070

    oPrint:Say(nLin, 700,"Km Rodado:", oFont12N,,,,1) 
    oPrint:Say(nLin, 1000, Transform(_kmRod, "@e 999,999,999.999"), oFont12,,,,1)  
    nLin+=40
    oPrint:Say(nLin, 700,"Qtd Litro Total:", oFont12N,,,,1)
    oPrint:Say(nLin, 1000, Transform(_Litros, "@e 999,999,999.999"), oFont12,,,,1)  
    nLin+=40
    oPrint:Say(nLin, 700,"Consumo Médio:", oFont12N,,,,1) 
    oPrint:Say(nLin, 1000, Transform(_kmRod/_Litros,"@e 999,999,999.999"), oFont12,,,,1)
	nLin+=40
    oPrint:Say(nLin, 700,"Valor:", oFont12N,,,,1) 
    oPrint:Say(nLin, 1000, Transform(_TotVal,"@e 999,999,999.99"), oFont12,,,,1)

    nLin+=70

   If nLin >= 3000 // veja o tamanho adequado da página que este numero pode variar
      oPrint:EndPage() // Finaliza a página
      oPrint:StartPage()
      nLin := 300
   Endif	
Enddo
TMP5->(DbCloseArea())
oBrush1 := TBrush():New( , CLR_BLACK ) 
oPrint:FillRect( {nLin, 100, nLin+10, 2300}, oBrush1 ) 
oBrush1:End()

nLin+=70

//If nLin >= 3000 // veja o tamanho adequado da página que este numero pode variar
   oPrint:EndPage() // Finaliza a página
   oPrint:StartPage()
   nLin := 300
//Endif	
Dados3()
//aAdd(_aBmp,"\system\DANFE01" + cEmpAnt+ ".bmp") 
oPrint:Say(nLin, 900,"D E S P E S A S",oFont16N,1400,CLR_HRED)  
nLin+=100
oPrint:Say(nLin, 100,   ("Data"), oFont10N)
oPrint:Say(nLin, 300,   ("Classificação"), oFont10N)
//oPrint:Say(nLin, 500,   ("Litros"), oFont10N)
oPrint:Say(nLin, 600,   ("Descrição"), oFont10N)
oPrint:Say(nLin, 1300,  ("Modalidade"), oFont10N)
oPrint:Say(nLin, 1700,  ("Valor"), oFont10N)
oPrint:Say(nLin, 1900,  ("Aplicação"), oFont10N)
nLin+=70
dbselectarea("TMP7")
DBGOTOP()
DO WHILE !TMP7->(EOF())
	
	oPrint:Say(nLin, 100, CVALTOCHAR(STOD(TMP7->ZPX_DATA)), oFont10)	
	oPrint:Say(nLin, 300, TMP7->Classificacao, oFont10)	
	//oPrint:Say(nLin, 500, Transform(TMP7->ZPX_LITRO, "@e 999,999,999.999"), oFont10,,,,1)
	oPrint:Say(nLin, 600, TMP7->ZPX_DESC, oFont10)	
	oPrint:Say(nLin, 1300, TMP7->Modalidade, oFont10)	
	oPrint:Say(nLin, 1700, Transform(TMP7->ZPX_VALOR, "@e 999,999,999.99"), oFont10,,,,1)
	oPrint:Say(nLin, 1900, TMP7->ZPX_APLIC, oFont10)	
    //
	oPrint:Line(nLin,100,nLin,2300) // Horizontal
	_nTot:= _nTot + TMP7->ZPX_VALOR
    nLin+=50
	IF ALLTRIM(TMP7->Modalidade)= 'CARTAO EMPRESA'
	   _nTotCart := _nTotCart + TMP7->ZPX_VALOR
    EndIf
	IF ALLTRIM(TMP7->Modalidade)= 'FATURADO'
	   _nTotFat := _nTotFat + TMP7->ZPX_VALOR
    EndIf
	IF ALLTRIM(TMP7->Modalidade)= 'ACERTO'   .or.  ALLTRIM(TMP7->Modalidade)= 'ACERTO AVULSO'
	   _nTotAcer := _nTotAcer + TMP7->ZPX_VALOR
    EndIf
    //Segundo Marlon e Alda o valor do Saque não entra no Valor final do acerto (comentado a variavel que soma o saque) - 25/02/2021 - Inicio
	IF ALLTRIM(TMP7->Modalidade) = 'SAQUE'
	   _nTotSaq := _nTotSaq + TMP7->ZPX_VALOR
    EndIf
	IF ALLTRIM(TMP7->Modalidade) = 'ABAST. INICIAL' 
	   _nTotAbIn := _nTotAbIn + TMP7->ZPX_VALOR
    EndIf
	//Segundo Marlon e Alda o valor do Saque não entra no Valor final do acerto (comentado a variavel que soma o saque) - 25/02/2021 - Fim
	TMP7->( dbSkip() )

	If nLin >= 2900 // veja o tamanho adequado da página que este numero pode variar
	  oPrint:EndPage() // Finaliza a página
	  oPrint:StartPage()
	  nLin := 200
   Endif	
ENDDO

/*
oPrint:Say(nLin, 700,"Km Rodado:", oFont10N,,,,1) 
oPrint:Say(nLin, 1000, Transform(_kmRod, "@e 999,999,999.99"), oFont10,,,,1)  


nLin+=100
oPrint:Say(nLin, 700,"Km Rodado:" +Transform(_nTot, "@e 999,999,999.99"), oFont8N)  
nLin+=50
oPrint:Say(nLin, 700,"Qtd Litro Total:" +Transform(_nTotCart, "@e 999,999,999.99"), oFont8N) 
nLin+=50
oPrint:Say(nLin, 700,"Consumo Médio:" +Transform(_nTotFat, "@e 999,999,999.99"), oFont8N) 
nLin+=50
oPrint:Say(nLin, 700,"Consumo Médio:" +Transform(_nTotSaq, "@e 999,999,999.99"), oFont8N) 
nLin+=50
oPrint:Say(nLin, 700,"Consumo Médio:" +Transform(_nTotAcer, "@e 999,999,999.99"), oFont8N) 
nLin+=50
_nReemb := (_nTotCart+_nTotSaq+_nTotAcer) - _nTot

If _nReemb < 0
   _nReemb := 0 
   oPrint:Say(nLin, 100,"Reembolso P/ Funcionário:" +Transform(_nReemb, "@e 999,999,999.99"), oFont8N)     
Else
   oPrint:Say(nLin, 100,"Reembolso P/ Funcionário:" +Transform(_nReemb, "@e 999,999,999.99"), oFont8N) 
EndIf
*/
oPrint:endPage()
MS_FLUSH()
oPrint:Preview() 
//U_BRG024()

Return()

/*
///Fechando aki para fazer o teste.

nLin+=100

TMP1->(DbCloseArea())

//query para pegar os lançamentos de conbustivel - inicio

  

//query para pegar os lançamentos de conbustivel - Fim


If nLin >= 3000 // veja o tamanho adequado da página que este numero pode variar
	oPrint:EndPage() // Finaliza a página
	oPrint:StartPage()
	nLin := 200
Endif


oPrint:EndPage()
oPrint:StartPage()
	//MS_FLUSH()

///COMEÇAR AKI A PLANILHA DE DESPESAS

aAdd(_aBmp,"\system\DANFE01" + cEmpAnt+ ".bmp")  

nLin+=100
   oPrint:SayBitmap(nLin+010, 0160, _aBmp[1], 350, 220)
nLin+=150



oPrint:endPage()
	MS_FLUSH()
oPrint:Preview() 
//U_BRG024()

Return()
*/

//Retorna os dados do Acerto AGrupando por Cliente
// 19/11/2020

Static Function Dados()
//Verifica se o arquivo TMP está em uso
If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQry := " "
cQry += "SELECT ZPX_FILIAL, ZPX_CARTAO, ZPX_CLIENT,ZPX_DESCLI,ZPX_TRANSP, ZPX_TIPO,ZPX_TEC, ZPX_PLACA, "
cQry += "CASE "
cQry += "WHEN ZPX_TIPO = '1' THEN 'CORRETIVA' "
cQry += "WHEN ZPX_TIPO = '2' THEN 'PREVENTIVA' "
cQry += "WHEN ZPX_TIPO = '3' THEN 'CORRENTIVA E PREVENTIVA' "  //"1=Corretiva;2=Preventiva;3=Corretiva e Preventiva;4=Logistica;5=Comercial;6=Emergencial;7=Instalação;8=Operação;9=Startup"
cQry += "WHEN ZPX_TIPO = '4' THEN 'LOGISTICA' "
cQry += "WHEN ZPX_TIPO = '5' THEN 'COMERCIAL' "
cQry += "WHEN ZPX_TIPO = '6' THEN 'EMERGENCIAL' "
cQry += "WHEN ZPX_TIPO = '7' THEN 'INSTALAÇÃO' "
cQry += "WHEN ZPX_TIPO = '8' THEN 'OPERAÇÃO' "
cQry += "WHEN ZPX_TIPO = '9' THEN 'STARTUP' "
cQry += "END AS Tipo, ZPX_VALOR Valor "
cQry += "FROM " + retsqlname("ZPX")+" ZPX " 
cQry += "WHERE ZPX.D_E_L_E_T_ <> '*' "
cQry += "AND ZPX_ACERTO = '" + ZPX->ZPX_ACERTO + "' "
//cQry += "GROUP BY  ZPX_FILIAL, ZPX_CARTAO, ZPX_CLIENT,ZPX_DESCLI,ZPX_TRANSP,ZPX_TIPO "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
Return Nil

Static Function Dados1()
If Select("TMP1") > 0
	TMP1->(dbCloseArea())
EndIf

_cQry := "SELECT ZPX_FILIAL, ZPX_ACERTO,ZPX_CARTAO,ZPX_DATA,ZPX_ITEM,ZPX_DESC,ZPX_VALOR,ZPX_APLIC,ZPX_TRANSP, ZPX_CLAS, "
_cQry += "CASE "
_cQry += "WHEN ZPX_CLAS = '1' THEN 'DIÁRIA MOTORISTA' "
_cQry += "WHEN ZPX_CLAS = '2' THEN 'DIÁRIA TÉCNICO' "
_cQry += "WHEN ZPX_CLAS = '3' THEN 'COMBÚSTIVEL' "
_cQry += "WHEN ZPX_CLAS = '4' THEN 'PEÇAS' "
_cQry += "WHEN ZPX_CLAS = '5' THEN 'PASSAGEM' "  //1=Diária Motorista;2=Diária Técnico;3=Combústivel;4=Peças;5=Passagem;6=Hospedagem;7=Refeição;8=Outros
_cQry += "WHEN ZPX_CLAS = '6' THEN 'HOSPEDAGEM' "
_cQry += "WHEN ZPX_CLAS = '7' THEN 'REFEIÇÃO' "
_cQry += "WHEN ZPX_CLAS = '8' THEN 'OUTROS' "
_cQry += "END AS Classificacao, "
_cQry += "ZPX_MODAL, "
_cQry += "CASE "
_cQry += "WHEN ZPX_MODAL = '1' THEN 'ACERTO' "
_cQry += "WHEN ZPX_MODAL = '2' THEN 'FATURADO' "
_cQry += "WHEN ZPX_MODAL = '3' THEN 'CARTAO EMPRESA' "   //"1=Acerto;2=Faturado;3=Cartao Empresa;4=Saque;5=Adiantamento;6=Abast. Inicial"
_cQry += "WHEN ZPX_MODAL = '4' THEN 'SAQUE' "
_cQry += "WHEN ZPX_MODAL = '5' THEN 'ADIANTAMENTO' "
_cQry += "WHEN ZPX_MODAL = '6' THEN 'ABAST. INICIAL' "
_cQry += "WHEN ZPX_MODAL = '7' THEN 'ACERTO AVULSO' "
_cQry += "END AS Modalidade "
_cQry += "FROM " + retsqlname("ZPX")+" ZPX "
_cQry += "WHERE ZPX.D_E_L_E_T_ <> '*' "   
_cQry += "AND   ZPX_ACERTO = '" + ZPX->ZPX_ACERTO  + "'  "
_cQry += "ORDER BY ZPX_ACERTO,ZPX_CARTAO,ZPX_ITEM,ZPX_DATA "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TMP1",.T.,.T.)   

Return Nil

Static Function Dados2()

If Select("TMP5") > 0
	TMP5->(dbCloseArea())
EndIf

_cQrry := "SELECT ZPX_FILIAL, ZPX_ACERTO,ZPX_CLIENT, ZPX_CARTAO,ZPX_DATA, ZPX_KMINI, ZPX_KMFIM,ZPX_DESC,ZPX_MODAL,ZPY_MODAL,  "
_cQrry += "ZPY_ACERTO, ZPY_PLACA, ZPY_KMINI, ZPY_KMFIM,ZPY_LITRO, ZPY_ODOME,ZPY_DTRET, ZPY_DTDEV,ZPX_PLACA,ZPY_DESC,ZPY_APLIC,ZPY_VALOR, ZPY_DATA  "
_cQrry += "FROM " + retsqlname("ZPX")+" ZPX "
_cQrry += " LEFT JOIN " + retsqlname("ZPY")+" ZPY ON ZPY_FILIAL = ZPX_FILIAL AND ZPY_ACERTO = ZPX_ACERTO AND ZPY_PLACA = ZPX_PLACA  AND ZPY.D_E_L_E_T_ <> '*' "	
_cQrry += "WHERE ZPX.D_E_L_E_T_ <> '*' "
_cQrry += "AND ZPX_CLAS = '3' "   
_cQrry += "AND ZPX_ACERTO = '" + ZPX->ZPX_ACERTO  + "'  "
_cQrry += "ORDER BY ZPY_PLACA, ZPY_ODOME "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQrry)),"TMP5",.T.,.T.) 

Return Nil

Static Function Dados3()

If Select("TMP7") > 0
	TMP7->(dbCloseArea())
EndIf

_cQry := "SELECT ZPX_FILIAL, ZPX_ACERTO,ZPX_CARTAO,ZPX_DATA,ZPX_ITEM,ZPX_DESC,ZPX_VALOR,ZPX_LITRO,ZPX_APLIC,ZPX_TRANSP,ZPX_CLAS ,ZPX_DESC,  "
_cQry += "CASE "
_cQry += "WHEN ZPX_CLAS = '1' THEN 'DIÁRIA MOTORISTA' "
_cQry += "WHEN ZPX_CLAS = '2' THEN 'DIÁRIA TÉCNICO' "
_cQry += "WHEN ZPX_CLAS = '3' THEN 'COMBÚSTIVEL' "
_cQry += "WHEN ZPX_CLAS = '4' THEN 'PEÇAS' "
_cQry += "WHEN ZPX_CLAS = '5' THEN 'PASSAGEM' "  //1=Diária Motorista;2=Diária Técnico;3=Combústivel;4=Peças;5=Passagem;6=Hospedagem;7=Refeição;8=Outros
_cQry += "WHEN ZPX_CLAS = '6' THEN 'HOSPEDAGEM' "
_cQry += "WHEN ZPX_CLAS = '7' THEN 'REFEIÇÃO' "
_cQry += "WHEN ZPX_CLAS = '8' THEN 'OUTROS' "
_cQry += "END AS Classificacao, "
_cQry += " ZPX_MODAL, "
_cQry += "CASE "
_cQry += "WHEN ZPX_MODAL = '1' THEN 'ACERTO' "
_cQry += "WHEN ZPX_MODAL = '2' THEN 'FATURADO' "
_cQry += "WHEN ZPX_MODAL = '3' THEN 'CARTAO EMPRESA' "   //"1=Acerto;2=Faturado;3=Cartao Empresa;4=Saque;5=Adiantamento;6=Abast. Inicial"
_cQry += "WHEN ZPX_MODAL = '4' THEN 'SAQUE' "
_cQry += "WHEN ZPX_MODAL = '5' THEN 'ADIANTAMENTO' "
_cQry += "WHEN ZPX_MODAL = '6' THEN 'ABAST. INICIAL' "
_cQry += "WHEN ZPX_MODAL = '7' THEN 'ACERTO AVULSO' "
_cQry += "END AS Modalidade "
_cQry += "FROM " + retsqlname("ZPX")+" ZPX "
_cQry += "WHERE ZPX.D_E_L_E_T_ <> '*' "   
_cQry += "AND   ZPX_CLAS NOT IN ('3')  "
_cQry += "AND   ZPX_ACERTO = '" + ZPX->ZPX_ACERTO  + "'  "
_cQry += "ORDER BY ZPX_ACERTO,ZPX_DATA,ZPX_CARTAO,ZPX_ITEM "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TMP7",.T.,.T.)      


Return Nil


Static Function Dados4()
If Select("TMP8") > 0
	TMP8->(dbCloseArea())
EndIf

_cQryy := "SELECT ZPY_FILIAL, ZPY_ACERTO,ZPY_MODAL,ZPY_VALOR, "
_cQryy += "CASE "
_cQryy += "WHEN ZPY_MODAL = '1' THEN 'ACERTO' "
_cQryy += "WHEN ZPY_MODAL = '2' THEN 'FATURADO' "
_cQryy += "WHEN ZPY_MODAL = '3' THEN 'CARTAO EMPRESA' "   //"1=Acerto;2=Faturado;3=Cartao Empresa;4=Saque;5=Adiantamento;6=Abast. Inicial"
_cQryy += "WHEN ZPY_MODAL = '4' THEN 'SAQUE' "
_cQryy += "WHEN ZPY_MODAL = '5' THEN 'ADIANTAMENTO' "
_cQryy += "WHEN ZPY_MODAL = '6' THEN 'ABAST. INICIAL' "
_cQryy += "WHEN ZPY_MODAL = '7' THEN 'ACERTO AVULSO' "
_cQryy += "END AS Modalidade "
_cQryy += "FROM " + retsqlname("ZPY")+" ZPY "
_cQryy += "WHERE ZPY.D_E_L_E_T_ <> '*' "   
_cQryy += "AND   ZPY_ACERTO = '" + ZPX->ZPX_ACERTO  + "'  "
_cQryy += "ORDER BY ZPY_ACERTO,ZPY_ITEM "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQryy)),"TMP8",.T.,.T.)   

Return Nil
