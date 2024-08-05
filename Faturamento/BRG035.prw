#Include "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 

/*
Funcao      : Cadastro de de Regras Contabilização
Objetivos   : AxCadastro da tabela ZCL
*/
*---------------------*
User Function BRG035()  //U_BRG035()
*---------------------*
Local   cOldArea := Select()
//Local   cFilter := ""
Local   aArea	 := GetArea()
Local   cAlias    := "ZLC"
Local aArea   := GetArea() // ARMAZENA ÁREA CORRENTE
Private aCores :=  {{'EMPTY(ZLC_FATOK)', 'BR_VERDE'},;
{'!EMPTY(ZLC_FATOK)', "BR_AMARELO"},;  
{'!EMPTY(ZLC_NOTRET)', 'BR_VERMELHO'}}

Private cCadastro := "Controle de Locação"
             
 Private aRotina   := {{ "Gera Fatura" ,'ExecBlock("chGerFat",.F.,.F.)'     ,0,2},;
					  { "Itens"        ,'ExecBlock("VItens",.F.,.F.)'       ,0,2},;
					  { "Relatório"    ,'ExecBlock("BRG037",.F.,.F.)'       ,0,5},;  
					  { "Pesquisar"    ,"AxPesqui"                          ,0,6},;					                     
                      { "Legenda"      ,'ExecBlock("LegDev",.F.,.F.)'       ,0,6}} 

//cFilter := "D2_CF ='5908'"
//abre a tela de manutenção
//MBrowse(,,,,cAlias,,,,,,)   
mBrowse( 6,1,22,75,cAlias,,,,,, aCores,,,,,,,,)

//volta pra area inicial
dbSelectArea(cOldArea) 
RestArea(aArea) // RESTAURAÇÃO DA ÁREA ANTERIOR
Return 

//Legenda - Inicio
User function LegDev()

aLegenda := {{'BR_VERDE', "Fatura não Gerada"},;
{'BR_AMARELO', "Fatura Gerada"},;
{'BR_VERMELHO', "Devolvido"}}
BRWLEGENDA(cCadastro, "Legenda", aLegenda)

Return 

//Legenda - Fim

User function VItens()

Local nX := 0
Local i  := 0
Local cNum := ""
Local cSer := ""
Private  item := "01"
Private  CliFab := "F"
Private oSay1
Private oSay2
Private BtnCancelar
Private BtnSalvar
Private BtnCalcular
Private oGet1
Private cGet1 := ZLC->ZLC_NOTA   //nota
Private oGet2
Private cGet5 := ZLC->ZLC_SERIE   //SERIE
Private oGet5
Private dGet2 := ZLC->ZLC_EMIS   //EMISSAO
Private oGet3
Private cGet3 := ZLC->ZLC_CLIENT+"/"+ZLC->ZLC_LOJA   //
Private oGet4
Private dGet4 := POSICIONE("SA1",1,XFILIAL("SA1")+ZLC->ZLC_CLIENT+ZLC->ZLC_LOJA,"A1_NOME") 
Private aHeaderEx1 := {}
Private aColsEx1 := {}
Private oMSNewGe1 := {}
Static oDlg

DEFINE MSDIALOG oDlg TITLE "Remessa de Locação" FROM 000, 000  TO 400, 900 COLORS 0, 16777215 PIXEL

@ 010, 015 SAY oSay1 PROMPT "Nota Remessa" SIZE 022, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 009, 040 MSGET oGet1 VAR cGet1 SIZE 041, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
@ 010, 100 SAY oSay2 PROMPT "Emissão" SIZE 022, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 009, 135 MSGET oGet2 VAR dGet2 SIZE 041, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
@ 035, 015 SAY oSay3 PROMPT "Cliente" SIZE 035, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 034, 040 MSGET oGet3 VAR cGet3 SIZE 050, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
@ 035, 100 SAY oSay4 PROMPT "Nome" SIZE 030, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 034, 135 MSGET oGet4 VAR dGet4 SIZE 110, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL

//@ 009, 250 BUTTON BtnSalvar 	PROMPT "Salvar" 	SIZE 037, 012 OF oDlg ACTION Processa({|| salvar()},"Aguarde...") PIXEL
@ 009, 300 BUTTON BtnCancelar 	PROMPT "OK" 	SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL

