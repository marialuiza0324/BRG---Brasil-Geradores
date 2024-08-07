#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

Static oMSNewGe1
Static oDlg

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050DES   �Autor  � Claudio Ferreira  � Data �  18/06/2012 ���
���Programa  �FA050DES   �Autor  � Tarc�sio Silva    � Data �  17/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada na confirma��o do Desdobramento            ���
���          �Utilizado para alterar as parcelas                          ���
�������������������������������������������������������������������������͹��
���Uso       �                             			 					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050DES()

	Local aParcelas	:= ParamixB
	Local aOldPar	:= ParamixB

	fTela(@aParcelas,aOldPar)

Return(aParcelas)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fTela      �Autor  � Tarc�sio Silva    � Data �  17/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Apresenta a tela com os titulos referente ao desdobramento. ���
�������������������������������������������������������������������������͹��
���Uso       �                             			 					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fTela(aParcelas,aOldPar)  

	Local oButton1
	Local oButton2     
	Local oGroup1
	Default aParcelas 	:= {}
	Default aOldPar 	:= {}

	DEFINE MSDIALOG oDlg TITLE "Titulos a serem gerados" FROM 000, 000  TO 343, 500 COLORS 0, 16777215 PIXEL Style 128

	@ 002, 003 GROUP oGroup1 TO 152, 248 PROMPT "Titulos a serem gerados | " OF oDlg COLOR 0, 16777215 PIXEL
	@ 155, 209 BUTTON oButton1 PROMPT "Ok" SIZE 037, 012 OF oDlg Action fOk(@aParcelas,aOldPar) PIXEL
	@ 155, 169 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg Action fSair(@aParcelas,aOldPar) PIXEL
	fMSNewGe1(aParcelas)

	oDlg:lEscClose := .F.

	ACTIVATE MSDIALOG oDlg CENTERED

return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMSNewGe1  �Autor  � Tarc�sio Silva    � Data �  17/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria todos os componentes da grid.						  ���
�������������������������������������������������������������������������͹��
���Uso       �                             			 					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fMSNewGe1(aParcelas)

	Local aFields	 	:= fRetColumn(1)
	Local cFieldsSQL 	:= fRetColumn(2)
	Local aCamposSX3 	:= u_fConvSX3(cFieldsSQL)
	Local aHeaderEx 	:= aClone(fLoadStr(aFields,aCamposSX3))
	Local aColsEx 		:= aClone(fCrgGrd(aParcelas))
	Local aAlterFields 	:= fRetColumn(1)
	Default aParcelas 	:= {}

	oMSNewGe1 := MsNewGetDados():New( 010, 006, 149, 245, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)
	oMSNewGe1:Refresh()

Return(Nil)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fSair      �Autor  � Tarc�sio Silva    � Data �  17/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �A��o do bot�o cancelar.									  ���
�������������������������������������������������������������������������͹��
���Uso       �                             			 					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fSair(aParcelas,aOldPar)

	Default aParcelas 	:= {}
	Default aOldPar 	:= {}

	aParcelas := aOldPar

	oDlg:End()

Return(Nil)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fOk        �Autor  � Tarc�sio Silva    � Data �  17/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �A��o do bot�o confirmar.									  ���
�������������������������������������������������������������������������͹��
���Uso       �                             			 					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fOk(aParcelas,aOldPar)

	Local nX 			:= 1
	Local nTotParc 		:= 0
	Local lContinua 	:= .T.
	Local lRet 			:= .T.
	Default aParcelas 	:= {}
	Default aOldPar 	:= {}

	For nX := 1 To Len(oMSNewGe1:aCols)  

		nTotParc += oMSNewGe1:aCols[nX][2]

	Next nX

	if nTotParc == M->E2_VALOR

		aParcelas := {}

		For nX := 1 To Len(oMSNewGe1:aCols)

			aadd(aParcelas,{oMSNewGe1:aCols[nX][1],oMSNewGe1:aCols[nX][2]})

		Next nX 

		lContinua := .F.

	else

		If MsgYesNo("Abandona Ajuste do Desdobramento?","Valor Total Incorreto!") //IW_MsgBox("Abandona Ajuste do Desdobramento?","Valor Total Incorreto" , "YESNO",2)

			aParcelas := aOldPar
			lContinua := .F.

		else

			lRet := .F.

		endif

	endif

	if lRet

		oDlg:End()

	endif

return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fRetColumn �Autor  � Tarc�sio Silva    � Data �  17/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna as colunas que ser�o apresentadas na grid.		  ���
�������������������������������������������������������������������������͹��
���Uso       �                             			 					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fRetColumn(_nOpc)

	Local cRet := ""
	Local aAux := {}
	Local aRet := {}

	if _nOpc == 1 

		aAdd(aAux,"E2_VENCREA")
		aAdd(aAux,"E2_SALDO")
		aAdd(aRet,aAux)
		Return(aRet[1])

	elseif _nOpc == 2 

		cRet += "('E2_VENCREA',"
		cRet += "'E2_SALDO')"
		Return(cRet)

	endif

Return(Nil)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCrgGrd    �Autor  � Tarc�sio Silva    � Data �  17/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Preenche o conte�do da grid com as devidas informa��es.	  ���
�������������������������������������������������������������������������͹��
���Uso       �                             			 					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static function fCrgGrd(aParcelas)

	Local nX 			:= 1
	Local aRet 			:= {}
	Default aParcelas 	:= {}

	For nX := 1 To Len(aParcelas)

		aadd(aRet,{aParcelas[nX][1],aParcelas[nX][2],.f.})

	Next nX

Return(aRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fLoadStr   �Autor  � Tarc�sio Silva    � Data �  17/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega a estrutura da grid.								  ���
�������������������������������������������������������������������������͹��
���Uso       �                             			 					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fLoadStr(aFields,aCamposSX3)

	Local aHeaderEx 	:= {}
	Local nX 			:= 1
	Local nPosField		:= 0
	Default aFields 	:= {}
	Default aCamposSX3 	:= {}

	For nX := 1 To Len(aFields)

		nPosField := aScan(aCamposSX3,{|x| AllTrim(x[2]) == aFields[nX]})

		aAdd(aHeaderEx, {AllTrim(aCamposSX3[nPosField][1]),aCamposSX3[nPosField][2],aCamposSX3[nPosField][3],;
		aCamposSX3[nPosField][4],aCamposSX3[nPosField][5],aCamposSX3[nPosField][6],aCamposSX3[nPosField][7],;
		aCamposSX3[nPosField][8],aCamposSX3[nPosField][9],aCamposSX3[nPosField][10],aCamposSX3[nPosField][11],;
		aCamposSX3[nPosField][12]})

	Next nX

Return(aHeaderEx)