#Include "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
//--------------------------------------------------------------
/*/{Protheus.doc}
Description

@param xParam Atualizar a SBF
@return xRet BRG
@author  -
@since 25/03/2019
/*/
//--------------------------------------------------------------
User Function M410LIOK()

Local aArea    := GetArea()
Local uRet     := .T.
Local cProd    := AScan(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO"})
Local cLocal   := AScan(aHeader, {|x| Alltrim(x[2]) == "C6_LOCAL"})
Local nQuant   := AScan(aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN"})
Local cTes     := AScan(aHeader, {|x| Alltrim(x[2]) == "C6_TES"})

//If Acols[n,cLocal] <> "13" .and. __cUserID = "000033"
   //MSGINFO("Amoxarifado Inválido"," Atenção ")
  // uRet     := .T.
//EndIf    


//IF M->C5_TIPO == "N" 
	/*
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+Acols[n,cProd])
		If SB1->B1_TIPO $ 'PA/AI'
			RestArea(aArea)
			Return(uRet)
		EndIf
	EndIf	
	

	DbSelectArea("SF4")
	DbSetOrder(1)
	If DbSeek(xFilial("SF4")+Acols[n,cTes])
		If SF4->F4_ESTOQUE = "S"
			DbSelectArea("SB2")
			DbSetOrder(1)
			IF dbSeek(xFilial("SB2")+Acols[n,cProd]+Acols[n,cLocal])
				nSaldo := NOROUND((SaldoSb2())/2,0)
				MSGINFO("Quantidade Disponível: " + cvaltochar(nSaldo)+" !!!!"," Atenção ")
				//IF Acols[n,nQuant] > nSaldo
					uRet     := .T.
					//MSGINFO("Saldo não disponível pra Venda"," Atenção ")
				//EndIf
			EndIF
		EndIf
	EndIf	
EndIf // C5_TIPO
*/
RestArea(aArea)
Return(uRet)
