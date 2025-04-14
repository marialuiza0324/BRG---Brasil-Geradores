#include 'protheus.ch'
#include 'parmtype.ch'

//U_FSPCP001
USER FUNCTION FSPCP001()

	Local cAlias := "Z10"
	Local cTitulo := "Amarração OP x Pedido de Venda"
	Local cFunExc := "U_FSPCPA()"
	Local cFunAlt := "U_FSPCPB()"


	AxCadastro(cAlias,cTitulo,cFunExc,cFunAlt)

RETURN

/*/{Protheus.doc} FSPCP001A
  (Função de exclusão da amarração do Pedido com a Ordem de Produção)
  @type  USER FUNCTION
  @author Marlon Pablo
  @since 28/08/2023
/*/
USER FUNCTION FSPCPA()

	Local lRet := .F.

	If MsgYesNo("Tem Certeza que deseja excluir o registro?","Confirmação")

		// Desfazendo a amarração na SC6
		dbSelectArea("SC6")
		If SC6->(DbSeek(xFilial("SC6") + Z10->Z10_PEDIDO + Z10->Z10_ITEM + Z10->Z10_PRODUT))
			Reclock("SC6", .F.)
			SC6->C6_NUMOP := ""  // Remove a OP
			SC6->(MsUnlock())
		EndIf
		
		lRet := .T.
	EndIf



Return lRet

