#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/* MT120FIL
//Coloca Rotina de Aprovar Pedido de Compra
//@author 3RL
//@since 25/01/2023
//@version 1.0
*/
USER FUNCTION MT120FIL  //MT120QRY
Local cRet :=""
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local cExcec   := SuperGetMV("MV_FILEXC", ," ") // Parametro para não deixar os usuários q estão no parametro, não filtrar para eles
Local cSegApr  := SuperGetMV("MV_APR2PC", ," ") // COLOCAR SOMENTE O CODIGO CLEITOM E GIU APROVADORES SUPERIORES. MV_PEDDIRE
Local cPedDir  := SuperGetMV("MV_PEDDIRE", ," ") // Parametro para não deixar os usuários q estão no parametro, não filtrar para eles //MV_GRUPCLE
Local cGrupCle := SuperGetMV("MV_GRUPCLE", ," ") // Parametro para não deixar os usuários q estão no parametro, não filtrar para eles //MV_GRUPCLE
Local cUser := " " 
Local cGrupo := " " 

IF (cCodUser $ cExcec)  
	If MsgYesNo("Deseja Filtrar Somente à Aprovar (Apr) ?","ATENÇÃO")    
         If MsgYesNo("Deseja Aprovar Pedidos Bloqueados por Limite (Apr) ?","ATENÇÃO")
          DbSelectArea("SAK")
          DbSetOrder(3)
            If DbSeek(xFilial("SAK")+cCodUser)
               Do While ! EOF() .AND. SAK->AK_APROSUP == cCodUser .AND. SAK->AK_FILIAL = xFilial("SAK")
                   cUser += SAK->AK_USER+";"
                   //cUser := "000089"
                   //cGrupo += SAI->AI_GRUPO+";"    
                   SAK->(dbSkip())
               EndDo
              cRet:=" (C7_APROV $ '"+cUser+"' .OR. !EMPTY(C7_APROV)) .And. C7_CONAPRO = 'B' "
              Return (cRet)
            Endif
         EndIf


      IF (cCodUser $ cSegApr)   //Giu e Cleiton
         DbSelectArea("SAK")
         DbSetOrder(3)
         If DbSeek(xFilial("SAK")+cCodUser)
            Do While ! EOF() .AND. SAK->AK_APROSUP == cCodUser .AND. SAK->AK_FILIAL = xFilial("SAK")
                   cUser += SAK->AK_USER+";"
                   //cUser := "000089"
                   //cGrupo += SAI->AI_GRUPO+";"    
                   SAK->(dbSkip())
            EndDo
            cRet:=" (C7_APROV $ '"+cUser+"' .OR. EMPTY(C7_APROV)) .And. C7_CONAPRO = 'B' "
            Return (cRet) 
         Endif
      Else
         If cCodUser = '000004'   // alteração para que a giu aprova pedidos do Cristiano (000006), Rebeca (000078), Luciano (000074), Karita (000015)
             cUser += cPedDir
         EndIf 

            DbSelectArea("SAI")
            DbSetOrder(5)
            If DbSeek(xFilial("SAI")+cCodUser)                   
                  Do While ! EOF() .AND. SAI->AI_XAPROV == cCodUser .AND. SAI->AI_FILIAL = xFilial("SAI") 
                     cUser += SAI->AI_USER+";"
                     cGrupo += SAI->AI_GRUPO+";"
                     SAI->(dbSkip())
                  EndDo
                  If cCodUser = '000004'   // alteração para que a giu aprova pedidos do Cristiano (000006), Rebeca (000078), Luciano (000074), Karita (000015)
                     cRet:=" C7_CODSOL $ '"+cUser+"' .And. C7_CONAPRO = 'B' "  
                  else
                     cRet:=" C7_CODSOL $ '"+cUser+"' .And. C7_CONAPRO = 'B' .And. C7_GRUPO $ '"+cGrupo+"' "  
                  EndIf                
                         
               Return (cRet) 
            EndIf          
	   EndIF
   EndIf   
EndIF
Return cRet  
 

