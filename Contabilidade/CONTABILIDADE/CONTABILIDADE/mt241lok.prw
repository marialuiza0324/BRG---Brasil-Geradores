#include "rwmake.ch"
#Include "SigaWin.ch"

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT241LOK  ¦ Utilizador ¦ Claudio Ferreira ¦ Data ¦ 12/11/15¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na confirmação do mov interno             ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦    
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

#include "rwmake.ch"


user function MT241LOK()
	local _lok:=.t.
	Local cOp       := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_OP"})
	Local nOstec    := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_OSTEC"})
	Local cLote     := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_LOTECTL"})
	Local cCod      := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_COD"})
	Local cLocal    := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_LOCAL"})
	Local _op       := ""
	Local cLoteCtl  := ""
	Local cTMAlm   := SupergetMv("MV_TMALM" , ,)
	Local cUserAlm  := SupergetMv("MV_USTMALM", ,)
	Local _Tm  := CTM
	Local cUserid := RetCodUsr()
	Local _MovTm := GetMv("MV_MOVTM") //002,502
	Local cUser  := GetMv("MV_BLOQUSE")//000120,000150,000004,000000
	Local cTMBaixa  := SupergetMv("MV_BAIXALM" , ,)
	Local cUsrAlm  :=  SupergetMv("MV_USRBAIX", ,)
	Local cBlq01  := SupergetMv("MV_USER01", ,)// Usuários que somente irão gerar e baixar requisições no almoxarifado 01
	Local cRefugo := SupergetMv("MV_REFUGO", ,)
	Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usuários que somente irão gerar e baixar requisições no almoxarifado 13
	Local cBlq05  := SupergetMv("MV_USER05", ,)// Usuários que somente irão gerar e baixar requisições no almoxarifado 05
	Local cOpTm := SupergetMv("MV_OPTM", ,) //TMs utilizadas para não permitir movimentações com campo de OP vazio


	_Os   := Acols[n,nOstec]
	_lote := Acols[n,cLote]
	_cod  := Acols[n,cCod]
	_op   := Acols[n,cOp]
	_local:= Acols[n,cLocal]

	if empty(aCols[n,nPosOP]) .or. 'OS'$aCols[n,nPosOP]
		if empty(cCc)
			_lok:=.f.
			FWAlertInfo("MT241LOK: Para este tipo de movimento o centro de custo deve ser informado!")
		endif
	endif


	//Tratamento para não fazer devolução 24/02/2021
	If cFilAnt == "0101"
		If _Tm $ cOpTm .AND. !EMPTY(_op)
			DbSelectArea("SD3")
			DbSetOrder(18)
			If !dbSeek(xFilial("SD3")+_op+_cod+_lote)  //Criar o Indice 18
				Help(, ,"AVISO#0018", ,"Produto e/ou Lote não encontrado na Ordem De Produção:" + cvaltochar(_op)+"",1, 0, , , , , , ;
					{"A TM: " +cOpTm+ " exige que as devoluções sejam realizadas apenas para itens que foram baixados através da OP:" + cvaltochar(_op)+ ""})
				_lok := .F.
			EndIf
		EndiF
	EndiF



	/*Valida a movimentação de determinadas TMs para usuários autorizados, 
	  validar a movimentação de OS - Maria Luiza - 07/08/2024
	*/
	If _Tm $ _MovTm .AND. FunName() <> "MATA185"//verifica se TM está contida no parâmetro
		If !(cUserid $ cUser) //verifica se usuário está contido no parâmetro
			Help(, ,"AVISO#0005", ,"Usuário " +cUserName+ " não tem permissão para utilizar TM selecionada",1, 0, , , , , , {"Utilize uma TM permitida para este usuário"})
			_lok := .F.//não permite salvar
		EndIf
	EndIf

	If SF5->F5_XOS == "S" .AND. FunName() <> "MATA185" //valida se TM movimenta estoque e na rotina de baixa, não verifica campo da OS
		If Empty(_Os) //se movimentar, verifica se o campo de OS esta vazio
			Help(, ,"AVISO#0007", ,"TM movimenta estoque",1, 0, , , , , , {"Preencha o campo OS"})
			_lok := .F.//não permite salvar
		EndIf
	ElseIf SF5->F5_XOS == "N" .AND. !Empty(_Os) //se TM não movimentar estoque, não permite preencher o campo se OS
		Help(, ,"AVISO#0008", ,"TM não movimenta estoque",1, 0, , , , , , {"Campo OS não pode ser preenchido"})
		_lok := .F.//não permite salvar
	EndIf





	/* Valida se produto possui rastreabilidade por lote, caso tenha, não permite campo de lote
	ficar vazio - Maria Luiza - 08/08/2024
	*/
	cLoteCtl  := Posicione('SB1', 1, FWxFilial('SB1') + _cod, 'B1_RASTRO')

	If SF5->F5_QTDZERO == "2" .AND. cLoteCtl ==  "L"//Valida se produto possiu rastro
		If Empty(_lote) //valida se campo de lote esta vazio
			Help(, ,"AVISO#0006", ,"Produto possui rastreabilidade",1, 0, , , , , , {"Preencha o campo de LOTE"})
			_lok := .F.//não permite salvar
		EndIf
	EndIf




	/* Validação para usuários do almoxarifado conseguirem utilizar a movimentação múltipla para transferência dos itens
	do armazém atual para o armazém 99, uilizando apenas a TM permitida no parâmetro MV_TMALM - Maria Luiza - 05/11/2024
	*/

	If !(_Tm  $ cTMAlm) .AND. FunName() <> "MATA185"//valida se usuário está usando TM que não está contida no parâmetro, só entra na validação na rotina MATA241
		If cUserid $ cUserAlm //verifica se é usuário do almoxarifado
			Help(, ,"AVISO#0003", ,"Usuário " +cUserName+ " não tem permissão para utilizar TM selecionada",1, 0, , , , , , {"Utilize a(s) TM(s) : " +cTMAlm})
			_lok := .F.//não permite salvar
		Endif
	EndIf




	/* Validação para usuários contidos no parâmetro MV_USRBAIX conseguirem realizar baixa 
	utilizando as TM's contidas no parâmetro MV_BAIXALM na empresa GRID - Maria Luiza - 19/12/2024
	*/

	If cFilAnt == "0501"
		If cUserid $ cUsrAlm
			If !(_Tm  $ cTMBaixa) .AND. FunName() <> "MATA241"//valida se usuário está usando TM que não está contida no parâmetro, só entra na validação na rotina de baixa
				Help(, ,"AVISO#0011", ,"Usuário " +cUserName+ " não tem permissão para utilizar TM selecionada",1, 0, , , , , , {"Utilize uma TM permitida para este usuário"})
				_lok := .F.//não permite salvar
			EndIf
		EndIf
	EndIF


	If _local == "99"
		If _Tm  $ cTMAlm .AND. Empty(_op) //Verifica se campo da OP esta vazio
			Help(, ,"AVISO#0009", ,"Campo da OP vazio.",1, 0, , , , , , {"Preencha o campo da OP."})
			_lok := .F.//não permite salvar
		EndIf
	EndIf



	/*Validações para que o usuário Levy consiga realizar baixa de OS somente no armazém 01 na GRID
	  Solicitado pela Giu - Maria Luiza - 18/12/2024*/


	If cFilAnt == "0501"
		If cUserid $ cBlq01 .AND. FunName() <> "MATA241"//valida se usuário está usando TM que não está contida no parâmetro, só entra na validação na rotina MATA185
			If SCP->CP_LOCAL <> "01"
				Help(, ,"AVISO#0012", ,"Usuário " +cUserName+ " não autorizado a baixar Pre Requisição nesse Almoxarifado",1, 0, , , , , , {"Realize baixa no almoxarifado 01"})
				_lok:=.F.
			Else
				If Empty(_Os)
					Help(, ,"AVISO#0013", ,"Campo de OS vazio",1, 0, , , , , , {"Preencha o campo da OS"})
					_lok:=.F.
				EndIf
			EndIf
		EndIf
	EndIf




	/*Validações para que o usuário Levy consiga realizar baixa somente no armazém 13 na BRG
	  Solicitado pela Giu - Maria Luiza - 16/01/2025*/
	
	
	If cFilAnt == "0101"
		If cUserid $ cBlq13 .and. _local <> "13"
			Help(, ,"AVISO#0016", ,"Usuário não pode movimentar neste armazém",1, 0, , , , , , {"Utilize o armazém 13"})
			_lok:=.F.
		EndIf
	EndIf






	/*Validações para que os usuários só utilizem a TM 009 para o armazém 21 e para itens de refugo
		Maria Luiza - 09/01/2024*/

	If _Tm = "009"
		If _local <> "21"
			Help(, ,"AVISO#0014", ,"TM não pode ser utilizada neste armazém",1, 0, , , , , , {"Utilize o armazém 21"})
			_lok:=.F.
		EndIf
		If !(Alltrim(_cod) $ cRefugo)
			Help(, ,"AVISO#0015", ,"TM não pode ser utilizada para este produto",1, 0, , , , , , {"Utilize um item de REFUGO"})
			_lok:=.F.
		EndIf
	EndIf




		/*Validação para que usuário do José Carlos só consiga movimentar no armazém 05
	Solicitado pela Giu - Maria Luiza - 16/01/2024*/

	If cUserid $ cBlq05 .and. _local <> "05"
		Help(, ,"AVISO#0017", ,"Usuário não pode movimentar neste armazém",1, 0, , , , , , {"Utilize o armazém 05"})
		_lok:=.F.
	EndIf

		return(_lok)
