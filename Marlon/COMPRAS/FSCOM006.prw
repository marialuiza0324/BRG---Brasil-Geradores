//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"

//Posições do Array
Static nPosTipo            := 1 //Coluna A no Excel
Static nPosCodProd         := 2 //Coluna B no Excel
Static nPosGrupo           := 3 //Coluna C no Excel
Static nPosDescri          := 4 //Coluna D no Excel
Static nPosUnidade         := 5 //Coluna E no Excel
Static nPosArmazem         := 6 //Coluna F no Excel
Static nPosipi             := 7 //Coluna G no Excel
Static nPosOrigem          := 8 //Coluna H no Excel

/*/{Protheus.doc} FSCOM006
Função para importar informações via csv
e realizar cadastro de produto via execauto
@author Maria Luiza
@since 06/02/2025
@version 1.0
@type function
/*/

User Function FSCOM006()

	Local aArea     := GetArea()
	Private cArqOri := ""
	Private cUser := RetCodUsr()
	Private cCadProd := SuperGetMV("MV_USREXEC", ,)

	If cUser $ cCadProd

		//Mostra o Prompt para selecionar arquivos
		cArqOri := tFileDialog( "CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )

		//Se tiver o arquivo de origem
		If ! Empty(cArqOri)

			//Somente se existir o arquivo e for com a extensão CSV
			If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
				Processa({|| fImporta() }, "Importando...")
			Else
				MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
			EndIf
		EndIf

	Else

		FwAlertInfo("Usuário não tem permissão para acessar rotina", "Atenção!!!")

	EndIf

	RestArea(aArea)
Return

/*-------------------------------------------------------------------------------*
 | Func:  fImporta                                                               |
 | Desc:  Função que importa os dados                                            |
 *-------------------------------------------------------------------------------*/
  
Static Function fImporta()

    Local aArea := FWGetArea()
    Local cTipo := ""
    Local cCodProd := " "
    Local cGrupo := " "
    Local cDescProd := " "
    Local cUnidade := " "
    Local cArmazem := " " 
    Local cPosipi := " "
    Local cOrigem := " " 
    Local nOpcAuto
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Local cArqLog    := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Private cDirLog    := GetTempPath() + "x_importacao\"
    Private cLog       := ""
    Private lMsErroAuto := .F.
    Private nSaldoFisico    := 0
	Private nSaldoComprometido := 0
	Private nSaldoDisponivel := 0
    Private lLog := .F.
    Private lLogError := .F.
    Private lAchou := .F.
      
    //Se a pasta de log não existir, cria ela
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf
  
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
  
            //Enquanto tiver linhas
            While (oArquivo:HasLine())
  
                //Incrementa na tela a mensagem
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                  
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")
                  
                //Se não for o cabeçalho (encontrar o texto "Código" na linha atual)
                If nLinhaAtu <> 1//! "CODIGO" $ Lower(cLinAtu)
  
                        //Zera as variaveis
                        cTipo       := aLinha[nPosTipo] 
                        cCodProd    := aLinha[nPosCodProd]
                        cGrupo      := aLinha[nPosGrupo]
                        cDescProd   := aLinha[nPosDescri]
                        cUnidade    := aLinha[nPosUnidade]
                        cArmazem    := aLinha[nPosArmazem]
                        cPosipi      := aLinha[nPosipi]
                        cOrigem     := aLinha[nPosorigem]
                
                        aLinha := {}

                        //aAdd(aAuto, {cDocumen, dDataBase})
                        aadd(aLinha,{"B1_COD",    PadR(AllTrim(cCodProd),TamSx3("B1_COD")[1]),    Nil}) //Cod Produto
                        aadd(aLinha,{"B1_DESC",   PadR(AllTrim(cDescProd),TamSx3("B1_DESC")[1]),    Nil}) //Descrição do produto
                        aadd(aLinha,{"B1_TIPO",   PadR(AllTrim(cTipo),TamSx3("B1_TIPO")[1]),   Nil}) //Tipo do produto
                        aadd(aLinha,{"B1_UM",     PadR(Alltrim(cUnidade),TamSx3("B1_UM")[1]),           Nil}) //Unidade do produto
                        aadd(aLinha,{"B1_GRUPO",  PadR(AllTrim(cGrupo),TamSx3("B1_GRUPO")[1]), Nil}) //Grupodo produto
                        aadd(aLinha,{"B1_LOCPAD", PadR(AllTrim(cArmazem),TamSx3("B1_LOCPAD")[1]),      Nil}) //Armazém do produto
                        aadd(aLinha,{"B1_POSIPI", PadR(AllTrim(cPosipi),TamSx3("B1_POSIPI")[1]),     Nil}) //Pos.IPI/NCM
                        aadd(aLinha,{"B1_ORIGEM", PadR(AllTrim(cOrigem),TamSx3("B1_ORIGEM")[1]),     Nil}) //unidade medida destino
                
                        //Aciona a inclusão 
                        nOpcAuto := 3

                        DbSelectArea("SB1")
                        DbSetOrder(1)

                        If SB1->(MsSeek(FWxFilial("SB1") + cCodProd ))
                            lAchou := .T.
                            cLog += "Linha " + cValToChar(nLinhaAtu) + " Produto "+Alltrim(cCodProd)+ "        JÁ CADASTRADO " + CRLF
                        EndIf

                        SB1->(DbCloseArea())

                        Begin Transaction 

                            If !lAchou

                                MSExecAuto({|x, y| MATA010(x, y)}, aLinha, nOpcAuto)
                        
                                //Se houve erro, mostra a mensagem
                                    If lMsErroAuto 
                                        MostraErro()
                                        cLog += "Linha " + cValToChar(nLinhaAtu) + " Produto "+Alltrim(cCodProd)+ "        NÃO PROCESSADO " + CRLF
                                        DisarmTransaction()
                                        lLogError := .T.
                                    //Se deu tudo certo, efetiva a numeração
                                    Else
                                    cLog += "Linha " + cValToChar(nLinhaAtu) + " Produto "+Alltrim(cCodProd)+ "         PROCESSADO COM SUCESSO " + CRLF
                                        ConfirmSX8()
                                    EndIf
                            EndIf

                                lAchou := .F.

                        End Transaction
                    EndIf
            EndDo

            //Se tiver log, mostra ele
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            Else 
              FWAlertSuccess("Cadastros realizados com sucesso", "Sucesso!!!")
            EndIf
        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf
  
        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
  
    RestArea(aArea)
Return
