#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TOTVS.CH"
#include "protheus.ch"
#INCLUDE "TBICONN.CH"

#define DMPAPER_A4 9    // A4 210 x 297 mm

#define __NPOSNRBCO 01 // [1]Numero do Banco
#define __NPOSNMBCO 02 // [2]Nome do Banco
#define __NPOSAGENC 03 // [3]Agência
#define __NPOSCONTA 04 // [4]Conta Corrente -2
#define __NPOSDVCTA 05 // [5]Dígito da conta corrente
#define __NPOSCARTE 06 // [6]Codigo da Carteira
#define __NPOSDGBCO 07 // [7] Digito do Banco
#define __NPOSLCPG1 08 // [8] Local de Pagamento1
#define __NPOSLCPG2 09 // [9] Local de Pagamento2
#define __NPOSDVAGE 10 //[10] Digito Verificador da agencia
#define __NPOSCONVE 11 //[11] Código Beneficiario fornecido pelo Banco
#define __NPOSLOGO  12 //[12] Logo impressa no boleto salvo em /system

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFIN001³ Autor ³ TOTVS            ³ Data ³ 12/08/2008      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ TOTVS-GO            ³Contato ³ andersonm@terra.com.br      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa de impressao de boletos.                          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NIL                                  				      	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL 														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³ SIGAFAT/SIGAOMS                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Grupo SCODRO  / Grupo Cepalgo                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson     ³  /  /  ³      ³ Adequacao para selecao de carteira.    ³±±
±±³ Diego Bueno  ³12/08/13³      ³ Adequacao para uso para Grupo Scodro   ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


****** Campos utilizados ******************
E1_MULTA  = Vlr. da multa a cerca do recebimento
E1_JUROS  = Vlr. da taxa permanencia cobrada
E1_CORREC = vlr. da Correcao referente ao recebimento
E1_VALJUR = Taxa diaria, tem precedencia ao % juros
E1_PORCJUR = % juro atraso dia
E1_XDVNNUM = Dv Nosso Numero - Campos que devem ser criados (C = 1)

EE_CODCART = Codigo da carteira de cobranca
EE_DVCTA = DV Conta    
EE_DVAGE = DV Agencia  
EE_TIPODAT = verificar se deve mudar para 4 a data para baixar sair correta     


***** Parametros utilizados ***********************
MV_TXPER = Indique o % da Taxa de Juros e colocado no E1_PORCJUR, ele ira calcular o E1_VALJUR
MV_LJMULTA = Percentual de multa para os titulos em atraso. Utilizado na rotina de recebimento de titulos.    
MV_XSEE = Define a carteira em uso pelo faturamento para emitir boletos 

********MELHORIA DIA 21/06/2012
Envio para todas as Situações do Protheus
EE_XSIT = C = 1	==> Podendo Ser:
1-Cobrança Simples
2-Cobrança Descontada
3-Cobrança Caucionada	
4-Cobrança Vinculada
7-Caucionada Descontada

*********MELHORIA DIA 25/11/2020 - João Vitor Ribeiro TBC
Implementação do banco 707 - Banco Daycoval
Dados para teste
707
Agencia 0001-9
Conta 740412-5
Sub-conta 001

Grupo = 04
Borderô = D25L20
titulos = 000099995, 000099996 e 000099997

*/                  

User Function RFIN001()

	Local   _cQry 	:= ""

	Private lJob 	:= .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preparo o ambiente na qual sera executada a rotina de negocio      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Select("SX2") == 0 // Se via JOB
		lJob := .T.
		U_ULogMsg(DTOC(DATE())+"-"+Time()+" Iniciando rotina para emissão de boletos...")

		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0101" TABLES "SA3","SED","SEE","SE1","SEA"
	else
		DbSelectArea("SA3")
		DbSelectArea("SED")
		DbSelectArea("SEE")
		DbSelectArea("SE1")
		DbSelectArea("SEA")
	Endif

	Private	lXOBSRM := SuperGetMV("MV_XOBSRM",,.F.) //João Vitor - TBC
	PRIVATE lExec       := .F.
	PRIVATE cIndexName  := ''
	PRIVATE cIndexKey   := ''
	PRIVATE cFilter     := ''
	PRIVATE cNumBco     := ''
	PRIVATE cMarca      := GetMark()
	PRIVATE Tamanho 	  := "M"
	PRIVATE titulo   	  := "Impressao de Boleto com Codigo de Barras"
	PRIVATE cDesc1  	  := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
	PRIVATE cDesc2  	  := ""
	PRIVATE cDesc3   	  := ""
	PRIVATE cString  	  := "SE1"
	PRIVATE wnrel    	  := "BOLETO LASER"
	PRIVATE lEnd     	  := .F.
	PRIVATE cPerg       :=Padr("RFIN001",10)
	PRIVATE aReturn     := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	PRIVATE nLastKey    := 0
	PRIVATE aCampos     :={}
	PRIVATE _MsExec	  	:= .F.
	PRIVATE dDtVencRea
	PRIVATE nVlSaldo	:= 0	   //Valor do Documento
	PRIVATE nVlJuros   	:= 0	   //Valor do Juros
	PRIVATE nVlMulta   	:= 0		//Valor Multa
	PRIVATE oTempTable
	PRIVATE	aPergs  := {}
	Private _Exec 		:= {}
	DEFAULT calias 		:= "TSE1"

	AjustaSx1()

	_MsExec	:= iif( FunName() == "MATA410" .OR. FunName() == "MATA410" ,.F. ,len(_Exec) > 0 )

	if !Pergunte(cPerg, !_MsExec) .And. !_MsExec
		Return
	endif

	if LastKey() == 27
		Return

	elseif Len(_Exec) <> 22 .and. _MsExec
		Aviso("ERRO","Informar ao Dept. T.I. diferença nos parametros vindo do Faturamento, o Boleto poderá ser impresso pela opção Relatorio->Personalização-> Boleto Laser!",{"OK"})
		Return

	elseif _MsExec
		MV_PAR01 := _Exec[01]	// Prefixo
		MV_PAR02 := _Exec[02]
		MV_PAR03 := _Exec[03]	// Nr.
		MV_PAR04 := _Exec[04]
		MV_PAR05 := _Exec[05]	// Parcela
		MV_PAR06 := _Exec[06]
		MV_PAR07 := _Exec[07]	// Portador
		MV_PAR08 := _Exec[08]
		MV_PAR09 := _Exec[09]	// Cliente
		MV_PAR10 := _Exec[10]
		MV_PAR11 := _Exec[11]	// Loja
		MV_PAR12 := _Exec[12]
		MV_PAR13 := _Exec[13]	// Emissão
		MV_PAR14 := _Exec[14]
		MV_PAR15 := _Exec[15]	// Vencimento
		MV_PAR16 := _Exec[16]
		MV_PAR17 := _Exec[17]	// Nr. Bordero
		MV_PAR18 := _Exec[18]
		MV_PAR19 := _Exec[19]	// Nr. Carga
		MV_PAR20 := _Exec[20]
		MV_PAR21 := _Exec[21]	// Msg1
		MV_PAR22 := _Exec[22]	// Msg2
	endif

	// Diego Bueno - 29-01-2014 - adicionado E1_SDACRES, E1_SDDECRES
	_cQry := ""
	_cQry += " SELECT DISTINCT"
	_cQry += "    (SELECT "
	_cQry += "       ISNULL(SUM(E1_VLCRUZ),0) "
	_cQry += "     FROM "
	_cQry += "          "+RetSqlName("SE1")
	_cQry += "     WHERE "
	_cQry += "           D_E_L_E_T_ <> '*' "
	_cQry += "       AND LTRIM(RTRIM(E1_TIPO)) = 'NCC'  "
	_cQry += "       AND E1_CLIENTE = SE1.E1_CLIENTE  "
	_cQry += "       AND E1_LOJA    = SE1.E1_LOJA "
	_cQry += "     ) E1_NCC "
	_cQry += "   ,(SELECT  "
	_cQry += "       ISNULL(SUM(E1_VLCRUZ),0) "
	_cQry += "     FROM "
	_cQry += "          "+RetSqlName("SE1")
	_cQry += "     WHERE "
	_cQry += "           D_E_L_E_T_ <> '*' "
	_cQry += "       AND LTRIM(RTRIM(E1_TIPO)) = 'RA'  "
	_cQry += "       AND E1_CLIENTE = SE1.E1_CLIENTE "
	_cQry += "       AND E1_LOJA    = SE1.E1_LOJA "
	_cQry += "     ) E1_RA "
	_cQry += "   ,SE1.E1_TIPO "
	_cQry += "   ,F2_CARGA E1_CARGA "
	_cQry += "   ,E1_NUMBOR   "
	_cQry += "   ,E1_PREFIXO   "
	_cQry += "   ,E1_NUM "
	_cQry += "   ,E1_PARCELA "
	_cQry += "   ,E1_TIPO "
	_cQry += "   ,E1_NATUREZ  "
	_cQry += "   ,E1_PORTADO  "
	_cQry += "   ,E1_CLIENTE "
	_cQry += "   ,ISNULL(A1_NOME,' ') E1_NOME"
	_cQry += "   ,E1_LOJA  "
	_cQry += "   ,E1_EMISSAO "
	_cQry += "   ,E1_VENCTO  "
	_cQry += "   ,E1_VENCREA "
	_cQry += "   ,E1_VLCRUZ  "
	_cQry += "   ,E1_FILIAL  "
	_cQry += "   ,E1_VEND1 "
	_cQry += "   ,E1_SALDO "
	_cQry += "   ,E1_HIST "
	_cQry += "   ,E1_DESCFIN "
	_cQry += "   ,E1_SDACRES "
	_cQry += "   ,E1_SDDECRE "
	_cQry += "   ,E1_PEDIDO "

	if lXOBSRM // Se tem integracao com RM no Boleto
		_cQry += "   ,E1_XOBSRM "	//Parcela RM
		_cQry += "   ,E1_XDTVEBO " //Data Vencimento Alterada RM
	Endif

	_cQry += " FROM "
	_cQry += "    "+RetSqlName("SE1")+" SE1 "

	// Nota fiscal de saida
	_cQry += "    LEFT JOIN "+RetSqlName("SF2")+" SF2 "
	_cQry += "    ON    SE1.E1_FILIAL  = SF2.F2_FILIAL "
	_cQry += "      AND SE1.E1_NUM     = SF2.F2_DOC  "
	_cQry += "      AND SE1.E1_PREFIXO = SF2.F2_SERIE "
	_cQry += "      AND SE1.E1_CLIENTE = SF2.F2_CLIENTE "
	_cQry += "      AND SE1.E1_LOJA    = SF2.F2_LOJA "
	_cQry += "      AND SF2.D_E_L_E_T_ = SE1.D_E_L_E_T_ "

	// Bordero - Brando 02/10/2009
	// Foi relacionado a tabela de bordero para buscar os titulos cuja a emissao
	_cQry += "    LEFT JOIN "+RetSqlName("SEA")+" SEA "
	_cQry += "    ON    SE1.E1_FILIAL  = SEA.EA_FILIAL "
	_cQry += "      AND SE1.E1_NUM     = SEA.EA_NUM  "
	_cQry += "      AND SE1.E1_PREFIXO = SEA.EA_PREFIXO "
	_cQry += "      AND SE1.E1_PARCELA = SEA.EA_PARCELA "
	_cQry += "      AND SE1.E1_NUMBOR = SEA.EA_NUMBOR "    // Diego Bueno - 12/08/2013 - estava faltando delet e num bordero
	_cQry += "      AND SEA.D_E_L_E_T_ = SE1.D_E_L_E_T_ "
	// Fim Brando 02/10/2009

	// Diego Bueno - 12/08/2013 - corrigido join com SA1
	_cQry += " 	  LEFT JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL = "+xFilial("SA1")+" AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA "
	_cQry += "  AND SA1.D_E_L_E_T_ = SE1.D_E_L_E_T_ "
	// Fim Diego 12/08/13

	_cQry += " WHERE "
	_cQry += 	" SE1.D_E_L_E_T_ <> '*' "
	_cQry += 	" AND LTRIM(RTRIM(SE1.E1_TIPO))  NOT IN ('NCC','RA','TX')  "
	_cQry += 	" AND E1_FILIAL           = '"+xFilial("SE1") + "'
	_cQry += 	" AND E1_PREFIXO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	_cQry += 	" AND E1_NUM     BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	_cQry += 	" AND E1_PARCELA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	_cQry += 	" AND E1_PORTADO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	_cQry += 	" AND E1_CLIENTE BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	_cQry += 	" AND E1_LOJA    BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "

	IF !Empty( AllTrim(MV_PAR19) )
		_cQry += " AND SF2.F2_CARGA BETWEEN '" + MV_PAR19+ "' AND '"+ MV_PAR20 + "' "
	ENDIF

	IF !Empty(MV_PAR17)
		_cQry += 	"   AND E1_NUMBOR BETWEEN '" + MV_PAR17 + "' AND '" + MV_PAR18 + "' "
	ENDIF

	if (MV_PAR13 <> CTOD("  /  /    ")) .AND. (MV_PAR14 <> CTOD("  /  /    "))
		_cQry += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR13)+"' AND '"+DTOS(MV_PAR14)+"' "
	endif

	if (MV_PAR15 <> CTOD("  /  /    ")) .AND. (MV_PAR16 <> CTOD("  /  /    "))
		_cQry += " AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR15)+"' AND '"+DTOS(MV_PAR16)+"' "
	endif

	_cQry += " AND E1_SALDO > 0 "
	_cQry += " AND A1_XBOLETO = 'S'
	//AND A1_XBOLETO = 'S'

	MemoWrite("D:\Consulta\rfin001.sql",_cQry)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Abrir a Query ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos := {}
	aadd(aCampos,{ "E1_OK"		   	,"C",02						,0 })
	aadd(aCampos,{ "E1_EMISSAO" 	,"D",08						,0 })
	aadd(aCampos,{ "E1_PREFIXO"		,"C",len(SE1->E1_PREFIXO)	,0 })
	aadd(aCampos,{ "E1_NUM"			,"C",len(SE1->E1_NUM)		,0 })
	aadd(aCampos,{ "E1_PARCELA"		,"C",len(SE1->E1_PARCELA)	,0 })
	aadd(aCampos,{ "E1_CLIENTE"		,"C",len(SE1->E1_CLIENTE)	,0 })
	aadd(aCampos,{ "E1_LOJA"  		,"C",len(SE1->E1_LOJA)		,0 })
	aadd(aCampos,{ "E1_NOME"		,"C",40						,0 })
	aadd(aCampos,{ "E1_VENCTO" 		,"D",08						,0 })
	aadd(aCampos,{ "E1_VENCREA"		,"D",08						,0 })
	aadd(aCampos,{ "E1_VLCRUZ"		,"N",15						,2 })
	aadd(aCampos,{ "E1_SALDO"		,"N",15						,2 })
	aadd(aCampos,{ "E1_DESCFIN"		,"N",06						,2 })
	aadd(aCampos,{ "E1_SDACRES "  	,"N",16						,2 })
	aadd(aCampos,{ "E1_SDDECRE "	,"N",16						,2 })
	aadd(aCampos,{ "E1_NCC"	      	,"N",15						,2 })
	aadd(aCampos,{ "E1_RA"	      	,"N",15						,2 })
	aadd(aCampos,{ "E1_CARGA"		,"C",06						,0 })
	aadd(aCampos,{ "E1_NUMBOR"		,"C",06						,0 })
	aadd(aCampos,{ "E1_TIPO"		,"C",03						,0 })
	aadd(aCampos,{ "E1_NATUREZ"		,"C",10						,0 })
	aadd(aCampos,{ "E1_PORTADO"		,"C",03						,0 })
	aadd(aCampos,{ "E1_FILIAL"	   	,"C",03						,0 })
	aadd(aCampos,{ "E1_VEND1"	   	,"C",06						,0 })
	aadd(aCampos,{ "E1_PEDIDO"	   	,"C",06						,0 })
	aadd(aCampos,{ "E1_HIST"	   	,"C",230					,0 })//254

	if lXOBSRM // Se tem integracao com RM no Boleto
		aadd(aCampos,{ "E1_XOBSRM"	,"C",70						,0 })//254   //Parcela RM
		aadd(aCampos,{ "E1_XDTVEBO"	,"D",08						,0 })//254   //Data Vencimento Alterada RM
	Endif

	cNtxSE1  := GetNextAlias()
	//oTemptable:FWTemporaryTable():New(calias)
	//oTemptable:SetFields( aCampos )
	//oTempTable:AddIndex("01", {"E1_FILIAL", "E1_PREFIXO", "E1_NUM", "E1_PARCELA", "E1_TIPO"} )
	//oTempTable:Create()

	cArqSE1  := CriaTrab(aCampos, .T.)
	cNtxSE1  := CriaTrab(nil,.f.)
	dbUseArea(.T.,__LocalDriver,cArqSE1,"TSE1",.F.)

	Processa({|| SqlToTrb(_cQry, aCampos, "TSE1")}) // Cria arquivo temporario
	INDEX ON E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO TO &cNtxSE1

	cMarca:=GetMark()
	cMarca:=soma1(cMarca)

	aStruSE1	:= {		{"E1_OK" 		,""					,02,0},;
		{"E1_EMISSAO" 	,"Dt. Emissão"		,08,0},;//	,"@D 99/99/9999"},;
		{"E1_PREFIXO" 	,"Prefixo"	 		,len(SE1->E1_PREFIXO),0},;
		{"E1_NUM" 		,"Titulo"			,len(SE1->E1_NUM),0},;
		{"E1_PARCELA" 	,"Parcela"			,len(SE1->E1_PARCELA),0},;
		{"E1_CLIENTE" 	,"Cliente"			,len(SE1->E1_CLIENTE),0},;
		{"E1_LOJA" 		,"Loja"				,len(SE1->E1_LOJA),0},;
		{"E1_NOME" 		,"Nome"				,40,0},;
		{"E1_VENCTO" 	,"Dt. Vencto"		,08,0},;//	,"@D 99/99/9999"},;
		{"E1_VENCREA"	,"Dt. Vencto Real"	,08,0},;
		{"E1_VLCRUZ"	,"Valor"	,"@E 999,999,999,999.99"},;
		{"E1_SALDO"  	,"Saldo a Receber"	,"@E 999,999,999,999.99"},;
		{"E1_DESCFIN" 	,"% Desconto","@E 999.99"},;
		{"E1_SDACRES"   ,"Acrescimo","@E 999,999,999,999.99"},;
		{"E1_SDDECRE"	,"Decrescimo","@E 999,999,999,999.99"},;
		{"E1_RA" 		,"RA"		,"@E 999,999,999,999.99"},;
		{"E1_NCC" 		,"NCC"		,"@E 999,999,999,999.99"},;
		{"E1_TIPO" 		,"Tipo"		,03,0},;
		{"E1_CARGA" 	,"Carga"	,06,0},;
		{"E1_NUMBOR" 	,"Bordero"	,06,0},;
		{"E1_NATUREZ" 	,"Natureza"	,10,0},;
		{"E1_VEND1" 	,"Vendedor"									,06,0},;
		{"E1_PORTADO" 	,"Portado"									,03,0} }

	TSE1->( dbGotop() )

	if !_MsExec
		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
		@ 001,001 TO 170,350 BROWSE "TSE1" FIELDS aStruSE1 MARK "E1_OK"  Object oBrowIncPed

		oBtn1 := tButton():New(180,050,"Desmarca Todos   " ,oDlg,{|| u_fMarTudo(cMarca,.t.)},060,015,,,,.T.)
		oBtn2 := tButton():New(180,110,"Marca Todos      " ,oDlg,{|| u_fMarTudo(cMarca,.f.)},060,015,,,,.T.)
		oBtn3 := tButton():New(180,170,"Inverte Seleção  " ,oDlg,{|| u_fMarTudo(cMarca,nil)},060,015,,,,.T.)
		oBtn4 := tButton():New(180,230,"Imprimir Boletos " ,oDlg,{|| lExec := .T.,MontaRel(),Close(oDlg)},060,015,,,,.T.)
		oBtn4 := tButton():New(180,290,"    Cancelar     " ,oDlg,{|| lExec := .F.,Close(oDlg)},060,015,,,,.T.)

		ACTIVATE DIALOG oDlg CENTERED

	Else
		lExec := .T.
		u_fMarTudo(cMarca,.F.)
		MontaRel()
	Endif

	TSE1->( dbCloseArea() )
	fErase(cArqSE1 + ".DBF")
	fErase(cNtxSE1 + ordBagExt())
