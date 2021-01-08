#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "ap5mail.ch"
#include "tbicode.ch"
#INCLUDE "DEFEMPSB.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "fivewin.ch"
#define DS_MODALFRAME 128

/*/{Protheus.doc} SSCH006
Funcao para trabalhar com Neogrid
@type function
@version 
@author tecno
@since 10/20/2020
@return return_type, return_description
/*/
User Function SSCH006(aparam) 	//u_SSCH006({"08,01,RP"}) aparam := {"08","01","RP"} || xEmp,XFil,cTipo
// Arquivo
local cPed        := ""	
// Caminho das pastas
local _cCamPVRec  := ""
local _cCamPVEnv  := ""
local _cCampNFEnv := ""
// aParam
Private xEmp      := aParam[1]		
Private xFil      := aParam[2]
Private cTipo     := aParam[3]	// RP = Recebe Pedido | EP = Envia Pedido | EN = Envia NF

// PREPARA AMBIENTE com "WorfFlow Protheus" se nao "Prepare Environment"
RPCSetType(3)					// Nao consome licensa de uso
If FindFunction('WFPREPENV')	
	lAuto := .T.      
	RPCSetType( 3 )				// Nao consome licensa de uso
	wfPrepENV(xEmp, xFil)	
Else
	lAuto := .T.
	RPCSetType( 3 )				// Nao consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil	
Endif

