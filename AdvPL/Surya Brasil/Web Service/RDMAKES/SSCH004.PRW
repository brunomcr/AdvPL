#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"
#include "APWEBEX.CH" 
#include "ap5mail.ch" 
#include "tbicode.ch"
#INCLUDE "DEFEMPSB.CH"     
#INCLUDE "Rwmake.ch"
#INCLUDE "fivewin.ch"
#define DS_MODALFRAME   128

User Function SSCH004(aParam)
//User Function SSCH004()
local aPed 			:= {}
local cQuery	    := ""
Local _cAlias 		:= ""

Private _cDest	    := ""
Private _cDestFat	:= ""
Private _cCopy	    := ""
Private xEmp 		:= aParam[1] //'03'
Private xFil 		:= aParam[2] //'00'

RPCSetType(3)
If FindFunction('WFPREPENV')
	lAuto := .T.      
	RPCSetType( 3 )						// Não consome licença de uso
	wfPrepENV(xEmp, xFil)	
	//wfPrepENV("03", "00")
Else
	lAuto := .T.
	RPCSetType( 3 )						// Não consome licença de uso
	Prepare Environment Empresa xEmp Filial xFil	
Endif

_cDest	    := GetMV("SB_DESTFTP")
_cDestFat	:= GetMV("SB_DESTFAT")
_cCopy	    := GetMV("SB_COPYFTP")
_cAlias 		:= GetNextAlias()
If Select(_cAlias) >0
	dbSelectArea(_cAlias)
    dbCloseArea()    
EndIf
cQuery := "SELECT * FROM "+RETSQLNAME( "SC5" )+" WHERE C5_NOTA = '' AND C5_LIBEROK = 'S' AND D_E_L_E_T_ = '' AND C5_XEMILOG = '' AND C5_XCANSAI IN ('2','5','6','7','8','9','A')"
//cQuery := "SELECT * FROM "+RETSQLNAME( "SC5" )+" WHERE C5_NOTA = '' AND C5_LIBEROK = 'S' AND D_E_L_E_T_ = '' AND C5_XCANSAI IN ('2','6','7','8','9','A')"      
//cQuery := "SELECT * FROM SC5030 WHERE C5_NUM = '315221' "
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), _cAlias, .F., .T. )

Do While  (_cAlias)->(!EOF())
	ProcEnt((_cAlias)->C5_NUM,(_cAlias)->C5_XCANSAI)
	Conout("SSCH004 - INPUT LOGISTICA: "+DTOC(DDATABASE)+" PED: "+(_cAlias)->C5_NUM)
	
	If Empty(POSICIONE("SC5",1,(_cAlias)->C5_FILIAL+(_cAlias)->C5_NUM,'C5_XEMILOG') )
		(_cAlias)->(DBSKIP())
		loop
	EndIf
	
	//Para não gerar a NF comentar desta linha até a 65.
	If LiberOK( (_cAlias)->C5_NUM) 
	
		If !_GeraNF((_cAlias)->C5_NUM)
				//envEcom1("Erro -Pedido:"+aPed[i]+" não faturado", "Erro no arquivo de retorno","fiscal@suryabrasil.com")
				envEcom1("Erro - Pedido:"+aPed[i]+" não faturado", "Erro no arquivo de retorno",_cDestFat,_cCopy)
		EndIf
		
	EndIf
	(_cAlias)->(DBSKIP())
EndDo

If Select(_cAlias) > 0
	dbSelectArea(_cAlias)
    dbCloseArea()    
EndIf
//Comentar da linha 74 até a 88 para gerar apenas o picking list.
//Inluido para casos em que o pedido seja liberado manualmente
cQuery := "SELECT * FROM "+RETSQLNAME( "SC5" )+" WHERE C5_NOTA = '' AND C5_LIBEROK = 'S' AND D_E_L_E_T_ = '' AND C5_XEMILOG <> '' AND C5_XCANSAI IN ('2','5','6','7','8','9','A')"
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), _cAlias, .F., .T. )

Do While  (_cAlias)->(!EOF())
	
	If LiberOK( (_cAlias)->C5_NUM) 
	
		If !_GeraNF((_cAlias)->C5_NUM)
				//envEcom1("Erro -Pedido:"+aPed[i]+" não faturado", "Erro no arquivo de retorno","fiscal@suryabrasil.com")
				envEcom1("Erro - Pedido:"+aPed[i]+" não faturado", "Erro no arquivo de retorno",_cDestFat,_cCopy)
		EndIf
	EndIf
	
	(_cAlias)->(DBSKIP())
EndDo

If Select(_cAlias) > 0
	dbSelectArea(_cAlias)
    dbCloseArea()    
