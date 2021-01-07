#include 'TOTVS.CH'
#include 'TBICONN.CH'

User Function MTA270MNU // PE: Menus tabela SB7

aadd(aRotina, {"Importar Lancamento de Inventario", "u_INVMEN", 0, 3, 17}) // <cTitulo> <funcao> <REservado> || <03> = Inclusao || <17??>

Return aRotina


/*/ {Protheus.doc} User Function INVMEN
    (Importacao de CSV para lancamento de Inventario Mensal)
    @type Function
    @author Bruno Real
    @since 30/10/2020
    @version v1.0
/*/
User Function INVMEN()

Local aCampos     := {} 	//Campos de cabecalho
Local aDados      := {} 	//Dados a serem incluidos
Local cArq        := "C:\TOTVS\TesteArq\teste001.csv" //Diretorio do arquivo / arquivo
Local cLinha      := "" 	//Linha do arquivo
Local cPrintLinha := .T. 	//
Local i 					//Roda Campo         
Local nArqOK 				//Autentica a existencia do arquivo              		
Private aErro     := {} 	//
Private cAlias    := "SB7" 	//
Private xEmp      := "99" 	// TESTE	
Private xFil      := "00" 	// FILIAl		

/*-----------------------------------------------------------------------------
// PREPARA AMBIENTE com "WorfFlow Protheus" se nao "Prepare Environment"	 //
-----------------------------------------------------------------------------*/
RPCSetType(3)					// Nao consome licensa de uso
If FindFunction('WFPREPENV')	
	lAuto := .T.      
	RPCSetType( 3 )				// Nao consome licensa de uso
	wfPrepENV(xEmp , xFil)	
Else
	lAuto := .T.
	RPCSetType( 3 )				// Nao consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil	
Endif

/*-----------------------------------------------------------------------------
// Valida existencia de arquivo em diretorio
-----------------------------------------------------------------------------*/
nArqOK := FOPEN( cArq , 0) 
If nArqOK == -1				// se nao abrir o aquivo = -1
MsgStop( 'Erro de abertura : FERROR ' + str(ferror(),4)) //ferror mostrara o erro 
Else
MsgAlert( 'Arquivo aberto com sucesso.' )
fclose(nArqOK) 											// Fecha arquivo
Endif
 
/*-----------------------------------------------------------------------------
// Preparacao para utilizacao de arquivo
-----------------------------------------------------------------------------*/
FT_FUSE(cArq) 				//Abre  um arquivo texto para disponibilizar �s fun��es FT_F*.
ProcRegua(FT_FLASTREC()) 	//Atribui o valor maximo de linhas (Retorna o valor maximo de linhas do arquivo aberto)
FT_FGOTOP() 				//Posiciona no in�cio (primeiro caracter da primeira linha) do arquivo texto aberto pela fun��o FT_FUse(). 

/*-----------------------------------------------------------------------------
// Le o arquivo, faz a separacao do delimitador, monta aCampos e aDados
-----------------------------------------------------------------------------*/
While !FT_FEOF() 			//Enquanto o ponteiro NAO ESTIVER posicionado no fim do arquivo texto.
 
	IncProc("Lendo arquivo texto...")

	cLinha := FT_FREADLN() //Retorna uma linha de texto do arquivo aberto pela fun��o FT_FUse()
    
	If cPrintLinha 		   // Se exister dados no arquivo.
		aCampos := Separa(cLinha,",",.T.) //Delimita o separador ";" da linha || SEPARA ( < cString > , < cToken > , < lEmpty > ) �> aTokens
		//aCampos           := Separa(cLinha,supergetmv("DV_DELIMIT",.F.,","),.T.)
		cPrintLinha := .F.
	Else
		aadd(aDados , Separa(cLinha,",",.T.))
	EndIf
 
	FT_FSKIP() //Pula para a proxima linha

EndDo

/*-----------------------------------------------------------------------------
 //Processo para incluir registro na SB7 por cada linha do CS
-----------------------------------------------------------------------------*/ 
For i := 1 to Len(aDados) 	// Loop para quantas linhas de registro exisitirem no aDados/arquivo
 
	IncProc("Importando Registros...") 
 
 	/*-----------------------------------------------------------------------------
 	//Seleciona a Tabela, a ordem e posicionoa no topo da tabela.
	-----------------------------------------------------------------------------*/
	dbSelectArea(cAlias) //Seleciona a Tabela a incluir os registros 
	dbSetOrder(3) 		 //Ordem do indice a ser usada "3" => B7_FILIAL+B7_DOC+B7_COD+B7_LOCAL
	dbGoTop()
	
	/*-----------------------------------------------------------------------------
 	//Tratamento para duplicidade e inclusao de dados na SB7
	-----------------------------------------------------------------------------*/ 	
	If !dbSeek(xFilial(cAlias);																	//"SB7"
			 +(alltrim(aDados[i,3])+space(LEN(SB7->B7_DOC)	 - LEN(alltrim(aDados[i,3]))));		//B7_DOC
			 +(alltrim(aDados[i,1])+space(LEN(SB7->B7_COD)	 - LEN(alltrim(aDados[i,1]))));		//B7_COD
			 +(alltrim(aDados[i,2])+space(LEN(SB7->B7_LOCAL) - LEN(alltrim(aDados[i,2])))))		//B7_LOCAL
		
		//Trava tabela para inclusao de dados
		Reclock(cAlias,.T.) // .T. = Inclusao 
		SB7->B7_FILIAL  := xFilial(cAlias)
		SB7->B7_COD     := alltrim(aDados[i,1])
		SB7->B7_LOCAL   := alltrim(aDados[i,2])
		SB7->B7_DOC     := alltrim(aDados[i,3])
		SB7->B7_QUANT   := VAL(aDados[i,4])
		SB7->B7_DATA    := STOD(aDados[i,5])
		//SB7->B7_DESC  := alltrim(aDados[i,6])
		SB7->B7_LOTECTL := alltrim(aDados[i,6])
		SB7->B7_DTVALID := STOD(aDados[i,7])
		SB7->(MsUnlock()) //Libera o travamento / bloqueio (lock) do registro posicionado no alias corrente, obtido atrav�s da fun��o RecLock(). 
		
	EndIf

Next i //Proxima linha do arquivo para incluir

FT_FUSE(cArq) // Libera/Fecha o arquivo 
  
MsgInfo("Importa��o conclu�da com sucesso!","Sucesso!")
 
Return
