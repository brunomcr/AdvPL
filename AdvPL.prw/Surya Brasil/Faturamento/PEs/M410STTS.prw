#INCLUDE "PROTHEUS.CH"
#INCLUDE "DEFEMPSB.CH"


User Function M410STTS()
Local aAreaSC5 	:= SC5->(GetArea())
lOCAL cCliente 	:= SC5->C5_CLIENTE
Local cLOjaCli	:= SC5->C5_LOJACLI   
local cPedido	:= SC5->C5_NUM
local cClilib	:= SuperGetMv("SB_CLILIB",.F., "000008/000024/000116")
local cEmpresa	:= cEmpAnt 
Local cEst		:= Posicione("SA1",1,xFilial("SA1")+cCliente+cLOjaCli,"A1_EST")
if ALTERA .OR. INCLUI
	IF cEmpresa == FC
		if  !Empty(alltrim(SC5->C5_XMAGCOD))
			If RecLock("SC5",.f.)
				SC5->C5_APROV := "S"
				SC5->C5_USUAPR := "AUTCLI"
				SC5->C5_HRAPROV := Left(Time(),5) // Grava Hora no formato HH:MM
				SC5->C5_DTAPRO := MsDate()
				MsUnlock()             
			Endif        
			DbSelectArea("SC9")
			DbSetOrder(1)
			If dbseek(xfilial("SC9")+cPedido)
				Do While !EOF() .And. SC9->C9_PEDIDO = cPedido
					RecLock("SC9",.f.) 
						SC9->C9_XCANAL	:= 'ECOMMERCE'
						SC9->C9_XEST	:= cEst
					MsUnlock() 
					SC9->(Dbskip())
				enddo
			endif		
		Else
			If cCliente $ cClilib
				Reclock("SC5",.F.)
				SC5->C5_APROV := "S"
				MsUnlock() 
			Else
				Reclock("SC5",.F.)
				SC5->C5_APROV := "N"
				MsUnlock() 
			Endif
			DbSelectArea("SC9")
			DbSetOrder(1)
			If dbseek(xfilial("SC9")+cPedido)
				Do While !EOF() .And. SC9->C9_PEDIDO = cPedido
					RecLock("SC9",.f.)						
						SC9->C9_XEST	:= cEst
					MsUnlock() 
					SC9->(Dbskip())
				enddo
			endif	
		Endif 
	elseif cEmpresa == VEDIC
		if cCliente $ cClilib
			Reclock("SC5",.F.)
				SC5->C5_APROV := "S"
			MsUnlock() 
		else
			Reclock("SC5",.F.)
				SC5->C5_APROV := "N"
			MsUnlock() 
		endif  
	else
		If RecLock("SC5",.f.)
			SC5->C5_APROV := "N"
			MsUnlock()             
		Endif
	endif

endif

If IsInCallStack('A410COPIA')
	If RecLock("SC5",.f.)
		SC5->C5_XEMILOG := SToD("  /  /    ")
		SC5->C5_XRASTRE := ''
		SC5->C5_XPROCLG := SToD("  /  /    ")
		SC5->C5_XSTATUS := ''
		SC5->C5_XDESCST := ''
		MsUnlock()    
	ENDIF
EndIf

RestArea(aAreaSC5) 
Return 