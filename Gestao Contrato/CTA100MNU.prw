/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CTA100MNU  ³ Autor ³ Ricardo Moreira³ 	  Data ³ 30/05/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada para Imprimir o Contrato                  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para BRG                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#INCLUDE "topconn.ch"

User Function CTA100MNU()

	aadd( aRotina,{"Gera Contrato","U_CONTRATO()",0,7,0, nil} )

Return NIL

User Function Contrato()
	//MsgAlert(CValToChar(rtrim(cfilant)),"FILIAL")
	//MsgAlert(CValToChar(rtrim(CN9->CN9_TPCTO)),"TIPO")
	If CN9->CN9_TPCTO = "001"
		Cont001()
	ElseIf CN9->CN9_TPCTO = "004"
		Cont004()
	ElseIf CN9->CN9_TPCTO = "005"  //locacao de equipamento com opção de compra
		Cont005()
	ElseIf CN9->CN9_TPCTO = "006" //contrato de locação rapida
		Cont006()
	ElseIf CN9->CN9_TPCTO = "007" //contrato com reserva de dominio
		Cont007()
	ElseIf rtrim(CN9->CN9_TPCTO) = "003" .AND. rtrim(cfilant) = "1001" //Contrato de Locação
		//MsgAlert(rtrim(cfilant),"Filial")
		U_FSGCT001()
	ElseIf rtrim(CN9->CN9_TPCTO) = "003" .AND. (rtrim(cfilant) = "0501" .OR. rtrim(cfilant) = "0502" .OR. rtrim(cfilant) = "0503") //Contrato de Locação
		//MsgAlert(rtrim(cfilant),"Filial")
		U_FSGCT002()
	EndIf

//Inicio impressão de contrato 001

