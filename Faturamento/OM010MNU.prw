/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � M460FIM  � Autor � Ricardo Moreira� 		  Data � 21/02/17 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada para Imprimir o Mapa de Conferencia apos  潮�
北�          � Nota Fiscal de Saida                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Pharma                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"
#INCLUDE "topconn.ch"

User Function OM010MNU()

aadd( aRotina,{"Importa ","U_IMPORTAB()",0,7,0, nil} )

Return aRotina 
User Function IMPORTAB()

Local cDir    := "C:\Temp\"  
Local cArq    := "tabela.txt"
Local cLinha  := ""
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}      
Local _nTab   := 0
Local _Item   := 1
local j		  := 1
local i		  :=1
Private aErro := {}
 
If !File(cDir+cArq)
	MsgStop("O arquivo " +cDir+cArq + " n鉶 foi encontrado. A importa玢o ser� abortada!","[IMPORTAB] - ATENCAO")
	Return
EndIf 

////Pega o 鷏timo codigo de Tabela
If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf
cQry := " "
cQry += "SELECT TOP 1 DA0_CODTAB "
cQry += "FROM " + retsqlname("DA0")+" DA0 "
cQry += "WHERE DA0.D_E_L_E_T_ <> '*' "
cQry += "AND DA0_FILIAL = '" + substr(cFilAnt,1,2)+ "' "
cQry += "ORDER BY DA0_FILIAL, DA0_CODTAB DESC "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP1",.T.,.T.)

 _nTab := strzero((val(TMP1->DA0_CODTAB)+ 1),3)  

//Gravando o Cabe鏰lho das Tabelas de Pre鏾
dbSelectArea("DA0")
dbSetOrder(1)
dbGoTop() 
If !dbSeek(xFilial("DA0")+_nTab)
   Reclock("DA0",.T.)
   DA0->DA0_FILIAL := xFilial("DA0")
   DA0->DA0_CODTAB := _nTab
   DA0->DA0_DESCRI := "TABELA IMPORTADA"
   DA0->DA0_DATDE  := DDATABASE
   DA0->DA0_HORADE := "00:00"
   DA0->DA0_HORATE := "23:59"
   DA0->DA0_TPHORA := "1"
   DA0->DA0_ATIVO  := "1" 
   DA0->DA0_FILIAL := substr(cFilAnt,1,2) 
   DA0->(MsUnlock())
EndIf
 
FT_FUSE(cDir+cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
 
	IncProc("Lendo arquivo texto...")
 
	cLinha := FT_FREADLN()
 
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
 
	FT_FSKIP()
EndDo
 
Begin Transaction
	ProcRegua(Len(aDados))	
	
	For i:=1 to Len(aDados)
 
		IncProc("Importando Tabela de Pre鏾...")
 
		dbSelectArea("DA1")
		dbSetOrder(3)
		dbGoTop()
		If !dbSeek(xFilial("DA1")+_nTab+strzero((_Item),4))
			Reclock("DA1",.T.)
			DA1->DA1_FILIAL := substr(cFilAnt,1,2)
			DA1->DA1_ATIVO := "1"
			DA1->DA1_TPOPER := "4"
			DA1->DA1_MOEDA := 1  
			DA1->DA1_DATVIG := DDATABASE
			DA1->DA1_QTDLOT := 999999.99
			DA1->DA1_ITEM   := strzero((_Item),4)  
			DA1->DA1_CODTAB := _nTab
			For j:=1 to Len(aCampos)
				cCampo  := "DA1->" + aCampos[j]
				&cCampo := IIF(type(cCampo) = "N",VAL(aDados[i,j]),aDados[i,j])			
			Next j
			DA1->(MsUnlock())
		EndIf
		_Item := _Item + 1
	Next i
End Transaction
 
FT_FUSE()
 
ApMsgInfo("Importa玢o da Tabela de Pre鏾 conclu韉a com sucesso!","[AEST901] - SUCESSO")
 
Return
