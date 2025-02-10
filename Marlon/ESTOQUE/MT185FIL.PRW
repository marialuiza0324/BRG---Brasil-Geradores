// Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"

User Function MT185FIL()
    Local cFiltro  := ""
    Local cUsuario := AllTrim(GetUser())  // Obtém o usuário logado
    Local cUsuariosPermitidos := AllTrim(GetMV("MV_BOPF")) // Obtém a lista de usuários no parâmetro

    // Verifica se o usuário logado está na lista do MV_BOPF
    If ("|" + cUsuariosPermitidos + "|" $ "|" + cUsuario + "|")
        // Aplica o filtro relacionando SCP com SC2 para exibir apenas OPs firmes
        cFiltro := "EXISTS (SELECT 1 FROM " + RetSqlName("SC2") + " SC2 " + ;
                   "WHERE SC2.C2_FILIAL = SCP.C6_FILIAL AND SC2.C2_NUM = SCP.C6_NUM " + ;
                   "AND SC2.C2_STATUS = 'F')"
    EndIf
    
Return cFiltro
