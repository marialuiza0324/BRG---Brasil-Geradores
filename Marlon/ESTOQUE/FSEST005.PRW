#Include "PROTHEUS.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} FSEST005
Função que monta uma tela
de filtro, utilizado na tabela SB2
@author  Maria Luiza
@since 01/10/2025
/*/
//--------------------------------------------------------------
User Function FSEST005()

	Local oButton1
	Local oButton2
	Local oSay1
	Local oSay2
    
	Static oDlg
	Static cGet1 := Space(4)
	Static cGet2 := Space(2)
    Static oGet1
	Static oGet2

	DEFINE MSDIALOG oDlg TITLE "Filtra Saldos na SB2" FROM 000, 000  TO 250, 450 COLORS 0, 16777215 PIXEL

	@ 019, 039 SAY oSay1 PROMPT "Filial :" SIZE 021, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 054, 038 SAY oSay2 PROMPT "Armazém :" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 019, 090 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 F3 "XM0" PIXEL 
	@ 054, 089 MSGET oGet2 VAR cGet2 SIZE 060, 010 OF oDlg COLORS 0, 16777215 F3 "NNR" PIXEL
	@ 098, 171 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oDlg ACTION PopulaSDA() PIXEL
	@ 098, 017 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION (oDlg:End()) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

Return

//--------------------------------------------------------------
/*/{Protheus.doc} PopulaSDA
Função que filtra os saldos na SB2
e Popula a tabela SDA para endereçamento
@author  Maria Luiza
@since 01/10/2025
/*/
//--------------------------------------------------------------
Static Function PopulaSDA()

    Local cQuery := ""

    If Select("TSB2") > 0
        TSB2->(dbCloseArea())
    EndIf

    cQuery := "SELECT SB2.B2_FILIAL, SB2.B2_COD, SB2.B2_LOCAL, SB2.B2_QATU, SB2.B2_LOCAL, "
    cQuery += "(SB2.B2_QATU - SB2.B2_RESERVA - SB2.B2_QTNP - SB2.B2_QNPT) AS Saldo_Disponivel "
    cQuery += "FROM SB2010 AS SB2 "
    cQuery += "INNER JOIN SB1010 AS SB1 ON SB1.B1_FILIAL = SUBSTRING(SB2.B2_FILIAL,3,4) "
    cQuery += "AND SB1.D_E_L_E_T_ <> '*' "
    cQuery += "AND SB1.B1_COD = SB2.B2_COD "
    cQuery += "WHERE SB2.B2_LOCAL = '" + cGet2 + "' "
    cQuery += "AND SB2.B2_FILIAL = '" + cGet1 + "' "
    cQuery += "AND (SB2.B2_QATU - SB2.B2_RESERVA - SB2.B2_QTNP - SB2.B2_QNPT) > 0 "
    cQuery += "AND SB2.D_E_L_E_T_ <> '*' "
    cQuery += "AND SB1.B1_MSBLQL = '2' "
    cQuery += "AND SB1.B1_LOCALIZ = 'S' "

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TSB2",.T.,.T.)

    TSB2->(DbGoTop())
	
    While !TSB2->(Eof())

        RecLock("SDA",.T.)
        SDA->DA_FILIAL  := TSB2->B2_FILIAL
        SDA->DA_PRODUTO := TSB2->B2_COD
        SDA->DA_LOCAL   := TSB2->B2_LOCAL
        SDA->DA_QTDORI  := TSB2->B2_QATU
        SDA->DA_SALDO   := TSB2->B2_QATU
        SDA->DA_QTSEGUM := 0
        SDA->DA_QTDORI2 := 0
        SDA->DA_NUMSEQ  := GetSxeNum("SDA","DA_NUMSEQ")
        SDA->(MsUnlock())

        TSB2->(DbSkip())
    EndDo

    TSB2->(DbCloseArea())

    FWAlertSuccess("Saldos Populados com Sucesso!")

    oDlg:End()

Return

