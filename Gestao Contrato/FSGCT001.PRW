/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � FSGCT001  � Autor � Marlon Pablo� 	  Data � 27/05/2022     潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Func玢o que ser� chamado quando o Tipo do Contrato for 003 潮�
北�          � na filial 1001 - Agrogera                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para BRG                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"
#INCLUDE "topconn.ch"

//???????????????????????????????????????????????????????????????????????????

User Function FSGCT001()
//???????????????????????????????????????????????????????????????????????????		
	local lhainfo	:= .f.
	local ngrupo	:= 0
	local agrupo	:= {}
	local aitem		:= {}
	local cultnum	:= ""
	local _cTpCon   := ""
	local _cFunc    := ""
	Local cImgLogo 	:= ""
	Local nXi       := 1
	Local _Venc   := CtoD("  /  /  ")
	Local _Total  := 0
	Local _Parc   := " "
	Local nValTot := 0
	Local cCond   := 0
	Local dData   := CtoD("  /  /  ")
	Local cLogoD    := GetSrvProfString("Startpath","") + "LGMID.png"
	private _nhandle

	Geratmp1()
	//1=Solteiro;2=Casado;3=Divorciado;4=Viuvo;5=Companheiro(a);
	DbSelectArea("SU5")
	DbSetOrder(1)
	dbSeek(xFilial("SU5")+TMP1->AC8_CODCON)

	Do Case
	Case SU5->U5_CIVIL=="1"
		EstCiv := "Solteiro"
	Case SU5->U5_CIVIL=="2"
		EstCiv := "Casado"
	Case SU5->U5_CIVIL=="3"
		EstCiv := "Divorciado"
	Case SU5->U5_CIVIL=="4"
		EstCiv := "Viuvo"
	OtherWise
		EstCiv := "Companheiro(a)"
	EndCase

	// VALIDA敲O INCRI敲O ESTADUAL INICIO 15/03/2022
	IF TMP1->A1_INSCR=="ISENTO"
		Inscr = TMP1->A1_INSCR
	ELSEIF empty(TMP1->A1_INSCR)
		Inscr = "N鉶 Informado"
	ELSE
		Inscr = transform((TMP1->A1_INSCR),'@R 999999999.99-99')
	ENDIF
	// VALIDA敲O INCRI敲O ESTADUAL FIM 15/03/2022


	//VALIDACAO PARA CAMPO EM BRANCO - INICIO 10/09/2019
	Do Case
	Case empty(SU5->U5_NACIONA)
		MSGINFO("Preencher Nacionalidade do Contato !!!!!"," Aten玢o ")
		Return
	Case empty(SU5->U5_FUNCAO)
		MSGINFO("Preencher a Profiss鉶 do Contato !!!!!"," Aten玢o ")
		Return
	Case empty(SU5->U5_END)
		MSGINFO("Preencher o Endere鏾 do Contato !!!!!"," Aten玢o ")
		Return
	Case empty(SU5->U5_BAIRRO)
		MSGINFO("Preencher o Bairro do Contato !!!!!"," Aten玢o ")
		Return
	Case empty(SU5->U5_CEP)
		MSGINFO("Preencher o Cep do Contato !!!!!"," Aten玢o ")
		Return
	Case empty(SU5->U5_CPF)
		MSGINFO("Preencher o CPF do Contato !!!!!"," Aten玢o ")
		Return
	Case empty(SU5->U5_CONTAT)
		MSGINFO("Preencher o Nome do Contato !!!!!"," Aten玢o ")
		Return
	Case empty(SU5->U5_EMAIL)
		MSGINFO("Preencher o e-MAIL do Contato !!!!!"," Aten玢o ")
		Return
	EndCase
	//VALIDA敲O PARA CAMPO EM BRANCO - FIM 10/09/2019
     Geratmp1()
     
	_cTpCon := Posicione("CN1",1,xFilial("CN1")+TMP1->CN9_TPCTO,"CN1_DESC2")
	//_cTpCon :=  "CONTRATO DE VENDA DE ENERGIA EL蒚RICA DE CURTO PRAZO"   
    //cBody += "<img src ='http://'www.xxxxx.com.br/images/title.png'>"
 	  
	procregua(0)   
	incproc()
	_Contr := TMP1->CN9_NUMERO 
	
	_cMsg := ''
	_cMsg += '<html>'
	_cMsg += '<head>'
	//_cMsg += '<title> Contrato n.' +rtrim(TMP1->CN9_NUMERO)+'/'+cvaltochar(Year(STOD(TMP1->CN9_DTINIC)))+'</title>'
	_cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
	_cMsg += '</head>'
     _cMsg += '<style>'
     _cMsg += '@media all{   '
     _cMsg += '  body {'
     _cMsg += '    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif !important;'
     _cMsg += '    font-size: 14;'
     _cMsg += '    line-height: 1.4;'
     _cMsg += '  }'
     _cMsg += '  #tabela_pagamento {'
     _cMsg += '    page-break-before: always;'
     _cMsg += '  }'
     _cMsg += '  #assinaturas {'
     _cMsg += '    /*page-break-before: always;*/'
     _cMsg += '  }'
     _cMsg += '  
     _cMsg += '  * {'
     _cMsg += '    padding-bottom: 0.5cm; /*Ravylla falou que nao tem importancia esse bloco que da um espa鏰mento de 0.5 cm entre cada elementro da impress鉶. Ganhou 1,3mm entre a ultima linha de cada pagina e o rodap�*/'
     _cMsg += '  }'
     _cMsg += '.dados_produtos td{'
     _cMsg += '    padding: 10px;'
     _cMsg += '    border: 1px solid; '
     _cMsg += '    text-align: left;     '
     _cMsg += '}'
     _cMsg += '.dados_produtos th{'
     _cMsg += '    padding: 3px;'
     _cMsg += '    border: 1px solid; '
     _cMsg += '    text-align: left;     '
     _cMsg += '}'
     _cMsg += '}'     
     _cMsg += '@page{'
     _cMsg += '  size: auto;'
     _cMsg += '  margin-top: 2cm;'
     _cMsg += '  margin-left: 3cm;'
     _cMsg += '  margin-right: 2cm;'
     _cMsg += '  margin-bottom: 0.8cm;'      
     _cMsg += '}'

     _cMsg += '</style>'
	_cMsg += '<body>'  
     //	_cMsg += '<img src = "'+cLogoD+'">'   	//figura \system\logoorc.png
      //  	_cMsg += '<img src="system\LGMID.png"> </td>'   http://brggeradores.com.br/vendas/LogoMini.png
     //	_cMsg += '<img src="C:\Temp\LGMID.png" height="100" width="98" ></td>'

   	_cMsg += '<img src="http://brggeradores.com.br/vendas/LogoAgrogera.PNG" height="120" width="118"  >'//</td>'        
	_cMsg += '<b><p align="right"> Contrato n. '+rtrim(TMP1->CN9_NUMERO)+'/'+cvaltochar(Year(STOD(TMP1->CN9_DTINIC)))+'</b> <br /> </p>'   //Year(STOD(TMP1->CN9_NUMERO))
   	_cMsg += '<b align="left">'+_cTpCon+'</b> <br />'

   	_cMsg += '<h2>CONTRATO DE LOCA敲O</h2>' 
 
     //PARAGRAFO COMPRADOR  (venda de Gerador)
     _cMsg += '<p align="left">Pelo presente instrumento particular, as Partes a seguir qualificadas, de um lado, </p>'

     If TMP1->A1_PESSOA = "F" .AND. TMP1->A1_TIPO = "L"
          //PRODUTOR RURAL:
          _cMsg += '<p align="justify"><b>'+rtrim(TMP1->A1_NOME)+'</b>, nacionalidade: '+rtrim(SU5->U5_NACIONA)+', estado civil: '+rtrim(EstCiv)+', residente e domiciliado � ' +rtrim(SU5->U5_END)+', '+rtrim(SU5->U5_BAIRRO)+', CEP '+rtrim(SU5->U5_CEP)+', na cidade de '+rtrim(SU5->U5_MUN)+' - '+SU5->U5_EST+', inscrito no CPF/ME de n. '+transform((SU5->U5_CPF),'@R 999.999.999-99')+', produtor rural na <b>'+rtrim(TMP1->A1_NREDUZ)+'</b>, inscri玢o estadual n� '+Inscr+', localizada na '+rtrim(TMP1->A1_END)+', doravante designada simplesmente de <b>LOCAT罵IO (A)</b>.</p>'

     ELSEIF TMP1->A1_PESSOA = "J"
          //PJ:
          _cMsg += '<p align="justify"><b>'+rtrim(TMP1->A1_NOME)+'</b>, pessoa jur韉ica de direito privado, nome fantasia <b>'+rtrim(TMP1->A1_NREDUZ)+'</b>, inscrita no CNPJ (ME) sob o n�. '+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')+', Inscri玢o Estadual N. '+rtrim(TMP1->A1_INSCR)+', endere鏾 na ' +rtrim(TMP1->A1_END)+', '+rtrim(TMP1->A1_BAIRRO)+', Cep '+transform((TMP1->A1_CEP),'@R 99999-999')+' na cidade de '+rtrim(TMP1->A1_MUN)+' - '+TMP1->A1_EST+' atrav閟 de seu representante legal, S.r.(a) '+rtrim(SU5->U5_CONTAT)+', nacionalidade: '+rtrim(SU5->U5_NACIONA)+', estado civil: '+rtrim(EstCiv)+', profiss鉶: '+rtrim(_cFunc)+', residente e domiciliado � '+rtrim(SU5->U5_END)+', '+rtrim(SU5->U5_BAIRRO)+', CEP '+rtrim(SU5->U5_CEP)+', na cidade de '+rtrim(SU5->U5_MUN)+' - '+SU5->U5_EST+', inscrito no CPF/ME de n. '+transform((SU5->U5_CPF),'@R 999.999.999-99')+', doravante designada simplesmente de <b>LOCAT罵IO (A)</b>.</p>'
         

     ELSEIF TMP1->A1_PESSOA = "F"
          //PF:
          _cMsg += '<p align="justify"><b>'+rtrim(TMP1->A1_NOME)+'</b>, nacionalidade: '+rtrim(SU5->U5_NACIONA)+', estado civil: '+rtrim(EstCiv)+', profiss鉶: '+rtrim(_cFunc)+', residente e domiciliado � ' +rtrim(SU5->U5_END)+', '+rtrim(SU5->U5_BAIRRO)+', CEP '+rtrim(SU5->U5_CEP)+', na cidade de '+rtrim(SU5->U5_MUN)+' - '+SU5->U5_EST+', inscrito no CPF/ME de n. '+transform((SU5->U5_CPF),'@R 999.999.999-99')+', doravante designada simplesmente de <b>LOCAT罵IO (A)</b>.</p>'     
     ENDIF                                 
     
    //PARAGRAFO VENDEDORA
    _cMsg += '<p align="justify">E do outro, <b>'+rtrim(sm0->m0_nomecom)+'</b>, pessoa jur韉ica de direito privado, '
    _cMsg += 'com sede � '+rtrim(sm0->m0_endcob)+', '+rtrim(sm0->m0_compcob)+', CEP: '
	_cMsg += rtrim(sm0->m0_cepcob)+', '+rtrim(sm0->m0_baircob)+', '+rtrim(sm0->m0_cidcob)+'/'+rtrim(sm0->m0_estcob)+', '
    _cMsg += 'inscrita no CNPJ/ME n� '+transform((sm0->m0_cgc),"@R 99.999.999/9999-99")+', conforme Contrato Social, '

	_cMsg += 'aqui representado por seu s骳io administrador, o <b> Sr. CLEITON PAULA DE MOURA</b>, '
    _cMsg += 'brasileiro, empres醨io, solteiro, inscrito na c閐ula de identidade n� 5151277 2� Via SSP/GO e no CPF/ME '
    _cMsg += 'sob o n� 035.566.211-69, sendo encontrado na sede da empresa, doravante denominada <b>LOCADORA</b>.</p>'
     
    _cMsg += '<p align="justify">T阭 entre si justo e contratado o presente Instrumento Particular de Contrato de Loca玢o '
    _cMsg += 'de Equipamentos, que se reger� de acordo com as cl醬sulas adiante estabelecidas: </p>'

    //CL罸SULA 1
    _cMsg += '<b><p align="justify">CL罸SULA 1. DO OBJETO </p></b>'
	
    IF TMP1->CN9_PROP == ""  
        nProp = '<b style="color:red">N鉶 Informado</b>'
    ELSE
        nProp = '<b>'+TMP1->CN9_PROP+'</b>'
    ENDIF 

    _cMsg += '<p align="justify">A LOCADORA � leg韙ima e exclusiva propriet醨ia e possuidora, livre de 鬾us, '
    _cMsg += 'pend阯cias ou lit韌ios, dos bens m髒eis descritos e caracterizados, nas quantidades e especifica珲es '
    _cMsg += 'indicadas abaixo, bem como na proposta N.: '+nProp+', parte integrante do presente instrumento.</p>'
	
     Geratmp2()
     _cMsg += '<table class="dados_produtos">'
     _cMsg += '<thead>'
     _cMsg += '<th align="center"><b>Descri玢o do Equipamento:</b></th>'
     _cMsg += '<th align="center"><b>Quantidade:</b></th>'
     _cMsg += '</thead>'
     _cMsg += '<tbody>'
     
    //Local para descrever os itens -> Isso na Planilha dentro do contrato. 15/03/2022 Val(M->F1_DOC)
    DO WHILE TMP2->(!EOF())
       	_cMsg += '<tr><td>'+alltrim(TMP2->CNB_PRODUT)+' - '+TMP2->CNB_DESCRI+'</td>'
		_cMsg += '<td align="right">'+alltrim(cvaltochar(TMP2->CNB_QUANT))+'</td></tr>
    	TMP2->(dbskip())
    EndDo 
    _cMsg += '</tbody>'
    _cMsg += '</table>'
    //Local para descrever os itens -> Isso na Planilha dentro do contrato. 15/03/2022
     

    //Tipo de Opera玢o  1 - Continua; 2 - Prime; 3 - Stand By 
    IF TMP1->CN9_TPOP == ""
        tpop := '<b style="color:red">NAO INFORMADO</b>'
    ELSEIF TMP1->CN9_TPOP == "1"
        tpop := '<b>Cont韓ua</b>'
    ELSEIF TMP1->CN9_TPOP == "2"
        tpop := '<b>Prime</b>'
    ELSE
        tpop := '<b>Stand By</b>'
    ENDIF

	  
     //Quem vai realizar a instala玢o
     IF rtrim(TMP1->CN9_RMANU) == ""
          rManu = '<b style="color:red">N肙 INFORMAR</b>'
     ELSEIF rtrim(TMP1->CN9_RINST) == "1"
          rManu = '<b>LOCADORA</b>'
     ELSE
          rManu = '<b>LOCAT罵IO (A)</b>'
     ENDIF
	 
     //Quem vai realizar a instala玢o
     IF rtrim(TMP1->CN9_RINST) == ""
          rInst = '<b style="color:red">N肙 INFORMAR</b>'
     ELSEIF rtrim(TMP1->CN9_RINST) == "1"
          rInst = '<b>LOCADORA</b>'
     ELSE
          rInst = '<b>LOCAT罵IO (A)</b>'
     ENDIF

    _cMsg += '<p align="justify">1.1.	O (s) grupo (s) gerador (es) acima ser� (鉶) contratado (s) para opera玢o '+tpop+', com franquia de '+TMP1->CN9_FRANQUIA+' horas por m阺.</p>'

	IF TMP1->CN9_TPOP <> "1"
     _cMsg += '<p align="justify">1.2.	Caso a utiliza玢o do(s) grupo(s) gerador(es) ultrapasse a franquia acima, ser鉶 cobrados horas excedentes conforme a seguir:</p>'

     _cMsg += '<p align="justify">R$ '+AllTrim(Transform(TMP1->CN9_EXFRAN,"@ze 999,999,999,999.99"))+' por hora excedente.</p>'
	 
     _cMsg += '<p align="justify">1.3.	A manuten玢o preventiva e corretiva do (s) equipamento (s) descrito acima dever� ser realizada pela '+rManu+', por t閏nicos pr髉rios ou contratados, incluindo pe鏰s necess醨ias para as manuten珲es. </p>'

     _cMsg += '<p align="justify">1.4.	A instala玢o e desinstala玢o do (s) equipamento (s) descrito (s) acima, considerando servi鏾s e materiais ser� realizada pela '+rInst+'. </p>'

	ELSE
     _cMsg += '<p align="justify">1.2.	A manuten玢o preventiva e corretiva do (s) equipamento (s) descrito acima dever� ser realizada pela '+rManu+', por t閏nicos pr髉rios ou contratados, incluindo pe鏰s necess醨ias para as manuten珲es. </p>'

     _cMsg += '<p align="justify">1.3.	A instala玢o e desinstala玢o do (s) equipamento (s) descrito (s) acima, considerando servi鏾s e materiais ser� realizada pela '+rInst+'. </p>'

	ENDIF
   

     //CL罸SULA 2
     Geratmp2()
     _cMsg += '<b><p align="justify">CL罸SULA 2 - PRECO E CONDI钦ES DE PAGAMENTO</p></b>'
     _cMsg += '<p align="justify">2.1. O valor mensal do presente contrato de loca玢o ser� conforme o descrito a seguir:</p> '     
     _cMsg += '<table class="dados_produtos">'
     _cMsg += '<thead>'
     _cMsg += '<th align="center"><b>Descri玢o do Equipamento:</b></th>'
     _cMsg += '<th align="center"><b>Quantidade:</b></th>'
     _cMsg += '<th align="center"><b>Valor Unit:</b></th>'
     _cMsg += '<th align="center"><b>Total Item:</b></th>'
     _cMsg += '</thead>'
     _cMsg += '<tbody>'
     
    //Local para descrever os itens -> Isso na Planilha dentro do contrato. 17/03/2022
    vTotPrd := 0
    DO WHILE TMP2->(!EOF())
        _cMsg += '<tr>'
		_cMsg += '<td>'+alltrim(TMP2->CNB_PRODUT)+' - '+TMP2->CNB_DESCRI+'</td>'
		_cMsg += '<td align="right">'+alltrim(cvaltochar(TMP2->CNB_QUANT))+'</td>'
		_cMsg += '<td align="right">R$ '+AllTrim(Transform(TMP2->CNB_VLUNIT,"@ze 999,999,999,999.99"))+'</td>'
		_cMsg += '<td align="right">R$ '+AllTrim(Transform(TMP2->CNB_VLUNIT*TMP2->CNB_QUANT,"@ze 999,999,999,999.99"))+'</td>'
		_cMsg += '</tr>'
        vTotPrd := vTotPrd + TMP2->CNB_VLUNIT*TMP2->CNB_QUANT
        TMP2->(dbskip())
    EndDo 
    _cMsg += '<tr><td colspan="3"><b>TOTAL:</b></td><td>R$ '+Transform(vTotPrd,"@ze 999,999,999,999.99")+'</td></tr>'
    _cMsg += '</tbody>'
    _cMsg += '</table>'
    _cMsg += '<p align="justify">2.2. O reajuste do valor descrito no item 2.1 ser� de acordo com o 韓dice de reajuste IGPM (positivo) ou em sua aus阯cia, outro que o substitua, ap髎 o prazo de 12 (doze) meses de loca玢o.</p> '
    _cMsg += '<p align="justify">2.3. Todos e quaisquer tributos e contribui珲es que incidam ou venham a incidir sobre o objeto do presente contrato, s鉶 de inteira responsabilidade do contribuinte como tal definido na norma tribut醨ia, sem direito a reembolso.</p> ' 
    _cMsg += '<p align="justify">2.4. Servir鉶 como comprovante, a autentica玢o mec鈔ica no boleto, quando da efetiva玢o do pagamento em favor da <b>LOCADORA</b>.</p> ' 
    _cMsg += '<p align="justify">2.5. Todos os pagamentos ser鉶 realizados por meio de boleto banc醨io.</p> ' 
    
	/* IF rtrim(cFilAnt) == "1001"

    _cMsg += '<p align="justify">2.6.  A LOCADORA, desde j� autoriza o (a) LOCAT罵IO (A), '
    _cMsg += 'a realizar os pagamentos das notas fiscais faturadas contra sua unidade rural, '
	_cMsg += 'referentes ao presente instrumento contratual, em conta de terceiro, '
    _cMsg += 'atrav閟 de transfer阯cia banc醨ia, conforme os seguintes dados abaixo relacionados:</p>'

    _cMsg += '<p align="justify">Banco:	Ita�</p>'
    _cMsg += '<p align="justify">Ag阯cia:	0208</p>'
    _cMsg += '<p align="justify">Conta Corrente:	77500-7</p>'
    _cMsg += '<p align="justify">CNPJ vinculado � Conta:	41.246.890/0001-01</p>'
    _cMsg += '<p align="justify">Raz鉶 social da titular:	RENTAL PART LTDA</p>'

    _cMsg += '<p align="justify">2.7. A LOCADORA, por meio do presente instrumento contratual, '
	_cMsg += 'declara estar ciente de que todos os pagamentos ser鉶 enviados para os dados banc醨ios '
    _cMsg += 'mencionados na cl醬sula anterior e que qualquer altera玢o acerca de tal autoriza玢o, '
    _cMsg += 'ser� previamente comunicada ao (�) LOCAT罵IO (A), atrav閟 do e-mail: '+rtrim(SU5->U5_EMAIL)+'</p>'

	ENDIF */
     //CL罸SULA 3
    _cMsg += '<b><p align="justify">CL罸SULA 3 - PRAZO DA LOCA敲O.</p></b>'
	

	//Ravilla mandou por email(marlon.pablo@brggeradores.com.br) 
	//no dia 17/08/2022 Favor retificar a cl醬sula 3.1 do contrato tipo 003 (Loca玢o) no TOTVS, 
	//para que passe a ter a seguinte reda玢o fixa:

	_cMsg += '3.1	A loca玢o objeto do presente instrumento contratual vigorar� por prazo indeterminado, sendo que, caso o (a) '
	_cMsg += 'LOCAT罵IO (A), solicite o encerramento da loca玢o, observado o prazo indicado na cl醬sula 6.1, a LOCADORA enviar� '
	_cMsg += 'um e-mail com a confirma玢o da data do encerramento da vig阯cia, que se dar� com a efetiva retirada do (s) equipamento '
	_cMsg += '(s), ou entrega in loco, para fins de faturamento da 鷏tima cobran鏰.'

    //Validando vigencia do contrato 
    /*
	 IF TMP1->CN9_UNVIGE == "4"
          vPeri := 'por prazo Indeterminado'
     ELSE 
          vPeri := 'pelo per韔do de '+cValToChar(STOD(TMP1->CN9_DTINIC))+' � '+cValToChar(STOD(TMP1->CN9_DTFIM))
     ENDIF
     _cMsg += '<p align="justify">3.1	O prazo da loca玢o ser� '+vPeri+'.</p>'
	*/
     _cMsg += '<b><p align="justify">CL罸SULA 4 - DO FRETE:</p></b>'
	
     //Resposnsabilidade do frete
     IF TMP1->CN9_FRETE == "C"
          vFrete := '<b>LOCADORA</b>'
     ELSEIF TMP1->CN9_FRETE == "F"
          vFrete := '<b>LOCAT罵IO</b>'
     ELSE
          vFrete := '<b style="color: red">N肙 INFORMADO</b>'
     ENDIF
     _cMsg += '<p align="justify">4.1. Despesas relacionadas ao transporte dos equipamentos de IDA e VOLTA ser鉶 de responsabilidade do (a) '+vFrete
     _cMsg += '<p align="justify">4.2 O equipamento dever� ser vistoriado pela <b>LOCAT罵IO (A)</b>, antes ou no momento da entrega do equipamento, sob pena de se presumir que o mesmo se encontra sem nenhum v韈io aparente, e estando em perfeito estado de fabrica玢o.</p>'

     _cMsg += '<b><p align="justify">CL罸SULA 5 - DAS PENALIDADES</p></b>'
     _cMsg += '<p align="justify">5.1. Em caso de ocorrer atraso no pagamento de alguma parcela devida, incidir� sobre a respectiva parcela multa de 5% (cinco por cento) ao m阺, juros morat髍ios de 1% (dois por cento) ao m阺 pro rata die e corre玢o monet醨ia pelo 韓dice IGPM, desde o vencimento at� a data do efetivo pagamento.</p>'
     _cMsg += '<p align="justify">5.2	N鉶 ser鉶 imputados � responsabilidade da <b>LOCADORA</b> os atrasos porventura ocorridos em raz鉶 de caso fortuito ou de for鏰 maior e de outros motivos fora do controle daquela, inclusive daqueles decorrentes de descumprimento e/ou irregularidade no cumprimento de quaisquer das obriga珲es do <b>LOCAT罵IO</b>.</p>'

     _cMsg += '<b><p align="justify">CL罸SULA 6 - DA RESCIS肙</p></b>'

     _cMsg += '<p align="justify">6.1 O presente Contrato poder� ser rescindido mediante notifica玢o pr関ia de no m韓imo 30 (Trinta) dias.</p>'

     _cMsg += '<p align="justify">6.2. Sem preju韟o das demais disposi珲es contidas neste instrumento, este contrato, tamb閙 se rescinde, de pleno direito e independentemente de qualquer formalidade judicial ou extrajudicial, oportunizando � LOCADORA a retirada imediata do equipamento locado, ocorrendo uma das seguintes hip髏eses:</p>'

     _cMsg += '<p align="justify">a) Atraso nos pagamentos por mais de 30 (trinta) dias corridos;</p>'
     _cMsg += '<p align="justify">b) Por infra玢o a qualquer de suas cl醬sulas e condi珲es, por qualquer das partes;</p>'
     _cMsg += '<p align="justify">c) Por Recupera玢o Judicial ou Extrajudicial, Fal阯cia, Liquida玢o ou Dissolu玢o de qualquer das partes.</p>'

     _cMsg += '<p align="justify">6.3. Eventual recusa da devolu玢o do equipamento ou dano nele produzido obriga o (a) <b>LOCAT罵IO (A)</b>, ainda, ao ressarcimento pelos danos e lucros cessantes, estes pelo per韔do em que o equipamento deixar de ser utilizado pela <b>LOCADORA</b>.</p>'


     _cMsg += '<b><p align="justify">CL罸SULA 7 - OBRIGA钦ES E DIREITO DO (A) LOCAT罵IO (A)</p></b>'

     _cMsg += '<p align="justify">7.1	O (A) <b>LOCAT罵IO (A)</b> ter� direito de plena utiliza玢o do equipamento, a partir da data da sua instala玢o, obrigando-se a:</p>'
     _cMsg += '<p align="justify">a)	Usar o equipamento corretamente e mant�-lo em perfeitas condi珲es de estado e de funcionamento, conforme lhe foi entregue no in韈io da vig阯cia deste contrato;</p>'
     _cMsg += '<p align="justify">b)	N鉶 introduzir modifica珲es de qualquer natureza no equipamento, enquanto perdurar a vig阯cia do contrato;</p>'
     _cMsg += '<p align="justify">c)	Defender e fazer valer todos os direitos de propriedade e de posse da <b>LOCADORA</b> sobre o equipamento, inclusive impedindo sua penhora, sequestro, arresto, arrecada玢o, etc., por terceiros, notificando-os sobre os direitos de propriedade e de posse da <b>LOCADORA</b> sobre o objeto da rela玢o contratual;</p>'
     _cMsg += '<p align="justify">d)	Comunicar imediatamente � <b>LOCADORA</b> qualquer interven玢o ou viola玢o por terceiros de qualquer dos seus direitos em rela玢o ao equipamento; e</p>'
     _cMsg += '<p align="justify">e)	Responsabilizar-se por qualquer dano ao equipamento.</p>'
     _cMsg += '<p align="justify">7.2. Quaisquer despesas decorrentes de eventual mudan鏰 de local, inclusive, mas n鉶 exclusivamente, transporte, montagem, coloca玢o do equipamento no novo local indicado e novas instala珲es el閠ricas, correm por conta exclusiva do (a) <b>LOCAT罵IO (A)</b>.</p>'
     //Valida responsavel pelo abastecimento

     IF TMP1->CN9_RABAST == "1"
          rAbast := '<b>LOCADORA</b>'
     ELSE
          rAbast := '<b>LOCAT罵IO</b>'
     ENDIF
     
     _cMsg += '<p align="justify"><b>Par醙rafo 鷑ico:</b> O abastecimento dos grupos geradores, com 髄eo diesel, ser� de inteira responsabilidade do (a) '+rAbast+', sendo esse (a) respons醰el pela escolha da distribuidora, pelos pagamentos, acertos financeiros e log韘ticos.</p>'

     //cTxtLinha := " "
   
   	DbSelectArea("ZCL")
     DbSetOrder(2)  
     dbSeek(xFilial("ZCL")+TMP1->CN9_TPCTO)
     _Doc := ZCL->ZCL_TIPOCO
     DO WHILE ! EOF() .AND. ZCL->ZCL_FILIAL = xFilial("ZCL") .AND. ZCL->ZCL_TIPOCO == _Doc   
          cTxtLinha := " "                                                                
          _cMsg += '<b align="left">CL罸SULA '+alltrim(CVALTOCHAR(ZCL->ZCL_CLAUSU))+'. '+ZCL->ZCL_TITULO+'</b> <br />'
    
          nLinhas := MLCount(ZCL->ZCL_TEXTO,140)    
          For nXi:= 1 To nLinhas
               cTxtLinha += MemoLine(ZCL->ZCL_TEXTO,140,nXi)        
          Next nXi
          _teste := StrTran( cTxtLinha, "<", "<p align='justify'>" )  
          _teste1 :=StrTran( _teste, ">", "</p>" ) 
          _cMsg += _teste1    
   	   ZCL->(dbskip())   	   
    EndDo
    
    
    _cMsg += '<div id="assinaturas">'
    _cMsg += '<p align="right">'+rtrim(sm0->m0_cidcob)+', '+str(day(stod(TMP1->CN9_DTINIC)),2)+' de '+mesextenso(month(stod(TMP1->CN9_DTINIC)),2)+ ' de '+str(year(stod(TMP1->CN9_DTINIC)),4)+ '</p>'    
    
    _cMsg += '<table>'
    _cMsg += '<tr>'
    _cMsg += '<td><align="left"><font face="Doppio One" size="2"> LOCADORA</font></td>' 
    _cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>' 
    _cMsg += '<td><align="left"><font face="Doppio One" size="2"> LOCAT罵IO (A)</font></td>'   
    _cMsg += '</tr>'
    _cMsg += '<tr>'
    _cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>' 
    _cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>' 
    _cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'   
    _cMsg += '</tr>'
    _cMsg += '<tr>'  
    _cMsg += '<td><align="left" class="1"><font face="Doppio One" size="2">'+rtrim(sm0->m0_nomecom)+'</font> </td>'
    _cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>' 
    _cMsg += '<td><align="left" class="2"><font face="Doppio One" size="2">'+rtrim(TMP1->A1_NOME)+'</font> </td>'
    _cMsg += '</tr>' 
    _cMsg += '<tr>'    
     IF TMP1->A1_PESSOA == "J"
          _cMsg += '<td><align="left" class="4"><font face="Doppio One" size="2">'+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')+'</font> </td>'
          _cMsg += '<td></td>'
          _cMsg += '<td><align="left" class="3"><font face="Doppio One" size="2">'+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')+'</font> </td>'
     ELSE
          _cMsg += '<td><align="left" class="4"><font face="Doppio One" size="2">'+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')+'</font> </td>'
          _cMsg += '<td></td>'
          _cMsg += '<td><align="left" class="3"><font face="Doppio One" size="2">'+transform((TMP1->A1_CGC),'@R 999.999.999-99')+'</font> </td>'
     ENDIF    
    _cMsg += '</tr>' 
    _cMsg += '<tr>'
    _cMsg += '<td></td>' 
    _cMsg += '<tr>' 
    _cMsg += '<tr>'
    _cMsg += '<td><align="left"><font face="Doppio One" size="2"> TESTEMUNHAS</font></td>' 
    _cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>' 
    _cMsg += '<td><align="left"><font face="Doppio One" size="2"></td>'   
    _cMsg += '</tr>'
    _cMsg += '</tr>'
    _cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>' 
    _cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>' 
    _cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'   
    _cMsg += '</tr>'
    _cMsg += '<tr>'
    _cMsg += '<td><align="left"><font face="Doppio One" size="2"> CPF:</font></td>'
    _cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>' 
    _cMsg += '<td><align="left"><font face="Doppio One" size="2">  CPF:</font></td>'
    _cMsg += '</tr>' 
    _cMsg += '</table>'
    _cMsg += '</div>'
    _cMsg += '</body>'
    _cMsg += '</html>'	
	
	_carquivo:="C:\WINDOWS\TEMP\"+rtrim(TMP1->CN9_NUMERO)+".HTML"     
	nHdl := fCreate(_carquivo)
	fWrite(nHdl,_cMsg,Len(_cMsg))
	fClose(nHdl)
	ExecArq(_carquivo)

	set device to screen

	ms_flush()

