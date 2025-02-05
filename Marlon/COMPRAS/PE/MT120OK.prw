#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT120OK 
Respons�vel pela valida��o de todos 
os itens do GetDados do Pedido 
de Compras / Autoriza��o de Entrega.
@type  Function
@author Maria Luiza
@since 04/09/2024 */

User Function MT120OK() 

 Local lRetorno := .T. // Retorno padr�o .T. para seguir o fluxo normal
 Local cRateio := "" // Vari�vel que vai armazenar o rateio
 Local cCentroCusto := "" // Vari�vel para o centro de custo
 Local cUser := ""
 Local cGrupo := ""
 Local cUserWeb := ""
 Local nCodSol    := AScan(aHeader, {|x| Alltrim(x[2]) == "C7_CODSOL"})
 Local nGrpProd   := AScan(aHeader, {|x| Alltrim(x[2]) == "C7_GRUPO"})


    If FunName() <> "MATA161"
        // Obtendo o centro de custo e o rateio
        cCentroCusto := ACOLS[1][23] 
        cRateio := ACOLS[1][62] 

            // Verificando se o centro de custo est� vazio e se o rateio est� informado
            If Empty(cCentroCusto) .and. cRateio == "1"
                // Se o centro de custo est� vazio e h� rateio, permite a confirma��o
                lRetorno := .T. // Permite continuar sem erro
            ElseIf Empty(cCentroCusto) .and. cRateio == "2"
                // Se ambos est�o vazios, bloqueia a grava��o e exibe uma mensagem
                FWAlertInfo("Informe um centro de custo ou rateio", "Aten��o!!!")
                lRetorno := .F. // Bloqueia a confirma��o
            EndIf
    EndIf

        cUserWeb := Posicione("SC1",1,xFilial("SC1")+ACOLS[1][18]+ACOLS[1][15],"C1_XSOLWEB")
		cUser := Posicione("SC1",1,xFilial("SC1")+ACOLS[1][18]+ACOLS[1][15],"SC1->C1_USER")
		cGrupo := Posicione("SB1",1,xFilial("SB1")+ACOLS[1][2],"SB1->B1_GRUPO")

                    If !Empty(cUserWeb)

                Acols[n,nCodSol] := cUserWeb 
                Acols[n,nGrpProd]  := cGrupo

            ElseIf !Empty(cUser)
    
                Acols[n,nCodSol] := cUser
                Acols[n,nGrpProd]  := cGrupo

            Else 
                
                Acols[n,nCodSol] := RetCodUsr()
                Acols[n,nGrpProd]  := cGrupo

            EndIf
    
    

Return lRetorno
