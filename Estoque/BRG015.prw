#include 'protheus.ch'
#include 'parmtype.ch'

/*
Funcao      : Cadastro de Com
Objetivos   : AxCadastro da tabela ZAE
*/
*---------------------*
User Function BRG015()  //U_BRG015()
*---------------------*
Local   cOldArea := Select()
Local   cAlias    := "SD3"
Private cNDesm   := GETMV("MV_NDESMON") //numero sequencial de desmontagem 07/02/2023
Private nFCICalc := SuperGetMV("MV_FCICALC",.F.,0)
Private cCadastro := "Desmontagem De Produtos"
Private aRotina   :=  { { "Pesquisar" ,"AxPesqui"                          ,0,1},;
                      { "Visualizar"  ,'A242Visual'    					   ,0,2},;
                      { "Desmontar"   ,'ExecBlock("DesmProd",.F.,.F.)'     ,0,3},;                     
                      { "Estornar"    ,"AxAltera"                          ,0,4},;
                      { "Excluir"     ,"AxDeleta"                          ,0,5}}

//abre a tela de manutenção
MBrowse(,,,,cAlias,,,,,,)   

//volta pra area inicial
dbSelectArea(cOldArea)     
//
Return 

User Function DesmProd

Local btnCarrega
Local btnDesmon
Local btnCancel
Local grpdesm

Local lblProd
Local lblLocal
Local lblLote
Local lblQtd
Local lblEmis
Local lblOp
Local lblDesc
Local lblCusto

Local txtProd
Local txtLocal
Local txtQtd
Local txtOp

Private txtLote
Private txtEmis
Private txtCusto
Private txtDesc
Private _Local   := "28" //"28"
Private cOp      := space(11)
Private cLote    := space(20)
Private cProd    := space(15)
Private dEmis    := DDATABASE
Private cLocal   := space(02)
Private cCusto   := 0
Private cCustoD  := 0
Private cCustoG  := 0
Private cDescP   := space(40)
Private cValor   := 0
Private cQtd     := 0
Private aHeaderEx	 := {}
private aColsEx      := {}
private aFieldFill   := {}
private aFields      := {}
private aAlterFields := {}
private grdDados     := {}
Private wContext  	 := " "
Private wCBox     	 := " "
Private wRelacao  	 := " "
Private cxtVlRat     := 0 //:= M->Z42_VALOR
Private txtVlRat
Private lblVlRat
Private txtBar
Private lblBar
Static odlPrincipal

DEFINE MSDIALOG odlPrincipal TITLE "Desmontagem de Produtos" FROM -049, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

@ 005, 000 GROUP grpdesm TO 080, 500 PROMPT "Desmontagem" OF odlPrincipal COLOR 0, 16777215 PIXEL

@ 020, 010 SAY 		lblProd 	    PROMPT "Produto Origem"	    SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215	PIXEL
@ 018, 040 MSGET 	txtProd 	    VAR cProd  Valid ValDesc()  SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215 F3 "SB1" 	PIXEL  PICTURE '@!'
@ 020, 194 SAY 		lblLocal 		PROMPT "Local"              SIZE 015, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 018, 220 MSGET 	txtLocal	    VAR cLocal 				    SIZE 025, 010 OF odlPrincipal COLORS 0, 16777215 READONLY  	PIXEL
@ 035, 010 SAY 		lblDesc 		PROMPT "Descrição"          SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 033, 040 MSGET 	txtDesc	        VAR cDescP 	   			   	SIZE 140, 010 OF odlPrincipal COLORS 0, 16777215 READONLY  	PIXEL
@ 035, 194 SAY 		lblLote 	   	PROMPT "Lote"               SIZE 036, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 033, 220 MSGET 	txtLote 	   	VAR cLote 					SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 050, 010 SAY 		lblQtd 		    PROMPT "Quant" 				SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 048, 040 MSGET 	txtQtd 		    VAR cQtd  		            SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215    PIXEL Picture "@E 999,999,999.99"
@ 050, 194 SAY 		lblEmis 	    PROMPT "Data"               SIZE 045, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 048, 220 MSGET	txtEmis 		VAR dEmis	        	    SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215 READONLY  	PIXEL
@ 065, 010 SAY 		lblOp 	    	PROMPT "Ord Prod"           SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
@ 063, 040 MSGET	txtOp 		    VAR cOp Valid TotGerC()		SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215    PIXEL Picture "@E 99999999999"
@ 065, 194 SAY 		lblCusto 		PROMPT "Custo" 				SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 063, 220 MSGET 	txtCusto 		VAR cCusto   When .F.       SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215 READONLY   PIXEL Picture "@E 999,999,999.99"

