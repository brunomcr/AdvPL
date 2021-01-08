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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.  ³ SBP0007 º Uso ³ Surya Brasil º Modulo ³ SIGAFAT º Data ³ 08/05/17 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³ Rotina de para gerar arquivo EDI para logistica leiaute 07  	  º±±
±±º       ³     Integracao NF x Pedido                                        º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor ³ Caio de Paula             º Contato ³(11) 98346-3154              º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SBP0007()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
cEol	:= "CHR(13)+CHR(10)"
	
If Empty(cEol)
	cEol := CHR(13)+CHR(10)
Else
	cEol := Trim(cEol)
	cEol := &cEol
Endif	
Processa({|| ProcessaI() },"Processando...")
Return()

Static Function ProcessaI()
/*Local nTamLin, cCpo
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

cPedido  := SC5->C5_NUM
lRet :=	MsAguarde({|| RunCont(cPedido)},"Criando arquivo integrador PickList...")    
//MsAguarde({|| x_ImpXml()},"Importando XML ...") 
 
*/
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
	cArqTxt := cCaminho  
	cArqTxt := ALLTRIM(cArqTxt) +"PL"+ALLTRIM(SC5->C5_NUM)+".txt"  	
	nHdl 	:= fCreate(cArqTxt)
	If nHdl == -1
	    conout("O arquivo de nome nao pode ser executado! Verifique os parametros.","Atencao!")
	    Return
	Endif  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabeçalho fornecido pelo layout L07 2Alianca                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLin := "14" //TIPO REGISTRO
	
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))+;
			space(15-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))))//COD EMPR
	
	cLin += 'PED' + space(2) // tipo documento   
   
	cLin += '1    '//serie
	
	cLin += ALLTRIM(SC5->C5_NUM)+space(4) //num doc 

	If xFilial("SC5") == "01"
		cLin += "SURYARJ"+space(8)//CODIGO DEPOSITANTE
		cLin += "0000000001" //codigo estabelecimento
	Else
		cLin += "SURYASP"+space(8)//CODIGO DEPOSITANTE
		cLin += "0000000004" //codigo estabelecimento
    EndIf
	
	cLin += SF2->F2_CHVNFE+space(50-len(SF2->F2_CHVNFE))//CHAVE NFE
	
	cLin += space(50)//PROTOCOLO NFE
	
	cLin += SF2->F2_DOC+space(25-len(SF2->F2_CHVNFE)) // DOC NFE
	
	clin += CHR(13)+CHR(10)
	If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
		If !conout("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Return()
		EndIf
	EndIf
	fClose(nHdl)  
endif	
Return 
