#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "DEFEMPSB.CH"
user function LJ7031()
Local cEmpresa		:= cEmpAnt 
Local lOpcao := PARAMIXB[1] 


If !lOpcao
		
	If cEmpresa == RCG

		U_ATUDETAL ( )

	EndIf	
		
	StaticCall( LOJA701B, Lj7ZeraPgtos )
	//StaticCall( LOJA701B, Lj7DefPag, lCria, oPanVA3	, aPosObj4	, oEncVA,	nOpc, lTefPendCS, aTefBKPCS	, cAlterCond,lDefPagto, nVlrAcrsFi,lRegraDesc,nPerDesc,aDadosCNeg )
	
EndIf
	
	
Return 