EndIf

//Pegar apenas o que for E-commerce
Static Function ProcEnt(__numSC5,__cCanalSaida)				
If __cCanalSaida $ '2-5-6-7-8-9-A'
	if LiberOK(__numSC5)
		if RunCont(__numSC5 ) //gera picking
			If !FT2All(,,,,__numSC5)  
				envEcom1(__numSC5, "2Alianca","Erro de Integração com Logistica - SEM CONEXÃO COM FTP",_cDest,_cCopy)
			Endif 
		else
			envEcom1(__numSC5, "2Alianca","Erro na geração do arquivo - PICKING LIST NÃO GERADO",_cDest,_cCopy)
		endif
	else
		envEcom1(__numSC5, "2Alianca"," Picking List não gerado - PEDIDO LIBERADO PARCIAL",_cDest,_cCopy)
	endif
EndIf

Static Function FT2All(cServer, nPorta, cUser, cPass,cPedido)      //chamado na linha 1109
Local cLocal := "\logisticae\Picking\"         
Local cFile 	:= ""  
Local cDirErroY,cDirErroM,cDirErroD,cDirOkY,cDirOkM,cDirOkD := ""
Local lRet := .F.
Default cServer 	:= "187.0.200.180"
Default nPorta 	:= 21//nPorta //21
Default cUser		:= "surya@2aliancas.com.br"
Default cPass	:= "2aliancas!!"

//Default cPedido	:= "309982"                
//aDir := directory(cLocal+"*.txt")
cPed		:= cPedido
cPedido		:= "pl"+ cPedido+".txt"
cFile 		:= cLocal + cPedido   
cDirErro 	:= cLocal+"Erros\"
cDirErroY 	:= cLocal+"Erros\"+ALLTRIM(str(Year(DATE())))
cDirErroM 	:= cLocal+"Erros\"+ALLTRIM(str(Year(DATE())))+"\"+StrZero(Month(DATE()),2) 
cDirErroD 	:= cLocal+"Erros\"+ALLTRIM(str(Year(DATE())))+"\"+StrZero(Month(DATE()),2)+"\"+strzero(day(DATE()),2) 
cDirOk		:= cLocal+"OK\"
cDirOkY  	:= cLocal+"OK\"+ALLTRIM(str(Year(DATE())))
cDirOkM  	:= cLocal+"OK\"+ALLTRIM(str(Year(DATE())))+"\"+StrZero(Month(DATE()),2) 
cDirOkD  	:= cLocal+"OK\"+ALLTRIM(str(Year(DATE())))+"\"+StrZero(Month(DATE()),2)+"\"+strzero(day(DATE()),2)

Private _cAmbAtual := Upper( AllTrim( GetEnvServer() ) )
FTPDisconnect()
If     FTPConnect( cServer, 21, cUser, cPass )
     Conout('FTP conectado!')
     Conout('Diretorio FTP',FTPGetCurDir())
     Conout('FTPDirChange',FTPDirChange('003/'))
     FTPGetCurDir()
     FTPDirChange('003/')
     
	If FTPUpLoad( cFile, cPedido)
		Conout('UpLoad Ok! '+ cPedido)  
		lRet := .T.    
		cDirOK := "\Dossie\"+cPed+"\"
		MakeDir(cDirOk)			
	    __CopyFile(cFile,cDirOK+cPedido)
		conout("PEDIDO: "+cFile+" JA SE ENCONTRA NA BASE...")
		If SC5->(DBSETORDER(1),DBSEEK(XFILIAL("SC5")+Substr(cPedido,3,6)))
		//if found()
			SC5->(RecLock("SC5",.F.))
			SC5->C5_XEMILOG := date()
			SC5->C5_XSTATUS :=  "1"
			SC5->(MsUnlock())
		EndIf
		//Ferase(cFile)
	Else
	    Conout('Falha UpLoad!'+cPedido)    
	    MakeDir(cDirErro)
	    MakeDir(cDirErroY)
	    MakeDir(cDirErroM)
	    MakeDir(cDirErroD)        
	     __CopyFile(cFile,cDirErroD+"\"+cPedido)
		conout("PEDIDO: "+cFile+" JA SE ENCONTRA NA BASE...")
		//Ferase(cFile)
	EndIf
     FTPDisconnect()
Else
     Conout('Falha Conexao!')
EndIf
Return lRet            

Static Function envEcom1(cPedido, cLogitica,cAssunto, cDest, cCopy)

			  oWorkFLW			 	 := TWEnviaEmail():New()	
			  oWorkFLW:cConta        := "suryabrasil@shared.mandic.net.br"					    
			  oWorkFLW:cSenha        := "75XQF9qg"						
			  oWorkFLW:cDestinatario := cDest
			  oWorkFLW:cCopia		 :=  cCopy
			  oWorkFLW:cServerSMTP   := "sharedrelay-cluster.mandic.net.br"						
			  oWorkFLW:cAssunto      := cAssunto
			  oWorkFLW:cDiretorio	 := "\workflow\html\AVECOM01.HTM"
			  
			  oWorkFLW:aDadosHTML   := { { '##cPedido##', cPedido} ,;
			  							 			   	  { '##cLogistica##'	   , cLogitica	} }  
			  oWorkFLW:EnviaEmail()
			  Conout('E-mail de erro e-commercel enviado com sucesso')  

Return      

STATIC FUNCTION LiberOK(cPedido)
Local lRet 				:= .T.
Local cQuery 		:= ""   
Local _cAlias 		:= GetNextAlias()
cQuery := "SELECT * FROM "+RETSQLNAME( "SC9" )+" WHERE C9_NFISCAL = '' AND C9_BLEST = '02' AND D_E_L_E_T_ = '' AND C9_PEDIDO = '"+cPedido+"'"      
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), _cAlias, .F., .T. )
if  (_cAlias)->(!EOF())
	lRet := .F.
