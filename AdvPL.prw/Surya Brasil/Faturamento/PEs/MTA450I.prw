#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "DEFEMPSB.CH"

User Function MTA450I
local cEmpresa:= cEmpAnt
local cNUM	:= SC9->C9_PEDIDO
local cCanal:= .T.
local lBlk	:= .T.
if cEmpresa == FC
	cCanal := SC5->C5_XCANSAI $ '2-4-5-6-7-8-9-A'
	if !cCanal
		DbSelectArea("SC9")
		DbSetOrder(1)
		if Dbseek(xFilial("SC9")+cNUM)
			Do While !EOF() .and. SC9->C9_PEDIDO == cNUM
			   RecLock("SC9",.F.)
			      SC9->C9_BLCRED := ""
			   MsUnlock("SC9")
			   SC9->(DbSkip())
			Enddo
		endif
	endif
Endif
Return
	
