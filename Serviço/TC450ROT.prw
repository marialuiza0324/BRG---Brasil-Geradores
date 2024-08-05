#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TC450ROT º Autor ³ Ricardo Moreira   º Data ³  29/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍ¹±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime Ordem de Serviço 					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BRG                               			              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TC450ROT() 

Local aRotAdic:= {}        
    aAdd(aRotAdic, { 'Impressão OS','U_ImpOs', 0 , 2} )
	aAdd(aRotAdic, { 'Gera Pedido','U_GEROSPED', 0 , 2} )   

Return aRotAdic 

User Function GEROSPED()

processa({|| _gerapd()})

RETURN


User Function ImpOs()

	Local aArea   			:= GetArea()
	Local aOrd  			:= {}
	Local cDesc1 			:= "Este programa tem como objetivo imprimir OS "
	Local cDesc2 			:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3 			:= ""
    
	Private nomeprog 		:= "IMPOS"
	Private cPerg    		:= "IMPOS"
//aReturn[4] 1- Retrato, 2- Paisagem
//aReturn[5] 1- Em Disco, 2- Via Spool, 3- Direto na Porta, 4- Email
	Private aReturn  		:= {"Zebrado", 1,"Administracao", 1, 1, "1", "",1 }	//"Zebrado"###"Administracao"
	Private nTamanho		:= "M"
	Private wnrel        	:= "IMPOS"            //Nome Default do relatorio em Disco
	Private cString     	:= "AB6"
	Private titulo  := "Ordem de Serviço"
	Private nPage			:= 1
	Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
	Private oFont6N 	:= TFONT():New("ARIAL",7,6,,.T.,,,,.T.,.F.) ///Fonte 6 Negrito
	Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
	Private oFont8N 	:= TFONT():New("ARIAL",8,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
	Private oFont10    	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 10 Normal
	Private oFont10S	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.T.) ///Fonte 10 Sublinhando
	Private oFont10N 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.F.) ///Fonte 10 Negrito
	Private oFont12		:= TFONT():New("Courier new",12,12,,.F.,,,,.T.,.F.) ///Fonte 12 Normal
	Private oFont12NS	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.T.) ///Fonte 12 Negrito e Sublinhado
	Private oFont12N	:= TFONT():New("Courier new",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito
	Private oFont14		:= TFONT():New("ARIAL",14,14,,.F.,,,,.T.,.F.) ///Fonte 14 Normal
	Private oFont14NS	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.T.) ///Fonte 14 Negrito e Sublinhado
	Private oFont14N	:= TFONT():New("Courier new",14,14,,.T.,,,,.T.,.F.) ///Fonte 14 Negrito
	Private oFont16  	:= TFONT():New("ARIAL",16,16,,.F.,,,,.T.,.F.) ///Fonte 16 Normal
	Private oFont16N	:= TFONT():New("Courier new",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
	Private oFont16NS	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.T.) ///Fonte 16 Negrito e Sublinhado
	Private oFont20N	:= TFONT():New("ARIAL",20,20,,.T.,,,,.T.,.F.) ///Fonte 20 Negrito
	Private oFont22N	:= TFONT():New("ARIAL",22,22,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito
	Private nLin 			:= 0
	Private wTotal			:= 0
	Private NumOs := AB6->AB6_NUMOS
	Public _oPrint                
	Private cLogoD
	Private  cStartPath := GETPVPROFSTRING(GETENVSERVER(),"StartPath","ERROR",GETADV97())
         cStartPath += IF(RIGHT(cStartPath,1) <> "\","\","")
	//   cLogoD     := cStartPath + "LGRL" + cFilAnt + ".IBMP"
         cLogoD     :=  "\system\DANFE01" + cFilAnt+ ".bmp"
      
   	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho )

	nOrdem :=  aReturn[8]
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
		//_oPrint:Setup()
		oPrint:SetPortrait()
	   //	If oPrint:nLogPixelY() < 300
		 //	MsgInfo("Impressora com baixa resolução o modo de compatibilidade será acionado!")
		  //	oPrint:SetCurrentPrinterInUse()
		//EndIf
	//Chama função para buscar dados
	   	Dados()
 	If Select("QAB6") > 0	
		QAB6->(DbGoTop()) 	//Posiciona no inicio do arquivo
    EndIf
		//Chama função para imprimir dados
			getHeader(@nPage)
		//quebraDePg(@nLin,@nPage)
	   //-------	endif
	//footer(@nLin) //Rodape
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
		//while !QSD3->(eof())                                    
			Local nLi := 0 
			Local _Total := 0          

  			cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
			cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")
   			nLin+=100
  			//oPrint:Box(550, 200, 500, 2000)    //ALTURA/    /      / LARGURA
  			
   			nLin+=100  
   			oPrint:Line(nLin,110,nLin,2350)
   			oPrint:SayBitmap(250, 260,cLogoD , 300, 220)	///Impressao da Logo   
			nLin+=50
			oPrint:Say(nLin, 1850,DTOC(DDATABASE), oFont10)
			oPrint:Say(nLin, 2050, TIME(), oFont10)
   
			nLin+=50
			oPrint:Say(nLin,750, SUBSTR(SM0->M0_NOMECOM,1,50), oFont12N)
			nLin+=50
			oPrint:Say(nLin,750, ALLTRIM(SM0->M0_ENDCOB), oFont10N)
			oPrint:Say(nLin,1600, ALLTRIM(SM0->M0_CIDCOB) +"-"+ALLTRIM(SM0->M0_ESTCOB), oFont10N)
			nLin+=50
			oPrint:Say(nLin, 750, TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont10N)
			nLin+=70
			oPrint:Line(nLin,110,nLin,2350)		
			nLin+=100
   		       	   	
			oPrint:Say(nLin, 700, ("O R D E M  D E  S E R V I Ç O "), oFont16N)
    
			nLin+=150
			oPrint:Say(nLin,110, "N. OS.:", oFont8N)   //250
			oPrint:Say(nLin,360,alltrim(QAB6->AB6_NUMOS), oFont8)   //500
			oPrint:Say(nLin,560,"Data Emissão:", oFont8N)
			oPrint:Say(nLin,850,CVALTOCHAR(STOD(QAB6->AB6_EMISSA)), oFont8)					
			oPrint:Say(nLin,1220,"Emitido por:", oFont8N)
			oPrint:Say(nLin,1500,CUSERNAME, oFont8N) 
			
	    	nLin+=50        
       		oPrint:Say(nLin,110,"Cliente:", oFont8N)
			oPrint:Say(nLin,360,alltrim(QAB6->AB6_CODCLI)+"/"+alltrim(QAB6->AB6_LOJA)+" - "+alltrim(QAB6->A1_NOME), oFont8)   //500 
			nLin+=100  
			oPrint:Say(nLin,110,"Produto:", oFont8N)
			oPrint:Say(nLin,360,alltrim(QAB6->AB7_CODPRO)+" - "+alltrim(QAB6->B1_DESC), oFont8)   //500 
			nLin+=50 
			oPrint:Say(nLin,110,"Ocorrência:", oFont8N)
			oPrint:Say(nLin,360,alltrim(QAB6->AB7_CODPRB)+"-"+alltrim(QAB6->AAG_DESCRI), oFont8)   //500 
			nLin+=50 
			oPrint:Line(nLin,110,nLin,2350) //2300        
			nLin+=100 
			Dados1()
			oPrint:Say(nLin,110,"Item", oFont8N)   
	        oPrint:Say(nLin,250,"Produto/Eqto", oFont8N)   
	        oPrint:Say(nLin,450,"Descrição", oFont8N)   
	        oPrint:Say(nLin,1050,"Serviço/Descrição", oFont8N)  
	        oPrint:Say(nLin,1600,"Quant", oFont8N)   
	        oPrint:Say(nLin,1900,"Vlr Unit", oFont8N) 
	        oPrint:Say(nLin,2200,"Valor Total", oFont8N) 
	       	nLin+=100  
			dbSelectArea("QAB8")
   			QAB8->(dbgotop())
  		    //dbSeek(xFilial("SBF")+SC6->C6_PRODUTO+SC6->C6_LOCAL+SC6->C6_LOTECTL)                                                                                          47000   > 19000
	         While QAB8->(!EOF()) .AND. xFilial("AB8") = QAB8->AB8_FILIAL .AND. NumOs = QAB8->AB8_NUMOS  
	         
		       	oPrint:Say(nLin, 110, QAB8->AB8_SUBITE, oFont8)   //VER 
            	oPrint:Say(nLin, 250, QAB8->AB8_CODPRO , oFont8) 
   				oPrint:Say(nLin, 450, QAB8->B1_DESC, oFont8)
   				oPrint:Say(nLin, 1050, QAB8->AB8_CODSER+"/"+QAB8->AA5_DESCRI, oFont8) // VER 		
   				oPrint:Say(nLin, 1650, Transform(QAB8->AB8_QUANT, "@e 999,999,999.99"), oFont8,,,,1)   //VER 
   				oPrint:Say(nLin, 1950, Transform(QAB8->AB8_VUNIT, "@e 999,999,999.99"), oFont8,,,,1)   //VER 
   				oPrint:Say(nLin, 2250, Transform(QAB8->AB8_TOTAL, "@e 999,999,999.99"), oFont8,,,,1)   //VER 
				nLin+=50 
				_Total := _Total + QAB8->AB8_TOTAL 
				
   				If nLin >= 2500 // veja o tamanho adequado da página que este numero pode variar
					oPrint:EndPage() // Finaliza a página
					oPrint:StartPage()
					nLin := 200
	  			Endif 

   				QAB8->( dbSkip() )
   	      Enddo 
   	      	nLin+=50 
			oPrint:Say(nLin,300,("Total Geral ->"), oFont8N)
			oPrint:Say(nLin,450, TRANSFORM(_Total,"@R 999,999,999.99"), oFont8) 
			
			nLin+=100
			oPrint:Say(nLin,1450,"_________________________", oFont8N)
			nLin+=50
			oPrint:Say(nLin,1520,"Supervisor", oFont8N)
			
			/*
			nLin+=50
			oPrint:Say(nLin,150,"R$ " + TRANSFORM((SE2->E2_SALDO+SE2->E2_ACRESC),"@R 999,999,999.99"), oFont12N)
			nLin+=50 
			//Extenso
			nValor := (SE2->E2_SALDO+SE2->E2_ACRESC)
			// Gera o extenso do valor, formatando a variavel com
			// 100 caracteres preenchendo os espacos em branco com *
			cExtenso := PADR(Extenso(nValor),150,"*")
			// Imprime o extenso em duas linhas (50 caracteres em cada):
			For nLi := 20 To 21
				oPrint:Say(nLin,165,Substr(cExtenso,(nLi-20)*75+1,75), oFont12N) 
				nLin+=50 
			   //@nLi,10 Say Substr(cExtenso,(nLi-20)*50+1,50)
			Next nLi

			nLin+=50			
		
		    //_CONDF1:=Posicione("SF1",1,xFilial("SF1")+SE2->E2_PREFIXO+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA,"F1_COND") 			
			//_CONDE2:= Posicione("SE4",1,xFilial("SE4")+_CONDF1,"E4_DESCRI")                                                                               
			
			oPrint:Say(nLin,110, "Prazo:", oFont12N)			
		   	oPrint:Say(nLin,380,RetConPG(), oFont12N)   //500 
		   	oPrint:Say(nLin,1220, "Solicitação:", oFont12N)			
		   	oPrint:Say(nLin,1600,RetSc(), oFont12N)		   	
		   	nLin+=80
			oPrint:Line(nLin,150,nLin,2000) //2300
			nLin+=50
			oPrint:Say(nLin,110, "Fornecedor:", oFont12N)
		   	oPrint:Say(nLin,400,alltrim(SE2->E2_FORNECE)+"/"+alltrim(SE2->E2_LOJA)+" - "+alltrim(SE2->E2_NOMFOR), oFont12N)   //500
			//oPrint:Say(nLin,850,"Ordem de Produção:", oFont12N)
			//oPrint:Say(nLin,1600,"Dt Emissão OP:", oFont12N)    	 //Produo e Descrição
			nLin+=50
		        
			nLin+=50
			oPrint:Line(nLin,150,nLin,2000)   
			nLin+=50                    
			
			oPrint:Say(nLin,110, "Histórico:", oFont12N)
		   	oPrint:Say(nLin,380,SE2->E2_HIST, oFont12N)   //500
			
			nLin+=150
		                
			oPrint:Say(nLin, 130, ("_____________________"), oFont12)
			oPrint:Say(nLin, 890, ("_____________________"), oFont12) 
			oPrint:Say(nLin, 1580,("_____________________"), oFont12)
			nLin+=70	 		 		
	 		
			oPrint:Say(nLin, 110,  ("Total Geral ->"), oFont10N)
			oPrint:Say(nLin, 980,  ("Financ/Coordenação"), oFont10N)
			oPrint:Say(nLin, 1730, ("Diretoria"), oFont10N)
			nLin+=70
  		//QSD3->(dbskip())
	   //	EndDo
	   */
	Return Nil  
	
	
//PharmaExprees
//Data: 09/11/2016
//Retorna a condicao de pagamento
//Autor: Ricardo Moreira                                        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca dados para tabela temporaria                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Static Function Dados()
//Verifica se o arquivo TMP está em uso
If Select("QAB6") > 0; QAB6->(DbCloseArea()); EndIf
   cQry := " "
   cQry += "SELECT DISTINCT AB6_NUMOS, AB6_EMISSA, AB6_HORA, AB6_STATUS,AB6_CODCLI,AB6_LOJA,A1_NOME,AB7_CODPRO, B1_DESC , AB7_CODPRB, AAG_DESCRI, AB7_MEMO1, YP_TEXTO "
   cQry += "FROM " + retsqlname("AB7")+" AB7 " 
   cQry += " INNER JOIN " + retsqlname("AB6")+" AB6 ON AB7_FILIAL = AB6_FILIAL AND AB7_NUMOS = AB6_NUMOS  AND AB6.D_E_L_E_T_ <> '*' "	
   cQry += " INNER JOIN " + retsqlname("SA1")+" SA1 ON AB7_CODCLI = A1_COD AND A1_LOJA = AB7_LOJA AND  SA1.D_E_L_E_T_ <> '*' "	
   cQry += " INNER JOIN " + retsqlname("SB1")+" SB1 ON AB7_CODPRO = B1_COD AND B1_FILIAL = '01'  AND SB1.D_E_L_E_T_ <> '*' "	
   cQry += " INNER JOIN " + retsqlname("AAG")+" AAG ON AB7_CODPRB = AAG_CODPRB AND AAG_FILIAL= '01' "
   cQry += " INNER JOIN " + retsqlname("SYP")+" SYP ON AB7_MEMO1 = YP_CHAVE AND SYP.D_E_L_E_T_ <> '*' "		
   cQry += "WHERE AB7.D_E_L_E_T_ <> '*' "
   cQry += "AND AB6_NUMOS = '" + NumOs + "' "		
   cQry += "ORDER BY AB6_NUMOS "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"QAB6",.T.,.T.)