//txtBar:SetFocus() // forca o foco nesta variavel
DadosRt()

txtDesc:disable()
txtLocal:disable()
txtEmis:disable()
txtCusto:disable()
//carregaGrid(strzero(i,8,0),cod,desc)@ 035, 330 MSGET oCodBarra VAR wCodBarra PICTURE "@!" Valid fVerBarra() SIZE 100, 015 OF oGroupBar COLORS 0, 16777215 PIXEL
@ 020, 350 BUTTON btnCarrega PROMPT "Carregar" SIZE 037, 012 OF odlPrincipal ACTION Processa({|| Carregar()},"Aguarde...")  PIXEL //oDlg:End()
@ 240, 400 BUTTON btnDesmon PROMPT "Desmontar" SIZE 037, 012 OF odlPrincipal ACTION Processa({|| Desmontar()},"Aguarde...")  PIXEL 
@ 240, 450 BUTTON btnCancel PROMPT "Cancelar" SIZE 037, 012 OF odlPrincipal ACTION (odlPrincipal:End()) PIXEL

ACTIVATE MSDIALOG odlPrincipal CENTERED

Return

Static Function DadosRt()

private nX := 0

Static odlPrincipal

aFields := {"dbProduto","dbUnd","dbLocal","dbDesc","dbQtd","dbLote","dbValidade","dbCusto","dbRateio"}

aAlterFields := {}

