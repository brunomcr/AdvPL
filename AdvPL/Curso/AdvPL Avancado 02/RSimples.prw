#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Protheus.ch"

User Function RSimples()
Local oReport := nil


oReport := RptDef()//Chama a fun��o para carregar a Classe tReport
oReport:PrintDialog()

Return()


Static Function RptDef()

Local oReport := Nil
Local oSection1:= Nil
Local oBreak
Local oFunction
 	
//Sintaxe: 
//Classe TReport
//cNome: Nome f�sico do relat�rio
//cTitulo: Titulo do Relario
//cPergunta: Nome do grupo de pergunta que sera carredo em par�metros
//bBlocoCodigo: Execura a fun��o que ira alimenter as TRSection
//TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)

oReport:=TReport():New("Exemplo01", "Cadastro Produtos",/* cPergunta */,;
 {|oReport| ReportPrint( oReport ) }, "Descri��o do meu relat�rio")

// Relatorio em retrato 
oReport:SetPortrait() //Define orienta��o de p�gina do relat�rio como retrato

// Define se os totalizadores ser�o impressos em linha ou coluna
oReport:SetTotalInLine(.F.) //Define se os totalizadores ser�o impressos em linha ou coluna.
	
//Monstando a primeira se��o
oSection1:= TRSection():New(oReport, "Produtos", {"SB1"}, NIL, .F., .T.) // A classe TRSection pode ser entendida como um layout do relat�rio, por conter c�lulas, quebras e totalizadores que dar�o um formato para sua impress�o.
TRCell():New(oSection1, "B1_COD"    ,"SB1","Produto"		,"@!",30 )
TRCell():New(oSection1, "B1_DESC"   ,"SB1","Descri��o"	,"@!",100)
TRCell():New(oSection1, "B1_LOCPAD" ,"SB1","Arm.Padrao"	,"@!",20 )
TRCell():New(oSection1, "B1_POSIPI" ,"SB1","NCM"			,"@!",30 )


//O par�metro que indica qual c�lula o totalizador se refere ,
//ser� utilizado para posicionamento de impress�o do totalizador quando 
//estiver definido que a impress�o ser� por coluna e como conte�do para a 
//fun��o definida caso n�o seja informada uma f�rmula para o totalizador
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
	
	oReport:IncMeter() //Incrementa a r�gua da tela de processamento do relat�rio
			
	IncProc("Imprimindo " + alltrim((cAlias)->B1_DESC))
		
	//inicializo a primeira se��o
	oSection1:Init()
	
	//imprimo a se��o, relacionando os campos da section com os 
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
	
//finalizo se��o
oSection1:Finish()
	
Return( NIL )


