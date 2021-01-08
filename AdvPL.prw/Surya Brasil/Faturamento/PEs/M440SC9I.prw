#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "DEFEMPSB.CH"

User Function M440SC9I
local cEmpresa:= cEmpAnt
local cCust	:= SC5->C5_CLIENTE
local cCanal:= .T.
local lBlk	:= .T.
if cEmpresa == FC
	cCanal := SC5->C5_XCANSAI $ '2-5-6-7-8-9-A'
	if !cCanal
		lBlk := ValFin(cCust)
		if !lBlk
		   RecLock("SC9",.F.)
		      SC9->C9_BLCRED := "02"
		   MsUnlock("SC9")
		Endif
	endif
Endif
Return
	
Static Function ValFin(cCust)
	local cQuery := ""
	Local lRet := .T.
	Local _cAlias 		:= GetNextAlias()
	cQuery := "SELECT * FROM "+RETSQLNAME("SE1") + " SE1"
	cquery += " WHERE SE1.D_E_L_E_T_ = '' AND SE1.E1_CLIENTE = '"+cCust+"'"
	cQuery += " AND E1_SALDO > 0 AND E1_TIPO = 'NF'"
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), _cAlias, .F., .T. )	
	If  (_cAlias)->(!EOF())
		lRet := .F.
	EndIf	
	If Select(_cAlias) >0
		dbSelectArea(_cAlias)
	    dbCloseArea()    
	EndIf	
Return lRet