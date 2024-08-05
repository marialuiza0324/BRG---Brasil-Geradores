#include "Protheus.ch"

/*
Funcao      : BRG028
Objetivos   : Excluir acerto Selecionado (Botao Excluir)
*/
*---------------------*
User Function BRG028()

Local _Acert := ZPX->ZPX_ACERTO   
Local _Cart  := ZPX->ZPX_CARTAO 

//MSGINFO("Último preço do Item R$:" + cvaltochar(_Valor)+" ","Atenção")
If MsgYesNo( "Deseja Deletar o Acerto: " + ZPX->ZPX_ACERTO + "!!!!" , "Deletar Acerto" )
   DbSelectArea("ZPX")
	  DbSetOrder(1)
	  If DbSeek(xFilial("ZPX")+_Acert+_Cart)
		 DO WHILE ZPX->(!EOF()) .AND. xFilial("ZPX") == ZPX->ZPX_FILIAL .AND. _Acert == ZPX->ZPX_ACERTO .AND. _Cart == ZPX->ZPX_CARTAO 
			ZPX->(RECLOCK("ZPX",.F.))
			ZPX->( dbDelete() )
			ZPX->(MSUNLOCK())
			ZPX->(dbSkip())
		 EndDo
	  EndIf
    MSGINFO("Acerto :" + cvaltochar(_Acert)+" Deletado. !!!!! ","Atenção")
EndIf

Return
