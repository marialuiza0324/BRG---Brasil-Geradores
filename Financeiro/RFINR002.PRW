#INCLUDE "RWMAKE.CH"
#include "protheus.ch"        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ BLTCDBB  ณ Autor ณ Microsiga             ณ Data ณ 20/03/07 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ IMPRESSAO DO BOLETO BANCO BRASIL COM CODIGO DE BARRAS      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes PREMIER - Adaptado po TRADE       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RFINR002(oPrn)

_cSacador := ""
Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras-Itau"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := "" 
Dgtest   := "DIG"
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
nLastKey := 0

dbSelectArea("SE1")

If nLastKey == 27
	Set Filter to
	Return
Endif

If lExec
	Processa({|lEnd|MontaRel()})
Endif

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ  MontaRelณ Autor ณ Microsiga             ณ Data ณ 13/10/03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontaRel()
LOCAL nX := 0
LOCAL cNroDoc :=  " "
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                     ,; //[2]Endere็o
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {"Ap๓s o vencimento cobrar multa de R$ ",;
"Mora Diaria de R$ " ,;
"Sujeito a protesto ap๓s 05 (cinco) dias uteis do vencimento"} //Sujeito a Protesto apos 05 (cinco) dias do vencimento

//Local aBolText := { MV_PAR19,MV_PAR20,MV_PAR21 }

LOCAL nI           := 1
LOCAL aCB_RN_NI    := {}
LOCAL nVlrAbat		:= 0

oPrn:StartPage()   // Inicia uma nova pแgina


//Posiciona o SA6 (Bancos)
DbSelectArea("SA6")
DbSetOrder(1)
DbSeek(xFilial("SA6")+"341") //332003662
//DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)

//Posiciona o SA1 (Cliente)
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)

DbSelectArea("SE1")                  
aDadosBanco  := {SA6->A6_COD,; 									// [1]Numero do Banco
SA6->A6_NREDUZ,;  												// [2]Nome do Banco
SUBSTR(SA6->A6_AGENCIA, 1, 4),; 								// [3]Ag๊ncia
SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),; 	    // [4]Conta Corrente
SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  ,;    	// [5]Dํgito da conta corrente
"   "}															// [6]Codigo da Carteira

If Empty(SA1->A1_ENDCOB)
	aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razใo Social
	AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]C๓digo
	AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endere็o
	AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
	SA1->A1_EST                                      ,;     	// [5]Estado
	SA1->A1_CEP                                      ,;      	// [6]CEP
	SA1->A1_CGC										          ,;// [7]CGC
	SA1->A1_PESSOA										}       // [8]PESSOA
Else
	aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Razใo Social
	AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]C๓digo
	AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endere็o
	AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
	SA1->A1_ESTC	                                     ,;   	// [5]Estado
	SA1->A1_CEPC                                        ,;   	// [6]CEP
	SA1->A1_CGC											 ,;		// [7]CGC
	SA1->A1_PESSOA										 }		// [8]PESSOA
Endif

nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo.
//Abaixo apenas uma sugestao
cNroDoc	:= Strzero(Val(Alltrim(SE1->E1_NUM)),6)+StrZERO(Val(Alltrim(SE1->E1_PARCELA)),2)
cNroDoc	:= STRZERO(Val(cNroDoc),11)

//Monta codigo de barras
aCB_RN_NI    :=  Ret_cBarra( SE1->E1_PREFIXO	,SE1->E1_NUM	,SE1->E1_PARCELA	,SE1->E1_TIPO	,;
Subs(aDadosBanco[1],1,3)	,aDadosBanco[3]	,aDadosBanco[4] ,aDadosBanco[5]	,;
cNroDoc		,(E1_VALOR-nVlrAbat)	, "18"	,"9"	)
DbSelectArea("SE1")
aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;  // [1] N๚mero do tํtulo
E1_EMISSAO                              	,;  			// [2] Data da emissใo do tํtulo
dDataBase                    					,;  		// [3] Data da emissใo do boleto
E1_VENCTO                               	,;  			// [4] Data do vencimento
(E1_SALDO - nVlrAbat)                  	,;  				// [5] Valor do tํtulo
aCB_RN_NI[3]                             	,; 		    	// [6] Nosso n๚mero (Ver f๓rmula para calculo)
E1_PREFIXO                               	,; 				// [7] Prefixo da NF
E1_TIPO	                           	,;  					// [8] Tipo do Titulo
E1_VALJUR                          	,;   					// [9] Mora por dia de atraso
_cSacador                          ,;   					// [10]Sacador/Avalista
E1_VLMULTA	} 												// [11]Multa

