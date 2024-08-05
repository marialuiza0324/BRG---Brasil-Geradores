//14/10/2022
//Function A110GRAVA - Fun��o da Solicita��o de Compras responsavel pela grava��o das SCs.
//EM QUE PONTO : No laco de grava��o dos itens da SC na fun��o A110GRAVA, executado ap�s gravar o item da SC, a cada item gravado da SC o ponto � executado.
//3rl solucoes

User Function MT110GRV()

Local lExp1 :=  PARAMIXB[1]//Rotina do Usuario para poder gravar campos especificos ou alterar campos gravados do item da SC.
Local cObs := cusername+"-"+cvaltochar(time())+" / "+cvaltochar(ddatabase)+SC1->C1_OBS
Local cObsMem := SC1->C1_XOBMEMO
Local _CRLF     := Chr(13) + Chr(10)
Local cMensagem := ""
Local nXi
Local nLinhas

nLinhas := MLCount(SC1->C1_XOBMEMO+cusername+" / "+cvaltochar(time())+"-"+cvaltochar(ddatabase)+" "+SC1->C1_OBS,70)
   For nXi:= 1 To nLinhas
       cTxtLinha := MemoLine(SC1->C1_XOBMEMO+cusername+" / "+cvaltochar(time())+"-"+cvaltochar(ddatabase)+" "+SC1->C1_OBS,70,nXi)
       If !Empty(cTxtLinha) 
               cMensagem +=cTxtLinha  + _CRLF
       EndIf
   Next nXi

   SC1->(RECLOCK("SC1",.F.)) 
   SC1->C1_OBS     := "" 
   SC1->C1_XOBMEMO := cMensagem + _CRLF   
   SC1->(MSUNLOCK()) 

Return
