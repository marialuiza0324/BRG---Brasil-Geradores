//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"

//Posições do Array
Static nPosCodProd      := 1 //Coluna A no Excel
Static nPosDescProd     := 2 //Coluna B no Excel
Static nPosUm           := 3 //Coluna C no Excel
Static nPosLocal        := 4 //Coluna D no Excel
Static nPosLote         := 5 //Coluna E no Excel
Static nPosQuant        := 6 //Coluna F no Excel
Static nPosCodDest      := 7 //Coluna G no Excel
Static nPosDescDest     := 8 //Coluna H no Excel
Static nPosUmDest       := 9 //Coluna I no Excel
Static nPosLocalDest    := 10 //Coluna J no Excel
Static nPosLoteDest     := 11 //Coluna K no Excel


/*/{Protheus.doc} FSEST002
Função para importar informações via csv
@author Maria Luiza
@since 26/11/2024
@version 1.0
@type function
/*/

User Function FSEST002()

	Local aArea     := GetArea()
	Private cArqOri := ""

	//Mostra o Prompt para selecionar arquivos
	cArqOri := cGetFile('Arquivos CSV|*.csv','Seleção de Arquivos',0,'C:\',.T.,,.F.)//tFileDialog( "CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )

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

/*-------------------------------------------------------------------------------*
 | Func:  fImporta                                                               |
 | Desc:  Função que importa os dados                                            |
 *-------------------------------------------------------------------------------*/
  
Static Function fImporta()

    Local aArea := FWGetArea()
    Local aAuto := {}
    Local cDocumen := {}
    Local cProduto := " "
    Local cDescProd := " "
    Local cUmProd   := " "
    Local cArmOrig := " "
    Local cLote    := ""
    Local nQtd     := 0
    Local dValidLote := CtoD("  /  /  ")
   

    Local cProdDest := " "
    Local cDescDest := " "
    Local cUmDest   := " "
    Local cArmDest := " "
    Local cLoteDest   := ""
    Local dValidDest := CtoD("  /  /  ")
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
                        cProduto    := aLinha[nPosCodProd] 
                        cDescProd   := aLinha[nPosDescProd]
                        cUmProd     := aLinha[nPosUm]
                        cArmOrig    := aLinha[nPosLocal]
                        cLote       := aLinha[nPosLote]
                        nQtd        := aLinha[nPosQuant]
                        cProdDest   := aLinha[nPosCodDest]
                        cDescDest   := aLinha[nPosDescDest]
                        cUmDest     := aLinha[nPosUmDest]
                        cArmDest    := aLinha[nPosLocalDest]
                        cLoteDest   := aLinha[nPosLoteDest]
  
                     //Adiciona espaços a direita, conforme o tamanho do campo
                    cProduto := AvKey(cProduto, "B1_COD")
                    cProdDest := AvKey(cProdDest, "B1_COD")
                
                    //Posiciona no produto
                    DbSelectArea("SB1")
                    SB1->(DbSetOrder(1)) // B1_FILIAL + B1_COD
                    If SB1->(MsSeek(FWxFilial("SB1") + cProduto))
                        //Pega o documento e a data logada atual
                        cDocumen := GetSxeNum("SD3","D3_DOC")
                        //aAdd(aAuto, {cDocumen, dDataBase})

                    If !(Empty(cLote)) .OR. !(Empty(cLoteDest))
                        dValidLote := Posicione("SB8",5,FWxFilial('SB8')+cProduto+cLote,'B8_DTVALID')
                        dValidDest := Posicione("SB8",5,FWxFilial('SB8')+cProdDest+cLoteDest,'B8_DTVALID')
                    EndIf
                            // PadR(AllTrim(cNumPC+"/"+substr(cItemPc,3,4)),TamSx3("E2_NUM")[1])
                       //Origem
                        aAuto := {}
                        aLinha := {}
                        aAdd(aAuto, {cDocumen, dDataBase})
                        aadd(aLinha,{"D3_COD",     PadR(AllTrim(cProduto),TamSx3("D3_COD")[1]),    Nil}) //Cod Produto origem
                        aadd(aLinha,{"D3_DESCRI",  PadR(AllTrim(cDescProd),TamSx3("D3_DESCRI")[1]),   Nil}) //descr produto origem
                        aadd(aLinha,{"D3_UM",      PadR(AllTrim(cUmProd),TamSx3("D3_UM")[1]),      Nil}) //unidade medida origem
                        aadd(aLinha,{"D3_LOCAL",   PadR(AllTrim(cArmOrig),TamSx3("D3_LOCAL")[1]),    Nil}) //armazem origem
                        aadd(aLinha,{"D3_LOCALIZ", PadR(" ",TamSx3("D3_LOCALIZ")[1]),           Nil}) //Informar endereço origem
                        aadd(aLinha,{"D3_COD",     PadR(AllTrim(cProdDest),TamSx3("D3_COD")[1]),      Nil}) //cod produto destino
                        aadd(aLinha,{"D3_DESCRI",  PadR(AllTrim(cDescDest),TamSx3("D3_DESCRI")[1]),     Nil}) //descr produto destino
                        aadd(aLinha,{"D3_UM",      PadR(AllTrim(cUmDest),TamSx3("D3_UM")[1]),     Nil}) //unidade medida destino
                        aadd(aLinha,{"D3_LOCAL",   PadR(AllTrim(cArmDest),TamSx3("D3_LOCAL")[1]),       Nil}) //armazem destino
                        aadd(aLinha,{"D3_LOCALIZ", PadR(" ",TamSx3("D3_LOCALIZ")[1]),            Nil}) //Informar endereço destino
                        aadd(aLinha,{"D3_NUMSERI", PadR(" ",TamSx3("D3_NUMSERI")[1]),            Nil}) //Numero serie x
                        aadd(aLinha,{"D3_LOTECTL", PadR(AllTrim(cLote),TamSx3("D3_LOTECTL")[1]),        Nil}) //Lote Origem
                        aadd(aLinha,{"D3_NUMLOTE", PadR(" ",TamSx3("D3_NUMLOTE")[1]),           Nil}) //sublote origem x -
                        aadd(aLinha,{"D3_DTVALID", dValidLote,   Nil}) //data validade
                        aadd(aLinha,{"D3_POTENCI", PadR(0 ,TamSx3("D3_POTENCI")[1]),            Nil}) //Potencia x
                        aadd(aLinha,{"D3_QUANT",   VAL(nQtd)                          ,         Nil}) //Quantidade
                        aadd(aLinha,{"D3_QTSEGUM", PadR(0 ,TamSx3("D3_QTSEGUM")[1]),            Nil}) //Seg unidade medida x
                        aadd(aLinha,{"D3_ESTORNO", PadR(" ",TamSx3("D3_ESTORNO")[1]),           Nil}) //Estorno x
                        aadd(aLinha,{"D3_NUMSEQ",  PadR(" ",TamSx3("D3_NUMSEQ")[1]),           Nil}) //Numero sequencia D3_NUMSEQ x
                        aadd(aLinha,{"D3_LOTECTL", PadR(AllTrim(cLoteDest),TamSx3("D3_LOTECTL")[1]),    Nil}) //Lote destino
                        aadd(aLinha,{"D3_DTVALID", dValidDest,    Nil}) //validade lote destino 01/01/2600
                        aadd(aLinha,{"D3_ITEMGRD", PadR(" ",TamSx3("D3_ITEMGRD")[1]),           Nil}) //Item Grade - seq
                        aadd(aLinha,{"D3_OBSERVA", PadR(" ",TamSx3("D3_OBSERVA")[1]),           Nil}) //Observação 
                     
                        
                        /*Outros campos
                        aadd(aLinha,{"D3_CODLAN",  "",           Nil}) //cat83 prod origem
                        aadd(aLinha,{"D3_CODLAN",  "",           Nil}) //cat83 prod destino*/
                        aAdd(aAuto, aLinha)
                
                        //Aciona a inclusão de uma transferência múltipla
                        nOpcAuto := 3

                        DbSelectArea("SB2")
                        SB2->(DbSetOrder(1))
                       // Verifica se o registro foi encontrado
                        If SB2->(MsSeek(FWxFilial('SB2')+cProduto + cArmOrig))
                            nSaldoFisico    := SB2->B2_QATU
                            nSaldoComprometido :=  SB2->B2_RESERVA + SB2->B2_QEMP + SB2->B2_QACLASS + SB2->B2_QEMPSA + SB2->B2_QEMPPRJ + SB2->B2_QTNP + SB2->B2_QEMPPRE

                            // Se o saldo comprometido for maior que o saldo físico, saldo disponível = 0
                            If nSaldoComprometido > nSaldoFisico
                                nSaldoDisponivel := 0
                            Else
                                nSaldoDisponivel := nSaldoFisico - nSaldoComprometido
                            EndIf
                        EndIf

                        SB2->(DbCloseArea())

                        Begin Transaction 

                        If Val(nQtd) <= nSaldoDisponivel
                            MSExecAuto({|x, y| MATA261(x, y)}, aAuto, nOpcAuto)
                        Else
                             //Help(, ,"AVISO#0010", ,"Quantidade informada maior que saldo disponível",1, 0, , , , , , {})
                            cLog += "Linha " + cValToChar(nLinhaAtu) + " Produto "+Alltrim(cProduto)+" não possui saldo suficiente, ";
                            + "saldo disponível para transferência: " +cValToChar(nSaldoDisponivel)+ "         NÃO PROCESSADO " + CRLF
                            lLog := .T.
                        EndIf
                    
                            //Se houve erro, mostra a mensagem
                                If lMsErroAuto 
                                    MostraErro()
                                    cLog += "Linha " + cValToChar(nLinhaAtu) + " Produto "+Alltrim(cProduto)+ "        NÃO PROCESSADO " + CRLF
                                    DisarmTransaction()
                                    lLogError := .T.
                                ElseIf lLog
                                    DisarmTransaction()
                                ElseIf lLog .AND. lMsErroAuto
                                    MostraErro()
                                    cLog += "Linha " + cValToChar(nLinhaAtu) + " Produto "+Alltrim(cProduto)+ "        NÃO PROCESSADO " + CRLF
                                    DisarmTransaction()
                                //Se deu tudo certo, efetiva a numeração
                                Else
                                cLog += "Linha " + cValToChar(nLinhaAtu) + " Produto "+Alltrim(cProduto)+ "         PROCESSADO COM SUCESSO " + CRLF
                                    ConfirmSX8()
                                EndIf

                                lLog := .F.
                        End Transaction
                    EndIf
                EndIf
                  
            EndDo

            //Se tiver log, mostra ele
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            Else 
              FWAlertSuccess("Transferência realizada com sucesso!!!", "Sucesso")
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
