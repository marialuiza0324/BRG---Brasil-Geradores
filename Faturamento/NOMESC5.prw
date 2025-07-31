#Include "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOMESC5   �Autor  �Pedro Paulo Aires   � Data �  28/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE para informar o nome do cliente ou fornecedor conforme  ���
���          � o tipo do pedido.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � TOTVS                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function NOMESC5()                             
Local cNomCli :=  "" 

/*
	DATA: 02/06/2022
	AUTOR: MARLON PABLO
	DESCRI��O: AVISO DE CLIENTE N�O CONTRIBUINTE
*/

//INICIO
Local cContrib := ""

	DbSelectArea("SA1")
    DbSetOrder(1)  
    dbSeek(xFilial("SA1")+M->C5_CLIENTE)

	If Funname() <> "LOCA001"

			IF SA1->A1_CONTRIB == '2'
				cContrib := '<b style="color:red">N�O CONTRIBUINTE!!!</b>'
			ELSE
				cContrib := 'Contribuinte SIM/N�O CHR(13)<b style="color:red">N�O INFORMADO</b> no cadastro do cliente!!!'
			ENDIF

			FWAlertWarning('Cliente '+cContrib, "Aviso Cliente Contribuinte")


		//FIM

		
		//Validar se o tipo do Pedido de Vendas cont�m D ou B
		IF (M->C5_TIPO $ 'DB')                              
			cNomCli := POSICIONE ("SA2",1,XFILIAL("SA2")+M->C5_CLIENTE+M->C5_LOJACLI,"A2_NOME") 
		Else
			cNomCli := POSICIONE ("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NREDUZ")                                                                                         
		EndIf
	EndIf
	
Return (cNomCli)
