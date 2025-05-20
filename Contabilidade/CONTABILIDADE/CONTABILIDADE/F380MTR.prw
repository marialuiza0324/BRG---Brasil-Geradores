#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F380MTR   �Autor  �CF				     � Data �  20/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada no momento da concilia��o                 ���
�������������������������������������������������������������������������͹��
���Uso       � SGL/FAG                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F380MTR
	Local cArquivo
	Local cPadrao
	Local lHead		:= .F.					// Ja montou o cabecalho?
	Local lPadrao
	Local nTotal	:=0
	Local nHdlPrv	:=0
	Local cLote     :='008850'
	Local OldDataBase:=dDataBase

	DbSelectArea("TRB")
	dbGoTop()
	While ! Eof()
		dbSelectArea("SE5")
		dbGoTo( TRB->E5_RECNO )
		IF !lHead
			lHead := .T.
			nHdlPrv:=HeadProva(cLote,"RFIN380",Substr(cUsuario,7,6),@cArquivo)
		End
		//Verifico se nao estava reconciliado anteriormente
		cReconAnt := SE5->E5_RECONC
		lEstorna:=.f.
		If cReconAnt='x' .and. (SE5->E5_DTDISPO # TRB->E5_DTDISPO .or. Empty(TRB->E5_OK))
			lEstorna:=.t.
			dOldDispo:=SE5->E5_DTDISPO
			if nTotal>0
				RodaProva(nHdlPrv,nTotal)

				//�����������������������������������������������������Ŀ
				//� Envia para Lan�amento Cont�bil                      �
				//�������������������������������������������������������
				lDigita	:=.T.
				lAglut 	:=.T.
				cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
				nTotal:=0
			endif
			//Inicia o estorno
			nHdlPrv:=HeadProva(cLote,"RFIN380",Substr(cUsuario,7,6),@cArquivo)
			cPadrao	:= '002'
			lPadrao	:= VerPadrao(cPadrao)
			dDataBase:=dOldDispo
			IF lPadrao
				nTotal += DetProva(nHdlPrv,cPadrao,"RFIN380",cLote)
			EndIf
			//�����������������������������������������������������Ŀ
			//� Envia para Lan�amento Cont�bil                      �
			//�������������������������������������������������������
			lDigita	:=.T.
			lAglut 	:=.T.
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
			lHead := .F.
			nTotal:=0
			dDataBase:=TRB->E5_DTDISPO
		End
		IF !lHead
			lHead := .T.
			nHdlPrv:=HeadProva(cLote,"RFIN380",Substr(cUsuario,7,6),@cArquivo)
		End
		dDataBase:=TRB->E5_DTDISPO
		If !Empty(TRB->E5_OK) .and. (Empty(cReconAnt).or.lEstorna)
			cPadrao	:= '001'
			lPadrao	:= VerPadrao(cPadrao)
			IF lPadrao
				nTotal += DetProva(nHdlPrv,cPadrao,"RFIN380",cLote)
			EndIf
		Endif
		DbSelectArea("TRB")
		dbSkip()
		if dDataBase<>TRB->E5_DTDISPO
			RodaProva(nHdlPrv,nTotal)

			//�����������������������������������������������������Ŀ
			//� Envia para Lan�amento Cont�bil                      �
			//�������������������������������������������������������
			lDigita	:=.T.
			lAglut 	:=.T.
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
			lHead := .F.
			nTotal:=0
		endif

	Enddo
//�����������������������������������������������������Ŀ
//� Grava Rodape                                        �
//�������������������������������������������������������
	If lHead
		RodaProva(nHdlPrv,nTotal)
		//�����������������������������������������������������Ŀ
		//� Envia para Lan�amento Cont�bil                      �
		//�������������������������������������������������������
		lDigita := .T.
		lAglut  := .T.
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
	Endif
	dbGoTop()
	dDataBase:=OldDataBase
Return

