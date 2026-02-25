// #########################################################################################
// Projeto: SEMENTES GOIAS
// Modulo : ESTOQUE
// Fonte  : ATUCTB001  -  U_ATUCTB001()
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 30/03/16 | Carlos F. Martins | Importação de arquivo de Orçamento
// ---------+-------------------+-----------------------------------------------------------

#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#INCLUDE 'rwmake.ch'
#define CRLF Chr(13) + Chr(10)

/*/{Protheus.doc} ATUCTB001
//Importação de arquivo de Orçamento.
@author carlos.freitas
@since 30/03/2016
@version 1.0
@type function
/*/
USER FUNCTION ATUCTB001()
	Private oDlg
	Private cArquivo   := space(100)
	Private CV1_FILIAL := xfilial("CV1")
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

	DEFINE MSDIALOG oDlgAn1 TITLE "Importar Orçamento" FROM 000,000 TO 170,500 PIXEL
	@ 000, 000 MSPANEL oPanelAn1   PROMPT '' SIZE 4, 4 OF oDlgAn1
	oPanelAn1:Align := CONTROL_ALIGN_ALLCLIENT

	oBtnAn2 := TBtnBmp2():New( 03,05,26,26,'OK'    ,,,,{||IMPORTACSV(),oDlgAn1:end()}, oPanelAn1,OemToAnsi('Confirma'),,.T. )
	oBtnAn2 := TBtnBmp2():New( 03,40,26,26,'FINAL' ,,,,{||oDlgAn1:end()} , oPanelAn1,OemToAnsi('Finaliza'),,.T. )

	oGroup0:= TGroup():New(015,000,016,275,''   ,oPanelAn1,,,.T.)

	oGroup1:= TGroup():New(017,003,032,040,'Filial'   ,oPanelAn1,,,.T.)
	oGroup2:= TGroup():New(017,042,032,082,'Orçamento',oPanelAn1,,,.T.)
	oGroup3:= TGroup():New(017,084,032,250,'Descrição',oPanelAn1,,,.T.)

	oGroup4:= TGroup():New(035,003,050,040,'Status'     ,oPanelAn1,,,.T.)
	oGroup5:= TGroup():New(035,042,050,082,'Calendário' ,oPanelAn1,,,.T.)
	oGroup6:= TGroup():New(035,084,050,129,'Moeda'      ,oPanelAn1,,,.T.)
	oGroup7:= TGroup():New(035,131,050,171,'Revisao'    ,oPanelAn1,,,.T.)
	oGroup8:= TGroup():New(035,173,050,250,'Aprovador'  ,oPanelAn1,,,.T.)

	@ 067, 005 Say OemToAnsi('Arquivo')  Size 070, 009 Of oPanelAn1 PIXEL
	@ 065, 025 MSGET oGet3 VAR cArquivo SIZE 197, 010  /*F3 'DIR'*/ Picture "@S100" OF oDlgAn1 COLORS 0, 16777215  PIXEL

	@ 065, 222 BUTTON oButton1 PROMPT "..." SIZE 010, 012 OF oDlg ACTION (cArquivo:=cGetFile('Arquivos CSV|*.csv','Seleção de Arquivos',0,'C:\',.T.,,.F.), lImorpOrc:=VerArq1() ) PIXEL
          
	ACTIVATE MSDIALOG oDlgAn1 CENTERED

RETURN(.T.)


/*/{Protheus.doc} VerArq1
// Verifica se o arquivo selecionado está disponível e imprime os dados do cabecalho.
@author carlos.freitas
@since 28/03/2016
@version 1.0
@type function
/*/
STATIC FUNCTION VerArq1()
	Local lRet := .T.
	Local aDados := {}

	if File(cArquivo) 
		if FT_FUSE(cArquivo) == -1
			MsgAlert('Não foi possível abrir o arquivo '+cArquivo,'Erro')
			lRet := .F.
		else
			FT_FGOTOP()
			FT_FSKIP()
			cLinha := FT_FREADLN()
			aTmp := Separa(cLinha,";",.T.)
			aadd(aDados, aTmp )

			cFilialOrc := ALLTRIM(aDados[01][01]) // M->CV1_FILIAL 
			cNumeroOrc := ALLTRIM(aDados[01][02]) // M->CV1_ORCMTO 
			cDescriOrc := ALLTRIM(aDados[01][03]) // M->CV1_DESCRI 
			cCalendOrc := ALLTRIM(aDados[01][04]) // M->CV1_CALEND
			cMoedaOrc  := ALLTRIM(aDados[01][05]) // M->CV1_MOEDA 
			cRevisaOrc := ALLTRIM(aDados[01][06]) // M->CV1_REVISAO
           // cSafraOrc  := ALLTRIM(aDados[01][07])
            cExerciOrc := ALLTRIM(aDados[01][07]) // M->CV1_ 

			oSay1 := TSay():New(023, 010,{|| cFilialOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_FILIAL 
			oSay2 := TSay():New(023, 047,{|| cNumeroOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_ORCMTO 
			oSay3 := TSay():New(023, 086,{|| cDescriOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_DESCRI 
			oSay4 := TSay():New(041, 010,{|| cStatusOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_STATUS
			oSay5 := TSay():New(041, 047,{|| cCalendOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_CALEND
			oSay6 := TSay():New(041, 093,{|| cMoedaOrc  },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_MOEDA 
			oSay7 := TSay():New(041, 140,{|| cRevisaOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_REVISA
			oSay8 := TSay():New(041, 178,{|| cAprovaOrc },oPanelAn1,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,200,20)  // M->CV1_APROVA
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
@version 1.0
@type function
/*/
Static Function ValidaArq()

	Local lRet := .T.
	Local aDados := {}
	Local cMensImp := CRLF  //" " 
    Local nCalen := 0

	if File(cArquivo) .and. !FT_FUSE(cArquivo) == -1

		FT_FGOTOP()
		cCabe1Orc := FT_FREADLN()
		FT_FSKIP()
		FT_FSKIP()
		cCabe2Orc := FT_FREADLN()
		FT_FGOTOP()
		FT_FSKIP()
		cLinha := FT_FREADLN()
		aTmp := Separa(cLinha,";",.T.)
		aadd(aDados, aTmp )

		cFilialOrc := ALLTRIM(aDados[01][01]) // M->CV1_FILIAL 
		cNumeroOrc := ALLTRIM(aDados[01][02]) // M->CV1_ORCMTO 
		cDescriOrc := ALLTRIM(aDados[01][03]) // M->CV1_DESCRI 
		cCalendOrc := ALLTRIM(aDados[01][04]) // M->CV1_CALEND
		cMoedaOrc  := ALLTRIM(aDados[01][05]) // M->CV1_MOEDA 
		cRevisaOrc := ALLTRIM(aDados[01][06]) // M->CV1_REVISAO
       // cSafraOrc  := ALLTRIM(aDados[01][07])
        cExerciOrc := ALLTRIM(aDados[01][07]) // M->CV1_ 
         
		// Posiciona a índice correto nas tabelas
		CT1->(DbSetOrder(1))   // Conta Contábil
		CTT->(DbSetOrder(1))   // Centro de Custo 
		CTE->(DbSetOrder(1))   // Amarração Calendário Contábil x moeda Contábil
		
		CTO->(dbSetOrder(1))   // Moeda Contábil
		CV2->(dbSetOrder(1))   // Cabeçalho do Orçamento

		/*Verifica se o arquivo é válido
		IF  !alltrim(cCabe1Orc) = 'FILIAL;Orçamento;EXERCICIO;Descrição;CALENDARIO;MOEDA;Revisão;SAFRA;;;;;;;';
		.or.!alltrim(cCabe2Orc) ='CONTA CONTABIL;CENTRO DE CUSTO;CLASSE DE VALOR;JAN;FEV;MAR;ABR;MAI;JUN;JUL;AGO;SET;OUT;NOV;DEZ'
			cMensImp += 'Layout do arquivo Inválido.'+ CRLF  
			cMensImp += 'Favor verificar o layout do arquivo selecionado.'+CRLF  
			lRet := .F.
		ELSE*/     
			// Verifica a filial
			IF cFilialOrc <> ALLTRIM(SM0->M0_CODFIL)
				cMensImp += 'Filial do arquivo '+cFilialOrc+' diferente da filial corrente '+ ALLTRIM(SM0->M0_CODFIL)+'.'+ CRLF  
				cMensImp += 'Favor selecionar a filial correta.'+CRLF  
				lRet := .F.
			ELSE
				// Verifica a Revisão
				cRevisaAnt := STRZERO(VAL(cRevisaOrc)-1,3)
				IF Val(cRevisaOrc) > 1 .and. !CV2->(DBSeek(cFilialOrc+cNumeroOrc+cCalendOrc+cMoedaOrc+cRevisaAnt))
					cMensImp += 'Revisão do Orçamento '+cRevisaOrc+' porém Não foi encontrada a Revisão '+cRevisaAnt+'.'+ CRLF  
					cMensImp += 'Favor verificar.'+CRLF  
					lRet := .F.
				ELSE

					If CV2->(DBSeek(cFilialOrc+cNumeroOrc+cCalendOrc+cMoedaOrc+cRevisaOrc))
						cMensImp += 'Orçamento '+cNumeroOrc+' Revisão '+cRevisaOrc+' já cadastrado.'+CRLF  
						lRet := .F.
					ELSE

						// Verifica Moeda Contábil
						If !CTO->(DBSeek(cFilialOrc+cMoedaOrc))
							cMensImp += 'Moeda '+cMoedaOrc+' Não encontrada.'+CRLF  
							lRet := .F.
						ENDIF

                        DbSelectArea("CTG")
                        CTG->(dbSetOrder(1))   // Calendário Contábil

						// Verifica Calendário Contábil
						FOR nCalen = 1 to 12
 							If !CTG->(DBSeek(Substr(cFilialOrc,1,2)+cCalendOrc+cExerciOrc+strzero(nCalen,2)))
								cMensImp += 'Calendário Contábil '+cCalendOrc+' Período '+strzero(nCalen,2)+' Não encontrado.' +CRLF  
								lRet := .F.
							ENDIF
						NEXT nCalen

						// Verifica Amarração Calendário Contábil x moeda Contábil
						If ! CTE->(DbSeek(xFilial() + cMoedaOrc + cCalendOrc))
							cMensImp += 'Amarração da Moeda '+cMoedaOrc+' x Calendário Contábil '+cCalendOrc+' Não encontrada.'+CRLF 
							lRet := .F.
						Endif

						IF lRet
							// Verifica as contas contábeis e centro de custo
							FT_FGOTOP()
							FT_FSKIP()
							FT_FSKIP()
							FT_FSKIP()
							nSeqLanc := 1

							While !FT_FEOF()
								cLinha := FT_FREADLN()
								IncProc(Str(nSeqLanc+3) + "/" + Alltrim(Str(FT_FLASTREC())))
								aTmp := Separa(cLinha,";",.T.)
								aLanctos := {}
								aadd(aLanctos, aTmp )
                                
                                // Valida Conta Contábil
								If !CT1->(DBSeek(XFILIAL('CT1')+aLanctos[1][01] ))
									cMensImp += 'Linha: '+STRZERO(nSeqLanc+3,4)+'  Conta Contábil '+aLanctos[1][01]+' Não Cadastrada.'+CRLF
									lRet := .F.
								ELSE
									IF CT1->CT1_BLOQ = '1'
										cMensImp += 'Linha: '+STRZERO(nSeqLanc+3,4)+'  Conta Contábil '+aLanctos[1][01]+' bloqueada.'+CRLF
										lRet := .F.
									ENDIF
									IF CT1->CT1_CLASSE = '1'
										cMensImp += 'Linha: '+STRZERO(nSeqLanc+3,4)+'  Conta Contábil '+aLanctos[1][01]+' sintética.'+CRLF
										lRet := .F.
									ENDIF
									IF /*CT1->CT1_NTSPED*/ CT1->CT1_INDNAT = /*'04'*/ '4' .AND. EMPTY(aLanctos[1][02])
										cMensImp += 'Linha: '+STRZERO(nSeqLanc+3,4)+'  Conta Contábil '+aLanctos[1][01]+' Conta de despesa/custo. Favor informar o centro de custo.'+CRLF
										lRet := .F.
									ENDIF
								ENDIF
								
								// Valida Centro de Custo
								If !EMPTY(aLanctos[1][02]) .AND. !CTT->(DBSeek(XFILIAL('CTT')+aLanctos[1][02] ))
									cMensImp += 'Linha: '+STRZERO(nSeqLanc+3,4)+'  Centro de Custo '+aLanctos[1][02]+' Não Cadastrado.'+CRLF
									lRet := .F.
								ELSE
									IF !EMPTY(aLanctos[1][02]) .AND. CTT->CTT_BLOQ = '1'
										cMensImp += 'Linha: '+STRZERO(nSeqLanc+3,4)+'  Centro de Custo '+aLanctos[1][02]+' bloqueado.'+CRLF
										lRet := .F.
									ENDIF	
								ENDIF

								FT_FSKIP()
								nSeqLanc++ 
							end
						ENDIF

					ENDIF

				ENDIF
			ENDIF
		//ENDIF
		FT_FUSE()
        CTG->(DbCloseArea())
	else
		cMensImp += 'Erro na abertura do arquivo: '+cArquivo
		lRet := .F.
	endif

	IF !lRet
		DEFINE DIALOG oDlgError TITLE "Foram encontrados os problemas na validação do arquivo" FROM 180,180 TO 550,700 PIXEL
		@ 000, 000 MSPANEL oPanelError   PROMPT '' SIZE 4, 4 OF oDlgError
		oPanelError:Align := CONTROL_ALIGN_ALLCLIENT
		oBtnError1 := TBtnBmp2():New( 03,05,26,26,'S4WB010N' ,,,,{||oDlgError:end()}, oPanelError,OemToAnsi('Finaliza'),,.T. )
		oBtnError1 := TBtnBmp2():New( 03,40,26,26,'FINAL' ,,,,{||oDlgError:end()}, oPanelError,OemToAnsi('Imprime'),,.T. )
		oGroup0:= TGroup():New(015,000,016,275,''   ,oPanelError,,,.T.)
		cTexto1 := 'Arquivo: '+cArquivo+CRLF+cMensImp
		oTMultiget1 := tMultiget():new( 018, 003, {| u | if( pCount() > 0, cTexto1 := u, cTexto1 ) },oDlgError, 257,165, oFont,.T.,,,,.T.,,, /*[ bWhen]*/,,, /*[ lReadOnly]*/ .T.,/*[ bValid]*/,,, /*[ lNoBorder]*/, .T. /*[ lVScroll]*/ )
		ACTIVATE DIALOG oDlgError CENTERED
	ENDIF

Return(lRet)


/*/{Protheus.doc} IMPORTACSV
// Chama validação do arquivo selecionado e Importação dos dados.
@author carlos.freitas
@since 30/03/2016
@version 1.0
@type function
/*/
STATIC FUNCTION IMPORTACSV()
	Local lRet := .F.
	Local lValida := .T.
	IF !EMPTY(cArquivo) .and. lImorpOrc 
		Processa( { || lValida := ValidaArq() }  ,"Aguarde... Validando Registros"   ,"Iniciando processo...")
		IF lValida 
			Processa( { || Importa() }  ,"Aguarde... Importando Registros"   ,"Concluindo processo...")
			lRet := .T. 
		ENDIF
	ELSE
		MSGSTOP("É necessário selecionar um arquivo válido para importação.","Atenção!!!")
	ENDIF
	IF lRet
		MSGSTOP("Importação Efetuada com sucesso.","Atenção!!!")
	ELSE
		MSGSTOP("Importação Não Efetuada.","Atenção!!!")
	ENDIF

Return(lRet)



/*/{Protheus.doc} Importa
// Importa os dados do arquivo selecionado.
@author carlos.freitas
@since 30/03/2016
@version 1.0
@type function
/*/
Static Function Importa()

	Local cLinha   := ""
	Local nMax     := 0
    Local nPerCnt  := 0
	Local lRet     := .T.
	Private aLanctos := {}

	if File(cArquivo)
		if FT_FUSE(cArquivo) == -1
			MsgAlert('Não foi possível abrir o arquivo '+cArquivo,'Erro')
			lRet := .F.
		else
			nMax := FT_FLASTREC()
			ProcRegua(nMax)

			// Importa Cabeçalho
			DBSELECTAREA("CV2")
			RECLOCK("CV2",.T.) 
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
			nMax     := Alltrim(Str(nMax))
			nSeqLanc := 1

			While !FT_FEOF()
				cLinha := FT_FREADLN()
				IncProc(Str(nSeqLanc) + "/" + nMax)
				aTmp := Separa(cLinha,";",.T.)
				aLanctos := {}
				aadd(aLanctos, aTmp )

				FOR nPerCnt = 1 to 12
					DBSELECTAREA("CV1")
					RECLOCK("CV1",.T.) 
					CV1->CV1_FILIAL := cFilialOrc  
					CV1->CV1_ORCMTO := cNumeroOrc  
					CV1->CV1_DESCRI := cDescriOrc  
					CV1->CV1_STATUS := cStatusOrc  
					CV1->CV1_CALEND := cCalendOrc  
					CV1->CV1_MOEDA  := cMoedaOrc   
					CV1->CV1_REVISA := cRevisaOrc  
					CV1->CV1_SEQUEN := STRZERO(nSeqLanc,4)
					CV1->CV1_CT1INI := aLanctos[1][01]
					CV1->CV1_CT1FIM := aLanctos[1][01]
					CV1->CV1_CTTINI := aLanctos[1][02]
					CV1->CV1_CTTFIM := aLanctos[1][02]
					CV1->CV1_CTDINI := " "
					CV1->CV1_CTDFIM := " "
					CV1->CV1_CTHINI := aLanctos[1][03]
					CV1->CV1_CTHFIM := aLanctos[1][03]
					CV1->CV1_PERIOD := strzero(nPerCnt,2)
					CV1->CV1_DTINI  := FirstDate(CTOD("01/"+strzero(nPerCnt,2)+"/"+cExerciOrc))
					CV1->CV1_DTFIM  := LastDate(CTOD("01/"+strzero(nPerCnt,2)+"/"+cExerciOrc))
					CV1->CV1_VALOR  := VAL(StrTran(StrTran( aLanctos[1][3+nPerCnt], ".", "" ), ",", "." ))                    //VAL(aLanctos[1][3+nPerCnt])
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
			cRevisaAnt := STRZERO(VAL(cRevisaOrc)-1,3)
			IF CV2->(DBSeek(cFilialOrc+cNumeroOrc+cCalendOrc+cMoedaOrc+cRevisaAnt))
				RECLOCK("CV2",.F.) 
				CV2->CV2_STATUS := '3'    
				CV2->(msUnlock())
			ENDIF
			FT_FUSE()
		endif
	else
		cMsg := 'O arquivo ['+cArquivo+'] não foi encontrado, verifique!'
		MsgAlert(cMsg,'Arquivo não encontrado')
		lRet := .F.
	endif

Return(lRet)

