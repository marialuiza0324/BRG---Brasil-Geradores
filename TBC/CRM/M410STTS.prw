#include "totvs.ch"
#include "protheus.ch"

/*/-------------------------------------------------------------------
- Programa: M410STTS
- Autor:
- Data: 01/11/2021
- Descrição: Alimenta o campo natureza conforme a oportunidade.

PARAMIXB
3 - Inclusão
4 - Alteração
5 - Exclusão
6 - Cópia
7 - Devolução de Compras
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