endif
If Select(_cAlias) >0
	dbSelectArea(_cAlias)
    dbCloseArea()    
EndIf
Return lRet               


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

cCaminho := "\Logisticae\Picking\"
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
				nCont1++				
		   	endif
			SC9->(DbSkip())	
		ENDDO  
		if nCont == nCont1 
			AutoGrLog("Pedido não gerado: "+SC9->C9_PEDIDO +". Motivo: Pedido inteiro bloqueado por estoque")     
			lLote := .F.		
		endif
	ENDIF
	//lLote := .T.	
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
	/*SC5->(RecLock("SC5",.F.))
		SC5->C5_XEMILOG := date()
		SC5->C5_XSTATUS :=  "1"
		SC5->(MsUnlock())
	SC5->(MsUnlock())*/
endif	
Return lLote

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


//GERA NF
Static Function _GeraNF(cPedido)     
local lRet := .T.   
local cSerie := "003"    
Private aPvlNfs := {}
DbSelectArea("SC9")
SC9->(DbSetOrder(1))
DbSelectArea("SC6")
SC6->(DbSetOrder(1))
DbSelectArea("SE4")
SE4->(DbSetOrder(1))
DbSelectArea("SB1")
SB1->(DbSetOrder(1))
DbSelectArea("SB2")
SB2->(DbSetOrder(1))   
DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(Dbseek(xFilial("SC5")+cPedido))  
if ALLTRIM(SC5->C5_NOTA) <> ''
	Return .F.
endif 
//if !LiberOK(cPedido)     
//	conout("PEDIDO "+cPedido+"NAO LIBERADO POR COMPLETO")
//	Return .F.
//endif
If SC9->(DbSeek(xFilial("SC9")+SC5->C5_NUM))
	While SC9->(!Eof()) .AND. SC9->C9_PEDIDO == SC5->C5_NUM   
		if Alltrim(SC9->C9_BLEST) <> ''
			SC9->(DbSkip())
			  loop
		endif
		SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
		SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
		SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
		SB2->(DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL))
		SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))
		
		aAdd(aPvlNfs,{;
		SC9->C9_PEDIDO,;
		SC9->C9_ITEM,;
		SC9->C9_SEQUEN,;
		SC9->C9_QTDLIB,;
		SC9->C9_PRCVEN,;
		SC9->C9_PRODUTO,;
		.F.,;
		SC9->(RECNO()),;
		SC5->(RECNO()),;
		SC6->(RECNO()),;
		SE4->(RECNO()),;
		SB1->(RECNO()),;
		SB2->(RECNO()),;
		SF4->(RECNO());
		})
		SC9->(DbSkip())
	EndDo
EndIf
Begin Transaction
	//Gera documento de saida
	Pergunte("MT460A",.F.)
	cNFSaida := MaPvlNfs(aPvlNfs, cSerie, .F. , .F. , .F. , .F. , .F., 0, 0, .F., .F.)
	If Empty(cNFSaida)
		DisarmTransaction()
		conout("Não foi possível gerar a Nota fiscal")    
		lRet := .F.
	Else
		 SF2->(DBSetOrder(1))
		 SF2->(DbSeek(xFilial("SF2")+cNFSaida+cSerie)) 
		 RecLock("SF2")
		 SF2->F2_XIMP := "F"
		 SF2->(MsUnlock())
	Endif                                                           
End Transaction	
Return lRet

