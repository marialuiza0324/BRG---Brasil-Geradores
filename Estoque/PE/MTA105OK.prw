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
             If !(__CUSERID $ "000000/000031/000049") 
		        lRet  := .F.
		        MSGINFO("Usuário não Autorizado a inserir itens com lote na OS !!!"," Atenção ")
	         EndIF
          EndIF
       EndIF
    EndIF
NEXT n

Return lRet
