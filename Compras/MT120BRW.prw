#INCLUDE "RWMAKE.CH"
#DEFINE ENTER Chr(13)+Chr(10)
/*
//*******************************************************************************
Rotina: MATA120
ExecBlock: MT120BRW
Ponto: Antes da chamada da função de Browse.
Observações: Utilizado para o tratamento de dados a serem apresentados. no Browse.
Retorno Esperado: Nenhum.
//*******************************************************************************
*/ 
User Function MT120BRW 

aadd(aRotina, {OemToAnsi("Altera Fornecedor"), "U_XALTFOR", 0 , 2} )

Return

//*******************************************************************************
//*
//*******************************************************************************
User Function XALTFOR()
Local nQUJE := 0
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local cCompr   := SuperGetMV("MV_XCOMPRA", ," ") // Parametro dos Id's dos Compradores
Private cPerg := PADR('XALTFOR',10)

If !(cCodUser $ cCompr) //Criar o parametro 	Filtro para os Compradores (somente o tem para aprovar) 
   APMSGALERT( "Você não tem permissão para usar essa rotina !!!","ATENÇÃO")
RETURN
ENDIF


CriaSx1()
//+
//| Disponibiliza para usuario digitar os parametros
//+
MV_PAR01  := SC7->C7_FORNECE
MV_PAR02  := ""
 
IF !Pergunte(cPerg,.T.)
RETURN
ENDIF
cMsg := "PEDIDO: "+SC7->C7_NUM+ENTER
cMsg += "**DE:"+ENTER+SC7->C7_FORNECE+"/"+SC7->C7_LOJA+" - "+Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")+ENTER
cMsg += "**PARA:"+ENTER+MV_PAR01+"/"+MV_PAR02+" - "+Posicione("SA2",1,xFilial("SA2")+MV_PAR01+MV_PAR02,"A2_NOME")+ENTER
cMsg += ENTER+"ATENÇÃO: ESSA MODIFICAÇÃO NÃO TEM COMO RETORNAR !!!"
IF (Aviso("ATENÇÃO",cMsg,{"Sim","Nao"},3,"De/Para")) == 1

cQuery := "SELECT SUM(C7_QUJE) QTDE FROM "+RetSqlname("SC7")+ENTER
cQuery += " WHERE C7_FILIAL='"+xFilial("SC7")+"' AND "
cQuery += " C7_NUM = "+VALTOSQL(SC7->C7_NUM)+" AND C7_FORNECE = "+VALTOSQL(SC7->C7_FORNECE)+" AND C7_LOJA = "+VALTOSQL(SC7->C7_LOJA)+ENTER
cQuery += " AND D_E_L_E_T_=' ' "+ENTER
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
nQUJE := TRB->QTDE
TRB->(dbCloseArea())

//Valida a Exitencia do Fornecedor q esta digitando - Inicio
DbSelectArea("SA2")
DbSetOrder(1)   
If !dbSeek(xFilial("SA2")+SC7->C7_FORNECE+MV_PAR02)
   ApMsgInfo("Fornecedor Inexistente, Por Favor Cadastrar !!!")
   Return
EndIf
//Valida a Exitencia do Fornecedor q esta digitando - Fim

IF nQUJE == 0
   cQuery := "UPDATE "+RetSqlname("SC7")+ENTER
   cQuery += " SET "+ENTER
   cQuery += " C7_XALTFOR = 'S' " 
   cQuery += " ,C7_LOJA = "+VALTOSQL(MV_PAR02)+ENTER
   cQuery += " FROM "+RetSqlname("SC7")+ENTER
   cQuery += " WHERE C7_FILIAL='"+xFilial("SC7")+"' AND "
   cQuery += " C7_NUM = "+VALTOSQL(SC7->C7_NUM)+" AND C7_FORNECE = "+VALTOSQL(SC7->C7_FORNECE)+" AND C7_LOJA = "+VALTOSQL(SC7->C7_LOJA)
   cQuery += " AND D_E_L_E_T_=' ' "
   //Memowrite("c:\siga\XALTFOR.sql",cQuery)
   TcSqlExec(cQuery)    

   //Alterar na SC8 
   cQuery := "UPDATE "+RetSqlname("SC8")+ENTER
   cQuery += " SET "+ENTER   
   cQuery += " C8_LOJA = "+VALTOSQL(MV_PAR02)+ENTER
   cQuery += " FROM "+RetSqlname("SC8")+ENTER
   cQuery += " WHERE C8_FILIAL='"+xFilial("SC8")+"' AND "
   cQuery += " C8_NUM = "+VALTOSQL(SC7->C7_NUMCOT) +" AND C8_FORNECE = "+VALTOSQL(SC7->C7_FORNECE) 
   cQuery += " AND D_E_L_E_T_=' ' "
   //Memowrite("c:\siga\XALTFOR.sql",cQuery)
   TcSqlExec(cQuery)

   ApMsgInfo("Alteração efetuada com sucesso !!!")


   //Alteração para gerar novamente 



ELSE
   ALERT("ROTINA CANCELADA !!! Já teve entrega para esse pedido !!!")
ENDIF

ENDIF
Return


///////////////////////////////////////////////////////////////////////////////////
//+
//
//| PROGRAMA | Relatorio_SQL.prw | AUTOR | | DATA | 18/01/2004 |//
//+
//
//| DESCRICAO | Funcao - CriaSX1() |//
//| | Fonte utilizado no curso oficina de programacao. |//
//| | Funcao que cria o grupo de perguntas se caso nao existir |//
//+
//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaSx1()
Local j := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Fornecedor ? ","mv_ch1","C",9,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"02","Loja ? ","mv_ch2","C",4,0,0,"G","","","","","","","","","","","","","","","","","LJA2"})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)

For ny:=1 to Len(aReg)-1
If !dbSeek(aReg[ny,1]+aReg[ny,2])
RecLock("SX1",.T.)
For j:=1 to Len(aReg[ny])
FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
Next j
MsUnlock()
EndIf
Next ny ?

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return Nil

 
