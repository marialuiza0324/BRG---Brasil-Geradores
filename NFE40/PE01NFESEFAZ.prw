#include "protheus.ch"
#DEFINE CRLF CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PE01NFESEFAZ ºAutor  ³ Totvs GO    	 º Data ³  26/11/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Msg NF-e                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laranja                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PE01NFESEFAZ()

Local aProd			:= PARAMIXB[1]
Local cMensCli		:= PARAMIXB[2]
Local cMensFis		:= PARAMIXB[3]
Local aDest			:= PARAMIXB[4]
Local aNota   		:= PARAMIXB[5]
Local aInfoItem		:= PARAMIXB[6]
Local aDupl			:= PARAMIXB[7]
Local aTransp		:= PARAMIXB[8]
Local aEntrega		:= PARAMIXB[9]
Local aRetirada		:= PARAMIXB[10]
Local aVeiculo		:= PARAMIXB[11]
Local nx            := 0
Local aReboque		:= PARAMIXB[12]
Local aNfVincRur 	:= PARAMIXB[13]
Local aEspVol       := PARAMIXB[14]//aParam[14]
Local aNfVinc		:= PARAMIXB[15]//aParam[15]
Local aDetPag		:= PARAMIXB[16] //aParam[16]
Local aObsCont      := PARAMIXB[17] //Param[17]

Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC6  := SC6->(GetArea())

Local aRetorno		:= {}
Local cMsg 			:= ""
Local cCodTran	 	:= ""
Local cTexto        := ""
Local cMenAtivo     := ""

If (aNota[4] == "1") //cTipo == "1"   
	
	// -------------------------------------
	// Dados da Carga, Caminhão e Motorista
	// -------------------------------------
	SD2->(dbSetOrder(3))
	SD2->(MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
	dbSelectArea("SC5")
	dbSetOrder(1)
	SC5->(MsSeek(xFilial("SC5")+SD2->D2_PEDIDO))
	
	if SF2->F2_TIPO='N' //Somente NFe normal Claudio 12.02.14
		
		For nx := 1 To Len(aProd)
  			cSerie:=''
			
			SB1->(dbSetOrder(1))
			IF SB1->(dbSeek(xFilial("SB1") + aProd[nx][2])) //posicona no produto pelo código
					  
				//Trata descricao do produto 
				cDescr  := Alltrim(iif(empty(SB1->B1_DESC),SB1->B1_DESC,SB1->B1_DESC))
				
				//Trata Numero de Serie  
				if !Empty(aProd[nx][19]) //posicao 19: SD2->D2_LOTECTL
					cSerie:='Nº SÉRIE:'+AllTrim(aProd[nx][19]) //posicao 19: SD2->D2_LOTECTL
				endif 			  
	            				
			EndIF
  
  			//Define a descricao
  			aProd[nx][4] := cDescr+ '  '  + cSerie+ '  ' 
		Next
				
		cMensCli += " / "
		cMensCli += "COD CLIENTE: " + SC5->C5_CLIENTE + " - " + SC5->C5_LOJACLI
		cMensCli += " / "
		cMensCli += "PEDIDO: " + SC5->C5_NUM
		cMensCli += " / "   
		cMensCli += "TAB PRECO: " + SC5->C5_TABELA
		cMensCli += " / "	
		cMensCli += "N FANTASIA: " + Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NREDUZ")
		cMensCli += " / "
		cMensCli += " F.PGTO:"+RetField("SCV",1,xFilial("SCV")+SC5->C5_NUM,"CV_FORMAPG")
		cMensCli += " / "
		cMensCli += " PEDIDO N.: " + SC5->C5_XPEDCOM  
		cMensCli += "  /  "
		cMensCli +=  SC5->C5_XMENNOT		 
	Endif
		
	aadd(aNota, IIF(Empty(SF2->F2_DTENTR),SF2->F2_EMISSAO,SF2->F2_DTENTR))
	
Endif

RestArea(aAreaSC5)
RestArea(aAreaSC6)

aadd(aRetorno,aProd)    //1
aadd(aRetorno,cMensCli) //2
aadd(aRetorno,cMensFis) //3
aadd(aRetorno,aDest)    //4
aadd(aRetorno,aNota)    //5
aadd(aRetorno,aInfoItem)//6
aadd(aRetorno,aDupl)    //7
aadd(aRetorno,aTransp)  //8
aadd(aRetorno,aEntrega) //9
aadd(aRetorno,aRetirada)//10
aadd(aRetorno,aVeiculo) //11
aadd(aRetorno,aReboque) //12
aadd(aRetorno,aNfVincRur) //13
aadd(aRetorno,aEspVol) //14
aadd(aRetorno,aNfVinc) //15   
aadd(aRetorno,aDetPag) //16
aadd(aRetorno,aObsCont) //17 

RETURN aRetorno
