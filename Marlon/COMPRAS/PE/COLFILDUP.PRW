#Include 'PRTOPDEF.ch'
#Include 'Protheus.ch'

/*/{Protheus.doc}
@author Maria Luiza
@since 11/08/2025
@version 1.1
@description O Ponto de Entrada COLFILDUP permite informar 
empresa e filial quando for encontrada duplicidade durante a importação
*/

User Function COLFILDUP()

Local cCGC:= PARAMIXB[1]
Local cIE := PARAMIXB[2]
Local aRet := {}
Local cCodEmpresa := Alltrim(SM0->M0_CODIGO)
Local cCodFilial := Alltrim(SM0->M0_CODFIL)
Local cAlerta := "" 

// Verifica se a empresa é válida
If cCodEmpresa <> '97' .AND. cCodEmpresa <> '98' .AND. cCodEmpresa <> '99'
    aRet := {cCodEmpresa,cCodFilial}
EndIf

Return aRet
