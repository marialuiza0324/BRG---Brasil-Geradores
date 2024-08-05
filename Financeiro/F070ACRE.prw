#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
//Ponto de Entrada antes da Abertura da Tela da Baixa a Receber.
User Function F070ACRE
Local URET  := .T.
local _Aux  := 0
Local _PcMul := SuperGetMv("MV_MULTA")
Local _PcTax := SuperGetMv("MV_TXPER")
Local _Client := SE1->E1_CLIENTE
Local _Lj    := SE1->E1_LOJA 
  //Private nMulta := 0
 //Private nJuros := 0


 IF ddatabase > SE1->E1_VENCREA .and. SE1->E1_SALDO > 0
   If SE1->E1_SALDO = SE1->E1_VALOR
      nMulta := Round(((SE1->E1_SALDO-SE1->E1_INSS) * _PcMul),2)
   EndIf
 EndIf
 _Aux := (SE1->E1_SALDO - SE1->E1_INSS) * ((1+(_PcTax/100))**DateDiffDay(DBAIXA,SE1->E1_VENCREA))

  RECLOCK("SE1",.F.)
   SE1->E1_VALJUR := ROUND((_Aux-(SE1->E1_SALDO - SE1->E1_INSS))/DateDiffDay(DBAIXA,SE1->E1_VENCREA),2) 
  MSUNLOCK()
 //nJuros :=  ROUND((SE1->E1_SALDO - SE1->E1_INSS)*((1+(_PcTax/100))**DateDiffDay(DBAIXA,SE1->E1_VENCREA)),2) 
 //nJuros := Round(((SE1->E1_SALDO - SE1->E1_INSS) * (_PcTax/100))* DateDiffDay(DBAIXA,SE1->E1_VENCREA),2)

Return URET
