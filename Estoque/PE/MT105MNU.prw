#include 'protheus.ch'
#include 'parmtype.ch'

//27/02/2020
//Adiciona um Menu na Rotina Solicitar
//Brg Geradores

user function MT105MNU()

aAdd(aRotina,{ "Doc Desmontado", "U_Documento)", 0 , 3, 0, .F.})
aAdd(aRotina,{ "Novo Termo Retirada", "U_Termo()", 0, 8, 0, .F.})

Return aRotina

//27/02/2020
//Tela para informar o número de Documento
//Brg Geradores


User Function Documento()
Local oButton1
Local oButton2
Private oGet1
Private oGet2
Private cGet2 := space(11)
Private oSay2
Private cGet1 := space(9)
Private oSay1
Static oDlg

// @ 012, 185 BUTTON oButton1 PROMPT "Fechar Estoque" SIZE 043, 012 OF oDlg ACTION Processa({|| ProgSbj()},"Aguarde...") PIXEL    //Processa({|| ProgSbj()},"Aguarde...")

  DEFINE MSDIALOG oDlg TITLE "Documento" FROM 000, 000  TO 200, 250 COLORS 0, 16777215 PIXEL

    @ 010, 025 SAY oSay1 PROMPT "Insira o Número do Documento" SIZE 080, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 022, 034 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 043, 030 SAY oSay2 PROMPT "Insira o Número da OP" SIZE 080, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 055, 034 MSGET oGet2 VAR cGet2 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL    
    @ 077, 029 BUTTON oButton1 PROMPT "Executar" SIZE 037, 012 OF oDlg ACTION Processa({|| Solic()},"Aguarde...") PIXEL
    @ 077, 078 BUTTON oButton2 PROMPT "Fechar" SIZE 037, 012 OF oDlg Action oDlg:End() PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return

//27/02/2020
//Rotina para Carregar os itens do Documento
//Brg Geradores

Static Function Solic()

Local btnDesmon
Local btnCancel
Local grpdesm
Local lblnSolic   //Ativo
Local lblSolic   //Ativo
Local lblEmis   //ATIVO
Local txtnSolic //Ativo
Local txtSolic //Ativo
Local txtEmis  //ativo
Private  item := "00" 
//Private item2 := "A"
Private cSolic   := cusername //space(25)  //aTIVO
Private cNSolic  := strzero(val(NSolic()) + 1,6) //space(06)   //ATIVO  strzero(_Nsa,6)
Private dEmis    := DDATABASE   //aTIVO
Private aHeaderEx	 := {}
private aColsEx      := {}
private aFieldFill   := {}
private aFields      := {}
private aAlterFields := {}
private grdDados     := {}
Private wContext  	 := " "
Private wCBox     	 := " "
Private wRelacao  	 := " "
Static odlPrincipal

If Empty(cGet1)
   MSGINFO("Por favor Informar o número do Documento !!!"," Atenção ")  
   Return
EndIf
 
DEFINE MSDIALOG odlPrincipal TITLE "Solicitação" FROM -049, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

@ 005, 000 GROUP grpdesm TO 050, 500 PROMPT "Solicitação" OF odlPrincipal COLOR 0, 16777215 PIXEL

@ 020, 010 SAY 		lblnSolic 	    PROMPT "Numero"	            SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215	PIXEL
@ 018, 040 MSGET 	txtnSolic 	    VAR cNSolic  				SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215    PIXEL 
@ 020, 194 SAY 		lblSolic 		PROMPT "Solicitante"        SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 018, 220 MSGET 	txtSolic	    VAR cSolic   				SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215  	PIXEL
@ 035, 010 SAY 		lblEmis 		PROMPT "Emissão"            SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 033, 040 MSGET 	txtEmis	        VAR dEmis 	   			   	SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215  	PIXEL

DadosSc()

txtnSolic:disable()
txtSolic:disable()
txtEmis:disable()

If Select("QSD3") > 0
   QSD3->(DbCloseArea())
EndIf

ccQry := " "
ccQry += "SELECT  D3_FILIAL,  D3_TM, D3_COD, B1_DESC, D3_LOCAL, D3_UM, D3_QUANT, D3_LOTECTL, D3_OP, D3_TIPO, D3_DOC,D3_OBS  "
ccQry += "FROM " + retsqlname("SD3")+" SD3 "
ccQry += "LEFT JOIN " + retsqlname("SB1") + " SB1 ON B1_COD = D3_COD  AND B1_FILIAL = '" + substr(cFilAnt,1,2) + "' AND SB1.D_E_L_E_T_ <> '*' "
ccQry += "LEFT JOIN " + retsqlname("SB2") + " SB2 ON B2_FILIAL = D3_FILIAL AND B2_COD = D3_COD AND B2_LOCAL = D3_LOCAL AND SB2.D_E_L_E_T_ <> '*' "
ccQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
ccQry += "AND  D3_CF = 'DE7' "    
ccQry += "AND  B2_QATU > 0 "    
ccQry += "AND  D3_FILIAL = '" + cFilAnt + "' "
ccQry += "AND  D3_DOC = '" + cGet1 + "' "
ccQry += "AND  D3_ESTORNO <> 'S' "  	 
ccQry += "ORDER BY D3_FILIAL, D3_COD, D3_LOTECTL " 
	
DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"QSD3",.T.,.T.) 

DbSelectArea("QSD3")
DBGOTOP()
DO WHILE !QSD3->( EOF() )
   
	//item := strzero((val(item) + 1),2)
	item := SOMA1(item)
      			 
	Aadd(aColsEx, {item,QSD3->D3_COD,QSD3->D3_UM,QSD3->D3_LOCAL,QSD3->B1_DESC,QSD3->D3_QUANT,QSD3->D3_LOTECTL,cGet2,QSD3->D3_OBS,.F.})
		
	QSD3->( dbSkip())	
ENDDO

grdDados:SetArray(aColsEx,.T.)
grdDados:Refresh()

@ 240, 400 BUTTON btnDesmon PROMPT "Processar" SIZE 037, 012 OF odlPrincipal ACTION Processa({|| Processar()},"Aguarde...")  PIXEL 
@ 240, 450 BUTTON btnCancel PROMPT "Cancelar" SIZE 037, 012 OF odlPrincipal ACTION (odlPrincipal:End()) PIXEL

ACTIVATE MSDIALOG odlPrincipal CENTERED

Return

//27/02/2020
//Cria a Grid
//Brg Geradores


Static Function DadosSc()

private nX := 0

Static odlPrincipal

aFields := {"dbItem","dbProduto","dbUnd","dbLocal","dbDesc","dbQtd","dbLote","dbOrd","dbObs"}

aAlterFields := {}

AADD(aHeaderEx,{"Item"    	    ,"dbItem"       ,"@!"          		  , 02 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Codigo"    	,"dbProduto"    ,"@!"          		  , 20 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Und"    		,"dbUnd"    	,"@!"          		  , 05 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Local"         ,"dbLocal"      ,"@!"          		  , 05 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Descricao"     ,"dbDesc"   	,"@!"          		  , 40 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao }) 
AADD(aHeaderEx,{"Quantidade"    ,"dbQtd"        ,"@E 999,999,999.999" , 14 ,3 ,  ,"û"   ,"N",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Lote"          ,"dbLote"       ,"@!"				  , 20 ,0 ,  ,"û"   ,"C", 	     , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Ord Prod"      ,"dbOrd"        ,"@!"				  , 11 ,0 ,  ,"û"   ,"C", 	     , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Observação"    ,"dbObs"   	    ,"@!"          		  , 40 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })

//Limpa varivaeis da grid
aFieldFill := {}
aColsEx    := {}

//Chama função para montar a grid  /074
grdDados  := MsNewGetDados():New( 050, 001, 220, 500, GD_INSERT + GD_UPDATE + GD_DELETE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 9999, "AllwaysTrue", "", "AllwaysTrue", odlPrincipal, @aHeaderEx, @aColsEx)
Return

//27/02/2020
//Cria a Grid
//Brg Geradores



Static Function processar()

Local j := 1
Local aAutoCab := {}
Local aAutoItens := {}
//Local _cNumDoc   := "503005929" //GETSXENUM("SD3","D3_DOC",NIL) 
Private lMsErroAuto := .F.

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0101" Modulo "EST" tables "SD3"

aAutoCab := {   {"CP_FILIAL"   , cFilAnt          , Nil},;  
				{"CP_NUM"      , cNSolic          , Nil},;                            
                {"CP_EMISSAO"  , dDatabase        , Nil},;
                {"CP_SOLICIT"  , cUserName        , Nil}}

For  j := 1 to len(grdDados:aCols)    
   aadd(aAutoItens,{{"CP_ITEM"    , ACOLSEX[j,1]  , Nil},;
		{"CP_PRODUTO"  , ACOLSEX[j,2]			  , Nil},;
		{"CP_QUANT"    , ACOLSEX[j,6]			  , Nil},;
		{"CP_OP"       , cGet2					  , Nil},;
		{"CP_LOCAL"    , ACOLSEX[j,4]			  , Nil}})		 				
Next j
              
MSExecAuto({|x,y,z| Mata105(x,y,z)},aAutoCab,aAutoItens,3,.T.)
 
If lMsErroAuto  
    Mostraerro()
EndIf

MSGINFO("Solicitação Incluida: " + cNSolic+" ","Atenção - Verifique Arquivos")

odlPrincipal:End()
oDlg:End()
//RESET ENVIRONMENT
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ RetNSol   º Autor ³ Ricardo Moreira    º Data ³ 26/04/2017 º±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna o Número da Proxima Solicitação a ser gravada      o±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function NSolic()
//Verifica se o arquivo TMP está em uso

Local _Num := ""
If Select("QTMP") > 0
	QTMP->(DbCloseArea())
EndIf
_cQry := " "
_cQry += "SELECT TOP 1 CP_NUM "
_cQry += "FROM " + retsqlname("SCP")+" SCP "
_cQry += "WHERE SCP.D_E_L_E_T_ <> '*' "
_cQry += "AND CP_FILIAL = '" + cFilAnt + "' "
_cQry += "ORDER BY CP_NUM DESC "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"QTMP",.T.,.T.)

_Num:= QTMP->CP_NUM

Return _Num




