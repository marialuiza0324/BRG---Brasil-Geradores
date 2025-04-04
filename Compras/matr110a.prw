#INCLUDE "MATR110A.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR110  � Autor � Alexandre Inacio Lemes� Data �06/09/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pedido de Compras e Autorizacao de Entrega                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR110(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico SIGACOM                                           ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MATR110A( cAlias, nReg, nOpcx )

Local oReport
Local lTRepInUse := .T.

PRIVATE lAuto := (nReg!=Nil)

//����������������������������������������������������������������������������Ŀ
//�Para versoes localizadas em TReport R4 e usado o MATR110, a chamada e       �
//�realizada atraves do MATR111 onde a funcao TRepInUse() e executada para     �
//�selecionar o tipo de impressao R3 ou R4, este tratamento e para impedir que �
//�a pergunta seja apresentada 2 vezes.                                        �
//������������������������������������������������������������������������������
If FunName() == Alltrim("MATR111") .Or. (cPaisLoc <> "BRA" .And. FunName() == Alltrim("MATA121"))
	lTRepInUse := .T.
Else                                    
	lTRepInUse := TRepInUse()
EndIf

If lTRepInUse
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef(nReg, nOpcx)
	oReport:PrintDialog()
Else
	MATR110R3( cAlias, nReg, nOpcx )
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Alexandre Inacio Lemes �Data  �06/09/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pedido de Compras / Autorizacao de Entrega                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nExp01: nReg = Registro posicionado do SC7 apartir Browse  ���
���          � nExp02: nOpcx= 1 - PC / 2 - AE                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef(nReg,nOpcx)

Local cTitle   := STR0003 // "Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
Local oReport
Local oSection1
Local oSection2
Local nTamCdProd:= TamSX3("C7_PRODUTO")[1]


