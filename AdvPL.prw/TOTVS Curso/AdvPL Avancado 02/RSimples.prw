#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Protheus.ch"

User Function RSimples()
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

oReport:=TReport():New("Exemplo01", "Cadastro Produtos",/* cPergunta */,;
 {|oReport| ReportPrint( oReport ) }, "Descrição do meu relatório")

// Relatorio em retrato 
oReport:SetPortrait() //Define orientação de página do relatório como retrato

// Define se os totalizadores serão impressos em linha ou coluna
oReport:SetTotalInLine(.F.) //Define se os totalizadores serão impressos em linha ou coluna.
	
//Monstando a primeira seção
oSection1:= TRSection():New(oReport, "Produtos", {"SB1"}, NIL, .F., .T.) // A classe TRSection pode ser entendida como um layout do relatório, por conter células, quebras e totalizadores que darão um formato para sua impressão.
TRCell():New(oSection1, "B1_COD"    ,"SB1","Produto"		,"@!",30 )
TRCell():New(oSection1, "B1_DESC"   ,"SB1","Descrição"	,"@!",100)
TRCell():New(oSection1, "B1_LOCPAD" ,"SB1","Arm.Padrao"	,"@!",20 )
TRCell():New(oSection1, "B1_POSIPI" ,"SB1","NCM"			,"@!",30 )


//O parâmetro que indica qual célula o totalizador se refere ,
//será utilizado para posicionamento de impressão do totalizador quando 
//estiver definido que a impressão será por coluna e como conteúdo para a 
//função definida caso não seja informada uma fórmula para o totalizador
TRFunction():New(oSection1:Cell("B1_COD"),NIL,"COUNT",,,,,.F.,.T.)

Return(oReport)



Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local cQuery    := ""
Local cNcm      := ""
Local lPrim 	:= .T.
Local cAlias  := GetNextAlias()
cPart := "% AND B1_COD >= '' "
cPart += "  AND B1_COD <= 'ZZZZZZZZZZ' %"

BeginSql alias cAlias

	SELECT B1_COD,B1_DESC,B1_LOCPAD,B1_POSIPI
	FROM %table:SB1% SB1
	WHERE B1_FILIAL = %xfilial:SB1%
	AND B1_MSBLQL <> '1'
	AND SB1.%notDel%
	
	%exp:cPart%
	
	ORDER BY B1_COD
	
EndSql
		
dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
	
oReport:SetMeter((cAlias)->(LastRec()))

While !(cAlias)->( EOF() )
		
	If oReport:Cancel()
		Exit
	EndIf
	
	oReport:IncMeter() //Incrementa a régua da tela de processamento do relatório
			
	IncProc("Imprimindo " + alltrim((cAlias)->B1_DESC))
		
	//inicializo a primeira seção
	oSection1:Init()
	
	//imprimo a seção, relacionando os campos da section com os 
           //valores da tabela
		
	oSection1:Cell("B1_COD"   ):SetValue((cAlias)->B1_COD    )
	oSection1:Cell("B1_DESC"  ):SetValue((cAlias)->B1_DESC   )
	oSection1:Cell("B1_LOCPAD"):SetValue((cAlias)->B1_LOCPAD )
	oSection1:Cell("B1_POSIPI"):SetValue((cAlias)->B1_POSIPI)
	oSection1:Printline()

	(cAlias)->(dbSkip())
 			
		//imprimo uma linha 
		oReport:ThinLine()
		oReport:ThinLine()
		
EndDo
	
//finalizo seção
oSection1:Finish()
	
Return( NIL )


