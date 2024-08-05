#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CLIEMAIL º Autor ³ Ricardo Moreira     º Data ³  07/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍ¹±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envia email de titulos vencido e á vencer para clientes    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BRG                     			              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CLIEMAIL()
Local lRet := .T.
Local aArea    := GetArea()

If MsgYesNo("Deseja emitir Relatório dos Titulos que foram enviados ?","ATENÇÃO") 
   u_AviVenc() // Envio de email aos cliente para titulos vencidos   
EndIf
If MsgYesNo("Deseja Envia email para Clientes Vencidos ?","ATENÇÃO") 
   MEmail() // Envio de email aos cliente para titulos vencidos   
EndIf

//If MsgYesNo("Deseja Envia email para Clientes a Vencer ?","ATENÇÃO")    
   //MVmail() // Envio de email aos cliente para titulos a vencer
//EndIf
RestARea(aArea)
Return lRet

//// Envio de email aos cliente para titulos vencidos  - Ricardo Moreira 05/01/2021
// BRG - Geradores

Static Function MEmail()
Local cAccount  := Lower(Alltrim(SuperGetMv("MV_RELACNT",.F.))) //SuperGetMv pega o parametro de acordo com a Filial (Anotação Marlon)
//Local cAccount  := Lower(Alltrim(GetMv("MV_RELACNT")))
Local cEnvia    := Lower(Alltrim(GetMv("MV_RELFROM"))) //GetMv pega qualquer parametro (Anotação Marlon)
Local cPassword := Alltrim(GetMv("MV_RELPSW"))
Local cServer   := Alltrim(GetMv("MV_RELSERV"))
Local cRecebe   := "" //"giuliana@brggeradores.com.br"//Alltrim(GetMv("MV_YMT010I"))
Local dDtVenc   := DaySub(DDATABASE, 2)
//Local dDtaVenc  := DaySum(DDATABASE, 1)
//Local aFiles    := {}
Local _cClient  := ""
Local _cLoja    := ""
Local cMensagem := ''
//Local cTos
Local _CRLF      := Chr(13) + Chr(10)
Local _NEGR      := Chr(27)+ Chr(69) 
Local lConectou := .F.
Local lEnviado  := .F. //Variavel criada por Marlon 29/04/2021 13:41 para eliminação de erro orientado pela Brenda


If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := "SELECT E1_FILIAL, E1_PREFIXO, E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,A1_NOME,A1_EMAIL,A1_ENVCOB "
_cQry += ",E1_EMISSAO,E1_VENCREA,E1_SALDO "
_cQry += "FROM " + retsqlname("SE1")+" SE1 "  
_cQry += " INNER JOIN " + retsqlname("SA1")+" SA1 ON E1_CLIENTE  = A1_COD AND E1_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ <> '*' "
_cQry += "WHERE SE1.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SE1.E1_SALDO > 0 "
//_cQry += "AND   SE1.E1_CLIENTE = '016475581' "
_cQry += "AND   SA1.A1_ENVCOB <> 'N' "   
_cQry += "AND   SE1.E1_TIPO = 'NF' "   //33845322 
_cQry += "AND   SE1.E1_FILIAL  BETWEEN '" + xFilial("SE1")  + "' AND '" + xFilial("SE1")  + "' "
_cQry += "AND   SE1.E1_VENCREA < '" + DTOS(dDtVenc)+ "' "
_cQry += "ORDER BY SE1.E1_FILIAL, SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE TMP->(!EOF())  
  _cClient := TMP->E1_CLIENTE 
  _cLoja:= TMP->E1_LOJA 
   cRecebe := TMP->A1_EMAIL 

   cMensagem := ' Prezado(a) '+TMP->A1_NOME + _CRLF
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF
   cMensagem += ' Não Identificamos, em nossos registros, o pagamento do(s) seguinte(s) valor(es), até então em aberto(s):' + _CRLF
   cMensagem += '' + _CRLF

   DO WHILE TMP->(!EOF()) .AND. _cClient = TMP->E1_CLIENTE .AND. _cLoja = TMP->E1_LOJA

      cMensagem += ' Titulo/Parcela: '+TMP->E1_NUM+ "/"+TMP->E1_PARCELA+ _CRLF 
      cMensagem += ' Vencimento: ' +CVALTOCHAR(STOD(TMP->E1_VENCREA)) + _CRLF
      cMensagem += ' Valor: ' +AllTrim(Transform(TMP->E1_SALDO,"@ze 999,999,999,999.99")) + _CRLF  
      cMensagem += '' + _CRLF
      cMensagem += '' + _CRLF
   
      TMP->(dbskip())
   ENDDO

   cMensagem += '' + _CRLF
   cMensagem += ' Como não recebemos nenhuma comunicação sobre os motivos do atraso, solicitamos que entre em contato' + _CRLF
   cMensagem += ' o quanto antes para regularização desta pendência ou siga a seguinte instrução:' + _CRLF   
   cMensagem += '' + _CRLF 
   cMensagem += ' Caso o pagamento já tenha sido efetuado, por favor desconsidere este aviso.' + _CRLF
   cMensagem += '' + _CRLF
   cMensagem += ' ENTRAR EM CONTATO VIA TELEFONE OU PELO EMAIL: auxiliar.financeiro@brggeradores.com.br' + _NEGR
   cMensagem += '' + _CRLF   
   cMensagem += '' + _CRLF
   cMensagem += ' POR FAVOR NÃO RESPONDER ESSE EMAIL' + _NEGR
   cMensagem += '' + _CRLF
   cMensagem += ' Se tiver dúvidas ou problemas para efetuar o pagamento entre em contato conosco através do' + _CRLF
   cMensagem += ' telefone (062) 3771-2544 ou por e-mail: auxiliar.financeiro@brggeradores.com.br.' + _CRLF
   cMensagem += '' + _CRLF
   cMensagem += ' Atenciosamente' + _CRLF 
   cMensagem += '' + _CRLF
   cMensagem += '' + _CRLF
   cMensagem += ' BRG Geradores'  + _CRLF
   cMensagem += ' Departamento de Contas a Receber.'  + _CRLF
   cMensagem += ' Fone: (062) 3771-2544 / (062) 9 9220-3007'  + _CRLF

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
MailAuth(ALLTRIM(cAccount),ALLTRIM(cPassword)) // qdo nao conseguir autenticar ver antivirus no servidor
SEND MAIL FROM cEnvia TO cRecebe SUBJECT 'T'+EncodeUTF8("í")+'tulos Vencidos - BRG GERADORES' BODY cMensagem RESULT lEnviado //FUNCÇÃO DE CODIFICAÇÃO UTF-8 MARLON 20/04/2021

If !lEnviado 
     cMensagem := ""
     GET MAIL ERROR cMensagem
     Alert(cMensagem)
Endif
   
DISCONNECT SMTP SERVER Result lDisConectou

//If lDisConectou
    // Alert("Desconectado com servidor de E-Mail - " + cServer)
//Endif

 //TMP->(dbskip())
ENDDO

If lEnviado
   MSGINFO("E-mail's enviados"," Atenção ")  
ENDIF
Return


