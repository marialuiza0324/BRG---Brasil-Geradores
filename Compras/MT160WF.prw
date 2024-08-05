//#INCLUDE "RWMAKE.CH"
//#INCLUDE "PROTHEUS.CH"
//#INCLUDE "topconn.ch"
/* MT160WF
limpa o campo de aprovador - QUANDO FAZ A ANALISE O CAMPO ESTA VINDO PREENCHIDO COM O aPROVADOR
@author 3RL
@since 11/06/2018
@version 1.0
*/
//User Function MT160WF()



/*
Local aResult    := {}//-- Gera notificacao - Encerramento de cotacao
Local cPedc      := SC7->C7_NUM

dbSelectArea("SC7")
SC7->(DbGoTop())
dbSetOrder(1)
IF dbSeek(xFilial("SC7")+cPedc)
   Do While !SC7->(EOF()) .AND. SC7->C7_FILIAL == xFilial("SC7") .AND. SC7->C7_NUM == cPedc
        RecLock("SC7", .F. )
        SC7->C7_APROV     := ""
        MsUnLock()       
        SC7->(DBSKIP())
   ENDDO 
EndIf
//  ApMsgStop('Erro na chamada do processo')     
*/
//Return 
