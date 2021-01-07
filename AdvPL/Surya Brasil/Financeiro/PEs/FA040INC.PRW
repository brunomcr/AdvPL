#include "Protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "DEFEMPSB.CH"
//********
//Programa: Travar o usuario para nao incluir titulo do tipo NF no contas a Receber
//Desenv: Leonardo Perrella (dsm)
//Data: 08/02/2013
//Cliente: Surya Brasil
//********

User Function FA040INC ()

Local lOk := .T.
 
if (ALLTRIM(M->E1_TIPO)=="NF")
	MsgBox("Não pode incluir titulos igual a NF, verifique o documento a ser incluso!")
	lOk := .F.
EndIf

Return (lOk)             

