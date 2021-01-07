#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'DEFEMPSB.CH'

/*Confirma��o de elimina��o de residuos*/
User Function M410VRES()
Local cEmpresa	:= cEmpAnt 
Local aAreaAnt := GETAREA()
Local lRet := .F.

If cEmpresa == FC
	If IsInCallStack('Ma410Resid')
		
		If RecLock("SC5",.f.)
			SC5->C5_XSTATUS := "8"
			SC5->C5_XDESCST := "Residuo Eliminado"
			MsUnlock()    
			
			lRet := .T.
		EndIf
	
	EndIf
EndIf

RESTAREA(aAreaAnt)
	
Return lRet