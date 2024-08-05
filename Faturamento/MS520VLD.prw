#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MS520VLD  ³ Autor ³ RICARDO MOREIRA        ³ Data ³ 10/03/17³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Excluir Nota se serviço tratando o titulo do imposto no    ³±±
±±³          ³ contas a pagar	                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para BRG                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


User Function MS520VLD()

Local lValido := .T. 
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local cExrps   := SuperGetMV("MV_EXCRPS", ," ") // Parametro para não deixar os usuários q estão no parametro não filtrar para eles
LOCAL aArea		:= GetArea()
Local cMunic := "01067479 " 
Local cLjMun := "0000" 

//If MONTH(SF2->F2_EMISSAO) <> MONTH(DDATABASE) .AND. YEAR(SF2->F2_EMISSAO) <> YEAR(DDATABASE) 
   IF SF2->F2_ESPECIE = "RPS"   //Quando tem uma exclusão de NFSE, e tem um titulos do fornecedor Municipio baixado vou na origem e coloco FINA050 pra excluir e continua a SE2
      If cCodUser $ cExrps
         DbSelectArea("SE2")
         DbSetOrder(6)   
         If dbSeek(xFilial("SE2")+cMunic+cLjMun+SF2->F2_SERIE+SF2->F2_DOC)
         //ALERT(CVALTOCHAR(SE2->SE2_FILIAL))
         //If dbSeek(XFilial("SE2")+cMunic+cLjMun+SF2->F2_PREFIXO+SF2->F2_DOC)
         //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO                                                                                               
            Do While ! eof() .AND. xFilial("SF2") == SE2->E2_FILIAL .AND. cMunic == SE2->E2_FORNECE .AND. cLjMun == SE2->E2_LOJA .AND. SE2->E2_PREFIXO== SF2->F2_SERIE .AND.  SE2->E2_NUM== SF2->F2_DOC
	            RecLock("SE2",.F.) //acrecentado 26/10/23 Jonathas
               SE2->E2_ORIGEM := "FINA050"
	            msUnlock()
	            SE2->(dbSkip()) 
            ENDDO   
            SE2->(DBCLOSEAREA()) 
         EndIf   
      Else
         MsgInfo("Usuário não autorizado a excluir RPS fora da Competencia !!","Atenção")
      EndIf     
   EndIf       
   //MsgInfo("Pedido de Compra Liberado !!","Atenção - Pedido de Compra ")
//EndIf

RestARea(aArea)    

Return lValido
