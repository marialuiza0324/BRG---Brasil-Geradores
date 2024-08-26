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
	Local nPosOP := aScan(aHeader,{|x| AllTrim(x[2])=="D3_OP"})
	Local nOstec    := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_OSTEC"})
	Local cLote     := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_LOTECTL"})
	Local cCod      := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_COD"})
	Local cLoteCtl  := ""

	_Os   := Acols[n,nOstec]
	_lote := Acols[n,cLote]
	_cod  := Acols[n,cCod]

	if empty(aCols[n,nPosOP]) .or. 'OS'$aCols[n,nPosOP]
		if empty(cCc)    
			_lok:=.f.
			FWAlertInfo("MT241LOK: Para este tipo de movimento o centro de custo deve ser informado!")
		endif
	endif

	If SF5->F5_XOS == "S" .AND. FunName() <> "MATA185" //valida se TM movimenta estoque e na rotina de baixa, n�o verifica campo da OS
		If Empty(_Os) //se movimentar, verifica se o campo de OS esta vazio
			FWAlertInfo("Preencher campo da OS","Aten��o!!!")
			_lok := .F.//n�o permite salvar
		EndIf
	ElseIf SF5->F5_XOS == "N" .AND. !Empty(_Os) //se TM n�o movimentar estoque, n�o permite preencher o campo se OS
		FWAlertInfo("Campo da OS n�o pode ser preenchido pois TM n�o movimenta estoque para opera��o selecionada","Aten��o!!!")
		_lok := .F.//n�o permite salvar
	EndIf

	cLoteCtl  := Posicione('SB1', 1, FWxFilial('SB1') + _cod, 'B1_RASTRO')

	If SF5->F5_QTDZERO == "2" .AND. cLoteCtl ==  "L"//Valida se produto possiu rastro
		If Empty(_lote) //valida se campo de lote esta vazio
			FWAlertInfo("Preencher o campo LOTE, pois produto possui restreabilidade","Aten��o!!")
			_lok := .F.//n�o permite salvar
		EndIf
	EndIf

return(_lok)
