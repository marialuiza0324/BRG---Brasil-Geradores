#include "Protheus.ch"

/*
Funcao      : Tabela Price
Objetivos   : AxCadastro da tabela ZPR
*/
*---------------------*
User Function BRG021()  //U_PHA008()
*---------------------*
Local   cOldArea := Select()
Local   cAlias    := "ZPR"
Private cCadastro := "Tabela Price"
Private aRotina   :=  { { "Pesquisar" ,"AxPesqui"                          ,0,1},;
                      { "Visualizar"  ,"AxVisual"                          ,0,2},;
                      { "Incluir"     ,"AxInclui"                          ,0,3},;
                      { "Altera"      ,"AxAltera"                          ,0,4},;
                      { "Excluir"     ,"AxDeleta"                          ,0,5}}


//abre a tela de manutenção
MBrowse(,,,,cAlias,,,,,,)   

//volta pra area inicial
dbSelectArea(cOldArea)     
//
Return 
