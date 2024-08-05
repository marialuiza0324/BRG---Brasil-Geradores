/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT103FIM  ³ Autor ³ RICARDO MOREIRA       ³ Data ³ 11/05/21³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada para Preencher a tabela ZPL , se ocorre   ³±±
±±³          ³ Controle de Palete  - nota de entrada                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para PHARMA                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#Include "RwMake.CH"
#include "tbiconn.ch"
#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOPCONN.CH'

User Function MT103FIM()

Local aArea    := GetArea()
Local nOpcao := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina 
Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÇÃO DO USUARIO..... 
Local _SerOri := ""
Local _DocOri := "" 
Local cCond := ""
Local nVIPI   := 0
Local nValTot := 0
Local dData   := CtoD("  /  /  ") //SC7->C7_DATPRF //SC7->C7_EMISSAO
Local nVSol   := 0
Local _Venc   := CtoD("  /  /  ")
Local _Total  := 0
Local _Parc   := ""
Local i := 1
Local cont := 1
Private _Nota   := SF1->F1_DOC
Private _Ser    := SF1->F1_SERIE 
Private _Cli    := SF1->F1_FORNECE
Private _Lj     := SF1->F1_LOJA  
Private _Emis   := SF1->F1_EMISSAO
Private lMsErroAuto := .F.
Private _PComp := "" //SD1->D1_PEDIDO //colocado em 24/08/2021
Private _Ped   := SD1->D1_PEDIDO

If nConfirma == 1 .and. (nOpcao == 3 .or. nOpcao == 4 .or. nOpcao == 5) //incluir
   IF SF1->F1_TIPO $ "B/D"
      DbSelectArea("SD1")
      DBGOTOP()
      DbSetOrder(1)  // D1_FILIAL +  D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA
      If DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
         While !SD1->(Eof()) .and. SF1->F1_FILIAL = SD1->D1_FILIAL .and. SF1->F1_DOC = SD1->D1_DOC .and. SF1->F1_DOC = SD1->D1_DOC
               _DocOri := SD1->D1_NFORI
               _SerOri := SD1->D1_SERIORI
               _It     := SD1->D1_ITEMORI                
               _Cod    := SD1->D1_COD

               DbSelectArea("ZLI")
               DBGOTOP()
               DbSetOrder(1)  // D1_FILIAL +  D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA
               If DbSeek(xFilial("ZLI")+_DocOri+_SerOri+alltrim(_It)+_Cod) 
                  ZLI->(RECLOCK("ZLI",.F.)) 
                  ZLI->ZLI_NOTRET := _Nota
                  ZLI->ZLI_SERRET := _Ser
                  ZLI->ZLI_DATRET := _Emis
                  ZLI->(MSUNLOCK())                  
               EndIf
               SD1->(dbSkip())
         Enddo
      EndIf
   ElseIf SF1->F1_TIPO = "N" //Deletar a Provisão de do pedido e gerar novamente 
    //01/08/2018 -Deletar as provisões Classificadas. Inicio   
     //IF (nOpcao == 3 .and. nOpcA == 1) .or. (nOpcao == 9 .and. nOpcA == 1) .or. (nOpcao == 4 .and. nOpcA == 1)
 //25/11/2021 grava historico na se2 - f1_mennota inicio
           DbSelectArea("SE2")
           DBGOTOP()
           DbSetOrder(6)  // D1_FILIAL +  D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA
           IF DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)  
              DO WHILE SE2->(!EOF()) .AND. SE2->E2_FILIAL = SF1->F1_FILIAL .AND. SE2->E2_NUM = SF1->F1_DOC .AND. SE2->E2_PREFIXO = SF1->F1_SERIE .AND. SE2->E2_FORNECE = SF1->F1_FORNECE .AND. SE2->E2_LOJA = SF1->F1_LOJA
                 SE2->(RECLOCK("SE2",.F.)) 
                 SE2->E2_HIST := SF1->F1_MENNOTA
                 SE2->(MSUNLOCK())   
                 SE2->(dbSkip())
           EndDo   
           SE2->(DbCloseArea())
         EndIf
 //25/11/2021 grava historico na se2 - f1_mennota fim

 //Tratamento para tirar (deletar) da tabela CDA as notas com CFOP 1556, q estão indo para o SPED, como diferença de DIFAL - Inicio  20/12/2022
         DbSelectArea("CDA")
         DBGOTOP()
         DbSetOrder(3)  // D1_FILIAL +  D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA
         IF DbSeek(xFilial("CDA")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)  
            DO WHILE CDA->(!EOF()) .AND. CDA->CDA_FILIAL = SF1->F1_FILIAL .AND. CDA->CDA_NUMERO = SF1->F1_DOC .AND. CDA->CDA_SERIE = SF1->F1_SERIE .AND. SE2->E2_FORNECE = CDA->CDA_CLIFOR .AND. CDA->CDA_LOJA = SF1->F1_LOJA
               If CDA->CDA_TPMOVI = "E"
                  RecLock("CDA",.F.)
                  CDA->( dbDelete() )
                  msUnlock()
               ENDIF
		            CDA->( DbSkip() )               
            EndDo   
           CDA->(DbCloseArea())
         EndIf

