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
%%%%	Data:		05/09/20 													%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%	Funcao:		SBEst									               	    %%%%
%%%%	Descricao: 	Relatório de Estoque + Descricao Produto (PCP) 	            %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%	Parametros: MV_PAR01 => Armazem de                                      %%%%
%%%%			    MV_PAR02 => Armazem ate                                     %%%%
%%%%			    MV_PAR03 => Produto de					                    %%%%
%%%%			    MV_PAR04 => Produto ate					                    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/

User Function SBEst(aDados)
Local oReport                               //TReport
Local aPerg         := {}                   //Parambox (Perguntas)
Local aResp         := {}                   //Parambox (Resposta)
Local cArmzDe       := Space(15)            
Local cArmzAte      := Space(15)
Local cProdDe       := Space(15)
Local cProdAte      := Space(15)
//############################### PERGUNTAS #################################
// Tipo 1 -> MsGet()
//           [2]-Descricao
//           [3]-String contendo o inicializador do campo
//           [4]-String contendo a Picture do campo
//           [5]-String contendo a validacao
//           [6]-Consulta F3
//           [7]-String contendo a validacao When
//           [8]-Tamanho do MsGet
//           [9]-Flag .T./.F. Parametro Obrigatorio ?

aAdd(aPerg,{1,"Armazem de",  cArmzDe,"", ".T.","NRR",".T.",80,.F.})
aAdd(aPerg,{1,"Armazem até", cArmzAte,"",".T.","NRR",".T.",80,.F.})  
aAdd(aPerg,{1,"Produto De",  cProdDe,"", ".T.","SB1",".T.",80,.F.})
aAdd(aPerg,{1,"Produto Até", cProdAte,"",".T.","SB1",".T.",80,.F.})        

//##########################################################################
   
IF Parambox(aPerg ,"Estoque Detalhado", aResp)
	MV_PAR01	:= aResp[1]        //Pergunta    :=  Resposta[1]
    MV_PAR02	:= aResp[2]        //Pergunta    :=  Resposta[2]
    MV_PAR03	:= aResp[3]        //Pergunta    :=  Resposta[3]
    MV_PAR04	:= aResp[4]        //Pergunta    :=  Resposta[4]
else
	return()
Endif

oReport := ReportDef()	
oReport:PrintDialog()	

Return


Static Function ReportDef()
Local oReport
Local oSection1
Local aTitulo 	:= {"","Estoque Detalhado",""}
Local cFileLogo := "LGRL"+RTrim(SM0->M0_CODIGO)+RTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial

If !File( cFileLogo )
	cFileLogo += "LGRL"+RTrim(SM0->M0_CODIGO)+".BMP" // Empresa
EndIf
If !File( cFileLogo )
	cFileLogo := SM0->M0_NOMECOM // Empresa
EndIf

If Select("SBEst") > 0
   SBEst->(dbCloseArea())
EndIf

oReport := TReport():New("SBEst","Estoque Detalhado","SBEst",{|oReport| PrintReport(oReport)},"Estoque Detalhado")
oReport:ShowHeader()
oReport:SayBitmap(10,10,cFileLogo,474,117) //-- Logotipo
oReport:SetCustomText(aTitulo)

oSection1 := TRSection():New(oReport,"Estoque Detalhado",{"SB8","SB1"})

TRCell():New(oSection1,"B8_PRODUTO" ,"SBEst",)
TRCell():New(oSection1,"B1_DESC"    ,"SBEst",)
TRCell():New(oSection1,"B1_UM"      ,"SBEst",)
TRCell():New(oSection1,"B8_LOCAL"   ,"SBEst",)
TRCell():New(oSection1,"B8_SALDO"   ,"SBEst",)
TRCell():New(oSection1,"B8_LOTECTL" ,"SBEst",)
TRCell():New(oSection1,"B8_DTVALID" ,"SBEst",)
															

Return oReport

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

oSection1:PrintLine() 
MakeSqlExpr("SBEst")

oSection1:BeginQuery()
BeginSQL ALIAS "SBEst"

/* 	++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++ 		QUERY ORIGINAL 		++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++   

    SELECT
        B8_PRODUTO[PRODUTO],
        B1_DESC[DESCRICAO],
        B1_UM[UM],
        B8_LOCAL[ARMAZEM],
        B8_SALDO[SALDO ATUAL],
        B8_LOTECTL[LOTE],
        B8_DTVALID[VALIDADE]
    FROM SB8010 SB8
        INNER JOIN SB1010 SB1 ON B8_PRODUTO = B1_COD
    WHERE SB8.D_E_L_E_T_ = ''
        AND (B8_LOCAL >=? AND B8_LOCAL<=?)
        AND(B8_PRODUTO>=? AND B8_PRODUTO<=?)
	
    ++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++    */ 
    
	SELECT
        B8_PRODUTO,
        B1_DESC,
        B1_UM,
        B8_LOCAL,
        B8_SALDO,
        B8_LOTECTL,
        B8_DTVALID
	FROM  %table:SB8% SB8
        INNER JOIN %table:SB1% SB1 ON B8_PRODUTO = B1_COD AND SB1.%notDel%				
	WHERE SB8.%notDel%
        AND (B8_LOCAL   >= %exp:MV_PAR01% AND B8_LOCAL    <= %exp:MV_PAR02%)
        AND (B8_PRODUTO >= %exp:MV_PAR03% AND B8_PRODUTO  <= %exp:MV_PAR04%)
        
EndSQL

oSection1:EndQuery()  

oSection1:SetHeaderBreak(.F.)

oSection1:SetParentQuery()

oSection1:Print() 

Return