//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01               Do Pedido                             �
//� mv_par02               Ate o Pedido                          �
//� mv_par03               A partir da data de emissao           �
//� mv_par04               Ate a data de emissao                 �
//� mv_par05               Somente os Novos                      �
//� mv_par06               Campo Descricao do Produto    	     �
//� mv_par07               Unidade de Medida:Primaria ou Secund. �
//� mv_par08               Imprime ? Pedido Compra ou Aut. Entreg�
//� mv_par09               Numero de vias                        �
//� mv_par10               Pedidos ? Liberados Bloqueados Ambos  �
//� mv_par11               Impr. SC's Firmes, Previstas ou Ambas �
//� mv_par12               Qual a Moeda ?                        �
//� mv_par13               Endereco de Entrega                   �
//� mv_par14               todas ou em aberto ou atendidos       �
//����������������������������������������������������������������
Pergunte("MTR110",.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//��������������������������������������������������������������������������
oReport:= TReport():New("MATR110",cTitle,"MTR110", {|oReport| ReportPrint(oReport,nReg,nOpcx)},STR0001+" "+STR0002) 
oReport:SetLandscape() // Paisagem 
//oReport:SetPortrait() // Retrato
oReport:HideParamPage()
oReport:HideHeader()
oReport:HideFooter()
oReport:SetTotalInLine(.F.)
oReport:DisableOrientation()
oReport:ParamReadOnly(lAuto)
oSection1:= TRSection():New(oReport,STR0102,{"SC7","SM0","SA2"}, /* <aOrder> */ ,;
								 /* <.lLoadCells.> */ , , /* <cTotalText>  */, /* !<.lTotalInCol.>  */, /* <.lHeaderPage.>  */,;
								 /* <.lHeaderBreak.> */, /* <.lPageBreak.>  */, /* <.lLineBreak.>  */, /* <nLeftMargin>  */,;
								 .T./* <.lLineStyle.>  */, /* <nColSpace>  */,.T. /*<.lAutoSize.> */, /*<cSeparator> */,;
								 /*<nLinesBefore>  */, /*<nCols>  */, /* <nClrBack> */, /* <nClrFore>  */)
oSection1:SetReadOnly()
oSection1:SetNoFilter("SA2")

TRCell():New(oSection1,"M0_NOMECOM","SM0",STR0087      ,/*Picture*/,49,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_ENDENT" ,"SM0",STR0088      ,/*Picture*/,48,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_CEPENT" ,"SM0",STR0089      ,/*Picture*/,10,/*lPixel*/,{|| Trans(SM0->M0_CEPENT,PesqPict("SA2","A2_CEP")) })
TRCell():New(oSection1,"M0_CIDENT" ,"SM0",STR0090      ,/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_ESTENT" ,"SM0",STR0091      ,/*Picture*/,11,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_CGC"    ,"SM0",STR0113      ,/*Picture*/,18,/*lPixel*/,{|| Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")) })
If cPaisLoc == "BRA"
	TRCell():New(oSection1,"M0IE"  ,"   ",STR0041      ,/*Picture*/,18,/*lPixel*/,{|| InscrEst()})
EndIf
TRCell():New(oSection1,"M0_TEL"    ,"SM0",STR0092      ,/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_FAX"    ,"SM0",STR0093      ,/*Picture*/,34,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_NOME"   ,"SA2",/*Titulo*/   ,/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_COD"    ,"SA2",/*Titulo*/   ,/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_LOJA"   ,"SA2",/*Titulo*/   ,/*Picture*/,04,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_END"    ,"SA2",/*Titulo*/   ,/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_BAIRRO" ,"SA2",/*Titulo*/   ,/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_CEP"    ,"SA2",/*Titulo*/   ,/*Picture*/,08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_MUN"    ,"SA2",/*Titulo*/   ,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_EST"    ,"SA2",/*Titulo*/   ,/*Picture*/,02,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_CGC"    ,"SA2",/*Titulo*/   ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"INSCR"     ,"   ",If( cPaisLoc$"ARG|POR|EUA",space(11) , STR0095 ),/*Picture*/,18,/*lPixel*/,{|| If( cPaisLoc$"ARG|POR|EUA",space(18), SA2->A2_INSCR ) })
TRCell():New(oSection1,"FONE"      ,"   ",STR0094      ,/*Picture*/,25,/*lPixel*/,{|| "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15)})
TRCell():New(oSection1,"FAX"       ,"   ",STR0093      ,/*Picture*/,25,/*lPixel*/,{|| "("+Substr(SA2->A2_DDD,1,3)+") "+SubStr(SA2->A2_FAX,1,15)})

oSection1:Cell("A2_BAIRRO"):SetCellBreak()
oSection1:Cell("A2_CGC"   ):SetCellBreak()
oSection1:Cell("INSCR"    ):SetCellBreak()

oSection2:= TRSection():New(oSection1, STR0103, {"SC7","SB1"}, /* <aOrder> */ ,;
								 /* <.lLoadCells.> */ , , /* <cTotalText>  */, /* !<.lTotalInCol.>  */, /* <.lHeaderPage.>  */,;
								 /* <.lHeaderBreak.> */, /* <.lPageBreak.>  */, /* <.lLineBreak.>  */, /* <nLeftMargin>  */,;
								 /* <.lLineStyle.>  */, /* <nColSpace>  */, /*<.lAutoSize.> */, /*<cSeparator> */,;
								 /*<nLinesBefore>  */, /*<nCols>  */, /* <nClrBack> */, /* <nClrFore>  */)

oSection2:SetCellBorder("ALL",,,.T.)
oSection2:SetCellBorder("RIGHT")                        
oSection2:SetCellBorder("LEFT")                                   

TRCell():New(oSection2,"C7_NUM"			,"SC7",/*Titulo*/  	,/*Picture*/)                                                                                
TRCell():New(oSection2,"C7_ITEM"    	,"SC7",/*Titulo*/	,/*Picture*/)
TRCell():New(oSection2,"C7_PRODUTO" 	,"SC7",/*Titulo*/	,/*Picture*/)      
TRCell():New(oSection2,"C7_DESCRI"   	,"SC7",STR0097	,PesqPict("SC7","C7_DESCRI"),35) 
//TRCell():New(oSection2,"DESCPROD"   	,"   ",STR0097   	,/*Picture*/,30,/*lPixel*/, {|| cDescPro},,,,,,.T.)
TRCell():New(oSection2,"C7_UM"      	,"SC7",STR0115   	,/*Picture*/)
TRCell():New(oSection2,"C7_QUANT"   	,"SC7",/*Titulo*/	,PesqPict("SC7","C7_QUANT")) 
TRCell():New(oSection2,"C7_SEGUM"   	,"SC7",STR0118	,/*Picture*/)
TRCell():New(oSection2,"C7_QTSEGUM" 	,"SC7",/*Titulo*/	,/*Picture*/)
TRCell():New(oSection2,"PRECO"      	,"   ",STR0098	,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| nVlUnitSC7 },"RIGHT",,"RIGHT")
TRCell():New(oSection2,"C7_IPI"     	,"SC7",STR0119	,/*Picture*/)
TRCell():New(oSection2,"TOTAL"     	,"   ",STR0099	,PesqPict("SC7","C7_TOTAL"),/*Tamanho*/,/*lPixel*/,{|| nValTotSC7 },"RIGHT",,"RIGHT")
TRCell():New(oSection2,"C7_DATPRF"  	,"SC7",/*Titulo*/	,/*Picture*/)   
TRCell():New(oSection2,"C7_OBS"      	,"SC7","Observa��es",PesqPict("SC7","C7_OBS"),92)
//TRCell():New(oSection2,"C7_CC"      	,"SC7",STR0066	,/*Picture*/)
//TRCell():New(oSection2,"C7_NUMSC"   	,"SC7",STR0123	,/*Picture*/)
TRCell():New(oSection2,"OPCC"       	,"   ",STR0100  	,/*Picture*/,TamSX3("C7_OP")[1],/*lPixel*/,{|| cOPCC },,,,,,.F.)          

oSection2:Cell("C7_PRODUTO"):SetLineBreak()                        
//oSection2:Cell("DESCPROD"):SetLineBreak()                        
//oSection2:Cell("C7_CC"):SetLineBreak()                        
oSection2:Cell("OPCC"):SetLineBreak()                        

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Alexandre Inacio Lemes �Data  �06/09/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao do Pedido de Compras / Autorizacao de Entrega      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ReportPrint(ExpO1,ExpN1,ExpN2)                             ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Objeto oReport                      	              ���
���          � ExpN1 = Numero do Recno posicionado do SC7 impressao Menu  ���
���          � ExpN2 = Numero da opcao para impressao via menu do PC      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,nReg,nOpcX)

Local oSection1   := oReport:Section(1)
Local oSection2   := oReport:Section(1):Section(1)

Local aRecnoSave  := {}
Local aPedido     := {}
Local aPedMail    := {}
Local aValIVA     := {}

Local cNumSC7		:= Len(SC7->C7_NUM)
Local cCondicao	:= ""
Local cFiltro		:= ""
Local cComprador	:= ""
LOcal cAlter		:= ""
Local cAprov		:= ""
Local cTipoSC7	:= ""
Local cCondBus	:= ""
Local cMensagem	:= ""
Local cVar			:= ""
Local cPictVUnit	:= PesqPict("SC7","C7_PRECO",16)
Local cPictVTot	:= PesqPict("SC7","C7_TOTAL",, mv_par12)
Local lNewAlc		:= .F.
Local lLiber		:= .F.
Local lRet			:= .T.

Local nRecnoSC7   := 0
Local nTotalsX3   := 0
Local nRecnoSM0   := 0
Local nX          := 0
Local nY          := 0
Local nVias       := 0
Local nTxMoeda    := 0
Local nTpImp	  := IIF(ValType(oReport:nDevice)!=Nil,oReport:nDevice,0) // Tipo de Impressao
Local nPageWidth  := IIF(nTpImp==1.Or.nTpImp==6,3005,3005) // oReport:PageWidth()  //2435 ki tava no lubar de 3005 Ricardo Moreira 
Local nPrinted    := 0 //0 Ricardo alterado pra teste
Local nValIVA     := 0
Local nTotIpi	  := 0
Local nTotIcms	  := 0
Local nTotDesp	  := 0
Local nTotFrete	  := 0
Local nTotalNF	  := 0
Local nTotSeguro  := 0
Local nLinPC	  := 0
Local nLinObs     := 0
Local nDescProd   := 0
Local nTotal      := 0
Local nTotMerc    := 0
Local nPagina     := 0
Local nOrder      := 1
Local cUserId     := RetCodUsr()
Local cCont       := Nil
Local lImpri      := .F.
Local cCident	  := ""
Local cCidcob	  := ""
Local nLinPC2	  := 0
Local nLinPC3	  := 0
Local nAprovLin := 0

Private cDescPro  := ""
Private cOPCC     := ""
Private	nVlUnitSC7:= 0
Private nValTotSC7:= 0

Private cObs01    := ""
Private cObs02    := ""
Private cObs03    := ""
Private cObs04    := ""
Private cObs05    := ""
Private cObs06    := ""
Private cObs07    := ""
Private cObs08    := ""
Private cObs09    := ""
Private cObs10    := ""
Private cObs11    := ""
Private cObs12    := ""
Private cObs13    := ""
Private cObs14    := ""
Private cObs15    := ""
Private cObs16    := ""
If Type("lPedido") != "L"
	lPedido := .F.
Endif
/*
If nTpImp==1 .Or. nTpImp==6
	oSection2:ACELL[2]:NSIZE:=20
	oSection2:ACELL[3]:NSIZE:=20
	oSection2:ACELL[14]:NSIZE:=25
EndIf
*/
dbSelectArea("SC7")

	mv_par01 := SC7->C7_NUM
	mv_par02 := SC7->C7_NUM
If lAuto
	dbSelectArea("SC7")
	dbGoto(nReg)
	mv_par01 := SC7->C7_NUM
	mv_par02 := SC7->C7_NUM
	mv_par03 := SC7->C7_EMISSAO
	mv_par04 := SC7->C7_EMISSAO
	mv_par05 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","05"),If(cCont == Nil,2,cCont) })
   	mv_par08 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","08"),If(cCont == Nil,C7_TIPO,cCont) })
	mv_par09 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","09"),If(cCont == Nil,1,cCont) })
  	mv_par10 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","10"),If(cCont == Nil,3,cCont) }) 
	mv_par11 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","11"),If(cCont == Nil,3,cCont) }) 
  	mv_par14 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","14"),If(cCont == Nil,1,cCont) }) 	
Else
	MakeAdvplExpr(oReport:uParam)
	
	cCondicao := 'C7_FILIAL=="'       + xFilial("SC7") + '".And.'
	cCondicao += 'C7_NUM>="'          + mv_par01       + '".And.C7_NUM<="'          + mv_par02 + '"'
	//cCondicao += 'Dtos(C7_EMISSAO)>="'+ Dtos(mv_par03) +'".And.Dtos(C7_EMISSAO)<="' + Dtos(mv_par04) + '"'
	
	oReport:Section(1):SetFilter(cCondicao,IndexKey())
EndIf      

If lPedido
	mv_par12 := MAX(SC7->C7_MOEDA,1)
EndIf

If SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3
	If ( cPaisLoc$"ARG|POR|EUA" )
		cCondBus := "1"+StrZero(Val(mv_par01),6)
		nOrder	 := 10
	Else
		cCondBus := mv_par01
		nOrder	 := 1
	EndIf
Else
	cCondBus := "2"+StrZero(Val(mv_par01),6)
	nOrder	 := 10
EndIf

If mv_par14 == 2
	cFiltro := "SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)"
Elseif mv_par14 == 3
	cFiltro := "SC7->C7_QUANT > SC7->C7_QUJE"
EndIf

oSection2:Cell("PRECO"):SetPicture(cPictVUnit)
oSection2:Cell("TOTAL"):SetPicture(cPictVTot)

TRPosition():New(oSection2,"SB1",1,{ || xFilial("SB1") + SC7->C7_PRODUTO })
TRPosition():New(oSection2,"SB5",1,{ || xFilial("SB5") + SC7->C7_PRODUTO })

//�����������������������������������������������������������������������������������������Ŀ
//� Executa o CodeBlock com o PrintLine da Sessao 1 toda vez que rodar o oSection1:Init()   �
//�������������������������������������������������������������������������������������������
oReport:onPageBreak( { || nPagina++ , nPrinted := 0 , CabecPCxAE(oReport,oSection1,nVias,nPagina) })

oReport:SetMeter(SC7->(LastRec()))
dbSelectArea("SC7")
dbSetOrder(nOrder)
dbSeek(xFilial("SC7")+cCondBus,.T.)

oSection2:Init()

cNumSC7 := SC7->C7_NUM

While !oReport:Cancel() .And. !SC7->(Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM >= mv_par01 .And. SC7->C7_NUM <= mv_par02
	
	If (SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(SC7->C7_CONAPRO <> "B" .And. mv_par10 == 2) .Or.;
		(SC7->C7_EMITIDO == "S" .And. mv_par05 == 1) .Or.;
		((SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)) .Or.;
		((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3) .And. mv_par08 == 2) .Or.;
		(SC7->C7_TIPO == 2 .And. (mv_par08 == 1 .OR. mv_par08 == 3)) .Or. !MtrAValOP(mv_par11, "SC7") .Or.;
		(SC7->C7_QUANT > SC7->C7_QUJE .And. mv_par14 == 3) .Or.;
		((SC7->C7_QUANT - SC7->C7_QUJE <= 0 .Or. !Empty(SC7->C7_RESIDUO)) .And. mv_par14 == 2 )
		
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	
	If oReport:Cancel()
		Exit
	EndIf
	
	MaFisEnd()
	R110FIniPC(SC7->C7_NUM,,,cFiltro)
	
	cObs01    := " "
	cObs02    := " "
	cObs03    := " "
	cObs04    := " "
	cObs05    := " "
	cObs06    := " "
	cObs07    := " "
	cObs08    := " "
	cObs09    := " "
	cObs10    := " "
	cObs11    := " "
	cObs12    := " "
	cObs13    := " "
	cObs14    := " "
	cObs15    := " "
	cObs16    := " "
	
	//������������������������������������������������������������������Ŀ
	//� Roda a impressao conforme o numero de vias informado no mv_par09 �
	//��������������������������������������������������������������������
	For nVias := 1 to mv_par09
		
		//��������������������������������������������������������������Ŀ
		//� Dispara a cabec especifica do relatorio.                     �
		//����������������������������������������������������������������
		oReport:EndPage()
		
		nPagina  := 0
		nPrinted := 0
		nTotal   := 0
		nTotMerc := 0
		nDescProd:= 0
		nLinObs  := 0
		nRecnoSC7:= SC7->(Recno())
		cNumSC7  := SC7->C7_NUM
		aPedido  := {SC7->C7_FILIAL,SC7->C7_NUM,SC7->C7_EMISSAO,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_TIPO}
		
		While !oReport:Cancel() .And. !SC7->(Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == cNumSC7
			
			If (SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
				(SC7->C7_CONAPRO <> "B" .And. mv_par10 == 2) .Or.;
				(SC7->C7_EMITIDO == "S" .And. mv_par05 == 1) .Or.;
				((SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)) .Or.;
				((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3) .And. mv_par08 == 2) .Or.;
				(SC7->C7_TIPO == 2 .And. (mv_par08 == 1 .OR. mv_par08 == 3)) .Or. !MtrAValOP(mv_par11, "SC7") .Or.;
				(SC7->C7_QUANT > SC7->C7_QUJE .And. mv_par14 == 3) .Or.;
				((SC7->C7_QUANT - SC7->C7_QUJE <= 0 .Or. !Empty(SC7->C7_RESIDUO)) .And. mv_par14 == 2 )
				dbSelectArea("SC7")
				dbSkip()
				Loop
			Endif
			
			If oReport:Cancel()
				Exit
			EndIf
			
			oReport:IncMeter()
			
			If oReport:Row() > oReport:LineHeight() * 50 //100
			   	oReport:Box( oReport:Row(),010,oReport:Row() + oReport:LineHeight() * 3, nPageWidth )
				oReport:SkipLine()
				oReport:PrintText(STR0101,, 050 ) // Continua na Proxima pagina ....
				oReport:EndPage()
			EndIf
		
			//��������������������������������������������������������������Ŀ
			//� Salva os Recnos do SC7 no aRecnoSave para marcar reimpressao.�
			//����������������������������������������������������������������
			If Ascan(aRecnoSave,SC7->(Recno())) == 0
				AADD(aRecnoSave,SC7->(Recno()))
			Endif
			
			//������������������������������������������������������������Ŀ
			//� Inicializa o descricao do Produto conf. parametro digitado.�
			//��������������������������������������������������������������
			cDescPro :=  ""
			If Empty(mv_par06)
				mv_par06 := "B1_DESC"
			EndIf
			
			If AllTrim(mv_par06) == "B1_DESC"
				SB1->(dbSetOrder(1))
				SB1->(dbSeek( xFilial("SB1") + SC7->C7_PRODUTO ))
				cDescPro := SB1->B1_DESC
			ElseIf AllTrim(mv_par06) == "B5_CEME"
				SB5->(dbSetOrder(1))
				If SB5->(dbSeek( xFilial("SB5") + SC7->C7_PRODUTO ))
					cDescPro := SB5->B5_CEME
				EndIf
			ElseIf AllTrim(mv_par06) == "C7_DESCRI"
				cDescPro := SC7->C7_DESCRI
			EndIf
			
			If Empty(cDescPro)
				SB1->(dbSetOrder(1))
				SB1->(dbSeek( xFilial("SB1") + SC7->C7_PRODUTO ))
				cDescPro := SB1->B1_DESC
			EndIf
			
			SA5->(dbSetOrder(1))
			If SA5->(dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO)) .And. !Empty(SA5->A5_CODPRF)
				cDescPro := cDescPro + " ("+Alltrim(SA5->A5_CODPRF)+")"
			EndIf
			
			If SC7->C7_DESC1 != 0 .Or. SC7->C7_DESC2 != 0 .Or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif
			//��������������������������������������������������������������Ŀ
			//� Inicializacao da Observacao do Pedido.                       �
			//����������������������������������������������������������������
			If !Empty(SC7->C7_OBS) .And. nLinObs < 17
				nLinObs++
				cVar:="cObs"+StrZero(nLinObs,2)
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
			
			nTxMoeda   := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
			nValTotSC7 := xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)
			
			nTotal     := nTotal + SC7->C7_TOTAL
			nTotMerc   := MaFisRet(,"NF_TOTAL")
			
			If oReport:nDevice != 4 .Or. (oReport:nDevice == 4 .And. !oReport:lXlsTable .And. oReport:lXlsHeader)  //impressao em planilha tipo tabela
				oSection2:Cell("C7_NUM"):Disable()
			EndIf
			
			If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM) .And. !Empty(SC7->C7_SEGUM)
				oSection2:Cell("C7_SEGUM"  ):Enable()
				oSection2:Cell("C7_QTSEGUM"):Enable()
				oSection2:Cell("C7_UM"     ):Disable()
				oSection2:Cell("C7_QUANT"  ):Disable()
				nVlUnitSC7 := xMoeda((SC7->C7_TOTAL/SC7->C7_QTSEGUM),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)
			ElseIf MV_PAR07 == 1 .And. !Empty(SC7->C7_QUANT) .And. !Empty(SC7->C7_UM)
				oSection2:Cell("C7_SEGUM"  ):Disable()
				oSection2:Cell("C7_QTSEGUM"):Disable()
				oSection2:Cell("C7_UM"     ):Enable()
				oSection2:Cell("C7_QUANT"  ):Enable()
				nVlUnitSC7 := xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)
			Else
				oSection2:Cell("C7_SEGUM"  ):Enable()
				oSection2:Cell("C7_QTSEGUM"):Enable()
				oSection2:Cell("C7_UM"     ):Enable()
				oSection2:Cell("C7_QUANT"  ):Enable()
				nVlUnitSC7 := xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)
			EndIf
			
			If cPaisLoc <> "BRA" .Or. mv_par08 == 2
				oSection2:Cell("C7_IPI" ):Disable()
			EndIf            ''
			
			If mv_par08 == 1 .OR. mv_par08 == 3
				oSection2:Cell("OPCC"):Disable()
			Else
				oSection2:Cell("C7_DATPRF"):SetSize(9)
			   	//oSection2:Cell("C7_OBS"):SetSize(120)
			   	oSection2:Cell("C7_OBS"):Enable()
				/* RICARDO MOREIRA 28/05/2018
				//oSection2:Cell("C7_CC"):Disable()
				//oSection2:Cell("C7_NUMSC"):Disable()
				If !Empty(SC7->C7_OP)
					cOPCC := STR0065 + " " + SC7->C7_OP
				ElseIf !Empty(SC7->C7_CC)
					cOPCC := STR0066 + " " + SC7->C7_CC
				EndIf
				*/
			EndIf
			
			If oReport:nDevice == 4 .And. oReport:lXlsTable .And. !oReport:lXlsHeader  //impressao em planilha tipo tabela	
				oSection1:Init()
				TRPosition():New(oSection1,"SA2",1,{ || xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA })
				oSection1:PrintLine()
				oSection2:PrintLine()
				oSection1:Finish()
			Else	
				oSection2:PrintLine()
			EndIf
			
			nPrinted ++
			lImpri  := .T.
			dbSelectArea("SC7")
			dbSkip()
			
		EndDo
		
		SC7->(dbGoto(nRecnoSC7))
     	/*
		If oReport:Row() > oReport:LineHeight() * 68
			
			oReport:Box( oReport:Row(),010,oReport:Row() + oReport:LineHeight() * 3, nPageWidth )
			oReport:SkipLine()
			oReport:PrintText(STR0101,, 050 ) // Continua na Proxima pagina ....
			
			//��������������������������������������������������������������Ŀ
			//� Dispara a cabec especifica do relatorio.                     �
			//����������������������������������������������������������������
			oReport:EndPage()
			oReport:PrintText(" ",1992 , 010 ) // Necessario para posicionar Row() para a impressao do Rodape
			
		    oReport:Box( 280,010,oReport:Row() + oReport:LineHeight() * ( 93 - nPrinted ) , nPageWidth )
			//oReport:Box( 280,010,oReport:Row() + oReport:LineHeight() * ( nPrinted ) , nPageWidth )
			
		Else
			//oReport:Box( oReport:Row(),oReport:Col(),oReport:Row() + oReport:LineHeight() * ( nPrinted ) , nPageWidth )
		   	oReport:Box( oReport:Row(),oReport:Col(),oReport:Row() + oReport:LineHeight() * ( 93 - nPrinted ) , nPageWidth )
		EndIf 
		
		*/
	    //oReport:Box( 1990 ,010,oReport:Row() + oReport:LineHeight() * (nPrinted ) , nPageWidth)  
	   	//oReport:Box( 2080 ,010,oReport:Row() + oReport:LineHeight() * (nPrinted ) , nPageWidth)
		//oReport:Box( 2200 ,010,oReport:Row() + oReport:LineHeight() * (nPrinted ) , nPageWidth)
		//oReport:Box( 2320 ,010,oReport:Row() + oReport:LineHeight() * (nPrinted ) , nPageWidth)   
		//oReport:Box( 2200 , 1080 , 2320 , 1400 ) // Box da Data de Emissao
	    //oReport:Box( 2320 ,  010 , 2406 , 1220 ) // Box do Reajuste
		//oReport:Box( 2320 , 1220 , 2460 , 1750 ) // Box do IPI e do Frete
		//oReport:Box( 2320 , 1750 , 2460 , nPageWidth ) // Box do ICMS Despesas e Seguro
	    //oReport:Box( 2406 ,  010 , 2700 , 1220 ) // Box das Observacoes    
	
	
	    oReport:Box( 1540 ,010,oReport:Row() + oReport:LineHeight() * ( 93 - nPrinted ) , nPageWidth)  //1990  //1590
	   	oReport:Box( 1630 ,010,oReport:Row() + oReport:LineHeight() * ( 93 - nPrinted ) , nPageWidth)  //2080  //1680
		oReport:Box( 1750 ,010,oReport:Row() + oReport:LineHeight() * ( 93 - nPrinted ) , nPageWidth)  //2200  //1800
		oReport:Box( 1870 ,010,oReport:Row() + oReport:LineHeight() * ( 93 - nPrinted ) , nPageWidth)  //2320  //1920
		
		oReport:Box( 1750 , 1080 , 1870 , 1400 ) // Box da Data de Emissao    2200        2320    
		oReport:Box( 1870 ,  010 , 1956 , 1220 ) // Box do Reajuste           2320         2406
		oReport:Box( 1870 , 1220 , 2010 , 1750 ) // Box do IPI e do Frete     2320         2460
		oReport:Box( 1870 , 1750 , 2010 , nPageWidth ) // Box do ICMS Despesas e Seguro 2320   2460
		oReport:Box( 1956 ,  010 , 2250 , 1220 ) // Box das Observacoes        2406             2700

		cMensagem:= Formula(C7_MSG)
		If !Empty(cMensagem)
			oReport:SkipLine()
			oReport:PrintText(PadR(cMensagem,129), , oSection2:Cell("DESCPROD"):ColPos() )
		Endif
		//oReport:SkipLine(-5)
		oReport:PrintText( STR0007 /*"D E S C O N T O S -->"*/ + " " + ;
		TransForm(SC7->C7_DESC1,"999.99" ) + " %    " + ;
		TransForm(SC7->C7_DESC2,"999.99" ) + " %    " + ;
		TransForm(SC7->C7_DESC3,"999.99" ) + " %    " + ;
		TransForm(xMoeda(nDescProd,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , PesqPict("SC7","C7_VLDESC",14, MV_PAR12) ),;
		1572 , 050 )  //Ricardo Moreira de 2022 para 1622
		//2022
		oReport:SkipLine()
		oReport:SkipLine()
		oReport:SkipLine()
		
		//��������������������������������������������������������������Ŀ
		//� Posiciona o Arquivo de Empresa SM0.                          �
		//� Imprime endereco de entrega do SM0 somente se o MV_PAR13 =" "�
		//� e o Local de Cobranca :                                      �
		//����������������������������������������������������������������
		SM0->(dbSetOrder(1))
		nRecnoSM0 := SM0->(Recno())
		SM0->(dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT))

		cCident := IIF(len(SM0->M0_CIDENT)>20,Substr(SM0->M0_CIDENT,1,15),SM0->M0_CIDENT)
		cCidcob := IIF(len(SM0->M0_CIDCOB)>20,Substr(SM0->M0_CIDCOB,1,15),SM0->M0_CIDCOB)

		If Empty(MV_PAR13) //"Local de Entrega  : "
			oReport:PrintText(STR0008 + SM0->M0_ENDENT+"  "+Rtrim(SM0->M0_CIDENT)+"  - "+SM0->M0_ESTENT+" - "+STR0009+" "+Trans(Alltrim(SM0->M0_CEPENT),PesqPict("SA2","A2_CEP")),, 050 )
		Else
			oReport:PrintText(STR0008 + mv_par13,, 050 ) //"Local de Entrega  : " imprime o endereco digitado na pergunte
		Endif
		SM0->(dbGoto(nRecnoSM0))
		oReport:PrintText(STR0010 + SM0->M0_ENDCOB+"  "+Rtrim(SM0->M0_CIDCOB)+"  - "+SM0->M0_ESTCOB+" - "+STR0009+" "+Trans(Alltrim(SM0->M0_CEPCOB),PesqPict("SA2","A2_CEP")),, 050 )
		
		oReport:SkipLine()
		oReport:SkipLine()
		
		SE4->(dbSetOrder(1))
		SE4->(dbSeek(xFilial("SE4")+SC7->C7_COND))
		
		nLinPC := oReport:Row() 
		oReport:PrintText( STR0011+SubStr(SE4->E4_COND,1,40),nLinPC,050 )
		oReport:PrintText( STR0070,nLinPC,1120 ) //"Data de Emissao"
		oReport:PrintText( STR0013 +" "+ Transform(xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotal,14,MsDecimais(MV_PAR12)) ),nLinPC,1612 ) //"Total das Mercadorias : "
		oReport:SkipLine()
		nLinPC := oReport:Row()
		
		If cPaisLoc<>"BRA"
			aValIVA := MaFisRet(,"NF_VALIMP")
			nValIVA :=0
			If !Empty(aValIVA)
				For nY:=1 to Len(aValIVA)
					nValIVA+=aValIVA[nY]
				Next nY
			EndIf
			oReport:PrintText(SubStr(SE4->E4_DESCRI,1,34),nLinPC, 050 )
			oReport:PrintText( dtoc(SC7->C7_EMISSAO),nLinPC,1120 )
			oReport:PrintText( STR0063+ "   " + ; //"Total dos Impostos:    "
			Transform(xMoeda(nValIVA,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nValIVA,14,MsDecimais(MV_PAR12)) ),nLinPC,1612 )
		Else
			oReport:PrintText( SubStr(SE4->E4_DESCRI,1,34),nLinPC, 050 )
			oReport:PrintText( dtoc(SC7->C7_EMISSAO),nLinPC,1120 )
			oReport:PrintText( STR0064+ "  " + ; //"Total com Impostos:    "
			Transform(xMoeda(nTotMerc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotMerc,14,MsDecimais(MV_PAR12)) ),nLinPC,1612 )
		Endif
		oReport:SkipLine()
		
		nTotIpi	  := MaFisRet(,'NF_VALIPI')
		nTotIcms  := MaFisRet(,'NF_VALICM')
		nTotDesp  := MaFisRet(,'NF_DESPESA')
		nTotFrete := MaFisRet(,'NF_FRETE')
		nTotSeguro:= MaFisRet(,'NF_SEGURO')
		nTotalNF  := MaFisRet(,'NF_TOTAL')
		
	    oReport:SkipLine()
		oReport:SkipLine()
		nLinPC := oReport:Row() //-40
		
		SM4->(dbSetOrder(1))
		If SM4->(dbSeek(xFilial("SM4")+SC7->C7_REAJUST))
			oReport:PrintText(  STR0014 + " " + SC7->C7_REAJUST + " " + SM4->M4_DESCR ,nLinPC, 050 )  //"Reajuste :"
		EndIf			

		If cPaisLoc == "BRA"
			oReport:PrintText( STR0071 + Transform(xMoeda(nTotIPI ,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIpi ,14,MsDecimais(MV_PAR12))) ,nLinPC,1320 ) //"IPI      :"
			oReport:PrintText( STR0072 + Transform(xMoeda(nTotIcms,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIcms,14,MsDecimais(MV_PAR12))) ,nLinPC,1815 ) //"ICMS     :"
		EndIf
		oReport:SkipLine()

		nLinPC := oReport:Row()
		oReport:PrintText( STR0073 + Transform(xMoeda(nTotFrete,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotFrete,14,MsDecimais(MV_PAR12))) ,nLinPC,1320 ) //"Frete    :"
		oReport:PrintText( STR0074 + Transform(xMoeda(nTotDesp ,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotDesp ,14,MsDecimais(MV_PAR12))) ,nLinPC,1815 ) //"Despesas :"
		oReport:SkipLine()
		
		//��������������������������������������������������������������Ŀ
		//� Inicializar campos de Observacoes.                           �
		//���������������������������������������������������������������� 
		/* Inibi Ricardo Moreira 28/05/2018
		If Empty(cObs02)
			If Len(cObs01) > 30
				cObs := cObs01
				cObs01 := Substr(cObs,1,30)
				For nX := 2 To 16
					cVar  := "cObs"+StrZero(nX,2)
					&cVar := Substr(cObs,(30*(nX-1))+1,30)
				Next nX
			EndIf
		Else
			cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<30,Len(cObs01),30))
			cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<30,Len(cObs01),30))
			cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<30,Len(cObs01),30))
			cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<30,Len(cObs01),30))
			cObs05:= Substr(cObs05,1,IIf(Len(cObs05)<30,Len(cObs01),30))
			cObs06:= Substr(cObs06,1,IIf(Len(cObs06)<30,Len(cObs01),30))
			cObs07:= Substr(cObs07,1,IIf(Len(cObs07)<30,Len(cObs01),30))
			cObs08:= Substr(cObs08,1,IIf(Len(cObs08)<30,Len(cObs01),30))
			cObs09:= Substr(cObs09,1,IIf(Len(cObs09)<30,Len(cObs01),30))
			cObs10:= Substr(cObs10,1,IIf(Len(cObs10)<30,Len(cObs01),30))
			cObs11:= Substr(cObs11,1,IIf(Len(cObs11)<30,Len(cObs01),30))
			cObs12:= Substr(cObs12,1,IIf(Len(cObs12)<30,Len(cObs01),30))
			cObs13:= Substr(cObs13,1,IIf(Len(cObs13)<30,Len(cObs01),30))
			cObs14:= Substr(cObs14,1,IIf(Len(cObs14)<30,Len(cObs01),30))
			cObs15:= Substr(cObs15,1,IIf(Len(cObs15)<30,Len(cObs01),30))
			cObs16:= Substr(cObs16,1,IIf(Len(cObs16)<30,Len(cObs01),30))
		EndIf
		*/
		cComprador:= ""
		cAlter	  := ""
		cAprov	  := ""
		lNewAlc	  := .F.
		lLiber 	  := .F.
		
		dbSelectArea("SC7")
	//Incluida valida��o para os pedidos de compras por item do pedido  (IP/al�ada)			
		cTipoSC7:= IIF((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"PC","AE") 
		
		If cTipoSC7 == "PC"
		
			dbSelectArea("SCR")
			dbSetOrder(1)
			If dbSeek(xFilial("SCR")+cTipoSC7+SC7->C7_NUM)
			Else
				dbSeek(xFilial("SCR")+"IP"+SC7->C7_NUM)
			EndIf
		
		Else
		
			dbSelectArea("SCR")
			dbSetOrder(1)
			dbSeek(xFilial("SCR")+cTipoSC7+SC7->C7_NUM)
		EndIf
		/*
		If !Empty(SC7->C7_APROV) .Or. (Empty(SC7->C7_APROV) .And. SCR->CR_TIPO == "IP")
			
			lNewAlc := .T.
			cComprador := UsrFullName(SC7->C7_USER)
			If SC7->C7_CONAPRO != "B"
				lLiber := .T.
			EndIf

			While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO $ "PC|AE|IP"
				cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["
				Do Case
					Case SCR->CR_STATUS=="02" //Pendente
        				cAprov += "BLQ"
					Case SCR->CR_STATUS=="03" //Liberado
						cAprov += "Ok"
					Case SCR->CR_STATUS=="04" //Bloqueado
						cAprov += "BLQ"
					Case SCR->CR_STATUS=="05" //Nivel Liberado
						cAprov += "##"
					OtherWise                 //Aguar.Lib
						cAprov += "??"
				EndCase
				cAprov += "] - "
				dbSelectArea("SCR")
				dbSkip()
			Enddo
			If !Empty(SC7->C7_GRUPCOM)
				dbSelectArea("SAJ")
				dbSetOrder(1)
				dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
				While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
					If SAJ->AJ_USER != SC7->C7_USER
						If SAJ->(FieldPos("AJ_MSBLQL") > 0)
							If SAJ->AJ_MSBLQL == "1"
								dbSkip()
								LOOP
							EndIf 
						EndIf
						cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
					EndIf
					dbSelectArea("SAJ")
					dbSkip()
				EndDo
			EndIf
		EndIf
        */
		nLinPC := oReport:Row()
		oReport:PrintText( STR0077 ,nLinPC, 050 ) // "Observacoes "
		oReport:PrintText( STR0076 + Transform(xMoeda(nTotSeguro,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotSeguro,14,MsDecimais(MV_PAR12))) ,nLinPC, 1815 ) // "SEGURO   :"
		oReport:SkipLine()
		oReport:SkipLine()
		oReport:SkipLine()
		nLinPC2 := oReport:Row()
		//oReport:PrintText(cObs01,,050 )
		//oReport:PrintText(cObs02,,050 )

		nLinPC := oReport:Row()
		//oReport:PrintText(cObs03,nLinPC,050 )
                                              
		If !lNewAlc
			oReport:PrintText( STR0078 + Transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotalNF,14,MsDecimais(MV_PAR12))) ,nLinPC,1774 ) //"Total Geral :"
			oReport:PrintText("Informar o Numero do Pedido de Compra na Nota Fiscal.",,050 ) //"NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras." Ricardo Coloquei ao inves na linha 903
		Else
			If lLiber
				oReport:PrintText( STR0078 + Transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotalNF,14,MsDecimais(MV_PAR12))) ,nLinPC,1774 )
			Else
				oReport:PrintText( STR0078 + If((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),STR0051,STR0086) ,nLinPC,1390 )
			EndIf
		EndIf
		oReport:SkipLine()
		oReport:PrintText("N�o Aceitamos Factoring.",,050 ) 
		/*       Ricardo 04/06/2018 Tirado a Observa��es no final 
		oReport:PrintText(cObs04,,050 )
		oReport:PrintText(cObs05,,050 )
		oReport:PrintText(cObs06,,050 )
		nLinPC3 := oReport:Row()
		oReport:PrintText(cObs07,,050 )
		oReport:PrintText(cObs08,,050 )
		oReport:PrintText(cObs09,nLinPC2,650 )
		oReport:SkipLine()
		oReport:PrintText(cObs10,,650 )
		oReport:PrintText(cObs11,,650 )
		oReport:PrintText(cObs12,,650 )
		oReport:PrintText(cObs13,,650 )
		oReport:PrintText(cObs14,,650 )
		oReport:PrintText(cObs15,,650 )
		oReport:PrintText(cObs16,,650 )
        */
        
		If !lNewAlc
			
			//oReport:Box( 2300 , 0010 , 2470 , 0400 )         //    2700       3020
			//oReport:Box( 2300 , 0400 , 2470 , 0800 )          //   2700       3020
			//oReport:Box( 2300 , 0800 , 2470 , 1220 )           //  2700       3020
			oReport:Box( 2200 , 1220 , 2300 , 1770 )            // 2600       3020
			oReport:Box( 2200 , 1770 , 2300 , nPageWidth )       //2600       3020
			
			//oReport:SkipLine()
			oReport:SkipLine()
			oReport:SkipLine()

			nLinPC := oReport:Row()
			oReport:PrintText( If((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),UsrFullName(SC7->C7_USER),STR0084),nLinPC,1310) //"Liberacao do Pedido"##"Liber. Autorizacao "
			oReport:PrintText( STR0080 + IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF",IF(SC7->C7_TPFRETE $ "T","Por Conta Terceiros"," " ) )) ,nLinPC,1820 )
			oReport:SkipLine()
           /*
			oReport:SkipLine()
			oReport:SkipLine()

			nLinPC := oReport:Row()
			oReport:PrintText( STR0021 ,nLinPC, 050 ) //"Comprador"
			oReport:PrintText( STR0022 ,nLinPC, 430 ) //"Gerencia"
			oReport:PrintText( STR0023 ,nLinPC, 850 ) //"Diretoria"
			oReport:SkipLine()
           */
			//oReport:SkipLine()
			//oReport:SkipLine()      Inabilitado Ricardo Moreira 04/06/18
			//oReport:SkipLine()
            /*
			nLinPC := oReport:Row()
			oReport:PrintText( Replic("_",23) ,nLinPC,  050 )
			oReport:PrintText( Replic("_",23) ,nLinPC,  430 )
			oReport:PrintText( Replic("_",23) ,nLinPC,  850 )
			oReport:PrintText( Replic("_",31) ,nLinPC, 1310 )
			oReport:SkipLine()

			oReport:SkipLine()
		    //oReport:SkipLine()
			//oReport:SkipLine()
		    //oReport:SkipLine() Inabilitado Ricardo Moreira 04/06/18
			//oReport:SkipLine() Inabilitado Ricardo Moreira 04/06/18
			
			If SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3
				oReport:PrintText(STR0081,,050 ) //"NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
			Else
				oReport:PrintText(STR0083,,050 ) //"NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega."
			EndIf
		*/
		Else
			
			oReport:Box( 2570 , 1220 , 2700 , 1820 )
			oReport:Box( 2570 , 1820 , 2700 , nPageWidth )
			oReport:Box( 2700 , 0010 , 3020 , nPageWidth )
			oReport:Box( 2970 , 0010 , 3020 , 1340 )
			
			nLinPC := nLinPC3
			
			oReport:PrintText( If((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3), If( lLiber , STR0050 , STR0051 ) , If( lLiber , STR0085 , STR0086 ) ),nLinPC,1290 ) //"     P E D I D O   L I B E R A D O"#"|     P E D I D O   B L O Q U E A D O !!!"
			oReport:PrintText( STR0080 + Substr(RetTipoFrete(SC7->C7_TPFRETE),3),nLinPC,1830 ) //"Obs. do Frete: "
			oReport:SkipLine()

			oReport:SkipLine()
			oReport:SkipLine()
			oReport:SkipLine()
			oReport:PrintText(STR0052+" "+Substr(cComprador,1,60),,050 ) 	//"Comprador Responsavel :" //"BLQ:Bloqueado"
			oReport:SkipLine()
			oReport:PrintText(STR0053+" "+If( Len(cAlter) > 0 , Substr(cAlter,001,130) , " " ),,050 ) //"Compradores Alternativos :"
			oReport:PrintText(            If( Len(cAlter) > 0 , Substr(cAlter,131,130) , " " ),,440 ) //"Compradores Alternativos :"
			
			nLinCar := 140
			nColCarac := 050
			nCCarac := 140
			
			nAprovLin := Round(Len(AllTrim(cAprov)) / nLinCar,0)
			
			For nX := 1 to nAprovLin 
				If nX == 1
					oReport:PrintText(STR0054+" "+If( Len(cAprov) > 0 , Substr(cAprov,001,nLinCar) , " " ),,nColCarac ) //"Aprovador(es) :"
					nColCarac+=250
				Else
					oReport:PrintText(            If( Len(cAprov) > 0 , Substr(cAprov,nCCarac+1,nLinCar) , " " ),,nColCarac )
					nCCarac+=nLinCar
				EndIf
			Next nx

			nX:=nAprovLin
			While nX <= 3			
				oReport:SkipLine()
				nX:=nX+1
			EndDo

			nLinPC := oReport:Row()
			oReport:PrintText( STR0082+" "+STR0060 ,nLinPC, 050 ) 	//"Legendas da Aprovacao : //"BLQ:Bloqueado"
			oReport:PrintText(       "|  "+STR0061 ,nLinPC, 610 ) 	//"Ok:Liberado"
			oReport:PrintText(       "|  "+STR0062 ,nLinPC, 830 ) 	//"??:Aguar.Lib"
			oReport:PrintText(       "|  "+STR0067 ,nLinPC,1070 )	//"##:Nivel Lib"
			oReport:SkipLine()

			oReport:SkipLine()
			If SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3
				oReport:PrintText(STR0081,,050 ) //"NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
			Else
				oReport:PrintText(STR0083,,050 ) //"NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega."
			EndIf
		EndIf
		
	Next nVias
	
	MaFisEnd()
	
	
	//��������������������������������������������������������������Ŀ
	//� Grava no SC7 as Reemissoes e atualiza o Flag de impressao.   �
	//����������������������������������������������������������������
	
		
	dbSelectArea("SC7")
	If Len(aRecnoSave) > 0
		For nX :=1 to Len(aRecnoSave)
			dbGoto(aRecnoSave[nX])
			If(SC7->C7_QTDREEM >= 99)	
				If nRet == 1
					RecLock("SC7",.F.)
					SC7->C7_EMITIDO := "S"
					MsUnLock()
				Elseif nRet == 2
					RecLock("SC7",.F.)
					SC7->C7_QTDREEM := 1
					SC7->C7_EMITIDO := "S"
					MsUnLock()
				Elseif nRet == 3
					//cancelar
				Endif
			Else
				RecLock("SC7",.F.)
				SC7->C7_QTDREEM := (SC7->C7_QTDREEM + 1)
				SC7->C7_EMITIDO := "S"
				MsUnLock()
			Endif
		Next nX
		//��������������������������������������������������������������Ŀ
		//� Reposiciona o SC7 com base no ultimo elemento do aRecnoSave. �
		//����������������������������������������������������������������
		dbGoto(aRecnoSave[Len(aRecnoSave)])
	Endif
	
	Aadd(aPedMail,aPedido)
	
	aRecnoSave := {}
	
	dbSelectArea("SC7")
	dbSkip()
	
EndDo

oSection2:Finish()

//��������������������������������������������������������������Ŀ
//� Executa o ponto de entrada M110MAIL quando a impressao for   �
//� enviada por email, fornecendo um Array para o usuario conten �
//� do os pedidos enviados para possivel manipulacao.            �
//����������������������������������������������������������������
If ExistBlock("M110MAIL")
	lEnvMail := (oReport:nDevice == 3)
	If lEnvMail
		Execblock("M110MAIL",.F.,.F.,{aPedMail})
	EndIf
EndIf

If lAuto .And. !lImpri
	Aviso(STR0104,STR0105,{"OK"})
Endif

dbSelectArea("SC7")
dbClearFilter()
dbSetOrder(1)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �CabecPCxAE� Autor �Alexandre Inacio Lemes �Data  �06/09/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao do Pedido de Compras / Autorizacao de Entrega      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CabecPCxAE(ExpO1,ExpO2,ExpN1,ExpN2)                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Objeto oReport                      	              ���
���          � ExpO2 = Objeto da sessao1 com o cabec                      ���
���          � ExpN1 = Numero de Vias                                     ���
���          � ExpN2 = Numero de Pagina                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CabecPCxAE(oReport,oSection1,nVias,nPagina)

Local cMoeda		:= IIf( mv_par12 < 10 , Str(mv_par12,1) , Str(mv_par12,2) )
Local nLinPC		:= 0
Local nTpImp	  	:= IIF(ValType(oReport:nDevice)!=Nil,oReport:nDevice,0) // Tipo de Impressao
Local nPageWidth	:= IIF(nTpImp==1.Or.nTpImp==6,3005,3005)//Alterado de 2435 Ricardo Moreira 
Local cCident		:= IIF(len(SM0->M0_CIDENT)>20,Substr(SM0->M0_CIDENT,1,15),SM0->M0_CIDENT)
Local cCGC			:= ""
Public nRet		:= 0

TRPosition():New(oSection1,"SA2",1,{ || xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA })
cBitmap := "DANFE" + cFilAnt + ".BMP" //R110Logo()

SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))

