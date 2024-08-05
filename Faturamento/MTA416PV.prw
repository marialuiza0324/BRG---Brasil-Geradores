/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦    ¦ Autor ¦  Ricardo Moreira - 3rl               ¦ Data ¦ ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Efetivacao Pedido Vendas em Orcamento                      ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

USER FUNCTION MTA416PV()
//LOCAL NX :=0                                                         
Local aAreaSCK := GetArea("SCK")

M->C5_TPFRETE := SCJ->CJ_TIPOFRT
M->C5_VEND   := SCJ->CJ_VEND

/*
M->C5_REPRESE:= SCJ->CJ_REPRESE
M->C5_M2CIFRA:= SCJ->CJ_M2CIFRA
M->C5_COMREPR:= SCJ->CJ_COMREPR
M->C5_TPFRETE:= SCJ->CJ_INCOTER
M->C5_TIPOENT:= SCJ->CJ_TIPOENT
M->C5_ATEND  := SCJ->CJ_ATEND
M->C5_OBSENTR:= SCJ->CJ_OBSENTR
M->C5_INCOMP := SCJ->CJ_INCOMP
If SC5->(FieldPos("C5_ENDETIQ")) > 0
	M->C5_ENDETIQ := SCJ->CJ_ENDETIQ
Endif
If SC5->(FieldPos("C5_TPPAGTO")) > 0
	M->C5_TPPAGTO := SCJ->CJ_TPPAGTO
Endif                          
If SC5->(FieldPos("C5_M2VELIQ")) > 0
	M->C5_M2VELIQ:= SCJ->CJ_M2VELIQ
Endif

FOR nX :=1 TO len(_aCols)                                            
	nPosqdlib := aScan( aHeadC6, { |x| Alltrim(x[2])=="C6_QTDLIB" } )
	nPosOrc   := aScan( aHeadC6, { |x| Alltrim(x[2])=="C6_NUMORC" } )
	nPosDtProg:= aScan( aHeadC6, { |x| Alltrim(x[2])=="C6_DTPROG" } ) 
	nPosNCM   := aScan( aHeadC6, { |x| Alltrim(x[2])=="C6_POSIPI" } )
	SCK->(DbSelectArea("SCK"))
	SCK->(DbSetOrder(1))
	If SCK->(DbSeek(xfilial("SCK") + _aCols[NX][nPosOrc] )) .And. nPosDtProg > 0 .And. nPosNCM > 0
		_aCols[NX][nPosDtProg] := SCK->CK_DTPROG	
		_aCols[NX][nPosNCM]    := SCK->CK_POSIPI			
	EndIF
	_aCols[NX][nPosqdlib] :=0
NEXT 
*/                         
RestArea(aAreaSCK)
//aColsC6:=_aCols
RETURN
