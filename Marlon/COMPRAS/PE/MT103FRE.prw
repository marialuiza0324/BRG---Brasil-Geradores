// BIBLIOTECAS NECESS�RIAS
#Include "TOTVS.ch"

// FUN��O PRINCIPAL
User Function MT103FRE()

    Local aParam   := PARAMIXB  // RATEIO DE FRETE
    Local aAreaTOT := GetArea() // TABELA POSICIONADA NO MOMENTO
    Local aAreaSB1 := {}        // POSICIONAMENTO DA TABELA A SER MANIPULADA
    Local nPosDesc := 0         // ARMAZENA A POSI��O DO CAMPO CUSTOMIZADO D1_XPDDESC (DESTINO)
    Local nPosProd := 0         // ARMAZENA A POSI��O DO CAMPO PADR�O D1_COD (ORIGEM)
    Local nX       := 0         // CONTROLADOR DO LA�O DE REPETI��O

    // ARMAZENA O ESTADO DA �REA CORRENTE DA TABELA SB1
    DbSelectArea("SB1")
    aAreaSB1 := SB1->(GetArea())

    // ARMAZENA AS POSI��ES DOS CAMPOS D1_COD E D1_XPDDESC COM BASE NA AHEADER
    nPosDesc := AScan(aHeader, {|x| AllTrim(x[2]) == "D1_XDESCPR"})
    nPosProd := AScan(aHeader, {|x| AllTrim(x[2]) == "D1_COD"})

    // LA�O DE REPETI��O PREENCHENDO O CAMPO CUSTOMIZADO COM O CONTE�DO DO POSICIONE EM B1_DESC
     For nX :=1 To Len(aCols)
        aCols[nX][nPosDesc] := Posicione("SB1", 1, FwXFilial("SB1") + aCols[nX][nPosProd], "B1_DESC")
    Next nX

    // RESTAURA��O DA �REA DE SB1 E DA �REA ANTERIOR
    RestArea(aAreaSB1)
    RestArea(aAreaTOT)

Return (aParam)
