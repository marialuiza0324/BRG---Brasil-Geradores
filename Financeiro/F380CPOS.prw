/*/
�����������������������������������������������������������������������������
����������������������������f������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F380CPOS      � Autor � Ricardo         � Data �  26/04/18  ���
�������������������������������������������������������������������������͹��
���Descricao � Altera a ORdem dos Campos na Concilia��o			          ���
�������������������������������������������������������������������������͹��
���Uso       � BRG Geradores                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//Vetor com os campos que poder�o ser alterados. Se retornar um vetor vazio, todos os campos ficar�o bloqueados.

User Function F380CPOS()

Local UPAR := {}

UPAR := { { "E5_OK"  		     ,,"Rec."  },; //"Rec."      
					    { "E5_FILIAL"    ,,"Filial"         },; 		 //"Filial"
					    { "E5_BENEF"     ,, "Beneficiario"  },; //"Benefici�rio" 
					   	{ "E5_PREFIXO"   ,, "Prefixo"		},;  //"Prefixo"
						{ "E5_NUMERO"    ,, "N�mero"	    },;  //"N�mero"
						{ "E5_DTDISPO"   ,, "DT Disponivel" },; 		 //"DT Disponivel"
						{ "E5_MOEDA"     ,, "Numerario"     },; //"Numer�rio"
						{ "E5_VALOR"     ,, "Vlr. Movimen.",PesqPict("SE5","E5_VALOR",19)},; //"Vlr. Movimen."
						{ "E5_NATUREZ"   ,, "Natureza"      },; //"Natureza"
						{ "E5_BANCO"     ,, "Banco"         },; //"Banco"
						{ "E5_AGENCIA"   ,, "Agencia"       },; //"Ag�ncia"
						{ "E5_CONTA"     ,, "Conta"         },; //"Conta"
						{ "E5_NUMCHEQ"   ,, "Num. Cheque"   },; //"Num. Cheque"
						{ "E5_DOCUMEN"   ,, "Documento"     },; //"Documento"
						{ "E5_VENCTO"    ,, "Vencimeto"     },; //"Vencimeto"
						{ "E5_DATA"		 ,, "DT Movimento"  },; //"DT Movimento"
						{ "E5_RECPAG"    ,, "Rec/Pag"       },; //"Rec/Pag"					
						{ "E5_HISTOR"    ,, "Hist�rico"     },; //"Hist�rico"
						{ "E5_CREDITO"   ,, "Cta Cr�dito"   },;  //"Cta Cr�dito"					
						{ "E5_PARCELA"   ,, "Parcela"		},;  //"Parcela"
						{ "E5_TIPO" 	 ,, "Tipo"	 		},;   //"Tipo"
						{ "E5_CLIFOR"	 ,, "Cli/For"		},;  //"Cli/For"
						{ "E5_LOJA" 	 ,, "Loja"    	    }}   //"Loja" 
						
						
Return UPAR 
