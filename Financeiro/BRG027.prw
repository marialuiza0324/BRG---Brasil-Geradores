#include "Protheus.ch"

/*
Funcao      : BRG027
Objetivos   : Carrega os dados da ZPX na Visulização (Botao Visualizar)
*/
*---------------------*
User Function BRG027()  //U_BRG027()

//Local btnCarrega
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
Local nX
 
//Private nAcerto := SuperGetMV("MV_NACERTO",.F.,0)   //Númeração do Acerto
Private txtAcert
Private txtEmp
Private txtCart
Private txtCpf
Private txtColab
Private cAcert   := space(06) //SuperGetMV("MV_NACERTO",.F.,0)//space(25)
Private Empre    := SM0->M0_NOME
Private cCart    := space(05)
Private cCPF     := space(25)
Private cColab   := space(120)
Private cCirc    := space(60)
Private cPlaca   := space(09)
Private cKmIni   := 0
Private cKmFim   := 0
Private cTec     := space(60)

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
Private txtDiar
Private cDiar := space(03)
Private dInic := CTOD("  /  /   ")
Private dFinal := CTOD("  /  /  ")

Static odlPrincipal

//DEFINE MSDIALOG odlPrincipal TITLE "Desmontagem de Produtos" FROM 000, 000  TO 420, 740 COLORS 0, 16777215 PIXEL
DEFINE MSDIALOG odlPrincipal TITLE "Acerto Viagens" FROM -049, 000  TO 500, 1800 COLORS 0, 16777215 PIXEL


@ 005, 000 GROUP  grpdesm TO 080, 900 PROMPT "Acerto Viagens" OF odlPrincipal COLOR 0, 16777215 PIXEL
@ 020, 010 SAY 	    lblAcert 	      PROMPT "Acerto"	          SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215	PIXEL
@ 018, 040 MSGET 	txtAcert 	      VAR cAcert                  SIZE 025, 010 OF odlPrincipal COLORS 0, 16777215 	READONLY PIXEL  PICTURE '@!'
@ 020, 200 SAY 	    lblEmp 		      PROMPT "Empresa"            SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 018, 240 MSGET 	txtEmp   	      VAR Empre 				  SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
@ 042, 010 SAY 	    lblCart		      PROMPT "Cartão"             SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 040, 040 MSGET 	txtCart	          VAR cCart VALID ExistSA6()  SIZE 025, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
@ 042, 200 SAY 	    lblCpf 	     	  PROMPT "CPF"                SIZE 036, 007 OF odlPrincipal COLORS 0, 16777215  PIXEL
@ 040, 240 MSGET 	txtCpf 	   	      VAR cCPF 					  SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215 	PIXEL PICTURE '@R 999.999.999-99'                            
@ 042, 380 SAY 	    lblColab 	   	  PROMPT "Nome"               SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
@ 040, 410 MSGET	txtColab 		  VAR cColab              	  SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
@ 020, 380 SAY 	    lblDtIni 		  PROMPT "Diaria Inicial"     SIZE 060, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 018, 410 MSGET 	txtDtIni	      VAR dInic	   			      SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
@ 020, 580 SAY 	    lblDtFim 		  PROMPT "Diaria Final"       SIZE 060, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 018, 620 MSGET 	txtDtFim	      VAR dFinal 	   			  SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
@ 042, 580 SAY 	    lblDiar		      PROMPT "Tabela Diária"      SIZE 050, 007 OF odlPrincipal COLORS 0, 16777215 	PIXEL
@ 040, 620 MSGET 	txtDiar	          VAR cDiar                   SIZE 010, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL

//@ 042, 770 SAY 	    lblPlc 	   	  PROMPT "Placa"          SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
//@ 040, 810 MSGET    txtPlc	      VAR cPlaca 	   		  SIZE 050, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL PICTURE '@! AAA-9X99'
//@ 042, 580 SAY 	    lblCirc 	  PROMPT "Transporte"     SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
//@ 040, 620 MSCOMBOBOX oComboBo1     VAR cComboBo1 ITEMS {"Carro BRG","Caminhão","Carro Locado","Avião"} SIZE 060, 010 OF odlPrincipal COLORS 0, 16777215 PIXEL

@ 062, 010 SAY 	lblCirc 	   	      PROMPT "Circuito"           SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
@ 060, 040 MSGET	txtCirc 		  VAR cCirc              	  SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
//@ 062, 200 SAY   	lblKmIni 	   	  PROMPT "KM Inicial"         SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
//@ 060, 230 MSGET	txtKmIni 		  VAR cKmIni                  SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL PICTURE '@E 999,999,999'
//@ 062, 380 SAY   	lblKmFim 	      PROMPT "KM Final"           SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
//@ 060, 410 MSGET	txtKmFim 		  VAR cKmFim                  SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL PICTURE '@E 999,999,999'
@ 062, 200 SAY 	lblTec 	   	          PROMPT "Tec/Motorista"       SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215	PIXEL
@ 060, 240 MSGET	txtTec	          VAR cTec              	    SIZE 120, 010 OF odlPrincipal COLORS 0, 16777215  PIXEL
//txtBar:SetFocus() // forca o foco nesta variavel  /1=Carro BRG;2=Caminhão;3=Carro Locado;4=Avião
DadosAc()

