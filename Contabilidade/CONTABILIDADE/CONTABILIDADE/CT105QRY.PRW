#INCLUDE 'PROTHEUS.CH'

/*-------------------------------------------------------------------
- Programa: CT105QRY
- Autor: Claudio Ferreira
- Data: 16.03.23
- Descrição: PE Usado alterar a ordem da contabilziação
- Uso: TBC-GO
-------------------------------------------------------------------*/


User Function CT105QRY
Local cQuery:=Paramixb[1]  
//MemoWrit("D:\QUERY_old.sql", cQuery)
If AllTrim(FUNNAME())$'CTBANFS/CTBANFE'        
  cQuery:=StrTran(cQuery,'ORDER BY CTK_FILIAL,CTK_SEQUEN, CTK_TABORI, CTK_RECORI, R_E_C_N_O_','ORDER BY CTK_FILIAL,CTK_SEQUEN, R_E_C_N_O_') 
endif  
If AllTrim(FUNNAME())$'CTBAFIN/'        
  cQuery:=StrTran(cQuery,'ORDER BY CTK_FILIAL,CTK_SEQUEN, CTK_TABORI, CTK_RECORI, R_E_C_N_O_','ORDER BY CTK_FILIAL,CTK_SEQUEN,CTK_AT01DB,CTK_TABORI, CTK_RECORI, R_E_C_N_O_') 
endif 
//MemoWrit("D:\QUERY.sql", cQuery)
Return cQuery


