#INCLUDE "PROTHEUS.CH"
#INCLUDE "DEFEMPSB.CH"

User Function MT094LOK
local lRet 		:= .T.
local cStatus	:= ""
local cNum		:= SCR->CR_NUM
local cTipo		:= SCR->CR_TIPO
	If SCR->CR_TIPO $ "PA"
		lRet 		:= .F.
		cStatus 	:= U_TlApr094()
		If cStatus <> ""
			U_Env094(cNum,cTipo,cStatus)
		endif
	Endif
Return lRet
                                      
