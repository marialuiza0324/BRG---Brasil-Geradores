#INCLUDE "RWMAKE.CH"
#INCLUDE "Protheus.CH"
#INCLUDE "TopConn.CH"

User Function BltItau()

Local 	aCampos 	:= {{"E1_NOMCLI","Cliente","@!"},{"E1_PREFIXO","Prefixo","@!"},{"E1_NUM","Titulo","@!"},;
{"E1_PARCELA","Parcela","@!"},{"E1_SALDO","Valor","@E 9,999,999.99"},{"E1_VENCREA","Vencimento"}}       
Local 	nOpc 		:= 0
Local 	aMarked 	:= {}
Local 	aDesc 		:= {"Este programa imprime os boletos de","cobranca bancaria de acordo com","os parametros informados"}
Local 	lInverte 	:= .F.
Local 	cMarca		:= GetMark()
Local	aCpoBro		:= {{"E1_OK"     ,,          , "" }}
Local 	llOk		:= .T.

Private Exec    := .F.
Private cIndexName := ''
Private cIndexKey  := ''
Private cFilter    := ''
Private lMarca	   := .F.
Private aBMP       := {} //"\system\itau.bmp" //aBitMap

Tamanho  := "M"
titulo   := "Impressao de Boleto Itau"
cDesc1   := "Este programa destina-se a impressao do Boleto Itau."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.

aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

dbSelectArea("SE1")

cPerg     :="TBOL04"

CriaSX1(cPerg)

If !Pergunte (cPerg,.T.)
	Return
EndIF	

If nLastKey == 27
	Set Filter to
	Return
Endif

nOpc := 1

