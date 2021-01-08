#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDE "AvPrint.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออัอออออออออหอออออัออออออออออออออหออออออออัอออออออออหออออออัออออออออออปฑฑ
ฑฑบProg.  ณMTA700MNUบ Uso ณ Surya Brasil บ Modulo ณ SIGAFAT บ Data ณ 08/07/17 บฑฑ
ฑฑฬอออออออุอออออออออสอออออฯออออออออออออออสออออออออฯอออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.  ณ PE para incluir rotina no menu de previsใo de vendas para importarบฑฑ
ฑฑบ       ณ previs๕es                                                         บฑฑ
ฑฑฬอออออออุอออออออออออออออออออออออออออหอออออออออัอออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor ณ Caio de Paula             บ Contato ณ(11) 98346-3154              บฑฑ
ฑฑศอออออออฯอออออออออออออออออออออออออออสอออออออออฯอออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                                      

User Function MTA700MNU() 
Aadd(aRotina,{"Importa Previsao"	, "U_SBP0003()"	,0,2})
Return      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออัอออออออออหอออออัออออออออออออออหออออออออัอออออออออหออออออัออออออออออปฑฑ
ฑฑบProg.  ณ SBP0003 บ Uso ณ Surya Brasil บ Modulo ณ SIGAFAT บ Data ณ 08/04/17 บฑฑ
ฑฑฬอออออออุอออออออออสอออออฯออออออออออออออสออออออออฯอออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.  ณ Rotina de para importar arquivo csv de previsใo de vendas		  บฑฑ
ฑฑบ       ณ                                                                   บฑฑ
ฑฑฬอออออออุอออออออออออออออออออออออออออหอออออออออัอออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor ณ Caio de Paula             บ Contato ณ(11) 98346-3154              บฑฑ
ฑฑศอออออออฯอออออออออออออออออออออออออออสอออออออออฯอออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



User Function SBP0003()

	Processa({|| ImpSC4() },"Importanto Previsao de Vendas...")           

Return

Static FuncTion ImpSC4()
Local aSays := {}
Local aButtons:= {}
Local nTamPrd	:= TamSX3("B1_COD")[1]
//Private cArqTxt 	:= cGetFile("Arquivos CSV|*.CSV|Todos os Arquivos|*.*",OemToAnsi("De/para Produtos ..."),,,.T.,GETF_NETWORKDRIVE)
//Private cArqTxt 	:= cGetFile("Arquivos CSV|*.CSV|Todos os Arquivos|*.*",OemToAnsi("Previsao de vendas ..."),,,.T.,GETF_RETDIRECTORY + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE)
Private cArqTxt 	:= cGetFile("Arquivos CSV|*.CSV|Todos os Arquivos|*.*",OemToAnsi("Previsao de vendas ..."),,,.T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE)
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
AADD(aSays," Este programa ler o arquivo .CSV e atualizar a tabela SC4 Previsao de     ")
AADD(aSays," vendas. As colunas devera seguir a sequencia abaixo:                      ")
AADD(aSays," Produto	Descricao	Quantidade	Total	Local	Data")
AADD(aSays," As colunas numericas deveras estar formatadas como Numero Ex.: 101.393,64 ")
AADD(aSays," A Data deve vir no padrao DD/MM/AAAA e sempre o ultimo dia do mสs         ")

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )

If nOpca # 1
	Return
Endif

lEnd := .F.

/*cPerg := "GCRIAPVDA3"
aHelpP:=aHelpE:=aHelpS:= {}
PutSx1(cPerg,"01","Data Final da Previsao","Data Final da Previsao","Data Final da Previsao","mv_ch1","D",08,0,0,"G",""                ,     ,,,"mv_par01",     ,     ,     ,  ,     ,     ,     ,  ,  ,  ,  ,  ,  ,  ,  ,  ,aHelpP,aHelpE,aHelpS)

If ! Pergunte(cPerg,.T.)
	Return
EndIf*/	

c_Doc := VerMaxDoc()

