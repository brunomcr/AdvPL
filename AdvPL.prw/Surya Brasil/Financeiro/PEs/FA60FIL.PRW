#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "DEFEMPSB.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออัอออออออออหอออออัออออออออออออออหออออออออัอออออออออหออออออัออออออออออปฑฑ
ฑฑบProg.  ณ M460FIM บ Uso ณ Surya Brasil บ Modulo ณ SIGAFAT บ Data ณ 08/03/18 บฑฑ
ฑฑฬอออออออุอออออออออสอออออฯออออออออออออออสออออออออฯอออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.  ณ Ponto de entrada para filtro no bordero de contas a receber		  บฑฑ
ฑฑบ       ณ                                                                   บฑฑ
ฑฑฬอออออออุอออออออออออออออออออออออออออหอออออออออัอออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor ณ Caio de Paula             บ Contato ณ(11) 98346-3154              บฑฑ
ฑฑศอออออออฯอออออออออออออออออออออออออออสอออออออออฯอออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FA60FIL()
local cEmpresa	:= cEmpAnt 
local _cCond	:= ""
if cEmpresa = FC
	cPerg := "FA060F"
	AjustaSx1(cPerg)
	While .T.
		IF Pergunte(cPerg,.T.)
			Exit
		Endif
	EndDo
	
	DbSelectArea("SE1")       
	
	_cCond := " E1_XFORMA = '"+mv_par01+"' 
ENDIF
Return(_cCond)


Static Function AjustaSx1(cPerg)
u_xPutSX1(cPerg	,"01"	,"Forma pagto:","                  ", "             ",    "mv_ch1"	,"C",    5			,0			,0		,"G"	,""		,"mv_par1"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,"ZY"		,""		,""		,""	)
Return
