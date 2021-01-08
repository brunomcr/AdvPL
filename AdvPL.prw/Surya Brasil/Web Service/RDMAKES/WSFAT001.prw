#INCLUDE "protheus.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE 'DIRECTRY.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"
#INCLUDE "LOJNFCE.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "RPTDEF.CH"
 
/* ===============================================================================
Fonte	  -	WSFAT002
Descriï¿½ï¿½o - Tela para gerar a etiqueta manualmente.
Autor	  - Vinicius Martins
Data	  - 18/04/2019
=============================================================================== */
User Function WSFAT002()
Local oButton1
Local oButton2
//Local oGet1
Local cGet1 := "000000000"
//Local oGet2
Local cGet2 := "000"
Local oGroup1
Local oSay1
Local oSay2
Local oSay3
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "TOTVS" FROM 000, 000  TO 185, 370 COLORS 0, 16777215 PIXEL

    @ 003, 004 GROUP oGroup1 TO 075, 182 PROMPT " Gerar Etiqueta " OF oDlg COLOR 0, 16777215 PIXEL
    @ 018, 010 SAY oSay1 PROMPT "Informe o nï¿½mero do documento e sï¿½rie que deseja gerar a etiqueta:" SIZE 166, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 033, 009 SAY oSay2 PROMPT "Documento:" SIZE 032, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 046, 025 SAY oSay3 PROMPT "Sï¿½rie:" SIZE 013, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 031, 043 MSGET lblDoc VAR cGet1 SIZE 059, 010 OF oDlg COLORS 0, 16777215 ON CHANGE 000000000 PIXEL
    @ 043, 043 MSGET lblSerie VAR cGet2 SIZE 026, 010 OF oDlg COLORS 0, 16777215 ON CHANGE 000 PIXEL
    @ 076, 144 BUTTON oButton1 PROMPT "Ok" SIZE 037, 012 OF oDlg ACTION (Gera_Etiq(lblDoc:ctext,lblSerie:ctext), oDlg:End() ) PIXEL
    @ 076, 104 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED
 
Return

Static Function Gera_Etiq(cDoc, cSerie)

	Local cQuery	:= ""
	Local _cAlias 	:= GetNextAlias()

	cQuery := " SELECT DISTINCT C5_NUM [PEDIDO], D2_DOC [DOC], A1_NOME [NOME_CLI] "
	cQuery += " , CASE WHEN LEN(A1_END) > 50 THEN SUBSTRING(LTRIM(RTRIM(A1_END)),1,50) ELSE LTRIM(RTRIM(A1_END)) END AS [ENDERECO] "
	cQuery += " , CASE WHEN LEN(A1_END) > 50 THEN SUBSTRING(LTRIM(RTRIM(A1_END)),50,50) + '#Complemento do Endereï¿½o: ' + RTRIM(LTRIM(A1_COMPLEM))" 
	cQuery += " WHEN RTRIM(LTRIM(A1_COMPLEM)) = '' THEN '' ELSE '#Complemento do Endereï¿½o: ' + RTRIM(LTRIM(A1_COMPLEM)) END AS [OBS]"
	cQuery += " , A1_BAIRRO [BAIRRO], A1_EST [UF], A1_MUN [CIDADE] "
	cQuery += " , SUBSTRING(A1_CEP,1,5) + '-' + SUBSTRING(A1_CEP,6,3) [CEP] "
	cQuery += " , SUBSTRING(A1_CGC,1,3) + '.' + SUBSTRING(A1_CGC,4,3) + '.' + SUBSTRING(A1_CGC,7,3) + '-' + SUBSTRING(A1_CGC,10,2) [CPF] "
	cQuery += " , F2_TRANSP [TRANSPORTADORA]"
	cQuery += " FROM SC5030 SC5 "
	cQuery += " LEFT JOIN SD2030 SD2 "
	cQuery += " ON SD2.D2_PEDIDO = C5_NUM AND SD2.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SA1030 SA1 "
	cQuery += " ON SA1.A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI "
	cQuery += " LEFT JOIN SF2030 SF2 "
	cQuery += " ON F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND SF2.D_E_L_E_T_ = '' "
	cQuery += " WHERE SC5.D_E_L_E_T_ = '' "
	cQuery += " AND D2_DOC = '" + cDoc + "' AND D2_SERIE = '" +cSerie+ "' "
	cQuery := changequery(cQuery)
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), (_cAlias), .F., .T. )
	dbSelectArea(_cAlias)
	dbGoTop()
	
	If !empty((_cAlias)->DOC)
		MsgRun("Gerando etiqueta...", "TOTVS", {|| U_WSFAT001( .F., alltrim((_cAlias)->PEDIDO),  alltrim((_cAlias)->DOC), alltrim((_cAlias)->NOME_CLI),alltrim((_cAlias)->ENDERECO),alltrim((_cAlias)->BAIRRO),alltrim((_cAlias)->UF),alltrim((_cAlias)->CIDADE),alltrim((_cAlias)->CEP),alltrim((_cAlias)->CPF),alltrim((_cAlias)->OBS), alltrim((_cAlias)->TRANSPORTADORA) ) })
	Else
		Alert("Documento nao encontrado!")
	EndIf
	