If nOpc == 1
      		
	DbSelectArea("SA6")
	SA6->(DbSetOrder(1))
	DbSelectArea("SEE")
	SEE->(DbSetOrder(1))
	
	cBanco  := mv_par15 //Codigo do Banco.
	cCodAge := mv_par16 //Codigo da agencia + o dígito.
	cCodCta := mv_par17 //Codigo da conta + o digito.	
	If SEE->(DbSeek(xFilial("SEE")+mv_par15+cCodAge+cCodCta+"001"))
		If SA6->(DbSeek(xFilial("SA6")+mv_par15+cCodAge+cCodCta))
			If "ITAU" $ SA6->A6_NOME
				If !Empty(SA6->A6_NUMBCO)
					cBanco := Alltrim(SA6->A6_NUMBCO)
				EndIf	
			Else
				llOk := .F.
				Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("O banco selecionado nos parâmetros não corresponde ao Banco do ITAU!"),{"OK"})
			EndIf
		Else
			llOk := .F.
			Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Banco não localizado"),{"OK"})
		EndIf
	Else
		llOk := .F.
		Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Não localizado banco no cadastro de parâmetros para envio"),{"OK"})
	EndIf
	
	If llOk 
		
		cCodAge := StrTran(cCodAge,"-")//SubStr(cCodAge,1,nlPosAge) //Codigo da agencia + o dígito.
		cCodCta := StrTran(cCodCta,"-")//SubStr(cCodCta,1,nlPosCta) //Codigo da conta + o digito.
		
		cIndexName	:= Criatrab(Nil,.F.)	
		cIndexKey	:= "E1_NUM+E1_PREFIXO+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
		
	   	cFilter		+= "E1_FILIAL == '"+xFilial("SE1")+"' .And. E1_SALDO>0 .And. "
		cFilter		+= "E1_PREFIXO >= '" + MV_PAR01 + "' .And. E1_PREFIXO <= '" + MV_PAR02 + "' .And. " 
		cFilter		+= "E1_NUM >= '" + MV_PAR03 + "' .And. E1_NUM <= '" + MV_PAR04 + "' .And."
		cFilter		+= "E1_PARCELA >= '" + MV_PAR05 + "' .And. E1_PARCELA <= '" + MV_PAR06 + "' .And. "
		If mv_par18 == 1 //ReImpressão
			cFilter		+= "!Empty(E1_NUMBCO) .And. Empty(E1_BAIXA) .And. "
		Else
			cFilter		+= "Empty(E1_NUMBCO) .And. "   
		EndIf
		cFilter		+= "E1_CLIENTE >= '" + MV_PAR07 + "' .And. E1_CLIENTE <= '" + MV_PAR08 + "' .And. "
		cFilter		+= "E1_LOJA >= '" + MV_PAR09 + "' .And. E1_LOJA <= '"+MV_PAR10+"' .And. "
		cFilter		+= "DTOS(E1_EMISSAO) >= '"+DTOS(mv_par11)+"' .and. DTOS(E1_EMISSAO) <= '"+DTOS(mv_par12)+"' .And. "
		cFilter		+= "DTOS(E1_VENCREA) >= '"+DTOS(mv_par13)+"' .and. DTOS(E1_VENCREA) <= '"+DTOS(mv_par14)+"' .And. "
		cFilter		+= "!(E1_TIPO$MVABATIM)"
		cFilter		+= " .AND. ALLTRIM(E1_TIPO) $ 'NF|FT' "
	
		IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")		
		dbSelectArea("SE1")
		SE1->(dbGoTop())
	
		aAreaSX3 := SX3->(GetArea())	
		SX3->(DbGoTop())
		If SX3->(DbSeek("SE1"))
			While SX3->(!EoF()) .AND. SX3->X3_ARQUIVO == "SE1"
				If	(x3uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .AND. Alltrim(SX3->X3_CAMPO) <> "E1_OK")
					aAdd(aCpoBro,{SX3->X3_CAMPO,,SX3->X3_TITULO,PesqPict("SE1", SX3->X3_CAMPO)})
				EndIf
				SX3->(DbSkip())
			EndDo
		EndIf	
		RestArea(aAreaSX3)
		
		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
	
		oMark := MsSelect():New("SE1","E1_OK",,aCpoBro,@lInverte,@cMarca,{17,10,160,340})
		oMark:oBrowse:lCanAllmark := .T.
		MarkInverte("SE1", cMarca, .T., oMark)
		oMark:oBrowse:bAllMark := { || MarkInverte("SE1", cMarca, .T., oMark)}
		@ 180,310 BMPBUTTON TYPE 01 ACTION( Processa({|lEnd| MontaRel()}), Close( oDlg ) )
		@ 180,280 BMPBUTTON TYPE 02 ACTION( lExec := .F.,Close( oDlg ) )
	
		ACTIVATE DIALOG oDlg CENTERED

		RetIndex("SE1")
		fErase(cIndexName+OrdBagExt())
	EndIf	
EndIf

Return Nil

Static Function MarkInverte(cAlias,cMarca,lTodos,oMark)

Local nReg := (cAlias)->(Recno())
Local lMarkTit := .T.
Local clMarca	:= "  "

If lMarca
	lMarca := .F.
Else
	lMarca 	:= .T.
	clMarca := cMarca
EndIf

DEFAULT lTodos  := .T.

dbSelectArea(cAlias)                       

If lTodos 
	dbGotop()
Endif

While (!lTodos .Or. !Eof()) 

	If (lTodos .And. (cAlias)->(MsRLock())) .Or. !lTodos

		If (cAlias)->(MsRLock()) 
			

			  RecLock(cAlias)
			  (cAlias)->E1_OK	:= clMarca
			  (cAlias)->(MsUnlock()) 


		Endif  
		
		If lTodos 
		
			(cAlias)->(dbSkip())  
			
		Endif
		
	EndIf	
	
Enddo

(cAlias)->(dbGoto(nReg))

oMark:oBrowse:Refresh(.t.)
Return Nil



Static Function MontaRel()//aMarked)

LOCAL oPrint
LOCAL n := 0

//ORIGINAL
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM              ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                                            ,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText  := {"Após o vencimento cobrar multa de R$ ",;
					"Mora Diaria de R$ ",;
					"Sujeito a Protesto apos 14 (quatorze) dias do vencimento"}

