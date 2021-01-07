#include "protheus.ch"
#include "rwmake.ch"

/*
Programa ...: MT410ALT.Prw
Uso ........: Na alteracao do pedido de vendas, volta a condicao de nao aprovado
Data .......: 11/01/2013
Feito por ..: Surya
*/

User Function MT410ALT()
/****************************************************************************************
* Chamada do Programa
*
***/   
If RecLock("SC5",.F.)
	SC5->C5_APROV := "N"	
Endif


Return