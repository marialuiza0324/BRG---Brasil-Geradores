#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT110END � Autor � Ricardo Moreira     � Data �  20/09/22  ���
�������������������������������������������������������������������������͹��
������������������������������������ͱ�����������������������������������͹��
���Descricao � Valida��o do usu�rio ap� execu��o de a��es em bot�es      ���
�������������������������������������������������������������������������͹��
���Uso       � BRG GERADORES                     			              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT110END()

Local nOpca  := PARAMIXB[2]       // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear     
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local xCompra   := SuperGetMV("MV_XCOMPRA", ," ") // Parametro contendo os compradores
Local cTime := TIME()
Private nNumSC := PARAMIXB[1]       // Numero da Solicita��o de compras 
//PARAMIXB[1] == 1 Aprovar

If nOpca <> 1
   If SC1->C1_ITEM = "0001"
      MsgInfo("Informe o Motivo da Rejei��o/Bloqueio !!","Solicita��o de Compra ") 
      SC1->(RECLOCK("SC1",.F.)) 
      SC1->C1_FOIBLQ  := "S" 
      SC1->(MSUNLOCK()) 
      U_OBSAPRV() //Chama a tela de observa��o para dissertar o porque do bloqueio ou rejei��o
      MEmail()
    EndIF
Else
    If nOpca == 1 .AND. !(cCodUser $ xCompra)
      SC1->(RECLOCK("SC1",.F.)) 
      SC1->C1_APROV  := "B"     
      SC1->C1_DTAPGES  := DDATABASE  //data ta aprova��o 
      SC1->C1_HRAPGES  := SUBSTR(cTime,1,5)  //Hora da Aprova��o
      SC1->(MSUNLOCK()) 
      If SC1->C1_ITEM = "0001"
        AEmail()
	     MsgInfo("Solicita��o Pendente de Aprova��o do Comprador !!","Aten��o - Solicita��o de Compra ") 
      EndIF
    Else     
      SC1->(RECLOCK("SC1",.F.)) 
      SC1->C1_APROV  := "L"     //L OU B
      SC1->C1_APROVC  := cCodUser
      SC1->C1_DTAPCOM  := DDATABASE  //data ta aprova��o 
      SC1->C1_HRAPCOM  := SUBSTR(cTime,1,5)  //Hora da Aprova��o Altera��o solicitada (GRUPO )
      SC1->(MSUNLOCK()) 
      If SC1->C1_ITEM = "0001"
        CEmail()
	     MsgInfo("Solicita��o Completamente Aprovada !!","Aten��o - Solicita��o de Compra ") 
      EndIF
    EndIF
EndIf

Return 

//Fun��o para enviar email de Bloqueio ou Rejei��o

Static Function MEmail()
 
Local cAccount  := Lower(Alltrim(SuperGetMv("MV_RELACNT",.F.))) //SuperGetMv pega o parametro de acordo com a Filial (Anota��o Marlon)
//Local cAccount  := Lower(Alltrim(GetMv("MV_RELACNT")))
Local cEnvia    := Lower(Alltrim(GetMv("MV_RELFROM"))) //GetMv pega qualquer parametro (Anota��o Marlon)
Local cPassword := Alltrim(GetMv("MV_RELPSW"))
Local cServer   := Alltrim(GetMv("MV_RELSERV"))  //smtps.uhserver.com:587                                                                                                                                                                                                                                    
Local cRecebe   := UsrRetMail(SC1->C1_USER) 
Local cMensagem := ''
Local _CRLF     := Chr(13) + Chr(10)
Local _NEGR     := Chr(27)+ Chr(69)  
Local cTxtLinha := ''
Local lConectou := .F.
Local lEnviado  := .F.
Local nXi  
   
   cMensagem := ' Aviso de Bloqueio/Rejei��o '+ _CRLF
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF 
   cMensagem += ' Solicita��o: '+nNumSC+ _CRLF 
   cMensagem += ' Motivo Bloqueio: ' + _CRLF  
   cMensagem += ' Aprovador: ' + cusername +_CRLF    
   nLinhas := MLCount(SC1->C1_XOBSBLQ,70)
   For nXi:= 1 To nLinhas
       cTxtLinha := MemoLine(SC1->C1_XOBSBLQ,70,nXi)
       If !Empty(cTxtLinha) 
               cMensagem += ' '+cTxtLinha  + _CRLF
       EndIf
   Next nXi
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF     
   cMensagem += '<b> POR FAVOR N�O RESPONDER ESSE EMAIL</b>' //+ _NEGR
   cMensagem += '' + _CRLF    
   cMensagem += ' Atenciosamente' + _CRLF 
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF
   cMensagem += ' '+SM0->M0_NOMECOM  + _CRLF
   cMensagem += ' Departamento de Compras'  + _CRLF
   cMensagem += ' Fone: (062) 3333-0000'  + _CRLF

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
MailAuth(ALLTRIM(cAccount),ALLTRIM(cPassword)) // qdo nao conseguir autenticar ver antivirus no servidor
SEND MAIL FROM cEnvia TO cRecebe SUBJECT 'Solicita��o Bloqueada - '+nNumSC BODY cMensagem RESULT lEnviado //FUNC��O DE CODIFICA��O UTF-8 MARLON 20/04/2021

