#include 'protheus.ch'
#include 'parmtype.ch'

//BRG
//Encerra uma OP ja iniciada
//14/04/2020

User function MTA650MNU()

	AAdd(aRotina, { "Encerrar OP", "U_ENCERRA", 0, 5 } )

Return (aRotina)

User Function ENCERRA()

	Local nCons := 0
	Local cOP := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	Local nAreaOld := Select()

	If MsgYesNo("Deseja Realmente Encerrar a OP.","ATENÇÃO")
// Verifica se a quantidade produzida é zero
		If SC2->C2_QUJE == 0
			// Verifica se existem itens requisitados/consumidos na OP usando SD3
			dbSelectArea("SD3")
			dbSetOrder(1) // Ajuste para o índice correto da tabela SD3 (normalmente por OP)
			SD3->(MsSeek(FWxFilial("SD3") + cOP))
			While !Eof() .AND. Alltrim(SD3->D3_OP) == cOP
				nCons += SD3->D3_QUANT
				SD3->(dbSkip())
			EndDo
			dbSelectArea(nAreaOld)
			If nCons > 0
				Help(, ,"AVISO#0027", ,"Não é permitido encerrar a OP, pois existem itens requisitados ou consumidos vinculados a ela.",1, 0, , , , , , ;
					{"É necessário que esses materiais sejam devolvidos e requisitados corretamente na OP onde foram consumidos."})
				Return
			Else
				SC2->(RECLOCK("SC2",.F.))
				SC2->C2_DATRF   := DDATABASE
				SC2->C2_STATUS  := "U"
				SC2->(MSUNLOCK())

				FWAlertInfo("OP iniciada encerrada.", "Atenção!!!")
			EndIf
		EndIf
	EndIf

Return
