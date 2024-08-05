//11/10/2022
//Ricardo Moreira BRG
// Valida a inclusão da Solicitação de compra

User Function MT110VLD()

Local ExpN1    := Paramixb[1]  //3- Inclusão, 4- Alteração, 8- Copia, 6- Exclusão.
Local ExpL1    := .T.   
Local cUserId   := RetCodUsr() //Retorna o Usuário Logado

DbSelectArea("SAI")
DbSetOrder(2)
If !DbSeek(xFilial("SAI")+cUserId)
   ExpL1    := .F.
   FWAlertError("Usuário não é um Solicitante !!! ", "Alerta - Erro")
EndIf

Return ExpL1
