//BRG GERADORES
//DATA 18/10/2018
//3RL Solu��es - Ricardo Moreira
//Grava a Descri��o do Produto na Inclusao da Pre-Nota

User Function SD1140I
Local _Desc := SB1->B1_DESC

 SD1->(RECLOCK("SD1",.F.))
 SD1->D1_XDESCPR := _Desc
 SD1->(MSUNLOCK())

Return Nil