LOCAL _ImpRet := 0
LOCAL i            := 0
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0

//aAdd(aBMP,"\system\itau.bmp")


oPrint:= TMSPrinter():New( "Boleto Itau" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

DbSelectArea("SE1")
SE1->(dbGoTop())	
While SE1->(!EOF())

	IncProc()

	i := i + 1 

	If Marked("E1_OK")//aMarked[i]				         
	
		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)

		DbSelectArea("SE1")
		  
	  	aDadosBanco  := {"341-7"                           ,; //SA6->A6_COD [1]Numero do Banco
	                      "" 	            	                  ,; // [2]Nome do Banco
		                  SUBSTR(SA6->A6_AGENCIA, 1, 4)                        ,; // [3]Agência
	                      SUBSTR(SA6->A6_NUMCON,1,5),; // [4]Conta Corrente
	                      ALLTRIM(SA6->A6_DVCTA)    ,; // [5]Dígito da conta corrente
	                      "109"                                              		}// [6]Codigo da Carteira
	
		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      // [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      // [2]Código
			AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      // [3]Endereço
			AllTrim(SA1->A1_MUN )                            ,;      // [4]Cidade
			SA1->A1_EST                                      ,;      // [5]Estado
			SA1->A1_CEP                                      ,;      // [6]CEP
			SA1->A1_CGC										 }       // [7]CGC
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)              ,;   // [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]Código
			AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endereço
			AllTrim(SA1->A1_MUNC)	                             ,;   // [4]Cidade
			SA1->A1_ESTC	                                     ,;   // [5]Estado
			SA1->A1_CEPC                                        ,;   // [6]CEP
			SA1->A1_CGC										 }    // [7]CGC
		Endif
		            
		            
	   _nVlrAbat := 0
		dbSelectArea("SE5")
		dbSetOrder(7)
		dbSeek(xFilial()+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
		While !EOF() .And. SE5->E5_PREFIXO == SE1->E1_PREFIXO .And. SE5->E5_NUMERO == SE1->E1_NUM .And.;
		SE5->E5_PARCELA == SE1->E1_PARCELA .And. SE5->E5_TIPO == SE1->E1_TIPO
	                     
			If SE5->E5_DTDISPO >= SE1->E1_EMISSAO  
			If SE5->E5_MOTBX == "CMP"	
				iF AllTrim(SE5->E5_TIPODOC) == "ES"
					_nVlrAbat -= SE5->E5_VALOR
				Else
					_nVlrAbat += SE5->E5_VALOR
				EndIf	
			EndIf  
			EndIf
			dbSkip()		
	   EndDo
	   IF SE1->E1_VRETIRF > 10 
	      _ImpRet := SE1->E1_VRETIRF
	   Else
          _ImpRet := 0
	   EndIf  
	  
	    //_nVlrAbat   += SomaAbat(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA,"R", SE1->E1_MOEDA, dDataBase, SE1->E1_CLIENTE, SE1->E1_LOJA, xFilial("SE1", SE1->E1_FILORIG), dDataBase, SE1->E1_TIPO)
		_nVlrAbat   +=  SE1->E1_DECRESC + SE1->E1_INSS + SE1->E1_CSLL + SE1->E1_COFINS + SE1->E1_PIS +_ImpRet //+ SE1->E1_ISS    //E1_VALLIQ //SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		//SomaAbat(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, “R”, SE1->E1_MOEDA, dDataBase, SE1->E1_CLIENTE, SE1->E1_LOJA, xFilial("SE1", SE1->E1_FILORIG), dDataBase, SE1->E1_TIPO)          
		IF EMPTY(SE1->E1_NUMBCO)
		
			_cFaixa:= strzero(val(SEE->EE_FAXATU)+1,11)
					
		    DbSelectArea("SEE")
			RecLock("SEE",.f.)
			SEE->EE_FAXATU  := _cFaixa   // CONTA
			MsUnlock()
			_cNossoNum := _cFaixa //CB_RN_NN[3]+_cFaixa 
		    _cNossoNum := Right(_cNossoNum,8)
		Else
		    _cNossoNum  := SE1->E1_NUMBCO   //alterado não pegar o digito verificado da conta
	   	    // _cNossoNum := Substr(_cNossoNum,4,8)
	   	    _cNossoNum := Substr(_cNossoNum,1,8)
	
		ENDIF
	    
		_CDIGITO := Modulo10(aDadosBanco[3]+aDadosBanco[4]+"109"+_cNossoNum)
	    
	    DbSelectArea("SE1")

        CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],_cNossoNum,E1_SALDO+E1_ACRESC-_nVlrAbat,E1_VENCREA)     // ANTIGO --> (E1_VLCRUZ-_nVlrAbat)	
	
		aDadosTit    := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)						,;  // [1] Número do título
		E1_EMISSAO                              					,;  // [2] Data da emissão do título
		Date()                                  					,;  // [3] Data da emissão do boleto
		E1_VENCREA                               					,;  // [4] Data do vencimento
		E1_SALDO                     					            ,;  // [5] Valor do título
		CB_RN_NN[3]                             					,;  // [6] Nosso número (Ver fórmula para calculo)
		E1_PREFIXO                               					,;  // [7] Prefixo da NF
		E1_TIPO	                               					,;  // [8] Tipo do Titulo
		_nVlrAbat	                                          ,;  // [9] Valor do Abatimento
		E1_JUROS																,;	 // [10]Valor do Juros
		E1_DESCONT															,;
		E1_ACRESC}   // [11]Valor do Desconto
	
		If Empty(SE1->E1_NUMBCO) // .T. aMarked[i]
	
			//informacoes do banco
			DbSelectArea("SE1")
			RecLock("SE1",.f.)
			//_cNossoNum:=_cNossoNum+ALLTRIM(STR(_CDIGITO))
			//SE1->E1_NUMBCO  :=	_cNossoNum  
			SE1->E1_NUMBCO  :=	_cNossoNum+ALLTRIM(STR(_CDIGITO)) //CB_RN_NN[3]   // Nosso número (Ver fórmula para calculo) 
			SE1->E1_PORTADO := SA6->A6_COD
			SE1->E1_AGEDEP  :=	SA6->A6_AGENCIA 
			SE1->E1_CONTA   :=  SA6->A6_NUMCON 
			SE1->E1_SITUACA :=  "1"  				
			MsUnlock()
		Else
	       _cNossoNum := Substr(ALLTRIM(SE1->E1_NUMBCO),1,8) 	
	                                           
	    Endif
		Impress(oPrint,aBMP,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
		n := n + 1		
	EndIf
	SE1->(dbSkip())

EndDo
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return nil



Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)

