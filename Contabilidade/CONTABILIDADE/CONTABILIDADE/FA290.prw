/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘�
臼�Programa  �FA290     �Autor  � Claudio Ferreira   � Data � 15/05/15    艮�
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒�
臼�Desc.     � Ponto de entrada na montagem da fatura                     艮�
臼�          � Utilizado para complementar o titulo                       艮�
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒�
臼�Uso       � TBC-GO                                                     艮�
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識�
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