Impress(oPrn,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NI)
nX := nX + 1
nI++
oPrn:EndPage()     // Finaliza a pแgina

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ  Impress ณ Autor ณ Microsiga             ณ Data ณ 13/10/03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ IMPRS  DO BOLETO LASER ITAU COM CODIGO DE BARRAS      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Impress(oPrn,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NI)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0 
LOCAL _aBitMap := {"itau.bmp"} ///RICARDO 26/04

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrn:StartPage()   // Inicia uma nova pแgina

/******************/
/* PRIMEIRA PARTE */
/******************/


nRow1 := 0

oPrn:Line (0150,500,0070, 500)
oPrn:Line (0150,710,0070, 710)

oPrn:SayBitMap(nRow1+0075,100,_aBitMap[1], 390,80)
//oPrn:Say  (0084,100,"Itau",oFont11 )	    // [2]Nome do Banco
oPrn:Say  (0075,513,aDadosBanco[1]+"-7",oFont21 )	// [1]Numero do Banco

oPrn:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
oPrn:Line (nRow1+0150,100,nRow1+0150,2300)

oPrn:Say  (nRow1+0150,100 ,"Cedente",oFont8)
oPrn:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

oPrn:Say  (nRow1+0150,1060,"Ag๊ncia/C๓digo Cedente",oFont8)
oPrn:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+"37141-3",oFont10) // codigo cedente 
//oPrn:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrn:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
oPrn:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrn:Say  (nRow1+0250,100 ,"Sacado",oFont8)
oPrn:Say  (nRow1+0300,100 ,aDatSacado[1],oFont10)				//Nome

oPrn:Say  (nRow1+0250,1060,"Vencimento",oFont8)
oPrn:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrn:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
oPrn:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrn:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/tํtulo",oFont10)
oPrn:Say  (nRow1+0450,0100,"com as caracterํsticas acima.",oFont10)
oPrn:Say  (nRow1+0350,1060,"Data",oFont8)
oPrn:Say  (nRow1+0350,1410,"Assinatura",oFont8)
oPrn:Say  (nRow1+0450,1060 ,"Data do Documento",oFont8)
oPrn:Say  (nRow1+0480,1060, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)
//oPrn:Say  (nRow1+0450,1410,"Entregador",oFont8)
oPrn:Say  (nRow1+0450,1410,"Nosso N๚mero",oFont8)
cstring := substr(aCB_RN_NI[3],1,3)+"/"+substr(aCB_RN_NI[3],4,8) //,1,3)+"/"+substr(aCB_RN_NI[3],4,8) //cString := aCB_RN_NI[3] //cString := substr(aCB_RN_NI[3],8,17) 
cstring := substr(cstring,1,3)+(substr(cstring,5,9)) //nao pode conter a Barra no DgTest //,1,3)+"/"+substr(aCB_RN_NI[3],4,8) //cString := aCB_RN_NI[3] //cString := substr(aCB_RN_NI[3],8,17) 
nCol := 1410+(374-(len(cString)*22))
Dgtest := U_CALC_DPI(cString,8,10)
cstring := substr(cstring,1,3)+"/"+(substr(cstring,4,8))// Retorna a Barra  //,1,3)+"/"+substr(aCB_RN_NI[3],4,8) //cString := aCB_RN_NI[3] //cString := substr(aCB_RN_NI[3],8,17) 
oPrn:Say  (nRow1+0480,nCol,cString+"-"+Dgtest,oFont11c) //+" "+str(Dgtest)  //CALC_DP(val(SUBSTR(cString,8,10)))  //oPrn:Say  (nRow1+0480,nCol,cString,oFont11c)
//oPrn:Say  (nRow1+0480,nCol,Strzero(Val(Substr(cString,8,10)),12),oFont11c) //+" "+str(Dgtest)  //CALC_DP(val(SUBSTR(cString,8,10)))  //oPrn:Say  (nRow1+0480,nCol,cString,oFont11c)
//oPrn:Say  (nRow1+0480,1810,Alltrim(Dgtest),oFont11c)
oPrn:Line (nRow1+0250, 100,nRow1+0250,1900 )
oPrn:Line (nRow1+0350, 100,nRow1+0350,1900 )
oPrn:Line (nRow1+0450,1050,nRow1+0450,1900 )
oPrn:Line (nRow1+0550, 100,nRow1+0550,2300 )

oPrn:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrn:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrn:Line (nRow1+0350,1500,nRow1+0150,1500 )
oPrn:Line (nRow1+0550,1900,nRow1+0150,1900 )

