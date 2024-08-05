#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
 
 //Valida o Estorno da OP' (se caso estiver estornando apos o mÊs que foi apontada não deixar)
 //Pharma
 //11/01/2022

User Function MT680EST()
Local nAcao := PARAMIXB[1]    //AnoMes(Data)  aaaamm
Local lRet  := .T.

/*
If nAcao == 2 //Operador confirmou estorno 
   If AnoMes(dDataBase) <> AnoMes(SD3->D3_EMISSAO)
      MsgInfo("Estorno não autorizado, fora do mês do Apontamento."," Atenção ")	  
      lRet  := .F.
   EndIf
EndIf
*/
Return lRet
