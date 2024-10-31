//Bibliotecas
#Include "TOTVS.ch"
#INCLUDE "topconn.ch"
#include "fwmvcdef.ch"

/*/{Protheus.doc} User Function FSMNT001
Exemplo de consumo de REST usando Httpget
@type  Function
@author Maria Luiza
@since 09/10/2024
https://tdn.totvs.com/display/tec/HTTPGet
/*/

User Function FSMNT001()

	Local cHtmlPage
	Local aHorim := {}
	Local nX     := 0
	Local nPos := 0
	Local cLote := ''
	Local cHorim := ''
	Local cDados := ''
	Local aPares := {}
	Local i  := 0
	Local nTotal := 0
	Local cUserID :=  RetCodUsr()
	Local cHora   := SUBSTR(Time(),1,5)
	Local cRotina := FunName()
	Local cQry   := ''
	Local cCodBem := ""
	Local dDtUltLan
	Local cCCusto := ""
	Local cCenTrab := ""
	Local nVarDia  := 0
	Local nContAcu := 0
	Local nViradas  := 0

	Local cGERAPREV := AllTrim(GETMv("MV_NGGERPR"))
	Local oSTP := Nil
	//Local lRet
	//Local TIPOACOM := .F.

	Private cSerie := ''

	// Buscar página web
	cHtmlPage := Httpget('https://api.brggeradores.com.br/api/v2/public/integracao/horimetros')
	ConOut("WebPage", cHtmlPage) //retorna uma string com os dados encontrados

	If !Empty(cHtmlPage) //verifica se o link retorna alguma informação

		aHorim := strtokarr(cHtmlPage, ",") //transforma os dados da string em um array

		For nX := 1 To Len(aHorim) //Percorre o array

			cDados := Alltrim(aHorim[nX]) //Posiciona no registro

			// Remover aspas extras e caracteres esperiais
			cDados := StrTran(cDados, '"', '')
			cDados := StrTran(cDados, "{", "")

			// Localizar a posição dos dois pontos
			nPos := At(':', cDados)

			// Separar o lote e horímetro
			cLote := AllTrim(SubStr(cDados, 1, nPos - 1))  // Obtém Lote
			cHorim := AllTrim(SubStr(cDados, nPos + 1))     // Obtém Horímetro

			// Adicionar Lote e Horímetro ao novo array com posições separadas
			aAdd(aPares, {cLote, cHorim})

		Next nX

		For i := 1 To Len(aPares) // percorre array de lote e horímetro

			cSerie := aPares[i][1] //número do lote

			// Verifica se a área TMP1 está em uso e fecha-a, se necessário
			If Select("TMP1") > 0
				TMP1->(DbCloseArea())  // Fecha a área de trabalho se estiver aberta
			EndIf

			cQry := "SELECT ST9.T9_CODBEM,ST9.T9_DTULTAC,ST9.T9_CCUSTO,ST9.T9_CENTRAB,ST9.T9_VARDIA,ST9.T9_CONTACU,ST9.T9_VIRADAS,ST9.R_E_C_N_O_ AS RECNOST9 "
			cQry += "FROM " + retsqlname("ST9")+" ST9 "
			cQry += "WHERE ST9.T9_SERIE LIKE '"+cSerie+"' "
			cQry += "AND ST9.D_E_L_E_T_ <> '*' "
			cQry += "AND ST9.T9_SITBEM = 'A'" // Somente bem ativo
			cQry += "ORDER BY ST9.T9_CODBEM,ST9.T9_DTULTAC,ST9.T9_CCUSTO,ST9.T9_CENTRAB,ST9.T9_VARDIA,ST9.T9_CONTACU,ST9.T9_VIRADAS "

			cQry := ChangeQuery(cQry)
			TcQuery cQry New Alias "TMP1"

			//DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP1",.T.,.T.) //filtrando o bem

			//Count To nTotal

			//If nTotal = 1 //verifica se a query retorna algum registro
			If TMP1->(!EOF())

				ST9->(DbGoTo(TMP1->RECNOST9))

				cCodBem := TMP1->T9_CODBEM
				dDtUltLan := TMP1->T9_DTULTAC
				cCCusto := TMP1->T9_CCUSTO
				cCenTrab := TMP1->T9_CENTRAB
				nVarDia  := TMP1->T9_VARDIA
				nContAcu := TMP1->T9_CONTACU
				nViradas  := TMP1->T9_VIRADAS

				Reclock("STP",.T.) //faz a inclusão dos dados na tabela STP

				STP->TP_ORDEM    := u_zUltNum("STP", "TP_ORDEM", .T.)
				STP->TP_PLANO 	 := "000000" //validar
				STP->TP_CODBEM   := Alltrim(cCodBem)
				STP->TP_SEQUENC  := 0 //validar
				STP->TP_DTORIGI  := DATE() //validar
				STP->TP_POSCONT  := GetDToVal(aPares[i][2]) //Val()
				STP->TP_DTREAL   := DATE() //validar
				STP->TP_DTLEITU  := DATE() //validar
				STP->TP_SITUACA  := "L" //validar
				STP->TP_TERMINO  := "S" //validar
				STP->TP_USULEI   := Alltrim(UsrRetName(cUserID))
				STP->TP_DTULTAC  := cTod(dDtUltLan)
				STP->TP_COULTAC  := 0 //validar
				STP->TP_CCUSTO   := Alltrim(cCCusto)
				STP->TP_CENTRAB  := cCenTrab
				STP->TP_VARDIA   := nVarDia
				STP->TP_TEMCONT  := "S" //validar
				STP->TP_ACUMCON  := nContAcu
				STP->TP_VIRACON  := nViradas
				STP->TP_TIPOLAN  := "C" //validar
				STP->TP_HORA     := cHora
				STP->TP_ORIGEM   := cRotina

				STP->(MsUnlock()) 

				/*oSTP:= MNTCounter():New()
				oSTP:setOperation(3)

				TIPOACOM  := IIf(ST9->T9_TEMCONT = "S",.T.,.F.)

				If TIPOACOM .And. GetDToVal(aPares[i][2]) > 0
					oSTP:setValue("TP_CODBEM" ,Alltrim(cCodBem))
					oSTP:setValue("TP_POSCONT",GetDToVal(aPares[i][2]))
					oSTP:setValue("TP_DTLEITU",DATE())
					oSTP:setValue("TP_HORA"   ,cHora)
				EndIf

				STC->(DbSetOrder(1))
				If STC->(DbSeek(xFilial("STC")+cCodBem))
					lRet := oSTP:inform(STC->TC_COMPONE,0)
					If !lRet .And. !Empty(oSTP:getErrorList())
						cError := oSTP:getErrorList()[1]
						Alert(cError)
					EndIf	
				EndIf	*/		

				// GERAR O.S AUTOMATICA POR CONTADOR
				If (cGERAPREV = "S" .Or. cGERAPREV = "C") .And. (!Empty(GetDToVal(aPares[i][2])) /*.Or. !Empty(nCONT2V)*/)
					If NGCONFOSAUT(cGERAPREV)
						NGGEROSAUT(cCodBem, If(!Empty(GetDToVal(aPares[i][2])), GetDToVal(aPares[i][2]), 0/*nCONT2V*/),xFilial("STJ"))
					EndIf
				EndIf
			Else
				ConOut("Bem ativo não encontrado.")
			Endif

			nTotal := 0 //zera a variável

		Next i

	Else //caso o link não retorne dados, emite um alerta em tela

		FwAlertInfo("O link não possui informações","Atenção!!!")

	EndIf

	TMP1->(DbCloseArea())

	FreeObj(oSTP)
