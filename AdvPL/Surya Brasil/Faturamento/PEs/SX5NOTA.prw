#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDE "AvPrint.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Prog.  � SX5NOTA � Uso � Surya Brasil � Modulo � SIGAFAT � Data � 08/07/17 ���
�����������������������������������������������������������������������������͹��
���Desc.  � PE para separar a numera��o da serie por grupo de usuario		  ���
���       �                                                                   ���
�����������������������������������������������������������������������������͹��
��� Autor � Caio de Paula             � Contato �(11) 98346-3154              ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/


USER FUNCTION SX5NOTA() 
Local cSerie:= "" 
Local lRet := .F. 
Local cEmpresa := cEmpAnt
Local aAreaAnt := GETAREA()

if cEmpresa == FC
	If AScan(FWSFGrpUsers('000003'), __cUserID) > 0 //GRUPO ECOMMERCE
		cSerie := Alltrim(SuperGetMV("SB_SERECOM",.t.,"003"))          //parametro
	ELSEIF AScan(FWSFGrpUsers('000002'), __cUserID) > 0 //TELEVENDAS
		cSerie := Alltrim(SuperGetMV("SB_SERTELE",.t.,"002/004"))     //parametro
	else
		cSerie := "001/002/003/004/005/006/007/008/009/010/011/090"
	Endif


	If alltrim(X5_CHAVE) $ cSerie 
	   lRet := .T. 
	Endif 
else
	lRet := .T.
endif

RESTAREA(aAreaAnt)

return(lRet)