#Include "TOTVS.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} MT185FIL  
Ponto de entrada utilizado para adicionar 
Filtro no Menu da mBrowse das solicitações ao armazém (SCP)
@type  Function
@author Seu Nome
@since 12/02/2025 
*/
User Function MT185FIL()

    Local cQuery    := ""        // Variável para armazenar a Query SQL
    Local aOpValidas := {}       // Array para armazenar as OPs firmadas
    Local cFiltroSCP := ""       // String para armazenar o filtro final
    Local cListaOps := ""        // Variável para armazenar a lista formatada das OPs válidas
    
    // Monta a consulta SQL para buscar OPs firmadas
    cQuery := "SELECT C2_NUM, C2_ITEM, C2_SEQUEN FROM " + RetSqlName("SC2") + " " + ;
              "WHERE C2_TPOP = 'F' AND D_E_L_E_T_ = ' '"

    // Executa a query e armazena os dados na TMP_SC2
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMP_SC2", .F., .F.)

    // Preenche o array com as OPs válidas
    DbSelectArea("TMP_SC2")
    TMP_SC2->(DbGoTop())
    While !TMP_SC2->(EOF())
        AAdd(aOpValidas, "'" + AllTrim(TMP_SC2->C2_NUM) + AllTrim(TMP_SC2->C2_ITEM) + AllTrim(TMP_SC2->C2_SEQUEN) + "'")
        TMP_SC2->(DbSkip())
    EndDo
    TMP_SC2->(DbCloseArea())

    // Transforma o array em string formatada corretamente
    If Len(aOpValidas) > 0
        cListaOps := ArrTokStr(aOpValidas, ",")
        cFiltroSCP := "CP_LOCAL <> '01' .And. aScan({" + cListaOps + "}, CP_OP) > 0"
    Else
        cFiltroSCP := "CP_LOCAL <> '01'"
    EndIf

    // Aplica o filtro na tabela SCP010
    DbSelectArea("SCP")
    SCP->(DbSetFilter({|| &(cFiltroSCP)}, cFiltroSCP))


Return (cFiltroSCP)
