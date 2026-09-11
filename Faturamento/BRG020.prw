/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BRG020  ³ Autor ³ Ricardo Moreira³ 		  Data ³ 21/02/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressão de Fatura   									  ³±±
±±³          ³ 						                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para BRG                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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
	Local nLinRodape    := 2300 // Posição fixa para o rodapé (ajustável conforme necessidade)
	Local nEspacoRodape := 400  // Espaço reservado para o rodapé (estimado)

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

//³Variveis para impressão                                              ³
	Private cStartPath
	Private nLin 		:= 50
	Private nLinMax 	:= 3000 // Defina o número máximo de linhas por página
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
		MSGINFO("Tipo de Documento Incorreto para a impressão. !!! "," Atenção ")
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
	oPrint:Say(nLin, 1400,  ("FATURA DE LOCAÇÃO N.º: ")+SC5->C5_NOTA+"/"+SC5->C5_SERIE, oFont16N)
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
	_DDD      := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_DDD")
	_TpCli    := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_TIPO")

	oPrint:Say(nLin, 100,  ("Emissão:"), oFont12)
	oPrint:Say(nLin, 1570,  ("Telefone:"), oFont12)
	oPrint:Say(nLin, 300,  CVALTOCHAR(SC5->C5_EMISSAO), oFont12N)
	oPrint:Say(nLin, 1800, FmtFone(_DDD, _TEL), oFont12N)
	nLin+=70
	oPrint:Say(nLin, 100, ("Cliente:"), oFont12)
	oPrint:Say(nLin, 300,  SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI +"-"+_Desc, oFont12N)
	oPrint:Say(nLin, 1570, ("CNPJ:"), oFont12)
	oPrint:Say(nLin, 1800, TRANSFORM(_Cnpj,"@R 99.999.999/9999-99"),oFont12N)
	nLin+=70
	oPrint:Say(nLin, 100,  ("Endereço:"), oFont12)
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
	oPrint:Say(nLin, 1570,  ("Responsável:"), oFont12)
	oPrint:Say(nLin, 1800, SC5->C5_XUSER, oFont12N)
	nLin+=100
	oPrint:Say(nLin, 100,  ("Item"), oFont10N)
	oPrint:Say(nLin, 220,  ("Produto"), oFont10N)
	oPrint:Say(nLin, 380,  ("Descrição"), oFont10N)
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

		// Verifica se há espaço para o item e o rodapé
		If nLin + 50 + nEspacoRodape <= nLinMax

			nTotReal:= SC6->C6_PRCVEN

			_Tot  := _Tot + SC6->C6_VALOR
			nDesconto += SC6->C6_VALDESC

			oPrint:Say(nLin, 110, SC6->C6_ITEM, oFont10)
			oPrint:Say(nLin, 230, SC6->C6_PRODUTO, oFont10)
			oPrint:Say(nLin, 390, SC6->C6_DESCRI, oFont10)
			oPrint:Say(nLin, 1010, SC6->C6_XSEREQU, oFont10)
			oPrint:Say(nLin, 1250, cValToChar(SC6->C6_QTDVEN), oFont10,,,,1)
			oPrint:Say(nLin, 1550, Transform(nTotReal, "@e 999,999,999.99"), oFont10,,,,1)
			oPrint:Say(nLin, 1850, Transform(SC6->C6_VALDESC, "@e 999,999,999.99"), oFont10,,,,1)
			
			//If !Empty(SC6->C6_VALDESC)
				//oPrint:Say(nLin, 2070, Transform(SC6->C6_QTDVEN-nDesconto, "@e 999,999,999.99"), oFont10,,,,1)
			//Else
				oPrint:Say(nLin, 2070, Transform(SC6->C6_PRCVEN*SC6->C6_QTDVEN, "@e 999,999,999.99"), oFont10,,,,1)
			//EndIf
			nLin+=50

		Else
			   nTotReal:= SC6->C6_PRCVEN

				nDesconto += SC6->C6_VALDESC

				_Tot  := _Tot + SC6->C6_VALOR

			// Finaliza a página e inicia uma nova
			oPrint:Line(nLin,100,nLin,2200)
			oPrint:EndPage()
			oPrint:StartPage()
			nLin := 50
			// Reimprime cabeçalho dos itens na nova página
			oPrint:Say(nLin, 100,  ("Item"), oFont10N)
			oPrint:Say(nLin, 220,  ("Produto"), oFont10N)
			oPrint:Say(nLin, 380,  ("Descrição"), oFont10N)
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
			
			//If !Empty(SC6->C6_VALDESC)
				//oPrint:Say(nLin, 2070, Transform(_Tot-nDesconto, "@e 999,999,999.99"), oFont10,,,,1)
			//Else
				oPrint:Say(nLin, 2070, Transform(SC6->C6_PRCVEN*SC6->C6_QTDVEN, "@e 999,999,999.99"), oFont10,,,,1)
			//EndIf
			nLin+=50

		EndIf
		SC6->(dbSkip())
	EndDo

