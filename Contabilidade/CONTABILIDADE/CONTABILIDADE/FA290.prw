/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA290     บAutor  ณ Claudio Ferreira   บ Data ณ 15/05/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada na montagem da fatura                     บฑฑ
ฑฑบ          ณ Utilizado para complementar o titulo                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TBC-GO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
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
