#include 'protheus.ch'
#include 'parmtype.ch'

User Function DADOSTIT()  
Local	aTeste		:= {}
Local	cOrigem		:=	PARAMIXB[1]
	If AllTrim(cOrigem)=="MATA460A"	//Apuracao de ISS
		//aTeste	:=	{"9999999999", DataValida(dDataBase+30,.T.)}
		SF6->F6_DTVENC  := dDataBase	
	EndIf 
	
Return {SF6->F6_NUMERO,SF6->F6_DTVENC}