/*/{Protheus.doc} FSPCP001B
  (
    Função que trata a inclusão de um novo registro
  )
  @type  USER FUNCTION
  @author Marlon Pablo
  @since 28/08/2023
/*/
USER FUNCTION FSPCPB()

	Local lRet  := .F.
	Local lOp   := .T.
	//Local lPed  := .T.
	Local lIte  := .T.
	Local cMsg := ""
	Local nCont := 0
	Local lAmarra := .T.
	Local lAmarraOP := .T.
	Local cOp := ""
	Local cPedido := ""
	Local cItem   := ""
	Local _cQry  := ""
	Local cQuery := ""
	Local nTotal := 0

	IF INCLUI
		cMsg := "Confirma a inclusão do Registro?
		If MsgYesNo(cMsg,"Confirmação")

			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial("SC6") + PADR(M->Z10_PEDIDO, TAMSX3("C5_NUM")[1]))

			//Validar
			//Validar se o pedido esta aberto Abrir area do Cabeçalho do pedido para validar a emissão da nota
			/*IF !Empty(SC2->C2_OK) .AND. SC2->C2_QUANT = SC2->C2_QUJE .AND. !Empty(SC2->C2_DATRF)
				//FWAlertWarning( "Ordem de produção apontada. Selecione outra", "Validação de Ordem de Produção!" )
				lPed := .T.
			ENDIF*/

			//Validar se a Op esta aberta.
			//Permitir OP Firme; Prevista e Apontada
			dbSelectArea("SC2")
			dbSetOrder(1)
			dbSeek(xFilial("SC2")+PADR(SubStr(M->Z10_PEDIDO,1,6), TAMSX3("C2_NUM")[1])+PADR(SubStr(M->Z10_PEDIDO,7,2), TAMSX3("C2_ITEM")[1])+PADR(SubStr(M->Z10_PEDIDO,9), TAMSX3("C2_SEQUEN")[1]))

			IF SC6->C6_NOTA == ""
				FWAlertWarning( "Pedido já Faturado! Escolha outro item.", "Validação de Pedido" )
				lOp := .F.
			ENDIF

			cProdutoOp:= Posicione("SC2",1,FWxFilial('SC2')+SUBSTR(Z10_ORDEM,1,6)+SUBSTR(Z10_ORDEM,7,2)+SUBSTR(Z10_ORDEM,9,3),'C2_PRODUTO')

			//Validar se o código do produto selecionado é o mesmo da OP
			IF M->Z10_PRODUT <> cProdutoOp
				lIte := .F.
				nCont := 1
			ENDIF

			If Select("TZ10") > 0
				TZ10->(dbCloseArea())
			EndIf

			//Valida se pedido já esta amarrado a outra OP
			_cQry := "SELECT * FROM " + retsqlname("Z10")+" Z10 "
			_cQry += "WHERE D_E_L_E_T_ = '' "
			_cQry += "AND Z10_PEDIDO = '"+M->Z10_PEDIDO+"' "
			_cQry += "AND Z10_ITEM = '"+M->Z10_ITEM+"' "
			_cQry += "AND Z10_PRODUT = '"+M->Z10_PRODUT+"' "
			_cQry += "AND Z10_STATUS = '1' "

			DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TZ10",.T.,.T.) //Filtra pedido na SC7

			DbSelectArea("TZ10")

			cOp := TZ10->Z10_ORDEM

			Count to nTotal

			IF nTotal > 0
				nCont := nCont +1
				lAmarraOP := .F.
			EndIf

			If Select("TZ10") > 0
				TZ10->(dbCloseArea())
			EndIf

			// Valida se a OP já está amarrada a outro pedido
			cQuery := "SELECT  * FROM " + retsqlname("Z10") + " Z10 "
			cQuery += "WHERE D_E_L_E_T_ = '' "
			cQuery += "AND Z10_ORDEM = '"+M->Z10_ORDEM+"' "
			cQuery += "AND Z10_ITEM = '"+M->Z10_ITEM+"' "
			cQuery += "AND Z10_PRODUT = '"+M->Z10_PRODUT+"' "

			DbUseArea(.T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "TZ10", .T., .T.)

			DbSelectArea("TZ10")

			cPedido := TZ10->Z10_PEDIDO
			cItem  := TZ10->Z10_ITEM

			Count to nTotal

			IF nTotal > 0
				lAmarra := .F.
			EndIf

			TZ10->(DbCloseArea())

			IF  lOp = .F. //.OR. lPed = .F.
				lRet := .F.


			ELSEIF lIte = .F. .AND. lAmarra = .F.
				FWAlertWarning("<br><br><font color='#FF0000'>Total de Ocorrências: " + cValtoChar(nCont) + CHR(13) + ;
					"1-Produtos Divergentes!" + CHR(13) + ;
					"Escolha um item do pedido que tenha o mesmo produto da Ordem de Produção." + CHR(13) + ;
					"2-Ordem de produção amarrada ao pedido Nº: " + cPedido + CHR(13) + ;
					"Item do pedido: " + cItem + "</font>", "Avisos de Inconsistências!!!")
				lRet = .F.

			ELSEIF lAmarra = .F.
				FWAlertWarning("<br><br><font color='#FF0000'>Total de Ocorrências: "+cValtoChar(nCont)+CHR(13);
					+"1-Ordem de produção amarrada ao pedido Nº: "+cPedido+CHR(13);
					+"Item do pedido: "+cItem+ "</font>", "Avisos de Inconsistências!!!")
				lRet = .F.

			Elseif lAmarraOP = .F.
				FWAlertWarning("<br><br><font color='#FF0000'>Total de Ocorrências: "+cValtoChar(nCont)+CHR(13);
					+"1-Pedido amarrado a OP Nº: "+cOP+CHR(13);
					+"Item do pedido: "+cItem+ "</font>", "Avisos de Inconsistências!!!")
				lRet = .F.

			ELSEIF lIte = .F.
				FWAlertWarning("<br><br><font color='#FF0000'>Total de Ocorrências: "+cValtochar(nCont)+CHR(13);
					+"1-Produtos Divergentes!"+CHR(13);
					+"Escolha um item do pedido que tenha o mesmo produto da Ordem de Produção."+CHR(13);
					+"</font>", "Avisos de Inconsistências!!!")
				lRet = .F.

			ELSE

				dbSelectArea("SC6")
				dbSetOrder(1)

				If SC6->(Dbseek(xFilial("SC6")+M->Z10_PEDIDO+M->Z10_ITEM+M->Z10_PRODUT))
					Reclock("SC6",.F.)

					SC6->C6_NUMOP := M->Z10_ORDEM

					SC6->(MsUnlock())
				EndIF
				lRet := .T.
			ENDIF
		EndIf

	Elseif  ALTERA

		cMsg := "Confirma alteração do registro?"

		If MsgYesNo(cMsg,"Confirmação")
			dbSelectArea("SC6")
			dbSetOrder(1)

			If SC6->(Dbseek(xFilial("SC6")+M->Z10_PEDIDO+M->Z10_ITEM+M->Z10_PRODUT))

				Reclock("SC6",.F.)

				SC6->C6_NUMOP := ''

				SC6->(MsUnlock())

			EndIf
			lRet := .T.
		EndIf

	EndIf

Return lRet


User Function xDesc()

	Local cDescri := POSICIONE("SC6",1,FWxFilial('SC6')+M->Z10_PEDIDO+M->Z10_ITEM+M->Z10_PRODUT,'C6_DESCRI')


Return cDescri


User Function xNomCli()

	Local cCodCli := Posicione("SC5",1,FWxFilial('SC5')+M->Z10_PEDIDO,'C5_CLIENTE')
	Local cNomCli := Posicione("SC5",1,FWxFilial('SC5')+M->Z10_PEDIDO,'C5_XNOMCLI')
	Local cNome := ''

	cNome := Alltrim(cCodCli)+ ' - ' +Alltrim(cNomCli)


Return cNome