oSection1:Init()

oReport:Box( 010 , 010 ,  260 , 1000 ) //1000
oReport:Box( 010 , 1010,  260 , nPageWidth-2 )   //Ricardo - Colocado o 570   
//oReport:Box( 010 , 1010,  260 , nPageWidth+80 )   //Ricardo - Colocado o 570

oReport:PrintText( If(nPagina > 1,(STR0033)," "),,oSection1:Cell("M0_NOMECOM"):ColPos())

nLinPC := oReport:Row()
oReport:PrintText( If( mv_par08 == 1 , (STR0068), (STR0069) ) + " - " + GetMV("MV_MOEDA"+cMoeda) ,nLinPC,1030 )
oReport:PrintText( If( mv_par08 == 1 , SC7->C7_NUM, SC7->C7_NUMSC + "/" + SC7->C7_NUM ) + " /" + Ltrim(Str(nPagina,2)) ,nLinPC,1910 )
oReport:SkipLine()


nLinPC := oReport:Row()
If(SC7->C7_QTDREEM >= 99)	
	nRet := Aviso("TOTVS", STR0125 +chr(13)+chr(10)+ "1- " + STR0126 +chr(13)+chr(10)+ "2- " + STR0127 +chr(13)+chr(10)+ "3- " + STR0128,{"1", "2", "3"},2)
	If(nRet == 1)
		oReport:PrintText( Str(SC7->C7_QTDREEM,2) + STR0034 + Str(nVias,2) + STR0035 ,nLinPC,1910 )
	Elseif(nRet == 2)
		oReport:PrintText( "1" + STR0034 + Str(nVias,2) + STR0035 ,nLinPC,1910 )
	Elseif(nRet == 3)
		oReport:CancelPrint()
	Endif