Return Nil

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³  fMarTudo³ Autor ³ Brando                ³ Data ³ 19/07/07 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri??o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS		      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
User Function fMarTudo(cMarca, ltudo)
	Local aArea := TSE1->(GetArea())

	TSE1->( dbGoTop() )

	While !TSE1->( Eof() )

		RecLock("TSE1",.F.)
		if lTudo        // Marca todos os Itens
			TSE1->E1_OK := cMarca

		elseIf !lTudo   // Desmarca todos os itens
			TSE1->E1_OK := "  "

		else                   // Inverte a Seleção

			if TSE1->E1_OK == cMarca
				TSE1->E1_OK := "  "
			else
				TSE1->E1_OK := cMarca
			endif

		endIf

		TSE1->( MsUnLock() )
		TSE1->( dbSkip() )

	Enddo

	RestArea(aArea)
	if !_MsExec
		oDlg:Refresh()
	endif
Return


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³  MontaRel³ Autor ³ Brando                ³ Data ³ 19/07/07 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri??o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS		      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
	RptStatus({|lEnd| ImpDet() },"Processando Impressão Boletos...") //"Processando"
Return


Static Function ImpDet()
	LOCAL oPrint
	LOCAL nX      := 0
	LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
	SM0->M0_ENDCOB                                     ,; //[2]Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
	"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
	"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+              ; //[6]
	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
	Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

	LOCAL aDadosTit
	LOCAL aDadosBanco
	LOCAL aDatPagador
	LOCAL aBolText     := {  AllTrim(FMsgCnab(SEE->EE_FORMEN1)), ;    // Primeiro texto para comentario
	AllTrim(FMsgCnab(SEE->EE_FORMEN2)), ;    // Segundo texto para comentario
	SEE->EE_FOREXT1, ;    // Terceiro texto para comentario
	SEE->EE_FOREXT2 ,;
		"* Valores Expressos em REAIS(R$) *"  }

	LOCAL nI           := 1
	LOCAL aCB_RN_NN    := {}
	LOCAL nVlrAbat	   := 0
	LOCAL cNosso       := ""
	LOCAL _aVlrNF	   := {}
	LOCAL ccontaBB     := ""
	Local aPesos       := {}

	Private cDigNosso    := ""
	Private _cConvenio := ""
	Private _cCarteira := ""

	Private cString  := "SE1"
	Private wnrel    := "BOLETO BANCARIO"
	//Private cPerg     :="BOLETOBB  "
	Private titulo   := "Impressao de Boleto com Codigo de Barras"
	Private cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
	Private cDesc2   := ""
	Private cDesc3   := ""
	Private Tamanho  := "G"

	Private aReturn := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	Private nLastKey:= 0
	Private lF055E1	:= GetMv("MV_XF055E1",,.F.)
	Private nTXPERB := SuperGetMv("MV_TXPERB",,1)
	Private nLJMULB := SuperGetMv("MV_LJMULB",,2)
	Private nLJMULTA:= GetMV("MV_LJMULTA")
	Private nTXPER	:= GetMV("MV_TXPER")


	//Banco Abc do Brasil
	Public _cCart     := ""
	Public _cAgencia  := ""
	Public _cOperacao := ""
	Public _cFaixaBc  := ""



	oPrint:= TMSPrinter():New( "Boleto Bancario Laser" )
	oPrint:Setup()
	oPrint:SetPortrait()

	If nLastKey == 27
		Set Filter to
		Return
	Endif

	TSE1->( dbGoTop() )
	SetRegua( TSE1->( LastRec() ) )

	while !TSE1->( Eof() )

		IncRegua()

		IF lF055E1 .and. ("FINA055" $ SE1->E1_ORIGEM)
			Aviso("ATENÇÃO","Não é permitido imprimir boletos do RM no protheus!. Pref. "+Alltrim(TSE1->E1_PREFIXO)+" Tit. "+Alltrim(TSE1->E1_NUM),{"OK"})
			loop
		endif

		If TSE1->E1_OK = '  '

			SE1->(DbSetOrder(2), DbSeek( xFilial("SE1") + TSE1->E1_CLIENTE + TSE1->E1_LOJA + TSE1->E1_PREFIXO + TSE1->E1_NUM + TSE1->E1_PARCELA + TSE1->E1_TIPO ) )
			cNroDoc    :=  ""

			If !NrBordero()
				Set Filter to
				Aviso("ATENÇÃO","O banco "+SEE->EE_CODIGO+" não esta configurado para Impressão Boleto Laser",{"OK"})
				Return
			Endif

			//Posiciona na Tabela do bordero.
			SEA->( DBSetOrder(1) )
			if !SEA->( DBSeek( xFilial("SEA") + SE1->E1_NUMBOR + TSE1->E1_PREFIXO + TSE1->E1_NUM + TSE1->E1_PARCELA + TSE1->E1_TIPO ) )
				Alert("Titulo nao localizado no bordero selecionado. Pref. "+Alltrim(TSE1->E1_PREFIXO)+" Tit. "+Alltrim(TSE1->E1_NUM))
				Return
			Endif

			//Posiciona na Arq de Parametros CNAB
			SEE->( DbSetOrder(1) )
			if !SEE->( DbSeek(xFilial("SEE")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON)+"001",.T.) )
				alert("Erro na leitura dos parametros do banco do bordero gerado (Sub-conta diferente de 001),")
				return
			EndIf
			//Retornar Mensagem Correta do Parametros de Banco.	Ajustado Data 07/10/2015
			aBolText     := {  AllTrim(FMsgCnab(SEE->EE_FORMEN1)),;    // Primeiro texto para comentario
			AllTrim(FMsgCnab(SEE->EE_FORMEN2)),;    // Segundo texto para comentario
			SEE->EE_FOREXT1,;    // Terceiro texto para comentario
			SEE->EE_FOREXT2 ,;
				"* Valores Expressos em REAIS(R$) *"  }

			//Posiciona o SA6 (Bancos)
			SA6->( DbSetOrder(1) )
			if !SA6->( DbSeek(xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON) ,.T.) )
				Alert("Banco do bordero ("+Alltrim(SEA->EA_PORTADO)+" - "+Alltrim(SEA->EA_AGEDEP)+" - "+Alltrim(SEA->EA_NUMCON)+") nao localizado no cadastro de Bancos.")
				Return
			Endif

			if Empty(SEE->EE_CODEMP)
				alert("Informar o convenio do banco no cadastro de parametros do banco (EE_CODEMP) !")
				return nil
			endif

			if Empty(SEE->EE_TABELA)
				alert("Informar a tabela do banco no cadastro de parametros do banco (EE_TABELA) !")
				return nil
			endif

			_cConvenio := AllTrim(SEE->EE_CODEMP) // Tamanho de 7.
			_cCarteira := Alltrim(SEE->EE_CODCART) // Carteira
			_cOperacao := Alltrim(SEE->EE_OPER) //Operação

			if Alltrim(SEE->EE_CONTA) == "002218440" //tratamento para nova conta abc
				ccontaBB := "5022542"
			else
				ccontaBB := Alltrim(SEE->EE_CONTA)
			endif

			//Posiciona o SA1 (Cliente)
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+TSE1->E1_CLIENTE+TSE1->E1_LOJA,.T.) )



			If SEE->EE_CODIGO == '001'  // Banco do Brasil
				aDadosBanco  := {SEE->EE_CODIGO          ,;	// [1]Numero do Banco
				"BANCO BRASIL"     ,; // [2]Nome do Banco
				Substr(SEE->EE_AGENCIA,1,4)   ,;	// [3]Agência
				Alltrim(SEE->EE_CONTA),; 	// [4]Conta Corrente -2
				Alltrim(SEE->EE_DVCTA),; 	// [5]Dígito da conta corrente
				_cCarteira ,; // [6]Codigo da Carteira
				"9" ,; // [7] Digito do Banco
				"ATÉ O VENCIMENTO, PREFERENCIALMENTE EM TODA REDE BANCÁRIA" ,; // [8] Local de Pagamento1
				"APÓS O VENCIMENTO, SOMENTE NAS AGÊNCIAS DO BANCO DO BRASIL",; // [9] Local de Pagamento2
				SEE->EE_DVAGE,; 	//[10] Digito Verificador da agencia
				_cConvenio,;	//[11] Código Beneficiario fornecido pelo Banco
				AllTrim(SEE->EE_XLOGO)}	//[12] Logo impressa no boleto salvo em /system

			ElseIf SEE->EE_CODIGO == '341' .Or. SEE->EE_CODIGO == '187' // Itau
				aDadosBanco  := {'341'          ,;	// [1]Numero do Banco
				"Banco Itaú S.A."     ,; // [2]Nome do Banco
				Substr(SEE->EE_AGENCIA,1,4)   ,;	// [3]Agência
				Alltrim(SEE->EE_CONTA),; 	// [4]Conta Corrente -2
				Alltrim(SEE->EE_DVCTA),; 	// [5]Dígito da conta corrente
				_cCarteira ,; // [6]Codigo da Carteira
				"7" ,; // [7] Digito do Banco
				"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ" ,; // [8] Local de Pagamento1
				"APÓS O VENCIMENTO, SOMENTE NAS AGÊNCIAS DO ITAÚ",; // [9] Local de Pagamento2
				SEE->EE_DVAGE,;//[10] Digito Verificador da agencia
				_cConvenio,;	//[11] Código Beneficiario fornecido pelo Banco
				AllTrim(SEE->EE_XLOGO) }	//[12] Logo impressa no boleto salvo em /system
			ElseIf SEE->EE_CODIGO == '336'// C6 BANK
				aDadosBanco  := {'336'          ,;	// [1]Numero do Banco
				"Banco C6"     ,; // [2]Nome do Banco
				Substr(SEE->EE_AGENCIA,1,4)   ,;	// [3]Agência
				Alltrim(SEE->EE_CONTA),; 	// [4]Conta Corrente -2
				Alltrim(SEE->EE_DVCTA),; 	// [5]Dígito da conta corrente
				_cCarteira ,; // [6]Codigo da Carteira
				"1" ,; // [7] Digito do Banco
				"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO C6" ,; // [8] Local de Pagamento1
				"APÓS O VENCIMENTO, SOMENTE NAS AGÊNCIAS DO C6",; // [9] Local de Pagamento2
				SEE->EE_DVAGE,;//[10] Digito Verificador da agencia
				_cConvenio,;	//[11] Código Beneficiario fornecido pelo Banco
				AllTrim(SEE->EE_XLOGO) }	//[12] Logo impressa no boleto salvo em /system

			ElseIf SEE->EE_CODIGO == '237'  // Bradesco
				aDadosBanco  := {SEE->EE_CODIGO          ,;	// [1]Numero do Banco
				"Bradesco S.A."     ,; // [2]Nome do Banco
				Substr(SEE->EE_AGENCIA,1,4)   ,;	// [3]Agência
				Alltrim(SEE->EE_CONTA),; 	// [4]Conta Corrente -2
				Alltrim(SEE->EE_DVCTA),; 	// [5]Dígito da conta corrente
				StrZero(Val(_cCarteira),2) ,; // [6]Codigo da Carteira
				"2" ,; // [7] Digito do Banco
				"ATÉ O VENCIMENTO, PREFERENCIALMENTE NAS AGÊNCIAS BRADESCO" ,; // [8] Local de Pagamento1
				"APÓS O VENCIMENTO, NAS AGÊNCIAS DO BRADESCO",; // [9] Local de Pagamento2
				SEE->EE_DVAGE,;	//[10] Digito Verificador da agencia
				_cConvenio,;	//[11] Código Beneficiario fornecido pelo Banco
				AllTrim(SEE->EE_XLOGO) }	//[12] Logo impressa no boleto salvo em /system


			ElseIf SEE->EE_CODIGO == '033'  				// Santander
				aDadosBanco  := {SEE->EE_CODIGO          	,;	// [1]Numero do Banco
				"SANTANDER S.A."     		,; // [2]Nome do Banco
				AllTrim(SEE->EE_AGENCIA)   ,;	// [3]Agência
				_cConvenio                 ,; //Alltrim(SEE->EE_CONTA),; 	// [4]Conta Corrente -2
				' '                        ,; //Alltrim(SEE->EE_DVCTA),; 	// [5]Dígito da conta corrente ( e para ser vazio )
				_cCarteira                 ,; // [6]Codigo da Carteira
				"7" ,; // [7] Digito do Banco
				"ATÉ O VENCIMENTO, PREFERENCIALMENTE NAS AGÊNCIAS SANTANDER" ,; // [8] Local de Pagamento1
				"APÓS O VENCIMENTO, SOMENTE NAS AGÊNCIAS DO SANTANDER",; // [9] Local de Pagamento2
				SEE->EE_DVAGE,;	//[10] Digito Verificador da agencia
				_cConvenio,;	//[11] Código Beneficiario fornecido pelo Banco
				AllTrim(SEE->EE_XLOGO) }	//[12] Logo impressa no boleto salvo em /system


			ElseIf SEE->EE_CODIGO == '756'  // Banco Sicoob     ?
				aDadosBanco  := {SEE->EE_CODIGO          ,;		// [1]Numero do Banco
				"SICOOB"     ,; 				// [2]Nome do Banco
				AllTrim(SubStr(SEE->EE_AGENCIA,1,4)) ,;	// [3]Agência
				AllTrim(SEE->EE_CONTA),; 		// [4]Conta Corrente -2
				AllTrim(SEE->EE_DVCTA),; 		// [5]Dígito da conta corrente
				_cCarteira ,; 					// [6]Codigo da Carteira
				"0" ,; 						// [7] Digito do Banco
				"Pagável em qualquer banco até a data de vencimento." ,; // [8] Local de Pagamento1
				"",; // [9] Local de Pagamento2
				"",; 	//[10] Digito Verificador da agencia
				_cConvenio,;	//[11] Código Beneficiario fornecido pelo Banco
				AllTrim(SEE->EE_XLOGO) }	//[12] Logo impressa no boleto salvo em /system

			Elseif SEE->EE_CODIGO = "104" // Caixa //  DATA 07/08/2013

				aDadosBanco  := {SEE->EE_CODIGO          ,;		// [1]Numero do Banco
				"CAIXA"     ,; 				// [2]Nome do Banco
				AllTrim(SubStr(SEE->EE_AGENCIA,1,4)) ,;	// [3]Agência
				AllTrim(SEE->EE_CONTA),; 		// [4]Conta Corrente -2
				AllTrim(SEE->EE_DVCTA),; 		// [5]Dígito da conta corrente
				_cCarteira ,; 					// [6]Codigo da Carteira
				"0" ,; 						// [7] Digito do Banco
				"PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE." ,; // [8] Local de Pagamento1
				"",; // [9] Local de Pagamento2
				SEE->EE_DVAGE,; 	//[10] Digito Verificador da agencia
				_cConvenio,;	//[11] Código Cedente fornecido pelo Banco
				AllTrim(SEE->EE_XLOGO) }	//[12] Logo impressa no boleto salvo em /system
			Elseif SEE->EE_CODIGO = "422" // Safra

				aDadosBanco  := {SEE->EE_CODIGO         ,;		// [1]Numero do Banco
				"SAFRA"     ,; 				// [2]Nome do Banco
				AllTrim(SubStr(SEE->EE_AGENCIA,1,5)) ,;	// [3]Agência
				AllTrim(SEE->EE_CONTA),; 		// [4]Conta Corrente -2
				AllTrim(SEE->EE_DVCTA),; 		// [5]Dígito da conta corrente
				_cCarteira ,; 					// [6]Codigo da Carteira
				"7" ,; 						// [7] Digito do Banco
				"PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE." ,; // [8] Local de Pagamento1
				"",; // [9] Local de Pagamento2
				SEE->EE_DVAGE,; 	//[10] Digito Verificador da agencia
				_cConvenio,;	//[11] Código Cedente fornecido pelo Banco
				AllTrim(SEE->EE_XLOGO) }	//[12] Logo impressa no boleto salvo em /system
			elseIf SEE->EE_CODIGO == '246'  // Banco ABC Brasil
				aDadosBanco  := {SEE->EE_CODIGO          ,;	// [1]Numero do Banco
				"BANCO ABC BRASIL"     ,; // [2]Nome do Banco
				Substr(SEE->EE_AGENCIA,1,4)   ,;	// [3]Agência
				ccontaBB,;
					Alltrim(SEE->EE_DVCTA),; 	// [5]Dígito da conta corrente
				_cCarteira ,; // [6]Codigo da Carteira
				"9" ,; // [7] Digito do Banco
				"ATÉ O VENCIMENTO, PREFERENCIALMENTE EM TODA REDE BANCÁRIA" ,; // [8] Local de Pagamento1
				"APÓS O VENCIMENTO, SOMENTE NAS AGÊNCIAS DO BANCO DO BRASIL",; // [9] Local de Pagamento2
				SEE->EE_DVAGE,; 	//[10] Digito Verificador da agencia
				_cConvenio,;	//[11] Código Beneficiario fornecido pelo Banco
				AllTrim(SEE->EE_XLOGO)}	//[12] Logo impressa no boleto salvo em /system

				_cAgencia  := AllTrim(SEE->EE_AGENCIA) //Agencia
				_cCart     := AllTrim(SEE->EE_CODCART) //Carteira
				_cOperacao := AllTrim(SEE->EE_OPER) //Operacao
				_cNum	   := AllTrim(SEE->EE_FAXATU) //Faixa atual Nosso numero

				If !empty(SE1->E1_NUMBCO)
					_cDigVeri := SE1->E1_XDVNNUM
					_cNum := SE1->E1_NUMBCO
					//_cDigVeri := Dig10ABC(alltrim(SE1->E1_NUMBCO),_cAgencia,_cCart)
					//Else
					//_cNum := StrZero(Val(SEE->EE_FAXATU),10)
					//_cDigVeri  := Dig10ABC(_cNum,_cAgencia,_cCart) // Função que irá calcular nosso numero.
					//_cDigVeri := Dig10ABC(_cNum,_cAgencia,_cCart)
				EndIf
			elseIf SEE->EE_CODIGO == '707'  // Banco Daycoval
				aDadosBanco  := {;
					SEE->EE_CODIGO		     	,;	// [1]Numero do Banco
				"BancoDaycoval"     		,;  // [2]Nome do Banco
				Left(SEE->EE_AGENCIA,4) 	,;	// [3]Agência
				Alltrim(SEE->EE_CONTA)		,; 	// [4]Conta Corrente -2
				Alltrim(SEE->EE_DVCTA)		,; 	// [5]Dígito da conta corrente
				_cCarteira 					,;  // [6]Codigo da Carteira
				"2" 						,;  // [7] Digito do Banco
				"PAGAVEL EM QUALQUER AGENCIA BANCARIA, MESMO APOS VENCIMENTO" ,; // [8] Local de Pagamento1
				"",; 							// [9] Local de Pagamento2
				SEE->EE_DVAGE,; 				//[10] Digito Verificador da agencia
				_cConvenio,;					//[11] Código Beneficiario fornecido pelo Banco
				AllTrim(SEE->EE_XLOGO)}			//[12] Logo impressa no boleto salvo em /system
			Endif

			If Empty(SA1->A1_ENDCOB)
				aDatPagador   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
				AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
				AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
				SA1->A1_EST                                      ,;     	// [5]Estado
				SA1->A1_CEP                                      ,;      	// [6]CEP
				SA1->A1_CGC										 ,;  		// [7]CGC
				SA1->A1_PESSOA									  }     	// [8]PESSOA
			Else
				aDatPagador   := {AllTrim(SA1->A1_NOME)            	,;   	// [1]Razão Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
				AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
				AllTrim(SA1->A1_MUN )	                            ,;   	// [4]Cidade
				SA1->A1_ESTC	                                    ,;   	// [5]Estado
				SA1->A1_CEPC                                        ,;   	// [6]CEP
				SA1->A1_CGC											,;		// [7]CGC
				SA1->A1_PESSOA										 }		// [8]PESSOA
			Endif

			nVlrAbat   :=  SomaAbat(TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_PARCELA,"R",1,,TSE1->E1_CLIENTE,TSE1->E1_LOJA)

			//
			// Incrementa sequencia do nosso numero no parametro banco
			//
			_cont:=0
			DbSelectArea("SE1")
			SE1->( DBSetOrder(1) )
			If SE1->( DBSeek( xFilial("SE1")+TSE1->E1_PREFIXO+TSE1->E1_NUM+TSE1->E1_PARCELA+TSE1->E1_TIPO) )

				If !Empty(SE1->E1_NUMBCO)
					cNroDoc    := Alltrim(SE1->E1_NUMBCO)
					cDigNosso := SE1->E1_XDVNNUM
					_cont:=1
				Endif

			EndIf

			If Empty(cNroDoc)
				If SEE->EE_CODIGO == '001'
					if Len( AllTrim(SEE->EE_CODEMP) ) < 7
						cNroDoc   := StrZero((Val(Alltrim(SEE->EE_FAXATU))+1),5)
						cDigNosso := Dig11BB(AllTrim(SEE->EE_CODEMP)+cNroDoc )		//CALC_di9(SEE->EE_CODEMP+cNosso)
					Elseif Len( AllTrim(SEE->EE_CODEMP) ) == 7
						// PARA CONVENIO TAMANHO 7 (ACIMA DE 1.000.000) NAO SE USA DV DO NOSSO NUMERO
						cNroDoc    := StrZero((Val(Alltrim(SEE->EE_FAXATU))+1),10)
						cDigNosso  := DigitoBB(cNosso) 											//cNosso     := StrZero(Val(AllTrim(SEE->EE_CODEMP)),7)+cNroDoc estava comentado
					Endif

				ElseIf SEE->EE_CODIGO == '336'

					cNroDoc   := StrZero((Val(Alltrim(SEE->EE_FAXATU))+1),10)
					AADD(aPesos,{2,7,6,5,4,3,2,7,6,5,4,3,2})
					cDigNosso := Dig11C6(SEE->EE_CODCART,cNroDoc,aPesos)

				ElseIf SEE->EE_CODIGO == '341' .Or. SEE->EE_CODIGO == '187'
					cNroDoc := StrZero((Val(Alltrim(SEE->EE_FAXATU))+1),8)

					//
					//  IDENTIFICAR PQ RETIRARAM A CARTEIRA PARA CALCULAR O DAC
					//
					cTexto    := aDadosBanco[03] + aDadosBanco[04] + aDadosBanco[6] + cNroDoc
					//cTexto    := Alltrim(aDadosBanco[03]) + Alltrim(aDadosBanco[04]) + cNroDoc
					cDigNosso := Modu10(cTexto)

				ElseIf SEE->EE_CODIGO == '237'
					cNroDoc   := StrZero((Val(Alltrim(SEE->EE_FAXATU))+1),11)
					if aDadosBanco[6] == "02"
						cDigNosso := Modu11(Alltrim(aDadosBanco[6]) + cNroDoc , 7 ,"P")
					else
						cDigNosso := BradMod11(Alltrim(aDadosBanco[6]) + cNroDoc)
					endif

				ElseIf SEE->EE_CODIGO $ '033'	// Santander nosso nr tem o tamanho fixo 12 + digito
					cNroDoc := StrZero((Val(Alltrim(SEE->EE_FAXATU))+1),12)
					cDigNosso := Dig11Santander(@cNroDoc)

				ElseIf SEE->EE_CODIGO $ '756'	// SICOOB nosso nr tem o tamanho fixo 07
					cNroDoc   := StrZero((Val(Alltrim(SEE->EE_FAXATU))+1),7)
					cDigNosso := DigNNSicoob(cNroDoc,AllTrim(SEE->EE_CODEMP),AllTrim(SEE->EE_AGENCIA))

				elseIf SEE->EE_CODIGO $ '104'	//CAIXA nosso nr tem o tamanho fixo 07    DATA 07/08/2013

					If Empty(SE1->E1_NUMBCO)
						cNroDoc	  := RetNN_CX()
						cDigNosso := Modu11(cNroDoc,,"CX")
					Else
						cNroDoc	 := TRANSFORM(SE1->E1_NUMBCO,'@R 99999999999999999-9')
						cDigNosso := Modu11(cNroDoc,,"CX")
					EndIf
				elseIf SEE->EE_CODIGO $ '246'	// Banco ABC Brasil Nosso Numero (cAgencia+cCarteira+cNum)
					/*If !empty(SE1->E1_NUMBCO)
					_cDigVeri := SE1->E1_XDVNNUM
				Else
					//_cDigVeri  := Dig10ABC(_cNum,_cAgencia,_cCart) // Função que irá calcular nosso numero.
					_cDigVeri := Modu10(_cNum,_cAgencia,_cCart)
				EndIf*/
					If Empty(SE1->E1_NUMBCO)
						cNroDoc	  := StrZero(Val(SEE->EE_FAXATU),10)
						_cDigVeri  := Dig10ABC(cNroDoc,_cAgencia,_cCart)
						//cNroDoc	  := RetNN_SF()1
						//cDigNosso := CALC_5p(cNroDoc,,"SF")
						
						cDigNosso := _cDigVeri
					Else
						cNroDoc	  := StrZero(Val(SE1->E1_NUMBCO),10)  //TRANSFORM(SE1->E1_NUMBCO,'@R 99999999999999999-9')
						_cDigVeri  := iif(alltrim(SE1->E1_XDVNNUM) != "", SE1->E1_XDVNNUM,Dig10ABC(cNroDoc,_cAgencia,_cCart))
						//cDigNosso := Modu11(cNroDoc,,"SF")
						//cDigNosso := CALC_5p(cNroDoc,,"SF")
						cDigNosso := _cDigVeri
					EndIf
				elseIf SEE->EE_CODIGO $ '422'	//Banco Safra

					If Empty(SE1->E1_NUMBCO)
						cNroDoc	  := RetNN_SF()
						cDigNosso := Modu11(cNroDoc,,"SF")
					Else
						cNroDoc	  := TRANSFORM(SE1->E1_NUMBCO,'@R 99999999999999999-9')
						cDigNosso := Modu11(cNroDoc,,"SF")


					EndIf
				ElseIf SEE->EE_CODIGO == '707'	//Banco Daycoval - João Vitor TBC
					If Empty(SE1->E1_NUMBCO)
						cNroDoc	  := StrZero(Val(SEE->EE_FAXATU),10)
						cDigNosso := RetDV_DayC(cNroDoc,1)
					Else
						cNroDoc	  := SE1->E1_NUMBCO
						cDigNosso := SE1->E1_XDVNNUM
					EndIf
				Else
					cNroDoc := '9999999999'
				EndIf


				RecLock("SE1",.F.)
				SE1->E1_NUMBCO  := cNroDoc //aNossoN   // Nosso número (Ver fórmula para calculo)
				SE1->E1_XDVNNUM := cDigNosso // incluída para gravar digito verificador do nosso número
				SE1->( MsUnlock())

				// atuliza a faixa atual do parametro banco
				RecLock("SEE",.F.)
				SEE->EE_FAXATU := Soma1(AllTrim(cNroDoc),0)
				SEE->( MsUnlock() )
				//fim

			Endif

			dDtVencRea := TSE1->E1_VENCREA
			nVlSaldo   := (TSE1->E1_SALDO - nVlrAbat + TSE1->E1_SDACRES - TSE1->E1_SDDECRE)
			nVlJuros   := 0
			nVlMulta   := 0

			//Integração Boleto Protheus x RM Simulação Data - 18/08/2018
			if lXOBSRM // Se tem integracao com RM no Boleto

				if cEmpant = '01' .AND. cFilial = '0401'

					dDtVencRea := iif(TSE1->E1_XDTVEBO > TSE1->E1_VENCREA ,TSE1->E1_XDTVEBO,TSE1->E1_VENCREA)

					if TSE1->E1_XDTVEBO > TSE1->E1_VENCREA

						nQtdDiasJ := DateDiffDay(TSE1->E1_VENCREA, TSE1->E1_XDTVEBO)   //Quantidade de Dias de Juros

						//"Apos o Vencimento cobrar multa de 2% e juros de 1%  ao mes"
						nJuros := (nTXPERB/30)/100  //Valor Juros Diario
						nMulta := (nLJMULB/100)   	//Valor Multa

						nVlJuros   := Round( (TSE1->E1_SALDO + TSE1->E1_SDACRES - TSE1->E1_SDDECRE) * (nJuros) * nQtdDiasJ ,2)
						nVlMulta   := Round( (TSE1->E1_SALDO + TSE1->E1_SDACRES - TSE1->E1_SDDECRE) * (nMulta) ,2)

						nVlSaldo		+= nVlJuros 
						nVlSaldo		+= nVlMulta

					EndIf

				EndIf

			EndIf

			//
			//Monta codigo de barras
			//
			aCB_RN_NN    := Ret_cBarra(TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_PARCELA,TSE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4] ,aDadosBanco[5],;
				cNroDoc,nVlSaldo, aDadosBanco[6] ,"9", aDadosBanco	)
			//							cNroDoc,(TSE1->E1_SALDO - nVlrAbat  + TSE1->E1_SDACRES - TSE1->E1_SDDECRE)	, aDadosBanco[6] ,"9"	) //Alterado para Incrementar Juros mais Multa
			//							cNroDoc,(TSE1->E1_VLCRUZ - nVlrAbat  + TSE1->E1_SDACRES - TSE1->E1_SDDECRE)	, aDadosBanco[6] ,"9"	) Diego - 24/06 - alterado para E1_SALDO


			aDadosTit	:= {  TSE1->E1_NUM + AllTrim(TSE1->E1_PARCELA)	,;  		// [1] Número do título
			TSE1->E1_EMISSAO                         	,; 		// [2] Data da emissão do título
			dDataBase          							,;				// [3] Data da emissão do boleto
			dDtVencRea                          	,;   			// [4] Data do vencimento  //Alterado Data 13/08/2015 TSE1->E1_VENCREA --Intg RM
			nVlSaldo  				,;  									// [5] Valor do título
			aCB_RN_NN[3]                       			,;  		// [6] Nosso número (Ver fórmula para calculo) // de 3 coloquei 9
			TSE1->E1_PREFIXO							,;  				// [7] Prefixo da NF
			"DM"										,;						// [8] Tipo do Titulo
			(TSE1->E1_SALDO + TSE1->E1_SDACRES - TSE1->E1_SDDECRE) * (TSE1->E1_DESCFIN/100)  }		// [9] Desconto financeiro


			//------------------------------------------------------------------------------------------------------------------------------
			//				TEXTO PADRAO PARA MSG NO CORPO DO BOLETO
			//------------------------------------------------------------------------------------------------------------------------------

			//     aBolText[1] := iif( Empty(aBolText[1]),"", aBolText[1])

			//	    aBolText[2] := "ATENÇÃO SR. CAIXA: "

			if nLJMULTA > 0
				if cEmpant = '01' .AND. cFilial = '0401'
					aBolText[3] := iif(DTOS(dDatabase) > DTOS(TSE1->E1_VENCTO)," ","Apos o Vencimento cobrar multa de 2% e juros de 1%  ao mes")
				Else
					aBolText[3] := "Após Vencimento, Multa de "+ Transform(nLJMULTA,"@R 99.99%") +" no Valor de R$ "+AllTrim(Transform(( (TSE1->E1_SALDO + TSE1->E1_SDACRES - TSE1->E1_SDDECRE) * (nLJMULTA/100)),"@E 99,999.99"))
				EndIf
			Endif

			if nTXPER > 0
				if cEmpant = '01' .AND. cFilial = '0401' //Cepalgo
					//	aBolText[4] := "Mora Diária de "+ Transform(nTXPER,"@R 99.99%") +" no valor de R$ "+AllTrim(Transform(( ( TSE1->E1_SALDO*nTXPER )/100),"@E 99,999.99"))+"."
				Else
					aBolText[4] := "Juros por dia de atraso: R$ "+AllTrim(Transform(( ( (TSE1->E1_SALDO + TSE1->E1_SDACRES - TSE1->E1_SDDECRE)*nTXPER )/100),"@E 99,999.99"))+" Apos: "+DtoC(TSE1->E1_VENCREA)
				EndIf
			Endif

			if Alltrim(SEE->EE_CONTA) == "002218440"//tratamento para nova conta ABC
				aBolText[3] := "Multa de 2,00% a partir de: "+DtoC(TSE1->E1_VENCREA)                 
				aBolText[4] := "Juros por dia de atraso: R$ "+AllTrim(Transform(( ( (TSE1->E1_SALDO + TSE1->E1_SDACRES - TSE1->E1_SDDECRE)*nTXPER )/100),"@E 99,999.99"))+" Apos: "+DtoC(TSE1->E1_VENCREA)
			EndIf

			if cEmpant = '01' .AND. cFilial = '0401'
				aBolText[2] := "Dpto Financeiro (62) 3923 8056 / E-Mail: paulo.almeida@scodro.com.br"
				aBolText[4] :=  Alltrim(TSE1->E1_HIST)
				aBolText[5] := 'N.Parcela '+Alltrim(TSE1->E1_XOBSRM)+iif(!Empty(TSE1->E1_PEDIDO),' / Ped.Venda '+Alltrim(TSE1->E1_PEDIDO)+'/','')+iif(DTOS(dDatabase) > DTOS(TSE1->E1_VENCTO),"   NÃO RECEBER APÓS O VENCIMENTO.","   NÃO RECEBER APÓS 30 DIAS DO VENCIMENTO.")
			EndIf
			if cEmpant = '01' .AND. xFilial() = '2001'
				if aDadosTit[9] > 0  .and. aDadosTit[4] >= dDataBase
					aBolText[5] := "Desconto concedido de R$ "+AllTrim(Transform(aDadosTit[9] ,"@E 99,999.99"))+" para pagamento até a data de vencimento."
				endif
			endif
			//------------------------------------------------------------------------------------------------------------------------------

			Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatPagador,aBolText,aCB_RN_NN,cNroDoc)
			nX := nX + 1

		EndIf

		TSE1->( dbSkip() )
		IncProc()
		nI += 1

	Enddo

	oPrint:Preview()		// Visualiza antes de imprimir