return


//???????????????????????????????????????????????????????????????????????????
static function para_texto(xtoconv)
//???????????????????????????????????????????????????????????????????????????
	if valtype(xtoconv) == "U"
		cnewtxt	:= ""
	elseif valtype(xtoconv) == "D"
		cnewtxt	:= substr(dtos(xtoconv),7,2)+"/"+substr(dtos(xtoconv),5,2)+"/"+substr(dtos(xtoconv),1,4)
	elseif valtype(xtoconv) == "N"
		cnewtxt	:= alltrim(str(xtoconv))
	else
		cnewtxt	:= alltrim(xtoconv)
	endif
return cnewtxt

//???????????????????????????????????????????????????????????????????????????
static function implinha(clinha)
//???????????????????????????????????????????????????????????????????????????
	fwrite(_nhandle,clinha+chr(13)+chr(10))
return

//???????????????????????????????????????????????????????????????????????????
Static Function Geratmp1()
//???????????????????????????????????????????????????????????????????????????

	If Select("TMP1") > 0
		TMP1->(dbCloseArea())
	EndIf
	cquery := " "
	cquery += "SELECT * "
	cquery += "FROM " + retsqlname("CNC")+" CNC "
	cquery += "INNER JOIN " + retsqlname("CN9") + " CN9 ON  CNC_FILIAL = CN9_FILIAL AND CNC_NUMERO = CN9_NUMERO AND CN9.D_E_L_E_T_ <> '*' "
	cquery += "INNER JOIN " + retsqlname("SA1") + " SA1 ON  CNC_CLIENT = A1_COD AND CNC_LOJACL = A1_LOJA AND SA1.D_E_L_E_T_ <> '*' "
	cquery += "INNER JOIN " + retsqlname("AC8") + " AC8 ON  CNC_CLIENT + CNC_LOJACL = AC8_CODENT AND AC8.D_E_L_E_T_ <> '*' "
	cquery += "WHERE CNC.D_E_L_E_T_ <> '*' "
	cquery += "AND CNC_NUMERO = '" + CN9->CN9_NUMERO + "' "

	cquery	:= changequery(cquery)
	tcquery cquery new alias "TMP1"