txtCart:disable()
txtCpf:disable()
txtEmp:disable()
txtAcert:disable()
txtColab:disable()
txtCirc:disable()
txtDtIni:disable()
txtDtFim:disable()
txtDiar:disable()


//carregaGrid(strzero(i,8,0),cod,desc)@ 035, 330 MSGET oCodBarra VAR wCodBarra PICTURE "@!" Valid fVerBarra() SIZE 100, 015 OF oGroupBar COLORS 0, 16777215 PIXEL
//@ 020, 350 BUTTON btnCarrega PROMPT "Carregar" SIZE 037, 012 OF odlPrincipal ACTION Processa({|| Carregar()},"Aguarde...")  PIXEL //oDlg:End()
//@ 240, 650 BUTTON btnDesmon PROMPT "Gravar" SIZE 037, 012 OF odlPrincipal PIXEL 
@ 240, 700 BUTTON btnCancel PROMPT "Cancelar" SIZE 037, 012 OF odlPrincipal ACTION (odlPrincipal:End()) PIXEL

/////////////   Visualizar 26/11/2020 inicio

DbSelectArea("ZPX")
DbSetOrder(1)  //ZPX_FILIAL +ZPX_ACERTO + ZPX_CARTAO + ZPX_ITEM
//ZPX->(DbGoTop())
If DbSeek(xFilial("ZPX")+ZPX->ZPX_ACERTO+ZPX->ZPX_CARTAO)
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
			//nX
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

aAlterFields := {}

AADD(aHeaderEx,{"Data"    	      ,"dbData"    ,"@!"          		  , 20 ,0 ,  ,"û"   ,"D",         , wContext ,wCBox, " " })
AADD(aHeaderEx,{"Item"    	      ,"dbItem"    ,"@!"          		  , 03 ,0 ,  ,"û"   ,"C",         , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Placa"    	      ,"dbPlaca"   ,"@! AAA9X99"          , 15 ,0 ,  ,"û"   ,"C",         , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Transporte"     ,"dbTrans"   ,"@!"          		  , 10 ,0 ,  ,"û"   ,"C",         , wContext ,"1=Carro BRG;2=Caminhão;3=Carro Locado;4=Avião", wRelacao })
AADD(aHeaderEx,{"Classificação"  ,"dbClas"    ,"@!"          		  , 05 ,0 ,  ,"û"   ,"C",         , wContext ,"1=Diária Motorista;2=Diária Técnico;3=Combústivel;4=Peças;5=Passagem;6=Hospedagem;7=Refeição;8=Outros", wRelacao })
AADD(aHeaderEx,{"Tipo"           ,"dbTipo"    ,"@!"				      , 30 ,0 ,  ,"û"   ,"C", 	      , wContext ,"1=Corretiva;2=Preventiva;3=Corretiva e Preventiva;4=Logistica;5=Comercial;6=Emergencial;7=Instalação;8=Operação;9=Startup", wRelacao })
AADD(aHeaderEx,{"Descrição"      ,"dbDesc"    ,"@!"          		  , 40 ,0 ,  ,"û"   ,"C",         , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Modalidade"     ,"dbModal"   ,"@!"          		  , 20 ,0 ,  ,"û"   ,"C",         , wContext ,"1=Acerto;2=Faturado;3=Cartao Empresa;4=Saque;5=Adiantamento;6=Abast. Inicial;7=Acerto Avulso", wRelacao }) 
AADD(aHeaderEx,{"Valor"          ,"dbValor"   ,"@E 999,999,999.999"   , 14 ,3 ,  ,"û"   ,"N",         , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Documento"      ,"dbAplic"   ,"@!"				      , 30 ,0 ,  ,"û"   ,"C", 	      , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Cliente"        ,"dbCliente" ,"@!"				      , 13 ,0 ,  ,"û"   ,"C",         , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Nome Cliente"   ,"dbDescCli" ,"@!"				      , 40 ,0 ,  ,"û"   ,"C",     	  , wContext ,wCBox, wRelacao })

//Limpa varivaeis da grid
aFieldFill := {}
aColsEx    := {}

//Chama função para montar a grid  /074
grdDados  := MsNewGetDados():New( 080, 001, 220, 900, GD_INSERT + GD_UPDATE + GD_DELETE, "AllwaysTrue", "AllwaysTrue", "+dbItem+", aAlterFields,, 9999, "AllwaysTrue", "", "AllwaysTrue", odlPrincipal, @aHeaderEx, @aColsEx)
Return

