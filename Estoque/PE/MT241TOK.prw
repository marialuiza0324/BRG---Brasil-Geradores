#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

//BRG GERADORES
//DATA 07/02/2018
//3RL Soluções - Ricardo Moreira
//Valida a o centro de custo conforme o parametro SF5 do centro de custo.

User Function MT241TOK()
	Local lRet := .T.//-- Validações do usuário para inclusão do movimento
	Local _Tm  := CTM
	Local _MovTm := GetMv("MV_MOVTM") //002,005,502,505 (bloquear)
	Local cUser  := GetMv("MV_BLOQUSE")
	Local cUserid := RetCodUsr()
	//Local cCodUser  := RetCodUsr() //Retorna o Codigo do Usuario
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


	_cod  := Acols[n,cCod]
	_lote := Acols[n,cLote]
	_op   := Acols[n,cOp]
	_Os   := Acols[n,nOstec]
	_local:= Acols[n,cLocal]


	If _Tm $ _MovTm //verifica se TM está contida no parâmetro
		If !(cUserid $ cUser) //verifica se usuário está contido no parâmetro
			FWAlertInfo("Usuário não autorizado à movimentar TM selecionada","Atenção!!!")
			lRet := .F.//não permite salvar
		EndIf
	ElseIf SF5->F5_XOS == "S" .AND. FunName() <> "MATA185" //verifica se TM movimenta estoque e na rotina de baixa, não verifica campo da OS
		If Empty(_Os) //se movimentar, verifica se o campo de OS esta vazio
			FWAlertInfo("Preencher campo da OS","Atenção!!!")
			lRet := .F.//não permite salvar
		EndIf
	EndIf 

	cLoteCtl  := Posicione('SB1', 1, FWxFilial('SB1') + _cod, 'B1_RASTRO')

	If SF5->F5_QTDZERO == "2" .AND. cLoteCtl ==  "L"//Valida se produto possiu rastro
		If Empty(_lote) //valida se campo de lote esta vazio
			FWAlertInfo("Preencher o campo LOTE, pois produto possui restreabilidade","Atenção!!")
			lRet := .F.//não permite salvar
		EndIf
	EndIf

	

	/*If cFilAnt $ "0101/0901"    //000041 - Guilherme engenharia    //000049 - Guilherme BRG
		IF !(__CUSERID $ "000000/000031/000049/000004/000120/000150")
			IF !empty(_Os) .and. !empty(_lote)
				lRet := .F.
				MSGINFO("Usuário não tem permissão para devolver item da OS com lote !!! "," Atenção ")
			endIf
		EndIf
		If CTM $ _MovTm .and. empty(_Os)
			lRet := .F.
			MSGINFO("Movimentação de TM não Permitida !!! "," Atenção ")
		EndIf
	Else
		If !(__CUSERID $ "000000/000031/000041/000120/000150")
			IF !empty(_Os) .and. !empty(_lote)
				lRet := .F.
				MSGINFO("Usuário não tem permissão para devolver item da OS com lote !!! "," Atenção ")
			endIf
		EndiF
		If CTM $ _MovTm
			lRet := .F.
			MSGINFO("Movimentação de TM não Permitida !!! "," Atenção ")
		EndIf

	EndIf*/

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
		If CTM = '001' //.AND. !EMPTY(_op)  devolução
			FOR n := 1 TO len(aCols)
				DbSelectArea("SD3")
				DbSetOrder(18)
				If !dbSeek(xFilial("SD3")+_op+_cod+_lote)  //Criar o Indice
					lRet := .F.
					MSGINFO("Produto e/ou Lote não encontrado na Ordem De Produção:" + cvaltochar(_op)+"!!!!"," Atenção ")

				else
					//VALIDAÇÃO PARA NÃO DEIXAR SAIR MAIS DO ENTROU 03/03/2023 INICIO
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
							MSGINFO("Quantidade insuficiente para estornar da OP !! "," Atenção ")
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
							MSGINFO("Quantidade insuficiente para estornar da OP !! "," Atenção ")
						EndIf

						TMP1->(DbCloseArea())

					EndIf
					//VALIDAÇÃO PARA NÃO DEIXAR SAIR MAIS DO ENTROU 03/03/2023 FIM
				EndIf
			NEXT n
		EndiF
	EndiF

	FOR n := 1 TO len(aCols)
		Acols[n,nVlCust] := Acols[n,nCusto]
	NEXT n

//VALIDAÇÃO PARA NÃO DEIXAR SAIR MAIS DO ENTROU 03/03/2023 INICIO
/*
If Select("TMP2") > 0
	TMP2->(DbCloseArea())
EndIf  

cQry1 := " "
cQry1 += "SELECT SUM(D3_QUANT) TOTAPON  "
cQry1 += "FROM " + retsqlname("SD3")+" SD3 "
cQry1 += "WHERE SD3.D_E_L_E_T_ <> '*' " 
cQry1 += "AND D3_FILIAL = '" + cFilAnt + "' "
cQry1 += "AND D3_TM = '005' "
cQry1 += "AND D3_ESTORNO = '  ' "
cQry1 += "AND D3_OP = '" + _Op + "' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry1)),"TMP2",.T.,.T.) 

_QtTSd3 := TMP2->TOTAPON  

TMP2->(DbCloseArea())

If _QtTSd3 > 0 //Alerta de Quantidade Devolvida no apontamento.
   ALERT("Existe Quantidade Devolvida de:  " +cvaltochar(_QtTSd3))
EndIf


//VALIDAÇÃO PARA NÃO DEIXAR SAIR MAIS DO ENTROU 03/03/2023 FIM
*/

Return(lRet)
