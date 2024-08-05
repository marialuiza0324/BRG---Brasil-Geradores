#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/* MT160GRPC
limpa o campo de aprovador
@author 3RL
@since 11/06/2018
@version 1.0
*/
User Function MT160GRPC 

SC7->C7_CODSOL  := SC1->C1_USER
SC7->C7_GRUPO   := SC1->C1_GRPRD
SC7->C7_DTPREV  := SC8->C8_DTENT
SC7->C7_CC      := SC1->C1_CC
SC7->C7_APROV   := ""

//RecLock("SC7", .F. )  
//SC7->C7_CONAPRO   :=  "B"
//SC7->( MSUNLOCK() ) 

//SC7->C7_CONAPRO := "B"


//SC7->C7_CONAPRO   :=  "B"

//Alert("TESTE")
/*
Local cNumPC := C7_NUM   // Numero do Pedido de Compras  

dbSelectArea("SC7")
SC7->(DbGoTop())
SC7->(dbSeek(xFilial("SC7")+cNumPC))
Do While !EOF() .AND. C7_FILIAL == xFilial("SC7") .AND. C7_NUM == cNumPC 
   RecLock("SC7", .F. )
   SC7->C7_CODSOL    := SC1->C1_USER
   SC7->C7_GRUPCOM   :=  " "  
   SC7->C7_CONAPRO   :=  "B"
   SC7->( MSUNLOCK() ) 
   SC7->(DBSKIP())
ENDDO 
*/ 
Return 