fMSNewGe1()
   
DbSelectArea("ZLI")
DbSetOrder(1)  //ZLI_FILIAL+ZLI_NOTA+ZLI_SERIE+ZLI_ITEM+ZLI_PROD
If DbSeek(xFilial("ZLI")+cGet1+cGet5)
	cNum := ZLI->ZLI_NOTA
	cSer := ZLI->ZLI_SERIE
		
	WHILE cNum == ZLI->ZLI_NOTA .AND. ZLI->ZLI_SERIE == cSer 
		
		//For i := 1 To Len(aColsEx1)
			AADD(aColsEx1,Array(LEN(aHeaderEx1)+1))
			aColsEx1[LEN(aColsEx1),LEN(aHeaderEx1)+1]:=.F.  // 15 nao deletada
			//nX
			For nX := 1 To Len(aHeaderEx1)         //parou aki
				Do Case
					Case Trim(aHeaderEx1[nX][2]) == "dbItem"	// Especificação
						aColsEx1[LEN(aColsEx1)][nX] := ZLI->ZLI_ITEM
					Case Trim(aHeaderEx1[nX][2]) == "dbProd"	// Medio
						aColsEx1[LEN(aColsEx1)][nX] := ZLI->ZLI_PROD				   	
					Case Trim(aHeaderEx1[nX][2]) == "dbDesc"	// Minimo
						aColsEx1[LEN(aColsEx1)][nX] := ZLI->ZLI_DESCPR					
					Case Trim(aHeaderEx1[nX][2]) == "dbLote"	// Maximo
						aColsEx1[LEN(aColsEx1)][nX] := ZLI->ZLI_LOTE	
					Case Trim(aHeaderEx1[nX][2]) == "dbQuant"	// Verificado
						aColsEx1[LEN(aColsEx1)][nX] := ZLI->ZLI_QUANT
					Case Trim(aHeaderEx1[nX][2]) == "dbVlUnit"	// Verificado
						aColsEx1[LEN(aColsEx1)][nX] := ZLI->ZLI_VLRUNI		
					Case Trim(aHeaderEx1[nX][2]) == "dbVlTot"	// Verificado
						aColsEx1[LEN(aColsEx1)][nX] := ZLI->ZLI_VLRTOT					
				EndCase
		  	Next nX			
			ZLI->(DbSkip())
	   //Next i
	ENDDO
		
	oMSNewGe1:oBrowse:SetArray( aColsEx1 )
	oMSNewGe1:aCols := aColsEx1
	oMSNewGe1:oBrowse:Refresh(.T.)	
	
EndIf
//oGetDados:oBrowse:Refresh(.t.)
oMSNewGe1:refresh() 

ACTIVATE MSDIALOG oDlg CENTERED

Return

//------------------------------------------------
Static Function fMSNewGe1()
//------------------------------------------------
Local nX
Local aFields1 := {"dbItem","dbProd","dbDesc","dbLote","dbQuant","dbVlUnit","dbVlTot"}
Local aAlterFields1 := {}
Private wContext1  	 := " "
Private wCBox1     	 := " "
Private wRelacao1  	 := " "

AADD(aHeaderEx1,{"Item"             ,"dbItem"        ,"@!"            			 , 02 ,0 , ""   				   ,"û"   ,"C","XEP"   , wContext1 ,wCBox1, wRelacao1 })
AADD(aHeaderEx1,{"Produto"          ,"dbProd"        ,"@!"	                     , 15 ,0 , ""                      ,"û"   ,"C", 	   , wContext1 ,wCBox1, wRelacao1 })
AADD(aHeaderEx1,{"Descrição"        ,"dbDesc"        ,"@!"                       , 30 ,0 , ""                      ,"û"   ,"C", 	   , wContext1 ,wCBox1, wRelacao1 })
AADD(aHeaderEx1,{"Lote"             ,"dbLote"        ,"@!"	                     , 20 ,0 , ""                      ,"û"   ,"C", 	   , wContext1 ,wCBox1, wRelacao1 })
AADD(aHeaderEx1,{"Quant"       		,"dbQuant"       ,"@E 99,999,999.99"		 , 12 ,2 , ""                      ,"û"   ,"N", 	   , wContext1 ,wCBox1, wRelacao1 })
AADD(aHeaderEx1,{"Vlr Unit"         ,"dbVlUnit"      ,"@E 999,999,999.99"        , 14 ,2 , ""                      ,"û"   ,"N", 	   , wContext1 ,wCBox1, wRelacao1 })
AADD(aHeaderEx1,{"Vlr Total"        ,"dbVlTot"       ,"@E 999,999,999.99"        , 14 ,2 , ""                      ,"û"   ,"N", 	   , wContext1 ,wCBox1, wRelacao1 })

