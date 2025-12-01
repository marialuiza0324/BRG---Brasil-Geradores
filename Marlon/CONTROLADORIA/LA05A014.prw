#Include "Protheus.ch"
#Include "MSMGADD.CH"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"
#include "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FILEIO.CH"


#DEFINE CRLF Chr(13) + Chr(10)
#DEFINE nTRB  1
#DEFINE nIND1 2


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTABELA DE PREวOS บAutor  ณRodrigo Dias      บ Data ณ05/03/20บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ IMPORTA ARQUIVO VIA CSV SELECIONANDO VIA PESQUISA          บฑฑ
ฑฑบ          ณ Tabela DA0  e DA1 - Tabela de Pre็os                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Linea Alimentos                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//Rodrigo Dias 16/05/22
//Caso exista a regra excluir e incluir novamente (com os dados atuais da planilha)
//Refatoramento feito por Isaac Oliveira em 08/12/2022



//Teste em 18/11/2025 com Marlon Pablo


User Function LA05A014()


	Public cArq
	Public cDoc
	Public dtfinal
	Public dtinicial

	@ 200,1 TO 400,900 DIALOG oImpTxt TITLE OemToAnsi("Atualizacao de tabelas de pre็os Via Planilha")
	@ 02,10 TO 120,400
	@ 10,018 Say " Esta rotina tem como objetivo de ajustar pre็os da tabela de pre็os. "
	@ 18,018 Say " Informa็๕es devem estar  em arquivo no formato: .CVS (SEPARADO POR VIRGULAS)."
	@ 26,018 Say " As tabelas envolvidas sใo: DA0 e DA1.  "
	@ 34,018 Say " O arquivo Excel com extensใo .CSV  precisa ter a seguinte estrutura  "
	@ 42,018 Say " DESCREVER LAYOUT DO ARQUIVO	"
	@ 50,018 Say " DESCREVER LAYOUT DO ARQUIVO"


	@ 90,100 BMPBUTTON TYPE 01 ACTION ChmImp()
	@ 90,130 BMPBUTTON TYPE 02 ACTION Close(oImpTxt)

	Activate Dialog oImpTxt Centered

Return

Static Function ChmImp()
	Processa( {|| GetDocFromPC() })
Return


//********************************************************************************************//


