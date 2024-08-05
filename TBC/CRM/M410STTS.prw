#include "totvs.ch"
#include "protheus.ch"

/*/-------------------------------------------------------------------
-�Programa: M410STTS
-�Autor:
-�Data:�01/11/2021
-�Descri��o:�Alimenta o campo natureza conforme a oportunidade.

PARAMIXB
3 - Inclus�o
4 - Altera��o
5 - Exclus�o
6 - C�pia
7 - Devolu��o de Compras
-------------------------------------------------------------------/*/
User Function M410STTS()
	Local nOper 	:= PARAMIXB[1]

	If nOper == 3  
		if FWIsInCallStack("FATA300")
			RecLock("SC5", .F.)
			SC5->C5_NATUREZ := AD1->AD1_XNATUR
			SC5->(MsUnlock())
		Endif
	EndIf

Return