AADD(aHeaderEx,{"Codigo"    	,"dbProduto"    ,"@!"          		  , 20 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Und"    		,"dbUnd"    	,"@!"          		  , 05 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Local"         ,"dbLocal"      ,"@!"          		  , 05 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Descricao"     ,"dbDesc"   	,"@!"          		  , 40 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao }) 
AADD(aHeaderEx,{"Quantidade"    ,"dbQtd"        ,"@E 999,999,999.999" , 14 ,3 ,  ,"û"   ,"N",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Lote"          ,"dbLote"       ,"@!"				  , 20 ,0 ,  ,"û"   ,"C", 	     , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Validade"      ,"dbValidade"   ,"@!"				  , 15 ,0 ,  ,"û"   ,"D", 	     , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Custo"         ,"dbCusto"      ,"@E 999,999,999.99"  , 14 ,2 ,  ,"û"   ,"N",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Rateio(%)"     ,"dbRateio"     ,"@E 999.9999" 	      , 08 ,4 ,  ,"û"   ,"N",        , wContext ,wCBox, wRelacao })

//Limpa varivaeis da grid
aFieldFill := {}
aColsEx    := {}

//Chama função para montar a grid  /074
grdDados  := MsNewGetDados():New( 080, 001, 220, 500, GD_INSERT + GD_UPDATE + GD_DELETE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 9999, "AllwaysTrue", "", "AllwaysTrue", odlPrincipal, @aHeaderEx, @aColsEx)
Return


//-----------------------------------------------
//Função para preencher grid na tela
//-----------------------------------------------

Static Function Carregar()

Local cDesc   := " " 
Local _QtdExt := 0
Local _VlrExt := 0 
Local _Text := ""
Local _Desc := ""
Local _SomaP :=  0
Local _Dif  :=  0
 
If Empty(cProd) .or. Empty(cLote) .or. cQtd = 0 .or. Empty(cOp)
   MSGINFO("Por favor Informar dados do Cabeçalho !!!"," Atenção ")  
   Return
EndIf

If Select("QSD3") > 0
   QSD3->(DbCloseArea())
EndIf

ccQry := " "
ccQry += "SELECT  D3_FILIAL,  D3_OP, D3_COD, D3_UM, D3_LOTECTL, D3_DTVALID, SUM(D3_QUANT) QUANT, SUM(D3_CUSTO1) CUSTO  "
ccQry += "FROM " + retsqlname("SD3")+" SD3 "
ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
ccQry += "AND  D3_CF IN ('RE6','RE0') "    
ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
ccQry += "AND  D3_ESTORNO <> 'S' "  	 
ccQry += "AND  D3_OP = '" + cOp + "' "
ccQry += "GROUP BY  D3_FILIAL,  D3_OP, D3_COD, D3_UM, D3_LOTECTL,D3_DTVALID" 
ccQry += "ORDER BY D3_FILIAL, D3_COD " 
	
DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"QSD3",.T.,.T.) 

If len(aColsEx) > 0
  MSGINFO("Itens já foram carregado, Por favor Desmontar ou Sair !!!!"," Atenção ") 
  Return
End


DO WHILE !QSD3->( EOF() )
    DbSelectArea("SB9")
    DbSetOrder(1)
    If !DbSeek(xFilial("SB9")+QSD3->D3_COD+_Local) 
       _Desc := POSICIONE("SB1",1,XFILIAL("SB1")+QSD3->D3_COD,"B1_DESC")   
       _Text += "Produto: "+QSD3->D3_COD+ " Descrição: "+_Desc + Chr(13) + Chr(10)
    EndIf      
       QSD3->(dbSkip())
ENDDO
//alert("Marlon")
If !empty(_Text)
   AVISO("Itens sem Local 28", _Text, {"Fechar"}, 2)
   Return
EndIf

DbSelectArea("QSD3")
DBGOTOP()
DO WHILE !QSD3->( EOF() )

/*
  DBGOTOP()
  DbSelectArea("SB9")
  DbSetOrder(1)
  If !DbSeek(xFilial("SB9")+QSD3->D3_COD+_Local)
     RECLOCK("SB9",.T.)
     SB9->B9_FILIAL  := xFilial("SB9")
     SB9->B9_COD     := ALLTRIM(QSD3->D3_COD) //
     SB9->B9_LOCAL   := _Local
     SB9->B9_DATA    := Ddatabase
     MSUNLOCK()
  EndIf	
 */ 
	cDesc  := POSICIONE("SB1",1,XFILIAL("SB1")+QSD3->D3_COD,"B1_DESC")	
	DevExt()
	
	DO WHILE !TSD3->( EOF() )
	   If QSD3->D3_OP = TSD3->D3_OP .and. QSD3->D3_COD = TSD3->D3_COD .and. QSD3->D3_UM = TSD3->D3_UM .and. QSD3->D3_LOTECTL = TSD3->D3_LOTECTL 
	      _QtdExt := TSD3->D3_QUANT  
	      _VlrExt := TSD3->D3_CUSTO1
	      TSD3->( dbSkip())	
	   Endif
	ENDDO	
	If (QSD3->QUANT-_QtdExt) >0 	 
	  Aadd(aColsEx, {QSD3->D3_COD,QSD3->D3_UM,_Local,cDesc,(QSD3->QUANT-_QtdExt),QSD3->D3_LOTECTL,QSD3->D3_DTVALID,(QSD3->CUSTO-_VlrExt),round(((QSD3->CUSTO-_VlrExt)*100)/CustGer(),4),.F.})
	EndIf                //1          //2       //3   //4           //5                 //6             //7                   //8                      //9
	
	_QtdExt := 0
	_VlrExt := 0
	
	_SomaP  := _SomaP + round(((QSD3->CUSTO-_VlrExt)*100)/CustGer(),4)
	QSD3->( dbSkip())	
ENDDO
//Valida a Diferença de Casas Decimais na Porcentagem inicio
If _SomaP > 100
   _Dif := _SomaP - 100
   aColsEx[1,9] = aColsEx[1,9] - _Dif
End
//Valida a Diferença de Casas Decimais na Porcentagem Fim
//Alert("teste")
grdDados:SetArray(aColsEx,.T.)
grdDados:Refresh()
Return


Static Function CustGer()
//Verifica se o arquivo TMP está em uso

Local _Custo := ""
	If Select("TSDD") > 0
	   TSDD->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
	ccQry += "AND  D3_CF IN ('RE6','RE0') "     
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "  	 
	ccQry += "AND  D3_OP = '" + cOp+ "' "
	ccQry += "GROUP BY D3_FILIAL " 	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TSDD",.T.,.T.) 
	
	_Custo := TSDD->Custo1
	
Return _Custo

//Retorna a Descrição do Produto de Origem

Static Function ValDesc()

Local _ret  := .T.
lOCAL cTipo := ""

DbSelectArea("SB1")
DbSetOrder(1)
If !DbSeek(xFilial("SB1")+cProd)
   _ret := .F.
    MSGINFO("Codigo Inexistente !!!"," Atenção ")  
Else
   cDescP  := POSICIONE("SB1",1,XFILIAL("SB1")+cProd,"B1_DESC")
   //cTipo   := POSICIONE("SB1",1,XFILIAL("SB1")+cProd,"B1_TIPO")
   cLocal   := "28"

   grdDados:Refresh()
   odlPrincipal:Refresh()
EndIf


Return .T.

//Retorna o Custo do Produto de Origem
Static Function TotGerC()
//Verifica se o arquivo TMP está em uso

//Custo de requisição
	If Select("TTMP") > 0
	   TTMP->(DbCloseArea())
	EndIf
	ccQry := " "
	ccQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo1 "
	ccQry += "FROM " + retsqlname("SD3")+" SD3 "
	ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
	ccQry += "AND  D3_CF IN ('RE6','RE0') "	    
	ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	ccQry += "AND  D3_ESTORNO <> 'S' "  	 
	ccQry += "AND  D3_OP = '" + cOp + " ' "
	ccQry += "GROUP BY D3_FILIAL "
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTMP",.T.,.T.) 
	
	cCustoG := TTMP->Custo1
	
//custo de Retorno 
	
	If Select("TCCC") > 0
	   TCCC->(DbCloseArea())
	EndIf
	cQry := " "
	cQry += "SELECT D3_FILIAL,SUM(D3_CUSTO1) Custo2 "
	cQry += "FROM " + retsqlname("SD3")+" SD3 "
	cQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
	cQry += "AND  D3_TM IN ('499','001') "      
	cQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
	cQry += "AND  D3_ESTORNO <> 'S' "  	 
	cQry += "AND  D3_OP = '" + cOp + " ' "
	cQry += "GROUP BY D3_FILIAL " 
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TCCC",.T.,.T.) 
	
	cCustoD := TCCC->Custo2
	
	//Requisição - Retorno
	cCusto := TTMP->Custo1 - TCCC->Custo2
	
	grdDados:Refresh()
	odlPrincipal:Refresh()
	
Return .T.

Static Function Desmontar()

Local j := 1
Local aAutoCab := {}
Local aAutoItens := {}
//Local _cNumDoc   := "503005929" //GETSXENUM("SD3","D3_DOC",NIL) 
Local _ProxDoc := ""
Private lMsErroAuto := .F.

If len(grdDados:aCols) = 1
 MSGINFO("Por favor Carregar os Itens !!!!"," Atenção ") 
 Return
EndIF
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0101" Modulo "EST" tables "SD3"

_ProxDoc := GetMV("MV_NDESMON") //aLTERADO A MANEIRA 07/02/2023

//_ProxDoc := ProxDoc()  

//Alert("Teste")
 
aAutoCab := {   {"cProduto"     , cProd                  , Nil},;
                  {"cLocOrig"   , cLocal                 , Nil},;
                  {"nQtdOrig"   , cQtd                   , Nil},;           
                  {"nQtdOrigSe" , CriaVar("D3_QTSEGUM")  , Nil},;           
                  {"cDocumento" , _ProxDoc				 , Nil},;          
                  {"cNumLote"   , CriaVar("D3_NUMLOTE")  , Nil},;           
                  {"cLoteDigi"  , cLote  				 , Nil},;           
                  {"dDtValid"   , CriaVar("D3_DTVALID")  , Nil},;           
                  {"nPotencia"  , CriaVar("D3_POTENCI")  , Nil},;           
                  {"cLocaliza"  , CriaVar("D3_LOCALIZ")  , Nil},;           
                  {"cNumSerie"  , CriaVar("D3_NUMSERI")  , Nil}}

For j := 1 to len(grdDados:aCols)
	
    If Empty(ACOLSEX[j,6])  //.and. ACOLSEX[j,8] = 0
       aadd(aAutoItens,{{"D3_COD"    , ACOLSEX[j,1] 	, Nil}, ;
			{"D3_LOCAL"  , ACOLSEX[j,3]				, Nil}, ;
			{"D3_QUANT"  , ACOLSEX[j,5]				, Nil}, ;
			{"D3_QTSEGUM", 0						, Nil}, ;
			{"D3_RATEIO" , ACOLSEX[j,9]			    , Nil}, ;
			{"D3_CUSTO1" , ACOLSEX[j,8]      		, Nil}})
	Else
	   aadd(aAutoItens,{{"D3_COD"    , ACOLSEX[j,1] 	, Nil}, ;
			{"D3_LOCAL"  , ACOLSEX[j,3]				, Nil}, ;
			{"D3_QUANT"  , ACOLSEX[j,5]				, Nil}, ;
			{"D3_QTSEGUM", 0						, Nil}, ;
			{"D3_RATEIO" , ACOLSEX[j,9]    , Nil}, ;
			{"D3_LOTECTL", ACOLSEX[j,6]      		, Nil}, ;
			{"D3_DTVALID", STOD(ACOLSEX[j,7])   	, Nil}, ;
			{"D3_CUSTO1" , ACOLSEX[j,8]      		, Nil}})	
	EndIf					
Next j
              
MSExecAuto({|v,x,y,z| Mata242(v,x,y,z)},aAutoCab,aAutoItens,3,.T.)
 
If lMsErroAuto  
   Mostraerro()
Else
   MSGINFO("Op Desmontada - Documento:" + _ProxDoc+" ","Atenção - Verifique Arquivos")
   _ProxDoc := "DES"+strzero(val(SUBSTR(_ProxDoc,4,6))+1,6)
   PutMV("MV_NDESMON",_ProxDoc)   //Alterado dia 07/02/2023 tirei para não usar viua Query STatic Function Proximo ricardo 
EndIf

odlPrincipal:End()
//RESET ENVIRONMENT
 
Return

//Retorna o ultimo numero do documento na SD3  Static function desabilitada 07/02/2023 - Erro no sequencial numerico , agora feito por parametro
/*
Static Function ProxDoc() //U_ProxDoc   

Local _num := " " 

If Select("TMP5") > 0
	TMP5->(DbCloseArea())
EndIf  

cQry := " "
cQry += "SELECT MAX(D3_DOC) DOC "
cQry += "FROM " + retsqlname("SD3")+" SD3 "
cQry += "WHERE SD3.D_E_L_E_T_ <> '*' "
cQry += "AND D3_DOC <> 'INVENT' "
cQry += "AND D3_FILIAL = '" + cFilAnt + "' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP5",.T.,.T.) 

_num := strzero((val(TMP5->DOC)) + 1,9) 

Return _num     
*/
//Desconta os itens Devolvidos e Extornados
//04/02/2020

Static Function DevExt() //U_DevExt   

If Select("TSD3") > 0
	TSD3->(DbCloseArea())
EndIf  

cQry := " "
cQry += "SELECT * "
cQry += "FROM " + retsqlname("SD3")+" SD3 "
cQry += "WHERE SD3.D_E_L_E_T_ <> '*' "
cQry += "AND D3_TM IN ('499','001') "  
cQry += "AND D3_FILIAL = '" + cFilAnt + "' "
cQry += "AND D3_COD = '" + QSD3->D3_COD + "' "
cQry += "AND D3_UM = '" + QSD3->D3_UM + "' "
cQry += "AND D3_LOTECTL = '" + QSD3->D3_LOTECTL + "' "
cQry += "AND D3_OP = '" + cOp+ "' "
cQry += "ORDER BY D3_FILIAL, D3_COD,D3_TM, D3_LOTECTL " 

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TSD3",.T.,.T.) 

Return      
