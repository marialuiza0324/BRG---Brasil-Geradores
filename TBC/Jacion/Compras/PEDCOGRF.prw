#include 'fivewin.ch'
#include 'topconn.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LC13R    บAutor ณPedro Netoบ Data ณ  28/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PEDIDO DE COMPRAS (Emissao em formato Grafico)             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// alterar o parametro MV_PCOMPRA e colocar PEDGRF para substituir a impressใo padrใo.

User Function PEDGRF()
Private	lEnd		:= .f.,;
		aAreaSC7	:= SC7->(GetArea()),;
		aAreaSA2	:= SA2->(GetArea()),;
		aAreaSA5	:= SA5->(GetArea()),;   
		aAreaSF4	:= SF4->(GetArea()),;
	 	cPerg		:= Padr('PEDGRF',10)


	 	//	aAreaSZF	:= SZF->(GetArea()),;

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAjusta os parametros.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		AjustaSX1(cPerg)

		// Se a Impressใo Nใo Vier da Tela de Pedido de Compras entใo Efetua Pergunta de Parโmetros
		// Caso contrแrio entใo posiciona no pedido que foi clicado a op็ใo imprimir.

		If Upper(ProcName(2)) <> 'A120IMPRI'
           	If !Pergunte(cPerg,.t.)
           		Return
           	Endif

		
			Private	cNumPed  	:= mv_par01			// Numero do Pedido de Compras
			Private	lImpPrc		:= (mv_par02==2)	// Imprime os Precos ?
			Private	nTitulo 	:= mv_par03			// Titulo do Relatorio ?
			Private	cObserv1	:= mv_par04			// 1a Linha de Observacoes
			Private	cObserv2	:= mv_par05			// 2a Linha de Observacoes
			Private	cObserv3	:= mv_par06			// 3a Linha de Observacoes
			Private	cObserv4	:= mv_par07			// 4a Linha de Observacoes
			Private	lPrintCodFor:= (mv_par08==1)	// Imprime o Cvvvvvvvvvvvvvvvvvvvvvvvvvvvodigo do produto no fornecedor ?
	

  		Else

			Private	cNumPed  	:= SC7->C7_NUM		// Numero do Pedido de Compras
			Private	lImpPrc		:= .t.	// Imprime os Precos ?
			Private	nTitulo 	:= 2			// Titulo do Relatorio ?
			Private	cObserv1	:= ''			// 1a Linha de Observacoes
			Private	cObserv2	:= ''			// 2a Linha de Observacoes
			Private	cObserv3	:= ''			// 3a Linha de Observacoes
			Private	cObserv4	:= ''			// 4a Linha de Observacoes
			Private	lPrintCodFor:= .f.	// Imprime o Codigo do produto no fornecedor ?
  		Endif


		DbSelectArea('SC7')
		SC7->(DbSetOrder(1))
		If	( ! SC7->(DbSeek(xFilial('SC7') + cNumPed)) )
			Help('',1,'PEDGRF',,OemToAnsi('Pedido nใo encontrado.'),1)
			Return .f.
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณExecuta a rotina de impressao ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Processa({ |lEnd| xPrintRel(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRestaura a area anterior ao processamento. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RestArea(aAreaSC7)
		RestArea(aAreaSA2)
		RestArea(aAreaSA5)
	 //	RestArea(aAreaSZF)
		RestArea(aAreaSF4)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xPrintRelบAutor ณLuis Henrique Robustoบ Data ณ  10/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime a Duplicata...                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xPrintRel()
local _nt := 0
local i := 0
local alinha := {}
local _nlinhas := 0
Private	oPrint		:= TMSPrinter():New(OemToAnsi('Pedido de Compras')),;
		oBrush		:= TBrush():New(,4),;
		oPen		:= TPen():New(0,5,CLR_BLACK),;
		cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP',;
		oFont07		:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
		oFont08		:= TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
		oFont09		:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
		oFont10		:= TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
		oFont10n	:= TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
		oFont11		:= TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
		oFont11n	:= TFont():New('Tahoma',11,11,,.T.,,,,.T.,.F.),;
		oFont12		:= TFont():New('Tahoma',09,09,,.T.,,,,.T.,.F.),;
		oFont12n	:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
		oFont13		:= TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.),;
		oFont14		:= TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
		oFont15		:= TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
		oFont18		:= TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
		oFont16		:= TFont():New('Arial',14,14,,.T.,,,,.T.,.F.),;
		oFont20		:= TFont():New('Arial',20,20,,.F.,,,,.T.,.F.),;
		oFont22		:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)   
	

	oPrint:Setup()
	
	//cFileLogo := "lgrlpc" + cEmpAnt + ".bmp"
	cFileLogo := "lgrlpc" + ".bmp"

	If !File(cFileLogo)
		cFileLogo := "lgrl" + cEmpAnt + cFilAnt + ".bmp"
	EndIf

	

Private	lFlag		:= .t.,;	// Controla a impressao do fornecedor
		nLinha		:= 3000,;	// Controla a linha por extenso
		nLinFim		:= 0,;		// Linha final para montar a caixa dos itens
		lPrintDesTab:= .f.,;	// Imprime a Descricao da tabela (a cada nova pagina)
		cRepres		:= Space(80)

Private	_nQtdReg	:= 0,;		// Numero de registros para intruir a regua
		_nValMerc 	:= 0,;		// Valor das mercadorias
		_nValIPI	:= 0,;		// Valor do I.P.I.
		_nValDesc	:= 0,;		// Valor de Desconto
		_nTotAcr	:= 0,;		// Valor total de acrescimo
		_nTotSeg	:= 0,;		// Valor de Seguro
		_nTotFre	:= 0,;		// Valor de Frete
		_nTotIcmsRet:= 0		// Valor do ICMS Retido
        
Private cStartPath             //Pedro Neto
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPosiciona nos arquivos necessarios. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea('SA2')
		SA2->(DbSetOrder(1))
		If	! SA2->(DbSeek(xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA)))
			Help('',1,'REGNOIS')
			Return .f.
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณDefine que a impressao deve ser RETRATOณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:SetPortrait()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMonta query !ณ    //SC7.C7_CODPRF, 
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		//cSELECT :=	'SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_COND, SC7.C7_CONTATO, ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),SC7.C7_OBSM)),'') , '+;
		cSELECT :=	"SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_COND, SC7.C7_CONTATO, ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C7_OBSM)),'') AS OBSM, "+; //ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024), C7_OBS)),'') AS OBSM, "+; 
					'SC7.C7_ITEM, SC7.C7_UM, SC7.C7_PRODUTO, SC7.C7_DESCRI, SC7.C7_LOCAL, SC7.C7_QUANT, '+;
					'SC7.C7_PRECO, SC7.C7_IPI, SC7.C7_TOTAL, SC7.C7_VLDESC, SC7.C7_DESPESA, '+;
					'SC7.C7_SEGURO, SC7.C7_VALFRE, SC7.C7_TES, SC7.C7_LOCAL, SC7.C7_ICMSRET, SC7.C7_DATPRF'
					

		//cSELECT :=	"SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_COND, SC7.C7_CONTATO, ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024), C7_OBS)),'') AS OBSM"
					//SC7.C7_ITEM, SC7.C7_UM, SC7.C7_PRODUTO, SC7.C7_DESCRI, SC7.C7_QUANT, 
					//SC7.C7_PRECO, SC7.C7_IPI, SC7.C7_TOTAL, SC7.C7_VLDESC, SC7.C7_DESPESA,
					//SC7.C7_SEGURO, SC7.C7_VALFRE, SC7.C7_TES, SC7.C7_ICMSRET, SC7.C7_DATPRF 
		cFROM   :=	RetSqlName('SC7') + ' SC7 '

		cWHERE  :=	'SC7.D_E_L_E_T_ <>   '+CHR(39) + '*'            +CHR(39) + ' AND '+;
					'SC7.C7_FILIAL  =    '+CHR(39) + xFilial('SC7') +CHR(39) + ' AND '+;
					'SC7.C7_NUM     =    '+CHR(39) + cNumPed        +CHR(39) 

		cORDER  :=	'SC7.C7_FILIAL, SC7.C7_ITEM '

		cQuery  :=	' SELECT '   + cSELECT + ; 
					' FROM '     + cFROM   + ;
					' WHERE '    + cWHERE  + ;
					' ORDER BY ' + cORDER

		TCQUERY cQuery NEW ALIAS 'TRA'   
		
		TcSetField('TRA','C7_DATPRF','D')

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf

		DbSelectArea('TRA')
		Count to _nQtdReg
		ProcRegua(_nQtdReg)
		TRA->(DbGoTop())

		
      cObServ := ''
		While 	TRA->( ! Eof() )

				xVerPag()

				If	( lFlag )
					//ฺฤฤฤฤฤฤฤฤฤฤฟ
					//ณFornecedorณ
					//ภฤฤฤฤฤฤฤฤฤฤู
					oPrint:Say(0530,0100,OemToAnsi('Fornecedor:'),oFont10)
					oPrint:Say(0520,0430,AllTrim(SA2->A2_NOME) + '  ('+AllTrim(SA2->A2_COD)+'/'+AllTrim(SA2->A2_LOJA)+')',oFont13)
					oPrint:Say(0580,0100,OemToAnsi('Endere็o:'),oFont10)
					oPrint:Say(0580,0430,SA2->A2_END,oFont11)
					oPrint:Say(0630,0100,OemToAnsi('Municํpio/U.F.:'),oFont10)
					oPrint:Say(0630,0430,AllTrim(SA2->A2_MUN)+'/'+AllTrim(SA2->A2_EST),oFont11)
					oPrint:Say(0630,1200,OemToAnsi('Cnpj:'),oFont10)
					oPrint:Say(0630,1370,TransForm(SA2->A2_CGC,'@R 99.999.999/9999-99'),oFont11n)
					//oPrint:Say(0630,1200,OemToAnsi('Cep:'),oFont10)
					//oPrint:Say(0630,1370,TransForm(SA2->A2_CEP,'@R 99.999-999'),oFont11)
					oPrint:Say(0680,0100,OemToAnsi('Telefone:'),oFont10)
					oPrint:Say(0680,0430,SA2->A2_TEL,oFont11)
					//oPrint:Say(0680,1200,OemToAnsi('Cnpj:'),oFont10)
					//oPrint:Say(0680,1370,SA2->A2_CGC,'@R 99.999.999/999-99')oFont11)
					oPrint:Say(0680,1200,OemToAnsi('Cep:'),oFont10)
					oPrint:Say(0680,1370,TransForm(SA2->A2_CEP,'@R 99.999-999'),oFont11)
					oPrint:Say(0730,0100,OemToAnsi('Contato:'),oFont10)
					oPrint:Say(0730,0430,SC7->C7_CONTATO,oFont11)
					oPrint:Say(0730,1200,OemToAnsi('Email:'),oFont10)
					oPrint:Say(0730,1370,SA2->A2_EMAIL,oFont11)

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณNumero/Emissaoณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				  
					oPrint:Box(0530,1900,0730,2300)
					oPrint:Say(0535,1960,OemToAnsi('Numero documento'),oFont08)
					oPrint:Say(0570,2000,SC7->C7_NUM,oFont18)
					oPrint:Say(0690,2000,Dtoc(SC7->C7_EMISSAO),oFont12) 
					oPrint:Say(0650,2000,"SC:"+SC7->C7_NUMSC,oFont12)
					
					lFlag := .f.
				EndIf
				
				If	( lPrintDesTab )
					//oPrint:Line(nLinha,100,nLinha,2300) 
					oPrint:Line(nLinha,100,nLinha,2300)
					oPrint:Line(nLinha,100,nLinha+70,100) // Item
					oPrint:Line(nLinha,160,nLinha+70,160) // Codigo
					oPrint:Line(nLinha,310,nLinha+70,310) // Descricao
					oPrint:Line(nLinha,1220,nLinha+70,1220) // Un
					oPrint:Line(nLinha,1300,nLinha+70,1300) // Entrega
					oPrint:Line(nLinha,1455,nLinha+70,1455) // Qtde
					oPrint:Line(nLinha,1680,nLinha+70,1680) // Unit
					oPrint:Line(nLinha,1850,nLinha+70,1850) // Ipi
					oPrint:Line(nLinha,2000,nLinha+70,2000) // Total
					oPrint:Line(nLinha,2300,nLinha+70,2300)

					//oPrint:Say(nLinha,0120,OemToAnsi('It'),oFont12)
					oPrint:Say(nLinha,0120,OemToAnsi('It'),oFont12)
					oPrint:Say(nLinha,0170,OemToAnsi('C๓digo'),oFont12)
					oPrint:Say(nLinha,0320,OemToAnsi('Descri็ใo'),oFont12)
					oPrint:Say(nLinha,1230,OemToAnsi('Un'),oFont12)
					oPrint:Say(nLinha,1350,OemToAnsi('Entrg'),oFont12)
					oPrint:Say(nLinha,1560,OemToAnsi('Qtde'),oFont12)
					oPrint:Say(nLinha,1700,OemToAnsi('Vlr.Unit.'),oFont12)
					oPrint:Say(nLinha,1900,OemToAnsi('Ipi %'),oFont12)
					oPrint:Say(nLinha,2080,OemToAnsi('Valor Total'),oFont12)
					lPrintDesTab := .f.
					nLinha += 70
					oPrint:Line(nLinha,100,nLinha,2300)
				EndIf

				//oPrint:Line(nLinha,100,nLinha,2300) 
				oPrint:Line(nLinha,100,nLinha,2300) 
				oPrint:Line(nLinha,100,nLinha+70,100) // Item
				oPrint:Line(nLinha,160,nLinha+70,160) // Codigo
				oPrint:Line(nLinha,310,nLinha+70,310) // Descricao
				oPrint:Line(nLinha,1220,nLinha+70,1220) // Un
				oPrint:Line(nLinha,1300,nLinha+70,1300) // Entrega
				oPrint:Line(nLinha,1455,nLinha+70,1455) // Qtde
				oPrint:Line(nLinha,1680,nLinha+70,1680) // Unit
				oPrint:Line(nLinha,1850,nLinha+70,1850) // Ipi
				oPrint:Line(nLinha,2000,nLinha+70,2000) // Total
				oPrint:Line(nLinha,2300,nLinha+70,2300)

				oPrint:Say(nLinha,0120,Right(TRA->C7_ITEM,2),oFont09)
				If	( lPrintCodFor )
					DbSelectArea('SA5')
					SA5->(DbSetOrder(1))
					If	SA5->(DbSeek(xFilial('SA5') + SA2->A2_COD + SA2->A2_LOJA + TRA->C7_PRODUTO)) .and. ( ! Empty(SA5->A5_CODPRF) )
						oPrint:Say(nLinha,0180,SA5->A5_CODPRF,oFont09)
					Else
						oPrint:Say(nLinha,0168,TRA->C7_PRODUTO,oFont09)
					EndIf
				Else
					oPrint:Say(nLinha,0168,TRA->C7_PRODUTO,oFont09)
				EndIf	
				oPrint:Say(nLinha,1230,TRA->C7_UM,oFont09)
				//oPrint:Say(nLinha,1450,Left(DtoC(TRA->C7_DATPRF),5),oFont10n,,,,1)
				oPrint:Say(nLinha,1437,Left(DtoC(TRA->C7_DATPRF),8),oFont09,,,,1)
				oPrint:Say(nLinha,1670,AllTrim(TransForm(TRA->C7_QUANT,'@E 99,999.9')),oFont12,,,,1)

				If	( lImpPrc )
					oPrint:Say(nLinha,1850,AllTrim(TransForm(TRA->C7_PRECO,'@E 999,999.99')),oFont12,,,,1)
					oPrint:Say(nLinha,2000,AllTrim(TransForm(TRA->C7_IPI,'@E 99.99')),oFont12,,,,1)
					oPrint:Say(nLinha,2260,AllTrim(TransForm(TRA->C7_TOTAL,'@E 999,999.99')),oFont12,,,,1)
				EndIf

				SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+TRA->C7_PRODUTO))
				If !SB5->(dbSetOrder(1), dbSeek(xFilial("SB5")+TRA->C7_PRODUTO))
					cDesc := AllTrim(SB1->B1_DESC)
				Else
					cDesc := AllTrim(SB5->B5_CEME)
				Endif
				
				
				
				_nLinhas := MlCount(cDesc,45)
				For _nT := 1 To _nLinhas
					//oPrint:Line(nLinha,100,nLinha+70,100) // Item
					oPrint:Line(nLinha,100,nLinha+70,0100) // Item
					oPrint:Line(nLinha,160,nLinha+70,160) // Codigo
					oPrint:Line(nLinha,310,nLinha+70,310) // Descricao
					oPrint:Line(nLinha,1220,nLinha+70,1220) // Un
					oPrint:Line(nLinha,1300,nLinha+70,1300) // Entrega
					oPrint:Line(nLinha,1455,nLinha+70,1455) // Qtde
					oPrint:Line(nLinha,1680,nLinha+70,1680) // Unit
					oPrint:Line(nLinha,1850,nLinha+70,1850) // Ipi
					oPrint:Line(nLinha,2000,nLinha+70,2000) // Total
					oPrint:Line(nLinha,2300,nLinha+70,2300)

					//oPrint:Say(nLinha,0320,Capital(MemoLine(cDesc,45,_nT)),oFont10,,0)
					oPrint:Say(nLinha,0320,Capital(MemoLine(cDesc,45,_nT)),oFont09,,0)
					nLinha+=40
				Next _nT

				nLinha += 30
				oPrint:Line(nLinha,100,nLinha,2300)

				_nValMerc 		+= TRA->C7_TOTAL
				_nValIPI		+= (TRA->C7_TOTAL * TRA->C7_IPI) / 100
				_nValDesc		+= TRA->C7_VLDESC
				_nTotAcr		+= TRA->C7_DESPESA
				_nTotSeg		+= TRA->C7_SEGURO
				_nTotFre		+= TRA->C7_VALFRE

				If	( Empty(TRA->C7_TES) )
					_nTotIcmsRet	+= TRA->C7_ICMSRET
				Else
					DbSelectArea('SF4')
					SF4->(DbSetOrder(1))
					If	SF4->(DbSeek(xFilial('SF4') + TRA->C7_TES))
						If	( AllTrim(SF4->F4_INCSOL) == 'S' )
							_nTotIcmsRet	+= TRA->C7_ICMSRET
						EndIf
					EndIf
				EndIf

				       
				//cObserv += AllTrim(TRA->C7_OBS)+' '   //ALTERADO PARA NAO PEGAR O CAMPO PADRAO DO SISTEMA
				cObserv +=  TRA->OBSM

			IncProc()
			TRA->(DbSkip())	

		End

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE MERCADORIASณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor Mercadorias ',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nValMerc,'@E 9,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE I.P.I. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nValIpi > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de I. P. I. (+)',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nValIpi,'@E 9,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE DESCONTOณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nValDesc > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de Desconto (-)',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nValDesc,'@E 9,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE ACRESCIMO ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotAcr > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de Acresc. (+)',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nTotAcr,'@E 9,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE SEGURO ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotSeg > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de Seguro (+)',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nTotSeg,'@E 9,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE FRETE ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotFre > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de Frete (+)',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nTotFre,'@E 9,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime ICMS RETIDO    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotIcmsRet > 0 )
			oPrint:Line(nLinha,1390,nLinha+80,1390)
			oPrint:Line(nLinha,1840,nLinha+80,1840)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de ICMS Retido',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nTotIcmsRet,'@E 9,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1390,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o VALOR TOTAL !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//		oPrint:FillRect({nLinha,1390,nLinha+80,2300},oBrush)
		oPrint:Line(nLinha,1390,nLinha+80,1390)
		oPrint:Line(nLinha,1840,nLinha+80,1840)
		oPrint:Line(nLinha,2300,nLinha+80,2300)
		oPrint:Say(nLinha+10,1400,'VALOR TOTAL ',oFont12)
		If	( lImpPrc )
			oPrint:Say(nLinha+10,2260,TransForm(_nValMerc + _nValIPI - _nValDesc + _nTotAcr	+ _nTotSeg + _nTotFre + _nTotIcmsRet,'@E 9,999,999.99'),oFont13,,,,1)
		EndIf
		nLinha += 80
		xVerPag()
		oPrint:Line(nLinha,1390,nLinha,2300)
		nLinha += 70

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime as observacoes dos parametros. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		//alert(cObServ)
		/*
		cObserv1 := Left(cObserv,70)
		cObserv2 := SubStr(cObserv,71,70)
		cObserv3 := SubStr(cObserv,141,70)
		cObserv4 := SubStr(cObserv,211,70)
		*/
		alinha := {}
		aLinha   := u_TbcSubSt(cObserv, 1,200)
		for i := 1 to len(aLinha)
			if i = 1
				cObserv1 := iif(!empty(aLinha[1]),alinha[1],'') 
			elseif i = 2 
				cObserv2 := iif(!empty(aLinha[2]),alinha[2],'')
			elseif i = 3
				cObserv3 := iif(!empty(aLinha[3]),alinha[3],'')
			elseif i = 4
				cObserv4 := iif(!empty(aLinha[4]),alinha[4],'')
			endif
		next I
		oPrint:Say(nLinha,0100,OemToAnsi('Observa็๕es/USO:'),oFont12)
		oPrint:Say(nLinha,0500,cObserv1,oFont12n)
		nLinha += 60
		xVerPag()
		If	( ! Empty(cObserv2) )
			oPrint:Say(nLinha,0500,cObserv2,oFont12n)
			nLinha += 60
			xVerPag()
		EndIf	
		If	( ! Empty(cObserv3) )
			oPrint:Say(nLinha,0500,cObserv3,oFont12n)
			xVerPag()
			nLinha += 60
		EndIf	
		If	( ! Empty(cObserv4) )
			oPrint:Say(nLinha,0500,cObserv4,oFont12n)
			xVerPag()
			nLinha += 60
			xVerPag()
		EndIf

		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o Representante comercial do fornecedorณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
		/*
		DbSelectArea('SZF')
		SZF->(DbSetOrder(1))
		If	SZF->(DbSeek(xFilial('SZF') + SA2->A2_COD + SA2->A2_LOJA))
			If	( ! Empty(SZF->ZF_REPRES) )
				oPrint:Say(nLinha,0100,OemToAnsi('Representante:'),oFont12)
				oPrint:Say(nLinha,0500,AllTrim(SZF->ZF_REPRES) + Space(5) + AllTrim(SZF->ZF_TELREPR) + Space(5) + AllTrim(SZF->ZF_FAXREPR),oFont12n)
				nLinha += 60
				xVerPag()
			EndIf
		EndIf	
        */
		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime a linha de prazo pagamento/entrega!ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say(nLinha,0100,OemToAnsi('Prazo Pagamento:'),oFont12)
		If !Empty(SC7->C7_COND)
			If SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+SC7->C7_COND))
				oPrint:Say(nLinha,0500,SE4->E4_CODIGO + ' - ' + SE4->E4_DESCRI,oFont12n)
			Endif
		Else
			oPrint:Say(nLinha,0500,'_____________________',oFont12n)
		Endif
		