//???????????????????????????????????????????????????????????????????????????
Static Function Cont001()
//???????????????????????????????????????????????????????????????????????????		
	local lhainfo	:= .f.
	local ngrupo	:= 0
	local agrupo	:= {}
	local aitem		:= {}
	LOCAL nXi       := 1
	local i         := 1
	local cultnum	:= ""
	local _cTpCon   := ""
	local _cFunc    := ""
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

	_cTpCon := Posicione("CN1",1,xFilial("CN1")+TMP1->CN9_TPCTO,"CN1_DESC2")
	//cBody += "<img src ='http://'www.xxxxx.com.br/images/title.png'>"

	procregua(0)
	incproc()
	_Contr := TMP1->CN9_NUMERO

	_cMsg := ''
	_cMsg += '<html>'
	_cMsg += '<head>'
	_cMsg += '<title></title>'
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
	_cMsg += '  * {'
	_cMsg += '    padding-bottom: 0.5cm; /*Ravylla falou que nao tem importancia esse bloco que da um espaçamento de 0.5 cm entre cada elementro da impressão. Ganhou 1,3mm entre a ultima linha de cada pagina e o rodapé*/'
	_cMsg += '  }'
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
	_cMsg += '<img src="http://brggeradores.com.br/vendas/LogoMini.png" height="120" width="118" >'//</td>'
	_cMsg += '<b><p align="right"> Contrato n. '+rtrim(TMP1->CN9_NUMERO)+'/'+cvaltochar(Year(STOD(TMP1->CN9_DTINIC)))+'</b> <br /> </p>'   //Year(STOD(TMP1->CN9_NUMERO))
	_cMsg += '<b align="left">'+_cTpCon+'</b> <br />'

	//PARAGRAFO VENDEDORA
	_cMsg += '<b><p align="justify">'+rtrim(sm0->m0_nomecom)+'</b>'
	_cMsg += ', nome fantasia <b>'+rtrim(substr(sm0->m0_nomecom,1,30))+'</b>'
	_cMsg += ', pessoa jurídica de direito privado, inscrita no CNPJ (MF) sob o N. '+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')'
	_cMsg += ', localizada na ' +rtrim(sm0->m0_endcob)+', '+rtrim(sm0->m0_baircob)+ ' na cidade de '+rtrim(sm0->m0_cidcob)+' - '+sm0->m0_estcob
	_cMsg += ', através de sua representante legal Sra. Paula Cristina Crispim Oliveira Bueno, Brasileira, Casada, empresária, inscrita no CPF sob o '
	_cMsg += ' n. 016.997.101-55, residente e domiciliada na cidade de Anápolis - GO, doravante designada simplesmente de VENDEDORA.</p>'

	//PARAGRAFO COMPRADOR  (venda de Gerador)
	_cMsg += '<b><align="left">E DE OUTRO LADO</b> <br />'
	_cMsg += '<b><p align="justify">'+rtrim(TMP1->A1_NOME)+'</b>'
	If TMP1->A1_PESSOA = "F"
		_cMsg += ' pessoa física, nome fantasia ' +rtrim(TMP1->A1_NREDUZ)+', inscrita no CNPJ (MF) sob o N. '+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')'
	Else
		_cMsg += ', pessoa jurídica de direito privado, nome fantasia ' +rtrim(TMP1->A1_NREDUZ)+', inscrita no CNPJ (MF) sob o N. '+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')'
	EndIf
	_cMsg += ', Inscrição Estadual N. '+rtrim(TMP1->A1_INSCR)
	_cMsg += ', endereço na ' +rtrim(TMP1->A1_END)+', '+rtrim(TMP1->A1_BAIRRO)+', Cep '+transform((TMP1->A1_CEP),'@R 99999-999')+ ' na cidade de '+rtrim(TMP1->A1_MUN)+' - '+TMP1->A1_EST

	DbSelectArea("SU5")
	DbSetOrder(1)
	dbSeek(xFilial("SU5")+TMP1->AC8_CODCON)
	_cMsg += ', através de seu representante legal, Sr(a) '+rtrim(SU5->U5_CONTAT)
	_cMsg += ', Nacionalidade: ' +rtrim(SU5->U5_NACIONA)
	_cFunc := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")
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
	_cMsg += ', Estado Civil: ' +rtrim(EstCiv)
	_cMsg += ', Profissão: '+rtrim(_cFunc)
	_cMsg += ', residente e domiciliado à ' +rtrim(SU5->U5_END)+', '+rtrim(SU5->U5_BAIRRO)+' Cep '+transform((SU5->U5_CEP),'@R 99999-999')+ ' na cidade de '+rtrim(SU5->U5_MUN)+' - '+SU5->U5_EST
	_cMsg += ', inscrito no CPF de n. ' + transform((SU5->U5_CPF),'@R 999.999.999-99')+', doravante designada simplesmente de COMPRADORA.</p>'

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
		MSGINFO("Preencher o CPF do Contato !!!!!"," Atenção ")
		Return
	EndCase

	//VALIDAÇÃO PARA CAMPO EM BRANCO - FIM 10/09/2019


	_cMsg += '<p align="justify">As partes, acima, qualificadas têm entre si, justas e acordadas, o presente contrato de compra e venda de grupos geradores '
	_cMsg += 'equipamentos auxiliares, que se regerá pelas cláusulas e condições seguintes: </p>'
	// _cMsg += '<b><p align="center">DA UTILIZAÇÃO DA GARANTIA</b> </p>'
	//Clausula 1
	_cMsg += '<b><p align="justify">CLAUSULA 1. DO OBJETO</b></br></br>'
	_cMsg += '1.1. Constitui-se objeto deste contrato de compra e venda, o(s) produtos(s) e demais condições comerciais descritas na, '
	_cMsg += '<b>PROPOSTA N.: '+rtrim(CN9->CN9_PROP)+'</b>, parte integrante do presente instrumento. </p> ' //Colocar a Proposta '
	_cMsg += '<p align="justify">1.2.  Sendo eles: </p>'
	Geratmp2()

	DO WHILE TMP2->(!EOF())
		_cMsg += '<b align="left">'+alltrim(cvaltochar(TMP2->CNB_QUANT))+'       '+TMP2->CNB_UM+ '       '+alltrim(TMP2->CNB_PRODUT)+'/'+TMP2->CNB_DESCRI+'</b> <br />'
		TMP2->(dbskip())
	EndDo

	//Local para descrever os itens -> ISso na Planilha dentro do contrato.

	//Clausula 2
	_cMsg += '<br />'
	_cMsg += '<b align="left">CLAUSULA 2. DAS CONDIÇÕES COMERCIAIS, ASSISTENCIA TECNICA E GARANTIA</b> <br />'

	_cMsg += '<p align="justify">2.1.  Os equipamentos fornecidos pela <b>VENDEDORA</b>, à <b>COMPRADORA</b> atenderão a todas as especificações, solicitadas pela  '
	_cMsg += '<b>COMPRADORA</b>, atendendo aos padrões específicos do seu ramo de atividade e setor comercial. </p>'
	//2.1
	_cMsg += '<p align="justify">2.2.  É garantido pela <b>VENDEDORA</b> que os produtos fabricados estão de acordo com previsto na legislação brasileira, '
	_cMsg += 'pois se trata de aquisição, por parte da <b>COMPRADORA</b>, de produtos para incrementação da atividade comercial da mesma, '
	_cMsg += 'aplicando assim os dispositivos previstos no Código Civil Brasileiro. </p>'
	//2.2
	_cMsg += '<p align="justify">2.3.  A <b>VENDEDORA</b> fará a <b>ENTREGA TÉCNICA POR MEIO DO TERMO DE ACEITACÃO DE ENTREGA AO COMPRADOR</b> '
	_cMsg += 'quando do primeiro funcionamento em campo (TESTE), esse primeiro funcionamento deverá ser efetuado por um técnico credenciado, para validação da garantia '
	_cMsg += 'do equipamento, nas bases de atendimento nas cidades de <b>Anápolis - GO ou Goiânia - GO.</b></p>'
	//2.3
	_cMsg += '<p align="justify">2.4.  Para realização de entrega técnica e atendimentos em garantia, em horário comercial, as despesas de: '
	_cMsg += '<b>deslocamento, viagem, estada em hotéis ou similares, pedágios e alimentação,</b>  '
	_cMsg += 'para um raio de atendimento superior à 50 KM da base de atendimento, correrão por conta do(a) Comprador(a). </p>'
	//2.4
	_cMsg += '<p align="justify">2.5.  No que se refere a ASSISTÊNCIA TÉCNICA a <b>VENDEDORA</b> coloca a disposição da <b>COMPRADORA</b>, nas cidades de Anápolis - GO e '
	_cMsg += 'Goiânia - GO,  uma equipa técnica especializada com treinamento na fábrica e peças sobressalentes para toda a linha de equipamentos. </p>'
	//2.5
	_cMsg += '<p align="justify">2.6.  Após a validação e entrega técnica e início da primeira partida do(s) equipamento(s), inicia-se o prazo de '
	_cMsg += 'Garantia pelo período de: </p>'

	//Garantia Inicio

    /*
    
    Alterado por Marlon Pablo

    #################
      Foi comentado a pedido da Ravylla em 15/02/2022 Às 15:09 
      Remover esse bloco porque usam o campo CN9_GARANT inserindo manualmente os dados da garantia
    #################

   	IF CN9->CN9_TPGARA = "B"
   	   _cMsg += '<p align="justify" style="margin-left: 150px;">(i) '+cvaltochar(TMP1->CN9_MESPRI)+' ('+EXTENSO(TMP1->CN9_MESPRI,.T.)+')  meses sem limite de horas trabalhadas em Regime '   
       _cMsg += ' Prime, ou '+cvaltochar(TMP1->CN9_MESLTP)+' ('+EXTENSO(TMP1->CN9_MESLTP,.T.)+') meses, respeitando-se o limite de 500 horas, quando em Regime LTP (Emergência), ' 
   	   _cMsg += ' em conformidade com a Norma ISO 8528, contados da data de emissão da nota fiscal de venda, ou seja, quando da efetiva tradição do(s) equipamento(s). </p>'    	 	
   	EndIf 
     */                                                    
	cGarant := " "
	nLinhas := MLCount(CN9->CN9_GARANT,140)
	For nXi:= 1 To nLinhas
		cGarant += MemoLine(CN9->CN9_GARANT,140,nXi)
	Next nXi
	_cMsg += '<p style="margin-left: 150px;">'+ cGarant+'</p>'
	//_cMsg += '<p style="margin-left: 100px;">(ii) O prazo de garantia das máquinas no que se refere à montagem (quando for o caso), pelo prazo máximo de 03 meses, '
	//_cMsg += ' contados da data de                   . </p>'
	//Garantia Fim

	//Inserir os Prazos de Garantia
	//2.6
	//_cMsg += '<p align="justify">2.7.  As condições acima são consideradas após a data da primeira partida ou 12 (doze) meses após o faturamento. </p>'
	//2.7
	_cMsg += '<p align="justify">2.7.  Todos os pesos, medidas, tamanhos, legendas ou descrições impressas, estampadas, anexadas ou de qualquer outra maneira '
	_cMsg += ' indicadas, no que se refere ao(s) produto(s), são atestadas como verdadeiras e corretas pela <b>VENDEDORA.</b> '
	_cMsg += ' Desta forma, estão em conformidade e atendem as normas e regulamentações relacionados com o(s) referido(s) produto(s). </p>'
	//2.8
	_cMsg += '<p align="justify">2.8.  A <b>VENDEDORA</b> fará a <b>ENTREGA TÉCNICA E GARANTIAS</b> quando do primeiro funcionamento em campo, que deverá ser efetuado '
	_cMsg += 'por um técnico credenciado, para validação da garantia do equipamento, na base de atendimento na cidade de '+rtrim(sm0->m0_cidcob)+'.</p>'

	_cMsg += '<b><p align="center">DA VERIFICAÇÃO DA MÁQUINA ANTES DA ENTREGA</b> </p>'
	//2.9
	_cMsg += '<p align="justify">2.9.  A COMPRADORA deverá inspecionar o(s) grupo(s) gerado(es) e seu(s) equipamentos(s), com antecedência de 48 (quarenta e oito) horas, '
	_cMsg += ' mediante pré-agendamento com o departamento comercial. </p>'
	//2.10
	_cMsg += '<p align="justify">2.10.  A VENDEDORA coloca à disposição seus engenheiros e/ou técnicos especializados, para uma visita, onde a COMPRADORA fará verificação '
	_cMsg += 'técnica e inspeção do(s) grupo(s) gerador(es) na base de inspeção, acompanhados de um check-list denominado TAF (Termo de Aceitação de Fábrica) '
	_cMsg += ', que será fornecido no ato da vistoria do equipamento. </p>'
	//2.10.1
	_cMsg += '<b align="justify">2.10.1. ATENÇÃO: A dispensa da visita e vistoria, por parte da COMPRADORA, importará no aceite das '
	_cMsg += ' condições de fábrica bem como o pleno funcionamento do(s) equipamento(s). </font></b>'

	_cMsg += '<b><p align="center">DA UTILIZAÇÃO DA GARANTIA</b> </p>'
	//2.11
	_cMsg += '<p align="justify">2.11.  A garantia só abrangerá as peças e componentes que tenham defeito original de fábrica ou defeitos de funcionamento descritos nas '
	_cMsg += ' condições normais de uso e que estejam de acordo com as instruções que acompanharão o(s) grupo(s) gerador(es), mediante comprovação feita por vistoria preliminar. </p>'
	//2.14
	_cMsg += '<p align="justify">2.12.  A garantia não cobre avarias ocasionadas pelo uso inapropriado e ficará automaticamente cancelada se os equipamentos '
	_cMsg += ' vierem a sofrer danos decorrentes de acidentes, chuva, água, quedas, variações de tensão elétrica e sobrecarga acima do especificado, utilização '
	_cMsg += ' de combustível adulterado, utilização de óleo lubrificante de procedência duvidosa ou fora da lista de autorizados constantes do manual, ou '
	_cMsg += ' qualquer ocorrência imprevisível, decorrentes de má utilização dos equipamentos por parte do usuário. </p>'
	//2.16
	_cMsg += '<p align="justify">2.13.  Os custos e despesas necessárias para o saneamento do defeito, vício, falha ou não conformidade, tais como fretes, '
	_cMsg += ' embalagens, desmontagem e montagem, correção por conta integral da COMPRADORA. </p>'
	//2.17
	_cMsg += '<p align="justify">2.14.  A garantia não inclui a substituição do equipamento por outro equivalente, enquanto perdurar o reparo, conserto e ou '
	_cMsg += ' verificação do equipamento em garantia. </p>'
	//2.18
	_cMsg += '<p align="justify">2.15.  Despesas com viagem, alimentação e estada da equipe técnica da a VENDEDORA correrão por conta da COMPRADORA. </p>'
	//3.
	_cMsg += '<b align="left">CLAUSULA 3. DO FRETE</b> <br />'
	If CN9->CN9_FRETE = "C"
		_Frete := "CIF"
	Else
		_Frete := "FOB"
	EndIf

	_cMsg += '<p align="justify"></b>3.1.  O FRETE será modalidade '+_Frete+' conforme indicado na <b>PROPOSTA N.: '+rtrim(CN9->CN9_PROP)+'</b>  </p>'

	_cMsg += '<p align="justify">3.2.  O transporte vertical será de inteira responsabilidade da COMPRADORA. </p>'

	If  CN9->CN9_FRETE = "F"
		_cMsg += '<b><p align="center"><font face="Doppio One" size="2"> DA MODALIDADE FOB (free on board)</font> </p></b>'
		//3.1
		_cMsg += '<p align="justify">3.3.  A responsabilidade pelos custos com frete, seguro e despesas relacionadas ao transporte horizontal e vertical, correrão '
		_cMsg += ' de inteira responsabilidade da COMPRADORA, ou seja, será realizado na modalidade FOB-ANÁPOLIS/GO. </p> '
		//3.2
		_cMsg += '<p align="justify">3.4.  Em caso de problemas técnicos e/ou avarias no equipamento correrão todos os custos referentes a frete e transporte por conta da '
		_cMsg += ' COMPRADORA para o translado do equipamento até a base de Anápolis/GO para análise técnica do equipamento que será realizada em um período não superior a 30(trinta) dias. </p>'
	Else
		_cMsg += '<b><p align="center"><font face="Doppio One" size="2"> DA MODALIDADE CIF (cost, Insurance and Freigth)</font> </p></b>'
		//3.3
		_cMsg += '<p align="justify">3.3.  Optando a COMPRADORA por transporte na modalidade CIF , a VENDEDORA será a responsável pelo transporte horizontal. '
		_cMsg += 'A COMPRADORA responsabilizar-se-á com o transporte vertical, além dos gastos para locação de caminhão munck, para descarregamento, que serão por conta da COMPRADORA. </p>'
	EndIf
	//4.
	_cMsg += '<b align="left">CLAUSULA 4. PREÇO E CONDIÇÕES DE PAGAMENTO</b> <br />'
	//4.1
	_cMsg += '<p align="justify">4.1.  A COMPRADORA pagará à VENDEDORA '
	_cMsg += ' pela(s) mercadoria(s) vendida(s) e que é(são) objeto do presente contrato, no valor de R$ '+AllTrim(Transform(TMP1->CN9_VLINI,"@ze 999,999,999,999.99"))+' ('+EXTENSO(TMP1->CN9_VLINI) +'), à vista</p>'
	//4.2
    /*_cMsg += '<p align="justify">4.2.  O valor previsto acima será pago da seguinte forma: </p>'
    nValTot := TMP1->CN9_VLINI
    cCond   := TMP1->CN9_CONDPG
    dData   := STOD(TMP1->CN9_ASSINA)
    nVIPI   := 0
       
    aParc := Condicao(nValTot,cCond,nVIPI,dData)
    _cMsg += '<table border="1"><thead><tr><th>Parcela</th><th>Vencimento</th><th>Valor</th></tr></thead> '  
    
    //Alteração Ricardo para contratos com Entrada 29/10/2019 - Inicio
    If TMP1->CN9_ENTRAD > 0
       _Parc  := "ENTRADA"    
       _cMsg += '<tr><td>'+_Parc+'</td><td>'+CVALTOCHAR(STOD(TMP1->CN9_DTINIC))+'</td><td>'+AllTrim(Transform(TMP1->CN9_ENTRAD,"@ze 999,999,999,999.99"))+'</td></tr> '                             
    EndIf
    //Alteração Ricardo para contratos com Entrada 29/10/2019 - Fim
   
   
    DbSelectArea("SE4")
    DbSetOrder(1)  
    dbSeek(xFilial("SE4")+cCond)
    If SE4->E4_TIPO <> "A"  
    
       For i:= 1 to Len(aParc)
           _Venc := aParc[i,1]   //retorna a data em branco     
           _Total := aParc[i,2]   // CtoD("28/06/2018")
	       _Parc  := cvaltochar(i)
	       If cCond = "001"  
              _cMsg += '<tr><td>'+_Parc+'</td><td>'+CVALTOCHAR(STOD(TMP1->CN9_DTINIC))+'</td><td>'+AllTrim(Transform(_Total,"@ze 999,999,999,999.99"))+'</td></tr> '                             
	       Else
	          _cMsg += '<tr><td>'+_Parc+'</td><td>'+CVALTOCHAR(_Venc)+'</td><td>'+AllTrim(Transform(_Total,"@ze 999,999,999,999.99"))+'</td></tr> '                             
	       EndIf
	   //_cMsg += '<table border="1"><align="center"><tr><td>'+_Parc+'</td><td>'+AllTrim(Transform(_Total,"@ze 999,999,999,999.99"))+'</td></tr> '
       Next i       
           _cMsg += '<tr><td></td><td>TOTAL</td><td>'+AllTrim(Transform(TMP1->CN9_VLINI,"@ze 999,999,999,999.99"))+'</td></tr> ' 
           _cMsg += '</table>'    
    Else    
    _cMsg += '<p align="justify"> - '+SE4->E4_COND+'</b>  </p>'
    EndIf
    */

	//FAZER LISTAR OS VALORES A PAGAR CONFORME A IMPRESSAO EM TABELAS ... DATA E VALOR
	//4.3

    /*
      Alterado por Marlon
      Segundo a Ravylla as porcentagens mudaram
      Sendo multa de 2% para 5%
      Sendo juros de 2% para 1%    
    */
	_cMsg += '<p align="justify">4.2.  O atraso no pagamento das parcelas previstas acima, quando for o caso, implicará em multa de 5% (cinco por cento) '
	_cMsg += ' ao mês, juros de mora de 1% (um por cento) ao mês <i>pró rata die</i> de atraso, e correção monetária conforme índice do IGPM (FGV) Positivo, ou outro que venha substituí-lo. </p>'
	//4.4
	_cMsg += '<p align="justify">4.3.  As partes acordam que a purgação da mora não isentará a Compradora do pagamento da multa Contratual prevista no Item 9.1, '
	_cMsg += ' salvo acordo formalizado entre as partes. </p>'
	//5.
	_cMsg += '<b align="left">CLAUSULA 5. DO PRAZO DE ENTREGA E DA RESPONSABILIDADE PELO TRANSPORTE DAS MERCADORIAS</b> <br />'
	//5.1
	_cMsg += '<p align="justify">5.1.  Os produtos são entregues pela VENDEDORA à COMPRADORA'
	If TMP1->CN9_PRZENT = "0"
		_cMsg += ' de imediato'
	Else
		_cMsg += ' em até ' +rtrim(TMP1->CN9_PRZENT)+' dias, iniciando a contagem do prazo a partir da assinatura do presente contrato. </p>'
	EndIf
	//5.2
	_cMsg += '<p align="justify">5.2.  A VENDEDORA enviará seus melhores esforços para atender a data de entrega estimada,  todavia, reserva-se o direito de rever esta '
	_cMsg += ' data comunicando previamente à COMPRADORA a nova entrega estimada, sem qualquer imposição de multa em caso de atraso, superior ao prazo previsto. </p>'
	//5.3
	_cMsg += '<p align="justify">5.3.  Em caso de atraso na entrega por parte da VENDEDORA, a COMPRADORA '
	_cMsg += ' deverá notificar a VENDEDORA para se manifestar acerca do prazo e conclusão da entrega do produto. </p>'
	//5.4
	If  CN9->CN9_FRETE = "F"
		_cMsg += '<p align="justify">5.4.  Os produtos serão considerados entregues no momento em que são expedidos fisicamente à Transportadora ou de qualquer forma confiados '
		_cMsg += ' para o transporte, momento no qual o risco passará à COMPRADORA, assim como todos os custos e despesas com seguros e transporte. Eventuais defeitos aparentes, '
		_cMsg += ' avarias, ou danos de quaisquer espécie, deverão ser relatados no ato da entrega técnica. '
		_cMsg += ' Qualquer reclamação posterior não será considerada pela VENDEDORA. OBS: MODALIDADE FOB. </p>'
	Else
		_cMsg += '<p align="justify">5.4.  Os produtos serão considerados entregues no momento em que são expedidos fisicamente à Transportadora, confiados para o transporte, '
		_cMsg += ' A VENDEDORA apenas se responsabiliza pelo equipamento avariado ou incompleto, se for constatado no ato do recebimento, por escrito ao transportador que fará '
		_cMsg += ' o registro do fato no conhecimento de transporte. OBS: MODALIDADE CIF. </p>'
	EndIf
	//cTxtLinha := " "

	DbSelectArea("ZCL")
	DbSetOrder(2)
	dbSeek(xFilial("ZCL")+TMP1->CN9_TPCTO)
	_Doc := ZCL->ZCL_TIPOCO
	DO WHILE ! EOF() .AND. ZCL->ZCL_FILIAL = xFilial("ZCL") .AND. ZCL->ZCL_TIPOCO == _Doc
		cTxtLinha := " "
		_cMsg += '<b align="left">CLAUSULA '+CVALTOCHAR(ZCL->ZCL_CLAUSU)+'. '+ZCL->ZCL_TITULO+'</b> <br />'

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
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> VENDEDORA</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> COMPRADORA</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(sm0->m0_nomecom)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->A1_NOME)+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(sm0->m0_nome)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td>&nbsp;</td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> TESTEMUNHAS</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->CN9_NOME1)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->CN9_NOME2)+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">CPF:</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">CPF:</font> </td>'
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

