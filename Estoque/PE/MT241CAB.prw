#INCLUDE "TOTVS.CH"
#INCLUDE'TBICONN.CH'

User Function MT241CAB() 

/*
    Ponto de entrada MT241CAB permite a inclusão de campos no cabeçalho da rotina "Movimentos Internos - Modelo 2".

    EM QUE PONTO: Nas funções A241Visual, A241Inclui, A241Estorn e será executado antes da chamada da
    MsDialog.

    Para armazenar o conteúdo dos campos, deve retornar um vetor bidimensional, com a estrutura [L][C], onde:
    L = nome do campo, de acordo com o dicionário de dados,
    C = conteúdo do campo.
 */ 
//#INCLUDE "PROTHEUS.CH"User Function MT241CAB()  Local oNewDialog  := PARAMIXB[1]      Local aCp:=Array(2,2)  aCp[1][1]="D3_CP1"  aCp[2][1]="D3_CP2"IF PARAMIXB[2]==3   aCp[1][2]=SPAC(10)   aCp[2][2]=SPAC(10)   @1.6,44.5 SAY "Cpo1" OF oNewDialog   @1.5,46.5 MSGET aCp[1][2] SIZE 40,08 OF oNewDialog   @1.6,53.5 SAY "Cpo2" OF oNewDialog   @1.5,55.5 MSGET aCp[2][2] SIZE 40,08 OF oNewDialogEndIfreturn (aCp)  

 Local oNewDialog    := PARAMIXB[1]      
 Local aCp:=Array(2,2)  


 aCp[1][1]="D3_CP1" 
 aCp[2][1]="D3_CP2"
 IF PARAMIXB[2]==3 
 // ALERT('PASSOU PELO PE MT241CAB')
 aCp[1][2]=SPAC(10)   
 aCp[2][2]=SPAC(10)   
        @1.6,44.5 SAY "Cpo1" OF oNewDialog    
        @1.5,46.5 MSGET aCp[1][2] SIZE 40,08 OF oNewDialog    
        @1.6,53.5 SAY "Cpo2" OF oNewDialog    
        @1.5,55.5 MSGET aCp[2][2] SIZE 40,08 OF oNewDialog   
 EndIf 

return (aCp) 
