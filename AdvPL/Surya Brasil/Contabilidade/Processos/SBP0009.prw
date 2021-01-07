#INCLUDE 'Protheus.CH'

User Function SBP0009() 

Local cCadastro := OemToAnsi("Ajusta Data Contabiliza TXT")
Local aSays:={}, aButtons:={}
Local nOpca     := 0 
LOCAL cPerg		:= "XJCTBA"
local dDtCV		:= CtoD("  /  /  ")
AADD(aSays,OemToAnsi( "Este programa ira fazer o ajuste de data de lançamento conforme arquivo"))

AjustaSx1(cPerg)
AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. )}})
AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch()}})
AADD(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch()}})

FormBatch( cCadastro, aSays, aButtons )
If nOpca == 1
     Processa( { |lEnd| AjCt2ctba() })
EndIf
Return
          
Static Function AjCt2ctba()  
local nTotReg,i	:= 0
local cAlias	:= "AJQRY" 

If Select(cAlias) <> 0
	dbSelectArea(cAlias)
	dbCloseArea()
EndIf

BEGINSQL ALIAS cAlias
     SELECT *
     FROM %TABLE:CT2% CT2
     WHERE CT2_FILIAL = %EXP:XFILIAL("CT2")%
     AND CT2_LOTE BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
     AND CT2_DATA BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04% 
     AND CT2.%notdel%       
ENDSQL 


nTotReg := Contar(cAlias,"!Eof()")
(cAlias)->(DbGoTop()) 
ProcRegua(nTotReg)

Do While (cAlias)->(!EOF())
	IncProc("Validando registro "+AllTrim(Str(i))+" de "+AllTrim(Str(nTotReg))) 
	DbSelectArea("CT2")
	DbGoTo((cAlias)->(R_E_C_N_O_))
	IF ALLTRIM(CT2->CT2_ROTINA) == 'CTBA500'
		IF !empty(CT2->CT2_DTCV3)
			RecLock("CT2",.F.)
				CT2->CT2_DATA := CT2->CT2_DTCV3
			MsUnlock()
		else
			DbGoTo((cAlias)->(R_E_C_N_O_)-1)
			dDtCV := CT2->CT2_DTCV3
			DbGoTo((cAlias)->(R_E_C_N_O_))
			RecLock("CT2",.F.)
				CT2->CT2_DATA := dDtCV
			MsUnlock()			
		endif
	ENDIF  
	(cAlias)->(DbSkip())
Enddo 
If Select(cAlias) <> 0
	dbSelectArea(cAlias)
	dbCloseArea()
EndIf	
Return 
 
Static Function AjustaSx1(cPerg)
u_xPutSX1(cPerg,"01"   ,"Do Lote ?"		,"Lote ?"	 	,"Lote ?"	    ,"mv_ch1"	,"C"	,6		,0		,0		,"G","","  ","","","mv_par01","","","","","","","","","","","","","","","","",{"Informe o numero do Lote de","",""},{},{})
u_xPutSX1(cPerg,"02"   ,"Ate o Lote ?"		,"Lote ?"	 	,"Lote ?"		,"mv_ch2"	,"C"    ,6		,0		,0		,"G","","  ","","","mv_par02","","","","","","","","","","","","","","","","",{"Informe o numero do Lote ate","",""},{},{})
u_xPutSX1(cPerg,"03"   ,"Data Inicial"	,"Emissao Inicial"	,"Emissao Inicial"	,"mv_ch3","D",08,0,0,"G","","  ","","","mv_par03","","","","","","","","","","","","","","","","",{"","",""},{},{})
u_xPutSx1(cPerg,"04"	,"Data Final"	,"Emissao Final"    ,"Emissao Final"	,"mv_ch4","D",08,0,0,"G","","  ","","","mv_par04","","",  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,{"","",""},{},{})
Return