Else		
	oReport:PrintText( If( SC7->C7_QTDREEM > 0, Str(SC7->C7_QTDREEM+1,2) , "1" ) + STR0034 + Str(nVias,2) + STR0035 ,nLinPC,1910 )
Endif                                             

oReport:SkipLine()

//_cFileLogo	:= GetSrvProfString('Startpath','') + cBitmap 
_cFileLogo	:= GetSrvProfString('Startpath','') + cBitmap

oReport:SayBitmap(25,25,_cFileLogo,150,60) // insere o logo no relatorio

nLinPC := oReport:Row()
oReport:PrintText(STR0087 + SM0->M0_NOMECOM,nLinPC,15)  // "Empresa:"
oReport:PrintText(STR0106 + Substr(SA2->A2_NOME,1,50) + " " + STR0107 + SA2->A2_COD + " " + STR0108 + SA2->A2_LOJA ,nLinPC,1025)
oReport:SkipLine()

nLinPC := oReport:Row()
oReport:PrintText(STR0088 + SM0->M0_ENDENT,nLinPC,15)
oReport:PrintText(STR0088 + Substr(SA2->A2_END,1,49) + " " + STR0109 + Substr(SA2->A2_BAIRRO,1,25),nLinPC,1025)
oReport:SkipLine()

If cPaisLoc == "BRA"
	cCGC	:= Transform(SA2->A2_CGC,Iif(SA2->A2_TIPO == 'F',Substr(PICPES(SA2->A2_TIPO),1,17),Substr(PICPES(SA2->A2_TIPO),1,21))) 
Else  
	cCGC	:= SA2->A2_CGC
EndIf   
        
nLinPC := oReport:Row()
oReport:PrintText(STR0089 + Trans(SM0->M0_CEPENT,PesqPict("SA2","A2_CEP"))+Space(2)+STR0090 + "  " + RTRIM(SM0->M0_CIDENT) + " " + STR0091 + SM0->M0_ESTENT ,nLinPC,15)
oReport:PrintText(STR0110+Left(SA2->A2_MUN, 30)+" "+STR0111+SA2->A2_EST+" "+STR0112+SA2->A2_CEP+" "+STR0113+":"+cCGC,nLinPC,1025)
oReport:SkipLine()

