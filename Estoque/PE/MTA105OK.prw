#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

//BRG GERADORES
//DATA 07/02/2018
//3RL Soluções - Ricardo Moreira
//Valida a o centro de custo conforme o parametro SF5 do centro de custo.

User Function MTA105OK()
Local lRet := .T.//-- Validações do usuário para inclusão do movimento 
Local cLote     := AScan(aHeader, {|x| Alltrim(x[2]) == "CP_LOTE"})
Local cCod      := AScan(aHeader, {|x| Alltrim(x[2]) == "CP_PRODUTO"})
Local cNos      := AScan(aHeader, {|x| Alltrim(x[2]) == "CP_NUMOS"})
Local nCcusto   := AScan(aHeader, {|x| Alltrim(x[2]) == "CP_CC"})
Local nOp       := AScan(aHeader, {|x| Alltrim(x[2]) == "CP_OP"})
Local cObs      := AScan(aHeader, {|x| Alltrim(x[2]) == "CP_OBS"})
Local cTipo     := ""
Local cRastr    := ""
lOCAL n := 1
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario

For n:= 1 to len(Acols)
    DbSelectArea("SB1")
    DbSetOrder(1)   
    IF dbSeek(xFilial("SB1")+Acols[n,cCod])
	   cRastr := SB1->B1_RASTRO
	   If cRastr ="L"
          If !empty(Acols[n,cLote]) .and. !empty(Acols[n,cNos])
             If !(cCodUser $ "000000/000031/000049") 
		        lRet  := .F.
		        FwAlertInfo("Usuário não Autorizado a inserir itens com lote na OS !!!"," Atenção ")
	         EndIF
          EndIF
       EndIF
    EndIF

      cTipo := Posicione("SB1",1,xFilial("SB1")+Acols[n,cCod],'B1_TIPO')

      If !Empty(Acols[n,nCcusto]) .And. Empty(Acols[n,nOp]) .AND. cTipo == "MP" .AND. Empty(Acols[n,cObs])
         lRet := .F.
         Help(, ,"AVISO#0033", ,"Campo Observação vazio.",1, 0, , , , , , {"Requisição de Matéria-Prima para centro de custo requer justificativa no campo Observação."})
      ElseIf !Empty(Acols[n,nCcusto]) .And. Empty(Acols[n,nOp]) .AND. cTipo == "MP" .AND. Len(Trim(Acols[n,cObs])) < 15
         lRet := .F.
         Help(, ,"AVISO#0034", ,"Campo Observação não tem informação suficiente.",1, 0, , , , , , {"O campo Observação deve conter no mínimo 15 caracteres."})
      EndIf
NEXT n

Return lRet
