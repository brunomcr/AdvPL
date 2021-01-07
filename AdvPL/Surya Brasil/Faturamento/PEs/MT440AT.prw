#include "protheus.ch"
#include "rwmake.ch"
#INCLUDE "DEFEMPSB.CH"

/*
Programa ...: MT440AT.Prw
Uso ........: Só fatura de campo C5_APROV estiver com S
Data .......: 11/01/2013
Feito por ..: Surya
*/

User Function MT440AT()
/****************************************************************************************
* Chamada do Programa
*
***/
Local lContinua := .T.

//If SC5->C5_TIPO == "N"
If SC5->C5_APROV <> "S"
	MsgAlert("Pedido bloqueado, não é possivel libera-lo","MT440AT")	
	lContinua := .F.                                                        
Endif
//Endif

Return(lContinua)