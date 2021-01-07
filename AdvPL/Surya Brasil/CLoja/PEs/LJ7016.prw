#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Rwmake.ch" 
#INCLUDE "DEFEMPSB.CH"
#INCLUDE "Font.CH"
#INCLUDE "colors.ch"
#INCLUDE "AvPrint.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"
#INCLUDE "Totvs.ch" 


#DEFINE BF_ITEM	002
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Funcao>: LJ7016
<Descricao> : CustomizaÁ„o da Barra de FunÁıes Venda Assistida (SIGALOJA)
<Autor> : Renan Ros·rio
<Data> : 31/08/18
<Parametros> : Nil
<Retorno> : Nil
<Processo> : Loja
<Tipo> : 
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
User Function LJ7016()

Local _aDados 		:= {}
//Local nAtalho 		:= Paramixb[2]
Local aAtalho 		:= {}
Local cEmpresa		:= cEmpAnt 
Local cXMLFile		:= ""

/*DefiniÁ„oo do array de retorno
1 - TÌtulo para o Menu (caracter)
2 - TÌtulo para o Bot„o (caracter)
3 - Resource (objeto)
4 - FunÁ„oo a ser executada (formula)
5 - Aparece na ToolBar lateral (lÛgico)
6 - Habilitado? (lÛgico)
7 - Grupo ( inteiro, 1 = gravaÁ„oo, 2 = detalhes, 3 = Estoque e 4 = Outros )
8 - Tecla de Atalho (vetor): ¡ um Array com a seguinte definiÁ„oo: 1 - identificaÁ„oo (inteiro) 2 - comandos (caracter)
*/

If cEmpresa == RCG

	nAtalho := 16
	aAtalho := Lj7Atalho(nAtalho) 
	AAdd(_aDados, {"Imp. Trinks" , "Imp. Trinks" , "Imp. Trinks", { || U_ImpTrink( ) }, .T., .T., 4, aAtalho} )
	
Endif


Return(_aDados)

/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Funcao>: ImpTrink
<Descricao> : Leitura do arquivo TXT
<Autor> : Renan Ros·rio
<Data> : 31/08/18
<Parametros> : Nil
<Retorno> : Nil
<Processo> : Loja
<Tipo> : 
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
User Function ImpTrink( )
 
Local aArq			:= {}
Local cDirXml		:= ''
Local cXMLFile		:= ''
Local _cFile		:= ''

cDirXml 		:= SuperGetMV( "RC_DIRECTI" )
aArq 			:= Directory(cDirXml+"*.ECF")
cDirOk    		:= cDirXml+"processados\"

MakeDir(cDirOk)

If Len ( aArq ) > 0 

	For i= 1 to len( aArq )
		
		_cFile		:= aArq[i][1]
		cXMLFile 	:= cDirXml+aArq[i][1]
		Processa	( { || ImpLoja( cXMLFile, _cFile ) },"Importanto Itens Trinks..." )
		           
	Next
Else

	MsgAlert("Arquivo n„o encontrado!")
	
EndIf

Return

/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Funcao>: ImpSC5
<Descricao> : Preenchimento do Grid de itens da venda assistida
<Autor> : Renan Ros·rio
<Data> : 31/08/18
<Parametros> : Nil
<Retorno> : Nil
<Processo> : Loja
<Tipo> : 
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Static FuncTion ImpLoja( cXMLFile, _cFile )

Local cProduto			:= ''
Local nQuanti			:= 0
Local nPreco			:= 0   
Local nDesco			:= 0
Local nHandle 			:= 0
Local cLinhaInd 		:= '01'
Local cIdentif			:= ''
Local _cProd			:= ''
Local _cDescSB1			:= ''
Local cClient			:= SuperGetMV( "MV_CLIPAD" )
Local cLoja				:= SuperGetMV( "MV_LOJAPAD" )
Local nDescItem			:= 0
Local _cUNIDAD			:= ''

Private cArqTxt 		:= cXMLFile //cGetFile("Arquivos CSV|*.CSV|Todos os Arquivos|*.*",OemToAnsi("Peso e volume ..."),,,.T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE)
Private aTmpDados		:= {}