Return

/* ===============================================================================
Fonte	  -	WSFAT001
Descriï¿½ï¿½o - Fonte responsï¿½vel por consumir o Web Service dos Correios
			para capturar a etiqueta do pedido.
Autor	  - Vinicius Martins
Data	  - 13/03/2019
=============================================================================== */
User Function WSFAT001(lAuto, cPedido, cnotaFiscal, cnomeDestinatario,cenderecoDestinatario, cbairroDestinatario, cufDestinatario,ccidadeDestinatario, ccepDestinatario, ccpfCnpjDestinatario, cObs, cTransportadora)
 
	//Variaveis contendo as informaï¿½ï¿½es para consumir o WS - Mï¿½todo PrePostarObjetoV5
	Local ccnpj 					:= '04.457.868/0001-76' //'73.186.116/0001-30' -> homolog 
	Local cnumeroCartao 			:= '0066844347' // '0067059090' -> homolog
	Local nnumeroDestinatario		:= 0
	Local ccomplementoDestinatario	:= strtran(Substr( cObs,1,at('#',cObs) ),'#','')
	Local ncodigoDoServico			:= Val(cTransportadora) //04162
	Local npesoReal					:= 100
	Local nvalorDeclarado			:= 0
	Local naltura					:= 2
	Local nlargura					:= 11
	Local ncomprimento				:= 16
	Local ndiametro					:= 0
	Local ntipoEmbalagem			:= 1
	Local lavisoDeRecebimento		:= .F.
	Local lmaoPropria				:= .F.
	Local lnumeroDeRegistro			:= .T.
	Local cemail					:= ''
	Local ccelularDestinatario		:= ''
	Local cobservacoes				:= strtran(Substr( cObs,at('#',cObs),len(alltrim(cObs)) ),'#','')
	Local ldescConteudo				:= .F.
	Local oWSlistaConteudo			:= ''
	Local cusuario 					:= 'SuryaWS' // 'HomologacaoMP' -> homolog
	Local csenha 					:= 'Duh4PAbbQ14c5zl' // 'Dej6PFEcPiNGyHm1JK' -> homolog
	
	//Variaveis contendo as informaï¿½ï¿½es para consumir o WS - RetornaEtiquetasParaImpressao
	Local aRegistros 				:= {}
	Local limpressoraZebra 			:= .T.
	Local oWSregistros  			:= ''
	Local cRetorno					:= ''
	local _cDest	    			:= GetMV("SB_DESTFTP")
	local _cCopy	    			:= GetMV("SB_COPYFTP")
	
	//Variaveis para salvar arquivo em .PDF
	Local cLocal	 				:= "\Dossie\"
	Local cArqPdf	 				:= ""
	Local cArqOk					:= ""
	//Variaveis para verificar os arquvios salvos em .PDF
	Local nI					:= 0
	Local nIx					:= 99
	Local cMsgErro 				:= UPPER(FwNoAccent("Nao foi encontrada precificacao. ERP-007: CEP de origem nao pode postar para o CEP de destino informado(-1).|Servico nao e aceito para essa Origem e Destino!"))
	Local cRetErro				:= ""
	Local aArqEtq				:= {}
	
	//Variaveis para controle de pedidos que já foram prepostados e estão retornand para o processo
	Local lVldPost					:= .T.
	Local nLog 						:= 0
	Local nErro						:= 0
	Local cWsReErro					:= ""
	Local cError   					:= ""
	Local bError   					:= ErrorBlock({ |oError| cError := oError:Description})
	Private oPrinter
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	
	If DbSeek("00"+cPedido)
		cCodPlp := ALLTRIM(STRTRAN(SC5->C5_XRASTRE,"-"," "))
