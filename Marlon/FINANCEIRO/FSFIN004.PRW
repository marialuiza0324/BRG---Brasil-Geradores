//Bibliotecas
#Include "Totvs.ch"
#Include "RwMake.CH"
#include 'protheus.ch'
#include 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} User Function FSFIN004
Função para importar condição de pagamento via csv
@author Maria Luiza
@since 14/01/2026
@version 1.0
@type function
/*/

User Function FSFIN004()

	Local aArea     := GetArea()
	Private cArqOri := ""

	//Mostra o Prompt para selecionar arquivos
	cArqOri := cGetFile('Arquivos CSV|*.csv','Seleção de Arquivos',0,'C:\',.T.,,.F.) //tFileDialog("CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )

	//Se tiver o arquivo de origem
	If ! Empty(cArqOri)
		//Somente se existir o arquivo e for com a extensão CSV
		If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
			Processa({|| fImporta() }, "Importando...")
		Else
			MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
		EndIf
	EndIf

	RestArea(aArea)
Return

/*/{Protheus.doc} fImporta
Função que processa o arquivo e realiza a importação para o sistema
@author Maria Luiza
@since 14/01/2026
@version 1.0
@type function
/*/

Static Function fImporta()
	Local cDirTmp    := GetTempPath()
	Local cArqLog    := 'importacao_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
	Local nTotLinhas := 0
	Local cLinAtu    := ''
	Local nLinhaAtu  := 0
	Local aLinha     := {}
	Local oArquivo
	Local cLog       := ''
	//Variáveis do ExecAuto
	Private aDados         := {}
	Private aCab           := {}
	Private cCondAtu    := ""
	Private aItens         := {}
	Private lMSHelpAuto    := .T.
	Private lAutoErrNoFile := .T.
	Private lMsErroAuto    := .F.
	//Variáveis da Importação
	Private cAliasImp  := 'SE4'
	Private cSeparador := ';'

	//Abre as tabelas que serão usadas
	DbSelectArea(cAliasImp)
	(cAliasImp)->(DbSetOrder(1))
	(cAliasImp)->(DbGoTop())

	//Definindo o arquivo a ser lido
	oArquivo := FWFileReader():New(cArqOri)

	//Se o arquivo pode ser aberto
	If (oArquivo:Open())

		//Se não for fim do arquivo
		If ! (oArquivo:EoF())

			//Definindo o tamanho da régua
			aLinhas := oArquivo:GetAllLines()
			nTotLinhas := Len(aLinhas)
			ProcRegua(nTotLinhas)

			//Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
			oArquivo:Close()
			oArquivo := FWFileReader():New(cArqOri)
			oArquivo:Open()

			//Caso você queira, usar controle de transação, descomente a linha abaixo (e a do End Transaction), mas tem algumas rotinas que podem ser impactadas via ExecAuto
			//Begin Transaction

			//Enquanto tiver linhas
			While (oArquivo:HasLine())

				//Incrementa na tela a mensagem
				nLinhaAtu++
				IncProc('Analisando linha ' + cValToChar(nLinhaAtu) + ' de ' + cValToChar(nTotLinhas) + '...')

				//Pegando a linha atual e transformando em array
				cLinAtu := oArquivo:GetLine()
				aLinha  := Separa(cLinAtu, cSeparador)

				//Se houver posições no array
				If nLinhaAtu <> 1

					//Transformando de caractere para numérico (exemplo '1.234,56' para 1234.56)
					aLinha[13] := StrTran(aLinha[13], '.', '')
					aLinha[13] := StrTran(aLinha[13], ',', '.')
					aLinha[13] := Val(aLinha[13])

					aLinha[6] := StrTran(aLinha[6], '.', '')
					aLinha[6] := StrTran(aLinha[6], ',', '.')
					aLinha[6] := Val(aLinha[6])

					//Transformando os campos caractere, adicionando espaços a direita conforme tamanho do campo no dicionário
					aLinha[1] := AvKey(aLinha[1], 'E4_TIPO')
					aLinha[2] := AvKey(aLinha[2], 'E4_COND')
					aLinha[3] := AvKey(aLinha[3], 'E4_DESCRI')

					If !Empty(aLinha[4])
						aLinha[4] := AvKey(aLinha[4], 'E4_CTRADT')
					EndIf
					If !Empty(aLinha[5])
						aLinha[5] := AvKey(aLinha[5], 'E4_DDD')
					EndIf

					If !Empty(aLinha[7])
						aLinha[7] := AvKey(aLinha[7], 'EC_ITEM')
					Endif
					If !Empty(aLinha[8])
						aLinha[8] := AvKey(aLinha[8], 'EC_TIPO')
					Endif
					If !Empty(aLinha[9])
						aLinha[9] := AvKey(aLinha[9], 'EC_COND')
					Endif
					If !Empty(aLinha[10])
						aLinha[10] := AvKey(aLinha[10], 'EC_IPI')
					Endif
					If !Empty(aLinha[11])
						aLinha[11] := AvKey(aLinha[11], 'EC_DDD')
					Endif
					If !Empty(aLinha[12])
						aLinha[12] := AvKey(aLinha[12], 'EC_SOLID')
					Endif

					// Lógica de agrupamento
					If aLinha[14] == "C"

						// Processa o cabeçalho anterior se existir
						If !Empty(aCab)
							lMsErroAuto := .F.
							MSExecAuto({|x, y| Mata360(x, y)}, aCab, aItens, 3)  // 3 = inclusão

							If lMsErroAuto
								// Tratamento de erro: logue ou mostre MostraErro()
								cLog += '- Erro na linha [' + cValToChar(nLinhaAtu - 1)+ '];' + CRLF
								// Ou adicione a um array de erros para relatório final
							EndIf
						EndIf

						// Inicia novo cabeçalho
						aCab := {}
						aAdd(aCab, {'E4_TIPO', aLinha[1], Nil})
						aAdd(aCab, {'E4_COND', aLinha[2], Nil})
						aAdd(aCab, {'E4_DESCRI', aLinha[3], Nil})
						aAdd(aCab, {'E4_CTRADT', aLinha[4], Nil})
						aAdd(aCab, {'E4_DDD', aLinha[5], Nil})
						aAdd(aCab, {'E4_FINAN', aLinha[6], Nil})
						// Adicione outros campos de cabeçalho se existirem

						cCondAtu := aLinha[2]  // Armazena o cond atual para validação

						aItens := {}

						// Se campos de item estiverem preenchidos na linha "C", trata como simples com 1 item
						If !Empty(aLinha[7]) .Or. !Empty(aLinha[8])  // Cheque outros se necessário
							aItem := {}
							aAdd(aItem, {'EC_ITEM', aLinha[7], Nil})
							aAdd(aItem, {'EC_TIPO', aLinha[8], Nil})
							aAdd(aItem, {'EC_COND', aLinha[9], Nil})
							aAdd(aItem, {'EC_IPI', aLinha[10], Nil})
							aAdd(aItem, {'EC_DDD', aLinha[11], Nil})
							aAdd(aItem, {'EC_SOLID', aLinha[12], Nil})
							aAdd(aItem, {'EC_RATEIO', aLinha[13], Nil})
							// Adicione outros campos de item se existirem
							aAdd(aItens, aItem)
						EndIf

					ElseIf aLinha[14] == "I"

						// Verifica se há cabeçalho ativo
						If Empty(aCab)
							// Erro: item sem cabeçalho
							cLog += '- Falha ao incluir registro, linha [' + cValToChar(nLinhaAtu) + ']: Item sem cabeçalho correspondente.' + CRLF
							Loop
						EndIf

						// Validação opcional: se E4_COND preenchido no item, deve bater com o atual
						If !Empty(aLinha[2]) .And. aLinha[2] != cCondAtu
							cLog += '- Falha ao incluir registro, linha [' + cValToChar(nLinhaAtu) + ']: Condição do item não corresponde ao cabeçalho.' + CRLF
							Loop
						EndIf

						// Adiciona o item
						aItem := {}
						aAdd(aItem, {'EC_ITEM', aLinha[7], Nil})
						aAdd(aItem, {'EC_TIPO', aLinha[8], Nil})
						aAdd(aItem, {'EC_COND', aLinha[9], Nil})
						aAdd(aItem, {'EC_IPI', aLinha[10], Nil})
						aAdd(aItem, {'EC_DDD', aLinha[11], Nil})
						aAdd(aItem, {'EC_SOLID', aLinha[12], Nil})
						aAdd(aItem, {'EC_RATEIO', aLinha[13], Nil})
						// Adicione outros campos de item se existirem
						aAdd(aItens, aItem)

					Else
						// Tipo inválido
						cLog += '- Falha ao incluir registro, linha [' + cValToChar(nLinhaAtu) + ']: Tipo de item inválido (' + aLinha[14] + ');' + CRLF
						Loop
					EndIf

				EndIf

			EndDo

			// Não esqueça de processar o último grupo
			If !Empty(aCab)
				lMsErroAuto := .F.
				MSExecAuto({|x, y| Mata360(x, y)}, aCab, aItens, 3)

				If lMsErroAuto
					cLog += '- Falha ao incluir registro, linha [' + cValToChar(nLinhaAtu) + '];' + CRLF
				EndIf

			EndIf

			//Se tiver log, mostra ele
			If ! Empty(cLog)
				MemoWrite(cDirTmp + cArqLog, cLog)
				ShellExecute('OPEN', cArqLog, '', cDirTmp, 1)
			Else 
				FWAlertInfo('Importação concluída com sucesso!', 'Sucesso!!!')
			EndIf

		Else
			FWAlertError('Arquivo não tem conteúdo!', 'Atenção')
		EndIf
//Fecha o arquivo
		oArquivo:Close()
	Else
		FWAlertError('Arquivo não pode ser aberto!', 'Atenção')
	EndIf

Return
