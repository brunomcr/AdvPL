#include "protheus.ch"
#include "rwmake.ch"
#INCLUDE "DEFEMPSB.CH"

/*
Programa ...: MA410MNU.Prw
Uso ........: P.E. para Inclusão do botão de aprovador
Data .......: 11/01/2013
Feito por ..: Caio de Paula
*/
User Function A410CONS()
Local aBut	:= {}
Local cEmpresa := cEmpAnt
if IsInCallStack("A410VISUAL")
	aAdd(aBut,{"AprovaPV", {|| U_fAprovaPV()},"Aprovacao PV","Aprovacao PV" } ) 
endif
Return aBut

User Function fAprovaPV()     
Local cAprov := GetMv("MV_SURYAPV")

If Upper(Alltrim(UsrRetName(RetCodUsr()))) $ Upper(Alltrim(cAprov))
	If !Empty(SC5->C5_NOTA)
		MsgBox("o pedido já foi faturado, não há o que fazer.", "FAPROVPV")
		Return()
	Endif
	If SC5->C5_APROV == "S"			
		If MsgYesNo("Pedido já aprovado, deseja voltar atrás na decisão?", "FAPROVPV")
			If RecLock("SC5",.F.)
				SC5->C5_APROV := "N"
				MsUnLock()	
				MsgAlert("Pedido desaprovado.","FAPROVPV")	
			Endif
		Endif
	Else 
		if SC5->C5_APROV == "L" .And. Upper(Alltrim(UsrRetName(RetCodUsr()))) $ Upper(Alltrim(cAprov)) .And. !__cUserID $ GetMv("SB_APROVPV") 
			If MsgYesNo("Pedido já aprovado, deseja voltar atrás na decisão?", "FAPROVPV")
				If RecLock("SC5",.F.)
					SC5->C5_APROV := "N"
					MsUnLock()	
					MsgAlert("Pedido desaprovado.","FAPROVPV") 
					return	
				Endif
			Endif
		endif
		If MsgYesNo("Confirma aprovação?", "FAPROVPV")
			If RecLock("SC5",.F.)
				if __cUserID $ GetMv("SB_APROVPV")
					SC5->C5_APROV := "S"
				else
					SC5->C5_APROV := "L"
				endif
				SC5->C5_HRAPROV := Left(Time(),5) // Grava Hora no formato HH:MM
				SC5->C5_DTAPRO := MsDate()
				SC5->C5_USUAPR := RetCodUsr()
				MsUnLock()
			Endif
			MsgAlert("Pedido aprovado.","FAPROVPV")	
		Endif
	Endif
Else
	MsgAlert("Usuário sem permissão para aprovar pedidos de vendas.","FAPROVPV")
Endif
Return