If !lEnviado 
     cMensagem := ""
     GET MAIL ERROR cMensagem
     Alert(cMensagem)
Endif
   
DISCONNECT SMTP SERVER Result lDisConectou

If lEnviado
   MSGINFO("E-mail's enviados"," Aten��o ")  
ENDIF
Return  


//Fun��o para enviar email de Aprova��o do Gestor

Static Function AEmail()
 
Local cAccount  := Lower(Alltrim(SuperGetMv("MV_RELACNT",.F.))) //SuperGetMv pega o parametro de acordo com a Filial (Anota��o Marlon)
//Local cAccount  := Lower(Alltrim(GetMv("MV_RELACNT")))
Local cEnvia    := Lower(Alltrim(GetMv("MV_RELFROM"))) //GetMv pega qualquer parametro (Anota��o Marlon)
Local cPassword := Alltrim(GetMv("MV_RELPSW"))
Local cServer   := Alltrim(GetMv("MV_RELSERV"))  //smtps.uhserver.com:587                                                                                                                                                                                                                                    
Local cRecebe   := UsrRetMail(SC1->C1_USER) 
Local cMensagem := ''
Local _CRLF     := Chr(13) + Chr(10)
Local _NEGR     := Chr(27)+ Chr(69)  
Local cTxtLinha := ''
Local lConectou := .F.
Local lEnviado  := .F.
Local nXi  
   
   cMensagem := ' Aviso de Aprova��o do Gestor '+ _CRLF
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF 
   cMensagem += ' Solicita��o: '+nNumSC+ _CRLF 
   cMensagem += ' Aprovador: ' + cusername +_CRLF    
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF     
   cMensagem += '<b> POR FAVOR N�O RESPONDER ESSE EMAIL</b>' //+ _NEGR
   cMensagem += '' + _CRLF    
   cMensagem += ' Atenciosamente' + _CRLF 
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF
   cMensagem += ' '+SM0->M0_NOMECOM  + _CRLF
   cMensagem += ' Departamento de Compras'  + _CRLF
   cMensagem += ' Fone: (062) 3333-0000'  + _CRLF

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
MailAuth(ALLTRIM(cAccount),ALLTRIM(cPassword)) // qdo nao conseguir autenticar ver antivirus no servidor
SEND MAIL FROM cEnvia TO cRecebe SUBJECT 'Solicita��o Aprovada - Gestor - '+nNumSC BODY cMensagem RESULT lEnviado //FUNC��O DE CODIFICA��O UTF-8 MARLON 20/04/2021

If !lEnviado 
     cMensagem := ""
     GET MAIL ERROR cMensagem
     Alert(cMensagem)
Endif
   
DISCONNECT SMTP SERVER Result lDisConectou

If lEnviado
   MSGINFO("E-mail's enviados"," Aten��o ")  
ENDIF
Return  


//Fun��o para enviar email de Aprova��o do Compras

Static Function CEmail()
 
Local cAccount  := Lower(Alltrim(SuperGetMv("MV_RELACNT",.F.))) //SuperGetMv pega o parametro de acordo com a Filial (Anota��o Marlon)
//Local cAccount  := Lower(Alltrim(GetMv("MV_RELACNT")))
Local cEnvia    := Lower(Alltrim(GetMv("MV_RELFROM"))) //GetMv pega qualquer parametro (Anota��o Marlon)
Local cPassword := Alltrim(GetMv("MV_RELPSW"))
Local cServer   := Alltrim(GetMv("MV_RELSERV"))  //smtps.uhserver.com:587                                                                                                                                                                                                                                    
Local cRecebe   := UsrRetMail(SC1->C1_USER) 
Local cMensagem := ''
Local _CRLF     := Chr(13) + Chr(10)
Local _NEGR     := Chr(27)+ Chr(69)  
Local cTxtLinha := ''
Local lConectou := .F.
Local lEnviado  := .F.
Local nXi  
   
   cMensagem := ' Aviso de Aprova��o do Compras '+ _CRLF
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF 
   cMensagem += ' Solicita��o: '+nNumSC+ _CRLF 
   cMensagem += ' Aprovador: ' + cusername +_CRLF    
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF     
   cMensagem += '<b> POR FAVOR N�O RESPONDER ESSE EMAIL</b>' //+ _NEGR
   cMensagem += '' + _CRLF    
   cMensagem += ' Atenciosamente' + _CRLF 
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF
   cMensagem += ' '+SM0->M0_NOMECOM  + _CRLF
   cMensagem += ' Departamento de Compras'  + _CRLF
   cMensagem += ' Fone: (062) 3333-0000'  + _CRLF

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
MailAuth(ALLTRIM(cAccount),ALLTRIM(cPassword)) // qdo nao conseguir autenticar ver antivirus no servidor
SEND MAIL FROM cEnvia TO cRecebe SUBJECT 'Solicita��o Aprovada - Compras - '+nNumSC BODY cMensagem RESULT lEnviado //FUNC��O DE CODIFICA��O UTF-8 MARLON 20/04/2021

If !lEnviado 
     cMensagem := ""
     GET MAIL ERROR cMensagem
     Alert(cMensagem)
Endif
   
DISCONNECT SMTP SERVER Result lDisConectou

If lEnviado
   MSGINFO("E-mail's enviados"," Aten��o ")  
ENDIF
Return  