Return Nil

 /*

//PharmaExprees
//Data: 09/11/2016
//Retorna a Solicitação de Compra
//Autor: Ricardo Moreira                                        

Static Function RetSc()    
                                                   
Private _Solic := " "

If Select("TMP3") > 0
	TMP3->(dbCloseArea())
EndIf

_cQry := " " 
_cQry += "SELECT C7_NUMSC NUMSC "  
_cQry += "FROM " + retsqlname("SD1")+" SD1 "
_cQry += " INNER JOIN " + retsqlname("SC7")+" SC7 ON C7_NUM = D1_PEDIDO "	
_cQry += "WHERE SD1.D_E_L_E_T_ <> '*' "  
_cQry += "AND SC7.D_E_L_E_T_ <> '*' "
_cQry += "AND SD1.D1_FILIAL= '" + SE2->E2_FILIAL + "' 
_cQry += "AND SD1.D1_SERIE= '" + SE2->E2_PREFIXO + "'
_cQry += "AND SD1.D1_DOC= '" + SE2->E2_NUM + "'
_cQry += "AND SD1.D1_FORNECE= '" + SE2->E2_FORNECE + "'
_cQry += "AND SD1.D1_LOJA= '" + SE2->E2_LOJA + "'

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP3"

dbselectarea("TMP3") 
	_Solic := TMP3->NUMSC

Return _Solic      
 
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca dados para tabela temporaria                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	Static Function Dados1()
//Verifica se o arquivo TMP está em uso
		If Select("QAB8") > 0; QAB8->(DbCloseArea()); EndIf
			cQry := " "
			cQry += "SELECT DISTINCT AB8_FILIAL,AB8_NUMOS, AB8_ITEM, AB8_SUBITE, AB8_CODPRO,B1_DESC, AB8_DESPRO, AB8_CODSER, AA5_DESCRI, AB8_QUANT, AB8_VUNIT, AB8_TOTAL "
			cQry += "FROM " + retsqlname("AB8")+" AB8 " 
			cQry += " INNER JOIN " + retsqlname("SB1")+" SB1 ON AB8_CODPRO = B1_COD AND B1_FILIAL = '01'  AND SB1.D_E_L_E_T_ <> '*' "	
			cQry += " INNER JOIN " + retsqlname("AA5")+" AA5 ON AB8_CODSER = AA5_CODSER AND AA5_FILIAL= '01' "		
			cQry += "WHERE AB8.D_E_L_E_T_ <> '*' "
		    cQry += "AND AB8_NUMOS = '" + NumOs + "' "		
			cQry += "ORDER BY AB8_NUMOS,AB8_SUBITE"

			DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"QAB8",.T.,.T.)
		Return Nil
 /*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera perguntas SX1                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		Static Function geraX1()
			Local aArea    := GetArea()
			Local aRegs    := {}
			Local i	       := 0
			Local j        := 0
			Local aHelpPor := {}
			Local aHelpSpa := {}
			Local aHelpEng := {}

			cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

			aAdd(aRegs,{cPerg,"01","Documento         ?","","","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SD3"})
			aAdd(aRegs,{cPerg,"02","Filial De         ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
			aAdd(aRegs,{cPerg,"03","Filial Ate        ?","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

			dbSelectArea("SX1")
			dbSetOrder(1)
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
			RestArea(aArea)
		Return
     
  */


