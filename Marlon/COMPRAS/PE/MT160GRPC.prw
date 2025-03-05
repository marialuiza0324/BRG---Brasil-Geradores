#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function MT160GRPC()

	Local cUser         := ""
	Local cGrupo        := ""
	Local cUserWeb      := ""

	cUserWeb := Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"C1_XSOLWEB")
	cUser := Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"SC1->C1_USER")
	cGrupo := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"SB1->B1_GRUPO")
		
			If !Empty(cUserWeb)
	
				SC7->C7_CODSOL := cUserWeb
				SC7->C7_GRUPO := cGrupo

			ElseIf !Empty(cUser)
			
				SC7->C7_CODSOL := cUser
				SC7->C7_GRUPO  := cGrupo

			Else
		
				SC7->C7_CODSOL := RetCodUsr()
				SC7->C7_GRUPO  := cGrupo
				
			EndIf
Return

