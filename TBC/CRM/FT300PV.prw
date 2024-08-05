#Include "Protheus.ch"

/*/-------------------------------------------------------------------
- Programa: FT300PV
- Autor:
- Data: 03/11/2020
- Descrição: A finalidade deste ponto de entrada é permitir a inclusão 
de campos nas tabelas SC5 - Cabeçalho e SC6 - Item no momento da 
gravação do pedido de vendas.
-------------------------------------------------------------------/*/

User Function FT300PV()
	Local aArea 	:= GetArea()
	Local aCabec 	:= {}
	Local aItem 	:= {}
	Local aLinha 	:= {}

	//Necessário retornar um array com 2 posições, sendo:
	//aRet[1] = Campos do cabeçalho do pedido de vendas (SC5)
	//aRet[2] = Campos dos itens do pedido de vendas (SC6)
	Local aRet := {}

	
    Aadd( aCabec,{"C5_XFORPG"	,AD1->AD1_XFORPG	,Nil} )
    Aadd( aCabec,{"C5_XPEDCOM"	,AD1->AD1_XPEDCO	,Nil} )
	Aadd( aCabec,{"C5_XCONTRA"	,AD1->AD1_XCONTR	,Nil} )
	
//Alert("Carregou cab.")


	

	If ADZ->(DbSeek(xFilial("ADZ")+SCJ->CJ_PROPOST))	//ADZ_FILIAL+ADZ_PROPOS+ADZ_ITEM

		
		If SCK->(DbSeek(xFilial("SCK")+SCJ->CJ_NUM))

			//Alert("Entrou no if sck")

			While ( SCK->(!Eof()) .And. xFilial("SCK")==SCK->CK_FILIAL .And. SCK->CK_NUM == SCJ->CJ_NUM)

				aLinha := {}
				
				Aadd( aLinha,{"C6_ENTREG"	,ADZ->ADZ_XDTENT	,Nil} ) 
				Aadd( aLinha,{"C6_LOCAL"	,ADZ->ADZ_XLOCAL    ,Nil} ) 

				aadd(aItem,aLinha)

				SCK->(DbSkip())
			End

		
		EndIf

	endif
 

	aadd(aRet,aCabec)
	aadd(aRet,aItem)
	
	RestArea(aArea)

Return(aRet)
