/*/
???????????????????????????????????????????????????????????????????????????????
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±??????????????????????????????????????????????????????????????????????????ª±±
±±?Programa  ≥ CRFIN004 ? Autor ≥ Joao Paulo L. Ribeiro ? Data ≥ 19/08/2014 ?±±
±±???????????????????????????????????????????????????????????????????????????±±
±±?Descricao ≥ Relatorio de emprestimos financeiros HTML                    ?±±
±±?          ≥                                                              ?±±
±±???????????????????????????????????????????????????????????????????????????±±
±±?Uso       ≥ Copocentro                                                   ?±±
±±T??????????????????????????????????????????????????????????????????????????±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
???????????????????????????????????????????????????????????????????????????????
/*/

#include "protheus.ch"
#include "topconn.ch"
#include "totvs.ch"

//?????????????????????????????????????????????????????????????????????????????
user function CRFIN004
//?????????????????????????????????????????????????????????????????????????????
	private crlf	:= chr(13)+chr(10)
	private cperg	:= padr("CRFIN004",len(sx1->x1_grupo))    
	gerax1()                                                
	
	if pergunte(cperg,.t.)
		processa({||imprime()},"Imprimindo...")
	endif
	
return
                                                                             
//???????????????????????????????????????????????????????????????????????????
static function imprime()
//???????????????????????????????????????????????????????????????????????????	
	local lhainfo	:= .f.  
	local ngrupo	:= 0
	local agrupo	:= {}
	local aitem		:= {}
	local cultnum	:= ""
	local x := 1
	private _nhandle     

	procregua(0)   
	incproc()
	
	_cdirdocs	:= msdocpath()	
	_carq		:= "emprestimos.html"	 
	
	if file(_cdirdocs+"\"+_carq)
		ferase(_cdirdocs+"\"+_carq)
	endif                       	
	_nhandle:=fcreate(_cdirdocs+"\"+_carq,0) 
		                            
	implinha('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">')
	implinha('<html xmlns="http://www.w3.org/1999/xhtml">')
	implinha('<head>')
	implinha('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />')
	implinha('<title>Emprestimos</title>')
	implinha('<script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>')		
	implinha('<style type="text/css" media="all">')
	implinha('#titulo{')		
	implinha('	background-color:rgb(0,168,89);')
	implinha('	color:#FFFFFF;')
	implinha('	font-size:16px;	')
	implinha('	text-align:center;')              
	implinha('	height:35px;')
	implinha('	font-weight:bold;')
	implinha('}')
	implinha('#param{')		
	implinha('	font-size:12px;	')
	implinha('	cursor:pointer;')
	implinha('}')  		
	implinha('.pars{')
	implinha('	font-family:Arial, Helvetica, sans-serif;')
	implinha('	font-size:14px;	')
	implinha('}')
	implinha('')
	implinha('#principal{')
	implinha('	font-family:Arial, Helvetica, sans-serif;')
	implinha('}')
	implinha('')
	implinha('#principal td{')
	implinha('	border:rgb(0,168,89) 1px solid;')
	implinha('}')
	implinha('')
	implinha('.detalhes{')
	implinha('	width:20px;')
	implinha('	cursor:pointer;')
	implinha('	text-align:center;')
	implinha('}')
	implinha('')
	implinha('.cab{')
	implinha('	text-align:center;')              
	implinha('	height:35px;')
	implinha('	font-size:14px;')
	implinha('	font-weight:bold;')
	implinha('}')			
	implinha('')   
	implinha('.cab td{')
	implinha('	width:90px;	')
	implinha('}')
	implinha('')   
	implinha('.cab td:nth-child(1){')
	implinha('	width:40px;	')
	implinha('}')
	implinha('')
	implinha('.cab td:nth-child(2){')
	implinha('	width:400px;	')
	implinha('}')
	implinha('')        
	implinha('.cab{')
	implinha('	font-size:14px;		')
	implinha('	font-weight:bold;')
	implinha('}')
	implinha('')
	implinha('.grupo{')
	implinha('	text-align:right;')
	implinha('	font-size:14px;		')
	implinha('	font-weight:bold;')
	implinha('}')
	implinha('')
	implinha('.grupo td:nth-child(2){')
	implinha('	text-align:left;		')
	implinha('}')
	implinha('')
	implinha('.grupo td:nth-child(4){')
	implinha('	text-align:center;	')
	implinha('}')
	implinha('')
	implinha('.itens{')
	implinha('	font-size:14px;	')
	implinha('	text-align:right;')
	implinha('}')
	implinha('')
	implinha('.itens td:nth-child(3){')
	implinha('	text-align:center;	')
	implinha('}')
	implinha('')
	implinha('.itens td:first-child{')
	implinha('	text-align:left;	')
	implinha('}')
	implinha('#totais{')		
	implinha('	background-color:rgb(0,168,89);')
	implinha('	color:#FFFFFF;')
	implinha('}')		
	implinha('</style>')
	implinha('<script type="text/javascript" defer="defer" >')
	implinha('	$(function(){')
	implinha('    	$(".itens").hide();')
	implinha('    	$(".pars").hide();')
	implinha('    	$(".menos").hide();')
	implinha('	});')
	implinha('</script>')
	implinha('</head>')
	implinha('<body>')
	implinha('<div id="box">')  		
	implinha('<table id="principal" cellpadding="0" cellspacing="0">')
	implinha('	<tr id="titulo" >')	
	implinha('    	<td title="Inverte Sele??o (Todos)" onclick="$('+"'"+'.itens, .mais, .menos'+"'"+').toggle(); " class="detalhes" >')
	implinha('        	+/-')
	implinha('      </td>')  	
	implinha('    	<td colspan="11">')
	implinha('        	BRG - TESTE HTML')
	implinha('      </td>')  
	implinha('    	<td id="param" title="Mostrar/Ocultar Parﬂmetros" onclick="$('+"'"+'.pars'+"'"+').toggle(); " >')
	implinha('        	Parﬂmetros')
	implinha('      </td>')  
	implinha('	</tr>')
	dbselectarea("SX1")
	sx1->(dbsetorder(1))
	if sx1->(dbseek(cperg+"01"))				
		while sx1->x1_grupo == cperg  			
			if alltrim(sx1->x1_gsc) == "C"                           
				if valtype(&(sx1->x1_var01)) == "N"
					if &(sx1->x1_var01) < 5
						cctpar := para_texto(&("sx1->x1_def0"+alltrim(str(&(sx1->x1_var01)))))
					else
						cctpar := para_texto(&(sx1->x1_var01))
					endif
				else
					cctpar := para_texto(&(sx1->x1_var01))
				endif
			else
				cctpar := para_texto(&(sx1->x1_var01))
			endif
			implinha('	<tr class="pars" >') 
			implinha('    	<td colspan="13" >')
			implinha('           '+strtran(alltrim(sx1->x1_pergunt),"?",":")+' '+cctpar)
			implinha('    	</td>')
			implinha('	</tr>')
			sx1->(dbskip())
		end
	endif	 	
	implinha('	</tr>')	
	implinha('	<tr class="cab" >')
	implinha('    	<td title="Inverte Sele??o" onclick="$('+"'"+'.grpger'+"'"+').toggle(); " class="detalhes" >')
	implinha('        	+/-')
	implinha('        </td>')	
	implinha('        <td>')
	implinha('        	FORNCEDOR')
	implinha('        </td>')
	implinha('    	<td>') 
	implinha('        	NUMERO')
	implinha('        </td>')
	implinha('       	<td>')
	implinha('        	PARCELAS')
	implinha('        </td>')
	implinha('        <td>')
	implinha('        	VENCIMENTO')
	implinha('        </td>')
	implinha('        <td>')
	implinha('        	BAIXA')
	implinha('        </td>')
	implinha('        <td>')
	implinha('        	VALOR')
	implinha('        </td>')
	implinha('        <td>')
	implinha('        	VALOR PAGO')
	implinha('        </td>')
	implinha('        <td>')
	implinha('        	A PAGAR')
	implinha('        </td>')
	implinha('        <td>')
	implinha('        	JUROS')
	implinha('        </td>')
	implinha('        <td>')
	implinha('        	JUROS PAGOS')
	implinha('        </td>')
	implinha('        <td>')
	implinha('        	JUROS A PAGAR')
	implinha('        </td>')
	implinha('        <td>')
	implinha('        	TOTAL A PAGAR')
	implinha('        </td>')
	implinha('    </tr>') 

	geratmp1()	
	tmp1->(dbgotop())
	if !tmp1->(eof())
		lhainfo := .t.
		while !tmp1->(eof())                          
			cultnum	:= tmp1->num
			agrupo	:= {}
			aitens	:= {}
			while!tmp1->(eof()) .and. cultnum == tmp1->num 
				cultnum	:= tmp1->num
				aadd(aitens,{;
  								tmp1->fornece,;
  								tmp1->loja,;
  								tmp1->nomfor,;
  								tmp1->num,;
  								tmp1->parcela,;
  								substr(tmp1->vencrea,7,2)+"/"+substr(tmp1->vencrea,5,2)+"/"+substr(tmp1->vencrea,1,4),;
  								substr(tmp1->baixa,7,2)+"/"+substr(tmp1->baixa,5,2)+"/"+substr(tmp1->baixa,1,4),;
  								tmp1->valor,;
  								tmp1->valpag,;
  								tmp1->saldo,;
  								tmp1->jurmul,;
  								tmp1->jurmulpag,;
  								tmp1->jurmul-tmp1->jurmulpag,;
  								tmp1->saldo+(tmp1->jurmul-tmp1->jurmulpag)}) 
  								
  				if len(agrupo) == 0
  					aadd(agrupo,tmp1->fornece)
  					aadd(agrupo,tmp1->loja)
  					aadd(agrupo,tmp1->nomfor)
  					aadd(agrupo,tmp1->num)
  					aadd(agrupo,0)
  					aadd(agrupo,"")
  					aadd(agrupo,"")  				
  					aadd(agrupo,tmp1->valor)
  					aadd(agrupo,tmp1->valpag)
  					aadd(agrupo,tmp1->saldo)
  					aadd(agrupo,tmp1->jurmul)
  					aadd(agrupo,tmp1->jurmulpag)    
  					aadd(agrupo,aitens[len(aitens)][13])    
  					aadd(agrupo,tmp1->saldo+iif(aitens[len(aitens)][13]>0,aitens[len(aitens)][13],0))    
  				else
  					agrupo[8]	+= tmp1->valor
  					agrupo[9]	+= tmp1->valpag
  					agrupo[10]	+= tmp1->saldo
  					agrupo[11]	+= tmp1->jurmul
  					agrupo[12]	+= tmp1->jurmulpag
  					agrupo[13]	+= aitens[len(aitens)][13]
  					agrupo[14]	+= tmp1->saldo+iif(aitens[len(aitens)][13]>0,aitens[len(aitens)][13],0)
  				endif         
  				  				
  				tmp1->(dbskip())
			end   
			ngrupo++
			implinha('	<tr class="grupo" >')
			implinha('    	<td title="Mostrar/Ocultar Detalhes" onclick="$('+"'"+'.it'+alltrim(str(ngrupo))+"'"+').toggle();" class="detalhes" >')
			implinha('        	<span class="mais it'+alltrim(str(ngrupo))+' grpger ">')
			implinha('        		+')    
			implinha('        	</span>')
			implinha('        	<span class="menos it'+alltrim(str(ngrupo))+' grpger ">')
			implinha('        		-')    
			implinha('        	</span>')
			implinha('			</td>')    
			implinha('			<td title="Fornecedor" >')
			implinha('        		'+agrupo[1]+"/"+agrupo[2]+" - "+alltrim(agrupo[3]))
			implinha('			</td>')
			implinha('			<td title="Numero" >')
			implinha('        		'+agrupo[4])
			implinha('			</td>')
			implinha('			<td title="Quantidade de Parcelas" >')
			implinha('        		'+alltrim(str(len(aitens))))
			implinha('			</td>')
			implinha('			<td title="Vencimento" >')
			implinha('        		'+aitens[1][6]+' a '+aitens[len(aitens)][6])
			implinha('			</td>')
			implinha('			<td title="Data da baixa" >')
			implinha('        		')
			implinha('			</td>')
			implinha('			<td title="Valor" >')
			implinha('        		'+alltrim(transform(agrupo[8],"@E 999,999,999.99")))
			implinha('			</td>')
			implinha('			<td title="Valor Pago" >')
			implinha('        		'+alltrim(transform(agrupo[9],"@E 999,999,999.99")))
			implinha('			</td>')
			implinha('			<td title="Valor a Pagar" >')
			implinha('        		'+alltrim(transform(agrupo[10],"@E 999,999,999.99")))
			implinha('			</td>')
			implinha('			<td title="Juros" >')
			implinha('        		'+alltrim(transform(agrupo[11],"@E 999,999,999.99")))
			implinha('			</td>')
			implinha('			<td title="Juros Pagos" >')
			implinha('        		'+alltrim(transform(agrupo[12],"@E 999,999,999.99")))
			implinha('			</td>')
			implinha('			<td title="Juros a Pagar" >')
			implinha('        		'+alltrim(transform(agrupo[13],"@E 999,999,999.99")))
			implinha('			</td>')
			implinha('			<td title="Total a Pagar" >')
			implinha('        		'+alltrim(transform(agrupo[14],"@E 999,999,999.99")))
			implinha('			</td>')
			implinha('    </tr>')   
			
			for x := 1 to len(aitens)
				implinha('    <tr class="itens grpger it'+alltrim(str(ngrupo))+'">')
				implinha('			<td title="Fornecedor" colspan="2">')
				implinha('        		'+aitens[x][1]+"/"+aitens[x][2]+" - "+alltrim(aitens[x][3]))
				implinha('			</td>')
				implinha('			<td title="Numero" >')
				implinha('        		'+aitens[x][4])
				implinha('			</td>')
				implinha('			<td title="Parcela" >')
				implinha('        		'+aitens[x][5])
				implinha('			</td>')
				implinha('			<td title="Vencimento" >')
				implinha('        		'+aitens[x][6])
				implinha('			</td>')
				implinha('			<td title="Data da baixa" >')
				implinha('        		'+iif(aitens[x][7]!="  /  /    ",aitens[x][7],"&nbsp;"))
				implinha('			</td>')
				implinha('			<td title="Valor" >')
				implinha('        		'+alltrim(transform(aitens[x][8],"@E 999,999,999.99")))
				implinha('			</td>')
				implinha('			<td title="Valor Pago" >')
				implinha('        		'+alltrim(transform(aitens[x][9],"@E 999,999,999.99")))
				implinha('			</td>')
				implinha('			<td title="Valor a Pagar" >')
				implinha('        		'+alltrim(transform(aitens[x][10],"@E 999,999,999.99")))
				implinha('			</td>')
				implinha('			<td title="Juros" >')
				implinha('        		'+alltrim(transform(aitens[x][11],"@E 999,999,999.99")))
				implinha('			</td>')
				implinha('			<td title="Juros Pagos" >')
				implinha('        		'+alltrim(transform(aitens[x][12],"@E 999,999,999.99")))
				implinha('			</td>')
				implinha('			<td title="Juros a Pagar" >')
				implinha('        		'+alltrim(transform(aitens[x][13],"@E 999,999,999.99")))
				implinha('			</td>')
				implinha('			<td title="Total a Pagar" >')
				implinha('        		'+alltrim(transform(aitens[x][14],"@E 999,999,999.99")))
				implinha('			</td>')
				implinha('    </tr> ')
			next
			
		end
	endif             
	tmp1->(dbclosearea())
	
	/*                    
	implinha('	<tr class="grupo" >')
	implinha('    	<td')
	implinha('        	&nbsp;')
	implinha('        </td>')
	implinha('    	<td>')
	implinha('        	TOTAIS PP')
	implinha('        </td>')
	implinha('       	<td title="PP - Quantidade Total">')
	implinha('        	'+alltrim(transform(round(atotpp[1],2),"@E 999,999,999.99")))
	implinha('        </td>')
	implinha('        <td>') 
	implinha('        	'+cums)
	implinha('        </td>')
	implinha('        <td>')
	implinha('        	&nbsp;')
	implinha('        </td>')
	implinha('       	<td title="PP - Valor Total">')
	implinha('        	'+alltrim(transform(round(atotpp[2],2),"@E 999,999,999.99")))
	implinha('        </td>')
	implinha('        <td title="PP - Bonifica??o Total">')
	implinha('        	'+alltrim(transform(round(atotpp[3],2),"@E 999,999,999.99")))
	implinha('        </td>')
	implinha('        <td title="PP - Peso">')
	implinha('        	'+alltrim(transform(round(atotpp[4],2),"@E 999,999,999.99")))
	implinha('        </td>')
	implinha('        <td title="PP - Preco M?dio">')
	implinha('        	'+alltrim(transform(round(atotpp[2]/atotpp[4],3),"@E 999,999,999.999")))
	implinha('        </td>')
	implinha('        <td title="PP - Preco M?dio Sem IPI">')
	implinha('        	'+alltrim(transform(round((atotpp[2]-atotpp[5])/atotpp[4],3),"@E 999,999,999.999")))
	implinha('        </td>')
	implinha('        <td title="PP - Preco M?dio Sem Impostos">')
	implinha('        	'+alltrim(transform(round((atotpp[2]-atotpp[5]-atotpp[6])/atotpp[4],3),"@E 999,999,999.999")))
	implinha('        </td>')
	implinha('    </tr>')
	*/
	
	implinha('</table>')
	implinha('</div>')
	implinha('</body>')
	implinha('</html>')                       	    		
	
	fclose(_nhandle) 
	if lhainfo		
		if getremotetype() == 5                             
			if cpys2tw(_cdirdocs+"\"+_carq,.t.) == 0
				msginfo("Relatsrio gerado com sucesso!")	
			else 
				alert("Ocorreu erro ao importar o arquivo do servidor!")
			endif
		else
			_cpathtmp:=alltrim(gettemppath())
			if file(_cpathtmp+_carq)
				ferase(_cpathtmp+_carq)
			endif
			if cpys2t(_cdirdocs+"\"+_carq,_cpathtmp,.t.)	
				shellexecute("open",_carq,"",_cpathtmp,1)
				msginfo("Relatsrio gerado com sucesso!")   
			else 				
				alert("Ocorreu erro ao criar o arquivo na maquina local!")
			endif
		endif
	else 	
   		if getremotetype() != 5
			_cpathtmp:=alltrim(gettemppath())
	   		if file(_cpathtmp+_carq)
				ferase(_cpathtmp+_carq)
			endif
   		endif
   		msginfo("N?o ha dados para os parﬂmetros informados!")
	endif	
	
return    

//???????????????????????????????????????????????????????????????????????????
static function para_texto(xtoconv)
//???????????????????????????????????????????????????????????????????????????
	if valtype(xtoconv) == "U"			
		cnewtxt	:= ""
	elseif valtype(xtoconv) == "D"			
		cnewtxt	:= substr(dtos(xtoconv),7,2)+"/"+substr(dtos(xtoconv),5,2)+"/"+substr(dtos(xtoconv),1,4)
	elseif valtype(xtoconv) == "N"			
		cnewtxt	:= alltrim(str(xtoconv))
	else
		cnewtxt	:= alltrim(xtoconv)
	endif	
return cnewtxt
 
//???????????????????????????????????????????????????????????????????????????
static function implinha(clinha)
//???????????????????????????????????????????????????????????????????????????
	fwrite(_nhandle,clinha+chr(13)+chr(10))
return

//???????????????????????????????????????????????????????????????????????????
Static Function geratmp1()
//???????????????????????????????????????????????????????????????????????????

	cquery := " "
	cquery += "SELECT * "
	cquery += "FROM " + retsqlname("CNC")+" CNC "
	cquery += "INNER JOIN " + retsqlname("CN9") + " CN9 ON  CNC_FILIAL = CN9_FILIAL AND CNC_NUMERO = CN9_NUMERO AND CN9.D_E_L_E_T_ <> '*' " 
	cquery += "INNER JOIN " + retsqlname("SA1") + " SA1 ON  CNC_CLIENT = A1_COD AND CNC_LOJACL = A1_LOJA AND SA1.D_E_L_E_T_ <> '*'"
	cquery += "WHERE CNC.D_E_L_E_T_ <> '*' "
	cquery += "AND CNC_NUMERO = '" + CNC->CNC_NUMERO + "' " 
 
	cquery	:= changequery(cquery) 
	tcquery cquery new alias "TMP1"	 		

return          

//??????????????????????????????????????????????????????????????????????????????????????
Static Function GeraX1()
//??????????????????????????????????????????????????????????????????????????????????????
	Local _sAlias
	local j := 1
	local i := 1
	_sAlias := Alias()
	aRegs	:= {}
	dbSelectArea ("SX1")
	dbSetOrder (1)
	
	AADD(aRegs,{cperg,"01","Emissao De?"		,"","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"02","Emissao Ate?"		,"","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"03","Vencimento De?"		,"","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"04","Vencimento Ate?"	,"","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"05","Forncedor?"			,"","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})
	
	for i:=1 to len(aRegs)
		if !dbseek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			for j := 1 to fcount()
				if j <= len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				endif
			next
			MsUnlock()
		endif
	next
	dbSelectArea(_sAlias)
Return