oMSNewGe1 := MsNewGetDados():New( 050, 003, 200, 450, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields1,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx1, aColsEx1)

Return


//-----------------------------------------------
//Função para GRAVAR NA TABELA ZAG
//-----------------------------------------------
/*
Static Function salvar()

Local  i := 0
Local  y := 0
//Local  item := " "
//Local  CliFab := "C"

//Grava Dados do cliente ou Fabricante

For i:= 1 to len(oMSNewGe1:aCols) 
	item := STRZERO(i,2)
	If !(oMSNewGe1:aCols[i] [Len(aHeaderEx1)+1])  //linha deletada
		DbSelectArea("ZAG")
		DbSetOrder(2)
		If !DbSeek(xFilial("ZAG")+cGet1+CliFab+item)
		//If !DbSeek(xFilial("ZAG")+item+CliFab+cGet1)
			RECLOCK("ZAG",.T.) 
			ZAG->ZAG_FILIAL := cFilant
			ZAG->ZAG_LOTE   := cGet1
			ZAG->ZAG_ITEM   := item
			ZAG->ZAG_CLIFAB := CliFab
			ZAG->ZAG_ESPEC  := oMSNewGe1:aCols[i,1]
			ZAG->ZAG_MAX    := oMSNewGe1:aCols[i,2]
			ZAG->ZAG_MINIM  := oMSNewGe1:aCols[i,3]
			ZAG->ZAG_MEDIO  := oMSNewGe1:aCols[i,4]			
			ZAG->ZAG_VERIF  := oMSNewGe1:aCols[i,5]
		ElseIf DbSeek(xFilial("ZAG")+cGet1+CliFab+item)
			RECLOCK("ZAG",.F.) 
			ZAG->ZAG_FILIAL := cFilant
			ZAG->ZAG_LOTE   := cGet1 
			ZAG->ZAG_ITEM   := item
			ZAG->ZAG_CLIFAB := CliFab
	   		ZAG->ZAG_ESPEC  := oMSNewGe1:aCols[i,1]
			ZAG->ZAG_MAX    := oMSNewGe1:aCols[i,2]
			ZAG->ZAG_MINIM  := oMSNewGe1:aCols[i,3]
			ZAG->ZAG_MEDIO  := oMSNewGe1:aCols[i,4]			
			ZAG->ZAG_VERIF  := oMSNewGe1:aCols[i,5]		 
		EndIf
		MSUNLOCK()
	EndIF
Next i

MsgInfo("Registros inseridos com sucesso!!!")
oDlg:End()
return
*/
//09/09/2020
//Valida a Digitação do Codigo da Especificação
//Perlen
/*
User Function ValEsp(campo)   

oMSNewGe1:aCols[n][1] := &(ReadVar()) 

DbSelectArea("ZES")
DbSetOrder(1)
If DbSeek(oMSNewGe1:aCols[n][1])
   oMSNewGe1:aCols[n][1] := ZES->ZES_DESC
Else
   MSGINFO("Especificação Inexistente !!"," Atenção ")
   Return .F.
EndIf 
    
Return .T.
*/
//Cria Automaticamente Pedidos de Venda para locação
//04/05/2021
//BRG Geradores

User Function chGerFat ()
Processa({|| u_GerFat()},"Aguarde...")

Return 

User Function GerFat()
 
