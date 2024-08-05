#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.ch"
  
User Function SPED1601()
  
    Local aReg1601  := {}
    Local dDataDe   := Iif(Len(paramixb) >= 1 , paramixb[1], ctod("  /  /  "))
    Local dDataAte  := Iif(Len(paramixb) >= 2 , paramixb[2], ctod("  /  /  "))
    Local cQuery    := ""
    Local cAliasTrb := GetNextAlias()
  
  
    // COD_PART_IP - COD_PART_IT - TOT_VS - TOT_ISS - TOT_OUTROS
    // Exemplo do Array
    // aAdd (aReg1601, {"CODIGO_CLIENTE_ADM_CARTAO","CODIGO_INTERMEDIADOR",0,0,0})
    // OBS:
    // COD_PART_IP: O valor informado deve existir no campo COD_PART do registro 0150.
    // COD_PART_IT: O valor informado deve existir no campo COD_PART do registro 0150.
    // TOT_VS : o valor deve ser preenchido com o total bruto de vendas que tiveram escritura��o de ICMS , inclusive como ICMS Isento ou Outros
    // TOT_ISS: o valor deve ser preenchido com o total bruto de presta��o de servi�os que tiveram incid�ncia de ISS.
    // TOT_OUTROS : o valor de ser preenchido com o total bruto das opera��es que n�o estejam no campo de incid�ncia do ICMS ou ISS.
  
    /*
    No modulo SIGAFAT n�o h� o controle de Administradoras de Cart�o para poder fazer amarra��o, portanto a ideia � fazer um DEPARA com a condi��o de pagamento
    e ter um registro na tabela SA1 que corresponda a operadora.
    Ex.: Foi criado a Condi��o de Pagamento "002" que corresponde as vendas de Cart�o de Credito, tamb�m foi criado um registro na tabela SA1 com as informa��es
    da operadora de Cart�o de Credito.
    Sugest�o para montagem da Consulta no banco de Dados:
    */
      
    cQuery := " SELECT "
    cQuery += "     F2_FILIAL AS FILIAL,"
    cQuery += "     AE_CODCLI + AE_LOJCLI AS COD_PART_IP,"
    cQuery += "     F2_CODA1U AS INTERMEDIADOR,"
    cQuery += "     CASE WHEN SUM(SF2.F2_VALICM) <> 0 THEN SUM(F2_VALBRUT) ELSE 0 END AS TOT_VS,"
    cQuery += "     CASE WHEN SUM(SF2.F2_VALISS) <> 0 THEN SUM(F2_VALBRUT) ELSE 0 END AS TOT_ISS,"
    cQuery += "     CASE WHEN SUM(SF2.F2_VALISS) = 0 AND SUM(SF2.F2_VALICM)= 0 THEN SUM(F2_VALBRUT) ELSE 0 END AS TOT_OUT "
    cQuery += " FROM "+RetSQLName("SF2")+" SF2 "
 
    cQuery += " INNER JOIN "+RetSQLName("SAE")+" SAE "
    cQuery += "     ON AE_FILIAL        = '"+ xFilial("SAE") +"'"
    cQuery += "     AND SAE.AE_COD      = F2_COND "
    cQuery += "     AND SAE.D_E_L_E_T_  = ' ' "
 
    cQuery += " WHERE F2_EMISSAO BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
    cQuery += "     AND SF2.D_E_L_E_T_ = ' ' "
 
    cQuery += " GROUP BY F2_FILIAL, AE_CODCLI, AE_LOJCLI, F2_CODA1U "
 
 
    cQuery := ChangeQuery( cQuery )
    DbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cAliasTrb, .T., .F. )
  
    While !(cAliasTrb)->( Eof() )
  
        // Fica a crit�rio do cliente a melhor maneira de realiza��o a amarra��o dos cadastros
        // No entanto, deve-se observar que esta informa��o deve ser enviada com o c�digo do CLIENTE + LOJA com todos os caracteres
 
        cCodAdm := (cAliasTrb)->COD_PART_IP  // "C09   01" // CODIGO + LOJA -> AE_CODCLI + AE_LOJCLI
  
        aADD(aReg1601, {(cAliasTrb)->FILIAL,cCodAdm,(cAliasTrb)->INTERMEDIADOR,(cAliasTrb)->TOT_VS,(cAliasTrb)->TOT_ISS,(cAliasTrb)->TOT_OUT})
          
        (cAliasTrb)->(DbSkip())
    EndDo
  
    (cAliasTrb)->(DbCloseArea())
  
Return aReg1601
