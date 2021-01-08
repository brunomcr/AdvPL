#include "PROTHEUS.ch"


//rel de notas canceladas
User Function SBRFAT001()

Local oReport

	//Criando o grupo de pergunta
	CriaPerg()
	
	//Carregando os dados da pergunta
	Pergunte("GIL2",.F.)

	//Chando a Função para criar a estrutura do relatorio	
	oReport := ReportDef()
  
	//Imprimindo o Relatorio
	oReport:PrintDialog()                                                       
      

Return( Nil )
//***********************************************************************************************************************************

Static Function ReportDef()

Local oReport
Local oSection
Local oBreak

// Criando a o Objeto

oReport := TReport():New("","HNFCANC","GIL2",{|oReport| PrintReport(oReport)},"HNFCANC")

oSection := TRSection():New(oReport,"HNFCANC",{""} )

	TRCell():New(oSection,"F3_FILIAL"        ,      "SF3")
	TRCell():New(oSection,"F3_NFISCAL"       ,      "SF3")
	TRCell():New(oSection,"F3_EMISSAO"       ,      "SF3")
	TRCell():New(oSection,"F3_SERIE" 	     ,      "SF3")
	TRCell():New(oSection,"F3_DTCANC"        ,      "SF3")
	TRCell():New(oSection,"F3_OBSERV"        ,      "SF3")
	TRCell():New(oSection,"F3_CHVNFE"        ,      "SF3")
	TRCell():New(oSection,"F3_DESCRET"       ,      "SF3")
	TRCell():New(oSection,"F3_PROTOC"        ,      "SF3")

	TRCell():New(oSection,"F3_TIPO"          ,      "SF3")
	TRCell():New(oSection,"F3_ENTRADA"       ,      "SF3")
	TRCell():New(oSection,"F3_CFO"           ,      "SF3")
	TRCell():New(oSection,"F3_CLIEFOR"       ,      "SF3")
	TRCell():New(oSection,"F3_LOJA"          ,      "SF3")
	TRCell():New(oSection,"F3_CLIENT"        ,      "SF3")

   	TRCell():New(oSection,"TP"               ,    , "TP")
   	TRCell():New(oSection,"NOME"             ,    , "Nome")

	TRCell():New(oSection,"A1_NOME"        	 ,      "SA1")
	TRCell():New(oSection,"A2_NOME"        	 ,      "SA2")

	//TRCell():New(oSection,"D2_PRUNIT"        ,      "SD2",,"@E 999,999,999.99")
Return ( oReport )

//*******************************************************************************************


Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)
Local cPart := ""
Local cAlias := GetNextAlias()




//---------------------------------------------------------------------------------------------------------------
// controle de acesso ao relatório de vendas, todas as lojas via parâmetro de restrição MV_ZUSUMED e MV_ZUSUME1 
//---------------------------------------------------------------------------------------------------------------
Local cCodUsr   := RetCodUsr()
local _cFilIni 	:= ''   
local _cFilFin 	:= 'ZZZZ'   

//-------------------------------------------------------------------------------------------



	
BeginSql Alias cAlias        
//-------------------------------------------------------------------------------------------------
// relação de notas canceladas e inutilizadas
//-------------------------------------------------------------------------------------------------
select
	SF3.F3_FILIAL
    ,SF3.F3_NFISCAL
	,CONVERT(VARCHAR,CAST(SF3.F3_EMISSAO AS DATETIME),103) as F3_EMISSAO
	,SF3.F3_SERIE
	,CONVERT(VARCHAR,CAST(SF3.F3_DTCANC AS DATETIME),103) as F3_DTCANC
	,SF3.F3_OBSERV
	,SF3.F3_CHVNFE
	,SF3.F3_DESCRET
	,SF3.F3_PROTOC
	,SF3.F3_TIPO
	,SF3.F3_ENTRADA
	,SF3.F3_CFO
	,SF3.F3_CLIEFOR
	,SF3.F3_LOJA
	,SF3.F3_CLIENT
	,case 
		when isnull(SA1.A1_NOME,'') <> '' then 'CLIENTE'
	else
		'FORNECEDOR' 
	end as TP
	,ltrim(rtrim( isnull(SA1.A1_NOME,'') + ' ' + isnull(SA2.A2_NOME,''))) as NOME
	,SA1.A1_NOME
	,SA2.A2_NOME
from
	%table:SF3% SF3
	left join %table:SA1% SA1 on SF3.F3_CLIEFOR = SA1.A1_COD and SF3.F3_LOJA = SA1.A1_LOJA // and SF3.F3_TIPO in ('','N','C','I','P','S','B','D')
	left join %table:SA2% SA2 on SF3.F3_CLIEFOR = SA2.A2_COD and SF3.F3_LOJA = SA2.A2_LOJA and SF3.F3_TIPO not in ('','B')
where
	SF3.D_E_L_E_T_ <> '*'
	and SF3.F3_EMISSAO between %exp:MV_PAR01% and %exp:MV_PAR02% 
	and (SF3.F3_DESCRET like '%Cancela%' or SF3.F3_DESCRET like '%Inut%')
order by
	SF3.F3_FILIAL
	,SF3.F3_NFISCAL
	,SF3.F3_EMISSAO

EndSql

aRetSql := GetLastQuery()

//MemoWrite("C:\TEMP\sql.txt",aRetSql[2])

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
	