nIx := 0 //Debug
		IF !EMPTY(cCodPlp)
			BEGIN SEQUENCE 
					_oWs := WSService1():New()
					_oWs:cnumeroRegistro 	:= cCodPlp				//Numero do registro de postagem
					_oWs:cusuario			:= cusuario				// Usuï¿½rio
					_oWs:csenha				:= csenha				// Senha
					_oWs:RetornaDadosPrePostagem(cCodPlp,cusuario,csenha)
					nErro := _oWs:OWSRETORNADADOSPREPOSTAGEMRESULT:NERRO
			END SEQUENCE
			ErrorBlock(bError)
nIx := 0 //Debug
			IF nErro == 0
				lVldPost := .F.
				aadd(aRegistros,cCodPlp)
				nLog := FCREATE(cLocal+cPedido+"\EtiquetaPrePostada.txt")
				if nLog = -1
					conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
					CONOUT("O Codigo: "+cCodPlp+ " de pre-postagem da Etiqueta do pedido " + cPedido +" que ja estava gravado é valido assim será gerado o pdf da mesma.")
				else
					FWrite(nLog,"O Codigo: "+cCodPlp+ " de pre-postagem da Etiqueta do pedido " + cPedido +" que ja estava gravado no mesmo é valido assim será gerado o pdf da mesma")
					FClose(nLog)
				endif
			ELSE
				lVldPost := .T.
				
				cWsReErro := _oWs:OWSRETORNADADOSPREPOSTAGEMRESULT:CMSGERRO
				nLog := FCREATE(cLocal+cPedido+"\ErroEtiquetaPrePostada.txt")
				if nLog = -1
					conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
					CONOUT("O Codigo: "+cCodPlp+ " de pre-postagem da Etiqueta do pedido " + cPedido +" que ja estava gravado no mesmo nao é valido.")
				else
					FWrite(nLog,"O Codigo: "+cCodPlp+ " de pre-postagem da Etiqueta do pedido " + cPedido +" que ja estava gravado no mesmo nao é valido." +CRLF+"**** _ "+cError+" _***"+CRLF+"Erro de retorno do WS: "+cWsReErro)
					FClose(nLog)
				endif
			ENDIF
		ELSE
			lVldPost := .T.	
nIx := 0 //Debug
			 cError  := ""
			 bError  := ErrorBlock({ |oError| cError := oError:Description})
		ENDIF	
	ENDIF

