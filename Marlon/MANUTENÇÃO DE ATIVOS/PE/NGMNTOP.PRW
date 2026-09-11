#include 'protheus.ch'
#include 'parmtype.ch'
 
User Function NGMNTOP()
 
    Local aFields := aClone(Paramixb)
    Local nPos 
 
    // Alterando o valor de um campo já existente no array passado para o execauto de geração de OP
    If ( nPos := aScan(aFields, {|x| x[1] == 'C2_TPOP' }) ) > 0
        aFields[nPos][2] := 'F'
    else
        Aadd(aFields, {"C2_TPOP", "F", NIL})
    EndIf

Return aFields