_cCamPVRec  := SuperGetMV("SB_NGRECPV",.F., '\Neogrid\PVRec\' )
_cCamPVEnv  := SuperGetMV("SB_NGREMPV",.F., '\Neogrid\PVRem\' )
_cCampNFEnv := SuperGetMV("SB_NGREMNF",.F., '\Neogrid\NFRem\' )
if cTipo == "RP"
	ImpPVNeo(_cCamPVRec,@cPed)
elseif cTipo == "EP"
	RetPVNeo(_cCamPVEnv)
elseif cTipo == "EN"
	EnvNFNeo(_cCampNFEnv)
endif

Return
//###############################################################################################################

/*/{Protheus.doc} FTR2All
description
@type function
@version 
@author tecno
@since 10/20/2020
@return return_type, return_description
/*/
Static Function FTR2All()
Local cLocal       := "\logistica\rnc\"
Local cFile        := ""
Local lRet         := .T.
Local cServer      := "179.191.71.210" 	//Quantic
Local nPorta       := 2121 				//nPorta //2121
Local cUser        := "Protheus"
Local cPass        := "Carg!!2010"
Local aDir         := {}


Private _cAmbAtual := Upper( AllTrim( GetEnvServer() ) )
//FTPDisconnect()
If	FTPConnect( cServer, 2121, cUser, cPass )
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

/*/{Protheus.doc} envEcom1
description
@type function
@version 
@author tecno
@since 10/20/2020
@param cAssunto, character, param_description
@param cMensagem, character, param_description
@param cDest, character, param_description
@param cCopy, character, param_description
@return return_type, return_description
/*/
Static Function envEcom1(cAssunto, cMensagem, cDest, cCopy)

			  oWorkFLW               := TWEnviaEmail():New()
			  oWorkFLW:cConta        := "suryabrasil@shared.mandic.net.br"
			  oWorkFLW:cSenha        := "75XQF9qg"
			  oWorkFLW:cDestinatario := cDest
			  oWorkFLW:cCopia        := cCopy
			  oWorkFLW:cServerSMTP   := "sharedrelay-cluster.mandic.net.br"
			 
			  oWorkFLW:cAssunto      := cAssunto
			  oWorkFLW:cMensagem     := cMensagem
			  
			  oWorkFLW:EnviaEmail()
			  Conout( 'E-mail de erro e-commerce enviado com sucesso' )

Return

/*/{Protheus.doc} ImpPVNeo
description
@type function
@version 
@author tecno
@since 10/20/2020
@param cCaminho, character, param_description
@param cPed, character, param_description
@return return_type, return_description
/*/
Static Function ImpPVNeo(cCaminho,cPed)
local aArq    := {}
local cDirXml := ''
local lRet    := .T.
cDirXml       := cCaminho
aArq := Directory(cDirXml+"*.txt")
for i= 1 to len(aArq)
	cXMLFile := cDirXml+aArq[i][1]
	lRet     := ImpSC5(cXMLFile,@cPed)
	if !lRet
		envEcom1("Erro Integracao Pedido Neogrid", "O Pedido da Neogrid nao foi importado", "caio.santos@suryabrasil.com", "bruno.real@suryabrasil.com")
	endif         
next
Return lRet

/*/{Protheus.doc} ImpSC5
description
@type function
@version 
@author tecno
@since 10/20/2020
@param cArq, character, param_description
@param cped, character, param_description
@return return_type, return_description
/*/
Static FuncTion ImpSC5(cArq,cped)
Local aSays       := {}
Local aButtons    := {}
Local nTamPrd     := TamSX3("B1_COD")[1]
local cPedido     := ""
local nVolume     := 0
local nPeso       := 0
local nPesoB      := 0
local nHandle     := 0
local dSep        := CTOD(" / / ")
local lRet        := .T.
Local aEstCabe    := {}
local aEstItem    := {}
local aCabec      := {}
local aItens      := {}
local __aLinha    := {}
Private cArqTxt   := cArq
Private cDirOk    := "\Dossie"
Private aTmpDados := {}
Private aDados    := {}
Private nDados    := 0
Private aInfo     := {}
Private xPos      := ""
Private lImp      := .F.
Private cContem   := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
CR_LF             := Chr(13) + Chr(10)
nOpca             := 0
cCadastro         := " L E I A : "
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
/*---------------------*
* Abre o Arquivo Texto   *
*---------------------*/
nHandle := FT_FUSE(cArqTxt)
if nHandle = -1
    return .F.
endif
/*-------------------------------------------------------------------------------*
* Vai para o Inicio do Arquivo e Define o numero de Linhas para a Barra de Processamento. *
*-------------------------------------------------------------------------------*/
FT_FGOTOP()

_nTotal := FT_FLASTREC()

ProcRegua(_nTotal)

/*--------------------------*
* Leitura da linha do arquivo *
*--------------------------*/
cBuffer := FT_FREADLN()
nCt := 0
/*------------------------------------*
* Percorre todo os itens do arquivo CSV. *
*------------------------------------*/
While !FT_FEOF()
	
	IncProc()        
	/*---------------------------------------------------------*
	* Faz a Leitura da Linha do Arquivo e atribui a Variavel cBuffer *
	*---------------------------------------------------------*/
	cBuffer := FT_FREADLN()
	
	/*----------------------------*
	* Remover os acentos da linha 	*
	*----------------------------*/
	//	cBuffer := SemAcentos(cBuffer)
	/*---------------------------------------------------------------*
	* Se ja passou por todos os registros do TXT sai do While. *
	*---------------------------------------------------------------*/
	If Empty(cBuffer)
		Return .F.
	Endif
	if Substr(cBuffer,1,2) == "01"
		AADD(aEstCabe,  POSICIONE("SA1",3,xfilial("SA1")+substr(cBuffer,181,14),"A1_COD"))	//1 cliente posi��o errada no leiaute esta 180
		AADD(aEstCabe, Posicione("SA1",3,xFilial("SA1")+alltrim(substr(cBuffer,181,14)),"A1_LOJA")) // 2 LojaCli
		AADD(aEstCabe, SuperGetMV("SB_NEOTRAN",.F.,"000008")) // 3 transportadora para ser utilizada no pedido
		AADD(aEstCabe, SuperGetMV("SB_NEOVEND",.F.,"000114"))// 4 vendedor unico 000114
		AADD(aEstCabe, SuperGetMV("SB_NEOCOND",.F.,"003"))//5 003 CONDICAO DE PAGTO
		AADD(aEstCabe,  "Ped Compra: "+Substr(cBuffer,180,14)) // 6 MENSAGEM NOTA
	elseif Substr(cBuffer,1,2) == "04" //aEstItem
		nCt++
		AADD(aEstItem, {strzero(nCt,2),; //1 item
						Posicione("SB1",5,xFilial("SB1")+ALLTRIM(Substr(cBuffer,17,14)),"B1_COD"),; //2produto
						"01",; // 3tp Operacao Venda = 01
						SuperGetMV("SB_NEOARM",.F.,"03"),; //4 armazem
						VAL(Substr(cBuffer,100,15))/100,; //5 QUANTIDADE leiaute 99
						VAL(Substr(cBuffer,198,15)),; //6 PRECO						leiaute 1970 
						})

		
	endif

	/*----------------------------------------------------------------------------------------------*
	* somente grava o item se houver o "x" na planilha,ou seja, o ";" n�o estiver na posi��o 1.    *
	*----------------------------------------------------------------------------------------------*/
	


   
	
  
	nCt ++
	/*------------------------	*
	* Incrementa linha          *
	*------------------------	*/
	FT_FSKIP()
	/*------------------------	*
	* Zera Vetor                *
	*------------------------	*/
	aTmpDados := {}	
Enddo
If !FCLOSE(nHandle)
	conout( "Erro ao fechar arquivo, erro numero: ", FERROR() )
	lRet:= .F.
EndIf
FT_FUse()              
MakeDir("\Neogrid\PVRec\Proc\")
__CopyFile(cArqTxt,"\Neogrid\PVRec\Proc\"+cArqTxt)
IF FERASE(cArqTxt) <> -1
          conout("Arquivo eliminado!")
ELSE
          conout("Erro na elimina��o do arquivo n� " + STR(FERROR()))
          lRet:= .F.
          RETURN lRet
ENDIF


aadd(aCabec, {"C5_TIPO"   , "N"        , Nil})
aadd(aCabec, {"C5_CLIENTE", aEstCabe[1], Nil})
aadd(aCabec, {"C5_LOJACLI", aEstCabe[2], Nil})
aadd(aCabec, {"C5_CLIENT" , aEstCabe[1], Nil})
aadd(aCabec, {"C5_LOJAENT", aEstCabe[2], Nil})
aadd(aCabec, {"C5_TRANSP" , aEstCabe[3], Nil}) //NÃ£o excluir do fonte, pois com esse campo p execauto nÃ£o funciona
aadd(aCabec, {"C5_CONDPAG", aEstCabe[5], Nil})
aadd(aCabec, {"C5_VEND1"  , aEstCabe[4], Nil})
aadd(aCabec, {"C5_MENNOTA", aEstCabe[6], Nil}) // Mensagem para Nota
aadd(aCabec, {"C5_TPFRETE", "C"        , Nil})
For n = 1 to len(aEstItem)
	aadd(__aLinha, {"C6_ITEM"   , strzero(n,2), Nil})  // 01
	aadd(__aLinha, {"C6_PRODUTO", aEstItem[n][2], Nil})
	aadd(__aLinha, {"C6_LOCAL"  , aEstItem[n][4], Nil})
	aadd(__aLinha, {"C6_OPER"   , aEstItem[n][3], Nil})
	aadd(__aLinha, {"C6_QTDVEN" , aEstItem[n][5], Nil})
	aadd(__aLinha, {"C6_QTDLIB" , aEstItem[n][5], Nil})
	aadd(__aLinha, {"C6_PRCVEN" , aEstItem[n][6], Nil})
	aadd(__aLinha, {"C6_PRUNIT" , aEstItem[n][6], Nil})
	aadd(aItens,__aLinha)
next
lMSHelpAuto 	:= .T.
lMSErroAuto 	:= .F.
lAutoErrNoFile 	:= .T.
SA1->( dbSetOrder(1) )
SC5->( dbSetOrder(1) )
MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, 3) 

If lMSErroAuto
	aErroAuto := GetAutoGRLog()
	For __nY := 1 To Len(aErroAuto)
		CONOUT(StrTran(StrTran(StrTran(aErroAuto[__nY],"<"," "),"-"," "),"/"," ")+" ")
		CONOUT(__wsSoapFault)
		//exit //TDJ001
	Next __nY
	lRet := .F.
Else
	ConfirmSX8()
	cPed := SC5->C5_NUM
	lRet := .T.
EndIf


Return  lRet              



