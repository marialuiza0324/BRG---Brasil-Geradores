//Bibliotecas
#Include "TOTVS.ch"
 
/*/{Protheus.doc} User Function zVid0126
Demonstração em como abrir um site pelo navegador
@type  Function
@author Atilio
@since 22/02/2024
/*/
 
User Function RelOs()

    Local aArea := FWGetArea()

    Local cURL  := "http://geradores.datasetsolucoes.com.br:7061//"+STJ->TJ_ORDEM+"?filial="+cFilAnt"
 

        //Abre o link pelo navegador
        ShellExecute("Open", cURL, "", "", 1)
    FWRestArea(aArea)
Return