nLinPC := oReport:Row()
oReport:PrintText(STR0092 + SM0->M0_TEL + Space(2) + STR0093 + SM0->M0_FAX ,nLinPC,15)
oReport:PrintText(STR0094 + "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15) + " "+STR0114+"("+Substr(SA2->A2_DDD,1,3)+") "+SubStr(SA2->A2_FAX,1,15)+" "+If( cPaisLoc$"ARG|POR|EUA",space(11) , STR0095 )+If( cPaisLoc$"ARG|POR|EUA",space(18), SA2->A2_INSCR ),nLinPC,1025)
oReport:SkipLine()

nLinPC := oReport:Row()
oReport:PrintText(STR0113 + Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")) ,nLinPC,15)
If cPaisLoc == "BRA"
	oReport:PrintText(Space(2) + STR0041 + InscrEst() ,nLinPC,415)
Endif
oReport:SkipLine()
oReport:SkipLine()

oSection1:Finish()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR110R3� Autor � Wagner Xavier         � Data � 05.09.91 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao do Pedido de Compras                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
���              �        �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri�ao � PLANO DE MELHORIA CONTINUA        �Programa: MATR110R3.PRX ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data          |BOPS             ���
�������������������������������������������������������������������������Ĵ��
���      01  �                          �               �                 ���
���      02  � Marcos V. Ferreira       � 01/02/2006    �                 ���
���      03  �                          �               �                 ���
���      04  � Ricardo Berti            � 03/05/2006    �00000097026      ���
���      05  �                          �               �                 ���
���      06  � Marcos V. Ferreira       � 01/02/2006    �                 ���
���      07  � Ricardo Berti            � 03/05/2006    �00000097026      ���
���      08  � Flavio Luiz Vicco        � 07/04/2006    �00000094742      ���
���      09  �                          �               �                 ���
���      10  � Flavio Luiz Vicco        � 07/04/2006    �00000094742      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MATR110R3(cAlias,nReg,nOpcx)

LOCAL wnrel		:= "MATR110"
LOCAL cDesc1	:= STR0001	//"Emissao dos pedidos de compras ou autorizacoes de entrega"
LOCAL cDesc2	:= STR0002	//"cadastradados e que ainda nao foram impressos"
LOCAL cDesc3	:= " "
LOCAL cString	:= "SC7"
Local lComp		:= .T.	// Ativado habilita escolher modo RETRATO / PAISAGEM
Local cUserId   := RetCodUsr()
Local cCont     := Nil

PRIVATE lAuto		:= (nReg!=Nil)
PRIVATE Tamanho		:= "G"
PRIVATE titulo	 	:=STR0003										//"Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
PRIVATE aReturn 	:= {STR0004, 1,STR0005, 1, 2, 1, "",0 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog	:="MATR110"
PRIVATE nLastKey	:= 0
PRIVATE nBegin		:= 0
PRIVATE nDifColCC   := 0
PRIVATE aLinha		:= {}
PRIVATE aSenhas		:= {}
PRIVATE aUsuarios	:= {}
PRIVATE M_PAG		:= 1
If Type("lPedido") != "L"
	lPedido := .F.
Endif

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01               Do Pedido                             �
//� mv_par02               Ate o Pedido                          �
//� mv_par03               A partir da data de emissao           �
//� mv_par04               Ate a data de emissao                 �
//� mv_par05               Somente os Novos                      �
//� mv_par06               Campo Descricao do Produto    	     �
//� mv_par07               Unidade de Medida:Primaria ou Secund. �
//� mv_par08               Imprime ? Pedido Compra ou Aut. Entreg�
//� mv_par09               Numero de vias                        �
//� mv_par10               Pedidos ? Liberados Bloqueados Ambos  �
//� mv_par11               Impr. SC's Firmes, Previstas ou Ambas �
//� mv_par12               Qual a Moeda ?                        �
//� mv_par13               Endereco de Entrega                   �
//� mv_par14               todas ou em aberto ou atendidos       �
//����������������������������������������������������������������
Pergunte("MTR110",.F.)

//������������������������������������������������������������������������������������������������������������Ŀ
//� Verifica se no SX3 o C7_CC esta com tamanho 9 (Default) se igual a 9 muda o tamanho do relatorio           �
//� para Medio possibilitando a impressao em modo Paisagem ou retrato atraves da reducao na variavel nDifColCC �
//� se o tamanho do C7_CC no SX3 estiver > que 9 o relatorio sera impresso comprrimido com espaco para o campo �
//� C7_CC centro de custo para ate 20 posicoes,Obs.desabilitando a selecao do modo de impresso retrato/paisagem�
//��������������������������������������������������������������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("C7_CC")
	If SX3->X3_TAMANHO == 9
		nDifColCC := 11
		Tamanho   := "M"
	Else
		lComp	  := .F.   // C.Custo c/ tamanho maior que 9, sempre PAISAGEM
	Endif
Endif

wnrel:=SetPrint(cString,wnrel,If(lAuto,Nil,"MTR110"),@Titulo,cDesc1,cDesc2,cDesc3,.F.,,lComp,Tamanho,,!lAuto)

If nLastKey <> 27

	SetDefault(aReturn,cString)

	If lAuto
		mv_par08 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","08"),If(cCont == Nil,SC7->C7_TIPO,cCont) })
	EndIf

	If lPedido
		mv_par12 := MAX(SC7->C7_MOEDA,1)
	EndIf

	If mv_par08 == 1 .OR. mv_par08 == 3
		RptStatus({|lEnd| C110PC(@lEnd,wnRel,cString,nReg)},titulo)
	Else
		RptStatus({|lEnd| C110AE(@lEnd,wnRel,cString,nReg)},titulo)
	EndIf

	lPedido := .F.
	
Else 
	dbClearFilter()
EndIf

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C110PC   � Autor � Cristina M. Ogura     � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR110			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C110PC(lEnd,WnRel,cString,nReg)
Local nReem
Local nOrder
Local cCondBus
Local nSavRec
Local aPedido := {}
Local aPedMail:= {}
Local aSavRec := {}
Local nLinObs := 0
Local i       := 0
Local ncw     := 0
Local cFiltro := ""
Local cUserId := RetCodUsr()
Local cCont   := Nil
Local lImpri  := .F.

Private cCGCPict, cCepPict
//��������������������������������������������������������������Ŀ
//�Definir as pictures                                           �
//����������������������������������������������������������������
cCepPict:=PesqPict("SA2","A2_CEP")
cCGCPict:=PesqPict("SA2","A2_CGC")

If nDifColCC < 11
	limite   := 139
Else
	limite   := 129
Endif

li       := 80
nDescProd:= 0
nTotal   := 0
nTotMerc := 0
NumPed   := Space(6)

If lAuto
	dbSelectArea("SC7")
	dbGoto(nReg)
	SetRegua(1)
	mv_par01 := C7_NUM
	mv_par02 := C7_NUM
	mv_par03 := C7_EMISSAO
	mv_par04 := C7_EMISSAO
	mv_par05 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","05"),If(cCont == Nil,2,cCont) })
   	mv_par08 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","08"),If(cCont == Nil,C7_TIPO,cCont) })
	mv_par09 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","09"),If(cCont == Nil,1,cCont) })
  	mv_par10 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","10"),If(cCont == Nil,3,cCont) }) 
	mv_par11 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","11"),If(cCont == Nil,3,cCont) }) 
  	mv_par14 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","14"),If(cCont == Nil,1,cCont) }) 
EndIf

If ( cPaisLoc$"ARG|POR|EUA" )
	cCondBus	:=	"1"+strzero(val(mv_par01),6)
	nOrder	:=	10
	nTipo		:= 1
Else
	cCondBus	:=mv_par01
	nOrder	:=	1
EndIf
   
If mv_par14 == 2
	cFiltro := "SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)"
Elseif mv_par14 == 3
	cFiltro := "SC7->C7_QUANT > SC7->C7_QUJE"
EndIf

dbSelectArea("SC7")
dbSetOrder(nOrder)
SetRegua(RecCount())
dbSeek(xFilial("SC7")+cCondBus,.T.)

//�������������������������������������������������������������������Ŀ
//� Faz manualmente porque nao chama a funcao Cabec()                 �
//���������������������������������������������������������������������
@ 0,0 PSay AvalImp(Iif(nDifColCC < 11,220,132))

While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. ;
		C7_NUM <= mv_par02

	//��������������������������������������������������������������Ŀ
	//� Cria as variaveis para armazenar os valores do pedido        �
	//����������������������������������������������������������������
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "

	If	C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif
	If	(C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(C7_CONAPRO != "B" .And. mv_par10 == 2)
		dbSkip()
		Loop
	Endif
	If	(C7_EMISSAO < mv_par03) .Or. (C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif
	If	C7_TIPO == 2
		dbSkip()
		Loop
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Consiste este item. EM ABERTO                                �
	//����������������������������������������������������������������
	If mv_par14 == 2
		If SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
	Endif

	//��������������������������������������������������������������Ŀ
	//� Consiste este item. ATENDIDOS                                �
	//����������������������������������������������������������������
	If mv_par14 == 3
		If SC7->C7_QUANT > SC7->C7_QUJE
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
	Endif

	//��������������������������������������������������������������Ŀ
	//� Filtra Tipo de SCs Firmes ou Previstas                       �
	//����������������������������������������������������������������
	If !MtrAValOP(mv_par11, 'SC7')
		dbSkip()
		Loop
	EndIf

	MaFisEnd()
	R110FIniPC(SC7->C7_NUM,,,cFiltro)

	For ncw := 1 To mv_par09		// Imprime o numero de vias informadas

		ImpCabec(ncw)

		nTotal   := 0
		nTotMerc	:= 0
		nDescProd:= 0
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM
		nLinObs  := 0
		aPedido  := {SC7->C7_FILIAL,SC7->C7_NUM,SC7->C7_EMISSAO,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_TIPO}

		While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM == NumPed

			//��������������������������������������������������������������Ŀ
			//� Consiste este item. EM ABERTO                                �
			//����������������������������������������������������������������
			If mv_par14 == 2
				If SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)
					dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif
			Endif

			//��������������������������������������������������������������Ŀ
			//� Consiste este item. ATENDIDOS                                �
			//����������������������������������������������������������������
			If mv_par14 == 3
				If SC7->C7_QUANT > SC7->C7_QUJE
					dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif
			Endif

			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif
			If lEnd
				@PROW()+1,001 PSAY STR0006	//"CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif

			IncRegua()

			//��������������������������������������������������������������Ŀ
			//� Verifica se havera salto de formulario                       �
			//����������������������������������������������������������������
			If li > 56
				nOrdem++
				ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec(ncw)
			Endif

			li++

			@ li,001 PSAY "|"
			@ li,002 PSAY C7_ITEM  		Picture PesqPict("SC7","C7_ITEM")
			@ li,006 PSAY "|"
			//��������������������������������������������������������������Ŀ
			//� Pesquisa Descricao do Produto                                �
			//����������������������������������������������������������������
			ImpProd()

			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif
			//��������������������������������������������������������������Ŀ
			//� Inicializacao da Observacao do Pedido.                       �
			//����������������������������������������������������������������
			If !EMPTY(SC7->C7_OBS) .And. nLinObs < 5
				nLinObs++
				cVar:="cObs"+StrZero(nLinObs,2)
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
			lImpri  := .T.
			dbSkip()
		EndDo

		dbGoto(nSavRec)

		If li>38
			nOrdem++
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec(ncw)
		Endif

		FinalPed(nDescProd)		// Imprime os dados complementares do PC

	Next

	MaFisEnd()

	If Len(aSavRec)>0
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace C7_QTDREEM With (C7_QTDREEM+1)
			Replace C7_EMITIDO With "S"
			MsUnLock()
		Next
		dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
	Endif

	Aadd(aPedMail,aPedido)

	aSavRec := {}

	dbSkip()
EndDo

//��������������������������������������������������������������Ŀ
//� Executa o ponto de entrada M110MAIL quando a impressao for   �
//� enviada por email, fornecendo um Array para o usuario conten �
//� do os pedidos enviados para possivel manipulacao.            �
//����������������������������������������������������������������
If ExistBlock("M110MAIL")
	lEnvMail := HasEmail(,,,,.F.)
	If lEnvMail
		Execblock("M110MAIL",.F.,.F.,{aPedMail})
	EndIf
EndIf

//If lAuto .And. !lImpri
  //	Aviso(STR0104,STR0105,{"OK"})
//Endif

dbSelectArea("SC7")
dbClearFilter()
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C110AE   � Autor � Cristina M. Ogura     � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR110			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C110AE(lEnd,WnRel,cString,nReg)
Local nReem
Local nSavRec,aSavRec := {}
Local aPedido := {}
Local aPedMail:= {}
Local nLinObs := 0
Local ncw     := 0
Local i       := 0
Local cFiltro := ""
Local cUserId := RetCodUsr()
Local lImpri  := .F.

Private cCGCPict, cCepPict
//��������������������������������������������������������������Ŀ
//�Definir as pictures                                           �
//����������������������������������������������������������������
cCepPict:=PesqPict("SA2","A2_CEP")
cCGCPict:=PesqPict("SA2","A2_CGC")

If nDifColCC < 11
	limite   := 139
Else
	limite   := 129
Endif

li       := 80
nDescProd:= 0
nTotal   := 0
nTotMerc := 0
NumPed   := Space(6)

If !lAuto
	dbSelectArea("SC7")
	dbSetOrder(10)
	dbSeek(xFilial("SC7")+"2"+mv_par01,.T.)
Else
	dbSelectArea("SC7")
	dbGoto(nReg)
	mv_par01 := C7_NUM
	mv_par02 := C7_NUM
	mv_par03 := C7_EMISSAO
	mv_par04 := C7_EMISSAO
	mv_par05 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","05"),If(cCont == Nil,2,cCont) })
	mv_par08 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","08"),If(cCont == Nil,C7_TIPO,cCont) })
	mv_par09 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","09"),If(cCont == Nil,1,cCont) })
	mv_par10 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","10"),If(cCont == Nil,3,cCont) }) 
	mv_par11 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","11"),If(cCont == Nil,3,cCont) }) 
  	mv_par14 := Eval({|| cCont:=ChkPergUs(cUserId,"MTR110","14"),If(cCont == Nil,1,cCont) }) 

	dbSelectArea("SC7")
	dbSetOrder(10)
	dbSeek(xFilial("SC7")+"2"+mv_par01,.T.)
EndIf

If mv_par14 == 2
	cFiltro := "SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)"
Elseif mv_par14 == 3
	cFiltro := "SC7->C7_QUANT > SC7->C7_QUJE"
EndIf

SetRegua(Reccount())
//�������������������������������������������������������������������Ŀ
//� Faz manualmente porque nao chama a funcao Cabec()                 �
//���������������������������������������������������������������������
@ 0,0 PSay AvalImp(Iif(nDifColCC < 11,220,132))
While !Eof().And.C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. C7_NUM <= mv_par02
	//��������������������������������������������������������������Ŀ
	//� Cria as variaveis para armazenar os valores do pedido        �
	//����������������������������������������������������������������
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "

	If	C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	If	(C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(C7_CONAPRO != "B" .And. mv_par10 == 2)
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	If	(SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	If	SC7->C7_TIPO != 2
		dbSelectArea("SC7")
		dbSkip()
		Loop
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Consiste este item. EM ABERTO                                �
	//����������������������������������������������������������������
	If mv_par14 == 2
		If SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
	Endif

	//��������������������������������������������������������������Ŀ
	//� Consiste este item. ATENDIDOS                                �
	//����������������������������������������������������������������
	If mv_par14 == 3
		If SC7->C7_QUANT > SC7->C7_QUJE
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
	Endif

	//��������������������������������������������������������������Ŀ
	//� Filtra Tipo de SCs Firmes ou Previstas                       �
	//����������������������������������������������������������������
	If !MtrAValOP(mv_par11, 'SC7')
		dbSelectArea("SC7")
		dbSkip()
		Loop
	EndIf

	MaFisEnd()
	R110FIniPC(SC7->C7_NUM,,,cFiltro)

	For ncw := 1 To mv_par09		// Imprime o numero de vias informadas

		ImpCabec(ncw)

		nTotal   := 0
		nTotMerc := 0

		nDescProd:= 0
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM
		nLinObs := 0
		aPedido  := {SC7->C7_FILIAL,SC7->C7_NUM,SC7->C7_EMISSAO,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_TIPO}

		While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM == NumPed

			//��������������������������������������������������������������Ŀ
			//� Consiste este item. EM ABERTO                                �
			//����������������������������������������������������������������
			If mv_par14 == 2
				If SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)
					dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif
			Endif

			//��������������������������������������������������������������Ŀ
			//� Consiste este item. ATENDIDOS                                �
			//����������������������������������������������������������������
			If mv_par14 == 3
				If SC7->C7_QUANT > SC7->C7_QUJE
					dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif
			Endif

			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif

			If lEnd
				@PROW()+1,001 PSAY STR0006		//"CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif

			IncRegua()

			//��������������������������������������������������������������Ŀ
			//� Verifica se havera salto de formulario                       �
			//����������������������������������������������������������������
			If li > 56
				nOrdem++
				ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec(ncw)
			Endif
			li++
			@ li,001 PSAY "|"
			@ li,002 PSAY SC7->C7_ITEM  	Picture PesqPict("SC7","C7_ITEM")
			@ li,006 PSAY "|"
			//��������������������������������������������������������������Ŀ
			//� Pesquisa Descricao do Produto                                �
			//����������������������������������������������������������������
			ImpProd()		// Imprime dados do Produto

			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif
			//��������������������������������������������������������������Ŀ
			//� Inicializacao da Observacao do Pedido.                       �
			//����������������������������������������������������������������
			If !EMPTY(SC7->C7_OBS) .And. nLinObs < 5
				nLinObs++
				cVar:="cObs"+StrZero(nLinObs,2)
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
			lImpri  := .T.
			dbSelectArea("SC7")
			dbSkip()
		EndDo

		dbGoto(nSavRec)
		If li>38
			nOrdem++
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec(ncw)
		Endif

		FinalAE(nDescProd)		// dados complementares da Autorizacao de Entrega
	Next

	MaFisEnd()

	If Len(aSavRec)>0
		dbGoto(aSavRec[Len(aSavRec)])
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace C7_EMITIDO With "S"
			Replace C7_QTDREEM With (C7_QTDREEM+1)
			MsUnLock()
		Next
	Endif

	Aadd(aPedMail,aPedido)

	aSavRec := {}

	dbSelectArea("SC7")
	dbSkip()
End

//��������������������������������������������������������������Ŀ
//� Executa o ponto de entrada M110MAIL quando a impressao for   �
//� enviada por email, fornecendo um Array para o usuario conten �
//� do os pedidos enviados para possivel manipulacao.            �
//����������������������������������������������������������������
If ExistBlock("M110MAIL")
	lEnvMail := HasEmail(,,,,.F.)
	If lEnvMail
		Execblock("M110MAIL",.F.,.F.,{aPedMail})
	EndIf
EndIf

//If lAuto .And. !lImpri
 //	Aviso(STR0104,STR0105,{"OK"})
//Endif

dbSelectArea("SC7")
dbClearFilter()
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpProd  � Autor � Wagner Xavier         � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pesquisar e imprimir  dados Cadastrais do Produto.         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpProd(Void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpProd()
LOCAL nBegin   := 0, cDescri := "", nLinha:=0
Local nTamDesc := 26
Local aColuna  := Array(8)
Local nTamProd := 15

If Empty(mv_par06)
	mv_par06 := "B1_DESC"
EndIf

//��������������������������������������������������������������Ŀ
//� Impressao da descricao generica do Produto.                  �
//����������������������������������������������������������������
If AllTrim(mv_par06) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1")+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf
//��������������������������������������������������������������Ŀ
//� Impressao da descricao cientifica do Produto.                �
//����������������������������������������������������������������
If AllTrim(mv_par06) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial("SB5")+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf
	dbSelectArea("SC7")
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par06) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
EndIf

If Empty(cDescri)
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek( xFilial("SB1")+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf

dbSelectArea("SA5")
dbSetOrder(1)
If dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO).And. !Empty(SA5->A5_CODPRF)
	cDescri := cDescri + " ("+Alltrim(A5_CODPRF)+")"
EndIf
dbSelectArea("SC7")
aColuna[1] :=  49
aColuna[2] :=  52
aColuna[3] :=  65
aColuna[4] :=  80
aColuna[5] :=  86
aColuna[6] := 103
aColuna[7] := 114
acoluna[8] := 142 - nDifColCC

If Len(cDescri) > Len(SC7->C7_PRODUTO)
	nLinha:= MLCount(cDescri,nTamDesc)    
Else
	nLinha:= MLCount(SC7->C7_PRODUTO,nTamProd) 
EndIf

@ li,007 PSAY MemoLine(SC7->C7_PRODUTO,nTamProd,1)
@ li,022 PSAY "|"
@ li,023 PSAY MemoLine(cDescri,nTamDesc,1)

ImpCampos()
For nBegin := 2 To nLinha
	li++
	@ li,001 PSAY "|"
	@ li,006 PSAY "|"    
	@ li,007 PSAY MemoLine(SC7->C7_PRODUTO,nTamProd,nBegin)
	@ li,022 PSAY "|"
	@ li,023 PSAY Memoline(cDescri,nTamDesc,nBegin)
	@ li,aColuna[1] PSAY "|"
	@ li,acoluna[2] PSAY "|"
	@ li,acoluna[3] PSAY "|"
	@ li,aColuna[4] PSAY "|"

	If mv_par08 == 1 .OR. mv_par08 == 3
		If cPaisLoc == "BRA"
			@ li,aColuna[5] PSAY "|"
		Else
			@ li,aColuna[5] PSAY " "
		EndIf
		@ li,aColuna[6] PSAY "|"
		@ li,114 PSAY "|"
		@ li,135 - nDIfColCC PSAY "|"
		@ li,aColuna[8] PSAY "|"
	Else
		@ li,097 PSAY "|"
		@ li,108 PSAY "|" 
		//	@ li,142 - nDifColCC PSAY "|"
		@ li,142 - nDifColCC PSAY "|"
	EndIf
Next nBegin

Return NIL
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpCampos� Autor � Wagner Xavier         � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir dados Complementares do Produto no Pedido.        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpCampos(Void)                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpCampos()

LOCAL aColuna[6]
Local nTxMoeda := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
dbSelectArea("SC7")

aColuna[1] :=  49
aColuna[2] :=  52
aColuna[3] :=  65
aColuna[4] :=  80
aColuna[5] :=  86
aColuna[6] := 103

@ li,aColuna[1] PSAY "|"
If MV_PAR07 == 2 .And. !Empty(SC7->C7_SEGUM)
	@ li,PCOL() PSAY SC7->C7_SEGUM Picture PesqPict("SC7","C7_UM")
Else
	@ li,PCOL() PSAY SC7->C7_UM    Picture PesqPict("SC7","C7_UM")
EndIf
@ li,aColuna[2] PSAY "|"
If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM)
	@ li,PCOL() PSAY SC7->C7_QTSEGUM Picture PesqPictQt("C7_QUANT",13)
Else
	@ li,PCOL() PSAY SC7->C7_QUANT   Picture PesqPictQt("C7_QUANT",13)
EndIf
@ li,aColuna[3] PSAY "|"
If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM)
	@ li,PCOL()	PSAY xMoeda((SC7->C7_TOTAL/SC7->C7_QTSEGUM),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture PesqPict("SC7","C7_PRECO",14)
Else
	@ li,PCOL() PSAY xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture PesqPict("SC7","C7_PRECO",14)
EndIf
@ li,aColuna[4] PSAY "|"

If mv_par08 == 1 .OR. mv_par08 == 3
	If cPaisLoc == "BRA"
		@ li,    PCOL() PSAY SC7->C7_IPI Picture PesqPictQt("C7_IPI",5)
		@ li,    aColuna[5] PSAY "|"
	Else
		@ li,    PCOL() 	PSAY "  "
		@ li,aColuna[5]-2 	PSAY " "
		@ li,    PCOL() 	PSAY " "
	EndIf
	@ li,    PCOL() PSAY xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture PesqPict("SC7","C7_TOTAL",16,MV_PAR12)
	@ li,aColuna[6] PSAY "|"
	@ li,    PCOL() PSAY SC7->C7_DATPRF Picture PesqPict("SC7","C7_DATPRF")
	@ li,114 PSAY "|"
	@ li,PCOL() PSAY SC7->C7_CC         Picture PesqPict("SC7","C7_CC",20)
	@ li,135 - nDifColCC PSAY "|"
	@ li,  PCOL() PSAY SC7->C7_NUMSC
	@ li,142 - nDifColCC PSAY "|"
Else
	@ li,  PCOL() PSAY xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture PesqPict("SC7","C7_TOTAL",16,MV_PAR12)
	@ li,     097 PSAY "|"
	@ li,  PCOL() PSAY SC7->C7_DATPRF   Picture PesqPict("SC7","C7_DATPRF")
	@ li,     108 PSAY "|"
	// Tenta imprimir OP
	If !Empty(SC7->C7_OP)
		@ li,  PCOL() PSAY STR0065
		@ li,  PCOL() PSAY SC7->C7_OP
	// Caso Op esteja vazia imprime Centro de Custos
	ElseIf !Empty(SC7->C7_CC)
		@ li,  PCOL() PSAY STR0066
		@ li,PCOL() PSAY SC7->C7_CC     Picture PesqPict("SC7","C7_CC",20)
	EndIf
	@ li,142 - nDifColCC PSAY "|"
EndIf

nTotal  :=nTotal+SC7->C7_TOTAL
nTotMerc:=MaFisRet(,"NF_TOTAL")
Return .T.
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FinalPed � Autor � Wagner Xavier         � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime os dados complementares do Pedido de Compra        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FinalPed(Void)                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FinalPed(nDescProd)

Local nk		:= 1,nG
Local nX		:= 0
Local nQuebra	:= 0
Local nTotDesc	:= nDescProd
Local lNewAlc	:= .F.
Local lLiber 	:= .F.
Local lImpLeg	:= .T.
Local lImpLeg2	:= .F.
Local cComprador:=""
LOcal cAlter	:=""
Local cAprov	:=""
Local nTotIpi	:= MaFisRet(,'NF_VALIPI')
Local nTotIcms	:= MaFisRet(,'NF_VALICM')
Local nTotDesp	:= MaFisRet(,'NF_DESPESA')
Local nTotFrete	:= MaFisRet(,'NF_FRETE')
Local nTotalNF	:= MaFisRet(,'NF_TOTAL')
Local nTotSeguro:= MaFisRet(,'NF_SEGURO')
Local aValIVA   := MaFisRet(,"NF_VALIMP")
Local nValIVA   :=0
Local aColuna   := Array(8), nTotLinhas
Local nTxMoeda  := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)

If cPaisLoc <> "BRA" .And. !Empty(aValIVA)
	For nG:=1 to Len(aValIVA)
		nValIVA+=aValIVA[nG]
	Next
Endif

cMensagem:= Formula(C7_MSG)

If !Empty(cMensagem)
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,142 - nDifColCC PSAY "|"
Endif
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++

aColuna[1] :=  49
aColuna[2] :=  52
aColuna[3] :=  65
aColuna[4] :=  80
aColuna[5] :=  86
aColuna[6] := 103
acoluna[7] := 114
aColuna[8] := 142 - nDifColCC
nTotLinhas :=  39

While li<nTotLinhas
	@ li,001 PSAY "|"
	@ li,006 PSAY "|"
	@ li,022 PSAY "|"
	@ li,022 + nk PSAY "*"
	nk := IIf( nk == 42 , 1 , nk + 1 )
	@ li,aColuna[1] PSAY "|"
	@ li,aColuna[2] PSAY "|"
	@ li,aColuna[3] PSAY "|"
	@ li,aColuna[4] PSAY "|"
	If cPaisLoc == "BRA"
		@ li,aColuna[5] PSAY "|"
	EndIf
	@ li,aColuna[6] PSAY "|"
	@ li,114 PSAY "|"
	@ li,135 - nDifColCC PSAY "|"
	@ li,aColuna[8] PSAY "|"
	li++
EndDo
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,015 PSAY STR0007		//"D E S C O N T O S -->"
@ li,037 PSAY C7_DESC1 Picture "999.99"
@ li,046 PSAY C7_DESC2 Picture "999.99"
@ li,055 PSAY C7_DESC3 Picture "999.99"

@ li,068 PSAY xMoeda(nTotDesc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture PesqPict("SC7","C7_VLDESC",14, MV_PAR12)

@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
//��������������������������������������������������������������Ŀ
//� Posiciona o Arquivo de Empresa SM0.                          �
//����������������������������������������������������������������
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)

//��������������������������������������������������������������Ŀ
//� Imprime endereco de entrega do SM0 somente se o MV_PAR13 =" "�
//����������������������������������������������������������������
If Empty(MV_PAR13)
	//"Local de Entrega  : " -- //"CEP :"
	@ li,003 PSAY STR0008 + AllTrim(SM0->M0_ENDENT) + " - " + AllTrim(SM0->M0_CIDENT) + " - " + Alltrim(SM0->M0_ESTENT) + " - " + STR0009 + Trans(Alltrim(SM0->M0_CEPENT),cCepPict)
Else
	@ li,003 PSAY STR0008 + MV_PAR13		//"Local de Entrega  : " imprime o endereco digitado na pergunte
Endif

@ li,142 - nDifColCC PSAY "|"
dbGoto(nRegistro)
dbSelectArea( cAlias )

li++
@ li,001 PSAY "|"
//"Local de Cobranca : "
@ li,003 PSAY STR0010 + Alltrim(SM0->M0_ENDCOB) + " - " + Alltrim(SM0->M0_CIDCOB) + " - " + Alltrim(SM0->M0_ESTCOB) + " - " +	STR0009 + Trans(Alltrim(SM0->M0_CEPCOB),cCepPict)
@ li,142 - nDifColCC PSAY " |"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY " |"

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+SC7->C7_COND)
dbSelectArea("SC7")
li++
@ li,001 PSAY "|"
@ li,003 PSAY STR0011+SubStr(SE4->E4_COND,1,40)		//"Condicao de Pagto "
@ li,061 PSAY STR0012		//"|Data de Emissao|"
@ li,079 PSAY STR0013		//"Total das Mercadorias : " 
@ li,108 PSAY xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nTotal,14,MsDecimais(MV_PAR12))
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
@ li,061 PSAY "|"
@ li,066 PSAY SC7->C7_EMISSAO
@ li,077 PSAY "|"
If cPaisLoc<>"BRA"
	@ li,079 PSAY OemtoAnsi(STR0063)	//"Total de los Impuestos : "
	@ li,108 PSAY xMoeda(nValIVA,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nValIVA,14,MsDecimais(MV_PAR12))
Else
	@ li,079 PSAY STR0064		//"Total com Impostos : "
	@ li,108 PSAY xMoeda(nTotMerc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nTotMerc,14,MsDecimais(MV_PAR12))
Endif
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",53)
@ li,055 PSAY Replicate("-",86 - nDifColCC)
@ li,142 - nDifColCC PSAY "|"
li++
dbSelectArea("SM4")
dbSetOrder(1)
dbSeek(xFilial("SM4")+SC7->C7_REAJUST)
dbSelectArea("SC7")

@ li,001 PSAY "|"
@ li,003 PSAY STR0014		//"Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","C7_REAJUST",,MV_PAR12)
@ li,018 PSAY SM4->M4_DESCR

If cPaisLoc == "BRA"
	@ li,054 PSAY STR0015		//"| IPI   :"
	@ li,064 PSAY xMoeda(nTotIPI,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nTotIpi,14,MsDecimais(MV_PAR12))
	@ li,088 PSAY "| ICMS   : "
	@ li,100 PSAY xMoeda(nTotIcms,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nTotIcms,14,MsDecimais(MV_PAR12))
	@ li,142 - nDifColCC PSAY "|"
Else	
	@ li,054 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
EndIf

li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY (STR0049) //"| Frete :"
@ li,064 PSAY xMoeda(nTotFrete,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nTotFrete,14,MsDecimais(MV_PAR12))
@ li,088 PSAY (STR0058) //"| Despesas :"
@ li,100 PSAY xMoeda(nTotDesp,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nTotDesp,14,MsDecimais(MV_PAR12))

@ li,142 - nDifColCC PSAY "|"
//��������������������������������������������������������������Ŀ
//� Inicializar campos de Observacoes.                           �
//����������������������������������������������������������������
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs := cObs01
		cObs01 := Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

dbSelectArea("SC7")            
/*
If !Empty(SC7->C7_APROV) .Or. (Empty(SC7->C7_APROV) .And. SCR->CR_TIPO == "IP")
	lNewAlc := .T.
	cComprador := UsrFullName(SC7->C7_USER)
	If C7_CONAPRO != "B"
		lLiber := .T.
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO $ "PC|AE|IP"
		cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["
        Do Case
        	Case SCR->CR_STATUS=="02" //Pendente
        		cAprov += "BLQ"
        	Case SCR->CR_STATUS=="03" //Liberado
        		cAprov += "Ok"
        	Case SCR->CR_STATUS=="04" //Bloqueado
        		cAprov += "BLQ"
			Case SCR->CR_STATUS=="05" //Nivel Liberado
				cAprov += "##"
			OtherWise                 //Aguar.Lib
				cAprov += "??"
		EndCase
		cAprov += "] - "
		dbSelectArea("SCR")
		dbSkip()
	Enddo
	If !Empty(SC7->C7_GRUPCOM)
		dbSelectArea("SAJ")
		dbSetOrder(1)
		dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
		While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
			If SAJ->AJ_USER != SC7->C7_USER
				If SAJ->(FieldPos("AJ_MSBLQL") > 0)
					If SAJ->AJ_MSBLQL == "1"
						dbSkip()
						LOOP
					EndIf 
				EndIf
				cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
			EndIf
			dbSelectArea("SAJ")
			dbSkip()
		EndDo
	EndIf
EndIf
*/
li++
@ li,001 PSAY STR0016		//"| Observacoes"
@ li,054 PSAY STR0017		//"| Grupo :"
@ li,088 PSAY STR0059      //"| SEGURO :"
@ li,100 PSAY xMoeda(nTotSeguro,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nTotSeguro,14,MsDecimais(MV_PAR12))
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs01
@ li,054 PSAY "|"+Replicate("-",86 - nDifColCC)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs02
@ li,054 PSAY STR0018		//"| Total Geral : "

If !lNewAlc
	@ li,094 PSAY xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nTotalNF,14,MsDecimais(MV_PAR12))
