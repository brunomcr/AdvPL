#include 'protheus.ch'
#include 'parmtype.ch'

User Function TITICMST()

Local	cOrigem		:=	PARAMIXB[1]
Local	cTipoImp	:=  PARAMIXB[2]

	If AllTrim(cOrigem)='MATA460A'	//Apuracao de ISS
		//SE2->E2_NUM		:=	SE2->(Soma1(E2_NUM,Len(E2_NUM)))
		SE2->E2_VENCTO  := dDataBase	
		SE2->E2_VENCREA := DataValida(dDataBase, .T.)
		IF SELECT("SF6") > 0
			if SF6->F6_NUMERO <> SE2->E2_PREFIXO+SE2->E2_NUM	
				IF SE2->E2_PREFIXO == "ICM"
					RECLOCK("SF6",.F.)
						SF6->F6_NUMERO := SE2->E2_PREFIXO+SE2->E2_NUM
					SF6->(MSUNLOCK())
				ENDIF
			ENDIF
		endif
	EndIf    //EXEMPLO 2 (cTipoImp)If AllTrim(cTipoImp)='3' // ICMS ST	  SE2->E2_NUM := SE2->(Soma1(E2_NUM,Len(E2_NUM)))	  SE2->E2_VENCTO := DataValida(dDataBase+30,.T.)	  SE2->E2_VENCREA := DataValida(dDataBase+30,.T.)EndIfReturn {SE2->E2_NUM,SE2->E2_VENCTO}	
Return {SE2->E2_NUM,SE2->E2_VENCTO}	