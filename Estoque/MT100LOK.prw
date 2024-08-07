#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH' 

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MT100LOK  � Autor � RICARDO MOREIRA       � Data � 04/10/18潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada para validar a n鉶 digita玢o do lote      潮�
北�          � na entrada da nota					                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para PHARMA                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function MT100LOK()

//Local lRet     := .T.
 
Local lRet     := ParamIxb[1]
local nPosLoteCtl := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_LOTECTL"})
local nPosCod     := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"})
local nPosTes     := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_TES"})
local nPosQtd     := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_QUANT"})
LOCAL nPosItem       := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_ITEM"})
Local _lote       := " "
Local _cod        := " "
Local _Loc        := " "
Local RetSal   := 0
LOCAL nLinhaAtual := n
LOCAL nLoop := 0

//Validar se tem dois lote iguais na digita玢o da nota - 12/08/2022 - Inicio

 DbSelectArea("SF4")
 DbSetOrder(1)   
 IF dbSeek(xFilial("SF4")+Acols[n,nPosTes]) //3
    If SF4->F4_ESTOQUE = 'N'
      // Adicionado a condi玢o 06/01/2023 - Solicita玢o KArita
       MSGINFO("Tes n鉶 movimenta Estoque !!!"," Aten玢o ") 
    EndIf   
 EndIf     

For nLoop := 1 to Len( aCols )

   If !Empty(Acols[n,nPosLoteCtl])     
   // N鉶 deve validar a linha atual.
      If nLoop == nLinhaAtual
         Loop
      EndIf
      If (aCols[n,nPosLoteCtl] == aCols[nLoop,nPosLoteCtl]) .and. (aCols[n,nPosCod] == aCols[nLoop,nPosCod])
         MsgInfo("Este produto e opera玢o j� foram digitados no item " + aCols[nLoop,nPosItem] )
         lRet  := .F.
	     Return lRet 
      EndIf
   EndIF
Next nLoop

//Validar se tem dois lote iguais da digita玢o da nota - 12/08/2022 - Fim


//For n:= 1 to len(Acols)
   DbSelectArea("SB1")
   DbSetOrder(1)   
   IF dbSeek(xFilial("SB1")+Acols[n,nPosCod]) //1
      If SB1->B1_RASTRO == "L" //2
         If Empty(Acols[n,nPosLoteCtl])  .AND. (Acols[n,nPosTes]) <> "392"
            lRet  := .F. //.F. 
            MSGINFO("Item com Rastreabilidade. Informe o Lote"," Aten玢o ")
         EndIf

         DbSelectArea("SF4")
         DbSetOrder(1)   
         IF dbSeek(xFilial("SF4")+Acols[n,nPosTes]) //3
            If SF4->F4_ESTOQUE = 'S'
               
               _lote := Acols[n,nPosLoteCtl]		
		         //_Loc  := Acols[n,nPosLocal]
		         _cod  := Acols[n,nPosCod]
		
		         If Select("TMP8") > 0
			         TMP8->(DbCloseArea())
		         EndIf
		
		         cQry := " "
		         cQry += "SELECT B8_FILIAL, B8_PRODUTO, B8_LOTECTL, SUM(B8_SALDO) SALDO "
		         cQry += "FROM " + retsqlname("SB8")+" SB8 "
		         cQry += "WHERE SB8.D_E_L_E_T_ <> '*' "
		         cQry += "AND B8_FILIAL = '" + cFilAnt + "' "
		         cQry += "AND B8_PRODUTO = '" + _cod + "' "
		         //cQry += "AND B8_LOCAL = '" + _Loc + "' "
		         cQry += "AND B8_LOTECTL = '" + _lote + "' "
		         cQry += "GROUP BY B8_FILIAL, B8_PRODUTO, B8_LOTECTL "
		
		         DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP8",.T.,.T.)
		
		         RetSal := TMP8->SALDO
		
		         If  RetSal > 0 .or. Acols[n,nPosQtd] > 1 
			          lRet  := .F.
			        MSGINFO("Lote com Saldo ou Quantidade maior que Um"," Aten玢o ")
		         EndIf             
            EndIf
         EndIf //3   
      EndIf //2
   EndIf //1
//NEXT n

Return(lRet)
