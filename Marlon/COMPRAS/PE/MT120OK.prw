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
 Local nPosCC     := AScan(aHeader, {|x| Alltrim(x[2]) == "C7_CC"})
 Local nPosRateio := AScan(aHeader, {|x| Alltrim(x[2]) == "C7_RATEIO"})
 Local cFormPag := ""
 Local cPagamento := SupergetMv("MV_FORMPAG", , )
 Local cBanco := ""
 Local cAgencia := ""
 Local cDigitVerAgen := ""
 Local cDigitVerCon  := ""
 Local cConta := ""


    If FunName() == "MATA161"
           cCentroCusto := Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"C1_CC")
           cRateio := Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"C1_RATEIO")
    Else
        // Obtendo o centro de custo e o rateio
        cCentroCusto := ACOLS[n,nPosCC] 
        cRateio := ACOLS[n, nPosRateio]
    EndIf


    If FunName() <> "MATA161"
            // Verificando se o centro de custo est� vazio e se o rateio est� informado
            If Empty(cCentroCusto) .and. cRateio == "1"
                // Se o centro de custo est� vazio e h� rateio, permite a confirma��o
                lRetorno := .T. // Permite continuar sem erro
            ElseIf Empty(cCentroCusto) .and. cRateio == "2"
                // Se ambos est�o vazios, bloqueia a grava��o e exibe uma mensagem
                FWAlertInfo("Informe um centro de custo ou rateio", "Aten��o!!!")
                lRetorno := .F. // Bloqueia a confirma��o
            EndIf

            If SC7 ->(MsSeek(xFilial("SC7")+SC7->C7_NUM+SC7->C7_ITEM))

                cUserWeb := Posicione("SC1",1,xFilial("SC1")+ACOLS[n][18]+ACOLS[n][15],"C1_XSOLWEB")
                cUser := Posicione("SC1",1,xFilial("SC1")+ACOLS[n][18]+ACOLS[n][15],"C1_USER")
                cGrupo := Posicione("SB1",1,xFilial("SB1")+ACOLS[n][2],"B1_GRUPO")
                

                    If !Empty(cUserWeb)

                        RecLock("SC7", .F.)
                        SC7->C7_CODSOL := cUserWeb 
                        SC7->C7_GRUPO  := cGrupo
                        SC7->(MsUnlock())

                    ElseIf !Empty(cUser)

                        RecLock("SC7", .F.)
                        SC7->C7_CODSOL := cUser
                        SC7->C7_GRUPO  := cGrupo
                        SC7->(MsUnlock())

                    Else 
                        RecLock("SC7", .F.)
                        SC7->C7_CODSOL := RetCodUsr()
                        SC7->C7_GRUPO  := cGrupo
                        SC7->(MsUnlock())
                    EndIf

            EndIf

         cFormPag := Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,'A2_FORMPAG')
         cBanco := Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,'A2_BANCO')
         cAgencia := Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,'A2_AGENCIA')
         cDigitVerAgen := Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,'A2_DVAGE')
         cDigitVerCon  := Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,'A2_DVCTA')
         cConta := Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,'A2_NUMCON')

        If Empty(cFormPag)
            Help(, ,"AVISO#0019", ,"Fornecedor n�o possui forma de pagamento cadastrada.",1, 0, , , , , , {"Preencher o campo Forma de Pagamento no cadastro desse fornecedor."})
            lRetorno := .F.
        Else
            If cFormPag $ cPagamento
                If Empty(cBanco) .OR. Empty(cAgencia) .OR. Empty(cDigitVerAgen) .OR. Empty(cDigitVerCon) .OR. Empty(cConta)

                 Help(, ,"AVISO#0020", ,"Diverg�ncia de informa��es.",1, 0, , , , , , {"Preencher os seguintes campos no cadastro deste fornecedor : " + CHR(13) + " 1-Banco" + CHR(13) + "2-Ag�ncia" + CHR(13) + "3-D�gito verificador da ag�ncia" + CHR(13) + "4-N�mero da conta" + CHR(13) + "5-D�gito verificador da conta"})
                    lRetorno := .F.
                Else 
                    lRetorno := .T.
                EndIf
            EndIF
        EndIf

    EndIf

Return lRetorno
