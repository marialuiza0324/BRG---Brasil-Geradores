/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT103IPC   ¦ Autor Claudio Ferreira      ¦  Data ¦ 17/01/18¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na confirmação da seleçao do PC usado para¦¦¦
¦¦¦          ¦ atualizar os campos customizados no Documento de Entrada e ¦¦¦
¦¦¦          ¦ na Pré Nota de Entrada após a importação dos itens do PC.  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Gravar a conta do produto na tabela SD1                    ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MT103IPC() 
Local aArea	:= GetArea() 
Local nItem := Paramixb[01]
Local nPosProd :=aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_COD" })   
Local nPosConta := aScan(aHeader,{|x| Trim(x[2])=="D1_CONTA"} )
Local lMT103CPO	:= ExistBlock("MT103CPO")    
Local aTriggerCpo:={} 

Private n :=nItem   

M->D1_COD := aCols[nItem][nPosProd]
	   
DbSelectArea("SB1")
DbSetorder(1)
Dbseek(xFilial("SB1")+M->D1_COD)

If lMT103CPO
	If nPosConta > 0
		AADD(aTriggerCpo,"D1_CONTA")  
		ExecBlock("MT103CPO",.F.,.F.,{aTriggerCpo})
	EndIf
EndIf

RestArea(aArea)

Return (.T.)
