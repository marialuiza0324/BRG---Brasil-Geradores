
#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"
#Include "RESTFUL.ch"
#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// Inclui bibliotecas padrão do Protheus para integração com REST, banco de dados e MVC.

/*/{Protheus.doc}
@author Maria Luiza
@since 24/07/2025
@version 1.1
@description Processa JSON de OPs via API e gera pedidos de venda com MATA410
*/

User Function FSFAT004()
 
Local cPathPostDoc := ""
Local oRestPostDoc
Local cUrlDoc := "https://n8n.brggeradores.com.br"
Local aHeaderPostDoc := {}
Local cBody := ""
Local cRespPostDoc := ""   
Local cDoc              := SF2->F2_DOC
Local cSerie            := SF2->F2_SERIE
Local cCliente          := SF2->F2_CLIENTE
Local cQuery            := ''
Static cUsrLogin    := Alltrim("kit_reparo@2025")
Static cUsrSenha    := Alltrim("financeiro@2025")
Static cBasicAuth   := Encode64(cUsrLogin + ":" + cUsrSenha)
 
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
         
            If Select("TMP1") > 0
                  TMP1->(dbCloseArea())
            EndIf

            // Executa a consulta usando os parâmetros recebidos
            cQuery:= "SELECT * FROM " +RetSqlName("SF2")+" SF2 "
            cQuery+= "WHERE D_E_L_E_T_ = '' "
            cQuery+= "AND F2_DOC   = '"+ cDoc +"' "
            cQuery+= "AND F2_SERIE = '"+ cSerie +"' "
            cQuery+= "AND F2_CLIENTE = '"+ cCliente +"' "

            DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMP1",.T.,.T.)

            cChave := TMP1->F2_CHVNFE


               cPathPostDoc := "/webhook/nf/chave"
               oRestPostDoc := FWRest():New(cUrlDoc)
               aHeaderPostDoc := {}
               // Adiciona cabeçalhos HTTP ao array
               AAdd(aHeaderPostDoc, 'Authorization: Basic ' + cBasicAuth) // Adiciona o cabeçalho de autenticação
               AAdd(aHeaderPostDoc, 'Content-Type: application/json') // Define o tipo de conteúdo como JSON

               oRestPostDoc:SetPath(cPathPostDoc) // Define o caminho do endpoint no objeto FWRest

               If !Empty(cChave)
                  // Monta o corpo da requisição em formato JSON
                  cBody := '{"nota": "'+cDoc+'", "serie": "'+cSerie+'", "chave_nf": "'+cChave+'"}'
               Else
                  FwAlertwarning("Verifique se a Nota foi autorizada ou contate o administrador do sistema.","As informações não foram enviadas!")
                  Return .F.
               EndIf

               oRestPostDoc:SetPostParams(cBody)

               If oRestPostDoc:Post(aHeaderPostDoc) // Executa a requisição POST
                  cRespPostDoc := oRestPostDoc:GetResult() // Obtém a resposta do servidor
                  FWAlertSuccess("Informações enviadas com sucesso.", "Sucesso!")
               Else
			      Help(, ,"AVISO#0021", ,"As informações não foram enviadas.",1, 0, , , , , , {"Verifique se a Nota foi autorizada ou contate o administrador do sistema."})
                  ConOut("FSFAT004: Falha ao enviar POST: " + oRestPostDoc:GetLastError()) // Exibe mensagem de erro
                  Return .F.
               EndIf

Return 

  