Return .T.

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³  Impress ³ Autor ³ Kesley M Martins      ³ Data ³ 19/07/07 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri??o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ TOTVS                                                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatPagador,aBolText,aCB_RN_NN,aNossoN)
	LOCAL oFont8
	LOCAL oFont11c
	LOCAL oFont10
	LOCAL oFont14
	LOCAL oFont16n
	LOCAL oFont15
	LOCAL oFont14n
	LOCAL oFont24
	LOCAL nI := 0
	LOCAL cDigVer

	//Parametros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)

	oFont8   := TFont():New("Arial",9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8n  := TFont():New("Arial",9, 8,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10  := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10n := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11  := TFont():New("Arial",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11n := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12  := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont12n := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14  := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15  := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15n := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20  := TFont():New("Arial",9,20,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont21  := TFont():New("Arial",9,21,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24  := TFont():New("Arial",9,24,.T.,.F.,5,.T.,5,.T.,.F.)

	oPrint:StartPage()   // Inicia uma nova página

	/******************/
	/* PRIMEIRA PARTE */
	/******************/
	nRow1 := 0

	oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
	oPrint:Line (nRow1+0150,710,nRow1+0070, 710)

	if Empty(aDadosBanco[12])
		oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont12 )						// [2]Nome do Banco
	else
		oPrint:SayBitmap(nRow1+0080,100,aDadosBanco[12],400,075)					// Mostra Figura do Banco
	endif
	oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-"+aDadosBanco[7] ,oFont20 )	// [1]Numero do Banco   + [7] DV Banco

	oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10n)
	oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

	oPrint:Say  (nRow1+0150,100 ,"Beneficiario",oFont8)
	oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10n)				//Nome + CNPJ

	oPrint:Say  (nRow1+0150,1060,"Agência/Código Beneficiario",oFont8)

	If aDadosBanco[1] == "422" //Leandro

		_cCarteira := ""
		_cAgencia  := ""
		_cOperacao := ""
		_cFaixaBc  := ""

		oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+"001402031",oFont10n)
	ElseIf aDadosBanco[1] == "336" //C6
		oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+SUBSTR(aDadosBanco[11],5,LEN(aDadosBanco[11])),oFont10n)
	Else
		oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+iif(!Empty(aDadosBanco[10]),"-"+aDadosBanco[10],"")+"/"+iif(!Empty(aDadosBanco[11]),aDadosBanco[4]+iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""), aDadosBanco[11]) ,oFont10n)
	EndIf
	
	oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
	If aDadosBanco[1] == "336" //C6
		oPrint:Say  (nRow1+0200,1510,STRZERO(VAL(aDadosTit[1]),10),oFont10n) //Numero+Parcela 10 posicoes
	Else
		oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10n) //Prefixo +Numero+Parcela
	EndIf

	oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
	oPrint:Say  (nRow1+0300,100 ,aDatPagador[1],oFont10n)				//Nome

	oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
	oPrint:Say  (nRow1+0300,1060,StrZero(Day((aDadosTit[4])),2) +"/"+ StrZero(Month((aDadosTit[4])),2) +"/"+ Right(Str(Year((aDadosTit[4]))),4),oFont10n)

	oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
	oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10n)

	oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título",oFont10)
	oPrint:Say  (nRow1+0450,0100,"com as características acima.",oFont10)
	oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
	oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
	oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
	oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)

	oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
	oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
	oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
	oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

	oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
	oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
	oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
	oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

	oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
	oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                    ,oFont8)
	oPrint:Say  (nRow1+0245,1910,"(  )Não existe nº indicado"                  	,oFont8)
	oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
	oPrint:Say  (nRow1+0325,1910,"(  )Não procurado"                              ,oFont8)
	oPrint:Say  (nRow1+0365,1910,"(  )Endereço insuficiente"                	  	,oFont8)
	oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
	oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                   ,oFont8)
	oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                  	,oFont8)


	/*****************/
	/* SEGUNDA PARTE */
	/*****************/
	nRow2 := 0

	//Pontilhado separador
	For nI := 100 to 2300 step 50
		oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
	Next nI

	oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
	oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
	oPrint:Line (nRow2+0710,710,nRow2+0630, 710)

	if Empty(aDadosBanco[12])
		oPrint:Say  (nRow2+0644,100,aDadosBanco[2],oFont12 )		// [2]Nome do Banco
	else
		oPrint:SayBitmap(nRow2+0630,100,aDadosBanco[12],400,075)	// Figura do Banco do Brasil
	endif
	oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-"+aDadosBanco[7],oFont20 )	// [1]Numero do Banco
	oPrint:Say  (nRow2+0644,1800,"Recibo do Pagador",oFont10n)

	oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
	oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
	oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
	oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )

	oPrint:Line (nRow2+0910,500,nRow2+1050,500)
	oPrint:Line (nRow2+0980,750,nRow2+1050,750)
	oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
	oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
	oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

	oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow2+0725,400 ,aDadosBanco[8] ,oFont10n)
	oPrint:Say  (nRow2+0765,400 ,aDadosBanco[9] ,oFont10n)

	oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
	cString	:= StrZero(Day((aDadosTit[4])),2) +"/"+ StrZero(Month((aDadosTit[4])),2) +"/"+ Right(Str(Year((aDadosTit[4]))),4)
	nCol := 1850+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0750,nCol,cString,oFont12n)

	oPrint:Say  (nRow2+0810,100 ,"Beneficiario"                                        ,oFont8)

	If aDadosBanco[1] == "246"
		//oPrint:Say  (nRow2+0850,100 ,Alltrim(aDadosEmp[1])+"  "+Alltrim(aDadosEmp[6])+"  "+AllTrim(aDadosEmp[2])+"  "+AllTrim(aDadosEmp[3])+"  "+AllTrim(aDadosEmp[4]),oFont8n) //Informações completas
		oPrint:Say  (nRow2+0850,100 ,Alltrim(aDadosEmp[1])+"  "+Alltrim(aDadosEmp[6])+"  "+AllTrim(aDadosEmp[2]),oFont8n) //Informações completas
		oPrint:Say  (nRow2+0880,100 ,AllTrim(aDadosEmp[3])+"  "+AllTrim(aDadosEmp[4]),oFont8n) //Informações completas
	Else
		oPrint:Say  (nRow2+0850,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10n) //Nome + CNPJ
	EndIf

	oPrint:Say  (nRow2+0810,1810,"Agência/Código Beneficiario",oFont8)   //Leandro

	If aDadosBanco[1] == "422" //Leandro
		cString := Alltrim(aDadosBanco[3]+"/001402031")
	ElseIf aDadosBanco[1] == "336" //C6
		cString := ALLTRIM(aDadosBanco[3]+"/"+SUBSTR(aDadosBanco[11],5,LEN(aDadosBanco[11])))
	Else
		cString := Alltrim(aDadosBanco[3]+iif(!Empty(aDadosBanco[10]),"-"+aDadosBanco[10],"")+"/"+iif(!Empty(aDadosBanco[11]),aDadosBanco[4]+iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""), aDadosBanco[11]) )
	EndIf

	//cString := Alltrim(aDadosBanco[3]+iif(!Empty(aDadosBanco[10]),"-"+aDadosBanco[10],"")+"/"+iif(!Empty(aDadosBanco[11]),aDadosBanco[4]+iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""), aDadosBanco[11]) )
	nCol := 1830+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say  (nRow2+0940,100, StrZero(Day((aDadosTit[2])),2) +"/"+ StrZero(Month((aDadosTit[2])),2) +"/"+ Right(Str(Year((aDadosTit[2]))),4),oFont10n)

	oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
	If aDadosBanco[1] == "336" //C6
		oPrint:Say  (nRow2+0940,605,STRZERO(VAL(aDadosTit[1]),10),oFont10n) //Numero+Parcela 10 posicoes
	Else
		oPrint:Say  (nRow2+0940,605,aDadosTit[7]+aDadosTit[1],oFont10n) //Prefixo +Numero+Parcela
	EndIf

	oPrint:Say  (nRow2+0910,1005,"Espécie Doc."                                   ,oFont8)
	oPrint:Say  (nRow2+0940,1050,aDadosTit[8]										,oFont10n) //Tipo do Titulo

	oPrint:Say  (nRow2+0910,1305,"Aceite"                                         ,oFont8)
	oPrint:Say  (nRow2+0940,1400,"N"                                             ,oFont10n)

	oPrint:Say  (nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (nRow2+0940,1550,StrZero(Day((aDadosTit[3])),2) +"/"+ StrZero(Month((aDadosTit[3])),2) +"/"+ Right(Str(Year((aDadosTit[3]))),4),oFont10n) // Data impressao

	oPrint:Say  (nRow2+0910,1810,"Nosso Número"                                   ,oFont8)

// nosso numero
	if aDadosBanco[__NPOSNRBCO] == '246' //Banco Abc Nosso Número
	//	cDigVer := Dig10ABC(_cNum,_cAgencia,_cCart) //aqui
		cString := Alltrim(Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)+"-"+_cDigVeri)
	Elseif aDadosBanco[__NPOSNRBCO] == '707' //Banco Daycoval Nosso Número
		//O Nosso Número será a concatenação do código da agência (com DV), da carteira, do nosso número e do DV do nosso número.
		//No exemplo: 00019/121/0004309540-8.
		cString := aCB_RN_NN[03]
	else
		cString := Alltrim(Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4))
	endif

	//nCol := 1820+(374-(len(cString)*22))
	if aDadosBanco[__NPOSNRBCO] == '707'
		nCol := 1800
	Else
		nCol := 1890+(374-(len(cString)*22))
	Endif

	oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0980,100 ,"Uso do Banco"                                   ,oFont8)

	oPrint:Say  (nRow2+0980,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6]                                  	,oFont10n)

	oPrint:Say  (nRow2+0980,755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (nRow2+1010,805 ,"R$"                                             ,oFont10n)

	oPrint:Say  (nRow2+0980,1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (nRow2+0980,1485,"Valor"                                          ,oFont8)

	oPrint:Say  (nRow2+0980,1810,"Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol := 1840+(374-(len(cString)*22))
	oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

	oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiario)",oFont8)

	oPrint:Say  (nRow2+1100,100 ,aBolText[1],oFont10n)	// 1150
	oPrint:Say  (nRow2+1150,100 ,aBolText[2],oFont10n)	// 1200
	oPrint:Say  (nRow2+1200,100 ,aBolText[3],oFont10n)	// 1250
	oPrint:Say  (nRow2+1250,100 ,aBolText[4],oFont10n)	// 1300
	oPrint:Say  (nRow2+1300,100 ,aBolText[5],oFont10n)	// 1300

	// MSG dos Parametros
	if !Empty(MV_PAR21)
		oPrint:Say  (nRow2+1350,100, AllTrim(MV_PAR21) + " - " + AllTrim(MV_PAR22),oFont10n)
	endif

	oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"                           ,oFont8)
	oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)

	if aDadosTit[9] > 0 .and. aDadosTit[4] >= dDataBase
		cString := Alltrim(Transform( aDadosTit[9],"@E 999,999,999.99"))
		nCol 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+1080,nCol,cString,oFont11c)
	endif

	oPrint:Say  (nRow2+1400,100 ,"Pagador"                                          ,oFont8)

	If  aDadosBanco[1] == "422"   //Safra
		oPrint:Say  (nRow2+1430,100 ,aDatPagador[1]+" CNPJ: "+aDatPagador[7],oFont10n) //Nome + Cnpj+ Endereco+CEP+Cidade+Estado
		oPrint:Say  (nRow2+1460,100 ,aDatPagador[3]+" "+aDatPagador[6]+" "+aDatPagador[4]+" "+aDatPagador[5],oFont10n) //Nome + Cnpj+ Endereco+CEP+Cidade+Estado
	Else
		oPrint:Say  (nRow2+1430,400 ,aDatPagador[1]+" ("+aDatPagador[2]+")"             ,oFont10n)
		oPrint:Say  (nRow2+1483,400 ,aDatPagador[3]                                     ,oFont10n)
		oPrint:Say  (nRow2+1536,400 ,aDatPagador[6]+"    "+aDatPagador[4]+" - "+aDatPagador[5],oFont10n) // CEP+Cidade+Estado

		if aDatPagador[8] = "J"
			oPrint:Say  (nRow2+1589,400 ,"CNPJ: "+TRANSFORM(aDatPagador[7],"@R 99.999.999/9999-99"),oFont10n) // CGC
		Else
			oPrint:Say  (nRow2+1589,400 ,"CPF: "+TRANSFORM(aDatPagador[7],"@R 999.999.999-99"),oFont10n) 	// CPF
		EndIf
	End
	//oPrint:Say  (nRow2+1589,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

	If  aDadosBanco[1] == "422"   //Safra
		oPrint:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
		oPrint:Say  (nRow2+1645,1500,"Autenticação Mecânica",oFont8)
	Else
		oPrint:Say  (nRow2+1605,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow2+1645,1500,"Autenticação Mecânica",oFont8)
	EndIf

	oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
	oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
	oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
	oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
	oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
	oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
	oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )


	/******************/
	/* TERCEIRA PARTE */
	/******************/

	nRow3 := 0 //-150

	For nI := 100 to 2300 step 50
		oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
	Next nI

	oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
	oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
	oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

	if Empty(aDadosBanco[12])
		oPrint:Say  (nRow3+1934,100,aDadosBanco[2],oFont12 )		// 	[2]Nome do Banco
	else
		oPrint:SayBitmap(nRow3+1922,100,aDadosBanco[12],400,075)			// [2]Nome do Banco
	endif
	oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-"+aDadosBanco[7],oFont20 )	// 	[1]Numero do Banco
	oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont14n)			//	Linha Digitavel do Codigo de Barras

	oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
	oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
	oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
	oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

	oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
	oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
	oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
	oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
	oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

	oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow3+2015,400 ,aDadosBanco[8],oFont10n)
	oPrint:Say  (nRow3+2055,400 ,aDadosBanco[9],oFont10n)

	oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
	cString := StrZero(Day((aDadosTit[4])),2) +"/"+ StrZero(Month((aDadosTit[4])),2) +"/"+ Right(Str(Year((aDadosTit[4]))),4)
	nCol	 	 := 1850+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2040,nCol,cString,oFont12)

	oPrint:Say  (nRow3+2100,100 ,"Beneficiario",oFont8)

	If aDadosBanco[1] == "246"
		//oPrint:Say  (nRow3+2140,100 ,Alltrim(aDadosEmp[1])+"  "+Alltrim(aDadosEmp[6])+"  "+AllTrim(aDadosEmp[2])+"  "+AllTrim(aDadosEmp[3])+"  "+AllTrim(aDadosEmp[4]),oFont8n) //Informações completas
		oPrint:Say  (nRow3+2140,100 ,Alltrim(aDadosEmp[1])+"  "+Alltrim(aDadosEmp[6])+"  "+AllTrim(aDadosEmp[2]),oFont8n) //Informações completas
		oPrint:Say  (nRow3+2170,100 ,AllTrim(aDadosEmp[3])+"  "+AllTrim(aDadosEmp[4]),oFont8n) //Informações completas
	Else
		oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10n) //Nome + CNPJ leandro
	EndIf

	oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiario",oFont8) //

	If aDadosBanco[1] == "422"
		cString := Alltrim(aDadosBanco[3]+"/001402031")
	ElseIf aDadosBanco[1] == "336" //C6
		cString := ALLTRIM(aDadosBanco[3]+"/"+SUBSTR(aDadosBanco[11],5,LEN(aDadosBanco[11])))
	Else
		cString := Alltrim(aDadosBanco[3]+iif(!Empty(aDadosBanco[10]),"-"+aDadosBanco[10],"")+"/"+iif(!Empty(aDadosBanco[11]),aDadosBanco[4]+iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""), aDadosBanco[11]) )
	EndIf

	//cString := Alltrim(aDadosBanco[3]+iif(!Empty(aDadosBanco[10]),"-"+aDadosBanco[10],"")+"/"+iif(!Empty(aDadosBanco[11]),aDadosBanco[4]+iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""), aDadosBanco[11]))
	nCol 	 := 1830+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)

	oPrint:Say  (nRow3+2200,100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say (nRow3+2230,100, StrZero(Day((aDadosTit[2])),2) +"/"+ StrZero(Month((aDadosTit[2])),2) +"/"+ Right(Str(Year((aDadosTit[2]))),4), oFont10n)


	oPrint:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
	If aDadosBanco[1] == "336" //C6
		oPrint:Say  (nRow3+2230,605,STRZERO(VAL(aDadosTit[1]),10),oFont10n) //Numero+Parcela 10 posicoes
	Else
		oPrint:Say  (nRow3+2230,605,aDadosTit[7]+aDadosTit[1],oFont10n) //Prefixo +Numero+Parcela
	EndIf


	oPrint:Say  (nRow3+2200,1005,"Espécie Doc."                                   ,oFont8)
	oPrint:Say  (nRow3+2230,1050,aDadosTit[8]									  				,oFont10n) //Tipo do Titulo

	oPrint:Say  (nRow3+2200,1305,"Aceite"                                         ,oFont8)
	oPrint:Say  (nRow3+2230,1400,"N"                                             	,oFont10n)

	oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (nRow3+2230,1550,StrZero(Day((aDadosTit[3])),2) +"/"+ StrZero(Month((aDadosTit[3])),2) +"/"+ Right(Str(Year((aDadosTit[3]))),4)                               ,oFont10n) // Data impressao


	oPrint:Say  (nRow3+2200,1810,"Nosso Número"                                   ,oFont8)

	if aDadosBanco[1] == '246' //Banco Abc Nosso Número
		//cDigVer := Dig10ABC(_cNum,_cAgencia,_cCart) //aqui
		cString := Alltrim(Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)+"-"+_cDigVeri)// nosso numero
	else
		cString := Alltrim(Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4))// nosso numero
	endif

	/*
	if aDadosBanco[1] == '756' //aqui
	cString := Alltrim(aDadosTit[6])
	else
	cString := Alltrim(Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4))
	endif
	*/

					//cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
					if aDadosBanco[__NPOSNRBCO] == '707'
						nCol := 1800
					Else
						nCol := 1890+(374-(len(cString)*22))
					Endif

					oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)


					oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                   ,oFont8)

					oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
					oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                  	,oFont10n)

					oPrint:Say  (nRow3+2270,755 ,"Espécie"                                        ,oFont8)
					oPrint:Say  (nRow3+2300,805 ,"R$"                                             ,oFont10n)

					oPrint:Say  (nRow3+2270,1005,"Quantidade"                                     ,oFont8)
					oPrint:Say  (nRow3+2270,1485,"Valor"                                          ,oFont8)

					oPrint:Say  (nRow3+2270,1810,"Valor do Documento"                          	,oFont8)
					cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
					nCol 	 := 1840+(374-(len(cString)*22))
					oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

					oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiario)",oFont8)

					oPrint:Say  (nRow3+2390,100 ,aBolText[1],oFont10n)
					oPrint:Say  (nRow3+2440,100 ,aBolText[2],oFont10n)
					oPrint:Say  (nRow3+2490,100 ,aBolText[3],oFont10n)
					oPrint:Say  (nRow3+2540,100 ,aBolText[4],oFont10n)
					oPrint:Say  (nRow3+2590,100 ,aBolText[5],oFont10n)

					if !Empty(MV_PAR21)
						oPrint:Say  (nRow2+2640,100 ,AllTrim(MV_PAR21) + " - " + AllTrim(MV_PAR22),oFont10n)
					endif

					If _cont = 1 .and. Empty(aBolText[4]+aBolText[5])
						oPrint:Say  (nRow3+2590,100 ,"/////ATENÇÃO/////--> SEGUNDA VIA",oFont10n)
					EndIf

					oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                         ,oFont8)
					oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"                             ,oFont8)
					oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                  ,oFont8)
					oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"                           ,oFont8)
					oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                               ,oFont8)

					oPrint:Say  (nRow3+2690,100 ,"Pagador"                                          ,oFont8)

					If  aDadosBanco[1] == "422"   //Safra
						oPrint:Say  (nRow3+2730,100 ,aDatPagador[1]+" CNPJ: "+aDatPagador[7],oFont10n) //Nome + Cnpj
						oPrint:Say  (nRow3+2760,100 ,aDatPagador[3]+" "+aDatPagador[6]+" "+aDatPagador[4]+" "+aDatPagador[5],oFont10n) //Endereco+CEP+Cidade+Estado
					Else
						oPrint:Say  (nRow3+2700,400 ,aDatPagador[1]+" ("+aDatPagador[2]+")"             ,oFont10n)
						oPrint:Say  (nRow3+2753,400 ,aDatPagador[3]                                     ,oFont10n)
						oPrint:Say  (nRow3+2806,400 ,Transform(aDatPagador[6],"@R 99.999-999")+"    "+aDatPagador[4]+" - "+aDatPagador[5],oFont10n) // CEP+Cidade+Estado

						if aDadosTit[9] > 0  .and. aDadosTit[4] >= dDataBase
							cString := Alltrim(Transform(aDadosTit[9],"@E 999,999,999.99"))
							nCol 	 := 1810+(374-(len(cString)*22))
							oPrint:Say  (nRow3+2370,nCol,cString,oFont11c)
						endif

					End

					If  aDadosBanco[1] == "422"   //Safra
						oPrint:Say  (nRow3+2875,100 ,"Sacador/Avalista"                               ,oFont8)
					Else
						oPrint:Say  (nRow3+2875,100 ,"Pagador/Avalista"                               ,oFont8)
					EndIf

					If  aDadosBanco[1] == "422"   //Safra

					Else
						if aDatPagador[8] = "J"
							oPrint:Say  (nRow3+2875,400 ,"CNPJ: "+TRANSFORM(aDatPagador[7],"@R 99.999.999/9999-99"),oFont10n) // CGC
						Else
							oPrint:Say  (nRow3+2875,400 ,"CPF: "+TRANSFORM(aDatPagador[7],"@R 999.999.999-99"),oFont10n) 	// CPF
						EndIf
					EndIf

					oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
					oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
					oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
					oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
					oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
					oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )

					oPrint:Line (nRow3+2920,100,nRow3+2920,2300  )
					oPrint:Say  (nRow3+2935,1500,"Autenticação Mecânica - Ficha de Compensação"   ,oFont8)

					MSBAR("INT25",26,1.6,aCB_RN_NN[1],oPrint,.F.,,,,1.5,,,,.F.)
					//MSBAR("INT25",13,1.6,aCB_RN_NN[1],oPrint,.F.,,,,1.5,,,,.F.)    //descomentada luis
					//MSBAR("INT25",1,1,aCB_RN_NN[1],oPrint,.F.,,,0.0107,0.64,,,,.F.) // folha A4 - driver windows 2000 server
					oPrint:EndPage() // Finaliza a página

					Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RetDados  ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o codigo de barras.        					          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ret_cBarra(	cPrefixo	,cNumero	,cParcela	,cTipo	,;
		cBanco		,cAgencia	,cConta		,cDacCC	,;
		cNroDoc		,nValor		,cCart		,cMoeda , aDadosBanco	)
	Local cNosso		:= ""
	Local NNUM			:= ""
	Local cCampoL		:= ""
	Local cFatorValor	:= ""
	Local cLivre		:= ""
	Local cDigBarra     := ""
	Local cBarra		:= ""
	Local cParte1		:= ""
	Local cDig1			:= ""
	Local cParte2		:= ""
	Local cDig2			:= ""
	Local cParte3		:= ""
	Local cDig3			:= ""
	Local cParte4		:= ""
	Local cParte5		:= ""
	Local cDigital		:= ""
	Local cTexto        := ""
	Local aRet			:= {}
	Local xPesos        := {}

	public digito

	if cBanco == '187' // Diego Bueno - 19/06 - Na implantacao do Protheus na Cepalgo, cadastraram o ITau com codigo 187.... putz!
		cBanco := '341'
	endif

	//DEFAULT nValor := 0
	If cBanco == '422' // Safra
		cAgencia   := StrZero(Val(cAgencia),5)
		cNosso     := ""
	Else
		cAgencia   := StrZero(Val(cAgencia),4)
		cNosso     := ""
	EndIf

	If cBanco == '001' .and. len( AllTrim(_cConvenio) ) == 6 	// Banco do Brasil
		//
		// CONVENIO 6 POSICOES
		//

		cConta	   := StrZero( val(cConta),8)
		cNosso     := _cConvenio + cNroDoc
		cDigNosso  := CALC_di9(cNosso)
		cCart      := cCart

		//campo livre do codigo de barra                   // verificar a conta
		If nValor > 0
			cFatorValor  := fator()+strzero(nValor*100,10)
		Else
			cFatorValor  := fator()+strzero((SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE)*100,10)
		Endif

		// campo livre
		cCampoL    := _cConvenio + cNroDoc + cAgencia + cConta + cCart

		// campo do digito verificador do codigo de barra
		cLivre := cBanco+cMoeda+cFatorValor+cCampoL
		cDigBarra := ( cLivre )

		// campo do codigo de barra
		cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5,40)

		// composicao da linha digitavel
		If cBanco == '246' // ABC do Brasil
			cParte1  := cBanco + cMoeda + Substr(_cConvenio,1,5)
			cDig1    := DIGIT001( cParte1 )
			cParte1  := cParte1 + cDig1

			cParte2  := SUBSTR(cCampoL,6,10)	//cNroDoc + cAgencia
			cDig2    := DIGIT001( cParte2 )
			cParte2  := cParte2 + cDig2

			cParte3  := SUBSTR(cCampoL,16,10)
			cDig3    := DIGIT001( cParte3 )
			cParte3  := cParte3 + cDig3

			cParte4  := cDigBarra
			cParte5  := cFatorValor

			cDigital :=  substr(cParte1,1,5)+"."+substr(cparte1,6,5)+" "+;
				substr(cParte2,1,5)+"."+substr(cparte2,6,6)+" "+;
				substr(cParte3,1,5)+"."+substr(cparte3,6,6)+" "+;
				cParte4+" "+;
				cParte5
		Else
			cParte1  := cBanco + cMoeda + Substr(_cConvenio,1,5)
			cDig1    := DIGIT001( cParte1 )
			cParte1  := cParte1 + cDig1

			cParte2  := SUBSTR(cCampoL,6,10)	//cNroDoc + cAgencia
			cDig2    := DIGIT001( cParte2 )
			cParte2  := cParte2 + cDig2

			cParte3  := SUBSTR(cCampoL,16,10)
			cDig3    := DIGIT001( cParte3 )
			cParte3  := cParte3 + cDig3

			cParte4  := cDigBarra
			cParte5  := cFatorValor

			cDigital :=  substr(cParte1,1,5)+"."+substr(cparte1,6,5)+" "+;
				substr(cParte2,1,5)+"."+substr(cparte2,6,6)+" "+;
				substr(cParte3,1,5)+"."+substr(cparte3,6,6)+" "+;
				cParte4+" "+;
				cParte5
		EndIf

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)


	elseif cBanco == '001' .and. len( AllTrim(_cConvenio) ) == 7
		//
		// CONVENIO 7 POSICOES
		//

		cNosso     := StrZero(Val(_cConvenio),7)+StrZero(Val(cNroDoc),10)
		// PARA CONVENIO TAMANHO 7 (ACIMA DE 1.000.000) NAO SE USA DV DO NOSSO NUMERO
		// cDigNosso  := CALC_di9(cNosso)
		cCart      := cCart

		// campo livre
		cCampoL    := StrZero(Val(_cConvenio),13)+strzero(Val(cNroDoc),10)+cCart

		//campo livre do codigo de barra                   // verificar a conta
		If nValor > 0
			cFatorValor  := fator()+strzero(nValor*100,10)
		Else
			cFatorValor  := fator()+strzero((SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE)*100,10)
		Endif

		// campo do digito verificador do codigo de barra
		cLivre := cBanco+cMoeda+cFatorValor+cCampoL
		cDigBarra := CALC_5p( cLivre )

		// campo do codigo de barra
		cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5,40)

		// composicao da linha digitavel
		cParte1  := cBanco+cMoeda+Strzero(val(Substr(cBarra,4,1)),6)
		cDig1    := DIGIT001( cParte1 )

		cParte2  := SUBSTR(cCampoL,6,10) // alterado aqui cParte2  := SUBSTR(cCampoL,7,10)
		cDig2    := DIGIT001( cParte2 )
		cParte2  := cParte2 + cDig2

		cParte3  := SUBSTR(cCampoL,16,10)
		cDig3    := DIGIT001( cParte3 )
		cParte3  := cParte3 + cDig3

		cParte4  := cDigBarra
		cParte5  := cFatorValor

		cDigital :=  substr(cParte1,1,5)+"."+substr(cparte1,6,5)+" "+;
			substr(cParte2,1,5)+"."+substr(cparte2,6,6)+" "+;
			substr(cParte3,1,5)+"."+substr(cparte3,6,6)+" "+;
			cParte4+" "+;
			cParte5

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)

	ElseIf cBanco == '336' // Banco C6
		//
		// CONVENIO 6 POSICOES
		//

		// Calcula Fator de Vecimento + o Valor do Documento
		// DateDiffDay( SE1->E1_VENCTO , CTOD("07/10/1997") )
		If nValor > 0
			cFatorValor  := fator()+strzero(nValor*100,10)//CVALTOCHAR(DateDiffDay( SE1->E1_VENCTO , CTOD("07/10/1997") ))+strzero(nValor*100,10)
		Else
			cFatorValor  := fator()+strzero((SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE)*100,10)//CVALTOCHAR(DateDiffDay( SE1->E1_VENCTO , CTOD("07/10/1997") ))+strzero((SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE)*100,10)
		Endif

		// Codigo de Barras
		cLivre := cBanco+cMoeda+cFatorValor
		cLivre += Strzero(VAL(_cConvenio),12) + cNroDoc + SUBSTR(cCart,2,2) + "4"

		AADD(xPesos,{4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2})
		// Passando as 43 posicao do codigo de barras e seus pesos
		cDigBarra := Mod11C6B9(cLivre,xPesos)
		cBarra    := SUBSTR(cLivre,1,4) + cDigBarra + SUBSTR(cLivre,5,43)
		//Fim Codigo de barras

		// Codigo de Barras Digitavel
		cLivre := cBanco+cMoeda
		//5 primeiras posições do código do cedente
		cLivre += SUBSTR(ALLTRIM(_cConvenio),1,5)
		//Dígito Verificador Módulo 10 (Campo 1)
		cParte1  := cBanco + cMoeda + SUBSTR(ALLTRIM(_cConvenio),1,5)
		cLivre   += DIGIT001( cParte1)
		// 7 Ultimas posicao codigo cedente
		cLivre += IIF( LEN(_cConvenio)>7, SUBSTR( _cConvenio, (LEN(_cConvenio) - 7 + 1 ), 7 ), StrZero(VAL(_cConvenio),7))
		// 3 primeiras posicao nosso numero
		cLivre += SUBSTR(cNroDoc,1,3)
		//Dígito Verificador Módulo 10 (Campo 2)
		cPart2 := IIF( LEN(_cConvenio)>7, SUBSTR( _cConvenio, (LEN(_cConvenio) - 7 + 1 ), 7 ), StrZero(VAL(_cConvenio),7) ) + SUBSTR(cNroDoc,1,3)
		cLivre += DIGIT001( cPart2)
		// 7 ultimas posicao nosso numero
		cLivre += SUBSTR( cNroDoc, (LEN(cNroDoc) - 7 + 1 ), 7 )
		// 2 ultima posicao cod carteira
		cLivre += SUBSTR(cCart,2,2)
		// Identificador de Layout
		// 3 para cobrança registrada com emissão
		// 4 para cobrança direta com emissão pelo cedente
		cLivre += "4"
		//Dígito Verificador Módulo 10 (Campo 3)
		cPart3 := SUBSTR( cNroDoc, (LEN(cNroDoc) - 7 + 1 ), 7 ) + SUBSTR(cCart,2,2) + "4"
		cLivre += DIGIT001( cPart3)
		//Digito Verificador Geral Que foi Calculado para Codigo de Barras
		cLivre += cDigBarra
		//Fator de Vecimento e Valor do Documento mesmo utilizado para codigo de barras
		cLivre	 += cFatorValor
		//Formatando Codigo Digitavel
		cDigital := SUBSTRING(cLivre,1,5) + "." + SUBSTRING(cLivre,6,5)
		cDigital += SUBSTRING(cLivre,11,5) + "." + SUBSTRING(cLivre,16,6)
		cDigital += SUBSTRING(cLivre,22,5) + "." + SUBSTRING(cLivre,27,6)
		cDigital += " " + SUBSTRING(cLivre,33,1) + " "
		cDigital += SUBSTRING(cLivre,34,14)
		// Fim Codigo de Barras Digitavel

		cConta	   := StrZero( val(cConta),8)
		cNosso     := cNroDoc
		cCart      := cCart

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)

	ElseIf cBanco == '341' // Itau

		If cCart $ '126/131/146/150/168'
			cTexto := cCart + cNroDoc
		Else
			cTexto := cAgencia + cConta + cCart + cNroDoc
		EndIf

		cTexto2 := cAgencia + cConta

		cDigCC  := Modu10(cTexto2)

		cNosso    := cCart + '/' + cNroDoc + '-' + cDigNosso
		cCart     := cCart

		If nValor > 0
			cFatorValor  := fator()+strzero(nValor*100,10)
		Else
			cFatorValor  := fator()+strzero((SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE)*100,10)
		Endif

		cValor:= StrZero(nValor * 100, 10)

		/* Calculo do codigo de barras */
		cCdBarra:= cBanco + cMoeda + cFatorValor + cCart + cNroDoc + cDigNosso +;
			cAgencia + cConta + cDigCC + "000"

		cDigCdBarra:= Modu11(cCdBarra,9)

		cCdBarra := Left(cCdBarra,4) + cDigCdBarra + Substr(cCdBarra,5,40)

		/* Calculo da representacao numerica */
		//	cCampo1:= "341" + "9" + cCart + Substr(cNosso, 5, 2)
		//	cCampo2:= Substr(cNosso, 7, 6) + Substr(cNosso, 14, 1) + Substr(cAgencia, 1, 3)
		//	cCampo3:= Substr(cAgencia, 4, 1) + cConta + cDacCC + "000"
		cCampo1:= cBanco+cMoeda+Substr(cCdBarra,20,5)
		cCampo2:= Substr(cCdBarra,25,10)
		cCampo3:= Substr(cCdBarra,35,10)

		cCampo4:= Substr(cCdBarra, 5, 1)
		cCampo5:= cFatorValor

		/* Calculando os DACs dos campos 1, 2 e 3 */
		cCampo1:= cCampo1 + Modu10(cCampo1)
		cCampo2:= cCampo2 + Modu10(cCampo2)
		cCampo3:= cCampo3 + Modu10(cCampo3)

		cRepNum := Substr(cCampo1, 1, 5) + "." + Substr(cCampo1, 6, 5) + "  "
		cRepNum += Substr(cCampo2, 1, 5) + "." + Substr(cCampo2, 6, 6) + "  "
		cRepNum += Substr(cCampo3, 1, 5) + "." + Substr(cCampo3, 6, 6) + "  "
		cRepNum += cCampo4 + "  "
		cRepNum += cCampo5

		Aadd(aRet,cCdBarra)
		Aadd(aRet,cRepNum)
		Aadd(aRet,cNosso)

	ElseIf cBanco == '237' // Bradesco
		cNosso     := cCart + '/' + cNroDoc + '-' + cDigNosso

		// campo livre
		cCampoL    := cAgencia+cCart+cNroDoc+StrZero(Val(cConta),7)+'0'

		//campo livre do codigo de barra                   // verificar a conta
		If nValor > 0
			cFatorValor  := fator()+strzero(nValor*100,10)
		Else
			cFatorValor  := fator()+strzero((SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE)*100,10)
		Endif

		// campo do digito verificador do codigo de barra
		cLivre := cBanco+cMoeda+cFatorValor+cCampoL

		cDigBarra := CALC_5p( cLivre )

		// campo do codigo de barra
		cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5,40)

		// composicao da linha digitavel
		cParte1  := cBanco+cMoeda+Substr(cBarra,20,5)
		cDig1    :=  Modu10( cParte1 )
		cParte1  := cParte1 + cDig1

		cParte2  := SUBSTR(cBarra,25,10) // alterado aqui cParte2  := SUBSTR(cCampoL,7,10)
		cDig2    :=  Modu10( cParte2 )
		cParte2  := cParte2 + cDig2

		cParte3  := SUBSTR(cBarra,35,10)
		cDig3    :=  Modu10( cParte3 )
		cParte3  := cParte3 + cDig3

		cParte4  := cDigBarra
		cParte5  := cFatorValor

		cDigital :=  substr(cParte1,1,5)+"."+substr(cparte1,6,5)+" "+;
			substr(cParte2,1,5)+"."+substr(cparte2,6,6)+" "+;
			substr(cParte3,1,5)+"."+substr(cparte3,6,6)+" "+;
			cParte4+" "+;
			cParte5

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)

	ElseIf cBanco == '033' 	// Santander
		cNosso    := cNroDoc + '-' + cDigNosso

		//campo livre do codigo de barra                   // verificar a conta
		If nValor > 0
			cFatorValor  := fator()+strzero(nValor*100,10)
		Else
			cFatorValor  := fator()+strzero(( SE1->E1_SALDO +SE1->E1_SDACRES - SE1->E1_SDDECRE)*100,10)
		Endif

		cBarra := cBanco 										//Codigo do banco na camara de compensacao
		cBarra += cMoeda  										//Codigo da Moeda
		cBarra += Fator()						  	    		//Fator Vencimento
		cBarra += strzero(nValor*100,10)						//Strzero(Round(SE1->E1_SALDO,2)*100,10)		//Valor (ALTERADO PARA PEGAR O SALDO DO TITULO E NÃO O VALOR)
		cBarra += "9"                                           //Sistema - Fixo
		cBarra += _cConvenio									//Código Beneficiario
		cBarra += cNroDoc + cDigNosso							//Nosso numero
		cBarra += "0"											//IOS
		cBarra += _cCarteira					     			//Tipo de Cobrança

		cDigBarra := Modu11(cBarra)								//DAC codigo de barras

		cBarra := SubStr(cBarra,1,4) + cDigBarra + SubStr(cBarra,5,39)


		// composicao da linha digitavel  1 PARTE DE 1
		cParte1 := cBanco 		 				     	//Codigo do banco na camara de compensacao
		cParte1 += cMoeda								//Cod. Moeda
		cParte1 += "9"									//Fixo "9" conforme manual Santander
		cParte1 += Substr(_cConvenio,1,4)				//Código do Beneficiario (Posição 1 a 4)

		cDig1 := Substr(cParte1,1,9)                  //Pega variavel sem o '.'

		cParte1 += Modu10(cDig1)				  	    //Digito verificador do campo


		// composicao da linha digitavel 1 PARTE DE 2
		cParte2 := Substr(_cConvenio,5,3)			//Código do Beneficiario (Posição 5 a 7)
		cParte2 += Substr(cNroDoc + cDigNosso,1,7)			//Nosso Numero (Posição 1 a 7)

		cDig2 := Substr(cParte2,1,10)					//Pega variavel sem o '.'

		cParte2 += Modu10(cDig2)					    //Digito verificador do campo


		// composicao da linha digitavel 2 PARTE DE 1
		cParte3 := SubStr(cNroDoc + cDigNosso,8,6)  		//Nosso Numero (Posição 8 a 13)
		cParte3 +="0"									//IOS (Fixo "0")
		cParte3 +=_cCarteira							//Tipo Cobrança (101-Cobrança Simples Rápida Com Registro)

		cDig3 := Substr(cParte3,1,10) 			        //Pega variavel sem o '.'

		cParte3 += Modu10(cDig3)				     	//Digito verificador do campo


		// composicao da linha digitavel 4 PARTE
		cParte4 := SubStr(cBarra,5,1)				//Digito Verificador do Código de Barras


		// composicao da linha digitavel 5 PARTE
		cParte5 := Fator()							//Fator de vencimento
		cParte5 += strzero(nValor*100,10)			//Valor do titulo (Saldo no E1)

		cDigital :=  substr(cParte1,1,5)+"."+substr(cparte1,6,5)+" "+;
			substr(cParte2,1,5)+"."+substr(cparte2,6,6)+" "+;
			substr(cParte3,1,5)+"."+substr(cparte3,6,6)+" "+;
			cParte4+" "+cParte5


		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)


	ElseIf cBanco == '756' // Sicoob

		cConta	   := StrZero( val(cConta),8)
		cNosso    := cNroDoc + '-' + cDigNosso
		cCart      := cCart

		//campo livre do codigo de barra                   // verificar a conta
		If nValor > 0
			cFatorValor  := fator()+strzero(nValor*100,10)
		Else
			cFatorValor  := fator()+strzero(( SE1->E1_SALDO +SE1->E1_SDACRES - SE1->E1_SDDECRE )*100,10)
		Endif

		// campo livre
		cCampoL    := Left(cCart,1) + cAgencia + Right(cCart,2) + StrZero( Val(_cConvenio),7) + cNroDoc + cDigNosso + StrZero( Val(se1->e1_parcela),3)

		// campo do digito verificador do codigo de barra
		cLivre := cBanco + cMoeda + cFatorValor + cCampoL
		cDigBarra := CALC_5p( cLivre )

		// campo do codigo de barra
		cBarra    := SubStr(cLivre,1,4) + cDigBarra + SubStr(cLivre,5,39)

		// composicao da linha digitavel
		cParte1  := cBanco + cMoeda + Left(cCart,1) + cAgencia
		cDig1    := DIGIT001( cParte1 )
		cParte1  := cParte1 + cDig1

		cParte2  := Right(cCart,2) + StrZero( Val(see->ee_codemp), 7) +	Left(cNroDoc,1)
		cDig2    := DIGIT001( cParte2 )
		cParte2  := cParte2 + cDig2

		cParte3  := Right(cNroDoc,6) + cDigNosso + StrZero( Val(se1->e1_parcela),3)
		cDig3    := DIGIT001( cParte3 )		//DigitoLinhaDigitavel(cParte3)	//
		cParte3  := cParte3 + cDig3

		cParte4  := cDigBarra
		cParte5  := cFatorValor

		cDigital :=  substr(cParte1,1,5)+"."+substr(cparte1,6,5)+" "+;
			substr(cParte2,1,5)+"."+substr(cparte2,6,6)+" "+;
			substr(cParte3,1,5)+"."+substr(cparte3,6,6)+" "+;
			cParte4+" "+;
			cParte5

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)

	ElseIf cBanco == '104' // CAIXA

		cConta	   := StrZero( val(cConta),8)              º
		cNosso    := cNroDoc + '-' + cDigNosso
		cCart      := cCart

		//campo livre do codigo de barra                   // verificar a conta
		If nValor > 0
			cFatorValor  := fator()+strzero(nValor*100,10)
		Else
			cFatorValor  := fator()+strzero((SE1->E1_SALDO +SE1->E1_ACRESC)*100,10)// Alterado Athos 27/12/12
		Endif


		// campo livre
		//cCampoL    := Left(cCart,1) + cAgencia + Right(cCart,2) + StrZero( Val(_cConvenio),6)+"9" + cNroDoc + cDigNosso + StrZero( Val(se1->e1_parcela),3)
		DvConv :=""
		If ALLTRIM(_cConvenio) == "338294"

			DvConv := "0"
		else
			DvConv := "9" //euler Criado para assumir o dv do Cedente. para caixa economica.
		Endif
		cCampoL    := StrZero( Val(_cConvenio),6)+DvConv+subStr(cNroDoc,3,3)+"1"+subStr(cNroDoc,6,3)+"4"+subStr(cNroDoc,9,9)
		DvCampoL	:= Modu11(cCampoL,,"CX")
		cCampoL	   := cCampoL+DvCampoL
		// campo do digito verificador do codigo de barra
		cLivre := cBanco + cMoeda + cFatorValor + cCampoL
		cDigBarra := CALC_5p( cLivre )

		// campo do codigo de barra
		cBarra    := SubStr(cLivre,1,4) + cDigBarra + SubStr(cLivre,5,39)

		// composicao da linha digitavel
		cParte1  := cBanco + cMoeda + Substr(_cConvenio,1,5)//Left(cCart,1) + cAgencia
		cDig1    := DIGIT001( cParte1 )
		cParte1  := cParte1 + cDig1

		cParte2  := Substr(_cConvenio,6,1)+DvConv+subStr(cNroDoc,3,3)+"1"+subStr(cNroDoc,6,3)+"4"//Right(cCart,2) + StrZero( Val(see->ee_codemp), 6)+"9" +	Left(cNroDoc,1)
		cDig2    := DIGIT001( cParte2 )
		cParte2  := cParte2 + cDig2

		cParte3  := subStr(cNroDoc,9,9)+DvCampoL//Right(cNroDoc,6) + cDigNosso + StrZero( Val(se1->e1_parcela),3)
		cDig3    := DIGITº001( cParte3 )		//DigitoLinhaDigitavel(cParte3)	//
		cParte3  := cParte3 + cDig3

		cParte4  := cDigBarra
		cParte5  := cFatorValor

		cDigital :=  substr(cParte1,1,5)+"."+substr(cparte1,6,5)+" "+;
			substr(cParte2,1,5)+"."+substr(cparte2,6,6)+" "+;
			substr(cParte3,1,5)+"."+substr(cparte3,6,6)+" "+;
			cParte4+" "+;
			cParte5

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)

	ElseIf cBanco == '422' // Safra Bol

		cNosso     := cNroDoc

		// campo livre
		cCampoL    := cAgencia+"001402031"+cNroDoc+"2"

		//campo livre do codigo de barra
		If nValor > 0
			cFatorValor  := fator()+strzero(nValor*100,10)
		Else
			cFatorValor  := fator()+strzero((SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE)*100,10)
		Endif

		// campo do digito verificador do codigo de barra
		cLivre := cBanco + cMoeda  + cFatorValor +"7"+ cCampoL

		cDigBarra := CALC_5p( cLivre )

		// campo do codigo de barra
		cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5,40)

		// composicao da linha digitavel
		cParte1  := cBanco + cMoeda + "7" + cAgencia
		cDig1    := Modu10( cParte1 )
		cParte1  := cParte1 + cDig1

		cParte2  := "0001402031"
		cDig2    := Modu10( cParte2 )
		cParte2  := cParte2 + cDig2

		cParte3  := AllTrim(se1->e1_numbco) + "2"
		cDig3    := Modu10(cParte3)		//DigitoLinhaDigitavel(cParte3)	//
		cParte3  := AllTrim(cParte3) + AllTrim(cDig3)

		cParte4  := AllTrim(cDigBarra)
		cParte5  := AllTrim(cFatorValor)

		cDigital :=  substr(cParte1,1,5)+"."+substr(cparte1,6,5)+" "+;
			substr(cParte2,1,5)+"."+substr(cparte2,6,6)+" "+;
			substr(cParte3,1,5)+"."+substr(cparte3,6,6)+" "+;
			cParte4+" "+;
			cParte5

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)

	ElseIf cBanco == '246' // ABC do Brasil

		cNosso := "110/"+cNroDoc

		// Preenchimento do Campo Livre Agencia+Carteira+Operacao+Nossonum+Digverificar
		cCampoL := AllTrim(_cAgencia)+AllTrim(_cCart)+AllTrim(_cOperacao)+AllTrim(cNroDoc)+AllTrim(cDigNosso)

		//campo livre do codigo de barra                   // verificar a conta
		If nValor > 0
			cFatorValor  := fator()+strzero(nValor*100,10)
		Else
			cFatorValor  := fator()+strzero((SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE)*100,10)
		Endif

		// campo do digito verificador do codigo de barra
		cLivre := AllTrim(cBanco)+AllTrim(cMoeda)+AllTrim(cFatorValor)+AllTrim(cCampoL)

		//Função Dig10ABC - ROTINA PARA CÁLCULO DO DV DO NOSSO NÚMERO
		//cDigBarra :=  Dig10ABC(AllTrim(cNroDoc),AllTrim(_cAgencia),AllTrim(_cCart))
		cDigBarra := Modu10(AllTrim(cNroDoc),AllTrim(_cAgencia),AllTrim(_cCart))

		//Dígito verificador do código de barras (Módulo 11, Item 6)
		cDigBarraMod11 := Modu11(cLivre)

		//Código de barras é composto por 44 posições - Banco+Moeda+Digito Verificador+Fator Vencimento+Valor+Campo livre
		cBarra    := AllTrim(cBanco)+AllTrim(cMoeda)+AllTrim(cDigBarraMod11)+AllTrim(cFatorValor)+AllTrim(cCampoL)

		// composicao da linha digitavel
		cParte1  := AllTrim(cBanco) +AllTrim(cMoeda)+ AllTrim(Substr(cCampoL,1,5))
		cDig1    := Modu10(cParte1)
		cParte1  := AllTrim(cParte1) + AllTrim(cDig1)

		cParte2  := AllTrim(Substr(cCampoL,6,10))
		cDig2    := Modu10( cParte2 )
		cParte2  := AllTrim(cParte2) + AllTrim(cDig2)

		cParte3  := AllTrim(Substr(cCampoL,16,10))
		cDig3    := Modu10( cParte3 )
		cParte3  := AllTrim(cParte3) + AllTrim(cDig3)

		cParte4  := AllTrim(cDigBarraMod11)

		cParte5  := AllTrim(cFatorValor)

		cDigital := substr(cParte1,1,5)+"."+substr(cparte1,6,5)+" "+;
			substr(cParte2,1,5)+"."+substr(cparte2,6,6)+" "+;
			substr(cParte3,1,5)+"."+substr(cparte3,6,6)+" "+;
			cParte4 +" "+ cParte5

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)

	ElseIf cBanco == '707' // Daycoval
		//No exemplo: 00019/121/0004309540-8.
		cNosso  := aDadosBanco[__NPOSAGENC]+aDadosBanco[__NPOSDVAGE] +'/'+ aDadosBanco[__NPOSCARTE] +'/'+AllTrim(cNroDoc) +'-'+AllTrim(cDigNosso)

		If nValor > 0
			cFatorValor  := fator()+strzero(nValor*100,10)
		Else
			cFatorValor  := fator()+strzero((SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE)*100,10)
		Endif

		//25 posições, onde:
		//Agência sem DV ? 4 posições (vide e-mail)
		//Carteira ? 3 posições (vide e-mail)
		//Operação ? 7 posições (vide e-mail)
		//Nosso Número + DV ? 11 posições (utilizar o range disponibilizado ? vide e-mail)
		cCampoL := aDadosBanco[__NPOSAGENC] + aDadosBanco[__NPOSCARTE]  + _cOperacao
		cCampoL += AllTrim(cNroDoc) + AllTrim(cDigNosso)

		cLivre := AllTrim(cBanco)+AllTrim(cMoeda)+AllTrim(cFatorValor)+AllTrim(cCampoL)
		cDigBarraMod11 := Modu11(cLivre)

		//Parte superior direita: Deve haver representação numérica do conteúdo do código de barras, sendo que, para cada um dos 3 (três) primeiros campos,
		//um dígito verificador (calculado no módulo 10) e, entre cada campo, espaço equivalente a 2(duas) posições.
		//Campo 1: Composto pelo código do banco, código da moeda e as cinco primeiras posições do campo livre do cód de barras (veja definição abaixo),
		// mais o dígito verificador deste campo;
			//	BBBMLLLLLD, onde:
		//? BBB ? Número do Banco (707)
		//? M - Moeda (9 = reais; 0 = moeda variável)
		//? LLLLL - cinco primeiras posições do campo livre


		//Código de barras é composto por 44 posições - Banco+Moeda+Digito Verificador+Fator Vencimento+Valor+Campo livre
		cBarra    := AllTrim(cBanco)+AllTrim(cMoeda)+AllTrim(cDigBarraMod11)+AllTrim(cFatorValor)+AllTrim(cCampoL)

		// composicao da linha digitavel
		cParte1  := AllTrim(cBanco) +AllTrim(cMoeda)+ AllTrim(Substr(cCampoL,1,5))
		cDig1    := Modu10( cParte1 )//RetDV_DayC(cParte1 , 2 )
		cParte1  := AllTrim(cParte1) + AllTrim(cDig1)

		cParte2  := AllTrim(Substr(cCampoL,6,10))
		cDig2    := Modu10( cParte2 ) //RetDV_DayC(cParte2 , 2 )
		cParte2  := AllTrim(cParte2) + AllTrim(cDig2)

		cParte3  := AllTrim(Substr(cCampoL,16,10))
		cDig3    := Modu10( cParte3 )//RetDV_DayC(cParte3 , 2 )
		cParte3  := AllTrim(cParte3) + AllTrim(cDig3)

		cParte4  := AllTrim(cDigBarraMod11)
		cParte5  := AllTrim(cFatorValor)

		cDigital := substr(cParte1,1,5)+"."+substr(cparte1,6,5)+" "+;
			substr(cParte2,1,5)+"."+substr(cparte2,6,6)+" "+;
			substr(cParte3,1,5)+"."+substr(cparte3,6,6)+" "+;
			cParte4 +" "+ cParte5

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)
	EndIf

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CALC_di9  ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para calculo do nosso numero do banco do brasil             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CALC_di9(cVariavel)
	Local Auxi := 0, sumdig := 0

	cbase  := cVariavel
	lbase  := LEN(cBase)
	base   := 9
	sumdig := 0
	Auxi   := 0
	iDig   := lBase
	While iDig >= 1
		If base == 1
			base := 9
		EndIf
		auxi   := Val(SubStr(cBase, idig, 1)) * base
		sumdig := SumDig+auxi
		base   := base - 1
		iDig   := iDig-1
	EndDo
	auxi := mod(Sumdig,11)
	If auxi == 10
		auxi := "X"
	Else
		auxi := str(auxi,1,0)
	EndIf
