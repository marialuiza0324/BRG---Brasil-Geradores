//11/10/2022
//Ricardo Moreira BRG
// Valida a inclus�o da Solicita��o de compra

User Function MT110VLD()

Local ExpN1    := Paramixb[1]  //3- Inclus�o, 4- Altera��o, 8- Copia, 6- Exclus�o.
Local ExpL1    := .T.   
Local cUserId   := RetCodUsr() //Retorna o Usu�rio Logado

DbSelectArea("SAI")
DbSetOrder(2)
If !DbSeek(xFilial("SAI")+cUserId)
   ExpL1    := .F.
   FWAlertError("Usu�rio n�o � um Solicitante !!! ", "Alerta - Erro")
EndIf

Return ExpL1