//Inicio impressão de contrato 005 10/03/2022 - Venda de Energia Eletrica de Curto Prazo
//Marlon Pablo - 10/03/2022 12:08

//???????????????????????????????????????????????????????????????????????????
Static Function Cont003()
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


   	_cMsg += '<img src="http://brggeradores.com.br/vendas/LogoGrid.PNG" height="90" width="250">'//</td>'        
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
    _cMsg += '<p align="justify">2.4.	Servirão como comprovante, a autenticação mecânica no boleto, quando da efetivação do pagamento em favor da <b>LOCADORA</b>.</p> ' 
    _cMsg += '<p align="justify">2.5.	Todos os pagamentos serão realizados por meio de boleto bancário.</p> ' 
    
	IF rtrim(cFilAnt) == "1001"

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

	ENDIF
     //CLÁUSULA 3
    _cMsg += '<b><p align="justify">CLÁUSULA 3 - PRAZO DA LOCAÇÃO.</p></b>'
	

	//Ravilla mandou por email(marlon.pablo@brggeradores.com.br) 
	//no dia 17/08/2022 Favor retificar a cláusula 3.1 do contrato tipo 003 (Locação) no TOTVS, 
	//para que passe a ter a seguinte redação fixa:

	_cMsg += '3.1	A locação objeto do presente instrumento contratual vigorará por prazo indeterminado, sendo que, caso o (a) '
	_cMsg += 'LOCATÁRIO (A), solicite o encerramento da locação, observado o prazo indicado na cláusula 6.1, a LOCADORA confirmará '
	_cMsg += 'a data do encerramento da vigência, que se dará com a efetiva retirada do (s) equipamento '
	_cMsg += '(s), ou entrega in loco, para fins de faturamento da última cobrança.'

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

//Inicio impressão de contrato 005 24/09/2019 - Venda de Energia Eletrica de Curto Prazo
 
//???????????????????????????????????????????????????????????????????????????
Static Function Cont004()
//???????????????????????????????????????????????????????????????????????????		
	local lhainfo	:= .f.  
	local ngrupo	:= 0
	local agrupo	:= {}
	local aitem		:= {}
	local cultnum	:= "" 
	local _cTpCon   := ""
	local _cFunc    := "" 
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
  _cMsg += '    line-height: 1.5;'
  _cMsg += '  }'
  _cMsg += '  #tabela_pagamento {'
  _cMsg += '    page-break-before: always;'
  _cMsg += '  }'
  _cMsg += '  #assinaturas {'
  _cMsg += '    page-break-before: always;'
  _cMsg += '  }'
  _cMsg += '  
  _cMsg += '  * {'
  _cMsg += '    padding-bottom: 0.5cm; /*Ravylla falou que nao tem importancia esse bloco que da um espaçamento de 0.5 cm entre cada elementro da impressão. Ganhou 1,3mm entre a ultima linha de cada pagina e o rodapé*/'
  _cMsg += '  }'
  _cMsg += '}'     
  _cMsg += '@page{'
  _cMsg += '  size: auto;'
  _cMsg += '  margin-top: 2cm;'
  _cMsg += '  margin-left: 3cm;'
  _cMsg += '  margin-right: 2cm;'
  _cMsg += '  margin-bottom: 0.8cm;'
  _cMsg += '  padding-bottom: 3cm;'        
  _cMsg += '}'

  _cMsg += '</style>'
	_cMsg += '<body>'  
     //	_cMsg += '<img src = "'+cLogoD+'">'   	//figura \system\logoorc.png
      //  	_cMsg += '<img src="system\LGMID.png"> </td>'   http://brggeradores.com.br/vendas/LogoMini.png
     //	_cMsg += '<img src="C:\Temp\LGMID.png" height="100" width="98" ></td>' 
   	_cMsg += '<img src="http://brggeradores.com.br/vendas/LogoMini.png" height="120" width="118" >'//</td>'        
	_cMsg += '<b><p align="right"> Contrato n. '+rtrim(TMP1->CN9_NUMERO)+'/'+cvaltochar(Year(STOD(TMP1->CN9_DTINIC)))+'</b> <br /> </p>'   //Year(STOD(TMP1->CN9_NUMERO))
   	_cMsg += '<b align="left">'+_cTpCon+'</b> <br />' 
   
    //PARAGRAFO VENDEDORA
    _cMsg += '<b><p align="justify">'+rtrim(sm0->m0_nomecom)+'</b>' 
    _cMsg += ', nome fantasia <b>'+rtrim(substr(sm0->m0_nomecom,1,20))+'</b>'
    _cMsg += ', pessoa jurídica de direito privado, inscrita no CNPJ (MF) sob o N. '+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')'
    _cMsg += ', localizada na ' +rtrim(sm0->m0_endcob)+', '+rtrim(sm0->m0_baircob)+ ' na cidade de '+rtrim(sm0->m0_cidcob)+' - '+sm0->m0_estcob 
    _cMsg += ', através de sua representante legal Sra. Paula Cristina Crispim Oliveira Bueno, Brasileira, Casada, empresária, inscrita no CPF sob o '
    _cMsg += ' n. 016.997.101-55, residente e domiciliada na cidade de Anápolis - GO, doravante designada simplesmente de VENDEDORA.</p>'    
        
     //PARAGRAFO COMPRADOR  (venda de Gerador)
    _cMsg += '<b><align="left">E DE OUTRO LADO</b> <br />'     
    _cMsg += '<b><p align="justify">'+rtrim(TMP1->A1_NOME)+'</b>'
	If TMP1->A1_PESSOA = "F"
      _cMsg += ' pessoa física, nome fantasia ' +rtrim(TMP1->A1_NREDUZ)+', inscrita no CNPJ (MF) sob o N. '+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')'
     Else
	  _cMsg += ', pessoa jurídica de direito privado, nome fantasia ' +rtrim(TMP1->A1_NREDUZ)+', inscrita no CNPJ (MF) sob o N. '+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')'
    EndIf
	_cMsg += ', Inscrição Estadual N. '+rtrim(TMP1->A1_INSCR)	
	_cMsg += ', endereço na ' +rtrim(TMP1->A1_END)+', '+rtrim(TMP1->A1_BAIRRO)+', Cep '+transform((TMP1->A1_CEP),'@R 99999-999')+ ' na cidade de '+rtrim(TMP1->A1_MUN)+' - '+TMP1->A1_EST   
	 
	DbSelectArea("SU5")
    DbSetOrder(1)  
    dbSeek(xFilial("SU5")+TMP1->AC8_CODCON)
	_cMsg += ', através de seu representante legal, Sr(a) '+rtrim(SU5->U5_CONTAT)   
	_cMsg += ', Nacionalidade: ' +rtrim(SU5->U5_NACIONA)
	_cFunc := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC") 
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
	_cMsg += ', Estado Civil: ' +rtrim(EstCiv)	  
 	_cMsg += ', Profissão: '+rtrim(_cFunc) 
 	_cMsg += ', residente e domiciliado à ' +rtrim(SU5->U5_END)+', '+rtrim(SU5->U5_BAIRRO)+' Cep '+transform((SU5->U5_CEP),'@R 99999-999')+ ' na cidade de '+rtrim(SU5->U5_MUN)+' - '+SU5->U5_EST
    _cMsg += ', inscrito no CPF de n. ' + transform((SU5->U5_CPF),'@R 999.999.999-99')+', doravante designada simplesmente de COMPRADORA.</p>'                                   
    
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
    EndCase  
            
    //VALIDAÇÃO PARA CAMPO EM BRANCO - FIM 10/09/2019
    
     
    _cMsg += '<p align="justify">As partes, acima, qualificadas têm entre si, justas e acordadas, o presente contrato de venda de energia elétrica '  
	_cMsg += 'de curto prazo que se regerá pelas cláusulas e condições seguintes: </p>'
	                                                               
	  //Clausula 1
	_cMsg += '<b><p align="justify">CLAUSULA 1. DO OBJETO -</b>'
	
	_cMsg += '<p align="justify">1.1.  Constitui-se objeto deste contrato a venda de energia de curto prazo, conforme as condições comerciais descritas na '
	_cMsg += '<b>PROPOSTA N.: '+rtrim(CN9->CN9_PROP)+'</b>, parte integrante do presente instrumento e transcritas abaixo: </p> ' //Colocar a Proposta '
	
     Geratmp2()
     
     _cMsg += '<p align="justify"> #######################DEFINIR DE ONDE PEGAR Energia Contratada / Periodo de Fornecimento / Ponto de entrega ######################</p>'
          
     /*
     DO WHILE TMP2->(!EOF())
        _cMsg += '<b align="left">'+alltrim(cvaltochar(TMP2->CNB_QUANT))+'       '+TMP2->CNB_UM+ '       '+alltrim(TMP2->CNB_PRODUT)+'/'+TMP2->CNB_DESCRI+'</b> <br />' 
        TMP2->(dbskip())
     EndDo 
     */
	//Energia contratada
	//Local para descrever os itens -> Isso na Planilha dentro do contrato.

	//Clausula 2
	_cMsg += '<br />'
	_cMsg += '<b align="left">CLAUSULA 2. DAS CONDIÇÕES COMERCIAIS E OPERACIONAIS</b> <br />'

	_cMsg += '<p align="justify">2.1.  As condições comerciais e operacionais são as seguintes: </p>'

	_cMsg += '<p align="justify"> ##############################DEFINIR DE ONDE PEGAR CONDIÇÕES COMERCIAIS ########################## </p>'
	//2.1
	_cMsg += '<p align="justify">2.2.  O ajuste do registro da Energia Contratada na CCEE será realizado pela <b>VENDEDORA</b> após a verificação do '
	_cMsg += 'pagamento por parte da <b>COMPRADORA</b>, na data do vencimento da respectiva fatura. </p>'
	//2.2
	_cMsg += '<p align="justify">2.3.  A <b>COMPRADORA</b> se obriga a validar o referido registro, de acordo com as disposições '
	_cMsg += 'previstas nas REGRAS E PROCEDIMENTOS DE COMERCIALIZAÇÃO. </p>'
	//2.3
	_cMsg += '<p align="justify">2.4.  A falta do pagamento na data do vencimento desobriga a <b>VENDEDORA</b> de promover o ajuste '
	_cMsg += 'da Energia Contratada no CliqCCEE, sem qualquer direito à indenização à <b>COMPRADORA.</b> '
	//2.4
	_cMsg += '<p align="justify">2.5.  Caso a <b>COMPRADORA</b> mantenha o interesse na compra, deverá promover o pagamento acrescido '
	_cMsg += 'de 2% (dois por cento) de multa até a data prevista para o ajuste da Energia Contratada no CliqCCEE, sendo certo que '
	_cMsg += 'a validação somente irá ocorrer após a confirmação do recebimento por parte da <b>VENDEDORA.</b> '
	//2.5
	_cMsg += '<p align="justify">2.6.  Após a validação e entrega técnica e início da primeira partida do(s) equipamento(s), inicia-se o prazo de '
	_cMsg += 'Garantia pelo período de: </p>'

	//cTxtLinha := " "

	DbSelectArea("ZCL")
	DbSetOrder(2)
	dbSeek(xFilial("ZCL")+TMP1->CN9_TPCTO)
	_Doc := ZCL->ZCL_TIPOCO
	DO WHILE ! EOF() .AND. ZCL->ZCL_FILIAL = xFilial("ZCL") .AND. ZCL->ZCL_TIPOCO == _Doc
		cTxtLinha := " "
		_cMsg += '<b align="left">CLAUSULA '+alltrim(CVALTOCHAR(ZCL->ZCL_CLAUSU))+'. '+ZCL->ZCL_TITULO+'</b> <br />'

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
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> VENDEDORA</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> COMPRADORA</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(sm0->m0_nomecom)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->A1_NOME)+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(sm0->m0_nome)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td>&nbsp;</td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td>&nbsp;</td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> TESTEMUNHAS</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->CN9_NOME1)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->CN9_NOME2)+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->CN9_CPF1),'@R 999.999.999-99')+'</font> </td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> CPF:</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->CN9_CPF2),'@R 999.999.999-99')+'</font> </td>'
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

