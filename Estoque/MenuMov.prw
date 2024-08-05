#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#Include 'Protheus.ch'

User Function MenuMov()
    //Cria o MsApp
    MsApp():New('SIGAFIN')
    oApp:CreateEnv()
     
    //Seta o tema do Protheus (SUNSET = Vermelho; OCEAN = Azul)
    PtSetTheme("SUNSET")
     
    //Define o programa que será executado após o login
    oApp:cStartProg    := 'U_BRG023()'
    //oApp:cStartProg    := 'fA100Pag()'
    //Seta Atributos 
    __lInternet := .T.
     
    //Inicia a Janela 
    oApp:Activate()
Return Nil
