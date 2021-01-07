#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

User Function NWVERQTD()
Local lRet      := .T.
Local nPosProd  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
Local nQtdVen   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})//nPosQtdVen   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
Local aAmz      := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCAL"})
Local nQtdDisp  := 0

If !Empty(aCols[n][nPosProd]) .AND. !Empty( aCols[n][aAmz] )
	If acols[n][nQtdVen] > ( nQtdDisp:= Posicione("SB2",1,xFilial("SB2")+aCols[n][nPosProd]+aCols[n][aAmz],"SaldoSb2()") )
		MsgInfo("Quantidade em estoque insuficiente! Por Favor Avisar a Logistica! "+ Chr(13) + Chr(10) +"Disponível no local " + aCols[n][aAmz] + " atual é de: " + Chr(13) + Chr(10) + Alltrim(Transform(nQtdDisp, "@E 999,999,999.99")) ,"Aviso")
		aCols[n][nQtdVen] := 0
		M->C6_QTDVEN 	  := 0
		lRet:= .T.
	EndIf
	If IsInCallStack("MATA410") .AND. ( INCLUI .OR. ALTERA )
		oGetDad:oBrowse:Refresh()
	EndIf
EndIf

Return(lRet)
//Tem q colocar na validação do campo C6_LOCAL também
//pq se o usuario trocar o almoxarifado tb tem q validar a quantidade
