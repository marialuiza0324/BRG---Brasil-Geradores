#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
 
 //Valida o Estorno da OP' (se caso estiver estornando apos o m�s que foi apontada n�o deixar)
 //Pharma
 //11/01/2022

User Function MT250EST()

Local lRet  := .T.//Desativado por solicita��o de Guilherme no dia 07/02/2022 
 /*
If SD3->D3_CF == "PR0" //Operador confirmou estorno 
   If AnoMes(dDataBase) <> AnoMes(SD3->D3_EMISSAO)
      MsgInfo("Estorno n�o autorizado, fora do m�s do Apontamento."," Aten��o ")	  
      lRet  := .F.   
   EndIf
EndIf
 */
Return lRet
