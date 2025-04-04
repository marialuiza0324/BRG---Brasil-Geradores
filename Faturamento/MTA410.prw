#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MTA410 � Autor � Ricardo Moreira � Data �10/03/2017        潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de entrada para verificar se a TES , digitada � de   潮�
北�          � Armazenamento.							                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Pharma Express                             潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
User Function MTA410()
	Local uRet := .T.
	Local xCfop  := " "
	Local xTes  := " "
	Local xCod  := " " //Cod. do Produto
	//Local xRast := " " //Verifica a rastreabilidade
	Local i    := 0
	//Local _TpPag := M->C5_TPPAGF //TIpo de pagamento
	Local _NfRem := M->C5_NFREM //
	//Local _VcFat := M->C5_VENCFAT // Venc. Fatura
	//Local _Cond  := M->C5_CONDLOC // Cond. Pag Loca玢o
	//Local _VlrFat:= M->C5_VLRFAT  //Vrl Fatura
	//Local _ForPg := M->C5_XFORPG //Forma de Pagamento   esse tem q ser RE (remessa), para todas as notas de remessa loca玢o

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
					//If empty(_TpPag) .or. empty(_VcFat) .or. empty(_Cond) .or. _VlrFat = 0 .or. _ForPg <> "RE"
					// uRet := .F.
					// Alert("Pedido Remessa Loca玢o, Por Favor configurar a ABA Loca玢o !!!")
					//EndIf
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+xCod)
						IF SB1->B1_RASTRO = "L"
							IF EMPTY(xLctl)
								uRet := .F.
								Alert("Item de Loca玢o com Rastro, por favor preencher o Lote !!!")
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf

Return uRet
