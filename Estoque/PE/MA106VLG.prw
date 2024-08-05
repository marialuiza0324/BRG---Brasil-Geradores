#Include "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"   

//BRG
//Valida a gera��o da Pre Requisi��o
//14/04/2020

User function MA106VLG()

Local lRet := .T.
Local cBlq28 := SuperGetMV("MV_USER28", ," ") // Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 28
Local cBlq13 := SuperGetMV("MV_USER13", ," ") // Usu�rios que somente ir�o gerar e baixar requisi��es no almoxarifado 13
Local cBlqAll := SuperGetMV("MV_USERALL", ," ") //  
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
local alista := {}
Local N := 0
Local _Cnum := SCP->CP_NUM

If cCodUser $ cBlq28 .and. SCP->CP_LOCAL <> "28"
   lRet:=.F.  
   MSGINFO("Usu�rio n�o autorizado para gerar Pre Requisi��o no Almoxarifado 28."," Aten��o ") 
EndIf

If cCodUser $ cBlq13 .and. SCP->CP_LOCAL <> "13"
   lRet:=.F.  
   MSGINFO("Usu�rio n�o autorizado para gerar Pre Requisi��o no Almoxarifado 13."," Aten��o ") 
EndIf

If cCodUser $ cBlqAll .and. SCP->CP_LOCAL $ "13/28"
   lRet:=.F.  
   MSGINFO("Usu�rio n�o autorizado para gerar Pre Requisi��o nesse Almoxarifado."," Aten��o ") 
EndIf
 /*
	If Select("QSB2") > 0
		QSB2->(dbCloseArea())
	EndIf
	
	cQry := "SELECT B2_FILIAL, B2_COD, B2_LOCAL "
	cQry += "FROM " + retsqlname("SB2")+" SB2 "
	cQry += "WHERE SB2.D_E_L_E_T_ <> '*' "
	cQry += "AND   SB2.B2_QEMP > 0 "
	cQry += "AND   SB2.B2_FILIAL = '" + cFilAnt + "' "	 
	cQry += "ORDER BY B2_FILIAL, B2_COD, B2_LOCAL  "
	
	cQry := ChangeQuery(cQry)
	TcQuery cQry New Alias "QSB2"
	
	ProcRegua(QSB2->(RecCount()))
	DbSelectArea("QSB2")               
	DBGOTOP()
	DO WHILE QSB2->(!EOF()) 

   DbSelectarea('SB2')
   DbSetorder(1)
   DbSeek(xFilial('SB2')+QSB2->B2_COD+QSB2->B2_LOCAL)     
       SB2->(RECLOCK("SB2",.F.))
       SB2->B2_QEMP  := 0                           
       SB2->(MSUNLOCK())    
     DbSkip()

   Enddo

   
/*
DbSelectarea('SCP')
DbSetorder(1)
DbSeek(xFilial('SCP'))
Do While !EOF() .and. CP_FILIAL = xfilial('SCP')
     If CP_PREREQU <> 'S' .and. CP_OK == ThisMark()
       aadd(alista,{CP_FILIAL,CP_NUM, CP_PRODUTO,CP_QUANT, CP_SOLICIT})   //alista[n,2]
     EndIf
     DbSkip()
enddo

for n:= 1 to len(aLista)
   DbSelectarea('SB2')
   DbSetorder(1)
   If DbSeek(xFilial('SB2')+alista[n,3])
      If SB2->B2_QEMP > 0 
         SB2->(RECLOCK("SB2",.F.))
         SB2->B2_QEMP  := 0                          
         SB2->(MSUNLOCK())	
      EndIf   
   endif
next n

DbSelectarea('SCP')
DbSetorder(1)
If DbSeek(xFilial('SCP')+SCP->CP_NUM)
   Do While !EOF() .and. SCP->CP_FILIAL = xfilial('SCP') .and. SCP->CP_NUM = _Cnum
      If SCP->CP_PREREQU <> 'S' .and. SCP->CP_OK == ThisMark()
         DbSelectarea('SB2')
         DbSetorder(1)
         DbSeek(xFilial('SB2')+SCP->CP_PRODUTO+SCP->CP_LOCAL)
         If SB2->B2_QEMP > 0 
            SB2->(RECLOCK("SB2",.F.))
            SB2->B2_QEMP  := 0                          
            SB2->(MSUNLOCK())	
         EndIf   
      EndIf
    SCP->(DbSkip())
   Enddo
EndIf
*/
Return lRet