//Inicio impressão de contrato 005 - Locação de Equipamento com Opção de Compra

//???????????????????????????????????????????????????????????????????????????
Static Function Cont005()
//???????????????????????????????????????????????????????????????????????????		
	local lhainfo  := .f.
	local ngrupo	:= 0
	local nXi      := 1
	Local i		:= 1
	local agrupo	:= {}
	local aitem	:= {}
	local cultnum	:= ""
	local _cTpCon  := ""
	local cTx    := 0
	local cPrime := ''
	local _cFunc   := ""
	Local _Venc    := CtoD("  /  /  ")
	Local _Total   := 0
	Local _Parc    := " "
	Local nValTot  := 0
	Local vTotOpc  := 0
	Local cCond    := 0
	Local dData    := CtoD("  /  /  ")
	Local cLogoD   := GetSrvProfString("Startpath","") + "LGMID.png"	
	Local cCondPag := ""
    Local aDadosPag := NIL
	Local cE4TpPag := ""
	private _nhandle

	Geratmp1()
	//1=Solteiro;2=Casado;3=Divorciado;4=Viuvo;5=Companheiro(a);

	_cTpCon := Posicione("CN1",1,xFilial("CN1")+TMP1->CN9_TPCTO,"CN1_DESC2")
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
     _cMsg += '    text-align: center;     '
     _cMsg += '}'
     _cMsg += '.dados_produtos th{'
     _cMsg += '    padding: 3px;'
     _cMsg += '    border: 1px solid; '
     _cMsg += '    text-align: center;     '
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
	_cMsg += '<img src="http://brggeradores.com.br/vendas/LogoMini.png" height="120" width="118" >'//</td>'
	_cMsg += '<b><p align="right"> Contrato n. '+rtrim(TMP1->CN9_NUMERO)+'/'+cvaltochar(Year(STOD(TMP1->CN9_DTINIC)))+'</b> <br /> </p>'   //Year(STOD(TMP1->CN9_NUMERO))
	_cMsg += '<b align="left">'+_cTpCon+'</b> <br />'


    //PARAGRAFO LOCADORA

    _cMsg += '<p align="justify">'
    _cMsg += 'Pelo presente instrumento particular, as Partes a seguir qualificadas, de um lado <b>'+rtrim(TMP1->A1_NOME)+'</b>, '
    IF TMP1->A1_PESSOA = "F"
        _cMsg += 'pessoa fisica de direito privado, incrita no CPF (ME) sob o Nº. '+transform((TMP1->A1_CGC),'@R 999.999.999-99')'
    ELSE
        _cMsg += 'pessoa Jurídica de direito privado, incrita no CNPJ (ME) sob o Nº. '+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')'
    ENDIF
    _cMsg += ' endereço na ' +rtrim(TMP1->A1_END)+', '+rtrim(TMP1->A1_BAIRRO)+', Cep '+transform((TMP1->A1_CEP),'@R 99999-999')+ ' na cidade de '+rtrim(TMP1->A1_MUN)+' - '+TMP1->A1_EST
    _cMsg += ', neste instrumento representada na forma do seu ato consstitutivo, doravante denominada <b>LOCATARIA</b>'     
    _cMsg += '</p>'

    _cMsg += '<p>E do outro <b>'+rtrim(sm0->m0_nomecom)+'</b>'
    _cMsg += ', pessoa jurídica de direito privado, inscrita no CNPJ (ME) sob o N. '+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')'
    _cMsg += ' com sede à Rua' +rtrim(sm0->m0_endcob)+', '+rtrim(sm0->m0_baircob)+ ' na cidade de '+rtrim(sm0->m0_cidcob)+' - '+sm0->m0_estcob
    _cMsg += ' conforme Contrato Social, aqui representada por seu sócio administrador o Sr <b>SILVIO HENRIQUE CRISPIM OLIVEIRA</b>, brasileiro, empresário'
    _cMsg += ', solteiro, portador da célula de identidade nº 5151277 2ª via SSP/GO, inscrito no CPF (ME) sob o nº 035.566.211-69, sendo encontrado na sede'
    _cMsg += ' da empresa, doravante denominada <b>LOCADORA</b></p>'

    _cMsg += '<p>Como <b>PROMITENTE VENDEDORA BRG BRASIL GERADORES-EIRELI</b>, de nome fantasia <b>BRG BRASIL GERADORES</b>, pessoa jurídica, inscrita no CNPJ/ME sob o Nº 04.675.878/0001-88 '
    _cMsg += 'com sede na Via principal R3, QD 2A, Lotes 43/44, CEP n. 75.132-015, DAIA, na Cidade de Anápolis, Estado de Goiás, neste ato representada por sua administradora'
    _cMsg += 'PAULA CRISTINA CRISPIM OLIVEIRA BUENO, brasileira, casada, empresária, inscrita no CPF/ME sob o n.º 016.997.101-55 e, portadora da Cédula de '
    _cMsg += 'Identidade RG n. 5.151.223 SSP/GO, podendo ser encontrada na sede da empresa.'
    _cMsg += 'As partes têm entre si justo e contratado o presente Instrumento Particular de Contrato de Locação de Equipamentos, '
    _cMsg += 'que se regerá de acordo com as cláusulas adiante estabelecidas:</p>'
	  
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
	EndCase

	//VALIDAÇÃO PARA CAMPO EM BRANCO - FIM 10/09/2019

	//Clausula 1
    _cMsg += '<h2>CLÁUSULA 1. OBJETO</h2>'
	_cMsg += '<p>1.1. O presente instrumento tem como objeto a locação com futura opção de compra dos'
	_cMsg += 'seguintes equipamentos em posse da <b>LOCADORA</b> e de propriedade da <b>ANUENTE E '
	_cMsg += 'PROMITENTE VENDEDORA</b>.</p>'

	Geratmp2()

    _cMsg += '<table class="dados_produtos">'
	_cMsg += '<thead>'
	_cMsg += '<th align="center"><b>Descrição do Equipamento</b></th>'
	_cMsg += '<th align="center"><b>Quantidade</b></th>'
	_cMsg += '</thead>'
	_cMsg += '<tbody>'
     
    //Local para descrever os itens -> Isso na Planilha dentro do contrato. 17/03/2022
    vTotPrd := 0
    DO WHILE TMP2->(!EOF())
        _cMsg += '<tr><td>'+alltrim(TMP2->CNB_PRODUT)+' - '+TMP2->CNB_DESCRI+'</td><td align="right">'+alltrim(cvaltochar(TMP2->CNB_QUANT))+'</td></tr>
        vTotPrd := vTotPrd + TMP2->CNB_VLTOT

       TMP2->(dbskip())
    EndDo 
    _cMsg += '<tr><td><b>TOTAL:</b></td><td>R$ '+Transform(vTotPrd,"@ze 999,999,999,999.99")+'</td></tr>'
    _cMsg += '</tbody>'
    _cMsg += '</table>'

	_cMsg += '<p>1.2. A manutenção do equipamento descrito acima deverá ser realizada pela empresa '
	_cMsg += '<b>LOCATÁRIA</b>, por técnicos próprios ou contratados.</p>'

	_cMsg += '<p>1.3. As obras civis e elétricas necessárias à instalação e funcionamento dos '
	_cMsg += 'equipamentos, deverão ser executadas pela <b>LOCATÁRIA</b>, cuja execução deverá ser '
	_cMsg += 'conforme a legislação e regulamentos técnicos aplicáveis.</p>'

	_cMsg += '<p>1.4. Havendo qualquer discrepância, omissão, erro e transgressão às normas técnicas, '
	_cMsg += 'regulamentos ou legislação vigente na obra civil para a implantação, a responsabilidade será '
	_cMsg += 'exclusiva da <b>LOCATÁRIA</b>.</p>'

	_cMsg += '<p>1.5. O equipamento deverá ser vistoriado pela <b>LOCATÁRIA</b>, antes de sua retirada da '
	_cMsg += 'fábrica pelo transportador, sob pena de se presumir que o mesmo se encontra sem nenhum '
	_cMsg += 'vício aparente.</p>'
	
	//Clausula 2
    //_Contr


	_cMsg += '<h2>CLÁUSULA 2. - PREÇO E CONDIÇÕES DE PAGAMENTO</h2>'  
