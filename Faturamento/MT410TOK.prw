#include "Protheus.ch"

/*
Funcao      : MT410TOK
Objetivos   : Excluir acerto Selecionado (Botao Excluir)
*/
User Function MT410TOK()
Local lRet      := .T.				// Conteudo de retorno
Local nOpc      := PARAMIXB[1]	// Opcao de manutencao
Local aRecTiAdt := PARAMIXB[2]	// Array com registros de adiantamentoc

/*
if !(cfilant $ "0101/0901") 

If nOpc = 3 .or. nOpc = 4
   If M->C5_TPDOC <> "N" .AND. EMPTY(M->C5_TPLOC) .AND. EMPTY(M->C5_NFREM)
      lRet   := .F.
      MSGINFO("Verificar Tipo de Documento e/ou Tipo de Locação/Nota de Remessa"," Atenção ")
    EndIf
EndIf
Endif
*/
Return(lRet)
