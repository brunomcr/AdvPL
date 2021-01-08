#include "protheus.ch"
#include "rwmake.ch"
#INCLUDE "DEFEMPSB.CH"

/*
Programa ...: M410PVNF.Prw
Uso ........: S� fatura de campo C5_APROV estiver com S    e com Volume
Data .......: 11/01/2013
Feito por ..: Surya
*/

User Function M410PVNF()
/****************************************************************************************
* Chamada do Programa
*
***/
Local lContinua := .T.

If SC5->C5_APROV <> "S"
	MsgAlert("Pedido n�o pode ser liberado pois n�o foi aprovado.","M410PVNF")	
	lContinua := .F.                                                        
Endif
If empty(alltrim(SC5->C5_VOLUME1))
	MsgAlert("Pedido n�o FATURAVEL. Deve se importar o volume antes","M410PVNF")	
	lContinua := .F.                                                        
Endif

Return(lContinua)