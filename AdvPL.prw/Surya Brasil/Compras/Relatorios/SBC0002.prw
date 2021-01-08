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
±±ºPrograma  ³ SBR0005  º Autor ³ Adriana Colafati   º Data ³  20/01/16   º±±
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

User Function SBC0002(aDados) //antigo SBR0005
Local oReport
lOCAL cPerg		:= "SBR0005"
AjustaSx1(cPerg)
//If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
if valtype(aDados) = "U"
	Pergunte("SBR0005",.T.)	
else
	Pergunte("SBR0005",.F.)
	MV_PAR01	:= aDados[3]
	MV_PAR02	:= aDados[4]
	MV_PAR03	:= aDados[5]
	MV_PAR04	:= aDados[9]
Endif
	oReport := ReportDef()	
	oReport:PrintDialog()	
//EndIf

Return

Static Function ReportDef()
Local oReport
Local oSection1
Local aTitulo 	:= {"","Folha de Pagamento Antecipado",""}
Local cFileLogo := "LGRL"+RTrim(SM0->M0_CODIGO)+RTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
If !File( cFileLogo )
	cFileLogo += "LGRL"+RTrim(SM0->M0_CODIGO)+".BMP" // Empresa
EndIf
If !File( cFileLogo )
	cFileLogo := SM0->M0_NOMECOM // Empresa
EndIf
	
//Local cDados := ""
//Public aDados := {"","","","","","","","","","","","","",""}

If Select("SBR0005") > 0
   SBR0005->(dbCloseArea())
EndIf

oReport := TReport():New("SBR0005","PAGAMENTO ANTECIPADO","SBR0005",{|oReport| PrintReport(oReport)},"Relatório de Ocorrências de Entrega.")
oReport:ShowHeader()
oReport:SayBitmap(10,10,cFileLogo,474,117) //-- Logotipo
oReport:SetCustomText(aTitulo)

oSection1 := TRSection():New(oReport,"PAGTO ANTECIPADO",{"SE2","FIE","SA2"})
																		//[8] Descrição Classificação
TRCell():New(oSection1,"E2_TIPO"	,"SBR0005",)
TRCell():New(oSection1,"E2_PREFIXO"	,"SBR0005",)
TRCell():New(oSection1,"E2_NUM"	 	,"SBR0005",)
TRCell():New(oSection1,"FIE_PEDIDO"	,"SBR0005",)
TRCell():New(oSection1,"E2_VALOR"	,"SBR0005",)
TRCell():New(oSection1,"A2_NOME"	,"SBR0005",)
TRCell():New(oSection1,"E2_FORBCO"	,"SBR0005",)
TRCell():New(oSection1,"E2_FORAGE"	,"SBR0005",)
TRCell():New(oSection1,"E2_FORCTA"	,"SBR0005",)
TRCell():New(oSection1,"E2_HIST"	,"SBR0005",)
Return oReport

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

oSection1:PrintLine() 
MakeSqlExpr("SBR0005")
oSection1:BeginQuery()

BeginSQL ALIAS "SBR0005"

/* 	++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++ 		QUERY ORIGINAL 		++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++   

SELECT * FROM SE2070 SE2 INNER JOIN FIE070 FIE ON E2_NUM = FIE_NUM AND E2_PREFIXO = FIE_PREFIX AND E2_PARCELA = FIE_PARCEL AND E2_TIPO = FIE_TIPO
INNER JOIN SA2070 SA2 ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA
WHERE SE2.D_E_L_E_T_ = '' AND FIE.D_E_L_E_T_ = '' AND SA2.D_E_L_E_T_ = ''
AND E2_PREFIXO = '' AND E2_PARCELA = '' AND E2_NUM = '' AND E2_TIPO = ''
	
	*/ 

	SELECT *
	FROM  %table:SE2% SE2
		INNER JOIN %table:SA2% SA2 ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA2.%notDel%
		INNER JOIN %table:FIE% FIE ON E2_NUM = FIE_NUM AND E2_PREFIXO = FIE_PREFIX AND 
						E2_PARCELA = FIE_PARCEL AND E2_TIPO = FIE_TIPO AND FIE.%notDel%		
	WHERE SE2.%notDel%
		AND E2_PREFIXO = %exp:MV_PAR01% 
		AND E2_TIPO = %exp:MV_PAR04%
		AND E2_NUM = %exp:MV_PAR02%
		AND E2_PARCELA = %exp:MV_PAR03%
EndSQL

oSection1:EndQuery()  

oSection1:SetHeaderBreak(.F.)

oSection1:SetParentQuery()

oSection1:Print() 


Return

Static Function AjustaSx1(cPerg)
u_xPutSX1(cPerg,"01"   	,"Prefixo: ","Prefixo: ","Prefixo:	","mv_ch1"	,"C"	,3		,0		,0		,"G","","  ","","","mv_par01","","","","","","","","","","","","","","","","",{"","",""},{},{})
u_xPutSX1(cPerg,"02"   	,"Titulo:  ","Titulo: "	,"Titulo "	 ,"mv_ch2"	,"C"    ,9		,0		,0		,"G","","  ","","","mv_par02","","","","","","","","","","","","","","","","",{"","",""},{},{})
u_xPutSX1(cPerg,"03"   	,"Parcela: ","Parcela"	,"Parcela"	 ,"mv_ch3"  ,"C"    ,2		,0		,0		,"G","","  ","","","mv_par03","","","","","","","","","","","","","","","","",{"","",""},{},{})
u_xPutSx1(cPerg,"04"	,"Tipo:    ","Tipo:    ","Tipo:"	 ,"mv_ch4"  ,"C"    ,3		,0		,0		,"G","","  ","","","mv_par04","","",  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,{"","",""},{},{})
Return