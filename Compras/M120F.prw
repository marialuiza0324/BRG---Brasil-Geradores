

#include 'protheus.ch'
#include 'parmtype.ch'

//BRG GERADORES
//DATA 01/02/2023
//3RL Soluções - Ricardo Moreira
//Bloqueio na Inclusão

User Function MT120F() // NA iNLCUSÃO MANUAL 
Local cPedido  :=  PARAMIXB

If Inclui .or. Altera
   dBselectArea('SC7')
   dbSetOrder(1)
   dbSeek(cPedido)
   While !SC7->(Eof()) .and. xFilial("SC7")==SC7->C7_FILIAL .and. cPedido == SC7->C7_NUM
         SC7->(RECLOCK("SC7",.F.)) 
         SC7->C7_CONAPRO     := "B"   //  B PARA L   - TIROU PARA QUE NÃO TRAVA AS INCLUSÕES MANUAIS NA BASE DE PRODUÇAÕ 08/02/2023
         SC7->(MSUNLOCK()) 
   ENDDO
ENDIF

Return 
