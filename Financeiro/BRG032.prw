#include "Protheus.ch"

/*
Funcao      : Cadastro de Diaria
Objetivos   : AxCadastro da tabela ZPD
*/
*---------------------*
User Function BRG032()  //U_BRG032()
*---------------------*
Local   cOldArea := Select()
Local   cAlias    := "ZPD"        
Private cCadastro := "Cadastro de Diárias"
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
