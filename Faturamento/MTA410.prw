#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MTA410 ³ Autor ³ Ricardo Moreira ³ Data ³10/03/2017        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada para verificar se a TES , digitada é de   ³±±
±±³          ³ Armazenamento.							                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Pharma Express                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function MTA410()
	Local uRet := .T.
	Local xCfop  := " "
	Local xTes  := " "
	Local xCod  := " " //Cod. do Produto
	Local i    := 0
	Local _NfRem := M->C5_NFREM 

	If Funname() <> "LOCA029"

		For i:= 1 to Len(aCols)
			If !aCols[i,Len(aHeader)+1]
				xCfop := aCols[i,GdFieldPos("C6_CF",aHeader)]
				xTes  := aCols[i,GdFieldPos("C6_TES",aHeader)]
				xCod  := aCols[i,GdFieldPos("C6_PRODUTO",aHeader)] //Cod. Do Produto
				xLctl := aCols[i,GdFieldPos("C6_LOTECTL",aHeader)] //Lote do Produto
				If xTes $ "530/535"
					If empty(_NfRem)
						uRet := .F.
						Alert("Pedido de Fatura, Por Favor Preencher o campo nota de Remessa !!!")
					EndIf
				EndIf
 
				If substr(xCfop,2,3) = "908"
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+xCod)
						IF SB1->B1_RASTRO = "L"
							IF EMPTY(xLctl)
								uRet := .F.
								Alert("Item de Locação com Rastro, por favor preencher o Lote !!!")
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf

Return uRet
