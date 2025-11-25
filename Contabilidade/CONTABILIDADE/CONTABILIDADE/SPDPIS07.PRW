#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ SPDPIS07     ¦ Autor ¦ Claudio Ferreira  ¦ Data ¦ 28/06/19 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de entrada                                           ¦¦¦
¦¦¦          ¦ Definir a conta Receita blocos EFD Contribuições           ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TOTVS-GO								                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*
User Function SPDPIS07()
Local	cFilial		:=	PARAMIXB[1]	//FT_FILIAL
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
	// Verifica a TES 
	If SFT->(FieldPos("FT_TES"))> 0    
		If !Empty(SFT->FT_TES)
			//posicionando no TES
			DbSelectArea("SF4")
			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4")+SFT->FT_TES))
		    If SFT->FT_TIPO<>'D' .and. !SF4->F4_BONIF="S" //Conta na TES
		      cConta	:= SF4->(if(!empty(F4_XCTAC),F4_XCTAC,IF(F4_TRANFIL='1',IF(!EMPTY(SB1->B1_CONTA),SB1->B1_CONTA,''),U_RetCta(IF(SA1->A1_EST<>'EX','122','123'),U_RetGrpCtb())))) 					    
		    ElseIf SFT->FT_TIPO='D'  //Conta na TES
		      cConta	:=  iif(!empty(SF4->F4_XCTAD),SF4->F4_XCTAD,U_RetCta('113')) 					    
		    ElseIf SF4->F4_BONIF="S".AND.SF4->F4_DUPLIC<>'S' //Bonificação
		      cConta	:= U_RetCta('064',U_RetGrpCtb()) 
		    Endif
		Else
			cConta	:=	U_RetCta(IF(SA1->A1_EST<>'EX','122','123'),U_RetGrpCtb())	    
		Endif
	Else
     	cConta	:=	U_RetCta(IF(SA1->A1_EST<>'EX','122','123'),U_RetGrpCtb())		
	Endif

    If 'VZA'$Upper(cConta) .or. Empty(cConta)
    	cConta	:= if(!empty(SFT->FT_CONTA),SFT->FT_CONTA,SB1->B1_CONTA)
    Endif
Endif				
RestArea(aArea) 

Return cConta*/

