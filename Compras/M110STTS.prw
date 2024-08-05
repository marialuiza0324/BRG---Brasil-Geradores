#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

 
//18/10/2022
//LOCALIZA��O : Function A110Inclui, A110Altera, e A110Deleta responsaveis pela inclus�o, altera��o, exclus�o e c�pia das Solicita��es de Compras.
//EM QUE PONTO : Ap�s a grava��o da Solicita��o pela fun��o A110Grava em inclus�o, altera��o e exclus�o , localizado fora da transa��o possibilitando assim a inclusao de interface ap�s a grava��o de todas as solicita��e
//Ricardo Moreira

User Function M110STTS()
Local cNumSol   := Paramixb[1]
Local nOpt      := Paramixb[2]
Local lCopia    := Paramixb[3]
Local cAprov    := ""
Local cTime := TIME()

/* 
Do case
    case nOpt == 1     
        msgalert("Solicita��o "+alltrim(cNumSol)+" inclu�da com sucesso!") 
    case nOpt == 2     
        msgalert("Solicita��o "+alltrim(cNumSol)+" alterada com sucesso!")     
    case nOpt == 3     
        msgalert("Solicita��o "+alltrim(cNumSol)+" exclu�da com sucesso!")
Endcase
 */ 

dbSelectArea("SC1")
dbsetorder(1)    
dbSeek(xFilial("SC1")+cNumSol)
If nOpt == 1 .or. nOpt == 2
	While SC1->(!EOF()) .AND. xFilial("SC1") = SC1->C1_FILIAL .AND. SC1->C1_NUM = cNumSol
        cAprov := POSICIONE("SAI",6,xFilial("SAI")+SC1->C1_USER+SC1->C1_GRPRD,"AI_XAPROV")

        SC1->(RECLOCK("SC1",.F.))
		SC1->C1_APROVC  := ""
		SC1->C1_NOMAPRO := UsrRetName(cAprov)  //UsrFullName
		SC1->C1_APROV   := "B"
        SC1->C1_DTAPGES := DDATABASE  //data ta aprova��o  na inclus�o j� cai aprovada a primeira aproca��o *************************
        SC1->C1_HRAPGES := SUBSTR(cTime,1,5)  //Hora da Aprova��o Altera��o solicitada (GRUPO )
		SC1->(MSUNLOCK())
		SC1->( dbSkip() )

       //Foi retirado o envio de email para o AProvador (1�) quando a data � menor q 5 dias, pq agora a Solicita��o j� cai aprovada na inclus�o 28/04/2023
       //If  DateDiffDay(SC1->C1_DATPRF,ddatabase) <= 10  // EX. Necessidade 29/10/22 - hj 19/10/22 = 10  If  (SC1->C1_DATPRF - ddatabase)
        // MailUrg() // Se a solicita��o em quest�o conter itens q tenha data de entrada <= q 10 dias dispara o email 
        //Return Nil
       //EndIF 

       SC1->(DBSKIP())
	Enddo	
	//MSGINFO("Solicita��o Urgente !!"," Aten��o ")
EndIf
   
Return Nil


Static Function MailUrg()
 
Local cAccount  := Lower(Alltrim(SuperGetMv("MV_RELACNT",.F.))) //SuperGetMv pega o parametro de acordo com a Filial (Anota��o Marlon)
//Local cAccount  := Lower(Alltrim(GetMv("MV_RELACNT")))
Local cEnvia    := Lower(Alltrim(GetMv("MV_RELFROM"))) //GetMv pega qualquer parametro (Anota��o Marlon)
Local cPassword := Alltrim(GetMv("MV_RELPSW"))
Local cServer   := Alltrim(GetMv("MV_RELSERV"))  //smtps.uhserver.com:587                                                                                                                                                                                                                                    
Local cRecebe   := ""//UsrRetMail(SC1->C1_USER)    //UsrRetMail(cUserID)
Local cMensagem := '' 
//Local cAprov    :=
Local _CRLF     := Chr(13) + Chr(10)
Local _NEGR     := Chr(27)+ Chr(69)  
Local cTxtLinha := ''
Local lConectou := .F.
Local lEnviado  := .F.
Local nXi  

//Posiciona no Aprovador do Solicitante - Inicio

DbSelectArea("SAI")
DbSetOrder(2)
If DbSeek(xFilial("SAI")+SC1->C1_USER)
    cRecebe := UsrRetMail(SAI->AI_XAPROV) 
EndIF  

///Posiciona no Aprovador do Solicitante - Fim



   cMensagem := ' Aviso de Solicita��o Urgente !! '+ _CRLF
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF 
   cMensagem += ' Solicita��o: '+SC1->C1_NUM+ _CRLF 
   cMensagem += ' Solicitante: ' + cusername +_CRLF   
   cMensagem += ' Aprovador: ' + UsrRetName(SAI->AI_XAPROV) +_CRLF    //UserRetname(SAI->AI_XAPROV)
   cMensagem += ' Motivo Urgencia: ' + _CRLF  
    
   nLinhas := MLCount(SC1->C1_XOBMEMO,70)
   For nXi:= 1 To nLinhas
       cTxtLinha := MemoLine(SC1->C1_XOBMEMO,70,nXi)
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
SEND MAIL FROM cEnvia TO cRecebe SUBJECT 'Solicita��o Urgente - '+SC1->C1_NUM BODY cMensagem RESULT lEnviado //FUNC��O DE CODIFICA��O UTF-8 MARLON 20/04/2021

If !lEnviado 
     cMensagem := ""
     GET MAIL ERROR cMensagem
     Alert(cMensagem)
Endif
   
DISCONNECT SMTP SERVER Result lDisConectou

If lEnviado
   MSGINFO("E-mail enviado - SOLICITA��O URGENTE"," Aten��o ")  
ENDIF
Return  
