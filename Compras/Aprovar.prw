#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/* MT121BRW
Coloca Rotina de Aprovar Pedido de Compra
@author 3RL
@since 21/10/2021
@version 1.0
*/
User Function Aprovar()

	Local oButton1
	Local oButton2
	Local oGet1
	Local cGet1 := space(6)
	Local oGet2
	Local cGet2 := space(40)
	Local oGet3
	Local nGet3 := 0
	Local oGet6
	Local cGet6 := space(6)
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
//Local oSay5
	Local oSay6
//Local oSay7
//Local oSay8
	Local oSay9
	Local oGet4
	Local cGet4 := UsrRetName(RetCodUsr())//UsrRetName(SC7->C7_APROV)
	Local cUserApr := SuperGetMV("MV_USERAPR", ," ")
	Local oMultiGe1
	Local cMultiGe1 := " "
	Local xSMaster   := SuperGetMV("MV_XSHMAS", ," ") // Parametro contendo senha master
	Private  _Total := 0
	Private _Num   := SC7->C7_NUM
	Private _Solic := SC7->C7_NUMSC
	//Private _User := If(EMPTY(SC7->C7_APROV),RetCodUsr(),SC7->C7_APROV)
	Private _User := RetCodUsr()
	Static oDlg

	dbSelectArea("SAK")
	dbSetOrder(2)
	If !DbSeek(xFilial("SAK")+_User)
		MsgInfo("Usuário não Autorizado para Aprovar !!","Atenção ")
		Return
	Else
		DbSelectArea("SAI")
		DbSetOrder(5) //fOI cRIADO INDICE NOVO AI_FILIAL+AI_XAPROV - ### VERIFICAR SE FOI CRIADO NA BASE OFICIAL """"
		If DbSeek(xFilial("SAI")+_User)
			Do While ! EOF() .AND. SAI->AI_XAPROV == _User .AND. SAI->AI_FILIAL = xFilial("SAI")
				If _User $ xSMaster //Parametro da SEnha master, colocando a senha da Paula MV_XSHMAS  cLEITO
					lRet := .T.
				ElseIf SAI->AI_XAPROV = _User
					lRet := .T.
				EndIF
				SAI->(dbSkip())
			EndDo
			If !lRet
				FWAlertError("Grupo não permitido para Aprovação !!! ", "Alerta - Erro")
				Return
			EndIf
		Else
			FWAlertError("Aprovador sem regra de aprovação !!! ", "Alerta - Erro")
			Return
		EndIf
	EndIF

//Retorna a Observação cadastrada na Solicitação - Inicio

	If Select("TMP4") > 0
		TMP4->(dbCloseArea())
	EndIf
//SELECT ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C1_XOBMEMO)),'') AS OBSSC1 FROM SC1010 SC1

	_cQry := " "
	_cQry += "SELECT ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C1_XOBMEMO)),'') AS OBSSC1  "
	_cQry += "FROM " + retsqlname("SC1")+" SC1 "
	_cQry += "WHERE SC1.D_E_L_E_T_ <> '*' "
	_cQry += "AND C1_FILIAL = '" + cFilAnt + "'
	_cQry += "AND C1_NUM = '" + _Solic + "'

	_cQry := ChangeQuery(_cQry)
	TcQuery _cQry New Alias "TMP4"

	Do While !TMP4->(EOF())
		IF !AllTrim(SC7->C7_OBSM) $ cMultiGe1
			cMultiGe1 += alltrim(TMP4->OBSSC1)+"/"
		EndIf
		TMP4->(DBSKIP())
	EndDo

