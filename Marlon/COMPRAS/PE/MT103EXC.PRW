#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT103EXC 
Ponto de entrada para validação 
da exclusão do documento de entrada.
Utilizado para incluir PRV caso NF 
seja excluida.
@type  Function
@author Maria Luiza
@since 09/04/2025 */

User Function MT103EXC()

Local aArea     := GetArea() // Salva todas as áreas atuais
Local cCond     := ""
Local nVIPI     := 0
Local nValTot   := 0
Local dData     := Date()
Local nVSol     := 0
Local _Venc     := CtoD("  /  /  ")
Local _Total    := 0
Local _Parc     := " "
Local i         := 1
Local cTipo     := "PR"
Local cNumPC    := ""
Local lRet      := .T. 
Local lMsg      := .F.
Local _Forn     := ""
Local _Lj       := SD1->D1_LOJA
Local lAchou    := .F.
Local cQuery    := ""
Local aDelet    := {}
Local nTotal    := 0
Local cItemPc   := ""
Private lMsErroAuto := .F.

// Só executa as validações se NÃO estiver no callstack da função de estorno de classificação
If !FWIsInCallStack("A140EstCla")

    // Posiciona corretamente na SD1 para buscar o número do pedido
    cNumPC := Posicione('SD1', 1, xFilial('SD1') + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA, 'D1_PEDIDO')

    If Empty(cNumPC)// se não tiver numeração de PC, não prossegue com o processo
        lMsg := .F.
    Else
        lMsg := .T.
    EndIf

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))

        If  SC7->(MsSeek(FWxFilial("SC7") + cNumPC )) //Posiciona no pedido correto

        While !SC7->(Eof()) .AND. cNumPc == SC7->C7_NUM // Verifica se o número do pedido é igual ao que foi passado

        //Fecha a área TSC7, se aberta
        If Select("TSC7") > 0
            TSC7->(dbCloseArea())
        EndIf

            // Query na SC7
            cQuery := "SELECT DISTINCT C7_FILIAL, C7_NUM, C7_COND, C7_EMISSAO, C7_FORNECE, C7_LOJA, C7_DATPRF,C7_XDTPRF, SUM(C7_TOTAL) TOTAL, SUM(C7_VALIPI) VALIPI, SUM(C7_VALSOL) VALSOL "
            cQuery += "FROM " + RetSqlName("SC7") + " SC7 "
            cQuery += "WHERE SC7.D_E_L_E_T_ <> '*' "
            cQuery += "AND SC7.C7_FILIAL = '" + xFilial('SC7') + "' "
            cQuery += "AND SC7.C7_NUM = '" + cNumPC + "' "
            cQuery += "AND SC7.C7_ENCER = '' "
            cQuery += "AND SC7.C7_QUJE < SC7.C7_QUANT "
            cQuery += "GROUP BY C7_FILIAL, C7_NUM, C7_COND, C7_EMISSAO, C7_DATPRF, C7_FORNECE, C7_LOJA,C7_XDTPRF "
            cQuery += "ORDER BY C7_FILIAL, C7_NUM, C7_DATPRF,C7_XDTPRF "

            // Executa a query
            DbUseArea(.T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "TSC7", .T., .T.)

        If Empty(SC7->C7_XDTPRF)

            dData :=  SC7->C7_DATPRF

        Else

            dData :=  SC7->C7_XDTPRF

        EndIf
            _Forn   := AllTrim(SC7->C7_FORNECE)
            _Lj     := SC7->C7_LOJA
            cCond   := SC7->C7_COND
        
            nValTot += SC7->C7_TOTAL + SC7->C7_VALIPI + SC7->C7_VALSOL // Somando valor total do PC
            aParc   := Condicao(nValTot, cCond, nVIPI, dData, nVSol)// Calculando o número de parcelas
            cItemPc := SC7->C7_ITEM //Item PC

        SC7->(DbCloseArea())

        For i := 1 To Len(aParc)
            _Venc  := LastDay(aParc[i,1], 3)// Vencimento
            _Total := aParc[i,2] // Valor da parcela
            _Parc  := cValToChar(i)// Número da parcela

            // Array de inclusão do título
            aArray := { {"E2_PREFIXO", "PRV", NIL},;
                {"E2_NUM", PadR(AllTrim(cNumPC+"/"+substr(cItemPc,3,4)),TamSx3("E2_NUM")[1])  , NIL },; //Validando tamanho do campo na SX3
                {"E2_PARCELA", PadR(AllTrim(_Parc), TamSx3("E2_PARCELA")[1]), NIL},;
                {"E2_TIPO", PadR(AllTrim(cTipo), TamSx3("E2_TIPO")[1]), NIL},;
                {"E2_NATUREZ", PadR(AllTrim("602030007"), TamSx3("E2_NATUREZ")[1]), NIL},;
                {"E2_FORNECE", _Forn, NIL},;
                {"E2_LOJA", _Lj, NIL},;
                {"E2_EMISSAO", dData, NIL},;
                {"E2_VENCTO", _Venc, NIL},;
                {"E2_VENCREA", _Venc, NIL},;
                {"E2_VALOR", _Total, NIL}}

            // Array de exclusão do título
            aDelet := { {"E2_PREFIXO", "PRV", NIL},;
                {"E2_NUM", PadR(AllTrim(cNumPC+"/"+substr(cItemPc,3,4)),TamSx3("E2_NUM")[1])  , NIL },;
                {"E2_PARCELA", PadR(AllTrim(_Parc), TamSx3("E2_PARCELA")[1]), NIL},;
                {"E2_TIPO", PadR(AllTrim(cTipo), TamSx3("E2_TIPO")[1]), NIL},;
                {"E2_NATUREZ", PadR(AllTrim("602030007"), TamSx3("E2_NATUREZ")[1]), NIL}}

            // Verifica se existe título na SE2
            If Select("TSE2") > 0
            TSE2->(dbCloseArea())
            EndIf

            cQuery := " SELECT * FROM " + retsqlname("SE2") + " "
            cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND E2_PREFIXO = 'PRV' "
            cQuery += " AND E2_NUM = '"+cNumPC+"/"+substr(cItemPc,3,4)+"' AND E2_PARCELA = '"+_Parc+"'
            cQuery += " AND E2_TIPO = '" +cTipo+"' AND D_E_L_E_T_ <> '*' "

            DbUseArea(.T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "TSE2", .T., .T.)

            TSE2->(dbGoTop())
            Count To nTotal

            If nTotal > 0
            lAchou := .T.
            EndIf

            TSE2->(dbCloseArea())

            Begin Transaction

            // Exclui título existente, se encontrado
            If lAchou
                MsExecAuto({|x,y,z| FINA050(x,y,z)}, aDelet,, 5)
                If lMsErroAuto
                FWAlertInfo("Sistema não conseguiu excluir o título, refaça o processo", "Atenção!!!")
                MostraErro()
                DisarmTransaction()
                lRet := .F.
                lMsg := .F.
                EndIf
            EndIf

            // Inclui novo título
            MsExecAuto({|x,y,z| FINA050(x,y,z)}, aArray,, 3)
            If lMsErroAuto
                FWAlertInfo("Não foi possível incluir o título, verifique", "Atenção!!!")
                MostraErro()
                DisarmTransaction()
                lMsg := .F.
            Else
                lRet := .T.
                lMsg := .T.
            EndIf

            End Transaction

            lAchou := .F.

        Next i

            SC7->(DbSkip())
        EndDo

        EndIf

    SC7->(dbCloseArea())

    // Restaura as áreas
    RestArea(aArea)

    If lMsg
        FWAlertInfo("Título financeiro criado com sucesso.", "Atenção!!!")
    EndIf

EndIf

Return lRet
