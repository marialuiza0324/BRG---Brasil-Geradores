#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT235AIR
O Ponto de Entrada: MT235AIR será executado sempre ao final do processamento de eliminação por resíduo,
para cada item do Pedido de Compra, Solicitação de Compras e Contrato de Parceria permitindo que sejam 
realizadas customizações do usuário.De acordo com o processo que for executado, deverá ser verificado o 
Número indicativo do arq.em verificação conforme está descrito naseção de parâmetros do ponto de entrada.
Utilizado para excluir título financeiro na tabela SE2
@type  Function
@author Maria Luiza
@since 05/09/2024 */

User Function MT235AIR()

    Local lRet := .T.
    Local aArea := FWGetArea()
    Local cCond   := ""
    Local nVIPI   := 0
    Local nValTot := 0
    Local dData
    Local nVSol   := 0
    Local _Venc   := CtoD("  /  /  ")
    Local _Total  := 0
    Local _Parc   := " "
    Local i := 1
    Local lAchou:= .f.
    Local cTipo := "PR"
    Local cQuery := ""
    Local aDelet := {}
    Local nTotal := 0
    Local lMsErroAuto := .F.
    Local cNumPC  := ""
    Local cItemPc := ""

                cNumPC :=  SC7->C7_NUM //Num Pc
                cItemPc := SC7->C7_ITEM //Item Pc 

            
            //Fecha a área TSC7, se aberta
            If Select("TSC7") > 0
                TSC7->(dbCloseArea())
            EndIf

            DbSelectArea("SC7")
            SC7->(DbSetOrder(1))

        If  SC7->(MsSeek(FWxFilial("SC7") + cNumPC+ cItemPc)) //Posiciona no pedido correto

                        // Query na SC7
                        cQuery := "SELECT DISTINCT C7_FILIAL, C7_NUM, C7_COND, C7_EMISSAO, C7_FORNECE, C7_LOJA, C7_DATPRF,C7_XDTPRF, SUM(C7_TOTAL) TOTAL, SUM(C7_VALIPI) VALIPI, SUM(C7_VALSOL) VALSOL "
                        cQuery += "FROM " + RetSqlName("SC7") + " SC7 "
                        cQuery += "WHERE SC7.D_E_L_E_T_ <> '*' "
                        cQuery += "AND SC7.C7_FILIAL = '" + xFilial('SC7') + "' "
                        cQuery += "AND SC7.C7_NUM = '" + cNumPC + "' "
                        cQuery += "AND SC7.C7_ITEM = '" + cItemPc + "' "
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

                    aDelet := { { "E2_PREFIXO" , "PRV" , NIL },; //Array de exclusão do título
                    { "E2_NUM" , PadR(AllTrim(cNumPC+"/"+substr(cItemPc,3,4)),TamSx3("E2_NUM")[1])  , NIL },; //Validando tamanho do campo na SX3
                    { "E2_PARCELA" , PadR(AllTrim(_Parc),TamSx3("E2_PARCELA")[1])   , NIL },;
                    { "E2_TIPO" , PadR(AllTrim(cTipo),TamSx3("E2_TIPO")[1])  , NIL },;
                    { "E2_NATUREZ" , PadR(AllTrim("202010058"),TamSx3("E2_NATUREZ")[1])  , NIL }}

                    If Select("TSE2") > 0
                        TSE2->(dbCloseArea())
                    EndIf

                    cQuery := " SELECT * FROM " + retsqlname("SE2") + " "
                    cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND E2_PREFIXO = 'PRV' "
                    cQuery += " AND E2_NUM = '"+cNumPC+"/"+substr(cItemPc,3,4)+"' AND E2_PARCELA = '"+_Parc+"'
                    cQuery += " AND E2_TIPO = '" +cTipo+"' AND D_E_L_E_T_ <> '*' "

                    DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TSE2",.T.,.T.)

                    DbSelectArea("TSE2") //query retorna se existe título na SE2 com chave informada

                    TSE2->( dbGoTop() )
                    Count To nTotal

                    If  nTotal > 0
                        lAchou := .T.
                    EndIf

                    TSE2->(DbCloseArea())

                    Begin Transaction

                        If lAchou 
                                 MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aDelet,, 5) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

                                If lMsErroAuto //se der erro cancela exclusão e mostra erro
                                    FWAlertInfo("Sistema não conseguiu excluir o título, refaça o processo","Atenção!!!")
                                    MostraErro()
                                    DisarmTransaction()
                                    lMsg := .F.
                                Else
                                    lMsErroAuto:= .F.
                                    lRet := .T.
                                    lMsg := .T.
                                Endif
                        Endif

                    End Transaction

                    lAchou := .F. // zera variável
                    Next i
            

                    SB1->(DbCloseArea())
                    FwRestArea(aArea)
         EndIf

Return lRet 
