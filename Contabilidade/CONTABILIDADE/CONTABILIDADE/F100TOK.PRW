#include "protheus.ch"

/*
__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � F100TOK   � Utilizador � Claudio Ferreira � Data � 20/06/12���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de Entrada na confirma��o da MB                      ���
���          � Utilizado para validar o preenchimento do C.Custo Deb      ���
���          � 								  ���
��+----------+------------------------------------------------------------���
��� Uso      � TOTVS-GO                                                   ���    
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                         

User Function F100TOK()
Local lRet:=.t.

if empty(M->E5_CCD) .and. cRecPag='P' .and. M->E5_RATEIO<>'S'
  Aviso('Aten��o!','Informar o campo [C.Custo Deb]',{'Ok'})
  lRet:=.f.
endif

if empty(M->E5_CCC) .and. cRecPag='R' .and. M->E5_RATEIO<>'S'
  Aviso('Aten��o!','Informar o campo [C.Custo Cre]',{'Ok'})
  lRet:=.f.
endif

Return lRet
