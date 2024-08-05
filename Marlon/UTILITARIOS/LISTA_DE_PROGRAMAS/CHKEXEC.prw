#Include "PROTHEUS.CH"
#Include "PARMTYPE.CH"
#Include "FWMVCDEF.CH"
#Include "TOPCONN.CH"

/*
Uso das rotinas no sistema.
Configurações:
Criar os parametros

XX_TABACAU parametro com nome da tabela ser criada, conferir qual tabela SZ.(
(SZ1, SZ2, SZ3...) estão livre e inserir neste parametro.
XX_ATVACAU se ativa ou nÃ£o o log, deve estar ativado, .T.

*/

Static nTamRotina 	:= 254
Static __cAliasTmp  := SuperGetMv("XX_TABACAU",.F.,"ACCESSAUDIT")
Static NOMEROTINA   := OMAINWND:CTITLE

User Function CHKEXEC()
	
	if SuperGetMv("XX_ATVACAU",.F.,.T.)
		auditAccess(PARAMIXB)
	EndIf

Return  .T.

Static function auditAccess(cRotina)
	Local lIndex  := .F.
	Local lInsert := .T.	

	createTable(@lIndex)

	IF lIndex
		lInsert := !DbSeek(__cUserID+PadR(cRotina,nTamRotina)   )
	Else
		cQry := ' SELECT R_E_C_N_O_ AS RECNO FROM ' +__cAliasTmp
		cQry += " WHERE D_E_L_E_T_= ' ' "
		cQry += " AND USERID=  "+ValToSql(__cUserID)
		cQry += " AND ROTINA=  "+ValToSql(cRotina)
		nRecno  := MpSysExecScalar(cQry, 'RECNO')
		if nRecno > 0
			(__cAliasTmp)->(DbGoTo(nRecno))
			lInsert := .F.
		EndIf
	eNDif

	RecLock(__cAliasTmp,lInsert)

	if lInsert
		NOMEROTINA   := OMAINWND:CTITLE	
		ROTINA		:= cRotina
		USERID		:= __cUserID
		USERNAME	:= cUserName
		MODULO		:= nModulo
		NOMEMODULO	:= cModulo
		NACESSOS	:= 1
	Else
		NACESSOS	:= NACESSOS+1
	EndIf
	ULTDATA		:= Date()
	ULTHORA		:= Time()
	MsUnlock()

Return


Static Function createTable(lIndex)
	Local aOldaStruct as array
	Local nTopErr
	Local aStruct := {}

	aAdd( aStruct, { 'NOMEROTINA', 'C', 50 						, 0 } )
	aAdd( aStruct, { 'ROTINA' 	 , 'C', nTamRotina				, 0 } )
	aAdd( aStruct, { 'USERID' 	 , 'C', 06						, 0 } )
	aAdd( aStruct, { 'USERNAME'	 , 'C', 25						, 0 } )
	aAdd( aStruct, { 'MODULO'	 , 'N', 2						, 0 } )
	aAdd( aStruct, { 'NOMEMODULO', 'C', 25						, 0 } )
	aAdd( aStruct, { 'ULTDATA'	 , 'D', 8						, 0 } )
	aAdd( aStruct, { 'ULTHORA'	 , 'C', 8						, 0 } )
	aAdd( aStruct, { 'NACESSOS'	 , 'N', 20						, 0 } )

	IF !TCCanOpen(__cAliasTmp)
		FWDBCreate( __cAliasTmp, aStruct , 'TOPCONN' , .T.)
	EndIf

	if Select(__cAliasTmp) == 0
		DbUseArea(.T.,'TOPCONN',__cAliasTmp,__cAliasTmp,.T.,.F.)
	EndIf

	aOldaStruct := (__cAliasTmp)->(DbStruct())

	if Len(aOldaStruct) !=  Len(aStruct)
		(__cAliasTmp)->(DbCloseArea( ))

		bRet := TCAlter(__cAliasTmp,aOldaStruct,aStruct, @nTopErr)
		If !bRet
			MsgInfo(tcsqlerror(),"Erro no TCAlter!")
		Endif
	EndIf
	if Select(__cAliasTmp) == 0
		DbUseArea(.T.,'TOPCONN',__cAliasTmp,__cAliasTmp,.T.,.F.)
	EndIf

	//--------------------------------------------------------------------------------
	//Cria indice para Arquivo de Trabalho
	//--------------------------------------------------------------------------------
	If !TCCanOpen(__cAliasTmp,__cAliasTmp+"1")
		DBCreateIndex(__cAliasTmp+"1", "USERID + ROTINA"  )
		dbClearIndex()
		dbSetIndex(__cAliasTmp+"1")
		lIndex := .T.
	EndIf

	DbSelectArea(__cAliasTmp)

	FwfreeArray(aStruct)
	FwfreeArray(aOldaStruct)

Return
