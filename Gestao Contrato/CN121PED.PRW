#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'PROTHEUS.CH'
#DEFINE	CR	Chr(13)+Chr(10)

/*/-------------------------------------------------------------------
- Programa: CN121PED
- Autor: Adriano Costa
- Data: 27/01/2022
- Descrição: Grava informações no pedido de vendas,titulo e pedido de compras
-------------------------------------------------------------------/*/
User Function CN121PED()

	Local nPosAux
	Local aCab 			:= PARAMIXB[1]
	Local aItens 		:= PARAMIXB[2]
	Local cOBSM 
	Local cForma
	Local cVenc
	Local aArea			:= GetArea()
	Local aAreaCNE		:= CNE->(GetArea())
	Local aAreaCNF		:= CNF->(GetArea())
	Local cQry			:= ""
	Local cAliasTmp 	:= GetNextAlias()
	Local cCCusto
	Local oModel        := FWModelActive()
	Local oModelCND		:= oModel:GetModel("CNDMASTER")
	Local cContra		:= oModelCND:GetValue("CND_CONTRA")
	Local cRevisa		:= oModelCND:GetValue("CND_REVISA")
	Local cNummed		:= oModelCND:GetValue("CND_NUMMED")
	Local cChvCNE 		:= cContra + cRevisa
	Local cCodEmp 		:= FWCodEmp()
	
	Local cEmp3T        := SuperGetMv("MV_XEMP3T",.F.,"030101")
	Local nI
	Local cPlaca		:= ""
	Local cSerie		:= ""

// Pegar numero da planilha para chave da CNE
	if !empty(aCab) .AND. SubStr(aCab[1][1],1,2)=="E1"
		nPosAux := aScan(aCab, {|x| x[1] == "E1_MDPLANI"})
		cChvCNE += aCab[nPosAux][2]
	elseif !empty(aCab) .AND. SubStr(aCab[1][1],1,2)=="E2"
		nPosAux := aScan(aCab, {|x| x[1] == "E2_MDPLANI"})
		cChvCNE += aCab[nPosAux][2]
	elseif !empty(aCab) .AND. SubStr(aCab[1][1],1,2)=="C5"
		nPosAux := aScan(aCab, {|x| x[1] == "C5_MDPLANI"})
		cChvCNE += aCab[nPosAux][2]
	elseif !empty(aCab) .AND. SubStr(aCab[1][1],1,2)=="C7"
		nPosAux := aScan(aItens[1], {|x| x[1] == "C7_PLANILH"})
		cChvCNE += aItens[1][nPosAux][2]
	endif


//Buscar centro de custo
	cCCusto := Posicione("CNE",1,xFilial("CNE")+ cChvCNE + cNummed,"CNE_CC")

	//Buscar forma de pagamento
	//cForma := Posicione("CN9",1,xFilial("CN9")+ cChvCNE ,"CN9_XFORPG")
	cForma := "BOL"

// Buscar competencia e vencimento do mes 
	cQry := "SELECT CNF_FILIAL, CNF_COMPET, CNF_DTVENC "
	cQry +=  " FROM " + RetSqlName("CNF") + " CNF "
	cQry +=  " WHERE "
	cQry +=  " CNF.CNF_FILIAL = '" + CND->CND_FILIAL + "' "
	cQry +=  " AND CNF.CNF_CONTRA = '" + CND->CND_CONTRA + "' "
	cQry +=  " AND CNF.CNF_REVISA = '" + CND->CND_REVISA + "' "
	cQry +=  " AND CNF.CNF_COMPET = '" + CND->CND_COMPET + "' "
	cQry +=  " AND CNF.D_E_L_E_T_ = '' "
	cQry +=  " ORDER BY CNF_FILIAL, CNF_COMPET, CNF_DTVENC "

	cQry := ChangeQuery(cQry)

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), cAliasTmp, .F., .T. )

	
	cOBSM	:= CND->CND_OBS
	
//tratamento para pedido de pedido
	if !empty(aCab) .AND. SubStr(aCab[1][1],1,2)=="C5"

		cOBSM	:= "SERVICO DE MANUTENCAO EM GRUPO GERADOR REALIZADO EM XX/20XX - CONTRATO N XXXX/20XX"

		if !empty(cOBSM)
			nPosAux := aScan(aCab, {|x| x[1] == 'C5_MENNOTA' })
			if nPosAux == 0
				aadd(aCab, {'C5_MENNOTA', cOBSM, Nil} )
			else
				aCab[nPosAux][2] := cOBSM
			endif
		endif
	endif

	//tratamento para pedido de pedido
	if !empty(aCab) .AND. SubStr(aCab[1][1],1,2)=="C5"

		if !empty(cForma)
			nPosAux := aScan(aCab, {|x| x[1] == 'C5_XFORPG' })
			if nPosAux == 0
				aadd(aCab, {'C5_XFORPG', cForma, Nil} )
			else
				aCab[nPosAux][2] := cForma
			endif
		endif
	endif

	
	//tratamento para contas a receber
	if !empty(aCab) .AND. SubStr(aCab[1][1],1,2)=="E1"

		if !empty(cCCusto)
			nPosAux := aScan(aCab, {|x| x[1] == 'E1_CCC' })
			if nPosAux == 0
				aadd(aCab, {'E1_CCC', cCCusto, Nil} )
			else
				aCab[nPosAux][2] := cCCusto
			endif
		endif
	endif

	if !empty(aCab) .AND. SubStr(aCab[1][1],1,2)=="E2"

		if !empty(cCCusto)
			nPosAux := aScan(aCab, {|x| x[1] == 'E2_CCD' })
			if nPosAux == 0
				aadd(aCab, {'E2_CCD', cCCusto, Nil} )
			else
				aCab[nPosAux][2] := cCCusto
			endif
		endif
	endif

	

	RestArea(aAreaCNF)
	RestArea(aAreaCNE)
	RestArea(aArea)

Return {aCab,aItens}