//Return

//Gera o PEdido de Venda pelo EXECAUTO 06/12/2022

Static Function _gerapd()

procregua(1)

Local aHeader := {} // INFORMAÇÕES DO CABEÇALHO 
Local aItens  := {} // CONJUNTO DE LINHAS  
Local aLine   := {} // INFORMAÇÕES DA LINHA
Local n       := 1
Local cNome   := ""
Local  cOs    := AB6->AB6_NUMOS
Local  cClient:= AB6->AB6_CODCLI
Local  cLoja  := AB6->AB6_LOJA
Local cF4TES     := "501" 
Local nOpr       := 3  // NÚMERO DA OPERAÇÃO (INCLUSÃO)
Local lMsErroAuto    := .F.  

 cNome     := Posicione("SA1",1,cFilAnt+AB6->AB6_CODCLI+AB6->AB6_LOJA,"A1_NOME")  

If Select("TMP5") > 0
	TMP5->(DbCloseArea())
EndIf

cQry := " "
cQry += "SELECT DISTINCT ABG_FILIAL, ABG_NUMOS,ABG_CODPRO, ABG_QUANT,B2_CM1 " 
cQry += "FROM " + retsqlname("ABG")+" ABG "
cQry += "LEFT JOIN " + retsqlname("SB2") + " SB2 ON ABG_FILIAL = B2_FILIAL AND  ABG_CODPRO = B2_COD AND B2_LOCAL = '01' AND SB2.D_E_L_E_T_ <> '*'  " 
cQry += "WHERE ABG.D_E_L_E_T_ <> '*' " 
cQry += "AND ABG_FILIAL = '"+cfilant+"' " 
cQry += "AND ABG_NUMOS = '"+cOs+"' " 

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP5",.T.,.T.)