//		oPrint:Say(nLinha,1120,OemToAnsi('Prazo Entrega:'),oFont12)
//		oPrint:Say(nLinha,1500,'___________________________',oFont12n)
		nLinha += 60
  		xVerPag()

		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime a linha de transportadora !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*		oPrint:Say(nLinha,0100,OemToAnsi('Transportadora:'),oFont12)
		oPrint:Say(nLinha,0500,'____________________________________________________',oFont12n)*/
		nLinha += 60
		xVerPag()

		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o Contato.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( ! Empty(SA2->A2_CONTATO) )
			oPrint:Say(nLinha,0100,OemToAnsi('Contato: '),oFont12)
			oPrint:Say(nLinha,0500,SA2->A2_CONTATO,oFont12n)
			nLinha += 60
			xVerPag()
		EndIf

		oPrint:Line(nLinha,0100,nLinha,2300)
		nLinha += 10
		xVerPag()

		TRA->(DbCloseArea())

		xRodape()

		
		If !Empty(_nQtdReg)
			U_EPed(cNumPed,'')					
		Endif
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime em Video, e finaliza a impressao. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		oPrint:Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xCabec() บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Cabecalho do relatorio...                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xCabec()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o cabecalho da empresa. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:SayBitmap(050,100,cFileLogo,1050,260)
	   //	oPrint:Say(050,1300,AllTrim(Upper(SM0->M0_NOMECOM)),oFont13)
		//oPrint:Say(050,1300,"QUEBEC CONSTRUวีES E TEC. AMBIENTAL S/A",oFont13)
		oPrint:Say(050,1300,AllTrim(SM0->M0_NOMECOM),oFont14)
		oPrint:Say(135,1300,AllTrim(SM0->M0_ENDCOB),oFont11)
		oPrint:Say(180,1300,Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) + '  -  ' + TransForm(AllTrim(SM0->M0_TEL),"@R (999) 9999-9999"),oFont11)
		oPrint:Say(225,1300,AllTrim('www.delfirearms.com'),oFont11) 
		oPrint:Say(300,1930,"PC:"+SC7->C7_NUM,oFont12)
		oPrint:Line(285,1300,285,2270)
		oPrint:Say(300,1300,TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99'),oFont12)
		oPrint:Say(300,1700,SM0->M0_INSC,oFont12) 
		oPrint:Say(350,1300,"Local de Entrega: "+Posicione("NNR",1,xFilial("NNR")+SC7->C7_LOCAL,"NNR_DESCRI"),oFont12) //Pedro Neto

		
		//oPrint:Box(0330,1900,0730,2300)
   	   //	oPrint:Say(0535,1960,OemToAnsi('Numero documento'),oFont08)
		//oPrint:Say(0570,2000,SC7->C7_NUM,oFont18)
		//oPrint:Say(0490,2000,Dtoc(SC7->C7_EMISSAO),oFont12) 
		//oPrint:Say(0450,2000,"SC:"+SC7->C7_NUMSC,oFont12)
		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTitulo do Relatorioณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( nTitulo == 1 ) // Cotacao
			oPrint:Say(0400,0800,OemToAnsi('Cota็ใo de Compras'),oFont22)
		Else
			oPrint:Say(0400,0800,OemToAnsi('Pedido de Compras'),oFont22)
		EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xRodape()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Rodape do Relatorio....                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xRodape()
      
//TESTE PEDRO 
    	
    
    	cComprador:= ""
		cAlter	  := ""
		cAprov	  := ""
		lNewAlc	  := .F.
		lLiber 	  := .F.
		
		dbSelectArea("SC7")
		If !Empty(SC7->C7_APROV)
			
			cTipoSC7:= IIF(SC7->C7_TIPO == 1,"PC","AE")
			lNewAlc := .T.
			cComprador := UsrFullName(SC7->C7_USER) 
			If SC7->C7_CONAPRO != "B"
			lLiber := .T.
			EndIf
			dbSelectArea("SCR")
			dbSetOrder(1)
			dbSeek(xFilial("SCR")+cTipoSC7+SC7->C7_NUM)
			While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SCR")+SC7->C7_NUM .And. SCR->CR_TIPO == cTipoSC7
				cAprov += AllTrim(UsrFullName(SCR->CR_USERLIB)) +'                                                              '
					//Do Case
					//Case SCR->CR_STATUS=="03" //Liberado
						//cAprov += "Ok"
					//Case SCR->CR_STATUS=="04" //Bloqueado
					//	cAprov += "BLQ"
					//Case SCR->CR_STATUS=="05" //Nivel Liberado
					 //	cAprov += "##"
					//OtherWise                 //Aguar.Lib
						//cAprov += "??"
				//EndCase
				//cAprov += "] - "
				dbSelectArea("SCR")
				dbSkip()
			Enddo
			If !Empty(SC7->C7_GRUPCOM)
				dbSelectArea("SAJ")
				dbSetOrder(1)
				dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
				While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
					If SAJ->AJ_USER != SC7->C7_USER
						cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
					EndIf
					dbSelectArea("SAJ")
					dbSkip()
				EndDo
			EndIf
		EndIf
             // TESTE PEDRO


	    
    //oPrint:Say(2948,0515,'FELICIANO MATOS',oFont16) //Pedro Neto 23/05/2016
    oPrint:Say(2950,0500,'_________________________',oFont16)  
    oPrint:Say(2948,1535, cAprov ,oFont16)
    oPrint:Say(2950,1500,'_________________________',oFont16)
    oPrint:Say(2950,0535, cComprador ,oFont16)//Pedro Neto 23/05/2016
    oPrint:Say(3000,0600,'Comprador',oFont16)
    oPrint:Say(3000,1600,'Aprovador',oFont16) 
    	
    	
	oPrint:Line(3100,0100,3100,2300)
   // oPrint:Say(3120,1050,TransForm(AllTrim(SM0->M0_TEL),"@R (999) 9999-9999"),oFont16)  
   oPrint:SayBitmap(3120,160,"logo_totvs.bmp", 140, 60) //Impressao da Logo
   oPrint:Say(3120, 1200, "Microsiga Protheus", oFont10N,,,,2)
   oPrint:Say(3120,2290, DTOC(dDatabase) + " " + TIME(), oFont10,,,,1)
   oPrint:Line(3200,0100,3200,2300)
   oPrint:EndPage()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xVerPag()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se deve ou nao saltar pagina...                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xVerPag()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia a montagem da impressao.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//If	( nLinha >= 3000 )
	If	( nLinha >= 2800 )//Delimita o fim da impressao dos itens
		If	( ! lFlag )
			xRodape()
			oPrint:EndPage()
			nLinha:= 600
		Else
			nLinha:= 800
		EndIf

		oPrint:StartPage()
		xCabec()

		lPrintDesTab := .t.

	EndIf
	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSX1บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta o SX1 - Arquivo de Perguntas..                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1(cPerg)
Local	aRegs   := {},;
		_sAlias := Alias(),;
		nX

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCampos a serem grav. no SX1ณ
		//ณaRegs[nx][01] - X1_GRUPO   ณ
		//ณaRegs[nx][02] - X1_ORDEM   ณ
		//ณaRegs[nx][03] - X1_PERGUNTEณ
		//ณaRegs[nx][04] - X1_PERSPA  ณ
		//ณaRegs[nx][05] - X1_PERENG  ณ
		//ณaRegs[nx][06] - X1_VARIAVL ณ
		//ณaRegs[nx][07] - X1_TIPO    ณ
		//ณaRegs[nx][08] - X1_TAMANHO ณ
		//ณaRegs[nx][09] - X1_DECIMAL ณ
		//ณaRegs[nx][10] - X1_PRESEL  ณ
		//ณaRegs[nx][11] - X1_GSC     ณ
		//ณaRegs[nx][12] - X1_VALID   ณ
		//ณaRegs[nx][13] - X1_VAR01   ณ
		//ณaRegs[nx][14] - X1_DEF01   ณ
		//ณaRegs[nx][15] - X1_DEF02   ณ
		//ณaRegs[nx][16] - X1_DEF03   ณ
		//ณaRegs[nx][17] - X1_F3      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria uma array, contendo todos os valores...ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aAdd(aRegs,{cPerg,'01','Numero do Pedido   ?','Numero do Pedido   ?','Numero do Pedido   ?','mv_ch1','C', 6,0,0,'G','','mv_par01','','','','SC7'})
		aAdd(aRegs,{cPerg,'02','Imprime precos     ?','Imprime precos     ?','Imprime precos     ?','mv_ch2','N', 1,0,1,'C','','mv_par02',OemToAnsi('Nใo'),'Sim','',''})
		aAdd(aRegs,{cPerg,'03','Titulo do Relatorio?','Titulo do Relatorio?','Titulo do Relatorio?','mv_ch3','N', 1,0,1,'C','','mv_par03',OemToAnsi('Cota็ใo'),'Pedido','',''})
		aAdd(aRegs,{cPerg,'04',OemToAnsi('Observa็๕es'),'Observa็๕es         ','Observa็๕es         ','mv_ch4','C',70,0,1,'G','','mv_par04','','','',''})
		aAdd(aRegs,{cPerg,'05','                    ','                    ','                    ','mv_ch5','C',70,0,1,'G','','mv_par05','','','',''})
		aAdd(aRegs,{cPerg,'06','                    ','                    ','                    ','mv_ch6','C',70,0,0,'G','','mv_par06','','','',''})
		aAdd(aRegs,{cPerg,'07','                    ','                    ','                    ','mv_ch7','C',70,0,0,'G','','mv_par07','','','',''})
		aAdd(aRegs,{cPerg,'08','Imp. Cod. Prod. For?','Imp. Cod. Prod. For?','Imp. Cod. Prod. For?','mv_ch8','N', 1,0,1,'C','','mv_par08',OemToAnsi('Sim'),OemToAnsi('Nใo'),'',''})

		DbSelectArea('SX1')
		SX1->(DbSetOrder(1))

		For nX:=1 to Len(aRegs)
			If !SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02]))
				RecLock('SX1',.t.)
				Replace SX1->X1_GRUPO		With aRegs[nx][01]
				Replace SX1->X1_ORDEM   	With aRegs[nx][02]
				Replace SX1->X1_PERGUNTE	With aRegs[nx][03]
				Replace SX1->X1_PERSPA		With aRegs[nx][04]
				Replace SX1->X1_PERENG		With aRegs[nx][05]
				Replace SX1->X1_VARIAVL		With aRegs[nx][06]
				Replace SX1->X1_TIPO		With aRegs[nx][07]
				Replace SX1->X1_TAMANHO		With aRegs[nx][08]
				Replace SX1->X1_DECIMAL		With aRegs[nx][09]
				Replace SX1->X1_PRESEL		With aRegs[nx][10]
				Replace SX1->X1_GSC			With aRegs[nx][11]
				Replace SX1->X1_VALID		With aRegs[nx][12]
				Replace SX1->X1_VAR01		With aRegs[nx][13]
				Replace SX1->X1_DEF01		With aRegs[nx][14]
				Replace SX1->X1_DEF02		With aRegs[nx][15]
				Replace SX1->X1_DEF03		With aRegs[nx][16]
				Replace SX1->X1_F3   		With aRegs[nx][17]
				MsUnlock('SX1')
			Endif
		Next nX

