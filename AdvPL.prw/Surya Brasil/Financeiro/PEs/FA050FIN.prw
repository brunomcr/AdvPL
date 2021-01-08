#INCLUDE "PROTHEUS.CH"
#INCLUDE "DEFEMPSB.CH"
//Ponto de Entrada após a gravação do Titulo 
User Function FA050FIN()
Local cGrpAprov	:= SuperGetMV("SB_GAPROVPA",.F.,"000001")
Local aDadosPa	:= {} 
Local cIdMov	:= "" 

If Alltrim(SE2->E2_TIPO) = "PA" .And. Alltrim(SE2->E2_ORIGEM) == "FINA050" 
	if !IsInCallStack("A120ADIANT")
		AADD(aDadosPa,SE2->E2_FILIAL) //1
		AADD(aDadosPa,SE2->E2_TIPO)
		AADD(aDadosPa,SE2->E2_PREFIXO)
		AADD(aDadosPa,SE2->E2_NUM)  //4
		AADD(aDadosPa,SE2->E2_PARCELA)
		AADD(aDadosPa,SE2->E2_FORNECE)
		AADD(aDadosPa,SE2->E2_LOJA)  //7
		AADD(aDadosPa,SE2->E2_SALDO)
		AADD(aDadosPa,SE2->E2_EMISSAO)
		AADD(aDadosPa,cGrpAprov)// 10
		AADD(aDadosPa,SE2->E2_HIST)
		AADD(aDadosPa,SE2->E2_MOEDA)
		U_GrvLibDoc(aDadosPa) 
		if MsgYesNo("Deseja relacionar este titulo a um pedido de compra?","Relacionar Pedidos")
			U_RelacPAPC(aDadosPa)
		endif
	endif
	DbSelectArea("SE5")
	DbSetOrder(2)
	if DbSeek(SE2->E2_FILIAL+"PA"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+ DTOS(SE2->E2_EMISSAO) +SE2->E2_FORNECE+SE2->E2_LOJA)
		RecLock("SE5",.F.)
			SE5->E5_DTDISPO	:= SE2->E2_VENCREA
		MsUnlock()
		cIdMov	:= SE5->E5_IDORIG
	endif
	DbSelectArea("FK5")
	DbSetOrder(1)
	if DbSeek(SE2->E2_FILIAL+cIdMov)
		RecLock("FK5",.F.)
			FK5->FK5_DTDISP	:= SE2->E2_VENCREA
		MsUnlock()
	endif
EndIf 

Return(Nil)  

           