nIx := 0 //Debug
/*	Local nX

	aFiles := Directory( cLocal + "*.rel*", "D")
	
	nCount := Len(aFiles)
	For nX := 1 to nCount
		FERASE(cLocal + aFiles[nX,1])
	Next nX
*/
	// Criando o objeto Web Service
	_oWs := WSService1():New()
	_oWs:ccnpj						:= ccnpj
	_oWs:cnumeroCartao				:= cnumeroCartao
	_oWs:cnomeDestinatario			:= cnomeDestinatario
	_oWs:cenderecoDestinatario		:= cenderecoDestinatario
	_oWs:nnumeroDestinatario		:= nnumeroDestinatario
	_oWs:ccomplementoDestinatario	:= ccomplementoDestinatario
	_oWs:cbairroDestinatario		:= cbairroDestinatario
	_oWs:cufDestinatario			:= cufDestinatario
	_oWs:ccidadeDestinatario		:= ccidadeDestinatario
	_oWs:ccepDestinatario			:= ccepDestinatario
	_oWs:ccpfCnpjDestinatario		:= ccpfCnpjDestinatario
	_oWs:cnotaFiscal				:= cnotaFiscal
	_oWs:cPedido					:= cPedido
	_oWs:ncodigoDoServico			:= ncodigoDoServico
	_oWs:npesoReal					:= npesoReal
	_oWs:nvalorDeclarado			:= nvalorDeclarado
	_oWs:naltura					:= naltura
	_oWs:nlargura					:= nlargura
	_oWs:ncomprimento				:= ncomprimento
	_oWs:ndiametro					:= ndiametro
	_oWs:ntipoEmbalagem				:= ntipoEmbalagem
	_oWs:lavisoDeRecebimento		:= lavisoDeRecebimento
	_oWs:lmaoPropria				:= lmaoPropria
	_oWs:lnumeroDeRegistro			:= lnumeroDeRegistro
	_oWs:cemail						:= cemail
	_oWs:cobservacoes				:= cobservacoes
	_oWs:ccelularDestinatario		:= ccelularDestinatario
	_oWs:ldescConteudo				:= ldescConteudo
	_oWs:oWSlistaConteudo			:= oWSlistaConteudo
	_oWs:cusuario					:= cusuario
	_oWs:csenha						:= csenha
	
	IF lVldPost //Caso precise gerar a pré postagem executa.
		//Executa o mï¿½todo para retornar o Nï¿½mero de Registro 
		_oWs:PrePostarObjetoV5(ccnpj,cnumeroCartao,cnomeDestinatario,cenderecoDestinatario,nnumeroDestinatario,ccomplementoDestinatario,cbairroDestinatario,cufDestinatario,ccidadeDestinatario,ccepDestinatario,ccpfCnpjDestinatario,cnotaFiscal,cPedido,ncodigoDoServico,npesoReal,nvalorDeclarado,naltura,nlargura,ncomprimento,ndiametro,ntipoEmbalagem,lavisoDeRecebimento,lmaoPropria,lnumeroDeRegistro,cemail,cobservacoes,ccelularDestinatario,ldescConteudo,oWSlistaConteudo,cusuario,csenha)
		//Resultado
		oWSregistros := _oWs:OWSPREPOSTAROBJETOV5RESULT:CNUMEROREGISTRO
nIx := 0 //Debug
		/*Envia e-mail caso tenha algum erro de cadastro*/
		if !empty(_oWs:OWSPREPOSTAROBJETOV5RESULT:CMMSGERRO) .and. lAuto == .T.
			envEcom2("Erro ao gerar Etiqueta", "ATENÇÃO - ERRO AO GERAR ETIQUETA", "Ocorreu um erro ao gerar etiqueta do pedido: " + cPedido + ", Erro: " + _oWs:OWSPREPOSTAROBJETOV5RESULT:CMMSGERRO,"",_cDest,_cCopy)
			//envEcom2("Erro ao gerar Etiqueta", "ATENÃ‡ÃƒO - ERRO AO GERAR ETIQUETA", "Ocorreu um erro ao gerar etiqueta do pedido: " + cPedido + ", Erro: " + _oWs:OWSPREPOSTAROBJETOV5RESULT:CMMSGERRO,"","alexsandro.lima@suryabrasil.com","alexsandro.lima@suryabrasil.com")	
			cRetErro := UPPER(FwNoAccent(_oWs:OWSPREPOSTAROBJETOV5RESULT:CMMSGERRO))

			If ncodigoDoServico == 04669 .And.  cRetErro $ cMsgErro 
				U_WSFAT001(lAuto, cPedido, cnotaFiscal, cnomeDestinatario,cenderecoDestinatario, cbairroDestinatario, cufDestinatario,ccidadeDestinatario, ccepDestinatario, ccpfCnpjDestinatario, cObs, '04162')
			EndIf
			
			Return
		ElseIf !Empty(_oWs:OWSPREPOSTAROBJETOV5RESULT:CMMSGERRO) .and. lAuto == .F.
			MSGALERT(_oWs:OWSPREPOSTAROBJETOV5RESULT:CMMSGERRO)
			Return
		end
