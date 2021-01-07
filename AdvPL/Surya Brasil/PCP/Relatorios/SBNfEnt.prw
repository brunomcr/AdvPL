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
%%%%	Data:		04/09/20 													%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%	Funcao:		SBNfEnt									               	    %%%%
%%%%	Descricao: 	Relatório de Acompanhaento NF Entrada ProdxFornecdor (PCP)  %%%%
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

User Function SBNfEnt(aDados)
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
   
IF Parambox(aPerg ,"Notas Fiscais de Entrada", @aResp)
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
Local aTitulo 	:= {"","Notas Fiscais de Entrada Fornecedor",""}
Local cFileLogo := "LGRL"+RTrim(SM0->M0_CODIGO)+RTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial

If !File( cFileLogo )
	cFileLogo += "LGRL"+RTrim(SM0->M0_CODIGO)+".BMP" // Empresa
EndIf
If !File( cFileLogo )
	cFileLogo := SM0->M0_NOMECOM // Empresa
EndIf

If Select("SBNfEnt") > 0
   SBNfEnt->(dbCloseArea())
EndIf

oReport := TReport():New("SBNfEnt","NOTAS FISCAIS DE ENTRADA","SBNfEnt",{|oReport| PrintReport(oReport)},"Relatório Notas Fiscais de Entrada.")
oReport:ShowHeader()
oReport:SayBitmap(10,10,cFileLogo,474,117) //-- Logotipo
oReport:SetCustomText(aTitulo)

oSection1 := TRSection():New(oReport,"NOTA FISCAL DE ENTRADA",{"SD1"})

TRCell():New(oSection1,"D1_DOC"     ,"SBNfEnt",)
TRCell():New(oSection1,"D1_SERIE"	,"SBNfEnt",)
TRCell():New(oSection1,"D1_FORNECE"	,"SBNfEnt",)
TRCell():New(oSection1,"D1_COD"	    ,"SBNfEnt",)
TRCell():New(oSection1,"D1_VUNIT"	,"SBNfEnt",)
TRCell():New(oSection1,"D1_QUANT"	,"SBNfEnt",)
TRCell():New(oSection1,"D1_LOTECTL"	,"SBNfEnt",)
TRCell():New(oSection1,"D1_DTDIGIT"	,"SBNfEnt",)																		

Return oReport

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

oSection1:PrintLine() 
MakeSqlExpr("SBNfEnt")

oSection1:BeginQuery()
BeginSQL ALIAS "SBNfEnt"

/* 	++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++ 		QUERY ORIGINAL 		++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++   

    SELECT
        D1_DOC[NOTA FISCAL],
        D1_SERIE[SERIE NOTA],
        D1_FORNECE[FORNECEDOR],
        D1_COD[PRODUTO],
        D1_VUNIT[PREÇO],
        D1_QUANT[QUANTIDADE],
        D1_LOTECTL[LOTE],
        D1_DTDIGIT[DATA]
    FROM SD1010
    WHERE D_E_L_E_T_ = ''
        AND (D1_FORNECE >= ? AND D1_FORNECE <= ?)
        AND (D1_COD >= ? AND D1_COD <= ?)
        AND (D1_DTDIGIT >= ? AND D1_DTDIGIT<=?)
	
    ++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++    */ 
    
	SELECT
        D1_DOC,
        D1_SERIE,
        D1_FORNECE,
        D1_COD,
        D1_VUNIT,
        D1_QUANT,
        D1_LOTECTL,
        D1_DTDIGIT
	FROM  %table:SD1% SD1				
	WHERE SD1.%notDel%
		AND (D1_FORNECE >= %exp:MV_PAR01% AND D1_FORNECE  <= %exp:MV_PAR02%)
        AND (D1_COD     >= %exp:MV_PAR03% AND D1_COD      <= %exp:MV_PAR04%)
        AND (D1_DTDIGIT >= %exp:MV_PAR05% AND D1_DTDIGIT  <= %exp:MV_PAR06%)

		
EndSQL

oSection1:EndQuery()  

oSection1:SetHeaderBreak(.F.)

oSection1:SetParentQuery()

oSection1:Print() 

Return