//c_Revisao := VerRevSC4(MV_PAR01)
//If c_Revisao <> "001"
//	If ! MsgYesNo( "Confirma gerar revisao: " + c_Revisao +" ?", "Atencao" )
//		Return
//	EndIf	
//EndIf	

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
		msgalert("Erro no arquivo")
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
	
	xPos := AT(";",cBuffer)
	xPos := IIF(xPos==0, AT(",",cBuffer),xPos)
	/*----------------------------------------------------------------------------------------------*
	* somente grava o item se houver o "x" na planilha,ou seja, o ";" nใo estiver na posi็ใo 1.    *
	*----------------------------------------------------------------------------------------------*/
	If xPos > 0 // !Empty(SubStr(cBuffer , 1, xPos-1 ))
		*----------------------------------------------------------------------------------------*
		* Adiciona as informacoes no vetor ate o ";" e retira o conteudo inserido no vetor da linha cBuffer *
		*----------------------------------------------------------------------------------------*
		While xPos <> 0
			aInfo  := Alltrim(SubStr(cBuffer , 1, xPos-1 ))
			aAdd( aTmpDados , aInfo )
			cBuffer:= SubStr(cBuffer , xPos+1, Len(cBuffer)-xPos)
			xPos := AT(";",cBuffer)
			xPos := IIF(xPos==0, AT(",",cBuffer),xPos)
		Enddo
		*---------------------------------------------------------------------------------------*
		* Se ainda tiver informacao no cBuffer, adiciona a ultima parte do arquivo depois do ";" no vetor  *
		*---------------------------------------------------------------------------------------*
		//Produto	Descricao	Quantidade	Total	Local	Data
		if Len(cBuffer) > 0
			aInfo  := Alltrim(SubStr(cBuffer , 1, Len(cBuffer) ))
			aAdd( aTmpDados , aInfo )
		endif
		aAdd( aDados , aTmpDados )
		nDados++
		lImp := .T. // O item serแ importado
	endif
	xx := "1"
	c_Prod := aTmpDados[1]          
	/*l_Char := .F.
	For nL := 1 To Len(Alltrim(c_Prod))
		If Substr(c_Prod,nL,1) $ cContem
			l_Char := .T.
		    Exit
		 EndIf    
	Next 
	xx := "1"
	If ! l_Char
		c_Prod := StrZero(Val(aTmpDados[1]),If(Len(Alltrim(c_Prod))<= 4,4,Len(Alltrim(c_Prod)) ))
	Else
		c_Prod := aTmpDados[1] 
	EndIf	 */     
	c_Prod  := Substr(Alltrim(c_Prod) + Space(nTamPrd),1,nTamPrd)
	c_Local := aTmpDados[5]

	DbSelectArea("SC4")
    n_Qtd := STRTRAN(aTmpDados[3],".","")
    n_Qtd := STRTRAN(n_Qtd,",",".")    
    n_Vlr := STRTRAN(aTmpDados[4],".","")
	n_Vlr := STRTRAN(n_Vlr,",",".")
	n_Vlr := STRTRAN(n_Vlr,"R$","")
	n_Vlr := STRTRAN(n_Vlr," ","")
	d_Data:= Lastday(CTOD(aTmpDados[6]))
	cCanal:= iif(Alltrim(aTmpDados[7])=="PJ","1","2")
	RecLock("SC4", .T.)
	C4_FILIAL	:= xFilial("SC4")
	C4_PRODUTO  := c_Prod
	C4_LOCAL	:= c_Local
	C4_DOC   	:= c_Doc
	C4_QUANT	:= Val(n_Qtd)
	C4_VALOR	:= Val(n_Vlr)
	C4_DATA		:= d_Data
	C4_XCANSAI	:= cCanal
	C4_OBS	    := "Inserido por "+ UsrRetName (__cUserID) 
	MsUnlock()
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
Alert("Importa็ใo finalizada....")
Return


Static FuncTIon VerMaxDoc()
Local c_rev := "000000000"
cQuery	:= 	"SELECT MAX(C4_DOC)[DOC] "
cQuery 	+= 	"FROM "+RetSqlName("SC4")+" SC4 "
cQuery 	+= 	"WHERE SC4.C4_FILIAL='"+xFilial("SC4")+"' AND "
cQuery 	+=	"SC4.D_E_L_E_T_=' ' "
//
cQuery := ChangeQuery(cQuery)
If SELECT("TSC4") > 0
	TSC4->(DbCloseArea())
EndIf	
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSC4")
//
DbSelectArea("TSC4")
TSC4->(DbGoTop())
If ! TSC4->(Eof())
	c_rev := TSC4->DOC
	c_rev := strzero(val(c_rev),9)
EndIf	
c_rev := Soma1(c_rev)

Return(c_rev)

