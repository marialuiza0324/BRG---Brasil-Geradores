#include "rwmake.ch"

User Function M440STTS()
  
//msginfo("teste")

//If SD3->D3_CF == "PR0" .AND.  SD3->D3_QUANT > 0  
	_cde_pa      :=Alltrim(getmv("MV_WFMAIL"))
	_cconta_pa   :=Alltrim(getmv("MV_WFMAIL"))
	_csenha_pa   :=Alltrim(getmv("MV_WFPASSW"))

	_cpara_pa    := "3rlsolucoes@gmail.com"   //
	_ccc_pa      :=" " //"marlon.pablo@brggeradores.com.br"  
	_ccco_pa     :=" " // com copia oculta
	_cassunto_pa :="Produto Cadastrado: "+sb1->b1_cod+"/"+sb1->b1_desc
    
	_cmensagem_pa:="Produto: "+sb1->b1_cod+"<P>"
	_cmensagem_pa+="Descrição: "+sb1->b1_desc+"<P>"    		
	_cmensagem_pa+="Tipo: "+alltrim(sb1->b1_tipo)+"<P>"
	  	//_cmensagem_pa+="Data Liberacao: "+dtoc(sc9->c9_datalib)+"<P>"
   //	_cmensagem_pa+="Lote: "+sh6->h6_lotectl+"<P>"
	_cmensagem_pa+="Usuario: "+cusername+"<P>"
   	_cmensagem_pa+="Data: "+dtoc(date())+"<P>"
	_cmensagem_pa+="Hora: "+time()+"<P>"
					
	_canexos_pa  :="" // caminho completo dos arquivos a serem anexados, separados por ;
	_lavisa_pa   :=.f.
	u_envemail(_cde_pa,_cconta_pa,_csenha_pa,_cpara_pa,_ccc_pa,_ccco_pa,_cassunto_pa,_cmensagem_pa,_canexos_pa,_lavisa_pa)
//EndIf
			
return Nil   
