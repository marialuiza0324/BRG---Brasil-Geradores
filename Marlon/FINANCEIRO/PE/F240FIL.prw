#include "rwmake.ch"                                                                       
#include "protheus.ch"        

/*-------------------------------------------------------------------

Programa: F240FIL

Autor: Pedro Paulo

Data: 16/04/2020

Descrição: PE para filtrar títulos de acordo com parâmetro de geração
do borderô

------------------------------------------------------------------*/

/*
/////////LEGENDA DOS PARÂMETROS DO FILTRO///////////////// 
CPORT240  = CODIGO DO BANCO
CMODPGTO  = MODELO DO PAGAMENTO
CCONTA240 = AGENCIA
CCONTA240 = CONTA
CCONTRATO = CONTRATO
CTIPOPAG  = TIPO DO PAGAMENTO
/////////FIM LEGENDA DOS PARÂMETROS DO FILTRO/////////////////*/

User Function F240FIL()                                                                       
	Local aAreaatu := GetArea()
	Local _cFiltro := ""
    
If cModPgto == "01" 
   
   _cFiltro += " !(AllTrim(E2_FORMPAG) $ 'CD-CP-CC-CR-R$') .AND. E2_FORBCO =='"+cPort240+"' .AND. Empty(E2_CODBAR)"

elseIf cModPgto == "03" 
   
   _cFiltro += " !(AllTrim(E2_FORMPAG) $ 'CD-CP-CC-CR-R$') .AND. E2_FORBCO <>'"+cPort240+"' .AND. Empty(E2_CODBAR)"

elseIf cModPgto == "05" 
   
   _cFiltro += " !(AllTrim(E2_FORMPAG) $ 'CD-CP-CC-CR-R$') .AND. E2_FORBCO =='"+cPort240+"' .AND. Empty(E2_CODBAR)"

elseIf cModPgto == "30" 

	_cFiltro += " !(AllTrim(E2_FORMPAG) $ 'CD-CP-CC-CR-R$') .AND. !(SUBSTR(E2_CODBAR,1,1) $ '8') .AND. SUBSTR(E2_CODBAR,1,3) =='"+cPort240+"'"    
       
ElseIf cModPgto == "31" 
   
	_cFiltro += " !(AllTrim(E2_FORMPAG) $ 'CD-CP-CC-CR-R$') .AND. !(SUBSTR(E2_CODBAR,1,1) $ '8') .AND. !Empty(E2_CODBAR) .AND. SUBSTR(E2_CODBAR,1,3) <>'"+cPort240+"'"    
   
ElseIf cModPgto == "41" 
	
    _cFiltro += "!(AllTrim(E2_FORMPAG) $ 'CD-CP-CC-CR-R$') .AND. Empty(E2_CODBAR) .AND. !Empty(E2_FORBCO) .AND. E2_FORBCO <>'"+cPort240+"'"
                     
ElseIf cModPgto == "43" 
    
    _cFiltro += "!(AllTrim(E2_FORMPAG) $ 'CD-CP-CC-CR-R$') .AND. Empty(E2_CODBAR) .AND. !Empty(E2_FORBCO) .AND. E2_FORBCO <>'"+cPort240+"'"    

ElseIf cModPgto == "13" 
    
    _cFiltro += " !(AllTrim(E2_FORMPAG) $ 'CD-CP-CC-CR-R$') .AND. !Empty(E2_CODBAR) .AND. !(SUBSTR(E2_CODBAR,1,3) $ '033-341-237-001-756-748-104-364') .AND. SUBSTR(E2_CODBAR,1,3) <>'"+cPort240+"'"    

ENDIF   
        
Restarea(aAreaatu)
Return(_cFiltro)
