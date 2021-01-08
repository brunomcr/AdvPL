#include "rwmake.ch"
#INCLUDE "DEFEMPSB.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT103NAT �Autor  �Microsiga           � Data �  03/17/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE VALIDAR NATUREZA OBRIGATORIA NA ENTRADA DE NF           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MT103NAT()
Local nPosTes	:= aScan(aHeader,{|x|AllTrim(x[2]) == "D1_TES"})
Local _bRet := .T.
Public _cNAT_MATA103 := ParamIxb

For zz:=1 to Len(aCols)

	If !EMPTY(aCols[zz][nPosTES]) .And. cTipo == "N"
		_cGeraDup:= "N"

		DbSelectArea("SF4")
		DbSetOrder(1)
		DbSeek(xFilial("SF4")+aCols[zz][nPosTES])
		If Found()
			_cGeraDup := SF4->F4_DUPLIC
		EndIf
		If _cGeraDup == "S" .And. Empty(_cNAT_MATA103)
			MsgAlert("A TES do item: "+StrZero(zz,4) +"gera FINANCEIRO. Natureza Obrigatoria. Verifique!!!")
			_bRet := .F.
		EndIf
		    
	EndIf
Next

Return(_bRet)