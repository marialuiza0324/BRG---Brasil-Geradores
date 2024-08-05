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

	_Os   := Acols[n,nOstec]

	if empty(aCols[n,nPosOP]) .or. 'OS'$aCols[n,nPosOP]
		if empty(cCc)
			_lok:=.f.
			FWAlertInfo("MT241LOK: Para este tipo de movimento o centro de custo deve ser informado!")
		endif
	endif

	If SF5->F5_XOS == "S" //valida se TM movimenta estoque
		If Empty(_Os) //se movimentar, verifica se o campo de OS esta vazio
			FWAlertInfo("Preencher campo da OS","Aten��o!!!")
			_lok := .F.//n�o permite salvar
		EndIf
	ElseIf SF5->F5_XOS == "N" .AND. !Empty(_Os) //se TM n�o movimentar estoque, n�o permite preencher o campo se OS
		FWAlertInfo("Campo da OS n�o pode ser preenchido pois TM n�o movimenta estoque","Aten��o!!!")
		_lok := .F.//n�o permite salvar
	EndIf


return(_lok)
