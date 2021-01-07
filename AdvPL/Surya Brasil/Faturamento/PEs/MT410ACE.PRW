#include 'rwmake.ch'
#INCLUDE "DEFEMPSB.CH"
//Desabilita função exclui
User Function Mt410Ace()

Local lContinua 	:= .T.  
Local nOpc  		:= PARAMIXB [1]
Local cAprov 		:= GetMv("MV_SURYAPV")
 
IF nOpc == 1 .AND. !( Upper( Alltrim( UsrRetName( RetCodUsr() ) ) ) $ Upper( Alltrim( cAprov ) ) ) // excluir   
 
	Msgalert("Função desabilitada","HELP: MT410ACE")     
	lContinua := .F.	 

Endif 

Return(lContinua)