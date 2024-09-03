#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "topconn.ch"

//06/04/2020
//Adiciona um Menu na Rotina Baixa de Solicitação
//Brg Geradores


User function MTA185MNU()

aAdd(aRotina,{ "Novo Termo Retirada", "U_Termo()", 0,8,0, NIL})

Return aRotina

//06/04/2020
//Imprime o Termo de Retirada
//Brg Geradores


User function Termo()

Local _aBmp := {}
Local _user := "" 
Local _CpNum := ""
Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
Private oFont6N 	:= TFONT():New("ARIAL",7,6,,.T.,,,,.T.,.F.) ///Fonte 6 Negrito
Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
Private oFont8N 	:= TFONT():New("ARIAL",8,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
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
Private cPerg       := PADR("Termo",Len(SX1->X1_GRUPO))
Private cStartPath
Private nLin 		:= 0
Private oPrint		:= TMSPRINTER():New("")
Private nPag		:= 1
Private _Emp
Private nRepita // variavel que controla a quantidade de relatorios impressos
Private nContador // contador do for principal, que imprime o relatorio n vezes
Private nZ
Private nJ
Private cLogoD  

ValidPerg1()
pergunte(cPerg,.T.)    // sem tela de pergunta  

//Private _SomSbf := 0
//Private  cStartPath := GETPVPROFSTRING(GETENVSERVER(),"StartPath","ERROR",GETADV97())
//cStartPath += IF(RIGHT(cStartPath,1) <> "\","\","")
//         cLogoD     := cStartPath + "LGRL" + cFilAnt + ".BMP"
//cLogoD     :=  "LGRL" + cEmpAnt+ ".BMP"

//³Define Tamanho do Papel                                                  ³

#define DMPAPER_A4 9 //Papel A4
oPrint:setPaperSize( DMPAPER_A4 )

//oPrint:SetPortrait()///Define a orientacao da impressao como retrato
oPrint:SetLandscape() ///Define a orientacao da impressao como paisagem
//³Monta Query com os dados que serão impressos no relatório            ³

oPrint:StartPage()
cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")  

aAdd(_aBmp,"\system\DANFE01" + cFilAnt+ ".bmp")  

   	If Select("TMP") > 0
	   TMP->(dbCloseArea())
	EndIf
    
    _CpNum := StrTran(alltrim(MV_PAR01),",","','") 
	_cQry := " " 
	_cQry += "SELECT  CP_FILIAL , CP_NUM, CP_ITEM, CP_NUMOS, CP_PRODUTO, CP_DESCRI, CP_XENDERE, CP_UM, CP_QUANT, CP_OP, CP_LOCAL, CP_LOTE, CP_OBS, CP_EMISSAO, CP_SOLICIT "  
	_cQry += "FROM " + retsqlname("SCP")+" SCP "
	_cQry += "WHERE SCP.D_E_L_E_T_ <> '*' "
	_cQry += "AND CP_FILIAL = '" +xFilial("SCP") + "'  
	_cQry += "AND CP_NUM IN ('" + _CpNum  + "') "
   	_cQry += "ORDER BY CP_FILIAL, CP_SOLICIT,CP_NUM, CP_PRODUTO  "
     
	_cQry := ChangeQuery(_cQry)
	TcQuery _cQry New Alias "TMP"   	
   	
	dbSelectArea("TMP")
	dbgotop()    
	While TMP->(!EOF())
	  
	  oPrint:StartPage()
	
	  nLin+=100
	  oPrint:SayBitmap(nLin+010, 0160, _aBmp[1], 350, 220)			
         
	  nLin+=50
	//	oPrint:Say(nLin, 2100, "Pagina: " + strzero(nPag,3), oFont8N)
	  oPrint:Say(nLin, 1500,  ("T E R M O  D E  R E T I R A D A"), oFont14NS)

	  nLin+=200
 
	  oPrint:Say(nLin, 50,   ("Nr. S. A."), oFont8)
	  oPrint:Say(nLin, 250,   ("Solicitante"), oFont8)
	  oPrint:Say(nLin, 600,  ("Nr. OS"), oFont8)
	  oPrint:Say(nLin, 800,  ("Item"), oFont8)
	  oPrint:Say(nLin, 900,  ("Produto"), oFont8)
	  oPrint:Say(nLin, 1200, ("Descrição"), oFont8)
	  oPrint:Say(nLin, 1800, ("Local"), oFont8)
	  oPrint:Say(nLin, 1950, ("Quantidade"), oFont8)
	  oPrint:Say(nLin, 2250, ("Und"), oFont8)
	  oPrint:Say(nLin, 2350, ("Endereço"), oFont8)
	  oPrint:Say(nLin, 2620, ("Ord. Produção"), oFont8)  
	  oPrint:Say(nLin, 2920, ("N. Lote"), oFont8)  
	  oPrint:Say(nLin, 3150, ("Dt. Emissão"), oFont8)
	   nLin+=100
	  _user := TMP->CP_SOLICIT  
	
	     While TMP->(!EOF()) .AND. _user = TMP->CP_SOLICIT    
	
	        oPrint:Say(nLin, 0060, TMP->CP_NUM , oFont8N) 
		    oPrint:Say(nLin, 0260, TMP->CP_SOLICIT , oFont8N) 
		    oPrint:Say(nLin, 0610, TMP->CP_NUMOS , oFont8N) 
		    oPrint:Say(nLin, 0810, TMP->CP_ITEM , oFont8N) 
		    oPrint:Say(nLin, 0910, TMP->CP_PRODUTO , oFont8N) 
		    oPrint:Say(nLin, 1210, TMP->CP_DESCRI , oFont8N) 
		    oPrint:Say(nLin, 1810, TMP->CP_LOCAL , oFont8N) 		
            oPrint:Say(nLin, 1960, Transform(TMP->CP_QUANT, "@e 999,999,999.999"), oFont8N)   //VER 
            oPrint:Say(nLin, 2260, TMP->CP_UM , oFont8N) 
   		    oPrint:Say(nLin, 2360, TMP->CP_XENDERE, oFont8N)
   		    oPrint:Say(nLin, 2630, TMP->CP_OP, oFont8N)  	
   		    oPrint:Say(nLin, 2930, TMP->CP_LOTE, oFont8N)  
   		    oPrint:Say(nLin, 3150, CVALTOCHAR(STOD(TMP->CP_EMISSAO)), oFont8N)  
   		    //oPrint:Say(nLin, 3560, TMP->CP_OBS, oFont8N)  	
		    nLin+=50
		    If nLin >= 2500 // veja o tamanho adequado da página que este numero pode variar
			   oPrint:EndPage() // Finaliza a página
			   oPrint:StartPage()
	     	   nLin := 200
	  	    Endif   	     
		    
   		  TMP->( dbSkip() )
   	     Enddo
   	     
   	     nLin+=100
   	     oPrint:Say(nLin, 2300,  ("_________________________________________"), oFont10N)
   	     oPrint:Say(nLin, 500, alltrim(sm0->m0_cidcob)+","+str(day(DDATABASE))+" de "+	mesextenso(month(DDATABASE))+" de "+str(year(DDATABASE)), oFont10N)

   	     nLin+=70
   	     oPrint:Say(nLin, 2500, ("Solicitante"), oFont10N)  
   	     nLin+=70
   	       	      
		 oPrint:EndPage() // Finaliza a página
		 
	     nLin := 0
	  	   	      
   	Enddo 
   	nLin+=70 
   	

//oPrint:endPage()
	MS_FLUSH()
oPrint:Preview() 
Return()


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

aAdd(aRegs,{cPerg,"01","Nr. S. A. De     ?","","","mv_ch1","C",45,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"02","Nr. S. A. Ate    ?","","","mv_ch2","C",06,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})


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
			AADD(aHelpPor,"Informe a(s) Solicitação(ões).             ")								
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return 