//Retorna a Observação cadastrada na Solicitação - Fim

	cGet6 := _Solic
	cGet1 := _Num
	cGet2 := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

	dbSelectArea("SC7")
	SC7->(DbGoTop())
	SC7->(dbSeek(xFilial("SC7")+_Num) )
	Do While !EOF() .AND. C7_FILIAL == xFilial("SC7") .AND. C7_NUM == _Num
		_Total := _Total + (SC7->C7_TOTAL+SC7->C7_VALIPI + SC7->C7_ICMSRET - SC7->C7_VLDESC)
		IF !EMPTY(SC7->C7_OBSM) .AND. !AllTrim(SC7->C7_OBSM) $ cMultiGe1
			cMultiGe1 += SC7->C7_OBSM
		EndIF
		SC7->(DBSKIP())
	ENDDO

	nGet3 := Transform(_Total,"@E 999,999,999.99")

	DEFINE MSDIALOG oDlg TITLE "Aprovação de Pedido de Compra" FROM 000, 000  TO 350, 500 COLORS 0, 16777215 PIXEL

	@ 145, 050 BUTTON oButton1 PROMPT "Aprovar" SIZE 037, 012 OF oDlg Action Aprovar1() PIXEL
	@ 145, 100 BUTTON oButton1 PROMPT "Estornar" SIZE 037, 012 OF oDlg Action Estornar() PIXEL
	@ 145, 150 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg Action oDlg:End() PIXEL
	@ 145, 200 BUTTON oButton2 PROMPT "Reprovar" SIZE 037, 012 OF oDlg Action Reprovar() PIXEL
	@ 022, 010 SAY oSay1 PROMPT "Ped. Compra:" SIZE 044, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 021, 045 MSGET oGet1 VAR cGet1 SIZE 030, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	@ 042, 010 SAY oSay2 PROMPT "Fornecedor:" SIZE 031, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 041, 045 MSGET oGet2 VAR cGet2 SIZE 164, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	@ 022, 080 SAY oSay3 PROMPT "Valor Total:" SIZE 033, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 021, 110 MSGET oGet3 VAR nGet3 SIZE 045, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	@ 022, 160 SAY oSay9 PROMPT "Solicitacao:" SIZE 033, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 021, 190 MSGET oGet6 VAR cGet6 SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	@ 060, 010 SAY oSay4 PROMPT "Aprovador" SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL
//@ 070, 010 SAY oSay7 PROMPT " Master  " SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 063, 045 MSGET oGet4 VAR cGet4 SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
//@ 060, 130 SAY oSay5 PROMPT "Aprovador" SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL
//@ 070, 130 SAY oSay8 PROMPT " Primário" SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL
//@ 064, 164 MSGET oGet5 VAR cGet5 SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	@ 085, 011 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 211, 033 COLORS 0, 16777215 READONLY HSCROLL PIXEL
//@ 120, 014 SAY oSay6 PROMPT "Obs. Valor dos impostos não inclusos." SIZE 219, 007 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

Return

//************************************************************

Static Function Aprovar1()

//Executa a validação de Valores - Inicio
/*
dbSelectArea("SAK")
dbSetOrder(2)
If DbSeek(xFilial("SAK")+_User)
   If SAK->AK_LIMITE > TotVlAp() + _Total 
    dbSelectArea("SC7")
	  dbSetOrder(1)
	  If DbSeek(xFilial("SC7")+_Num)
         If !Empty((SC7->C7_APROV)) .and.  SC7->C7_CONAPRO == "B"
            dbSelectArea("SAK")
            dbSetOrder(3)
            If DbSeek(xFilial("SAK")+_User)   //User Superior para aprovar pra quem excedeu o limite de aprovação
			   Do While !EOF() .AND. C7_FILIAL == xFilial("SC7") .AND. C7_NUM == _Num
		          RecLock("SC7", .F. )		          
		          SC7->C7_APROV2  := _User//Quando é necessário somente uma aprovação		   
		          SC7->C7_CONAPRO := "L"
		          MsUnLock()
		          SC7->(DBSKIP())
               ENDDO

*/

//Executa a validação de Valores - Fim 




