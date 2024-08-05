#include "rwmake.ch"
#include "PROTHEUS.CH"
#Include "TOPCONN.CH" 
#Include "PARMTYPE.CH"

User Function CNTA300()

Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local lIsGrid    := .F.
Local nLinha     := 0
Local nQtdLinhas := 0
Local cMsg       := ''
Local nVIPI      := 0
Local nVSol      := 0
Local _Tx      := SE4->E4_FINAN  //Condição de pagametno
Local _Parc    := CN9->CN9_NPARC //SE1->E1_PARCELA
Local cCond    := CN9->CN9_CONDPG
Local nParc    := 1
Local dData    := CN9->CN9_DTINIC // Data Inicial
Local i
Local _VlVen  := CN9->CN9_VLINI-CN9->CN9_VLRENT //Valor do Contrato - Entrada
//Local _vEntr   := SE4->E4_VLENT //Valor de Entrada (Tabela Price)
//Local _vEntr := SC5->C5_VLRENT  //Valor de Entrada (Tabela Price)
 

If aParam <> NIL
      
       oObj       := aParam[1]
       cIdPonto   := aParam[2]
       cIdModel   := aParam[3]
       lIsGrid    := ( Len( aParam ) > 3 )
      
       //If lIsGrid
        //     nQtdLinhas := oObj:GetQtdLine()
      //       nLinha     := oObj:nLine
      // EndIf
      
       If     cIdPonto == 'MODELPOS'
             cMsg := 'Chamada na validação total do modelo (MODELPOS).' + CRLF
             cMsg += 'ID ' + cIdModel + CRLF
            
             If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
                    Help( ,, 'Help',, 'O MODELPOS retornou .F.', 1, 0 )
             EndIf
            
       
       ElseIf cIdPonto == 'MODELCOMMITNTTS'
//ApMsgInfo('Chamada apos a gravação total do modelo e fora da transação (MODELCOMMITNTTS).' + CRLF + 'ID ' + cIdModel)


IF SE4->E4_PRIME = "1"
//Customização para Calcular a Tabela Price - Inicio - 27/10/2020

//dData :=  stod(TSC7->C7_DATPRF)
nValTot := _VlVen	      
aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol)
//len(aParc)

  _VlParc := _VlVen*(((1+(_Tx/100))^len(aParc))*(_Tx/100))/((1+(_Tx/100))^len(aParc)-1)
  //_VlParc := _VlVen*(((1+(_Tx/100))^Val(_Parc))*(_Tx/100))/((1+(_Tx/100))^Val(_Parc)-1)
//Customização para Calcular a Tabela Price - Fim
   If _Tx >  0 
       FOR i := 1 TO LEN(aParc)

        DbSelectArea("ZPR")
        DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
        If  !DbSeek(xFilial("ZPR")+SUBSTR(CN9->CN9_NUMERO,7,9)+"C  "+cvaltochar(strzero(nParc,2))) 

            RecLock("ZPR",.T.)
            ZPR->ZPR_FILIAL := xFilial("CN9")
            ZPR->ZPR_NOTA   := SUBSTR(CN9->CN9_NUMERO,7,9)
            ZPR->ZPR_SERIE  := "C" // C de contrato
            ZPR->ZPR_VALOR  := _VlParc
            ZPR->ZPR_VENC   := aParc[i,1]
            ZPR->ZPR_PARC   := cvaltochar(strzero(nParc,2))
            ZPR->ZPR_AMORT  := 0
            ZPR->ZPR_JURO   := 0
            ZPR->ZPR_SLDEV  := _VlParc
            ZPR->( MsUnLock() )

           nParc++
        EndIf

       NEXT
        

    Endif 
    
Endif            
             //ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
            
       ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
//ApMsgInfo('Chamada apos a gravação da tabela do formulário (FORMCOMMITTTSPOS).' + CRLF + 'ID ' + cIdModel)
            
       ElseIf cIdPonto == 'MODELCANCEL'
//cMsg := 'Chamada no Botão Cancelar (MODELCANCEL).' + CRLF + 'Deseja Realmente Sair ?'
            
            // If !( xRet := ApMsgYesNo( cMsg ) )
              //      Help( ,, 'Help',, 'O MODELCANCEL retornou .F.', 1, 0 )
             //EndIf
            
       ElseIf cIdPonto == 'BUTTONBAR'
//ApMsgInfo('Adicionando Botao na Barra de Botoes (BUTTONBAR).' + CRLF + 'ID ' + cIdModel )
//xRet := { {'Salvar', 'SALVAR', { || Alert( 'Salvou' ) }, 'Este botao Salva' } }
            
       EndIf

EndIf

Return xRet
