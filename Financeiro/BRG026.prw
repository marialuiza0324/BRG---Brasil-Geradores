#include 'protheus.ch'
#include 'parmtype.ch'

/*
Funcao      : BRG027
Objetivos   : Carrega os dados da ZPX e da a Opção para Alterar (Botao Alterar)
*/
*---------------------*
User Function BRG026()  //U_BRG027()

Local btnGrava
Local btnCancel
Local grpdesm
Local lblAcert
Local lblEmp
Local lblCart
Local lblCpf
Local lblColab
Local lblDtIni   
Local lblDtFim
Local lblDiar
LOCAL nX
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local cAberto  := SuperGetMV("MV_ABERTO", ," ") // OK
Local cGestor  := SuperGetMV("MV_GESTOR", ," ") // OK
Local cConcil  := SuperGetMV("MV_CONCIL", ," ") // OK
Local cDiret   := SuperGetMV("MV_DIRET", ," ") //  OK
Local cArquiv  := SuperGetMV("MV_ARQUIV", ," ") // ok 
 
//Private nAcerto := SuperGetMV("MV_NACERTO",.F.,0)   //Númeração do Acerto
Private txtAcert
Private txtEmp
Private txtCart
Private txtCpf
Private txtColab
Private cAcert   := space(05) //SuperGetMV("MV_NACERTO",.F.,0)//space(25)
Private Empre    := SM0->M0_NOME
Private cCart    := space(05)
Private cCPF     := space(25)
Private cColab   := space(120)
Private cCirc    := space(60)
Private cPlaca   := space(09)
Private cKmIni   := 0
Private cKmFim   := 0
Private cTec     := space(60)
Private _Diar      := .F. 

Private aHeaderEx	 := {}
private aColsEx      := {}
private aFieldFill   := {}
private aFields      := {}
private aAlterFields := {}
private grdDados     := {}
Private oComboBo1
Private cComboBo1    := " "
Private wContext  	:= " "
Private wCBox     	:= " "
Private wRelacao  	:= " "
Private lblCirc
Private txtCirc
Private lblKmIni
Private txtKmIni
Private lblKmFim
Private txtKmFim
Private lblTec
Private txtTec
Private cDiar := space(03)
Private dInic := CTOD("  /  /   ")
Private dFinal := CTOD("  /  /  ")

Static odlPrincipal

//DEFINE MSDIALOG odlPrincipal TITLE "Desmontagem de Produtos" FROM 000, 000  TO 420, 740 COLORS 0, 16777215 PIXEL
DEFINE MSDIALOG odlPrincipal TITLE "Acerto Viagens" FROM -049, 000  TO 500, 1800 COLORS 0, 16777215 PIXEL

@ 005, 000 GROUP grpdesm TO 080, 900 PROMPT "Acerto Viagens" OF odlPrincipal COLOR 0, 16777215 PIXEL
@ 020, 010 SAY 		lblAcert 	      PROMPT "Acerto"	       SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215	PIXEL
@ 018, 040 MSGET 	txtAcert 	      VAR cAcert                  SIZE 025, 010 OF odlPrincipal COLORS 0, 16777215 	PIXEL  PICTURE '@!'
@ 020, 200 SAY 		lblEmp 		      PROMPT "Empresa"         SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 018, 230 MSGET 	txtEmp   	      VAR Empre 				       SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
@ 042, 010 SAY 		lblCart		      PROMPT "Cartão"          SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 040, 040 MSGET 	txtCart	         VAR cCart VALID ExSA6()	    SIZE 025, 010 OF odlPrincipal COLORS 0, 16777215 F3 "SA6CR"	PIXEL
@ 042, 200 SAY 		lblCpf 	     	   PROMPT "CPF"             SIZE 036, 007 OF odlPrincipal COLORS 0, 16777215  PIXEL
@ 040, 230 MSGET 	txtCpf 	   	   VAR cCPF 					    SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215 	PIXEL PICTURE '@R 999.999.999-99'                            
@ 042, 380 SAY 		lblColab 	   	PROMPT "Nome"            SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
@ 040, 410 MSGET	txtColab 		   VAR cColab              	 SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
@ 020, 380 SAY 	lblDtIni 		   PROMPT "Diaria Inicial"     SIZE 060, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 018, 410 MSGET 	txtDtIni	         VAR dInic	   			    SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
@ 020, 580 SAY 	lblDtFim 		   PROMPT "Diaria Final"       SIZE 060, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 018, 620 MSGET 	txtDtFim	         VAR dFinal 	   			    SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
@ 042, 580 SAY 	lblDiar		      PROMPT "Tabela Diária"      SIZE 050, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 040, 620 MSGET 	txtDiar	         VAR cDiar                   SIZE 010, 010 OF odlPrincipal COLORS 0, 16777215 F3 "ZPD" PIXEL
//@ 042, 770 SAY 	lblPlc 	   	   PROMPT "Placa"              SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
//@ 040, 810 MSGET txtPlc	            VAR cPlaca 	   			    SIZE 050, 010 OF odlPrincipal COLORS 0, 16777215 F3 "CTT" PIXEL PICTURE '@! AAA-9X99'
// 042, 580 SAY 	lblCirc 	   	      PROMPT "Transporte"      SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
//@ 040, 620 MSCOMBOBOX oComboBo1     VAR cComboBo1 ITEMS {"Carro BRG","Caminhão","Carro Locado","Avião"} SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215 PIXEL
@ 062, 010 SAY 	lblCirc 	   	      PROMPT "Circuito"        SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
@ 060, 040 MSGET	txtCirc 		      VAR cCirc              	    SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
//@ 062, 200 SAY 	lblKmIni 	   	   PROMPT "KM Inicial"      SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
//@ 060, 230 MSGET	txtKmIni 		   VAR cKmIni              	 SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL PICTURE '@E 999,999,999'
//@ 062, 380 SAY 	lblKmFim 	         PROMPT "KM Final"        SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
//@ 060, 410 MSGET	txtKmFim 		   VAR cKmFim              	 SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL PICTURE '@E 999,999,999'
@ 062, 200 SAY 	lblTec 	   	      PROMPT "Tec/Motorista"   SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
@ 060, 230 MSGET	txtTec	         VAR cTec              	    SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL

DadosAc()
txtCpf:disable()
txtEmp:disable()
txtAcert:disable()
txtColab:disable()
txtCart:disable()

//carregaGrid(strzero(i,8,0),cod,desc)@ 035, 330 MSGET oCodBarra VAR wCodBarra PICTURE "@!" Valid fVerBarra() SIZE 100, 015 OF oGroupBar COLORS 0, 16777215 PIXEL
//@ 020, 350 BUTTON btnCarrega PROMPT "Carregar" SIZE 037, 012 OF odlPrincipal ACTION Processa({|| Carregar()},"Aguarde...")  PIXEL //oDlg:End()
@ 240, 650 BUTTON btnGrava PROMPT "Gravar" SIZE 037, 012 OF odlPrincipal ACTION Processa({|| GrvSE5()},"Aguarde...")  PIXEL 
@ 240, 700 BUTTON btnCancel PROMPT "Cancelar" SIZE 037, 012 OF odlPrincipal ACTION (odlPrincipal:End()) PIXEL

/////////////   Visualizar 26/11/2020 inicio

DbSelectArea("ZPX")
DbSetOrder(1)  //ZPX_FILIAL +ZPX_ACERTO + ZPX_CARTAO + ZPX_ITEM
//ZPX->(DbGoTop())
If DbSeek(xFilial("ZPX")+ZPX->ZPX_ACERTO+ZPX->ZPX_CARTAO)
   //Não se pode alterar  um Acerto se o mesmo estiver ja no extrato 06/07/2021
   If ZPX->ZPX_STATUS = "3"
       MSGINFO("Não se Pode Alterar o Acerto, Status Financeiro, volte para o Gestor !!!!"," Atenção ")
       Return
   EndIF

   If ZPX->ZPX_STATUS = "2"
       MSGINFO("Não se Pode Alterar o Acerto, Status Gestor, volte para o Em Aberto !!!!"," Atenção ")
       Return
   EndIF

   If ZPX->ZPX_STATUS = "4"
       MSGINFO("Não se Pode Alterar o Acerto, Status Diretoria, volte para o Gestor !!!!"," Atenção ")
       Return
   EndIF

   If ZPX->ZPX_STATUS = "5"
       MSGINFO("Não se Pode Alterar o Acerto, Status Arquivado !!!!"," Atenção ")
       Return
   EndIF

	cAcert    := ZPX->ZPX_ACERTO
	Empre     := SM0->M0_NOME 
	cCart     := ZPX->ZPX_CARTAO    
	cCPF      := Posicione("SA6",1,xFilial("SA6")+"999"+ZPX->ZPX_CARTAO,"A6_NUMCON+A6_DVCTA")
   cColab    := Posicione("SA6",1,xFilial("SA6")+"999"+ZPX->ZPX_CARTAO,"A6_NOME")
	//cComboBo1 := ZPX->ZPX_TRANSP
   cDiar     := ZPX->ZPX_TABDIA
	dInic     := ZPX->ZPX_DIAINI
   dFinal    := ZPX->ZPX_DIAFIM 
	cCirc     := ZPX->ZPX_CIRCUI
	cKmIni    := ZPX->ZPX_KMINI
   cKmFim    := ZPX->ZPX_KMFIM
   cTec      := ZPX->ZPX_TEC   
   //cPlaca    := ZPX->ZPX_PLACA
	
	WHILE cAcert == ZPX->ZPX_ACERTO 		 
		
		//For i := 1 To Len(aColsEx1)
			AADD(aColsEx,Array(LEN(aHeaderEx)+1))
			aColsEx[LEN(aColsEx),LEN(aHeaderEx)+1]:=.F.  // 15 nao deletada
			For nX := 1 To Len(aHeaderEx)         //parou aki
				Do Case
					Case Trim(aHeaderEx[nX][2]) == "dbData"	
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_DATA
					Case Trim(aHeaderEx[nX][2]) == "dbItem"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_ITEM
					Case Trim(aHeaderEx[nX][2]) == "dbClas"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_CLAS					               
					Case Trim(aHeaderEx[nX][2]) == "dbTipo"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_TIPO
					Case Trim(aHeaderEx[nX][2]) == "dbDesc"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_DESC					
               Case Trim(aHeaderEx[nX][2]) == "dbModal"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_MODAL               
               Case Trim(aHeaderEx[nX][2]) == "dbValor"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_VALOR	
					Case Trim(aHeaderEx[nX][2]) == "dbAplic"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_APLIC
					Case Trim(aHeaderEx[nX][2]) == "dbCliente"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_CLIENT
					Case Trim(aHeaderEx[nX][2]) == "dbDescCli"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_DESCLI	
               Case Trim(aHeaderEx[nX][2]) == "dbPlaca"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_PLACA		
               Case Trim(aHeaderEx[nX][2]) == "dbTrans"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPX->ZPX_TRANSP								
				EndCase
		  	Next nX			
			ZPX->(DbSkip())
	   //Next i
	ENDDO

  	grdDados:oBrowse:SetArray( aColsEx )
   grdDados:aCols := aColsEx
   grdDados:oBrowse:Refresh(.T.)	
		
EndIf
//oGetDados:oBrowse:Refresh(.t.)
grdDados:refresh() 

//////////////////  Visulizar 26/11/2020 fim

ACTIVATE MSDIALOG odlPrincipal CENTERED

Return


Static Function DadosAc()

private nX := 0

Static odlPrincipal

aFields := {"dbData","dbItem","dbPlaca","dbTrans","dbClas","dbTipo","dbDesc","dbModal","dbValor","dbAplic","dbCliente","dbDescCli"}

aAlterFields := {"dbData","dbPlaca","dbTrans","dbClas","dbTipo","dbDesc","dbModal","dbValor","dbAplic","dbCliente"}

