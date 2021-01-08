#include "Protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "DEFEMPSB.CH"
//********
//Programa: Travar o usuario para nao incluir titulo do tipo NF no contas a Pagar
//Desenv: Leonardo Perrella (dsm)
//Data: 08/02/2013
//Cliente: Surya Brasil
//********

User Function FA050INC ()

Local lOk := .T.
if (ALLTRIM(M->E2_TIPO)=="PA") 
	M->E2_PREFIXO := "MAN"
ENDIF
if (ALLTRIM(M->E2_TIPO)=="NF")
	MsgAlert("Não pode incluir titulos igual a NF, verifique o documento a ser incluso!")
	lOk := .F.
EndIf 
if (ALLTRIM(M->E2_TIPO)=="PA")  .And. Empty(ALLTRIM(M->E2_HIST))
	MsgAlert("Favor incluir o motivo do PA no campo Historico !")
	lOk := .F.
EndIf
if (ALLTRIM(M->E2_TIPO)=="PA")
	if empty(ALLTRIM(M->E2_FORBCO))
		MsgBox("Deve-se inserir o banco do fornecedor para titulos do tipo PA!")
		lOk := .F.
	endif
ENDIF
Return (lOk)  
