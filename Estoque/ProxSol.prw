/*/
�����������������������������������������������������������������������������
���Programa  � RetNSol   � Autor � Ricardo Moreira    � Data � 26/04/2017 ���
������������������������������������ͱ�����������������������������������͹��
���Descricao � Retorna o N�mero da Proxima Solicita��o a ser gravada      o��
�����������������������������������������������������������������������������
/*/

User Function ProxSol() //U_ProxSol()
//Verifica se o arquivo TMP est� em uso

Local _Num := " "
If Select("QTMP") > 0
	QTMP->(DbCloseArea())
EndIf
cQry := " "
cQry += "SELECT TOP 1 CP_NUM "
cQry += "FROM " + retsqlname("SCP")+" SCP "
cQry += "WHERE SCP.D_E_L_E_T_ <> '*' "
cQry += "AND CP_FILIAL = '" + cFilAnt + "' "
cQry += "ORDER BY CP_NUM DESC "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"QTMP",.T.,.T.)

_Num:= str(val(QTMP->CP_NUM)+1)

Return _Num
