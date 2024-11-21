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
	Local _op       := ""
	Local cLoteCtl  := ""
	Local cTMAlm   := SupergetMv("MV_TMALM" , ,)//560
	Local cUserAlm  := SupergetMv("MV_USTMALM", ,)//000121
	Local _Tm  := CTM
	Local cUserid := RetCodUsr()
	Local _MovTm := GetMv("MV_MOVTM") //002,502,560
	Local cUser  := GetMv("MV_BLOQUSE")//000120,000150,000004,000000



	_Os   := Acols[n,nOstec]
	_lote := Acols[n,cLote]
	_cod  := Acols[n,cCod]
	_op   := Acols[n,cOp]

	if empty(aCols[n,nPosOP]) .or. 'OS'$aCols[n,nPosOP]
		if empty(cCc)
			_lok:=.f.
			FWAlertInfo("MT241LOK: Para este tipo de movimento o centro de custo deve ser informado!")
		endif
	endif




	/*Valida a movimentação de determinadas TMs para usuários autorizados, 
	  validar a movimentação de OS - Maria Luiza - 07/08/2024
	*/
	If _Tm $ _MovTm //verifica se TM está contida no parâmetro
		If !(cUserid $ cUser) //verifica se usuário está contido no parâmetro
			Help(, ,"AVISO#0005", ,"Usuário " +cUserName+ " não tem permissão para utilizar TM selecionada",1, 0, , , , , , {"Utilize uma TM permitida para este usuário, exceto : " +_MovTm})
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

	If _Tm  $ cTMAlm .AND. Empty(_op) //Verifica se campo da OP esta vazio
		Help(, ,"AVISO#0009", ,"Campo da OP vazio.",1, 0, , , , , , {"Preencha o campo da OP."})
		_lok := .F.//não permite salvar
	EndIf


return(_lok)
