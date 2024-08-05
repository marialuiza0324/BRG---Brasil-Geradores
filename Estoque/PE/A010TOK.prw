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
EndIF

RestArea(aAreaB1)
RestArea(aArea)

Return (lExecuta)
