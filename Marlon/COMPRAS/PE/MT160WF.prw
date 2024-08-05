#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

User Function MT160WF()

    /*
        cQuery := "UPDATE SC7010 SET SC7.C7_GRUPO = SC1.C1_GRPRD, SC7.C7_CODSOL = USR.USR_ID "
        cQuery += "FROM "+RetSQLName("SC7")+" AS SC7 "
        cQuery += "INNER JOIN "+RetSQLName("SC1")+" AS SC1 ON SC7.C7_FILIAL = SC1.C1_FILIAL "
        cQuery += "    AND SC7.C7_PRODUTO = SC1.C1_PRODUTO "
        cQuery += "    AND SC7.C7_NUMSC = SC1.C1_NUM "
        cQuery += "    AND SC7.C7_ITEMSC = SC1.C1_ITEM "
        cQuery += "    AND SC1.D_E_L_E_T_ <> '*' "
        cQuery += "INNER JOIN "+RetSQLName("SYS_USR")+" AS USR  ON SC1.C1_SOLICIT = USR.USR_CODIGO "
        cQuery += "    AND USR.D_E_L_E_T_ <> '*'
        cQuery += "WHERE SC7.C7_GRUPO = '' 
        cQuery += "    AND SC7.C7_CODSOL = ''
        cQuery += "    AND SC7.D_E_L_E_T_ <> '*'
        cQuery += "    AND SC7.C7_EMISSAO BETWEEN '20240101' AND '29990101'


        //Executa a instrução SQL de cQuery
        nRet := TCSQLExec(cQuery)
    
        If(nRet < 0 )
            MsgStop("Erro na execução da query:"+TcSqlError(), "Atenção")
        Else
            MsgAlert("O UPDATE da query "+cQuery+" foi executado com sucesso!")
        EndIf
    */
    Local lRet          := .F.
    Local nOpc          := 4
    Local cDoc          := ""
    Local aCabec        := {}
    Local aLinha        := {}
    Local aItens        := {}
    Local lMsErroAuto   := .F.
    Local _cQryC7       := ""
    Local _cQryC8       := ""
    //Local cQuery := ""


    DbSelectArea('SC8')
    SC8->(DbSetOrder(1)) // Filial + Código
    SC8->(dbSeek(FWxFilial("SC8")+SC8->C8_NUM))

    //Capturando dados SC8
    If Select("TSC8") > 0
        TSC8->(dbCloseArea())
    EndIf

    _cQryC8 := "SELECT * "
    _cQryC8 += " FROM " + retsqlname("SC8")+" SC8 "
    _cQryC8 += " WHERE SC8.D_E_L_E_T_ <> '*' "
    _cQryC8 += " AND SC8.C8_NUM = '"+SC8->C8_NUM+"'"

    _cQryC8 := ChangeQuery(_cQryC8)
    TcQuery _cQryC8 New Alias "TSC8"   


    //Capturando dados SC7    
    If Select("TSC7") > 0
        TSC7->(dbCloseArea())
    EndIf

    _cQryC7 := "SELECT * "
    _cQryC7 += " FROM " + retsqlname("SC7")+" SC7 "
    _cQryC7 += " WHERE SC7.D_E_L_E_T_ <> '*' "
    _cQryC7 += " AND SC7.C7_NUMCOT = '"+SC8->C8_NUM+"'"    

    _cQryC7 := ChangeQuery(_cQryC7)
    TcQuery _cQryC7 New Alias "TSC7"    

    SC8->(dbCloseArea())
    
    
    DO WHILE !TSC8->(Eof())

        DO WHILE !TSC7->(Eof())

            If RTRIM(TSC7->C7_NUM) == RTRIM(TSC8->C8_NUMPED) .AND. RTRIM(TSC7->C7_ITEM) == RTRIM(TSC8->C8_ITEMPED)

                    //RecLock('SC7', .F.)
                    
                    nOpc    := 4  
                    aCabec  := {}
                    aLinha  := {}
                    aItens  := {}

                    aadd(aCabec,{"C7_NUM" ,TSC7->C7_NUM})
                    aadd(aCabec,{"C7_EMISSAO" ,TSC7->C7_EMISSAO})
                    aadd(aCabec,{"C7_FORNECE" ,TSC7->C7_FORNECE})
                    aadd(aCabec,{"C7_LOJA" ,TSC7->C7_LOJA})
                    aadd(aCabec,{"C7_COND" ,TSC7->C7_COND}) // Condição de pagamento que permite adiantamento
                    aadd(aCabec,{"C7_CONTATO" ,TSC7->C7_CONTATO})
                    aadd(aCabec,{"C7_FILENT" ,TSC7->C7_FILENT})

                    // Alterar item existente
                    aadd(aLinha,{"C7_ITEM" ,TSC7->C7_ITEM ,Nil})
                    aadd(aLinha,{"C7_PRODUTO" ,TSC7->C7_PRODUTO,Nil})
                    aadd(aLinha,{"C7_CODSOL" ,Posicione("SC1",1,xFilial("SC1")+TSC7->C7_NUMSC+TSC7->C7_ITEMSC,"SC1->C1_USER"),Nil})
                    aadd(aLinha,{"C7_GRUPO" ,Posicione("SB1",1,xFilial("SB1")+TSC7->C7_PRODUTO,"SB1->B1_GRUPO"),Nil})
                    aAdd(aLinha,{"LINPOS","C7_ITEM",TSC7->C7_ITEM})
                    aAdd(aLinha,{"AUTDELETA","N" ,Nil})

                    aadd(aItens,aLinha)

                    MSExecAuto({|a,b,c,d,e,f,g,h| MATA120(a,b,c,d,e,f,g,h)},1,aCabec,aItens,nOpc,.F.,,)

                //SC7->(MsUnlock())
                Exit
            EndIf    
              
            TSC7->(DbSkip())

        ENDDO

        TSC8->(DbSkip())  

    ENDDO

    If !lMsErroAuto
        lRet := .T.
        ConOut("Alterado PC: "+cDoc)
    Else
        MostraErro()
    EndIf

    
Return lRet 





