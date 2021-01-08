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

// Função de agendamento para fazer o download do arquivo RNC, importar no sistema e gerar a NF
User Function SSCH005(aparam)
//User Function SSCH001()
local _cDest	    := ""
local _cDestFat	    := ""
local _cCopy	    := ""

Private xEmp 		:= aParam[1]
Private xFil 		:= aParam[2]

RPCSetType(3)
If FindFunction('WFPREPENV')
	lAuto := .T.      
	RPCSetType( 3 )						// Não consome licensa de uso
	wfPrepENV(xEmp, xFil)	
	//wfPrepENV("03", "00")
Else
	lAuto := .T.
	RPCSetType( 3 )						// Não consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil	
Endif

_cDest	    := GetMV("SB_DESTFTP")
_cDestFat	:= GetMV("SB_DESTFAT")
_cCopy	    := GetMV("SB_COPYFTP")
//DbSelectArea("SC5")  
//_GeraNF("308707") 
//Return
if !FTR2All()  
	Conout("Erro 008 - Download Arquivo FTP", "Erro no arquivo de retorno")
else
	ImpRNC()			
endif
Return


Static Function FTR2All()
Local cLocal := "\logistica\coleta\"
Local lRet := .T.
Local cServer 	:= "187.0.200.180"
Local cUser		:= "surya@2aliancas.com.br"
Local cPass	:= "2aliancas!!"
Local aDir	:= {}
local i		:= 0
//FTPDisconnect()
If	FTPConnect( cServer, 21, cUser, cPass )
    Conout('FTP conectado!')
    Conout('Diretorio FTP',FTPGetCurDir())
    Conout('FTPDirChange',FTPDirChange('008/PROCESSADOS'))
    FTPGetCurDir()
    FTPDirChange('008/PROCESSADOS')
    aDir	:= FTPDIRECTORY( "*.txt", )    
    For i := 1 to Len(aDir) 
		If !FTPDOWNLOAD(cLocal+aDir[i][1], aDir[i][1]) 
	    	conout("008 - Problemas ao copiar arquivo"+ aDir[i][1] ) 
	    	
	    	lRet := .F.
        EndIf
        If !FTPERASE(aDir[i][1])
        	Conout("008 - Problemas ao apagar o arquivo" + aDir[i][1] )  
        	lRet := .F.
        EndIf
	Next
     FTPDisconnect()
Else
     Conout('Falha Conexao!')
     lRet := .F.
EndIf
Return lRet 

Static Function ImpRNC()
local aArq			:= {}
local cDirXml		:= ''        
local lRet 			:= .T.
Local cDirXml 		:= "\logistica\coleta\"
Local cXMLFile		:= ""
Private cDirErro  	:= cDirXml+"Erro\"
Private cDirOk    	:= cDirXml+"processados\"
aArq := Directory(cDirXml+"*.txt")
for i= 1 to len(aArq)
	cXMLFile := cDirXml+aArq[i][1]
	lRet :=	ImpSC5(cXMLFile)    
	if lRet		
		__CopyFile(cXMLFile,cDirOk+aArq[i][1])
		IF FERASE(cXMLFile) <> -1
		          conout("Arquivo eliminado!")
		ELSE
		          conout("Erro na eliminação do arquivo nº " + STR(FERROR()))
		          lRet:= .F.		          
		ENDIF
	else
		__CopyFile(cXMLFile,cDirErro+aArq[i][1])
		IF FERASE(cXMLFile) <> -1
		          conout("Arquivo eliminado!")
		ELSE
		          conout("Erro na eliminação do arquivo nº " + STR(FERROR()))
		          lRet:= .F.		          
		ENDIF
	endif	       
next
Return lRet

Static FuncTion ImpSC5(cArq)

local cPedido	:= ""
local dData		:= ctod("  /  /  ")
local dHora		:= ""   
local nHandle := 0                                                                     
local lRet		:= .T.
Private cArqTxt 	:= cArq
Private aTmpDados		:= {}




*---------------------*
* Abre o Arquivo Texto   *
*---------------------*
nHandle := FT_FUSE(cArqTxt)
if nHandle = -1
    lRet := .F.
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
		lRet := .F.
	Endif
		
	/*----------------------------------------------------------------------------------------------*
	* somente grava o item se houver o "x" na planilha,ou seja, o ";" não estiver na posição 1.    *
	*----------------------------------------------------------------------------------------------*/
	
	
	cPedido := alltrim(substr(cBuffer,274,10))
	dData := Ctod(StrZero(Val(alltrim(substr(cBuffer,568,2))),2)+"/"+StrZero(Val(alltrim(substr(cBuffer,570,2))),2)+"/"+;
				StrZero(Val(alltrim(substr(cBuffer,572,4))),4))
	dHora	:= strzero(val(alltrim(substr(cBuffer,577,2))),2)+":"+strzero(val(alltrim(substr(cBuffer,579,2))),2)+":00"
	DbSelectArea("SC5")
    DbSetOrder(1)                                 
    IF dbseek(xFilial("SC5")+alltrim(cPedido))
    	RecLock("SC5", .F.)  
			SC5->C5_XSTATUS :=  "6"
			SC5->C5_XDESCST :=  "Pedido de Venda Coletado"
		MsUnlock()
    	DbSelectArea("SF2")
    	DbSetOrder(1)
    	IF dbseek(xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
			RecLock("SF2", .F.)  
				SF2->F2_XDTCOL	:= dData
				SF2->F2_XHRCOL  := dHora			
			MsUnlock()
			exit
		else
			lRet := .F.
		endif	
	else
		lRet := .F.
	endif   
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
Return  lRet  