nIx := 0 //Debug
		dbSelectArea("SC5")
		dbSetOrder(1)
		If DbSeek("00"+cPedido)
			RecLock( 'SC5', .F. )
			SC5->C5_XRASTRE	:= oWSregistros + 'BR'
			SC5->(msUnlock())
		EndIf
		aadd(aRegistros,oWSregistros)
nIx := 0 //Debug
	ENDIF

	
	// Criando o objeto Web Service
	_oWs := WSService1():New()
	_oWs:ccnpj				:= ccnpj				// CNPJ
	_oWs:cnumeroCartao		:= cnumeroCartao		// Nï¿½ Cartï¿½o
	_oWs:oWSregistros		:= aRegistros			// Registros
	_oWs:limpressoraZebra	:= limpressoraZebra		// Impressora Zebra
	_oWs:cusuario			:= cusuario				// Usuï¿½rio
	_oWs:csenha				:= csenha				// Senha
	                            
	// Executa o metodo RetornaEtiquetasParaImpressao
	_oWs:RetornaEtiquetasParaImpressao( ccnpj,cnumeroCartao,aRegistros,limpressoraZebra,cusuario,csenha )
	
	// Retorno do PDF com a etiqueta 	
	cRetorno := _oWs:cRetornaEtiquetasParaImpressaoResult

	cArqOk := cLocal+cPedido+"\"
	
	//Cria PDF
	If oPrinter == Nil .and. !Empty(cRetorno) .and. lAuto == .T.

		lAdjustToLegacy 	:= .F.
		oPrinter 			:= FWMSPrinter():New("etiqueta_"+cPedido, IMP_SPOOL , lAdjustToLegacy, cLocal, .T.,.f., , , .t., , ,,"1" )
		oPrinter:StartPage()
		oPrinter:lserver 	:= .T.
		oPrinter:lInJob 	:= .T.
		oPrinter:cSession :=""
		oPrinter:Say(10,10,cRetorno, , ,)
		oPrinter:EndPage()
		
		oPrinter:preview()

		cArqPdf := oPrinter:cfileprint
		
		//Copia para pasta Dossie
		__CopyFile(cArqPdf, cArqOk+"Etiqueta_"+cPedido+".pdf")
		aArqEtq := DIRECTORY(cArqOk+"Etiqueta_"+cPedido+".pdf","D")
nIx := 0 //Debug
		//Apaga arquivo .rel
		FERASE(cArqPdf)
		
		FreeObj(oPrinter)
		While (!FILE(cArqOk+"Etiqueta_"+cPedido+".pdf") .Or. aArqEtq[1][2] <= 30000)  .AND. nI <=10
			// Executa o metodo RetornaEtiquetasParaImpressao
			_oWs:RetornaEtiquetasParaImpressao( ccnpj,cnumeroCartao,aRegistros,limpressoraZebra,cusuario,csenha )
			// Retorno do PDF com a etiqueta 	
			cRetorno := _oWs:cRetornaEtiquetasParaImpressaoResult

			lAdjustToLegacy 	:= .F.
			oPrinter 			:= FWMSPrinter():New("etiqueta_"+cPedido, IMP_SPOOL , lAdjustToLegacy, cLocal, .T.,.f., , , .t., , ,,"1" )
			oPrinter:StartPage()
			oPrinter:lserver 	:= .T.
			oPrinter:lInJob 	:= .T.
			oPrinter:cSession :=""
			oPrinter:Say(10,10,cRetorno, , ,)
			oPrinter:EndPage()
		
			oPrinter:preview()

			cArqPdf := oPrinter:cfileprint
		
			//Copia para pasta Dossie
			__CopyFile(cArqPdf, cArqOk+"Etiqueta_"+cPedido+".pdf")

			//Apaga arquivo .rel
			FERASE(cArqPdf)
			FreeObj(oPrinter)

			SLEEP( 10000 )
			nI ++
			aArqEtq := {} //Zera o Array
			aArqEtq := DIRECTORY(cArqOk+"Etiqueta_"+cPedido+".pdf","D") //Procura novamente pela etiqueta.
			IF nI >=10 .AND. !FILE(cArqOk+"Etiqueta_"+cPedido+".pdf")
				envEcom2("Erro ao gravar Etiqueta", "ATENÇÃO - ERRO AO GRAVAR ETIQUETA", "A etiqueta do pedido: " + cPedido + ", Não foi gerada!! Verifique a pasta Dossie! ",_cDest,_cCopy)
			//	envEcom2("Erro ao gravar Etiqueta", "ATENÃ‡ÃƒO - ERRO AO GRAVAR ETIQUETA", "Ocorreu um erro ao gravar etiqueta do pedido: " + cPedido + ", Verifique a pasta Dossie ","alexsandro.lima@suryabrasil.com","alexsandrosallalima@gmail.com")
			ELSEIF nI >= 10 .AND. aArqEtq[1][2] <= 30000
				FERASE(cArqOk+"Etiqueta_"+cPedido+".pdf")						
				envEcom2("Erro ao gravar Etiqueta", "ATENÇÃO - ERRO AO GRAVAR ETIQUETA", "A etiqueta do pedido: " + cPedido + ", Foi gerada com erros por isso foi excluída!! Verifique a pasta Dossie ",_cDest,_cCopy)
				//envEcom2("Erro ao gravar Etiqueta", "ATENÃ‡ÃƒO - ERRO AO GRAVAR ETIQUETA", "Ocorreu um erro ao gravar etiqueta do pedido: " + cPedido + ", Verifique a pasta Dossie ","alexsandro.lima@suryabrasil.com","alexsandrosallalima@gmail.com")	
			ENDIF	
		END
