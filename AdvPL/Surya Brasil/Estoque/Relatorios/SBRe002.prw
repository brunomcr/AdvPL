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
%%%%	Funcao:		SBRe002									                  	%%%%
%%%%	Descricao: 	Relatorio Estoque - Saoldos Fisico e Financeiro (SB2)      	%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/

User Function SBRe002(aDados) // Relatorio SBRe002

Local oReport				// Objeto
oReport := ReportDef()		// Corpo
oReport:PrintDialog()		// Dados

Return


Static Function ReportDef()

Local oReport
Local oSection1

	Local aTitulo 	:= {"","Relatório Saldo Fisico e Financeiro",""}
	Local cFileLogo := "LGRL"+RTrim(SM0->M0_CODIGO)+RTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial

	If !File( cFileLogo )
		cFileLogo += "LGRL"+RTrim(SM0->M0_CODIGO)+".BMP" // Empresa
	EndIf
	If !File( cFileLogo )
		cFileLogo := SM0->M0_NOMECOM // Empresa
	EndIf

	If Select("SBRe002") > 0
		SBRe002->(dbCloseArea())
	EndIf

oReport := TReport():New("SBRe002","SALDOS FISICO E FINANCEIRO","SBRe002",{|oReport| PrintReport(oReport)},"Relatório Estoque Saldos Fisico e Financeiro.")
oReport:ShowHeader()
oReport:SayBitmap(10,10,cFileLogo,474,117) //-- Logotipo
oReport:SetCustomText(aTitulo)

oSection1 := TRSection():New(oReport,"SALDOS FISICO E FINANCEIRO",{"SB2"})

TRCell():New(oSection1,"B2_FILIAL"	,"SBRe002",)
TRCell():New(oSection1,"B2_COD"		,"SBRe002",)
TRCell():New(oSection1,"B2_QFIM"	,"SBRe002",)
TRCell():New(oSection1,"B2_LOCAL"	,"SBRe002",)
TRCell():New(oSection1,"B2_QATU"	,"SBRe002",)
TRCell():New(oSection1,"B2_VFIM1"	,"SBRe002",)
TRCell():New(oSection1,"B2_VATU1"	,"SBRe002",)
TRCell():New(oSection1,"B2_CM1"		,"SBRe002",)
TRCell():New(oSection1,"B2_RESERVA"	,"SBRe002",)
TRCell():New(oSection1,"B2_QPEDVEN"	,"SBRe002",)
TRCell():New(oSection1,"B2_QEMP"	,"SBRe002",)
TRCell():New(oSection1,"B2_NAOCLAS"	,"SBRe002",)
TRCell():New(oSection1,"B2_DINVENT"	,"SBRe002",)

Return oReport


Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

oSection1:PrintLine() 
MakeSqlExpr("SBRe002")

oSection1:BeginQuery()
BeginSQL ALIAS "SBRe002"

/* 	++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++ 		QUERY ORIGINAL 		++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++   

SELECT
	SB2030.B2_FILIAL, SB2030.B2_COD, SB2030.B2_QFIM, SB2030.B2_LOCAL,
	SB2030.B2_QATU, SB2030.B2_VFIM1, SB2030.B2_VATU1, SB2030.B2_CM1,
	SB2030.B2_VFIM2, SB2030.B2_VATU2, SB2030.B2_CM2, SB2030.B2_VFIM3,
	SB2030.B2_VATU3, SB2030.B2_CM3, SB2030.B2_VFIM4, SB2030.B2_VATU4,
	SB2030.B2_CM4, SB2030.B2_VFIM5, SB2030.B2_VATU5, SB2030.B2_CM5,
	SB2030.B2_QEMP, SB2030.B2_QEMPN, SB2030.B2_QTSEGUM, SB2030.B2_USAI,
	SB2030.B2_RESERVA, SB2030.B2_QPEDVEN, SB2030.B2_LOCALIZ, SB2030.B2_NAOCLAS,
	SB2030.B2_SALPEDI, SB2030.B2_DINVENT, SB2030.B2_DINVFIM, SB2030.B2_QTNP,
	SB2030.B2_QNPT, SB2030.B2_QTER, SB2030.B2_QFIM2, SB2030.B2_QACLASS,
	SB2030.B2_DTINV, SB2030.B2_CMFF1, SB2030.B2_CMFF2, SB2030.B2_CMFF3,
	SB2030.B2_CMFF4, SB2030.B2_CMFF5, SB2030.B2_VFIMFF1, SB2030.B2_VFIMFF2,
	SB2030.B2_VFIMFF3, SB2030.B2_VFIMFF4, SB2030.B2_VFIMFF5, SB2030.B2_QEMPSA,
	SB2030.B2_QEMPPRE, SB2030.B2_SALPPRE, SB2030.B2_QEMP2, SB2030.B2_QEMPN2,
	SB2030.B2_RESERV2, SB2030.B2_QPEDVE2, SB2030.B2_QEPRE2, SB2030.B2_QFIMFF,
	SB2030.B2_SALPED2, SB2030.B2_QEMPPRJ, SB2030.B2_QEMPPR2, SB2030.B2_STATUS,
	SB2030.B2_CMFIM1, SB2030.B2_CMFIM2, SB2030.B2_CMFIM3, SB2030.B2_CMFIM4,
	SB2030.B2_CMFIM5, SB2030.B2_TIPO, SB2030.B2_CMRP1, SB2030.B2_VFRP1,
	SB2030.B2_CMRP2, SB2030.B2_VFRP2, SB2030.B2_CMRP3, SB2030.B2_VFRP3,
	SB2030.B2_CMRP4, SB2030.B2_VFRP4, SB2030.B2_CMRP5, SB2030.B2_VFRP5,
	SB2030.B2_BLOQUEI, SB2030.B2_USERLGI, SB2030.B2_USERLGA, SB2030.B2_QULT,
	SB2030.B2_DULT, SB2030.B2_MSEXP, SB2030.D_E_L_E_T_, SB2030.R_E_C_N_O_,
	SB2030.R_E_C_D_E_L_, SB2030.B2_ECSALDO, SB2030.B2_XDTFIN, SB2030.B2_XDTINI
FROM P11FCSANTOS.dbo.SB2030 SB2030
WHERE (SB2030.D_E_L_E_T_=' ')

	++++++++++++++++++++++++++++++++++++++++++++++++++++ */

	SELECT
		SB2.B2_FILIAL,	SB2.B2_COD,		SB2.B2_QFIM,	SB2.B2_LOCAL,
		SB2.B2_QATU,	SB2.B2_VFIM1,	SB2.B2_VATU1, 	SB2.B2_CM1,
		SB2.B2_RESERVA, SB2.B2_QPEDVEN,	SB2.B2_QEMP,	SB2.B2_NAOCLAS,
		SB2.B2_DINVENT,	SB2.D_E_L_E_T_,	SB2.R_E_C_N_O_,	SB2.R_E_C_D_E_L_
	FROM %table:SB2% SB2
	WHERE SB2.%notDel%

		
EndSQL

oSection1:EndQuery()  

oSection1:SetHeaderBreak(.F.)

oSection1:SetParentQuery()

oSection1:Print() 

Return
