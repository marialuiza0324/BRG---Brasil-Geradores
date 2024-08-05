#include "Protheus.ch"

/*
Funcao      : Cadastro de de Regras Contabilização
Objetivos   : AxCadastro da tabela ZCL
*/
*---------------------*
User Function CRIATAB()  //U_BRG013()
*---------------------*
Local   cOldArea := Select()
Local   cAlias    := "ZA2"//U_NTAB()       
Private cCadastro := "Cria Tabela"
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

*---------------------*
User Function NTAB()
*---------------------*
//Local oError := ErrorBlock({|e|ChecErro(e)}) //Para exibir um erro mais amigável
Local cRetorno := ""
Local nRetorno := 0
cRetorno := FWInputBox("Informe a Tabela", "")
Return(cRetorno)
