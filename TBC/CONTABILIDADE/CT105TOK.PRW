#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT105TOK  ºAutor  ³Claudio Ferreira    º Data ³  25/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para validar Debito/Credito                             º±±
±±º          ³ Utilizado para validar Deb/Cre por Classe Valor            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CT105TOK
Local nDeb 	 := ParamIXB[1]
Local nCre 	 := ParamIXB[2]
Local lRet:=.t. 

If NoRound(Round(nDeb,3)) != NoRound(Round(nCre,3))
	If !'MATA330'$FUNNAME() .AND. !'MATA331'$FUNNAME()
		Help(" ",1,"DOCNOBAT")
		lRet := .F.
	Else
		lRet := MsgYesNo(OemToAnsi('Debito e Credito nao conferem !'),OemToAnsi('Aceita Lançamento'))
	EndIf
Endif



Return lRet
  

User Function  C105VLIN
Local lRet:=.t.   

//Valida linha deletada
if SuperGetMV("MV_XVLDDEL",.F.,.F.) 
	If TMP->CT2_FLAG .and. !FunName() $ 'CTBA102#CTBA103#CTBA104'+SuperGetMV("MV_XVLDDRT",.F.,'')	/// SE ESTIVER DELETADO E NAO FOR CTB  
      MsgStop("ATENÇÃO, Não é permitido apagar as linhas."+chr(13)+chr(10)+" Por favor solicite apoio do responsável contábil")
      lRet :=.f.                            
	Endif
endif

Return lRet


User Function CT105CHK
Local lRet:=.t.
Local nDbRecTMP := TMP->( RECNO() )  // guardo o recno
Local aVlrClas:={}
Local nPosClaDb,nPosClaCr
Local ii

if SuperGetMV("MV_XVLDCLV",.F.,"N") = 'N'
	return lRet
endif

dbSelectArea( "TMP" )
TMP->( dbGotop() )

While ! Eof()
	nPosClaDb :=0
	nPosClaCr :=0
	If !TMP->CT2_FLAG
		If TMP->CT2_DC == "1" .or. TMP->CT2_DC == "3"	// Debito
			nPosClaDb := Ascan(aVlrClas,{|x|x[1] == TMP->CT2_CLVLDB })
			if nPosClaDb=0
				aadd(aVlrClas,{TMP->CT2_CLVLDB,0,0})
				nPosClaDb:=Len(aVlrClas)
			endif
		Endif
		If TMP->CT2_DC == "2" .or. TMP->CT2_DC == "3" //Credito
			nPosClaCr := Ascan(aVlrClas,{|x|x[1] == TMP->CT2_CLVLCR })
			if nPosClaCr=0
				aadd(aVlrClas,{TMP->CT2_CLVLCR,0,0})
				nPosClaCr:=Len(aVlrClas)
			endif
		EndIf
		if nPosClaDb>0
			aVlrClas[nPosClaDb,2]+=if(TMP->CT2_DC=='1'.or.TMP->CT2_DC == "3",TMP->CT2_VALOR,0)
		endif
		if nPosClaCr>0
			aVlrClas[nPosClaCr,3]+=if(TMP->CT2_DC=='2'.or.TMP->CT2_DC == "3",TMP->CT2_VALOR,0)
		endif
	Endif
	TMP->( dbSkip() )
EndDo

For ii:=1 to Len(aVlrClas)
	If NoRound(Round(aVlrClas[ii,2],3)) != NoRound(Round(aVlrClas[ii,3],3))
		MsgStop("ATENÇÃO, Os totais por Classe Valor não batem."+chr(13)+chr(10)+' Classe: '+aVlrClas[ii,1])
		lRet := .F.
	Endif
Next ii
TMP->(DbGoto(nDbRecTMP ))
Return lRet
