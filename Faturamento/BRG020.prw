/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � BRG020  � Autor � Ricardo Moreira� 		  Data � 21/02/17 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Impress�o de Fatura   									  ���
���          � 						                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para BRG                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function BRG020()

//Private _Nf        := SC5->C5_NOTA 
//Private _Serie     := SC5->C5_SERIE
	Local _Desc,_End,_Bair,_Cid,_Uf := " "
	Local _aBmp 		:= {}
	Local cFormPg 		:= ""
	Local cNfRem 		:= ""
	Local aNfRem 		:= {}
	Local nValor 		:= 0
	Local nInicio 		:= 1
	Local nFim			:= 0
	Local nCont			:= 0
	Local nFimPalavra 	:= ""
	Local cTexto		:= ""
	Local nMaxLen		:= 95
	Local nPosicao 		:= 0
	Local nLinRodape    := 2300 // Posi��o fixa para o rodap� (ajust�vel conforme necessidade)
	Local nEspacoRodape := 400  // Espa�o reservado para o rodap� (estimado)

	Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
	Private oFont6N 	:= TFONT():New("ARIAL",7,6,,.T.,,,,.T.,.F.) ///Fonte 6 Negrito
	Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
	Private oFont8N 	:= TFONT():New("ARIAL",8,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
	Private oFont9N 	:= TFONT():New("ARIAL",9,9,,.T.,,,,.T.,.F.) ///Fonte 9 Negrito
	Private oFont10    	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 10 Normal
	Private oFont10S	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.T.) ///Fonte 10 Sublinhando
	Private oFont10N 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.F.) ///Fonte 10 Negrito
	Private oFont12		:= TFONT():New("ARIAL",12,12,,.F.,,,,.T.,.F.) ///Fonte 12 Normal
	Private oFont12NS	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.T.) ///Fonte 12 Negrito e Sublinhado
	Private oFont12N	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito
	Private oFont14		:= TFONT():New("ARIAL",14,14,,.F.,,,,.T.,.F.) ///Fonte 14 Normal
	Private oFont14NS	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.T.) ///Fonte 14 Negrito e Sublinhado
	Private oFont14N	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.F.) ///Fonte 14 Negrito
	Private oFont16  	:= TFONT():New("ARIAL",16,16,,.F.,,,,.T.,.F.) ///Fonte 16 Normal
	Private oFont16N	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
	Private oFont16NS	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.T.) ///Fonte 16 Negrito e Sublinhado
	Private oFont20N	:= TFONT():New("ARIAL",20,20,,.T.,,,,.T.,.F.) ///Fonte 20 Negrito
	Private oFont22N	:= TFONT():New("ARIAL",22,22,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito

//�Variveis para impress�o                                              �
	Private cStartPath
	Private nLin 		:= 50
	Private nLinMax 	:= 3000 // Defina o n�mero m�ximo de linhas por p�gina
	Private oPrint
	Private _Emp
	Private cPerg 		:= "BRG020"
	Private nRepita // variavel que controla a quantidade de relatorios impressos
	Private nContador // contador do for principal, que imprime o relatorio n vezes
	Private nZ
	Private nJ
	Private cLogoD
	Private _Nf        := SC5->C5_NOTA
	Private _Serie     := SC5->C5_SERIE
	Private _Tot       := 0
	Private _TotIpi    := 0
	Private _TotDif    := 0
	Private _Local     := " "
	Private _LtCtl     := " "
	Private _Prod      := " "
	Private _NumSeq    := " "
	Private _AlqDif    := 0
	Private cLogo      := ''
	Private nDesconto  := 0
	Private _Nun       := SC5->C5_NUM
	Private nTotReal   := 0

	If SC5->C5_TPDOC <> "F"
		MSGINFO("Tipo de Documento Incorreto para a impress�o. !!! "," Aten��o ")
		Return
	EndIf

	If oPrint == Nil
		oPrint:=FWMSPrinter():New("Fatura",6,.T.,,.T.)
		oPrint:SetPortrait()
		oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
		oPrint:cPathPDF :="C:\TEMP\"
	EndIf

	oPrint:StartPage()
	cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
	cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")

	cLogo := "\system\danfe"+cEmpAnt+cFilAnt+".bmp"

	oPrint:SayBitmap(nLin+010, 0160, cLogo, 350, 300)
	nLin+=100
	oPrint:Say(nLin,550,SM0->M0_NOMECOM,oFont10)
	nLin+=50
	oPrint:Say(nLin, 1400,  ("FATURA DE LOCA��O N.�: ")+SC5->C5_NOTA+"/"+SC5->C5_SERIE, oFont16N)
	oPrint:Say(nLin,550,SM0->M0_ENDCOB,oFont10)
	nLin+=50
	oPrint:Say(nLin,550,AllTrim(SM0->M0_BAIRCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB+" - CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont10)
	nLin+=50
	oPrint:Say(nLin,550,"FONE: " + SM0->M0_TEL ,oFont10)
	nLin+=50
	oPrint:Say(nLin,550,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   " +"IE:"+ SM0->M0_INSC,oFont10)
	nLin+=100

	_Desc     := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
	_End      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_END")
	_Bair     := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_BAIRRO")
	_Cid      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_MUN")
	_Uf       := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")
	_Cnpj     := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CGC")
	_CEP      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CEP")
	_TEL      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_TEL")
	_TpCli    := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_TIPO")

	oPrint:Say(nLin, 100,  ("Emiss�o:"), oFont12)
	oPrint:Say(nLin, 1570,  ("Telefone:"), oFont12)
	oPrint:Say(nLin, 300,  CVALTOCHAR(SC5->C5_EMISSAO), oFont12N)
	oPrint:Say(nLin, 1800, TRANSFORM(_TEL,"@R (99)9999-9999"), oFont12N)
	nLin+=70
	oPrint:Say(nLin, 100, ("Cliente:"), oFont12)
	oPrint:Say(nLin, 300,  SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI +"-"+_Desc, oFont12N)
	oPrint:Say(nLin, 1570, ("CNPJ:"), oFont12)
	oPrint:Say(nLin, 1800, TRANSFORM(_Cnpj,"@R 99.999.999/9999-99"),oFont12N)
	nLin+=70
	oPrint:Say(nLin, 100,  ("Endere�o:"), oFont12)
	oPrint:Say(nLin, 300,  _End, oFont12N)
	oPrint:Say(nLin, 1570,  ("Cidade:"), oFont12)
	oPrint:Say(nLin, 1800,  alltrim(_Cid)+"/"+_Uf, oFont12N)
	nLin+=70
	oPrint:Say(nLin, 100,  ("Cond. Pgto:"), oFont12)
	_Cond := Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI")
	oPrint:Say(nLin, 300,  SC5->C5_CONDPAG+" - "+_Cond, oFont12N)
	oPrint:Say(nLin, 1570,  ("Cep:"), oFont12)
	oPrint:Say(nLin, 1800,  TRANSFORM(_CEP,"@R 99999-999"), oFont12N)
	nLin+=70
	oPrint:Say(nLin, 100,  ("Contrato:"), oFont12)
	oPrint:Say(nLin, 300,  SC5->C5_XCONTRA, oFont12N)
	oPrint:Say(nLin, 1570,  ("Ped Compra:"), oFont12)
	oPrint:Say(nLin, 1800, SC5->C5_XPEDCOM, oFont12N)
	nLin+=70
	oPrint:Say(nLin, 100,  ("Proposta:"), oFont12)
	oPrint:Say(nLin, 300,  SC5->C5_XPROPOS, oFont12N)
	oPrint:Say(nLin, 1570,  ("Respons�vel:"), oFont12)
	oPrint:Say(nLin, 1800, SC5->C5_XUSER, oFont12N)
	nLin+=100
	oPrint:Say(nLin, 100,  ("Item"), oFont10N)
	oPrint:Say(nLin, 220,  ("Produto"), oFont10N)
	oPrint:Say(nLin, 380,  ("Descri��o"), oFont10N)
	oPrint:Say(nLin, 1000, ("Serie"), oFont10N)
	oPrint:Say(nLin, 1200, ("Qtde"), oFont10N)
	oPrint:Say(nLin, 1500, ("Valor Unit."), oFont10N)
	oPrint:Say(nLin, 1800, ("Desconto"), oFont10N)
	oPrint:Say(nLin, 2050, ("Total"), oFont10N)
	nLin+=50
	oPrint:Line(nLin,100,nLin,2200)
	nLin+=50

	dbSelectArea("SC6")
	dbsetorder(1)
	dbSeek(xFilial("SC6")+_Nun)

	While SC6->(!EOF()) .AND. xFilial("SC6") = SC6->C6_FILIAL .AND. SC6->C6_NUM = _Nun

		nTotReal:= SC6->C6_PRCVEN+SC6->C6_VALDESC

		_Tot  := _Tot + SC6->C6_VALOR
		nDesconto += SC6->C6_VALDESC

		// Verifica se h� espa�o para o item e o rodap�
		If nLin + 50 + nEspacoRodape <= nLinMax
			oPrint:Say(nLin, 110, SC6->C6_ITEM, oFont10)
			oPrint:Say(nLin, 230, SC6->C6_PRODUTO, oFont10)
			oPrint:Say(nLin, 390, SC6->C6_DESCRI, oFont10)
			oPrint:Say(nLin, 1010, SC6->C6_XSEREQU, oFont10)
			oPrint:Say(nLin, 1250, cValToChar(SC6->C6_QTDVEN), oFont10,,,,1)
			oPrint:Say(nLin, 1550, Transform(nTotReal, "@e 999,999,999.99"), oFont10,,,,1)
			oPrint:Say(nLin, 1850, Transform(SC6->C6_VALDESC, "@e 999,999,999.99"), oFont10,,,,1)
			
			If !Empty(SC6->C6_VALDESC)
				oPrint:Say(nLin, 2070, Transform(nTotReal-nDesconto, "@e 999,999,999.99"), oFont10,,,,1)
			Else
				oPrint:Say(nLin, 2070, Transform(SC6->C6_PRCVEN, "@e 999,999,999.99"), oFont10,,,,1)
			EndIf
			nLin+=50

		Else
			   nTotReal:= SC6->C6_PRCVEN+SC6->C6_VALDESC

				nDesconto += SC6->C6_VALDESC

				_Tot  := _Tot + SC6->C6_VALOR

			// Finaliza a p�gina e inicia uma nova
			oPrint:Line(nLin,100,nLin,2200)
			oPrint:EndPage()
			oPrint:StartPage()
			nLin := 50
			// Reimprime cabe�alho dos itens na nova p�gina
			oPrint:Say(nLin, 100,  ("Item"), oFont10N)
			oPrint:Say(nLin, 220,  ("Produto"), oFont10N)
			oPrint:Say(nLin, 380,  ("Descri��o"), oFont10N)
			oPrint:Say(nLin, 1000, ("Serie"), oFont10N)
			oPrint:Say(nLin, 1200, ("Qtde"), oFont10N)
			oPrint:Say(nLin, 1500, ("Valor Unit."), oFont10N)
			oPrint:Say(nLin, 1800, ("Desconto"), oFont10N)
			oPrint:Say(nLin, 2100, ("Total"), oFont10N)
			nLin+=50
			oPrint:Line(nLin,100,nLin,2200)
			nLin+=50
			// Imprime o item
			oPrint:Say(nLin, 110, SC6->C6_ITEM, oFont10)
			oPrint:Say(nLin, 230, SC6->C6_PRODUTO, oFont10)
			oPrint:Say(nLin, 390, SC6->C6_DESCRI, oFont10)
			oPrint:Say(nLin, 1010, SC6->C6_XSEREQU, oFont10)
			oPrint:Say(nLin, 1250, cValToChar(SC6->C6_QTDVEN), oFont10,,,,1)
			oPrint:Say(nLin, 1550, Transform(nTotReal, "@e 999,999,999.99"), oFont10,,,,1)
			oPrint:Say(nLin, 1850, Transform(SC6->C6_VALDESC, "@e 999,999,999.99"), oFont10,,,,1)
			
			If !Empty(SC6->C6_VALDESC)
				oPrint:Say(nLin, 2070, Transform(nTotReal-nDesconto, "@e 999,999,999.99"), oFont10,,,,1)
			Else
				oPrint:Say(nLin, 2070, Transform(SC6->C6_PRCVEN, "@e 999,999,999.99"), oFont10,,,,1)
			EndIf
			nLin+=50

		EndIf
		SC6->(dbSkip())
	EndDo

// Ap�s o loop, desenha linha de separa��o
	oPrint:Line(nLin,100,nLin,2200)

// Ajusta nLin para o rodap�, se houver espa�o suficiente
	If nLin + nEspacoRodape > nLinMax
		oPrint:EndPage()
		oPrint:StartPage()
		nLin := nLinRodape
	Else
		nLin := nLinRodape
	EndIf

// Imprime o rodap�
	PrintRodape()

	oPrint:EndPage()
	MS_FLUSH()
	oPrint:Preview()
Return()

// Fun��o auxiliar para imprimir o rodap�
Static Function PrintRodape()

	Local nValor, cNfRem := "", aNfRem, nInicio := 1, nFim, nCont := 1, nPosicao, cTexto := SC5->C5_MENNOTA
	Local nMaxLen := 95

	// Imprime o rodap� com o novo layout
	oPrint:Say(nLin, 0110, "FATURA DE LOCA��O N.�: " + SC5->C5_NOTA + "/" + SC5->C5_SERIE, oFont14N)
	nLin += 50
	oPrint:Say(nLin, 0110, "PER�ODO: REF: " + SUBSTR(DTOS(SC5->C5_XDTINI),7,2) + "/" + SUBSTR(DTOS(SC5->C5_XDTINI),5,2) + "/" + SUBSTR(DTOS(SC5->C5_XDTINI),1,4) + " A " + SUBSTR(DTOS(SC5->C5_XDTFIM),7,2) + "/" + SUBSTR(DTOS(SC5->C5_XDTFIM),5,2) + "/" + SUBSTR(DTOS(SC5->C5_XDTFIM),1,4), oFont14N)
	nLin += 50
	aNfRem := SEPARA(SC5->C5_NFREM,'/',.T.)
	FOR nValor := 1 to Len(aNfRem)
		if cNfRem == "" .AND. Len(aNfRem) == 1
			oPrint:Say(nLin, 0110, "NF REMESSA: " + CVALTOCHAR(aNfRem[nValor]), oFont14N)
			nLin += 50
		elseif cNfRem == "" .AND. Len(aNfRem) > 1
			cNfRem := CVALTOCHAR(aNfRem[nValor])
		else
			cNfRem := cNfRem + " - " + CVALTOCHAR(aNfRem[nValor])
			if Mod(nValor, 8) == 0 .OR. nValor == Len(aNfRem)
				oPrint:Say(nLin, 0110, "NF REMESSA: " + cNfRem, oFont14N)
				cNfRem := ""
				nLin += 50
			endif
		endif
	next
	nLin += 50
	oPrint:Say(nLin, 0110, "PEDIDO N.�: " + SC5->C5_NUM, oFont14N)
	nLin += 50
	oPrint:Say(nLin, 0110, "ID Cobran�a: " + SC5->C5_XIDCOB, oFont14N)
	nLin += 50
	oPrint:Say(nLin, 0110, "OUTRAS OBSERVA��ES:", oFont14N)
	nLin += 50

	// Imprime as observa��es, se houver
	nFim := LEN(SC5->C5_MENNOTA)
	do while nInicio <= LEN(cTexto)
		nPosicao := 0
		nFim := nInicio + nMaxLen
		while nFim > nInicio
			if SubStr(cTexto, nFim, 1) == " "
				nPosicao := nFim
				exit
			endif
			nFim--
		enddo
		if nPosicao = 0
			nPosicao := nInicio + nMaxLen
		endif
		oPrint:Say(nLin, 0110, SubStr(cTexto, nInicio, nPosicao - nInicio), oFont14N)
		nLin += 50
		nInicio := nPosicao + 1
	enddo

	// Adiciona a se��o TOTAIS conforme a configura��o anterior
	nLin += 50
	oPrint:Say(nLin, 100, "T O T A I S", oFont14N)
	nLin += 30 // Reduzido para espa�amento mais compacto
	oPrint:Line(nLin, 100, nLin, 2200)
	nLin += 30 // Espa�amento reduzido para melhor visual
	dbSelectArea("SCV")
	dbsetorder(1)
	dbSeek(xFilial("SCV") + _Nun)
	cFormPg := SCV->CV_DESCFOR
	oPrint:Say(nLin, 110, "Forma de Pagamento: " + cFormPg, oFont12N)
	oPrint:Say(nLin, 1800, "Total S/ Desconto R$: " + Transform(_Tot+nDesconto, "@e 999,999,999.99"), oFont12N)
	nLin += 30 // Espa�amento reduzido
	oPrint:Say(nLin, 110, "Vencimento: " + CVALTOCHAR(STOD(RETVENC())), oFont12N)
	oPrint:Say(nLin, 1800, "Total C/ Desconto R$: " + Transform(_Tot, "@e 999,999,999.99"), oFont12N)
Return

Static Function RetVenc()
	Local dDtVenc := " "
	If Select("TMP2") > 0
		TMP2->(dbCloseArea())
	EndIf
	_cQry := "SELECT E1_VENCREA DataVenc  "
	_cQry += "FROM " + retsqlname("SE1")+" SE1 "
	_cQry += "WHERE SE1.D_E_L_E_T_ <> '*' "
	_cQry += "AND   SE1.E1_NUM = '" + _Nf + "' "
	_cQry += "AND   SE1.E1_PREFIXO = '" + _Serie + "' "
	_cQry += "AND   SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
	_cQry := ChangeQuery(_cQry)
	TcQuery _cQry New Alias "TMP2"
	dDtVenc := TMP2->DataVenc
Return dDtVenc