Return

//***********************************************************************
Static Function ExecArq(_carquivo)
//***********************************************************************
	LOCAL cDrive := ""
	LOCAL cDir := ""
	LOCAL cPathFile := ""
	LOCAL cCompl := ""
	LOCAL nRet := 0



     //?Retira a ultima barra invertida ( se houver )
	cPathFile := _carquivo

	SplitPath(cPathFile, @cDrive, @cDir )
	cDir := Alltrim(cDrive) + Alltrim(cDir)

//?Faz a chamada do aplicativo associado ?
	nRet := ShellExecute( "Open", cPathFile,"",cDir, 1)

	If nRet <= 32
		cCompl := ""
		If nRet == 31
			cCompl := " Nao existe aplicativo associado a este tipo de arquivo!"
		EndIf
		Aviso( "Atencao !", "Nao foi possivel abrir o objeto '" + AllTrim(cPathFile) + "'!" + cCompl, { "Ok" }, 2 )
	EndIf

Return

//Retorna os Itens da Planilha
//???????????????????????????????????????????????????????????????????????????
Static Function Geratmp2()
//???????????????????????????????????????????????????????????????????????????

	If Select("TMP2") > 0
		TMP2->(dbCloseArea())
	EndIf
	cquery := " "
	cquery += "SELECT * "
	cquery += "FROM " + retsqlname("CNB")+" CNB "
	cquery += "WHERE CNB.D_E_L_E_T_ <> '*' "
	cquery += "AND CNB_FILIAL = '"+xFilial("CNB")+"' "
	cquery += "AND CNB_CONTRA = '" + _Contr + "' "

	cquery	:= changequery(cquery)
	tcquery cquery new alias "TMP2"

Return

//??????????????????????????????????????????????????????????????????????????????????????
Static Function GeraX1()
//??????????????????????????????????????????????????????????????????????????????????????
	Local _sAlias
	Local j   := 1
	Local i   := 1
	_sAlias := Alias()
	aRegs	:= {}
	dbSelectArea ("SX1")
	dbSetOrder (1)

	AADD(aRegs,{cperg,"01","Emissao De?"		,"","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"02","Emissao Ate?"		,"","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"03","Vencimento De?"		,"","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"04","Vencimento Ate?"	,"","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"05","Forncedor?"			,"","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})

	for i:=1 to len(aRegs)
		if !dbseek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			for j := 1 to fcount()
				if j <= len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				endif
			next
			MsUnlock()
		endif
	next
	dbSelectArea(_sAlias)

Return
