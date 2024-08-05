#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ F70GRSE1     ¦ Autor ¦ Claudio Ferreira¦ Data ¦ 02/01/2019 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de entrada na baixa de titulos a receber.			  ¦¦¦
¦¦¦          ¦                                							  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ CTB   		                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function F70GRSE1()

Local aArea := GetArea()
Local lPerda := 'PDD'$Alltrim(cMotBx) .or. 'PCLD'$Alltrim(cMotBx) .or. 'PERDA'$Alltrim(cMotBx)  
dbSelectArea("SA1")
dbSetOrder(1)
if lPerda .and. SE1->E1_SITUACA='6' .and. MsSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA)) 
	RECLOCK("SA1",.F.)
	if SA1->(FieldPos("A1_MSBLQL"))> 0
	  SA1->A1_MSBLQL='1'
	endif
	if SA1->(FieldPos("A1_XHISPDD"))> 0
	  SA1->A1_XHISPDD+='PDD: '+SE1->(E1_PREFIXO+'/'+E1_NUM+'-'+E1_PARCELA)+' Bx.'+Dtoc(dDatabase)+' R$ '+AllTrim(Transform(SE1->E1_VALLIQ,"@E 999,999.99"))+' - '+UsrRetName(RetCodUsr())+CHR(13)+CHR(10)		
	endif  
	SA1->(MSUNLOCK())
endif
RestArea(aArea)

Return