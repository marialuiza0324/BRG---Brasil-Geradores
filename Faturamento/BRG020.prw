/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BRG020  ³ Autor ³ Ricardo Moreira³ 		  Data ³ 21/02/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressão de Fatura   									  ³±±
±±³          ³ 						                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para BRG                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function BRG020()

//Private _Nf        := SC5->C5_NOTA 
//Private _Serie     := SC5->C5_SERIE
Local _Desc,_End,_Bair,_Cid,_Uf :=  " "
Local _aBmp 		:= {}
Local _Nun    		:= SC5->C5_NUM
Local cFormPg 		:= ""
Local cNfRem 		:= ""
Local aNfRem 		:= {}
Local nValor 		:= 0
Local nInicio 		:= 1
Local nFim			:= 0
Local nCont			:= 0
Local nFimPalavra 	:= ""
Local cTexto		:= ""
Local nMaxLen		:= 95
Local nPosicao 		:= 0

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
Private oPrint		 
//Private oPrint		:= FWMsPrinter():New("") //FWMsPrinter
Private nPag		:= 1
Private _Emp
Private cPerg 		:= "BRG020"
Private nRepita // variavel que controla a quantidade de relatorios impressos
Private nContador // contador do for principal, que imprime o relatorio n vezes
Private nZ
Private nJ
Private cLogoD
Private _Nf        := SC5->C5_NOTA 
Private _Serie     := SC5->C5_SERIE   
Private	_Qtd    := 0
Private _Tot    := 0   
Private _TotIpi := 0
Private _TotDif := 0  
Private	_Local  := " "
Private	_LtCtl  := " " 
Private _Prod   := " " 
Private _NumSeq := " "
Private _AlqDif := 0
Private cLogo := ''

If SC5->C5_TPDOC <> "F"
   MSGINFO("Tipo de Documento Incorreto para a impressão. !!! "," Atenção ") 
   Return
EndIf

If oPrint == Nil

//oPrint:=FwMSPrinter():New("Laudo.rel")
oPrint:=FWMSPrinter():New("Fatura",6,.T.,,.T.)
oPrint:SetPortrait() 
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
oPrint:cPathPDF :="C:\TEMP\"   
//oPrint:cPathPDF := "c:\rel\"
//oPrint:Preview()
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

//oPrint:SetPortrait()///Define a orientacao da impressao como retrato
//oPrint:SetLandscape() ///Define a orientacao da impressao como paisagem
//³Monta Query com os dados que serão impressos no relatório            ³

oPrint:StartPage()
cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")  

cLogo := "\system\danfe"+cEmpAnt+cFilAnt+".bmp"