oReport:SetMeter((cAlias)->( LastRec() ))

	//todos os meus registros
	While ! (cAlias)->( EOF() )
		If oReport:Cancel()
			Exit
		EndIf
	
		oReport:IncMeter()
			
		//inicializo a primeira seção
		oSection:Init()

                oSection:Cell("F3_FILIAL"  ):SetValue((cAlias)->F3_FILIAL ) 		
                oSection:Cell("F3_NFISCAL" ):SetValue((cAlias)->F3_NFISCAL) 		
                oSection:Cell("F3_EMISSAO" ):SetValue((cAlias)->F3_EMISSAO) 		
                oSection:Cell("F3_SERIE"   ):SetValue((cAlias)->F3_SERIE  ) 		
                oSection:Cell("F3_DTCANC"  ):SetValue((cAlias)->F3_DTCANC ) 		
                oSection:Cell("F3_OBSERV"  ):SetValue((cAlias)->F3_OBSERV ) 		
                oSection:Cell("F3_CHVNFE"  ):SetValue((cAlias)->F3_CHVNFE ) 		
                oSection:Cell("F3_DESCRET" ):SetValue((cAlias)->F3_DESCRET) 		
                oSection:Cell("F3_PROTOC"  ):SetValue((cAlias)->F3_PROTOC ) 		
                oSection:Cell("F3_TIPO"    ):SetValue((cAlias)->F3_TIPO   ) 		
                oSection:Cell("F3_ENTRADA" ):SetValue((cAlias)->F3_ENTRADA) 		
                oSection:Cell("F3_CFO"     ):SetValue((cAlias)->F3_CFO    ) 		
                oSection:Cell("F3_CLIEFOR" ):SetValue((cAlias)->F3_CLIEFOR) 		
                oSection:Cell("F3_LOJA"    ):SetValue((cAlias)->F3_LOJA   ) 		
                oSection:Cell("F3_CLIENT"  ):SetValue((cAlias)->F3_CLIENT ) 		
                oSection:Cell("TP"         ):SetValue((cAlias)->TP        ) 		
                oSection:Cell("NOME"       ):SetValue((cAlias)->NOME      ) 		
                oSection:Cell("A1_NOME"    ):SetValue((cAlias)->A1_NOME   ) 		
                oSection:Cell("A2_NOME"    ):SetValue((cAlias)->A2_NOME   ) 		

                //oSection:Cell("F4_TEXTO"   ):SetValue(Posicione("SF4",1,(cAlias)->F4_FILIAL+(cAlias)->D2_TES,"F4_TEXTO")) 		
                 		
              //  oSection:Cell("FT_OBSERV"  ):SetValue((cAlias)->FT_OBSERV ) 		
		 oSection:Printline()
		(cAlias)->(dbSkip())
	EndDo	

//finalizo seção
oSection:Finish()

(cAlias)->( dbCloseArea() )

Return( Nil )


//Criação de pergunta no arquivo SX1
Static Function CriaPerg()
	cPerg:= "GIL2"
	//PutSX1(cGrupo,cOrdem,cPergunt,cPergSpa,cPergEng,cVar,cTipo,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3,cGrpSXG, [ cPyme], < cVar01>, [ cDef01], [ cDefSpa1], [ cDefEng1], [ cCnt01], [ cDef02], [ cDefSpa2], [ cDefEng2], [ cDef03], [ cDefSpa3], [ cDefEng3], [ cDef04], [ cDefSpa4], [ cDefEng4], [ cDef05], [ cDefSpa5], [ cDefEng5], [ aHelpPor], [ aHelpEng], [ aHelpSpa], [ cHelp] )
	u_xPutSx1( cPerg,"01","Data de ? "		      	,"","","mv_ch1","D",8,0,0,"G","","SF3","","","MV_PAR01","","","","","","","","","","","","","","","","",{""},{""},{""},"")
	u_xPutSx1( cPerg,"02","Data ate ? "			,"","","mv_ch2","D",8,0,0,"G","","SF3","","","MV_PAR02","","","","","","","","","","","","","","","","",{""},{""},{""},"")
Return()
//------------------------------------------------------------------------------------------------------------------
Static Function fNoEspecial(cCaract)

	cCaract := FwNoAccent(cCaract)
    cCaract := StrTran( Alltrim( cCaract ), chr(26),"o")
    cCaract := StrTran( Alltrim( cCaract ), chr(10),"")
    cCaract := StrTran( Alltrim( cCaract ), "`",""  ) 
    cCaract := StrTran( Alltrim( cCaract ), "ª","a.") 
    cCaract := StrTran( Alltrim( cCaract ), "º","o.") 
    cCaract := StrTran( Alltrim( cCaract ), ""," " ) 
    cCaract := StrTran( Alltrim( cCaract ), "%"," " ) 
    cCaract := StrTran( Alltrim( cCaract ), "-"," " ) 
    cCaract := StrTran( Alltrim( cCaract ), "_"," " ) 
    cCaract := StrTran( Alltrim( cCaract ), "."," " ) 
    cCaract := StrTran( Alltrim( cCaract ), ","," " ) 
    cCaract := StrTran( Alltrim( cCaract ), ";"," " ) 
    cCaract := StrTran( Alltrim( cCaract ), "@"," " ) 
    cCaract := StrTran( Alltrim( cCaract ), "¨"," " ) 

Return(cCaract)


