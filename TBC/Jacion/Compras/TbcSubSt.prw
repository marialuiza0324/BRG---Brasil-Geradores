#include "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GwSubStr บAutor  ณ            		 บ Data ณ  24/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza substring coerente para nao contar nomes ao meio.  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TbcSubSt(cGwString, nGwIni, nGwMaximo, _qbPalavra) 
Local aArea := GetArea()
Local nCorte   := 1  
Local cRetorno := ""    
Local cNovaLinha := "" 
Local aTexto   := {}, aRetorno := {}
Local nI := 0

Default _qbPalavra := 0
Default cGwString := ""
Default nGwIni 	  := 1
Default nGwMaximo := 0
//alert(cgwstring)
cGwString := AllTrim(cGwString)

//SE _qbPalavra = 1 temos que as palavras tambem serao quebradas
if _qbPalavra == 1
	For nI := nGwIni to Len(cGwString) 
		if SubStr(cGwString,nI,1) == " " .Or. nI == Len(cGwString) .Or. nI == nGwMaximo  //".Or. nI == nGwMaximo" Altera็ใo feita por Thiago Afonso - 08/01/2015 para quebrar palavras muito cumpridas  
			if Alltrim(SubStr(cGwString,nCorte,nI - nCorte + iif(nI == Len(cGwString),1,0) )) <> ""
				if nI == nGwMaximo //Evita que se pule um caractere ao se quebrar uma palavra - Thiago Afonso - 08/01/2015
					aAdd(aTexto,SubStr(cGwString,nCorte,(nI - nCorte)+1 + iif(nI == Len(cGwString),1,0) ))  //calcula o tamanho da Substring que sera gerada
				else
				    aAdd(aTexto,SubStr(cGwString,nCorte,nI - nCorte + iif(nI == Len(cGwString),1,0) ))     
				endif
			endif
			nCorte := nI + 1
		endif 	
	Next nI
else
	For nI := nGwIni to Len(cGwString) 
		if SubStr(cGwString,nI,1) == " " .Or. nI == Len(cGwString)  
			if Alltrim(SubStr(cGwString,nCorte,nI - nCorte + iif(nI == Len(cGwString),1,0) )) <> ""	
				aAdd(aTexto,SubStr(cGwString,nCorte,nI - nCorte + iif(nI == Len(cGwString),1,0) ))
			endif
			nCorte := nI + 1
		endif 	
	Next nI
endif


For nI := 1 to Len(aTexto)
    if Len(cNovaLinha+aTexto[nI]) < nGwMaximo .And. At(chr(13)+chr(10),aTexto[nI]) <= 0
		cNovaLinha += aTexto[nI]+" "
    else    
    	nPosEOL := At(chr(13)+chr(10),aTexto[nI])
                                                  
    	if nPosEOL > 0
			aAdd(aRetorno, cNovaLinha+SubStr(aTexto[nI],1,nPosEOL-1))
			cNovaLinha := StrTran(SubStr(aTexto[nI],nPosEOL,Len(aTexto[nI]))+" ",chr(13)+chr(10),"")
		else    
	    	aAdd(aRetorno,cNovaLinha)
	    	cNovaLinha := aTexto[nI]+" "   	    	
    	endif	    	
    endif  
	//alert(cnovalinha)           
Next

if ( Len(aRetorno) > 0 .And.  ! ( cNovaLinha $ aRetorno[Len(aRetorno)] ) .And. !Empty(cNovaLinha) ) ; 
		.Or. Len(aRetorno) == 0 .And. Len(cNovaLinha) > 0 

	aAdd(aRetorno,cNovaLinha)
	
endif
RestArea(aArea)
Return(aRetorno)
