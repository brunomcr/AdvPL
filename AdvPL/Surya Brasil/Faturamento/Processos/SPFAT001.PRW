#INCLUDE "Protheus.ch"
#INCLUDE "Font.CH"
#INCLUDE "colors.ch"
#INCLUDE "AvPrint.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.  ³SPFAT001 º Uso ³ Surya Brasil º Modulo ³ SIGAFAT º Data ³ 08/11/18 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³ PE para incluir codigo de rastreio nos pedidos					  º±±
±±º       ³                                                                   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor ³ Caio de Paula             º Contato ³(11) 98346-3154              º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                                                      

User Function SPFAT001() 
FWMsgRun( ,{ || U_ProcRegO() },"Importando Cod de Rastreio")
Return      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.  ³ ProcRegO º Uso ³ Surya Brasil º Modulo ³ SIGAFAT º Data ³ 08/04/17 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³ Rotina de para importar arquivo csv de cod de rastreio      	  º±±
±±º       ³                                                                   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor ³ Caio de Paula             º Contato ³(11) 98346-3154              º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function ProcRegO()
Local aSays := {}
Local aButtons:= {}
Local nTamPrd	:= TamSX3("B1_COD")[1]
Local cRegObj	:= ""
Local cDoc		:= ""
Local cSerie	:= ""
Local cPedido	:= ""
Local lErr		:= .F.
Local cPerg		:= "REGOBJ"
Private cArqTxt 	:= ""
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
AADD(aSays," Este programa ler o arquivo .CSV e atualizar a tabela SC5 Pedido de     ")
AADD(aSays," vendas com as informacoes do correio. Registros de Objetos              ")
AADD(aSays,"                                                                           ")
AjustaSx1(cPerg)
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
aADD(aButtons, { 5,.T.,{|| Pergunte( cPerg,.T. )		}	}	)
FormBatch( cCadastro, aSays, aButtons )

If nOpca # 1 
	Return
Endif
cArqTxt:= cGetFile("Arquivos CSV|*.CSV|",OemToAnsi("Registros de Objetos..."),,,.T., GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE)
lEnd := .F.

*---------------------*
* Abre o Arquivo Texto   *
*---------------------*
FT_FUSE(cArqTxt)

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
	* Se ja passou por todos os registros da planilha "CSV" sai do While. *
	*---------------------------------------------------------------*
	If Empty(cBuffer)
		Exit
	Endif
	*----------------------------------------------	*
	* Desconsidera o primeira linha cabecalho.  	    *
	*----------------------------------------------	*
	If nCt == 1  //
		nCt ++
		FT_FSKIP()
		cBuffer := FT_FREADLN()
	EndIf
	/*----------------------------------------*
	* Retorna posicao em que foi encontrado o ";" *
	*----------------------------------------*/
	
	xPos := AT(MV_PAR03,cBuffer)
	
	/*----------------------------------------------------------------------------------------------*
	* somente grava o item se houver o "x" na planilha,ou seja, o ";" não estiver na posição 1.    *
	*----------------------------------------------------------------------------------------------*/
	If xPos > 0 // !Empty(SubStr(cBuffer , 1, xPos-1 ))
		*----------------------------------------------------------------------------------------*
		* Adiciona as informacoes no vetor ate o ";" e retira o conteudo inserido no vetor da linha cBuffer *
		*----------------------------------------------------------------------------------------*
		While xPos <> 0
			aInfo  := Alltrim(SubStr(cBuffer , 1, xPos-1 ))
			aAdd( aTmpDados , aInfo )
			cBuffer:= SubStr(cBuffer , xPos+1, Len(cBuffer)-xPos)
			xPos := AT(MV_PAR03,cBuffer)
		Enddo
		*---------------------------------------------------------------------------------------*
		* Se ainda tiver informacao no cBuffer, adiciona a ultima parte do arquivo depois do ";" no vetor  *
		*---------------------------------------------------------------------------------------*
		//Datax	Descr	Rem	Dest CEP UF PEso cUBO QTDE REGISTRO AD OBS CONTA NF
		if Len(cBuffer) > 0
			aInfo  := Alltrim(SubStr(cBuffer , 1, Len(cBuffer) ))
			aAdd( aTmpDados , aInfo )
		endif
		aAdd( aDados , aTmpDados )
		nDados++
		lImp := .T. // O item será importado
	endif
	xx := "1"
	cRegObj := ALLTRIM(aTmpDados[MV_PAR01])+"BR"
	cDoc	:= aTmpDados[MV_PAR02]
	cSerie	:= "003"        
	cPedido	:= U_FindPV(cDoc,cSerie)

	DbSelectArea("SC5")
    DbSetOrder(1)
    if dbSeek(xFilial("SC5")+cPedido)
		RecLock("SC5", .F.)
			C5_XRASTRE := cRegObj
		MsUnlock()
	else
		lErr := .T.
		autogrlog('Pedido não encontrado.Erro no Objeto: '+cRegObj)
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
Alert("Importação finalizada....")
if lErr
	MostraErro()
Endif
Return

Static Function AjustaSx1(cPerg)
u_xPutSX1(cPerg,"01"   	,"Pos. Coluna Objeto: ","Prefixo: ","Prefixo:	","mv_ch1"	,"N"	,2		,0		,0		,"G","","  ","","","mv_par01","","","","","","","","","","","","","","","","",{"","",""},{},{})
u_xPutSX1(cPerg,"02"   	,"Pos. Coluna NF: ","Titulo: "	,"Titulo "	 ,"mv_ch2"	,"N"    ,2		,0		,0		,"G","","  ","","","mv_par02","","","","","","","","","","","","","","","","",{"","",""},{},{})
u_xPutSX1(cPerg,"03"   	,"Separador: ","Titulo: "	,"Titulo "	 ,"mv_ch3"	,"C"    ,1		,0		,0		,"G","","  ","","","mv_par03","","","","","","","","","","","","","","","","",{"","",""},{},{})
Return

User Function FindPV(cNota,cSerie)
local cPed	 	:= ""
local cQuery	:= ""
Local cAlias	:= GetNextAlias()
cQuery := "SELECT D2_PEDIDO FROM "+RetSQLName("SD2")+" WHERE D_E_L_E_T_ = '' AND "
cQuery += "D2_DOC LIKE '%"+cNota+"' "
cQuery += "AND D2_SERIE = '"+cSerie+"'" 
cQuery := Changequery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
if !(cAlias)->(EOF())
	cPed := (cAlias)->D2_PEDIDO
endif						
(cAlias)->(DbCloseArea())
Return cPed