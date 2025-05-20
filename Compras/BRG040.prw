#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºAUTOR     ³ RICARDO    25/08/2022                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para validar a inclusão de produto na solicitação   º±±
±±ºSe não tiver no cadastro de solicitantes o grupo ao seu user, bloqueia º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 3RL Solucões                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BRG040() //BRG040()

	Local cRet := .F.
	Local aArea		:= GetArea()
	Local cGrupo := ""
	local cTipo := ""
	Local cUserId   := RetCodUsr() //Retorna o Usuário Logado


	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+M->C1_PRODUTO)
		cGrupo := SB1->B1_GRUPO
		cTipo := SB1->B1_TIPO

		If cTipo = 'OI' 
			Help(, ,"AVISO#0021", ,"Produto não permitido.",1, 0, , , , , , {"Selecione um produto que não seja do tipo OI."})
			cRet := .F.
		Else

			DbSelectArea("SAI")
			DbSetOrder(2)
			If DbSeek(xFilial("SAI")+cUserId)
				Do While ! EOF() .AND. SAI->AI_USER == cUserId .AND. SAI->AI_FILIAL = xFilial("SAI")
					If  cGrupo = SAI->AI_GRUPO
						cRet := .T.
					EndIF
					SAI->(dbSkip())
				EndDo
				If !cRet
					Help(, ,"AVISO#0022", ,"Grupo não permitido.",1, 0, , , , , , {"Selecione um produto cujo grupo seja permitido para o seu usuário, ou contate o setor de compras."})
				EndIf
			EndIf
		EndIf

	EndIf

	RestArea(aArea)
Return cRet
