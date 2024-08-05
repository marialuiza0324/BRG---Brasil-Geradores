#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UPROXCOD º Autor ³ Wellington Gonçalves º Data ³25/04/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para geração de códigos sequenciais				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³ 1 - Tabela												  º±±
±±		     ³ 2 - Nome do campo										  º±±
±±		     ³ 3 - Prefixo do código (Não obrigatório)					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Santa Marta	                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

User Function UPROXCOD()

Local aArea			:= GetArea()
Local cQry			:= ""
Local cCodRet		:= ""
//Local nTamCpo	  	:= 9 Original
Local nTamCpo	  	:= 9
//Local nTamCpo	  	:= TamSx3(cCampo)[1] -> Quando precisar usar total de digitos do campo
Local cTabela		:= "SB1"
Local cCampo		:= "B1_COD"
Local cPrefixo		:= M->B1_GRUPO //Original
//Local cPrefixof		:= M->B1_XFAMILI //Jácion adicionado Ferrobraz
//Local cPrefixot		:= M->B1_XTPMAT//Jácion Adicionado ferrobraz
Local cfullprefixo	:= cPrefixo
//Local cPrefixo		:= M->B1_TIPO
Local aAreaTabela	:= (cTabela)->(GetArea())
Local nTamPrefixo	:= Len(AllTrim(cPrefixo))
//Local nTamPrefof	:= Len(AllTrim(cPrefixof))//jacion
//Local nTamPrefixot	:= Len(AllTrim(cPrefixot))//jacion
Local nTamfullprfx	:= nTamPrefixo

// apenas na inclusao do produto
if Inclui

	/*Conout(">> Geração de numeração Sequencial")
	Conout(" - Tabela: " + cTabela)
	Conout(" - Campo: " + cCampo)
	Conout(" - Prefixo: " + cPrefixo)
	Conout(" - Prefixo: " + cPrefixof)//Jácion
	Conout(" - Prefixo: " + cPrefixot)//Jácion*/ 

	//Alert("teste")

	cQry := " SELECT "
	cQry += " MAX( SUBSTRING(" + cCampo + "," + cValToChar(nTamfullprfx + 1) + "," + cValToChar(nTamCpo - nTamfullprfx) + ")) PROX "
	cQry += " FROM "
	cQry += " " + RetSqlName(cTabela)
	cQry += " WHERE "
	cQry += " D_E_L_E_T_ <> '*' "
	cQry += " AND SUBSTRING(" + cCampo + ",1," + cValToChar(nTamfullprfx) + ") = '" + cfullprefixo + "' "
		// preenche filial do alias
	If Left(cTabela,1) <> "S"
		cQry += " AND " + cTabela + "_FILIAL = '" + xFilial(cTabela) + "' "
	Else
		cQry += " AND " + Right(cTabela,2) + "_FILIAL = '" + xFilial(cTabela) + "' "
	Endif

	If Select("QRYCAD") > 0
		QRYCAD->(dbCloseArea())
	EndIf

	cQry := ChangeQuery(cQry)
	TcQuery cQry NEW Alias "QRYCAD"

	If QRYCAD->(!Eof())

		If Empty(QRYCAD->PROX)
			cCodRet := cfullprefixo + StrZero(1,nTamCpo - nTamfullprfx)
		Else

			Conout(" - Ultimo codigo cadastrado: " + cfullprefixo + QRYCAD->PROX)
			// Completo com zeros a esquerda
			cCodRet := PADL(Soma1(AllTrim(QRYCAD->PROX)),nTamCpo - nTamfullprfx,"0")
			// Libero todos os codigos reservados
			FreeUsedCode()

			// Verifico se este codigo já está sendo utilizado por outro usuário
			While !MayIUseCode( cTabela + xFilial(cTabela) + cfullprefixo + cCodRet )
				Conout(" - Codigo ja reservado: " + cfullprefixo + cCodRet)
				cCodRet := Soma1(cCodRet)
			EndDo
			
			cCodRet := cfullprefixo + cCodRet
			
		EndIf

	Else
		cCodRet := cfullprefixo + StrZero(1,nTamCpo - nTamfullprfx)
	EndIf

	Conout(" - Proximo codigo: " + cCodRet)

	M->B1_COD := cCodRet

	If Select("QRYCAD") > 0
		QRYCAD->(DbCloseArea())
	EndIf

endif

RestArea(aAreaTabela)
RestArea(aArea)

Return(.T.)
