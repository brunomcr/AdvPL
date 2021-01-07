#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDe "AvPrint.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"
#define CRLF chr(13)+chr(10)
#DEFINE STR000 "CONFIRMACAO DOS DADOS BANCARIOS"
#DEFINE STR001 "Confirme se Algum dos dados bancแrios para P.A. estใo corretos:"
#DEFINE STR002 "Se Estiverem ERRADOS, Ajuste no cadastro do Fornecedor!"
#DEFINE STR003 "BANCO 1: "
#DEFINE STR004 "AGENCIA 1: "
#DEFINE STR005 "CONTA CORRENTE 1: "
#DEFINE STR006 "BANCO 2: "
#DEFINE STR007 "AGENCIA 2: "
#DEFINE STR008 "CONTA CORRENTE 2: 
#DEFINE STR009 "OS DADOS ESTรO CORRETOS?"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออัอออออออออหอออออัออออออออออออออหออออออออัอออออออออหออออออัออออออออออปฑฑ
ฑฑบProg.  ณ MT120GRVบ Uso ณ Surya Brasil บ Modulo ณ SIGACOM บ Data ณ 22/04/18 บฑฑ
ฑฑฬอออออออออออออออออสอออออฯออออออออออออออสออออออออฯอออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.   Ponto de entrada para liberar pedidos de compra com confirmacao    บฑฑ
ฑฑบ        dos dados bancarios do fornecedor					              บฑฑ
ฑฑบ        Criar Campo no SE4 - E4_XCTRADT(1=sim;2=nao)						  บฑฑ
ฑฑบ		   Criar Parametro SB_PCFORBC - recebe formula criada para chamada	  บฑฑ
ฑฑฬอออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ      		
ฑฑบ Autor ณ Caio de Paula             บ Contato ณ(11) 98346-3154              บฑฑ
ฑฑศอออออออฯอออออออออออออออออออออออออออสอออออออออฯอออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT120GRV
Local cNum  	:= PARAMIXB[1]
Local lInclui	:= PARAMIXB[2]
Local lAltera	:= PARAMIXB[3]
Local lExclui	:= PARAMIXB[4]
Local lRet 		:= .T.
Local cForn		:= CA120FORN
Local cLoja		:= cA120Loj
Local cCond		:= cCONDICAO
Local cBanco	:= Posicione("SA2",1,xFilial("SA2")+cForn+cLoja,"A2_BANCO")
Local cAgencia	:= Posicione("SA2",1,xFilial("SA2")+cForn+cLoja,"A2_AGENCIA")
Local cContaCor	:= Posicione("SA2",1,xFilial("SA2")+cForn+cLoja,"A2_NUMCON")
Local cBanco2	:= Posicione("SA2",1,xFilial("SA2")+cForn+cLoja,"A2_XBANCO2")
Local cAgencia2	:= Posicione("SA2",1,xFilial("SA2")+cForn+cLoja,"A2_XAGENC2")
Local cContaCor2:= Posicione("SA2",1,xFilial("SA2")+cForn+cLoja,"A2_XNUMCO2")
Local cRA		:= Posicione("SE4",1,xFilial("SE4")+cCond,"E4_XCTRADT")
if lInclui .or. lAltera	
	if cRA == "1"
		if Empty(Alltrim(cBanco)) .And. Empty(Alltrim(cBanco2))
			MsgAlert("Nใo hแ Banco cadastrado para esse Fornecedor!"+CRLF+"Favor Cadastrar")
			lRet := .F.
			Return lRet
		endif
		lRet := MsgNoYes(STR001+CRLF+;
						STR002+CRLF+CRLF+;
						STR003+cBanco+CRLF+;
						STR004+cAgencia+CRLF+;
						STR005+cContaCor+CRLF+CRLF+;
						STR006+cBanco2+CRLF+;
						STR007+cAgencia2+CRLF+;
						STR008+cContaCor2+CRLF+CRLF+;
						STR009,STR000)
		if lRet
			cMSG := SuperGetMV("SB_PCFORBC",.T.,"044")
		endif 
	endif
endif
Return lRet