#include "protheus.ch"      
#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"

/*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%	Autor:		Bruno Real													%%%%
%%%%	Data:		04/09/20													%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%	Funcao:		SBRe001									                  	%%%%
%%%%	Descricao: 	Relatorio Estoque - Saoldo por Lote (SB8)                  	%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/

User Function SBRe001(aDados) // Relatorio SBRe001

Local oReport				// Objeto
oReport := ReportDef()		// Corpo
oReport:PrintDialog()		// Dados

Return


Static Function ReportDef()

Local oReport
Local oSection1

	Local aTitulo 	:= {"","Relatório Saldo por Lote",""}
	Local cFileLogo := "LGRL"+RTrim(SM0->M0_CODIGO)+RTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial

	If !File( cFileLogo )
		cFileLogo += "LGRL"+RTrim(SM0->M0_CODIGO)+".BMP" // Empresa
	EndIf
	If !File( cFileLogo )
		cFileLogo := SM0->M0_NOMECOM // Empresa
	EndIf

	If Select("SBRe001") > 0
		SBRe001->(dbCloseArea())
	EndIf

oReport := TReport():New("SBRe001","SALDO POR LOTE","SBRe001",{|oReport| PrintReport(oReport)},"Relatório Estoque Saldo por Lote.")
oReport:ShowHeader()
oReport:SayBitmap(10,10,cFileLogo,474,117) //-- Logotipo
oReport:SetCustomText(aTitulo)

oSection1 := TRSection():New(oReport,"SALDO POR LOTE",{"SB8"})

TRCell():New(oSection1,"B8_FILIAL"	,"SBRe001",)
TRCell():New(oSection1,"B8_QTDORI"	,"SBRe001",)
TRCell():New(oSection1,"B8_PRODUTO"	,"SBRe001",)
TRCell():New(oSection1,"B8_LOCAL"	,"SBRe001",)
TRCell():New(oSection1,"B8_LOTECTL"	,"SBRe001",)
TRCell():New(oSection1,"B8_DTVALID"	,"SBRe001",)
TRCell():New(oSection1,"B8_SALDO"	,"SBRe001",)
TRCell():New(oSection1,"B8_ORIGLAN"	,"SBRe001",)
TRCell():New(oSection1,"B8_EMPENHO"	,"SBRe001",)
TRCell():New(oSection1,"B8_DOC"		,"SBRe001",)
TRCell():New(oSection1,"B8_SERIE"	,"SBRe001",)
TRCell():New(oSection1,"B8_CLIFOR"	,"SBRe001",)
TRCell():New(oSection1,"B8_LOJA"	,"SBRe001",)

Return oReport


Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

oSection1:PrintLine() 
MakeSqlExpr("SBRe001")

oSection1:BeginQuery()
BeginSQL ALIAS "SBRe001"

/* 	++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++ 		QUERY ORIGINAL 		++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++   

SELECT
 SB8030.B8_FILIAL, SB8030.B8_QTDORI, SB8030.B8_PRODUTO, SB8030.B8_LOCAL,
 SB8030.B8_DATA, SB8030.B8_DTVALID, SB8030.B8_SALDO, SB8030.B8_EMPENHO, SB8030.B8_ORIGLAN,
 SB8030.B8_LOTEFOR, SB8030.B8_CHAVE, SB8030.B8_LOTECTL, SB8030.B8_NUMLOTE, SB8030.B8_QEMPPRE,
 SB8030.B8_QACLASS, SB8030.B8_SALDO2, SB8030.B8_QTDORI2, SB8030.B8_EMPENH2, SB8030.B8_QEPRE2,
 SB8030.B8_QACLAS2, SB8030.B8_DOC, SB8030.B8_SERIE, SB8030.B8_CLIFOR, SB8030.B8_LOJA,
 SB8030.B8_POTENCI, SB8030.B8_PRCLOT, SB8030.B8_ITEM, SB8030.B8_ORIGEM, SB8030.B8_DFABRIC,
 SB8030.B8_NUMDESP, SB8030.D_E_L_E_T_, SB8030.R_E_C_N_O_, SB8030.R_E_C_D_E_L_, SB8030.B8_SDOC
FROM P11FCSANTOS.dbo.SB8030 SB8030
WHERE (SB8030.D_E_L_E_T_=' ')

	++++++++++++++++++++++++++++++++++++++++++++++++++++ */

	SELECT
		SB8.B8_FILIAL,	SB8.B8_QTDORI,	SB8.B8_PRODUTO,	SB8.B8_LOCAL,
		SB8.B8_DATA,	SB8.B8_DTVALID,	SB8.B8_SALDO,	SB8.B8_EMPENHO,
		SB8.B8_ORIGLAN,	SB8.B8_LOTEFOR,	SB8.B8_CHAVE,	SB8.B8_LOTECTL,
		SB8.B8_NUMLOTE,	SB8.B8_QEMPPRE,	SB8.B8_QACLASS,	SB8.B8_SALDO2,
		SB8.B8_QTDORI2,	SB8.B8_EMPENH2,	SB8.B8_QEPRE2,	SB8.B8_QACLAS2,
		SB8.B8_DOC,		SB8.B8_SERIE,	SB8.B8_CLIFOR,	SB8.B8_LOJA,
		SB8.B8_POTENCI,	SB8.B8_PRCLOT,	SB8.B8_ITEM,	SB8.B8_ORIGEM,
		SB8.B8_DFABRIC,	SB8.B8_NUMDESP,	SB8.D_E_L_E_T_,	SB8.R_E_C_N_O_,
		SB8.R_E_C_D_E_L_,	SB8.B8_SDOC
	FROM %table:SB8% SB8
	WHERE SB8.%notDel%

		
EndSQL

oSection1:EndQuery()  

oSection1:SetHeaderBreak(.F.)

oSection1:SetParentQuery()

oSection1:Print() 

Return
