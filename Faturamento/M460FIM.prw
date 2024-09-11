#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³Sangelles           º Data ³  05/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para gravar a Forma de Pagamento na SE1   º±±
±±º          ³ e Imprimir Boleto Laser			                          º±±        
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Acelerador Totvs Goias                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º	Dados Adicionais de Alteracao/Ajustes do Fonte                        º±±  
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºData      ³ Descricao:                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±º 		 ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß  
*/

User Function M460FIM()

	Local aArea	:= GetArea()
	Local aSCV := SCV->( GetArea() )
	Local aSEA := SEA->( GetArea() )
	Local aSE1 := SE1->( GetArea() )
	Local aSF2 := SF2->( GetArea() )
	Local aSD2 := SD2->( GetArea() )
	Local aDAK := DAK->( GetArea() )
	Local aDAI := DAI->( GetArea() )
	Local aDAJ := DAJ->( GetArea() )
	Local aSA1 := SA1->( GetArea() )
	Local aSC5 := SC5->( GetArea() )
	Local aSC6 := SC6->( GetArea() )
	Local aSC9 := SC9->( GetArea() )
	Local aDCF := DCF->( GetArea() )
	Local aDAU := DAU->( GetArea() )
	Local aDA3 := DA3->( GetArea() )
	Local aDA4 := DA4->( GetArea() )
	Local aDB0 := DB0->( GetArea() )
	Local aDA5 := DA5->( GetArea() )
	Local aDA6 := DA6->( GetArea() )
	Local aDA7 := DA7->( GetArea() )
	Local aDA8 := DA8->( GetArea() )
	Local aDA9 := DA9->( GetArea() )
	Local aSB1 := SB1->( GetArea() )
	Local aSB2 := SB1->( GetArea() )
	Local aSB6 := SB1->( GetArea() )
//Local aSC9 := SB1->( GetArea() )
	Local aSED := SB1->( GetArea() )
	Local aSEE := SB1->( GetArea() )
	Local aSA6 := SB1->( GetArea() )
	Local aSX5 := SX5->( GetArea() )
	Local aMVs := { M->MV_PAR01, M->MV_PAR02, M->MV_PAR03, M->MV_PAR04, M->MV_PAR05, M->MV_PAR06,;
		M->MV_PAR07, M->MV_PAR08, M->MV_PAR09, M->MV_PAR10, M->MV_PAR11, M->MV_PAR12,;
		M->MV_PAR13, M->MV_PAR14, M->MV_PAR15, M->MV_PAR16, M->MV_PAR17, M->MV_PAR18,;
		M->MV_PAR19, M->MV_PAR20, M->MV_PAR21, M->MV_PAR22, M->MV_PAR23, M->MV_PAR24,;
		M->MV_PAR25 }
	Local nWorkArea := Select()
	Local _aVencto := {}
	Local cHist := ""
	Local _nValTitulos := 0
	Local _nValTitST   := 0
	Local _dNovaData  := ''   //calcula a data do vencimento do ICMS
//Local cEstTilImp  := AllTrim(GetMV("MV_XUFTIST"))
//Local cPrxTilImp  := AllTrim(GetMV("MV_XPRTIST"))
	Local  _aDados  := {}
	Local lBolet	  := GetMv("MV_GERBOLS",,.F.)
	Local cMV_1DUPREF := &(GetMV("MV_1DUPREF") )

