#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDE "AvPrint.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"  
#include "Totvs.ch"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.  ³ SBP0006 º Uso ³ Surya Brasil º Modulo ³ SIGAFAT º Data ³ 08/06/17 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³ Rotina de para importar PESO e VOLUME mandados pela IBEX		  º±±
±±º       ³                                                                   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor ³ Caio de Paula             º Contato ³(11) 98346-3154              º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function SBP0006()
local aArq		:= {}
local cDirXml	:= ''
cDirXml := "\logistica\rnc\"
aArq := Directory(cDirXml+"*.txt")
cDirOk    := cDirXml+"processados\"
MakeDir(cDirOk)


for i= 1 to len(aArq)
	cXMLFile := cDirXml+aArq[i][1]
	Processa({|| ImpSC5(cXMLFile) },"Importanto Peso e Volume dos Pedidos...")           
next
Return

Static FuncTion ImpSC5(cXMLFile)
Local aSays := {}
Local aButtons:= {}
Local nTamPrd	:= TamSX3("B1_COD")[1]
local cPedido	:= ""
local nVolume	:= 0
local nPeso		:= 0   
local nPesoB	:= 0
local nHandle := 0
Private cArqTxt 	:= cXMLFile//cGetFile("Arquivos CSV|*.CSV|Todos os Arquivos|*.*",OemToAnsi("Peso e volume ..."),,,.T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE)
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
AADD(aSays," vendas. os campos atualizados serão PESO E VOLUME                        ")
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
		Exit
	Endif
		
	/*----------------------------------------------------------------------------------------------*
	* somente grava o item se houver o "x" na planilha,ou seja, o ";" não estiver na posição 1.    *
	*----------------------------------------------------------------------------------------------*/
	
	xx := "1"
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
		SC5->C5_PBRUTO	:= nPesoB  /10000
		SC5->C5_VOLUME1  := nVolume
		SC5->C5_ESPECI1	:= 'CAIXAS'
		SC5->C5_XPROCLG	:= dSep
		SC5->C5_XSTATUS :=  "2"
		MsUnlock()
		exit
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
EndIf
FT_FUse()
__CopyFile(cArqTxt,cDirOk+cPedido+".TXT")
IF FERASE(cArqTxt) <> -1
          conout("Arquivo eliminado!")
ELSE
          conout("Erro na eliminação do arquivo nº " + STR(FERROR()))
          RETURN NIL
ENDIF
MsgAlert("Importação finalizada....")
Return



