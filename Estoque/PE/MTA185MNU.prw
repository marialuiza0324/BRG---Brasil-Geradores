#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "topconn.ch"

//06/04/2020
//Adiciona um Menu na Rotina Baixa de Solicitação
//Brg Geradores


User function MTA185MNU()

	aAdd(aRotina,{ "Novo Termo Retirada", "U_Termo()", 0,8,0, NIL})

Return aRotina

//06/04/2020
//Imprime o Termo de Retirada
//Brg Geradores


User function Termo()

	Local _aBmp := {}
	Local _user := ""
	//Local _CpNum := ""
	Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
	Private oFont6N 	:= TFONT():New("ARIAL",7,6,,.T.,,,,.T.,.F.) ///Fonte 6 Negrito
	Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
	Private oFont8N 	:= TFONT():New("ARIAL",8,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
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
	Private cPerg       := PADR("Termo",Len(SX1->X1_GRUPO))
	Private cStartPath
	Private nLin 		:= 0
	Private oPrint		:= TMSPRINTER():New("")
	Private nPag		:= 1
	Private _Emp
	Private nRepita // variavel que controla a quantidade de relatorios impressos
	Private nContador // contador do for principal, que imprime o relatorio n vezes
	Private nZ
	Private nJ
	Private cLogoD
	Private nSaldoAtu := 0
	Private nSaldoFisico    := 0
	Private nSaldoComprometido := 0
	Private nSaldoDisponivel := 0
	Private cLogo
	Private cRequis 

	ValidPerg1()
	pergunte(cPerg,.T.)    // sem tela de pergunta

//Private _SomSbf := 0
//Private  cStartPath := GETPVPROFSTRING(GETENVSERVER(),"StartPath","ERROR",GETADV97())
//cStartPath += IF(RIGHT(cStartPath,1) <> "\","\","")
//         cLogoD     := cStartPath + "LGRL" + cFilAnt + ".BMP"
//cLogoD     :=  "LGRL" + cEmpAnt+ ".BMP"

//³Define Tamanho do Papel                                                  ³

	#define DMPAPER_A4 9 //Papel A4
	oPrint:setPaperSize( DMPAPER_A4 )

//oPrint:SetPortrait()///Define a orientacao da impressao como retrato
	oPrint:SetLandscape() ///Define a orientacao da impressao como paisagem
//³Monta Query com os dados que serão impressos no relatório            ³

	oPrint:StartPage()
	cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
	cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")

	cLogo := cStartPath + "orc/" + cfilant + ".png"

	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf

	//_CpNum := StrTran(alltrim(MV_PAR01),",","','")
	_cQry := " "
	_cQry += "SELECT  CP_FILIAL , CP_NUM, CP_ITEM, CP_NUMOS, CP_PRODUTO, CP_DESCRI, CP_XENDERE, CP_UM, CP_QUANT, CP_OP, CP_LOCAL, CP_LOTE, CP_OBS, CP_EMISSAO, CP_SOLICIT "
	_cQry += "FROM " + retsqlname("SCP")+" SCP "
	_cQry += "WHERE SCP.D_E_L_E_T_ <> '*' "
	_cQry += "AND CP_FILIAL = '" +xFilial("SCP") + "'
	_cQry += "AND CP_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQry += "ORDER BY CP_FILIAL,CP_NUM, CP_SOLICIT, CP_PRODUTO  "

	_cQry := ChangeQuery(_cQry)
	TcQuery _cQry New Alias "TMP"

	dbSelectArea("TMP")
	dbgotop()
	While TMP->(!EOF())

		oPrint:StartPage()

		nLin+=100
		oPrint:SayBitmap(nLin+010, 0160, cLogo, 350, 220)

		nLin+=50
		//	oPrint:Say(nLin, 2100, "Pagina: " + strzero(nPag,3), oFont8N)
		oPrint:Say(nLin, 1500,  ("T E R M O  D E  R E T I R A D A"), oFont14NS)

		nLin+=200

		oPrint:Say(nLin, 50,   ("Nr. S. A."), oFont8)
		oPrint:Say(nLin, 250,  ("Solicitante"), oFont8)
		oPrint:Say(nLin, 450,  ("Nr. OS"), oFont8)
		oPrint:Say(nLin, 600,  ("Item"), oFont8)
		oPrint:Say(nLin, 750,  ("Produto"), oFont8)
		oPrint:Say(nLin, 950, ("Descrição"), oFont8)
		oPrint:Say(nLin, 1450, ("Local"), oFont8)
		oPrint:Say(nLin, 1600, ("Quantidade"), oFont8)
		oPrint:Say(nLin, 1850, ("Und"), oFont8)
		oPrint:Say(nLin, 2050, ("Endereço"), oFont8)
		oPrint:Say(nLin, 2220, ("Ord. Produção"), oFont8)
		oPrint:Say(nLin, 2450, ("N. Lote"), oFont8)
		oPrint:Say(nLin, 2650, ("Dt. Emissão"), oFont8)
		oPrint:Say(nLin, 2850, ("Saldo Atual"), oFont8)
		oPrint:Say(nLin, 3050, ("Saldo Disponível"), oFont8)
		nLin+=100
		_user := TMP->CP_SOLICIT
		cRequis := TMP->CP_NUM

		While TMP->(!EOF()) .AND. cRequis = TMP->CP_NUM //_user = TMP->CP_SOLICIT

			oPrint:Say(nLin, 0050, TMP->CP_NUM , oFont8N)
			oPrint:Say(nLin, 0250, TMP->CP_SOLICIT , oFont8N)
			oPrint:Say(nLin, 0460, TMP->CP_NUMOS , oFont8N)
			oPrint:Say(nLin, 0610, TMP->CP_ITEM , oFont8N)
			oPrint:Say(nLin, 0760, TMP->CP_PRODUTO , oFont8N)
			oPrint:Say(nLin, 960, TMP->CP_DESCRI , oFont8N)
			oPrint:Say(nLin, 1460, TMP->CP_LOCAL , oFont8N)
			oPrint:Say(nLin, 1600, Transform(TMP->CP_QUANT, "@e 999,999,999.999"), oFont8N)   //VER
			oPrint:Say(nLin, 1860, TMP->CP_UM , oFont8N)
			oPrint:Say(nLin, 2060, TMP->CP_XENDERE, oFont8N)
			oPrint:Say(nLin, 2230, TMP->CP_OP, oFont8N)
			oPrint:Say(nLin, 2450, TMP->CP_LOTE, oFont8N)
			oPrint:Say(nLin, 2650, CVALTOCHAR(STOD(TMP->CP_EMISSAO)), oFont8N)
			nSaldoAtu := Posicione("SB2",1,FWxFilial('SB2')+ TMP->CP_PRODUTO+TMP->CP_LOCAL,'B2_QATU')
			oPrint:Say(nLin, 2870,cValToChar(nSaldoAtu), oFont8N)

			// Consultar o saldo físico na tabela SB2
			DbSelectArea("SB2")
			DbSetOrder(1) // Índice pela chave de produto

			// Verifica se o registro foi encontrado
			If DbSeek(FWxFilial('SB2')+TMP->CP_PRODUTO + TMP->CP_LOCAL)
				nSaldoFisico    := SB2->B2_QATU
				nSaldoComprometido :=  SB2->B2_RESERVA + SB2->B2_QEMP + SB2->B2_QACLASS + SB2->B2_QEMPSA + SB2->B2_QEMPPRJ + SB2->B2_QTNP + SB2->B2_QEMPPRE

				// Se o saldo comprometido for maior que o saldo físico, saldo disponível = 0
				If nSaldoComprometido > nSaldoFisico
					nSaldoDisponivel := 0
				Else
					nSaldoDisponivel := nSaldoFisico - nSaldoComprometido
				EndIf
			EndIf

			oPrint:Say(nLin,3070,cValToChar(nSaldoDisponivel), oFont8N)

			nLin+=50
			If nLin >= 2300 // veja o tamanho adequado da página que este numero pode variar
				oPrint:EndPage() // Finaliza a página
				oPrint:StartPage()
				nLin := 200
			Endif

			TMP->( dbSkip() )
		Enddo

		nLin+=100
		oPrint:Say(nLin, 2300,  ("_________________________________________"), oFont10N)
		oPrint:Say(nLin, 500, alltrim(sm0->m0_cidcob)+","+str(day(DDATABASE))+" de "+	mesextenso(month(DDATABASE))+" de "+str(year(DDATABASE)), oFont10N)

		nLin+=70
		oPrint:Say(nLin, 2500, ("Solicitante"), oFont10N)
		nLin+=70

		oPrint:EndPage() // Finaliza a página

		nLin := 0

	Enddo
	nLin+=70


//oPrint:endPage()
	MS_FLUSH()
	oPrint:Preview()
Return()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao das perguntas dos parametros                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ValidPerg1()
	Local aArea    := GetArea()
	Local aRegs    := {}
	Local i	       := 0
	Local j        := 0
	Local aHelpPor := {}
	Local aHelpSpa := {}
	Local aHelpEng := {}

	aAdd(aRegs,{cPerg,"01","Nr. S. A. De     ?","","","mv_ch1","C",45,0,0,"G","","\",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""})
    aAdd(aRegs,{cPerg,"02","Nr. S. A. Ate    ?","","","mv_ch2","C",06,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","XM0"})


	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:=1 to Len(aRegs)
		If !DbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()

			aHelpPor := {} ; aHelpSpa := {} ; 	aHelpEng := {}
			If i==1
				AADD(aHelpPor,"Informe a(s) Solicitação(ões).             ")
			Endif
			PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
		EndIf
	Next

	RestArea(aArea)
Return


