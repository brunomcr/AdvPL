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
���Prog.  �MT103FIM � Uso � Surya Brasil � Modulo � SIGACOM � Data � 08/05/17 ���
�����������������������������������������������������������������������������͹��
���Desc.  � Ponto de entrada para gravar status na tabela SZ1 xml Entrada auto���
���       �                                                                   ���
�����������������������������������������������������������������������������͹��      		
��� Autor � Caio de Paula             � Contato �(11) 98346-3154              ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function MT103FIM
Local nOpcao 	:= PARAMIXB[1]   // Op��o Escolhida pelo usuario no aRotina 
Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a opera��o de grava��o da NFE 
Local cEmpresa 	:= cEmpAnt
Local aArea		:= GetArea()
Local aAreaSD1	:= SD1->(GetArea())
Local aAreaSFT	:= SFT->(GetArea())
Local cChave	:= SF1->F1_CHVNFE
Local cDoc		:= SF1->F1_DOC
Local cSerie	:= SF1->F1_SERIE
Local cFornece	:= SF1->F1_FORNECE
Local cLjFor	:= SF1->F1_LOJA
if nConfirma == 1 .and. (nOpcao == 3 .Or. nOpcao == 4)
	Do While !EOF() .And. cDoc == SD1->D1_DOC .And. cSerie == SD1->D1_SERIE .And. cFornece == SD1->D1_FORNECE .and. cLjFor == SD1->D1_LOJA
		RecLock("SD1",.F.)
			SD1->D1_BASNDES	:= SD1->D1_BRICMS                                                                       
			SD1->D1_ALQNDES	:= SD1->D1_ALIQSOL
			SD1->D1_ICMNDES	:= SD1->D1_ICMSRET
		MsUnlock()
		SD1->(DbSkip())
	Enddo
	SFT->(Dbsetorder(1))
	SFT->(Dbseek(SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA))
	Do While !EOF() .And. cDoc == SFT->FT_NFISCAL .And. cSerie == SFT->FT_SERIE .And. cFornece == SFT->FT_CLIEFOR .and. cLjFor == SFT->FT_LOJA
		RecLock("SFT",.F.)
			SFT->FT_BASNDES	:= SFT->FT_BASERET                                                                      
			SFT->FT_ALQNDES	:= SFT->FT_ALIQSOL
			SFT->FT_ICMNDES	:= SFT->FT_ICMSRET
		MsUnlock()
		SFT->(DbSkip())
	Enddo	
Endif  
if cEmpresa == FC .or. cEmpresa == RCG .or. cEmpresa == COSMETIC
	AtuSZ1(cChave,nConfirma,nOpcao)
endif

RestArea(aAreaSD1)
RestArea(aAreaSFT)
RestArea(aArea)
Return





Static Function AtuSZ1(cChave,nConfirma,nOpcao)
if nConfirma == 1 .and. nOpcao == 4 
     DbSelectArea("SZ1")
     DbSetOrder(4)
     IF dbseek(SF1->F1_FILIAL+cChave)
     	RecLock("SZ1",.F.)
     		SZ1->Z1_STATUS := "3"
     	MsUnlock()
     endif
elseif nConfirma == 1 .and. nOpcao == 3
     DbSelectArea("SZ1")
     DbSetOrder(4)
     IF dbseek(SF1->F1_FILIAL+cChave)
     	RecLock("SZ1",.F.)
     		SZ1->Z1_STATUS := "3"
     	MsUnlock()
     endif
elseif nConfirma == 1 .and. nOpcao == 5
     DbSelectArea("SZ1")
     DbSetOrder(4)
     IF dbseek(SF1->F1_FILIAL+cChave)
     	RecLock("SZ1",.F.)
     		SZ1->Z1_STATUS := "0"
     	MsUnlock()
     endif        
endIF
Return