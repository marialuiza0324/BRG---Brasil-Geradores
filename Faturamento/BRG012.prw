/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BRG012  ³ Autor ³ Ricardo Moreira³ 		  Data ³ 21/02/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressão de Orçamento 									  ³±±
±±³          ³ 						                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para BRG                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

//Autora - Maria Luiza

//Ajuste para retirar validações de filiais, tornando o fonte genérico para filial corrente - Solicitado pelo Marlon 03/06/2024
//Adição das logos no orçamento de forma genérica para a filial corrente, logos adicionadas no servidor pasta /system/orc/.

#include "rwmake.ch"
#INCLUDE "topconn.ch"

User Function BRG012()


//Local _Nf        := SC5->C5_NOTA 
//Local _Serie     := SC5->C5_SERIE
	Local _Desc,_End,_Bair,_Cid,_Uf,cTes, cNcn :=  " "
	Local _aBmp := {}
	Local _nPagin := 1
	Local _cMvCon := "MV_CONVEND" //Contato do vendedor por parametro
	Local cString := ""
	Local aString := ""
	Local nString := ""

	Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
	Private oFont6N 	:= TFONT():New("ARIAL",7,6,,.T.,,,,.T.,.F.) ///Fonte 6 Negrito
	Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
	Private oFont8N 	:= TFONT():New("ARIAL",8,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
	Private oFont9N 	:= TFONT():New("ARIAL",9,9,,.T.,,,,.T.,.F.) ///Fonte 9 Negrito
	Private oFont10    	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 10 Normal
	Private oFont10S	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.T.) ///Fonte 10 Sublinhando
	Private oFont10N 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.F.) ///Fonte 10 Negrito
	Private oFont12		:= TFONT():New("ARIAL",12,12,,.F.,,,,.T.,.F.) ///Fonte 12 Normal
	Private oFont12NS	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.T.) ///Fonte 12 Negrito e Sublinhado
	Private oFont12N	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito
	Private oFont14		:= TFONT():New("ARIAL",14,14,,.F.,,,,.T.,.F.) ///Fonte 14 Normal
	Private oFont14NS	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.T.) ///Fonte 14 Negrito e Sublinhado
	Private oFont14N	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.F.) ///Fonte 14 Negrito
	Private oFont16  	:= TFONT():New("ARIAL",16,16,,.F.,,,,.T.,.F.) ///Fonte 16 Normal
	Private oFont16N	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
	Private oFont16NS	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.T.) ///Fonte 16 Negrito e Sublinhado
	Private oFont20N	:= TFONT():New("ARIAL",20,20,,.T.,,,,.T.,.F.) ///Fonte 20 Negrito
	Private oFont22N	:= TFONT():New("ARIAL",22,22,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito

//³Variveis para impressão                                              ³

	Private cStartPath
	Private nLin 		:= 50
	Private oPrint		:= NIL

	Private nPag		:= 1
	Private _Emp
	Private cPerg 		:= "BRG012"
	Private nRepita // variavel que controla a quantidade de relatorios impressos
	Private nContador // contador do for principal, que imprime o relatorio n vezes
	Private nZ
	Private nJ
	Private cLogoD
	Private _Nun       := SCJ->CJ_NUM
	Private	_Qtd    := 0
	Private _Tot    := 0
	Private _TotIpi := 0
	Private _TotDif := 0
	Private	_Local  := " "
	Private	_LtCtl  := " "
	Private _Prod   := " "
	Private _NumSeq := " "
	Private _AlqDif := 0
	Private cLogo

//Private _SomSbf := 0
//Private  cStartPath := GETPVPROFSTRING(GETENVSERVER(),"StartPath","ERROR",GETADV97())
//cStartPath += IF(RIGHT(cStartPath,1) <> "\","\","")
//         cLogoD     := cStartPath + "LGRL" + cFilAnt + ".BMP"
//cLogoD     :=  "LGRL" + cEmpAnt+ ".BMP"

//³Define Tamanho do Papel                                                  ³

	#define DMPAPER_A4 9 //Papel A4
//oPrint:setPaperSize( DMPAPER_A4 )

	If oPrint == Nil

		oPrint:=FWMSPrinter():New("Orcamento",6,.T.,,.T.)
		oPrint:SetPortrait()
		oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
		oPrint:cPathPDF :="C:\TEMP\"

	EndIf



	oPrint:SetPortrait()///Define a orientacao da impressao como retrato
//oPrint:SetLandscape() ///Define a orientacao da impressao como paisagem
//³Monta Query com os dados que serão impressos no relatório            ³

	oPrint:StartPage()

	cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
	cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")

	cLogo := cStartPath+ "orc/" + cfilant + ".png"
//aAdd(_aBmp,"\system\DANFE01" + cFilAnt+ ".bmp")  
	/*aAdd(_aBmp,"C:\temp\logoorc.png")
	aAdd(_aBmp,"C:\temp\timborc.png") //RAIO BRG
	aAdd(_aBmp,"C:\temp\zaporc.png") //ICONE DO ZAP
	aAdd(_aBmp,"C:\temp\botgr.png") //cabeçalho Grid
	aAdd(_aBmp,"C:\temp\topgr.png") //Rodapé GRID
	aAdd(_aBmp,"C:\temp\gridmg.png")  //lOGO GRID Minas
	aAdd(_aBmp,"C:\temp\volvo.png")  //lOGO VOLVO*/

	oPrint:SayBitmap(nLin+010, 100, cLogo, 350, 350)

	//R. 261-B, Nº 449 - Setor Leste Universitário, Goiânia - GO, 74610-270
    /*If cFilAnt <> "0501$"  //Quando for a Grid não tem o Raio
       oPrint:SayBitmap(010, 0650, cLogo, 1700, 3190) //FAzendo teste
    EndIF

	If cFilAnt = "0501"	
       oPrint:SayBitmap(nLin+010, 0100, _aBmp[4], 2200, 300) //350     220
	   oPrint:SayBitmap(nLin+010, 2000, _aBmp[7], 250, 250)	 //350     220
	   
	elseif cFilAnt = "0502"  //GRID Mg
	   oPrint:SayBitmap(nLin+010, 0100, _aBmp[6], 350, 350)	 //350     220
	   oPrint:SayBitmap(nLin+010, 2000, _aBmp[7], 250, 250)	 //350     220		   
	else	 
     oPrint:SayBitmap(nLin+010, 0160, _aBmp[1], 350, 350)	 //350     220	 
	EndIF*/		
    
    nLin+=170

	oPrint:Say(nLin,800,ALLTRIM(SM0->M0_NOMECOM),oFont10)

	/*If Cfilant = "0501"      
       oPrint:Say(nLin,800,SM0->M0_NOMECOM,oFont10) //550 grid go
	elseIF Cfilant = "0502" 
	   oPrint:Say(nLin,600,SM0->M0_NOMECOM,oFont10) //550 grid mg
	elseIf Cfilant = "0101" 
	   oPrint:Say(nLin,600,SM0->M0_NOMECOM,oFont10) //550 brg
	endif*/

	nLin+=30

	oPrint:Say(nLin,800,ALLTRIM(SM0->M0_ENDENT)+", "+ALLTRIM(SM0->M0_COMPENT),oFont10)  //ALTEROU DE 550 PARA 650 PARA GRID

	/*If Cfilant = "0501"
	   oPrint:Say(nLin,800,"RUA 261-B, Nº 449 - LESTE UNIVERSITÁRIO",oFont10)  //ALTEROU DE 550 PARA 650 PARA GRID
	elseIF  Cfilant = "0502"
       oPrint:Say(nLin,600,"RUA AV FERNAO DIAS PAIS LEME, QUADRA12 LOTE 06 Nº 261 - ESTANCIA PARAOPEBA",oFont10)  //ALTEROU DE 550 PARA 650 PARA GRID
	elseIF  Cfilant = "0101"
	oPrint:Say(nLin,600,SM0->M0_ENDCOB,oFont10) 
	Endif*/

    //oPrint:Say(nLin,550,SM0->M0_ENDCOB,oFont10) 
    nLin+=30

    oPrint:Say(nLin,800,AllTrim(SM0->M0_BAIRCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB+" - CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont10)

	/*If Cfilant = "0501"
	   oPrint:Say(nLin,800,"GOIÂNIA - GO, CEP - 74610-270 ",oFont10)
	ElseIf Cfilant = "0502"
 	   oPrint:Say(nLin,600,"SAO JOAQUIM DE BICAS - MG, CEP - 32920-000 ",oFont10)
	ElseIf Cfilant = "0101"
 	   oPrint:Say(nLin,600,AllTrim(SM0->M0_BAIRCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB+" - CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont10)
	EndIf*/

	//oPrint:Say(nLin,550,AllTrim(SM0->M0_BAIRCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB+" - CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont10)
	nLin+=30
	oPrint:Say(nLin+70, 1500,  ("O R Ç A M E N T O  N.º: ")+SCJ->CJ_NUM, oFont16N)   //1400 ALTERADO PARA GRID

	 oPrint:Say(nLin,800,"FONE: " + SM0->M0_TEL ,oFont10)
	   nLin+=30
	   oPrint:Say(nLin,800,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   " +"IE:"+ SM0->M0_INSC,oFont10) 
	
	/*IF Cfilant = "0501"
	   oPrint:Say(nLin,800,"FONE: " + SM0->M0_TEL ,oFont10)
	   nLin+=30
	   oPrint:Say(nLin,800,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   " +"IE:"+ SM0->M0_INSC,oFont10) 
	ELSEIF Cfilant = "0502"
       oPrint:Say(nLin,600,"FONE: " + SM0->M0_TEL ,oFont10)
	   nLin+=30
	   oPrint:Say(nLin,600,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   " +"IE:"+ SM0->M0_INSC,oFont10) 
	ELSEIF Cfilant = "0101"
       oPrint:Say(nLin,600,"FONE: " + SM0->M0_TEL ,oFont10)
	   nLin+=30
	   oPrint:Say(nLin,600,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   " +"IE:"+ SM0->M0_INSC,oFont10) 
	endif*/

	//nLin+=50  
	//oPrint:Say(nLin,550,"E-mail: comercial@brggeradores.com.br",oFont10)   
	nLin+=100
	//	oPrint:Say(nLin, 2100, "Pagina: " + strzero(nPag,3), oFont10N)
_Desc     := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME")  
_End      := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_END")
_Bair     := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_BAIRRO") 
_Cid      := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_MUN") 
_Uf       := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_EST")
_Cnpj     := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_CGC")  
_CEP      := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_CEP")
_TEL      := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_TEL")  
_TpCli    := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_TIPO")
 
oPrint:Say(nLin, 080,  ("Emissão:"), oFont12)
oPrint:Say(nLin, 1600,  ("Telefone:"), oFont12)
oPrint:Say(nLin, 300,  CVALTOCHAR(SCJ->CJ_EMISSAO), oFont12N)
oPrint:Say(nLin, 1800, TRANSFORM(_TEL,"@R (99)9999-9999"), oFont12N)
nLin+=50	
oPrint:Say(nLin, 080, ("Cliente:"), oFont12)
oPrint:Say(nLin, 300,  SCJ->CJ_CLIENTE+"/"+SCJ->CJ_LOJA +"-"+_Desc, oFont12N)    
oPrint:Say(nLin, 1600, ("CNPJ:"), oFont12)
oPrint:Say(nLin, 1800, TRANSFORM(_Cnpj,"@R 99.999.999/9999-99"),oFont12N) // CGC

nLin+=50 
oPrint:Say(nLin, 080,  ("Endereço:"), oFont12)
oPrint:Say(nLin, 300,  _End, oFont12N)
oPrint:Say(nLin, 1600,  ("Cidade:"), oFont12)
oPrint:Say(nLin, 1800,  alltrim(_Cid)+"/"+_Uf, oFont12N) 
 
nLin+=50 
oPrint:Say(nLin, 080,  ("Cond. Pgto:"), oFont12)
_Cond := Posicione("SE4",1,xFilial("SE4")+SCJ->CJ_CONDPAG,"E4_DESCRI")
oPrint:Say(nLin, 300,  SCJ->CJ_CONDPAG+" - "+_Cond, oFont12N)
oPrint:Say(nLin, 1600,  ("Cep:"), oFont12)
oPrint:Say(nLin, 1800,  TRANSFORM(_CEP,"@R 99999-999"), oFont12N)    

nLin+=50
oPrint:Say(nLin, 080,  ("Tipo Frete:"), oFont12)
oPrint:Say(nLin, 300, IIF(SCJ->CJ_TIPOFRT = "F","FOB","CIF"), oFont12N) 
oPrint:Say(nLin, 1600,  ("Validade:"), oFont12)
oPrint:Say(nLin, 1800,  CVALTOCHAR(SCJ->CJ_VALIDA), oFont12N)

nLin+=50  
_Vend := Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_VEND,"A3_NOME")
oPrint:Say(nLin, 080,  ("Vendedor:"), oFont12)
oPrint:Say(nLin, 300,  SCJ->CJ_VEND +"-"+_Vend, oFont12N) 
oPrint:Say(nLin, 1600,  ("Moeda:"), oFont12)

oPrint:Say(nLin, 1800,  IF(SCJ->CJ_MOEDA = 1 ,"R$ (Real)", "US$ (Dólar)"), oFont12N)

nLin+=50  
oPrint:Say(nLin, 080,  ("Observação:"), oFont12)
oPrint:Say(nLin, 300,  SCJ->CJ_OBS, oFont12N)

nLin+=120
//oPrint:Say(nLin, 900, ("I T E N S  D O  O R Ç A M E N T O"), oFont14NS)

nLin+=50
oPrint:Say(nLin, 080,  ("Item"), oFont9N)
oPrint:Say(nLin, 140,  ("Produto"), oFont9N)
oPrint:Say(nLin, 350,  ("Descrição"), oFont9N)
oPrint:Say(nLin, 900,  ("NCM"), oFont9N)
oPrint:Say(nLin, 1050, ("UN"), oFont9N)
oPrint:Say(nLin, 1150, ("CF"), oFont9N)
oPrint:Say(nLin, 1250, ("Qtde"), oFont9N)
oPrint:Say(nLin, 1460, ("Valor Unit."), oFont9N) 
oPrint:Say(nLin, 1700, ("Ipi (%)"), oFont9N)
oPrint:Say(nLin, 1820, ("Icms (%)"), oFont9N)
oPrint:Say(nLin, 1940, ("Iss (%)"), oFont9N)
oPrint:Say(nLin, 2075, ("Total"), oFont9N) 

nLin+=20
oPrint:Line(nLin,080,nLin,2320)	
nLin+=30

//nLin+=50
dbSelectArea("SCK")
dbsetorder(1)    
dbSeek(xFilial("SCK")+_Nun)
                                                                                                                                                               

While SCK->(!EOF()) .AND. xFilial("SCK") = SCK->CK_FILIAL .AND. SCK->CK_NUM = _Nun 		
	
	cTes := Posicione("SF4",1,xFilial("SF4")+SCK->CK_TES,"F4_CF")
	cNcn := Posicione("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_POSIPI")		
	
	oPrint:Say(nLin, 080, SCK->CK_ITEM, oFont10)

	If len(ALLTRIM(SCK->CK_PRODUTO))	> 12		
	   oPrint:Say(nLin, 140, SCK->CK_PRODUTO, oFont10) 
	Else
	   oPrint:Say(nLin, 140, SCK->CK_PRODUTO, oFont10) 
	EndIF     //Lin+025

	oPrint:Say(nLin, 350, SCK->CK_DESCRI, oFont10)
	oPrint:Say(nLin, 0900, cNcn, oFont10)
	oPrint:Say(nLin, 1050, SCK->CK_UM, oFont10)
	oPrint:Say(nLin, 1150, cTes, oFont10) 
	oPrint:Say(nLin, 1200, Transform(SCK->CK_QTDVEN, "@e 999,999,999.999"), oFont10,,,,1)  
	oPrint:Say(nLin, 1420, Transform(SCK->CK_PRCVEN, "@e 999,999,999.99"), oFont10,,,,1) 
	oPrint:Say(nLin, 1700, Transform(SCK->CK_IPI, "@e 99.99"), oFont10) 
	oPrint:Say(nLin, 1820, Transform(SCK->CK_ICMS, "@e 99.99"), oFont10) 
	oPrint:Say(nLin, 1940, Transform(SCK->CK_ISS, "@e 99.99"), oFont10) 	
	oPrint:Say(nLin, 2030, Transform(SCK->CK_VALOR, "@e 999,999,999.99"), oFont10,,,,1)      //oFont10,,,,2) // centraliza 
    //oPrint:Say(nLin, 2200, Transform(SCK->CK_VALOR+(SCK->CK_VALOR*((SCK->CK_IPI/100)))+(SCK->CK_VALOR*((SCK->CK_ICMS/100)))+(SCK->CK_VALOR*((SCK->CK_ISS/100))), "@e 999,999,999.999"), oFont10) 	
	nLin+=20
  	oPrint:Line(nLin-50,130,nLin,130) 		// Vertical
  	oPrint:Line(nLin-50,340,nLin,340) 		// Vertical
  	oPrint:Line(nLin-50,890,nLin,890) 		// Vertical
  	oPrint:Line(nLin-50,1040,nLin,1040) 	// Vertical
  	oPrint:Line(nLin-50,1140,nLin,1140) 	// Vertical
  	oPrint:Line(nLin-50,1240,nLin,1240) 	// Vertical
  	oPrint:Line(nLin-50,1440,nLin,1440) 	// Vertical
  	oPrint:Line(nLin-50,1690,nLin,1690) 	// Vertical
  	oPrint:Line(nLin-50,1810,nLin,1810) 	// Vertical
  	oPrint:Line(nLin-50,1920,nLin,1920) 	// Vertical 
  	oPrint:Line(nLin-50,2050,nLin,2050) 	// Vertical

  	oPrint:Line(nLin,080,nLin,2320) // Horizontal
  	nLin+=30
    //oPrint:Line(nLinV,020,nLinV,2350) // Vertical
	
	  
	If Cfilant = "0502"  
  	
  	   If _TpCli = "F"  	
  	      Do case
	         case _Uf $ "AL/AM/AP/BA/CE/DF/MA/PB/PR/PE/PI/RN/RS/SP/SE/TO" // 18 % Filial MG - não fica na Lista
			    _AlqDif := 18 - 12
		     case _Uf  = "AC/ES/GO/MT/MS/PA/RR/SC" // 17 %
				_AlqDif := 17 - 12	  
		     case _Uf  = "RJ" // 20 %
			    _AlqDif := 20 - 12
		     case _Uf  = "RO" //17,5 %
				_AlqDif := 17.5 - 12		   		
   		   EndCase   		      
     	  //_VlDif  := (SCK->CK_VALOR*((_AlqDif/100)))
     	  _TotDif := _TotDif + (SCK->CK_VALOR*((_AlqDif/100)))
  	   EndIF
	Else

	   If _TpCli = "F"  	
  	      Do case
	         case _Uf $ "AL/AM/AP/BA/CE/DF/MA/MG/PB/PR/PE/PI/RN/RS/SP/SE/TO" // 18 %  
			    _AlqDif := 18 - 12
		     case _Uf  = "AC/ES/MT/MS/PA/RR/SC" // 17 % Filial GO - Não fica na Lista
				_AlqDif := 17 - 12	  
		     case _Uf  = "RJ" // 20 %
			    _AlqDif := 20 - 12
		     case _Uf  = "RO" //17,5 %
				_AlqDif := 17.5 - 12		   		
   		   EndCase   		      
     	  //_VlDif  := (SCK->CK_VALOR*((_AlqDif/100)))
     	  _TotDif := _TotDif + (SCK->CK_VALOR*((_AlqDif/100)))
  	   EndIF


	Endif


  	
  	_Icms := (SCK->CK_VALOR*((SCK->CK_ICMS/100)))
  	_Iss  := (SCK->CK_VALOR*((SCK->CK_ISS/100)))
  	_Ipi  := (SCK->CK_VALOR*((SCK->CK_IPI/100)))  	   	
   	_Qtd  := _Qtd + SCK->CK_QTDVEN   
   	_Tot  := _Tot + SCK->CK_VALOR //(SCK->CK_VALOR+(SCK->CK_VALOR*((SCK->CK_IPI/100)))+(SCK->CK_VALOR*((SCK->CK_ICMS/100)))+(SCK->CK_VALOR*((SCK->CK_ISS/100))))  
   	_TotIpi  := _TotIpi + (SCK->CK_VALOR*((SCK->CK_IPI/100)))
   		
 SCK->( dbSkip() )    
     
 	If nLin >= 3000 // veja o tamanho adequado da página que este numero pode variar  //3000
       //	oPrint:Say(nLin+80, 2100, ("Nº Paginas: ")+cvaltochar(_nPagin)+"/"+ALLTRIM(RetPag()), oFont10)
        //oPrint:SayBitmap(010, 0650, _aBmp[2], 1700, 3190)      //teste ricardo 

       oPrint:SayBitmap(3200, 0100, cLogo, 2200, 300)	 //350     220

		/*If cFilAnt = "0501"
	       oPrint:SayBitmap(3200, 0100, _aBmp[5], 2200, 300)	 //350     220
           //oPrint:SayBitmap(010, 0650, _aBmp[5], 350, 1000)   //rodape Grid
        EndIF*/
    	oPrint:Say(3200, 2100, ("Nº Paginas: ")+cvaltochar(_nPagin)+"/"+ALLTRIM(RetPag()), oFont10)  
 	    _nPagin := _nPagin + 1
		oPrint:EndPage() // Finaliza a página
		oPrint:StartPage()

		oPrint:SayBitmap(nLin+010, 100, cLogo, 350, 350)

		/*If cFilAnt <> "0501"
	       oPrint:SayBitmap(010, 0650,_aBmp[1], 1700, 3190)      //teste ricardo
		EndIF*/
		nLin := 50 //nLin := 200
		
		//CABEÇALHO

		oPrint:SayBitmap(nLin+010, 0100, cLogo, 350, 350)	 //350     220

		/*If cFilAnt = "0501"	
	       oPrint:SayBitmap(nLin+010, 0100, _aBmp[4], 2200, 300)	 //350     220
	    elseif cFilAnt = "0502"  //GRID Mg
	      oPrint:SayBitmap(nLin+010, 0100, cLogo, 350, 350)	 //350     220
	      oPrint:SayBitmap(nLin+010, 1600, _aBmp[7], 250, 250)	 //350     220	   
	    else
           oPrint:SayBitmap(nLin+010, 0160, _aBmp[1], 350, 350)	 //350     220
	    EndIF*/

        nLin+=100      
        oPrint:Say(nLin,650,SM0->M0_NOMECOM,oFont10)
	    nLin+=50       
        oPrint:Say(nLin,650,SM0->M0_ENDCOB,oFont10) 
        nLin+=50
		oPrint:Say(nLin,1400,  ("O R Ç A M E N T O  N.º: ")+SCJ->CJ_NUM, oFont16N)
      	oPrint:Say(nLin,650,AllTrim(SM0->M0_BAIRCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB,oFont10)
     	nLin+=50
     	oPrint:Say(nLin,650,"FONE: " + SM0->M0_TEL +" - CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999") ,oFont10)
    	nLin+=50
     	oPrint:Say(nLin,650,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   " +"IE:"+ SM0->M0_INSC,oFont10)
		nLin+=100
		//CABEÇALHO
	
		oPrint:Say(nLin, 080,  ("Item"), oFont9N)
		oPrint:Say(nLin, 140,  ("Produto"), oFont9N)
		oPrint:Say(nLin, 350,  ("Descrição"), oFont9N)
		oPrint:Say(nLin, 900,  ("NCM"), oFont9N)
		oPrint:Say(nLin, 1050, ("UN"), oFont9N)
		oPrint:Say(nLin, 1150, ("CF"), oFont9N)
		oPrint:Say(nLin, 1250, ("Qtde"), oFont9N)
		oPrint:Say(nLin, 1460, ("Valor Unit."), oFont9N) 
		oPrint:Say(nLin, 1700, ("Ipi (%)"), oFont9N)
		oPrint:Say(nLin, 1820, ("Icms (%)"), oFont9N)
		oPrint:Say(nLin, 1940, ("Iss (%)"), oFont9N)
		oPrint:Say(nLin, 2075, ("Total"), oFont9N) 	
		nLin+=50	
		oPrint:Line(nLin,100,nLin,2320)	
	Endif 
	
Enddo
nLin+=50 

If nLin >= 2850

    oPrint:SayBitmap(3200, 0100, cLogo, 2200, 300)	 //350     220

    /*If cFilAnt = "0501"
	oPrint:SayBitmap(3200, 0100, _aBmp[5], 2200, 300)	 //350     220
      //oPrint:SayBitmap(010, 0650, _aBmp[5], 350, 1000)   //rodape Grid
    EndIF*/

   	oPrint:Say(3200, 2100, ("Nº Paginas: ")+cvaltochar(_nPagin)+"/"+ALLTRIM(RetPag()), oFont10)
	oPrint:EndPage() // Finaliza a página
	oPrint:StartPage()
	nLin := 50 //nLin := 200
	//oPrint:SayBitmap(010, 0650, _aBmp[2], 1700, 3190)	
		//CABEÇALHO

		
	   oPrint:SayBitmap(nLin+010, 1600, cLogo, 250, 250)	 //350     220	


	/*If cFilAnt = "0501"	
	   oPrint:SayBitmap(nLin+010, 0100, _aBmp[4], 2200, 300)	 //350     220
	elseif cFilAnt = "0502"  //GRID Mg
	   oPrint:SayBitmap(nLin+010, 0100, _aBmp[6], 350, 350)	 //350     220
	   oPrint:SayBitmap(nLin+010, 1600, _aBmp[7], 250, 250)	 //350     220		   
	else
       oPrint:SayBitmap(nLin+010, 0160, _aBmp[1], 350, 350)	 //350     220
	EndIF*/

    nLin+=100      
    oPrint:Say(nLin,550,SM0->M0_NOMECOM,oFont10)
    nLin+=50 
  	oPrint:Say(nLin, 1400,  ("O R Ç A M E N T O  N.º: ")+SCJ->CJ_NUM, oFont16N)
    oPrint:Say(nLin,550,SM0->M0_ENDCOB,oFont10) 
    nLin+=50
  	oPrint:Say(nLin,550,AllTrim(SM0->M0_BAIRCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB+" - CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont10)
   	nLin+=50
   	oPrint:Say(nLin,550,"FONE: " + SM0->M0_TEL ,oFont10)
   	nLin+=50
  	oPrint:Say(nLin,550,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   " +"IE:"+ SM0->M0_INSC,oFont10)
	nLin+=100
	//CABEÇALHO

EndIf
//oPrint:SayBitmap(010, 0650, _aBmp[2], 1700, 3190)         //ricardo moreira de lima
oPrint:Say(nLin, 080,   ("T O T A I S"), oFont10N) 
nLin+=50
oPrint:Line(nLin,080,nLin,2320)                      
nLin+=50
oPrint:Say(nLin, 1200, Transform(_Qtd, "@e 999,999,999.999"), oFont10) 
oPrint:Say(nLin, 1700, "Total S/ Impostos" +Transform(_Tot, "@e 999,999,999.99"), oFont10)
nLin+=50
oPrint:Say(nLin, 1700, "Total C/ Impostos" +Transform(_Tot+_TotIpi+_TotDif, "@e 999,999,999.99"), oFont10)
nLin+=50
oPrint:Say(nLin, 080,   ("I M P O S T O S"), oFont10N) 
nLin+=50
oPrint:Line(nLin,080,nLin,2320)                      
nLin+=100    
oPrint:Say(nLin, 0080, ("Valor IPI"), oFont10) 
oPrint:Say(nLin, 0400, ("Valor ICMS"), oFont10)
oPrint:Say(nLin, 0700, ("Valor ISS"), oFont10)
oPrint:Say(nLin, 1000, ("Valor Total"), oFont10)
oPrint:Say(nLin, 1300, ("Valor Difal"), oFont10)

nLin+=50  
oPrint:Say(nLin, 0150, Transform(_TotIpi, "@e 999,999,999.99"), oFont10) 
oPrint:Say(nLin, 0450, Transform(_Icms, "@e 999,999,999.99"), oFont10) 
oPrint:Say(nLin, 0750, Transform(_Iss, "@e 999,999,999.99"), oFont10) 
oPrint:Say(nLin, 1050, Transform((_Tot+_TotIpi), "@e 999,999,999.99"), oFont10)
oPrint:Say(nLin, 1350, Transform(_TotDif, "@e 999,999,999.99"), oFont10)   //Difal
nLin+=100
oPrint:Say(nLin, 0150, ("Sujeito a Disponibilidade"), oFont10)
nLin+=15
/*If cFilAnt <> "0502" //Alterado 08/06/2021 Solicitado por Marlon
   oPrint:SayBitmap(nLin, 0400, _aBmp[3], 050, 050)
   oPrint:Say(nLin, 0150, ("(062) 99698-9715 "), oFont8) 
   oPrint:SayBitmap(nLin, 0400, _aBmp[3], 050, 050)
   oPrint:Say(nLin, 0150, ("(062) 3771-2553 "), oFont8) 
EndIf*/
//INICIO alteração Marlon 08/06/2022 #2155
/* 
	O tratamento dos contatos do orçamento é feito atraves de parametro.
	O parametro será o MV_CONVEND
	O padrao para preenchimento do parametro é NOME - FONE(Separado por - Ex.: (062) 99999-9999)
	De um contato para o outro separar com ;

 */
//If cFilAnt <> "0502" 
	cString := GetMV(_cMvCon)
	aString := strtokarr (cString, ";")
	for nString := 1 to len(aString)
		cStr1 := strtokarr (cValtoChar(aString[nString]), "-")
		nLin+=50
		oPrint:SayBitmap(nLin-22, 0530, cLogo, 030, 030)
		oPrint:Say(nLin, 0150, (cStr1[1]), oFont10)
		oPrint:Say(nLin, 0350, (cStr1[2]+"-"+cStr1[3]), oFont10)
	next
//EndIf
//FIM
	oPrint:Say(nLin, 2100, ("Nº Paginas: ")+cvaltochar(_nPagin)+"/"+ALLTRIM(RetPag()), oFont10)
	nLin+=50

	oPrint:SayBitmap(3200, 0100, cLogo, 2200, 300)	 //350     220

/*If cFilAnt = "0501"
   oPrint:SayBitmap(3200, 0100, _aBmp[5], 2200, 300)	 //350     220
      //oPrint:SayBitmap(010, 0650, _aBmp[5], 350, 1000)   //rodape Grid
EndIF*/
oPrint:endPage()
	MS_FLUSH()
oPrint:Preview() 
Return()

//Retorna a Quantidade de Pagina do Orçamento
 
Static Function RetPag()   
Local _nPag := " "
Local _nCalc := 0

If Select("TMP2") > 0
	TMP2->(dbCloseArea())
EndIf

_cQry := "SELECT TOP 1 CK_ITEM Quant  "
_cQry := "SELECT CK_ITEM Quant  "
_cQry += "FROM " + retsqlname("SCK")+" SCK "  
_cQry += "WHERE SCK.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SCK.CK_NUM = '" + _Nun + "' "
_cQry += "AND   SCK.CK_FILIAL = '"+xFilial("SCK")+"'"
_cQry += "ORDER BY CK_FILIAL,CK_ITEM DESC "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP2"

If val(TMP2->Quant) <= 41
    _nCalc := 1
ElseIf val(TMP2->Quant) > 41 .and. val(TMP2->Quant) <= 86
    _nCalc := 2
ElseIf val(TMP2->Quant) > 86 .and. val(TMP2->Quant) <= 131
	_nCalc := 3 
ElseIf val(TMP2->Quant) > 131 .and. val(TMP2->Quant) <= 176   
    _nCalc := 4 
ElseIf val(TMP2->Quant) > 176 .and. val(TMP2->Quant) <= 221   
    _nCalc := 5 
ElseIf val(TMP2->Quant) > 221 .and. val(TMP2->Quant) <= 266   
    _nCalc := 6
EndIf   

 _nPag   := cvaltochar(_nCalc) //cvaltochar(round((val(TMP2->Quant)/41),0)+1) //val(TMP2->Quant)/41
       
Return _nPag