//Local cDoc       := ""                                                                 // Número do Pedido de Vendas
//Local cA1Cod     := "000001"                                                           // Código do Cliente
//Local cA1Loja    := "01"                                                               // Loja do Cliente
Local cB1Cod     := ""                                                                 // Código do Produto
Local cF4TES     := "530"                                                                 // Código do TES
//Local cE4Codigo  := "001"                                                              // Código da Condição de Pagamento
Local cMsgLog    := ""
Local cFilSA1    := ""
Local cFilSB1    := ""
Local cFilSE4    := ""
Local cFilSF4    := ""
Local nCont      := 0
Local _aux       := 0
Local _QtdFat    := 0
Local aHeader := {} // INFORMAÇÕES DO CABEÇALHO 
Local aItens  := {} // CONJUNTO DE LINHAS  
Local aLine     := {} // INFORMAÇÕES DA LINHA
Local lOk        := .T.
Local nOpr       := 3  // NÚMERO DA OPERAÇÃO (INCLUSÃO)
Private cNF        := ""
Private cSer       := "" 
Private lMsErroAuto    := .F.
Private lAutoErrNoFile := .F.
 
//****************************************************************
//* Abertura do ambiente
//****************************************************************
//ConOut("Inicio: " + Time())
 
//ConOut(Repl("-",80))
//ConOut(PadC("Teste de inclusao / alteração / exclusão de 01 pedido de venda com 02 itens", 80))
 
//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4"
 
SA1->(dbSetOrder(1))
SB1->(dbSetOrder(1))
SE4->(dbSetOrder(1))
SF4->(dbSetOrder(1)) 

cFilSA1 := xFilial("SA1")
cFilSB1 := xFilial("SB1")
cFilSE4 := xFilial("SE4")
cFilSF4 := xFilial("SF4")
 
//****************************************************************
//* Verificacao do ambiente para teste
//****************************************************************
If cFilAnt = "0501"
   cB1Cod := "S0000032"
ElseIf cFilAnt = "0401"
   cB1Cod := "S0000017"
EndIf
 
If SB1->(! MsSeek(cFilSB1 + cB1Cod))
   cMsgLog += "Cadastrar o Produto: " + cB1Cod + CRLF
   lOk     := .F.
EndIf

If Select("TMP5") > 0
	TMP5->(DbCloseArea())
EndIf
cQry := " "
cQry += "SELECT DISTINCT ZLC_FILIAL, ZLC_PEDIDO, ZLC_NOTA, ZLC_SERIE, ZLC_CLIENT, ZLC_LOJA, ZLC_EMIS, ZLC_VALOR, C5_XNOMCLI, C5_TPDOC, C5_VLRFAT, ZLC_FATOK, "
cQry += " C5_NOTA,C5_SERIE, C5_TPPAGF, C5_CONDLOC, C5_VENCFAT, ZLC_NOTRET, ZLC_SERRET, ZLI_PROD,ZLI_ITEM,ZLI_QUANT, C6_VLRFAT "
cQry += "FROM " + retsqlname("ZLI")+" ZLI "
cQry += "LEFT JOIN " + retsqlname("SC5") + " SC5 ON ZLI_FILIAL = C5_FILIAL AND  ZLI_NOTA = C5_NOTA  AND ZLI_SERIE = C5_SERIE AND SC5.D_E_L_E_T_ <> '*'  "
cQry += "LEFT JOIN " + retsqlname("SC6") + " SC6 ON ZLI_FILIAL = C6_FILIAL AND  ZLI_NOTA = C6_NOTA  AND ZLI_SERIE = C6_SERIE AND ZLI_PROD = C6_PRODUTO AND ZLI_ITEM = C6_ITEM AND SC6.D_E_L_E_T_ <> '*'  "
cQry += "LEFT JOIN " + retsqlname("ZLC") + " ZLC ON  ZLC_FILIAL = ZLI_FILIAL	AND ZLC_NOTA = ZLI_NOTA AND ZLC_SERIE = ZLI_SERIE AND ZLC.D_E_L_E_T_ <> '*' "
cQry += "WHERE ZLI.D_E_L_E_T_ <> '*' "
cQry += "AND ZLC_EMIS > '20220101' " // teste
cQry += "AND ZLI_FILIAL = '"+cfilant+"' " 
//cQry += "AND ZLC_NOTA BETWEEN '000002251' AND '000002277' " // teste
cQry += "AND C6_VLRFAT > 0 " // SOMENTE OS Q TEM VALOR INSERIDO NO PEDIDO MARLON 13/06/2022
cQry += "AND ZLC_FATOK = '' "
cQry += "AND ZLI_NOTRET = '' " //Segundo a brenda quando tem nota de retorno não gera a fatura
cQry += "ORDER BY ZLC_FILIAL, ZLC_NOTA,ZLC_SERIE,ZLI_ITEM "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP5",.T.,.T.)

