//BRG GERADORES
//DATA 06/02/2018
// 3RL Soluções - Ricardo Moreira
//Na baixa da Pre-Requisição é gravado o lote na tabela SCP (CP_LOTE) escolhido na SD3 (D3_LOTECTL)

User Function M185GRV() 

Local _Lote := SD3->D3_LOTECTL           //-- Rotina de customização do usuário
 
 SCP->(RECLOCK("SCP",.F.))
 SCP->CP_LOTE := _Lote
 SCP->(MSUNLOCK())

Return 