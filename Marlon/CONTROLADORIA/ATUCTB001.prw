  // #########################################################################################
// Projeto: BRG - BRASIL GERADORES
// Modulo : CONTROLADORIA
// Fonte  : ATUCTB001  -  U_ATUCTB001()
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 30/03/16 | Carlos F. Martins | Importação de arquivo de Orçamento
// 23/02/26 | Revisao tecnica   | Correcoes de robustez - regra de negocio preservada:
//          |                   | - validacao da quantidade de colunas do CSV
//          |                   | - linhas em branco ignoradas
//          |                   | - importacao dentro de Begin Transaction
//          |                   | - CTG deixa de ser fechada (era alias do ambiente)
//          |                   | - FT_FUSE liberado em VerArq1
//          |                   | - ProcRegua antes do IncProc na validacao
//          |                   | - dialogo de erro fora do Processa
//          |                   | - datas por SToD (independe de SET DATE FORMAT)
//          |                   | - xFilial("CTE") no lugar de xFilial()
//          |                   | - verificacao dos aliases antes de usar
//          |                   | - variaveis declaradas explicitamente
// 20/08/26 | Revisao tecnica   | Aliases do modulo passam a ser abertos pela propria rotina
//          |                   | (ChkFile), em vez de dependerem da abertura do ambiente
// 20/08/26 | Revisao tecnica   | Chaves de DBSeek da CTO/CTG/CTE montadas com xFilial e com
//          |                   | os campos no tamanho do dicionario (ChvSX3)
// ---------+-------------------+-----------------------------------------------------------

#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#INCLUDE 'rwmake.ch'

//Colunas obrigatorias no arquivo CSV
#define COLS_CABEC   7    // FILIAL;ORCAMENTO;DESCRICAO;CALENDARIO;MOEDA;REVISAO;EXERCICIO
#define COLS_ITEM   15    // CONTA;CCUSTO;CLVL + 12 periodos
#define LIN_ITEM     4    // primeira linha de itens no arquivo

