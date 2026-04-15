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
	Local _MovTm := GetMv("MV_MOVTM") //002,502,560
	Local cUser  := GetMv("MV_BLOQUSE")//000120,000150,000004,000000
	Local cUserid := RetCodUsr()
	Local cNome   := UsrFullName(cUserid)
	Local cLote     := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_LOTECTL"})
	Local cCod      := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_COD"})
	Local cOp       := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_OP"})
	Local nOstec    := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_OSTEC"})
	Local cLocal    := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_LOCAL"})
	Local cQuant    := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_QUANT"})
	//Local cCentrCusto := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_CC"})
	Local _quant	:= ""
	Local _cod      := ""
	Local _lote     := ""
	Local _op       := ""
	Local _local    := ""
	Local _Os       := ""
	//Local _CC      := ""
	Local n         := 1
	Local cLoteCtl  := ""
	Local cTMAlm   := SupergetMv("MV_TMALM" , ,)//560
	Local cUserAlm  := SupergetMv("MV_USTMALM", ,)//000121
	Local cTMBaixa  := SupergetMv("MV_BAIXALM" , ,)
	Local cUsrAlm  :=  SupergetMv("MV_USRBAIX", ,)
	Local cBlq01  := SupergetMv("MV_USER01", ,)// Usuários que somente irão gerar e baixar requisições no almoxarifado 13
	Local cRefugo := SupergetMv("MV_REFUGO", ,)
	Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 13
	Local cBlq05  := SupergetMv("MV_USER05", ,)// Usuários que somente irão gerar e baixar requisições no almoxarifado 05
	Local cBlq12  := SupergetMv("MV_USER12", ,)// Usuários que somente irão gerar e baixar requisições no almoxarifado 12
	Local cOpTm := SupergetMv("MV_OPTM", ,) //TMs utilizadas para não permitir movimentações de produtos fora da OP selecionada
	Local cGrupo05 := SuperGetMV("MV_TRFGR05", ," ")
	Local cGrupo12 := SuperGetMV("MV_TRFGR12", ," ")
	Local cGrupo   := ""
	Local nQtdConsumida  := 0
	Local nQtdDevolvida  := 0
	Local nQtdDisponivel := 0
	Local _CRLF     := Chr(13) + Chr(10)
	Local cQuery	:= ""
	Local cTM       := ""

	_cod  := Acols[n,cCod]
	_lote := Acols[n,cLote]
	_op   := Acols[n,cOp]
	_Os   := Acols[n,nOstec]
	_local:= Acols[n,cLocal]
	_quant:= Acols[n,cQuant]
	//_CC   := Acols[n,cCentrCusto]

	cGrupo   := Posicione('SB1', 1, FWxFilial('SB1') + _cod, 'B1_GRUPO')
	cTM      := Posicione('SD3', 19, xFilial("SD3") + _op + _cod + _lote, 'D3_TM')

	If FunName() <> "MATA185" //Validações da movimentação múltipla, não entra na validação da rotina de baixa

		//Tratamento para não fazer devolução 24/02/2021
		If cFilAnt == "0101"
			If _Tm $ cOpTm .AND. !EMPTY(_op)

				If Select ("TSD3")
					TSD3->(dbCloseArea())
				EndIf

				cQuery := "SELECT D3_QUANT, D3_TM, D3_ESTORNO " +;
					" FROM " + retsqlname("SD3") + " SD3 " +;
					" WHERE D3_FILIAL = '" + xFilial("SD3") + "' AND " +;
					" D3_OP = '" + Alltrim(_op) + "' AND " +;
					" D3_COD = '" + Alltrim(_cod) + "' AND " +;
					" D3_LOTECTL = '" + Alltrim(_lote) + "'" +;
					" AND D_E_L_E_T_ = ' ' "

				DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TSD3",.T.,.T.)

				DbSelectArea("TSD3")

				While !TSD3->(Eof())
					If TSD3->D3_ESTORNO != "S"  // Ignora estornos já feitos
						If TSD3->D3_TM $ "550,999"   // <-- Substitua "XXX" pelas TM(s) de BAIXA/CONSUMO na OP (ex: '999','521' etc.)
							nQtdConsumida += TSD3->D3_QUANT
						ElseIf TSD3->D3_TM $ cOpTm  // TM de devolução/estorno (ex: '050' ou sua TM)
							nQtdDevolvida += TSD3->D3_QUANT
							cTM := TSD3->D3_TM
						EndIf
					EndIf

					TSD3->(DbSkip())
				EndDo

				nQtdDisponivel := nQtdConsumida - nQtdDevolvida

				DbSelectArea("SD3")
				DbSetOrder(19)
				If !dbSeek(xFilial("SD3")+_op+_cod+_lote)  .AND. !LinDelet(acols[n])//Criar o Indice 18
					Help(, ,"AVISO#0018", ,"Produto e/ou Lote não encontrado na Ordem De Produção:" + cvaltochar(_op)+"",1, 0, , , , , , ;
						{"A TM: " +cOpTm+ " exige que as devoluções sejam realizadas apenas para itens que foram baixados através da OP:" + cvaltochar(_op)+ ""})
					lRet := .F.
				ElseIf !Empty(_lote)
					If dbSeek(xFilial("SD3")+_op+_cod+_lote) .AND. cTM = '050' .AND. !LinDelet(acols[n])
						Help(, ,"AVISO#0035", ,"Lote : " + cvaltochar(Alltrim(_lote))+ " já foi devolvido",1, 0, , , , , , ;
							{"Validar se já existe devolução do lote : " + cvaltochar(Alltrim(_lote)) + " utilizando a(s) TM(s) : " + cvaltochar(cOpTm)+ " para esta OP: " + cvaltochar(_op)+ ""})
						lRet := .F.
					EndIf
				EndIf

				If nQtdDisponivel < _quant  // _quant = quantidade informada na devolução atual
					Help(, ,"AVISO#0038", ,"Quantidade insuficiente para devolução. ",1, 0, , , , , , ;
						{"Saldo consumido na OP " + cvaltochar(_op) + " para o item " + Alltrim(_cod) + ;
						" / lote " + Alltrim(_lote) + " = " + Alltrim(Transform(nQtdDisponivel,"@E 999,999,999.99")) + ;
						_CRLF + "Quantidade solicitada para devolução: " + Alltrim(Transform(_quant,"@E 999,999,999.99")) + ;
						_CRLF + "Verifique estornos anteriores ou consumo real na OP."})
					lRet := .F.
					Return(lRet)
				EndIf

				TSD3->(dbCloseArea())
			EndIf
		EndIf

		/*Valida a movimentação de determinadas TMs para usuários autorizados, 
		validar a movimentação de OS - Maria Luiza - 07/08/2024*/
		If _Tm $ _MovTm  //verifica se TM está contida no parâmetro
			If !(cUserid $ cUser) //verifica se usuário está contido no parâmetro
				Help(, ,"AVISO#0005", ,"Usuário " +cUserName+ " não tem permissão para utilizar TM selecionada",1, 0, , , , , , {"Utilize uma TM permitida para este usuário"})
				lRet := .F.//caso estejs, não permite salvar
				Return(lRet)
			EndIf
		EndIf

		If SF5->F5_XOS == "S"  //valida se TM movimenta estoque e na rotina de baixa, não verifica campo da OS
			If Empty(_Os) .AND. !LinDelet(acols[n])//se movimentar, verifica se o campo de OS esta vazio
				Help(, ,"AVISO#0007", ,"TM movimenta estoque",1, 0, , , , , , {"Preencha o campo OS"})
				lRet := .F.//não permite salvar
				Return(lRet)
			EndIf
		ElseIf SF5->F5_XOS == "N" .AND. !Empty(_Os) .AND. !LinDelet(acols[n])//se TM não movimentar estoque, não permite preencher o campo se OS
			Help(, ,"AVISO#0008", ,"TM não movimenta estoque",1, 0, , , , , , {"Campo OS não pode ser preenchido"})
			lRet := .F.//não permite salvar
			Return(lRet)
		EndIf

		/* Validação para usuários do almoxarifado conseguirem utilizar a movimentação múltipla para transferência dos itens
		do armazém atual para o armazém 99, uilizando apenas a TM permitida no parâmetro MV_TMALM - Maria Luiza - 05/11/2024*/
		If !(_Tm  $ cTMAlm) .AND. !LinDelet(acols[n])//verifica se usuário está utilizando TM que está fora do parâmetro,só entra na validação na rotina MATA241
			If cUserid $ cUserAlm
				Help(, ,"AVISO#0003", ,"Usuário " +cUserName+ " não tem permissão para utilizar TM selecionada",1, 0, , , , , , {"Utilize a(s) TM(s) : " +cTMAlm})
				lRet := .F.//não permite salvar
				Return(lRet)
			EndIf
		EndIf

		/*Validação para que usuário do José Carlos só consiga movimentar no armazém 05
		Solicitado pela Giu - Maria Luiza - 16/01/2024
		Ajuste para que o Danilo e Jose Carlos consiga movimentar para o armazém 99
		Solicitado pelo Hugo #GLPI 14438 - Maria Luiza 03/02/2026*/
		If cUserid $ cBlq05 
			If _local <> "05" .AND. !LinDelet(acols[n])
				Help(, ,"AVISO#0017", ,"Usuário não pode movimentar neste armazém",1, 0, , , , , , {"Utilize o armazém 05"})
				lRet:=.F.
				Return(lRet)
			EndIf
			If !(cGrupo $ cGrupo05) .AND. !LinDelet(acols[n])
				lRet := .F.
				Help(, ,"AVISO#0036", ,"Usuário " +cNome+ " não tem permissão para movimentar este produto",1, 0, , , , , , {"Utilize produtos do(s) grupo(s) : " +cGrupo05})
				Return(lRet)
			EndIf
		ElseIf cUserid $ cBlq12  .AND. FunName() <> "MATA185"
			If _local <> "12" .AND. !LinDelet(acols[n])
				Help(, ,"AVISO#0017", ,"Usuário não pode movimentar neste armazém",1, 0, , , , , , {"Utilize o armazém 12"})
				lRet:=.F.
				Return(lRet)
			EndIf
			If !(cGrupo $ cGrupo12) .AND. !LinDelet(acols[n])
				lRet := .F.
				Help(, ,"AVISO#0037", ,"Usuário " +cNome+ " não tem permissão para movimentar este produto",1, 0, , , , , , {"Utilize produtos do(s) grupo(s) : " +cGrupo12})
				Return(lRet)
			EndIf
		EndIf

		If _local == "99"
			If _Tm  $ cTMAlm .AND. Empty(_op ) .AND. !LinDelet(acols[n])//Verifica se campo da OP esta vazio
				Help(, ,"AVISO#0009", ,"Campo da OP vazio.",1, 0, , , , , , {"Preencha o campo da OP."})
				lRet := .F.//não permite salvar
				Return(lRet)
			EndIf
		EndIf

		/* Valida se produto possui rastreabilidade por lote, caso tenha, não permite campo de lote
		ficar vazio - Maria Luiza - 08/08/2024*/
		cLoteCtl  := Posicione('SB1', 1, FWxFilial('SB1') + _cod, 'B1_RASTRO')//retorna se produto possui rastro

		If SF5->F5_QTDZERO == "2" .AND. cLoteCtl ==  "L"//Valida se produto possiu rastro
			If Empty(_lote) .AND. !LinDelet(acols[n])//valida se campo de lote esta vazio
				Help(, ,"AVISO#0006", ,"Produto possui rastreabilidade",1, 0, , , , , , {"Preencha o campo de LOTE"})
				lRet := .F.//não permite salvar
				Return(lRet)
			EndIf
		EndIf

		DbSelectArea("SF5")
		DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
		dbSeek(xFilial("SF5")+_Tm)

		IF SF5->F5_CC == "S"
			IF EMPTY(CCC)
				Alert("Por Favor Preencher o Centro de Custo!!!")
				lRet := .F.
				Return(lRet)
			EndIf
		EndIf

		/*Validações para que os usuários só utilizem a TM 009 para o armazém 21 e para itens de refugo
		Maria Luiza - 09/01/2024*/
		If _Tm = "009"
			If _local <> "21" .AND. !LinDelet(acols[n])
				Help(, ,"AVISO#0014", ,"TM não pode ser utilizada neste armazém",1, 0, , , , , , {"Utilize o armazém 21"})
				lRet:=.F.
				Return(lRet)
			EndIf
			If !(Alltrim(_cod) $ cRefugo) .AND. !LinDelet(acols[n])
				Help(, ,"AVISO#0015", ,"TM não pode ser utilizada para este produto",1, 0, , , , , , {"Utilize um item de REFUGO"})
				lRet:=.F.
				Return(lRet)
			EndIf
		EndIf 

	EndIf

	If FunName() <> "MATA241" //Validações da baixa, não entra na validação da movimentação múltipla
		
		/* Validação para usuários contidos no parâmetro MV_USRBAIX conseguirem realizar baixa 
		utilizando as TM's contidas no parâmetro MV_BAIXALM na empresa GRID - Maria Luiza - 19/12/2024*/
		If cFilAnt == "0501"
			If cUserid $ cUsrAlm
				If !(_Tm  $ cTMBaixa).AND. !LinDelet(acols[n])//valida se usuário está usando TM que não está contida no parâmetro, só entra na validação na rotina de baixa
					Help(, ,"AVISO#0011", ,"Usuário " +cUserName+ " não tem permissão para utilizar TM selecionada",1, 0, , , , , , {"Utilize uma TM permitida para este usuário"})
					lRet := .F.//não permite salvar
					Return(lRet)
				EndIf
			EndIf
		EndIF

		/*Validações para que o usuário Levy consiga realizar baixa de OS somente no armazém 01 na GRID
		Solicitado pela Giu - Maria Luiza - 18/12/2024*/
		If cFilAnt == "0501"
			If cUserid $ cBlq01//valida se usuário está usando TM que não está contida no parâmetro, só entra na validação na rotina MATA185
				If SCP->CP_LOCAL <> "01" .AND. !LinDelet(acols[n])
					Help(, ,"AVISO#0012", ,"Usuário " +cUserName+ " não autorizado a baixar Pre Requisição nesse Almoxarifado",1, 0, , , , , , {"Realize baixa no almoxarifado 01"})
					lRet:=.F.
					Return(lRet)
				Else
					If Empty(_Os) .AND. !LinDelet(acols[n])
						Help(, ,"AVISO#0013", ,"Campo de OS vazio",1, 0, , , , , , {"Preencha o campo da OS"})
						lRet:=.F.
						Return(lRet)
					EndIf
				EndIf
			EndIf
		EndIf

		/*Validações para que o usuário Levy consiga realizar baixa somente no armazém 13 na BRG
		Solicitado pela Giu - Maria Luiza - 16/01/2025*/
		If cFilAnt == "0101"
			If cUserid $ cBlq13 .and. _local <> "13"  .AND. !LinDelet(acols[n])
				Help(, ,"AVISO#0016", ,"Usuário não pode movimentar neste armazém",1, 0, , , , , , {"Utilize o armazém 13"})
				lRet:=.F.
				Return(lRet)
			EndIf
		EndIf

		/* Valida se produto possui rastreabilidade por lote, caso tenha, não permite campo de lote
		ficar vazio - Maria Luiza - 08/08/2024*/
		cLoteCtl  := Posicione('SB1', 1, FWxFilial('SB1') + _cod, 'B1_RASTRO')//retorna se produto possui rastro

		If SF5->F5_QTDZERO == "2" .AND. cLoteCtl ==  "L"//Valida se produto possiu rastro
			If Empty(_lote) .AND. !LinDelet(acols[n])//valida se campo de lote esta vazio
				Help(, ,"AVISO#0006", ,"Produto possui rastreabilidade",1, 0, , , , , , {"Preencha o campo de LOTE"})
				lRet := .F.//não permite salvar
				Return(lRet)
			EndIf
		EndIf

		DbSelectArea("SF5")
		DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
		dbSeek(xFilial("SF5")+_Tm)

		IF SF5->F5_CC == "S"

			IF EMPTY(CCC)
				Alert("Por Favor Preencher o Centro de Custo!!!")
				lRet := .F.
				Return(lRet)
			EndIf
		EndIf


		/*Validação de TMs de baixa – Almoxarifado #GLPI 14911
		  Solicitado pelo Matheus - Maria Luiza - 23/03/2026
		*/

		If _Tm == "503"
			If Empty(CCC) .OR. !Empty(_op) .OR. !Empty(_Os) .AND. !LinDelet(acols[n])
				Help(, ,"AVISO#0039", ,"TM utilizada exclusivamente para baixa em Centro de Custo.",1, 0, , , , , , {"Para utilização da TM 503, os campos de OP e OS devem estar vazios e o Centro de Custo é obrigatório"})
				lRet := .F.
				Return(lRet)
			EndIf
		ElseIf _Tm == "506"
			If Empty(CCC) .AND. (Empty(_Os) .OR. !("OS" $ _op) .OR. !Empty(_op)) .AND. !LinDelet(acols[n])
				Help(, ,"AVISO#0040", ,"TM utilizada exclusivamente para baixa em Ordem de Serviço de manutenção.",1, 0, , , , , , {"Para utilização da TM 506, o campo de OP deve estar vazio ou a OP vinculada a manutenção e o Centro de Custo e OS são obrigatórios"})
				lRet := .F.
				Return(lRet)
			EndIf 
		ElseIf _Tm == "550"
			If !Empty(CCC) .OR. Empty(_op) .OR. !Empty(_Os) .AND. !LinDelet(acols[n])
				Help(, ,"AVISO#0041", ,"TM utilizada exclusivamente para baixa em Ordem de Produção.",1, 0, , , , , , {"Para utilização da TM 550, os campos de OS e Centro de Custo devem estar vazios e o campo de OP é obrigatório"})
				lRet := .F.
				Return(lRet)
			EndIf
		EndIf

	EndIf

Return(lRet)
