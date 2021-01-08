#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDe "AvPrint.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#include "fwprintsetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "DEFEMPSB.CH"
#define DMPAPER_A4 9
//#define IMP_PDF 2
//#define IMP_SPOOL 1
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.  ³FA740BRW º Uso ³ Surya Brasil º Modulo ³ SIGAFIN º Data ³ 22/02/18 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³ Ponto de entrada reimprimir boleto ja gerado pela emissao da NF   º±±
±±º       ³   												 	              º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±      		
±±º Autor ³ Caio de Paula             º Contato ³(11) 98346-3154              º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA740BRW()
Local aBotao := {}
Local cEmpresa := cEmpAnt
if cEmpresa == FC
	aAdd(aBotao, {'Reimp Boleto',"U_x2viabol",   0 , 3    })
Endif
Return(aBotao)

User Function x2viabol()
Local cCadastro := OemToAnsi("Reimpressao de Boleto")
Local aSays:={}, aButtons:={}
Local nOpca     := 0 
LOCAL cPerg		:= "BOLETOBCO"

AADD(aSays,OemToAnsi( "Este programa ira realizar a impressao dos boletos"))
AADD(aSays,OemToAnsi( "Verifique se o campo de boleto impresso está como [Nao]"))
AjustaSx1(cPerg)
AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
If nOpca == 1
     Processa( { |lEnd| RexImpBol() })
EndIf
Return

Static Function RexImpBol()   
local aParam		:= {}
local cparcFirst	:= ""
local cparcLast		:= ""  
local lDanfe		:= .T. 
local cimpBol		:= ''
LOCAL cQuery		:= ''
lOCAL cBanco		:= ""



cQuery :="SELECT * " 
cQuery +=" FROM "+RetSqlName("SE1") +" SE1 (NOLOCK)"
cQuery+=" WHERE SE1.D_E_L_E_T_ = ' '"
cQuery +=" AND E1_FILIAL = '"+XFILIAL("SE1")+"'"
cQuery +=" AND E1_PREFIXO = '"+MV_PAR01+"'"
cQuery +=" AND E1_NUM = '"+MV_PAR02+"' 
cQuery +=" AND E1_PARCELA BETWEEN '"+MV_PAR03+"' AND '"+ MV_PAR04 +"'"
cQuery +=" AND E1_TIPO = 'NF'"
cQuery +=" ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA " 
If Select("RS_BOLBRA") > 0           // Verificar se o Alias ja esta aberto.
	DbSelectArea("RS_BOLBRA")        // Se estiver, devera ser fechado.
	RS_BOLBRA->(DbCloseArea())
EndIf 
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "RS_BOLBRA", .F., .T.)  		
dbselectarea("RS_BOLBRA")    
DbGoTop()  
li:= 500000
//SetRegua(RecCount()) 
If !EOF()
	AADD(aParam, RS_BOLBRA->E1_PREFIXO)//[1]
	AADD(aParam, RS_BOLBRA->E1_NUM)
	AADD(aParam, RS_BOLBRA->E1_NUM)
	AADD(aParam, RS_BOLBRA->E1_PARCELA)//[4]
	AADD(aParam, MV_PAR04)
	AADD(aParam, RS_BOLBRA->E1_XIMPBOL) //[6]
	cimpBol :=  RS_BOLBRA->E1_XIMPBOL
	cBanco	:= RS_BOLBRA->E1_PORTADO
Endif	
if len(aParam) <= 0
	MsgAlert("Verifique os parametros","HELP: DADOS NAO ENCONTRADOS")
	Return()
endif
if cimpBol == '1'
	if MsgNoYes("Este Titulo ja teve boleto impresso, deseja libera-lo?","HELP: BOLETO JA IMPRESSO")
		cimpBol := "2"
	else
		Return()
	endif
endif
if Empty(alltrim(cBanco))
	MsgAlert("Este Titulo não possui Portador, Favor transferi-lo","HELP: NOPORTADOR")
	Return()
endif
	
 
if len(aParam) > 0	.And. cimpBol <> '1' .And. !Empty(alltrim(cBanco))
	SelBol(aParam,cBanco)		  
endif 


Return	
Static Function SelBol(aParam, cBanco)
Local oBoleto
LOcal lAdjustToLegacy	:= .T.
LOcal cFilePrint	:= ""
Local cPathInServer := "C:\spool\"
cFilePrint	:= "BOL"+cBanco+aParam[1]+aParam[2]
lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
oBoleto := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, cPathInServer, .T.)
oBoleto:nDevice := IMP_PDF
//oBoleto:cPathPDF := "\boletos"
oBoleto:cPathPDF := "C:\spool\"
oBoleto:SetResolution(78) //Tamanho estipulado para a Danfe
oBoleto:SetPortrait()
oBoleto:SetPaperSize(DMPAPER_A4)
oBoleto:SetMargin(60,60,60,60)
oBoleto:lServer := .T.
oBoleto:lViewPDF := .T.
Do Case
	Case cBanco == "237"
		U_BOLETBRA(.F., aParam,oBoleto)  
	Case cBanco	== "033"
		U_BOLETSAN(.F., aParam,oBoleto)   
EndCase
oBoleto:Preview()

Return

Static Function AjustaSx1(cPerg)
u_xPutSX1(cPerg,"01"   ,"Prefixo do titulo ?"		,"Prefixo do titulo ?"	 	,"Prefixo do titulo ?"	    ,"mv_ch1"	,"C"	,3		,0		,0		,"G","","  ","","","mv_par01","","","","","","","","","","","","","","","","",{"Informe o prefixo do titulo","",""},{},{})
u_xPutSX1(cPerg,"02"   ,"Numero do titulo ?"		,"Do o Numero do titulo ?"	,"Do o Numero do titulo ?"	,"mv_ch2"	,"C"    ,9		,0		,0		,"G","","  ","","","mv_par02","","","","","","","","","","","","","","","","",{"Informe o numero do titulo inicial","",""},{},{})
u_xPutSX1(cPerg,"03"   ,"Da Parcela ?"				,"Da PArcela ?"				,"Da PArcela ?"				,"mv_ch3"	,"C"    ,2		,0		,0		,"G","","  ","","","mv_par03","","","","","","","","","","","","","","","","",{"Informe o numero da parcela inicial","",""},{},{})
u_xPutSX1(cPerg,"04"   ,"Ate a Parcela ?"			,"Da PArcela ?"				,"Da PArcela ?"				,"mv_ch4"	,"C"    ,2		,0		,0		,"G","","  ","","","mv_par04","","","","","","","","","","","","","","","","",{"Informe o numero da parcela Final","",""},{},{})
Return
