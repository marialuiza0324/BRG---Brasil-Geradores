#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
 
Static ProCod:= "XXXXXX"
  
User Function _MT103CPO()  // Alterado para o MT100LOK
 
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Altera a forma padr�o de carregamento de campos dos itens da nota fiscal . �
//� quando o c�digo do produto � inserido. Correspondencia abaixo:                    �
//� D1_CONTA    -> B1_CONTA                                                       �
//� D1_CC       -> B1_CC                                                          �
//� D1_ITEMCTA  -> B1_ITEMCC                                                      �
//� D1_CLVL         -> B1_CLVL                                                        �
//� D1_TES      -> B1_TE                                                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
 
Local aCpo:= PARAMIXB[1] //Padrao = D1_CONTA
Local nPosConta 	:= aScan(aHeader,{|x| Trim(x[2])=="D1_CONTA"} )
Local cConta 

if ProCod<>SB1->B1_COD
  aCols[n][nPosConta]:=SB1->B1_CONTA
  ProCod:=SB1->B1_COD
  cConta:=aCols[n][nPosConta]
endif 

if empty(cConta).and.!Empty(SB1->B1_XCTAD)
  aCols[n][nPosConta]:= SB1->B1_XCTAD  
elseif empty(cConta) 
  aCols[n][nPosConta]:= SB1->B1_XCTAC   
endif

AADD(aCpo,  "D1_CONTA"   ) // Faz com que seja mantido o conteudo pre-existente no campo
AADD(aCpo,  "D1_TES"     ) // Faz com seja carregado o valor do cadastro de produto
AADD(aCpo,  "D1_CC"        ) // Faz com seja carregado o valor do cadastro de produto
AADD(aCpo,  "D1_ITEMCTA" ) // Faz com seja carregado o valor do cadastro de produto
AADD(aCpo,  "D1_CLVL"    ) // Faz com seja carregado o valor do cadastro de produto
 
Return aCpo