Return(auxi)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ Modulo11 ³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri??o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Modulo11(cData)
	Local L, D, P := 0

	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End

	If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
		D := 1
	End
Return(D)




/******************************************************************************************************************/
//CONVENIO COM 6 POSICOES BB
/******************************************************************************************************************/
Static Function Dig11BB(cData)
	Local Auxi := 0, sumdig := 0

	cbase  := cData
	lbase  := LEN(cBase)
	base   := 9	//7
	sumdig := 0
	Auxi   := 0
	iDig   := lBase

	while iDig >= 1
		If base == 1
			base := 9
		EndIf
		auxi   := Val(SubStr(cBase, idig, 1)) * base
		sumdig := SumDig+auxi
		base   := base - 1
		iDig   := iDig-1
	endDo

	auxi := mod(Sumdig,11)
	If auxi == 10
		auxi := "X"
	Else
		auxi := str(auxi,1,0)
	EndIf

Return(auxi)

/******************************************************************************************************************/
//CONVENIO COM 6 POSICOES C6 BANCO NOSSO NUMERO
//Mod 11 base 7
/******************************************************************************************************************/
Static Function Dig11C6(cCart,cData,aPesos)

	Local Auxi   := 0
	//Local aPesos := {}
	Local x      := 0
	Local nTot   := 0

	//AADD(aPesos,{2,7,6,5,4,3,2,7,6,5,4,3,2})

	cData = cCart + cData

	For x := 1 To Len(aPesos[1])
		nTot += Val(SubStr(cData, x, 1)) * aPesos[1][x]
	Next x

	auxi := mod(nTot,11)
	auxi := 11 - auxi

	If auxi == 11
		auxi := "0"
	ElseIf auxi == 10
		auxi := "p"
	Else
		auxi := str(auxi,1,0)
	EndIf

