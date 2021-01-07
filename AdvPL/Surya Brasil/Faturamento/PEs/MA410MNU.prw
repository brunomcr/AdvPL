#include "protheus.ch"
#include "rwmake.ch"
#INCLUDE "DEFEMPSB.CH"

/*
Programa ...: MA410MNU.Prw
Uso ........: P.E. para Inclusão do botão de aprovador
Data .......: 11/01/2013
Feito por ..: Caio de Paula
*/

User Function MA410MNU()
local nPosCB := 0   
Local cEmpresa := cEmpAnt
Aadd(aRotina,{'Picking List','u_Pick()' , 0 , 3,0,NIL})  
if cEmpresa == FC
	aadd(aRotina,{'Importa Volume'	 ,'u_SBP0006' , 0  , 3,0,NIL})
	aadd(aRotina,{'Imp. Volume Ecom' ,'u_SBE0001' , 0  , 3,0,NIL}) 
	aadd(aRotina,{'Imp. Cod Rastreio','u_SPFAT001' , 0 , 3,0,NIL}) 
	aadd(aRotina,{'Gerar Etiqueta'	 ,'u_WSFAT002' , 0 , 3,0,NIL})
	aadd(aRotina,{'Tracking Transporte'	 ,'u_WSSTAT01' , 0 , 3,0,NIL})
Endif 
nPosCB := ASCAN(aRotina, { |x| UPPER(x[1]) == "COD.BARRA" })
if nPosCB > 0
	aDel(aRotina,nPosCB)
	aSize(aRotina,len(aRotina)-1)
endif
Return()


/*
Programa ...: fAprovaPV.Prw
Uso ........: P.E. para Inclusão do botão de aprovador
Data .......: 11/01/2013
Feito por ..: Surya
*/                      

User Function Pick()                      
Local oGroup1
Local oRadMenu1
Local nRadMenu1 := 1 
local nOpca := 0
Local oSay1
Local oSay2
Local oSay3
Local oSButton1
Local oSButton2
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "PICKING LIST" FROM 000, 000  TO 212, 500 COLORS 0, 16777215 PIXEL

    @ 004, 003 GROUP oGroup1 TO 103, 246 PROMPT "  RELATÓRIO DE PICKING LIST  " OF oDlg COLOR 0, 16777215 PIXEL
    @ 018, 018 SAY oSay1 PROMPT "Este Programa tem como objetivo a impressão de picking list" SIZE 221, 038 OF oDlg COLORS 0, 16777215 PIXEL
    @ 009, 000 SAY oSay2 PROMPT "Aqui voce poderá escolher se quer imprimir em PDF ou em TXT para Integracao com a Logística" SIZE 217, 009 OF oSay1 COLORS 0, 16777215 PIXEL
    @ 041, 018 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "PDF","TXT" SIZE 025, 020 OF oDlg COLOR 0, 16777215 PIXEL
    @ 066, 017 SAY oSay3 PROMPT "Obs.: O arquivo TXT será salvo na pasta Logística\RNC" SIZE 210, 015 OF oDlg COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 082, 020 TYPE 01 OF oDlg ENABLE ACTION ( nOpca := nRadMenu1, oDlg:End() )
    DEFINE SBUTTON oSButton2 FROM 082, 051 TYPE 02 OF oDlg ENABLE ACTION ( nOpca := 0, oDlg:End() )
  ACTIVATE MSDIALOG oDlg CENTERED

if nOpca == 1     
	U_SRFAT002()
elseif nOpca == 2  
	U_SBPEST001()
else
	Return
endif

Return
