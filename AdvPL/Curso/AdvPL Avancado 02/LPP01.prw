#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Protheus.ch"

user function LPP01()

Local oReport := nil


oReport := RptDef()//Chama a função para carregar a Classe tReport
oReport:PrintDialog()

Return()


Static Function RptDef()

Local oReport := Nil
Local oSection1:= Nil
Local oBreak
Local oFunction
 	
//Sintaxe: 
//Classe TReport
//cNome: Nome físico do relatório
//cTitulo: Titulo do Relario
//cPergunta: Nome do grupo de pergunta que sera carredo em parâmetros
//bBlocoCodigo: Execura a função que ira alimenter as TRSection
//TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)

oReport:=TReport():New("ProdPer01", "Cadastro Produtos Personalizados",/* cPergunta */,;
 {|oReport| ReportPrint( oReport ) }, "Lista dos produtos personalizdaos gravados")

// Relatorio em retrato 
oReport:SetPortrait() //Define orientação de página do relatório como retrato

// Define se os totalizadores serão impressos em linha ou coluna
oReport:SetTotalInLine(.F.) //Define se os totalizadores serão impressos em linha ou coluna.
	
//Monstando a primeira seção
oSection1:= TRSection():New(oReport, "Produtos", {"SZ1"}, NIL, .F., .T.) // A classe TRSection pode ser entendida como um layout do relatório, por conter células, quebras e totalizadores que darão um formato para sua impressão.
TRCell():New(oSection1, "Z1_COD"    ,"SZ1","Produto"		,"@!",30 )
TRCell():New(oSection1, "Z1_NOME"   ,"SZ1","Nome"	,"@!",30)
TRCell():New(oSection1, "Z1_LIST" ,"SZ1","Tipo"	,"@!",5 )
TRCell():New(oSection1, "Z1_PREC" ,"SZ1","Preco"			,"@E 999,999,999.99",30 )


//O parâmetro que indica qual célula o totalizador se refere ,
//será utilizado para posicionamento de impressão do totalizador quando 
//estiver definido que a impressão será por coluna e como conteúdo para a 
//função definida caso não seja informada uma fórmula para o totalizador
TRFunction():New(oSection1:Cell("Z1_COD"),NIL,"COUNT",,,,,.F.,.T.)
TRFunction():New(oSection1:Cell("Z1_PREC"),NIL,"SUM",,,,,.F.,.T.)
Return(oReport)



Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local cQuery    := ""
Local cNcm      := ""
Local lPrim 	:= .T.
Local cAlias  := GetNextAlias()
cPart := "% AND Z1_COD >= '' "
cPart += "  AND Z1_COD <= 'ZZZZZZZZZZ' %"

BeginSql alias cAlias

	SELECT Z1_COD,Z1_NOME,Z1_LIST,Z1_PREC
	FROM %table:SZ1% SZ1
	WHERE Z1_FILIAL = %xfilial:SZ1%
	AND SZ1.%notDel%
	
	%exp:cPart%
	
	ORDER BY Z1_COD
	
EndSql
		
dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
	
oReport:SetMeter((cAlias)->(LastRec()))

While !(cAlias)->( EOF() )
		
	If oReport:Cancel()
		Exit
	EndIf
	
	oReport:IncMeter() //Incrementa a régua da tela de processamento do relatório
			
	IncProc("Imprimindo " + alltrim((cAlias)->Z1_NOME))
		
	//inicializo a primeira seção
	oSection1:Init()
	
	//imprimo a seção, relacionando os campos da section com os 
           //valores da tabela
		
	oSection1:Cell("Z1_COD"   ):SetValue((cAlias)->Z1_COD    )
	oSection1:Cell("Z1_NOME"  ):SetValue((cAlias)->Z1_NOME   )
	oSection1:Cell("Z1_LIST"):SetValue((cAlias)->Z1_LIST )
	oSection1:Cell("Z1_PREC"):SetValue((cAlias)->Z1_PREC)
	oSection1:Printline()

	(cAlias)->(dbSkip())
 			
		//imprimo uma linha 
		oReport:ThinLine()
		
EndDo
	
//finalizo seção
oSection1:Finish()
	
Return( NIL )
