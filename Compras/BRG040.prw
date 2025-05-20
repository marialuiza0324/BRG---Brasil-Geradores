#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���AUTOR     � RICARDO    25/08/2022                                      ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para validar a inclus�o de produto na solicita��o   ���
���Se n�o tiver no cadastro de solicitantes o grupo ao seu user, bloqueia ���
�������������������������������������������������������������������������͹��
���Uso       � 3RL Soluc�es                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BRG040() //BRG040()

	Local cRet := .F.
	Local aArea		:= GetArea()
	Local cGrupo := ""
	local cTipo := ""
	Local cUserId   := RetCodUsr() //Retorna o Usu�rio Logado


	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+M->C1_PRODUTO)
		cGrupo := SB1->B1_GRUPO
		cTipo := SB1->B1_TIPO

		If cTipo = 'OI' 
			Help(, ,"AVISO#0021", ,"Produto n�o permitido.",1, 0, , , , , , {"Selecione um produto que n�o seja do tipo OI."})
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
					Help(, ,"AVISO#0022", ,"Grupo n�o permitido.",1, 0, , , , , , {"Selecione um produto cujo grupo seja permitido para o seu usu�rio, ou contate o setor de compras."})
				EndIf
			EndIf
		EndIf

	EndIf

	RestArea(aArea)
Return cRet