// Valida os limite de valores a aprovar // 25/10/2022   - Inicio
	dbSelectArea("SAK")
	dbSetOrder(2)
	If DbSeek(xFilial("SAK")+_User)
		If SAK->AK_LIMITE < TotVlAp() + _Total   //o Aprovador passou do limite da sua alçada  ex. 20000,00 < 17000,00 + 5000,00 // Deixar sempre "<" menor
			dbSelectArea("SC7")
			dbSetOrder(1)
			If DbSeek(xFilial("SC7")+_Num)
				If !Empty((SC7->C7_APROV)) .and.  SC7->C7_CONAPRO == "B"
					_User :=  RetCodUsr()
					dbSelectArea("SAK")
					dbSetOrder(3)
					If DbSeek(xFilial("SAK")+_User)   //User Superior para aprovar pra quem excedeu o limite de aprovação
						U_BRG042() //Gerar a provisão na Aprovação do Pedido de Compra 08/02/2023 - Ricardo
						dbSelectArea("SC7")
						dbSetOrder(1)
						If DbSeek(xFilial("SC7")+_Num)
							Do While !EOF() .AND. SC7->C7_FILIAL == xFilial("SC7") .AND. SC7->C7_NUM == _Num
								RecLock("SC7", .F. )
								SC7->C7_APROV2  := _User//Quando é necessário somente uma aprovação
								SC7->C7_CONAPRO := "L"
								SC7->C7_DTAPROV := DDATABASE
								MsUnLock()
								SC7->(DBSKIP())
							ENDDO
						EndIf
						oDlg:End()
						FWAlertError("Pedido de Compra Aprovado com Aprovação Secundária !!! ", "Alerta")
					Else
						oDlg:End()
						FWAlertError("Usuário não é um Aprovador Secundário !!! ", "Alerta")
					EndIF
				Else
					Do While !EOF() .AND. SC7->C7_FILIAL == xFilial("SC7") .AND. SC7->C7_NUM == _Num
						RecLock("SC7", .F. )
						SC7->C7_APROV   := _User //Retorna o Codigo do Usuario
						SC7->C7_CONAPRO := "B"
						//SC7->C7_XXXXX := "LIMITE EXCEDIDO - AGUARDANDO APROVAÇÃO SUPERIOR" ---- IDEIA
						MsUnLock()
						SC7->(DBSKIP())
					ENDDO
					oDlg:End()
					FWAlertError("Limite de Aprovação Excedido, Aguardar Aprovação Superior !!! ", "Alerta - Erro")
				EndIF
				Return
			EndIF
		Else   //If SAK->AK_LIMITE >= TotVlAp() + _Total
			//Liberaçaõ quando esta dentro do Limite do Aprovador
			dbSelectArea("SC7")
			dbSetOrder(1)
			If DbSeek(xFilial("SC7")+_Num)
				U_BRG042() //Gerar a provisão na Aprovação do Pedido de Compra 08/02/2023 - Ricardo
				Do While !EOF() .AND. C7_FILIAL == xFilial("SC7") .AND. C7_NUM == _Num
					RecLock("SC7", .F. )
					SC7->C7_APROV   := _User //Retorna o Codigo do Usuario
					SC7->C7_APROV2  := "XXXXXX" //Quando é necessário somente uma aprovação
					SC7->C7_DTAPROV := DDATABASE
					SC7->C7_CONAPRO := "L"
					MsUnLock()
					SC7->(DBSKIP())
				ENDDO
				oDlg:End()
				MsgInfo("Pedido de Compra Liberado !!","Atenção - Pedido de Compra ")
				Return
			EndIF
		EndIf
	EndIf
// Valida os limite de valores a aprovar // 25/10/2022   - Fim 
Return

//Estornar
Static Function Estornar()
	Local _Cfor := ""
	Local _CLj := ""
