#INCLUDE 'Protheus.ch'

/*/{Protheus.doc} User Function nomeFunction
    
    
    
    @type  Função resposável por 
    @author user
    @since 05/06/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function FSCOM001()
    //Para testes retornar a data de entrega do pedido posicionado 
    dbSelectArea("SC7")
    dbSetOrder(1)
    If DbSeek(xFilial("SC7")+SC7->C7_NUM+SC7->C7_ITEM)
        FWAlertInfo(CVALTOCHAR(SC7->C7_DTPREV),"Teste de Posicionamento")
    Else
        FWAlertInfo("Não Encontrou","Teste de Posicionamento")
    EndIF
Return


