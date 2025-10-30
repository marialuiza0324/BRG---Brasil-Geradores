#INCLUDE "RWMAKE.CH"
#include "protheus.ch"        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ A010TOK  ³ Autor ³ Ricardo Moreira       ³ Data ³ 10/12/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a inclusão de Produto, não deixa mudar bloqueio     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para BRG       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A010TOK()

Local aArea := GetArea()
Local aAreaB1 := SB1->(GetArea())
Local lExecuta := .T.// Validações do usuário para inclusão ou alteração do produto 
Local _Cod:= SB1->B1_COD
Local _Loc:= SB1->B1_LOCPAD
Local cProduto := M->B1_COD // Código do produto sendo alterado
Local cAliasSC7 := GetNextAlias()
Local cQuery := ""

If M->B1_MSBLQL = "1" .AND. ALTERA

   If Select("QTMP") > 0
	  QTMP->(DbCloseArea())
   EndIf

   _cQry := " "
   _cQry += "SELECT COUNT(*) Qtd  "
   _cQry += "FROM " + retsqlname("SCP")+" SCP "
   _cQry += "WHERE SCP.D_E_L_E_T_ <> '*' "
   _cQry += "AND CP_FILIAL = '" + cFilAnt + "' "
   _cQry += "AND CP_PRODUTO = '" + _Cod + "' "
   _cQry += "AND CP_LOCAL = '" + _Loc + "' "
   _cQry += "AND CP_QUJE < CP_QUANT "
   _cQry += "AND CP_STATUS <> 'E' "

   DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"QTMP",.T.,.T.)

   _Num:= QTMP->Qtd
 
   If  _Num > 0
      MsgInfo('Produto a ser Bloqueado, existe Requisição em Aberto!!', 'Atenção')
      lExecuta := .F.
   EndIf

   // Monta query para verificar pedidos de compra pendentes
        cQuery := "SELECT C7_NUM, C7_PRODUTO "
        cQuery += "FROM " + RetSqlName("SC7") + " SC7 "
        cQuery += "WHERE SC7.D_E_L_E_T_ = ' ' "
        cQuery += "AND SC7.C7_PRODUTO = '" + cProduto + "' "
        cQuery += "AND SC7.C7_QUJE < SC7.C7_QUANT " // Quantidade entregue menor que quantidade pedida
        cQuery += "AND SC7.C7_RESIDUO = ' ' " // Pedido não estornado
        cQuery += "AND SC7.C7_CONAPRO = 'L' " // Pedido liberado, mas NF pendente

        // Executa a query
        DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasSC7, .T., .T.)

        // Verifica se há pedidos pendentes
        If !(cAliasSC7)->(Eof())
            // Impede o bloqueio e exibe mensagem
            MsgAlert("Não é possível bloquear o produto " + Alltrim(cProduto) + ". Existe pedido de compra pendente de entrada de NF.", "Atenção")
            lExecuta := .F. // Cancela a gravação
        EndIf

        // Fecha a área
        (cAliasSC7)->(DbCloseArea())
EndIF

RestArea(aAreaB1)
RestArea(aArea)

Return (lExecuta)