/*aAdd(_aBmp,"\system\LGMID010501.png") 
aAdd(_aBmp,"\system\danfe010401.bmp") 
aAdd(_aBmp,"\system\danfe010501.bmp") 
aAdd(_aBmp,"\system\danfe020801.bmp") 
aAdd(_aBmp,"\system\danfe021001.bmp") 
aAdd(_aBmp,"\system\danfe010601.bmp")*/
 
    //R. 261-B, Nº 449 - Setor Leste Universitário, Goiânia - GO, 74610-270
 
    //oPrint:SayBitmap(010, 0650, _aBmp[2], 1700, 3190) //FAzendo teste
	//If cFilAnt =="0401"
       oPrint:SayBitmap(nLin+010, 0160, cLogo, 350, 300)	 //350     220
	/*elseIF cFilAnt =="0501"
	   oPrint:SayBitmap(nLin+010, 0160, _aBmp[2], 350, 300)
	elseIF cFilAnt =="0801"  
	   oPrint:SayBitmap(nLin+010, 0160, _aBmp[3], 350, 300)
	elseIF cFilAnt =="1001"  
	   oPrint:SayBitmap(nLin+010, 0160, _aBmp[4], 350, 300)
	elseIF cFilAnt =="0601"  
	   oPrint:SayBitmap(nLin+010, 0160, _aBmp[5], 350, 300)
	EndIf	*/

    nLin+=100      
    oPrint:Say(nLin,550,SM0->M0_NOMECOM,oFont10) //550
	nLin+=50 
	oPrint:Say(nLin, 1400,  ("FATURA DE LOCAÇÃO N.º: ")+SC5->C5_NOTA+"/"+SC5->C5_SERIE, oFont16N)
	//oPrint:Say(nLin,550,"RUA 261-B, Nº 449",oFont8) 
    oPrint:Say(nLin,550,SM0->M0_ENDCOB,oFont10) 
    nLin+=50
	//oPrint:Say(nLin,550,"LESTE UNIVERSITÁRIO - GOIÂNIA - GO, CEP - 74610-270 ",oFont8)
	oPrint:Say(nLin,550,AllTrim(SM0->M0_BAIRCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB+" - CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont10)
	nLin+=50
	oPrint:Say(nLin,550,"FONE: " + SM0->M0_TEL ,oFont10)
	nLin+=50
	oPrint:Say(nLin,550,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   " +"IE:"+ SM0->M0_INSC,oFont10) 
	//nLin+=50  
	//oPrint:Say(nLin,550,"E-mail: comercial@brggeradores.com.br",oFont8)   
	nLin+=100
	//	oPrint:Say(nLin, 2100, "Pagina: " + strzero(nPag,3), oFont8N)
_Desc     := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")  
_End      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_END")
_Bair     := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_BAIRRO") 
_Cid      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_MUN") 
_Uf       := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")
_Cnpj     := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CGC")  
_CEP      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CEP")
_TEL      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_TEL")  
_TpCli    := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_TIPO")
 
oPrint:Say(nLin, 100,  ("Emissão:"), oFont12)
oPrint:Say(nLin, 1570,  ("Telefone:"), oFont12)
oPrint:Say(nLin, 300,  CVALTOCHAR(SC5->C5_EMISSAO), oFont12N)
oPrint:Say(nLin, 1800, TRANSFORM(_TEL,"@R (99)9999-9999"), oFont12N)
nLin+=70 		
oPrint:Say(nLin, 100, ("Cliente:"), oFont12)
oPrint:Say(nLin, 300,  SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI +"-"+_Desc, oFont12N)    
oPrint:Say(nLin, 1570, ("CNPJ:"), oFont12)
oPrint:Say(nLin, 1800, TRANSFORM(_Cnpj,"@R 99.999.999/9999-99"),oFont12N) // CGC

nLin+=70  
oPrint:Say(nLin, 100,  ("Endereço:"), oFont12)
oPrint:Say(nLin, 300,  _End, oFont12N)
oPrint:Say(nLin, 1570,  ("Cidade:"), oFont12)
oPrint:Say(nLin, 1800,  alltrim(_Cid)+"/"+_Uf, oFont12N) 
 
nLin+=70  
oPrint:Say(nLin, 100,  ("Cond. Pgto:"), oFont12)
_Cond := Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI")
oPrint:Say(nLin, 300,  SC5->C5_CONDPAG+" - "+_Cond, oFont12N)
oPrint:Say(nLin, 1570,  ("Cep:"), oFont12)
oPrint:Say(nLin, 1800,  TRANSFORM(_CEP,"@R 99999-999"), oFont12N)    

nLin+=70  
oPrint:Say(nLin, 100,  ("Contrato:"), oFont12)
oPrint:Say(nLin, 300,  SC5->C5_XCONTRA, oFont12N)
oPrint:Say(nLin, 1570,  ("Ped Compra:"), oFont12)
oPrint:Say(nLin, 1800, SC5->C5_XPEDCOM, oFont12N) 
nLin+=70 
oPrint:Say(nLin, 100,  ("Proposta:"), oFont12)
oPrint:Say(nLin, 300,  SC5->C5_XPROPOS, oFont12N)

//nLin+=120
//oPrint:Say(nLin, 900, ("I T E N S  D O  O R Ç A M E N T O"), oFont14NS)

nLin+=100 
oPrint:Say(nLin, 100,  ("Item"), oFont10N)
oPrint:Say(nLin, 220,  ("Produto"), oFont10N)
oPrint:Say(nLin, 380,  ("Descrição"), oFont10N)
oPrint:Say(nLin, 1000, ("Serie"), oFont10N)
oPrint:Say(nLin, 1200, ("Qtde"), oFont10N)
oPrint:Say(nLin, 1500, ("Valor Unit."), oFont10N) 
oPrint:Say(nLin, 2050, ("Total"), oFont10N) 
nLin+=50
	
oPrint:Line(nLin,100,nLin,2200)	

nLin+=50
dbSelectArea("SC6")
dbsetorder(1)    
dbSeek(xFilial("SC6")+_Nun)                                                                                                                                                             

While SC6->(!EOF()) .AND. xFilial("SC6") = SC6->C6_FILIAL .AND. SC6->C6_NUM = _Nun 		
	
	//cTes := Posicione("SF4",1,xFilial("SF4")+SCK->CK_TES,"F4_CF")
	//cNcn := Posicione("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_POSIPI")		
	
	oPrint:Say(nLin, 110, SC6->C6_ITEM, oFont10)			
	oPrint:Say(nLin, 230, SC6->C6_PRODUTO, oFont10)                                                       
	oPrint:Say(nLin, 390, SC6->C6_DESCRI, oFont10)
	//oPrint:Say(nLin, 0900, cNcn, oFont8)
	oPrint:Say(nLin, 1010, SC6->C6_XSEREQU, oFont10)  //C6_XSEREQU serie do equipamento
	//oPrint:Say(nLin, 1150, cTes, oFont8) 
	oPrint:Say(nLin, 1250, Transform(SC6->C6_QTDVEN, "@e 999,999,999.999"), oFont10,,,,1)  
	oPrint:Say(nLin, 1550, Transform(SC6->C6_PRCVEN, "@e 999,999,999.99"), oFont10,,,,1) 	
	oPrint:Say(nLin, 2070, Transform(SC6->C6_VALOR, "@e 999,999,999.99"), oFont10,,,,1)      //oFont8,,,,2) // centraliza 
    //oPrint:Say(nLin, 2200, Transform(SCK->CK_VALOR+(SCK->CK_VALOR*((SCK->CK_IPI/100)))+(SCK->CK_VALOR*((SCK->CK_ICMS/100)))+(SCK->CK_VALOR*((SCK->CK_ISS/100))), "@e 999,999,999.999"), oFont8) 	
  	/*
    oPrint:Line(nLin,170,nLin+050,170) // Vertical
  	oPrint:Line(nLin,340,nLin+050,340) // Vertical
  	oPrint:Line(nLin,890,nLin+050,890) // Vertical
  	oPrint:Line(nLin,1040,nLin+050,1040) // Vertical
  	oPrint:Line(nLin,1140,nLin+050,1140) // Vertical
  	oPrint:Line(nLin,1240,nLin+050,1240) // Vertical
  	oPrint:Line(nLin,1440,nLin+050,1440) // Vertical
  	oPrint:Line(nLin,1690,nLin+050,1690) // Vertical
  	oPrint:Line(nLin,1810,nLin+050,1810) // Vertical
  	oPrint:Line(nLin,1920,nLin+050,1920) // Vertical 
  	oPrint:Line(nLin,2050,nLin+050,2050) // Vertical
      */
  	nLin+=50 
    //oPrint:Line(nLinV,020,nLinV,2350) // Vertical
	  	 	   	
   	_Qtd  := _Qtd + SC6->C6_QTDVEN   
   	_Tot  := _Tot + SC6->C6_VALOR    
   		
 SC6->( dbSkip() )    
 	
Enddo
nLin+=20 

oPrint:Line(nLin,100,nLin,2200) // Horizontal 

	
//oPrint:SayBitmap(010, 0650, _aBmp[2], 1700, 3190)         //ricardo moreira de lima
nLin := 2200 //1950
oPrint:Say(nLin, 0110, "FATURA DE LOCAÇÃO N.º: : " +SC5->C5_NOTA+"/"+SC5->C5_SERIE, oFont16N)
nLin+=50
oPrint:Say(nLin, 0110, "PERIODO: : REF: "+SUBSTR(DTOS(SC5->C5_XDTINI),7,2)+"/"+SUBSTR(DTOS(SC5->C5_XDTINI),5,2)+"/"+SUBSTR(DTOS(SC5->C5_XDTINI),1,4)+" A "+SUBSTR(DTOS(SC5->C5_XDTFIM),7,2)+"/"+SUBSTR(DTOS(SC5->C5_XDTFIM),5,2)+"/"+SUBSTR(DTOS(SC5->C5_XDTFIM),1,4), oFont14N)  //+Chr(13) + Chr(10)
nLin+=50
aNfRem = SEPARA(SC5->C5_NFREM,'/',.T.)


FOR nValor := 1 to Len(aNfRem)
    if cNfRem == "" .AND. Len(aNfRem) == 1
        oPrint:Say(nLin, 0110, "NF REMESSA:: " + CVALTOCHAR(aNfRem[nValor]), oFont14N)
        nLin += 50
    elseif cNfRem == "" .AND. Len(aNfRem) > 1
        cNfRem := CVALTOCHAR(aNfRem[nValor])
    else
        cNfRem := cNfRem + " - " + CVALTOCHAR(aNfRem[nValor])

        if Mod(nValor, 8) == 0 .OR. nValor == Len(aNfRem)
            oPrint:Say(nLin, 0110, "NF REMESSA:: " + cNfRem, oFont14N)
            cNfRem := ""
            nLin += 50
        endif
    endif
next
nLin+=50
oPrint:Say(nLin, 0110, "OUTRAS OBSERVAÇÕES:: ", oFont14N)  //+Chr(13) + Chr(10)
nLin += 50

nCont := 1
nFim := LEN(SC5->C5_MENNOTA)
cTexto := SC5->C5_MENNOTA

do while nInicio <= LEN(cTexto)
    // Encontra o último espaço antes do limite de caracteres
    nPosicao := 0
    nFim := nInicio + nMaxLen
    while nFim > nInicio
        if SubStr(cTexto, nFim, 1) == " "
            nPosicao := nFim
            exit
        endif
        nFim--
    enddo

    // Verifica se nenhuma quebra de palavra ocorreu
    if nPosicao = 0
        nPosicao := nInicio + nMaxLen // Caso contrário, imprime a linha inteira
    endif

    // Imprime os próximos 95 caracteres
    oPrint:Say(nLin, 0110, SubStr(cTexto, nInicio, nPosicao - nInicio), oFont14N)
    nLin += 50
    nInicio := nPosicao + 1
enddo

//Nao zerar o contador


/*
do while nInicio <= LEN(SC5->C5_MENNOTA)
    // Adiciona quebra de linha no final da página
    if Mod(nCont, 120) == 0 .OR. (nCont >= 120 .AND. nInicio == nFim)
        oPrint:Say(nLin, 0110,SubStr(SC5->C5_MENNOTA, nInicio, nFim-nInicio), oFont14N)
		nLin += 50	
		nCont := 0	
    endif
	nInicio++
	nCont++
enddo
*/
nLin+=100
oPrint:Say(nLin, 100,   ("T O T A I S"), oFont14N) 
nLin+=50
oPrint:Line(nLin,100,nLin,2200)                      
nLin+=50
dbSelectArea("SCV")
dbsetorder(1)    
dbSeek(xFilial("SCV")+_Nun) 
cFormPg := SCV->CV_DESCFOR 

oPrint:Say(nLin, 0110, "Forma de Pagamento : " +cFormPg, oFont12N)
oPrint:Say(nLin, 1700, "Total Da Fatura R$ : " +Transform(_Tot, "@e 999,999,999.99"), oFont12N)
nLin+=50

oPrint:Say(nLin, 0110, "Vencimento : " +CVALTOCHAR(STOD(RETVENC())), oFont12N)
oPrint:endPage()
	MS_FLUSH()
oPrint:Preview() 
Return()

Static Function RetVenc()   
Local dDtVenc := " "

If Select("TMP2") > 0
	TMP2->(dbCloseArea())
EndIf

_cQry := "SELECT E1_VENCREA DataVenc  "
_cQry += "FROM " + retsqlname("SE1")+" SE1 "  
_cQry += "WHERE SE1.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SE1.E1_NUM = '" + _Nf + "' "
_cQry += "AND   SE1.E1_PREFIXO = '" + _Serie + "' "
_cQry += "AND   SE1.E1_FILIAL = '"+xFilial("SE1")+"'"

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP2"

 dDtVenc   :=  TMP2->DataVenc
       
Return dDtVenc

