#include "TOTVS.CH"
#include "tbicode.ch"
#include "tbiconn.ch"
#include "topconn.ch"     
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE "DEFEMPSB.CH"
#DEFINE CRLF Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460QRY     บAutor  ณMicrosiga         บ Data ณ  01/30/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFiltro na preparacao do Documento de saida                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M460QRY()
                                       
Local _cFiltro:= paramixb[1]    
Local _nTipo  := 0 
Local _aSaldo := {}                               
Local _nSC9QtLib := 0 
LOcal oDlg
LOcal oButton1
LOcal oGet1
LOcal cGet1 := "11"
LOcal oGroup1    
lOCAL aAuxProd := {}
LOCAL APEDSC9 := {} 
local cQuery	:= "" 
Local aRadio := {}  
LOCAL cCanal := ""   
Local cEmpresa := cEmpAnt   
Private nRadio := 2   
Public cType := ""
Public n_Tipo := 0  
	
if cEmpresa == FC
	_nTipo := Aviso("Filtro para pedidos por estado","Filtra pedidos por estado ?", { "Nao", "Sim" }, 1)
	If _nTipo == 2 
		DEFINE MSDIALOG oDlg TITLE "Escolha o Estado" FROM 000, 000  TO 100, 200 COLORS 0, 16777215 PIXEL
	    @ 003, 002 GROUP oGroup1 TO 045, 096 PROMPT "Informe o Estado    " OF oDlg COLOR 0, 16777215 PIXEL
	    @ 020, 008 MSGET oGet1 VAR cGet1 SIZE 017, 010 F3 "12" VALID iif(cGet1=="FS",.T.,ExistCpo("SX5","12"+cGet1)) OF oDlg  COLORS 0, 16777215 PIXEL PICTURE "@!"
	    oGet1:bHelp := {||    ShowHelpCpo(    "oGet1",;
                                {"Para trazer todos estados exceto SP Digite FS"},2)}
	    DEFINE SBUTTON oButton1 FROM 015, 046 TYPE 01 OF oDlg ENABLE ACTION {cType:= cGet1,oDlg:End()}
	    ACTIVATE MSDIALOG oDlg   CENTERED
	    cType := UPPER(cType)
	    IF cType == "FS"
	    	_cFiltro := _cFiltro +" AND C9_XEST <> 'SP' "
	    else
	    	_cFiltro := _cFiltro +" AND C9_XEST = '"+cType+"' "
	    Endif     
		nOrdNFS  := 1  
		n_Tipo := 2
	EndIf
	If AScan(FWSFGrpUsers('000003'), __cUserID) > 0
			cCanal := 'ECOMMERCE'
	   		_cFiltro := _cFiltro +" AND C9_XCANAL = '"+cCanal+"' "
	endif
ENDIF  	                                                                                         
Return(_cFiltro)        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460FIL   บAutor  ณMicrosiga           บ Data ณ  02/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtro para o Browse SC9                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M460FIL()
Local _cFiltro := ""  
local cCanal := '' 
Local cEmpresa := cEmpAnt
cType := UPPER(cType)
IF cEmpresa == FC
	if n_Tipo == 2 	
		if cType == "FS"
			_cFiltro := " C9_XEST <>'SP' "
		else
			_cFiltro := " C9_XEST =='"+cType+"'"
		endif 
		If AScan(FWSFGrpUsers('000003'), __cUserID) > 0
			cCanal := 'ECOMMERCE'
			_cFiltro := _cFiltro +" .And. ALLTRIM(C9_XCANAL) == '"+ALLTRIM(cCanal)+"' "
		endif	
	else
		If AScan(FWSFGrpUsers('000003'), __cUserID) > 0
			cCanal := 'ECOMMERCE'
			_cFiltro := " ALLTRIM(C9_XCANAL) == '"+ALLTRIM(cCanal)+"' " 
		else
			_cFiltro := " C9_FILIAL == '"+xFilial("SC9")+"' "
		endif
	endif
else
	_cFiltro := " C9_FILIAL == '"+xFilial("SC9")+"' "
Endif
Return(_cFiltro)