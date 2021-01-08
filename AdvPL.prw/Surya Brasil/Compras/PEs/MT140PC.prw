#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDe "AvPrint.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออัอออออออออหอออออัออออออออออออออหออออออออัอออออออออหออออออัออออออออออปฑฑ
ฑฑบProg.  ณ MT140PC บ Uso ณ Surya Brasil บ Modulo ณ SIGACOM บ Data ณ 22/02/18 บฑฑ
ฑฑฬอออออออุอออออออออสอออออฯออออออออออออออสออออออออฯอออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.  ณ Ponto de entrada para liberar as pre-notas de pedido de compra 	  บฑฑ
ฑฑบ       ณ para empresas especificas no parametro SB_FLIBXML                 บฑฑ
ฑฑฬอออออออุอออออออออออออออออออออออออออหอออออออออัอออออออออออออออออออออออออออออนฑฑ      		
ฑฑบ Autor ณ Caio de Paula             บ Contato ณ(11) 98346-3154              บฑฑ
ฑฑศอออออออฯอออออออออออออออออออออออออออสอออออออออฯอออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT140PC()
Local ExpL1 	:= PARAMIXB[1]  
Local cFornece	:= CA100FOR
Local cFornLib	:= SuperGetMv("SB_FLIBXML",.T.,"")
Local cTes		:= SuperGetMv("SB_TLIBXML",.T.,"013")
IF cFornece $ cFornLib
	ExpL1 := .F.
endif
Return ExpL1