Return



User Function EPed(cPedido,cProduto)
Local _aArea  := GetArea()
local _nLinhas := 0
Private oArial30  	:=	TFont():New("Arial",,24,,.F.,,,,,.F.,.F.)
Private oArial14N	:=	TFont():New("Arial Narrow",,14,,.T.,,,,,.F.,.F.)
Private oArial15N	:=	TFont():New("Arial Narrow",,15,,.T.,,,,,.F.,.F.) 
Private oArial18N	:=	TFont():New("Arial Narrow",,18,,.T.,,,,,.F.,.F.) 
Private o17N	:=	TFont():New("Arial Narrow",,12,,.T.,,,,,.F.,.F.)//TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o19N	:=	TFont():New("Arial Narrow",,14,,.T.,,,,,.F.,.F.)//TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o18N	:=	TFont():New("",,12,,.T.,,,,,.F.,.F.)
Private o21N	:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o10N	:=	TFont():New("",,7,,.T.,,,,,.F.,.F.)
Private o11N	:=	TFont():New("",,8,,.T.,,,,,.F.,.F.)
Private oTimes14N	:=	TFont():New("Times New Roman",,12,,.T.,,,,,.F.,.F.)
Private oTimes17N	:=	TFont():New("Times New Roman",,17,,.F.,,,,,.F.,.F.)
Private oTimes21N	:=	TFont():New("Times New Roman",,24,,.T.,,,,,.F.,.F.)   
Private oTimes24N	:=	TFont():New("Times New Roman",,24,,.T.,,,,,.T.,.F.)
Private o29N	:=	TFont():New("",,18,,.T.,,,,,.F.,.F.)
Private o28N	:=	TFont():New("Times New Roman",,12,,.T.,,,,,.F.,.F.)
PRIVATE oFont6  := TFont():New( "Arial",,08,,.f.,,,,,.f. )        
Private cxmail  := SuperGetMv( "MV_XPEDXML" )    //PARAMETRO QUE DEFINE QUAL E-MAIL SERม INFORMADO NO RELATORIO PARA RECEBIMENTO DE XML