Return(auxi)

/******************************************************************************************************************/
//CONVENIO COM 6 POSICOES C6 BANCO NOSSO NUMERO
// Mod 11 Base 9
/******************************************************************************************************************/
Static Function Mod11C6B9(cData,aPesos)

	Local Auxi   := 0
	//Local aPesos := {}
	Local x      := 0
	Local nTot   := 0

	//AADD(aPesos,{2,7,6,5,4,3,2,7,6,5,4,3,2})


	For x := 1 To Len(aPesos[1])
		nTot += Val(SubStr(cData, x, 1)) * aPesos[1][x]
	Next x

	auxi := mod(nTot,11)
	auxi := 11 - auxi

	If auxi == 0 .OR. auxi == 1 .OR. auxi == 10 .OR. auxi == 11
		auxi := "1"
	Else
		auxi := str(auxi,1,0)
	EndIf

Return(auxi)

/******************************************************************************************************************/
//CONVENIO COM 6 POSICOES C6 BANCO NOSSO NUMERO
// Mod 10
/******************************************************************************************************************/
Static Function Mod10C6(cData,aPesos)

	Local Auxi   := 0
	//Local aPesos := {}
	Local x      := 0
	Local nTot   := 0

	//AADD(aPesos,{2,7,6,5,4,3,2,7,6,5,4,3,2})


	For x := 1 To Len(aPesos[1])
		nTot += Val(SubStr(cData, x, 1)) * aPesos[1][x]
	Next x

	auxi := mod(nTot,11)
	auxi := 11 - auxi

	If auxi == 0 .OR. auxi == 1 .OR. auxi == 10 .OR. auxi == 11
		auxi := "1"
	Else
		auxi := str(auxi,1,0)
	EndIf

