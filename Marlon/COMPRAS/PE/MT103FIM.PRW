#Include "Protheus.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} MT103FIM
O ponto de entrada MT103FIM encontra-se no final da função A103NFISCAL.
Após o destravamento de todas as tabelas envolvidas na gravação do documento de entrada, depois de fechar a operação realizada neste.
É utilizado para realizar alguma operação após a gravação da NFE.
Autor: Maria Luiza
Data: 24/06/2026
/*/ 
User Function MT103FIM()

	Local nOpcao := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
	Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÇÃO DO USUARIO
	Local nX := 0

	If nOpcao == 3 .And. nConfirma == 1
		DbSelectArea("ST9")
		DbSetOrder(19) //Indíce criado para atender a necessidade T9_CODESTO+T9_SERIE
		For nX := 1 To Len(aCols)
			If MsSeek(xFilial("ST9") + aCols[nX][2] + aCols[nX][7])
				RecLock("ST9", .F.)
				ST9->T9_STATUS := "00"
				ST9->(MsUnlock())
			Endif
		Next nX
		ST9->(DbCloseArea())
	EndIf

Return (NIL)
