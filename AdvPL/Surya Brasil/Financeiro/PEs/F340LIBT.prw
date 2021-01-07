#Include 'Protheus.ch'
#INCLUDE "DEFEMPSB.CH"


User Function F340LIBT()
Local lRet 	   	:= .T. 
Local c_fil 	:= SE2->E2_FILIAL
Local cCart   	:= "P"
Local cFornece	:= SE2->E2_FORNECE
Local cLoja		:= SE2->E2_LOJA
Local cPrefixo	:= SE2->E2_PREFIXO
Local cTitulo 	:= SE2->E2_NUM
Local cParcela	:= SE2->E2_PARCELA
Local cTipo		:= SE2->E2_TIPO
Local cChvFIE	:= c_fil+cCart+cFornece+cLoja+cPrefixo+cTitulo+cParcela+cTipo //FIE_FILIAL+FIE_CART+FIE_FORNEC+FIE_LOJA+FIE_PREFIX+FIE_NUM+FIE_PARCEL+FIE_TIPO        order 3
Local cPedido	:= ""
Local dDtaBase	:= SuperGetMV("SB_DTALIB",.F.,CTOD("27/05/18")) //CRIAR COMO TIPO DATA


If ALLTRIM(SE2->E2_TIPO) == "PA" 
	if Date() <dDtaBase
		Return lRet := .T.
	endif            
	DbSelectArea("FIE")
	DbSetOrder(3)
	if DbSeek(cChvFIE)  
		cPedido := FIE->FIE_PEDIDO
		DbSelectArea("SCR")
		DbSetOrder(1)
		if DbSeek(c_fil+"PC"+cPedido)
			Do While !EOF() .And. CR_NUM == cPedido
				if SCR->CR_STATUS == "03" 
					lRet := .T.
				endif
			dbskip()
			Enddo
		endif
	else
		DbSelectArea("SCR")
		DbSetOrder(1)
		if DbSeek(c_fil+"PA"+cPrefixo+cTitulo+cParcela)
			Do While !EOF() .And. alltrim(CR_NUM) == Alltrim(cPrefixo+cTitulo+cParcela)
				if SCR->CR_STATUS == "03" 
					lRet := .T.
				endif
			dbskip()
			Enddo
		endif
	endif	           
EndIF
If !lRet
	MsgAlert("Documento não Liberado","Bloqueio de Compensacao")
endif
Return lRet