oPrn:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
oPrn:Say  (nRow1+0205,1910,"(  )Ausente"                                  ,oFont8)
oPrn:Say  (nRow1+0245,1910,"(  )Nใo existe nบ indicado"                  	,oFont8)
oPrn:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
oPrn:Say  (nRow1+0325,1910,"(  )Nใo procurado"                            ,oFont8)
oPrn:Say  (nRow1+0365,1910,"(  )Endere็o insuficiente"                  	,oFont8)
oPrn:Say  (nRow1+0405,1910,"(  )Desconhecido"                             ,oFont8)
oPrn:Say  (nRow1+0445,1910,"(  )Falecido"                                 ,oFont8)
oPrn:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                  ,oFont8)


/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 0


//Pontilhado separador
For nI := 100 to 2300 step 50
	oPrn:Line(0580, nI,0580, nI+30)
Next nI

oPrn:Line (nRow2+0710,100,nRow2+0710,2300)
oPrn:Line (nRow2+0710,500,nRow2+0630, 500)
oPrn:Line (nRow2+0710,710,nRow2+0630, 710)

oPrn:SayBitMap(nRow2+0635,100,_aBitMap[1], 390,70)
//oPrn:Say  (nRow2+0644,100,"Santander" ,oFont11 ) //aDadosBanco[2],oFont11 )		// [2]Nome do Banco
oPrn:Say  (nRow2+0635,513,aDadosBanco[1]+"-7",oFont21 )	// [1]Numero do Banco
oPrn:Say  (nRow2+0644,1800,"Recibo do Sacado",oFont10)

oPrn:Line (nRow2+0810,100,nRow2+0810,2300 )
oPrn:Line (nRow2+0910,100,nRow2+0910,2300 )
oPrn:Line (nRow2+0980,100,nRow2+0980,2300 )
oPrn:Line (nRow2+1050,100,nRow2+1050,2300 )

oPrn:Line (nRow2+0910,500,nRow2+1050,500)
oPrn:Line (nRow2+0980,750,nRow2+1050,750)
oPrn:Line (nRow2+0910,1000,nRow2+1050,1000)
oPrn:Line (nRow2+0910,1300,nRow2+0980,1300)
oPrn:Line (nRow2+0910,1480,nRow2+1050,1480)

oPrn:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
oPrn:Say  (nRow2+0725,400 ,"ATษ O VENCIMENTO, PREFERENCIALMENTE NO ITAU",oFont10)
oPrn:Say  (nRow2+0765,400 ,"APำS O VENCIMENTO, SOMENTE NO ITAU",oFont10)

