#INCLUDE "PROTHEUS.CH"
#INCLUDE "DEFEMPSB.CH"
//Ponto de Entrada após a gravação do Titulo 
User Function F100BROW

AAdd( aRotina, { "Alt. Dt Disponibilidade", "U_AtuDtDsp", 0, 1 } )

Return

User Function AtuDtDsp()
Local lContinua := .F. 
Local oData		
Local dData	:= CTOD("  /  /  ")
Local oGet1
Local cGet1 := "Define variable value"
Local oSButton1
Local cIdMov	:= "" 
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Insira nova data" FROM 000, 000  TO 180, 180 COLORS 0, 16777215 PIXEL

    @ 034, 012 MSGET oGet1 VAR dData SIZE 048, 010 OF oDlg PICTURE "@D" COLORS 0, 16777215 PIXEL HASBUTTON
    DEFINE SBUTTON oSButton1 FROM 048, 049 TYPE 01 ACTION (lContinua := .t., oDlg:End())  OF oDlg ENABLE

  ACTIVATE MSDIALOG oDlg CENTERED

If lContinua 
	RecLock("SE5",.F.) 
		SE5->E5_DTDISPO := dData 
	MsUnlock() 
	cIdMov	:= SE5->E5_IDORIG
	DbSelectArea("FK5")
	DbSetOrder(1)
	if DbSeek(SE2->E2_FILIAL+cIdMov)
		RecLock("FK5",.F.)
			FK5->FK5_DTDISP	:= dData
		MsUnlock()
	endif
	mSGaLERT("Data de disponibilidade alterada")
Endif 

Return 