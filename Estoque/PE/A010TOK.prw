#INCLUDE "RWMAKE.CH"
#include "protheus.ch"        
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � A010TOK  � Autor � Ricardo Moreira       � Data � 10/12/19 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida a inclus�o de Produto, n�o deixa mudar bloqueio     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para BRG       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function A010TOK()

Local aArea := GetArea()
Local aAreaB1 := SB1->(GetArea())
Local lExecuta := .T.// Valida��es do usu�rio para inclus�o ou altera��o do produto 
Local _Cod:= SB1->B1_COD
Local _Loc:= SB1->B1_LOCPAD
Local cProduto := M->B1_COD // C�digo do produto sendo alterado
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
      MsgInfo('Produto a ser Bloqueado, existe Requisi��o em Aberto!!', 'Aten��o')
      lExecuta := .F.
   EndIf

   // Monta query para verificar pedidos de compra pendentes
        cQuery := "SELECT C7_NUM, C7_PRODUTO "
        cQuery += "FROM " + RetSqlName("SC7") + " SC7 "
        cQuery += "WHERE SC7.D_E_L_E_T_ = ' ' "
        cQuery += "AND SC7.C7_PRODUTO = '" + cProduto + "' "
        cQuery += "AND SC7.C7_QUJE < SC7.C7_QUANT " // Quantidade entregue menor que quantidade pedida
        cQuery += "AND SC7.C7_RESIDUO = ' ' " // Pedido n�o estornado
        cQuery += "AND SC7.C7_CONAPRO = 'L' " // Pedido liberado, mas NF pendente

        // Executa a query
        DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasSC7, .T., .T.)

        // Verifica se h� pedidos pendentes
        If !(cAliasSC7)->(Eof())
            // Impede o bloqueio e exibe mensagem
            MsgAlert("N�o � poss�vel bloquear o produto " + Alltrim(cProduto) + ". Existe pedido de compra pendente de entrada de NF.", "Aten��o")
            lExecuta := .F. // Cancela a grava��o
        EndIf

        // Fecha a �rea
        (cAliasSC7)->(DbCloseArea())
EndIF

RestArea(aAreaB1)
RestArea(aArea)

Return (lExecuta)