// /*/{Protheus.doc} GetDocFromPC
// Busca dados (documento) do computador para importa็ใo
// @author Isaac Oliveira
// @since 08/12/2022
// @version 1.1
// /*/
Static Function GetDocFromPC()
	Local cPathArq   := ""
	Local cText      := ""
	Local nHandle    := 0
	Local nQtdBytes  := 1000000
	Local aDocs      := {}
	Local aDocsItens := {}
	Local nX         := 0

	cPathArq := cGetFile('Arquivos CSV|*.csv','Selecione um documento de tabela de pre็os',0,'C:\',.T.,,.F.)
	If Empty(cPathArq)
		MsgAlert("Documento nใo selecionado.", "GetDocFromPC")
		Return
	EndIf

	nHandle := FOpen(cPathArq , FO_READWRITE + FO_SHARED )
	If nHandle == -1
		MsgStop("Erro de abertura do arquivo: FERROR " + STR(FError(),4))
		Return
	Else
		cText := FReadStr(nHandle, nQtdBytes)
		aDocs := StrTokArr(cText, CHR(10)+CHR(13))

		If Len(aDocs) <= 0
			MsgStop("Arquivo informado estแ vazio.")
			FClose(nHandle)
			Return
		Else
			For nX := 1 To Len(aDocs)
				AADD(aDocsItens, StrTokArr2(aDocs[nX], ";", .T.) )
			Next nX

			FClose(nHandle)

			Processa( {|| ProcessDoc(aDocsItens) }, "Aguarde...", "Importando arquivo...", .F.)

		EndIf
	EndIf

Return



/*/{Protheus.doc} ProcessDoc
Processa importa็ใo do documento da tabela de Pre็os
@type Static Function
@author Isaac Oliveira
@since 08/12/2022
@version 1.0
@param aItens, array, Itens da Planilha(Tabela DA0 e DA1)
/*/
Static Function ProcessDoc(aItens)

	Local aAreaDA0       := DA0->( GetArea() )
	Local aAreaDA1       := DA1->( GetArea() )
	Local nX := 0
	Local cCodTabela     := ""
	Local cHorade        := "00:00"
	Local cCodProduto    := ""
	Local nValPrecoVenda
	Local cAtivo
	Local cItensAlterados := ""
	Local cContCa         := 0
	Local cContI          :=0
	Local cDescri         := ""
	Local cFil            := ""
	Local cTpHora 	  	  := ""


	ProcRegua(Len(aItens)-1)
	For nX := 2 To Len(aItens)

		cFil           := PadL(AllTrim(StrTran(StrTran(aItens[nX][1],'"',''),"'","")), TamSX3("DA0_FILIAL")[1], "0")
		cCodTabela 	   := GetSxeNum("DA0","DA0_CODTAB")
		cDescri 	   := aItens[nX][2] //DA0_DESCRI
		cTpHora	       := aItens[nX][3] //DA0_TPHORA
		cAtivo         := aItens[nX][4] //DA1_ATIVO
		cCodProduto    := aItens[nX][5] //DA1_CODPRO
		nValPrecoVenda := aItens[nX][6] //DA1_PRCVEN


		DA0->( dbSetOrder(1) )
		IF DA0->(dbSeek(xFilial("DA0") + cCodTabela ))

			RecLock("DA0", .F.)
			DA0->DA0_DATDE  := STOD(DTOS(dDataBase))
			DA0->DA0_HORADE := "00:00"
			DA0->( MsUnlock() )

			RestArea(aAreaDA0)

			DA1->( dbSetOrder(1) )
			IF DA1->(dbSeek(xFilial("DA1") + cCodTabela + cCodProduto))
				RecLock("DA1", .F.)
				DA1->DA1_PRCVEN := Val(StrTran(nValPrecoVenda,",","."))
				DA1->DA1_ATIVO  := cAtivo

				cItensAlterados += "Tabela: "+ cCodTabela +" | "+" Produto: "+ cCodProduto + " Alterado com sucesso! - "+ FWTimeStamp(2,Date())+CRLF
				cContCa++
				DA1->( MsUnlock() )
			ELSE
				RecLock("DA1", .T.)
				DA1->DA1_FILIAL := xFilial("DA1")
				DA1->DA1_ITEM   := PadL(cValToChar(SeqNumItemDA1(cCodTabela)), TamSX3("DA1_ITEM")[1], "0")
				DA1->DA1_CODPRO := cCodProduto
				DA1->DA1_CODTAB := cCodTabela
				DA1->DA1_PRCVEN := Val(StrTran(nValPrecoVenda,",","."))
				DA1->DA1_ATIVO  := cAtivo

				cConti++
				cItensAlterados += "Tabela: "+ cCodTabela +" | "+" Produto: "+ cCodProduto + " incluํdo com sucesso! - "+ FWTimeStamp(2,Date())+CRLF

				DA1->( MsUnlock() )
			ENDIF

		ELSE
			DA0->( dbSetOrder(1) )
			IF !DA0->(dbSeek(xFilial("DA0") + cCodTabela ))
				RecLock("DA0", .T.)
				DA0->DA0_FILIAL := cFil
				DA0->DA0_CODTAB := cCodTabela
				DA0->DA0_DESCRI := cDescri
				DA0->DA0_DATDE  := STOD(DTOS(dDataBase))
				DA0->DA0_HORADE := cHorade
				DA0->( MsUnlock() )
			EndIf

			RestArea(aAreaDA0)

			DA1->( dbSetOrder(1) )
			IF DA1->(dbSeek(xFilial("DA1") + cCodTabela + cCodProduto))
				RecLock("DA1", .F.)
				DA1->DA1_PRCVEN := Val(StrTran(nValPrecoVenda,",","."))
				DA1->DA1_ATIVO  := cAtivo

				cItensAlterados += "Tabela: "+ cCodTabela +" | "+" Produto: "+ cCodProduto + " Alterado com sucesso! - "+ FWTimeStamp(2,Date())+CRLF
				cContCa++
				DA1->( MsUnlock() )
			ELSE
				RecLock("DA1", .T.)
				DA1->DA1_FILIAL := cFil
				DA1->DA1_ITEM   := PadL(cValToChar(SeqNumItemDA1(cCodTabela)), TamSX3("DA1_ITEM")[1], "0")
				DA1->DA1_CODPRO := cCodProduto
				DA1->DA1_CODTAB := cCodTabela
				DA1->DA1_PRCVEN := Val(StrTran(nValPrecoVenda,",","."))
				DA1->DA1_ATIVO  := cAtivo

				cConti++
				cItensAlterados += "Tabela: "+ cCodTabela +" | "+" Produto: "+ cCodProduto + " incluํdo com sucesso! - "+ FWTimeStamp(2,Date())+CRLF

				DA1->( MsUnlock() )
			ENDIF
		ENDIF

	Next nX
	RestArea(aAreaDA1)
	MsgInfo("Atualizacao de precos na tabela de pre็os realizada com Sucesso! Em um total de "+cValToChar(cContCa)+" itens atualizados e com um total de: "+cValToChar(cConti)+" incluidos ")
Return

/*/{Protheus.doc} SeqNumItemDA1
	(long_description)
	@type  Static Function
	@author Isaac Oliveira
	@since 09/12/2022
	@version 1.0
	@param cCodTabela, char, C๓digo da tabela de pre็o para consulta
	@return nSeq, number, Retorna o pr๓ximo n๚mero na sequ๊ncia de ITEM da DA1 para inser็ใo de produtos
/*/
Static Function SeqNumItemDA1(cCodTabela)

	Local cQry := ""
	Local nSeq


	cQry := "SELECT (MAX(NVL(DA1_ITEM,'1'))+1) SEQUENCIA FROM DA1010 WHERE DA1_CODTAB = '"+cCodTabela+"'"

	cQry := ChangeQuery(cQry)

	If Select("TMP1") > 0
		TMP1->(dbCloseArea())
	EndIf

	DBUSEAREA(.T.,'TOPCONN',TcGenQry(,,cQry),"TMP1",.F.,.T.)

	DBSELECTAREA("TMP1")
	TMP1->(DBGOTOP())
	COUNT TO NQTREG

	If NQTREG > 0
		TMP1->(DBGOTOP())
		nSeq := TMP1 ->SEQUENCIA
		TMP1->(dbCloseArea())
	ENDIF
Return nSeq