/*/{Protheus.doc} ATUCTB001
//Importação de arquivo de Orçamento.
@author carlos.freitas
@since 30/03/2016
@version 1.1
@type function
/*/
USER FUNCTION ATUCTB001()
	Local cFalta := ''

	Private oDlgAn1
	Private oPanelAn1
	Private oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8
	Private cArquivo   := space(100)
	Private oFont      := TFont():New('Calibri',,-11,.T.)
	Private cFilialOrc := XFILIAL("CV2")
	Private cStatusOrc := "1"
	Private cRevisaOrc := " "
	Private cAprovaOrc := cUserName
	Private cNumeroOrc := " "
	Private cDescriOrc := " "
	Private cCalendOrc := " "
	Private cMoedaOrc  := " "
	Private cStatslOrc := " "
	Private cExerciOrc := " "
	//Private cSafraOrc  := " "
	Private lImorpOrc  := .F.
	Private lNReviOrc  := .F.

	/*
	    O ambiente nao abre todas as tabelas do modulo na entrada (abertura
	    sob demanda), por isso a rotina abre o que precisa por conta propria.
	    Sem isso o primeiro DbSetOrder estouraria com "Alias does not exist".
	*/
	cFalta := AbrAlias()

	If ! Empty(cFalta)
		MsgStop('Nao foi possivel abrir as seguintes tabelas: ' + cFalta + CRLF + ;
		        'Verifique se elas existem no dicionario (SX2) e se o usuario tem acesso.', 'Atenção!!!')
		Return(.F.)
	EndIf

	DEFINE MSDIALOG oDlgAn1 TITLE "Importar Orçamento" FROM 000,000 TO 170,500 PIXEL
	@ 000, 000 MSPANEL oPanelAn1   PROMPT '' SIZE 4, 4 OF oDlgAn1
	oPanelAn1:Align := CONTROL_ALIGN_ALLCLIENT

	TBtnBmp2():New( 03,05,26,26,'OK'    ,,,,{||IMPORTACSV(),oDlgAn1:end()}, oPanelAn1,OemToAnsi('Confirma'),,.T. )
	TBtnBmp2():New( 03,40,26,26,'FINAL' ,,,,{||oDlgAn1:end()} , oPanelAn1,OemToAnsi('Finaliza'),,.T. )

	TGroup():New(015,000,016,275,''   ,oPanelAn1,,,.T.)

	TGroup():New(017,003,032,040,'Filial'   ,oPanelAn1,,,.T.)
	TGroup():New(017,042,032,082,'Orçamento',oPanelAn1,,,.T.)
	TGroup():New(017,084,032,250,'Descrição',oPanelAn1,,,.T.)

	TGroup():New(035,003,050,040,'Status'     ,oPanelAn1,,,.T.)
	TGroup():New(035,042,050,082,'Calendário' ,oPanelAn1,,,.T.)
	TGroup():New(035,084,050,129,'Moeda'      ,oPanelAn1,,,.T.)
	TGroup():New(035,131,050,171,'Revisao'    ,oPanelAn1,,,.T.)
	TGroup():New(035,173,050,250,'Aprovador'  ,oPanelAn1,,,.T.)

	@ 067, 005 Say OemToAnsi('Arquivo')  Size 070, 009 Of oPanelAn1 PIXEL
	@ 065, 025 MSGET oGet3 VAR cArquivo SIZE 197, 010  /*F3 'DIR'*/ Picture "@S100" OF oDlgAn1 COLORS 0, 16777215  PIXEL

	@ 065, 222 BUTTON oButton1 PROMPT "..." SIZE 010, 012 OF oPanelAn1 ACTION (cArquivo:=cGetFile('Arquivos CSV|*.csv','Seleção de Arquivos',0,'C:\',.T.,,.F.), lImorpOrc:=VerArq1() ) PIXEL

	ACTIVATE MSDIALOG oDlgAn1 CENTERED

RETURN(.T.)


/*/{Protheus.doc} AbrAlias
// Abre na work area da thread os aliases utilizados pela rotina.
//
// O ambiente nao garante que as tabelas do modulo estejam abertas
// (abertura sob demanda), por isso cada alias e aberto aqui via ChkFile.
// Aliases ja abertos sao mantidos como estao.
@author Revisao tecnica
@since 20/08/2026
@version 1.1
@type function
@return Caractere, Lista dos aliases que nao puderam ser abertos ou vazio quando todos estao disponiveis
/*/
STATIC FUNCTION AbrAlias()
	Local aAlias := {"CV1","CV2","CT1","CTT","CTE","CTO","CTG"}
	Local cFalta := ''
	Local nI     := 0

	/*
	    SM0 e o cadastro de empresas, aberto pelo proprio ambiente e fora
	    do dicionario SX2, portanto nao passa por ChkFile.
	*/
	If Select("SM0") == 0
		cFalta += 'SM0 '
	EndIf

	For nI := 1 To Len(aAlias)
		If Select(aAlias[nI]) > 0
			Loop
		EndIf

		//ChkFile devolve .F. quando a tabela nao existe no dicionario ou nao pode ser aberta
		If ! ChkFile(aAlias[nI])
			cFalta += aAlias[nI] + ' '
		EndIf
	Next nI

RETURN(AllTrim(cFalta))


/*/{Protheus.doc} ColOrc
// Devolve o conteudo de uma coluna do CSV sem risco de array out of bounds.
@author Revisao tecnica
@since 23/02/2026
@version 1.0
@type function
@param aTmp, Array, Colunas devolvidas pelo Separa()
@param nPos, Numerico, Posicao desejada
@return Caractere, Conteudo da coluna ou vazio quando ela nao existe
/*/
STATIC FUNCTION ColOrc(aTmp, nPos)
	Local cRet := ''

	If ValType(aTmp) == 'A' .And. nPos >= 1 .And. nPos <= Len(aTmp)
		If ValType(aTmp[nPos]) == 'C'
			cRet := AllTrim(aTmp[nPos])
		ElseIf ValType(aTmp[nPos]) == 'N'
			cRet := AllTrim(Str(aTmp[nPos]))
		EndIf
	EndIf

RETURN(cRet)


/*/{Protheus.doc} LinVaz
// Indica se a linha lida do CSV esta vazia (inclusive a linha final do arquivo).
@author Revisao tecnica
@since 23/02/2026
@version 1.0
@type function
@param cLinha, Caractere, Linha lida do arquivo
@return Logico, .T. quando a linha nao possui conteudo util
/*/
STATIC FUNCTION LinVaz(cLinha)
	Local cAux := cLinha

	If ValType(cAux) <> 'C'
		cAux := ''
	EndIf

	cAux := StrTran(cAux, ';', '')
	cAux := StrTran(cAux, Chr(9), '')

RETURN(Empty(AllTrim(cAux)))


/*/{Protheus.doc} ChvSX3
// Devolve o valor preenchido no tamanho do campo, para montagem de chave de indice.
//
// DBSeek compara a chave posicao a posicao. Um valor menor que o campo
// desalinha tudo que vem depois dele na chave composta, e o registro
// existente aparece como inexistente.
@author Revisao tecnica
@since 20/08/2026
@version 1.0
@type function
@param cCampo, Caractere, Nome do campo no dicionario (ex.: "CTG_CALEND")
@param cValor, Caractere, Valor lido do arquivo
@return Caractere, Valor ajustado ao tamanho do campo
/*/
STATIC FUNCTION ChvSX3(cCampo, cValor)
	Local aTam := TamSX3(cCampo)
	Local cRet := AllTrim(cValor)

	//Campo ausente no dicionario: devolve o valor como veio, sem derrubar a rotina
	If ValType(aTam) == 'A' .And. Len(aTam) >= 1 .And. ValType(aTam[1]) == 'N' .And. aTam[1] > 0
		cRet := PadR(cRet, aTam[1])
	EndIf

RETURN(cRet)


/*/{Protheus.doc} VerArq1
// Verifica se o arquivo selecionado está disponível e imprime os dados do cabecalho.
@author carlos.freitas
@since 28/03/2016
@version 1.1
@type function
/*/
STATIC FUNCTION VerArq1()
	Local lRet   := .T.
	Local aTmp   := {}
	Local cLinha := ''

	if File(cArquivo)
		if FT_FUSE(cArquivo) == -1
			MsgAlert('Não foi possível abrir o arquivo '+cArquivo,'Erro')
			lRet := .F.
		else
			FT_FGOTOP()
			FT_FSKIP()
			cLinha := FT_FREADLN()
			aTmp   := Separa(cLinha,";",.T.)

			//Sem as 7 colunas do cabecalho os acessos abaixo estourariam
			If Len(aTmp) < COLS_CABEC
				MsgAlert('A linha 2 do arquivo possui ' + AllTrim(Str(Len(aTmp))) + ' coluna(s) e o layout exige ' + ;
				         AllTrim(Str(COLS_CABEC)) + '. Verifique o arquivo selecionado.','Layout inválido')
				lRet := .F.
			Else
				cFilialOrc := ColOrc(aTmp,01) // M->CV1_FILIAL
				cNumeroOrc := ColOrc(aTmp,02) // M->CV1_ORCMTO
				cDescriOrc := ColOrc(aTmp,03) // M->CV1_DESCRI
				cCalendOrc := ColOrc(aTmp,04) // M->CV1_CALEND
				cMoedaOrc  := ColOrc(aTmp,05) // M->CV1_MOEDA
				cRevisaOrc := ColOrc(aTmp,06) // M->CV1_REVISAO
			   // cSafraOrc  := ColOrc(aTmp,07)
				cExerciOrc := ColOrc(aTmp,07) // M->CV1_

				oSay1 := TSay():New(023, 010,{|| cFilialOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_FILIAL
				oSay2 := TSay():New(023, 047,{|| cNumeroOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_ORCMTO
				oSay3 := TSay():New(023, 086,{|| cDescriOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_DESCRI
				oSay4 := TSay():New(041, 010,{|| cStatusOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_STATUS
				oSay5 := TSay():New(041, 047,{|| cCalendOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_CALEND
				oSay6 := TSay():New(041, 093,{|| cMoedaOrc  },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_MOEDA
				oSay7 := TSay():New(041, 140,{|| cRevisaOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_REVISA
				oSay8 := TSay():New(041, 178,{|| cAprovaOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_APROVA
			EndIf

			//Libera o arquivo - na versao anterior o handle ficava aberto
			FT_FUSE()
		endif
	else
		IF !EMPTY(cArquivo)
			MsgAlert('O arquivo ['+cArquivo+'] Não foi encontrado, verifique!','Erro')
			lRet := .F.
		ENDIF
	endif

RETURN(lRet)



/*/{Protheus.doc} ValidaArq
// Valida as informações do arquivo selecionado.
@author carlos.freitas
@since 30/03/2016
@version 1.1
@type function

    A mensagem de erro e devolvida na Private cMensImp. O dialogo de erro
    NAO e mais aberto aqui: esta funcao roda dentro de um Processa() e
    abrir janela com a regua ativa trava a interface. Quem exibe e a
    IMPORTACSV, depois que o Processa retorna.
/*/
Static Function ValidaArq()

	Local lRet     := .T.
	Local aTmp     := {}
	Local cLinha   := ''
	Local nCalen   := 0
	Local nSeqLanc := 0
	Local nTotLin  := 0
	Local cRevAnt  := ''
	Local cConta   := ''
	Local cCCusto  := ''
	Local nLinArq  := 0
	Local cChvCTG  := ''
	Local nTamPer  := 0
	Local aTamPer  := {}

	cMensImp := CRLF

	if File(cArquivo) .and. !FT_FUSE(cArquivo) == -1

		FT_FGOTOP()
		FT_FSKIP()
		cLinha := FT_FREADLN()
		aTmp   := Separa(cLinha,";",.T.)

		//Sem as 7 colunas do cabecalho os acessos abaixo estourariam
		If Len(aTmp) < COLS_CABEC
			cMensImp += 'Linha 2 (cabecalho) possui ' + AllTrim(Str(Len(aTmp))) + ' coluna(s) e o layout exige ' + ;
			            AllTrim(Str(COLS_CABEC)) + '.' + CRLF
			cMensImp += 'Favor verificar o layout do arquivo selecionado.' + CRLF
			FT_FUSE()
			Return(.F.)
		EndIf

		cFilialOrc := ColOrc(aTmp,01) // M->CV1_FILIAL
		cNumeroOrc := ColOrc(aTmp,02) // M->CV1_ORCMTO
		cDescriOrc := ColOrc(aTmp,03) // M->CV1_DESCRI
		cCalendOrc := ColOrc(aTmp,04) // M->CV1_CALEND
		cMoedaOrc  := ColOrc(aTmp,05) // M->CV1_MOEDA
		cRevisaOrc := ColOrc(aTmp,06) // M->CV1_REVISAO
	   // cSafraOrc  := ColOrc(aTmp,07)
		cExerciOrc := ColOrc(aTmp,07) // M->CV1_

		// Posiciona a índice correto nas tabelas
		CT1->(DbSetOrder(1))   // Conta Contábil
		CTT->(DbSetOrder(1))   // Centro de Custo
		CTE->(DbSetOrder(1))   // Amarração Calendário Contábil x moeda Contábil

		CTO->(dbSetOrder(1))   // Moeda Contábil
		CV2->(dbSetOrder(1))   // Cabeçalho do Orçamento
		CTG->(dbSetOrder(1))   // Calendário Contábil

		/*Verifica se o arquivo é válido
		IF  !alltrim(cCabe1Orc) = 'FILIAL;Orçamento;EXERCICIO;Descrição;CALENDARIO;MOEDA;Revisão;SAFRA;;;;;;;';
		.or.!alltrim(cCabe2Orc) ='CONTA CONTABIL;CENTRO DE CUSTO;CLASSE DE VALOR;JAN;FEV;MAR;ABR;MAI;JUN;JUL;AGO;SET;OUT;NOV;DEZ'
			cMensImp += 'Layout do arquivo Inválido.'+ CRLF
			cMensImp += 'Favor verificar o layout do arquivo selecionado.'+CRLF
			lRet := .F.
		ELSE*/
			//O exercicio alimenta as datas dos periodos e precisa ter 4 digitos
			IF Len(cExerciOrc) <> 4 .Or. Val(cExerciOrc) <= 0
				cMensImp += 'Exercicio "'+cExerciOrc+'" invalido. Informe o ano com 4 digitos (ex.: 2026).'+ CRLF
				lRet := .F.
			ENDIF

			// Verifica a filial
			IF lRet .And. cFilialOrc <> ALLTRIM(SM0->M0_CODFIL)
				cMensImp += 'Filial do arquivo '+cFilialOrc+' diferente da filial corrente '+ ALLTRIM(SM0->M0_CODFIL)+'.'+ CRLF
				cMensImp += 'Favor selecionar a filial correta.'+CRLF
				lRet := .F.
			ELSEIF lRet
				// Verifica a Revisão
				cRevAnt := STRZERO(VAL(cRevisaOrc)-1,3)
				IF Val(cRevisaOrc) > 1 .and. !CV2->(DBSeek(cFilialOrc+cNumeroOrc+cCalendOrc+cMoedaOrc+cRevAnt))
					cMensImp += 'Revisão do Orçamento '+cRevisaOrc+' porém Não foi encontrada a Revisão '+cRevAnt+'.'+ CRLF
					cMensImp += 'Favor verificar.'+CRLF
					lRet := .F.
				ELSE

					If CV2->(DBSeek(cFilialOrc+cNumeroOrc+cCalendOrc+cMoedaOrc+cRevisaOrc))
						cMensImp += 'Orçamento '+cNumeroOrc+' Revisão '+cRevisaOrc+' já cadastrado.'+CRLF
						lRet := .F.
					ELSE

						// Verifica Moeda Contábil
						If !CTO->(DBSeek(xFilial("CTO") + ChvSX3("CTO_MOEDA", cMoedaOrc)))
							cMensImp += 'Moeda '+cMoedaOrc+' Não encontrada.'+CRLF
							lRet := .F.
						ENDIF

						// Verifica Calendário Contábil
						/*
						    A chave da CTG usava Substr(cFilialOrc,1,2), que so alinha com
						    filial de 2 posicoes. Com filial de 4 a chave saia deslocada e
						    os 12 periodos apareciam como "Nao encontrado". Agora usa
						    xFilial("CTG") e cada campo no tamanho do dicionario.
						*/
						cChvCTG := xFilial("CTG") + ChvSX3("CTG_CALEND", cCalendOrc) + ChvSX3("CTG_EXERC", cExerciOrc)
						//TamSX3 devolve array vazio para campo inexistente e o [1] derruba a rotina
						nTamPer := 2
						aTamPer := TamSX3("CTG_PERIOD")
						If ValType(aTamPer) == 'A' .And. Len(aTamPer) > 0
							nTamPer := aTamPer[1]
						EndIf

						FOR nCalen := 1 to 12
							If !CTG->(DBSeek(cChvCTG + StrZero(nCalen, nTamPer)))
								cMensImp += 'Calendário Contábil '+cCalendOrc+' Período '+strzero(nCalen,2)+' Não encontrado.' +CRLF
								lRet := .F.
							ENDIF
						NEXT nCalen

						// Verifica Amarração Calendário Contábil x moeda Contábil
						If ! CTE->(DbSeek(xFilial("CTE") + ChvSX3("CTE_MOEDA", cMoedaOrc) + ChvSX3("CTE_CALEND", cCalendOrc)))
							cMensImp += 'Amarração da Moeda '+cMoedaOrc+' x Calendário Contábil '+cCalendOrc+' Não encontrada.'+CRLF
							lRet := .F.
						Endif

						IF lRet
							// Verifica as contas contábeis e centro de custo
							nTotLin := FT_FLASTREC()
							ProcRegua(nTotLin)

							FT_FGOTOP()
							FT_FSKIP()
							FT_FSKIP()
							FT_FSKIP()
							nSeqLanc := 1

							While !FT_FEOF()
								cLinha  := FT_FREADLN()
								nLinArq := nSeqLanc + LIN_ITEM - 1

								IncProc(Str(nLinArq) + "/" + AllTrim(Str(nTotLin)))

								//Linha em branco (inclusive a ultima do arquivo) e ignorada
								If LinVaz(cLinha)
									FT_FSKIP()
									nSeqLanc++
									Loop
								EndIf

								aTmp := Separa(cLinha,";",.T.)

								//Sem as colunas do layout a gravacao estouraria no Importa
								If Len(aTmp) < COLS_ITEM
									cMensImp += 'Linha: '+STRZERO(nLinArq,4)+'  possui '+AllTrim(Str(Len(aTmp)))+ ;
									            ' coluna(s) e o layout exige '+AllTrim(Str(COLS_ITEM))+'.'+CRLF
									lRet := .F.
									FT_FSKIP()
									nSeqLanc++
									Loop
								EndIf

								cConta  := ColOrc(aTmp,01)
								cCCusto := ColOrc(aTmp,02)

								// Valida Conta Contábil
								If !CT1->(DBSeek(XFILIAL('CT1')+cConta ))
									cMensImp += 'Linha: '+STRZERO(nLinArq,4)+'  Conta Contábil '+cConta+' Não Cadastrada.'+CRLF
									lRet := .F.
								ELSE
									IF CT1->CT1_BLOQ == '1'
										cMensImp += 'Linha: '+STRZERO(nLinArq,4)+'  Conta Contábil '+cConta+' bloqueada.'+CRLF
										lRet := .F.
									ENDIF
									IF CT1->CT1_CLASSE == '1'
										cMensImp += 'Linha: '+STRZERO(nLinArq,4)+'  Conta Contábil '+cConta+' sintética.'+CRLF
										lRet := .F.
									ENDIF
									IF /*CT1->CT1_NTSPED*/ CT1->CT1_INDNAT == /*'04'*/ '4' .AND. EMPTY(cCCusto)
										cMensImp += 'Linha: '+STRZERO(nLinArq,4)+'  Conta Contábil '+cConta+' Conta de despesa/custo. Favor informar o centro de custo.'+CRLF
										lRet := .F.
									ENDIF
								ENDIF

								// Valida Centro de Custo
								If !EMPTY(cCCusto) .AND. !CTT->(DBSeek(XFILIAL('CTT')+cCCusto ))
									cMensImp += 'Linha: '+STRZERO(nLinArq,4)+'  Centro de Custo '+cCCusto+' Não Cadastrado.'+CRLF
									lRet := .F.
								ELSE
									IF !EMPTY(cCCusto) .AND. CTT->CTT_BLOQ == '1'
										cMensImp += 'Linha: '+STRZERO(nLinArq,4)+'  Centro de Custo '+cCCusto+' bloqueado.'+CRLF
										lRet := .F.
									ENDIF
								ENDIF

								FT_FSKIP()
								nSeqLanc++
							end

							//Arquivo sem nenhuma linha de item valida
							If nSeqLanc == 1
								cMensImp += 'O arquivo nao possui linhas de lancamento a partir da linha '+AllTrim(Str(LIN_ITEM))+'.'+CRLF
								lRet := .F.
							EndIf
						ENDIF

					ENDIF

				ENDIF
			ENDIF
		//ENDIF

		/*
		    A CTG NAO e fechada aqui. Ela e alias do ambiente e o
		    DbCloseArea da versao anterior derrubava a work area para toda
		    a thread, quebrando a segunda importacao da mesma sessao.
		*/
		FT_FUSE()
	else
		cMensImp += 'Erro na abertura do arquivo: '+cArquivo
		lRet := .F.
	endif

Return(lRet)


/*/{Protheus.doc} MostraErr
// Exibe os problemas encontrados na validacao do arquivo.
@author carlos.freitas
@since 30/03/2016
@version 1.1
@type function

    Separada da ValidaArq para que o dialogo seja aberto FORA do
    Processa(), evitando travar a interface com a regua ativa.
/*/
Static Function MostraErr()
	Local oDlgError
	Local oPanelError
	Local oTMultiget1
	Local cTexto1 := 'Arquivo: '+cArquivo+CRLF+cMensImp

	DEFINE DIALOG oDlgError TITLE "Foram encontrados os problemas na validação do arquivo" FROM 180,180 TO 550,700 PIXEL
	@ 000, 000 MSPANEL oPanelError   PROMPT '' SIZE 4, 4 OF oDlgError
	oPanelError:Align := CONTROL_ALIGN_ALLCLIENT
	TBtnBmp2():New( 03,05,26,26,'S4WB010N' ,,,,{||oDlgError:end()}, oPanelError,OemToAnsi('Finaliza'),,.T. )
	TGroup():New(015,000,016,275,''   ,oPanelError,,,.T.)
	oTMultiget1 := tMultiget():new( 018, 003, {| u | if( pCount() > 0, cTexto1 := u, cTexto1 ) },oDlgError, 257,165, oFont,.T.,,,,.T.,,, /*[ bWhen]*/,,, /*[ lReadOnly]*/ .T.,/*[ bValid]*/,,, /*[ lNoBorder]*/, .T. /*[ lVScroll]*/ )
	ACTIVATE DIALOG oDlgError CENTERED

Return(Nil)


/*/{Protheus.doc} IMPORTACSV
// Chama validação do arquivo selecionado e Importação dos dados.
@author carlos.freitas
@since 30/03/2016
@version 1.1
@type function
/*/
STATIC FUNCTION IMPORTACSV()
	Local lRet    := .F.
	Local lValida := .T.

	Private cMensImp := CRLF

	IF !EMPTY(cArquivo) .and. lImorpOrc
		Processa( { || lValida := ValidaArq() }  ,"Aguarde... Validando Registros"   ,"Iniciando processo...")

		IF lValida
			Processa( { || lRet := Importa() }  ,"Aguarde... Importando Registros"   ,"Concluindo processo...")
		ENDIF

		//Dialogo aberto somente apos o Processa encerrar
		IF ! lValida .Or. ! lRet
			MostraErr()
		ENDIF
	ELSE
		FWAlertError("É necessário selecionar um arquivo válido para importação.","Atenção!!!")
	ENDIF

	IF lRet
		FWAlertSuccess("Importação Efetuada com sucesso.","Atenção!!!")
	ELSE
		FWAlertError("Importação Não Efetuada.","Atenção!!!")
	ENDIF

Return(lRet)



/*/{Protheus.doc} Importa
// Importa os dados do arquivo selecionado.
@author carlos.freitas
@since 30/03/2016
@version 1.1
@type function

    Toda a gravacao (cabecalho CV2, itens CV1 e mudanca de status da
    revisao anterior) ocorre dentro de um unico Begin Transaction. Na
    versao anterior um erro no meio do arquivo deixava o orcamento
    parcialmente gravado - e como a validacao recusa orcamento ja
    cadastrado, a reimportacao ficava bloqueada.
/*/
Static Function Importa()

	Local cLinha   := ""
	Local aTmp     := {}
	Local nMax     := 0
	Local cMaxLin  := ''
	Local nPerCnt  := 0
	Local nSeqLanc := 0
	Local nLinArq  := 0
	Local lRet     := .T.
	Local cRevAnt  := ''
	Local dDtIni   := CToD('')
	Local cValor   := ''

	if File(cArquivo)
		if FT_FUSE(cArquivo) == -1
			MsgAlert('Não foi possível abrir o arquivo '+cArquivo,'Erro')
			lRet := .F.
		else
			nMax    := FT_FLASTREC()
			cMaxLin := AllTrim(Str(nMax))
			ProcRegua(nMax)

			DBSELECTAREA("CV2")
			DBSELECTAREA("CV1")

			Begin Transaction

				// Importa Cabeçalho
				If ! RecLock("CV2",.T.)
					cMensImp += 'Nao foi possivel obter o bloqueio para incluir o cabecalho do orcamento.'+CRLF
					lRet := .F.
					DisarmTransaction()
					Break
				EndIf

				CV2->CV2_FILIAL := cFilialOrc   // M->CV1_FILIAL    //NOT NULL CHAR(4)
				CV2->CV2_ORCMTO := cNumeroOrc   // M->CV1_ORCMTO    //NOT NULL CHAR(6)
				CV2->CV2_DESCRI := cDescriOrc   // M->CV1_DESCRI    //NOT NULL CHAR(50)
				CV2->CV2_STATUS := cStatusOrc   // M->CV1_STATUS   //NOT NULL CHAR(1)
				CV2->CV2_CALEND := cCalendOrc   // M->CV1_CALEND   //NOT NULL CHAR(3)
				CV2->CV2_MOEDA  := cMoedaOrc    // M->CV1_MOEDA    //NOT NULL CHAR(2)
				CV2->CV2_REVISA := cRevisaOrc   // M->CV1_REVISA   //NOT NULL CHAR(3)
				CV2->CV2_APROVA := cAprovaOrc   // M->CV1_APROVA   //NOT NULL CHAR(25)
				CV2->CV2_STATSL := cStatslOrc   // M->CV1_STATSL   //NOT NULL CHAR(1)
				CV2->(msUnlock())

				// Importa Itens
				FT_FGOTOP()
				FT_FSKIP()
				FT_FSKIP()
				FT_FSKIP()
				nSeqLanc := 1

				While !FT_FEOF()
					cLinha  := FT_FREADLN()
					nLinArq := nSeqLanc + LIN_ITEM - 1

					IncProc(Str(nLinArq) + "/" + cMaxLin)

					//Linha em branco (inclusive a ultima do arquivo) e ignorada
					If LinVaz(cLinha)
						FT_FSKIP()
						nSeqLanc++
						Loop
					EndIf

					aTmp := Separa(cLinha,";",.T.)

					//Rede de seguranca: a ValidaArq ja barra, mas nao se grava as cegas
					If Len(aTmp) < COLS_ITEM
						cMensImp += 'Linha: '+STRZERO(nLinArq,4)+'  possui '+AllTrim(Str(Len(aTmp)))+ ;
						            ' coluna(s) e o layout exige '+AllTrim(Str(COLS_ITEM))+'. Importacao cancelada.'+CRLF
						lRet := .F.
						DisarmTransaction()
						Break
					EndIf

					//Data do periodo montada por SToD - independe do SET DATE FORMAT
					dDtIni := SToD(cExerciOrc + StrZero(1,2) + "01")

					If Empty(dDtIni)
						cMensImp += 'Nao foi possivel montar a data do exercicio "'+cExerciOrc+'". Importacao cancelada.'+CRLF
						lRet := .F.
						DisarmTransaction()
						Break
					EndIf

					FOR nPerCnt := 1 to 12

						If ! RecLock("CV1",.T.)
							cMensImp += 'Linha: '+STRZERO(nLinArq,4)+'  nao foi possivel obter o bloqueio para incluir o periodo '+StrZero(nPerCnt,2)+'.'+CRLF
							lRet := .F.
							DisarmTransaction()
							Break
						EndIf

						dDtIni := SToD(cExerciOrc + StrZero(nPerCnt,2) + "01")

						CV1->CV1_FILIAL := cFilialOrc
						CV1->CV1_ORCMTO := cNumeroOrc
						CV1->CV1_DESCRI := cDescriOrc
						CV1->CV1_STATUS := cStatusOrc
						CV1->CV1_CALEND := cCalendOrc
						CV1->CV1_MOEDA  := cMoedaOrc
						CV1->CV1_REVISA := cRevisaOrc
						CV1->CV1_SEQUEN := STRZERO(nSeqLanc,4)
						CV1->CV1_CT1INI := ColOrc(aTmp,01)
						CV1->CV1_CT1FIM := ColOrc(aTmp,01)
						CV1->CV1_CTTINI := ColOrc(aTmp,02)
						CV1->CV1_CTTFIM := ColOrc(aTmp,02)
						CV1->CV1_CTDINI := " "
						CV1->CV1_CTDFIM := " "
						CV1->CV1_CTHINI := ColOrc(aTmp,03)
						CV1->CV1_CTHFIM := ColOrc(aTmp,03)
						CV1->CV1_PERIOD := strzero(nPerCnt,2)
						CV1->CV1_DTINI  := FirstDate(dDtIni)
						CV1->CV1_DTFIM  := LastDate(dDtIni)

						//Valor no formato brasileiro: remove o separador de milhar e troca a virgula decimal
						cValor := ColOrc(aTmp, 3+nPerCnt)
						CV1->CV1_VALOR  := VAL(StrTran(StrTran( cValor, ".", "" ), ",", "." ))   //VAL(aLanctos[1][3+nPerCnt])

						CV1->CV1_APROVA := cAprovaOrc
						//CV1->CV1_E05INI := cSafraOrc
						//CV1->CV1_E05FIM := cSafraOrc
						CV1->(msUnlock())
					Next nPerCnt

					FT_FSKIP()
					nSeqLanc++
				end

				// Muda Status da versão anterior do Orçamento
				DBSELECTAREA("CV2")
				CV2->(dbSetOrder(1))
				cRevAnt := STRZERO(VAL(cRevisaOrc)-1,3)

				IF CV2->(DBSeek(cFilialOrc+cNumeroOrc+cCalendOrc+cMoedaOrc+cRevAnt))
					If ! RecLock("CV2",.F.)
						cMensImp += 'Nao foi possivel obter o bloqueio para alterar o status da revisao anterior '+cRevAnt+'.'+CRLF
						lRet := .F.
						DisarmTransaction()
						Break
					EndIf

					CV2->CV2_STATUS := '3'
					CV2->(msUnlock())
				ENDIF

			End Transaction

			FT_FUSE()
		endif
	else
		cMensImp += 'O arquivo ['+cArquivo+'] não foi encontrado, verifique!'+CRLF
		MsgAlert('O arquivo ['+cArquivo+'] não foi encontrado, verifique!','Arquivo não encontrado')
		lRet := .F.
	endif

Return(lRet)
