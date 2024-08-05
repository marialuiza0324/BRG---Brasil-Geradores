#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT110END บ Autor ณ Ricardo Moreira     บ Data ณ  20/09/22  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida็ใo do usuแrio ap๓ execu็ใo de a็๕es em bot๕es      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BRG GERADORES                     			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MT110END()

Local nOpca  := PARAMIXB[2]       // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear     
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local xCompra   := SuperGetMV("MV_XCOMPRA", ," ") // Parametro contendo os compradores
Local cTime := TIME()
Private nNumSC := PARAMIXB[1]       // Numero da Solicita็ใo de compras 
//PARAMIXB[1] == 1 Aprovar

If nOpca <> 1
   If SC1->C1_ITEM = "0001"
      MsgInfo("Informe o Motivo da Rejei็ใo/Bloqueio !!","Solicita็ใo de Compra ") 
      SC1->(RECLOCK("SC1",.F.)) 
      SC1->C1_FOIBLQ  := "S" 
      SC1->(MSUNLOCK()) 
      U_OBSAPRV() //Chama a tela de observa็ใo para dissertar o porque do bloqueio ou rejei็ใo
      MEmail()
    EndIF
Else
    If nOpca == 1 .AND. !(cCodUser $ xCompra)
      SC1->(RECLOCK("SC1",.F.)) 
      SC1->C1_APROV  := "B"     
      SC1->C1_DTAPGES  := DDATABASE  //data ta aprova็ใo 
      SC1->C1_HRAPGES  := SUBSTR(cTime,1,5)  //Hora da Aprova็ใo
      SC1->(MSUNLOCK()) 
      If SC1->C1_ITEM = "0001"
        AEmail()
	     MsgInfo("Solicita็ใo Pendente de Aprova็ใo do Comprador !!","Aten็ใo - Solicita็ใo de Compra ") 
      EndIF
    Else     
      SC1->(RECLOCK("SC1",.F.)) 
      SC1->C1_APROV  := "L"     //L OU B
      SC1->C1_APROVC  := cCodUser
      SC1->C1_DTAPCOM  := DDATABASE  //data ta aprova็ใo 
      SC1->C1_HRAPCOM  := SUBSTR(cTime,1,5)  //Hora da Aprova็ใo Altera็ใo solicitada (GRUPO )
      SC1->(MSUNLOCK()) 
      If SC1->C1_ITEM = "0001"
        CEmail()
	     MsgInfo("Solicita็ใo Completamente Aprovada !!","Aten็ใo - Solicita็ใo de Compra ") 
      EndIF
    EndIF
EndIf

Return 

//Fun็ใo para enviar email de Bloqueio ou Rejei็ใo

Static Function MEmail()
 
Local cAccount  := Lower(Alltrim(SuperGetMv("MV_RELACNT",.F.))) //SuperGetMv pega o parametro de acordo com a Filial (Anota็ใo Marlon)
//Local cAccount  := Lower(Alltrim(GetMv("MV_RELACNT")))
Local cEnvia    := Lower(Alltrim(GetMv("MV_RELFROM"))) //GetMv pega qualquer parametro (Anota็ใo Marlon)
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
   
   cMensagem := ' Aviso de Bloqueio/Rejei็ใo '+ _CRLF
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF 
   cMensagem += ' Solicita็ใo: '+nNumSC+ _CRLF 
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
   cMensagem += '<b> POR FAVOR NรO RESPONDER ESSE EMAIL</b>' //+ _NEGR
   cMensagem += '' + _CRLF    
   cMensagem += ' Atenciosamente' + _CRLF 
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF
   cMensagem += ' '+SM0->M0_NOMECOM  + _CRLF
   cMensagem += ' Departamento de Compras'  + _CRLF
   cMensagem += ' Fone: (062) 3333-0000'  + _CRLF

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
MailAuth(ALLTRIM(cAccount),ALLTRIM(cPassword)) // qdo nao conseguir autenticar ver antivirus no servidor
SEND MAIL FROM cEnvia TO cRecebe SUBJECT 'Solicita็ใo Bloqueada - '+nNumSC BODY cMensagem RESULT lEnviado //FUNCวรO DE CODIFICAวรO UTF-8 MARLON 20/04/2021

