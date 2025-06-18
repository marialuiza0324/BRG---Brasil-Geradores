#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

//BRG GERADORES
//DATA 07/02/2018
//3RL Solu��es - Ricardo Moreira
//Valida a o centro de custo conforme o parametro SF5 do centro de custo.

User Function MT241TOK()
	Local lRet := .T.//-- Valida��es do usu�rio para inclus�o do movimento
	Local _Tm  := CTM
	Local _MovTm := GetMv("MV_MOVTM") //002,502,560
	Local cUser  := GetMv("MV_BLOQUSE")//000120,000150,000004,000000
	Local cUserid := RetCodUsr()
	Local cLote     := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_LOTECTL"})
	Local cCod      := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_COD"})
	Local cOp       := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_OP"})
	Local nCusto    := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_CUSTO1"})
	Local nOstec    := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_OSTEC"})
	Local cLocal    := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_LOCAL"})
	Local nVlCust   := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_CUSTMOV"})
	Local _cod      := ""
	Local _lote     := ""
	Local _op       := ""
	Local _local    := ""
	Local _Os       := ""
	Local n         := 1
	Local cRastro   := ""
	Local cLoteCtl  := ""
	Local cTMAlm   := SupergetMv("MV_TMALM" , ,)//560
	Local cUserAlm  := SupergetMv("MV_USTMALM", ,)//000121
	Local cTMBaixa  := SupergetMv("MV_BAIXALM" , ,)
	Local cUsrAlm  :=  SupergetMv("MV_USRBAIX", ,)
	Local cBlq01  := SupergetMv("MV_USER01", ,)// Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 13
	Local cRefugo := SupergetMv("MV_REFUGO", ,)
	Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 13
	Local cBlq05  := SupergetMv("MV_USER05", ,)// Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 05
	Local cOpTm := SupergetMv("MV_OPTM", ,) //TMs utilizadas para n�o permitir movimenta��es de produtos fora da OP selecionada

	_cod  := Acols[n,cCod]
	_lote := Acols[n,cLote]
	_op   := Acols[n,cOp]
	_Os   := Acols[n,nOstec]
	_local:= Acols[n,cLocal]


	//Tratamento para n�o fazer devolu��o 24/02/2021
	If cFilAnt == "0101"
		If _Tm $ cOpTm .AND. !EMPTY(_op)
			DbSelectArea("SD3")
			DbSetOrder(18)
			If !dbSeek(xFilial("SD3")+_op+_cod+_lote)  //Criar o Indice 18
				Help(, ,"AVISO#0018", ,"Produto e/ou Lote n�o encontrado na Ordem De Produ��o:" + cvaltochar(_op)+"",1, 0, , , , , , ;
					{"A TM: " +cOpTm+ " exige que as devolu��es sejam realizadas apenas para itens que foram baixados atrav�s da OP:" + cvaltochar(_op)+ ""})
				_lok := .F.
			EndIf
		EndiF
	EndiF



	/*Valida a movimenta��o de determinadas TMs para usu�rios autorizados, 
	  validar a movimenta��o de OS - Maria Luiza - 07/08/2024
	*/
	If _Tm $ _MovTm .AND. FunName() <> "MATA185"//verifica se TM est� contida no par�metro
		If !(cUserid $ cUser) //verifica se usu�rio est� contido no par�metro
			Help(, ,"AVISO#0005", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para utilizar TM selecionada",1, 0, , , , , , {"Utilize uma TM permitida para este usu�rio"})
			lRet := .F.//caso estejs, n�o permite salvar
		EndIf
	EndIf

	If SF5->F5_XOS == "S" .AND. FunName() <> "MATA185" //valida se TM movimenta estoque e na rotina de baixa, n�o verifica campo da OS
		If Empty(_Os) //se movimentar, verifica se o campo de OS esta vazio
			Help(, ,"AVISO#0007", ,"TM movimenta estoque",1, 0, , , , , , {"Preencha o campo OS"})
			lRet := .F.//n�o permite salvar
		EndIf
	ElseIf SF5->F5_XOS == "N" .AND. !Empty(_Os) //se TM n�o movimentar estoque, n�o permite preencher o campo se OS
		Help(, ,"AVISO#0008", ,"TM n�o movimenta estoque",1, 0, , , , , , {"Campo OS n�o pode ser preenchido"})
		lRet := .F.//n�o permite salvar
	EndIf




		/* Valida se produto possui rastreabilidade por lote, caso tenha, n�o permite campo de lote
	ficar vazio - Maria Luiza - 08/08/2024
	*/
	cLoteCtl  := Posicione('SB1', 1, FWxFilial('SB1') + _cod, 'B1_RASTRO')//retorna se produto possui rastro

	If SF5->F5_QTDZERO == "2" .AND. cLoteCtl ==  "L"//Valida se produto possiu rastro
		If Empty(_lote) //valida se campo de lote esta vazio
			Help(, ,"AVISO#0006", ,"Produto possui rastreabilidade",1, 0, , , , , , {"Preencha o campo de LOTE"})
			lRet := .F.//n�o permite salvar
		EndIf
	EndIf




	/* Valida��o para usu�rios do almoxarifado conseguirem utilizar a movimenta��o m�ltipla para transfer�ncia dos itens
	do armaz�m atual para o armaz�m 99, uilizando apenas a TM permitida no par�metro MV_TMALM - Maria Luiza - 05/11/2024
	*/
	If _Tm  $ cTMAlm .AND. FunName() <> "MATA185" //verifica se usu�rio est� utilizando TM que est� fora do par�metro,s� entra na valida��o na rotina MATA241
		If !(cUserid $ cUserAlm)
			Help(, ,"AVISO#0003", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para utilizar TM selecionada",1, 0, , , , , , {"Utilize a(s) TM(s) : " +cTMAlm})
			lRet := .F.//n�o permite salvar
		EndIf
	EndIf





	/* Valida��o para usu�rios contidos no par�metro MV_USRBAIX conseguirem realizar baixa 
	utilizando as TM's contidas no par�metro MV_BAIXALM na empresa GRID - Maria Luiza - 19/12/2024
	*/

	If cFilAnt == "0501"
		If cUserid $ cUsrAlm
			If !(_Tm  $ cTMBaixa) .AND. FunName() <> "MATA241"//valida se usu�rio est� usando TM que n�o est� contida no par�metro, s� entra na valida��o na rotina de baixa
				Help(, ,"AVISO#0011", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para utilizar TM selecionada",1, 0, , , , , , {"Utilize uma TM permitida para este usu�rio"})
				_lok := .F.//n�o permite salvar
			EndIf
		EndIf
	EndIF

	If _local == "99"
		If _Tm  $ cTMAlm .AND. Empty(_op ) //Verifica se campo da OP esta vazio
			Help(, ,"AVISO#0009", ,"Campo da OP vazio.",1, 0, , , , , , {"Preencha o campo da OP."})
			lRet := .F.//n�o permite salvar
		EndIf
	End


	/*Valida��es para que o usu�rio Levy consiga realizar baixa de OS somente no armaz�m 01 na GRID
	  Solicitado pela Giu - Maria Luiza - 18/12/2024*/

	If cFilAnt == "0501"
		If cUserid $ cBlq01 .AND. FunName() <> "MATA241"//valida se usu�rio est� usando TM que n�o est� contida no par�metro, s� entra na valida��o na rotina MATA185
			If SCP->CP_LOCAL <> "01"
				Help(, ,"AVISO#0012", ,"Usu�rio " +cUserName+ " n�o autorizado a baixar Pre Requisi��o nesse Almoxarifado",1, 0, , , , , , {"Realize baixa no almoxarifado 01"})
				lRet:=.F.
			Else
				If Empty(_Os)
					Help(, ,"AVISO#0013", ,"Campo de OS vazio",1, 0, , , , , , {"Preencha o campo da OS"})
					lRet:=.F.
				EndIf
			EndIf
		EndIf
	EndIf


		/*Valida��es para que o usu�rio Levy consiga realizar baixa somente no armaz�m 13 na BRG
	  Solicitado pela Giu - Maria Luiza - 16/01/2025*/
	  
	
	If cFilAnt == "0101"
		If cUserid $ cBlq13 .and. _local <> "13"
			Help(, ,"AVISO#0016", ,"Usu�rio n�o pode movimentar neste armaz�m",1, 0, , , , , , {"Utilize o armaz�m 13"})
			_lok:=.F.
		EndIf
	EndIf




	/*Valida��es para que os usu�rios s� utilizem a TM 009 para o armaz�m 21 e para itens de refugo
		Maria Luiza - 09/01/2024*/

	If _Tm = "009"
		If _local <> "21"
			Help(, ,"AVISO#0014", ,"TM n�o pode ser utilizada neste armaz�m",1, 0, , , , , , {"Utilize o armaz�m 21"})
			lRet:=.F.
		EndIf
		If !(Alltrim(_cod) $ cRefugo)
			Help(, ,"AVISO#0015", ,"TM n�o pode ser utilizada para este produto",1, 0, , , , , , {"Utilize um item de REFUGO"})
			lRet:=.F.
		EndIf
	EndIf




	/*Valida��o para que usu�rio do Jos� Carlos s� consiga movimentar no armaz�m 05
	Solicitado pela Giu - Maria Luiza - 16/01/2024*/

	If cUserid $ cBlq05 .and. _local <> "05"
		Help(, ,"AVISO#0017", ,"Usu�rio n�o pode movimentar neste armaz�m",1, 0, , , , , , {"Utilize o armaz�m 05"})
		lRet:=.F.
	EndIf

	DbSelectArea("SF5")
	DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
	dbSeek(xFilial("SF5")+_Tm)

	IF SF5->F5_CC == "S"
		IF EMPTY(CCC)
			Alert("Por Favor Preencher o Centro de Custo!!!")
			lRet := .F.
		EndIf
	End

	If cFilAnt == "0101"
		If CTM = '001' //.AND. !EMPTY(_op)  devolu��o
			FOR n := 1 TO len(aCols)
				DbSelectArea("SD3")
				DbSetOrder(18)
				If !dbSeek(xFilial("SD3")+_op+_cod+_lote)  //Criar o Indice
					lRet := .F.
					MSGINFO("Produto e/ou Lote n�o encontrado na Ordem De Produ��o:" + cvaltochar(_op)+"!!!!"," Aten��o ")

				else
					//VALIDA��O PARA N�O DEIXAR SAIR MAIS DO ENTROU 03/03/2023 INICIO
					DbSelectArea("SB1")
					DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
					DbSeek(xFilial("SB1")+_cod)
					cRastro := SB1->B1_RASTRO
					IF cRastro = "N"
						//Query foco na SB2
						If Select("TMP1") > 0
							TMP1->(DbCloseArea())
						EndIf

						cQry := " "
						cQry += "SELECT B2_FILIAL, B2_COD, B2_LOCAL, B2_QATU, "
						cQry += "(ISNULL((SELECT ISNULL(SUM(SD3.D3_QUANT),0) FROM SD3010 SD3 WHERE SB2.B2_FILIAL = SD3.D3_FILIAL  AND SB2.B2_COD = SD3.D3_COD  AND SB2.B2_LOCAL= SD3.D3_LOCAL AND SD3.D3_OP = '" + _op + "'  AND  SD3.D3_TM = '501' AND SD3.D3_ESTORNO = ' '  AND SD3.D_E_L_E_T_ <> '*'),0)) AS Qtd_Sai, "
						cQry += "(ISNULL((SELECT ISNULL(SUM(SD33.D3_QUANT),0) FROM SD3010 SD33 WHERE SB2.B2_FILIAL = SD33.D3_FILIAL  AND SB2.B2_COD = SD33.D3_COD  AND SB2.B2_LOCAL= SD33.D3_LOCAL  AND SD33.D3_OP = '" + _op + "'   AND  SD33.D3_TM = '001' AND SD33.D3_ESTORNO = ' '  AND SD33.D_E_L_E_T_ <> '*'),0)) AS Qtd_Ent "
						cQry += "FROM " + retsqlname("SB2")+" SB2 "
						cQry += "WHERE SB2.D_E_L_E_T_ <> '*' "
						cQry += "AND SB2.B2_COD = '" + _cod + "' "
						cQry += "AND SB2.B2_LOCAL = '" + _local + "' "
						cQry += "AND SB2.B2_FILIAL = '" + cFilAnt + "' "
						cQry += "GROUP BY  B2_FILIAL,  B2_COD, B2_LOCAL, B2_QATU "

						DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP1",.T.,.T.)

						If TMP1->Qtd_Sai - TMP1->Qtd_Ent = 0
							lRet := .F.
							MSGINFO("Quantidade insuficiente para estornar da OP !! "," Aten��o ")
						EndIf

						TMP1->(DbCloseArea())

					else
						//Query foco na SB8
						If Select("TMP1") > 0
							TMP1->(DbCloseArea())
						EndIf

						cQry := " "
						cQry += "SELECT B8_FILIAL, B8_PRODUTO, B8_LOCAL, B8_LOTECTL,B8_SALDO, "
						cQry += "(ISNULL((SELECT ISNULL(SUM(SD3.D3_QUANT),0) FROM SD3010 SD3 WHERE SB8.B8_FILIAL = SD3.D3_FILIAL  AND SB8.B8_PRODUTO = SD3.D3_COD  AND SB8.B8_LOCAL= SD3.D3_LOCAL AND SD3.D3_LOTECTL = '" + _lote + "'  AND SD3.D3_OP = '" + _op  + "'  AND  SD3.D3_TM = '501' AND SD3.D3_ESTORNO = ' '  AND SD3.D_E_L_E_T_ <> '*'),0)) AS Qtd_Sai, "
						cQry += "(ISNULL((SELECT ISNULL(SUM(SD33.D3_QUANT),0) FROM SD3010 SD33 WHERE SB8.B8_FILIAL = SD33.D3_FILIAL  AND SB8.B8_PRODUTO = SD33.D3_COD  AND SB8.B8_LOCAL= SD33.D3_LOCAL  AND SD33.D3_LOTECTL = '" + _lote + "'  AND SD33.D3_OP = '" + _op  + "'  AND  SD33.D3_TM = '001' AND SD33.D3_ESTORNO = ' '  AND SD33.D_E_L_E_T_ <> '*'),0)) AS Qtd_Ent "
						cQry += "FROM " + retsqlname("SB8")+" SB8 "
						cQry += "WHERE SB8.D_E_L_E_T_ <> '*' "
						cQry += "AND SB8.B8_PRODUTO = '" + _cod + "' "
						cQry += "AND SB8.B8_LOCAL = '" + _local + "' "
						cQry += "AND SB8.B8_LOTECTL = '" + _lote + "' "
						cQry += "AND SB8.B8_FILIAL = '" + cFilAnt + "' "
						cQry += "GROUP BY B8_FILIAL, B8_PRODUTO, B8_LOCAL, B8_LOTECTL,B8_SALDO "

						DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP1",.T.,.T.)

						If TMP1->Qtd_Sai - TMP1->Qtd_Ent = 0
							lRet := .F.
							MSGINFO("Quantidade insuficiente para estornar da OP !! "," Aten��o ")
						EndIf

						TMP1->(DbCloseArea())

					EndIf
					//VALIDA��O PARA N�O DEIXAR SAIR MAIS DO ENTROU 03/03/2023 FIM
				EndIf
			NEXT n
		EndiF
	EndiF

	FOR n := 1 TO len(aCols)
		Acols[n,nVlCust] := Acols[n,nCusto]
	NEXT n

Return(lRet)
