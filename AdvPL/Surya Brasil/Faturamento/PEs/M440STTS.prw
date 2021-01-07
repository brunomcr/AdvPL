#INCLUDE "PROTHEUS.CH"
#INCLUDE "DEFEMPSB.CH"

User Function M440STTS()
Local aAreaSC5 	:= SC5->(GetArea())
local cPedido	:= SC5->C5_NUM
local cEmpresa	:= cEmpAnt 
Local lToCli 	:= .f.
Local nLimCred	:= SA1->A1_LC
lOCAL nTotPed	:= 0

If cEmpresa == FC
	lToCli 	:= SC5->C5_XCANSAI $ '2/5/6/7/8/9/A'
	if !lToCli
		DbSelectArea("SC9")
		DbSetOrder(1)
		If dbseek(xfilial("SC9")+cPedido)
			Do While !EOF() .And. SC9->C9_PEDIDO = cPedido
				RecLock("SC9",.f.) 
					SC9->C9_XCANAL := 'ECOMMERCE'
				MsUnlock() 
				SC9->(Dbskip())
			EndDo
		EndIf	
	Else
		If !!lToCli
			DbSelectArea("SC9")
			DbSetOrder(1)
			If dbseek(xfilial("SC9")+cPedido)
				Do While !EOF() .And. SC9->C9_PEDIDO = cPedido
					nTotPed += (SC9->C9_QTDLIB*SC9->C9_PRCVEN)
					SC9->(Dbskip())
				EndDo
			EndIf
			If nTotPed > nLimCred .And. nLimCred > 0
				DbSetOrder(1)
				If dbseek(xfilial("SC9")+cPedido)	
					Do While !EOF() .And. SC9->C9_PEDIDO = cPedido
						RecLock("SC9",.f.) 
							SC9->C9_BLCRED := '02'
						MsUnlock()
						SC9->(Dbskip())
					EndDo
				EndIf				
			EndIf
		EndIf
	EndIf
EndIf               
RestArea(aAreaSC5)
Return 