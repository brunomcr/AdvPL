#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE "DEFEMPSB.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} M410FSQL

Filtrar pedidos de vendas aprovados ou não

@author PC - Surya

@since		11/01/13
@version	P10 R1.3
@param
@return     cQuery - Filtro aprovados

@Obs:

---------------------------------------------------------------------
Programador		Data		Motivo
---------------------------------------------------------------------
/*/   

User Function M410FSQL()
Local cAprov   := GetMv("SB_APROVPV")
Private cUsnome  := Upper(Alltrim(UsrRetName(RetCodUsr())))
Private cQuery := ""

If __cUserID $ Upper(Alltrim(cAprov))
	// Chamada de tela
	FTelaPar()
Endif

Return cQuery


// Tela seletora
Static Function FTelaPar()
Local aRadio := {}        
Private nRadio := 1

aRadio	  	:= {"Não aprovado","Liberado","Aprovado","Todos"}

@ 000,000 To 190,192 Dialog oDlg Title "Surya - Filtro PV" 
@ 008,037 Say cUsnome
@ 008,014 Say "Usuário :" 
@ 020,014 To 072,080 Title "Filtrar por"                                                                         
@ 028,018 Radio aRadio Var nRadio Object oRadio 
@ 078,025 Button "&OK"  Size 037,012 Action FOKFil()
Activate Dialog oDlg Center

Return 

// Filtro efetivo
Static Function FOKFil

Close(oDlg)

Do Case
	Case nRadio == 1
		cQuery := "C5_APROV $ 'N| '"		
	Case nRadio == 2 
		cQuery := "C5_APROV == 'L'"						
	Case nRadio == 3
		cQuery := "C5_APROV == 'S'"
	Case nRadio == 4
		cQuery := ""	
End Case	

Return