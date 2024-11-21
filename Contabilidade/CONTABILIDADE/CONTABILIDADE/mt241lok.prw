#include "rwmake.ch"
#Include "SigaWin.ch"

/*
__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � MT241LOK  � Utilizador � Claudio Ferreira � Data � 12/11/15���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de Entrada na confirma��o do mov interno             ���
���          �                                                            ���
���          � 															  ���
��+----------+------------------------------------------------------------���
��� Uso      � TOTVS-GO                                                   ���    
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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




	/*Valida a movimenta��o de determinadas TMs para usu�rios autorizados, 
	  validar a movimenta��o de OS - Maria Luiza - 07/08/2024
	*/
	If _Tm $ _MovTm //verifica se TM est� contida no par�metro
		If !(cUserid $ cUser) //verifica se usu�rio est� contido no par�metro
			Help(, ,"AVISO#0005", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para utilizar TM selecionada",1, 0, , , , , , {"Utilize uma TM permitida para este usu�rio, exceto : " +_MovTm})
			_lok := .F.//n�o permite salvar
		EndIf
	EndIf

	If SF5->F5_XOS == "S" .AND. FunName() <> "MATA185" //valida se TM movimenta estoque e na rotina de baixa, n�o verifica campo da OS
		If Empty(_Os) //se movimentar, verifica se o campo de OS esta vazio
			Help(, ,"AVISO#0007", ,"TM movimenta estoque",1, 0, , , , , , {"Preencha o campo OS"})
			_lok := .F.//n�o permite salvar
		EndIf
	ElseIf SF5->F5_XOS == "N" .AND. !Empty(_Os) //se TM n�o movimentar estoque, n�o permite preencher o campo se OS
		Help(, ,"AVISO#0008", ,"TM n�o movimenta estoque",1, 0, , , , , , {"Campo OS n�o pode ser preenchido"})
		_lok := .F.//n�o permite salvar
	EndIf





	/* Valida se produto possui rastreabilidade por lote, caso tenha, n�o permite campo de lote
	ficar vazio - Maria Luiza - 08/08/2024
	*/
	cLoteCtl  := Posicione('SB1', 1, FWxFilial('SB1') + _cod, 'B1_RASTRO')

	If SF5->F5_QTDZERO == "2" .AND. cLoteCtl ==  "L"//Valida se produto possiu rastro
		If Empty(_lote) //valida se campo de lote esta vazio
			Help(, ,"AVISO#0006", ,"Produto possui rastreabilidade",1, 0, , , , , , {"Preencha o campo de LOTE"})
			_lok := .F.//n�o permite salvar
		EndIf
	EndIf




	/* Valida��o para usu�rios do almoxarifado conseguirem utilizar a movimenta��o m�ltipla para transfer�ncia dos itens
	do armaz�m atual para o armaz�m 99, uilizando apenas a TM permitida no par�metro MV_TMALM - Maria Luiza - 05/11/2024
	*/

	If !(_Tm  $ cTMAlm) .AND. FunName() <> "MATA185"//valida se usu�rio est� usando TM que n�o est� contida no par�metro, s� entra na valida��o na rotina MATA241
		If cUserid $ cUserAlm //verifica se � usu�rio do almoxarifado
			Help(, ,"AVISO#0003", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para utilizar TM selecionada",1, 0, , , , , , {"Utilize a(s) TM(s) : " +cTMAlm})
			_lok := .F.//n�o permite salvar
		Endif
	EndIf

	If _Tm  $ cTMAlm .AND. Empty(_op) //Verifica se campo da OP esta vazio
		Help(, ,"AVISO#0009", ,"Campo da OP vazio.",1, 0, , , , , , {"Preencha o campo da OP."})
		_lok := .F.//n�o permite salvar
	EndIf


return(_lok)
