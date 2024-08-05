#INCLUDE 'Protheus.ch'


/*/{Protheus.doc} nomeFunction
    (
     Função para retornar a descrição do produto
     na tela de apontamento - PCP MOD II
    )
    @type  Function
    @author Maria Luiza
    @since 27/06/24
    /*/

User Function FSPCP002()

    Local cDescri:= Posicione('SB1', 2, FWxFilial('SB1') + SH6->H6_PRODUTO, 'B1_DESC') 
    
Return cDescri