//TMP1->CN9_VLINI
	_cMsg += '<p align="justify">2.1.  O valor deste contrato de Locação de Equipamentos, incluindo sua embalagem, é de R$ '+AllTrim(Transform(totcjur(),"@ze 999,999,999,999.99"))+' ('+EXTENSO(totcjur()) +'), '
	_cMsg += 'valor essse referente à locação dos objetos descritos na cláusula primeira </p>'

	_cMsg += '<p>2.2. O valor referido acima será pago de acordo e nas condições do Anexo I, parte '
	_cMsg += 'integrante deste instrumento.</p>'

	_cMsg += '<p>2.3. Todos e quaisquer tributos e contribuições que incidam ou venham a incidir sobre o '
	_cMsg += 'objeto do presente contrato, são de inteira responsabilidade do contribuinte como tal definido '
	_cMsg += 'na norma tributária, sem direito a reembolso.</p>'

	_cMsg += '<p>2.4. Todos os custos diretos e/ou indiretos que vierem a ser necessários para a '
	_cMsg += 'manutenção e operação do equipamento ora locado são de responsabilidade exclusiva da '
	_cMsg += '<b>LOCATÁRIA</b>.</p>'

	_cMsg += '<p>2.5. Servirão como comprovante a autenticação mecânica no boleto, quando da '
	_cMsg += 'efetivação do pagamento em favor da <b>LOCADORA</b>.</p>'

	//Clausula 3
	_cMsg += '<h2>CLÁUSULA 3. DO REAJUSTE.</h2>'
	_cMsg += '<p>3.1. O saldo devedor será reajustado anualmente sempre nos meses de janeiro, conforme '
	_cMsg += 'índice IPCA positivo de cada mês.</p>'

	//Clausula 4
	_cMsg += '<h2>CLÁUSULA 4. PRAZO DA LOCAÇÃO E ENTREGA</h2>'

	cUnVige := ''

    Geratmp1()

	DO CASE
		CASE TMP1->CN9_UNVIGE = "1"
		cUnVige := 'Dias'
		CASE TMP1->CN9_UNVIGE = "2"
		cUnVige := 'Meses'
		CASE TMP1->CN9_UNVIGE = "3"
		cUnVige := 'Anos'
		CASE TMP1->CN9_UNVIGE = "4"
		cUnVige := 'Indeterminado'
		OTHERWISE 
		cUnVige := '<b style="color:red">NÃO INFORMADO</b>'
	ENDCASE
       //substr(EXTENSO(TMP1->CN9_VIGE),1,len(EXTENSO(TMP1->CN9_VIGE))-6)

	_cMsg += '<p>4.1. O prazo da locação será de <b>'+CVALTOCHAR(TMP1->CN9_VIGE)+' ('+substr(EXTENSO(TMP1->CN9_VIGE),1,len(EXTENSO(TMP1->CN9_VIGE))-6)+')</b> '+cUnVige+', a contar-se conforme Anexo I.</p>'

	_cMsg += '4.2. A renovação deste contrato somente se dará por escrito e mediante anuência '
	_cMsg += '<p>expressa da <b>LOCADORA</b> e da anuente.</p>'

	_cMsg += '4.3. A responsabilidade pelos custos com frete, seguro e despesas relacionadas ao '
	_cMsg += '<p>transporte, será da <b>LOCATÁRIA</b>, ou seja, na modalidade <b>FOB- ANÁPOLIS (GO)</b></p>'

	_cMsg += '4.3.1. O equipamento deverá ser vistoriado pela <b>LOCATÁRIA</b>, antes ou no momento da '
	_cMsg += '<p>entrega do equipamento, sob pena de se presumir que o mesmo se encontra sem nenhum '
	_cMsg += 'vício aparente, e estando em perfeito estado de fabricação.</p>'

	//Clausula 5
	_cMsg += '<h2>CLÁUSULA 5. DA OPÇÃO DE COMPRA</h2>'


	nValTot  := TMP1->CN9_VLINI-TMP1->CN9_VLRENT

	DbSelectArea("SE4")
	DbSetOrder(1)
	dbSeek(xFilial("SE4")+TMP1->CN9_CONDPG) //TMP1->CN9_CONDPG
	
	cCondPag := SE4->E4_COND
	cE4TpPag := SE4->E4_TIPO
	cPrime   := SE4->E4_PRIME // 1 - Sim  2 - Não
	cTx      := SE4->E4_FINAN // Taxa de financiamento
	

	aDadosPag := STRTOKARR(cCondPag, "," ) //Quebrando a String nas virgulas e criando um array com as posições geradas

	DO CASE
		CASE cE4TpPag == '1'
		
		CASE cE4TpPag == '2'
		
		CASE cE4TpPag == '3'
		
		CASE cE4TpPag == '4'
		
		CASE cE4TpPag == '5'
		
		CASE cE4TpPag == '6'
		
		CASE cE4TpPag == '7'
		
		CASE cE4TpPag == '8'
		
		CASE cE4TpPag == '9'

	ENDCASE
   //<b>LOCADORA</b> 

	_cMsg += '<p>5.1. A <b>LOCADORA</b>, neste ato e na melhor forma de direito, fornece à <b>LOCATÁRIA</b>,'
	_cMsg += 'opção de compra do equipamento no valor residual <b>'+AllTrim(Transform(TMP1->CN9_VLROPC,"@ze 999,999,999,999.99"))+' ('+EXTENSO(TMP1->CN9_VLROPC) +'),</b> '
	_cMsg += 'conforme <b>Anexo I</b> parte integrante deste instrumento, valor este que poderá ser dividido '
	_cMsg += ' em até '+CVALTOCHAR(TMP1->CN9_NPARC)+' ('+EXTENSO(TMP1->CN9_NPARC) +'), parcelas, desde que não haja '
	_cMsg += 'débitos referente à locação.</p>'

	_cMsg += '<p>5.2. Exercida a opção de compra, nos termos deste contrato, a <b>LOCADORA</b> comunicará'
	_cMsg += 'à <b>PROMITENTE VENDEDORA</b> da venda, sendo que a mesma, ficará obrigada a vender os '
	_cMsg += 'geradores materializados nesse contrato.</p>'

	_cMsg += '<p>5.3. A opção de compra poderá ser exercida pela <b>LOCATÁRIA</b>, desde que tenha quitado '
	_cMsg += 'integralmente os montantes estabelecidos no presente instrumento.</p>'

	_cMsg += '<p>5.4. Dá-se à <b>LOCATÁRIA</b> a opção de quitar, a qualquer momento, o montante integral '
	_cMsg += '<b>de cada grupo gerador</b>, de forma individualizada, durante a vigência do contrato; sendo que '
	_cMsg += 'o montante pago será abatido de forma proporcional no valor total do presente contrato.</p>'


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
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> VENDEDORA</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> COMPRADORA</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(sm0->m0_nomecom)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->A1_NOME)+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(sm0->m0_nome)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '</tr>'
	//_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td>&nbsp;</td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td>&nbsp;</td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> TESTEMUNHAS</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->CN9_NOME1)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->CN9_NOME2)+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->CN9_CPF1),'@R 999.999.999-99')+'</font> </td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> CPF:</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->CN9_CPF2),'@R 999.999.999-99')+'</font> </td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">  CPF:</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
    
	//Anexo I -Forma de Pagamento - Inicio

    //_cMsg += '<h2>Anexo I -Forma de Pagamento</h2>'
	_cMsg += '<table class="dados_produtos">'
	_cMsg += '<thead>'
	_cMsg += '<th align="center"><b>Parcela</b></th>'
	_cMsg += '<th align="center"><b>Data</b></th>'
	_cMsg += '<th align="center"><b>Valor</b></th>'
	_cMsg += '</thead>'	
	_cMsg += '<tbody>'

	vTotPrd := 0

    DbSelectArea("ZPR")
	DbSetOrder(1)
	dbSeek(xFilial("ZPR")+SUBSTR(TMP1->CN9_NUMERO,7,9))  //TMP1->CN9_NUMERO

    DO WHILE xFilial("ZCL") = ZPR->ZPR_FILIAL .and. SUBSTR(TMP1->CN9_NUMERO,7,9) = ZPR->ZPR_NOTA      
	    If ZPR->ZPR_OPCCOM <> "S"  

		_cMsg += '<tr>'
		_cMsg += '<td>'+ZPR->ZPR_PARC+'</td>'
		_cMsg += '<td align="center">'+alltrim(cvaltochar(ZPR->ZPR_VENC))+'</td>'
		_cMsg += '<td align="right">R$ '+AllTrim(Transform(ZPR->ZPR_VALOR,"@ze 999,999,999,999.99"))+'</td>'
		_cMsg += '</tr>'

		   //_cMsg += '<tr><td>'+ZPR->ZPR_PARC+'</td><td align="right">'+CVALTOCHAR(ZPR->ZPR_VENC)+'</td><td align="right">R$ '+AllTrim(Transform(ZPR->ZPR_VALOR,"@ze 999,999,999,999.99"))+'</td></tr>
           vTotPrd := vTotPrd + ZPR->ZPR_VALOR 
		EndIf
		   ZPR->(dbskip())
    EndDo 

    _cMsg += '<tr><td><b>TOTAL:</b></td><td>R$ '+Transform(vTotPrd,"@ze 999,999,999,999.99")+'</td></tr>'
    _cMsg += '<tr><td><b></b></td><td>Da Opção de Compra</td></tr>'

	DbSelectArea("ZPR")
	DbSetOrder(1)
	dbSeek(xFilial("ZPR")+SUBSTR(TMP1->CN9_NUMERO,7,9))  //TMP1->CN9_NUMERO

    DO WHILE xFilial("ZCL") = ZPR->ZPR_FILIAL .and. SUBSTR(TMP1->CN9_NUMERO,7,9) = ZPR->ZPR_NOTA         
		If ZPR->ZPR_OPCCOM == "S" 
		   _cMsg += '<tr><td>'+ZPR->ZPR_PARC+'</td><td align="right">'+CVALTOCHAR(ZPR->ZPR_VENC)+'</td><td align="right">R$ '+AllTrim(Transform(ZPR->ZPR_VALOR,"@ze 999,999,999,999.99"))+'</td></tr>
           vTotOpc := vTotOpc + ZPR->ZPR_VALOR              
		EndIf
		  ZPR->(dbskip())
    EndDo 

    _cMsg += '<tr><td><b>TOTAL:</b></td><td>R$ '+Transform(vTotOpc,"@ze 999,999,999,999.99")+'</td></tr>'

	//vlrcopc := TMP1->CN9_VLROPC/TMP1->CN9_N
    _cMsg += '</tbody>'
    _cMsg += '</table>'

    //Anexo I -Forma de Pagamento - Inicio
	
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

//Retorna o Total do Contrato com os juros 31/03/2023
Static Function totcjur()
//Verifica se o arquivo TMP está em uso 
 
Local _Tot := 0
      
	If Select("TZPR") > 0
	   TZPR->(DbCloseArea())
	EndIf
	cQry := " SELECT ZPR_FILIAL, ZPR_NOTA,ZPR_SERIE, SUM(ZPR_VALOR) Total "	 
	cQry += "FROM " + retsqlname("ZPR")+" ZPR "		
	cQry += "WHERE ZPR.D_E_L_E_T_ <> '*' "	
	cQry += "AND ZPR_OPCCOM = ' ' "	
	cQry += "AND ZPR_FILIAL = '" + cFilAnt + "' " 
	cQry += "AND ZPR_NOTA = '" +substr(_Contr,7,9) + "' "
	cQry += "GROUP BY ZPR_FILIAL, ZPR_NOTA,ZPR_SERIE "   
     	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TZPR",.T.,.T.) 
	
   _Tot := TZPR->Total	
	
Return _Tot



//Inicio impressão de contrato 006 25/11/2021 - Contrato de locação Rapida