oPrn:Say  (nRow2+0710,1810,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrn:Say  (nRow2+0750,nCol,cString,oFont11c)

oPrn:Say  (nRow2+0810,100 ,"Cedente"                                        ,oFont8)
oPrn:Say  (nRow2+0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrn:Say  (nRow2+0810,1810,"Ag๊ncia/C๓digo Cedente",oFont8)

cString := Alltrim(aDadosBanco[3]+"/"+"37141-3")// Codigo Cedente
//cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol := 1810+(374-(len(cString)*22))
oPrn:Say  (nRow2+0850,nCol,cString,oFont11c)

oPrn:Say  (nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
oPrn:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrn:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrn:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrn:Say  (nRow2+0910,1005,"Esp้cie Doc."                                   ,oFont8)
oPrn:Say  (nRow2+0940,1050,"DM"										,oFont10) //Tipo do Titulo

oPrn:Say  (nRow2+0910,1305,"Aceite"                                         ,oFont8)
oPrn:Say  (nRow2+0940,1400,"N"                                             ,oFont10)

oPrn:Say  (nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
oPrn:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrn:Say  (nRow2+0910,1810,"Nosso N๚mero"                                   ,oFont8)
//cString := Alltrim(Substr(aDadosTit[6],0,0)+Alltrim(SA6->A6_NUMBCO)+"00"+Substr(aDadosTit[1],1,6)+"0"+Substr(aDadosTit[1],7,1)) //cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
cstring := substr(aCB_RN_NI[3],1,3)+"/"+substr(aCB_RN_NI[3],4,8)//cString := aCB_RN_NI[3] //cString := substr(aCB_RN_NI[3],8,17) 
nCol := 1810+(374-(len(cString)*22))
oPrn:Say  (nRow2+0940,nCol,cString+"-"+Dgtest,oFont11c)  //oPrn:Say  (nRow2+0940,nCol,cString,oFont11c)
//oPrn:Say  (nRow2+0940,2210,Alltrim(Dgtest),oFont11c)

oPrn:Say  (nRow2+0980,100 ,"Uso do Banco"                                   ,oFont8)

oPrn:Say  (nRow2+0980,505 ,"Carteira"                                       ,oFont8)
oPrn:Say  (nRow2+1010,555 ,aDadosBanco[6]                                  	,oFont10)

oPrn:Say  (nRow2+0980,755 ,"Esp้cie"                                        ,oFont8)
oPrn:Say  (nRow2+1010,805 ,"R$"                                             ,oFont10)

oPrn:Say  (nRow2+0980,1005,"Quantidade"                                     ,oFont8)
oPrn:Say  (nRow2+0980,1485,"Valor"                                          ,oFont8)

oPrn:Say  (nRow2+0980,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrn:Say  (nRow2+1010,nCol,cString ,oFont11c)

oPrn:Say  (nRow2+1050,100 ,"Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do cedente)",oFont8)
oPrn:Say  (nRow2+1150,100 ,aBolText[2]+" "+AllTrim(Transform(aDadosTit[9],"@E 99,999.99"))       ,oFont10)  //mora
oPrn:Say  (nRow2+1200,100 ,aBolText[3]  ,oFont10)
//oPrn:Say  (nRow2+1250,100 ,aBolText[3]                                        ,oFont10)
/* Alessandro - 13/11/2008
oPrn:Say  (nRow2+1150,100 ,aBolText[1] ,oFont10)
oPrn:Say  (nRow2+1200,100 ,aBolText[2] ,oFont10)
oPrn:Say  (nRow2+1250,100 ,aBolText[3] ,oFont10)
*/
oPrn:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrn:Say  (nRow2+1120,1810,"(-)Outras Dedu็๕es"                             ,oFont8)
oPrn:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrn:Say  (nRow2+1260,1810,"(+)Outros Acr้scimos"                           ,oFont8)
oPrn:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrn:Say  (nRow2+1400,100 ,"Sacado"                                         ,oFont8)
oPrn:Say  (nRow2+1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrn:Say  (nRow2+1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrn:Say  (nRow2+1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrn:Say  (nRow2+1430,1750 ,"CNPJ:"+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrn:Say  (nRow2+1430,1750 ,"CPF:"+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf


//oPrn:Say  (nRow2+1589,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

oPrn:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
oPrn:Say  (nRow2+1645,1500,"Autentica็ใo Mecโnica",oFont8)

oPrn:Line (nRow2+0710,1800,nRow2+1400,1800 )
oPrn:Line (nRow2+1120,1800,nRow2+1120,2300 )
oPrn:Line (nRow2+1190,1800,nRow2+1190,2300 )
oPrn:Line (nRow2+1260,1800,nRow2+1260,2300 )
oPrn:Line (nRow2+1330,1800,nRow2+1330,2300 )
oPrn:Line (nRow2+1400,100 ,nRow2+1400,2300 )
oPrn:Line (nRow2+1640,100 ,nRow2+1640,2300 )


/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 0

For nI := 100 to 2300 step 50
	oPrn:Line(nRow3+1880, nI, nRow3+1880, nI+30)
Next nI

oPrn:Line (nRow3+2000,100,nRow3+2000,2300)
oPrn:Line (nRow3+2000,500,nRow3+1920, 500)
oPrn:Line (nRow3+2000,710,nRow3+1920, 710)


//oPrn:Say  (nRow3+1934,100,"Itau",oFont11) //aDadosBanco[2],oFont11 )		// 	[2]Nome do Banco
oPrn:SayBitMap(nRow3+1925,100,_aBitMap[1], 390,70)
oPrn:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont21 )	// 	[1]Numero do Banco
oPrn:Say  (nRow3+1934,755,aCB_RN_NI[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

oPrn:Line (nRow3+2100,100,nRow3+2100,2300 )
oPrn:Line (nRow3+2200,100,nRow3+2200,2300 )
oPrn:Line (nRow3+2270,100,nRow3+2270,2300 )
oPrn:Line (nRow3+2340,100,nRow3+2340,2300 )

oPrn:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrn:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrn:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrn:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrn:Line (nRow3+2200,1480,nRow3+2340,1480)

oPrn:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
oPrn:Say  (nRow3+2015,400 ,"ATษ O VENCIMENTO, PREFERENCIALMENTE NO ITAU",oFont10)
oPrn:Say  (nRow3+2055,400 ,"APำS O VENCIMENTO, SOMENTE NO ITAU",oFont10)

oPrn:Say  (nRow3+2000,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrn:Say  (nRow3+2040,nCol,cString,oFont11c)

oPrn:Say  (nRow3+2100,100 ,"Cedente",oFont8)
oPrn:Say  (nRow3+2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrn:Say  (nRow3+2100,1810,"Ag๊ncia/C๓digo Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+"37141-3") // codigo cedente
nCol 	 := 1810+(374-(len(cString)*22))
oPrn:Say  (nRow3+2140,nCol,cString ,oFont11c)


oPrn:Say  (nRow3+2200,100 ,"Data do Documento"                              ,oFont8)
oPrn:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrn:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
oPrn:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrn:Say  (nRow3+2200,1005,"Esp้cie Doc."                                   ,oFont8)
oPrn:Say  (nRow3+2230,1050,"DM"										,oFont10) //Tipo do Titulo

oPrn:Say  (nRow3+2200,1305,"Aceite"                                         ,oFont8)
oPrn:Say  (nRow3+2230,1400,"N"                                             ,oFont10)

oPrn:Say  (nRow3+2200,1485,"Data do Processamento"                          ,oFont8)
oPrn:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrn:Say  (nRow3+2200,1810,"Nosso N๚mero"                                   ,oFont8)
//cString := Alltrim(Substr(aDadosTit[6],0,0)+"029168900"+Substr(aDadosTit[1],1,6)+"0"+Substr(aDadosTit[1],7,1)) //cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
//cString := Alltrim(Substr(aDadosTit[6],0,0)+ALLTRIM(SA6->A6_NUMBCO)+"0"+Substr(aDadosTit[1],1,6)+"0"+Substr(aDadosTit[1],7,1)) //cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
cstring := substr(aCB_RN_NI[3],1,3)+"/"+substr(aCB_RN_NI[3],4,8) //cString := aCB_RN_NI[3] //cString := substr(aCB_RN_NI[3],8,17) 

nCol 	 := 1810+(374-(len(cString)*22))
oPrn:Say  (nRow3+2230,nCol,cString+"-"+Dgtest,oFont11c) //oPrn:Say  (nRow3+2230,nCol,cString,oFont11c)
//oPrn:Say  (nRow3+2230,2210,Alltrim(Dgtest),oFont11c)

oPrn:Say  (nRow3+2270,100 ,"Uso do Banco"                  ,oFont8)

oPrn:Say  (nRow3+2270,505 ,"Carteira"                      ,oFont8)
oPrn:Say  (nRow3+2300,555 ,aDadosBanco[6]                  ,oFont10)

oPrn:Say  (nRow3+2270,755 ,"Esp้cie"                       ,oFont8)
oPrn:Say  (nRow3+2300,805 ,"R$"                            ,oFont10)

oPrn:Say  (nRow3+2270,1005,"Quantidade"                    ,oFont8)
oPrn:Say  (nRow3+2270,1485,"Valor"                         ,oFont8)

oPrn:Say  (nRow3+2270,1810,"Valor do Documento"            ,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrn:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrn:Say  (nRow3+2340,100 ,"Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do cedente)",oFont8)
oPrn:Say  (nRow3+2440,100 , aBolText[2]+" "+AllTrim(Transform(aDadosTit[9],"@E 99,999.99"))       ,oFont10)
oPrn:Say  (nRow3+2490,100 , aBolText[3] ,oFont10)
//oPrn:Say  (nRow3+2540,100 ,aBolText[3]                                        ,oFont10)
/* Alessandro - 13/11/08
oPrn:Say  (nRow3+2440,100 ,aBolText[1] ,oFont10)
oPrn:Say  (nRow3+2490,100 ,aBolText[2] ,oFont10)
oPrn:Say  (nRow3+2540,100 ,aBolText[3] ,oFont10)
*/
oPrn:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrn:Say  (nRow3+2410,1810,"(-)Outras Dedu็๕es"                             ,oFont8)
oPrn:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrn:Say  (nRow3+2550,1810,"(+)Outros Acr้scimos"                           ,oFont8)
oPrn:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrn:Say  (nRow3+2690,100 ,"Sacado"                                         ,oFont8)
oPrn:Say  (nRow3+2700,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

if aDatSacado[8] = "J"
	oPrn:Say  (nRow3+2700,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrn:Say  (nRow3+2700,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrn:Say  (nRow3+2753,400 ,aDatSacado[3]                                    ,oFont10)
oPrn:Say  (nRow3+2806,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
//oPrn:Say  (nRow3+2806,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

oPrn:Say  (nRow3+2815,100 ,"Sacador/Avalista"                               ,oFont8)
oPrn:Say  (nRow3+2855,1500,"Autentica็ใo Mecโnica - Ficha de Compensa็ใo"                        ,oFont8)

oPrn:Line (nRow3+2000,1800,nRow3+2690,1800 )
oPrn:Line (nRow3+2410,1800,nRow3+2410,2300 )
oPrn:Line (nRow3+2480,1800,nRow3+2480,2300 )
oPrn:Line (nRow3+2550,1800,nRow3+2550,2300 )
oPrn:Line (nRow3+2620,1800,nRow3+2620,2300 )
oPrn:Line (nRow3+2690,100 ,nRow3+2690,2300 )

oPrn:Line (nRow3+2850,100,nRow3+2850,2300  )

//MSBAR("INT25",12.7,1,aCB_RN_NI[1],oPrn,.F.,Nil,Nil,0.0135,0.75,Nil,Nil,"A",.F.) ///19

//MSBAR("INT25",27.83,1.78,aCB_RN_NI[1],oPrn,.F.,NIL,NIL,0.0295,1.32,.F.,.F.,.F.,.F.)
MSBAR("INT25",24.9,1.29,aCB_RN_NI[1],oPrn,.F.,NIL,NIL,0.0295,1.32,.F.,.F.,.F.,.F.)
//MSBAR("INT25",25,1,aCB_RN_NI[1],oPrn,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.) ///19
//MSBAR("INT25",25,1.78,aCB_RN_NI[1],oPrn,.F.,Nil,Nil,0.0295,1.32,Nil,Nil,"A",.F.) ///19

For nI := 100 to 2300 step 50
	oPrn:Line(nRow3+3150, nI, nRow3+3150, nI+30)
Next nI


DbSelectArea("SE1")
RecLock("SE1",.f.)
SE1->E1_NUMBCO 	:=	aCB_RN_NI[3] // Nosso n๚mero (Ver f๓rmula para calculo) //SE1->E1_NUMBCO 	:=	substr(aCB_RN_NI[3],8,17)
SE1->E1_HIST := "BOLETO ITAU GERADO"
SE1->E1_PORTADO := SA6->A6_COD
SE1->E1_AGEDEP   := SA6->A6_AGENCIA
SE1->E1_CONTA      := SA6->A6_NUMCON
SE1->E1_SITUACA   := "0"
//SE1->E1_TIPO   := "BOL"  //ALTERAวรO RICARDO 26/04/12
SE1->E1_FORMPG   := "BOL" //
MsUnlock()

oPrn:EndPage() // Finaliza a pแgina

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRetDados  บAutor  ณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera SE1                        					          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ret_cBarra(	cPrefixo	,cNumero	,cParcela	,cTipo	,;
cBanco		,cAgencia	,cConta		,cDacCC	,;
cNroDoc		,nValor		,cCart		,cMoeda	)


Local cNosso		    := ""
Local cDigNosso	:= ""
Local NNUM			:= ""
Local cCampoL		:= ""
Local cFatorValor	:= ""
Local cLivre		    := ""
Local cDigBarra	    := ""
Local cBarra		    := ""
Local cParte1		:= ""
Local cDig1			:= ""
Local cParte2		:= ""
Local cDig2			:= ""
Local cParte3		:= ""
Local cDig3			:= ""
Local cParte4		:= ""
Local cParte5		:= ""
Local cDigital		    := ""
Local aRet			    := {}  
Local DigP          := ""
Local DigF          := ""

cAgencia:=STRZERO(Val(cAgencia),4)
cCart    := "109"
//cCart    := "17" 
cNosso := ""

//Nosso Numero
If !Empty(SE1->E1_NUMBCO)
	nNum   := ALLTRIM(SE1->E1_NUMBCO)
	cNosso := ALLTRIM(SE1->E1_NUMBCO)
Else
	//cDigNosso  := U_CALC_diE(nNUM)
	see->(dbsetorder(1))
	see->(dbgotop())                    
	If see->(dbSeek(xFilial("SEE")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON)) //"001"+"3388X"+"218480    "SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA
		cNosso:=substr(see->ee_codemp,1,3)+substr(see->ee_faxatu,1,8)
        nNum :=substr(see->ee_codemp,1,3)+substr(see->ee_faxatu,1,8)
  
  		//cNosso:=strzero(substr(see->ee_faxatu,1,10),12)
		//nNum :=strzero(substr(see->ee_faxatu,1,10),12)
		see->(reclock("SEE",.f.))
        see->ee_faxatu:=Substr(cvaltochar(val(cNosso)+1),4,12)
        //see->ee_faxatu:=(val(Substr(cNosso,8,10))+1)
		see->(msunlock())
	Endif
EndIf

//cNosso     := STRZERO(VAL(cnumero),10) //acrescentar a parcela no n๚mero
//nNum       := cNosso

If nValor > 0
	cFatorValor  := u_fator2()+Strzero(nValor*100,10)
Else
	cFatorValor  := u_fator2()+strzero(SE1->E1_VALOR*100,10)
EndIf


cConvenio := ALLTRIM(SA6->A6_NUMBCO)


//DigP := substr(NNUM,6,7)
DigF := U_CALC_DpI(NNUM)
                          //53021   //53021
//cCampoL := "9"+cConvenio+"53021"+Substr(NNUM,6,7)+ DigF + "0101"
cCampoL := NNUM + DigF //"9" + cConvenio + NNUM + DigF + "0101"
//cLivre := cBanco+cMoeda+cFatorValor+cConvenio
cLivre := cBanco+cMoeda+cFatorValor+cCampoL+cAgencia+cConta+"3000" // 3 refere ao digito da conta

// campo do codigo de barra
cDigBarra := U_CALC_DvI( cLivre )   // alterar s๓ aki.....

cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5)

// composicao da linha digitavel
cParte1  := cBanco+"9"+cCart+SUBSTR(cNosso,4,5) //	// cBanco+cMoeda+"9"+"5302"  //cParte1  := cBanco+cMoeda+cFixo+cCodCed //cParte1  += SUBSTR(cBarra,20,5) //SUBSTR(cCampoL,20,5) //SUBSTR(cCampoL,1,5)
cDig1    := U_IDIGIT0001( cParte1,1 ) //DAC do primeiro campo 
cParte2  := SUBSTR(cNosso,6,12)+DigF+SUBSTR(cAgencia,1,3)	//"196"+SUBSTR(cNosso,1,7)// SUBSTR(cBarra,25,10 ) //SUBSTR(cCampoL,6,10)
cDig2    := U_IDIGIT0001( cParte2,2 )
cParte3  := SUBSTR(cAgencia,4,4)+cConta+"3000"  //o numero "3" representa o DAC da conta 				//+SUBSTR(cNroDoc,5,7)+"00341"+""+"0"			//SUBSTR(cNosso,8,5) + U_Calc_dpI(cNosso) + "0101" //SUBSTR(cBarra,35,10) //SUBSTR(cCampoL,6,29)//10
cDig3    := U_IDIGIT0001( cParte3,2 )
cParte4  := cDigBarra 					//" "+cDigBarra+" "
cParte5  := cFatorValor

cDigital := substr(cParte1,1,5)+"."+substr(cparte1,6,4)+cDig1+" "+;
substr(cParte2,1,5)+"."+substr(cparte2,6,5)+cDig2+" "+;
substr(cParte3,1,5)+"."+substr(cparte3,6,5)+cDig3+" "+;
cParte4+" "+;
cParte5


Aadd(aRet,cBarra)
Aadd(aRet,cDigital)
Aadd(aRet,cNosso)

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCALC_IdiE  บAutor  ณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPara calculo do nosso numero do banco do brasil             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CALC_IdiE(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
base   := 9
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	If base == 1
		base := 9
	EndIf
	auxi   := Val(SubStr(cBase, idig, 1)) * base
	sumdig := SumDig+auxi
	base   := base - 1
	iDig   := iDig-1
EndDo
auxi := mod(Sumdig,11)
If auxi == 10
	auxi := "X"
Else
	auxi := str(auxi,1,0)
EndIf
Return(auxi)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณIDIGIT0001  บAutor  ณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPara calculo da linha digitavel do ITAU                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IDIGIT0001(cVariavel,nOp)

//Local Auxi := 0, sumdig := 0Local _aArea     := GetArea()
local aMultiplic := {}  // Resultado das Multiplicacoes de cada algarismo
local _cRet      := " "
local aBaseNum   := {}
local cDigVer    := 0
local nB         := 0
local nC         := 0
local nSum       := 0
local _cNossoNum := ""
local _cCalcdig  := ""
cbase  := cVariavel
IF nOp == 1
	aBaseNum   := { 2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2}
ELSE
	aBaseNum   := { 1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1}
ENDIF

/*lbase  := LEN(cBase)
umdois := 2
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
auxi   := Val(SubStr(cBase, idig, 1)) * umdois
sumdig := SumDig+If (auxi < 10, auxi, (auxi-9))
umdois := 3 - umdois
iDig:=iDig-1
EndDo
cValor:=AllTrim(STR(sumdig,12))
nDezena:=VAL(ALLTRIM(STR(VAL(SUBSTR(cvalor,1,1))+1,12))+"0")
auxi := nDezena - sumdig

If auxi >= 10
auxi := 0

EndIf
*/
For nB := 1 To Len(cbase)
	
	nMultiplic := Val(Subs(cbase,nB,1) ) * aBaseNum[nB]
	Aadd(aMultiplic,StrZero(nMultiplic,2) )
	
next nB
For nC := 1 To Len(aMultiplic)
	nAlgarism1 := Val(Subs(aMultiplic[nC],1,1) )
	nAlgarism2 := Val(Subs(aMultiplic[nC],2,1) )
	nSum       := nSum + nAlgarism1 + nAlgarism2
Next nC

cDigVer := 10 - Mod(nSum,10)

IF cDigVer == 10
	cDigVer := 0
Endif


Return(str(cDigVer,1,0))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณFATOR		บAutor  ณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalculo do FATOR1  de vencimento para linha digitavel.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function Fator2()
If Len(ALLTRIM(SUBSTR(DTOC(SE1->E1_VENCTO),7,4))) = 4
	cData := SUBSTR(DTOC(SE1->E1_VENCTO),7,4)+SUBSTR(DTOC(SE1->E1_VENCTO),4,2)+SUBSTR(DTOC(SE1->E1_VENCTO),1,2)
Else
	cData := "20"+SUBSTR(DTOC(SE1->E1_VENCTO),7,2)+SUBSTR(DTOC(SE1->E1_VENCTO),4,2)+SUBSTR(DTOC(SE1->E1_VENCTO),1,2)
EndIf
cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
//cFator := STR(1000+(SE1->E1_VENCREA-STOD("20000703")),4)
Return(cFator)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCALC_DpI  บAutor  ณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalculo do digito do nosso numero do                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CALC_DpI(cVariavel)
Local Auxi := 0, sumdig := 0
Local aBasecalc := { 1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2}
//Local aBasecalc := { 4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2}
//Local aBasecalc := { 2,3,4,5,6,7,8}
//Local aBasecalc := { 8,7,6,5,4,3,2}  
Local tmABASE   := Len(aBasecalc)
Local nMult     := 0
Local nD        := 0
Local nE        := 0
Local aMult     := {}
Local nDigbar   := 0
Local nSoma     := 0
cbase  := "014737141"+cVariavel

For nd:=Len(cbase) To 1 step -1
	nMult := Val(Substr(cbase,nD,1) ) * aBasecalc[tmABASE]
	Aadd(aMult,StrZero(nMult,2) )                      
	tmABASE--
next nD

nSoma := 0
nAlgarism1 := 0
nAlgarism2 := 0
For nE := 1 To Len(aMult)
   	if (val(aMult[nE]) > 10)                    // se o Numero e Maior que 10 soma um digito pelo outro ex 14 = 1+4 = 14-9
		aMult[nE] := (val(aMult[nE])-9)
		aMult[nE] := strZero(aMult[nE],1)
	EndIf
	nAlgarism1 := Val(aMult[nE])
	nSoma      := nSoma + nAlgarism1 // + nAlgarism2 
Next nC

 If Mod(nSoma,10)== 0 .or. Mod(nSoma,10)== 10
     nDigbar := 0
  Else
nDigbar := 10 - Mod(nSoma,10)
EndIf

Return(str(nDigbar,1,0))
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCALC_Dv   บAutor  ณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalculo do digito do DV do Cod de Barra                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CALC_DvI(cVariav)
Local Auxid := 0, sumd := 0
Local aBasecal := { 4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2}
//Local aBasecalc := { 2,3,4,5,6,7,8}
//Local aBasecalc := { 8,7,6,5,4,3,2}  
Local tmABAS   := Len(aBasecal)
Local nMulti     := 0
Local nDv        := 0
Local nEv        := 0
Local aMulti     := {}
Local nDigb   := 0
Local nSomad     := 0
cbasedv  := cVariav

For ndv:=Len(cbasedv) To 1 step -1
	nMulti := Val(Subs(cbasedv,nDv,1) ) * aBasecal[tmABAS]
	Aadd(aMulti,StrZero(nMulti,2) )                      
	tmABAS--
next nDv  

nSomad := 0
nAlgaris1 := 0
nAlgaris2 := 0
For nEv := 1 To Len(aMulti)
	nAlgaris1 := Val(aMulti[nEv])
	nSomad      := nSomad + nAlgaris1 // + nAlgarism2 
	
Next nC
    
nDigb:= 11 - Mod(nSomad,11) 
/* 
nSomad      := nSomad * 10       //akiii
If Mod(nSomad,11)== 1 .or. Mod(nSomad,11)== 0 .or. Mod(nSomad,11)== 10
     nDigb := 1
  Else
nDigb := Mod(nSomad,11)
EndIf
*/
Return(str(nDigb,1,0))


/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ AjustaSx1    ณ Autor ณ Microsiga            	ณ Data ณ 13/10/03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica/cria SX1 a partir de matriz para verificacao          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para 
s Microsiga                    	  		ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next


Static function LimpaFlag()

DbSelectArea("SE1")
DbSetOrder(1)
DbSeek(xFilial("SE1")+MV_PAR01+MV_PAR03,.T. )

ProcRegua(RecCount())

While SE1->(!Eof()) .And. SE1->E1_NUM <= MV_PAR04
	
	IncProc("Limpando Flag.." )
	
	Reclock("SE1",.F.)
	SE1->E1_OK := Space(2)
	MsUnlock()
	DbSkip()
End

Return
