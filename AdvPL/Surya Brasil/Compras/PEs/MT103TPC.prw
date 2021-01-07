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
���Prog.  � MT103TPC� Uso � Surya Brasil � Modulo � SIGACOM � Data � 22/02/18 ���
�����������������������������������������������������������������������������͹��
���Desc.  � Ponto de entrada para liberar as nf de entrada sem ped de compra  ���
���       � para empresas especificas no parametro SB_FLIBXML                 ���
�����������������������������������������������������������������������������͹��      		
��� Autor � Caio de Paula             � Contato �(11) 98346-3154              ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function MT103TPC()
local _TesAtu := aCols[n,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="D1_TES" })]
local cTes := ''     
Local cFornece	:= CA100FOR
local cFornLib	:= SuperGetMv("SB_FLIBXML",.T.,"")
Local _cTes		:= SuperGetMv("SB_TLIBXML",.T.,"013")
IF cFornece $ cFornLib
	cTes := _TesAtu
Endif
if _TesAtu $ _cTes
	cTes := _TesAtu
Endif
return cTes