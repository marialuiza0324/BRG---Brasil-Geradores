#INCLUDE "rwmake.ch"

/////////////////////////////////////////////////////////////////////////////
// Programa...: GERAVT                                                   //
// Autor......: RICARDO MOREIRA						                       //
// Data.......: 12/01/2021                                                 //
// Descrição..: Função realiza calculo o vale tranporte         	       // 
//                                                                          //
//                                                                          //    
// Posicao....: 00411         // Linha do Roteiro                          //
////////////////////////////////////////////////////////////////////////////

User Function GERAVLT()

Local nSindica   :=  SRA->RA_SINDICA            // Guarda codigo do Sindicato do Funcionario
Local nCC        :=  SRA->RA_CC                // Centro de Custo
Local nPerc      :=  SRA->RA_PORCVT //10                         // Percentual para calculo do Sexênio 
Local _Valor     :=  0 
Local nValAdto   :=  0                        // Valor do Adiantamento Salarial 
Local nDiasTrab  :=  0                        // Variavel guarda dias Trabalhados 
Local nValSex    :=  0                          // Variavel guarda calculo sexênio

If SRA->RA_XVT == "1" 
   If nPerc > 0
      _Valor:= (((SRA->RA_SALARIO*nPerc)/100)/30*DIASTRAB)  
   Else
      _Valor:= (SRA->RA_SALARIO*POSICIONE("RCE",1,XFILIAL("RCE")+SRA->RA_SINDICA,"RCE_XVT")/100)/30*DIASTRAB 
   EndIf
      FGERAVERBA("561",_Valor,DIASTRAB,,,,"I",,,,.F.)  
   //fGeraVerba("183",nValSex,nPerc,,nCC,"V","C",0,,dData_Pgto,.T.) 

Endif                                                                                                                                                                                                                                                                                                                                                                          
Return 