Else
	If lLiber
		@ li,094 PSAY xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nTotalNF,14,MsDecimais(MV_PAR12))
	Else
		@ li,080 PSAY (STR0051)
	EndIf
EndIf

@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs03
@ li,054 PSAY "|"+Replicate("-",86 - nDifColCC)
@ li,142 - nDifColCC PSAY "|"
li++

If !lNewAlc
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs04
	@ li,054 PSAY "|"
	@ li,061 PSAY STR0019		//"|           Liberacao do Pedido"
	@ li,102 PSAY STR0020		//"| Obs. do Frete: "
	@ li,119 PSAY Substr(RetTipoFrete(SC7->C7_TPFRETE),3,10)
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"+Replicate("-",59)
	@ li,061 PSAY "|"
	@ li,102 PSAY "|"
	If !Empty(Substr(RetTipoFrete(SC7->C7_TPFRETE),13))
		@ li,104 PSAY Substr(RetTipoFrete(SC7->C7_TPFRETE),13)
	EndIf
	@ li,142 - nDifColCC PSAY "|"

	li++
	cLiberador := ""
	nPosicao := 0
	@ li,001 PSAY "|"
	@ li,007 PSAY STR0021		//"Comprador"
	@ li,021 PSAY "|"
	@ li,028 PSAY STR0022		//"Gerencia"
	@ li,041 PSAY "|"
	@ li,046 PSAY STR0023		//"Diretoria"
	@ li,061 PSAY "|     ------------------------------"
	@ li,102 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,021 PSAY "|"
	@ li,041 PSAY "|"
	@ li,061 PSAY "|     " + R110Center(cLiberador) // 30 posicoes
	@ li,102 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY STR0024		//"|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,142 - nDifColCC PSAY "|"
