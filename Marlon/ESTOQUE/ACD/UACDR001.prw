#Include 'Protheus.ch'
#include "totvs.ch"
#include "tbiconn.ch"
#include "FWMVCDEF.CH"
#Include 'FWEditPanel.CH'
#include "topconn.ch"

/*/{Protheus.doc} UACDR001
Etiqueta de produto pré-lota de entrada

@type user function
@author user
@since 23/10/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function UACDR001(cLote,dValid,cSLote) 
Local cMainpath as Character 

	
	cMainpath := "\etiquetas\"+Alltrim(SuperGetMv('MV_XARQPRN',," "))+".prn"

	if !File(cMainpath)
		MsgAlert("Arquivo texto: "+cMainpath+" nao localizado")
		Return
	endif
	nHandle := FT_FUse(cMainpath)

    if nHandle = -1
		MsgStop("Arquivo etiqueta invalido!","Erro")
		return
	endif
    
    FT_FGoTop()
	_cETIQ 	:= ""

    While !FT_FEOF()
		_cETIQ 	+= FT_FReadLn()+CHR(10)
		FT_FSKIP()
	EndDo
	
	FT_FUSE()

    _cEtiqImp:=_cETIQ
    
    _cEtiqImp := StrTran(_cEtiqImp,"cCodigo"		,Alltrim(SB1->B1_COD))
    _cEtiqImp := StrTran(_cEtiqImp,"cCodBarras"		,Alltrim(SB1->B1_COD))
    _cEtiqImp := StrTran(_cEtiqImp,"cDescricao"		,Alltrim(SubStr(SB1->B1_DESC,1,80)))
	
	//Busca unidade de medidas do cadastro de produtos
    cUnd := POSICIONE("SB1",1,XFILIAL("SB1")+SB1->B1_COD,'B1_UM')
    _cEtiqImp := StrTran(_cEtiqImp,"cUnd"	,Alltrim(cUnd))
        
Return _cEtiqImp