//???????????????????????????????????????????????????????????????????????????
Static Function Cont006()
//???????????????????????????????????????????????????????????????????????????		
	local lhainfo	:= .f.
	local ngrupo	:= 0
	local agrupo	:= {}
	local aitem		:= {}
	local cultnum	:= ""
	local _cTpCon   := ""
	local _cFunc    := ""
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
	_cMsg += '    line-height: 1.5;'
	_cMsg += '  }'
	_cMsg += '  #tabela_pagamento {'
	_cMsg += '    page-break-before: always;'
	_cMsg += '  }'
	_cMsg += '  #assinaturas {'
	_cMsg += '    page-break-before: always;'
	_cMsg += '  }'
	_cMsg += '  * {'
	_cMsg += '    padding-bottom: 0.5cm; /*Ravylla falou que nao tem importancia esse bloco que da um espaçamento de 0.5 cm entre cada elementro da impressão. Ganhou 1,3mm entre a ultima linha de cada pagina e o rodapé*/'
	_cMsg += '  }'
	_cMsg += '}'
	_cMsg += '@page{'
	_cMsg += '  size: auto;'
	_cMsg += '  margin-top: 2cm;'
	_cMsg += '  margin-left: 3cm;'
	_cMsg += '  margin-right: 2cm;'
	_cMsg += '  margin-bottom: 0.8cm;'
	_cMsg += '  padding-bottom: 3cm;'
	_cMsg += '}'

	_cMsg += '</style>'
	_cMsg += '<body>'
	//	_cMsg += '<img src = "'+cLogoD+'">'   	//figura \system\logoorc.png
	//  	_cMsg += '<img src="system\LGMID.png"> </td>'   http://brggeradores.com.br/vendas/LogoMini.png
	//	_cMsg += '<img src="C:\Temp\LGMID.png" height="100" width="98" ></td>'
	_cMsg += '<img src="http://brggeradores.com.br/vendas/LogoMini.png" height="120" width="118" >'//</td>'
	_cMsg += '<b><p align="right"> Contrato n. '+rtrim(TMP1->CN9_NUMERO)+'/'+cvaltochar(Year(STOD(TMP1->CN9_DTINIC)))+'</b> <br /> </p>'   //Year(STOD(TMP1->CN9_NUMERO))
	_cMsg += '<b align="left">'+_cTpCon+'</b> <br />'

	_cMsg += '<p align="justify">Pelo presente instrumento particular, Parte Contratada e Parte Contratante, nesta e na melhor forma de direito, de uma lado: </p>'

	//PARAGRAFO VENDEDORA
	_cMsg += '<b><p align="justify">'+rtrim(sm0->m0_nomecom)+'</b>'
	_cMsg += ', nome fantasia <b>'+rtrim(substr(sm0->m0_nomecom,1,20))+'</b>'
	_cMsg += ', pessoa jurídica de direito privado, inscrita no CNPJ/MF sob o N. '+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')'
	_cMsg += ', com sede à ' +rtrim(sm0->m0_endcob)+', '+rtrim(sm0->m0_baircob)+ ' na cidade de '+rtrim(sm0->m0_cidcob)+' - '+sm0->m0_estcob
	_cMsg += ', conforme Contrato Social, aqui representada por seu sócio administrador o Sr. SILVIO HENRIQUE CRISPIM OLIVEIRA, Brasileiro, empresário, solteiro, portador da cédula de '
	_cMsg += ' identidade nº. 5151277 2ª via SSP/GO, inscrito  n. 035.566.211-69, sendo encontrado na sede da empresa, doravante denominada simplesmente <b>"CONTRATADA"</b>. </p>'

	//PARAGRAFO COMPRADOR  (venda de Gerador)
	_cMsg += '<b><align="left">e, do outro lado</b> <br />'
	_cMsg += '<b><p align="justify">'+rtrim(TMP1->A1_NOME)+'</b>'
	If TMP1->A1_PESSOA = "F"
		_cMsg += ' pessoa física, nome fantasia ' +rtrim(TMP1->A1_NREDUZ)+', inscrita no CPF sob o Nº. '+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')'
	Else
		_cMsg += ', pessoa jurídica de direito privado, nome fantasia ' +rtrim(TMP1->A1_NREDUZ)+', inscrita no CNPJ (MF) sob o Nº. '+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')'
	EndIf
	//_cMsg += ', Inscrição Estadual nº '+rtrim(TMP1->A1_INSCR)
	_cMsg += ', endereço na ' +rtrim(TMP1->A1_END)+', '+rtrim(TMP1->A1_BAIRRO)+', Cep '+transform((TMP1->A1_CEP),'@R 99999-999')+ ' na cidade de '+rtrim(TMP1->A1_MUN)+' - '+TMP1->A1_EST

	DbSelectArea("SU5")
	DbSetOrder(1)
	dbSeek(xFilial("SU5")+TMP1->AC8_CODCON)
	_cMsg += ', através de seu representante legal, Sr(a) '+rtrim(SU5->U5_CONTAT)
	_cMsg += ', Nacionalidade: ' +rtrim(SU5->U5_NACIONA)
	_cFunc := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")
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
	_cMsg += ', Estado Civil: ' +rtrim(EstCiv)
	_cMsg += ', Profissão: '+rtrim(_cFunc)
	_cMsg += ', residente e domiciliado à ' +rtrim(SU5->U5_END)+', '+rtrim(SU5->U5_BAIRRO)+' Cep '+transform((SU5->U5_CEP),'@R 99999-999')+ ' na cidade de '+rtrim(SU5->U5_MUN)+' - '+SU5->U5_EST
	_cMsg += ', inscrito no CPF de n. ' + transform((SU5->U5_CPF),'@R 999.999.999-99')+', doravante designada simplesmente de <b>"CONTRATANTE"</b> </p>'

	_cMsg += '<p align="justify">e, quando referidos em conjunto, simplesmente denominado <b>"PARTES"</b>, resolvem, de comum acordo, celebrar o presente Instrumento Particular'
	_cMsg += 'de Contrato de Locação de Bens Móveis e outras avenças ("Contrato"), de acordo com as seguintes cláusulas, termos e condições. </p>'
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
	EndCase

	//VALIDAÇÃO PARA CAMPO EM BRANCO - FIM 10/09/2019


	//_cMsg += '<p align="justify">As partes, acima, qualificadas têm entre si, justas e acordadas, o presente contrato de venda de energia elétrica '
	//_cMsg += 'de curto prazo que se regerá pelas cláusulas e condições seguintes: </p>'

	//Clausula 1
	_cMsg += '<b><p align="justify">CLAUSULA 1. DO OBJETO -</b>'

	_cMsg += '1.1. A Parte Contratada é legítima e e exclusiva proprietária e possuidora, livre de ônus, pendências ou litígios, dos bens móveis descritos e caracterizados, '
	_cMsg += '<b>PROPOSTA N.: '+rtrim(TMP1->CN9_PROP)+'</b>, nas quantidades e especificações indicadas na primeira página e na proposta. </p> ' //Colocar a Proposta '
	_cMsg += '<p align="justify"> DESCRIÇÃO DO OBJETO: </p>'
	Geratmp2()

	DO WHILE TMP2->(!EOF())
		_cMsg += '<b align="left">'+alltrim(cvaltochar(TMP2->CNB_QUANT))+'       '+TMP2->CNB_UM+ '       '+alltrim(TMP2->CNB_PRODUT)+'/'+TMP2->CNB_DESCRI+'</b> <br />'
		TMP2->(dbskip())
	EndDo

	_cMsg += '<p align="justify">1.2. O(s) grupo(s) gerador(es) acima serão contratados para operação PRIME, com franquia de utilização livre durante o período. </p>'
     /*
     DO WHILE TMP2->(!EOF())
        _cMsg += '<b align="left">'+alltrim(cvaltochar(TMP2->CNB_QUANT))+'       '+TMP2->CNB_UM+ '       '+alltrim(TMP2->CNB_PRODUT)+'/'+TMP2->CNB_DESCRI+'</b> <br />' 
        TMP2->(dbskip())
     EndDo 
     */
	//Energia contratada
	//Local para descrever os itens -> Isso na Planilha dentro do contrato.

	//Clausula 2
	_cMsg += '<br />'
	_cMsg += '<b align="left">CLAUSULA 2. PRAZO E TÉRMINO DA LOCAÇÃO TRANSPORTE</b> <br />'

	_cMsg += '<p align="justify">2.1.  VIGÊNCIA DA LOCAÇÃO: ' +alltrim(cvaltochar(TMP1->CN9_VIGE))+'  </p>'

	//2.1
	_cMsg += '<p align="justify">2.2.  O presente contrato se encerrará com a devolução dos equipamentos bem como o pagamento de todos os '
	_cMsg += 'valores acordados, e vistoria dos equipamentos após a entrega. </p>'
	//2.2
	If TMP1->CN9_FRETE = "C"
		_cMsg += '<p align="justify">2.3.  O transporte será na modalidade FOB ( ) CIF (X) </p>'
	Else
		_cMsg += '<p align="justify">2.3.  O transporte será na modalidade FOB (X) CIF ( ) </p>'
	EndIf

	//Clausula 3
	_cMsg += '<br />'
	_cMsg += '<b align="left">CLAUSULA 3. DO VALOR DA LOCAÇÃO E FORMA DE PAGAMENTO</b> <br />'
	_cMsg += '<p align="justify">3.1.  A parte Contratada pagará Parte Contratada o valor fixo Conforme cláusula 3.2. </p>'


	_cMsg += '<p align="justify">3.2.  O valor do presente contrato de locação será de  R$ '+AllTrim(Transform(TMP1->CN9_VLINI,"@ze 999,999,999,999.99"))+' ('+EXTENSO(TMP1->CN9_VLINI) +'), '
	_cMsg += 'valor essse referente à locação dos objetos descritos na cláusula 1, bem como, a mobilização/instalação e desmobilização/desinstalação dos mesmos. </p>'
	DbSelectArea("SE4")
	DbSetOrder(1)
	dbSeek(xFilial("SE4")+TMP1->CN9_CONDPG)
	_DescPg := SE4->E4_DESCRI

	_cMsg += '<p align="justify">3.3.  O valor constante no item 3.2, será pago pela Contratante à Contratada, no prazo de ' +alltrim(_DescPg)+', '
	_cMsg += ' contados da data do presente instrumento. </p>'

	//cTxtLinha := " "

	DbSelectArea("ZCL")
	DbSetOrder(2)
	dbSeek(xFilial("ZCL")+TMP1->CN9_TPCTO)
	_Doc := ZCL->ZCL_TIPOCO
	DO WHILE ! EOF() .AND. ZCL->ZCL_FILIAL = xFilial("ZCL") .AND. ZCL->ZCL_TIPOCO == _Doc
		cTxtLinha := " "
		_cMsg += '<b align="left">CLAUSULA '+alltrim(CVALTOCHAR(ZCL->ZCL_CLAUSU))+'. '+ZCL->ZCL_TITULO+'</b> <br />'

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
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> LOCATÁRIO(A)</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(sm0->m0_nomecom)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->A1_NOME)+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(sm0->m0_nome)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td>&nbsp;</td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td>&nbsp;</td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> TESTEMUNHAS</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->CN9_NOME1)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->CN9_NOME2)+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->CN9_CPF1),'@R 999.999.999-99')+'</font> </td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> CPF:</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->CN9_CPF2),'@R 999.999.999-99')+'</font> </td>'
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

//Inicio impressão de Contrato de Compra e Venda com Reserva de Domínio 02/12/2021

