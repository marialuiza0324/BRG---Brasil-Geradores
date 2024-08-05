//Valida a Digitaçaõ do Centro de Custo na solicitação de compra
//3RL Soluções
//18/01/2023
//BRG 

User Function  MT110LOK()
Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
Local nPosItem   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_ITEM'}) 
Local nPosCC     := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_CC'})
Local nPosObs    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_OBS'})
Local nPosGrp    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_GRPRD'})
Local n
Local lValido := .T.

//cAux := aCols[n][nPosGrp]

//For n:=1 to len(Acols)

//If
   



//Next  

//If cFilAnt = "0201" // Pelo grupo Nagela pediu para colocar obrigatorio incluir centro de custo para todas as empresas 16/07/2020
   IF empty(aCols[n][nPosCC])
      lValido := .F.
      MSGINFO("Informe Centro de Custo !!!"," Atenção ")
   ElseIf !empty(aCols[n][nPosCC]) .and. len(alltrim(aCols[n][nPosCC])) < 8
      lValido := .F.
      MSGINFO("Centro de Custo Inválido !!!"," Atenção ")  
   EndIf

IF empty(aCols[n][nPosObs])
   lValido := .F.
   MSGINFO("Por Favor preencher o campo Observação !!!"," Atenção ") 
 EndIf

//EndIf
    
Return(lValido) 
