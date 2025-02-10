#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � SPDPIS07     � Autor � Walter Honorato   � Data � 03/02/21 ���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de entrada                                           ���
���          � Definir a conta Receita blocos EFD Contribui��es           ���
���          �                                                            ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico Wehrmann 				                          ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SPDPIS07()
	//Local	cFilial		:=	PARAMIXB[1]	//FT_FILIAL
	Local	cTpMov		:=	PARAMIXB[2]	//FT_TIPOMOV
	Local	cSerie		:=	PARAMIXB[3]	//FT_SERIE
	Local	cDoc		:=	PARAMIXB[4]	//FT_NFISCAL
	Local	cClieFor	:=	PARAMIXB[5]	//FT_CLIEFOR
	Local	cLoja		:=	PARAMIXB[6]	//FT_LOJA
	Local	cItem		:=	PARAMIXB[7]	//FT_ITEM
	Local	cProd		:=	PARAMIXB[8]	//FT_PRODUTO
	Local	cConta		:=	""
	Local 	aArea  	:= GetArea()
	SFT->(DbSetOrder(1))
	SFT->(dbSeek(xFilial("SFT")+cTpMov+cSerie+cDoc+cClieFor+cLoja+cItem+cProd))
	cConta		:= SFT->FT_CONTA

	If cTpMov=='S'
		//posicionando no cliente
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+cClieFor+cLoja))
		
		//posicionando no produto
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+cProd))
		
		//posicionando na TES
		SD2->(DbSetOrder(3))
		If SD2->(DbSeek(xFilial("SD2")+cDoc+cSerie+cClieFor+cLoja+cProd+cItem))
			SF4->(DbSetOrder(1))
			If SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
				cConta	:=	SF4->(if(!empty(F4_XCTAC),F4_XCTAC,IF(F4_TRANFIL='1',IF(!EMPTY(SB1->B1_CONTA),SB1->B1_CONTA,'CTA CTB PROD VAZIA'),U_RetCta(IF(SD2->D2_EST<>'EX','122','123'),U_RetGrpCtb()))))                                                                                
					      //SF4->(if(!empty(F4_XCTAC),F4_XCTAC,IF(F4_TRANFIL='1',IF(!EMPTY(SB1->B1_CONTA),SB1->B1_CONTA,'CTA CTB PROD VAZIA'),U_RetCta(IF(SD2->D2_EST<>'EX','122','123'),U_RetGrpCtb()))))                                                                                
				//SF4->(if(!empty(F4_XCTAC),F4_XCTAC,IF(F4_TRANFIL='1',IF(!EMPTY(SB1->B1_CONTA),SB1->B1_CONTA,'CTA CTB PROD VAZIA'),U_RetCta(IF(SD2->D2_EST<>'EX','122','123'),U_RetGrpCtb()))))   //AJUSTADO BRG                                                                             
				
				
				If 'VZA'$Upper(cConta)
					cConta	:= SFT->FT_CONTA
				ENDIF
			ENDIF
		Endif
	
	
	Elseif cTpMov=='E'//corre��o para sped devido mudan�a no layout do sped, por padrao � UTILIZADO O CAMPO B1_CONTA porem � utilizado mais de uma conta no produto
		cConta	:= SFT->FT_CONTA // pegar o padrao, e caso contemple as regras abaixo ser� mudado
		DbSelectArea("SD1")
		SD1->(DbSetOrder(1))
		If SD1->(DbSeek(xFilial("SD1")+cDoc+cSerie+cClieFor+cLoja+cProd+cItem))
			SF4->(DbSetOrder(1))
			If SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
				If SF4->F4_ATUATF<>'S' .AND. SF4->F4_ESTOQUE=='N' .AND. SD1->D1_TIPO $ 'N/C'
								
					//posicionando centro de custo
					DbSelectArea("CTT")
					CTT->(DbSetOrder(1))
					CTT->(DbSeek(xFilial("CTT")+SD1->D1_CC))
								
					//posicionando no produto
					DbSelectArea("SB1")
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+cProd))
					cConta := iif(!empty(SF4->F4_XCTAD),SF4->F4_XCTAD,U_RetCtaCC(SD1->D1_CC))


					
				EndIf
			EndIf
		EndIf
	Endif
	RestArea(aArea)

Return cConta