Return(auxi)


/******************************************************************************************************************/
Static Function DigitoBB(cData)
	Local Auxi := 0, sumdig := 0
	cbase  := cData
	lbase  := LEN(cBase)
	base   := 9
	sumdig := 0
	Auxi   := 0
	iDig   := lBase
	While iDig >= 1
		If base == 1
			base := 9
		EndIf
		auxi   := Val(SubStr(cBase, idig, 1)) * base
		sumdig := SumDig+auxi
		base   := base - 1
		iDig   := iDig-1
	EndDo
	auxi := mod(Sumdig,11)
	If auxi == 10
		auxi := "X"
	Else
		auxi := str(auxi,1,0)
	EndIf

Return(auxi)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³DIGIT001  ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para calculo da linha digitavel do Banco do Brasil          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DIGIT001(cVariavel)
	Local Auxi := 0, sumdig := 0

	cbase  := cVariavel
	lbase  := LEN(cBase)
	umdois := 2
	sumdig := 0
	Auxi   := 0
	iDig   := lBase
	While iDig >= 1
		auxi   := Val(SubStr(cBase, idig, 1)) * umdois
		sumdig := SumDig+If (auxi < 10, auxi, (auxi-9))
		umdois := 3 - umdois
		iDig:=iDig-1
	EndDo
	cValor:=AllTrim(STR(sumdig,12))
	nDezena:=VAL(ALLTRIM(STR(VAL(SUBSTR(cvalor,1,1))+1,12))+"0")
	auxi := nDezena - sumdig

	If auxi >= 10
		auxi := 0
	EndIf
