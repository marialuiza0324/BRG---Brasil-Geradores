/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M116ACOL  ³ Autor ³ RICARDO MOREIRA       ³ Data ³ 04/10/18³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Para Notas com Frete e Lote ja vem preenchido o Lote       ³±±
±±³          ³ na entrada da nota de conhecimento de Frete                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para BRG                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³// 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function M116ACOL()
 
Local cAliasSD1 := PARAMIXB[1]   //-- Alias arq. NF Entrada itens
Local nX       := PARAMIXB[2]    //-- Número da linha do aCols correspondente
Local aDoc  := PARAMIXB[3]    //-- Vetor contendo o documento, série, fornecedor, loja e itens do documento//-- Processamento de usuário
Local  nPosItem := aScan(aHEADER,{|x| Trim(x[2])=="D1_LOTECTL"})
Local  nPosDesc := aScan(aHEADER,{|x| Trim(x[2])=="D1_XDESCPR"})
Local i:= 1

FOR i:= 1 TO len(aHeader)
	Do Case
	   Case Trim(aHeader[i][2]) == "D1_LOTECTL"	
	     	acols[nX,nPosItem]:= A116INCLUI->D1_LOTECTL
       Case Trim(aHeader[i][2]) == "D1_XDESCPR"	
	     	acols[nX,nPosDesc] := A116INCLUI->D1_XDESCPR							
    EndCase
NEXT i

Return Nil