// Após o loop, desenha linha de separação
	oPrint:Line(nLin,100,nLin,2200)

// Ajusta nLin para o rodapé, se houver espaço suficiente
	If nLin + nEspacoRodape > nLinMax
		oPrint:EndPage()
		oPrint:StartPage()
		nLin := nLinRodape
	Else
		nLin := nLinRodape
	EndIf

// Imprime o rodapé
	PrintRodape()

	oPrint:EndPage()
	MS_FLUSH()
	oPrint:Preview()
Return()

// Função auxiliar para imprimir o rodapé
Static Function PrintRodape()

	Local nValor, cNfRem := "", aNfRem, nInicio := 1, nFim, nCont := 1, nPosicao, cTexto := GetObs()
	Local oFontObs := oFont10N			//Fonte do corpo das observacoes: mesma altura usada nas linhas de item
	Local nMaxLen := 130				//Caracteres por linha: 110 ate 2200 e a largura util do relatorio
	Local nAltLinha := 38				//Altura de uma linha de observacao
	Local nAltTitulo := 50				//Altura do titulo, que continua em fonte 14
	Local nEspTotais := 140				//Espaco do bloco T O T A I S (50 + 30 + 30 + 30)
	Local nLinTopo := 50				//Primeira linha util de uma pagina nova
	Local nLinLimObs := nLinMax - nEspTotais	//Ultima linha em que cabe observacao

	// Imprime o rodapé com o novo layout
	oPrint:Say(nLin, 0110, "FATURA DE LOCAÇÃO N.º: " + SC5->C5_NOTA + "/" + SC5->C5_SERIE, oFont14N)
	nLin += 50
	oPrint:Say(nLin, 0110, "PERÍODO: REF: " + SUBSTR(DTOS(SC5->C5_XDTINI),7,2) + "/" + SUBSTR(DTOS(SC5->C5_XDTINI),5,2) + "/" + SUBSTR(DTOS(SC5->C5_XDTINI),1,4) + " A " + SUBSTR(DTOS(SC5->C5_XDTFIM),7,2) + "/" + SUBSTR(DTOS(SC5->C5_XDTFIM),5,2) + "/" + SUBSTR(DTOS(SC5->C5_XDTFIM),1,4), oFont14N)
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
	oPrint:Say(nLin, 0110, "PEDIDO N.º: " + SC5->C5_NUM, oFont14N)
	nLin += 50
	oPrint:Say(nLin, 0110, "ID Cobrança: " + SC5->C5_XIDCOB, oFont14N)
	nLin += 50
	oPrint:Say(nLin, 0110, "OUTRAS OBSERVAÇÕES:", oFont14N)
	nLin += 50

	// Quebras de linha e tabulacoes gravadas no campo sairiam impressas como
	// caractere invalido e ainda desalinhavam a contagem de caracteres por linha.
	cTexto := StrTran(StrTran(StrTran(cTexto, Chr(13), " "), Chr(10), " "), Chr(9), " ")

	// Imprime as observações, se houver, quebrando por palavra e abrindo nova
	// página quando o texto ultrapassar a área útil, para que nada seja cortado.
	do while nInicio <= LEN(cTexto)
		nPosicao := 0
		nFim := nInicio + nMaxLen

		if nFim > LEN(cTexto)
			// Ultimo pedaco do texto: imprime o que restou, sem procurar espaco
			nPosicao := LEN(cTexto) + 1
		else
			// Recua ate o espaco anterior ao limite, para nao cortar palavra
			while nFim > nInicio
				if SubStr(cTexto, nFim, 1) == " "
					nPosicao := nFim
					exit
				endif
				nFim--
			enddo
			if nPosicao == 0
				// Palavra unica maior que a linha: corta no limite
				nPosicao := nInicio + nMaxLen
			endif
		endif

		// Nao havendo espaco para mais uma linha, continua na proxima pagina
		if nLin + nAltLinha > nLinLimObs
			oPrint:EndPage()
			oPrint:StartPage()
			nLin := nLinTopo
			oPrint:Say(nLin, 0110, "OUTRAS OBSERVAÇÕES (continuação):", oFont14N)
			nLin += nAltTitulo
		endif

		oPrint:Say(nLin, 0110, SubStr(cTexto, nInicio, nPosicao - nInicio), oFontObs)
		nLin += nAltLinha
		nInicio := nPosicao + 1
	enddo

	// Garante que o bloco de TOTAIS caiba inteiro na página
	if nLin + nEspTotais > nLinMax
		oPrint:EndPage()
		oPrint:StartPage()
		nLin := nLinTopo
	endif

	// Adiciona a seção TOTAIS conforme a configuração anterior
	nLin += 50
	oPrint:Say(nLin, 100, "T O T A I S", oFont14N)
	nLin += 30 // Reduzido para espaçamento mais compacto
	oPrint:Line(nLin, 100, nLin, 2200)
	nLin += 30 // Espaçamento reduzido para melhor visual
	dbSelectArea("SCV")
	dbsetorder(1)
	dbSeek(xFilial("SCV") + _Nun)
	cFormPg := SCV->CV_DESCFOR
	oPrint:Say(nLin, 110, "Forma de Pagamento: " + cFormPg, oFont12N)
	oPrint:Say(nLin, 1800, "Total S/ Desconto R$: " + Transform(_Tot+nDesconto, "@e 999,999,999.99"), oFont12N)
	nLin += 30 // Espaçamento reduzido
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

