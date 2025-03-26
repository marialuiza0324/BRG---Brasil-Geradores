/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BRG012  ³ Autor ³ Ricardo Moreira³ 		  Data ³ 21/02/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressão de Orçamento 									  ³±±
±±³          ³ 						                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para BRG                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

//Autora - Maria Luiza

//Ajuste para retirar validações de filiais, tornando o fonte genérico para filial corrente - Solicitado pelo Marlon 03/06/2024
//Adição das logos no orçamento de forma genérica para a filial corrente, logos adicionadas no servidor pasta /system/orc/.

#include "rwmake.ch"
#INCLUDE "topconn.ch"

User Function BRG012()


//Local _Nf        := SC5->C5_NOTA 
//Local _Serie     := SC5->C5_SERIE
	Local _Desc,_End,_Bair,_Cid,cTes, cNcn :=  " "
	Local _cMvCon := "MV_CONVEND" //Contato do vendedor por parametro
	Local cString := ""
	Local aString := ""
	Local nString := ""


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
	Private oPrint		:= NIL

	Private nPag		:= 1
	Private _Emp
	Private cPerg 		:= "BRG012"
	Private nRepita // variavel que controla a quantidade de relatorios impressos
	Private nContador // contador do for principal, que imprime o relatorio n vezes
	Private nZ
	Private nJ
	Private cLogoD
	Private _Nun       := SCJ->CJ_NUM
	Private	_Qtd    := 0
	Private _Tot    := 0
	Private _TotIpi := 0
	Private _TotDif := 0
	Private	_Local  := " "
	Private	_LtCtl  := " "
	Private _Prod   := " "
	Private _NumSeq := " "
	Private _AlqDif := 0
	Private cLogo
	Private aAliquotas := {}
	Private nAliquota := 0
	Static _Uf
	Static cLogoPath := ""
	Static nItemCount := 0
	Static _nPagin := 1

