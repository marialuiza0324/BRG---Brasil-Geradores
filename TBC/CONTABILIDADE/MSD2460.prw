#include "protheus.ch"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MSD2460    ¦ Autor ¦ Claudio Ferreira   ¦ Data ¦ 07/06/2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada apos o faturamento preenche o C.Custo     ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function _MSD2460() //Substituido por tratamento padrão. A TOTVS criou os campos na SC6
//http://tdn.totvs.com/pages/releaseview.action?pageId=236592589

SD2->(Reclock("SD2",.f.))

If SC5->(FieldPos("C5_XCC"))> 0
  SD2->D2_CCUSTO := SC5->C5_XCC
Endif  
If SC5->(FieldPos("C5_XITEMC"))> 0
  SD2->D2_ITEMCC := SC5->C5_XITEMC
Endif  
If SC5->(FieldPos("C5_XCLVL"))> 0
  SD2->D2_CLVL := SC5->C5_XCLVL
Endif  
SD2->(MsUnlock())

Return
