#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH' 

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT100LOK  ³ Autor ³ RICARDO MOREIRA       ³ Data ³ 04/10/18³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada para validar a não digitação do lote      ³±±
±±³          ³ na entrada da nota					                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para PHARMA                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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

//Validar se tem dois lote iguais na digitação da nota - 12/08/2022 - Inicio

 DbSelectArea("SF4")
 DbSetOrder(1)   
 IF dbSeek(xFilial("SF4")+Acols[n,nPosTes]) //3
    If SF4->F4_ESTOQUE = 'N'
      // Adicionado a condição 06/01/2023 - Solicitação KArita
       MSGINFO("Tes não movimenta Estoque !!!"," Atenção ") 
    EndIf   
 EndIf     

For nLoop := 1 to Len( aCols )

   If !Empty(Acols[n,nPosLoteCtl])     
   // Não deve validar a linha atual.
      If nLoop == nLinhaAtual
         Loop
      EndIf
      If (aCols[n,nPosLoteCtl] == aCols[nLoop,nPosLoteCtl]) .and. (aCols[n,nPosCod] == aCols[nLoop,nPosCod])
         MsgInfo("Este produto e operação já foram digitados no item " + aCols[nLoop,nPosItem] )
         lRet  := .F.
	     Return lRet 
      EndIf
   EndIF
Next nLoop

//Validar se tem dois lote iguais da digitação da nota - 12/08/2022 - Fim


//For n:= 1 to len(Acols)
   DbSelectArea("SB1")
   DbSetOrder(1)   
   IF dbSeek(xFilial("SB1")+Acols[n,nPosCod]) //1
      If SB1->B1_RASTRO == "L" //2
         If Empty(Acols[n,nPosLoteCtl])  .AND. (Acols[n,nPosTes]) <> "392"
            lRet  := .F. //.F. 
            MSGINFO("Item com Rastreabilidade. Informe o Lote"," Atenção ")
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
			        MSGINFO("Lote com Saldo ou Quantidade maior que Um"," Atenção ")
		         EndIf             
            EndIf
         EndIf //3   
      EndIf //2
   EndIf //1
//NEXT n

Return(lRet)