//---------------------------------------------------------------------------
// Monta o texto das observacoes a partir dos dois campos de mensagem do
// pedido, conforme o que o usuario preencheu:
//
//   - somente C5_MENNOTA preenchido -> imprime C5_MENNOTA
//   - somente C5_XMENNOT preenchido -> imprime C5_XMENNOT
//   - os dois preenchidos           -> imprime os dois, C5_XMENNOT primeiro
//
// C5_XMENNOT e campo customizado (vide M460FIM.prw e PE01NFESEFAZ.prw), por
// isso o FieldPos: em ambiente onde ele nao exista o relatorio segue
// imprimindo apenas C5_MENNOTA, sem erro de execucao.
//---------------------------------------------------------------------------
Static Function GetObs()

Local cRet		:= ""
Local cMenNota	:= AllTrim(SC5->C5_MENNOTA)
Local cXMenNot	:= ""

	If SC5->(FieldPos("C5_XMENNOT")) > 0
		cXMenNot := AllTrim(SC5->C5_XMENNOT)
	EndIf

	cRet := cXMenNot

	// Havendo os dois textos, separa por espaco: a quebra por palavra do
	// rodape se encarrega de distribuir o conteudo nas linhas.
	If !Empty(cMenNota)
		cRet += If(Empty(cRet), "", " ") + cMenNota
	EndIf

Return cRet

//---------------------------------------------------------------------------
// Monta o telefone para impressao a partir do DDD (A1_DDD) e do numero
// (A1_TEL), aplicando a mascara conforme a quantidade de digitos.
//
// A mascara fixa "@R (99)9999-9999" usada antes comportava apenas 10 digitos:
// com celular (DDD + 9 digitos = 11) o excedente era descartado pelo Transform.
// Alem disso o DDD nunca era lido, pois fica em A1_DDD e nao em A1_TEL - a
// montagem DDD + numero segue a mesma adotada no NFE40, fonte nfesefaz.prw.
//---------------------------------------------------------------------------
Static Function FmtFone(cDDD, cFone)

Local cNumero	:= ""
Local cRet		:= ""

	// Mantem apenas digitos: descarta mascara ja gravada no cadastro do cliente
	cDDD  := SoDigito(If(ValType(cDDD)  == "C", cDDD , ""))
	cFone := SoDigito(If(ValType(cFone) == "C", cFone, ""))

	// A1_TEL muitas vezes ja vem digitado com o DDD na frente. Como numero local
	// tem 8 ou 9 digitos, qualquer coisa com 10+ ja traz o DDD: nesse caso nao
	// concatena de novo, senao sobra 12/13 digitos e a mascara nao e aplicada.
	If Len(cFone) >= 10 .And. !Empty(cDDD) .And. SubStr(cFone, 1, Len(cDDD)) == cDDD
		cNumero := cFone
	Else
		cNumero := cDDD + cFone
	EndIf

	// Descarta o codigo do pais (55), quando gravado junto do numero
	If Len(cNumero) > 11 .And. SubStr(cNumero, 1, 2) == "55"
		cNumero := SubStr(cNumero, 3)
	EndIf

	Do Case
		Case Len(cNumero) == 11		// DDD + celular de 9 digitos
			cRet := Transform(cNumero, "@R (99)99999-9999")
		Case Len(cNumero) == 10		// DDD + fixo de 8 digitos
			cRet := Transform(cNumero, "@R (99)9999-9999")
		Case Len(cNumero) == 9		// Celular sem DDD
			cRet := Transform(cNumero, "@R 99999-9999")
		Case Len(cNumero) == 8		// Fixo sem DDD
			cRet := Transform(cNumero, "@R 9999-9999")
		OtherWise					// Formato nao previsto: imprime integral, sem perder digito
			cRet := cNumero
	EndCase

Return cRet

//---------------------------------------------------------------------------
// Retorna somente os digitos numericos de cValor.
//---------------------------------------------------------------------------
Static Function SoDigito(cValor)

Local cRet	:= ""
Local nX	:= 0

	cValor := AllTrim(cValor)

	For nX := 1 To Len(cValor)
		If IsDigit(SubStr(cValor, nX, 1))
			cRet += SubStr(cValor, nX, 1)
		EndIf
	Next nX

Return cRet
