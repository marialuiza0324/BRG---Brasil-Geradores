/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ EFDCON03  ³ Autor ³ Walter Junior       ³ Data ³ 17/07/24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ RETORNA CONTA PARA O F100 DO PRODUTO                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"

user function EFDCON03()
	Local   cTabela     :=  PARAMIXB[1] //SE1/SE2/SE3
	Local   cNumTit     :=  PARAMIXB[2] //E1_NUM/E2_NUM/E5_NUMERO
	Local   cPrefixo    :=  PARAMIXB[3] //E1_PREFIXO/E2_PREFIXO/E5_PREFIXO
	Local   cParcela    :=  PARAMIXB[4] //E1_PARCELA/E2_PARCELA/E5_PARCELA
	Local   cTipo       :=  PARAMIXB[5] //E1_TIPO/E2_TIPO/E5_TIPO
	Local   cPart       :=  PARAMIXB[6] //E1_CLIENTE/E2_FORNECE/E5_CLIENTE/E5_FORNECE
	Local   cLoja       :=  PARAMIXB[7] //E1_LOJA/E2_LOJA/E5_LOJA
	Local   cNaturez    :=  PARAMIXB[8] //E1_NATUREZ/E2_NATUREZ/E2_NATUREZ
	Local   nRecno      :=  PARAMIXB[9] //SE1->R_E_C_N_O_/SE2->R_E_C_N_O_/SE5->R_E_C_N_O_
	Local   cConta      :=  ""
	local aArea   	:= getarea()
	//local _cc		:= ""
	//local _codprod	:= ""
	//If cTpMov=='E'
	
	/*
	DbSelectArea("SF1")
	cConta	:= SED->ED_CONTA // pegar o padrao, e caso contemple as regras abaixo será mudado
	DbSelectArea("SD1")
	SD1->(DbSetOrder(26)) //CRIAR INDICE NUMERO + SERIE + FORNECEDOR + LOJA E ALTERAR AQUI NO FONTE (OBS:WALTER)
	If SD1->(DbSeek(xFilial("SD1")+cNumTit+cPrefixo+cPart+cLoja))
		//_cc 	 := SD1->D1_CC
		//_codprod := SD1->D1_COD
		SF1->(DbSetOrder(1))
		If SF1->(dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO))
			SF4->(DbSetOrder(1))
			If SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
				If SF4->F4_ATUATF<>'S' .AND. SF4->F4_ESTOQUE=='N' .AND. Alltrim(SF1->F1_ESPECIE) $ 'ND'  

					//posicionando centro de custo
					DbSelectArea("CTT")
					CTT->(DbSetOrder(1))
					CTT->(DbSeek(xFilial("CTT")+SD1->D1_CC))

					//posicionando no produto
					DbSelectArea("SB1")
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
					cConta := iif(!empty(SF4->F4_XCTAD),SF4->F4_XCTAD,U_RetCtaCC(SD1->D1_CC))

				EndIf
			EndIf
		EndIf
	EndIf
	RestArea(aArea)
	
	
	*/
	
	
	
	cConta:= "3401010002"
	
	
RestArea(aArea)
Return cConta
