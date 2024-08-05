#include 'protheus.ch'
#include 'parmtype.ch'

//U_FSPCP001
USER FUNCTION FSPCP001()
  
  Local cAlias := "Z10"
  Local cTitulo := "Amarração OP x Pedido de Venda"
  Local cFunExc := "U_FSPCPA()"
  Local cFunAlt := "U_FSPCPB()"

  
  AxCadastro(cAlias,cTitulo,cFunExc,cFunAlt)

RETURN
//TESTE


/*/{Protheus.doc} FSPCP001A
  (
    Função de exclusão da amarração do Pedido com a Ordem de Produção
  )
  @type  USER FUNCTION
  @author Marlon Pablo
  @since 28/08/2023
/*/
USER FUNCTION FSPCPA()
  
  Local lRet := MSGBOX("Tem Certeza que deseja excluir o registro?","Confirmação","YESNO") 

Return lRet

/*/{Protheus.doc} FSPCP001B
  (
    Função que trata a inclusão de um novo registro
  )
  @type  USER FUNCTION
  @author Marlon Pablo
  @since 28/08/2023
/*/
USER FUNCTION FSPCPB()
  
  Local lRet  := .F.
  Local lOp   := .T.
  Local lPed  := .T.  
  Local lIte  := .T.  
  Local cMsg := ""

  IF INCLUI
    cMsg := "Confirma a inclusão do Registro?"
  ELSE
    cMsg := "Confirma alteração do registro?"
  ENDIF

  lRet := MSGBOX(cMsg,"Confirmação","YESNO")

  IF lRet
  
    dbSelectArea("SC6")
    dbSetOrder(1)      
    dbSeek(xFilial("SC6") + PADR(M->Z10_PEDIDO, TAMSX3("C5_NUM")[1]))

    //Validar 
    //Validar se o pedido esta aberto Abrir area do Cabeçalho do pedido para validar a emissão da nota  
    IF SC6->C2_OK <> "" .AND. C2_QUANT = C2_QUJE .AND. C2_DATRF <> ''
      MSGINFO( "Ordem de produção apontada. Selecione outra", "Validação de Ordem de Produção!" )
      lPed := .F.
    ENDIF    

    //Validar se a Op esta aberta.  
    //Permitir OP Firme; Prevista e Apontada
    dbSelectArea("SC2")
    dbSetOrder(1)      
    dbSeek(xFilial("SC2")+PADR(SubStr(M->Z10_PEDIDO,1,6), TAMSX3("C2_NUM")[1])+PADR(SubStr(M->Z10_PEDIDO,7,2), TAMSX3("C2_ITEM")[1])+PADR(SubStr(M->Z10_PEDIDO,9), TAMSX3("C2_SEQUEN")[1]))
    
    IF SC6->C6_NOTA == ""
      MSGINFO( "Pedido já Faturado! Escolha outro item.", "Validação de Pedido" )
      lOp := .F.
    ENDIF

    //Validar se o código do produto selecionado é o mesmo da OP
    IF SC6->C6_PRODUTO <> C2_PRODUTO
      MSGINFO( "Item da OP diferente do item do Pedido", "Validação de Produto" )
      lIte := .F.
    ENDIF

    IF lIte = .T. .OR. lOp = .T. .OR. lPed = .T.
      lRet = .T.
    ELSE
      MSGINFO( "Verifique inconsistências para continuar!"+CHR(13);
              +"OP Aberta: "+lOp+CHR(13);
              +"Pedido Faturado: "+lOp+CHR(13);
              +"Itens Iguais: "+lOp+CHR(13);
              , "Validação de Amarração" )
      lRet = .F.
    /*
      Validar o faturamento se o pedido vai ter retorno por devolução de documento de saida para que seja feita a alteração do status da amarração para inativa


    */
    
    /*IF SE6->(DBSEEK(FWXFILIAL('SE6')+M->Z10_PEDIDO))
      ALERT("Entrou no IFF")
      RECLOCK('SE6',.F.)
        E6_OP := M->Z10_PEDIDO
      SE6->(MSUNLOCK())
    ENDIF*/

  ENDIF

Return lRet
