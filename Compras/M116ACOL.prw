/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M116ACOL  � Autor � RICARDO MOREIRA       � Data � 04/10/18���
�������������������������������������������������������������������������Ĵ��
���Descricao � Para Notas com Frete e Lote ja vem preenchido o Lote       ���
���          � na entrada da nota de conhecimento de Frete                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para BRG                                     ���
��������������������������������������������������������������������������ٱ�
���Versao    �// 1.0                                                        ���
�����������������������������������������������������������������������������
*/

User Function M116ACOL()
 
Local cAliasSD1 := PARAMIXB[1]   //-- Alias arq. NF Entrada itens
Local nX       := PARAMIXB[2]    //-- N�mero da linha do aCols correspondente
Local aDoc  := PARAMIXB[3]    //-- Vetor contendo o documento, s�rie, fornecedor, loja e itens do documento//-- Processamento de usu�rio
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