DbSelectArea("TMP5")
DBGOTOP()
DO WHILE TMP5->(!EOF())

 cNF    := TMP5->ZLC_NOTA
 cSer   := TMP5->ZLC_SERIE

 If ALLTRIM(TMP5->C5_TPPAGF) == "1" // Diario
    _aux := 30
 ElseIf ALLTRIM(TMP5->C5_TPPAGF) == "2" // Semanal
    _aux := 4  
 ElseIf ALLTRIM(TMP5->C5_TPPAGF) == "3" // Quinzenal
    _aux := 2 
 ElseIf ALLTRIM(TMP5->C5_TPPAGF) == "4" // Mensal
    _aux := 1 
 ElseIf ALLTRIM(TMP5->C5_TPPAGF) == "1" // Anual
    _aux := 0
EndIf		

 _QtdFat := QtdPed() //Executa a função para saber quantos pedidos de fatura foi gerado .

 If _QtdFat >= _aux
    TMP5->(dbSkip())
	LOOP 	
 EndIf

 If TMP5->C6_VLRFAT = 0  //Descarta os pedidos que não tem valor por item de fatura 13/06/2022
    nCont++ //Conta a quantidade de pedidos sem valor de fatura 13/06/2022
    TMP5->(dbSkip())
	LOOP 	
 EndIf

//IncProc("Criando ordem de produção") 
/*
If cFilAnt = "0501"   
   If TMP5->C5_TPDOC = 'F'
	  cF4TES := "530"
   ElseIf TMP5->C5_TPDOC = 'S'
	  cF4TES := "535"
   EndIf   
ElseIf cFilAnt = "0401" .AND. TMP5->C5_TPDOC = 'F'
   cF4TES := "530"
EndIf
*/
If SF4->(! MsSeek(cFilSF4 + cF4TES))
   cMsgLog += "Cadastrar o TES: " + cF4TES + CRLF
   lOk     := .F.
EndIf
  
//If SE4->(! MsSeek(cFilSE4 + TMP5->C5_CONDLOC))
  //cMsgLog += "Cadastrar a Condição de Pagamento: " + TMP5->C5_CONDLOC + CRLF
   //lOk     := .F.
//EndIf
 
If SA1->(! MsSeek(cFilSA1 + TMP5->ZLC_CLIENT + TMP5->ZLC_LOJA))
   cMsgLog += "Cadastrar o Cliente: " + TMP5->ZLC_CLIENT + " Loja: " + TMP5->ZLC_LOJA + CRLF
   lOk     := .F.
EndIf
 