aPrd := {}
If !Empty(cPedido) 
	If SC7->(dbSetOrder(1), dbSeek(xFilial("SC7")+cPedido))
		While SC7->(!Eof()) .And. SC7->C7_NUM == cPedido
			If !Empty(cProduto)
				If cProduto <> SC7->C7_PRODUTO
					SC7->(dbSkip(1));Loop
				Endif
			Endif
			
			SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC7->C7_PRODUTO))

			AAdd(aPrd,{SC7->C7_PRODUTO, SB1->B1_DESC, SB1->B1_UM, SC7->C7_QUANT})
			
			SC7->(dbSkip(1))
		Enddo
	Endif
ElseIf !Empty(cProduto)
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProduto))

	AAdd(aPrd,{cProduto, SB1->B1_DESC, SB1->B1_UM, 1})
Else
	Return .t.
Endif

SC7->(dbSetOrder(1), dbSeek(xFilial("SC7")+cPedido))
SA2->(dbSetOrder(1), dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))

//oPrinter:Setup()
//oPrinter:SetPortrait()

/* COMETANDA PEDRO NETO
For _nX := 1 To Len(aPrd)           

	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+aPrd[_nX,1]))

	For nCopias := 1 To 1 //aPrd[_nX,4]
		oPrint:StartPage()
		               
			
		If _nX == 1
		*/                                 
			/*oPrint:Say(0150,900,"A T E N ว ร O",oTimes24N,,0)
			oPrint:Say(0350,070,"Autorizamos o fornecimento dos materiais / equipamentos relacionados nesta",oArial18N,,0)  
			oPrint:Say(0430,070,"ordem de compra, desde que sejam obedecidas as regras abaixo:",oArial18N,,0)
			oPrint:Say(0800,070,"*Somente faturar para o CNPJ descrito na ordem de compra.",oArial14N,,0)
			oPrint:Say(0930,070,"*Constar no rodap้ da nota fiscal o n๚mero do pedido de compra.",oArial14N,,0)
			oPrint:Say(1050,070,"*Obedecer rigorosamente as condi็๕es de pagamento, valor unitแrio e quantidades descritas na ordem de compra.",oArial14N,,0)  
			oPrint:Say(1180,070,"*Em cumprimento as determina็๕es legais, o fornecedor que emitir a nota fiscal eltr๔nica (NF-e),em substitui็ใo",oArial14N,,0)
			oPrint:Say(1230,070," as nota fiscais Modelos 1A,deverใo encaminhแ-las ao endere็o eletr๔nico: " + cxmail+ ".",oArial14N,,0)
			oPrint:Say(1360,070,"*Caso nใo sejam cumpridas as exig๊ncias acima, a DELFIRE ARMS reserva-se o direito de nใo receber a mercadoria/",oArial14N,,0)  
			oPrint:Say(1410,070," equipamento.Toda e qualquer devolu็ใo ocorrerแ por conta e risco do fornecedor.",oArial14N,,0)*///Jแcion 19/01/2023
		
		    
		/*oPrint:Box(3200,50,70,2400)
		oPrint:Line(3100,50,3100,2400)	
	   	oPrint:SayBitmap(3120,160,"logo_totvs.bmp", 140, 60) //Impressao da Logo
	   	oPrint:Say(3120, 1200, "Microsiga Protheus", oFont10N,,,,2)
		oPrint:Say(3120,2290, DTOC(dDatabase) + " " + TIME(), oFont10,,,,1) - Jแcion Alterado*/

		
		
		/*
		
		Endif
		
		oPrint:Box(0044,0046,0182,0800)
		oPrint:Box(0182,0046,0293,0800)
	
		MSBAR("CODE3_9",0.8,0.8,Rtrim(aPrd[_nX,1]),oPrint,.f.,NIL,.T.,0.0270,0.7,.F.,oFont6,"CODE3_9",.F.)
	
		oPrint:Say(0150,0200,aPrd[_nX,1],o11N,,0)
		
		oPrint:Say(0204,0058,"Pedido:",oTimes14N,,0)
		oPrint:Say(0200,0240,cPedido,o19N,,0)
		oPrint:Box(0293,0046,0371,800)
		oPrint:Say(0297,0063,"Fornec:",oTimes14N,,0)
		oPrint:Say(0297,0240,Capital(SA2->A2_NOME),o11N,,0)
		oPrint:Box(0371,0046,0946,800)
		oPrint:Say(0390,0079,"Descri็ใo:",oTimes14N,,0)
	
		cDesc := aPrd[_nX,2]
		
		_nLinhas := MlCount(cDesc,45)
		lI := 0440 
		For _nT := 1 To _nLinhas
			oPrint:Say(lI,0079,Capital(MemoLine(cDesc,45,_nT)),o11N,,0)
			lI+=30
		Next _nT
				

		oPrint:Say(0660,0079,"Tipo:",oTimes14N,,0)
		oPrint:Say(0660,0300,"Unidade:",oTimes14N,,0)
		oPrint:Say(0660,0500,"Peso Total:",oTimes14N,,0)

		oPrint:Say(0722,0079,SB1->B1_TIPO,o17N,,0)
		oPrint:Say(0722,0300,aPrd[_nX,3],o17N,,0)
		oPrint:Say(0722,0500,TransForm((SB1->B1_PESO * aPrd[_nX,4]),"@E 99,999.9999"),o17N,,0)
		oPrint:Say(0804,0079,"Alm.Padrใo:",oTimes14N,,0)
		oPrint:Say(0857,0079,SB1->B1_LOCPAD,o17N,,0)
		oPrint:Box(0946,0046,1100,800)
	
		oPrint:Say(0080,0520,"QTDE: "+Str(aPrd[_nX,4],5),o28N,,0)
		*/
   //	Private cStartPath    
	//Private nLin 	:= 0    
	//Private nMargemL    := 160  
	//Private nMargemR    := 2300 
	//Private nMargemT	:= 150
	//Private nMargemB	:= 3000
	
	
		  
		//oPrint:EndPage()Jแcion 19/01/2023
	//Next
//Next
RestArea(_aArea)
Return

