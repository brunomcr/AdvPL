#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Rwmake.ch" 
#Include "PRCONST.CH"

#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_LOCALHARD )  //( GETF_RETDIRECTORY + GETF_ONLYSERVER )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.  ³ SBP0004 º Uso ³ Surya Brasil º Modulo ³ SIGAFAT º Data ³ 08/05/17 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³ Rotina de para gerar arquivo EDI para pickList					  º±±
±±º       ³                                                                   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor ³ Caio de Paula             º Contato ³(11) 98346-3154              º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SBPEST001()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
local aSays := {} 
local aButtons := {}  
Local nOpca    :=  0
Private cTitulo:= "Geração de Arquivo Integrador"  
Private cSepara  := SuperGetMv("SB_SEPARQ",.F.,";")
Private	cPerg := "SBPEST001"

AjustaSx1(cPerg)

//If ! Pergunte(cPerg,.T.)
//	Return .T.
//Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha a tela do programa                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aSays,"Este programa tem o objetivo Gerar os Arquivos de Integração.")
AADD(aSays,"Tipo de Arquivo: PICKLIST") 


AADD(aButtons, { 5,.T.,{|| pergunte(cPerg,.T.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cTitulo, aSays, aButtons )

If nOpca == 1
	cEol	:= "CHR(13)+CHR(10)"
	
	If Empty(cEol)
		cEol := CHR(13)+CHR(10)
	Else
		cEol := Trim(cEol)
		cEol := &cEol
	Endif
	
	
	Processa({|| ProcessaI() },"Processando...")
	
EndIf

Return()
Static Function ProcessaI()
Local nTamLin, cCpo
Local cLin     := ""
Local cArqTxt1 := ""
Local cArqTxt := ""
Local nHdl    
Local lNomeCli := .F.
Local cSepara  := SuperGetMv("SB_SEPARQ",.F.,";")
Local aLinha   := {}
Local cPedido, cBloqueio, cLoja
Local lRet		:= .T.
Local lRet2		:= .T.
local diferenca := 0
local nContador	
local nCont
local cCliente := ""
local cPedido := "" 
local _cFilial	:= ""
local aSays := {} 
local aButtons := {}  
Local nOpca    :=  0

Private cTitulo:= "Geração de Arquivo Integrador"





//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha a tela do programa                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cEol	:= "CHR(13)+CHR(10)"
	
	If Empty(cEol)
		cEol := CHR(13)+CHR(10)
	Else
		cEol := Trim(cEol)
		cEol := &cEol
	Endif
	DbSelectArea("SC5")
	DbSetOrder(1)
DbSelectArea("SC5")
DbSetOrder(1)
if Dbseek(xFilial("SC5")+MV_PAR01)
	While !EOF() .And. SC5->C5_NUM <= MV_PAR02
		if SC5->C5_EMISSAO < MV_PAR03     
			SC5->(DbSkip())
			loop
		endif  
		if SC5->C5_EMISSAO > MV_PAR04   
			SC5->(DbSkip())  
			loop
		endif
		if alltrim(SC5->C5_NOTA) <> ''   
			SC5->(DbSkip())  
			loop
		endif
		SC9->(dbsetOrder(1))
		if ! SC9->(dbseek(SC5->C5_FILIAL+SC5->C5_NUM))
			SC5->(DbSkip())  
			loop 	
		endif   		
		cPedido  := SC5->C5_NUM
		lRet :=	MsAguarde({|| RunCont(cPedido)},"Criando arquivo integrador PickList...")     
		if !lRet
			lRet2 := lRet
		endif
	SC5->(DbSkip())
	enddo   
endif    
if !lRet2
	MostraErro()
endif
Return

Static Function RunCont(cPedido)

Local _lInicio	:= .T.
Local _lFim		:= .F.
local cArqTxt1 	:=  MV_PAR04
local cLin		:= ""
local n			:= 0 
local aPgto 	:= {}     
Local cCaminho	:= SuperGetMv("SB_CENDLOG",.t., "C:\Users\Admin\Desktop\Saida\")   
local lLote		:= .T.  
local nItem		:= 0 
local nAt		:= 0

cCaminho := "\Logistica\Picking\"
cCaminho := iif(right(cCaminho,1) == "\",cCaminho,cCaminho+"\")  

If EmpTy(ALLTRIM(cCaminho))  
	conout("Arquivo de integração Logistica nao gerado! Caminho de Destino nao identificado")
	Return
EndIf

DbSelectArea("SC5")
DbSetOrder(1)
if Dbseek(xFilial("SC5")+cPedido)
	_lInicio := .T.
	_lFim    := .F.
	nQtdNf := 0   	
	
	if Empty(alltrim(SC5->C5_XMAGCOD))
		cArqTxt := cCaminho  
		cArqTxt := ALLTRIM(cArqTxt) +"PL"+ALLTRIM(SC5->C5_NUM)+".txt"   
	else
		cCaminho := "\Logisticae\Picking\"
		cCaminho := iif(right(cCaminho,1) == "\",cCaminho,cCaminho+"\")  
		cArqTxt := cCaminho 
		cArqTxt := ALLTRIM(cArqTxt) +"PL"+ALLTRIM(SC5->C5_NUM)+".txt"   	
	endif
	SC9->(dbsetOrder(1))  
	nCont  := 0
	nCont1 :=0
	if SC9->(dbseek(SC5->C5_FILIAL+SC5->C5_NUM))  
		do while !EOF() .And. ALLTRIM(SC9->C9_PEDIDO) == ALLTRIM(cPedido) .And. SC9->C9_FILIAL == cFilAnt//itens 
			nCont++
			if ALLTRIM(SC9->C9_BLEST) ==  "" 
				if alltrim(SC9->C9_LOTECTL)== '' .And. Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_RASTRO") = 'L' 
					lLote := .F.
		   			AutoGrLog("Pedido não gerado: "+SC9->C9_PEDIDO+". Motivo: Sem Lote em algum item") 				
					exit				
			   	endif 	
				if alltrim(SC9->C9_BLCRED) <> ''
			   		lLote := .F.                
		   			AutoGrLog("Pedido não gerado: "+SC9->C9_PEDIDO +". Motivo: Pedido com Bloqueio de Credito") 				
					exit
				endif 
			else
				If SC5->C5_XCANSAI $ '2-5-6-7-8-9-A'
					exit
				endif
				nCont1++				
		   	endif
			SC9->(DbSkip())	
		ENDDO  
		if nCont == nCont1 
			AutoGrLog("Pedido não gerado: "+SC9->C9_PEDIDO +". Motivo: Pedido inteiro bloqueado por estoque")     
			lLote := .F.		
		endif
	ENDIF
	if !lLote
		Mostraerro()
		return lLote
	endif
	nHdl 	:= fCreate(cArqTxt)
	If nHdl == -1
	    conout("O arquivo de nome nao pode ser executado! Verifique os parametros.","Atencao!")
	    Return
	Endif  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabeçalho fornecido pelo layout L01 2Alianca                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLin := "02" //TIPO REGISTRO
	
	If xFilial("SC5") == "01"
		cLin += "SURYARJ"+space(8)//CODIGO DEPOSITANTE
	Else
		cLin += "SURYASP"+space(8)//CODIGO DEPOSITANTE
    EndIf
   
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))+;
			space(15-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))))//CNPJ Cliente
   
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))+;
			space(15-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))))//CNPJ Cliente
	
	clin += substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_NOME")),1,40)+;
			space(40-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_NOME")),1,40)))) //nome cliente 
	if ALLTRIM(SC5->C5_XMAGCOD) = ''		
		nAt := At(",",Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END"))
		IIF(nAt == 0,nAt:=40,nAt:=nAt)		
		clin += Substr(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),1,nAt-1)+;
				space(40-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),1,nAt-1)))),1,40)  //end cliente     
		
		clin += Alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),nAt+1,10))+;
				space(10-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),nAt+1,10))))  //numero cliente   
	else
		cLin += Substr(Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END"))+" "+;
				Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_COMPLEM"),1,50)
	endif
	clin += alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_BAIRRO")),1,25))+;
			space(25-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_BAIRRO")),1,25))))     //Bairro
	
	clin += alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_MUN")),1,25))+;
			space(25-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_MUN")),1,25))))     //   Cidade
			
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_EST")) //estado
	
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CEP") ) +;
			space(9-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CEP")))) //CEP 
			
   	cLin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_COMPLEM") ) +;
			space(50-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_COMPLEM")))) // complemento
	
	cLin += space(15)//Inscrição estadual do cliente
	
	if ALLTRIM(SC5->C5_XMAGCOD) = ''
		cLin += 'PED' + space(2) // tipo documento       
	else
		cLin += 'PEX' + space(2) // tipo documento
	endif
	
	cLin += '1    '//serie
	
	cLin += ALLTRIM(SC5->C5_NUM)+space(4) //num doc    
	
	If xFilial("SC5") == "01"
		cLin += "0000000003" //codigo estabelecimento
	Else
		cLin += "0000000004" //codigo estabelecimento
    EndIf		  
	
	clin += Day2Str(SC5->C5_EMISSAO)+Month2Str(SC5->C5_EMISSAO)+Year2Str(SC5->C5_EMISSAO)  //emissao do documento
	
	clin += ALLTRIM(POSICIONE("SC6",1,SC5->C5_FILIAL+SC5->C5_NUM,"C6_CF"))+;
			SPACE(6-LEN(ALLTRIM(POSICIONE("SC6",1,SC5->C5_FILIAL+SC5->C5_NUM,"C6_CF")))) //natureza 6caractter
	                                                                                                            
	cLin += strzero(val(ALLTRIM(STRTRAN(Transform(ValTot(SC5->C5_NUM),"@E 9999999999.9999"),".",""))),20)// TOTAL DOS DOCUMENTOS
	
	cLin += replicate('0',20)// TOTAL DOS ITENS DO DOCUMENTO    
	
	cLin += replicate('0',20)// val icms
	
	cLin += replicate('0',20)// val st
	
	cLin += replicate('0',20)// val ip
	
	cLin += replicate('0',20)// base calc ICM
	
	cLin += replicate('0',20)// base calc st
	
	cLin += replicate('0',20)// base calc ipi
	
	cLin += replicate('0',20)// valor desconto
	
	cLin += replicate('0',20)// val acrescimo
	
	cLin += replicate('0',10)//  tipo frete
	
	cLin += alltrim(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP, "A4_CGC"))+;
			space(15-len(alltrim(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP, "A4_CGC"))))  //CNPJ Transp
			
	clin += strzero(val(ALLTRIM(STRTRAN(Transform(SC5->C5_PESOL,"@E 9999999999.9999"),".",""))),10)      // peso liquido        
	                                                                                                                                          
	clin += strzero(val(ALLTRIM(STRTRAN(Transform(SC5->C5_PBRUTO,"@E 9999999999.9999"),".",""))),10)      // peso liquido        C5_ESPECI1
	
	clin += strzero(val(ALLTRIM(Transform(SC5->C5_VOLUME1,"@E 9999999999"))),10)
			// 
	
	cLin += replicate("0",5)       //status do documento
	
	cLin += space(13) // document status hour
	
	cLin += Space(25) //replicador de documentos
	
	cLin += Space(25) //Informacao Adicional 1

	cLin += Space(25) //Informacao Adicional 2

	cLin += Space(25) //Informacao Adicional 3
	
	cLin += Space(100) //Observação do Documento
	
	cLin += replicate("0",5) //numero de linhas do documento
	
	cLin += replicate("0",8) // total de unidades do documento
	
	clin += CHR(13)+CHR(10)
	If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
		If !conout("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Return()
		EndIf
	EndIf

	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ITENS L02 2Alianca                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
	
	DbSelectArea("SC9")
	DbSetOrder(1)
	if Dbseek(xFilial("SC9")+cPedido)
		do while !EOF() .And. ALLTRIM(SC9->C9_PEDIDO) == ALLTRIM(cPedido) .And. SC9->C9_FILIAL == cFilAnt//itens     
			if alltrim(SC9->C9_BLEST) <> ""
				SC9->(DbSkip())
				loop
			endif
			nItem++
			n++ 
			cLin := "09"
			clin += strzero(nItem,3)    //item do documento
			clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))+;
				space(15-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))))//CNPJ Cliente
			if ALLTRIM(SC5->C5_XMAGCOD) = ''
				cLin += 'PED' + space(2) // tipo documento       
			else
				cLin += 'PEX' + space(2) // tipo documento
			endif
 			cLin += '11111'//serie
			cLin += ALLTRIM(SC5->C5_NUM)+space(4) //num doc    
   
			If xFilial("SC9") == "01"
				cLin += "SURYARJ"+space(8) //CODIGO DEPOSITANTE 
				cLin += "0000000003"       //codigo estabelecimento
			Else
				cLin += "SURYASP"+space(8) //CODIGO DEPOSITANTE 
				cLin += "0000000004"       //codigo estabelecimento
			EndIf
			
			cLin += ALLTRIM(SC9->C9_PRODUTO)+;
				space(15-len(alltrim(SC9->C9_PRODUTO)))//PRODUTO	
			cLin += strzero(val(ALLTRIM(STRTRAN(Transform(SC9->C9_QTDLIB,"@E 9999999999.9999"),".",""))),20) //qtd	
			clin += alltrim(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_UM"))+SPACE(3) // UM     
			cLin += replicate("0",20)  //fator segunda unidade de medida  
			cLin += '3'+space(9) //tipo logistico 
		   //	if Empty(alltrim(SC5->C5_ECVINCU))
			cLin += ALLTRIM(SC9->C9_LOTECTL)+;
						space(15-len(alltrim(SC9->C9_LOTECTL))) //dado logistico
		  /*	else 
				if Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_RASTRO") = 'L' 
					cLin += ALLTRIM(SC9->C9_LOTECTL)+"E"
				else
					cLin += ALLTRIM(SC9->C9_LOTECTL)
				endif
			endif   */		
			    
			cLin += strzero(val(ALLTRIM(STRTRAN(Transform(SC9->C9_PRCVEN,"@E 9999999999.9999"),",",""))),20) // valor item
			cLin += replicate("0",20) // aliq icm  
			cLin += replicate("0",20) // aliq ipi
			cLin += replicate("0",20) // aliq ST
			cLin += replicate("0",20) // fator base icm
			cLin += replicate("0",20) // aliq ipi reduz
			cLin += replicate("0",20) // fator base ipi
			cLin += replicate("0",20) // qtd atendida do item após a separação
			cLin += space(25)   // info 1
			clin += alltrim(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_CODBAR")) +;
					 space(25-len(alltrim(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_CODBAR"))))      // info 2
			cLin += space(25)   // info 3
			
			cLin += space(5)// classe do Produto
			cLin += CHR(13)+CHR(10)           
				If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
				If !conout("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Return()
				EndIf
			EndIf
		SC9->(DbSkip())
		enddo
	endif
	           
	//CADASTRO EMPRESA
	cLin := "16"
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))+;
			space(15-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))))//CNPJ Cliente     
			
	clin += substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_NOME")),1,40)+;
			space(40-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_NOME")),1,40)))) //nome cliente 
			
	nAt := At(",",Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END"))		
	clin += Substr(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),1,nAt-1)+;
			space(40-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),1,nAt-1)))),1,40)  //end cliente
			
	clin += Alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),nAt+1,10))+;
		space(10-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),nAt+1,10))))  //numero cliente  
		
	clin += alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_BAIRRO")),1,25))+;
			space(25-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_BAIRRO")),1,25))))     //Bairro
			
	clin += alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_MUN")),1,25))+;
			space(25-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_MUN")),1,25))))     //   Cidade
			
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_EST")) //estado
	
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CEP") ) +;
			space(9-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CEP")))) //CEP 
	cLin += space(50) // complemento
	
	cLin += space(15)//Inscrição estadual do cliente
	
	cLin += space(10) // tipo empresa   
	
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_PESSOA")) //fisica ou juridica  
	
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))+;
			space(15-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))))//CNPJ Cliente 
				  
	cLin += space(25)   // info 1
	cLin += space(25)   // info 2
	cLin += space(25)   // info 3  
	cLin += CHR(13)+CHR(10) 			
	If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
		If !conout("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Return()
		EndIf
	EndIf		
	fClose(nHdl)  
	SC5->(RecLock("SC5",.F.))
		SC5->C5_XEMILOG := date()
		SC5->C5_XSTATUS := "1"
		SC5->C5_XDESCST := "Picking Enviado"
	SC5->(MsUnlock())
endif		
Return lLote  


Static Function TpCond(cCond, nValor)
local cTipo
local aPgt := condicao(nValor,cCond,, DDATABASE)  

do case 
	case len(aPgt) == 1
		cTipo := "3"
	otherwise
		cTipo := "21"
endcase	
return cTipo     

Static Function AjustaSx1(cPerg)
PutSX1(cPerg,"01"   ,"Do Pedido ?"		,"Da NF ?"	 	,"Da NF ?"	    ,"mv_ch1"	,"C"	,9		,0		,0		,"G","","  ","","","mv_par01","","","","","","","","","","","","","","","","",{"Informe o numero do pedido de","",""},{},{})
PutSX1(cPerg,"02"   ,"Ate o Pedido ?"		,"Ate NF ?"	 	,"Ate NF ?"		,"mv_ch2"	,"C"    ,9		,0		,0		,"G","","  ","","","mv_par02","","","","","","","","","","","","","","","","",{"Informe o numero do pedido ate","",""},{},{})
PutSX1(cPerg,"03"   ,"Emissao Inicial"	,"Emissao Inicial"	,"Emissao Inicial"	,"mv_ch3","D",08,0,0,"G","","  ","","","mv_par03","","","","","","","","","","","","","","","","",{"","",""},{},{})
PutSx1(cPerg,"04"	,"Emissao Final"	,"Emissao Final"    ,"Emissao Final"	,"mv_ch4","D",08,0,0,"G","","  ","","","mv_par04","","",  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,{"","",""},{},{})
Return


Static Function ValTot(cPedido)    
local nTot := 0
DbSelectArea("SC9")
DbSetOrder(1)
if Dbseek(xFilial("SC9")+cPedido)
	do while !EOF() .And. ALLTRIM(SC9->C9_PEDIDO) == ALLTRIM(cPedido) .And. SC9->C9_FILIAL == cFilAnt//itens     
		if alltrim(SC9->C9_BLEST) <> ""
			SC9->(DbSkip())
			loop
		endif
		if alltrim(SC9->C9_LOTECTL) == ""
			SC9->(DbSkip())
			loop
		endif
		if alltrim(SC9->C9_NFISCAL) <> ""
			SC9->(DbSkip())
			loop
		endif
		nTot += (SC9->C9_QTDLIB*SC9->C9_PRCVEN)
	SC9->(DbSkip())
	enddo
endif 
rETURN nTot