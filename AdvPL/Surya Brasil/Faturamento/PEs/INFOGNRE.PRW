#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch" 
#INCLUDE "DEFEMPSB.CH"

//Alteaçao de dados da GNRE.. quando for bahia altera referencia
User Function INFOGNRE
Local lRet 	:= .T.	 
Local cEst	:= SF6->F6_EST

if cEst == "BA"   
	RecLock("SF6",.F.)	
		SF6->F6_REF := "1"
	SF6->(MsUnlock())
Endif
Return(lRet)