Return(str(auxi,1,0))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FATOR		ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do FATOR  de vencimento para linha digitavel.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function Fator()

	if lXOBSRM // Se tem integracao com RM no Boleto

		If Len( ALLTRIM( SUBSTR( dtos(dDtVencRea),7,4) ) ) = 4
			cData := SUBSTR( dtos(dDtVencRea),7,4)+SUBSTR( dtos(dDtVencRea),4,2)+SUBSTR( dtos(dDtVencRea),1,2)
		Else
			cData := "20"+SUBSTR( dtos(dDtVencRea),7,2)+SUBSTR( dtos(dDtVencRea),4,2)+SUBSTR( dtos(dDtVencRea),1,2)
		EndIf

		//cFator := STR(1000+(dDtVencRea-STOD("20000703")),4)

		//Nova data-base: a partir de 22/02/2025, o fator de vencimento retornará para “1000”,
		//devendo ser adicionado “1” a cada dia subsequente a esse fator, conforme exemplo
		//abaixo:
		if dDtVencRea >= cTod("22/02/2025")
			cFator := STR(1000+(dDtVencRea-STOD("20250222")),4)
		else
			cFator := STR(1000+(dDtVencRea-STOD("20000703")),4)
		endif

	Else

		If Len( ALLTRIM( SUBSTR( dtos(TSE1->E1_VENCREA),7,4) ) ) = 4
			cData := SUBSTR( dtos(TSE1->E1_VENCREA),7,4)+SUBSTR( dtos(TSE1->E1_VENCREA),4,2)+SUBSTR( dtos(TSE1->E1_VENCREA),1,2)
		Else
			cData := "20"+SUBSTR( dtos(TSE1->E1_VENCREA),7,2)+SUBSTR( dtos(TSE1->E1_VENCREA),4,2)+SUBSTR( dtos(TSE1->E1_VENCREA),1,2)
		EndIf

		//cFator := STR(1000+(TSE1->E1_VENCREA-STOD("20000703")),4)

		//Nova data-base: a partir de 22/02/2025, o fator de vencimento retornará para “1000”,
		//devendo ser adicionado “1” a cada dia subsequente a esse fator, conforme exemplo
		//abaixo:
		if TSE1->E1_VENCREA >= cTod("22/02/2025")
			cFator := STR(1000+(TSE1->E1_VENCREA-STOD("20250222")),4)
		else
			cFator := STR(1000+(TSE1->E1_VENCREA-STOD("20000703")),4)
		endif

	Endif

Return(cFator)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CALC_5p   ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do digito do nosso numero do                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CALC_5p(cVariavel)
	Local Auxi := 0, sumdig := 0

	cbase  := cVariavel
	lbase  := LEN(cBase)
	base   := 2
	sumdig := 0
	Auxi   := 0
	iDig   := lBase
	While iDig >= 1
		If base >= 10
			base := 2
		EndIf
		auxi   := Val(SubStr(cBase, idig, 1)) * base
		sumdig := SumDig+auxi
		base   := base + 1
		iDig   := iDig-1
	EndDo
	auxi := mod(sumdig,11)
	If auxi == 0 .or. auxi == 1 .or. auxi >= 10
		auxi := 1
	Else
		auxi := 11 - auxi
	EndIf
Return(str(auxi,1,0))


/******************************************************************************************************************/
/******************************************************************************************************************/
Static Function CdBarra_Itau()
	/******************************************************************************************************************/
	Local cDigCdBarra
	Local cFatVencto:= ""
	Local cValor
	Local nValor
	Local cCampo1:= ""
	Local cCampo2:= ""
	Local cCampo3:= ""
	Local cCampo4:= ""
	Local cCampo5:= ""

	cFatVencto:= StrZero(FatVencto('341'), 4)
	nValor:= Valliq()
	cValor:= StrZero(nValor * 100, 10)

	/* Calculo do codigo de barras */
	cCdBarra:= '341' + "9" + cFatVencto + cValor + cCartEmp + Substr(cNossoNum, 5, 8) + Substr(cNossoNum, 14, 1) +;
		cAgeEmp + cCtaEmp + cDigEmp + "000"

	cDigCdBarra:= Modu11(cCdBarra,9)

	cCdBarra:= '341' + "9" + cDigCdBarra + StrZero(FatVencto('341'), 4) + StrZero(Int(nValor * 100), 10) + cCartEmp + ;
		Substr(cNossoNum, 5, 8) + Substr(cNossoNum, 14, 1) + cAgeEmp + cCtaEmp + cDigEmp + "000"

	/* Calculo da representacao numerica */
	cCampo1:= "341" + "9" + cCartEmp + Substr(cNossoNum, 5, 2)
	cCampo2:= Substr(cNossoNum, 7, 6) + Substr(cNossoNum, 14, 1) + Substr(cAgeEmp, 1, 3)
	cCampo3:= Substr(cAgeEmp, 4, 1) + cCtaEmp + cDigEmp + "000"
	cCampo4:= Substr(cCdBarra, 5, 1)
	cCampo5:= cFatVencto + cValor

	/* Calculando os DACs dos campos 1, 2 e 3 */
	cCampo1:= cCampo1 + Modu10(cCampo1)
	cCampo2:= cCampo2 + Modu10(cCampo2)
	cCampo3:= cCampo3 + Modu10(cCampo3)

	cRepNum := Substr(cCampo1, 1, 5) + "." + Substr(cCampo1, 6, 5) + "  "
	cRepNum += Substr(cCampo2, 1, 5) + "." + Substr(cCampo2, 6, 6) + "  "
	cRepNum += Substr(cCampo3, 1, 5) + "." + Substr(cCampo3, 6, 6) + "  "
	cRepNum += cCampo4 + "  "
	cRepNum += cCampo5
Return




/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun??o    ³AJUSTASX1 º Autor ³ Carlos F. Martins  º Data ³  19/06/09   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri??o ³ Funcao auxiliar chamada para criar os parametros do        º±±
	±±º          ³ relatorio na tabela de parametros.                         º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AjustaSx1()

	Aadd(_Exec,{"01","De Prefixo"      ,"De Prefixo"      ,"De Prefixo"      ,"mv_ch1","C",03,0,0,"G","","","","","MV_PAR01","","","",""        ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"02","Ate Prefixo"     ,"Ate Prefixo"     ,"Ate Prefixo"     ,"mv_ch2","C",03,0,0,"G","","","","","MV_PAR02","","","","ZZZ"     ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"03","De Numero"       ,"De Numero"       ,"De Numero"       ,"mv_ch3","C",09,0,0,"G","","","","","MV_PAR03","","","",""        ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"04","Ate Numero"      ,"Ate Numero"      ,"Ate Numero"      ,"mv_ch4","C",09,0,0,"G","","","","","MV_PAR04","","","","ZZZZZZ"  ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"05","De Parcela"      ,"De Parcela"      ,"De Parcela"      ,"mv_ch5","C",03,0,0,"G","","","","","MV_PAR05","","","",""        ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"06","Ate Parcela"     ,"Ate Parcela"     ,"Ate Parcela"     ,"mv_ch6","C",03,0,0,"G","","","","","MV_PAR06","","","","Z"       ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"07","De Portador"     ,"De Portador"     ,"De Portador"     ,"mv_ch7","C",03,0,0,"G","","SA6","","","MV_PAR07","","","","001"     ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"08","Ate Portador"    ,"Ate Portador"    ,"Ate Portador"    ,"mv_ch8","C",03,0,0,"G","","SA6","","","MV_PAR08","","","","001"     ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"09","De Cliente"      ,"De Cliente"      ,"De Cliente"      ,"mv_ch9","C",06,0,0,"G","","SA1","","","MV_PAR09","","","",""        ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"10","Ate Cliente"     ,"Ate Cliente"     ,"Ate Cliente"     ,"mv_cha","C",06,0,0,"G","","SA1","","","MV_PAR10","","","","ZZZZZZ"  ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"11","De Loja"         ,"De Loja"         ,"De Loja"         ,"mv_chb","C",02,0,0,"G","","","","","MV_PAR11","","","",""        ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"12","Ate Loja"        ,"Ate Loja"        ,"Ate Loja"        ,"mv_chc","C",02,0,0,"G","","","","","MV_PAR12","","","","ZZ"      ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"13","De Emissao"      ,"De Emissao"      ,"De Emissao"      ,"mv_chd","D",08,0,0,"G","","","","","MV_PAR13","","","","01/01/01","","","","","","","","","","","",""})
	Aadd(_Exec,{"14","Ate Emissao"     ,"Ate Emissao"     ,"Ate Emissao"     ,"mv_che","D",08,0,0,"G","","","","","MV_PAR14","","","","31/12/10","","","","","","","","","","","",""})
	Aadd(_Exec,{"15","De Vencimento"   ,"De Vencimento"   ,"De Vencimento"   ,"mv_chf","D",08,0,0,"G","","","","","MV_PAR15","","","","01/01/01","","","","","","","","","","","",""})
	Aadd(_Exec,{"16","Ate Vencimento"  ,"Ate Vencimento"  ,"Ate Vencimento"  ,"mv_chg","D",08,0,0,"G","","","","","MV_PAR16","","","","31/12/10","","","","","","","","","","","",""})
	Aadd(_Exec,{"17","Do Bordero"      ,"Do Bordero"      ,"Do Bordero"      ,"mv_chh","C",06,0,0,"G","","","","","MV_PAR17","","","",""        ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"18","Ate Bordero"     ,"Ate Bordero"     ,"Ate Bordero"     ,"mv_chi","C",06,0,0,"G","","","","","MV_PAR18","","","","ZZZZZZ"  ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"19","Da Carga"        ,"Da Carga"        ,"Da Carga"        ,"mv_chj","C",06,0,0,"G","","DAK","","","MV_PAR19","","","",""        ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"20","Ate Carga"       ,"Ate Carga"       ,"Ate Carga"       ,"mv_chl","C",06,0,0,"G","","DAK","","","MV_PAR20",""   ,""   ,"","ZZZZZZ"  ,"","","","","","","","","",""})
	Aadd(_Exec,{"21","Mensagem 1"      ,"Mensagem 1"      ,"Mensagem 1"      ,"mv_chm","C",50,0,0,"G","","","","","MV_PAR21","","","",""        ,"","","","","","","","","","","",""})
	Aadd(_Exec,{"22","Mensagem 2"      ,"Mensagem 2"      ,"Mensagem 2"      ,"mv_chn","C",50,0,0,"G","","","","","MV_PAR22","","","",""        ,"","","","","","","","","","","",""})

Return _Exec

/******************************************************************************************************************/
Static Function Modu11(cLinha,cBase,cTipo)
	/******************************************************************************************************************/
	Local cDigRet
	Local nSoma:= 0
	Local nResto
	Local nCont
	Local nFator:= 9
	Local nResult
	Local _cBase := If( cBase = Nil , 9 , cBase )
	Local _cTipo := If( cTipo = Nil , '' , cTipo )
	//alert(cLinha)

	For nCont:= Len(cLinha) TO 1 Step -1
		nFator++
		If nFator > _cBase
			nFator:= 2
		EndIf

		nSoma += Val(Substr(cLinha, nCont, 1)) * nFator
	Next nCont

	nResto:= Mod(nSoma, 11)

	nResult:= 11 - nResto

	If _cTipo = 'P'   // Bradesco
		If nResto == 0
			cDigRet:= "0"
		ElseIf  nResto == 1
			cDigRet:= "P"
		Else
			cDigRet:= StrZero(11 - nResto, 1)
		EndIf
	Else
		If nResult == 0 .Or. nResult == 1 .Or. nResult == 10 .Or. nResult == 11
			cDigRet:= "1"
		Else
			cDigRet:= StrZero(11 - nResto, 1)
		EndIf
	EndIf
