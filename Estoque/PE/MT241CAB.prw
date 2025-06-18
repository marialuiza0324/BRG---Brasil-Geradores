#INCLUDE "TOTVS.CH"
#INCLUDE'TBICONN.CH'

User Function MT241CAB()

/*
    Ponto de entrada MT241CAB permite a inclus�o de campos no cabe�alho da rotina "Movimentos Internos - Modelo 2".

    EM QUE PONTO: Nas fun��es A241Visual, A241Inclui, A241Estorn e ser� executado antes da chamada da
    MsDialog.

    Para armazenar o conte�do dos campos, deve retornar um vetor bidimensional, com a estrutura [L][C], onde:
    L = nome do campo, de acordo com o dicion�rio de dados,
    C = conte�do do campo.
 */ 
	Local oNewDialog := PARAMIXB[1]
	Local aCp := Array(3,2)
	Local cUserAlm  := SupergetMv("MV_USTMALM", ,)
	Local cUserid := RetCodUsr()

	If cUserid $ cUserAlm

		// Define os nomes dos campos
		aCp[1][1] := "D3_CP1"
		aCp[2][1] := "D3_CP2"
		aCp[3][1] := "BTN_CLIQUE"

		IF PARAMIXB[2] == 3
			// Inicializa os valores dos campos
			aCp[1][2] := SPAC(10)
			aCp[2][2] := SPAC(10)
			aCp[3][2] := "" // Valor do bot�o, pode ser usado para controle se necess�rio

			// Campo 1
			@ 1.6,44.5 SAY "Cpo1" OF oNewDialog
			@ 1.5,46.5 MSGET aCp[1][2] SIZE 40,08 OF oNewDialog

			// Campo 2
			@ 1.6,53.5 SAY "Cpo2" OF oNewDialog
			@ 1.5,55.5 MSGET aCp[2][2] SIZE 40,08 OF oNewDialog

			// Bot�o - ajustado para ficar acima do campo Cpo2
			@ 1.6,135 BUTTON "Armaz�m de Processo" SIZE 60,08 OF oNewDialog ACTION U_AjustaAcols()
		ENDIF
	Else
		aCp:=Array(2,2)


		aCp[1][1]="D3_CP1"
		aCp[2][1]="D3_CP2"

		IF PARAMIXB[2]==3
			// ALERT('PASSOU PELO PE MT241CAB')
			aCp[1][2]=SPAC(10)
			aCp[2][2]=SPAC(10)
			@1.6,44.5 SAY "Cpo1" OF oNewDialog
			@1.5,46.5 MSGET aCp[1][2] SIZE 40,08 OF oNewDialog
			@1.6,53.5 SAY "Cpo2" OF oNewDialog
			@1.5,55.5 MSGET aCp[2][2] SIZE 40,08 OF oNewDialog
		EndIf
	EndIf

return (aCp)


/*Valida��o para movimenta��o de produtos com apropria��o indireta
	Solicita��o #GLPI 10242  - Maria Luiza - 11/06/2025
	*/

User Function AjustaAcols()

       // Declara��o de vari�veis locais
       Local cProdApropri := ""
       Local cLocPad := ""
       Local i
       Local cCod := AScan(aHeader, {|x| Alltrim(x[2]) == "D3_COD"})
       Local _Tm := CTM
       Local cTMAlm := SupergetMv("MV_TMALM" , ,)

       // Obt�m o c�digo do produto
       _cod := Acols[n,cCod]

       // Busca apropria��o e local padr�o do produto
       cProdApropri := Posicione('SB1', 1, FWxFilial('SB1') + _cod, 'B1_APROPRI')
       cLocPad := Posicione('SB1', 1, FWxFilial('SB1') + _cod, 'B1_LOCPAD')

       // Percorre as colunas da matriz Acols
       For i := 1 to Len(Acols)
              // Verifica se o tipo de movimento est� permitido
              If _Tm $ cTMAlm
                     // Se o produto � de apropria��o indireta
                     If cProdApropri == "I"
                            // Ajusta os campos conforme regra
                            Acols[i][73] := Acols[i][7]
                            Acols[i][72] := Acols[i][2]
                            Acols[i][7] := ""
                            Acols[i][2] := cLocPad
                     EndIf
              Else
                     // Exibe mensagem de aviso se n�o tiver permiss�o
                     Help(, ,"AVISO#0003", ,"Usu�rio " +cUserName+ " n�o tem permiss�o para utilizar TM selecionada",1, 0, , , , , , {"Utilize a(s) TM(s) : " +cTMAlm})
              EndIf
       Next

Return
Return


