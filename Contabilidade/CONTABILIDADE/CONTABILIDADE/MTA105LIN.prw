#include "rwmake.ch"
#Include "SigaWin.ch"

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MTA105LIN ¦ Utilizador ¦ Claudio Ferreira ¦ Data ¦ 04/05/16¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na confirmação da SA                      ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦    
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

#include "rwmake.ch"


user function MTA105LIN()
	local _lok:=.t.
	Local nPop      := aScan(aHeader,{|x| Trim(x[2])=="CP_OP"})
	Local nCC      := aScan(aHeader,{|x| Trim(x[2])=="CP_CC"})
	Local cCod      := AScan(aHeader, {|x| Alltrim(x[2]) == "CP_PRODUTO"})
	Local nOp       := AScan(aHeader, {|x| Alltrim(x[2]) == "CP_OP"})
	Local cObs      := AScan(aHeader, {|x| Alltrim(x[2]) == "CP_OBS"})
	Local cTipo     := ""

	if empty(aCols[n,nPop]) .or. 'OS'$aCols[n,nPop]
		if empty(aCols[n,nCC])
			_lok:=.f.
			FwAlertInfo("Para este tipo de movimento o centro de custo deve ser informado!","Atenção!!!")
		endif
	endif

	cTipo := Posicione("SB1",1,xFilial("SB1")+Acols[n,cCod],'B1_TIPO')

	If !Empty(Acols[n,nCC]) .And. Empty(Acols[n,nOp]) .AND. cTipo == "MP" .AND. Empty(Acols[n,cObs])
		_lok := .F.
		Help(, ,"AVISO#0033", ,"Campo Observação vazio.",1, 0, , , , , , {"Requisição de Matéria-Prima para centro de custo requer justificativa no campo Observação."})
	ElseIf !Empty(Acols[n,nCC]) .And. Empty(Acols[n,nOp]) .AND. cTipo == "MP" .AND. Len(Trim(Acols[n,cObs])) < 15
		_lok := .F.
		Help(, ,"AVISO#0034", ,"Campo Observação não tem informação suficiente.",1, 0, , , , , , {"O campo Observação deve conter no mínimo 15 caracteres."})
	EndIf

return(_lok)
