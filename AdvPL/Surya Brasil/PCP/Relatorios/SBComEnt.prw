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
%%%%	Funcao:		SBComEnt									               	%%%%
%%%%	Descricao: 	Relatório Ped.Compra / Aut.Entrega (PCP)      	            %%%%
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

User Function SBComEnt(aDados)
Local oReport                   //TReport
Local aPerg         := {}
Local aResp         := {}       //Parambox (Pergunta e Resposta)
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
   
IF Parambox(aPerg ,"Ped.Compra / Aut.Entrega", aResp)
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
Local aTitulo 	:= {"","Ped.Compra / Aut.Entrega Fornecedor",""}
Local cFileLogo := "LGRL"+RTrim(SM0->M0_CODIGO)+RTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial

If !File( cFileLogo )
	cFileLogo += "LGRL"+RTrim(SM0->M0_CODIGO)+".BMP" // Empresa
EndIf
If !File( cFileLogo )
	cFileLogo := SM0->M0_NOMECOM // Empresa
EndIf

If Select("SBComEnt") > 0
   SBComEnt->(dbCloseArea())
EndIf

oReport := TReport():New("SBComEnt","Ped.Compra / Aut.Entrega","SBComEnt",{|oReport| PrintReport(oReport)},"Relatório Ped.Compra / Aut.Entrega.")
oReport:ShowHeader()
oReport:SayBitmap(10,10,cFileLogo,474,117) //-- Logotipo
oReport:SetCustomText(aTitulo)

oSection1 := TRSection():New(oReport,"Ped.Compra / Aut.Entrega",{"SC7"})

TRCell():New(oSection1,"C7_NUM"     ,"SBComEnt",)
TRCell():New(oSection1,"C7_PRODUTO" ,"SBComEnt",)
TRCell():New(oSection1,"C7_QUANT"   ,"SBComEnt",)
TRCell():New(oSection1,"C7_PRECO"   ,"SBComEnt",)
TRCell():New(oSection1,"C7_EMISSAO" ,"SBComEnt",)
TRCell():New(oSection1,"C7_FORNECE" ,"SBComEnt",)																		

Return oReport

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

oSection1:PrintLine() 
MakeSqlExpr("SBComEnt")

oSection1:BeginQuery()
BeginSQL ALIAS "SBComEnt"

/* 	++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++ 		QUERY ORIGINAL 		++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++   

    SELECT
        C7_NUM[PEDIDO],
        C7_PRODUTO[PRODUTO],
        C7_QUANT[QUANTIDADE],
        C7_PRECO[PRECO],
        C7_EMISSAO[DATA],
        C7_FORNECE[FORNECEDOR]
    FROM SC7010
    WHERE D_E_L_E_T_ = ''
        AND C7_QUANT <>C7_QUJE
        AND (C7_FORNECE >= ? AND C7_FORNECE <= ?)
        AND (C7_PRODUTO >= ? AND C7_PRODUTO <=?)
        AND (C7_EMISSAO >=? AND C7_EMISSAO <=?)
	
    ++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++    */ 
    
	SELECT
        C7_NUM,
        C7_PRODUTO,
        C7_QUANT,
        C7_PRECO,
        C7_EMISSAO,
        C7_FORNECE
	FROM  %table:SC7% SC7				
	WHERE SC7.%notDel%
        AND C7_QUANT <> C7_QUJE
		AND (C7_FORNECE >= %exp:MV_PAR01% AND C7_FORNECE  <= %exp:MV_PAR02%)
        AND (C7_PRODUTO >= %exp:MV_PAR03% AND C7_PRODUTO  <= %exp:MV_PAR04%)
        AND (C7_EMISSAO >= %exp:MV_PAR05% AND C7_EMISSAO  <= %exp:MV_PAR06%)
		
EndSQL

oSection1:EndQuery()  

oSection1:SetHeaderBreak(.F.)

oSection1:SetParentQuery()

oSection1:Print() 

Return
