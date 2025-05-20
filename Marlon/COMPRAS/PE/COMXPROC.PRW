#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} COMXPROC 
   Ponto de entrada utilizado para validar a geração 
   de Documentos via TOTVS Collaboration.
   Chamado na geração de Doc Importador XML
   Utilizado para excluir título financeiro na tabela SE2
    @type  Function
    @author Maria Luiza
    @since 11/09/2024*/

User Function COMXPROC() 

Local aArea := FWGetArea()
Local cCond   := ""
Local nVIPI   := 0
Local nValTot := 0
Local dData
Local nVSol   := 0
Local _Venc   := CtoD("  /  /  ")
Local _Total  := 0
Local _Parc   := " "
Local i := 1
Local nX := 1
Local lAchou:= .f.
Local cTipo := "PR"
Local cQuery := ""
Local aDelet := {}
Local nTotal := 0
Local lMsErroAuto := .F.
Local cNumPC  := ""
Local cItemPc := ""
Local lRet := .T. 
Local cQry := ''
Local lMsg := .F.


	cQry := "SELECT * FROM "+retsqlname("SDT")+" SDT "
	cQry += "WHERE DT_FORNEC = '"+DS_FORNEC+"' "
	cQry += "AND DT_FILIAL = '"+xFilial("SDT")+"' "
	cQry += "AND DT_DOC = '"+DS_DOC+"' "
	cQry += "AND  D_E_L_E_T_= '' "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TSDT",.T.,.T.) //coleta dados de pedido e item da importação

	DbSelectArea('TSDT')

	While TSDT->(!EOF()) 

			cNumPC := TSDT->DT_PEDIDO //Num Pc
			cItemPc := TSDT->DT_ITEMPC //Item Pc 

			If Select("TSC7") > 0
				TSC7->(dbCloseArea())
			EndIf

			_cQry := "SELECT DISTINCT C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO,C7_FORNECE, C7_DATPRF,C7_XDTPRF, SUM(C7_TOTAL) TOTAL, SUM(C7_VALIPI) VALIPI, SUM(C7_VALSOL) VALSOL "
			_cQry += "FROM " + retsqlname("SC7")+" SC7 "
			_cQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
			_cQry += "AND   SC7.C7_FILIAL   = '" + cFilAnt  + "' "
			_cQry += "AND   SC7.C7_NUM	= '" + cNumPC  + "' "
			_cQry += "AND   SC7.C7_ENCER = '' "
			_cQry += "AND   SC7.C7_QUJE <  SC7.C7_QUANT "
			_cQry += "GROUP BY C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF,C7_FORNECE,C7_XDTPRF "
			_cQry += "ORDER BY C7_FILIAL, C7_NUM , C7_DATPRF,C7_XDTPRF "

			DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TSC7",.T.,.T.) //filtrando pedido na SC7

			 	If Empty(TSC7->C7_XDTPRF)

					dData :=  stod(TSC7->C7_DATPRF)

				Else

					dData :=  stod(TSC7->C7_XDTPRF)

				EndIf
			_Forn   := AllTrim(TSC7->C7_FORNECE)
			cCond   := TSC7->C7_COND //Condição de pagamento
			nValTot := TSC7->TOTAL + TSC7->VALIPI + TSC7->VALSOL //somando valor total do PC
			aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol)//calculando o numero de parcelas

			For i:= 1 to Len(aParc)  //laço de repetição de acordo com a quantidade de parcelas
				_Venc  := Lastday(aParc[i,1],3) //vencimento
				_Total := aParc[i,2] //valor da parcela
				_Parc  := cvaltochar(i) //Nº da parcela

				aDelet := { { "E2_PREFIXO" , "PRV" , NIL },; //Array de exclusão do título
				{ "E2_NUM" , PadR(AllTrim(cNumPC+"/"+substr(cItemPc,3,4)),TamSx3("E2_NUM")[1])  , NIL },; //Validando tamanho do campo na SX3
				{ "E2_PARCELA" , PadR(AllTrim(_Parc),TamSx3("E2_PARCELA")[1])   , NIL },;
				{ "E2_TIPO" , PadR(AllTrim(cTipo),TamSx3("E2_TIPO")[1])  , NIL },;
				{ "E2_NATUREZ" , PadR(AllTrim("202010058"),TamSx3("E2_NATUREZ")[1])  , NIL }}

				If Select("TSE2") > 0
					TSE2->(dbCloseArea())
				EndIf

				cQuery := " SELECT * FROM " + retsqlname("SE2") + " "
				cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND E2_PREFIXO = 'PRV' "
				cQuery += " AND E2_NUM = '"+cNumPC+"/"+substr(cItemPc,3,4)+"' AND E2_PARCELA = '"+_Parc+"'
				cQuery += " AND E2_TIPO = '" +cTipo+"' AND D_E_L_E_T_ <> '*' "

				DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TSE2",.T.,.T.)

				DbSelectArea("TSE2") //query retorna se existe título na SE2 com chave informada

				TSE2->( dbGoTop() )
				Count To nTotal

				If  nTotal > 0
					lAchou := .T.
				EndIf

				TSE2->(DbCloseArea())

				Begin Transaction

					If lAchou //se achar título na query acima, deleta ele
						MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aDelet,, 5) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

						If lMsErroAuto //se der erro cancela exclusão e mostra erro
							FWAlertInfo("Sistema não conseguiu excluir o título, refaça o processo","Atenção!!!")
							MostraErro()
							DisarmTransaction()
							lMsg := .F.
						Else
							lMsErroAuto:= .F.
							lRet := .T.
							lMsg := .T.
						Endif
					Else 
					lRet := .T.
					EndIf

				End Transaction

				lAchou := .F. // zera variável
				
			Next i
		TSDT->(DbSkIP())
	EndDo

	TSDT->(DbCloseArea())

	FwRestArea(aArea)

	If lMsg = .T. //Se estiver tudo certo, mostra mensagem de sucesso
    	FWAlertInfo("Título financeiro excluído com sucesso.","Atenção!!!")
	EndIf

Return lRet