Default cXMLFile		:= ''


/*---------------------*
* Abre o Arquivo Texto   *
*---------------------*/

nHandle 	:= FT_FUSE( cArqTxt )

/*-------------------------------------------------------------------------------*
* Vai para o Inicio do Arquivo e Define o numero de Linhas para a Barra de Processamento. *
*------------------------------------------------------------------------------*/

FT_FGOTOP()

_nTotal 	:= FT_FLASTREC()

ProcRegua( _nTotal )

/*--------------------------*
* Leitura da linha do arquivo *
*--------------------------*/

cBuffer := FT_FREADLN()
nCt := 1

/*------------------------------------*
* Percorre todo os itens do arquivo CSV. *
*------------------------------------*/

While !FT_FEOF()

	IncProc()
	
	/*---------------------------------------------------------*
	* Faz a Leitura da Linha do Arquivo e atribui a Variavel cBuffer *
	*---------------------------------------------------------*/
	
	cBuffer := FT_FREADLN()
	
	/*----------------------------*
	* Remover os acentos da linha 	*
	*----------------------------*/
	
	//	cBuffer := SemAcentos(cBuffer)
	
	/*---------------------------------------------------------------*
	* Se ja passou por todos os registros do TXT sai do While. *
	*---------------------------------------------------------------*/
	
	If Empty( cBuffer )
	
		Exit
		
	Endif
		
	/*----------------------------------------------------------------------------------------------*
	* somente grava o item se houver o "x" na planilha,ou seja, o ";" n„o estiver na posiÁ„o 1.    *
	*----------------------------------------------------------------------------------------------*/
	cIdentif 		:= AllTrim( substr( cBuffer,1,2		)	)
	
	If cIdentif <> cLinhaInd
		
		cProduto 		:= AllTrim( substr( cBuffer, 12, 14			)	)
		nQuanti 		:= Val(alltrim( Substr( cBuffer, 91, 16		)	)	)
		nPreco			:= Val(alltrim( Substr( cBuffer, 107, 16	)	)	)
		nDesco			:= Val(alltrim( Substr( cBuffer, 123, 13	)	)	)
		cDesc			:= AllTrim( Substr( cBuffer, 42, 49			)	) 
		nDescItem		:= nDesco/nQuanti 
		
		DbSelectArea("SA7")
		DbSetOrder(3) // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_CODCLI
			
		If ! DbSeek(xFilial("SA7") + cClient + cLoja + AllTrim(cProduto) )
				
			If GeraSA7(cClient,  cLoja,  cProduto,  cDesc , xFilial("SL2"))
				
				DbSetOrder(3) // A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
					
				If ! DbSeek(xFilial("SA7") + cClient + cLoja + AllTrim(cProduto) )
					
					MsgAlert("De/Para n„o realizado....")
					Return
				
				Else
				
					If !EmpTy(A7_PRODUTO)				
							
						_cProd  	:= SA7->A7_PRODUTO
						_cDescSB1	:= POSICIONE("SB1", 1, xFilial("SB1") + _cProd, "B1_DESC")	
							
					EndIf
						
				EndIf
					
			Else
							
				MsgAlert("Codigo Produto Protheus em Branco....")
				Return
				
				
					
			EndIf
				
		Else
		
			If !EmpTy(A7_PRODUTO)
			
				DbSelectArea("SB1")
				DbSetOrder(1)
				
				If DbSeek(xFilial("SB1") + AllTrim(SA7->A7_PRODUTO) )
										
					_cProd  	:= SA7->A7_PRODUTO
					_cDescSB1	:= POSICIONE("SB1", 1, xFilial("SB1") + _cProd, "B1_DESC")	
					_cUNIDAD	:= POSICIONE("SB1", 1, xFilial("SB1") + _cProd, "B1_UM")
					
				Else
						
					If GeraSA7(cClient,  cLoja,  cProduto,  cDesc , xFilial("SL2"))
				
						DbSetOrder(3) // A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
							
						If ! DbSeek(xFilial("SA7") + cClient + cLoja + AllTrim(cProduto) )
							
							MsgAlert("De/Para n„o realizado....")
							Return
						
						Else
						
							If !EmpTy(A7_PRODUTO)				
									
								_cProd  	:= SA7->A7_PRODUTO
								_cDescSB1	:= POSICIONE("SB1", 1, xFilial("SB1") + _cProd, "B1_DESC")	
									
							EndIf
								
						EndIf
							
					Else
									
						MsgAlert("Codigo Produto Protheus em Branco....")
						Return
							
					EndIf
					
				EndIf
				
			Else
								
				If GeraSA7(cClient,  cLoja,  cProduto,  cDesc , xFilial("SL2"))
				
					DbSetOrder(3) // A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
							
					If ! DbSeek(xFilial("SA7") + cClient + cLoja + AllTrim(cProduto) )
							
						MsgAlert("De/Para n„o realizado....")
						Return
						
					Else
						
						If !EmpTy(A7_PRODUTO)				
									
							_cProd  	:= SA7->A7_PRODUTO
							_cDescSB1	:= POSICIONE("SB1", 1, xFilial("SB1") + _cProd, "B1_DESC")	
									
						EndIf
								
					EndIf
							
				Else
									
					MsgAlert("Codigo Produto Protheus em Branco....")
					Return
							
				EndIf
					
			EndIf
			
		EndIf
		
		DbSelectArea("SB0")
		DbSetOrder(1) // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_CODCLI
			
		If DbSeek( xFilial( "SB0" ) + AllTrim( _cProd ) )
			
			If nPreco <> SB0->B0_PRV1
				
				//If MsgYesNo( 'Deseja alterar o PreÁo Prtotheus?', 'PreÁo divergente entreTRINKS e Protheus.' )
					
					AtuSB0( _cProd,  _cDescSB1, xFilial("SL2"), nPreco, .T. )
				
				//EndIf
			
			EndIf
		
		Else
		
				AtuSB0( _cProd,  _cDescSB1, xFilial("SL2"), nPreco, .F. )
				
		EndIf
		
	EndIf
	
	nCt ++
	
	/*------------------------	*
	* Incrementa linha          *
	*------------------------	*/
	
	FT_FSKIP()
	
	/*------------------------	*
	* Alimenta Vetor           *
	*------------------------	*/
	
	
	If cIdentif <> cLinhaInd
		
		AAdd(aTmpDados, { _cProd , _cDescSB1, nQuanti , nPreco, nDesco, _cUNIDAD, nDescItem  } )
		
	Endif	
			