Return cDigRet



	Static Procedure NrBordero()
	Local nBordero := ""
	Local aBanco := {{"001","B"},{"237","R"},{"033","S"},{"756","C"},{"341","I"},{"187","I"},{"104","X"},{"246","A"},{"422","F"},{"707","D"},{"336","6"}}//{{"001","B"},{"237","R"},{"033","S"},{"756","C"},{"341","I"},{"187","I"},{"104","X"},{"246","A"},{"422","F"},{"707","D"}}
	Local lFindSEA := .F.
	Local nPos := 0
	Local _nSEE := SuperGetMv ( "MV_XSEE", .F., 0 )

	SEE->( DbGoTo(_nSEE) )
	nPos := AScan ( aBanco, {|x| x[1] == SEE->EE_CODIGO } )

	if nPos == 0 .or. _nSEE == 0
		Return .T.

	elseif !Empty(SE1->E1_PORTADO)
		Return .T.

	endif

	// X - Codigo Banco
	// XX - Dia
	// X - Codigo Mes (A=Jan,B=Fev,C=Mar ... L=Dez)
	// XX - Ano

	nBordero := aBanco[nPos,2] + StrZero( day( dDataBase ),2 ) + Upper(chr( 64+Month( dDataBase ) ) ) + Right( Str( Year( date() ),4 ), 2 )

	//Posiciona na Agencia/Conta e Configuracoes bancarias
	////////SEE->( DbSeek( xFilial("SEE")+aBanco[nPos,1] ) ) o see ja esta posicionado pelo parametro mv_xsee!
	SA6->( DbSeek( xFilial("SA6")+SEE->EE_CODIGO+SEE->EE_AGENCIA+SEE->EE_CONTA) )

	RecLock("SE1")

	SE1->E1_PORTADO := SEE->EE_CODIGO
	SE1->E1_AGEDEP	:= SEE->EE_AGENCIA
	SE1->E1_CONTA	:= SEE->EE_CONTA
	SE1->E1_SITUACA	:= iif( SEE->( FieldPos("EE_XSIT") ) > 0, SEE->EE_XSIT, '1')
	SE1->E1_OCORREN	:= '01'
	SE1->E1_NUMBOR	:= M->nBordero
	SE1->E1_DATABOR	:= dDataBase

	SE1->( MsUnlock() )
	SE1->( DbCommit() )

	//
	//	Coloca o titulo no bordero
	//
	SEA->( dbSetOrder( 1 ) )

	lFindSEA := SEA->( DbSeek( xFilial( "SEA" )+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA,.F. ) )

	RecLock( "SEA",!lFindSEA )

	if !lFindSEA

		SEA->EA_FILIAL  := xFilial( "SEA" )
		SEA->EA_PREFIXO := SE1->E1_PREFIXO
		SEA->EA_NUM     := SE1->E1_NUM
		SEA->EA_PARCELA := SE1->E1_PARCELA
		SEA->EA_FILORIG := cFilAnt

	endif

	SEA->EA_NUMBOR  := SE1->E1_NUMBOR
	SEA->EA_TIPO    := SE1->E1_TIPO
	SEA->EA_CART    := "R"
	SEA->EA_PORTADO := SE1->E1_PORTADO
	SEA->EA_AGEDEP  := SE1->E1_AGEDEP
	SEA->EA_DATABOR := SE1->E1_DATABOR
	SEA->EA_NUMCON  := SE1->E1_CONTA
	SEA->EA_SITUACA := SE1->E1_SITUACA
	SEA->EA_TRANSF  := 'S'
	SEA->EA_SITUANT := '0'

	/*	If l060SEA
	ExecBlock("F060SEA",.f.,.f.)
Endif */

	SEA->( msUnLock() )
	SEA->( dbCommit() )
Return .T.



Static Function BradMod11(NumBoleta)
	Local Modulo   := 11
	Local strmult  := "2765432765432"
	Local BaseDac  := M->NumBoleta  //Carteira + N Nro
	Local VarDac   := 0, idac := 0

	// Calculo do numero bancario + digito e valor do juros

	For idac := 1 To 13
		VarDac := VarDac + Val(Subs(BaseDac, idac, 1)) * Val (Subs (strmult, idac, 1))
	Next idac

	VarDac  := Modulo - VarDac % Modulo
	VarDac  := Iif (VarDac == 10, "P", Iif (VarDac == 11, "0", Str (VarDac, 1)))		
Return VarDac



//
// Função para Colocar o Dígito no Código de Barras - SICOOB
//
Static Function DigBarSiCoob(CodigoBarra)
	Local Indice := '43290876543298765432987654329876543298765432'
	Local somax := 0, contador := 0, digito := 0

	for contador:=1 to 44

		if contador <> 5
			somax += ( val( Substr(CodigoBarra,contador,1) ) * Val( Substr(CodigoBarra,contador,1) ) )
			digito := 11 - Mod(SomaX,11)
		endif

		if (digito <= 1) .or. (digito > 9)
			digito := 1
		endif

	next contador

	//Colocar o digito no codigo barra
	//codigobarra[5] := inttostr(digito)[1];
return digito



//
// Função para Validação do Código de Barras - SICOOB
//
Static Function ValidaCodigoBarra(codigobarra)
	Local Indice := '43290876543298765432987654329876543298765432'
	Local somax := 0, contador := 0, digito := 0

	for contador:=1 to 44

		if contador <> 5
			somax += Val( Substr(codigobarra,contador,1) ) * Val( Substr(indice,contador,1) )
			digito := 11 - Mod(SomaX,11)
		endif

		if (digito <= 1) .or. (digito > 9)
			digito := 1
		endif

	next contador
Return digito


//
//Função para Definir o Próximo Múltiplo de 10 - SICOOB
//
Static Function Multiplo10(numero)
	Local result := 0

	while Mod(numero,10) <> 0
		numero += 1
		result := numero
	enddo
Return result


//
//Função para Definir Digito Nosso Numero  - SICOOB
//
Static Function SiCoobMod11(NumBoleta)
	Local Modulo   := 11
	Local strmult  := "319731973197319731973"
	//Local strmult  := "1973197319731973"
	Local BaseDac  := M->NumBoleta  //Carteira + N Nro
	Local VarDac   := 0, idac := 0

	// Calculo do numero bancario + digito e valor do juros
	For idac := 1 To len(NumBoleta)
		VarDac += Val(Subs(BaseDac, idac, 1)) * Val (Subs (strmult, idac, 1))
	Next idac

	VarDac  := Modulo - VarDac % Modulo
	VarDac  := Iif (VarDac < 2 .or. VarDac >= 10, "0", Str(VarDac) )
Return VarDac


Static Function DigNNSicoob(cNNum,cCodEmp,cCodCoop,cParcela)
	Local cCoop   := cCodCoop
	Local cClie   := StrZero(Val(cCodEmp),10)
	Local nMod    := 11
	Local nSoma   := 0
	Local nI      := 0

	Default cNNum 	:= '0000001'
	Default cParcela:= '001'

	aCons := {3,1,9,7,3,1,9,7,3,1,9,7,3,1,9,7,3,1,9,7,3}

	cSeq := cCoop+cClie+cNNum
	For nI := 1 to Len(cSeq)
		nSoma += Val(SubStr(cSeq,nI,1))*aCons[nI]
	Next

	nDigit := (nSoma % nMod)
	//cDigit := AllTrim(Str( iif( nDigit <= 1,0, iif(nDigit >= 10,1,nDigit)) ) )

	if nDigit <= 1
		cDigit := '0'
	else
		cDigit := AllTrim(Str(nMod - nDigit))
	endif

Return cDigit


//
// Função para Definir Linha Digital - SICOOB
//
Static Function DigitoLinhaDigitavel(linhadigitavel)
	Local Indice := '2121212120121212121201212121212'
	Local digito :=0, soma:=0, mult:=0, contador:=0
	Local codigobarra := ""
	Local nResult := ""

	//cálculo do primeiro dígito
	soma := 0

	for contador := 10 to 1 Step -1

		mult := Val( Substr(linhadigitavel,contador,1) ) * Val( Substr(indice,contador,1) )	
		if mult >= 10
			nResult := StrZero(mult,2)
			soma += Val( Left(nResult,1) ) + Val( Right(nResult,2) )
		else
			soma += mult
		endif

	next contador

	digito := multiplo10(soma) - soma

	//Coloca o primeiro digito na linha digitável
	linhadigitavel := Left(linhadigitavel,09,1) + Str(digito,1) + Substr(linhadigitavel,11,40)

	//cálculo do segundo dígito
	soma := 0

	for contador:=11 to 20

		mult := Val( Substr(linhadigitavel,contador,1) ) * Val( Substr(indice,contador,1) )	
		if mult >= 10
			nResult := StrZero(mult,2)
			soma += Val( Left(nResult,1) ) + Val( Right(nResult,2) )
		else
			soma += mult
		endif

	next contador

	digito := multiplo10(soma) - soma

	//Coloca o segundo digito na linha digitável
	linhadigitavel := Left( linhadigitavel,20) + Str(digito,1) + Substr(linhadigitavel,22,40)

	//cálculo do terceiro dígito
	soma := 0

	for contador:=22 to 31

		mult := Val( Substr(linhadigitavel,contador,1) ) * Val( Substr(indice,contador,1) )	
		if mult >= 10
			nResult := StrZero(mult,2)
			soma += Val( Left(nResult,1) ) + Val( Right(nResult,2) )
		else
			soma += mult
		endif

	next contador

	//digito := multiplo10(soma) ? soma

	//Coloca o terceiro digito na linha digitável
	linhadigitavel := Left( linhadigitavel,1,31) + Str(digito,1) + Substr(linhadigitavel,33,40)

	//Monta o codigo de barra para verificar o último dígito


	codigobarra := SubStr(linhadigitavel, 01, 03) //Código do Banco
	codigobarra += SubStr(linhadigitavel, 04, 01) //Moeda
	codigobarra += SubStr(linhadigitavel, 33, 01) //Digito Verificador
	codigobarra += SubStr(linhadigitavel, 34, 04) //fator de vencimento
	codigobarra += SubStr(linhadigitavel, 38, 10) //valor do documento
	codigobarra += SubStr(linhadigitavel, 05, 01) //Carteira
	codigobarra += SubStr(linhadigitavel, 06, 04) //Agencia
	codigobarra += SubStr(linhadigitavel, 11, 02) //Modalidade Cobranca
	codigobarra += SubStr(linhadigitavel, 13, 07) //Código do Cliente
	codigobarra += SubStr(linhadigitavel, 20, 01) + SubStr(linhadigitavel, 22, 7)//Nosso Numero
	codigobarra += SubStr(linhadigitavel, 29, 03) //Parcela

	codigobarra := DigitoCodigoBarra(codigobarra);
	//Coloca o primeiro digito na linha digitável
	linhadigitavel := Left(linhadigitavel,32) + Substr(codigobarra,5,1) + Substr(linhadigitavel,32)
Return {linhadigitavel,codigobarra}




/******************************************************************************************************************/
//CONVENIO SANTANDER
/******************************************************************************************************************/
Static Function Dig11Santander(cData)
	Local Auxi := 0, sumdig := 0

	cbase  := cData
	lbase  := Len(cBase)
	base   := 2
	sumdig := 0
	Auxi   := 0
	Local iDig   := lBase

	for iDig:=len(cBase) to 1 Step -1

		if base == 9
			base := 2
		endIf

		auxi   := Val(SubStr(cBase, iDig, 1)) * base
		sumdig := SumDig+auxi
		base   += 1

	next iDig

	auxi := mod(Sumdig,11)
	If auxi == 10
		auxi := "1"
	ElseIf auxi == 1 .or. auxi == 0
		auxi := "0"
	Else
		auxi := str(11-auxi,1,0)
	EndIf

Return(auxi)


/******************************************************************************************************************/
Static Function RetNN_CX()    //CAIXA
	/******************************************************************************************************************/
	Local cEE__NOSSO:= "14"+STRZERO(VAL(SEE->EE_FAXATU),15)
	Local cTexto:= cEE__NOSSO

	cRet:= cEE__NOSSO // sangelles+ "-" + Modu11(cTexto)

	/* Atualizar o nosso numero no cadastro do banco */
	DbSelectArea("SEE")
	RecLock("SEE", .f.)
	Replace SEE->EE_FAXATU	With Soma1(SEE->EE_FAXATU)
	MsUnlock()

Return cRet

/******************************************************************************************************************/
Static Function RetNN_SF()    //SAFRA
	/******************************************************************************************************************/
	Local SAF_NOSSO:= STRZERO(VAL(SEE->EE_FAXATU),9)   
	Local cTexto:= SAF_NOSSO
	Local cProximo

	cRet := SAF_NOSSO // sangelles+ "-" + Modu11(cTexto)

	/* Atualizar o nosso numero no cadastro do banco */
	DbSelectArea("SEE")
	RecLock("SEE", .F.)                               
	Replace SEE->EE_FAXATU	With Soma1(AllTrim(SEE->EE_FAXATU),0)
	//SEE->EE_FAXATU := Soma1(AllTrim(SEE->EE_FAXATU),0)
	MsUnlock()

Return cRet

//Banco Abc do Brasil - ROTINA PARA CÁLCULO DO DV DO NOSSO NÚMERO aqui
Static Function Modu10(cLinha)

	Local nSoma:= 0
	Local nResto
	Local nCont
	Local cDigRet
	Local nResult
	Local lDobra:= .f.
	Local cValor
	Local nAux
	Local cUnidad

	For nCont:= Len(cLinha) To 1 Step -1
		lDobra:= !lDobra

		If lDobra
			cValor:= AllTrim(Str(Val(Substr(cLinha, nCont, 1)) * 2))
		Else
			cValor:= AllTrim(Str(Val(Substr(cLinha, nCont, 1))))
		EndIf

		For nAux:= 1 To Len(cValor)
			nSoma += Val(Substr(cValor, nAux, 1))
		Next nAux
	
	Next nCont

	nResto:= MOD(nSoma, 10)

	nResult:= 10 - nResto

	If nResult == 10
		cDigRet:= "0"
	Else
		cDigRet:= StrZero(10 - nResto, 1)
	EndIf


Return cDigRet

//Banco Abc do Brasil - ROTINA PARA CÁLCULO DO DV DO NOSSO NÚMERO aqui
Static Function Dig10ABC(cNum,cAgencia,cCarteira)
	Local nMod  := 10
	local aCons := {2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2}
	local nSoma := 0
	local nDigit := 0
	local nTemp  := 0
	local nI := 0
	local nX := 0 

	cSeq := cAgencia+cCarteira+cNum

	For nI := 1 to Len(cSeq)

		nTemp := Val(SubStr(cSeq,nI,1))*aCons[nI] 

		if len(cValtoChar(nTemp)) > 1
			for nX := 1 to len(cValtoChar(nTemp))
				nSoma += val(SubStr(cValtoChar(nTemp),nX,1))
			next nX
		else
			nSoma += nTemp
		endif

	Next nI

	nDigit := (nSoma % nMod)

	if nDigit < 1
		cDigit := '0'
	else
		cDigit := AllTrim(Str(nMod - nDigit))
	endif

Return cDigit


/*/{Protheus.doc} RetDV_DayC
	Função responsavel pelo retorno do digito verificado do nosso numero do banco daycoval, segindo a regra abaixo.
	Sejam eles:

AAAA = Código da agência do título, sem DV.
CCC = Código da carteira (vide e-mail)
NNNNNNNNNN O nosso número, sem DV
Multiplica-se cada algarismo do número formado pela composição dos campos acima pela sequência de multiplicadores 2,1,2,1,2,1,2 (posicionados da direita para a esquerda).
. Se a multiplicação resultar > 9 (por exemplo = 12), somar os dígitos (1 + 2).
. A seguir, soma-se os algarismos dos produtos e o total obtido é dividido por 10. O DV é a diferença entre o divisor (10) e o resto da divisão:
10 - (RESTO DA DIVISAO) = DV. Se o resto da divisão for zero, o DV é zero.
EXEMPLO: Agência: 0001.9 Carteira = 121 Nosso Número = 0004309540

	PESOS: 	AAAACCCNNNNNNNNNN
			21212121212121212

Ou seja:00011210004309540
pesos:	21212121212121212

Parcial: 0+0+0+1+2+2+2+0+0+0+8+3+0+8+(10)+4+0
final:   0+0+0+1+2+2+2+0+0+0+8+3+0+8+(1+0)+4+0

Total 32/10 RESTO => 2, então DV=8
O Nosso Número será a concatenação do código da agência (com DV), da carteira, do nosso número e do DV do nosso número. No exemplo: 00019/121/0004309540-8.

	@type  Static Function
	@author user
	@since 25/11/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function RetDV_DayC(cConteudo , nOpc )
	Local cRet 		:= ""
	Local cText
	Local nX
	Local nParcial 	:= 0
	Local nFinal 	:= 0
	Local nResto
	Local nDigito

	Default nOpc := 1

	if nOpc == 1
		//Nosso Numero
		cText 	:= StrZero(Val(SEE->EE_AGENCIA),04) + StrZero(Val(SEE->EE_CODCART),3) + cConteudo
	Else
		//Linha digitavel
		cText	:= cConteudo
	Endif

	For nX := Len(cText) TO 1 Step -1
		if (nX % 2 ) > 0 // Impar
			nPeso := 2
		Else
			nPeso := 1
		Endif

		nParcial := Val(SubStr(cText,nX,1 )) * nPeso

		if nParcial > 9
			cTemp 		:= cValTochar(nParcial)
			nParcial 	:= Val(SubStr(cTemp,1,1)) + Val(SubStr(cTemp,2,1))
		Endif
		nFinal += nParcial

	Next nX

	//Linha digitavel
	if nOpc != 1
		nFinal *= 9
	Endif

	nRest := nFinal % 10

	if nOpc == 1 .And. nRest > 0
		nDigito := 10 - nRest
	Else
		nDigito := nRest
	Endif

	cRet := cValtoChar(nDigito)

Return cRet
