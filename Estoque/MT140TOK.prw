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

User function MT140TOK()

Local lRet     := ParamIxb[1]
local nPosLoteCtl    := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_LOTECTL"})
local nPosCod        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"})
local nPosLocal      := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_LOCAL"})
local nPosTes        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_TES"})
local nPosQtd        := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_QUANT"})
Local _lote    := " "
Local _cod     := " "
Local _Loc     := " "
Local RetSal   := 0
Local n        

For n:= 1 to len(Acols)
    DbSelectArea("SB1")
    DbSetOrder(1)   
    IF dbSeek(xFilial("SB1")+Acols[n,nPosCod])
	   _NCM := SB1->B1_POSIPI
	   If alltrim(_NCM) $ "111111111"
		  lRet  := .F.
		  MSGINFO("Informar ajustar o NCM igual a nota"," Aten玢o ")
	EndIF
 
    If SB1->B1_RASTRO == "L"
	   If Empty(Acols[n,nPosLoteCtl]) //.AND. (Acols[n,nPosTes]) <> "392"
		  lRet  := .F.   //.F.
		  MSGINFO("Item com Rastreabilidade. Informe o Lote"," Aten玢o ")
	   Else
		
		_lote := Acols[n,nPosLoteCtl]		
		_Loc  := Acols[n,nPosLocal]
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
	
  EndIf

ENDIF

NEXT n

Return(lRet)


