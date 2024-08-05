#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MS520VLD  � Autor � RICARDO MOREIRA        � Data � 10/03/17���
�������������������������������������������������������������������������Ĵ��
���Descricao � Excluir Nota se servi�o tratando o titulo do imposto no    ���
���          � contas a pagar	                                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para BRG                                        ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/


User Function MS520VLD()

Local lValido := .T. 
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local cExrps   := SuperGetMV("MV_EXCRPS", ," ") // Parametro para n�o deixar os usu�rios q est�o no parametro n�o filtrar para eles
LOCAL aArea		:= GetArea()
Local cMunic := "01067479 " 
Local cLjMun := "0000" 

//If MONTH(SF2->F2_EMISSAO) <> MONTH(DDATABASE) .AND. YEAR(SF2->F2_EMISSAO) <> YEAR(DDATABASE) 
   IF SF2->F2_ESPECIE = "RPS"   //Quando tem uma exclus�o de NFSE, e tem um titulos do fornecedor Municipio baixado vou na origem e coloco FINA050 pra excluir e continua a SE2
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
         MsgInfo("Usu�rio n�o autorizado a excluir RPS fora da Competencia !!","Aten��o")
      EndIf     
   EndIf       
   //MsgInfo("Pedido de Compra Liberado !!","Aten��o - Pedido de Compra ")
//EndIf

RestARea(aArea)    

Return lValido
