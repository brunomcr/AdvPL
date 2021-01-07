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

// Fun��o de agendamento para fazer o download do arquivo RNC, importar no sistema e gerar a NF
User Function SSCH001(aparam)
//User Function SSCH001()
local aPed := {}
local _cDest	    := ""
local _cDestFat	    := ""
local _cCopy	    := ""

Private xEmp 		:= aParam[1]
Private xFil 		:= aParam[2]

RPCSetType(3)
If FindFunction('WFPREPENV')
	lAuto := .T.      
	RPCSetType( 3 )						// N�o consome licensa de uso
	wfPrepENV(xEmp, xFil)	
	//wfPrepENV("03", "00")
Else
	lAuto := .T.
	RPCSetType( 3 )						// N�o consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil	
Endif

_cDest	    := GetMV("SB_DESTFTP")
_cDestFat	:= GetMV("SB_DESTFAT")
_cCopy	    := GetMV("SB_COPYFTP")
//DbSelectArea("SC5")  
//_GeraNF("308707") 
//Return
//if !FTR2All()  
	//envEcom1("Erro - Download Arquivo FTP", "Erro no arquivo de retorno","logistica@suryabrasil.com")	
	//envEcom1("Erro - Download Arquivo FTP", "Erro no arquivo de retorno",_cDest,_cCopy)
//else
	FTR2All() //Download Arquivo
	ImpRNC(@aPed) //Libera��o Pedido
	/*For i= 1 to len(aPed)
		if !_GeraNF(aPed[i])
			//envEcom1("Erro -Pedido:"+aPed[i]+" n�o faturado", "Erro no arquivo de retorno","fiscal@suryabrasil.com")
			envEcom1("Erro - Pedido:"+aPed[i]+" n�o faturado", "Erro no arquivo de retorno",_cDestFat,_cCopy)
		endif
	next*/			
//endif
Return


Static Function FTR2All()
Local cLocal 	:= "\logistica\rnc\"
Local cFile 	:= ""  
Local lRet 		:= .T.
Local cServer 	:= "187.0.200.180"
Local nPorta 	:= 21//nPorta //21
Local cUser		:= "surya@2aliancas.com.br"
Local cPass		:= "2aliancas!!"
Local aDir		:= {}


Private _cAmbAtual := Upper( AllTrim( GetEnvServer() ) )
//FTPDisconnect()
If	FTPConnect( cServer, 21, cUser, cPass )
    Conout('FTP conectado!')
    Conout('Diretorio FTP',FTPGetCurDir())
    Conout('FTPDirChange',FTPDirChange('006/PROCESSADOS'))
    FTPGetCurDir()
    FTPDirChange('006/PROCESSADOS')
    aDir	:= FTPDIRECTORY( "*.txt", )    
    For i := 1 to Len(aDir) 
		If !FTPDOWNLOAD(cLocal+aDir[i][1], aDir[i][1]) 
	    	Conout("Problemas ao copiar arquivo"+ aDir[i][1] ) 
	    	lRet := .F.
        EndIf
        If !FTPERASE(aDir[i][1])
        	Conout("Problemas ao apagar o arquivo" + aDir[i][1] )  
        	lRet := .F.
        EndIf
	Next
	
	FTPDirChange('006/PROCESSADOS/Importados')
	//aDirCopy := FTPDIRECTORY( "*.txt", )
	aRnc := Directory(cLocal+"*.txt",)
	/*
    For i := 1 to Len(aRnc)
		If !FTPUPLOAD(cLocal+aRnc[i][1], aRnc[i][1]) 
	    	conout("Problemas ao copiar arquivo" ) 
	    	lRet := .F.
        EndIf
	Next
	*/
     FTPDisconnect()
Else
     Conout('Falha Conexao!')
     lRet := .F.
EndIf
Return lRet 

Static Function envEcom1(cAssunto, cMensagem, cDest, cCopy)

			  oWorkFLW			 	 := TWEnviaEmail():New()	
			  oWorkFLW:cConta        := "suryabrasil@shared.mandic.net.br"					    
			  oWorkFLW:cSenha        := "75XQF9qg"						
			  oWorkFLW:cDestinatario := cDest
			  oWorkFLW:cCopia		 := cCopy
			  oWorkFLW:cServerSMTP   := "sharedrelay-cluster.mandic.net.br"						
			 
			  oWorkFLW:cAssunto      := cAssunto
			  oWorkFLW:cMensagem	 := cMensagem
			  
			  oWorkFLW:EnviaEmail()
			  Conout('E-mail de erro e-commerce enviado com sucesso')  

Return

Static Function ImpRNC(aPed)
local aArq		:= {}
local cDirXml	:= ''        
local lRet := .T.
Local cDirXml := "\logistica\rnc\"
aArq := Directory(cDirXml+"*.txt")
for i= 1 to len(aArq)
	cXMLFile := cDirXml+aArq[i][1]
	lRet :=	ImpSC5(cXMLFile,@aped)           
next
Return lRet

Static FuncTion ImpSC5(cArq,aped)
Local aSays := {}
Local aButtons:= {}
Local nTamPrd	:= TamSX3("B1_COD")[1]
local cPedido	:= ""
local nVolume	:= 0
local nPeso		:= 0   
local nPesoB	:= 0
local nHandle := 0    
local dSep 		:= CTOD("  /  /  ")                                                                 
local lRet		:= .T.
Private cArqTxt 	:= cArq
Private cDirOk	:= "\Dossie"
Private aTmpDados		:= {}
Private aDados 		:= {}
Private nDados		:= 0
Private aInfo			:= {}
Private xPos			:= ""
Private lImp 			:= .F.
Private cContem  := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
CR_LF := Chr(13) + Chr(10)
nOpca := 0
cCadastro := " L E I A : "
/*AADD(aSays," Este programa ler o arquivo .CSV e atualizar a tabela SC5 Pedidos de     ")
AADD(aSays," vendas. os campos atualizados ser�o PESO E VOLUME                        ")
AADD(aSays,"                                                                           ")

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )

If nOpca # 1
	Return
Endif*/