//INFORMAR O PESO E VOLUME NA NOTA APENAS DOS ITENS FATURADOS
//PEDRO PAULO - TOTVS 13/03/2014
	Local cQuery := ""
	Local cEOL	 := Chr(13) + Chr(10)
	Local _nVol  := _nPesoB := _nPesoL := 0
	Local nDescCli  := 0
	Local lAutNFE := .T.
	Local cQry  := ''
	Local cMsg := ""

	If !Empty(SC5->C5_MENNOTA) //verifica se o campo de mensagem da nota está vazio no PV

		cMsg := SUBSTR(SC5->C5_XMENNOT,1,40) //mensagem pra nota no PV

		cQry:= "SELECT * FROM "+RetSqlName("SE1")+" SE1 "
		cQry+= "WHERE E1_FILIAL = '"+xFilial("SE1")+"'" "
		cQry+= "AND E1_CLIENTE = '"+SC5->C5_CLIENTE+"' "
		cQry+= "AND E1_LOJA = '"+SC5->C5_LOJACLI+"' "
		cQry+= "AND E1_PREFIXO = '"+CMV_1DUPREF+"' "
		cQry+= "AND E1_NUM = '"+cNumero+"' "
		cQry+= "AND D_E_L_E_T_ <> '*'

		cQry := ChangeQuery(cQry)
		dbUseArea(.T., "TOPCONN", tcGenQry(,, cQry), "TSE1", .F., .T.) //busca os títulos criados

		DbSelectArea("TSE1")
		TSE1->(DBGotop())

		If !Empty(TSE1->E1_PARCELA) //verifica o campo de parcela, pois só é preenchido com mais de 1 título 

			While TSE1->(!EOF())
				If SE1->(DbSeek(xFilial("SE1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI+CMV_1DUPREF+cNumero+TSE1->E1_PARCELA)) //caso tenha mais de um título, utiliza a parcela como filtro 

					Reclock('SE1', .F.)

					SE1->E1_HIST := cMsg //grava a informação no campo de histórico

					SE1->(MsUnlock())

				EndIf

				TSE1->(DbSkip())
			EndDo
		Else //caso a parcela esteja vazia significa que é apenas um título, então não utiliza a parcela como filtro nem while, grava somente na linha encontrada
			If SE1->(DbSeek(xFilial("SE1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI+CMV_1DUPREF+cNumero))

				Reclock('SE1', .F.)

				SE1->E1_HIST := cMsg //grava a informação no campo de histórico

				SE1->(MsUnlock())

			EndIf
		EndIf
		TSE1->(dbCloseArea())
	EndIf


//INFORMAR O DESCONTO FINANCEIRO DO CADASTRO DO CLIENTE PARA ALIMENTAR A SE1 E EMITIR BOLETO COM DESCONTO
//PEDRO PAULO - TOTVS 05/08/2016

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	if SA1->( DbSeek( xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),.f. ) )
		nDescCli := SA1->A1_XDESCFI
	endif

//Gravar nas informações complementares na RPS (F3_OBSERV), conforme fonte MATR968.PRW , o campo C5_MENNOTA - Inicio 08/07/2021
/*
DbSelectArea("SF3")
SF3->( DbSetOrder(5) ) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO                                                                                               
If SF3->(DbSeek( xFilial("SF3")+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA))
   IF SF3->F3_TIPO = "S"
      cHist := SC5->C5_MENNOTA

      RecLock("SF3",.F.)
      SF3->F3_OBSERV := cHist
      SF3->( MsUnLock() )
   EndIf
EndIf
*/
////Gravar nas informações complementares na RPS (F3_OBSERV), conforme fonte MATR968.PRW , o campo C5_MENNOTA - Fim 08/07/2021


//Gravar na na SAE - Administradora Financeira - SAE - Inicio
	If Cfilant == '0502' //Somente para Grid Minas - 0502
		DbSelectArea("SE4")
		SE4->( DbSetOrder(1) )
		If !DbSeek(xFilial("SE4")+SF2->F2_COND)
			RecLock("SE4",.T.)
			SAE->AE_COD     := xFilial("SAE")
			SAE->AE_DESC    := SE4->F4_DESCRI
			SAE->AE_TIPO    := SE4->F4_FORMA
			SAE->AE_FINPRO  := 'N'
			SAE->AE_USAFATO := 'N'
			SAE->AE_CODCLI  := SF2->F2_CLIENTE
			SAE->AE_REDE    := '04'
			SAE->( MsUnLock() )
		EndIf
	EndIf
//Gravar na SAE - Adminstradora Financeira - SAE - Fim

	DbSelectArea("SE1")
	SE1->( DbSetOrder(2) ) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If SE1->(DbSeek( xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC))

		While xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
			If SE1->E1_TIPO $ "'NF ','BOL','CH ','DEP','R$ '"
				RecLock("SE1",.F.)
				If	nDescCli > 0
					SE1->E1_DECRESC := ((SE1->E1_VALOR * nDescCli)/100)
					SE1->E1_SDDECRE := ((SE1->E1_VALOR * nDescCli)/100)
				Endif
				SE1->( MsUnLock() )
			EndIf

			SE1->( DbSkip() )
		EndDo

	endif

//FINALIZA GRAVAÇÃO DO DESCONTO FINANCEIRO NO TÍTULO     


	DBSelectArea("SC9")
	SC9->(DBSetOrder(2))

	If Select("TQC9") > 0
		TQC9->(DBCloseArea())
	EndIf
//===Busca Produtos Faturados do pedido posicionado
	cQuery := " SELECT C9_FILIAL,C9_CLIENTE,C9_LOJA,C9_PEDIDO,C9_PRODUTO,C9_ITEM,C9_QTDLIB,C9_PRCVEN FROM " + cEOL
	cQuery += " "+RetSqlName("SC9")+" SC9" + cEOL
	cQuery += "	WHERE SC9.C9_FILIAL='"+xFilial("SC9")+"'" + cEOL
	cQuery += "		AND SC9.C9_PEDIDO='"+SC5->C5_NUM+"' AND " + cEOL
	cQuery += "		SC9.C9_BLCRED='10' AND " + cEOL
	cQuery += "		SC9.C9_BLEST='10' AND " + cEOL
	cQuery += "		SC9.C9_NFISCAL = '"+SF2->F2_DOC+"' AND " + cEOL
	cQuery += "		SC9.C9_SERIENF = '"+SF2->F2_SERIE+"' AND " + cEOL
	cQuery += "		SC9.C9_CLIENTE = '"+SF2->F2_CLIENTE+"' AND " + cEOL
	cQuery += "		SC9.C9_LOJA = '"+SF2->F2_LOJA+"' AND " + cEOL
	cQuery += "		SC9.D_E_L_E_T_<>'*' " + cEOL
	cQuery += " ORDER BY C9_ITEM,C9_PRODUTO " + cEOL

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", tcGenQry(,, cQuery), "TQC9", .F., .T.)

	TQC9->(DBGotop())

//Varre arquivo temporario gerando volume, peso bruto e liquidos dos produtos faturados		
	While TQC9->(!EOF())
		If SB1->(dbseek(xFilial("SB1")+TQC9->C9_PRODUTO))
			_nVol   += TQC9->C9_QTDLIB//Soma volume
			_nPesoB += TQC9->C9_QTDLIB*SB1->B1_PESBRU //soma o peso bruto total
			_nPesoL += TQC9->C9_QTDLIB*SB1->B1_PESO //soma o peso liquido total
		EndIf
		TQC9->(DBSkip())
	EndDo

	TQC9->(DBCloseArea())

//Grava na SF2 o peso e volume calculado
//IF RecLock("SF2",.F.)
	//SF2->F2_VOLUME1 := _nVol
	//SF2->F2_PBRUTO  := _nPesoB
	//SF2->F2_PLIQUI  := _nPesoL
	//SF2->(MsUnlock())
//EndIf

//FIM GRAVA VOLUME - PEDRO PAULO - TOTVS

//Grava SCV conforme campo C5_XFORPG
	GravaSCV()

//*************************************************************
//Grava CDL - Gerar Automatico Dados SPED Exportação  (Claudio)
	GravaCDL()
//Grava as informações Adicionais na remessa de locação // 29/04/2021
	GravZL()
//*************************************************************                                   

/* -- Transmite a nota automaticamente para Sefaz --
		Parametros AutoNfeEnv:
		cEmpresa,
		cFilial,
		cEspera,
		cAmbiente (1=producao,2=Homologcao) Muito cuidado.
		cSerie
		cDoc.Inicial
		cDoc.Final
		*/

	//Transmite nota automatica ES_AUTNFE
	// if lAutNFE .and. ALLTRIM(SF2->F2_SERIE) == '1' //verifica espécie == 1
	//Conout('- > [AUTONFE] Inicio Processo ' + Time() + ' ' + SF2->F2_DOC + '/' + SF2->F2_SERIE )
	//AutoNfeEnv(cEmpAnt, cFilAnt, "0", "1", SF2->F2_SERIE, SF2->F2_DOC, SF2->F2_DOC)
	// EndIf
	If lBolet //
		If cFilAnt == '1001'
			If MsgYesNo("Deseja Gerar Boleto para o Banco Santander ?","ATENÇÃO")

				cPerg     :="TBOL04"
				aAreaSX1 := SX1->(GetArea())
				cDoc   := SF2->F2_DOC
				cSerie := SF2->F2_SERIE

				dbSelectArea("SX1")
				SX1->(DbGoTop())
				dbSetOrder(1)
				If dbSeek(cPerg)
					While SX1->(!EoF()) .AND. ALLTRIM(SX1->X1_GRUPO) == cPerg
						If SX1->X1_ORDEM $ '01/02'
							RecLock("SX1",.F.)
							Replace SX1->X1_CNT01 with cSerie
							MSUnLock()
						EndIf
						If SX1->X1_ORDEM $ '03/04'
							RecLock("SX1",.F.)
							Replace SX1->X1_CNT01 with cDoc
							MsUnlock()
						EndIf
						If SX1->X1_ORDEM == '18'
							RecLock("SX1",.F.)
							Replace SX1->X1_PRESEL with 2
							MsUnlock()
						EndIf
						SX1->(DbSkip())
					EndDo
				EndIf
				RestArea(aAreaSX1)
				U_FSFIN003()
			EndIf
		Else
			If MsgYesNo("Deseja Gerar Boleto para o Banco Itaú ?","ATENÇÃO")
				cPerg     :="TBOL04"
				aAreaSX1 := SX1->(GetArea())
				cDoc   := SF2->F2_DOC
				cSerie := SF2->F2_SERIE

				dbSelectArea("SX1")
				SX1->(DbGoTop())
				dbSetOrder(1)
				If dbSeek(cPerg)
					While SX1->(!EoF()) .AND. ALLTRIM(SX1->X1_GRUPO) == cPerg
						If SX1->X1_ORDEM $ '01/02'
							RecLock("SX1",.F.)
							Replace SX1->X1_CNT01 with cSerie
							MSUnLock()
						EndIf
						If SX1->X1_ORDEM $ '03/04'
							RecLock("SX1",.F.)
							Replace SX1->X1_CNT01 with cDoc
							MsUnlock()
						EndIf
						If SX1->X1_ORDEM == '18'
							RecLock("SX1",.F.)
							Replace SX1->X1_PRESEL with 2
							MsUnlock()
						EndIf
						SX1->(DbSkip())
					EndDo
				EndIf
				RestArea(aAreaSX1)

				U_BltItau() //Chama a função do Boleto do Itaú - Ricardo Moreira 21/07/2020
			Else
				Return
				//Gerar o Boleto do Itau - Inicio
				//U_AFINP001()  //chamada do Acelerador Totvs (Fonte exclusivo TOTVS Goiás)
			EndIf
		EndIf

	Else
		cPerg     :="TBOL04"
		aAreaSX1 := SX1->(GetArea())
		cDoc   := SF2->F2_DOC
		cSerie := SF2->F2_SERIE

		dbSelectArea("SX1")
		SX1->(DbGoTop())
		dbSetOrder(1)
		If dbSeek(cPerg)
			While SX1->(!EoF()) .AND. ALLTRIM(SX1->X1_GRUPO) == cPerg
				If SX1->X1_ORDEM $ '01/02'
					RecLock("SX1",.F.)
					Replace SX1->X1_CNT01 with cSerie
					MSUnLock()
				EndIf
				If SX1->X1_ORDEM $ '03/04'
					RecLock("SX1",.F.)
					Replace SX1->X1_CNT01 with cDoc
					MsUnlock()
				EndIf
				If SX1->X1_ORDEM == '18'
					RecLock("SX1",.F.)
					Replace SX1->X1_PRESEL with 2
					MsUnlock()
				EndIf
				SX1->(DbSkip())
			EndDo
		EndIf
		RestArea(aAreaSX1)
		U_BltItau() //Chama a função do Boleto do Itaú - Ricardo Moreira 21/07/2020

	EndIf

	RestArea(aSEA)
	RestArea(aSCV )
	RestArea(aSE1 )
	RestArea(aSF2 )
	RestArea(aSD2 )
	RestArea(aDAK )
	RestArea(aDAI )
	RestArea(aDAJ )
	RestArea(aSA1 )
	RestArea(aSC5 )
	RestArea(aSC6 )
	RestArea(aSC9 )
	RestArea(aDCF )
	RestArea(aDAU )
	RestArea(aDA3 )
	RestArea(aDA4 )
	RestArea(aDB0 )
	RestArea(aDA5 )
	RestArea(aDA6 )
	RestArea(aDA7 )
	RestArea(aDA8 )
	RestArea(aDA9 )
	RestArea(aSB1 )
	RestArea(aSB2 )
	RestArea(aSB6 )
	RestArea(aSC9 )
	RestArea(aSED )
	RestArea(aSEE )
	RestArea(aSA6 )
	RestArea(aSX5 )

	MV_PAR01 := aMVs[01]
	MV_PAR02 := aMVs[02]
	MV_PAR03 := aMVs[03]
	MV_PAR04 := aMVs[04]
	MV_PAR05 := aMVs[05]
	MV_PAR06 := aMVs[06]
	MV_PAR07 := aMVs[07]
	MV_PAR08 := aMVs[08]
	MV_PAR09 := aMVs[09]
	MV_PAR10 := aMVs[10]
	MV_PAR11 := aMVs[11]
	MV_PAR12 := aMVs[12]
	MV_PAR13 := aMVs[13]
	MV_PAR14 := aMVs[14]
	MV_PAR15 := aMVs[15]
	MV_PAR16 := aMVs[16]
	MV_PAR17 := aMVs[17]
	MV_PAR18 := aMVs[18]
	MV_PAR19 := aMVs[19]
	MV_PAR20 := aMVs[20]
	MV_PAR21 := aMVs[21]
	MV_PAR22 := aMVs[22]
	MV_PAR23 := aMVs[23]
	MV_PAR24 := aMVs[24]
	MV_PAR25 := aMVs[25]

	SELECT(nWorkArea)
	RestArea(aArea)

/* Prencher a forma de pagamento do pedido de venda na tabela SCV  */

Static Function GravaSCV() //Grava Forma de Pagamento
	Local cPed     := SC5->C5_NUM
	Local cFormaPG := SC5->C5_XFORPG, cChave := ""
	Local nCont    := 0
	Local _nForm   := .T.

	SX5->( dbSetOrder(1) )
	SCV->( DbSetOrder(1) )                                                                                                                             //CV_FILIAL+CV_PEDIDO+CV_FORMAPG

	if SCV->(DbSeek(xFilial("SCV")+cPed))

		cChave := SCV->(CV_FILIAL+CV_PEDIDO)             //Verifica se realmente foi gravado a forma de Pagamento.
		_nForm := .F.

		while cChave == SCV->(CV_FILIAL+CV_PEDIDO)

			if SX5->( dbSeek(xFilial()+"24"+cFormaPG) )

				RecLock("SCV",.F.)

				// SCV->CV_FILIAL  := xFilial("SCV") //Se existir a forma de pagamento altera para a forma de pagamento correta.
				// SCV->CV_PEDIDO  := cPed
				// SCV->CV_RATFOR  := 100

				SCV->CV_FORMAPG := AllTrim(SX5->X5_CHAVE)
				SCV->CV_DESCFOR := AllTrim(SX5->X5_DESCRI)

				SCV->(MsUnLock())

			endif

			nCont++
			SCV->( DbSkip() )

		enddo

	endif //Caso não exista Forma de pagamento Grava a Forma Correta.

	If _nForm

		SX5->( dbSetOrder(1) )
		if SX5->( dbSeek( xFilial("SX5")+"24"+cFormaPG) )

			RecLock("SCV",.T.)

			SCV->CV_FILIAL  := xFilial("SCV")
			SCV->CV_PEDIDO  := cPed
			SCV->CV_FORMAPG := AllTrim(SX5->X5_CHAVE)
			SCV->CV_DESCFOR := AllTrim(SX5->X5_DESCRI)
			SCV->CV_RATFOR  := 100

			SCV->( MsUnLock() )

		endif

	endIf


Return .T.


Static Function GravaCDL()

	Local lCDL := .F.
	Local aSF2 := SF2->( GetArea() )
	Local aSD2 := SD2->( GetArea() )

//*********************************************
// Gerar Automatico Dados SPED Exportação
//*********************************************
	If SF2->F2_EST == "EX"

		SD2->(dbsetorder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		cChaveSD2:=SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
		If SD2->(dbseek(cChaveSD2))
			SC5->( DbSetOrder(1), DbSeek( xFilial("SC5") + SD2->D2_PEDIDO ) )
			While !SD2->(eof()) .and. cChaveSD2 == SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
				lCDL := CDL->( DbSetOrder(2),DbSeek( xFilial("CDL") + SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_ITEM) ) )

				RecLock("CDL",!lCDL)

				CDL->CDL_FILIAL := SF2->F2_FILIAL
				CDL->CDL_DOC	:= SF2->F2_DOC
				CDL->CDL_SERIE	:= SF2->F2_SERIE
				CDL->CDL_ESPEC	:= SF2->F2_ESPECIE
				CDL->CDL_CLIENT	:= SF2->F2_CLIENTE
				CDL->CDL_LOJA	:= SF2->F2_LOJA
				CDL->CDL_EMIEXP := SF2->F2_EMISSAO
				CDL->CDL_DTDE   := SF2->F2_EMISSAO
				CDL->CDL_DTAVB  := SF2->F2_EMISSAO
				CDL->CDL_UFEMB	:= SC5->C5_UFEMB
				CDL->CDL_LOCEMB	:= SC5->C5_LOCEMB
				CDL->CDL_PRODNF := SD2->D2_COD
				CDL->CDL_ITEMNF := SD2->D2_ITEM

				CDL->( DbUnLock() )

				SD2->(dbskip())
			Enddo
		Endif

	Endif

	RestArea(aSF2)
	RestArea(aSD2)

Return

//Grava a ZLC e ZLI (TABELAS AUXILIARES DE LOCAÇAÕ)

Static function GravZL()

	Local aSF2 := SF2->( GetArea() )
	Local aSD2 := SD2->( GetArea() )

	If SC5->C5_XFORPG = "RE" //Forma de Pagamento Remessa de locação 11/05/2021

		DbSelectArea("ZLC")
		DbSetOrder(1)//CDL_FILIAL+CDL_DOC+CDL_SERIE+CDL_CLIENT+CDL
		If !DbSeek(xFilial("ZLC")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
			ZLC->(RECLOCK("ZLC",.T.))
			ZLC->ZLC_FILIAL :=xFilial("ZLC")
			ZLC->ZLC_PEDIDO	  := SC5->C5_NUM
			ZLC->ZLC_NOTA       := SF2->F2_DOC
			ZLC->ZLC_SERIE      := SF2->F2_SERIE
			ZLC->ZLC_CLIENT     := SF2->F2_CLIENT
			ZLC->ZLC_LOJA       := SF2->F2_LOJA
			ZLC->ZLC_EMIS       := SF2->F2_EMISSAO
			ZLC->ZLC_VALOR      := SF2->F2_VALBRUT
			ZLC->(MSUNLOCK())
			ZLC->(dbSkip())
		EndIf

		DbSelectArea("SD2")
		DbSetOrder(3)//CDL_FILIAL+CDL_DOC+CDL_SERIE+CDL_CLIENT+CDL_LOJA+CDL_ITEMNF+CDL_NUMDE+CDL_DOCORI+CDL_SERORI+CDL_FORNEC+CDL_LOJFOR+CDL_NRREG
		If DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
			DO WHILE SD2->(!EOF()) .AND. SD2->D2_FILIAL = xFilial("SF2") .AND. SD2->D2_DOC = SF2->F2_DOC .AND. SD2->D2_SERIE = SF2->F2_SERIE .AND. SD2->D2_CLIENTE = SF2->F2_CLIENTE .AND. SD2->D2_LOJA = SF2->F2_LOJA .AND. substr(SD2->D2_CF,2,3) = "908"
				//If SD2->D2_CF = "5908"
				DbSelectArea("ZLI")
				DbSetOrder(1)//CDL_FILIAL+CDL_DOC+CDL_SERIE+CDL_CLIENT+CDL_LOJA+CDL_ITEMNF+CDL_NUMDE+CDL_DOCORI+CDL_SERORI+CDL_FORNEC+CDL_LOJFOR+CDL_NRREG
				If !DbSeek(xFilial("ZLI")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_ITEM+SD2->D2_COD)
					ZLI->(RECLOCK("ZLI",.T.))
					ZLI->ZLI_FILIAL :=xFilial("ZLI")
					ZLI->ZLI_NOTA       := SD2->D2_DOC
					ZLI->ZLI_SERIE      := SD2->D2_SERIE
					ZLI->ZLI_PROD       := SD2->D2_COD
					ZLI->ZLI_ITEM       := SD2->D2_ITEM
					ZLI->ZLI_DESCPR     := POSICIONE("SB1",1,XFILIAL("SB1")+SD2->D2_COD,"B1_DESC")
					ZLI->ZLI_QUANT      := SD2->D2_QUANT
					ZLI->ZLI_VLRUNI     := SD2->D2_PRCVEN
					ZLI->ZLI_VLRTOT     := SD2->D2_TOTAL
					ZLI->ZLI_LOTE       := SD2->D2_LOTECTL
					ZLI->(MSUNLOCK())
				ELSE
					ZLI->(RECLOCK("ZLI",.F.))
					ZLI->ZLI_FILIAL :=xFilial("ZLI")
					ZLI->ZLI_NOTA       := SD2->D2_DOC
					ZLI->ZLI_SERIE      := SD2->D2_SERIE
					ZLI->ZLI_PROD       := SD2->D2_COD
					ZLI->ZLI_ITEM       := SD2->D2_ITEM
					ZLI->ZLI_DESCPR     := POSICIONE("SB1",1,XFILIAL("SB1")+SD2->D2_COD,"B1_DESC")
					ZLI->ZLI_QUANT      := SD2->D2_QUANT
					ZLI->ZLI_VLRUNI     := SD2->D2_PRCVEN
					ZLI->ZLI_VLRTOT     := SD2->D2_TOTAL
					ZLI->ZLI_LOTE       := SD2->D2_LOTECTL
					ZLI->(MSUNLOCK())
				EndIf
				SD2->(dbSkip())
				//EndIf
			EndDo
		EndIf
	EndIf
	RestArea(aSF2)
	RestArea(aSD2)

Return
