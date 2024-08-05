#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³MA020TOK   ºAutor ³Ricardo Moreira       º Data ³ 12/11/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verificação de dados na inclusão/alteração de fornecedores º±±
±±º          ³ Principalmente dados para NFs de Exportação               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MA020TOK()

Local lOk   := .T.
Local cTipo := M->A2_TIPO
Local cCnpj := M->A2_CGC
Local cNome := M->A2_NOME
Local cNred := M->A2_NREDUZ
Local cEnd  := M->A2_END
Local cBair := M->A2_BAIRRO
Local cEst  := M->A2_EST
Local cCodMun := M->A2_COD_MUN
Local cMun  := M->A2_MUN
Local cCep  := M->A2_CEP
Local cDdd  := M->A2_DDD
Local cTel  := M->A2_TEL
Local cInsc := M->A2_INSCR
Local cEmail:= M->A2_EMAIL
Local cPais := M->A2_CODPAIS
Local cContr:= M->A2_CONTRIB
Local cSimp := M->A2_SIMPNAC
Local cCont := M->A2_CONTATO
Local cBlq  := M->A2_MSBLQL //  (1-Sim, 2-Não) caracter 
Local cPais1:= M->A2_PAIS

If Inclui .or. Altera
 
  If cBlq == "1" //sim
  Do case
    case empty(cTipo)
         Help("",1,"FWMODELPOS",,"Preencher o Campo Tipo",1)   
		lOk := .F.  
	case empty(cCnpj)
        Help("",1,"FWMODELPOS",,"Preencher o Campo CNPJ",1) 
		lOk := .F.  
	case empty(cNome)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Razão Social",1)
		lOk := .F.  
    case empty(cCep)
        Help("",1,"FWMODELPOS",,"Preencher o Campo CEP",1)
		lOk := .F.  
	case empty(cMun)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Municipio",1)  
		lOk := .F.  
	case empty(cNred)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Nome Reduzido",1) 
		lOk := .F.  
    case empty(cDdd)
        Help("",1,"FWMODELPOS",,"Preencher o Campo DDD",1)
		lOk := .F.  
    case empty(cEnd)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Endereço",1) 
		lOk := .F.  
    case empty(cTel)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Telefone",1) 
		lOk := .F.  
    case empty(cCont)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Contato",1) 
		lOk := .F.  	
    case empty(cEmail)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Email",1) 
		lOk := .F. 
  EndCase 

elseif cBlq == "2" //não

  Do case
	case empty(cTipo)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Tipo",1)     
		lOk := .F.  
	case empty(cCnpj)
        Help("",1,"FWMODELPOS",,"Preencher o Campo CNPJ",1) 
		lOk := .F.  
	case empty(cNome)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Razão Social",1)
		lOk := .F.  
	case empty(cNred)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Nome Reduzido",1)     
        lOk := .F.  
    case empty(cDdd)
        Help("",1,"FWMODELPOS",,"Preencher o Campo DDD",1)
		lOk := .F.  
    case empty(cTel)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Telefone",1)     
        lOk := .F.  
    case empty(cCont)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Contato",1) 
		lOk := .F.  	
    case empty(cEmail)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Email",1)         
		lOk := .F. 
    case empty(cEnd)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Endereço",1)        
		lOk := .F. 
    case empty(cBair)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Bairro",1)
        lOk := .F. 
    case empty(cCodMun)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Cod Municipio",1)
        lOk := .F. 
    case empty(cMun)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Municipio",1)         
		lOk := .F. 
    case empty(cCep)
        Help("",1,"FWMODELPOS",,"Preencher o Campo CEP",1)
		lOk := .F. 
    case empty(cInsc)         
        Help("",1,"FWMODELPOS",,"Preencher o Campo Ins. Estadual",1)
		lOk := .F. 
    case empty(cPais)         
        Help("",1,"FWMODELPOS",,"Preencher o Campo País",1)
		lOk := .F. 
    case empty(cContr)         
        Help("",1,"FWMODELPOS",,"Preencher o Campo Contribuinte",1)
		lOk := .F. 
    case empty(cSimp)         
        Help("",1,"FWMODELPOS",,"Preencher o Campo Simples Nacional",1)
		lOk := .F. 
    case empty(cEst)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Estado",1)        
		lOk := .F. 
    case empty(cPais1)
        Help("",1,"FWMODELPOS",,"Preencher o Campo Cod País",1)        
		lOk := .F. 
  EndCase 

  EndIf
EndIf
     
Return lOk
