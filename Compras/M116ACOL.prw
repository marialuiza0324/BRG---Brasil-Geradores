/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � M116ACOL  � Autor � RICARDO MOREIRA       � Data � 04/10/18潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Para Notas com Frete e Lote ja vem preenchido o Lote       潮�
北�          � na entrada da nota de conhecimento de Frete                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para BRG                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    �// 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function M116ACOL()
 
Local cAliasSD1 := PARAMIXB[1]   //-- Alias arq. NF Entrada itens
Local nX       := PARAMIXB[2]    //-- N鷐ero da linha do aCols correspondente
Local aDoc  := PARAMIXB[3]    //-- Vetor contendo o documento, s閞ie, fornecedor, loja e itens do documento//-- Processamento de usu醨io
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