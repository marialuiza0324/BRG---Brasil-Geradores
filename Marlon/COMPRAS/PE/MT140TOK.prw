#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MT140TOK 
   Este P.E � executado p�s o destravamento de todas as tabelas envolvidas 
   na grava��o do documento de entrada, depois de fechar
   a opera��o realizada neste.
   � utilizado para realizar a exclus�o do t�tulo 
   no contas a pagar ap�s a grava��o da NFE.
    @type  Function
    @author Maria Luiza
    @since 23/07/2024*/

User Function MT140TOK() 

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
Local cRateio := "" // Vari�vel que vai armazenar o rateio
Local cCentroCusto := "" // Vari�vel para o centro de custo
Local lMsg :=.F.
Local lRastro := .T.
local nPosLoteCtl    := AScan(aHeader, {|x| Alltrim(x[2]) == "D1_LOTECTL"})
Local nLinha

	If Funname() <> "LOCA001"
			For nX := 1 To Len(ACOLS) //percorre todas as linhas da pr�-nota


					DbSelectArea("SB1")
					DbSetOrder(1)   

					IF dbSeek(xFilial("SB1")+ACOLS[nX][2])//busca produto na SB1
						If SB1->B1_RASTRO == "L" .AND. Empty(ACOLS[nX][7])//se produto possuir ratreabilidade e lote estiver vazio
							lRet  := .F. //n�o permite inclus�o do doc 
							lRastro := .F.
							FWAlertInfo("Item com Rastreabilidade, informe o Lote"," Aten��o!!!")
							Return
						EndIf
					EndIf


					// Verifica se o lote j� foi usado em outra linha
						For nLinha := 1 To Len(Acols)
							If nLinha != n // Ignora a linha atual
								If Upper(AllTrim(Acols[nLinha, nPosLoteCtl])) == Upper(AllTrim(Acols[n, nPosLoteCtl])) .And. !Empty(Acols[n, nPosLoteCtl])
									FWAlertInfo("O lote '" + Alltrim(Acols[n, nPosLoteCtl]) + "' j� foi utilizado em outro item. Corrija para prosseguir.", "Lote Duplicado!")
									lRet := .F.
									Return
								EndIf
							EndIf
						Next


						// Obtendo o centro de custo e o rateio
						cCentroCusto := ACOLS[nX][13] 
						cRateio := ACOLS[nX][41] 

					// Verificando se o centro de custo est� vazio e se o rateio est� informado
					If Empty(cCentroCusto) .and. cRateio == "1"
						// Se o centro de custo est� vazio e h� rateio, permite a confirma��o
						lRet := .T. // Permite continuar sem erro
					ElseIf Empty(cCentroCusto) .and. cRateio == "2"
						// Se ambos est�o vazios, bloqueia a grava��o e exibe uma mensagem
						FWAlertInfo("Informe um centro de custo ou rateio", "Aten��o!!!")
						lRet := .F. // Bloqueia a confirma��o
					ElseIf !Empty(cCentroCusto) .and. cRateio == "1"
						FWAlertInfo("O campo de Centro de Custo e rateio est�o preenchidos, preencha somente um", "Aten��o!!!")
						lRet := .F. // Bloqueia a confirma��o
					EndIf
				
			cNumPC := ACOLS[nX][25] //Num Pc
			cItemPc := ACOLS[nX][1] //Item Pc 

				If Select("TSC7") > 0
					TSC7->(dbCloseArea())
				EndIf

				_cQry := "SELECT DISTINCT C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO,C7_FORNECE,C7_LOJA, C7_DATPRF,C7_XDTPRF, SUM(C7_TOTAL) TOTAL, SUM(C7_VALIPI) VALIPI, SUM(C7_VALSOL) VALSOL "
				_cQry += "FROM " + retsqlname("SC7")+" SC7 "
				_cQry += "WHERE SC7.D_E_L_E_T_ <> '*' "
				_cQry += "AND   SC7.C7_FILIAL   = '" + cFilAnt  + "' "
				_cQry += "AND   SC7.C7_NUM	= '" + cNumPC  + "' "
				_cQry += "AND   SC7.C7_ENCER = '' "
				_cQry += "AND   SC7.C7_QUJE <  SC7.C7_QUANT "
				_cQry += "GROUP BY C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF,C7_FORNECE,C7_LOJA,C7_XDTPRF "
				_cQry += "ORDER BY C7_FILIAL, C7_NUM , C7_DATPRF, C7_XDTPRF "
				
				DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TSC7",.T.,.T.) //filtrando pedido na SC7

					If Empty(TSC7->C7_XDTPRF)

						dData :=  stod(TSC7->C7_DATPRF)

					Else

						dData :=  stod(TSC7->C7_XDTPRF)

					EndIf
					_Forn   := AllTrim(TSC7->C7_FORNECE)
					cCond   := TSC7->C7_COND //Condi��o de pagamento
					nValTot := TSC7->TOTAL + TSC7->VALIPI + TSC7->VALSOL //somando valor total do PC
					aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol)//calculando o numero de parcelas

				For i:= 1 to Len(aParc)  //la�o de repeti��o de acordo com a quantidade de parcelas
					_Venc  := Lastday(aParc[i,1],3) //vencimento
					_Total := aParc[i,2] //valor da parcela
					_Parc  := cvaltochar(i) //N� da parcela

					/*If _Venc == Date() .OR. _Venc < Date() //verifica se a data de vencimento � igual ou menor que a data atual

						Help(, ,"AVISO#0028", ,"A data de vencimento � igual ou menor a data de hoje.",1, 0, , , , , , {"Renegocie com o fornecedor e ajuste a condi��o de pagamento do pedido."})
						lRet := .F.
							Exit
					Else*/

						aDelet := { { "E2_PREFIXO" , "PRV" , NIL },; //Array de exclus�o do t�tulo
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

						DbSelectArea("TSE2") //query retorna se existe t�tulo na SE2 com chave informada

						TSE2->( dbGoTop() )
						Count To nTotal

						If  nTotal > 0
							lAchou := .T.
						EndIf

						TSE2->(DbCloseArea())

						Begin Transaction

							If lAchou //se achar t�tulo na query acima, deleta ele
								MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aDelet,, 5) // 3 - Inclusao, 4 - Altera��o, 5 - Exclus�o

								If lMsErroAuto //se der erro cancela exclus�o e mostra erro
									FWAlertInfo("Sistema n�o conseguiu excluir o t�tulo, refa�a o processo","Aten��o!!!")
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

						lAchou := .F. // zera vari�vel
					//EndIf
				Next i

			Next nX

					SB1->(DbCloseArea())
					FwRestArea(aArea)

					If lRastro = .F. //Se tiver pendencia de lote, n�o exclui o t�tulo
						lRet := .F.
					EndIf

					If lMsg = .T. .AND. lRastro = .T. //se n�o tiver erro e n�o tiver pend�ncia de lote, exclui o t�tulo
						FWAlertInfo("T�tulo financeiro exclu�do com sucesso.","Aten��o!!!")
					EndIf 
	EndIf

Return lRet
