/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M460FIM  ³ Autor ³ RICARDO MOREIRA        ³ Data ³ 10/03/17³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada para Excluir a tabela ZLC                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para PHARMA                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#Include "RwMake.CH"
#include "tbiconn.ch"
#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOPCONN.CH'

//Exclusão do ZPL , para uma nota do palete. 14/03/2017

User Function MSD2520( )  
LOCAL aArea		:= GetArea()
Local cNota := SD2->D2_DOC // Número da nota
Local cSerie:= SD2->D2_SERIE // Série da nota
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
