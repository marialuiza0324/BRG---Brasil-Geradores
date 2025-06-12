#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} MT410TOK
 Este ponto de entrada é executado ao clicar no botão SALVAR
  da rotina de Manutenção do Pedido de Venda, Ele deve ser 
  utilizado quando se desejar validar a confirmação das operações de 
  inclusão, alteração, exclusão e cópia do Pedido de Venda.
  Utilizado para excluir amarração do PV X OP quando 
  Pedido de venda for excluído.
  @type  USER FUNCTION
  @author Maria Luiza
  @since 07/03/2025
/*/

USER FUNCTION MT410TOK()

	Local nOpc  := PARAMIXB[1]	//Número referente a opção de manutenção que está sendo utilizada. Ex: 2-Visualização, 3-Inclusão, 4-Alteração
	Local cQry := ""
	Local lRet := .T.
	Local cUser := SupergetMv("MV_USERLOC", , ) //Parâmetro que controla acesso à TES
	Local cUser_Id := RetCodUsr()
	Local cTesLoc  := SupergetMv("MV_TESLOC", , ) //Parâmetro que controla as TES que serão LIBERADAS para usuário de locação
	Local cUserId := RetCodUsr()
	Local cNome := UsrFullName(cUserID)
	Local nI := 0
	Local cEmpLoc := SupergetMv("MV_EMLOCPV", , ) // Parâmetro que controla empresas que irão validar o usuário locacao
	Local cEmp := FwCodEmp()


	If nOpc == 1

		If Select("TMP1") > 0
			TMP1->(dbCloseArea())
		EndIf

		cQry := "SELECT * FROM " +RetSqlName("SC6")+ " SC6 "
		cQry += "WHERE C6_NUM = " +SC5->C5_NUM+ " "
		cQry += "AND D_E_L_E_T_ = '' "

		DbUseArea(.T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TMP1", .T., .T.)

		DbSelectArea("TMP1")

		While TMP1->(!EOF())
			// Desfazendo a amarração na SC6
			dbSelectArea("Z10")
			dbsetorder(4)
			If Z10->(MsSeek(xFilial("Z10") + TMP1->C6_NUM + TMP1->C6_PRODUTO + TMP1->C6_ITEM))
				Reclock("Z10", .F.)
				DbDelete()
				Z10->(MsUnlock())
			EndIf
			TMP1->(DbSkip())
		EndDo

		TMP1->(DbCloseArea())



	ElseIf nOpc == 3

		/*Validação criada para quando for feita cópia do pedido de venda, validar o RESPONSÁVEL 
			pelo pedido 28/05/2025 Solicitante - Brenda #GLPI 9692*/

		M->C5_XUSER := cNome

		/*Validação criada para quando for feita cópia do pedido de venda, validar a TES
		28/05/2025 Solicitante - Brenda #GLPI 9694*/
		
		// Loop para validar as TES dos itens do pedido de venda
		For nI := 1 To Len(aCols)
			If cUser_Id $ cUser
				// Verifica se a TES do item não está liberada para o usuário de locação nas filiais 0501 ou 1001
				If !(aCols[nI][12] $ cTesLoc) .AND. cEmp $ cEmpLoc
					Help(, ,"AVISO#0001", ,"Usuário " +cUserName+ " não tem permissão para utilizar TES selecionada",1, 0, , , , , , {"Para esta filial, utilize a(s) TES : " +cTesLoc})
					lRet := .F.
					Exit
				ElseIf !(aCols[nI][12] $ cTesLoc) .AND. cEmp $ cEmpLoc 
					Help(, ,"AVISO#0001", ,"Usuário " +cUserName+ " não tem permissão para utilizar TES selecionada",1, 0, , , , , , {"Para esta filial, utilize a(s) TES : " +cTesLoc})
					lRet := .F.
					Exit
				EndIf
			EndIf
		Next

		// Validação para restringir o armazém conforme filial para usuário de locação
		// 28/06/2024 - Solicitante - Brenda #GLPI 9732
		/*
			Verifica se o usuário atual possui permissão para movimentar itens no armazém selecionado, de acordo com a filial.

			- Para a filial "0501", somente é permitido movimentar itens no armazém "99".
			- Para a filial "0101", somente é permitido movimentar itens no armazém "11".
			- Caso o usuário tente movimentar em um armazém diferente do permitido para a filial correspondente, é exibida uma mensagem de aviso (Help) informando a restrição e sugerindo o armazém correto.
			- Se a restrição for violada, a variável lRet é definida como .F. e o loop é interrompido.
			- O controle é feito para cada item da lista aCols, verificando o armazém associado ao item (posição 17 do array).*/
		
		If cUser_Id $ cUser
			For nI := 1 To Len(aCols)
				// aCols[nI][17] = Armazém do item
				If cFilAnt == "0501" .AND. aCols[nI][17] <> "99"
					Help(, ,"AVISO#0025", ,"Usuário " +cUserName+ " não tem permissão para movimentar no armazém selecionado",1, 0, , , , , , {"Para filial " +cFilAnt+ ", utilize o armazém: 99"})
					lRet := .F.
					Exit
				ElseIf cFilAnt == "0101" .AND. aCols[nI][17] <> "11" .AND. aCols[nI][17] <> "10"
					Help(, ,"AVISO#0026", ,"Usuário " +cUserName+ " não tem permissão para movimentar no armazém selecionado",1, 0, , , , , , {"Para filial " +cFilAnt+ ", utilize o armazém: 10 ou 11"})
					lRet := .F.
					Exit
				EndIf
			Next
		EndIf

	EndIf

Return lRet

