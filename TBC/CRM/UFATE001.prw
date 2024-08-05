#Include "Protheus.ch"

/*/-------------------------------------------------------------------
- Programa: UFATE001
- Autor:
- Data: 03/11/2020
- Descrição: Retorna a tes, conforme preenchimento do campo customizado:
ADZ_XOPER-> referente ao tipo de operação. O programa sera chamado via
gatilho na SC7, través da rotina FATA600.
-------------------------------------------------------------------/*/

User Function UFATE001()

	Local aArea     	:= GetArea()
    Local aAreaAD1 		:= AD1->(GetArea())
    Local oModel		:= FWModelActive()
    Local oMdlAADY  	:= oModel:GetModel("ADYMASTER")
    Local oMdlAADZ      := oModel:GetModel("ADZPRODUTO")
	Local nLinha  		:= oMdlAADZ:nLine   
	Local oStructADZ1   := oMdlAADZ:GetStruct()
    Local aCamposADZ    := oStructADZ1:GetFields()
    Local nPosProd    	:= aScan(aCamposADZ,{|x| AllTrim(x[3])=="ADZ_PRODUT"})	//Posicao do campo ADZ_PRODUT
    Local aColsx 		:= oMdlAADZ:aCols
    Local cNumOpt   	:= oMdlAADY:GetValue('ADY_OPORTU')
    Local cNumPre   	:= oMdlAADY:GetValue('ADY_REVISA')
	Local cOper 		:= M->ADZ_XOPER
	Local cTes 			:= ""
	
    AD1->(DbSelectArea("AD1"))
	AD1->(DbSetOrder(1))
	AD1->(DbGotop())
	if AD1->(DbSeek(FWxFilial("AD1")+cNumOpt+cNumPre))
	
		cTes := MaTesInt(2, cOper, AD1->AD1_CODCLI, AD1->AD1_LOJCLI, "C", aColsx[nLinha][nPosProd], Nil ,Posicione("SA1",1,FWxFilial("SA1")+AD1->AD1_CODCLI+AD1->AD1_LOJCLI,"A1_TIPO"))
		
	endif	
	
	RestArea(aAreaAD1)
	RestArea(aArea)

Return(cTes)
