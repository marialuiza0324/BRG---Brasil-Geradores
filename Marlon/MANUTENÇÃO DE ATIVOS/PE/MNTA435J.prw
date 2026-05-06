#include 'protheus.ch'
  
User Function MNTA435J()
  
    Local aButtons := ParamIXB[1]
      
    /*---------------------+
    | Incluindo novo botão |
    +---------------------*/
    aAdd( aButtons,  { 'PMSPRINT', { || U_RelOs() , '' }, 'Imprimir O.S Fotográfica', 'oBtn435J', .T. } )

Return aButtons