nIx := 0 //Debug

	Elseif lAuto == .F.
		
		cLocal := cGetFile("Selecione o caminho",,2,"",.T.,GETF_LOCALHARD  + GETF_NETWORKDRIVE +  GETF_RETDIRECTORY , .F.)
		//cLocal := cGetFile("Arquivos PDF|*.PDF|Todos os Arquivos|*.*",OemToAnsi("Etiqueta..."),,,.T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE)
		
		lAdjustToLegacy 	:= .F.
		oPrinter 			:= FWMSPrinter():New("etiqueta_"+cPedido, IMP_SPOOL , lAdjustToLegacy, cLocal, .T.,.f., , , .t., , ,,"1" )
		oPrinter:StartPage()
		oPrinter:lserver 	:= .T.
		oPrinter:lInJob 	:= .F.
		//oPrinter:cSession :=""
		oPrinter:Say(10,10,cRetorno)
		oPrinter:EndPage()
		
		oPrinter:preview()
		
		FreeObj(oPrinter)
		
		//Copia e cola como .pdf
		__CopyFile(cLocal+"Etiqueta_"+cPedido+".rel", cLocal+"Etiqueta_"+cPedido+".pdf")

		//Apaga arquivo .rel
		FERASE(cLocal+"Etiqueta_"+cPedido+".rel")
		
		MSGALERT( "Etiqueta Gerada com sucesso!", "" )
		
	EndIf
	
Return

/* ===============================================================================
Fonte	  -	WSFAT001
Descriï¿½ï¿½o - Fonte responsï¿½vel por Enviar e-mail 

Autor	  - Vinicius Martins
Data	  - 13/03/2019
=============================================================================== */
Static Function envEcom2(cAssunto, cMensagem1, cMensagem2, cAnexo, cDest, cCopia)

			  oWorkFLW			 	 := TWEnviaEmail():New()
			  oWorkFLW:cConta        := "suryabrasil@shared.mandic.net.br"					    
			  oWorkFLW:cSenha        := "75XQF9qg"						
			  oWorkFLW:cDestinatario := cDest
			  oWorkFLW:cCopia		 := cCopia
			  oWorkFLW:cServerSMTP   := "sharedrelay-cluster.mandic.net.br"						
			  oWorkFLW:cDiretorio	 := "\workflow\html\Error_Generic.txt"
			  oWorkFLW:cAnexo		 := cAnexo
			 
			  oWorkFLW:cAssunto      := cAssunto
			  oWorkFLW:aDadosHTML    := { { "##cAtencao##" ,cMensagem1 },;
			  							{ "##cMensagem##"  , cMensagem2} }
			  //oWorkFLW:cMensagem	 := cMensagem
			  
			  oWorkFLW:EnviaEmail()
Return