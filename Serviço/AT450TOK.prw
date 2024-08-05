//BRG Geradores
//14/11/2018
//
//3rl Soluções

#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"
#Include "PROTHEUS.CH"

User Function AT450TOK()  //u_ProLot()
Local _Ret := .T.
local _Lote    := AScan(aHeader, {|x| Alltrim(x[2]) == "AB7_NUMSER"})
Local  _IDSer := acols[n,4] //M->AB7_NUMSER  //Acols[n,_Lote]

If !Empty(Acols[n,_Lote])
  _IDSer := Acols[n,_Lote] 
  M->AB6_OBS := _IDSer 
EndIF    
Return _Ret