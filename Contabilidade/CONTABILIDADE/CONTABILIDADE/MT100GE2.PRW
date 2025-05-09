#INCLUDE "PROTHEUS.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100GE2  �Autor  �Claudio Ferreira    � Data �  26/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE chamado durante a gera��o da SE2.                       ���
���          � Utilizado para complementar o titulo a pagar              .���
�������������������������������������������������������������������������͹��
���Uso       � TBC-GO                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MT100GE2
Local   nPosCC := aScan(aHEADER,{|x| Trim(x[2])=="D1_CC"})
Local   nPosItem := aScan(aHEADER,{|x| Trim(x[2])=="D1_ITEMCTA"})
if !empty(acols[1,nPosCC])
  RecLock("SE2", .F. )
  SE2->E2_CCD   := acols[1,nPosCC] //Grava o item informado na 1 linha  
  MsUnLock()
endif

if !empty(acols[1,nPosItem])
  RecLock("SE2", .F. )
  SE2->E2_ITEMD   := acols[1,nPosItem] //Grava o item informado na 1 linha  
  MsUnLock()
endif
if SF1->(FieldPos("F1_MENNOTA"))> 0
  if !empty(SF1->F1_MENNOTA)
    RecLock("SE2", .F. )
    SE2->E2_HIST    := SF1->F1_MENNOTA //Grava o historico 
    MsUnLock()
  endif
endif  
Return  
