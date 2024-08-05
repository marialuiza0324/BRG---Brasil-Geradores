//BRG GERADORES
//DATA 20/02/2018
//3RL Soluções - Ricardo Moreira
//Traz o custo total de cada item

User Function M185CAMP()  

Local cCampo  := PARAMIXB[1]  //-- Nome do campo que esta sendo processado
Local z       := PARAMIXB[2]  //-- Numero da linha posicionada no aCols
Local nX      := PARAMIXB[3]   	//-- Dimensão de posição do array A185Dados ('Array onde esta os movimentos a serem gerados')
Local i       := PARAMIXB[4]  //-- Dimensão do campo dentro do aCols.//-- Customização do cliente
Private  _cProd      := " " 
Private  _cLocal     := " " 
Private  _num        := " " 
Private  _item       := " " 
Private  _cProd      := " " 


If cCampo == "D3_OBS" 

  _num    := a185dados[nx,2]
  _item   := a185dados[nx,3]
  _cProd  := a185dados[nx,4] 
  _cLocal := a185dados[nx,6] 
  aCols[z][i] := xObs()  
  
EndIF


If cCampo == "D3_CUSTO1"    //18  
   //_Valor := a185dados[nx,8] 

  _num    := a185dados[nx,2]
  _item   := a185dados[nx,3]
  _cProd  := a185dados[nx,4] 
  _cLocal  := a185dados[nx,6]  
  aCols[z][i] := xCusto() * xQUANT() //_Valor //Val(a185dados[nx,8])   
EndIF

Return Nil                 


Static Function xCusto() //U_ProxOp   

Local _Custo := " " 

If Select("TMP5") > 0
	TMP5->(DbCloseArea())
EndIf  

cQry := " "
cQry += "SELECT B2_CM1 Custo "
cQry += "FROM " + retsqlname("SB2")+" SB2 "
cQry += "WHERE SB2.D_E_L_E_T_ <> '*' "
cQry += "AND B2_FILIAL = '" + cFilAnt + "' " 
cQry += "AND B2_COD = '" + _cProd + "' "
cQry += "AND B2_LOCAL = '" + _cLocal + "' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP5",.T.,.T.) 

_Custo := TMP5->Custo 

Return _Custo        

Static Function xQUANT() //U_ProxOp   

Local _Quant := " " 

If Select("TMP6") > 0
	TMP6->(DbCloseArea())
EndIf  

cQry := " "
cQry += "SELECT CP_Quant Quant "
cQry += "FROM " + retsqlname("SCP")+" SCP "
cQry += "WHERE SCP.D_E_L_E_T_ <> '*' "
cQry += "AND CP_FILIAL = '" + cFilAnt + "' " 
cQry += "AND CP_NUM = '" + _num + "' "
cQry += "AND CP_ITEM = '" + _item + "' "    
cQry += "AND CP_PRODUTO = '" + _cProd + "' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP6",.T.,.T.) 

_Quant := TMP6->Quant 

Return _Quant  

Static Function xObs() //U_xObs   

Local _Obs := " " 

If Select("TMP7") > 0
	TMP7->(DbCloseArea())
EndIf  

cQry := " "
cQry += "SELECT CP_OBS Obs "
cQry += "FROM " + retsqlname("SCP")+" SCP "
cQry += "WHERE SCP.D_E_L_E_T_ <> '*' "
cQry += "AND CP_FILIAL = '" + cFilAnt + "' " 
cQry += "AND CP_NUM = '" + _num + "' "
cQry += "AND CP_ITEM = '" + _item + "' "    
cQry += "AND CP_PRODUTO = '" + _cProd + "' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP7",.T.,.T.) 

_Obs := TMP7->Obs 

Return _Obs 
