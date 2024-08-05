/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑfฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ F090CPOS      บ Autor ณ Ricardo        บ Data ณ  26/04/18  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Altera a ORdem dos Campos da Baixa automatica              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BRG Geradores                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
//Vetor com os campos que poderใo ser alterados. Se retornar um vetor vazio, todos os campos ficarใo bloqueados.

User Function F090CPOS()

Local aCampos := {}

aCampos := { { "E2_OK"  		     ,,"Rec."  },; //"Rec."      
					    { "E2_FILIAL"    ,,"Filial"         },; 		 //"Filial"    OK
					    { "E2_FORNECE"   ,, "Fornecedor"    },; //"Fornecedor"   OK
					   	{ "E2_LOJA"      ,, "Loja"		    },;  //"Prefixo"     OK
						{ "E2_NOMFOR"    ,, "Nome Fornece"	},;  //"N๚mero"      OK 
						{ "E2_SALDO"     ,, "Saldo",PesqPict("SE2","E2_SALDO",19)},; //"Saldo."     OK						
						{ "E2_VENCREA"   ,, "Vencto Real"   },;  //"Vencimento Real"      OK						
						{ "E2_PREFIXO"   ,, "Prefixo"       },; //"Prefixo"      OK					
						{ "E2_NUM"       ,, "N. Titulo"     },; //"N. Titulo"    OK
						{ "E2_PARCELA"   ,, "Parcela"       },; //"Parcela"      OK						
						{ "E2_TIPO"      ,, "Tipo"          },; //"Tipo"         OK						
						{ "E2_NATUREZ"   ,, "Natureza"      },; //"Natureza"     OK						
						{ "E2_PORTADO"   ,, "Portador"      },; //"Portador"     OK						
						{ "E2_EMISSAO"   ,, "Documento"     },; //"Emissao"      OK
						{ "E2_VENCTO"    ,, "Vencimeto"     },; //"Vencimeto"    OK 
						{ "E2_VALOR"     ,, "Valor",PesqPict("SE2","E2_VALOR",19)},; //"Valor"     OK					  						
						{ "E2_ISS"       ,, "ISS"           },; //"ISS"		     OK			
						{ "E2_IRRF"      ,, "IRRF"          },; //"IRRF"         OK						
						{ "E2_HIST"      ,, "Historico"     }} //"Historico"	 OK	
						
Return aCampos 
