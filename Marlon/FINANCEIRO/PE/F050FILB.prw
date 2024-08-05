#Include 'Protheus.ch'

User Function F050FILB()
Local cFiltro := " "
Local cUserId   := RetCodUsr() //Retorna o Usuário Logado

    IF (cUserId $ "000006/000074")
        cFiltro := "E2_PREFIXO = 'PRV'"        
    ENDIF    

Return cFiltro

