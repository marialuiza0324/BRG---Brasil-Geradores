/*
�������������������������������������������������������������������������ͻ��
���Programa  �FA290     �Autor  � Claudio Ferreira   � Data � 15/05/15    ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada na montagem da fatura                     ���
���          � Utilizado para complementar o titulo                       ���
�������������������������������������������������������������������������͹��
���Uso       � TBC-GO                                                     ���
�������������������������������������������������������������������������ͼ��
*/

#INCLUDE "rwmake.ch"

User Function _FA290()
Local aArea := getArea()  
Local cFiltroAtu := SE2->(DbFIlter())
dbClearFilter()
cItem:=Posicione("SE2",9,xFilial("SE2")+SE5->(E5_CLIFOR+E5_LOJA+SE2->(E2_PREFIXO+E2_NUM)),"E2_ITEMD")
Set Filter to &(cFiltroAtu)
restArea(aArea)
RecLock("SE2",.F.)
Replace E2_ITEMD with cItem
MsUnlock()

Return()
