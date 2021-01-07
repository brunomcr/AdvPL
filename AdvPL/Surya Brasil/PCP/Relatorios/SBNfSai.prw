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
%%%%	Funcao:		SBNfSai									               	    %%%%
%%%%	Descricao: 	Relatório de Acompanhaento NF Saida ProdxFornecdor (PCP)    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%	Parametros: MV_PAR01 => Fornecedor de                                   %%%%
%%%%			    MV_PAR02 => Fornecedor ate                                  %%%%
%%%%			    MV_PAR03 => Produto de					                    %%%%
%%%%			    MV_PAR04 => Produto ate					                    %%%%
%%%%			    MV_PAR05 => Data de						                    %%%%
%%%%		        MV_PAR06 => Data ate		                                %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/

User Function SBNfSai(aDados)
Local oReport                   //TReport
Local aPerg := {}
Local aResp := {}       //Parambox (Pergunta e Resposta)
Local cFornDe       := Space(15)
Local cFornAte      := Space(15)
Local cProdDe       := Space(15)
Local cProdAte      := Space(15)
Local dDataDe       := FirstDate(Date())
Local dDataAte      := LastDate(Date())
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

aAdd(aPerg,{1,"Codigo do Forn de",  cFornDe,"", ".T.","SA2",".T.",80,.F.})
aAdd(aPerg,{1,"Codigo do Forn até", cFornAte,"",".T.","SA2",".T.",80,.F.})  
aAdd(aPerg,{1,"Produto De",         cProdDe,"", ".T.","SB1",".T.",80,.F.})
aAdd(aPerg,{1,"Produto Até",        cProdAte,"",".T.","SB1",".T.",80,.F.})        
aAdd(aPerg,{1,"Data De",            dDataDe,"", ".T.","",".T.",80,.F.})
aAdd(aPerg,{1,"Data Até",           dDataAte,"",".T.","",".T.",80,.F.})

//##########################################################################
   
IF Parambox(aPerg ,"Notas Fiscais de SAIDA", aResp)
	MV_PAR01	:= aResp[1]        //Fornecedor de     :=  Resposta[1]
    MV_PAR02	:= aResp[2]        //Fornecedor ate    :=  Resposta[2]
    MV_PAR03	:= aResp[3]        //Produto de        :=  Resposta[3]
    MV_PAR04	:= aResp[4]        //Produto ate       :=  Resposta[4]
    MV_PAR05	:= aResp[5]        //Data de           :=  Resposta[5] 
    MV_PAR06	:= aResp[6]        //Data ate          :=  Resposta[6]
else
	return()
Endif

oReport := ReportDef()	
oReport:PrintDialog()	

Return


Static Function ReportDef()
Local oReport
Local oSection1
Local aTitulo 	:= {"","Notas Fiscais de Saida Fornecedor",""}
Local cFileLogo := "LGRL"+RTrim(SM0->M0_CODIGO)+RTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial

If !File( cFileLogo )
	cFileLogo += "LGRL"+RTrim(SM0->M0_CODIGO)+".BMP" // Empresa
EndIf
If !File( cFileLogo )
	cFileLogo := SM0->M0_NOMECOM // Empresa
EndIf

If Select("SBNfSai") > 0
   SBNfSai->(dbCloseArea())
EndIf

oReport := TReport():New("SBNfSai","NOTAS FISCAIS DE SAIDA","SBNfSai",{|oReport| PrintReport(oReport)},"Relatório Notas Fiscais de Saida.")
oReport:ShowHeader()
oReport:SayBitmap(10,10,cFileLogo,474,117) //-- Logotipo
oReport:SetCustomText(aTitulo)

oSection1 := TRSection():New(oReport,"NOTA FISCAL DE SAIDA",{"SD2"})

TRCell():New(oSection1,"D2_DOC"     ,"SBNfSai",)
TRCell():New(oSection1,"D2_SERIE"   ,"SBNfSai",)
TRCell():New(oSection1,"D2_CLIENTE" ,"SBNfSai",)
TRCell():New(oSection1,"D2_COD"     ,"SBNfSai",)
TRCell():New(oSection1,"D2_PRCVEN"  ,"SBNfSai",)
TRCell():New(oSection1,"D2_QUANT"   ,"SBNfSai",)
TRCell():New(oSection1,"D2_LOTECTL" ,"SBNfSai",)
TRCell():New(oSection1,"D2_EMISSAO" ,"SBNfSai",)
																		

Return oReport

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

oSection1:PrintLine() 
MakeSqlExpr("SBNfSai")

oSection1:BeginQuery()
BeginSQL ALIAS "SBNfSai"

/* 	++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++ 		QUERY ORIGINAL 		++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++   

    SELECT
        D2_DOC[NOTA FISCAL],
        D2_SERIE[SERIE NOTA],
        D2_CLIENTE[CLIENTE],
        D2_COD[PRODUTO],
        D2_PRCVEN[PREÇO],
        D2_QUANT[QUANTIDADE],
        D2_LOTECTL[LOTE],
        D2_EMISSAO[DATA]
    FROM SD2010
    WHERE D_E_L_E_T_ = ''
        AND (D2_CLIENTE >= ? AND D2_CLIENTE<= ?)
        AND (D2_COD >= ? AND D2_COD <= ?)
        AND (D2_EMISSAO >= ? AND D2_EMISSAO<=?)
	
    ++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++    */ 
    
	SELECT
        D2_DOC,
        D2_SERIE,
        D2_CLIENTE,
        D2_COD,
        D2_PRCVEN,
        D2_QUANT,
        D2_LOTECTL,
        D2_EMISSAO
	FROM  %table:SD2% SD2				
	WHERE SD2.%notDel%
		AND (D2_CLIENTE >= %exp:MV_PAR01% AND D2_CLIENTE  <= %exp:MV_PAR02%)
        AND (D2_COD     >= %exp:MV_PAR03% AND D2_COD      <= %exp:MV_PAR04%)
        AND (D2_EMISSAO >= %exp:MV_PAR05% AND D2_EMISSAO  <= %exp:MV_PAR06%)

		
EndSQL

oSection1:EndQuery()  

oSection1:SetHeaderBreak(.F.)

oSection1:SetParentQuery()

oSection1:Print() 

Return
