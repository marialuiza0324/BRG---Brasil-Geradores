#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT241LOK()

Local n := ParamIxb[1]
Local nCusto    := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_CUSTO1"})
Local nVlCust   := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_CUSTMOV"})
Local cLote     := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_LOTECTL"})
Local cCod      := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_COD"})
Local nOstec    := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_OSTEC"})
Local cOp       := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_OP"})
Local _cod      := ""
Local _lote     := ""
Local _op       := ""
Local lRet := .T.

_cod  := Acols[n,cCod]
_lote := Acols[n,cLote]
_op   := Acols[n,cOp]
_Os   := Acols[n,nOstec]

DbSelectArea("SB1")
DbSetOrder(1)  
dbSeek(xFilial("SB1")+_cod)

If SB1->B1_RASTRO = "L" .AND. EMPTY(_lote) .AND. !(CTM $ ('002','502'))
   lRet := .F.
   MSGINFO("Produto Rastreado, Digite o Lote !!!!!"," Atenção ")
EndIf    

//Tratamento para não fazer devolução 24/02/2021
If cFilAnt == "0101"
   If CTM == '001' .AND. !EMPTY(_op)
      DbSelectArea("SD3")
      DbSetOrder(18)  
      If !dbSeek(xFilial("SD3")+_op+_cod+_lote)  //Criar o Indice 18
         lRet := .F.
         MSGINFO("Produto e/ou Lote não encontrado na Ordem De Produção:" + cvaltochar(_op)+"!!!!"," Atenção ")
      EndIf 
   EndiF
EndiF

Return lRet