Else
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs04
	@ li,054 PSAY "|"
	@ li,059 PSAY IF(lLiber,STR0050,STR0051)		//"     P E D I D O   L I B E R A D O"#"|     P E D I D O   B L O Q U E A D O !!!"
	@ li,102 PSAY STR0020		//"| Obs. do Frete: "
	@ li,119 PSAY Substr(RetTipoFrete(SC7->C7_TPFRETE),3,10)
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"+Replicate("-",99)
	@ li,102 PSAY "|"
	If !Empty(Substr(RetTipoFrete(SC7->C7_TPFRETE),13))
		@ li,104 PSAY Substr(RetTipoFrete(SC7->C7_TPFRETE),13)
	EndIf
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0052		//"Comprador Responsavel :"
	@ li,027 PSAY Substr(cComprador,1,60)
	@ li,088 PSAY "|"
	@ li,089 PSAY STR0060      //"BLQ:Bloqueado"
	@ li,102 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
	li++
	nAuxLin := Len(cAlter)
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0053		//"Compradores Alternativos :"
	While nAuxLin > 0 .Or. lImpLeg
		@ li,029 PSAY Substr(cAlter,Len(cAlter)-nAuxLin+1,60)
		@ li,088 PSAY "|"
		If lImpLeg
			@ li,089 PSAY STR0061   //"Ok:Liberado"
			lImpLeg := .F.
		EndIf
		@ li,102 PSAY "|"
		@ li,142 - nDifColCC PSAY "|"
		nAuxLin -= 60
		li++
	EndDo
	nAuxLin := Len(cAprov)
	lImpLeg := .T.
	While nAuxLin > 0	.Or. lImpLeg
		@ li,001 PSAY "|"
		If lImpLeg  // Imprimir soh a 1a vez
			@ li,003 PSAY STR0054		//"Aprovador(es) :"
		EndIf
		@ li,018 PSAY Substr(cAprov,Len(cAprov)-nAuxLin+1,70)
		@ li,088 PSAY "|"
		If lImpLeg2  // Imprimir soh a 2a vez
			@ li,089 PSAY STR0067 //"##:Nivel.Lib"
			lImpLeg2 := .F.
		EndIf
		If lImpLeg   // Imprimir soh a 1a vez
			@ li,089 PSAY STR0062  //"??:Aguar.Lib"
			lImpLeg  := .F.
			lImpLeg2 := .T.
		EndIf
		@ li,102 PSAY "|"
		@ li,142 - nDifColCC PSAY "|"
		nAuxLin -=70
		li++
	EndDo
	If lImpLeg2
		lImpLeg2 := .F.
		@ li,001 PSAY "|"
		@ li,088 PSAY "|"
		@ li,089 PSAY STR0067 //"##:Nivel Lib"
		@ li,102 PSAY "|"
		@ li,142 - nDifColCC PSAY "|"
		li++
	EndIf
	If nAuxLin == 0
		li++
	EndIf
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY STR0024		//"|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,142 - nDifColCC PSAY "|"
EndIf

Return .T.
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FinalAE  � Autor � Cristina Ogura        � Data � 05.04.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime os dados complementares da Autorizacao de Entrega  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FinalAE(Void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FinalAE(nDescProd)
Local nk := 1
Local nX := 0
Local nTotDesc:= nDescProd
Local nTotNF	:= MaFisRet(,'NF_TOTAL')
Local nTxMoeda := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
Local cComprador:= UsrFullName(SC7->C7_USER)//""
LOcal cAlter	:=""
Local cAprov	:=""
Local lImpLeg	:= .T.
Local lImpLeg2	:= .F.

cMensagem:= Formula(C7_MSG)                                   

If !Empty(cMensagem)
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,142 - nDifColCC PSAY "|"
Endif
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
While li<39
	@ li,001 PSAY "|"
	@ li,006 PSAY "|"
	@ li,022 PSAY "|"
	@ li,022 + nk PSAY "*"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,049 PSAY "|"
	@ li,052 PSAY "|"
	@ li,065 PSAY "|"
	@ li,080 PSAY "|"
	@ li,097 PSAY "|"
	@ li,108 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
	li++
EndDo
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"

//��������������������������������������������������������������Ŀ
//� Posiciona o Arquivo de Empresa SM0.                          �
//����������������������������������������������������������������
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
//��������������������������������������������������������������Ŀ
//� Imprime endereco de entrega do SM0 somente se o MV_PAR13 =" "�
//����������������������������������������������������������������
If Empty(MV_PAR13)
	//"Local de Entrega  : " -- //"CEP :"
	@ li,003 PSAY STR0008 + AllTrim(SM0->M0_ENDENT) + " - " + AllTrim(SM0->M0_CIDENT) + " - " + Alltrim(SM0->M0_ESTENT) + " - " + STR0009 + Trans(Alltrim(SM0->M0_CEPENT),cCepPict)
Else
	@ li,003 PSAY STR0008 + MV_PAR13		//"Local de Entrega  : " imprime o endereco digitado na pergunte
Endif

@ li,142 - nDifColCC PSAY " |"
dbGoto(nRegistro)
dbSelectArea(cAlias)

li++
@ li,001 PSAY "|"
//"Local de Cobranca : "
@ li,003 PSAY STR0010 + Alltrim(SM0->M0_ENDCOB) + " - " + Alltrim(SM0->M0_CIDCOB) + " - " + Alltrim(SM0->M0_ESTCOB) + " - " +	STR0009 + Trans(Alltrim(SM0->M0_CEPCOB),cCepPict)
@ li,142 - nDifColCC PSAY " |"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+SC7->C7_COND)
dbSelectArea("SC7")
li++
@ li,001 PSAY "|"
@ li,003 PSAY STR0011+SubStr(SE4->E4_COND,1,15)		//"Condicao de Pagto "
@ li,038 PSAY STR0012		// "|Data de Emissao|"
@ li,056 PSAY STR0013		// "Total das Mercadorias : "
@ li,094 PSAY xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nTotal,14,MsDecimais(MV_PAR12))

@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
@ li,038 PSAY "|"
@ li,043 PSAY SC7->C7_EMISSAO
@ li,054 PSAY "|"
@ li,056 PSAY STR0064		// "Total com Impostos : "
@ li,094 PSAY xMoeda(nTotMerc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) Picture tm(nTotMerc,14,MsDecimais(MV_PAR12))
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "|"
@ li,055 PSAY Replicate("-",86 - nDifColCC)
@ li,142 - nDifColCC PSAY "|"
li++
dbSelectArea("SM4")
dbSeek(xFilial("SM4")+SC7->C7_REAJUST)
dbSelectArea("SC7")
@ li,001 PSAY "|"
@ li,003 PSAY STR0014		//"Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","C7_REAJUST",,MV_PAR12)
@ li,018 PSAY SM4->M4_DESCR
@ li,054 PSAY STR0018		//"| Total Geral : "

@ li,094 PSAY xMoeda(nTotNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)      Picture tm(nTotNF,14,MsDecimais(MV_PAR12))
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
//��������������������������������������������������������������Ŀ
//� Inicializar campos de Observacoes.                           �
//����������������������������������������������������������������
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs 	:= cObs01
		cObs01:= Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

li++
@ li,001 PSAY STR0025	//"| Observacoes"
@ li,054 PSAY STR0026	//"| Comprador    "
@ li,070 PSAY STR0027	//"| Gerencia     "
@ li,085 PSAY STR0028	//"| Diretoria    "
@ li,142 - nDifColCC PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs01
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,142 - nDifColCC PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs02
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,142 - nDifColCC PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs03
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,142 - nDifColCC PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs04
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
                                                                 
//������������������������Ŀ
//� Lista de Aprovadores   �
//��������������������������
dbSelectArea("SC7")
lNewAlc := .F.
/*
If !Empty(C7_APROV)   
	lNewAlc := .T.
	cComprador := UsrFullName(SC7->C7_USER)
	If C7_CONAPRO != "B"
		lLiber := .T.
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+"AE"+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO == "AE"
		cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["
        Do Case
        	Case SCR->CR_STATUS=="03" //Liberado
        		cAprov += "Ok"
        	Case SCR->CR_STATUS=="04" //Bloqueado
        		cAprov += "BLQ"
			Case SCR->CR_STATUS=="05" //Nivel Liberado
				cAprov += "##"
			OtherWise                 //Aguar.Lib
				cAprov += "??"
		EndCase
		cAprov += "] - "
		dbSelectArea("SCR")
		dbSkip()
	Enddo
	If !Empty(SC7->C7_GRUPCOM)
		dbSelectArea("SAJ")
		dbSetOrder(1)
		dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
		While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
			If SAJ->AJ_USER != SC7->C7_USER
				If SAJ->(FieldPos("AJ_MSBLQL") > 0)
					If SAJ->AJ_MSBLQL == "1"
						dbSkip()
						LOOP
					EndIf 
				EndIf
				cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
			EndIf
			dbSelectArea("SAJ")
			dbSkip()
		EndDo
	EndIf
EndIf
*/
//����������������������Ŀ
//� Imprime Aprovadores  �
//������������������������
If lNewAlc                   
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0052		//"Comprador Responsavel :"
	@ li,027 PSAY Substr(cComprador,1,60)
	@ li,088 PSAY "|"
	@ li,089 PSAY STR0060      //"BLQ:Bloqueado"
	@ li,102 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
	li++
	nAuxLin := Len(cAlter)
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0053		//"Compradores Alternativos :"
	While nAuxLin > 0 .Or. lImpLeg
		@ li,029 PSAY Substr(cAlter,Len(cAlter)-nAuxLin+1,60)
		@ li,088 PSAY "|"
		If lImpLeg
			@ li,089 PSAY STR0061   //"Ok:Liberado"
			lImpLeg := .F.
		EndIf
		@ li,102 PSAY "|"
		@ li,142 - nDifColCC PSAY "|"
		nAuxLin -= 60
		li++
	EndDo
	
	nAuxLin := Len(cAprov)
	lImpLeg := .T.
	
	While nAuxLin > 0	.Or. lImpLeg
		@ li,001 PSAY "|"
		If lImpLeg  // Imprimir soh a 1a vez
			@ li,003 PSAY STR0054		//"Aprovador(es) :"
		EndIf
		@ li,018 PSAY Substr(cAprov,Len(cAprov)-nAuxLin+1,70)
		@ li,088 PSAY "|"
		
		If lImpLeg2  // Imprimir soh a 2a vez
			@ li,089 PSAY STR0067 //"##:Nivel.Lib"
			lImpLeg2 := .F.
		EndIf
		If lImpLeg   // Imprimir soh a 1a vez
			@ li,089 PSAY STR0062  //"??:Aguar.Lib"
			lImpLeg  := .F.
			lImpLeg2 := .T.
		EndIf
		
		@ li,102 PSAY "|"
		@ li,142 - nDifColCC PSAY "|"      
	
		nAuxLin -=70
		li++
	EndDo
	
	If lImpLeg2            
		lImpLeg2 := .F.
		@ li,001 PSAY "|"
		@ li,088 PSAY "|"
		@ li,089 PSAY STR0067 //"##:Nivel Lib"
		@ li,102 PSAY "|"
		@ li,142 - nDifColCC PSAY "|"
		li++
	EndIf
	
	If nAuxLin == 0
		li++
	EndIf

	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,142 - nDifColCC PSAY "|"
	li++
	