LOCAL oFont8
LOCAL oFont10
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL i := 0
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2000,1900,2100,2300}
LOCAL aCoords7 := {2270,1900,2340,2300}
LOCAL aCoords8 := {2620,1900,2690,2300}
LOCAL oBrush

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

oPrint:StartPage()   // Inicia uma nova página

// Inicia aqui a alteracao para novo layout - RAI
oPrint:Line (0150,550,0050, 550)
oPrint:Line (0150,800,0050, 800)

aAdd(aBMP,"\system\itau.bmp")
//aAdd(aBMP,"\system\DANFE01" + cEmpAnt+ ".bmp")    

oPrint:SayBitmap(050, 120, aBMP[1], 300, 090)
//oPrint:Say  (0084,100,aDadosBanco[2],oFont10 )	// [2]Nome do Banco  //aBMP[1]
//oPrint:SayBitMap(0084,100,_aBitMap[1], 150,80)
//oPrint:SayBitmap(0084,100,aBMP,150, 80)
oPrint:Say  (0062,567,aDadosBanco[1],oFont16 )	// [1]Numero do Banco
oPrint:Say  (0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (0150,100,0150,2300)
oPrint:Say  (0150,100 ,"Beneficiário"                                        ,oFont8) // Cedente
oPrint:Say  (0200,100 ,aDadosEmp[1]                                 	,oFont10) //Nome + CNPJ
oPrint:Say  (0150,1060,"Agência/Código do Beneficiário"                         ,oFont8)
oPrint:Say  (0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
oPrint:Say  (0150,1510,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0200,1510,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (0250,100 ,"Pagador"                                         ,oFont8) // Sacado
oPrint:Say  (0300,100 ,SubStr(aDatSacado[1],1,40)                      ,oFont10)	//Nome
oPrint:Say  (0250,1060,"Vencimento"                                     ,oFont8)
oPrint:Say  (0300,1060,DTOC(aDadosTit[4])                               ,oFont10)
oPrint:Say  (0250,1510,"Valor do Documento"                          	,oFont8)
oPrint:Say  (0300,1550,AllTrim(Transform(aDadosTit[5]+aDadosTit[12]- aDadosTit[09],"@E 999,999,999.99"))   ,oFont10)
oPrint:Say  (0400,0100,"Recebi(emos) o bloqueto/título"                 ,oFont10)
oPrint:Say  (0450,0100,"com as características acima."             		,oFont10)
oPrint:Say  (0350,1060,"Data"                                           ,oFont8)
oPrint:Say  (0350,1410,"Assinatura"                                 	,oFont8)
oPrint:Say  (0450,1060,"Data"                                           ,oFont8)
oPrint:Say  (0450,1410,"Entregador"                                 	,oFont8)

oPrint:Line (0250, 100,0250,1900 )
oPrint:Line (0350, 100,0350,1900 )
oPrint:Line (0450,1050,0450,1900 ) //---
oPrint:Line (0550, 100,0550,2300 )

oPrint:Line (0550,1050,0150,1050 )
oPrint:Line (0550,1400,0350,1400 )
oPrint:Line (0350,1500,0150,1500 ) //--
oPrint:Line (0550,1900,0150,1900 )

oPrint:Say  (0150,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (0190,1910,"(  )Ausente"                                    ,oFont8)
oPrint:Say  (0230,1910,"(  )Não existe n?indicado"                  	,oFont8)
oPrint:Say  (0270,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (0310,1910,"(  )Não procurado"                              ,oFont8)
oPrint:Say  (0350,1910,"(  )Endereço insuficiente"                  	,oFont8)
oPrint:Say  (0390,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (0430,1910,"(  )Falecido"                                   ,oFont8)
oPrint:Say  (0470,1910,"(  )Outros(anotar no verso)"                  	,oFont8)

For i := 100 to 2300 step 50
	oPrint:Line( 0600, i, 0600, i+30)
Next i

oPrint:Line (0710,100,0710,2300)
oPrint:Line (0710,550,0610, 550)
oPrint:Line (0710,800,0610, 800)
oPrint:SayBitmap(0615, 120, aBMP[1], 300, 090)
//oPrint:Say  (0644,100,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
oPrint:Say  (0622,567,aDadosBanco[1],oFont16 )	// [1]Numero do Banco
oPrint:Say  (0644,1900,"Recibo do Sacado",oFont10)

oPrint:Line (0810,100,0810,2300 )
oPrint:Line (0910,100,0910,2300 )
oPrint:Line (0980,100,0980,2300 )
oPrint:Line (1050,100,1050,2300 )

oPrint:Line (0910,500,1050,500)
oPrint:Line (0980,750,1050,750)
oPrint:Line (0910,1000,1050,1000)
oPrint:Line (0910,1350,0980,1350)
oPrint:Line (0910,1550,1050,1550)

oPrint:Say  (0710,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (0750,100 ,"QUALQUER BANCO ATÉ A DATA DO VENCIMENTO"        ,oFont10)

oPrint:Say  (0710,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (0750,2010,DTOC(aDadosTit[4])                               ,oFont10)

oPrint:Say  (0810,100 ,"Beneficiário"                                        ,oFont8) // Cedente
oPrint:Say  (0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (0810,1910,"Agência/Código do Beneficiário"                         ,oFont8) // Agencia/Cedente
oPrint:Say  (0850,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (0940,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0940,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0910,1005,"Espécie Doc."                                   ,oFont8)

oPrint:Say  (0940,1050,"DM"										,oFont10) //Tipo do Titulo

oPrint:Say  (0910,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (0940,1455,"N"                                             ,oFont10)

oPrint:Say  (0910,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (0940,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

oPrint:Say  (0910,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (0940,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(_cNossoNum,1,8)+"-"+Alltrim(STR(_CDIGITO)),oFont10) // parei aqui nilton dias

oPrint:Say  (0980,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (1010,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (0980,1555,"Valor"                                          ,oFont8)

oPrint:Say  (0980,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (1010,2010,AllTrim(Transform(aDadosTit[5]+aDadosTit[12] - aDadosTit[09],"@E 999,999,999.99")),oFont10) // Alterado Ricardço 24/09/2020

oPrint:Say  (1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)

oPrint:Say (1150,0100,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]+aDadosTit[12]-aDadosTit[09])*0.02),"@E 99,999.99")),oFont10)
oPrint:Say (1200,0100,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]+aDadosTit[12]-aDadosTit[09])*0.0005),"@E 99,999.99")),oFont10)
oPrint:Say (1250,0100,aBolText[3],oFont10)

oPrint:Say  (1050,1910,"(-)Desconto/Abatimento"                         ,oFont8)   
//if aDadosTit[09] > 0.00
//		oPrint:Say  (1080,2010,AllTrim(Transform(aDadosTit[09],"@E 999,999,999.99")),oFont10) 
//endif		
oPrint:Say  (1120,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (1190,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (1260,1910,"(+)Outros Acréscimos"                           ,oFont8)
//oPrint:Say  (1290,2010,AllTrim(Transform(aDadosTit[12],"@E 999,999,999.99"))                        ,oFont8)

oPrint:Say  (1330,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (1400,100 ,"Pagador"                                         ,oFont8) // Sacado
oPrint:Say  (1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say  (1589,400 ,IIf(Len(Alltrim(aDatSacado[7]))=11,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),"CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99")),oFont10) // CGC
oPrint:Say  (1589,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(_cNossoNum,1,8)+"-"+Alltrim(STR(_CDIGITO))  ,oFont10)

oPrint:Say  (1605,100 ,"Pagador/Avalista"                               ,oFont8) // Sacador/Avalista
oPrint:Say  (1645,1500,"Autenticação Mecânica -"                        ,oFont8)

oPrint:Line (0710,1900,1400,1900 )
oPrint:Line (1120,1900,1120,2300 )
oPrint:Line (1190,1900,1190,2300 )
oPrint:Line (1260,1900,1260,2300 )
oPrint:Line (1330,1900,1330,2300 )
oPrint:Line (1400,100 ,1400,2300 )
oPrint:Line (1640,100 ,1640,2300 )

For i := 100 to 2300 step 50
	oPrint:Line( 1850, i, 1850, i+30)
Next i

// Encerra aqui a alteracao para o novo layout - RAI
oPrint:Line (2000,100,2000,2300)
oPrint:Line (2000,550,1900, 550)
oPrint:Line (2000,800,1900, 800)
oPrint:SayBitmap(1900, 120, aBMP[1], 300, 090)
//oPrint:Say  (1934,100,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
oPrint:Say  (1912,567,aDadosBanco[1],oFont16 )	// [1]Numero do Banco
oPrint:Say  (1934,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras

oPrint:Line (2100,100,2100,2300 )
oPrint:Line (2200,100,2200,2300 )
oPrint:Line (2270,100,2270,2300 )
oPrint:Line (2340,100,2340,2300 )

oPrint:Line (2200,500,2340,500)
oPrint:Line (2270,750,2340,750)
oPrint:Line (2200,1000,2340,1000)
oPrint:Line (2200,1350,2270,1350)
oPrint:Line (2200,1550,2340,1550)

oPrint:Say  (2000,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (2040,100 ,"QUALQUER BANCO ATÉ A DATA DO VENCIMENTO"        ,oFont10)

oPrint:Say  (2000,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (2040,2010,DTOC(aDadosTit[4])                               ,oFont10)

oPrint:Say  (2100,100 ,"Beneficiário"                                        ,oFont8)  // Cedente
oPrint:Say  (2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (2100,1910,"Agência/Código de Beneficiário"                         ,oFont8)  // Agencia / Codigo Cedente
oPrint:Say  (2140,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (2200,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (2230,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (2200,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (2230,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (2200,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (0940,1050,"DM"   										,oFont10) //Tipo do Titulo
//oPrint:Say  (2230,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo

oPrint:Say  (2200,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (2230,1455,"N"                                             ,oFont10)

oPrint:Say  (2200,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (2230,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

oPrint:Say  (2200,1910,"Nosso Número"                                   ,oFont8)

oPrint:Say  (2230,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(_cNossoNum,1,8)+"-"+Alltrim(STR(_CDIGITO)), oFont10)

oPrint:Say  (2270,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (2270,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (2300,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (2270,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (2300,805 ,"R$"                                             ,oFont10)

oPrint:Say  (2270,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (2270,1555,"Valor"                                          ,oFont8)

oPrint:Say  (2270,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (2300,2010,AllTrim(Transform(aDadosTit[5]+aDadosTit[12]- aDadosTit[09],"@E 999,999,999.99")),oFont10)

oPrint:Say  (2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)

oPrint:Say (2440,0100,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]+aDadosTit[12]-aDadosTit[09])*0.02),"@E 99,999.99")),oFont10)
oPrint:Say (2490,0100,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]+aDadosTit[12]-aDadosTit[09])*0.0005),"@E 99,999.99")),oFont10)
oPrint:Say (2540,0100,aBolText[3],oFont10)

oPrint:Say  (2340,1910,"(-)Desconto/Abatimento"                         ,oFont8)   
//if aDadosTit[09] > 0.00
		//oPrint:Say  (2380,2010,AllTrim(Transform(aDadosTit[09],"@E 999,999,999.99")),oFont10) 
//endif	
oPrint:Say  (2410,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (2480,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (2550,1910,"(+)Outros Acréscimos"                           ,oFont8)
//oPrint:Say  (2580,2010,AllTrim(Transform(aDadosTit[12],"@E 999,999,999.99"))                        ,oFont8)
oPrint:Say  (2620,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (2690,100 ,"Pagador"                                         ,oFont8)  // Sacado
oPrint:Say  (2720,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (2773,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (2826,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

oPrint:Say  (2879,400 ,IIf(Len(Alltrim(aDatSacado[7]))=11,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),"CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99")),oFont10) // CGC

oPrint:Say  (2879,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(_cNossoNum,1,8)+"-"+Alltrim(STR(_CDIGITO)), oFont10)

oPrint:Say  (2895,100 ,"Pagador/Avalista"                               ,oFont8)  // Sacador / Avalista
oPrint:Say  (2935,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (2935,1850,"Ficha de Compensação"                           ,oFont10)

oPrint:Line (2000,1900,2690,1900 )
oPrint:Line (2410,1900,2410,2300 )
oPrint:Line (2480,1900,2480,2300 )
oPrint:Line (2550,1900,2550,2300 )
oPrint:Line (2620,1900,2620,2300 )
oPrint:Line (2690,100 ,2690,2300 )

oPrint:Line (2930,100,2930,2300  )
       
MSBAR("INT25"  ,26.0,1.2,CB_RN_NN[1],oPrint,.F.,,,0.026,1.3,,,,.F.) // POSICIONAMENTO PARA IMPRESSORA HP 4250 
                                                                    // ALTERADO POR MAURICIO BARBOSA EM 01/01/08
oPrint:EndPage() // Finaliza a página

Return Nil

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±³Programa                                          ?Data           ³±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±³Descri‡…o ?IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?*/

Static Function Modulo10(cData)

LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End

Return(D)



Static Function Modulo11(cData)

LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End

Return(D)



Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)

LOCAL bldocnufinal := strzero(val(cNroDoc),8)
LOCAL blvalorfinal := strzero((nValor*100),10)     // antigo -> strzero(int(nValor*100),10)
LOCAL dvnn         := 0 //digito do nosso numero
LOCAL dvcb         := 0 //digito do codigo de barra
LOCAL dv           := 0 //digito verificador
LOCAL NN           := '' //nosso numero
LOCAL RN           := '' //
LOCAL CB           := '' //codigo de barra
LOCAL s            := ''
LOCAL _cfator      := strzero(1000 + (dVencto - ctod("22/02/25")),4)
LOCAL _cCart		:= "109"

//-------- Definicao do NOSSO NUMERO
s    :=  cAgencia + cConta + _cCart + bldocnufinal
dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
NN   := _cCart + bldocnufinal + '-' + AllTrim(Str(dvnn))

//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + _cfator + blvalorfinal + _cCart + bldocnufinal + AllTrim(Str(dvnn)) + cAgencia + cConta + cDacCC + '000'
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1: 
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

s    := cBanco + _cCart + SubStr(bldocnufinal,1,2)
dv   := modulo10(s)
RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '

// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

s    := SubStr(bldocnufinal, 3, 6) + AllTrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '

// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SubStr(cAgencia, 4, 1) + cConta + cDacCC + '000'
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '

// 	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + '  '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
RN   := RN + _cfator + StrZero((nValor * 100),14-Len(_cfator))  // antigo --> StrZero(Int(nValor * 100),14-Len(_cfator))

Return({CB,RN,NN})                  


	
Static Function ValidPerg(cPerg)

_sAlias := Alias()
	
aPergs := {}
	
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

	Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Numero","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Portador","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	Aadd(aPergs,{"Ate Portador","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	Aadd(aPergs,{"De Cliente","","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","CLI","","","",""})
	Aadd(aPergs,{"Ate Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","CLI","","","",""})
	Aadd(aPergs,{"De Loja","","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Loja","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Emissao","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Vencimento","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Reimpressao?","","","mv_chh","N",1,0,2,"C","","mv_par17","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","","",,,})

	AjustaSx1(CPERG,aPergs)

	
DBSelectArea(_sAlias)
	
Return


Static Function CriaSX1(cPerg)

	Local _sAlias 	:= Alias()
	Local aRegs 	:= {}
	Local i,j   
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	
	cPerg := PADR(cPerg,10)
	aAdd(aRegs,{cPerg,"01","De Prefixo     ?","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Ate Prefixo    ?","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","De Numero      ?","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Ate Numero     ?","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","De Parcela     ?","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Ate Parcela    ?","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","De Cliente     ?","","","mv_ch7","C",6,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(aRegs,{cPerg,"08","Ate Cliente    ?","","","mv_ch8","C",6,0,0,"G","","MV_PAR08","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(aRegs,{cPerg,"09","De Loja        ?","","","mv_ch9","C",2,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10","Ate Loja       ?","","","mv_cha","C",2,0,0,"G","","MV_PAR10","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"11","De Emissao     ?","","","mv_chb","D",8,0,0,"G","","MV_PAR11","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"12","Ate Emissao    ?","","","mv_chc","D",8,0,0,"G","","MV_PAR12","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"13","De Vencimento  ?","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"14","Ate Vencimento ?","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"15","Banco          ?","","","mv_chf","C",3,0,1,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	aAdd(aRegs,{cPerg,"16","Agencia        ?","","","mv_chg","C",5,0,1,"G","","MV_PAR16","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"17","Conta          ?","","","mv_chh","C",10,0,1,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"18","ReImpressão    ?","","","mv_chi","N",01,0,0,"C","","MV_PAR18","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)

Return


Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local cKey		:= ""
Local nJ		:= 0
Local nCondicao

cPerg := Padr(cPerg,10)

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