lEnd := .F.
*---------------------*
* Abre o Arquivo Texto   *
*---------------------*
nHandle := FT_FUSE(cArqTxt)
if nHandle = -1
    return .F.
endif
*-------------------------------------------------------------------------------*
* Vai para o Inicio do Arquivo e Define o numero de Linhas para a Barra de Processamento. *
*-------------------------------------------------------------------------------*
FT_FGOTOP()

_nTotal := FT_FLASTREC()

ProcRegua(_nTotal)

*--------------------------*
* Leitura da linha do arquivo *
*--------------------------*
cBuffer := FT_FREADLN()
nCt := 1
*------------------------------------*
* Percorre todo os itens do arquivo CSV. *
*------------------------------------*
While !FT_FEOF()

	IncProc()        
	*---------------------------------------------------------*
	* Faz a Leitura da Linha do Arquivo e atribui a Variavel cBuffer *
	*---------------------------------------------------------*
	cBuffer := FT_FREADLN()
	
	*----------------------------*
	* Remover os acentos da linha 	*
	*----------------------------*
	//	cBuffer := SemAcentos(cBuffer)
	*---------------------------------------------------------------*
	* Se ja passou por todos os registros do TXT sai do While. *
	*---------------------------------------------------------------*
	If Empty(cBuffer)
		Return .F.
	Endif
		
	/*----------------------------------------------------------------------------------------------*
	* somente grava o item se houver o "x" na planilha,ou seja, o ";" n�o estiver na posi��o 1.    *
	*----------------------------------------------------------------------------------------------*/
	
	xx := "1" 
	lVal	:= alltrim(substr(cBuffer,264,3))=="PEX"
	if !lVal
		Return .F.
	endif
	cPedido := alltrim(substr(cBuffer,274,10))
	nVolume := val(alltrim(substr(cBuffer,553,10)))
	nPeso	:= val(alltrim(substr(cBuffer,533,10)))
	nPesoB	:= val(alltrim(substr(cBuffer,543,10)))
	dSep	:= CTOD(substr(cBuffer,568,2)+"/"+substr(cBuffer,570,2)+"/"+substr(cBuffer,572,4))
    DbSelectArea("SC5")
    DbSetOrder(1)                                 
    IF dbseek(xFilial("SC5")+cPedido)
		RecLock("SC5", .F.)  
	   //	C5_PESOL	:= nPeso
		C5_PBRUTO	:= nPesoB  /10000
		C5_VOLUME1  := nVolume
		C5_ESPECI1	:= 'CAIXAS'
		C5_XPROCLG	:= dSep
		SC5->C5_XSTATUS :=  "2"
		MsUnlock()
		exit
	endif
	
   /* DbSelectArea("SC9")
    DbSetOrder(1)                                 
    If dbseek(xFilial("SC9")+cPedido)
    	While !EOF() .and. SC9->C9_PEDIDO == cPedido
			RecLock("SC9", .F.)
			C9_XIMPRNC	:= "S" 
			MsUnlock()
			SC9->(DBSKIP())
		EndDo
	endif*/
	nCt ++
	*------------------------	*
	* Incrementa linha          *
	*------------------------	*
	FT_FSKIP()
	*------------------------	*
	* Zera Vetor                *
	*------------------------	*
	aTmpDados := {}	
Enddo
If !FCLOSE(nHandle)
	conout( "Erro ao fechar arquivo, erro numero: ", FERROR() )
	lRet:= .F.
EndIf
FT_FUse()              
MakeDir("\Dossie\"+cPedido)
__CopyFile(cArqTxt,cDirOk+"\"+cPedido+"\"+cPedido+".TXT")
If Empty(alltrim(SC5->C5_NOTA))
	AADD(aPed,cPedido)
Endif
IF FERASE(cArqTxt) <> -1
          conout("Arquivo eliminado!")
ELSE
          conout("Erro na elimina��o do arquivo n� " + STR(FERROR()))
          lRet:= .F.
          RETURN lRet
ENDIF
Return  lRet              

/*STATIC FUNCTION ArrFat()
Local cQuery 		:= ""  
Local aArrPed		:= {} 
Local _cAlias 		:= GetNextAlias()  

cQuery := "SELECT C5_NUM FROM "+RETSQLNAME( "SC5" )+" WHERE C5_XMAGCOD <>'' AND C5_NOTA = '' AND D_E_L_E_T_ = '' AND C5_XPROCLG = '"+date()+"'"      
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), _cAlias, .F., .T. )
(_cAlias)->(dbgotop())
Do While  (_cAlias)->(!EOF())
	AADD(aArrPed,  (_cAlias)->(C5_NUM))  
	 (_cAlias)->(dbskip())
enddo
If Select(_cAlias) >0
	dbSelectArea(_cAlias)
    dbCloseArea()    
EndIf
Return aArrPed        */



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
if !LiberOK(cPedido)     
	conout("PEDIDO "+cPedido+"NAO LIBERADO POR COMPLETO")
	Return .F.
endif
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
		conout("N�o foi poss�vel gerar a Nota fiscal")    
		lRet := .F.
	Else
		 SF2->(DBSetOrder(1))
		 SF2->(DbSeek(xFilial("SF2")+cNFSaida+cSerie)) 
		 RecLock("SF2")
		 SF2->F2_XIMP := "F"
	Endif                                                           
End Transaction	
Return lRet

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