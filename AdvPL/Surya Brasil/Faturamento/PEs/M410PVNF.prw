#include "protheus.ch"
#include "rwmake.ch"
#INCLUDE "DEFEMPSB.CH"

/*
Programa ...: M410PVNF.Prw
Uso ........: Só fatura de campo C5_APROV estiver com S    e com Volume
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
	MsgAlert("Pedido não pode ser liberado pois não foi aprovado.","M410PVNF")	
	lContinua := .F.                                                        
Endif
If empty(alltrim(SC5->C5_VOLUME1))
	MsgAlert("Pedido não FATURAVEL. Deve se importar o volume antes","M410PVNF")	
	lContinua := .F.                                                        
Endif

Return(lContinua)