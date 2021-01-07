User Function MA960DUP()
Local cAlias    := "SF6"
Local cRazSoc   := ""
Local cNatureza := ""
Local cParcel	:= Space(TamSX3("E2_PARCELA")[1])
Local cPref     := "ICM"
Local cTipo     := "TX " //Natureza
do case    
	case F6_TIPOIMP=="1"   //icms     
		cNatureza := "2.03.010"   
	case F6_TIPOIMP=="2"        
		cNatureza := "ISS"   
	case F6_TIPOIMP=="3"  //icms st      
		cNatureza := "2.03.011"  
	case F6_TIPOIMP=="4"        
		cNatureza := "FUNRURAL"   
	case F6_TIPOIMP=="5"        
		cNatureza := "SIMPLES FEDERAL"   
	case F6_TIPOIMP=="6"        
		cNatureza := "FUNDERSUL"   
	case F6_TIPOIMP=="7"     //simplesnacional   
		cNatureza := "2.03.012"   
	case F6_TIPOIMP=="8"        
		cNatureza := "FUST/FUNTTEL"   
	case F6_TIPOIMP=="B"   //difal     
		cNatureza := "2.03.021" 
endcase
//Razão Social
DbSelectArea("SA2")                                            
DbSetOrder(3)                 
If DbSeek(xFilial('SA2')+(cAlias)->F6_CLIFOR+(cAlias)->F6_LOJA)   
	cRazSoc := A2_NREDUZ
Endif
//Verifica se existe a Duplicata no Contas a Pagar
dbSelectArea("SE2")     
dbSetOrder(1)
if dbSeek((cAlias)->F6_FILIAL+cPref+(cAlias)->F6_DOC+cParcel+cTipo+(cAlias)->F6_CLIFOR+(cAlias)->F6_LOJA)   
	//Alert("Documento já Cadastro no Contas a Pagar")   
	return
endif
//Grava Duplicata     2593857         
RecLock("SE2",.T.) 
	E2_FILIAL   := (cAlias)->F6_FILIAL 
	E2_PREFIXO  := cPref
	E2_NUM      := (cAlias)->F6_DOC
	E2_PARCELA  := cParcel
	E2_TIPO     := cTipo
	E2_NATUREZ  := cNatureza
	E2_FORNECE  := (cAlias)->F6_CLIFOR
	E2_LOJA     := (cAlias)->F6_LOJA
	E2_EMISSAO  := (cAlias)->F6_DTARREC
	E2_VENCTO   := (cAlias)->F6_DTVENC
	E2_VALOR    := (cAlias)->F6_VALOR
	E2_NUMBCO   := (cAlias)->F6_BANCO     
	E2_NOMFOR   := cRazSoc
MsUnlock()
Return