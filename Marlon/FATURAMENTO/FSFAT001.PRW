#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MFSFAT001  � Autor � Maria Luiza      � Data � 10/06/2024  潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Informa se a TES n鉶 movimenta estoque                     潮�
潮�                          	                                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�                                                                       潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function FSFAT001()

	Local lRet := .T.
	Local cTes := M->C6_TES
	Local cTesValid := Posicione('SF4', 1, FWxFilial('SF4') + cTes , 'F4_ESTOQUE')

	DbSelectArea("SF4")
	SF4->(DbSetOrder(1))
	SF4->(DbGoTop())

	IF SF4->(MsSeek(xFilial("SF4")+cTes))
		If cTesValid == "N"
			FWAlertInfo("Tes n鉶 movimenta estoque.","Aten玢o!")
		EndIf
	Endif

	SF4->(DbCloseArea())


Return lRet