//Tratamento para tirar (deletar) da tabela CDA as notas com CFOP 1556, q estão indo para o SPED, como diferença de DIFAL - Fim


 
      If Select("TSD1") > 0
	      TSD1->(dbCloseArea())
      EndIf

      _cQryy := "SELECT DISTINCT D1_PEDIDO "
      _cQryy += "FROM " + retsqlname("SD1")+" SD1 "  
      _cQryy += "WHERE SD1.D_E_L_E_T_ <> '*' " 
      _cQryy += "AND   SD1.D1_FILIAL   = '" + cfilant  + "' "
      _cQryy += "AND   SD1.D1_DOC	= '" + _Nota  + "' " 
      _cQryy += "AND   SD1.D1_FORNECE   = '" + _Cli  + "' "
      _cQryy += "AND   SD1.D1_LOJA	= '" + _Lj  + "' " 
      //_cQryy += "AND   SD1.D1_PEDIDO	= '" + _Ped  + "' " 13/04/2022
      _cQryy += "GROUP BY D1_PEDIDO "
      _cQryy += "ORDER BY D1_PEDIDO "

      DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQryy)),"TSD1",.T.,.T.) 

      DO WHILE TSD1->(!EOF())

        _PComp := TSD1->D1_PEDIDO
        SE2->(DBSetOrder(1))	  
        SE2->(DbGoTop())
       If SE2->(dbSeek( xFilial("SC7")+"PRV"+_PComp+"/1"))   
   	     While !SE2->(Eof()) .and. xFilial("SC7")==SE2->E2_FILIAL .and. _PComp == SUBSTR(SE2->E2_NUM,1,6) .and.  _Cli == SE2->E2_FORNECE .and.  _Lj == SE2->E2_LOJA			
	          RecLock("SE2",.F.)
             SE2->( dbDelete() )
             msUnlock()
		       SE2->( DbSkip() )		   
	        EndDo		
           SE2->(DbCloseArea())

       //Fim
           cont := 1
           CRetPed()

          DO WHILE TSC->(!EOF())
        
             cCond   := TSC->C7_COND

             dData :=  stod(TSC->C7_DATPRF)
             nValTot := TSC->TOTAL + TSC->VALIPI + TSC->VALSOL	      
             aParc := Condicao(nValTot,cCond,nVIPI,dData,nVSol)
	  
	          For i:= 1 to Len(aParc)
		       //DO WHILE TMP->(!EOF())	
		          _Venc  := aParc[i,1]
		          _Total := aParc[i,2]   // CtoD("28/06/2018")
		          _Parc  := cvaltochar(i)
			
		          aArray := { { "E2_PREFIXO" , "PRV" , NIL },;
		          { "E2_NUM" , _PComp+"/"+CVALTOCHAR(cont) , NIL },;
		          { "E2_PARCELA" , _Parc , NIL },;    
		          { "E2_TIPO" , "PR" , NIL },;
		          { "E2_NATUREZ" , "202010058" , NIL },;  //Cadastrar uma natureza com titulo provisoriao
		          { "E2_FORNECE" , _Cli , NIL },;
		          { "E2_LOJA" , _Lj , NIL },;
		          { "E2_EMISSAO" , dData, NIL },;
		          { "E2_VENCTO" ,_Venc, NIL },;    
		          { "E2_VENCREA" ,_Venc, NIL },;
		          { "E2_VALOR" ,_Total, NIL } }    
			
		          MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
			
		          If lMsErroAuto
		             Alert("Erro")
			          MostraErro()			
		          Endif			
		         //IncRegua()
	            Next i
	            cont++

               TSC->(dbSkip()) 
          ENDDO
          EndIf
        TSD1->(dbSkip()) 
      ENDDO

   EndIf

//ElseIf If nConfirma == 1 .and.   nOpcao == 5) //ExCluir  
EndIf             

RestArea(aArea)

Return


//Query Retorno

Static Function CRetPed() //U_DevExt  

If Select("TSC") > 0
	TSC->(dbCloseArea())
EndIf

   _cQry := "SELECT DISTINCT C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF, SUM(C7_TOTAL) TOTAL, SUM(C7_VALIPI) VALIPI, SUM(C7_VALSOL) VALSOL "
   _cQry += "FROM " + retsqlname("SC7")+" SC7 "  
   _cQry += "WHERE SC7.D_E_L_E_T_ <> '*' " 
   _cQry += "AND   SC7.C7_FILIAL   = '" + cfilant  + "' "
   _cQry += "AND   SC7.C7_NUM	= '" + _PComp  + "' "
   _cQry += "AND   SC7.C7_ENCER = '' "
   _cQry += "AND   SC7.C7_QUJE <  SC7.C7_QUANT "
   _cQry += "GROUP BY C7_FILIAL,C7_NUM,C7_COND ,C7_EMISSAO, C7_DATPRF "
   _cQry += "ORDER BY C7_FILIAL, C7_NUM , C7_DATPRF "

   DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TSC",.T.,.T.) 

Return      
