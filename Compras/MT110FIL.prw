#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/* MT110FIL
//Filtra as Solicitações somente com o solicitante q esta acessando
//@author 3RL
//@since 16/09/2022
//@version 1.0
*/
USer Function MT110FIL  
Local cFiltro :=""
Local cUser   :=""
Local cGrupo  :=""
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local cExcec   := SuperGetMV("MV_FILEXC", ," ") // Parametro para não deixar os usuários q estão no parametro não filtrar para eles
Local cCompr   := SuperGetMV("MV_XCOMPRA", ," ") // Parametro dos Id's dos Compradores

If  (cCodUser $ cCompr) //Criar o parametro 	Filtro para os Compradores (somente o tem para aprovar)	
    If MsgYesNo("Deseja Filtrar Somente à Aprovar (Com) ?","ATENÇÃO")    
        cFiltro:=" EMPTY(C1_APROVC) .And.  C1_APROV = 'B' .And. !EMPTY(C1_NOMAPRO) "  
        Return (cFiltro)  
    EndIf
Else
    If  !(cCodUser $ cExcec) //Criar o parametro 	Filtro para todos os solicitante verem somente suas solicitações.	 
        cFiltro:=" C1_USER == '"+cCodUser+"' "

        Return (cFiltro) 
    ElseIf MsgYesNo("Deseja Filtrar Somente à Aprovar (Apr) ?","ATENÇÃO")    
             DbSelectArea("SAI")
             DbSetOrder(5)
             If DbSeek(xFilial("SAI")+cCodUser)
                Do While ! EOF() .AND. SAI->AI_XAPROV == cCodUser .AND. SAI->AI_FILIAL = xFilial("SAI")
                   cUser += SAI->AI_USER+";"
                   cGrupo += SAI->AI_GRUPO+";"    
                   SAI->(dbSkip())
                EndDo
                cFiltro:=" C1_USER $ '"+cUser+"' .And. C1_GRPRD $ '"+cGrupo+"' .And.  C1_APROV = 'B' .And. EMPTY(C1_NOMAPRO) "   //
                Return (cFiltro) 
            EndIf   
        EndIf

        DbSelectArea("SAI")
        DbSetOrder(5)
        If DbSeek(xFilial("SAI")+cCodUser)
           Do While ! EOF() .AND. SAI->AI_XAPROV == cCodUser .AND. SAI->AI_FILIAL = xFilial("SAI")
              cUser += SAI->AI_USER+";"  
              SAI->(dbSkip())
           EndDo
           cFiltro:=" C1_USER $ '"+cUser+"' " 
           Return (cFiltro) 
        EndIf 

EndIF
 
Return (cFiltro) 

