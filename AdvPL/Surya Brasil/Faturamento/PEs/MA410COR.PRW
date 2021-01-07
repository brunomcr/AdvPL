#include "Protheus.ch"
#include "TOPCONN.ch"
#INCLUDE "DEFEMPSB.CH"

USer FuncTion MA410COR()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA410COR  ºAutor  ³  Caio de Paula     º Data ³  11/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada alteracao cores browse pedido de venda    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Local cEmpresa	:= cEmpAnt 
Local a_Ret := ParamIxb

/*
a_Ret := {  {"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. !U_XMA410PARC() .And. ! U_XMARES() .And. C5_APROV = 'N'",'ENABLE' },;		    // Pedido em Aberto
			{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. !U_XMA410PARC() .And. ! U_XMARES() .And. C5_APROV = 'L'",'BR_VERDE_ESCURO' },;
			{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. !U_XMA410PARC() .And. ! U_XMARES() .And. C5_APROV = 'S'",'BR_MARROM' },;
			{ "(!Empty(C5_NOTA).Or.C5_LIBEROK=='E') .And. Empty(C5_BLQ) .And. !U_XMA410PARC() .And. ! U_XMARES()" ,'DISABLE'},;		    // Pedido Encerrado
			{ "!Empty(C5_LIBEROK).And. Empty(C5_NOTA).And. Empty(C5_BLQ) .And. !U_XMA410PARC() .And. ! U_XMARES() .And. !U_XMABLEST()",'BR_AMARELO'},;	// Pedido Liberado por Completo
			{ "!Empty(C5_LIBEROK).And. Empty(C5_NOTA).And. Empty(C5_BLQ) .And. !U_XMA410PARC() .And. ! U_XMARES() .And. U_XMABLEST()" ,'BR_PRETO'},;	// Pedido com Bloqueio de Estoque
			{ "U_XMA410PARC() .And. ! U_XMARES()" ,'BR_PINK'},;	                    // Pedido parcialmente entregue
			{ "U_XMARES()" ,'BR_BRANCO'}
		  }
*/
If cEmpresa == FC
	a_Ret := {  {"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. ! U_XMARES() .And. C5_APROV = 'N'",'BR_VERDE' },; // Pedido em Aberto
	  			{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. !U_XMA410PARC() .And. ! U_XMARES() .And. C5_APROV = 'S'",'BR_VERDE_ESCURO' },;  // Pedido Aprovado
				{ "!Empty(C5_LIBEROK).And. Empty(C5_NOTA).And. Empty(C5_BLQ) .And. !U_XMA410PARC() .And. ! U_XMARES() .And. !U_XMABLEST()",'BR_AMARELO'},;	// Pedido Liberado
				{ "C5_XSTATUS = '1' ",'BR_MARRON_OCEAN'},;	// Picking Enviado
				{ "C5_XSTATUS = '2' ",'BR_LARANJA'},;	// Picking Separado
				{ "!Empty(C5_LIBEROK).And. !Empty(C5_NOTA) .And. !Empty(C5_SERIE) .And. Empty(C5_BLQ) .And. !U_XMA410PARC() .And. ! U_XMARES()",'BR_VIOLETA'},;	// Pedido de Venda Faturado
				{ "C5_XSTATUS = '4' ",'BR_AZUL_CLARO'},;	// Somente NFe Enviado
				{ "C5_XSTATUS = '5' ",'BR_AZUL'},;	// Somente Etiqueta Enviado
				{ "C5_XSTATUS = '9' ",'BR_CINZA'},;	// NFe e Etiqueta enviados
				{ "C5_XSTATUS = '6' ",'BR_PINK'},;	// Pedido de Venda Coletado
				{ "C5_XSTATUS = '7' ",'BR_VERMELHO'},;	// Pedido de Venda Concluído
				{ "C5_XSTATUS = '11' ",'BR_MARROM'},;	// Concluído com Residuo Eliminado
				{ "C5_XSTATUS = '10' ",'BR_PRETO'},;	// Objeto de Rastreio Inativo
				{ "U_XMARES()" ,'BR_BRANCO'} } //Residuo

EndIf

Return(a_Ret)	 

/*-----------------------------------------------*/
User FuncTion XMA410PARC()
/*-----------------------------------------------*/
Local l_Parcial := .F.
Local _aAreaSC5 := SC5->(GetArea())
Local _cPedido  := SC5->C5_NUM       
Local _aFat     := {}
Local _lFat     := .F.
Local _cFil     := SC5->C5_FILIAL

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(_cFil + _cPedido )
//While ! Eof() .And. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6") + _cPedido 
While ! Eof() .And. SC6->C6_FILIAL + SC6->C6_NUM == _cFil + _cPedido 
	If SC6->C6_QTDENT > 0
		_lFat     := .T.
	EndIf	
	aadd(_aFat,{SC6->C6_QTDVEN,SC6->C6_QTDENT})
	DbSkip()
EndDo
If _lFat
	For nF := 1 To Len(_aFat)
//		If _aFat[nF][2] == 0 .Or. (_aFat[nF][2] <> 0 .And. _aFat[nF][2] < _aFat[nF][1])
		If _aFat[nF][2] == 0 .Or. (_aFat[nF][2] <> 0 .And. _aFat[nF][2] < _aFat[nF][1])
			l_Parcial := .T.
			Exit
		EndIf		
    Next
EndIf    

RESTAREA(_aAreaSC5)

Return(l_Parcial)


/*-----------------------------------------------*/
User FuncTion XMARES()
/*-----------------------------------------------*/
Local l_Res := .F.
Local _aAreaSC5 := SC5->(GetArea())
Local _cPedido  := SC5->C5_NUM  
Local _cFil     := SC5->C5_FILIAL


xQry := " SELECT COUNT(*) AS NREG FROM " + RetSqlName("SC6")
xQry += "  WHERE D_E_L_E_T_ = '' AND "
//xQry += "   C6_FILIAL = '" + xFilial("SC6") + "' AND "
xQry += "   C6_FILIAL = '" + _cFil + "' AND "
xQry += "   C6_NUM = '" + _cPedido + "' AND C6_BLQ = 'R'"
	    
If Select("QRY2") <> 0
	DbSelectArea("QRY2")
	DbCloseArea("QRY2")
EndIf
		
TcQuery xQry New Alias "QRY2"
        
DbSelectArea("QRY2")
QRY2->(DbGoTop())
If ! QRY2->(Eof()) 
	If QRY2->NREG > 0
		l_Res := .T.
	EndIf
EndIf

RESTAREA(_aAreaSC5)
Return(l_Res)


User FuncTion XMABLEST()
/*-----------------------------------------------*/
Local l_Parcial := .F.
Local _aAreaSC5 := SC5->(GetArea())
Local _cPedido  := SC5->C5_NUM       
Local _aFat     := {}
Local _lFat     := .F.
Local _cFil     := SC5->C5_FILIAL

DbSelectArea("SC9")
DbSetOrder(1)
If DbSeek(_cFil + _cPedido )
//While ! Eof() .And. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6") + _cPedido 
	While ! Eof() .And. SC9->C9_FILIAL + SC9->C9_PEDIDO == _cFil + _cPedido 
		If ALLTRIM(SC9->C9_BLEST) $ "02/03" 
			l_Parcial     := .T.
		EndIf
		DbSkip()
	EndDo
endif  
RESTAREA(_aAreaSC5)

Return(l_Parcial)