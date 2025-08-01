#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} MT410TOK
 Este ponto de entrada � executado ao clicar no bot�o SALVAR
  da rotina de Manuten��o do Pedido de Venda, Ele deve ser 
  utilizado quando se desejar validar a confirma��o das opera��es de 
  inclus�o, altera��o, exclus�o e c�pia do Pedido de Venda.
  Utilizado para excluir amarra��o do PV X OP quando 
  Pedido de venda for exclu�do.
  @type  USER FUNCTION 
  @author Maria Luiza,
  @since 07/03/2025
/*/

USER FUNCTION MT410TOK()

	Local nOpc  := PARAMIXB[1]	//N�mero referente a op��o de manuten��o que est� sendo utilizada. Ex: 2-Visualiza��o, 3-Inclus�o, 4-Altera��o
	Local cQry := ""
	Local lRet := .T.
	Local cUser := SupergetMv("MV_USERLOC", , ) //Par�metro que controla acesso � TES
	Local cUser_Id := RetCodUsr()
	Local cTesLoc  := SupergetMv("MV_TESLOC", , ) //Par�metro que controla as TES que ser�o LIBERADAS para usu�rio de loca��o
	Local cUserId := RetCodUsr()
	Local cNome := UsrFullName(cUserID)
	Local nI := 0
	Local cEmpLoc := SupergetMv("MV_EMLOCPV", , ) // Par�metro que controla empresas que ir�o validar o usu�rio locacao
	Local cEmp := FwCodEmp()

	If Funname() <> "LOCA001"
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
				// Desfazendo a amarra��o na SC6
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

		/*Valida��o criada para quando for feita c�pia do pedido de venda, validar o RESPONS�VEL 
			pelo pedido 28/05/2025 Solicitante - Brenda #GLPI 9692*/

		M->C5_XUSER := cNome

		/*Valida��o criada para quando for feita c�pia do pedido de venda, validar a TES
		28/05/2025 Solicitante - Brenda #GLPI 9694*/
		
		// Loop para validar as TES dos itens do pedido de venda
		For nI := 1 To Len(aCols)
			If cUser_Id $ cUser
				// Verifica se a TES do item n�o est� liberada para o usu�rio de loca��o nas filiais 0501 ou 1001
				If !(aCols[nI][12] $ cTesLoc) .AND. cEmp $ cEmpLoc
					Help(, ,"AVISO#0001", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para utilizar TES selecionada",1, 0, , , , , , {"Para esta filial, utilize a(s) TES : " +cTesLoc})
					lRet := .F.
					Exit
				ElseIf !(aCols[nI][12] $ cTesLoc) .AND. cEmp $ cEmpLoc 
					Help(, ,"AVISO#0001", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para utilizar TES selecionada",1, 0, , , , , , {"Para esta filial, utilize a(s) TES : " +cTesLoc})
					lRet := .F.
					Exit
				EndIf
			EndIf
		Next

		// Valida��o para restringir o armaz�m conforme filial para usu�rio de loca��o
		// 28/06/2024 - Solicitante - Brenda #GLPI 9732
		/*
			Verifica se o usu�rio atual possui permiss�o para movimentar itens no armaz�m selecionado, de acordo com a filial.

			- Para a filial "0501", somente � permitido movimentar itens no armaz�m "99".
			- Para a filial "0101", somente � permitido movimentar itens no armaz�m "11".
			- Caso o usu�rio tente movimentar em um armaz�m diferente do permitido para a filial correspondente, � exibida uma mensagem de aviso (Help) informando a restri��o e sugerindo o armaz�m correto.
			- Se a restri��o for violada, a vari�vel lRet � definida como .F. e o loop � interrompido.
			- O controle � feito para cada item da lista aCols, verificando o armaz�m associado ao item (posi��o 17 do array).*/
		
		If cUser_Id $ cUser
			For nI := 1 To Len(aCols)
				If CCADASTRO == "Pedidos de Venda - INCLUIR"
					If cFilAnt == "0501" .AND. aCols[nI][16] <> "99"
						Help(, ,"AVISO#0025", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para movimentar no armaz�m selecionado",1, 0, , , , , , {"Para filial " +cFilAnt+ ", utilize o armaz�m: 99"})
						lRet := .F.
						Exit
					ElseIf cFilAnt == "0101" .AND. aCols[nI][16] <> "11" .AND. aCols[nI][16] <> "10"
						Help(, ,"AVISO#0026", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para movimentar no armaz�m selecionado",1, 0, , , , , , {"Para filial " +cFilAnt+ ", utilize o armaz�m: 10 ou 11"})
						lRet := .F.
						Exit
					EndIf
				ElseIf CCADASTRO == "Pedidos de Venda - COPIAR"
						If cFilAnt == "0501" .AND. aCols[nI][17] <> "99"
							Help(, ,"AVISO#0025", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para movimentar no armaz�m selecionado",1, 0, , , , , , {"Para filial " +cFilAnt+ ", utilize o armaz�m: 99"})
							lRet := .F.
							Exit
						ElseIf cFilAnt == "0101" .AND. aCols[nI][17] <> "11" .AND. aCols[nI][17] <> "10"
							Help(, ,"AVISO#0026", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para movimentar no armaz�m selecionado",1, 0, , , , , , {"Para filial " +cFilAnt+ ", utilize o armaz�m: 10 ou 11"})
							lRet := .F.
							Exit
						EndIf
				EndIf

			Next
		EndIf

	EndIf
EndIf

Return lRet

