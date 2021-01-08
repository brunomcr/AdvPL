#INCLUDE "PROTHEUS.CH"
#INCLUDE "DEFEMPSB.CH"
User Function MT094END()

Local cDocto    := PARAMIXB[1] 
Local cTipo     := PARAMIXB[2]
Local nOpc      := PARAMIXB[3]
Local cFilDoc   := PARAMIXB[4]
//teste renan
if cTipo $ "PC,NF,SA,IP,AE"
	if nOpc==1
		U_Env094(cDocto,cTipo,"03")
	elseif nOpc == 5
		U_Env094(cDocto,cTipo,"06")
	endif
endif
Return