EndIf

@ li,001 PSAY STR0029	//"|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega."
@ li,142 - nDifColCC PSAY "|"   

li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)     
@ li,142 - nDifColCC PSAY "|"

Return .T.
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpRodape� Autor � Wagner Xavier         � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o rodape do formulario e salta para a proxima folha���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpRodape(Void)   			         					  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 					                     				      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpRodape()
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,070 PSAY STR0030		//"Continua ..."
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li:=0
Return .T.
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpCabec � Autor � Wagner Xavier         � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o Cabecalho do Pedido de Compra                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpCabec(Void)                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpCabec(ncw)
Local nOrden, cCGC
LOCAL cMoeda
Local cCGCFOR := ""

cMoeda := Iif(mv_par12<10,Str(mv_par12,1),Str(mv_par12,2))

@ 01,001 PSAY "|"
@ 01,002 PSAY Replicate("-",limite)
@ 01,142 - nDifColCC PSAY "|"
@ 02,001 PSAY "|"
@ 02,029 PSAY IIf(nOrdem>1,(STR0033)," ")		//" - continuacao"

If mv_par08 == 1 .OR. mv_par08 == 3
	@ 02,045 PSAY (STR0031)+" - "+GetMV("MV_MOEDA"+cMoeda) 	//"| P E D I D O  D E  C O M P R A S"
Else
	@ 02,045 PSAY (STR0032)+" - "+GetMV("MV_MOEDA"+cMoeda)  //"| A U T. D E  E N T R E G A     "
EndIf

If ( Mv_PAR08==2 )
	@ 02,090 PSAY "|"
	@ 02,093 PSAY SC7->C7_NUMSC + "/" + SC7->C7_NUM  //    Picture PesqPict("SC7","c7_num")	
Else
	@ 02,096 PSAY "|"
	@ 02,101 PSAY SC7->C7_NUM      Picture PesqPict("SC7","C7_NUM")
EndIf

@ 02,107 PSAY "/"+Str(nOrdem,1)
@ 02,112 PSAY IIf(SC7->C7_QTDREEM>0,Str(SC7->C7_QTDREEM+1,2)+STR0034+Str(ncw,2)+STR0035," ")		//"a.Emissao "###"a.VIA"
@ 02,142 - nDifColCC PSAY "|"
@ 03,001 PSAY "|"
@ 03,003 PSAY Substr(SM0->M0_NOMECOM,1,42)
@ 03,045 PSAY "|"+Replicate("-",95 - nDifColCC)
@ 03,142 - nDifColCC PSAY "|"
@ 04,001 PSAY "|"
@ 04,003 PSAY Substr(SM0->M0_ENDENT,1,42)
dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
@ 04,045 PSAY "|"
If ( cPaisLoc$"ARG|POR|EUA" )
	@ 04,047 PSAY Substr(SA2->A2_NOME,1,35)+"-"+SA2->A2_COD+"-"+SA2->A2_LOJA	
Else
	@ 04,047 PSAY Substr(SA2->A2_NOME,1,35)+"-"+SA2->A2_COD+"-"+SA2->A2_LOJA+(STR0036)+" " + SA2->A2_INSCR		//" I.E.: "	
EndIf
@ 04,142 - nDifColCC PSAY "|"
@ 05,001 PSAY "|"
@ 05,003 PSAY (STR0009)+Trans(SM0->M0_CEPENT,cCepPict)+" - "+Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT		//"CEP :"
@ 05,045 PSAY "|"
@ 05,047 PSAY SubStr(SA2->A2_END,1,42)   Picture PesqPict("SA2","A2_END")
@ 05,089 PSAY "-  "+SubStr(Trim(SA2->A2_BAIRRO),1,(53-nDifColCC))	Picture "@!"
@ 05,142 - nDifColCC PSAY "|"
@ 06,001 PSAY "|"
@ 06,003 PSAY STR0037+SM0->M0_TEL		//"TEL: "
@ 06,023 PSAY STR0038+SM0->M0_FAX		//"FAX: "
@ 06,045 PSAY "|"
@ 06,047 PSAY Trim(SA2->A2_MUN)  Picture "@!"
@ 06,069 PSAY SA2->A2_EST    		Picture PesqPict("SA2","A2_EST")
@ 06,074 PSAY STR0009	//"CEP :"
@ 06,081 PSAY SA2->A2_CEP    		Picture PesqPict("SA2","A2_CEP")

dbSelectArea("SX3")
nOrden = IndexOrd()
dbSetOrder(2)
dbSeek("A2_CGC")
cCGC := Alltrim(X3TITULO())
@ 06,093 PSAY cCGC+":" //"CGC: "
dbSetOrder(nOrden)

dbSelectArea("SA2")
If cPaisLoc == "BRA"
	cCGCFOR	:= Transform(SA2->A2_CGC,Iif(SA2->A2_TIPO == 'F',Substr(PICPES(SA2->A2_TIPO),1,17),Substr(PICPES(SA2->A2_TIPO),1,21))) 
Else  
	cCGCFOR	:= SA2->A2_CGC
EndIf  
@ 06,103 PSAY cCGCFOR 
@ 06,142 - nDifColCC PSAY "|"
@ 07,001 PSAY "|"
@ 07,002 PSAY (cCGC) + " "+ Transform(SM0->M0_CGC,cCgcPict)		//"CGC: "
If cPaisLoc == "BRA"
	@ 07,029 PSAY (STR0041)+ InscrEst()		//"IE:"
EndIf
@ 07,045 PSAY "|"
@ 07,047 PSAY SC7->C7_CONTATO Picture PesqPict("SC7","C7_CONTATO")
@ 07,069 PSAY STR0042	//"FONE: "
@ 07,075 PSAY "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15)
@ 07,100 PSAY (STR0038)	//"FAX: "
@ 07,106 PSAY "("+Substr(SA2->A2_DDD,1,3)+") "+SubStr(SA2->A2_FAX,1,15)
@ 07,142 - nDifColCC PSAY "|"
@ 08,001 PSAY "|"
@ 08,002 PSAY Replicate("-",limite)
@ 08,142 - nDifColCC PSAY "|"

If mv_par08 == 1 .OR. mv_par08 == 3
	@ 09,001 PSAY "|"
	@ 09,002 PSAY STR0043	//"Itm|"
	@ 09,009 PSAY STR0044	//"Codigo      "
	@ 09,022 PSAY STR0045	//"|Descricao do Material"
	@ 09,049 PSAY STR0046	//"|UM|  Quant."
	If cPaisLoc <> "BRA"
		@ 09,065 PSAY IIF(nDifColcc == 0,STR0056,STR0057)	//"|Valor Unitario|      Valor Total   |Entrega   |  C.C.   | S.C. |"
	Else
		@ 09,065 PSAY IIF(nDifColcc == 0,STR0047,STR0055)	//"|Valor Unitario|IPI% |  Valor Total   | Entrega  |  C.C.   | S.C. |"
	EndIf
	@ 10,001 PSAY "|"
	@ 10,002 PSAY Replicate("-",limite)
	@ 10,142 - nDifColCC PSAY "|"
Else
	@ 09,001 PSAY "|"
	@ 09,002 PSAY STR0043	//"Itm|"
	@ 09,009 PSAY STR0044	//"Codigo      "
	@ 09,022 PSAY STR0045	//"|Descricao do Material"
	@ 09,049 PSAY STR0046	//"|UM|  Quant."
	@ 09,065 PSAY STR0048	//"|Valor Unitario|  Valor Total   |Entrega | Numero da OP  "
	@ 09,142 - nDifColCC PSAY "|"
	@ 10,001 PSAY "|"
	@ 10,002 PSAY Replicate("-",limite)
	@ 10,142 - nDifColCC PSAY "|"
EndIf
dbSelectArea("SC7")
li := 10
Return .T.
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R110Center� Autor � Jose Lucas            � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Centralizar o Nome do Liberador do Pedido.                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpC1 := R110CenteR(ExpC2)                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 := Nome do Liberador                                 ���
���Parametros� ExpC2 := Nome do Liberador Centralizado                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R110Center(cLiberador)
Return( Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador) )
                                                         
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ChkPergUs � Autor � Nereu Humberto Junior � Data �21/09/07  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para buscar as perguntas que o usuario nao pode     ���
���          � alterar para impressao de relatorios direto do browse      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ChkPergUs(ExpC1,ExpC2,ExpC3)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 := Id do usuario                                     ���
���          � ExpC2 := Grupo de perguntas                                ���
���          � ExpC2 := Numero da sequencia da pergunta                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ChkPergUs(cUserId,cGrupo,cSeq)

Local aArea  := GetArea()
Local cRet   := Nil
Local cParam := "MV_PAR"+cSeq

dbSelectArea("SXK")
dbSetOrder(2)
If dbSeek("U"+cUserId+cGrupo+cSeq)
	If ValType(&cParam) == "C"
		cRet := AllTrim(SXK->XK_CONTEUD)
	ElseIf 	ValType(&cParam) == "N"
		cRet := Val(AllTrim(SXK->XK_CONTEUD))
	ElseIf 	ValType(&cParam) == "D"
		cRet := CTOD((AllTrim(SXK->XK_CONTEUD)))
	Endif
Endif

RestArea(aArea)
Return(cRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �R110FIniPC� Autor � Edson Maricate        � Data �20/05/2000���
�������������������������������������������������������������������������Ĵ��
���Descricao � Inicializa as funcoes Fiscais com o Pedido de Compras      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R110FIniPC(ExpC1,ExpC2)                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 := Numero do Pedido                                  ���
���          � ExpC2 := Item do Pedido                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR110,MATR120,Fluxo de Caixa                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R110FIniPC(cPedido,cItem,cSequen,cFiltro)

Local aArea		:= GetArea()
Local aAreaSC7	:= SC7->(GetArea())
Local cValid	:= ""
Local nPosRef	:= 0
Local nItem		:= 0
Local cItemDe	:= IIf(cItem==Nil,'',cItem)
Local cItemAte	:= IIf(cItem==Nil,Repl('Z',Len(SC7->C7_ITEM)),cItem)
Local cRefCols	:= ''
Local aStru		:= FWFormStruct(3,"SC7")[1]
Local nX

DEFAULT cSequen	:= ""
DEFAULT cFiltro	:= ""

dbSelectArea("SC7")
dbSetOrder(1)
If dbSeek(xFilial("SC7")+cPedido+cItemDe+Alltrim(cSequen))
	MaFisEnd()
	MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})
	While !Eof() .AND. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido .AND. ;
			SC7->C7_ITEM <= cItemAte .AND. (Empty(cSequen) .OR. cSequen == SC7->C7_SEQUEN)

		// Nao processar os Impostos se o item possuir residuo eliminado  
		If &cFiltro
			dbSelectArea('SC7')
			dbSkip()
			Loop
		EndIf
            
		// Inicia a Carga do item nas funcoes MATXFIS  
		nItem++
		MaFisIniLoad(nItem)

		For nX := 1 To Len(aStru)
			cValid	:= StrTran(UPPER(GetCbSource(aStru[nX][7]))," ","")
			cValid	:= StrTran(cValid,"'",'"')
			If "MAFISREF" $ cValid .And. !(aStru[nX][14]) //campos que n�o s�o virtuais
				nPosRef  := AT('MAFISREF("',cValid) + 10
				cRefCols := Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
				// Carrega os valores direto do SC7.           
				MaFisLoad(cRefCols,&("SC7->"+ aStru[nX][3]),nItem)
			EndIf
		Next nX		

		MaFisEndLoad(nItem,2)
		dbSelectArea('SC7')
		dbSkip()
	End
EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �R110Logo  � Autor � Materiais             � Data �07/01/2015���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna string com o nome do arquivo bitmap de logotipo    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function R110Logo()

Local cBitmap := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

//��������������������������������������������������������������Ŀ
//� Se nao encontrar o arquivo com o codigo do grupo de empresas �
//� completo, retira os espacos em branco do codigo da empresa   �
//� para nova tentativa.                                         �
//����������������������������������������������������������������
If !File( cBitmap )
	cBitmap := "LGRL" + AllTrim(SM0->M0_CODIGO) + SM0->M0_CODFIL+".BMP" // Empresa+Filial
EndIf

//��������������������������������������������������������������Ŀ
//� Se nao encontrar o arquivo com o codigo da filial completo,  �
//� retira os espacos em branco do codigo da filial para nova    �
//� tentativa.                                                   �
//����������������������������������������������������������������
If !File( cBitmap )
	cBitmap := "LGRL"+SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

//��������������������������������������������������������������Ŀ
//� Se ainda nao encontrar, retira os espacos em branco do codigo�
//� da empresa e da filial simultaneamente para nova tentativa.  �
//����������������������������������������������������������������
If !File( cBitmap )
	cBitmap := "LGRL" + AllTrim(SM0->M0_CODIGO) + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

//��������������������������������������������������������������Ŀ
//� Se nao encontrar o arquivo por filial, usa o logo padrao     �
//����������������������������������������������������������������
If !File( cBitmap )
	cBitmap := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
EndIf

Return cBitmap