End

If !FCLOSE( nHandle )

	Conout( "Erro ao fechar arquivo, erro numero: ", FERROR() )
	
EndIf

FT_FUse()

__CopyFile(cArqTxt,cDirOk+_cFile+".ECF")

If FERASE(cArqTxt) <> -1

	Conout("Arquivo eliminado!")
          
          
          
Else
    
	MsgAlert("Erro na eliminaÁ„o do arquivo n„o " + STR(FERROR()))          
	Return Nil

EndIf

If	!EMPTY ( aTmpDados )

	GERAACOLS ( aTmpDados )
	
EndIf

//StaticCall( LOJA701B, Lj7DefPag, lCria, oPanVA3	, aPosObj4	, oEncVA,	nOpc, lTefPendCS, aTefBKPCS	, cAlterCond,lDefPagto, nVlrAcrsFi,lRegraDesc,nPerDesc,aDadosCNeg )

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GeraSA7  ∫Autor  ≥                 o ∫ Data ≥  04/01/10     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥    					                                      ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/ 
//GeraSA7
Static Function GeraSA7(cCli,  cLoja,  cProd,  cDesCPrd ,_cFilial)

Local lRet := .T.
Local oEdit1
Local cEdit1 := space(TamSX3('A7_CODCLI')[1])

DEFINE MSDIALOG _oDlg TITLE "INCLUIR DE/PARA CODIGO CLIENTE" FROM C(177),C(192) TO C(340),C(659) PIXEL STYLE DS_MODALFRAME

	_oDlg:lEscClose := .F.

	// Cria as Groups do Sistema
	@ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg
	
	// Cria Componentes Padroes do Sistema
	@ C(012),C(027) Say "Produto Cod. TRINKS: "+ cProd Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(020),C(027) Say "Descricao: "+cDesCPrd Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(038),C(067) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid( ValProd( cEdit1, cCli, cLoja ) ) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(040),C(027) Say "Produto digitado: " Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(058),C(027) Say "Descricao: "+Alltrim(GetAdvFVal("SB1","B1_DESC",XFilial("SB1")+cEdit1,1,""))Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Chkproc:=.T.,_oDlg:End())
	oEdit1:SetFocus()
	
