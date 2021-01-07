#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDe "AvPrint.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Prog.  � MT140PC � Uso � Surya Brasil � Modulo � SIGACOM � Data � 22/02/18 ���
�����������������������������������������������������������������������������͹��
���Desc.  � Ponto de entrada para liberar as pre-notas de pedido de compra 	  ���
���       � para empresas especificas no parametro SB_FLIBXML                 ���
�����������������������������������������������������������������������������͹��      		
��� Autor � Caio de Paula             � Contato �(11) 98346-3154              ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function MT140PC()
Local ExpL1 	:= PARAMIXB[1]  
Local cFornece	:= CA100FOR
Local cFornLib	:= SuperGetMv("SB_FLIBXML",.T.,"")
Local cTes		:= SuperGetMv("SB_TLIBXML",.T.,"013")
IF cFornece $ cFornLib
	ExpL1 := .F.
endif
Return ExpL1