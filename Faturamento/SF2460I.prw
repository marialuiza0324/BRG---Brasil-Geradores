#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//------------------------------------------------------------------------
//Autor: Ricardo Moreira de Lima
//Data: 14/06/2018
//Função: BRG005.PRW
//Descrição: Relatório para extrair dados estoque para inventario,
//
//------------------------------------------------------------------------

User Function SF2460I()

Local _Tx      := SE4->E4_FINAN  
Local _VlPrin  := SF2->F2_VALBRUT -SC5->C5_VLRENT
Local _VlFinan := 0
Local _Parc    := SE1->E1_PARCELA 
//Local _vEntr   := SE4->E4_VLENT //Valor de Entrada (Tabela Price)
//Local _vEntr := SC5->C5_VLRENT  //Valor de Entrada (Tabela Price)
Local _VlVen  := SF2->F2_VALBRUT -SC5->C5_VLRENT
Local _Juros   := 0
Local _Amort   := 0
Local _SaldDev := SF2->F2_VALBRUT -SC5->C5_VLRENT
Private _Nota := SF2->F2_DOC
Private _Ser  := SF2->F2_SERIE


IF SE4->E4_PRIME = "1"
//Customização para Calcular a Tabela Price - Inicio - 27/10/2020
  _VlParc := _VlVen*(((1+(_Tx/100))^Val(NParc()))*(_Tx/100))/((1+(_Tx/100))^Val(NParc())-1)
//Customização para Calcular a Tabela Price - Fim
   If _Tx >  0 
      DbSelectArea("SE1")
      SE1->( DbSetOrder(1) ) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO                                                                                               
      If SE1->(DbSeek( xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC))
         If SE1->E1_TIPO = "NF"	  
            RecLock("ZPR",.T.)
            ZPR->ZPR_FILIAL := xFilial("SE1")
            ZPR->ZPR_NOTA   := SE1->E1_NUM
            ZPR->ZPR_SERIE  := SE1->E1_PREFIXO
            ZPR->ZPR_VALOR  := 0
            ZPR->ZPR_PARC   := "00"
            ZPR->ZPR_AMORT  := 0
            ZPR->ZPR_JURO   := 0
            ZPR->ZPR_SLDEV  := _VlVen
            ZPR->( MsUnLock() )
         EndIf
	      While xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
               If dDataBase <> SE1->E1_VENCTO .and. SE1->E1_TIPO = "NF"
		            _Juros := (_SaldDev *(_Tx/100)) //
		            _Amort := _VlParc - _Juros //
                  _SaldDev := _SaldDev - _Amort

                  //Altera o Contas areceber conforme a tabela. Inicio
                  RecLock("SE1",.F.)
                  SE1->E1_VALOR   := _Amort
                  SE1->E1_SALDO   := _Amort
                  SE1->E1_VLCRUZ  := _Amort
                  SE1->E1_BASCOM1 := _Amort
                  SE1->E1_ACRESC  := _Juros
                  SE1->E1_SDACRES := _Juros
                  SE1->E1_VALJUR  := _Amort *(SE1->E1_PORCJUR/100)
                  msUnlock()
                  // Altera o Contas areceber conforme a tabela. Fim

		            DbSelectArea("ZPR")
		            ZPR->(DbSetOrder(1))
		            If !ZPR->(DbSeek(xFilial("ZPR")+SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_PARCELA ) )
		               RecLock("ZPR",.T.)
		               ZPR->ZPR_FILIAL := xFilial("SE1")
		               ZPR->ZPR_NOTA   := SE1->E1_NUM
		               ZPR->ZPR_SERIE  := SE1->E1_PREFIXO
		               ZPR->ZPR_VALOR  := _VlParc
		               ZPR->ZPR_PARC   := SE1->E1_PARCELA
		               ZPR->ZPR_AMORT  := _Amort
		               ZPR->ZPR_JURO   := _Juros
		               ZPR->ZPR_SLDEV  := _SaldDev // - _Amort 
		               ZPR->( MsUnLock() )                  
		            Endif	
        		   Endif
		            SE1->( DbSkip() )
	      EndDo

        Endif 
    EndIf
Else
    
  If _Tx >  0   
   _VlFinan := ((_VlPrin + ( _VlPrin *  (_Tx/100))))/ VAL(_Parc)

    DbSelectArea("SE1")
    DbSetOrder(2)  
    IF dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC) 
       Do While ! EOF() .AND. SF2->F2_FILIAL = xFilial("SE1") .AND. SE1->E1_PREFIXO = SF2->F2_SERIE .AND. SE1->E1_NUM = SF2->F2_DOC .AND. SE1->E1_CLIENTE = SF2->F2_CLIENTE .AND. SE1->E1_LOJA = SF2->F2_LOJA   
          RecLock("SE1",.F.)
          SE1->E1_VALOR  := _VlFinan
          SE1->E1_SALDO  := _VlFinan
          SE1->E1_VLCRUZ := _VlFinan
          msUnlock()
	      SE1->(dbskip())
       ENDDO
    EndIf
  EndIf
Endif
Return

//Retorna o Numero de Parcelas do financeiro que gerou a Nota/Titulo

Static Function NParc()   
Local cParc := ""

If Select("TMP2") > 0
	TMP2->(dbCloseArea())
EndIf

_cQry := "SELECT count(*) Parcela     "
_cQry += "FROM " + retsqlname("SE1")+" SE1 "  
_cQry += "WHERE SE1.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SE1.E1_NUM = '" + _Nota + "' "
_cQry += "AND   SE1.E1_PREFIXO = '" + _Ser + "' "   
_cQry += "AND   SE1.E1_EMISSAO <> SE1.E1_VENCTO "
_cQry += "AND   SE1.E1_FILIAL = '"+xFilial("SE1")+"'"

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP2"

 cParc   :=   cvaltochar(TMP2->Parcela)
       
Return cParc


