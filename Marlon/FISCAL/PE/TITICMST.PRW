#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'


/*/{Protheus.doc} TITICMST
    Este Ponto de Entrada est� localizado 
    ap�s a grava��o das informa��es padr�es do 
    tributo para t�tulo a ser gerado no financeiro
    Deve ser utilizado para complementar ou alterar 
    os valores padr�es j� gravados no t�tulo, 
    gerado pelos programas MATA461 
    @type  Function
    @author Maria Luiza
    @since 16/09/2024
    /*/

User Function TITICMST()


    //Local cOrigem := PARAMIXB[1]
    //Local cTipoImp := PARAMIXB[2]
    Local lDifal := PARAMIXB[3]
    Local cNatureza := SuperGetMv("MV_NATDIFA", , )
  
    /*EXEMPLO 1 (cOrigem)
    If AllTrim(cOrigem)='MATA954' //Apuracao de ISS
        SE2->E2_NUM := SE2->(Soma1(E2_NUM,Len(E2_NUM)))
        SE2->E2_VENCTO := DataValida(dDataBase+30,.T.)
        SE2->E2_VENCREA := DataValida(dDataBase+30,.T.)
        SE2->E2_NATUREZ := 'EXEMPLO1'
    EndIf
  
    //EXEMPLO 2 (cTipoImp)
    If AllTrim(cTipoImp)='1' // ICMS ST
        SE2->E2_NUM := SE2->(Soma1(E2_NUM,Len(E2_NUM)))
        SE2->E2_VENCTO := DataValida(dDataBase+30,.T.)
        SE2->E2_VENCREA := DataValida(dDataBase+30,.T.)
        SE2->E2_NATUREZ := 'EXEMPLO2'
    EndIf*/
  
    //EXEMPLO 3 (lDifal)
    If lDifal // DIFAL
        SE2->E2_NUM := SE2->(Soma1(E2_NUM,Len(E2_NUM)))
        SE2->E2_VENCTO := DataValida(dDataBase,.T.)
        SE2->E2_VENCREA := DataValida(dDataBase,.T.)
        SE2->E2_NATUREZ := cNatureza
    EndIf
  
Return {SE2->E2_NUM,SE2->E2_VENCTO}