//³Define Tamanho do Papel                                                  ³

	#define DMPAPER_A4 9 //Papel A4

	If oPrint == Nil

		oPrint:=FWMSPrinter():New("Orcamento",6,.T.,,.T.)
		oPrint:SetPortrait()
		oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
		oPrint:cPathPDF :="C:\TEMP\"

	EndIf

	cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
	cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")

	cLogoPath := "\system\timbr"+Cfilant+".png"
	nItemCount := 0
	_nPagin := 1

	oPrint:SetPortrait()///Define a orientacao da impressao como retrato          ³

	oPrint:StartPage()

	// Imprime o papel timbrado
	oPrint:SayBitmap(0, 0, cLogoPath, 2100, 2970) // Largura e altura em pontos

	nLin+=170

	oPrint:Say(nLin,800,ALLTRIM(SM0->M0_NOMECOM),oFont10)

	nLin+=30

	oPrint:Say(nLin,800,ALLTRIM(SM0->M0_ENDENT)+", "+ALLTRIM(SM0->M0_COMPENT),oFont10)  //ALTEROU DE 550 PARA 650 PARA GRID

	nLin+=30

	oPrint:Say(nLin,800,AllTrim(SM0->M0_BAIRCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB+" - CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont10)

	nLin+=30

	oPrint:Say(nLin+70, 1500,  ("O R Ç A M E N T O  N.º: ")+SCJ->CJ_NUM, oFont16N)   //1400 ALTERADO PARA GRID

	oPrint:Say(nLin,800,"FONE: " + SM0->M0_TEL ,oFont10)
	nLin+=30
	oPrint:Say(nLin,800,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   " +"IE:"+ SM0->M0_INSC,oFont10)

	nLin+=100
	//	oPrint:Say(nLin, 2100, "Pagina: " + strzero(nPag,3), oFont10N)
	_Desc     := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME")
	_End      := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_END")
	_Bair     := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_BAIRRO")
	_Cid      := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_MUN")
	_Uf       := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_EST")
	_Cnpj     := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_CGC")
	_CEP      := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_CEP")
	_TEL      := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_TEL")
	_TpCli    := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_TIPO")

	oPrint:Say(nLin, 080,  ("Emissão:"), oFont12)
	oPrint:Say(nLin, 1600,  ("Telefone:"), oFont12)
	oPrint:Say(nLin, 300,  CVALTOCHAR(SCJ->CJ_EMISSAO), oFont12N)
	oPrint:Say(nLin, 1800, TRANSFORM(_TEL,"@R (99)9999-9999"), oFont12N)
	nLin+=50
	oPrint:Say(nLin, 080, ("Cliente:"), oFont12)
	oPrint:Say(nLin, 300,  SCJ->CJ_CLIENTE+"/"+SCJ->CJ_LOJA +"-"+_Desc, oFont12N)
	oPrint:Say(nLin, 1600, ("CNPJ:"), oFont12)
	oPrint:Say(nLin, 1800, TRANSFORM(_Cnpj,"@R 99.999.999/9999-99"),oFont12N) // CGC

	nLin+=50
	oPrint:Say(nLin, 080,  ("Endereço:"), oFont12)
	oPrint:Say(nLin, 300,  _End, oFont12N)
	oPrint:Say(nLin, 1600,  ("Cidade:"), oFont12)
	oPrint:Say(nLin, 1800,  alltrim(_Cid)+"/"+_Uf, oFont12N)

	nLin+=50
	oPrint:Say(nLin, 080,  ("Cond. Pgto:"), oFont12)
	_Cond := Posicione("SE4",1,xFilial("SE4")+SCJ->CJ_CONDPAG,"E4_DESCRI")
	oPrint:Say(nLin, 300,  SCJ->CJ_CONDPAG+" - "+_Cond, oFont12N)
	oPrint:Say(nLin, 1600,  ("Cep:"), oFont12)
	oPrint:Say(nLin, 1800,  TRANSFORM(_CEP,"@R 99999-999"), oFont12N)

	nLin+=50
	oPrint:Say(nLin, 080,  ("Tipo Frete:"), oFont12)
	oPrint:Say(nLin, 300, IIF(SCJ->CJ_TIPOFRT = "F","FOB","CIF"), oFont12N)
	oPrint:Say(nLin, 1600,  ("Validade:"), oFont12)
	oPrint:Say(nLin, 1800,  CVALTOCHAR(SCJ->CJ_VALIDA), oFont12N)

	nLin+=50
	_Vend := Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_VEND,"A3_NOME")
	oPrint:Say(nLin, 080,  ("Vendedor:"), oFont12)
	oPrint:Say(nLin, 300,  SCJ->CJ_VEND +"-"+_Vend, oFont12N)
	oPrint:Say(nLin, 1600,  ("Moeda:"), oFont12)

	oPrint:Say(nLin, 1800,  IF(SCJ->CJ_MOEDA = 1 ,"R$ (Real)", "US$ (Dólar)"), oFont12N)

	nLin+=50
	oPrint:Say(nLin, 080,  ("Observação:"), oFont12)
	oPrint:Say(nLin, 300,  SCJ->CJ_OBS, oFont12N)

	nLin+=50

	oPrint:Say(nLin, 1800, ("Nº Paginas: ")+cvaltochar(_nPagin)+"/"+ALLTRIM(RetPag()), oFont10)

	nLin+=120

	nLin+=50
	oPrint:Say(nLin, 080,  ("Item"), oFont9N)
	oPrint:Say(nLin, 140,  ("Produto"), oFont9N)
	oPrint:Say(nLin, 350,  ("Descrição"), oFont9N)
	oPrint:Say(nLin, 900,  ("NCM"), oFont9N)
	oPrint:Say(nLin, 1050, ("UN"), oFont9N)
	oPrint:Say(nLin, 1150, ("CF"), oFont9N)
	oPrint:Say(nLin, 1250, ("Qtde"), oFont9N)
	oPrint:Say(nLin, 1460, ("Valor Unit."), oFont9N)
	oPrint:Say(nLin, 1700, ("Ipi (%)"), oFont9N)
	oPrint:Say(nLin, 1820, ("Icms (%)"), oFont9N)
	oPrint:Say(nLin, 1940, ("Iss (%)"), oFont9N)
	oPrint:Say(nLin, 2075, ("Total"), oFont9N)

	nLin+=20
	oPrint:Line(nLin,080,nLin,2320)
	nLin+=30

	dbSelectArea("SCK")
	dbsetorder(1)
	dbSeek(xFilial("SCK")+_Nun)


	While SCK->(!EOF()) .AND. xFilial("SCK") = SCK->CK_FILIAL .AND. SCK->CK_NUM = _Nun

		cTes := Posicione("SF4",1,xFilial("SF4")+SCK->CK_TES,"F4_CF")
		cNcn := Posicione("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_POSIPI")

		oPrint:Say(nLin, 080, SCK->CK_ITEM, oFont10)

		If len(ALLTRIM(SCK->CK_PRODUTO))	> 12
			oPrint:Say(nLin, 140, SCK->CK_PRODUTO, oFont10)
		Else
			oPrint:Say(nLin, 140, SCK->CK_PRODUTO, oFont10)
		EndIF

		oPrint:Say(nLin, 350, SCK->CK_DESCRI, oFont10)
		oPrint:Say(nLin, 0900, cNcn, oFont10)
		oPrint:Say(nLin, 1050, SCK->CK_UM, oFont10)
		oPrint:Say(nLin, 1150, cTes, oFont10)
		oPrint:Say(nLin, 1200, Transform(SCK->CK_QTDVEN, "@e 999,999,999.999"), oFont10,,,,1)
		oPrint:Say(nLin, 1420, Transform(SCK->CK_PRCVEN, "@e 999,999,999.99"), oFont10,,,,1)
		oPrint:Say(nLin, 1700, Transform(SCK->CK_IPI, "@e 99.99"), oFont10)
		oPrint:Say(nLin, 1820, Transform(SCK->CK_ICMS, "@e 99.99"), oFont10)
		oPrint:Say(nLin, 1940, Transform(SCK->CK_ISS, "@e 99.99"), oFont10)
		oPrint:Say(nLin, 2030, Transform(SCK->CK_VALOR, "@e 999,999,999.99"), oFont10,,,,1)      //oFont10,,,,2) // centraliza
		nLin+=20
		oPrint:Line(nLin-50,130,nLin,130) 		// Vertical
		oPrint:Line(nLin-50,340,nLin,340) 		// Vertical
		oPrint:Line(nLin-50,890,nLin,890) 		// Vertical
		oPrint:Line(nLin-50,1040,nLin,1040) 	// Vertical
		oPrint:Line(nLin-50,1140,nLin,1140) 	// Vertical
		oPrint:Line(nLin-50,1240,nLin,1240) 	// Vertical
		oPrint:Line(nLin-50,1440,nLin,1440) 	// Vertical
		oPrint:Line(nLin-50,1690,nLin,1690) 	// Vertical
		oPrint:Line(nLin-50,1810,nLin,1810) 	// Vertical
		oPrint:Line(nLin-50,1920,nLin,1920) 	// Vertical
		oPrint:Line(nLin-50,2050,nLin,2050) 	// Vertical

		oPrint:Line(nLin,080,nLin,2320) // Horizontal
		nLin+=30

		U_GetAliquota()

		If _TpCli = "F"

			_AlqDif := nAliquota- 12

			_TotDif := _TotDif + (SCK->CK_VALOR*((_AlqDif/100)))
		EndIF

		_Icms := (SCK->CK_VALOR*((nAliquota/100)))
		_Iss  := (SCK->CK_VALOR*((SCK->CK_ISS/100)))
		_Ipi  := (SCK->CK_VALOR*((SCK->CK_IPI/100)))
		_Qtd  := _Qtd + SCK->CK_QTDVEN
		_Tot  := _Tot + SCK->CK_VALOR
		_TotIpi  := _TotIpi + (SCK->CK_VALOR*((SCK->CK_IPI/100)))

		// Atualiza o contador
		nItemCount++

		// Se atingiu 30 itens, realiza a quebra de página
		If nItemCount >= 30
			oPrint:EndPage() // Finaliza a página
			oPrint:StartPage()
			nItemCount := 0    // Reseta contador
			nLin := 50       // Reinicia a posição da linha
			oPrint:SayBitmap(0, 0, cLogoPath, 2100, 2970) // Largura e altura em pontos

			nLin+=170

			oPrint:Say(nLin,800,ALLTRIM(SM0->M0_NOMECOM),oFont10)

			nLin+=30

			oPrint:Say(nLin,800,ALLTRIM(SM0->M0_ENDENT)+", "+ALLTRIM(SM0->M0_COMPENT),oFont10)  //ALTEROU DE 550 PARA 650 PARA GRID

			nLin+=30

			oPrint:Say(nLin,800,AllTrim(SM0->M0_BAIRCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB+" - CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont10)

			nLin+=30

			oPrint:Say(nLin+70, 1500,  ("O R Ç A M E N T O  N.º: ")+SCJ->CJ_NUM, oFont16N)   //1400 ALTERADO PARA GRID

			oPrint:Say(nLin,800,"FONE: " + SM0->M0_TEL ,oFont10)
			nLin+=30
			oPrint:Say(nLin,800,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ "   " +"IE:"+ SM0->M0_INSC,oFont10)

			nLin+= 80

			oPrint:Say(nLin, 1800, ("Nº Paginas: ")+cvaltochar(_nPagin)+"/"+ALLTRIM(RetPag()), oFont10)

			nLin+= 170

			oPrint:Say(nLin, 080,  ("Item"), oFont9N)
			oPrint:Say(nLin, 140,  ("Produto"), oFont9N)
			oPrint:Say(nLin, 350,  ("Descrição"), oFont9N)
			oPrint:Say(nLin, 900,  ("NCM"), oFont9N)
			oPrint:Say(nLin, 1050, ("UN"), oFont9N)
			oPrint:Say(nLin, 1150, ("CF"), oFont9N)
			oPrint:Say(nLin, 1250, ("Qtde"), oFont9N)
			oPrint:Say(nLin, 1460, ("Valor Unit."), oFont9N)
			oPrint:Say(nLin, 1700, ("Ipi (%)"), oFont9N)
			oPrint:Say(nLin, 1820, ("Icms (%)"), oFont9N)
			oPrint:Say(nLin, 1940, ("Iss (%)"), oFont9N)
			oPrint:Say(nLin, 2075, ("Total"), oFont9N)
			nLin+=20
			oPrint:Line(nLin,080,nLin,2320)
			nLin+=30

		EndIf


		SCK->( dbSkip() )

	Enddo
	nLin+=50

	oPrint:Say(nLin, 080,   ("T O T A I S"), oFont10N)
	nLin+=50
	oPrint:Line(nLin,080,nLin,2320)
	nLin+=50
	oPrint:Say(nLin, 1200, Transform(_Qtd, "@e 999,999,999.999"), oFont10)
	oPrint:Say(nLin, 1700, "Total S/ Impostos" +Transform(_Tot, "@e 999,999,999.99"), oFont10)
	nLin+=50
	oPrint:Say(nLin, 1700, "Total C/ Impostos" +Transform(_Tot+_TotIpi+_TotDif, "@e 999,999,999.99"), oFont10)
	nLin+=50
	oPrint:Say(nLin, 080,   ("I M P O S T O S"), oFont10N)
	nLin+=50
	oPrint:Line(nLin,080,nLin,2320)
	nLin+=100
	oPrint:Say(nLin, 0080, ("Valor IPI"), oFont10)
	oPrint:Say(nLin, 0400, ("Valor ICMS"), oFont10)
	oPrint:Say(nLin, 0700, ("Valor ISS"), oFont10)
	oPrint:Say(nLin, 1000, ("Valor Total"), oFont10)
	oPrint:Say(nLin, 1300, ("Valor Difal"), oFont10)

	nLin+=50
	oPrint:Say(nLin, 0150, Transform(_TotIpi, "@e 999,999,999.99"), oFont10)
	oPrint:Say(nLin, 0450, Transform(_Icms, "@e 999,999,999.99"), oFont10)
	oPrint:Say(nLin, 0750, Transform(_Iss, "@e 999,999,999.99"), oFont10)
	oPrint:Say(nLin, 1050, Transform((_Tot+_TotIpi), "@e 999,999,999.99"), oFont10)
	oPrint:Say(nLin, 1350, Transform(_TotDif, "@e 999,999,999.99"), oFont10)   //Difal
	nLin+=100
	oPrint:Say(nLin, 0150, ("Sujeito a Disponibilidade"), oFont10)
	nLin+=15

//INICIO alteração Marlon 08/06/2022 #2155
/* 
	O tratamento dos contatos do orçamento é feito atraves de parametro.
	O parametro será o MV_CONVEND
	O padrao para preenchimento do parametro é NOME - FONE(Separado por - Ex.: (062) 99999-9999)
	De um contato para o outro separar com ;

 */
		cString := GetMV(_cMvCon)
		aString := strtokarr (cString, ";")
		for nString := 1 to len(aString)
			cStr1 := strtokarr (cValtoChar(aString[nString]), "-")
			nLin+=50
			oPrint:Say(nLin, 0150, (cStr1[1]), oFont10)
			oPrint:Say(nLin, 0350, (cStr1[2]+"-"+cStr1[3]), oFont10)
		next

		_nPagin := 0

//FIM
		oPrint:endPage()
		MS_FLUSH()
		oPrint:Preview()
		Return()

//Retorna a Quantidade de Pagina do Orçamento

Static Function RetPag()
	Local _nPag := "1" // Padrão: pelo menos 1 página
	Local _nCalc := 0
	Local _nItens := 0
	Local _cQry := ""

	// Fecha a tabela TMP2 se estiver aberta
	If Select("TMP2") > 0
		TMP2->(dbCloseArea())
	EndIf

	// Consulta SQL para obter a quantidade total de itens
	_cQry := "SELECT COUNT(*) Quant "
	_cQry += "FROM " + retsqlname("SCK") + " SCK "
	_cQry += "WHERE SCK.D_E_L_E_T_ <> '*' "
	_cQry += "AND SCK.CK_NUM = '" + _Nun + "' "
	_cQry += "AND SCK.CK_FILIAL = '" + xFilial("SCK") + "'"

	_cQry := ChangeQuery(_cQry)
	TcQuery _cQry New Alias "TMP2"

	// Obtém o número de itens
	_nItens := TMP2->Quant

	// Calcula a quantidade de páginas (arredondando para cima)
	If _nItens > 0
		_nCalc := Ceiling(_nItens / 30.0) // Divide por 35 e arredonda para cima
	Else
		_nCalc := 1 // Se não houver itens, assume pelo menos 1 página
	EndIf

	_nPag := CValToChar(_nCalc)
	_nPagin := _nPagin + 1

Return _nPag


User Function GetAliquota()

	Local nEstado := 0
	Local nAliq01 := SuperGetMV("MV_ALIQ01", , " ") //19%
	Local nAliq02 := SuperGetMV("MV_ALIQ02", , " ") //18%
	Local nAliq03 := SuperGetMV("MV_ALIQ03", , " ") //20%
	Local nAliq04 := SuperGetMV("MV_ALIQ04", , " ") //20.5%
	Local nAliq05 := SuperGetMV("MV_ALIQ05", , " ") //17%
	Local nAliq06 := SuperGetMV("MV_ALIQ06", , " ") //22%
	Local nAliq07 := SuperGetMV("MV_ALIQ07", , " ") //19.5%
	Local nAliq08 := SuperGetMV("MV_ALIQ08", , " ") //21%

	If Empty(_Uf )
		_Uf := Posicione("SA1",1,xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA,"A1_EST")
	EndIf

	aAliquotas := {{"AC", nAliq01}, {"AL", nAliq01}, {"AP", nAliq02}, {"AM", nAliq03},;
		{"BA", nAliq04}, {"CE", nAliq03}, {"DF", nAliq03}, {"ES", nAliq05},;
		{"GO", nAliq01}, {"MA", nAliq06}, {"MT", nAliq05}, {"MS", nAliq05},;
		{"MG", nAliq02}, {"PA", nAliq01}, {"PB", nAliq03}, {"PR", nAliq07},;
		{"PE", nAliq04}, {"PI", nAliq08}, {"RJ", nAliq03}, {"RN", nAliq02},;
		{"RS", nAliq05}, {"RO", nAliq07}, {"RR", nAliq03}, {"SC", nAliq05},;
		{"SP", nAliq02}, {"SE", nAliq01}, {"TO", nAliq03} }


	For nEstado := 1 To Len(aAliquotas)
		If aAliquotas[nEstado][1] == _Uf
			nAliquota := aAliquotas[nEstado][2]
			Exit
		EndIf
	Next


Return nAliquota