If lOk
 
   // Neste RDMAKE (Exemplo), o mesmo número do Pedido de Venda é utilizado para a Rotina Automática (Modelos INCLUSÃO / ALTERAÇÃO e EXCLUSÃO).
   //cDoc := GetSxeNum("SC5", "C5_NUM")
 
   //****************************************************************
   //* Inclusao - INÍCIO
   //****************************************************************
   //Cabeçalho

   aCabec   := {}
   aItens  := {}
   aLinha   := {}

    // DADOS DO CABEÇALHO
        //AAdd(aHeader, {"C5_NUM", ProxSC5(), NIL}) // REMOVER PARA GERAÇÃO DE NUMERAÇÃO AUTOMÁTICA PELA ROTINA
        AAdd(aHeader, {"C5_TIPO", "N", NIL})
        AAdd(aHeader, {"C5_CLIENTE", TMP5->ZLC_CLIENT, NIL})
        AAdd(aHeader, {"C5_LOJACLI", TMP5->ZLC_LOJA, NIL})
        AAdd(aHeader, {"C5_CONDPAG", "002", NIL})  //C5_CONDLOC 
		AAdd(aHeader, {"C5_NATUREZ", "101010004", NIL})
		AAdd(aHeader, {"C5_NFREM"  , TMP5->C5_NOTA, NIL})  //CAMPOS QUE IDENTIFICA QUAL NOTA DE REMESSA É A FATURA
		AAdd(aHeader, {"C5_SERREM" , TMP5->C5_SERIE, NIL})
		AAdd(aHeader, {"C5_ORIGPED" , "BRG035", NIL})
		 
        // DADOS DOS ITENS

		DO WHILE TMP5->(!EOF()) .AND. xFilial("SC5") = TMP5->ZLC_FILIAL .AND. TMP5->ZLC_NOTA = cNF  .AND.  TMP5->ZLC_SERIE = cSer 
           
		   //ProcRegua(Reccount())
           //IncProc("Processando Nota de Remessa: "+TMP5->ZLC_NOTA)

			aLine := {}
			AAdd(aLine,{"C6_ITEM"    , TMP5->ZLI_ITEM 				  			                    , Nil})
			AAdd(aLine,{"C6_PRODUTO" , cB1Cod				                                        , Nil})
			AAdd(aLine,{"C6_QTDVEN"  , TMP5->ZLI_QUANT,						                        , Nil})   //4
			AAdd(aLine,{"C6_PRUNIT"  , ROUND(TMP5->C6_VLRFAT/TMP5->ZLI_QUANT,2)   				    , Nil})    //23333,3325
			AAdd(aLine,{"C6_PRCVEN"  , ROUND(TMP5->C6_VLRFAT/TMP5->ZLI_QUANT,2)                     , Nil})    
			AAdd(aLine,{"C6_VALOR"   , ROUND(TMP5->ZLI_QUANT*(TMP5->C6_VLRFAT/TMP5->ZLI_QUANT),2) 	, Nil})  //
			//AAdd(aLine,{"C6_VALOR"   , TMP5->C6_VLRFAT      					   , Nil}) //TMP5->C6_VLRFAT
			AAdd(aLine,{"C6_TES"     , cF4TES      							   , Nil})
			AAdd(aItens, aLine)

		    TMP5->(DbSkip())
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
        EndIf

        //RestArea(aArea) // RESTAURAÇÃO DA ÁREA ANTERIOR
    //RPCClearEnv() // FECHAMENTO DE AMBIENTE (REMOVER SE EXECUTADO VIA SMARTCLIENT)
Else 
   ConOut(cMsgLog) 
EndIf

//TMP5->(DbSkip())
EndDo

MSGINFO("Quantidade de pedidos sem Valor de fatura <b>"+cvaltochar(nCont)+"</b>!!!!"," Atenção ") // Aviso de qtd de PEdidos sem valor da fatura 13/06/2022
MSGINFO("Pedidos de Faturas Gerados !!!!"," Atenção ")  

Return 


//Contador de quantidade de faturas geradas para um determinada nota de remessa
//22/02/2022
//BRG GERADORES

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 22/02/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function QtdPed()  //YEAR(C5_EMISSAO) = YEAR(DDATABASE) AND MONTH(C5_EMISSAO) = YEAR(DDATABASE)

Local _Qtd := 0
Local _Mes := STRZERO(MONTH(DDATABASE),2) 
Local _Ano := STRZERO(YEAR(DDATABASE),4)  


If Select("TMP6") > 0
	TMP6->(DbCloseArea())
EndIf

cQry := " "
cQry += "SELECT COUNT(*) NCOUNT  " 
cQry += "FROM " + retsqlname("SC5")+" SC5 " 
cQry += "WHERE SC5.D_E_L_E_T_ <> '*' "
cQry += "AND C5_FILIAL = '"+cfilant+"' " 
cQry += "AND MONTH(C5_EMISSAO) = '"+_Mes+"' "  
cQry += "AND YEAR(C5_EMISSAO) = '"+_Ano+"' " 
cQry += "AND C5_NFREM IN ('"+ALLTRIM(cNF)+"') " // testecNF
cQry += "AND C5_SERREM = '"+cSer+"' " 

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP6",.T.,.T.)

_Qtd := TMP6->NCOUNT

Return _Qtd

//Retorna o proximo número de pedido de venda

Static Function ProxSC5() //U_ProxSC5()
 
Local _cNum := " "

If Select("QSC5") > 0
   QSC5->(DbCloseArea())
EndIf

cQry := " "
cQry += "SELECT TOP 1 C5_NUM "
cQry += "FROM " + retsqlname("SC5")+" SC5 "
cQry += "WHERE SC5.D_E_L_E_T_ <> '*' "
cQry += "AND C5_FILIAL = '" + cFilAnt + "' "
cQry += "ORDER BY C5_NUM DESC "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"QSC5",.T.,.T.)

_cNum:= strzero((val(QSC5->C5_NUM)+1),6)

Return _cNum









