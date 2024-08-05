//BRG GERADORES
//DATA 10/09/2019
//3RL Soluções - Ricardo Moreira
//Valida o apontamento de uma OP

#include 'protheus.ch'
#include 'parmtype.ch'

User function MT250TOK()

Local lRet := .T. //ParamIXB[1] //-- Validação do Sistema
Private _cOp := M->D3_OP
Private _Lote := M->D3_LOTECTL
Private _Prod:= M->D3_COD

 
DbSelectArea("SB1")
DbSetOrder(1)  
dbSeek(xFilial("SB1")+_Prod)

If SB1->B1_RASTRO = "L" .AND. EMPTY(_Lote)
   lRet := .F.
   MSGINFO("Produto Rastreado, Digite o Lote !!!!!"," Atenção ")
EndIf    

If RetSCP() > 0 .OR. RetSD4() > 0
   lRet := .F.
   MSGINFO("Existe Requisições e/ou Empenhos Pendentes !!!!!"," Atenção ")
EndIf
 
If TRIM(FUNNAME()) == 'MATA250'
 
   If Select("TMP1") > 0
	   TMP1->(DbCloseArea())
   EndIf  

   cQry := " "   
   cQry += "SELECT SD3.D3_FILIAL, SD3.D3_COD, SD3.D3_LOCAL, SD3.D3_TM, SD3.D3_QUANT Qtd_prod, SD3.D3_OP, SD3.D3_LOTECTL, SD3.D3_ESTORNO,  "    
   cQry += "(ISNULL((SELECT ISNULL(SUM(SD33.D3_QUANT),0) FROM " + retsqlname("SD3")+" SD33 WHERE SD3.D3_FILIAL = SD33.D3_FILIAL  AND SD3.D3_COD = SD33.D3_COD  AND SD33.D3_CF= 'RE7' AND SD33.D3_ESTORNO = ' ' AND SD3.D3_LOTECTL = SD33.D3_LOTECTL AND SD33.D_E_L_E_T_ <> '*'),0)) AS Qtd_Des " 
   cQry += "FROM " + retsqlname("SD3")+" SD3 " 
   cQry += "INNER JOIN " + retsqlname("SB1") + " SB1 ON  B1_COD = D3_COD AND SB1.D_E_L_E_T_ <> '*' "  
   cQry += "WHERE SD3.D_E_L_E_T_ <> '*' " 
   cQry += "AND SB1.B1_TIPO IN ('PA','PI') " // PI e PA conforme instruções 
   cQry += "AND SD3.D3_COD = '" + _Prod + "' "
   cQry += "AND SD3.D3_FILIAL = '" + cFilAnt + "' "
   cQry += "AND SD3.D3_LOTECTL = '" + _Lote + "' "
   cQry += "AND SD3.D3_TM = '003' " 
   cQry += "AND SD3.D3_ESTORNO = ' ' "  

   DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP1",.T.,.T.) 
   If !empty(TMP1->D3_LOTECTL)
      If TMP1->Qtd_prod > TMP1->Qtd_Des     //(TMP1->Qtd_prod > 0 .and. TMP1->Qtd_Des < 0) logica errada   
         lRet := .F.
         MSGINFO("Lote com Movimentação no Estoque !! "," Atenção ")
      EndIf
   EndIf


TMP1->(DbCloseArea())
 
//Valida o apontamento de OP no nível 001, somente deixa apontar o nível 001 se as intermediárias dela estiver apontadadas 
//Critério: Se o campo c2_DATRF estiver preenchido, esta apontado.
//20/01/2022
//3RL Soluções

  If substr(_cOp,9,3) == "001" //pegar somente o conteúdo da sequencia, só irá entrar na condição quando for 001
    If Select("TMP2") > 0
	     TMP2->(DbCloseArea())
    EndIf  

    ccQry := " "   
    ccQry += "SELECT C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_LOCAL, C2_QUANT, C2_DATRF "
    ccQry += "FROM " + retsqlname("SC2")+" SC2 "   
    ccQry += "WHERE SC2.D_E_L_E_T_ <> '*' "     
    ccQry += "AND SC2.C2_NUM = '" + substr(_cOp,1,6) + "' "
    ccQry += "AND SC2.C2_FILIAL = '" + cFilAnt + "' "
    ccQry += "AND SC2.C2_SEQUEN <> '001' "   
    ccQry += "ORDER BY C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN"   

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(ccQry)),"TMP2",.T.,.T.)

    dbselectarea("TMP2")
    DBGOTOP()
    DO WHILE ! EOF()
       If empty(TMP2->C2_DATRF)
          lRet := .F.
          MSGINFO("Por favor apontar primeiramente as OP's Filhas !! "," Atenção ")
       EndIf
       TMP2->(dbskip())
    EndDo
EndIf //pegar somente o conteúdo da sequencia, só irá entrar na condição quando for 001

EndIf  //TRIM(FUNNAME()) == 'MATA250'

 
Return lRet  
	
	
	/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ RETSD3   º Autor ³ Ricardo Moreira    º Data ³ 26/04/2017 º±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna o Número da Proxima Solicitação a ser gravada      o±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RetSCP()
//Verifica se o arquivo TMP está em uso

Local _cQuant := 0

If Select("QSCP") > 0
	QSCP->(DbCloseArea())
EndIf

_cQry := " "
_cQry += "SELECT COUNT(*) Quant "
_cQry += "FROM " + retsqlname("SCP")+" SCP "
_cQry += "WHERE SCP.D_E_L_E_T_ <> '*' "
_cQry += "AND CP_QUANT > CP_QUJE "
_cQry += "AND CP_OP = '" + _cOp + "' "
_cQry += "AND CP_FILIAL = '" + cFilAnt + "' "
_cQry += "AND CP_STATUS = ' ' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"QSCP",.T.,.T.)

_cQuant:= QSCP->Quant

Return _cQuant

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ RETSD4   º Autor ³ Ricardo Moreira    º Data ³ 26/04/2017 º±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna o Número da Proxima Solicitação a ser gravada      o±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RetSD4()
//Verifica se o arquivo TMP está em uso

Local _cQtd := 0

If Select("QSD4") > 0
	QSD4->(DbCloseArea())
EndIf

_cQry := " "
_cQry += "SELECT COUNT(*) Quant "
_cQry += "FROM " + retsqlname("SD4")+" SD4 "
_cQry += "WHERE SD4.D_E_L_E_T_ <> '*' "
_cQry += "AND D4_QUANT > 0 "
_cQry += "AND D4_OP = '" + _cOp + "' "
_cQry += "AND D4_FILIAL = '" + cFilAnt + "' "


DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"QSD4",.T.,.T.)

_cQtd:= QSD4->Quant

Return _cQtd
	



