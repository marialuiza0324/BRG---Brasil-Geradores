#Include "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOMESC5   ºAutor  ³Pedro Paulo Aires   º Data ³  28/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para informar o nome do cliente ou fornecedor conforme  º±±
±±º          ³ o tipo do pedido.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function NOMESC5()
	Local cNomCli :=  ""

/*
	DATA: 02/06/2022
	AUTOR: MARLON PABLO
	DESCRIÇÃO: AVISO DE CLIENTE NÃO CONTRIBUINTE
*/

//INICIO
	Local cContrib := ""

	DbSelectArea("SA1")
	DbSetOrder(1)
	dbSeek(xFilial("SA1")+M->C5_CLIENTE)

	If Funname() <> "LOCA001" .AND. Funname() <> "FSFAT004" .AND. Funname() <> "LOCA048" .AND. FunName() <> "RPC" .AND. FunName() <> "CNTA260"

		IF SA1->A1_CONTRIB == '2'
			cContrib := '<b style="color:red">NÃO CONTRIBUINTE!!!</b>'
		ELSE
			cContrib := 'Contribuinte SIM/NÃO CHR(13)<b style="color:red">NÃO INFORMADO</b> no cadastro do cliente!!!'
		ENDIF

		FWAlertWarning('Cliente '+cContrib, "Aviso Cliente Contribuinte")


		//FIM
	EndIf

	//Validar se o tipo do Pedido de Vendas contém D ou B
	IF (M->C5_TIPO $ 'DB')
		cNomCli := POSICIONE ("SA2",1,XFILIAL("SA2")+M->C5_CLIENTE+M->C5_LOJACLI,"A2_NOME")
	Else
		cNomCli := POSICIONE ("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NREDUZ")
	EndIf


Return (cNomCli)
