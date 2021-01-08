#include "protheus.ch"      
#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SBR0006  º Autor ³ Adriana Colafati   º Data ³  20/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Pagamento Antecipado Folha                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MV_PAR01 => Prefixo					                      º±±
±±º			 ³ MV_PAR02 => Titulo 					                      º±±
±±º			 ³ MV_PAR03 => Parcela					                      º±±
±±º			 ³ MV_PAR04 => Tipo						                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SBC0001() //antigo SBR0006
Local oReport
LOCAL cPerg		:= "SBC0001"
Private cPedCom	:= SC7->C7_NUM

oReport := ReportDef()	
oReport:PrintDialog()	
Return

Static Function ReportDef()
Local oReport
Local oSection1
Local aTitulo 	:= {"","PC PA",""}
Local cFileLogo := "LGRL"+RTrim(SM0->M0_CODIGO)+RTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
If !File( cFileLogo )
	cFileLogo += "LGRL"+RTrim(SM0->M0_CODIGO)+".BMP" // Empresa
EndIf
If !File( cFileLogo )
	cFileLogo := SM0->M0_NOMECOM // Empresa
EndIf
	
//Local cDados := ""
//Public aDados := {"","","","","","","","","","","","","",""}

If Select("SBC0001") > 0
   SBC0001->(dbCloseArea())
EndIf

oReport := TReport():New("SBC0001","Pedido de Compra x PAs","SBC0001",{|oReport| PrintReport(oReport)},"Relatório de Ocorrências de Entrega.")
oReport:ShowHeader()
oReport:SayBitmap(10,10,cFileLogo,474,117) //-- Logotipo
oReport:SetCustomText(aTitulo)

oSection1 := TRSection():New(oReport,"PAGTOS ANTECIPADOS",{"SC7","FIE","SA2"})
																		//[8] Descrição Classificação
TRCell():New(oSection1,"C7_NUM"		,"SBC0001",)
TRCell():New(oSection1,"C7_FORNECE"	,"SBC0001",)
TRCell():New(oSection1,"A2_NREDUZ" 	,"SBC0001",)
TRCell():New(oSection1,"FIE_PREFIX"	,"SBC0001",)
TRCell():New(oSection1,"FIE_NUM"	,"SBC0001",)
TRCell():New(oSection1,"FIE_PARCEL"	,"SBC0001",)
TRCell():New(oSection1,"A2_NOME"	,"SBC0001",)
TRCell():New(oSection1,"FIE_VALOR"	,"SBC0001",)

Return oReport

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

oSection1:PrintLine() 
MakeSqlExpr("SBC0001")
oSection1:BeginQuery()

BeginSQL ALIAS "SBC0001"

/* 	++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++ 		QUERY ORIGINAL 		++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++   

SELECT * FROM SE2070 SE2 INNER JOIN FIE070 FIE ON E2_NUM = FIE_NUM AND E2_PREFIXO = FIE_PREFIX AND E2_PARCELA = FIE_PARCEL AND E2_TIPO = FIE_TIPO
INNER JOIN SA2070 SA2 ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA
WHERE SE2.D_E_L_E_T_ = '' AND FIE.D_E_L_E_T_ = '' AND SA2.D_E_L_E_T_ = ''
AND E2_PREFIXO = '' AND E2_PARCELA = '' AND E2_NUM = '' AND E2_TIPO = ''
	
	*/ 

	SELECT distinct C7_NUM, C7_FORNECE, SA2.A2_NREDUZ, FIE_PREFIX, FIE_NUM, FIE_PARCEL, SA21.A2_NOME, 
FIE.FIE_VALOR
	FROM  %table:SC7% SC7
		INNER JOIN %table:FIE% FIE ON C7_FILIAL = FIE_FILIAL AND C7_NUM = FIE_PEDIDO AND FIE.%notDel%	
		INNER JOIN %table:SA2% SA2 ON C7_FORNECE = SA2.A2_COD AND C7_LOJA = SA2.A2_LOJA
		INNER JOIN %table:SA2% SA21 ON SA21.A2_COD = FIE_FORNEC AND SA21.A2_LOJA = FIE_LOJA
	WHERE SC7.%notDel%
		AND C7_NUM = %exp:cPedCom%
EndSQL

oSection1:EndQuery()  

oSection1:SetHeaderBreak(.F.)

oSection1:SetParentQuery()

oSection1:Print() 


Return