If !lEnviado 
     cMensagem := ""
     GET MAIL ERROR cMensagem
     Alert(cMensagem)
Endif
   
DISCONNECT SMTP SERVER Result lDisConectou

If lEnviado
   MSGINFO("E-mail's enviados"," Aten็ใo ")  
ENDIF
Return  


//Fun็ใo para enviar email de Aprova็ใo do Gestor

Static Function AEmail()
 
Local cAccount  := Lower(Alltrim(SuperGetMv("MV_RELACNT",.F.))) //SuperGetMv pega o parametro de acordo com a Filial (Anota็ใo Marlon)
//Local cAccount  := Lower(Alltrim(GetMv("MV_RELACNT")))
Local cEnvia    := Lower(Alltrim(GetMv("MV_RELFROM"))) //GetMv pega qualquer parametro (Anota็ใo Marlon)
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
   
   cMensagem := ' Aviso de Aprova็ใo do Gestor '+ _CRLF
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF 
   cMensagem += ' Solicita็ใo: '+nNumSC+ _CRLF 
   cMensagem += ' Aprovador: ' + cusername +_CRLF    
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF     
   cMensagem += '<b> POR FAVOR NรO RESPONDER ESSE EMAIL</b>' //+ _NEGR
   cMensagem += '' + _CRLF    
   cMensagem += ' Atenciosamente' + _CRLF 
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF
   cMensagem += ' '+SM0->M0_NOMECOM  + _CRLF
   cMensagem += ' Departamento de Compras'  + _CRLF
   cMensagem += ' Fone: (062) 3333-0000'  + _CRLF

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
MailAuth(ALLTRIM(cAccount),ALLTRIM(cPassword)) // qdo nao conseguir autenticar ver antivirus no servidor
SEND MAIL FROM cEnvia TO cRecebe SUBJECT 'Solicita็ใo Aprovada - Gestor - '+nNumSC BODY cMensagem RESULT lEnviado //FUNCวรO DE CODIFICAวรO UTF-8 MARLON 20/04/2021

If !lEnviado 
     cMensagem := ""
     GET MAIL ERROR cMensagem
     Alert(cMensagem)
Endif
   
DISCONNECT SMTP SERVER Result lDisConectou

If lEnviado
   MSGINFO("E-mail's enviados"," Aten็ใo ")  
ENDIF
Return  


//Fun็ใo para enviar email de Aprova็ใo do Compras

Static Function CEmail()
 
Local cAccount  := Lower(Alltrim(SuperGetMv("MV_RELACNT",.F.))) //SuperGetMv pega o parametro de acordo com a Filial (Anota็ใo Marlon)
//Local cAccount  := Lower(Alltrim(GetMv("MV_RELACNT")))
Local cEnvia    := Lower(Alltrim(GetMv("MV_RELFROM"))) //GetMv pega qualquer parametro (Anota็ใo Marlon)
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
   
   cMensagem := ' Aviso de Aprova็ใo do Compras '+ _CRLF
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF 
   cMensagem += ' Solicita็ใo: '+nNumSC+ _CRLF 
   cMensagem += ' Aprovador: ' + cusername +_CRLF    
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF     
   cMensagem += '<b> POR FAVOR NรO RESPONDER ESSE EMAIL</b>' //+ _NEGR
   cMensagem += '' + _CRLF    
   cMensagem += ' Atenciosamente' + _CRLF 
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF
   cMensagem += ' '+SM0->M0_NOMECOM  + _CRLF
   cMensagem += ' Departamento de Compras'  + _CRLF
   cMensagem += ' Fone: (062) 3333-0000'  + _CRLF

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
MailAuth(ALLTRIM(cAccount),ALLTRIM(cPassword)) // qdo nao conseguir autenticar ver antivirus no servidor
SEND MAIL FROM cEnvia TO cRecebe SUBJECT 'Solicita็ใo Aprovada - Compras - '+nNumSC BODY cMensagem RESULT lEnviado //FUNCวรO DE CODIFICAวรO UTF-8 MARLON 20/04/2021

If !lEnviado 
     cMensagem := ""
     GET MAIL ERROR cMensagem
     Alert(cMensagem)
Endif
   
DISCONNECT SMTP SERVER Result lDisConectou

If lEnviado
   MSGINFO("E-mail's enviados"," Aten็ใo ")  
ENDIF
Return  


