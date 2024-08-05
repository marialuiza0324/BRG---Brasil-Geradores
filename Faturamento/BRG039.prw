#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºAUTOR     ³ RICARDO    17/03/2022                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para digitar a fatura por item   				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 3RL                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BRG039()

Local btnCancelar
Local btnSalvar
Local grpSopag
Local lblNf
Local lblCli
Local lblEmiss
 

Local dEmiss   := SC5->C5_EMISSAO
Local cCliente := Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"))
 
Local txtNf
Local txtCli
Local txtEmiss
 
Private cPed    := SC5->C5_NUM
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

DEFINE MSDIALOG odlPrincipal TITLE "Valores Fatura por Item" FROM -049, 000  TO 300, 800 COLORS 0, 16777215 PIXEL

@ 005, 000 GROUP grpSopag TO 060, 400 PROMPT "Valores Fatura por Item" OF odlPrincipal COLOR 0, 16777215 PIXEL

@ 020, 010 SAY 		lblNf 	     	PROMPT "Pedido"	    SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 			PIXEL
@ 018, 040 MSGET 	txtNf 	      	VAR cPed 	     	SIZE 055, 010 OF odlPrincipal COLORS 0, 16777215 READONLY 	PIXEL
@ 020, 194 SAY 		lblEmiss 		PROMPT "Emissão"    SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 			PIXEL
@ 018, 220 MSGET 	txtEmiss	    VAR dEmiss 	     	SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215 READONLY 	PIXEL
@ 035, 010 SAY 		lblCli 	     	PROMPT "Cliente"    SIZE 036, 007 OF odlPrincipal COLORS 0, 16777215 			PIXEL
@ 033, 040 MSGET 	txtCli 	     	VAR cCliente 		SIZE 220, 010 OF odlPrincipal COLORS 0, 16777215 READONLY 	PIXEL 
 
DadosRt()
carregaGrid()

@ 025, 300 BUTTON btnSalvar PROMPT "Salvar" SIZE 037, 012 OF odlPrincipal ACTION salvar() PIXEL
@ 025, 350 BUTTON btnCancelar PROMPT "Cancelar" SIZE 037, 012 OF odlPrincipal ACTION CLOSE(odlPrincipal) PIXEL

ACTIVATE MSDIALOG odlPrincipal CENTERED

Return

////Cria a Grid

Static Function DadosRt()

private nX := 0

Static odlPrincipal

aFields := {"dbItem","dbCodigo","dbDesc","dbQtd","dbFatura"}

aAlterFields := {"dbFatura"}

AADD(aHeaderEx,{"Item"    	     ,"dbItem"       ,"@!"          		, 02 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Codigo"    	 ,"dbCodigo"     ,"@!"          		, 15 ,0 ,  ,"û"   ,"C",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Descrição"      ,"dbDesc"       ,"@!"				 	, 45 ,0 ,  ,"û"   ,"C", 	   , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Qtd"            ,"dbQtd"        ,"@E 999,999,999.99"   , 14 ,2 ,  ,"û"   ,"N",        , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Valor Fatura"   ,"dbFatura"     ,"@E 999,999,999.99" 	, 14 ,2 ,  ,"û"   ,"N",        , wContext ,wCBox, wRelacao })

//Limpa varivaeis da grid
aFieldFill := {}
aColsEx    := {}

//Chama função para montar a grid  /074
grdDados  := MsNewGetDados():New( 060, 001, 150, 400, GD_INSERT + GD_UPDATE + GD_DELETE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 9999, "AllwaysTrue", "", "AllwaysTrue", odlPrincipal, @aHeaderEx, @aColsEx)
Return

//-----------------------------------------------
//Função para preencher grid na tela
//-----------------------------------------------

Static Function carregaGrid()

Local cDesc   := " " //POSICIONE("SB1",1,XFILIAL("SB1")+SD2->D2_COD,"B1_DESC")

DbSelectArea("SC6")
DbSetOrder(1)  
dbSeek(xFilial("SC6")+cPed)
DO WHILE !SC6->( EOF() ) .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cPed	
	cDesc  := POSICIONE("SB1",1,XFILIAL("SB1")+SC6->C6_PRODUTO,"B1_DESC")	 
	Aadd(aColsEx, {SC6->C6_ITEM,SC6->C6_PRODUTO,cDesc,SC6->C6_QTDVEN,SC6->C6_VLRFAT,.F.})	
	SC6->( dbSkip() )	
ENDDO
//grdDados:SetArray(aColsEx,.T.)
//grdDados:Refresh()

grdDados:oBrowse:SetArray( aColsEx )
grdDados:aCols := aColsEx
grdDados:oBrowse:Refresh()	

Return

//Grava os Valores das Faturas por item
//17/03/2021

Static function Salvar()

local i

For i:= 1 to len(grdDados:aCols) 
	If !(grdDados:aCols[i] [Len(aHeaderEx)+1])  //linha deletada	
		If dbSeek(xFilial("SC6")+cPed+grdDados:aCols[i,1] + grdDados:aCols[i,2])
	       SC6->(RECLOCK("SC6",.F.))
           SC6->C6_VLRFAT  := grdDados:aCols[i,5]
           SC6->(MSUNLOCK())           
	  EndIf
	EndIF
Next i

MsgInfo("Gravação efetuada com sucesso de cada item !!!!!"," Atenção ")

//grdDados:SetArray(aColsEx,.T.)
//grdDados:Refresh()
odlPrincipal:End()

Return