AADD(aHeaderEx,{"Data"    	      ,"dbData"    ,"@!"          		  , 20 ,0 , "u_ValDat1('dbData')" ,"û"   ,"D",         , wContext ,wCBox, " " }) 
AADD(aHeaderEx,{"Item"    	      ,"dbItem"    ,"@!"          		  , 03 ,0 ,  ,"û"   ,"C",         , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Placa"    	   ,"dbPlaca"   ,"@! AAA9X99"         , 15 ,0 , "u_ValPlc1('dbPlaca')"  ,"û"   ,"C",  "CTT"  , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Transporte"     ,"dbTrans"   ,"@!"          		  , 10 ,0 ,  ,"û"   ,"C",         , wContext ,"1=Carro BRG;2=Caminhão;3=Carro Locado;4=Avião", wRelacao })
AADD(aHeaderEx,{"Classificação"  ,"dbClas"    ,"@!"          		  , 05 ,0 , "u_ValDia('dbClas')" ,"û"   ,"C",         , wContext ,"1=Diária Motorista;2=Diária Técnico;3=Combústivel;4=Peças;5=Passagem;6=Hospedagem;7=Refeição;8=Outros", wRelacao })
AADD(aHeaderEx,{"Tipo"           ,"dbTipo"    ,"@!"				     , 30 ,0 ,  ,"û"   ,"C", 	       , wContext ,"1=Corretiva;2=Preventiva;3=Corretiva e Preventiva;4=Logistica;5=Comercial;6=Emergencial;7=Instalação;8=Operação;9=Startup", wRelacao })
AADD(aHeaderEx,{"Descrição"      ,"dbDesc"    ,"@!"          		  , 40 ,0 ,  ,"û"   ,"C",         , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Modalidade"     ,"dbModal"   ,"@!"          		  , 20 ,0 , "u_ValModA('dbModal')" ,"û"   ,"C",         , wContext ,"1=Acerto;2=Faturado;3=Cartao Empresa;4=Saque;5=Adiantamento;6=Abast. Inicial;7=Acerto Avulso", wRelacao }) 
AADD(aHeaderEx,{"Valor"          ,"dbValor"   ,"@E 999,999,999.999" , 14 ,3 ,  ,"û"   ,"N",         , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Documento"      ,"dbAplic"   ,"@!"				     , 30 ,0 ,  ,"û"   ,"C", 	       , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Cliente"        ,"dbCliente" ,"@!"				     , 13 ,0 , "u_ValCli('dbCliente')" ,"û"   ,"C", "SA1ZPX" , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Nome Cliente"   ,"dbDescCli" ,"@!"				     , 40 ,0 ,  ,"û"   ,"C",     	 , wContext ,wCBox, wRelacao })

//Limpa varivaeis da grid
aFieldFill := {}
aColsEx    := {}

//Chama função para montar a grid  /074
grdDados  := MsNewGetDados():New( 080, 001, 220, 900, GD_INSERT + GD_UPDATE + GD_DELETE, "U_ValApll()", "AllwaysTrue", "+dbItem+", aAlterFields,, 9999, "AllwaysTrue", "", "AllwaysTrue", odlPrincipal, @aHeaderEx, @aColsEx)
Return


//Trata o digitação da Placa na Grid
//07/12/2021
//BRG Geradores

User Function ValPlc1(camplc)  

Local _ret := .T.
Local _CMod := ""

grdDados:aCols[n,3] := &(ReadVar())

If  LEN(ALLTRIM(grdDados:aCols[n,3])) < 7
    _ret := .F.
    MSGINFO("Atenção na Digitação da Placa !!!!"," Atenção ")
EndIf
  
Return _ret



//Trata o digitação da Data na Grid
//10/03/2022
//BRG Geradores

User Function ValDat1(campod)  

Local _ret := .T.

grdDados:aCols[n,1] := &(ReadVar())

If grdDados:aCols[n][1] < dInic 
   MSGINFO("Data Inválida, Menor que a data de Inicio !!!!"," Atenção ")
   _ret := .F.
EndIf
Return _ret

//Trata o digitação da Modalidade na Grid
//04/03/2020
//BRG Geradores

User Function ValModA(campoa)  

Local _ret := .T.
Local _CMod := ""

grdDados:aCols[n,8] := &(ReadVar())

If  grdDados:aCols[n,8] = "7"
   U_AcAvulA()
EndIf
  
Return _ret



//Trata o digitação dos Clientes na Grid
//24/02/2020
//BRG Geradores

User Function ValCli(campo)  

Local _ret := .T.
Local _Cli := ""

grdDados:aCols[n,11] := &(ReadVar()) 
If empty(grdDados:aCols[n,11]) //  = "1"
   grdDados:aCols[n,12] := ""
Else
   _Cli := grdDados:aCols[n,11]

   DbSelectArea("SA1")
   DbSetOrder(1)
   If DbSeek(xFilial("SA1")+ALLTRIM(_Cli))
      grdDados:aCols[n,12] := SA1->A1_NOME
   EndIf
EndIf 
Return _ret



//Calcula os o Número de dias da Diária
//28/01/2020
//BRG Geradores

User Function ValDia(campo)   

Local nCont 
Local _ret := .T.
Local _Valor := 0 
Local _Tot := 0
Local _VlDia := 0
lOCAL _VlDiaFer := 0
Local _QtdDias := DateDiffDay(dInic,dFinal)

 grdDados:aCols[n,5] := &(ReadVar())

//Quando for Combustivel informar a Placa 16/11/2021
If grdDados:aCols[n][5] $ "3"
   U_CarLocAl()
   If empty(grdDados:aCols[n][3]) 
      _ret := .F.
      MSGINFO("Informe a Placa !!!!"," Atenção ")
   EndIf    

   If empty(grdDados:aCols[n][4]) 
      _ret := .F.
      MSGINFO("Informe o Tipo de Transporte !!!!"," Atenção ")
   EndIf    

   //Quando seleciona o Tipo Combustivel soma o valor de combustivel da placa selecionada - Inicio 24/02/2022  - Ricardo 
   DbSelectArea("ZPY")
   DbSetOrder(1)     
   If DbSeek(xFilial("ZPY")+cAcert+grdDados:aCols[n][3])
      DO WHILE ZPY->(!EOF()) .AND. xFilial("ZPY") == ZPY->ZPY_FILIAL .AND. cAcert == ZPY->ZPY_ACERTO .AND. grdDados:aCols[n][3] == ZPY->ZPY_PLACA  
        _Tot := _Tot + ZPY->ZPY_VALOR 
        ZPY->(dbSkip())                          
      EndDo 
   EndIf 
   grdDados:aCols[n,9] := _Tot

   //Quando seleciona o Tipo Combustivel soma o valor de combustivel da placa selecionada - fim  Inicio 24/02/2022 - Ricardo  
EndIf 
//Quando for Combustivel informar a Placa  16/11/2021

//coloca diária na descrição inicio 25/05
If grdDados:aCols[n][5] $ "1/2"
   grdDados:aCols[n][7] := cvaltochar(_QtdDias)+" Diárias"      
EndIf 
//coloca diária na descrição fim 25/05 
 
If grdDados:aCols[n][5] = "1"  //Motorista
   DbSelectArea("ZPD")
   DbSetOrder(1)
   If DbSeek(xFilial("ZPD")+cDiar)

   If  _QtdDias - zDiaUt(dInic, dFinal) > 0 
       _VlDiaFer := (_QtdDias - (zDiaUt(dInic, dFinal)-1)) * ZPD->ZPD_FERMOT 
   EndIf 
       _VlDia := _QtdDias * ZPD->ZPD_DIAMOT + _VlDiaFer
         
   Else
      _ret := .F.
      MSGINFO("Tabela não encontrada !!!!"," Atenção ")
   EndIf           

ElseIf grdDados:aCols[n,5]  = "2"   // Tecnico
 DbSelectArea("ZPD")
 DbSetOrder(1)
 If DbSeek(xFilial("ZPD")+cDiar)       
    _VlDia := _QtdDias * ZPD->ZPD_DIATEC
 Else
    _ret := .F.
    MSGINFO("Tabela não encontrada !!!!"," Atenção ")
 EndIf 
EndIF

If grdDados:aCols[n][5] <> "3"  
   grdDados:aCols[n,9] := _VlDia
Endif
  
Return _ret


//10/12/2020
//Valida a Digitação do Codigo da Especificação
//BRG

User Function ValApll() 

Local _ret := .T. 
Local i
Local _cPlc :="" 

If grdDados:aCols[n][8] $ "2/3"
   If empty(grdDados:aCols[n][10])
      MsgInfo( 'Documento não informado !!', 'Atenção !!' )
    _ret := .F.
   EndIf
EndIf 

If grdDados:aCols[n][3] = "3"
   If empty(grdDados:aCols[n][13]) 
      _ret := .F.
      MSGINFO("Informe a Placa !!!!"," Atenção ")
   EndIf    
   If empty(grdDados:aCols[n][14]) 
      _ret := .F.
      MSGINFO("Informe o Tipo de Transporte !!!!"," Atenção ")
   EndIf        
   //If grdDados:aCols[n][4] = 0
   //   MsgInfo( 'Quantidade de Litros não informado !!', 'Atenção !!' )
   // _ret := .F.
   ///EndIf
//Else
   //If grdDados:aCols[n][4] > 0
    //  MsgInfo( 'Sem necessidade de Informar Litros !!', 'Atenção !!' )
   // _ret := .F.
   //EndIf
EndIf 

If grdDados:aCols[n][9] = 0
      MsgInfo( 'Lançamento sem Valor !!', 'Atenção !!' )
   _ret := .F.
EndIf

//Verificar  a existencia de duas placas identicas na GRID 22/03/2022 - Inicio

For i := 1 to len(grdDados:aCols)
   If !(grdDados:aCols[i] [Len(aHeaderEx)+1])  //linha deletada 
      If  grdDados:aCols[i,5] = "3" 
          If _cPlc == grdDados:aCols[i][3] 
            MsgInfo( 'Placa Duplicada !!', 'Atenção !!' )
            _ret := .F.
          EndIf
          IF empty(_cPlc) 
           _cPlc := grdDados:aCols[i][3] 
          EndIf
      EndIF
   EndiF
Next i  
//Verificar  a existencia de duas placas identicas na GRID 22/03/2022 - Fim
 
Return _ret

//Validação da Existência de uma Cartão
//30/10/2020
//BRG Geradores

Static Function ExSA6()
Local _ret := .T.

DbSelectArea("SA6")
DbSetOrder(1)
If DbSeek(xFilial("SA6")+'999'+cCart)
    cCPF   := SA6->A6_NUMCON + SA6->A6_DVCTA
    cColab := SA6->A6_NOME  
    txtCpf:Refresh()
    txtColab:Refresh()
ElseIf DbSeek(xFilial("SA6")+'748'+cCart)
    cCPF   := SA6->A6_NUMCON + SA6->A6_DVCTA
    cColab := SA6->A6_NOME     
    txtCpf:Refresh()
    txtColab:Refresh()  
ElseIf DbSeek(xFilial("SA6")+'888'+cCart)
    cCPF   := SA6->A6_NUMCON + SA6->A6_DVCTA
    cColab := SA6->A6_NOME     
    txtCpf:Refresh()
    txtColab:Refresh()    
else
    _ret := .F.
   MsgInfo( 'Cartão Inexistente. !!', 'Atenção !!' )
EndiF
Return _ret 


//Gravar os dados

Static Function GrvSE5()
LOCAL i
LOCAL _cPlc := ""
Private lMsErroAuto := .F.

//Verificar  a existencia de duas placas identicas na GRID 22/03/2022 - Inicio

For i := 1 to len(grdDados:aCols)
   If !(grdDados:aCols[i] [Len(aHeaderEx)+1])  //linha deletada 
      If  grdDados:aCols[i,5] = "3" 
          If _cPlc == grdDados:aCols[i][3] 
            MsgInfo( 'Placa Duplicada !!', 'Atenção !!' )
            Return
          EndIf
          IF empty(_cPlc) 
           _cPlc := grdDados:aCols[i][3] 
          EndIf
      EndIF
   EndiF
Next i  
//Verificar  a existencia de duas placas identicas na GRID 22/03/2022 - Fim

DbSelectArea("ZPX")
DbSetOrder(1)
If DbSeek(xFilial("ZPX")+cAcert+cCart)
   DO WHILE ZPX->(!EOF()) .AND. xFilial("ZPX") == ZPX->ZPX_FILIAL .AND. cAcert == ZPX->ZPX_ACERTO .AND. cCart == ZPX->ZPX_CARTAO 
		ZPX->(RECLOCK("ZPX",.F.))
		ZPX->( dbDelete() )
		ZPX->(MSUNLOCK())
		ZPX->(dbSkip())
	EndDo
EndIf

//Verificar se tem Diaria - Inicio
/*
For i := 1 to len(grdDados:aCols)
   If !(grdDados:aCols[i] [Len(aHeaderEx)+1])  //linha deletada
      If grdDados:aCols[i][3] = "1"                
         _Diar := .T.
      EndIf 
   EndiF
Next i    
*/
//If !(_Diar)
 // MsgInfo( 'Cliente sem Diária. Cliente:'+grdDados:aCols[i][12]+'!!!' , 'Aviso !!' )
//EndIf
//Verificar se tem Diaria - Inicio 

For i := 1 to len(grdDados:aCols)
   If !(grdDados:aCols[i] [Len(aHeaderEx)+1])  //linha deletada
      DbSelectArea("ZPX")
      DbSetOrder(1)     
      If DbSeek(xFilial("ZPX")+cAcert+cCart+grdDados:aCols[i,2]) 
         RECLOCK("ZPX",.F.)
         ZPX->ZPX_FILIAL := xFilial("ZPX")
         ZPX->ZPX_ACERTO := cAcert 
         ZPX->ZPX_CARTAO := cCart   //CRIAR CAMPO
         ZPX->ZPX_CIRCUI := cCirc
         ZPX->ZPX_KMINI  := cKmIni
         ZPX->ZPX_KMFIM  := cKmFim
         ZPX->ZPX_TEC    := cTec         
         ZPX->ZPX_DIAINI := dInic
         ZPX->ZPX_DIAFIM := dFinal
         ZPX->ZPX_TABDIA := cDiar         
         ZPX->ZPX_DATA   := grdDados:aCols[i,1]
         ZPX->ZPX_ITEM   := grdDados:aCols[i,2]
         ZPX->ZPX_PLACA  := grdDados:aCols[i,3]
         ZPX->ZPX_TRANSP := grdDados:aCols[i,4] //cComboBo1 //
         ZPX->ZPX_CLAS   := grdDados:aCols[i,5]
         ZPX->ZPX_TIPO   := grdDados:aCols[i,6]
         ZPX->ZPX_DESC   := grdDados:aCols[i,7]                
         ZPX->ZPX_MODAL  := grdDados:aCols[i,8]         
         ZPX->ZPX_VALOR  := grdDados:aCols[i,9]
         ZPX->ZPX_APLIC  := grdDados:aCols[i,10] 
         ZPX->ZPX_CLIENT := grdDados:aCols[i,11]
         ZPX->ZPX_DESCLI := grdDados:aCols[i,12]         
         ZPX->ZPX_STATUS := "1"	
         MSUNLOCK()
      Else 
         RECLOCK("ZPX",.T.)
         ZPX->ZPX_FILIAL := xFilial("ZPX")
         ZPX->ZPX_ACERTO := cAcert 
         ZPX->ZPX_CARTAO := cCart   
         ZPX->ZPX_CIRCUI := cCirc
         ZPX->ZPX_KMINI  := cKmIni
         ZPX->ZPX_KMFIM  := cKmFim
         ZPX->ZPX_TEC    := cTec         
         ZPX->ZPX_DIAINI := dInic
         ZPX->ZPX_DIAFIM := dFinal
         ZPX->ZPX_TABDIA := cDiar         
         ZPX->ZPX_DATA   := grdDados:aCols[i,1]
         ZPX->ZPX_ITEM   := grdDados:aCols[i,2]
         ZPX->ZPX_PLACA  := grdDados:aCols[i,3]
         ZPX->ZPX_TRANSP := grdDados:aCols[i,4] 
         ZPX->ZPX_CLAS   := grdDados:aCols[i,5]
         ZPX->ZPX_TIPO   := grdDados:aCols[i,6]
         ZPX->ZPX_DESC   := grdDados:aCols[i,7]                
         ZPX->ZPX_MODAL  := grdDados:aCols[i,8]         
         ZPX->ZPX_VALOR  := grdDados:aCols[i,9]
         ZPX->ZPX_APLIC  := grdDados:aCols[i,10] 
         ZPX->ZPX_CLIENT := grdDados:aCols[i,11]
         ZPX->ZPX_DESCLI := grdDados:aCols[i,12]         
         ZPX->ZPX_STATUS := "1"	
         MSUNLOCK()
      EndIf
   EndIf
Next i 

//MSGINFO("Último preço do Item R$:" + cvaltochar(_Valor)+" ","Atenção")
If MsgYesNo( "Deseja Mudar o Status de para Gestor ? Acerto: " + ZPX->ZPX_ACERTO + "!!!!" , "Status Acerto" )
     DbSelectArea("ZPX")
	  DbSetOrder(1)
	  If DbSeek(xFilial("ZPX")+cAcert+cCart)
		 DO WHILE ZPX->(!EOF()) .AND. xFilial("ZPX") == ZPX->ZPX_FILIAL .AND. cAcert == ZPX->ZPX_ACERTO .AND. cCart == ZPX->ZPX_CARTAO 
			ZPX->(RECLOCK("ZPX",.F.))
			ZPX->ZPX_STATUS := "2"
 			ZPX->(MSUNLOCK())
			ZPX->(dbSkip())
		 EndDo	  
     EndIf
    MSGINFO("Acerto :" + cvaltochar(cAcert)+" Status Gestor. !!!!! ","Atenção")
EndIf

odlPrincipal:End()   

Return




//BRG GEradores
//Tela pra trazer quando é acerto avulso 04/03/2021
//Ricardo Moreira

User Function AcAvulA()
Local oButton1
Local oButton2
Local oGroup1
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Private oGet1
Private dGet1 := Date()
Private oGet2
Private dGet2 := Date()
Private oGet3
Private cGet3 := space(14)
Private oGet4
Private cGet4 := space(45)
Private cGet5 := space(03)
Private oGet5
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Acerto Avulso" FROM 000, 000  TO 200, 500 COLORS 0, 16777215 PIXEL

    @ 001, 002 GROUP oGroup1 TO 098, 250 PROMPT "Acerto Avulso" OF oDlg COLOR 0, 16777215 PIXEL    
    @ 019, 006 SAY oSay1 PROMPT "Periodo de"          SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 018, 037 MSGET oGet1 VAR dGet1                  SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 019, 090 SAY oSay2 PROMPT "Até"                 SIZE 015, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 018, 110 MSGET oGet2 VAR dGet2                  SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 019, 160 SAY oSay5 PROMPT "Tabela Diária"       SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 018, 195 MSGET oGet5 VAR cGet5                  SIZE 030, 010 OF oDlg COLORS 0, 16777215 F3 "ZPD" PIXEL 
    @ 048, 006 SAY oSay3 PROMPT "Tecnico "            SIZE 036, 011 OF oDlg COLORS 0, 16777215 PIXEL
    @ 046, 030 MSGET oGet3 VAR cGet3 VALID ExisAA1() SIZE 060, 010 OF oDlg COLORS 0, 16777215 F3 "AA1"PIXEL
    @ 047, 100 SAY oSay4 PROMPT "Nome"                SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL   
    @ 046, 115 MSGET oGet4 VAR cGet4                  SIZE 132, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 075, 132 BUTTON oButton1 PROMPT "Ok"            SIZE 037, 012 OF oDlg  ACTION Processa({|| GerAvuA()},"Aguarde...")  PIXEL
    @ 075, 184 BUTTON oButton2 PROMPT "Fechar"        SIZE 037, 012 OF oDlg ACTION (oDlg:End()) PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return

//Função para preenchimento de descrição dos Acertos Avulsos
Static Function GerAvuA()

Local nCont 
Local _ret := .T.
Local _Valor := 0 
Local _VlDia := 0
lOCAL _VlDiaFer := 0
//Local _DtIni :=  dInic // Data inicial
//Local _DtFim :=  dFinal // Data Final
Local _QtdDias := DateDiffDay(dGet1,dGet2)

 //grdDados:aCols[n,3] := &(ReadVar()) 

//oMSNewGe1:aCols[n][3] := &(ReadVar())   
//oMSNewGe1:aCols[n][5] := _item //"01" 
 
If grdDados:aCols[n,5]  = "1" .and.  grdDados:aCols[n,8] = "7" //Motorista
   DbSelectArea("ZPD")
   DbSetOrder(1)
   If DbSeek(xFilial("ZPD")+cGet5)

   If  _QtdDias - zDiaUt(dInic, dFinal) > 0 
       _VlDiaFer := (_QtdDias - (zDiaUt(dInic, dFinal)-1)) * ZPD->ZPD_FERMOT 
   EndIf 
       _VlDia := _QtdDias * ZPD->ZPD_DIAMOT + _VlDiaFer
         
   Else
      _ret := .F.
      MSGINFO("Tabela não encontrada !!!!"," Atenção ")
   EndIf           

ElseIf grdDados:aCols[n,5]  = "2" .and. grdDados:aCols[n,8] = "7"  // Tecnico
 DbSelectArea("ZPD")
 DbSetOrder(1)
 If DbSeek(xFilial("ZPD")+cGet5)       
    _VlDia := _QtdDias * ZPD->ZPD_DIATEC
 Else
    _ret := .F.
    MSGINFO("Tabela não encontrada !!!!"," Atenção ")
 EndIf 
EndIF

grdDados:aCols[n,9] := _VlDia
grdDados:aCols[n,7] := Cvaltochar(_QtdDias)+" Diárias - " + alltrim(cGet4) + " - "+ cvaltochar(dGet1) + " a " + cvaltochar(dGet2)     //Descrição

oDlg:End()
Return _ret

//Validação da Existência de um Tecnico
//30/10/2020
//BRG Geradores

Static Function ExisAA1()
Local _ret := .T.

DbSelectArea("AA1")
DbSetOrder(1)
If !DbSeek(xFilial("AA1")+cGet3)
     _ret := .F.
    MsgInfo( 'Tecnico Inexistente. !!', 'Atenção !!' )
else   
    cGet4 := AA1->AA1_NOMTEC
    oGet4:Refresh()
EndiF

Return _ret 


//BRG GEradores
//Calcula do numero de dias 

Static Function zDiaUt(dDtIni, dDtFin)
    Local aArea    := GetArea()
    Local nDias    := 0
    Local dDtAtu   := sToD("")
    Default dDtIni := dDataBase
    Default dDtFin := dDataBase
     
    //Enquanto a data atual for menor ou igual a data final
    dDtAtu := dDtIni
    While dDtAtu <= dDtFin
        //Se a data atual for uma data Válida
        If dDtAtu == DataValida(dDtAtu) 
            nDias++
        EndIf
         
        dDtAtu := DaySum(dDtAtu, 1)
    EndDo
     
    RestArea(aArea)
Return nDias


//16/11/2021
//Inclusão de Tela de mais de um carro no acerto 
//BRG GERADORES


User Function CarLocAl()

Local btnDesmon
Local btnCancel
Local grpdesm
Local lblnSolic   //Ativo
Local txtnSolic //Ativo
Local lbKmIni   
Local txKmIni 
Local lbKmFim   
Local txKmFim 
Local lblDtIni   
Local txtDtIni 
Local lblDtFim   
Local txtDtFim 
Local  nX
Private cKmIni2 := 0
Private cKmFim2 := 0
Private dDataret := CTOD("  /  /   ")
Private dDatadev := CTOD("  /  /  ")
Private dEmis    := DDATABASE   //aTIVO
Private aHeaderEx	 := {}
private aColsEx      := {}
private aFieldFil   := {}
private aFields      := {}
private aAlterFields := {}
private grdCarro     := {}
Private cPlaca       := space(07) 
Private wContext  	 := " "
Private wCBox     	 := " "
Private wRelacao  	 := " "
Static odlCarro 
 
DEFINE MSDIALOG odlCarro TITLE "Carros Utilizados no Acerto" FROM -049, 000  TO 330, 1200 COLORS 0, 16777215 PIXEL

@ 005, 000 GROUP grpdesm TO 075, 230 PROMPT "Carros Utilizados no Acerto" OF odlCarro COLOR 0, 16777215 PIXEL
@ 020, 010 SAY 		lblnSolic 	    PROMPT "Acerto"	      SIZE 025, 007 OF odlCarro COLORS 0, 16777215	PIXEL
@ 018, 040 MSGET 	   txtnSolic 	    VAR cAcert  				SIZE 040, 010 OF odlCarro COLORS 0, 16777215 PIXEL
@ 020, 085 SAY 		lblPlc 	       PROMPT "Placa"	      SIZE 025, 007 OF odlCarro COLORS 0, 16777215	PIXEL
@ 018, 110 MSGET 	   txtPlc 	       VAR cPlaca  				SIZE 040, 010 OF odlCarro COLORS 0, 16777215 PIXEL PICTURE '@! AAA9X99'
@ 040, 010 SAY 	   lbKmIni 	   	 PROMPT "KM Inicial"    SIZE 040, 010 OF odlCarro COLORS 0, 16777215	PIXEL
@ 038, 040 MSGET	   txKmIni 		    VAR cKmIni2            SIZE 040, 010 OF odlCarro COLORS 0, 16777215 PIXEL PICTURE '@E 999999999.999'
@ 040, 085 SAY 	   lbKmFim 	       PROMPT "KM Final"      SIZE 040, 010 OF odlCarro COLORS 0, 16777215	PIXEL
@ 038, 110 MSGET	   txKmFim 		    VAR cKmFim2         	SIZE 040, 010 OF odlCarro COLORS 0, 16777215 PIXEL PICTURE '@E 999999999.999'
@ 060, 010 SAY 	   lblDtIni 		 PROMPT "Retirada"      SIZE 060, 007 OF odlCarro COLORS 0, 16777215 PIXEL
@ 058, 040 MSGET 	   txtDtIni	       VAR dDataret	   		SIZE 060, 010 OF odlCarro COLORS 0, 16777215 PIXEL
@ 060, 110 SAY 	   lblDtFim 		 PROMPT "Retorno"       SIZE 060, 007 OF odlCarro COLORS 0, 16777215 PIXEL
@ 058, 135 MSGET 	   txtDtFim	       VAR dDatadev 	   		SIZE 060, 010 OF odlCarro COLORS 0, 16777215 PIXEL 
 
Dcarloc1()
txtnSolic:disable()
txtPlc:disable()
cPlaca := grdDados:aCols[n,3]

DbSelectArea("ZPY")
DbSetOrder(1)  //ZPX_FILIAL +ZPX_ACERTO + ZPX_CARTAO + ZPX_ITEM
If DbSeek(xFilial("ZPY")+cAcert+alltrim(cPlaca))


   cPlaca     := ZPY->ZPY_PLACA
	cKmIni2    := ZPY->ZPY_KMINI
   cKmFim2    := ZPY->ZPY_KMFIM
   dDataret   := ZPY->ZPY_DTRET
   dDatadev   := ZPY->ZPY_DTDEV

   WHILE cAcert == ZPY->ZPY_ACERTO .AND. cPlaca == ZPY->ZPY_PLACA
		//For i := 1 To Len(aColsEx1)
			AADD(aColsEx,Array(LEN(aHeaderEx)+1))
			aColsEx[LEN(aColsEx),LEN(aHeaderEx)+1]:=.F.  // 15 nao deletada
			For nX := 1 To Len(aHeaderEx)         //parou aki
				Do Case	
               Case Trim(aHeaderEx[nX][2]) == "dbDtLoc"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPY->ZPY_DATA				
					Case Trim(aHeaderEx[nX][2]) == "dbItem"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPY->ZPY_ITEM
               Case Trim(aHeaderEx[nX][2]) == "dbMod"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPY->ZPY_MODAL
               Case Trim(aHeaderEx[nX][2]) == "dbOdom"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPY->ZPY_ODOME
					Case Trim(aHeaderEx[nX][2]) == "dbLitro"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPY->ZPY_LITRO 
               Case Trim(aHeaderEx[nX][2]) == "dbVlr"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPY->ZPY_VALOR
               Case Trim(aHeaderEx[nX][2]) == "dbAplic"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPY->ZPY_APLIC
               Case Trim(aHeaderEx[nX][2]) == "dbDesc"	// 
						aColsEx[LEN(aColsEx)][nX] := ZPY->ZPY_DESC
				EndCase
		  	Next nX			
			ZPY->(DbSkip())
	   //Next i
	ENDDO
  	 grdCarro:oBrowse:SetArray( aColsEx )
    grdCarro:aCols := aColsEx
    grdCarro:oBrowse:Refresh(.T.)
EndIF
	

/*
//txtSolic:disable()
//txtEmis:disable()

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

*/


@ 018, 110 BUTTON btnDesmon PROMPT "Gravar" SIZE 037, 012 OF odlCarro ACTION Processa({|| GrvCarlo()},"Aguarde...")  PIXEL 
@ 018, 150 BUTTON btnCancel PROMPT "Cancelar" SIZE 037, 012 OF odlCarro ACTION (odlCarro:End()) PIXEL


ACTIVATE MSDIALOG odlCarro CENTERED

Return

//27/02/2020
//Cria a Grid
//Brg Geradores


Static Function Dcarloc1()

private nX := 0

Static odlCarro

aFields := {"dbDtLoc","dbItem","dbMod","dbOdom","dbLitro","dbVlr","dbAplic","dbDesc"}

aAlterFields := {"dbDtLoc","dbMod","dbOdom","dbLitro","dbVlr","dbAplic","dbDesc"}

AADD(aHeaderEx,{"Data"    	       ,"dbDtLoc"       ,"@!"          		  , 20 ,0 ,  ,"û"   ,"D",        , wContext ,wCBox, " " })
AADD(aHeaderEx,{"Item"    	       ,"dbItem"        ,"@!"          		  , 02 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Modalidade"      ,"dbMod"         ,"@!"          		  , 20 ,0 ,  ,"û"   ,"C",        , wContext ,"1=Acerto;2=Faturado;3=Cartao Empresa;4=Saque;5=Adiantamento;6=Abast. Inicial", wRelacao }) 
AADD(aHeaderEx,{"Odômetro"    	 ,"dbOdom"    	   ,"@E 999,999,999.999"  , 14 ,3 ,  ,"û"   ,"N",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Litros"    	    ,"dbLitro"       ,"@E 999,999,999.999"  , 14 ,3 ,  ,"û"   ,"N",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Valor"    	    ,"dbVlr"         ,"@E 999,999,999.99"   , 14 ,2 ,  ,"û"   ,"N",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Documento"    	 ,"dbAplic"       ,"@!"                  , 40 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Descrição"    	 ,"dbDesc"        ,"@!"                  , 60 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })

//Limpa varivaeis da grid
aFieldFill := {}
aColsEx    := {}

//Chama função para montar a grid  /074
grdCarro  := MsNewGetDados():New( 085, 001, 180, 600, GD_INSERT + GD_UPDATE + GD_DELETE, "AllwaysTrue", "AllwaysTrue", "+dbItem+", aAlterFields,, 9999, "AllwaysTrue", "", "AllwaysTrue", odlCarro, @aHeaderEx, @aColsEx)
Return 


Static Function GrvCarLo()

Local _Tot := 0
Local i
Local _cPlc := ""
Private lMsErroAuto := .F.

//Verificar  a existencia de duas placas identicas na GRID 22/03/2022 - Inicio

For i := 1 to len(grdDados:aCols)
   If !(grdDados:aCols[i] [Len(aHeaderEx)+1])  //linha deletada 
      If  grdDados:aCols[i,5] = "3" 
          If _cPlc == grdDados:aCols[i][3] 
            MsgInfo( 'Placa Duplicada !!', 'Atenção !!' )
            RETURN
          EndIf
          IF empty(_cPlc) 
           _cPlc := grdDados:aCols[i][3] 
          EndIf
      EndIF
   EndiF
Next i  
//Verificar  a existencia de duas placas identicas na GRID 22/03/2022 - Fim


DbSelectArea("ZPY")
DbSetOrder(1)
If DbSeek(xFilial("ZPY")+cAcert+cPlaca)
   DO WHILE ZPY->(!EOF()) .AND. xFilial("ZPY") == ZPY->ZPY_FILIAL .AND. cAcert == ZPY->ZPY_ACERTO .AND. cPlaca == ZPY->ZPY_PLACA 
		ZPY->(RECLOCK("ZPY",.F.))
		ZPY->( dbDelete() )
		ZPY->(MSUNLOCK())
		ZPY->(dbSkip())
	EndDo
EndIf
 
//Verificar se tem Diaria - Inicio 

For i := 1 to len(grdCarro:aCols)
   If !(grdCarro:aCols[i] [Len(aHeaderEx)+1])   
      DbSelectArea("ZPY")
      DbSetOrder(1)     
      If !DbSeek(xFilial("ZPY")+cAcert+cPlaca+grdCarro:aCols[i,2]) 
         RECLOCK("ZPY",.T.)
         ZPY->ZPY_FILIAL := xFilial("ZPY")     
         ZPY->ZPY_ACERTO := cAcert
         ZPY->ZPY_DATA   := grdCarro:aCols[i,1] 
         ZPY->ZPY_ITEM   := grdCarro:aCols[i,2]         
         ZPY->ZPY_PLACA  := cPlaca
         ZPY->ZPY_KMINI  := cKmIni2
         ZPY->ZPY_KMFIM  := cKmFim2
         ZPY->ZPY_ODOME  := grdCarro:aCols[i,4]  
         ZPY->ZPY_LITRO  := grdCarro:aCols[i,5]
         ZPY->ZPY_DTRET  := dDataret   
         ZPY->ZPY_DTDEV  := dDatadev  
         ZPY->ZPY_VALOR  := grdCarro:aCols[i,6]   
         ZPY->ZPY_MODAL  := grdCarro:aCols[i,3]
         ZPY->ZPY_APLIC  := grdCarro:aCols[i,7]   
         ZPY->ZPY_DESC   := grdCarro:aCols[i,8]                          
         MSUNLOCK()
           _Tot := _Tot + grdCarro:aCols[i,6] 
      Else
         RECLOCK("ZPY",.F.)
         ZPY->ZPY_FILIAL := xFilial("ZPY")     
         ZPY->ZPY_ACERTO := cAcert
         ZPY->ZPY_DATA   := grdCarro:aCols[i,1] 
         ZPY->ZPY_ITEM   := grdCarro:aCols[i,2]         
         ZPY->ZPY_PLACA  := cPlaca
         ZPY->ZPY_KMINI  := cKmIni2
         ZPY->ZPY_KMFIM  := cKmFim2
         ZPY->ZPY_ODOME  := grdCarro:aCols[i,4]  
         ZPY->ZPY_LITRO  := grdCarro:aCols[i,5]
         ZPY->ZPY_DTRET  := dDataret   
         ZPY->ZPY_DTDEV  := dDatadev  
         ZPY->ZPY_VALOR  := grdCarro:aCols[i,6]   
         ZPY->ZPY_MODAL  := grdCarro:aCols[i,3] 
         ZPY->ZPY_APLIC  := grdCarro:aCols[i,7]   
         ZPY->ZPY_DESC   := grdCarro:aCols[i,8]             
         MSUNLOCK() 
         _Tot := _Tot + grdCarro:aCols[i,6] 
      EndIf      
   EndIf
Next i
MSGINFO("Gravado com Sucesso !!!! ","Atenção")
grdDados:aCols[n,9] := _Tot
odlCarro:End() 

Return