ACTIVATE MSDIALOG _oDlg CENTERED

If Chkproc 
	
	If SA7->(dbSetOrder(3), dbSeek( xFilial( "SA7" )+ cCli+ cLoja + ALLTRIM ( cProd ) ) )
		
		RecLock( "SA7",.F. )
			
	Else
		
		Reclock( "SA7",.T. )
			
	Endif
		
			SA7->A7_FILIAL 	:= xFilial("SA7")
			SA7->A7_CLIENTE := cCli
			SA7->A7_LOJA 	:= cLoja
			SA7->A7_PRODUTO := cEdit1
			SA7->A7_DESCCLI := POSICIONE("SB1", 1, xFilial("SB1") + cEdit1, "B1_DESC") //cDesCPrd
			SA7->A7_CODCLI  := cProd
		SA7->(MsUnlock())
		
Else
	
	Conout("ERRO!!!"+CRLF+"Contatar Administrador")
	lRet := .F.
	
EndIf

Return lRet

/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Funcao>: GERAACOLS
<Descricao> : Preenchimento do Grid de itens da venda assistida
<Autor> : Renan Ros·rio
<Data> : 31/08/18
<Parametros> : Nil
<Retorno> : Nil
<Processo> : Loja
<Tipo> : 
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Static Function GERAACOLS ( aTmpDados )

Local _cProduto	:= ''
Local _nQuant 	:= 0

For nX := 1 To Len ( aTmpDados )
	
	_cProduto 	:= aTmpDados [nX][1]
	_nQuant 	:= aTmpDados [nX][3]
	
	StaticCall( LOJA701, Lj7LancItem, _cProduto, _nQuant )

	aCols [nX][5] 	:= aTmpDados [nX][4] - aTmpDados [nX][7]
	aCols [nX][6] 	:= ( aTmpDados [nX][4] * aTmpDados [nX][3] ) - aTmpDados [nX][5] 
	aCols [nX][8] 	:= (aTmpDados [1][7]/aTmpDados [1][4])*100 //( 100 * aTmpDados [nX][5] ) / aTmpDados [nX][4] 
	aCols [nX][9] 	:= aTmpDados [nX][5]
		
	//M->LR_VALDESC := aTmpDados [nX][5]
	
Next nX

If Len ( aCols ) > 0

	U_ATUDETAL ( )
	
EndIf

Return

/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Funcao>: ATUVENDAS
<Descricao> : Atualiza aCols e detalhes da venda assistida.
<Autor> : Renan Ros·rio
<Data> : 31/08/18
<Parametros> : Nil
<Retorno> : Nil
<Processo> : Loja
<Tipo> : 
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
User Function ATUDETAL ()

Local nAuxTotal		:= 0
//Local nDescTotal	:= 0

Lj7Detalhe( ) 

Lj7T_SubTotal( 2, 0)

For nX:=1 To Len(aCols)

	If !aCols[nX, Len(aHeader)+1]
		
		nAuxTotal 	:= nAuxTotal 	+ (aCols[nX][6] )
		//nDescTotal 	:= nDescTotal 	+ (aCols[nX][9] )
		Lj7T_Total	( 2, nAuxTotal 	)
		//Lj7T_DescV	( 2, nDescTotal ) 
		//Lj7T_DescP	( 2, nDescTotal )
		
	EndIf
    