//???????????????????????????????????????????????????????????????????????????
Static Function Cont007()
//???????????????????????????????????????????????????????????????????????????		
	local lhainfo	:= .f.
	local ngrupo	:= 0
	local agrupo	:= {}
	local aitem		:= {}
	LOCAL nXi       := 1
	local i         := 1
	local cultnum	:= ""
	local _cTpCon   := ""
	local _cFunc    := ""
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

	_cTpCon := Posicione("CN1",1,xFilial("CN1")+TMP1->CN9_TPCTO,"CN1_DESC2")
	//cBody += "<img src ='http://'www.xxxxx.com.br/images/title.png'>"

	procregua(0)
	incproc()
	_Contr := TMP1->CN9_NUMERO

	_cMsg := ''
	_cMsg += '<html>'
	_cMsg += '<head>'
	_cMsg += '<title></title>'
	_cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
	_cMsg += '</head>'
	_cMsg += '<style>'

	_cMsg += '@media all{   '
	_cMsg += '  body {'
	_cMsg += '    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif !important;'
	_cMsg += '    font-size: 14;'
	_cMsg += '    line-height: 1.5;'
	_cMsg += '  }'
	_cMsg += '  #tabela_pagamento {'
	_cMsg += '    page-break-before: always;'
	_cMsg += '  }'
	_cMsg += '  #assinaturas {'
	_cMsg += '    page-break-before: always;'
	_cMsg += '  }'
	_cMsg += '  * {'
	_cMsg += '    padding-bottom: 0.5cm; /*Ravylla falou que nao tem importancia esse bloco que da um espaçamento de 0.5 cm entre cada elementro da impressão. Ganhou 1,3mm entre a ultima linha de cada pagina e o rodapé*/'
	_cMsg += '  }'
	_cMsg += '}'
	_cMsg += '@page{'
	_cMsg += '  size: auto;'
	_cMsg += '  margin-top: 2cm;'
	_cMsg += '  margin-left: 3cm;'
	_cMsg += '  margin-right: 2cm;'
	_cMsg += '  margin-bottom: 0.8cm;'
	_cMsg += '  padding-bottom: 3cm;'
	_cMsg += '}'

	_cMsg += '</style>'
	_cMsg += '<body>'
	//	_cMsg += '<img src = "'+cLogoD+'">'   	//figura \system\logoorc.png
	//  	_cMsg += '<img src="system\LGMID.png"> </td>'   http://brggeradores.com.br/vendas/LogoMini.png
	//	_cMsg += '<img src="C:\Temp\LGMID.png" height="100" width="98" ></td>'
	_cMsg += '<img src="http://brggeradores.com.br/vendas/LogoMini.png" height="120" width="118" >'//</td>'
	_cMsg += '<b><p align="right"> Contrato n. '+rtrim(TMP1->CN9_NUMERO)+'/'+cvaltochar(Year(STOD(TMP1->CN9_DTINIC)))+'</b> <br /> </p>'   //Year(STOD(TMP1->CN9_NUMERO))
	_cMsg += '<b align="left">'+_cTpCon+'</b> <br />'

	//PARAGRAFO VENDEDORA
	_cMsg += '<b><p align="justify">'+rtrim(sm0->m0_nomecom)+'</b>'
	_cMsg += ', nome fantasia <b>'+rtrim(substr(sm0->m0_nomecom,1,30))+'</b>'
	_cMsg += ', pessoa jurídica de direito privado, inscrita no CNPJ (MF) sob o N. '+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')'
	_cMsg += ', localizada na ' +rtrim(sm0->m0_endcob)+', '+rtrim(sm0->m0_baircob)+ ' na cidade de '+rtrim(sm0->m0_cidcob)+' - '+sm0->m0_estcob
	_cMsg += ', através de sua representante legal Sra. Paula Cristina Crispim Oliveira Bueno, Brasileira, Casada, empresária, inscrita no CPF sob o '
	_cMsg += ' n. 016.997.101-55, residente e domiciliada na cidade de Anápolis - GO, doravante designada simplesmente de VENDEDORA.</p>'

	//PARAGRAFO COMPRADOR  (venda de Gerador)
	_cMsg += '<b><align="left">E DE OUTRO LADO</b> <br />'
	_cMsg += '<b><p align="justify">'+rtrim(TMP1->A1_NOME)+'</b>'
	If TMP1->A1_PESSOA = "F"
		_cMsg += ' pessoa física, nome fantasia ' +rtrim(TMP1->A1_NREDUZ)+', inscrita no CNPJ (MF) sob o N. '+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')'
	Else
		_cMsg += ', pessoa jurídica de direito privado, nome fantasia ' +rtrim(TMP1->A1_NREDUZ)+', inscrita no CNPJ (MF) sob o N. '+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')'
	EndIf
	_cMsg += ', Inscrição Estadual N. '+rtrim(TMP1->A1_INSCR)
	_cMsg += ', endereço na ' +rtrim(TMP1->A1_END)+', '+rtrim(TMP1->A1_BAIRRO)+', Cep '+transform((TMP1->A1_CEP),'@R 99999-999')+ ' na cidade de '+rtrim(TMP1->A1_MUN)+' - '+TMP1->A1_EST

	DbSelectArea("SU5")
	DbSetOrder(1)
	dbSeek(xFilial("SU5")+TMP1->AC8_CODCON)
	_cMsg += ', através de seu representante legal, Sr(a) '+rtrim(SU5->U5_CONTAT)
	_cMsg += ', Nacionalidade: ' +rtrim(SU5->U5_NACIONA)
	_cFunc := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")
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
	_cMsg += ', Estado Civil: ' +rtrim(EstCiv)
	_cMsg += ', Profissão: '+rtrim(_cFunc)
	_cMsg += ', residente e domiciliado à ' +rtrim(SU5->U5_END)+', '+rtrim(SU5->U5_BAIRRO)+' Cep '+transform((SU5->U5_CEP),'@R 99999-999')+ ' na cidade de '+rtrim(SU5->U5_MUN)+' - '+SU5->U5_EST
	_cMsg += ', inscrito no CPF de n. ' + transform((SU5->U5_CPF),'@R 999.999.999-99')+', doravante designada simplesmente de COMPRADORA.</p>'

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
		MSGINFO("Preencher o CPF do Contato !!!!!"," Atenção ")
		Return
	EndCase

	//VALIDAÇÃO PARA CAMPO EM BRANCO - FIM 10/09/2019


	_cMsg += '<p align="justify">As partes, acima, qualificadas têm entre si, justas e acordadas, o presente contrato de compra e venda de grupos geradores '
	_cMsg += 'equipamentos auxiliares, que se regerá pelas cláusulas e condições seguintes: </p>'
	// _cMsg += '<b><p align="center">DA UTILIZAÇÃO DA GARANTIA</b> </p>'
	//Clausula 1
	_cMsg += '<b><p align="justify">CLAUSULA 1. DO OBJETO</b></br></br>'
	_cMsg += '1.1. Constitui-se objeto deste contrato de compra e venda, o(s) produtos(s) e demais condições comerciais descritas na, '
	_cMsg += '<b>PROPOSTA N.: '+rtrim(CN9->CN9_PROP)+'</b>, parte integrante do presente instrumento. </p> ' //Colocar a Proposta '
	_cMsg += '<p align="justify">1.2.  Sendo eles: </p>'
	Geratmp2()

	DO WHILE TMP2->(!EOF())
		_cMsg += '<b align="left">'+alltrim(cvaltochar(TMP2->CNB_QUANT))+'       '+TMP2->CNB_UM+ '       '+alltrim(TMP2->CNB_PRODUT)+'/'+TMP2->CNB_DESCRI+'</b> <br />'
		TMP2->(dbskip())
	EndDo

	//Local para descrever os itens -> ISso na Planilha dentro do contrato.

	//Clausula 2
	_cMsg += '<br />'
	_cMsg += '<b align="left">CLAUSULA 2. DA RESERVA DE DOMÍNIO, CONSERVAÇÃO E USO DO BEM</b> <br />'

	//2.1
	_cMsg += '<p align="justify">2.1.  Em Virtude da Reserva de Domínio, estabelecida neste instrumento, fica reservado à <b>VENDEDORA</b> o direito '
	_cMsg += 'de propriedade sobre os equipamentos, indicados no item 1.2 do objeto do presente, até a total quitação das parcelas estabelecidas '
	_cMsg += 'pelas partes para o pagamento. </p>'
	//2.2
	_cMsg += '<p align="justify">2.2.  A <b>COMPRADORA</b> fica obrigada em conservar o bem, objeto deste contrato, até o pagamento de todas as '
	_cMsg += 'parcelas, ficando à suas custas a perfeita manutenção e integridade, zelando pelo seu bom funcionamento, sendo defesa a sua '
	_cMsg += 'alteração de estrutura, funções ou aparência. </p>'

	//Clausula 3
	_cMsg += '<br />'
	_cMsg += '<b align="left">CLAUSULA 3. DAS CONDIÇÕES COMERCIAIS, ASSISTENCIA TECNICA E GARANTIA</b> <br />'
	//3.1
	_cMsg += '<p align="justify">3.1.  Os equipamentos fornecidos pela <b>VENDEDORA</b>, à <b>COMPRADORA</b> atenderão a todas as especificações, solicitadas pela  '
	_cMsg += '<b>COMPRADORA</b>, atendendo aos padrões específicos do seu ramo de atividade e setor comercial. </p>'
	//3.2
	_cMsg += '<p align="justify">3.2.  É garantido pela <b>VENDEDORA</b> que os produtos fabricados estão de acordo com previsto na legislação brasileira, '
	_cMsg += 'pois se trata de aquisição, por parte da <b>COMPRADORA</b>, de produtos para incrementação da atividade comercial da mesma, '
	_cMsg += 'aplicando assim os dispositivos previstos no Código Civil Brasileiro. </p>'
	//3.3
	_cMsg += '<p align="justify">3.3.  A <b>VENDEDORA</b> fará a <b>ENTREGA TÉCNICA POR MEIO DO TERMO DE ACEITACÃO DE ENTREGA AO COMPRADOR</b> '
	_cMsg += 'quando do primeiro funcionamento em campo (TESTE), esse primeiro funcionamento deverá ser efetuado por um técnico credenciado, para validação da garantia '
	_cMsg += 'do equipamento, nas bases de atendimento nas cidades de <b>Anápolis - GO ou Goiânia - GO.</b> </p>'
	//3.4
	_cMsg += '<p align="justify">3.4.  Para realização de entrega técnica e atendimentos em garantia, em horário comercial, as despesas de: '
	_cMsg += '<b>deslocamento, viagem, estada em hotéis ou similares, pedágios e alimentação,</b>  '
	_cMsg += 'para um raio de atendimento superior à 50 KM da base de atendimento, correrão por conta do(a) Comprador(a). </p>'
	//3.5
	_cMsg += '<p align="justify">3.5.  No que se refere a ASSISTÊNCIA TÉCNICA a <b>VENDEDORA</b> coloca a disposição da <b>COMPRADORA</b>, nas cidades de Anápolis - GO e '
	_cMsg += 'Goiânia - GO,  uma equipe técnica especializada com treinamento na fábrica e peças sobressalentes para toda a linha de equipamentos. </p>'
	//3.6
	_cMsg += '<p align="justify">3.6.  Após a validação e entrega técnica e início da primeira partida do(s) equipamento(s), inicia-se o prazo de '
	_cMsg += 'Garantia pelo período de: </p>'

	//Garantia Inicio

    /*
    Alterado por Marlon Pablo
    
    #################
      Foi comentado a pedido da Ravylla em 15/02/2022 Às 15:09 
      Remover esse bloco porque usam o campo CN9_GARANT inserindo manualmente os dados da garantia
    #################

   	IF CN9->CN9_TPGARA = "B"
   	   _cMsg += '<p align="justify" style="margin-left: 150px;">(i) '+cvaltochar(TMP1->CN9_MESPRI)+' ('+EXTENSO(TMP1->CN9_MESPRI,.T.)+')  meses sem limite de horas trabalhadas em Regime '   
       _cMsg += ' Prime, ou '+cvaltochar(TMP1->CN9_MESLTP)+' ('+EXTENSO(TMP1->CN9_MESLTP,.T.)+') meses, respeitando-se o limite de 500 horas, quando em Regime LTP (Emergência), ' 
   	   _cMsg += ' em conformidade com a Norma ISO 8528, contados da data de emissão da nota fiscal de venda, ou seja, quando da efetiva tradição do(s) equipamento(s). </p>'    	 	
   	EndIf 
     */                                                    
	cGarant := " "
	nLinhas := MLCount(CN9->CN9_GARANT,140)
	For nXi:= 1 To nLinhas
		cGarant += MemoLine(CN9->CN9_GARANT,140,nXi)
	Next nXi
	_cMsg += '<p style="margin-left: 150px;">'+ cGarant+'</p>'
	//3.7
	_cMsg += '<p align="justify">3.7.  Todos os pesos, medidas, tamanhos, legendas ou descrições impressas, estampadas, anexadas ou de qualquer outra maneira '
	_cMsg += ' indicadas, no que se refere ao(s) produto(s), são atestadas como verdadeiras e corretas pela <b>VENDEDORA.</b> '
	_cMsg += ' Desta forma, estão em conformidade e atendem as normas e regulamentações relacionados com o(s) referido(s) produto(s). </p>'
	//3.8
	_cMsg += '<p align="justify">3.8.  A <b>VENDEDORA</b> fará a <b>ENTREGA TÉCNICA E GARANTIAS</b> quando do primeiro funcionamento em campo, que deverá ser efetuado '
	_cMsg += 'por um técnico credenciado, para validação da garantia do equipamento, na base de atendimento na cidade de '+rtrim(sm0->m0_cidcob)+'.</p>'

	_cMsg += '<b><p align="center">DA VERIFICAÇÃO DA MÁQUINA ANTES DA ENTREGA</b> </p>'
	//3.9
	_cMsg += '<p align="justify">3.9.  A COMPRADORA deverá inspecionar o(s) grupo(s) gerado(es) e seu(s) equipamentos(s), com antecedência de 48 (quarenta e oito) horas, '
	_cMsg += ' mediante pré-agendamento com o departamento comercial. </p>'
	//3.10
	_cMsg += '<p align="justify">3.10.  A VENDEDORA coloca à disposição seus engenheiros e/ou técnicos especializados, para uma visita, onde a COMPRADORA fará verificação '
	_cMsg += 'técnica e inspeção do(s) grupo(s) gerador(es) na base de inspeção, acompanhados de um check-list denominado TAF (Termo de Aceitação de Fábrica) '
	_cMsg += ', que será fornecido no ato da vistoria do equipamento. </p>'
	//3.10.1
	_cMsg += '<b align="justify">3.10.1. ATENÇÃO: A dispensa da visita e vistoria, por parte da COMPRADORA, importará no aceite das '
	_cMsg += ' condições de fábrica bem como o pleno funcionamento do(s) equipamento(s). </font></b>'

	_cMsg += '<b><p align="center">DA UTILIZAÇÃO DA GARANTIA</b> </p>'
	//3.11
	_cMsg += '<p align="justify">3.11.  A garantia só abrangerá as peças e componentes que tenham defeito original de fábrica ou defeitos de funcionamento descritos nas '
	_cMsg += ' condições normais de uso e que estejam de acordo com as instruções que acompanharão o(s) grupo(s) gerador(es), mediante comprovação feita por vistoria preliminar. </p>'
	//3.12
	_cMsg += '<p align="justify">3.12.  A garantia não cobre avarias ocasionadas pelo uso inapropriado e ficará automaticamente cancelada se os equipamentos '
	_cMsg += ' vierem a sofrer danos decorrentes de acidentes, chuva, água, quedas, variações de tensão elétrica e sobrecarga acima do especificado, utilização '
	_cMsg += ' de combustível adulterado, utilização de óleo lubrificante de procedência duvidosa ou fora da lista de autorizados constantes do manual, ou '
	_cMsg += ' qualquer ocorrência imprevisível, decorrentes de má utilização dos equipamentos por parte do usuário. </p>'
	//3.13
	_cMsg += '<p align="justify">3.13.  Os custos e despesas necessárias para o saneamento do defeito, vício, falha ou não conformidade, tais como fretes, '
	_cMsg += ' embalagens, desmontagem e montagem, correção por conta integral da COMPRADORA. </p>'
	//3.14
	_cMsg += '<p align="justify">3.14.  A garantia não inclui a substituição do equipamento por outro equivalente, enquanto perdurar o reparo, conserto e ou '
	_cMsg += ' verificação do equipamento em garantia. </p>'
	//3.15
	_cMsg += '<p align="justify">3.15.  Despesas com viagem, alimentação e estada da equipe técnica da a VENDEDORA correrão por conta da COMPRADORA. </p>'
	//4.
	_cMsg += '<b align="left">CLAUSULA 4. DO FRETE</b> <br />'
	If CN9->CN9_FRETE = "C"
		_Frete := "CIF"
	Else
		_Frete := "FOB"
	EndIf

	_cMsg += '<p align="justify"></b>4.1.  O FRETE será na modalidade '+_Frete+' conforme indicado na <b>PROPOSTA N.: '+rtrim(CN9->CN9_PROP)+'</b>  </p>'

	_cMsg += '<p align="justify">4.2.  O transporte vertical será de inteira responsabilidade da COMPRADORA. </p>'

	If  CN9->CN9_FRETE = "F"
		_cMsg += '<b><p align="center"><font face="Doppio One" size="2"> DA MODALIDADE FOB (free on board)</font> </p></b>'
		//4.3
		_cMsg += '<p align="justify">4.3.  A responsabilidade pelos custos com frete, seguro e despesas relacionadas ao transporte horizontal e vertical, correrão '
		_cMsg += ' de inteira responsabilidade da COMPRADORA, ou seja, será realizado na modalidade FOB-ANÁPOLIS/GO. </p> '
		//4.2
		_cMsg += '<p align="justify">4.4.  Em caso de problemas técnicos e/ou avarias no equipamento correrão todos os custos referentes a frete e transporte por conta da '
		_cMsg += ' COMPRADORA para o translado do equipamento até a base de Anápolis/GO para análise técnica do equipamento que será realizada em um período não superior a 30(trinta) dias. </p>'
	Else
		_cMsg += '<b><p align="center"><font face="Doppio One" size="2"> DA MODALIDADE CIF (cost, Insurance and Freigth)</font> </p></b>'
		//4.3
		_cMsg += '<p align="justify">4.3.  Optando a COMPRADORA por transporte na modalidade CIF , a VENDEDORA será a responsável pelo transporte horizontal. '
		_cMsg += 'A COMPRADORA responsabilizar-se-á com o transporte vertical, além dos gastos para locação de caminhão munck, para descarregamento, que serão por conta da COMPRADORA. </p>'
	EndIf
	//4.
	_cMsg += '<b align="left">CLAUSULA 5. PREÇO E CONDIÇÕES DE PAGAMENTO</b> <br />'
	//4.1
	_cMsg += '<p align="justify">5.1.  A COMPRADORA pagará à VENDEDORA '
	_cMsg += ' pela(s) mercadoria(s) vendida(s) e que é(são) objeto do presente contrato, no valor de R$ '+AllTrim(Transform(TMP1->CN9_VLINI,"@ze 999,999,999,999.99"))+' ('+EXTENSO(TMP1->CN9_VLINI) +'). </p>'
	//4.2
	_cMsg += '<p align="justify">5.2.  O valor previsto acima será pago da seguinte forma: </p>'
	nValTot := TMP1->CN9_VLINI
	cCond   := TMP1->CN9_CONDPG
	dData   := STOD(TMP1->CN9_ASSINA)
	nVIPI   := 0

	aParc := Condicao(nValTot,cCond,nVIPI,dData)
	_cMsg += '<table border="1"><thead><tr><th>Parcela</th><th>Vencimento</th><th>Valor</th></tr></thead> '

	//Alteração Ricardo para contratos com Entrada 29/10/2019 - Inicio
	If TMP1->CN9_ENTRAD > 0
		_Parc  := "ENTRADA"
		_cMsg += '<tr><td>'+_Parc+'</td><td>'+CVALTOCHAR(STOD(TMP1->CN9_DTINIC))+'</td><td>'+AllTrim(Transform(TMP1->CN9_ENTRAD,"@ze 999,999,999,999.99"))+'</td></tr> '
	EndIf
	//Alteração Ricardo para contratos com Entrada 29/10/2019 - Fim

	DbSelectArea("SE4")
	DbSetOrder(1)
	dbSeek(xFilial("SE4")+cCond)
	If SE4->E4_TIPO <> "A"

		For i:= 1 to Len(aParc)
			_Venc := aParc[i,1]   //retorna a data em branco
			_Total := aParc[i,2]   // CtoD("28/06/2018")
			_Parc  := cvaltochar(i)
			If cCond = "001"
				_cMsg += '<tr><td>'+_Parc+'</td><td>'+CVALTOCHAR(STOD(TMP1->CN9_DTINIC))+'</td><td>'+AllTrim(Transform(_Total,"@ze 999,999,999,999.99"))+'</td></tr> '
			Else
				_cMsg += '<tr><td>'+_Parc+'</td><td>'+CVALTOCHAR(_Venc)+'</td><td>'+AllTrim(Transform(_Total,"@ze 999,999,999,999.99"))+'</td></tr> '
			EndIf
			//_cMsg += '<table border="1"><align="center"><tr><td>'+_Parc+'</td><td>'+AllTrim(Transform(_Total,"@ze 999,999,999,999.99"))+'</td></tr> '
		Next i
		_cMsg += '<tr><td></td><td>TOTAL</td><td>'+AllTrim(Transform(TMP1->CN9_VLINI,"@ze 999,999,999,999.99"))+'</td></tr> '
		_cMsg += '</table>'
	Else
		_cMsg += '<p align="justify"> - '+SE4->E4_COND+'</b>  </p>'
	EndIf


	//FAZER LISTAR OS VALORES A PAGAR CONFORME A IMPRESSAO EM TABELAS ... DATA E VALOR
	//5.3
	_cMsg += '<p align="justify">5.3.  O atraso no pagamento das parcelas previstas acima, quando for o caso, implicará em multa de 5% (cinco por cento) '
	_cMsg += ' ao mês, juros de mora de 1% ao mês <i>pró rata die</i> de atraso, e correção monetária conforme índice do IGPM (FGV) Positivo, ou outro que venha substituí-lo. </p>'
	//5.4
	_cMsg += '<p align="justify">5.4.  As partes acordam que a purgação da mora não isentará a Compradora do pagamento da multa Contratual prevista no Item 9.1, '
	_cMsg += ' salvo acordo formalizado entre as partes. </p>'

	//cTxtLinha := " "

	DbSelectArea("ZCL")   //_cMsg += '<b align="left">CLAUSULA 5. PREÇO E CONDIÇÕES DE PAGAMENTO</b> <br />'     O FRETE será modalidade '+_Frete+' conforme indicado na <
	DbSetOrder(2)
	dbSeek(xFilial("ZCL")+TMP1->CN9_TPCTO)
	_Doc := ZCL->ZCL_TIPOCO
	DO WHILE ! EOF() .AND. ZCL->ZCL_FILIAL = xFilial("ZCL") .AND. ZCL->ZCL_TIPOCO == _Doc
		cTxtLinha := " "
		_cMsg += '<b align="left">CLAUSULA '+alltrim(CVALTOCHAR(ZCL->ZCL_CLAUSU))+'. '+ZCL->ZCL_TITULO+'</b> <br />'

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
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> VENDEDORA</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> COMPRADORA</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(sm0->m0_nomecom)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->A1_NOME)+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(sm0->m0_nome)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->A1_CGC),'@R 99.999.999/9999-99')+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td>&nbsp;</td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td>&nbsp;</td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> TESTEMUNHAS</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2">_________________________________________________</font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->CN9_NOME1)+'</font> </td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+rtrim(TMP1->CN9_NOME2)+'</font> </td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->CN9_CPF1),'@R 999.999.999-99')+'</font> </td>'
	_cMsg += '<td><align="left"><font face="Doppio One" size="2"> CPF:</font></td>'
	_cMsg += '<td><font face="Doppio One" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>'
	//_cMsg += '<td><align="left"><font face="Doppio One" size="2">'+transform((TMP1->CN9_CPF2),'@R 999.999.999-99')+'</font> </td>'
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
