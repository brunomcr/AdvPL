#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Funcao>: LJ7002
<Descricao> : Ponto de Entrada chamado depois da gravaÁ„o de todos os dados e da impress„o do cupom fiscal na Venda Assistida e apÛs o processamento 
			  do Job LjGrvBatch(FRONT LOJA).
<Autor> : Renan Ros·rio
<Data> : 18/10/18
<Parametros> : Nil
<Retorno> : Nil
<Processo> : Loja
<Tipo> : 
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
User Function LJ7002 ()

Local nParTipo      := PARAMIXB[1] //(1-orcamento  2-venda  3-pedido)
Local lTroco		:= ( SL1->L1_NUM == NIL )
Local __nTroco		:= ''
Local __nDoaca		:= ''
Local _cQuery		:= ''
Local aArea  		:= GetArea()
Local cAlias 		:= GetNextAlias()

Local aSE1 			:= {}
Local _cDoc			:= ''
Local _cSerie		:= ''
Local _cCliente		:= ''
Local _cLojaCli		:= ''
Local _cNomeCli		:= ''
Local _dEmissao		:= ''
Local _dVencto		:= ''
Local _dVencrea		:= ''
Local _cPrefixo		:= ''
Local _cFonec		:= SuperGetMV( "MV_LJFORIA" )
Local _cLojFor		:= SuperGetMV( "MV_LJLOJIA" )
Local _cNatu		:= SuperGetMV( "MV_LJNATIA" )
Local _cDoac		:= SuperGetMV( "MV_LJPREIA" )
Local _cNomeFor		:= POSICIONE("SA2", 1, xFilial("SA2") + _cFonec + _cLojFor , "A2_NREDUZ")
Local _nValTot		:= 0
	
If !Empty ( SL1->L1_NUM ) .AND. !lTroco
		
	_cDoc	:= SL1->L1_DOC
		
	DbSelectArea("MGK")
				
	If MGK->( dbSetOrder( 3 ), dbSeek( xFilial( "MGK" ) + AllTrim ( SL1->L1_NUM  ) ) )
		
		__nTroco	:= SL1->L1_TROCO1 - MGK->MGK_VALOR
		__nDoaca	:= MGK->MGK_VALOR
		
		RecLock("SL1",.F.)
			
			//SL1->L1_TROCO1		:= __nTroco
			SL1->L1_VLRARR     	:= MGK->MGK_VALOR
					
		SL1->(MsUnlock())
		
		/*If !Empty ( _cDoc )
		
			If SE1->( dbSetOrder( 1 ), dbSeek( xFilial( "SE1" ) + AllTrim ( SL1->L1_SERIE  ) +  AllTrim ( SL1->L1_DOC  ) ) )
				
				_dEmissao		:= SE1->E1_EMISSAO
				_dVencto		:= SE1->E1_VENCTO
				_dVencrea		:= SE1->E1_VENCREA
				_cCliente		:= SE1->E1_CLIENTE
				_cLojaCli		:= SE1->E1_LOJA
				_cPrefixo		:= SE1->E1_PREFIXO
				_cNomeCli		:= SE1->E1_NOMCLI
				
				//Exceauto titulo Receber
				aSE1 := { { "E1_FILIAL"  	, xFilial( "SE1" )     				, NIL },; 
						{ "E1_PREFIXO"  	, _cDoac          				  	, NIL },;
						{ "E1_NUM"      	, AllTrim ( _cDoc )	            	, NIL },;
						{ "E1_TIPO"     	, "COD"              				, NIL },;
						{ "E1_NATUREZ"  	, AllTrim ( _cNatu )             	, NIL },;
						{ "E1_CLIENTE"  	, AllTrim ( _cCliente )          	, NIL },;
						{ "E1_LOJA"  		, AllTrim ( _cLojaCli )          	, NIL },;
						{ "E1_NOMCLI"  		, AllTrim ( _cNomeCli )          	, NIL },;
						{ "E1_EMISSAO"  	, _dEmissao							, NIL },;
						{ "E1_VENCTO"   	, _dVencto							, NIL },;
						{ "E1_VENCREA"  	, _dVencrea							, NIL },;
						{ "E1_VALOR"    	, __nDoaca             				, NIL } }
 
				MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - AlteraÁ„o, 5 - Exclus„o
				 
				 
				If lMsErroAuto
				
				    MostraErro()
				
				Else
				
				    Alert("TÌtulo a Receber DoaÁ„o incluÌdo com sucesso!")
				    
				    If SE1->( dbSetOrder( 1 ), dbSeek( xFilial( "SE1" ) + AllTrim ( SL1->L1_SERIE  ) +  AllTrim ( SL1->L1_DOC  ) ) )
				    	
				    	_nValTot	:=	SE1->E1_VALOR
				    	
				    	RecLock("SE1", .F.)
				    		
				    		SE1->E1_VALOR := _nValTot - __nDoaca 
				    		
				    	SE1->(MsUnlock())
				    	
				    EndIf	
				
				Endif
							
				If SE5->( dbSetOrder( 4 ), dbSeek( xFilial( "SE5" ) + Alltrim ( 'TROCO' ) + AllTrim ( SL1->L1_SERIE  ) +  AllTrim ( SL1->L1_DOC  ) ) ) //E5_NATUREZ, E5_PREFIXO, E5_NUMERO
						
					RecLock("SE5",.F.)
			
						SE5->E5_VALOR		:= __nTroco 
					
					SE5->(MsUnlock())	
					
				EndIf
				
			EndIf
		
		EndIf*/
		
	EndIf
		
EndIf

MsgAlert("Teste LJ7002....")

Return .T.