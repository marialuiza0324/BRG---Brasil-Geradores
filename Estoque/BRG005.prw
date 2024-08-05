//------------------------------------------------------------------------
//Autor: Ricardo Moreira de Lima
//Data: 14/06/2018
//Função: BRG005.PRW
//Descrição: Relatório para extrair dados estoque para inventario,
//
//------------------------------------------------------------------------

#Include 'Protheus.ch'
#include 'TopConn.ch'
#INCLUDE "TBICONN.CH"
User Function BRG005() // u_VIT418()
	Local aItensExcel :={}
	private aCabExcel :={}
	Private cPerg := "BRG005"
	
	// Gera Perguntas
	geraX1()
	
	// Inicia as perguntas
	Pergunte(cPerg, .T.,"Parametros do Resumo")
	
	//Definio cabeçalho	
	aAdd(aCabExcel, {"Cod_Produto" 		    ,"C",TamSX3("BF_PRODUTO") [1], 0})
    aAdd(aCabExcel, {"Unidade"	            ,"C",TamSX3("B1_UM")      [1], 0})
	aAdd(aCabExcel, {"Descricao"	        ,"C",TamSX3("B1_DESC")    [1], 0})
	aAdd(aCabExcel, {"Tipo"					,"C",TamSX3("B1_TIPO")    [1], 0})
	aAdd(aCabExcel, {"Grupo"				,"C",TamSX3("BM_DESC")    [1], 0})
	aAdd(aCabExcel, {"Armazem"				,"C",TamSX3("B8_LOCAL")   [1], 0})
	aAdd(aCabExcel, {"Endereco"	 	        ,"C",TamSX3("B1_XENDERE") [1], 0})       //SB1	
	aAdd(aCabExcel, {"Lote"					,"C",TamSX3("B8_LOTECTL") [1], 0})
	aAdd(aCabExcel, {"Quantidade"	  		,"N",TamSX3("B8_SALDO")   [1], 5}) 
	aAdd(aCabExcel, {"Empenho"	     		,"N",TamSX3("B8_EMPENHO") [1], 5})       
	
	MsgRun("Favor Aguardar.....", "Selecionando os Registros",;
		{|| GPItens(@aItensExcel)})
	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
		{||DlgToExcel({{"GETDADOS",;
		"PLANILHA DE DADOS ESTOQUE!",;
		aCabExcel,aItensExcel}})})
Return   

// --------------------------------------------
// Compõe o array aCols
// --------------------------------------------
Static Function GPItens(aCols)  

	//Busca Dados  
	If mv_par05 = 1   	
		_sql := "select b2_cod Cod_Produto, b1_desc Descricao, b1_um Und, b1_tipo Tipo, b1_grupo Grupo, b2_local Armazem, 
		_sql += "b2_qatu Quant, b1_xendere Endereco, b2_qemp Empenho  "	
	else	
		_sql := "select b8_produto Cod_Produto, b1_um Und, b1_desc Descricao, b1_tipo Tipo, b1_grupo Grupo,b8_local Armazem, b1_xendere Endereco, "	
		_sql += "b8_lotectl Lote, b8_saldo Quant, b8_empenho Empenho "
	EndIf
		
	If mv_par05 = 1
		_sql += "from "+retsqlname("SB2")+" SB2 " 
		_sql += ", "+retsqlname("SB1")+" SB1 " 
		_sql += "where sb2.D_E_L_E_T_ <> '*' "
		_sql += "and   sb1.D_E_L_E_T_ <> '*' "
		_sql += "and b2_cod = b1_cod "
		_sql += "and b2_filial = '0101' "
		_sql += "and b1_filial = '01' "
		_sql += "and b2_local between '"+MV_PAR01+"' AND '"+MV_PAR02+"' "  
		_sql += "and b1_tipo between '"+MV_PAR03+"' AND '"+MV_PAR04+"' " 
   		_sql += "order by b1_xendere "
    else
   		_sql += "from "+retsqlname("SB8")+" SB8 " 
		_sql += ", "+retsqlname("SB1")+" SB1 " 
		_sql += "where sb8.D_E_L_E_T_ <> '*' "
		_sql += "and   sb1.D_E_L_E_T_ <> '*' "
		_sql += "and b8_produto = b1_cod "
		_sql += "and b8_filial = '0101' " 
		_sql += "and b1_filial = '01' "
		_sql += "and b8_local between '"+MV_PAR01+"' AND '"+MV_PAR02+"' "   
		_sql += "and b1_tipo between '"+MV_PAR03+"' AND '"+MV_PAR04+"' " 
   		_sql += "order by b1_xendere , b8_lotectl "
	EndIf
	//MemoWrite("C:\Totvs\rel.sql",_sql)
	
	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf
		
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_sql)),"TMP",.T.,.T.)
	
	While TMP->(!EOF()) 
			  	
		aAdd(aCols,{chr(160)+TMP->Cod_Produto,;
			TMP->Und,;	
			TMP->Descricao,;		
			TMP->Tipo,;
			TMP->Grupo+"/"+POSICIONE("SBM",1,xFilial("SBM")+TMP->Grupo,"BM_DESC"),;
			chr(160)+TMP->Armazem,;
		    chr(160)+TMP->Endereco,;			
		    IIf(MV_PAR05 = 1," ",chr(160)+TMP->Lote),;		 
		    TMP->Quant,;
			TMP->Empenho,;					
			" "})
		TMP->(dbskip())
	EndDo
Return

// --------------------------------------------
// Gera perguntas
// --------------------------------------------
Static Function geraX1()
	Local aArea    := GetArea()
	Local aRegs    := {}
	Local i	       := 0
	Local j        := 0
	Local aHelpPor := {}
	Local aHelpSpa := {}
	Local aHelpEng := {}

	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	aAdd(aRegs,{cPerg,"01","Informe o Local Inicial    ?","","","mv_ch1","C",02,0,0,"G","","mv_par01",""		 ,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","  "})
	aAdd(aRegs,{cPerg,"02","Informe o Local Final      ?","","","mv_ch2","C",02,0,0,"G","","mv_par02",""		 ,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","  "})
	aAdd(aRegs,{cPerg,"03","Informe o Tipo Inicial     ?","","","mv_ch3","C",02,0,0,"G","","mv_par03",""		 ,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","02"})
	aAdd(aRegs,{cPerg,"04","Informe o Tipo Final       ?","","","mv_ch4","C",02,0,0,"G","","mv_par04",""		 ,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","02"})
	aAdd(aRegs,{cPerg,"05","Exportar Produtos          ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Sem Lote"    ,"","","","","Com Lote","","","","","","","","","","","","","","","","","","","  "})
		
	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:=1 to Len(aRegs)
		If !DbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()		
			aHelpPor := {} ; aHelpSpa := {} ; 	aHelpEng := {}
			If i==1
				AADD(aHelpPor,"Informe o Local Inicial.			          ")
			ElseIf i==2                                 	
				AADD(aHelpPor,"Informe o Local Final.             		  ") 
			ElseIf i==3                                 	
				AADD(aHelpPor,"Informe o Tipo Inicial.             		  ")
			ElseIf i==4                                 	
				AADD(aHelpPor,"Informe o Tipo Final.             		  ")
			ElseIf i==5                                 	
				AADD(aHelpPor,"Exportar Produtos.         	        	  ")
			EndIf
			PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
		EndIf
	Next

	RestArea(aArea)
Return