//Criar Parametro de limite de Liberação do PEdido de Compra MV_LIMPCOM
 	dbSelectArea("SC7")
	dbSetOrder(1)
	DbSeek(xFilial("SC7")+_Num)
	_Cfor := SC7->C7_FORNECE
	_CLj := SC7->C7_LOJA

	IF !empty(SC7->C7_APROV)
		Do While !EOF() .AND. C7_FILIAL == xFilial("SC7") .AND. C7_NUM == _Num
			RecLock("SC7", .F. )
			SC7->C7_APROV   := " "
			SC7->C7_GERSE2  := " "
			SC7->C7_APROV2  := " "
			SC7->C7_CONAPRO := "B"
			SC7->C7_DTAPROV := CTOD("  / /  ")
			MsUnLock()
			SC7->(DBSKIP())
		ENDDO
		oDlg:End()
		MsgInfo("Pedido de Compra, Aprovação Estornada !!","Atenção - Pedido de Compra ")
	endif

	DbSelectArea("SE2")
	SE2->(DBSetOrder(1))
	SE2->(DbGoTop())
	If SE2->(dbSeek( xFilial("SC7")+"PRV"+_Num+"/1"))
		While !SE2->(Eof()) .and. xFilial("SC7")==SE2->E2_FILIAL .and. _Num == SUBSTR(SE2->E2_NUM,1,6) .and.  _Cfor == SE2->E2_FORNECE .and.  _CLj == SE2->E2_LOJA
			RecLock("SE2",.F.)
			SE2->( dbDelete() )
			msUnlock()
			SE2->( DbSkip() )
			//cont++
		EndDo
		SE2->(DbCloseArea())
	EndIf

	U_OBSREJC7() //Chama a tela para informar o pq da rejeição ou bloqueio 22/02/2023


Return

Static Function Reprovar() // Depois q reprova não tem volta... somente novo pedido 11/10/2022
	Local _Cfor := ""
	Local _CLj := ""

	dbSelectArea("SC7")
	dbSetOrder(1)
	If DbSeek(xFilial("SC7")+_Num)
		_Cfor := SC7->C7_FORNECE
		_CLj := SC7->C7_LOJA
		Do While !EOF() .AND. C7_FILIAL == xFilial("SC7") .AND. C7_NUM == _Num
			RecLock("SC7", .F. )
			SC7->C7_CONAPRO := "R"
			MsUnLock()
			SC7->(DBSKIP())
		ENDDO
		MsgInfo("Pedido de Compra Reprovado/Rejeitado !!","Atenção - Pedido de Compra ")
		oDlg:End()
	EndIf
//Deleta a provisão 22/02/2023

	DbSelectArea("SE2")
	SE2->(DBSetOrder(1))
	SE2->(DbGoTop())
	If SE2->(dbSeek( xFilial("SC7")+"PRV"+_Num+"/1"))
		While !SE2->(Eof()) .and. xFilial("SC7")==SE2->E2_FILIAL .and. _Num == SUBSTR(SE2->E2_NUM,1,6) .and.  _Cfor == SE2->E2_FORNECE .and.  _CLj == SE2->E2_LOJA
			RecLock("SE2",.F.)
			SE2->( dbDelete() )
			msUnlock()
			SE2->( DbSkip() )
			//cont++
		EndDo
		SE2->(DbCloseArea())
	EndIf

	U_OBSREJC7() //Chama a tela para informar o pq da rejeição ou bloqueio 22/02/2023

Return


///Query para retonar o valor aprovado no periodo do mês competente da aprovação // 25/10/20220


Static Function TotVlAp()
//Verifica se o arquivo TMP está em uso

	Local _Tot := ""
//Local cAprv := UsrRetName(RetCodUsr())//UsrRetName(SC7->C7_APROV)
	Local cAprv := If(EMPTY(SC7->C7_APROV),RetCodUsr(),SC7->C7_APROV)

	If Select("TTMM") > 0
		TTMM->(DbCloseArea())
	EndIf

	ccQry := " "
	ccQry += "SELECT C7_FILIAL, C7_APROV, ROUND(SUM(C7_TOTAL),2) VALOR_TOTAL "
	ccQry += "FROM " + retsqlname("SC7")+" SC7 "
	ccQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
	ccQry += "AND C7_FILIAL = '"+xFilial("SC7")+"' "
	ccQry += "AND C7_APROV = '"+cAprv+"' "
	ccQry += "AND YEAR(C7_DTAPROV) = '"+substr(dtos(ddatabase),1,4)+"' "
	ccQry += "AND MONTH(C7_DTAPROV) = '"+substr(dtos(ddatabase),5,2)+"' "
	ccQry += "AND C7_CONAPRO = 'L' "
	ccQry += "GROUP BY C7_FILIAL, C7_APROV "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TTMM",.T.,.T.)

	_Tot := TTMM->VALOR_TOTAL

Return _Tot