Next

Lj7T_SubTotal	( 2, nAuxTotal )
//Lj7T_DescV(2, nDescTotal) 
Lj7T_Total( 2, nAuxTotal )
      
SetFocus( oGetVA:oBrowse:hWnd )
oGetVA:Refresh()
GetDRefresh()

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AtuSB0  ∫Autor  ≥                 o ∫ Data ≥  11/09/18     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥    					                                      ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/ 
Static Function AtuSB0( cProd,  cDesCPrd ,_cFilial, nPreco, _lSB0 )

Local lRet 		:= .T.
Local oEdit1
Local nEdit1 	:= nPreco //space(TamSX3('B0_PRV1')[1])

/*DEFINE MSDIALOG _oDlg TITLE "Atualizar PreÁo de Venda Protheus" FROM C(177),C(192) TO C(340),C(659) PIXEL STYLE DS_MODALFRAME

	_oDlg:lEscClose := .F.

	// Cria as Groups do Sistema
	@ C(002),C(003) TO C(071),C(186) LABEL "Dig. Valor de Substituicao " PIXEL OF _oDlg
	
	// Cria Componentes Padroes do Sistema
	@ C(012),C(027) Say "Produto	 : "+cProd Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg 
	@ C(020),C(027) Say "Descricao	 : "+cDesCPrd Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(048),C(027) Say "PreÁo Atual : "+Alltrim(GetAdvFVal("SB0","B0_PRV1",XFilial("SB0")+cProd,1,""))Size C(150),C(008) COLOR CLR_HBLUE OF _oDlg PIXEL PICTURE "@E 999,999,999.99"
	//@ C(028),C(070) MsGet oEdit1 Var nEdit1 F3 "SB1" Valid(ValProd(cEdit1)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(028),C(070) MsGet oEdit1 Var nEdit1 Size C(060),C(009) COLOR CLR_HBLUE OF _oDlg PIXEL PICTURE "@E 999,999,999.99"
	
	//Bot„o Gravar
	@ C(004),C(194) Button "Salvar" Size C(037),C(012) PIXEL OF _oDlg Action(Chkproc:=.T.,_oDlg:End())
	oEdit1:SetFocus()
	
ACTIVATE MSDIALOG _oDlg CENTERED*/

If _lSB0

	If SB0->( dbSetOrder( 1 ), dbSeek( xFilial( "SB0" )+cProd ) )
		
		RecLock("SB0",.F.)
			
			SB0->B0_PRV1	:= nEdit1
				
		SB0->(MsUnlock())
			
	Else
	
		Conout("ERRO!!!"+CRLF+"Produto n„o entcontrado: "+cProd)
		lRet := .F.
	
	EndIf
	
Else

	RecLock("SB0",.T.)
		
		SB0->B0_FILIAL	:= xFilial( "SB0" )
		SB0->B0_COD		:= cProd
		SB0->B0_PRV1	:= nEdit1
				
	SB0->(MsUnlock())
		
EndIf	

Return lRet

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ValProd  ∫Autor  ≥                 o ∫ Data ≥  04/01/10     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥    					                                      ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/ 
Static Function ValProd( cProd, cCli, cLoja )

Local lRet := .F.

If !Empty ( cProd )

	If Existchav("SB1",xFilial("SB1")+cProd,1)
		
		If !SA7->(dbSetOrder(2), dbSeek( xFilial( "SA7" )+ ALLTRIM ( cProd ) ) )
			
			lRet := .T.
			
		Else
			
			MsgAlert( "Produto j· relacionado a outro cÛdigo de cliente. " )
			lRet := .F.
			
		EndIf
	
	ElseIf !Existchav("SB1",xFilial("SB1")+cProd,1)	
		
		MsgAlert( "Produto n„o Cadastrado"+cProd+"." )
		lRet := .F.
			
	EndIf
	
Else

	MsgAlert( "Codigo do Produto em Branco." )
	lRet := .F.
	
EndIf

Return 	lRet