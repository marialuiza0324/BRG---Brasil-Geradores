#include "rwmake.ch"
/*
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � MT010INC   � Autor � Claudio Ferreira   � Data � 08/05/2012���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de Entrada apos a inclusao do produto                ���
���          � Utilizado para avisar a CTB                                ���
��+----------+------------------------------------------------------------���
��� Uso      � TOTVS-GO                                                   ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT010INC()

Local cAviso:='Inclus�o de novo Produto'
Local cDestino:=SuperGetMV("MV_XAVCTB", ,"")
Local _lGrv := .f.

if !empty(cDestino)
	//Envia email de Aviso
	xHTM := '<HTML><BODY>'
	xHTM += '<hr>'
	xHTM += '<p  style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
	xHTM += '<b><font face="Verdana" SIZE=3>'+cAviso+' &nbsp; '+dtoc(date())+'&nbsp;&nbsp;&nbsp;'+time()+'</b></p>'
	xHTM += '<hr>'
	xHTM += '<br>'
	xHTM += '<br>'
	xHTM += 'Foi incluido um novo Produto <BR><BR>-C�digo <b>'  +SB1->B1_COD+' - '+SB1->B1_DESC+'</b> <BR>-Usuario <b>'+UsrRetName(RetCodUsr())+'</b> <br><br>'
	xHTM += 'A��o: Deve-se validar o cadastro e liberar para uso<br><br>'
	xHTM += '</BODY></HTML>'
	
	//Parametros necessarios para a rotina
	// MV_RELACNT - Conta a ser utilizada no envio de E-Mail
	// MV_RELFROM - E-mail utilizado no campo FROM no envio
	// MV_RELSERV - Nome do Servidor de Envio de E-mail utilizado no envio
	// MV_RELAUTH - Determina se o Servidor de Email necessita de Autentica��o
	// MV_RELAUSR - Usu�rio para Autentica��o no Servidor de Email
	// MV_RELAPSW - Senha para Autentica��o no Servidor de Email
	
	oMail := SendMail():new()
	
	oMail:SetTo(cDestino)
	//oMail:SetCc('') // (opc)
	oMail:SetFrom(Alltrim(GetMv("MV_RELFROM",," ")))
	//oMail:SetAttachment('\system\siga.txt') //Anexo (opc)
	oMail:SetSubject('Aviso - '+cAviso)
	oMail:SetBody(xHTM)
	oMail:SetShedule(.f.) //(opc) Default .f. - define modo Schedule
	oMail:SetEchoMsg(.f.) //(opc) Default .t. - define se exibe mensagens automaticamente na Tela (Schedule .f.) / Console (Schedule .t.)
	oMail:Send()
endif

Return
