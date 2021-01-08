#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} SBRFAT004
Função para retornar uma lista de opções no campo C5_XCANSAI
@author Vinicius Martins
@since 28/05/2019
@version 1.0
@type function
/*/
User Function SRFAT004()
	
Local aArea   := GetArea()
Local cOpcoes := ''

If AScan(FWSFGrpUsers('000003'), __cUserID) > 0
	//Montando as opções de retorno
	cOpcoes += '2=Ecommerce;'
	cOpcoes += '5=Funcionário;'
	cOpcoes += '6=Submarino;'
	cOpcoes += '7=Americanas;'
	cOpcoes += '8=Shoptime;'
	cOpcoes += '9=Televendas-PF;'
	cOpcoes += 'A=Whatsapp;'
Else	
	cOpcoes += '1=Televendas-PJ;'
	cOpcoes += '3=Representacao;'
	cOpcoes += '4=Direto;'
	cOpcoes += '0=SAC;'
EndIf
 
RestArea(aArea)
Return cOpcoes