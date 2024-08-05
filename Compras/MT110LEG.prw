//Alteração da Tela de Legenda e Cor na Grid do Browse
//Ricardo Moreira 15/02/2023
//BRG

User Function MT110LEG()//  

Local aNewLegenda  := aClone(PARAMIXB[1])
aAdd(aNewLegenda,{'BR_VERDE_ESCURO' , 'Bloqueada/Já foi Rejeitada'})

Return (aNewLegenda) 


User Function MT110COR()


Local aNewCores    := PARAMIXB[1]
Local cCondic   := 'AllTrim(C1_FOIBLQ) == "S"'
Local cNomeCor := 'BR_VERDE_ESCURO'

//Adiciona uma nova linha no array
ASIZE(aNewCores,Len(aNewCores)+1)

//Posiciona a linha vazia criada no topo do array
AINS(aNewCores,1)    

aNewCores[1]:={cCondic,cNomeCor}

Return (aNewCores)

 