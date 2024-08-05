#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
 
 //Valida o Estorno da OP' (se caso estiver estornando apos o mÊs que foi apontada não deixar)
 //Pharma
 //11/01/2022

User Function MT250EST()

Local lRet  := .T.//Desativado por solicitação de Guilherme no dia 07/02/2022 
 /*
If SD3->D3_CF == "PR0" //Operador confirmou estorno 
   If AnoMes(dDataBase) <> AnoMes(SD3->D3_EMISSAO)
      MsgInfo("Estorno não autorizado, fora do mês do Apontamento."," Atenção ")	  
      lRet  := .F.   
   EndIf
EndIf
 */
Return lRet
