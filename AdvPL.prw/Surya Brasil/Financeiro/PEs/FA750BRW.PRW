#Include 'RwMake.ch'
#Include 'Protheus.ch'
#Include 'TopConn.ch'
#INCLUDE "DEFEMPSB.CH"

User Function FA750BRW()
Local aArea	:= GetArea()
Local aRet	:= {}
aAdd(aRet, {'Desvinc. PAxPC',"u_LibPAxPC()",   0 , 1    }) 
RestArea(aArea)
Return aRet

User Function LibPAxPC()
Local cNum	:= ""
Local cPref	:= ""
Local cParc	:= ""
Local cForn	:= ""
Local cLoja	:= ""
Local nRec	:= SE2->(Recno())
DbSelectArea("SE2")
Dbgoto(nRec)
cNum 	:= SE2->E2_NUM
cParc	:= SE2->E2_PARCELA
cPref	:= SE2->E2_PREFIXO
cForn	:= SE2->E2_FORNECE
cLoja	:= SE2->E2_LOJA

DbSelectArea("FIE")
DbSetOrder(3)
if DbSeek(xFilial("FIE")+"P"+cForn+cLoja+cPref+cNum+cParc)
	RecLock("FIE",.F.)
		FIE->(DbDelete())
	MsUnlock()
Else
	Msgalert("Não foi possível fazer a disvinculação","FA750BRW")
Endif
Return