Return

/*/{Protheus.doc} zUltNum
Função que retorna o ultimo registro de um campo na tabela especificada
@type function
@author Maria Luiza
@since 10/10/2024
@version 1.0
    @param cTab, Caracter, Tabela que será consultada
    @param cCampo, Caracter, Campo utilizado de código
    @param [lSoma1], Lógico, Define se além de trazer o último, já irá somar 1 no valor
/*/

User Function zUltNum(cTab, cCampo, lSoma1)

	Local aArea       := GetArea()
	Local cCodFull    := ""
	Local cCodAux     := ""
	Local cQuery      := ""
	Local nTamCampo   := 0
	Default lSoma1    := .T.

	//Definindo o código atual
	nTamCampo := TamSX3(cCampo)[01]
	cCodAux   := StrTran(cCodAux, ' ', '0')

	//Faço a consulta para pegar as informações
	cQuery := " SELECT "
	cQuery += "   ISNULL(MAX("+cCampo+"), '"+cCodAux+"') AS MAXIMO "
	cQuery += " FROM "
	cQuery += "   "+RetSQLName(cTab)+" TAB "
	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery New Alias "QRY_TAB"

	//Se não tiver em branco
	If !Empty(QRY_TAB->MAXIMO)
		cCodAux := QRY_TAB->MAXIMO
	EndIf

	//Se for para atualizar, soma 1 na variável
	If lSoma1
		cCodAux := Soma1(cCodAux)
	EndIf

	//Definindo o código de retorno
	cCodFull := cCodAux

	QRY_TAB->(DbCloseArea())

	RestArea(aArea)
	
Return cCodFull


