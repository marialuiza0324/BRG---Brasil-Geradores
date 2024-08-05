/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FSGCT001  ³ Autor ³ Marlon Pablo³ 	  Data ³ 27/05/2022     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcção que será chamado quando o Tipo do Contrato for 003 ³±±
±±³          ³ na filial 1001 - Agrogera                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para BRG                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#INCLUDE "topconn.ch"

//???????????????????????????????????????????????????????????????????????????

User Function FSGCT002()
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

	// VALIDAÇÃO INCRIÇÃO ESTADUAL INICIO 15/03/2022
	IF TMP1->A1_INSCR=="ISENTO"
		Inscr = TMP1->A1_INSCR
	ELSEIF empty(TMP1->A1_INSCR)
		Inscr = "Não Informado"
	ELSE
		Inscr = transform((TMP1->A1_INSCR),'@R 999999999.99-99')
	ENDIF
	// VALIDAÇÃO INCRIÇÃO ESTADUAL FIM 15/03/2022


	//VALIDACAO PARA CAMPO EM BRANCO - INICIO 10/09/2019
	Do Case
	Case empty(SU5->U5_NACIONA)
		MSGINFO("Preencher Nacionalidade do Contato !!!!!"," Atenção ")
		Return
	Case empty(SU5->U5_FUNCAO)
		MSGINFO("Preencher a Profissão do Contato !!!!!"," Atenção ")
		Return
	Case empty(SU5->U5_END)
		MSGINFO("Preencher o Endereço do Contato !!!!!"," Atenção ")
		Return
	Case empty(SU5->U5_BAIRRO)
		MSGINFO("Preencher o Bairro do Contato !!!!!"," Atenção ")
		Return
	Case empty(SU5->U5_CEP)
		MSGINFO("Preencher o Cep do Contato !!!!!"," Atenção ")
		Return
	Case empty(SU5->U5_CPF)
		MSGINFO("Preencher o CPF do Contato !!!!!"," Atenção ")
		Return
	Case empty(SU5->U5_CONTAT)
		MSGINFO("Preencher o Nome do Contato !!!!!"," Atenção ")
		Return
	Case empty(SU5->U5_EMAIL)
		MSGINFO("Preencher o e-MAIL do Contato !!!!!"," Atenção ")
		Return
	EndCase
	//VALIDAÇÃO PARA CAMPO EM BRANCO - FIM 10/09/2019
     Geratmp1()
     
	_cTpCon := Posicione("CN1",1,xFilial("CN1")+TMP1->CN9_TPCTO,"CN1_DESC2")
	//_cTpCon :=  "CONTRATO DE VENDA DE ENERGIA ELÉTRICA DE CURTO PRAZO"   
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
     _cMsg += '    padding-bottom: 0.5cm; /*Ravylla falou que nao tem importancia esse bloco que da um espaçamento de 0.5 cm entre cada elementro da impressão. Ganhou 1,3mm entre a ultima linha de cada pagina e o rodapé*/'
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

   	_cMsg += '<img src="http://brggeradores.com.br/vendas/LogoGrid.PNG" height="120" width="118"  >'//</td>'        
	_cMsg += '<b><p align="right"> Contrato n. '+rtrim(TMP1->CN9_NUMERO)+'/'+cvaltochar(Year(STOD(TMP1->CN9_DTINIC)))+'</b> <br /> </p>'   //Year(STOD(TMP1->CN9_NUMERO))
   	_cMsg += '<b align="left">'+_cTpCon+'</b> <br />'

   	_cMsg += '<h2>CONTRATO DE LOCAÇÃO</h2>' 
 
     //PARAGRAFO COMPRADOR  (venda de Gerador)
     _cMsg += '<p align="left">Pelo presente instrumento particular, as Partes a seguir qualificadas, de um lado, </p>'

     If TMP1->A1_PESSOA = "F" .AND. TMP1->A1_TIPO = "L"
          //PRODUTOR RURAL:
          _cMsg += '<p align="justify"><b>'+rtrim(TMP1->A1_NOME)+'</b>, nacionalidade: '+rtrim(SU5->U5_NACIONA)+', estado civil: '+rtrim(EstCiv)+', residente e domiciliado à ' +rtrim(SU5->U5_END)+', '+rtrim(SU5->U5_BAIRRO)+', CEP '+rtrim(SU5->U5_CEP)+', na cidade de '+rtrim(SU5->U5_MUN)+' - '+SU5->U5_EST+', inscrito no CPF/ME de n. '+transform((SU5->U5_CPF),'@R 999.999.999-99')+', produtor rural na <b>'+rtrim(TMP1->A1_NREDUZ)+'</b>, inscrição estadual nº '+Inscr+', localizada na '+rtrim(TMP1->A1_END)+', doravante designada simplesmente de <b>LOCATÁRIO (A)</b>.</p>'

     ELSEIF TMP1->A1_PESSOA = "J"
          //PJ:
          _cMsg += '<p align="justify"><b>'+rtrim(TMP1->A1_NOME)+'</b>, pessoa jurídica de direito privado, nome fantasia <b>'+rtrim(TMP1->A1_NREDUZ)+'</b>, inscrita no CNPJ (ME) sob o nº. '+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')+', Inscrição Estadual N. '+rtrim(TMP1->A1_INSCR)+', endereço na ' +rtrim(TMP1->A1_END)+', '+rtrim(TMP1->A1_BAIRRO)+', Cep '+transform((TMP1->A1_CEP),'@R 99999-999')+' na cidade de '+rtrim(TMP1->A1_MUN)+' - '+TMP1->A1_EST+' através de seu representante legal, S.r.(a) '+rtrim(SU5->U5_CONTAT)+', nacionalidade: '+rtrim(SU5->U5_NACIONA)+', estado civil: '+rtrim(EstCiv)+', profissão: '+rtrim(_cFunc)+', residente e domiciliado à '+rtrim(SU5->U5_END)+', '+rtrim(SU5->U5_BAIRRO)+', CEP '+rtrim(SU5->U5_CEP)+', na cidade de '+rtrim(SU5->U5_MUN)+' - '+SU5->U5_EST+', inscrito no CPF/ME de n. '+transform((SU5->U5_CPF),'@R 999.999.999-99')+', doravante designada simplesmente de <b>LOCATÁRIO (A)</b>.</p>'
         

     ELSEIF TMP1->A1_PESSOA = "F"
          //PF:
          _cMsg += '<p align="justify"><b>'+rtrim(TMP1->A1_NOME)+'</b>, nacionalidade: '+rtrim(SU5->U5_NACIONA)+', estado civil: '+rtrim(EstCiv)+', profissão: '+rtrim(_cFunc)+', residente e domiciliado à ' +rtrim(SU5->U5_END)+', '+rtrim(SU5->U5_BAIRRO)+', CEP '+rtrim(SU5->U5_CEP)+', na cidade de '+rtrim(SU5->U5_MUN)+' - '+SU5->U5_EST+', inscrito no CPF/ME de n. '+transform((SU5->U5_CPF),'@R 999.999.999-99')+', doravante designada simplesmente de <b>LOCATÁRIO (A)</b>.</p>'     
     ENDIF                                 
     
    //PARAGRAFO VENDEDORA
     _cMsg += '<p align="justify">E do outro, <b>'+rtrim(sm0->m0_nomecom)+'</b>, pessoa jurídica de direito privado, '
     _cMsg += 'com sede à '+rtrim(sm0->m0_endcob)+', '+rtrim(sm0->m0_compcob)+', CEP: '
	_cMsg += rtrim(sm0->m0_cepcob)+', '+rtrim(sm0->m0_baircob)+', '+rtrim(sm0->m0_cidcob)+'/'+rtrim(sm0->m0_estcob)+', '
     _cMsg += 'inscrita no CNPJ/ME nº '+transform((sm0->m0_cgc),"@R 99.999.999/9999-99")+', conforme Contrato Social, '

     _cMsg += 'aqui representado por seu sócio administrador, o <b> Sr. SILVIO HENRIQUE CRISPIM OLIVEIRA</b>, '
     _cMsg += 'brasileiro, empresário, solteiro, inscrito na cédula de identidade nº 5151277 2ª Via SSP/GO e no CPF/ME '
     _cMsg += 'sob o n° 035.566.211-69, sendo encontrado na sede da empresa, doravante denominada <b>LOCADORA</b>.</p>'
     
     _cMsg += '<p align="justify">Têm entre si justo e contratado o presente Instrumento Particular de Contrato de Locação '
     _cMsg += 'de Equipamentos, que se regerá de acordo com as cláusulas adiante estabelecidas: </p>'

    //CLÁUSULA 1
    _cMsg += '<b><p align="justify">CLÁUSULA 1. DO OBJETO </p></b>'
	
    IF TMP1->CN9_PROP == ""  
        nProp = '<b style="color:red">Não Informado</b>'
    ELSE
        nProp = '<b>'+TMP1->CN9_PROP+'</b>'
    ENDIF 

    _cMsg += '<p align="justify">A LOCADORA é legítima e exclusiva proprietária e possuidora, livre de ônus, '
    _cMsg += 'pendências ou litígios, dos bens móveis descritos e caracterizados, nas quantidades e especificações '
    _cMsg += 'indicadas abaixo, bem como na proposta N.: '+nProp+', parte integrante do presente instrumento.</p>'
	
     Geratmp2()
     _cMsg += '<table class="dados_produtos">'
     _cMsg += '<thead>'
     _cMsg += '<th align="center"><b>Descrição do Equipamento:</b></th>'
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
     

    //Tipo de Operação  1 - Continua; 2 - Prime; 3 - Stand By 
    IF TMP1->CN9_TPOP == ""
        tpop := '<b style="color:red">NAO INFORMADO</b>'
    ELSEIF TMP1->CN9_TPOP == "1"
        tpop := '<b>Contínua</b>'
    ELSEIF TMP1->CN9_TPOP == "2"
        tpop := '<b>Prime</b>'
    ELSE
        tpop := '<b>Stand By</b>'
    ENDIF

	  
     //Quem vai realizar a instalação
     IF rtrim(TMP1->CN9_RMANU) == ""
          rManu = '<b style="color:red">NÃO INFORMAR</b>'
     ELSEIF rtrim(TMP1->CN9_RINST) == "1"
          rManu = '<b>LOCADORA</b>'
     ELSE
          rManu = '<b>LOCATÁRIO (A)</b>'
     ENDIF
	 
     //Quem vai realizar a instalação
     IF rtrim(TMP1->CN9_RINST) == ""
          rInst = '<b style="color:red">NÃO INFORMAR</b>'
     ELSEIF rtrim(TMP1->CN9_RINST) == "1"
          rInst = '<b>LOCADORA</b>'
     ELSE
          rInst = '<b>LOCATÁRIO (A)</b>'
     ENDIF

    _cMsg += '<p align="justify">1.1.	O (s) grupo (s) gerador (es) acima será (ão) contratado (s) para operação '+tpop+', com franquia de '+TMP1->CN9_FRANQUIA+' horas por mês.</p>'

	IF TMP1->CN9_TPOP <> "1"
     _cMsg += '<p align="justify">1.2.	Caso a utilização do(s) grupo(s) gerador(es) ultrapasse a franquia acima, serão cobrados horas excedentes conforme a seguir:</p>'

     _cMsg += '<p align="justify">R$ '+AllTrim(Transform(TMP1->CN9_EXFRAN,"@ze 999,999,999,999.99"))+' por hora excedente.</p>'
	 
     _cMsg += '<p align="justify">1.3.	A manutenção preventiva e corretiva do (s) equipamento (s) descrito acima deverá ser realizada pela '+rManu+', por técnicos próprios ou contratados, incluindo peças necessárias para as manutenções. </p>'

     _cMsg += '<p align="justify">1.4.	A instalação e desinstalação do (s) equipamento (s) descrito (s) acima, considerando serviços e materiais será realizada pela '+rInst+'. </p>'

	ELSE
     _cMsg += '<p align="justify">1.2.	A manutenção preventiva e corretiva do (s) equipamento (s) descrito acima deverá ser realizada pela '+rManu+', por técnicos próprios ou contratados, incluindo peças necessárias para as manutenções. </p>'

     _cMsg += '<p align="justify">1.3.	A instalação e desinstalação do (s) equipamento (s) descrito (s) acima, considerando serviços e materiais será realizada pela '+rInst+'. </p>'

	ENDIF
   

     //CLÁUSULA 2
     Geratmp2()
     _cMsg += '<b><p align="justify">CLÁUSULA 2 - PRECO E CONDIÇÕES DE PAGAMENTO</p></b>'
     _cMsg += '<p align="justify">2.1. O valor mensal do presente contrato de locação será conforme o descrito a seguir:</p> '     
     _cMsg += '<table class="dados_produtos">'
     _cMsg += '<thead>'
     _cMsg += '<th align="center"><b>Descrição do Equipamento:</b></th>'
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
    _cMsg += '<p align="justify">2.2. O reajuste do valor descrito no item 2.1 será de acordo com o índice de reajuste IGPM (positivo) ou em sua ausência, outro que o substitua, após o prazo de 12 (doze) meses de locação.</p> '
    _cMsg += '<p align="justify">2.3. Todos e quaisquer tributos e contribuições que incidam ou venham a incidir sobre o objeto do presente contrato, são de inteira responsabilidade do contribuinte como tal definido na norma tributária, sem direito a reembolso.</p> ' 
    _cMsg += '<p align="justify">2.4. Servirão como comprovante, a autenticação mecânica no boleto, quando da efetivação do pagamento em favor da <b>LOCADORA</b>.</p> ' 
    _cMsg += '<p align="justify">2.5. Todos os pagamentos serão realizados por meio de boleto bancário.</p> ' 
    
	/* IF rtrim(cFilAnt) == "1001"

    _cMsg += '<p align="justify">2.6.  A LOCADORA, desde já autoriza o (a) LOCATÁRIO (A), '
    _cMsg += 'a realizar os pagamentos das notas fiscais faturadas contra sua unidade rural, '
	_cMsg += 'referentes ao presente instrumento contratual, em conta de terceiro, '
    _cMsg += 'através de transferência bancária, conforme os seguintes dados abaixo relacionados:</p>'

    _cMsg += '<p align="justify">Banco:	Itaú</p>'
    _cMsg += '<p align="justify">Agência:	0208</p>'
    _cMsg += '<p align="justify">Conta Corrente:	77500-7</p>'
    _cMsg += '<p align="justify">CNPJ vinculado à Conta:	41.246.890/0001-01</p>'
    _cMsg += '<p align="justify">Razão social da titular:	RENTAL PART LTDA</p>'

    _cMsg += '<p align="justify">2.7. A LOCADORA, por meio do presente instrumento contratual, '
	_cMsg += 'declara estar ciente de que todos os pagamentos serão enviados para os dados bancários '
    _cMsg += 'mencionados na cláusula anterior e que qualquer alteração acerca de tal autorização, '
    _cMsg += 'será previamente comunicada ao (à) LOCATÁRIO (A), através do e-mail: '+rtrim(SU5->U5_EMAIL)+'</p>'

	ENDIF */
     //CLÁUSULA 3
    _cMsg += '<b><p align="justify">CLÁUSULA 3 - PRAZO DA LOCAÇÃO.</p></b>'
	

	//Ravilla mandou por email(marlon.pablo@brggeradores.com.br) 
	//no dia 17/08/2022 Favor retificar a cláusula 3.1 do contrato tipo 003 (Locação) no TOTVS, 
	//para que passe a ter a seguinte redação fixa:

	_cMsg += '3.1	A locação objeto do presente instrumento contratual vigorará por prazo indeterminado, sendo que, caso o (a) '
	_cMsg += 'LOCATÁRIO (A), solicite o encerramento da locação, observado o prazo indicado na cláusula 6.1, a LOCADORA confirmará a data do encerramento da vigência, '
     _cMsg += 'que se dará com a efetiva retirada do (s) equipamento (s), '
     _cMsg += 'ou entrega in loco, para fins de faturamento da última cobrança.'

    //Validando vigencia do contrato 
    /*
	 IF TMP1->CN9_UNVIGE == "4"
          vPeri := 'por prazo Indeterminado'
     ELSE 
          vPeri := 'pelo período de '+cValToChar(STOD(TMP1->CN9_DTINIC))+' à '+cValToChar(STOD(TMP1->CN9_DTFIM))
     ENDIF
     _cMsg += '<p align="justify">3.1	O prazo da locação será '+vPeri+'.</p>'
	*/
     _cMsg += '<b><p align="justify">CLÁUSULA 4 - DO FRETE:</p></b>'
	
     //Resposnsabilidade do frete
     IF TMP1->CN9_FRETE == "C"
          vFrete := '<b>LOCADORA</b>'
     ELSEIF TMP1->CN9_FRETE == "F"
          vFrete := '<b>LOCATÁRIO</b>'
     ELSE
          vFrete := '<b style="color: red">NÃO INFORMADO</b>'
     ENDIF
     _cMsg += '<p align="justify">4.1. Despesas relacionadas ao transporte dos equipamentos de IDA e VOLTA serão de responsabilidade do (a) '+vFrete
     _cMsg += '<p align="justify">4.2 O equipamento deverá ser vistoriado pela <b>LOCATÁRIO (A)</b>, antes ou no momento da entrega do equipamento, sob pena de se presumir que o mesmo se encontra sem nenhum vício aparente, e estando em perfeito estado de fabricação.</p>'

     _cMsg += '<b><p align="justify">CLÁUSULA 5 - DAS PENALIDADES</p></b>'
     _cMsg += '<p align="justify">5.1. Em caso de ocorrer atraso no pagamento de alguma parcela devida, incidirá sobre a respectiva parcela multa de 5% (cinco por cento) ao mês, juros moratórios de 1% (dois por cento) ao mês pro rata die e correção monetária pelo índice IGPM, desde o vencimento até a data do efetivo pagamento.</p>'
     _cMsg += '<p align="justify">5.2	Não serão imputados à responsabilidade da <b>LOCADORA</b> os atrasos porventura ocorridos em razão de caso fortuito ou de força maior e de outros motivos fora do controle daquela, inclusive daqueles decorrentes de descumprimento e/ou irregularidade no cumprimento de quaisquer das obrigações do <b>LOCATÁRIO</b>.</p>'

     _cMsg += '<b><p align="justify">CLÁUSULA 6 - DA RESCISÃO</p></b>'

     _cMsg += '<p align="justify">6.1 O presente Contrato poderá ser rescindido mediante notificação prévia de no mínimo 30 (Trinta) dias.</p>'

     _cMsg += '<p align="justify">6.2. Sem prejuízo das demais disposições contidas neste instrumento, este contrato, também se rescinde, de pleno direito e independentemente de qualquer formalidade judicial ou extrajudicial, oportunizando à LOCADORA a retirada imediata do equipamento locado, ocorrendo uma das seguintes hipóteses:</p>'

     _cMsg += '<p align="justify">a) Atraso nos pagamentos por mais de 30 (trinta) dias corridos;</p>'
     _cMsg += '<p align="justify">b) Por infração a qualquer de suas cláusulas e condições, por qualquer das partes;</p>'
     _cMsg += '<p align="justify">c) Por Recuperação Judicial ou Extrajudicial, Falência, Liquidação ou Dissolução de qualquer das partes.</p>'

     _cMsg += '<p align="justify">6.3. Eventual recusa da devolução do equipamento ou dano nele produzido obriga o (a) <b>LOCATÁRIO (A)</b>, ainda, ao ressarcimento pelos danos e lucros cessantes, estes pelo período em que o equipamento deixar de ser utilizado pela <b>LOCADORA</b>.</p>'


     _cMsg += '<b><p align="justify">CLÁUSULA 7 - OBRIGAÇÕES E DIREITO DO (A) LOCATÁRIO (A)</p></b>'

     _cMsg += '<p align="justify">7.1	O (A) <b>LOCATÁRIO (A)</b> terá direito de plena utilização do equipamento, a partir da data da sua instalação, obrigando-se a:</p>'
     _cMsg += '<p align="justify">a)	Usar o equipamento corretamente e mantê-lo em perfeitas condições de estado e de funcionamento, conforme lhe foi entregue no início da vigência deste contrato;</p>'
     _cMsg += '<p align="justify">b)	Não introduzir modificações de qualquer natureza no equipamento, enquanto perdurar a vigência do contrato;</p>'
     _cMsg += '<p align="justify">c)	Defender e fazer valer todos os direitos de propriedade e de posse da <b>LOCADORA</b> sobre o equipamento, inclusive impedindo sua penhora, sequestro, arresto, arrecadação, etc., por terceiros, notificando-os sobre os direitos de propriedade e de posse da <b>LOCADORA</b> sobre o objeto da relação contratual;</p>'
     _cMsg += '<p align="justify">d)	Comunicar imediatamente à <b>LOCADORA</b> qualquer intervenção ou violação por terceiros de qualquer dos seus direitos em relação ao equipamento; e</p>'
     _cMsg += '<p align="justify">e)	Responsabilizar-se por qualquer dano ao equipamento.</p>'
     _cMsg += '<p align="justify">7.2. Quaisquer despesas decorrentes de eventual mudança de local, inclusive, mas não exclusivamente, transporte, montagem, colocação do equipamento no novo local indicado e novas instalações elétricas, correm por conta exclusiva do (a) <b>LOCATÁRIO (A)</b>.</p>'
     //Valida responsavel pelo abastecimento

     IF TMP1->CN9_RABAST == "1"
          rAbast := '<b>LOCADORA</b>'
     ELSE
          rAbast := '<b>LOCATÁRIO</b>'
     ENDIF
     
     _cMsg += '<p align="justify"><b>Parágrafo único:</b> O abastecimento dos grupos geradores, com óleo diesel, será de inteira responsabilidade do (a) '+rAbast+', sendo esse (a) responsável pela escolha da distribuidora, pelos pagamentos, acertos financeiros e logísticos.</p>'

     //cTxtLinha := " "
   
   	DbSelectArea("ZCL")
     DbSetOrder(2)  
     dbSeek(xFilial("ZCL")+TMP1->CN9_TPCTO)
     _Doc := ZCL->ZCL_TIPOCO
     DO WHILE ! EOF() .AND. ZCL->ZCL_FILIAL = xFilial("ZCL") .AND. ZCL->ZCL_TIPOCO == _Doc   
          cTxtLinha := " "                                                                
          _cMsg += '<b align="left">CLÁUSULA '+alltrim(CVALTOCHAR(ZCL->ZCL_CLAUSU))+'. '+ZCL->ZCL_TITULO+'</b> <br />'
    
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
    _cMsg += '<td><align="left"><font face="Doppio One" size="2"> LOCATÁRIO (A)</font></td>'   
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
