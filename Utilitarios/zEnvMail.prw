#include "rwmake.ch"
#Include "TOTVS.ch"
#INCLUDE "topconn.ch"
#include "fwmvcdef.ch"
/*
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � zEnvMail   � Autor � Maria Luiza        � Data � 25/06/2024���
��+----------+------------------------------------------------------------���
���Descri��o � Envia e-mail com assunto, corpo em HTML e anexos           ���
���Par�metros� cPara   - Destinat�rio(s) do e-mail                        ���
���          � cAssunto- Assunto do e-mail                                ���
���          � xHTM    - Corpo do e-mail em HTML                          ���
���          � aAnexos - Array de anexos                                  ���
���          �                             								  ���
��+----------+------------------------------------------------------------���
��� Uso      � BRG-Brasil Geradores                                       ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function zEnvMail(cPara, cAssunto, xHTM, aAnexos)

	Local aArea    := GetArea()
	Local lEnvioOK := .F.
	lEnvioOK := GPEMail(cAssunto, xHTM, cPara, aAnexos)
	RestArea(aArea)

Return lEnvioOK