DbSelectArea("TMP5")
DBGOTOP()

 // DADOS DO CABEÇALHO
//AAdd(aHeader, {"C5_NUM", ProxSC5(), NIL}) // REMOVER PARA GERAÇÃO DE NUMERAÇÃO AUTOMÁTICA PELA ROTINA
AAdd(aHeader, {"C5_TIPO", "N", NIL})
AAdd(aHeader, {"C5_CLIENTE", cClient, NIL})
AAdd(aHeader, {"C5_LOJACLI", cLoja, NIL})
AAdd(aHeader, {"C5_XNOMECLI", cNome, NIL})
AAdd(aHeader, {"C5_CONDPAG", "002", NIL})  
AAdd(aHeader, {"C5_NATUREZ", "101010002", NIL})
AAdd(aHeader, {"C5_ORIGPED" , "GEROS", NIL})
AAdd(aHeader, {"C5_MENNOTA" , cOs , NIL})
     // DADOS DOS ITENS
		DO WHILE TMP5->(!EOF()) .AND. xFilial("ABG") = TMP5->ABG_FILIAL .AND. TMP5->ABG_NUMOS = cOs   
           
		   //ProcRegua(Reccount())
           //IncProc("Processando Nota de Remessa: "+TMP5->ZLC_NOTA)

			aLine := {}
			AAdd(aLine,{"C6_ITEM"    , cvaltochar(strzero(n,2)) 	           , Nil})
			AAdd(aLine,{"C6_PRODUTO" , TMP5->ABG_CODPRO			               , Nil})
			AAdd(aLine,{"C6_QTDVEN"  , TMP5->ABG_QUANT 				           , Nil})   
			AAdd(aLine,{"C6_PRUNIT"  , TMP5->B2_CM1 				           , Nil})    
			AAdd(aLine,{"C6_PRCVEN"  , TMP5->B2_CM1                            , Nil})    
			AAdd(aLine,{"C6_VALOR"   , ROUND((TMP5->B2_CM1*TMP5->ABG_QUANT),4)  , Nil})  
			AAdd(aLine,{"C6_TES"     , cF4TES      							   , Nil})
			AAdd(aItens, aLine)

		    TMP5->(DbSkip())
			n++
        EndDo
        //AAdd(aItems, aLine)
        MsExecAuto({|x, y, z| MATA410(x, y, z)}, aHeader, aItens, nOpr, .F.)

		// VALIDAÇÃO DE ERRO
        If (lMsErroAuto)
            MostraErro()
            // RollbackSX8() // REMOVER PARA GERAÇÃO DE NUMERAÇÃO AUTOMÁTICA PELA ROTINA

            ConOut(Repl("-", 80))
            ConOut(PadC("MATA410 automatic routine ended with error", 80))
            ConOut(PadC("Ended at: " + Time(), 80))
            ConOut(Repl("-", 80))
        Else
            // ConfirmSX8() // REMOVER PARA GERAÇÃO DE NUMERAÇÃO AUTOMÁTICA PELA ROTINA
			//DbSelectArea("ZLC")
	        //DbSetOrder(1)
	        //If DbSeek(xFilial("ZLC")+TMP5->ZLC_NOTA+TMP5->ZLC_SERIE+TMP5->ZLC_CLIENT+TMP5->ZLC_LOJA)
		    //////If !DbSeek(xFilial("ZAG")+item+CliFab+cGet1)
			   //RECLOCK("ZLC",.F.) 
			   //ZLC->ZLC_FATOK := "1"			 
			   //MSUNLOCK()
	        //EndIF
            ConOut(Repl("-", 80))
            ConOut(PadC("MATA410 automatic routine successfully ended", 80))
            ConOut(PadC("Ended at: " + Time(), 80))
            ConOut(Repl("-", 80))
			MsgInfo("Pedido Gerado: " + SC5->C5_NUM + " Gravado com sucesso!")
        EndIf

		

        //RestArea(aArea) // RESTAURAÇÃO DA ÁREA ANTERIOR
    //RPCClearEnv() // FECHAMENTO DE AMBIENTE (REMOVER SE EXECUTADO VIA SMARTCLIENT)
//Else 
  // ConOut(cMsgLog) 
//EndIf

Return
