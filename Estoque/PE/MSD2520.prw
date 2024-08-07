/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � M460FIM  � Autor � RICARDO MOREIRA        � Data � 10/03/17潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada para Excluir a tabela ZLC                 潮�
北�          �                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para PHARMA                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#Include "RwMake.CH"
#include "tbiconn.ch"
#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOPCONN.CH'

//Exclus鉶 do ZPL , para uma nota do palete. 14/03/2017

User Function MSD2520( )  
LOCAL aArea		:= GetArea()
Local cNota := SD2->D2_DOC // N鷐ero da nota
Local cSerie:= SD2->D2_SERIE // S閞ie da nota
Local _Cli := SD2->D2_CLIENTE // Cliente
Local _Lj:= SD2->D2_LOJA // Loja
Local _Ped:= SD2->D2_PEDIDO //Pedido 
//Local _Prog:= SD2->D2_SEQPED // Loja

If cFilAnt <> "0801" //MIX

DbSelectArea("ZLC")
DbSetOrder(1)  // ZAF_FILIAL +  ZAF_COD
dbSeek(xFilial("ZLC")+SF2->F2_DOC+SF2->F2_SERIE)
Do While ! eof() .AND. ZLC->ZLC_NOTA = SF2->F2_DOC .AND. ZLC->ZLC_SERIE = SF2->F2_SERIE 
	recLock("ZLC",.F.)
	ZLC->( dbDelete() )
	msUnlock()
	dbSkip()
ENDDO   
ZLC->(DBCLOSEAREA())

DbSelectArea("ZLI")
DbSetOrder(1)  // ZAF_FILIAL +  ZAF_COD
dbSeek(xFilial("ZLI")+SF2->F2_DOC+SF2->F2_SERIE)
Do While ! eof() .AND. ZLI->ZLI_NOTA = SF2->F2_DOC .AND. ZLI->ZLI_SERIE = SF2->F2_SERIE 
	recLock("ZLI",.F.)
	ZLI->( dbDelete() )
	msUnlock()
	dbSkip()
ENDDO   
ZLI->(DBCLOSEAREA())

EndIf
RestARea(aArea)
Return
