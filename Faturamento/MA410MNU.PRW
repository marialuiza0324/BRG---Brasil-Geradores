/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � M460FIM  � Autor � Ricardo Moreira� 		  Data � 21/02/17 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada para GERAR O BORDERO DO BANCO ITAU  潮�
北�          � Nota Fiscal de Saida                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para BRG                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH" 
#DEFINE CRLF Chr(13)+Chr(10) 

User Function MA410MNU()

aadd( aRotina,{"Bordero Itau","U_TELABOR" ,0,7,0, nil} )
aadd( aRotina,{"Imprime Fatura","U_BRG020" ,0,7,0, nil} )
aadd( aRotina,{"Vlr Fatura Itens","U_BRG039" ,0,7,0, nil} )

Return 
 
