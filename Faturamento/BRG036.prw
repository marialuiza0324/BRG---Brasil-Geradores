#include "Protheus.ch"

/*
Funcao      : Cadastro de Clausula x Contrato
Objetivos   : AxCadastro da tabela ZCL
*/
*---------------------*
User Function BRG036()  //U_BRG013()
*---------------------*
Local   cOldArea := Select()
Local   cAlias    := "ZLI"        
Private cCadastro := "Itens Remesssa Loca��o"
Private aRotina   :=  { { "Pesquisar" ,"AxPesqui"                          ,0,1},;
                      { "Visualizar"  ,"AxVisual"                          ,0,2},;
                      { "Incluir"     ,"AxInclui"                          ,0,3},;
                      { "Altera"      ,"AxAltera"                          ,0,4},;
                      { "Excluir"     ,"AxDeleta"                          ,0,5}}


//abre a tela de manuten��o
MBrowse(,,,,cAlias,,,,,,)   

//volta pra area inicial
dbSelectArea(cOldArea)     
//
Return 
