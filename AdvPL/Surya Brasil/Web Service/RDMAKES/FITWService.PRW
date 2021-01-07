#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TRYEXCEPTION.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "aarray.ch"
#INCLUDE "shash.ch" 


WSStruct WSEstCustomers
	WsData __filial				AS String	Optional
	WsData __codigo				AS String	Optional
	WsData __loja				AS String	Optional
	WsData __pessoa				AS String
	WsData __nome				AS String
	WsData __nreduz				AS String
	WsData __endereco			AS String
	WsData __tipo				AS String 
	WsData __estado				AS String
	WsData __cod_municipio		AS String
	WsData __municipio			AS String
	WsData __bairro				AS String
	WsData __telefone			AS String
	WsData __cnpj_cgc			AS String
	WsData __InsEstadual		AS String
	WsData __CEP				AS String
	WsData __codpais			AS String
	WsData __venclimitecred		AS String
	WsData __condpagto			AS String
	WsData __freteFobCif		AS String
	WsData __msgreturn			AS String
	WsData __contato			As String   
	WsData __COMPL  			AS String	Optional
EndWSStruct

WSStruct Search_Customers
	WsData __adata			AS array OF WSSearchCustomers
EndWSStruct
 
WSStruct WSSearchCustomers
	WsData __cpf_cnpj		AS String	Optional
	WsData __busca_nome		AS String	Optional
EndWSStruct

WSStruct New_Customers
	WsData __adata			AS array OF WSNewCustomers
EndWSStruct

WSStruct WSNewCustomers
	WsData __filial			AS String	Optional
	WsData __codigo			AS String	Optional
	WsData __loja			AS String	Optional
	WsData __pessoa			AS String	Optional
	WsData __nome			AS String	Optional
	WsData __nreduz			AS String	Optional
	WsData __endereco		AS String	Optional
	WsData __tipo			AS String	Optional
	WsData __estado			AS String	Optional
	WsData __cidade			AS String	Optional
	WsData __cod_municipio	AS String	Optional
	WsData __municipio		AS String	Optional
	WsData __bairro			AS String	Optional
	WsData __ddd			AS String	Optional
	WsData __telefone		AS String	Optional
	WsData __cnpj_cgc		AS String	Optional
	WsData __InsEstadual	AS String	Optional
	WsData __CEP			AS String	Optional
	WsData __codpais		AS String	Optional
	WsData __email			AS String	Optional
	WsData __datadenascim	AS String	Optional
	WsData __contato		As String	Optional
	WsData __COMPL 			as String	Optional
EndWSStruct

WSStruct WSEstProduct
	WsData __filial				AS String	Optional
	WsData __codigo				AS String	Optional
	WsData __armazem			AS String	Optional
	WsData __descricao			AS String   Optional
	WsData __um					AS String   Optional
	WsData __grupo				AS String	Optional
	WsData __tipo				AS String	Optional
	WsData __msblql				AS String	Optional
	WsData __recursiva			AS String	Optional
	WsData __descricaogrupo		AS String	Optional
	WsData __grp_relacional		AS String	Optional
	WsData __codigo_magento		AS String	Optional
	WsData __pesobruto			AS Float	Optional
	WsData __precodevenda		AS Float	Optional
	WsData __precoB2B			AS Float	Optional
	WsData __saldo				AS Float	Optional
	WsData __precovendalojista	AS Float	Optional
	WsData __LTAdtven			AS String	Optional
	WsData __LTAlote			AS String	Optional
	WsData __LTAsallote			AS Float	Optional
	WsData __LTBdtven			AS String	Optional
	WsData __LTBlote			AS String	Optional
	WsData __LTBsallote			AS Float	Optional
	WsData __LTCdtven			AS String	Optional
	WsData __LTClote			AS String	Optional
	WsData __LTCsallote			AS Float	Optional
	WsData __msgreturn			AS String
	WsData __LOTEYN				AS String	Optional         //RODRIGO
EndWSStruct

WSStruct WSEstSalesOrder
	WsData __adata		AS array OF WSSalesHeader
EndWSStruct

WSStruct WSSalesHeader
	WsData __num				AS String	Optional
	WsData __tipo				AS String	Optional
	WsData __cliente			AS String
	WsData __nomecliente		AS String
	WsData __lojacliente		AS String	Optional
	WsData __lojaentrada		AS String	Optional
	WsData __tipocliente		AS String
	WsData __condpagamento		AS String	Optional
	WsData __msgreturn			AS String	Optional 
	WsData __cvendedor			AS String	Optional 
	WsData __cdcondpg			AS String	Optional 
	WsData __crastreio			AS String	Optional 
	WsData __ctransacao			AS String	Optional 
	WsData __cCanalS			AS String	Optional 
	WsData __aItems				AS array OF WSSalesItems
	WsData __EtiquetaMktPlace	AS String	Optional //Alex
	//WsData __EtiquetaMktPlace	AS base64Binary	Optional //Vinicius
	WsData __Prazo				As Date 	Optional //Alex
EndWSStruct

WSStruct WSSalesItems
	WsData __item				AS String	Optional
	WsData __produto			AS String
	WsData __descprod			AS String
	WsData __qtdvendida			AS String
	WsData __precovenda			AS String
	WsData __precounitario		AS String
	WsData __valor				AS String
	WsData __TES				AS String	Optional
	WsData __armazem			AS String	Optional
	WsData __lote				AS String	Optional
	WsData __Kitname			AS String	Optional
	// 	WsData __desc01 	AS String	Optional	
	//	WsData __prdescont  AS String	Optional		
EndWSStruct                                     

WSStruct Input_SalesOrder
	WsData __adata			AS array OF WSInpSales
EndWSStruct

WSStruct WSInpSales 
	WsData __num				AS String	Optional
	WsData __tipo				AS String	Optional
	WsData __cliente			AS String
	WsData __lojacliente		AS String	Optional
	WsData __lojaentrada		AS String	Optional
	WsData __tipocliente		AS String
	WsData __condpagamento		AS String	Optional
	WsData __aItems				AS Array OF sWSNewSalesItems
	WsData __unkey				AS String
	WsData __frete				AS String	Optional
	WsData __cCodTransp			AS String	Optional //Thiago 
	WsData __cvendedor			AS String	Optional //Thiago 
	WsData __cdcondpg			AS String	Optional //Thiago 
	WsData __crastreio			AS String	Optional //Thiago 
	WsData __ctransacao			AS String	Optional //Thiago 
	WsData __cCanalS			AS String	Optional //Thiago
	WsData __EtiquetaMktPlace	AS String	Optional //Alex
	//WsData __EtiquetaMktPlace	AS base64Binary	Optional //Vinicius
	WsData __Prazo				AS String		Optional //Alex
EndWSStruct

WSStruct sWSNewSalesItems
	WsData __item				AS String	Optional
	WsData __produto			AS String
	WsData __qtdvendida			AS String
	WsData __precovenda			AS String
	WsData __precounitario		AS String
	WsData __valor				AS String
	WsData __TES				AS String	Optional
	WsData __armazem			AS String	Optional
	WsData __lote				AS String	Optional
	WsData __Kitname			AS String	Optional
	//	WsData __desc01		AS String	Optional
	//	WsData __prdescont	AS String	Optional
EndWSStruct

WSStruct Search_Conveyor
	WsData __adata			AS array OF WSSearchConveyor
EndWSStruct

WSStruct WSSearchConveyor
	WsData __cpf_cnpj		AS String	Optional
	WsData __busca_nome		AS String	Optional
EndWSStruct

WSStruct WSEstConveyor
	WsData __filial			AS String	Optional
	WsData __codigo			AS String	Optional
	WsData __nome			AS String
	WsData __nreduz			AS String
	WsData __endereco		AS String
	WsData __bairro			AS String
	WsData __cod_municipio	AS String
	WsData __municipio		AS String
	WsData __estado			AS String
	WsData __ddd			AS String
	WsData __telefone		AS String
	WsData __cnpj_cgc		AS String
	WsData __InsEstadual	AS String
	WsData __CEP			AS String
	WsData __codpais		AS String
	WsData __msgreturn		AS String
	WsData __COMPL			AS String
EndWSStruct

/*

*/

WSService FITWService Description "Webservice utilizado para integração do e-commerce com o ERP"

	WsData __filial			AS String Optional
	WsData __codigo			AS String Optional
	WsData __msblql     	AS String Optional
	WsData __rangeini		AS String Optional
	WsData __rangefim		AS String Optional
	WsData __descrfim		AS String Optional
	WsData __operacao		AS String 
	WsData __login			AS String
	WsData __pws			AS String 
	WsData __recursiva		AS String Optional
	WsData __tabelaprc		AS String Optional
	WsData __tblogista      AS String Optional
	//	WsData __LOTE		AS String Optional

	WsData oException		AS String
	WsData cMsgSoapFault	AS String
	WsData lWsMethodRet		AS Boolean

	WsData aCustomers	  	AS array OF WSEstCustomers
	WsData aConveyor	  	AS array OF WSEstConveyor
	WsData __ArrCustomers   AS Search_Customers
	WsData __ArrConveyor	AS Search_Conveyor
	WsData __NewCustomers	AS New_Customers

	WsData aProduct		  	AS array OF WSEstProduct

	WsData aSalesOrder		AS array OF WSEstSalesOrder	
	WsData __ArrSalesOrder  AS Input_SalesOrder

	WSMethod WSCustomers 		Description "Tratativas especificas para Integracao de Clientes avulsos entre Protheus x Magento"
	WSMethod WSSalesOrder 		Description "Tratativas especificas para Integracao de Pedidos de Venda entre Protheus x Magento"
	WSMethod WSProduct			Description "Tratativas especificas para Integracao de Produtos entre Protheus x Magento"
	WSMethod WSConveyor			Description "Retorno de informacoes complementares referentes a transportadora | Protheus x Magento"
	//WSMethod WSPayCondition	Description "Retorna a condiÃƒÂ§ÃƒÂ£o de pagamento | Protheus x Magento"
EndWSService


////////////////////////////////////////////////////////////////////////////
//|Autor	|Thiago de Jesus      			| 12-02-2016 | Crail
//|Funcao   |WSProduct                      
//|Uso		|Listagem de Produtos via consumo WebServices
////////////////////////////////////////////////////////////////////////////

WSMethod WSProduct WSReceive __filial,__codigo,__msblql,__rangeini,__rangefim,__descrfim,__recursiva, __login, __pws, __tabelaprc, __tblogista  WSSend aProduct WSService FITWService

	local __retproduct 	:= {}
	local nX			:= 0
	local __Autetication:= {}
	local __wsSoapFault	:= ""

	default Self:__filial	:= ""	
	default Self:__codigo	:= ""
	default Self:__msblql	:= ""
	default Self:__rangeini	:= ""
	default Self:__rangefim	:= "" 
	default Self:__descrfim	:= ""
	default Self:__recursiva:= ""
	default	Self:__tabelaprc:= ""
	default	Self:__tblogista:= "" 

	TRYEXCEPTION
	__Autetication := aClone( __wblogin( Self:__login,Self:__pws ) )
	If( len(__Autetication) > 0 )
		If( !__Autetication[3] )
			SetSoapFault("[WS_SOAPFAULT]-ERR-4000012-WSMethod [WSProduct]", alltrim(__Autetication[1]))
			Return( .F. )
		EndIf
	EndIf    

	/*If( len(Self:__descrfim) < 4 )                                                               
	Self:cMsgSoapFault := "Obrigatoriamente o campo de filtro [Descricao] deve conter 4 caracteres.Por favor, refaca os filtros "
	Self:cMsgSoapFault += "e efetive a consulta novamente."
	SetSoapFault("[WS_SOAPFAULT]-ERR-4000010-WSMethod [WSProduct]", alltrim(Self:cMsgSoapFault))
	Return( .F. )
	EndIf*/
	Self:__filial 	:= TiraGraf(Self:__filial)
	Self:__codigo 	:= TiraGraf(Self:__codigo)
	Self:__msblql 	:= TiraGraf(Self:__msblql)
	Self:__rangeini := TiraGraf(Self:__rangeini)
	Self:__rangefim := TiraGraf(Self:__rangefim)
	Self:__descrfim := TiraGraf(Self:__descrfim)
	Self:__tabelaprc:= TiraGraf(Self:__tabelaprc)
	Self:__tblogista:= TiraGraf(Self:__tblogista)

	__retproduct 		:= ProdSearch(	Self:__filial,Self:__codigo,Self:__msblql,Self:__rangeini,Self:__rangefim,Self:__descrfim,@__wsSoapFault, Self:__recursiva, Self:__tabelaprc, Self:__tblogista )
	Self:aProduct 		:= {}
	Self:lWsMethodRet	:= .T.
	If len(__retproduct) > 0
		For nX := 1 To len(__retproduct)    
			AAdd( Self:aProduct, WSClassNew("WSEstProduct") )						
			Self:aProduct[nX]:__filial 			:= __retproduct[nX][01]
			Self:aProduct[nX]:__codigo    		:= __retproduct[nX][02]
			Self:aProduct[nX]:__armazem			:= __retproduct[nX][11]
			Self:aProduct[nX]:__descricao 		:= TiraGraf(__retproduct[nX][03])
			Self:aProduct[nX]:__um  			:= __retproduct[nX][12]
			Self:aProduct[nX]:__grupo     		:= __retproduct[nX][04]
			Self:aProduct[nX]:__tipo   			:= __retproduct[nX][13]
			Self:aProduct[nX]:__msblql  		:= __retproduct[nX][14]
			Self:aProduct[nX]:__recursiva  		:= __retproduct[nX][15]
			Self:aProduct[nX]:__descricaogrupo	:= TiraGraf(__retproduct[nX][05])
			Self:aProduct[nX]:__grp_relacional 	:= TiraGraf(__retproduct[nX][06])
			Self:aProduct[nX]:__codigo_magento 	:= __retproduct[nX][07]
			Self:aProduct[nX]:__pesobruto  		:= __retproduct[nX][08]
			Self:aProduct[nX]:__precodevenda  	:= __retproduct[nX][09]
			Self:aProduct[nX]:__precoB2B	  	:= __retproduct[nX][16]
			Self:aProduct[nX]:__saldo  			:= __retproduct[nX][10]
			
//			Self:aProduct[nX]:__sallote		    := __retproduct[nX][21]  .'.
//			Self:aProduct[nX]:__pridtven		:= __retproduct[nX][17] 
//			Self:aProduct[nX]:__prilote 		:= __retproduct[nX][18]
//			Self:aProduct[nX]:__ultdtven		:= __retproduct[nX][19]
//			Self:aProduct[nX]:__ultlote			:= __retproduct[nX][20]  
		
			Self:aProduct[nX]:__LTAdtven		:= __retproduct[nX][23]
			Self:aProduct[nX]:__LTAlote			:= __retproduct[nX][24]
			Self:aProduct[nX]:__LTAsallote		:= __retproduct[nX][25]
			Self:aProduct[nX]:__LTBdtven		:= __retproduct[nX][26]
			Self:aProduct[nX]:__LTBlote			:= __retproduct[nX][27]
			Self:aProduct[nX]:__LTBsallote		:= __retproduct[nX][28]
			Self:aProduct[nX]:__LTCdtven		:= __retproduct[nX][29]
			Self:aProduct[nX]:__LTClote			:= __retproduct[nX][30]
			Self:aProduct[nX]:__LTCsallote		:= __retproduct[nX][31] 
		  	Self:aProduct[nX]:__LOTEYN			:= __retproduct[nX][32]        //RODRIGO
			
			Self:aProduct[nX]:__precovendalojista:=__retproduct[nX][22]//Thiago

			Self:aProduct[nX]:__msgreturn 	  := "[MSG-WSProduct]  Integracao de Produtos efetuada com sucesso"
			If( !empty(__wsSoapFault) )                        
				Self:aProduct[nX]:__msgreturn := "[MSG-WSProduct] "+__wsSoapFault+""  
			EndIf
		Next nX
	Else
		nX := 1      
		Self:aProduct := {}
		AAdd( Self:aProduct, WSClassNew("WSEstProduct") )
		Self:aProduct[nX]:__filial 			:= "  "
		Self:aProduct[nX]:__codigo    		:= "  "
		Self:aProduct[nX]:__armazem			:= "  "
		Self:aProduct[nX]:__descricao 		:= "  "
		Self:aProduct[nX]:__um  			:= "  "
		Self:aProduct[nX]:__grupo     		:= "  "
		Self:aProduct[nX]:__tipo   			:= "  "
		Self:aProduct[nX]:__msblql  		:= "  "
		Self:aProduct[nX]:__recursiva  		:= "  "
		Self:aProduct[nX]:__descricaogrupo	:= "  "
		Self:aProduct[nX]:__grp_relacional 	:= "  "
		Self:aProduct[nX]:__codigo_magento 	:= "  "
		Self:aProduct[nX]:__pesobruto  		:= 0
		Self:aProduct[nX]:__precodevenda  	:= 0
		Self:aProduct[nX]:__precoB2B	  	:= 0
		Self:aProduct[nX]:__saldo  			:= 0
		
//		Self:aProduct[nX]:__sallote  		:= 0        .'.
//		Self:aProduct[nX]:__pridtven  		:= "  "
//		Self:aProduct[nX]:__prilote  		:= "  "
//		Self:aProduct[nX]:__ultdtven 		:= "  "
//		Self:aProduct[nX]:__ultlote  		:= "  "    
	
		Self:aProduct[nX]:__LTAdtven		:= "  "
		Self:aProduct[nX]:__LTAlote			:= "  "
		Self:aProduct[nX]:__LTAsallote		:= "  "
		Self:aProduct[nX]:__LTBdtven		:= "  "
		Self:aProduct[nX]:__LTBlote			:= "  "
		Self:aProduct[nX]:__LTBsallote		:= "  "
		Self:aProduct[nX]:__LTCdtven		:= "  "
		Self:aProduct[nX]:__LTClote			:= "  "
		Self:aProduct[nX]:__LTCsallote		:= "  "		
		
		Self:aProduct[nX]:__precovendalojista:= 0
		Self:aProduct[nX]:__msgreturn := "[MSG-WSProduct] Nao foram encontrados dados para procesamento da requisicao"
		If( !empty(__wsSoapFault) )                        
			Self:aProduct[nX]:__msgreturn := "[MSG-WSProduct] "+__wsSoapFault+""  
		EndIf
	EndIf	
	CATCHEXCEPTION USING Self:oException
	If ( ValType( Self:oException ) == "O" )
		Self:cMsgSoapFault := ""
		Self:cMsgSoapFault += IF( !Empty( Self:oException:Description )	, Self:oException:Description	, "" )
		Self:cMsgSoapFault += IF( !Empty( Self:oException:ErrorStack )		, Self:oException:ErrorStack 	, "" )
		SetSoapFault("[WS_SOAPFAULT]-ERR-4000012-WSMethod [WSProduct]", alltrim(Self:cMsgSoapFault))
	EndIf
	Self:lWsMethodRet := .F.			
	ENDEXCEPTION                                       

Return( Self:lWsMethodRet )


////////////////////////////////////////////////////////////////////////////
//|Autor	|Thiago de Jesus      			| 15-02-2016 | Crail
//|Funcao   |WSCustomers                      
//|Uso		|Trabalhando com Clientes via consumo WebServices
////////////////////////////////////////////////////////////////////////////

WSMethod WSCustomers WSReceive __ArrCustomers,__operacao,__NewCustomers,__login,__pws WSSend aCustomers WSService FITWService

	local __retcustomers 	:= {}
	local nX				:= 0
	local __wsSoapFault		:= ""
	local __Autetication:= {}

	default Self:__operacao	:= ""

	TRYEXCEPTION
	__Autetication := aClone( __wblogin( Self:__login,Self:__pws ) )
	If( len(__Autetication) > 0 )
		If( !__Autetication[3] )
			SetSoapFault("[WS_SOAPFAULT]-ERR-5000012-WSMethod [WSCustomers]", alltrim(__Autetication[1]))
			Return( .F. )
		EndIf
	EndIf

	__retcustomers := CustmSearch(Self:__ArrCustomers, Self:__operacao, Self:__NewCustomers, @__wsSoapFault)
	Self:aCustomers 	:= {}
	Self:lWsMethodRet	:= .T.
	If len(__retcustomers) > 0
		For nX := 1 To len(__retcustomers)
			AAdd( Self:aCustomers, WSClassNew("WSEstCustomers") )
			Self:aCustomers[nX]:__filial 		:= __retcustomers[nX][01]
			Self:aCustomers[nX]:__codigo    	:= __retcustomers[nX][02]
			Self:aCustomers[nX]:__loja			:= __retcustomers[nX][03]
			Self:aCustomers[nX]:__pessoa 		:= __retcustomers[nX][04]
			Self:aCustomers[nX]:__nome  		:= alltrim(__retcustomers[nX][05])
			Self:aCustomers[nX]:__nreduz     	:= alltrim(__retcustomers[nX][06])
			Self:aCustomers[nX]:__endereco   	:= alltrim(__retcustomers[nX][07])
			Self:aCustomers[nX]:__tipo  		:= __retcustomers[nX][08]
			Self:aCustomers[nX]:__estado		:= alltrim(__retcustomers[nX][09])
			Self:aCustomers[nX]:__cod_municipio := __retcustomers[nX][10]
			Self:aCustomers[nX]:__municipio 	:= alltrim(__retcustomers[nX][11])
			Self:aCustomers[nX]:__bairro  		:= alltrim(__retcustomers[nX][12])
			Self:aCustomers[nX]:__telefone  	:= alltrim(__retcustomers[nX][13])
			Self:aCustomers[nX]:__cnpj_cgc  	:= alltrim(__retcustomers[nX][14])
			Self:aCustomers[nX]:__InsEstadual  	:= alltrim(__retcustomers[nX][15])
			Self:aCustomers[nX]:__CEP  			:= __retcustomers[nX][16]
			Self:aCustomers[nX]:__codpais  		:= __retcustomers[nX][17]
			Self:aCustomers[nX]:__venclimitecred:= DTOC( __retcustomers[nX][18] )
			Self:aCustomers[nX]:__condpagto		:= __retcustomers[nX][19]
			Self:aCustomers[nX]:__freteFobCif	:= __retcustomers[nX][20]
			Self:aCustomers[nX]:__contato		:= __retcustomers[nX][21]
			//Self:aCustomers[nX]:__COMPL		:= __retcustomers[nX][22]
			Self:aCustomers[nX]:__msgreturn := "[MSG-WSCustomers]  Integracao de Clientes efetuada com sucesso"
			If( !empty(__wsSoapFault) )
				Self:aCustomers[nX]:__msgreturn := "[MSG-WSCustomers] "+__wsSoapFault+""
			EndIf
		Next nX
	Else
		nX := 1
		Self:aCustomers := {}
		AAdd( Self:aCustomers, WSClassNew("WSEstCustomers") )
		Self:aCustomers[nX]:__filial 		:= " "
		Self:aCustomers[nX]:__codigo    	:= " "
		Self:aCustomers[nX]:__loja			:= " "
		Self:aCustomers[nX]:__pessoa 		:= " "
		Self:aCustomers[nX]:__nome  		:= " "
		Self:aCustomers[nX]:__nreduz     	:= " "
		Self:aCustomers[nX]:__endereco   	:= " "
		Self:aCustomers[nX]:__tipo  		:= " "
		Self:aCustomers[nX]:__estado		:= " "
		Self:aCustomers[nX]:__cod_municipio := " "
		Self:aCustomers[nX]:__municipio 	:= " "
		Self:aCustomers[nX]:__bairro  		:= " "
		Self:aCustomers[nX]:__telefone  	:= " "
		Self:aCustomers[nX]:__cnpj_cgc  	:= " "
		Self:aCustomers[nX]:__InsEstadual  	:= " "
		Self:aCustomers[nX]:__CEP  			:= " "
		Self:aCustomers[nX]:__codpais  		:= " "
		Self:aCustomers[nX]:__venclimitecred:= "  /  /  "
		Self:aCustomers[nX]:__condpagto		:= " "
		Self:aCustomers[nX]:__freteFobCif	:= " "
		Self:aCustomers[nX]:__contato		:= " "
		Self:aCustomers[nX]:__COMPL			:= " "

		If AllTrim(Self:__operacao) == "V"
			Self:aCustomers[nX]:__msgreturn := ""
		Else
			Self:aCustomers[nX]:__msgreturn := "[MSG-WSCustomers] Nao foram encontrados dados para procesamento da requisicao"
			If( !empty(__wsSoapFault) )
				Self:aCustomers[nX]:__msgreturn := "[MSG-WSCustomers] "+__wsSoapFault+""
			EndIf
		ENdIf
	EndIf

	CATCHEXCEPTION USING Self:oException
	If ( ValType( Self:oException ) == "O" )
		Self:cMsgSoapFault := ""
		Self:cMsgSoapFault += IF( !Empty( Self:oException:Description )	, Self:oException:Description	, "" )
		Self:cMsgSoapFault += IF( !Empty( Self:oException:ErrorStack )		, Self:oException:ErrorStack 	, "" )
		SetSoapFault("[WS_SOAPFAULT]-ERR-5000012-WSMethod [WSCustomers]", alltrim(Self:cMsgSoapFault))
	EndIf
	Self:lWsMethodRet := .F.
	ENDEXCEPTION

Return( Self:lWsMethodRet )

////////////////////////////////////////////////////////////////////////////
//|Autor	|Thiago de Jesus      			| 15-02-2016 | Crail
//|Funcao   |WSSalesOrder                      
//|Uso		|Trabalhando com Pedidos de Venda via consumo WebServices
////////////////////////////////////////////////////////////////////////////

WSMethod WSSalesOrder WSReceive __ArrSalesOrder,__login,__pws WSSend aSalesOrder WSService FITWService

	local __retsales 	:= {}
	local nX			:= 0
	local nY 			:= 0
	local y				:= 0
	local x				:= 0
	local __wsSoapFault	:= ""
	local __mv_TES      := SUPERGETMV("MV_MAGTES",.T.,"   ")
	local __Autetication:= {}

	default Self:__operacao	:= ""

	TRYEXCEPTION
	__Autetication := aClone( __wblogin( Self:__login,Self:__pws ) )
	If( len(__Autetication) > 0 )
		If( !__Autetication[3] )
			SetSoapFault("[WS_SOAPFAULT]-ERR-9000012-WSMethod [WSSalesOrder]", alltrim(__Autetication[1]))
			Return( .F. )
		EndIf
	EndIf 

	__retsales 			:= SalesSearch(Self:__ArrSalesOrder,@__wsSoapFault )		
	Self:aSalesOrder 	:= {}
	Self:lWsMethodRet	:= .T.
	If len(__retsales) > 0
		x := 1
		For nX := 1 To len(__retsales)                           
			If( empty(__retsales[nX][01]) )
				loop
			EndIf
			//////////////////////////////////////////////////////////                             
			//Header do Pedido de Vendas
			//////////////////////////////////////////////////////////
			AAdd( Self:aSalesOrder, WSClassNew("WSEstSalesOrder") )				
			Self:aSalesOrder[nX]:__adata := {}
			AAdd( Self:aSalesOrder[nX]:__adata, WSClassNew("WSSalesHeader") )
			Self:aSalesOrder[nX]:__adata[x]:__num 				:= __retsales[nX][01]
			Self:aSalesOrder[nX]:__adata[x]:__tipo    			:= __retsales[nX][02]
			Self:aSalesOrder[nX]:__adata[x]:__cliente			:= __retsales[nX][03]
			Self:aSalesOrder[nX]:__adata[x]:__nomecliente		:= alltrim(Posicione("SA1",1,xFilial("SA1")+__retsales[nX][03],"A1_NOME"))
			Self:aSalesOrder[nX]:__adata[x]:__lojacliente 		:= __retsales[nX][04]
			Self:aSalesOrder[nX]:__adata[x]:__lojaentrada 		:= __retsales[nX][05]
			Self:aSalesOrder[nX]:__adata[x]:__tipocliente 		:= __retsales[nX][06]
			Self:aSalesOrder[nX]:__adata[x]:__condpagamento 	:= __retsales[nX][07]
			Self:aSalesOrder[nX]:__adata[x]:__cvendedor			:= __retsales[nX][08]
			Self:aSalesOrder[nX]:__adata[x]:__cdcondpg			:= __retsales[nX][09]
			Self:aSalesOrder[nX]:__adata[x]:__crastreio 		:= __retsales[nX][10]
			Self:aSalesOrder[nX]:__adata[x]:__ctransacao 		:= __retsales[nX][11]
			//Self:aSalesOrder[nX]:__adata[x]:__EtiquetaMktPlace 	:= __retsales[nX][15] //Vinicius
			//Self:aSalesOrder[nX]:__adata[x]:__Prazo				:= __retsales[nx][16]//Alex
	

			//Self:aSalesOrder[nX]:__adata[x]:__cCanalS	 	:= __retsales[nX][14]			
			Self:aSalesOrder[nX]:__adata[x]:__msgreturn 	:= "[MSG-WSSalesOrder] Integracao de Pedido de Vendas efetuada com sucesso" 
			If( !empty(__wsSoapFault) )                        
				Self:aSalesOrder[nX]:__adata[x]:__msgreturn := "[MSG-WSSalesOrder] "+__wsSoapFault+""  
			EndIf
			//////////////////////////////////////////////////////////                             
			//Itens do Pedido de Vendas
			//////////////////////////////////////////////////////////
			y := 0
			For nY := 8 To len(__retsales[nX])
				y++					
				Self:aSalesOrder[nX]:__adata[x]:__aItems := {}
				AAdd( Self:aSalesOrder[nX]:__adata[x]:__aItems, WSClassNew("WSSalesItems") )
				Conout(VARINFO('TESTANDO VARINFO TESTANDO ', Self:aSalesOrder[nX]))
				Conout("len(__retsales[nX]) " + cValtoChar(len(__retsales[nX])))
				Conout("y " + cValtoChar(y))
				Conout(VARINFO('TESTANDO2 VARINFO TESTANDO2 ', Self:aSalesOrder[nX]:__adata[x]:__aItems[1]))
				Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__item 				:= Iif(empty(__retsales[nX][12][01])," ",__retsales[nX][12][01])
				Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__produto 			:= Iif(empty(__retsales[nX][12][02])," ",__retsales[nX][12][02])
				Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__descprod 			:= alltrim(Posicione("SB1",1,xFilial("SB1")+__retsales[nX][12][02],"B1_DESC"))
				Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__qtdvendida 		:= Iif(empty(__retsales[nX][12][03]),"0",__retsales[nX][12][03])
				Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__precovenda 		:= Iif(empty(__retsales[nX][12][04]),"0",__retsales[nX][12][04])
				Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__precounitario 	:= Iif(empty(__retsales[nX][12][05]),"0",__retsales[nX][12][05])
				Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__valor 			:= Iif(empty(__retsales[nX][12][06]),"0",__retsales[nX][12][06])
				//Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__TES 				:= Iif(empty(__retsales[nX][12][07]),__mv_TES,__retsales[nX][12][07])
				Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__TES 				:= Iif(empty(__retsales[nX][12][07]),"01",__retsales[nX][12][07])
				Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__lote  			:= Iif(empty(__retsales[nX][12][08])," ",__retsales[nX][12][08])										
				Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__armazem			:= Iif(empty(__retsales[nX][12][09])," ",__retsales[nX][12][09])																		
				Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__Kitname			:= Iif(empty(__retsales[nX][12][10])," ",__retsales[nX][12][10])
				//					Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__desc01			:= Iif(empty(__retsales[nX][12][10]),"0",__retsales[nX][12][10])																							
				//					Self:aSalesOrder[nX]:__adata[x]:__aItems[1]:__prdescont			:= Iif(empty(__retsales[nX][12][11]),"0",__retsales[nX][12][11])																												
			Next nY
		Next nX
	Else
		nX := 1; nY := 1;y := 1      			
		Self:aSalesOrder := {}
		AAdd( Self:aSalesOrder, WSClassNew("WSEstSalesOrder") )

		Self:aSalesOrder[nX]:__adata := {}							
		AAdd( Self:aSalesOrder[nX]:__adata, WSClassNew("WSSalesHeader") )

		Self:aSalesOrder[nX]:__adata[nX]:__num 				:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__tipo    			:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__cliente			:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__nomecliente		:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__lojacliente 		:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__lojaentrada 		:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__tipocliente 		:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__condpagamento	:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__cvendedor		:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__cdcondpg			:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__crastreio		:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__ctransacao		:= " "	
	//	Self:aSalesOrder[nX]:__adata[nX]:__EtiquetaMktPlace	:= " "	 //Vinicius
	//	Self:aSalesOrder[nX]:__adata[nX]:__Prazo			:= " "	//Alex

		//Self:aSalesOrder[nX]:__adata[nX]:__unkey 		:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__msgreturn 	:= "[MSG-WSSalesOrder] Nao foram encontrados dados para procesamento da requisicao"
		If( !empty(__wsSoapFault) )
			Self:aSalesOrder[nX]:__adata[nX]:__msgreturn := "[MSG-WSSalesOrder] " + __wsSoapFault + ""
		EndIf

		Self:aSalesOrder[nX]:__adata[nX]:__aItems := {}
		AAdd( Self:aSalesOrder[nX]:__adata[nX]:__aItems, WSClassNew("WSSalesItems") )
		Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__item 						:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__produto 					:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__descprod 					:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__qtdvendida 					:= "0"
		Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__precovenda 					:= "0"
		Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__precounitario 				:= "0"
		Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__valor 						:= "0"
		//			Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__TES 			:= __mv_TES
		Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__TES 						:= " "//tipo de operacao
		Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__lote    					:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__armazem 					:= " "
		Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__Kitname 					:= " "
		//			Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__desc01			:= "0"
		//			Self:aSalesOrder[nX]:__adata[nX]:__aItems[nY]:__prdescont		:= "0"			
	EndIf	
	CATCHEXCEPTION USING Self:oException				
	If ( ValType( Self:oException ) == "O" )
		Self:cMsgSoapFault := ""
		Self:cMsgSoapFault += IF( !Empty( Self:oException:Description )	, Self:oException:Description	, "" )
		Self:cMsgSoapFault += IF( !Empty( Self:oException:ErrorStack )		, Self:oException:ErrorStack 	, "" )
		SetSoapFault("[WS_SOAPFAULT]-ERR-9000013-WSMethod [WSSalesOrder]", alltrim(Self:cMsgSoapFault))
	EndIf
	Self:lWsMethodRet := .F.			
	ENDEXCEPTION                                       

Return( Self:lWsMethodRet ) 

//_____________________________________________________________________________
/*/{Protheus.doc} WSConveyor
Retorno de informaÃƒÂ§ÃƒÂµes referentes a transportadora | Protheus x Magento


@author Icaro Queiroz
@since 04 de Fevereiro de 2017
@version P11
@Owner FIT Gestao for Crail
/*/
//_____________________________________________________________________________

WSMethod WSConveyor WSReceive __ArrConveyor,__login,__pws WSSend aConveyor WSService FITWService

	local __retConveyor 	:= {}
	local __nX				:= 0
	local __wsSoapFault		:= "Sucesso na pesquisa da transportadora"
	local __Autetication	:= {}


	TRYEXCEPTION
	__Autetication := aClone( __wblogin( Self:__login,Self:__pws ) )
	If( len(__Autetication) > 0 )
		If( !__Autetication[3] )
			SetSoapFault("[WS_SOAPFAULT]-ERR-5000012-WSMethod [WSConveyor]", alltrim(__Autetication[1]))
			Return( .F. )
		EndIf
	EndIf

	__retConveyor 		:= ConveSearch(	Self:__ArrConveyor,@__wsSoapFault )
	Self:aConveyor 	:= {}
	Self:lWsMethodRet	:= .T.

	If len(__retConveyor) > 0
		For __nX := 1 To len(__retConveyor)    
			AAdd( Self:aConveyor, WSClassNew("WSEstConveyor") )						
			Self:aConveyor[__nX]:__filial 		:= __retConveyor[__nX][01]
			Self:aConveyor[__nX]:__codigo    	:= __retConveyor[__nX][02]
			Self:aConveyor[__nX]:__nome  		:= alltrim(__retConveyor[__nX][03])
			Self:aConveyor[__nX]:__nreduz     	:= alltrim(__retConveyor[__nX][04])
			Self:aConveyor[__nX]:__contato     	:= alltrim(__retConveyor[__nX][05])
			Self:aConveyor[__nX]:__endereco   	:= alltrim(__retConveyor[__nX][06])
			Self:aConveyor[__nX]:__bairro  		:= alltrim(__retConveyor[__nX][07])
			Self:aConveyor[__nX]:__cod_municipio:= __retConveyor[__nX][08]
			Self:aConveyor[__nX]:__municipio 	:= alltrim(__retConveyor[__nX][09])
			Self:aConveyor[__nX]:__estado		:= alltrim(__retConveyor[__nX][10])
			Self:aConveyor[__nX]:__ddd		  	:= __retConveyor[__nX][11]
			Self:aConveyor[__nX]:__telefone  	:= alltrim(__retConveyor[__nX][12])
			Self:aConveyor[__nX]:__cnpj_cgc  	:= alltrim(__retConveyor[__nX][13])
			Self:aConveyor[__nX]:__InsEstadual	:= alltrim(__retConveyor[__nX][14])
			Self:aConveyor[__nX]:__CEP  		:= __retConveyor[__nX][15]
			Self:aConveyor[__nX]:__codpais  	:= __retConveyor[__nX][16]
			Self:aConveyor[__nX]:__COMPL		  	:= __retConveyor[__nX][17]
			If( !empty(__wsSoapFault) )                        
				Self:aConveyor[__nX]:__msgreturn:= "[MSG-WSConveyor] "+__wsSoapFault+""  
			EndIf
		Next __nX
	Else
		__nX := 1      
		Self:aConveyor := {}
		AAdd( Self:aConveyor, WSClassNew("WSEstConveyor") )						
		Self:aConveyor[__nX]:__filial 		:= " "
		Self:aConveyor[__nX]:__codigo    	:= " "
		Self:aConveyor[__nX]:__nome  		:= " "
		Self:aConveyor[__nX]:__nreduz     	:= " "
		Self:aConveyor[__nX]:__contato     	:= " "
		Self:aConveyor[__nX]:__endereco   	:= " "
		Self:aConveyor[__nX]:__bairro  		:= " "
		Self:aConveyor[__nX]:__cod_municipio:= " "
		Self:aConveyor[__nX]:__municipio 	:= " "
		Self:aConveyor[__nX]:__estado		:= " "
		Self:aConveyor[__nX]:__ddd		  	:= " "
		Self:aConveyor[__nX]:__telefone  	:= " "
		Self:aConveyor[__nX]:__cnpj_cgc  	:= " "
		Self:aConveyor[__nX]:__InsEstadual  := " "
		Self:aConveyor[__nX]:__CEP  		:= " "
		Self:aConveyor[__nX]:__codpais  	:= " "
		Self:aConveyor[__nX]:__COMPL  		:= " "
		Self:aConveyor[__nX]:__msgreturn 	:= "[MSG-WSConveyor] NÃƒÂ£o foram encontrados dados para procesamento da requisiÃƒÂ§ÃƒÂ£o"

	EndIf	

	CATCHEXCEPTION USING Self:oException				
	If ( ValType( Self:oException ) == "O" )
		Self:cMsgSoapFault := ""
		Self:cMsgSoapFault += IF( !Empty( Self:oException:Description )	, Self:oException:Description	, "" )
		Self:cMsgSoapFault += IF( !Empty( Self:oException:ErrorStack )		, Self:oException:ErrorStack 	, "" )
		SetSoapFault("[WS_SOAPFAULT]-ERR-5000012-WSMethod [WSConveyor]", alltrim(Self:cMsgSoapFault))
	EndIf
	Self:lWsMethodRet := .F.			
	ENDEXCEPTION                                       

Return( Self:lWsMethodRet )



////////////////////////////////////////////////////////////////////////////
//|Autor	|Thiago de Jesus      			| 16-02-2016 | Crail
//|Funcao   |__wblogin                     
//|Uso		|Autenticacao basica para WebServices
////////////////////////////////////////////////////////////////////////////
Static Function __wblogin( __login,__password )
	local cHtml		:= ""
	local login 	:= __login
	local password 	:= __password
	local ohash	 	:= sHash():New()
	local alogin	:= {}
	local aArea     := GetArea()
	local __cJSON   := ""
	local __userinfo:= {}
	local __lreturn := .F.
	local cNome		:= ""
	local aUsuario	:= {}
	local lPswSeek	:= .F.
	local __mens	:= ""

	private __codigo := ""
	private __nomusr := ""
	private __nomcpl := ""
	private __depart := ""
	private __cargo  := ""
	private __email  := ""
	private __usrblq := .F.
	private __empfil := ""
	private __ainfsis:= {}
	private __dtinclu:= dDataBase
	private __nivel  := ""

	PswOrder(2)
	If PswSeek( login, .T. )
		__userinfo := Pswret() 
		lPswSeek   := .T.

		If PswName(password)			
			__codigo := __userinfo[1][1]  //C   	Numero de identificaÃƒÂ§ÃƒÂ£o seqÃƒÂ¼encial com o tamanho de 6 caracteres
			__nomusr := __userinfo[1][2]  //C    	Nome do usuÃƒÂ¡rio			
			__nomcpl := __userinfo[1][4]  //C   	Nome completo do usuÃƒÂ¡rio
			__depart := __userinfo[1][12] //C   	Departamento
			__cargo  := __userinfo[1][13] //C    	Cargo
			__email  := __userinfo[1][14] //C    	E-mail						
			__usrblq := __userinfo[1][17] //L    	UsuÃƒÂ¡rio bloqueado			
			__empfil := __userinfo[1][22] //C    	Empresa, filial e matricula
			__ainfsis:= __userinfo[1][23] //A    	InformaÃƒÂ§ÃƒÂµes do sistema 			
			__dtinclu:= __userinfo[1][24] //D    	Data de inclusÃƒÂ£o no sistema
			__nivel  := __userinfo[1][25] //C    	NÃƒÂ­vel global de campo			
		Else                                                                                                            
			__wbblank( @alogin,login )
			__mens 	:= "[WS-Services|Soap-Fault-Exception|200001] Erro | Login inconsistente - (senha incorreta)"
			lPswSeek:= .F.
		EndIf
	Else 
		__wbblank( @alogin,login )
		__mens := "[WS-Services|Soap-Fault-Exception|200002] Erro | Login inconsistente - (usuario invalido)"					
		lPswSeek:= .F.
	EndIf

	If( !empty(login) .And. lPswSeek )
		aAdd( alogin,sHash():New() )
		aTail(alogin):Set("weblogin"	,login)				
		aTail(alogin):Set("codigo"		,__codigo)			
		aTail(alogin):Set("nomusr"		,__nomusr)
		aTail(alogin):Set("nomcpl"		,__nomcpl)
		aTail(alogin):Set("depart"		,__depart)
		aTail(alogin):Set("cargo"		,__cargo)
		aTail(alogin):Set("email"		,__email)
		aTail(alogin):Set("usrblq"		,__usrblq)
		aTail(alogin):Set("empfil"		,alltrim(SM0->M0_NOME)+" / "+alltrim(SM0->M0_FILIAL))
		aTail(alogin):Set("ainfsis"		,__ainfsis)
		aTail(alogin):Set("dtinclu"		,__dtinclu)
		aTail(alogin):Set("nivel"		,__nivel)
		__mens := "[WS-Services|app-14142 normal successful completion|100001] Processamento efetuado com sucesso"					
		lPswSeek:= .T.	
	EndIf
	RestArea( aArea )

Return( { __mens, alogin, lPswSeek } )  


Static Function __wbblank( alogin,login )
	aAdd( alogin,sHash():New() )
	aTail(alogin):Set("weblogin"	,login)				
	aTail(alogin):Set("codigo"		,"")			
	aTail(alogin):Set("nomusr"		,"")
	aTail(alogin):Set("nomcpl"		,"")
	aTail(alogin):Set("depart"		,"")
	aTail(alogin):Set("cargo"		,"")
	aTail(alogin):Set("email"		,"")
	aTail(alogin):Set("usrblq"		,.T.)
	aTail(alogin):Set("empfil"		,"")
	aTail(alogin):Set("ainfsis"		,{})
	aTail(alogin):Set("dtinclu"		,dDatabase)
	aTail(alogin):Set("nivel"		,"")
Return( alogin )


////////////////////////////////////////////////////////////////////////////
//|Autor	|Thiago de Jesus      			| 15-02-2016 | Crail
//|Funcao   |SalesSearch                     
//|Uso		|Valida e consulta Clientes existentes na Base do Protheus
////////////////////////////////////////////////////////////////////////////
Static Function SalesSearch( __aArrSales,__wsSoapFault )
	local __query   	:= ""
	local __alias   	:= GetNextAlias()
	local __aqry    	:= {}
	local __area    	:= GetArea()
	local __nY      	:= 0
	local __nX      	:= 0
	local __adata   	:= {}
	local __salesorder	:= {}	
	local __lseek
	local __nopc		:= 3
	local aqry			:= {}
	local __wsSoapFault	:= ""
	local __aSC5        := {}
	local __numSC5		:= ""
	local __mexechead 	:= {}
	local __mexecItems  := {}
	local __norepeat	:= ""
	local __mv_TES      := SUPERGETMV("MV_MAGTES",.T.,"   ")
	local __mv_NAT      := SUPERGETMV("MV_MAGNAT",.T.,4)
	local _cDest	    := SUPERGETMV("SB_DESTFTP",.T.,"logistica@suryabrasil.com;ecommerce@suryabrasil.com")
	local _cCopy	    := SUPERGETMV("SB_COPYFTP",.T.,"tecnologia@suryabrasil.com")
	local _cLocal		:= ALLTRIM(SUPERGETMV("FC_WEBARMZ",.T.,"17"))
	local __aLinha		:= {}
	local aErroAuto		:= {}		
	local __codcli 		:= ""
	local __lojcli 		:= ""
	local __tipcli 		:= ""
	local __condpg 		:= ""
	Local __cNcondpg	:= ""
	Local __cTranspSA4  := "" //Thiago
	Local __cCanalSaida	:= ""
	Local __EtiquetaMktPlace := "" //Vinicius
	Local __Prazo		:= "" //Alex

	default __aArrSales := {}

	If( len(__aArrSales:__ADATA) == 0 )
		__wsSoapFault := "Os parametros de entrada nao foram informados corretamente,efetue o envio dos dados correspondentes ao Pedido de Vendas."
		Return( __salesorder )
	Else
		__numSC5:= GetSxeNum("SC5","C5_NUM")
		RollBackSxE()		
		dbSelectArea("SC5")
		SC5->( dbSetOrder(1) )			
		While SC5->( dbSeek( xFilial("SC5")+__numSC5 ) )
			ConfirmSX8()
			__numSC5 := GetSxeNum("SC5","C5_NUM")
		End

		If( Valtype(__aArrSales:__ADATA)=="A" )
			If( len(__aArrSales:__ADATA) > 1 )		
				aDel (__aArrSales:__ADATA, len(__aArrSales:__ADATA))
				aSize(__aArrSales:__ADATA, len(__aArrSales:__ADATA)-1)
			EndIf

			SA1->( dbSetOrder(1) )
			__mexechead := {}
			For __nY := 1 to len(__aArrSales:__ADATA)
				__lseek 			:= SA1->( dbSeek( xFilial("SA1")+__aArrSales:__ADATA[__nY]:__CLIENTE ) )
				__num 				:= Iif(empty(__numSC5)		,__aArrSales:__ADATA[__nY]:__NUM,__numSC5)
				__tipo 				:= Iif(empty(SA1->A1_PESSOA),__aArrSales:__ADATA[__nY]:__TIPO,SA1->A1_PESSOA)
				__cliente 			:= alltrim(__aArrSales:__ADATA[__nY]:__CLIENTE)
				__lojacliente 		:= Iif(empty(SA1->A1_LOJA)	,__aArrSales:__ADATA[__nY]:__LOJAENTRADA,SA1->A1_LOJA)
				__lojaentrada 		:= Iif(empty(SA1->A1_LOJA)	,__aArrSales:__ADATA[__nY]:__LOJAENTRADA,SA1->A1_LOJA)
				__tipocliente 		:= Iif(empty(SA1->A1_TIPO)	,__aArrSales:__ADATA[__nY]:__TIPOCLIENTE,SA1->A1_TIPO)
				__condpagamento 	:= Upper(Alltrim( __aArrSales:__ADATA[__nY]:__CONDPAGAMENTO))
				__unkey				:= Alltrim( __aArrSales:__ADATA[__nY]:__UNKEY)//Chave Unica de processamento
				__frete				:= __aArrSales:__ADATA[__nY]:__FRETE
				__cCodTransp		:= AllTrim(__aArrSales:__ADATA[__nY]:__cCodTransp)
				__cvendedor			:= __aArrSales:__ADATA[__nY]:__cvendedor
				__cdcondpg			:= __aArrSales:__ADATA[__nY]:__cdcondpg
				__crastreio			:= __aArrSales:__ADATA[__nY]:__crastreio
				__ctransacao		:= __aArrSales:__ADATA[__nY]:__ctransacao
				__cCanalS			:= __aArrSales:__ADATA[__nY]:__cCanalS
				IF !EMPTY(__aArrSales:__ADATA[__nY]:__EtiquetaMktPlace)
					__EtiquetaMktPlace  := __aArrSales:__ADATA[__nY]:__EtiquetaMktPlace //Vinicius
				ELSE
					__EtiquetaMktPlace	:= ""
				ENDIF
				IF !EMPTY(__aArrSales:__ADATA[__nY]:__Prazo)
					__Prazo				:= __aArrSales:__ADATA[__nY]:__Prazo	//Alex
				else
					__Prazo := "19900101"
				ENDIF

				//Thiago
				If ValType(__cCodTransp) == "C"
					dbSelectArea("SA4")
					SA4->(dbOrderNickName("MAGCOD"))
					If SA4->(MsSeek(xFilial("SA4") + AllTrim(__cCodTransp)))
						__cTranspSA4 := SA4->A4_COD
							
					EndIf 
				
				EndIf

				If ValType(__condpagamento) == "C"
					dbSelectArea("SE4")
				 	SE4->(dbOrderNickName("MAGCOD"))
					If SE4->(dbSeek(xFilial("SE4") + AllTrim(__condpagamento)))
						__condpg := SE4->E4_CODIGO
					
					//__cNcondpg := SE4->E4_DESCRI
				   EndIf
				   	
				EndIf
               
				If Empty(__condpg)
					__condpg := GetNewPar("MV_MAGCPG","002")
				EndIf
				
				//

				////////////////////////////////////////////////////////////////////////////////
				//| Sempre sera adicionado o CNPJ do Cliente no retorno de consumo para o WS 
				//| ERP | Data | 18/03/2016
				////////////////////////////////////////////////////////////////////////////////
				If( !empty(__cliente) )
					//__cliente := cgc( Replace(Replace(Replace(__cliente,".",""),"/",""),"-","") )
					If !cgc( Replace(Replace(Replace(__cliente,".",""),"/",""),"-","") )
						__wsSoapFault := "CNPJ/CPF invÃƒÂ¡lido ["+Padr(__cliente,tamsx3("A1_COD")[1])+"]."
						Return( __salesorder )
					Else
						///////////////////////////////////////
						//| Busca por CNPJ
						///////////////////////////////////////
						SA1->( dbSetOrder(3) )
						lSeek := SA1->( dbSeek( xFilial("SA1")+Padr(__cliente,tamsx3("A1_CGC")[1]) ) )
					EndIf
					If( !lSeek )
						__wsSoapFault := "Cliente nÃƒÂ£o encontrado com o CNPJ/CPF ["+Padr(__cliente,tamsx3("A1_CGC")[1])+"] informados."
						Return( __salesorder )
					Else
						__codcli := SA1->A1_COD
						__lojcli := SA1->A1_LOJA
						__tipcli := SA1->A1_TIPO
						//__condpg := GetNewPar("MV_MAGCPG","ESP") //Thiago
					EndIf
				EndIf

				If( __norepeat != __num )
					Private __msgNota := "NRO WEB: " + __unkey + " - NRO PV: " + __num

					aadd(__mexechead,{"C5_TIPO" 	,"N"			,Nil})
					aadd(__mexechead,{"C5_CLIENTE"	,__codcli		,Nil})
					aadd(__mexechead,{"C5_LOJACLI"	,__lojcli  		,Nil})
					aadd(__mexechead,{"C5_CLIENT"	,__codcli		,Nil})
					aadd(__mexechead,{"C5_LOJAENT"	,__lojcli		,Nil})
					aadd(__mexechead,{"C5_TIPOCLI"	,__tipcli  		,Nil})
					//aAdd(__mexechead,{"C5_TRANSP"	,__cTranspSA4	,Nil}) //NÃƒÂ£o excluir do fonte, pois com esse campo p execauto nÃƒÂ£o funciona
					aadd(__mexechead,{"C5_CONDPAG"	,__condpg		,Nil})
					aadd(__mexechead,{"C5_VEND1"	,__cvendedor	,Nil})    
					aadd(__mexechead,{"C5_XFORMA"	,"1004"	,Nil})	
					aadd(__mexechead,{"C5_XDCNDPG"	,__cdcondpg		,Nil})
					aadd(__mexechead,{"C5_XRASTRE"	,__crastreio	,Nil})
					aadd(__mexechead,{"C5_XTRANSC"	,__ctransacao	,Nil})
					aadd(__mexechead,{"C5_XCANSAI"	,__cCanalS		,Nil})																		
					aadd(__mexechead,{"C5_MENNOTA"	,__msgNota		,Nil}) // Mensagem para Nota
					aadd(__mexechead,{"C5_XMAGCOD"	,__unkey		,Nil}) // Codigo PV Magento
					//					aadd(__mexechead,{"C5_TABELA"	,__ctabela		,Nil}) //IIF(__tipo=="R",GetNewPar( "MV_MAGB2B"),GetNewPar( "MV_MAGB2C" ))	,Nil})					

					Conout( "FITGESTAO INICIO segundo" )
					Conout( __frete )
					Conout( "FITGESTAO FIM segundo" )

					If ValType( __frete ) <> "U"
						aAdd(__mexechead, {"C5_TPFRETE", "F"         , Nil}) //Thiago
						aadd(__mexechead, {"C5_FRETE"  , Val(__frete), Nil})
					EndIf
					If VALTYPE(__EtiquetaMktPlace) <> "U"
						aadd(__mexechead,{"C5_XEMKTPL"	,__EtiquetaMktPlace		,Nil}) // Etiqueta Market Place - Vinicius
					ENDIF
					IF VALTYPE(__Prazo) <> "U"
						aadd(__mexechead,{"C5_FECENT"	,STOD(__Prazo)		,Nil}) // Prazo de entrega - Alex
					ENDIF
					__norepeat := __num
				EndIf

				For __nX := 1 to len(__aArrSales:__ADATA[__nY]:__AITEMS)
					__item 			:= Iif(empty(__aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__item),StrZero(__nX,2),__aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__item)					
					__produto 		:= alltrim(__aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__produto)
					__qtdvendida 	:= __aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__qtdvendida
					__precovenda 	:= __aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__precovenda
					__precounitario := __aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__precounitario
					__valor 		:= __aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__valor
					__TES 			:= __aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__TES     //tipo de operacao                     
					__lote 			:= __aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__lote    //ThiagoM                      
					__armazem		:= __aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__armazem//_cLocal
					__Kitname		:= __aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__Kitname//_cLocal
					//__aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__armazem //ThiagoM                                                                                                                    
					//					__desc01		:= __aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__desc01 //ThiagoM                                                                                                                    
					//					__prdescont		:= __aArrSales:__ADATA[__nY]:__AITEMS[__nX]:__prdescont //ThiagoM					


					If( !empty(__produto) )
						__aLinha := {}    
						aadd(__aLinha,{"C6_ITEM"	,__item				,Nil})    
						aadd(__aLinha,{"C6_PRODUTO"	,__produto			,Nil})    
						aadd(__aLinha,{"C6_LOCAL"	,__armazem			,Nil})//ThiagoM 
						//aadd(__aLinha,{"C6_LOTECTL"	,__lote   			,Nil})//ThiagoM 
						if val(__precovenda) == 0
							aadd(__aLinha,{"C6_OPER"	,"04"   			,Nil})
						else
							aadd(__aLinha,{"C6_OPER"	,"01"   			,Nil})
						endif	    
						aadd(__aLinha,{"C6_QTDVEN"	,val(__qtdvendida)	,Nil})    
						aadd(__aLinha,{"C6_QTDLIB"  ,val(__qtdvendida) ,Nil})
						aadd(__aLinha,{"C6_PRCVEN"	,iif(val(__precovenda)==0,val(__precounitario),val(__precovenda))	,Nil})    
						aadd(__aLinha,{"C6_PRUNIT"	,val(__precounitario),Nil})    
						//						aadd(__aLinha,{"C6_VALOR"	,val(__valor)		,Nil})    
						//						aadd(__aLinha,{"C6_TES"		,__mv_TES			,Nil})    
						//						aadd(__aLinha,{"C6_VALDESC"	,Val(__desc01)		,Nil})//ThiagoM 												
						//						aadd(__aLinha,{"C6_DESCONT"	,Val(__prdescont)	,Nil})//ThiagoM
						CONOUT("KIT: "+__Kitname)
						if !empty(alltrim(__Kitname))
							aadd(__aLinha,{"C6_XKITNAM"	,__Kitname,Nil})
						endif 
						aadd(__mexecItems,__aLinha)

						aAdd( __aSC5,{ __num,__tipo,__cliente,__lojacliente,__lojaentrada,__tipocliente,__condpagamento,__cvendedor,__cdcondpg,__crastreio,__ctransacao,;
						{ __item,__produto,__qtdvendida,__precovenda,__precounitario,__valor,__TES,__lote,__armazem, __Kitname},__unkey, __cCanalS,__EtiquetaMktPlace, __Prazo} )//

					EndIf

				Next __nX                                                            
			Next __nY			
			lMSHelpAuto 	:= .T.
			lMSErroAuto 	:= .F.
			lAutoErrNoFile 	:= .T.
			SA1->( dbSetOrder(1) )
			SC5->( dbSetOrder(1) )
			MsExecAuto({|x, y, z| MATA410(x, y, z)}, __mexechead, __mexecItems, __nopc) 

			If lMSErroAuto
				aErroAuto := GetAutoGRLog()
				For __nY := 1 To Len(aErroAuto)
					__wsSoapFault += StrTran(StrTran(StrTran(aErroAuto[__nY],"<"," "),"-"," "),"/"," ")+" "
					CONOUT(__wsSoapFault)
					//exit //TDJ001
				Next __nY

				//Begin TDJ001
				If At("A410TIPO9", __wsSoapFault) > 0
					//Limpo a variavel pois e apenas um Alerta
					CONOUT(__wsSoapFault)
					__wsSoapFault := ""

					//Confirmo a numeracao do pedido de venda
					ConfirmSX8()
				EndIf
				//TDJ001 End
			Else
				ConfirmSX8()
				
				If !Empty(__cTranspSA4)
					RecLock("SC5", .F.)
					SC5->C5_TRANSP := __cTranspSA4
					MsUnlock()
				EndIf
				__numSC5 :=  SC5->C5_NUM
				__cCanalSaida := SC5->C5_XCANSAI
				//Pegar apenas o que for E-commerce
				/*If __cCanalSaida $  '2-5-6-7-8-9-A'
					if LiberOK(__numSC5) 
						if RunCont(__numSC5 ) //gera picking
							If !FT2All(,,,,__numSC5)  
								envEcom1(__numSC5, "2Alianca","Erro de Integra com Logistica - SEM CONEXÏ COM FTP",_cDest,_cCopy)
							Endif 
						else
							envEcom1(__numSC5, "2Alianca","Erro de Integra com Logistica - PICKING LIST NÏ GERADO",_cDest,_cCopy)
						endif
					else
						envEcom1(__numSC5, "2Alianca","Erro de Integra com Logistica - PEDIDO LIBERADO PARCIAL",_cDest,_cCopy)
					endif
				EndIf*/
			EndIf
			__salesorder := aClone(__aSC5)
		EndIf
	EndIf

	RestArea(__area)
Return( __salesorder )


////////////////////////////////////////////////////////////////////////////
//|Autor	|Thiago de Jesus      			| 15-02-2016 | Crail
//|Funcao   |CustmSearch                     
//|Uso		|Valida e consulta Clientes existentes na Base do Protheus
////////////////////////////////////////////////////////////////////////////

Static Function CustmSearch( __aArrCust,__operacao,__NewCustomers,__wsSoapFault )
	local __query   	:= ""
	local __alias   	:= GetNextAlias()
	local __aqry    	:= {}
	local __area    	:= GetArea()
	local __nY      	:= 0
	local __adata   	:= {}
	local __customer	:= {}
	local __cpf_cnpj	:= ""
	local __like_nome	:= ""
	local __cWhereNome  := ""
	local __lrangeN     := .F.
	local __rangeN     	:= ""
	local __lseek
	local __nopc		:= 0
	local aqry			:= {}

	default __wsSoapFault	:= ""
	default __aArrCust 		:= {}

	If( len(__aArrCust:__ADATA) == 0 )
		__wsSoapFault := "Os parametros de entrada nao foram informados corretamente,efetue o envio dos dados correspondentes ao Cliente."
		Return( __salesorder )
	Else
		If( Valtype(__aArrCust:__ADATA)=="A" )
			If( len(__aArrCust:__ADATA) > 1 )
				aDel (__aArrCust:__ADATA, len(__aArrCust:__ADATA))
				aSize(__aArrCust:__ADATA, len(__aArrCust:__ADATA)-1)
			EndIf

			For __nY := 1 to len(__aArrCust:__ADATA)
				__like_nome:= __aArrCust:__ADATA[__nY]:__BUSCA_NOME
				__cpf_cnpj := __aArrCust:__ADATA[__nY]:__CPF_CNPJ

				If !Empty(__like_nome) .or. !Empty(__cpf_cnpj)//Thiago
					exit
				EndIf //Thiago
			Next __nY

			/* //Thiago
			If( Valtype(__cpf_cnpj) == Nil .Or. empty(__cpf_cnpj) )
			__cpf_cnpj := Replace(Replace(Replace("08.658.317/0001-21",".",""),"/",""),"-","")
			EndIf
			*/
			__cpf_cnpj := Replace(Replace(Replace(__cpf_cnpj, ".", ""), "/", ""), "-", "")
			//Thiago

			//If( len(Replace(Replace(Replace(__cpf_cnpj,".",""),"/",""),"-","")) == 14 ) //Thiago
			If Len(Alltrim(__cpf_cnpj)) == 14 //Thiago
				__type := "J"
			Else
				__type := "F"
			EndIf
			//__lret := cgc( Replace(Replace(Replace(__cpf_cnpj,".",""),"/",""),"-","") ) //Thiago
			If !Empty(__cpf_cnpj)
				__lret := cgc(__cpf_cnpj) //Thiago
			Else
				//FaÃƒÂ§o isso para que possa prosseguir com a inclusÃƒÂ£o
				__cpf_cnpj := "99999999999"
				__lret := .T.
			EndIf

			If( __lret )  
				DBSelectArea("SA1")
				dbSetOrder(3) 
				if msSeek( xFilial("SA1")+ALLTRIM(__cpf_cnpj) )
					__lseek := .T. //chupa
				else
					__lseek := .F.
				endif
				////////////////////////////////////////////////////////////
				//Tipos de operacao 2=Visualiza,3=Inclui,4=Altera,5=Exclui
				////////////////////////////////////////////////////////////
				__nopc 	:= Iif(__lseek,Iif(Upper(Substr(__operacao,1,1))=="V",2,Iif(Upper(Substr(__operacao,1,1))=="E",5,4)),3)
				If( __nopc == 3 .or. __nopc == 4 .or. __nopc == 5 )
					u_ManCustomer(__NewCustomers, __nopc, __type, @__cpf_cnpj, @__wsSoapFault, @__customer)
				Else

					///////////////////////////////////////////
					//Filtra por Nome
					///////////////////////////////////////////
					If( !empty(alltrim(__like_nome)) )
						__cWhereNome := "'%"+alltrim(__like_nome)+"%'"
						__lrangeN := .T.
					EndIf
					If( !empty(__cWhereNome) )
						__rangeN := " SA1.A1_NOME LIKE "+__cWhereNome+" "
						__rangeN := "%" + __rangeN + "%"
					EndIf

					If( !empty(__rangeN) )
						beginSQL alias __alias
						SELECT SA1.* FROM %table:SA1% SA1
						WHERE SA1.A1_FILIAL = %xFilial:SA1%
						AND SA1.%NotDel%
						AND %exp:__rangeN%
						ORDER BY 1, 5
						endSQL

						aqry := GetLastQuery()
						While (__alias)->( !eof() )
							aAdd( __customer,{ (__alias)->A1_FILIAL,alltrim((__alias)->A1_COD),alltrim((__alias)->A1_LOJA),(__alias)->A1_PESSOA,;
							alltrim((__alias)->A1_NOME),alltrim((__alias)->A1_NREDUZ),alltrim((__alias)->A1_END),(__alias)->A1_TIPO,;
							(__alias)->A1_EST,(__alias)->A1_COD_MUN,(__alias)->A1_MUN,(__alias)->A1_BAIRRO,;
							(__alias)->A1_TEL,(__alias)->A1_CGC,(__alias)->A1_INSCR,(__alias)->A1_CEP,;
							(__alias)->A1_CODPAIS, (__alias)->A1_VENCLC, (__alias)->A1_COND, (__alias)->A1_TPFRET, AllTrim((__alias)->A1_CONTATO) })
							(__alias)->( dbSkip() )
						End
						(__alias)->( dbCloseArea() )
					Else
						SA1->( dbSetOrder(3) )
						SA1->( dbSeek( xFilial("SA1")+__cpf_cnpj ) )
						While SA1->( !eof() ) .And. SA1->A1_FILIAL+alltrim(SA1->A1_CGC) == xFilial("SA1")+alltrim(__cpf_cnpj)
							aAdd( __customer,{ SA1->A1_FILIAL,alltrim(SA1->A1_COD),alltrim(SA1->A1_LOJA),SA1->A1_PESSOA,;
							alltrim(SA1->A1_NOME),alltrim(SA1->A1_NREDUZ),alltrim(SA1->A1_END),SA1->A1_TIPO,;
							SA1->A1_EST,SA1->A1_COD_MUN,SA1->A1_MUN,SA1->A1_BAIRRO,;
							SA1->A1_TEL,SA1->A1_CGC,SA1->A1_INSCR,SA1->A1_CEP,;
							SA1->A1_CODPAIS, SA1->A1_VENCLC, SA1->A1_COND, SA1->A1_TPFRET, AllTrim(SA1->A1_CONTATO) })
							SA1->( dbSkip() )
						End
					EndIf

				EndIf

			EndIf

		EndIf
	EndIf
	RestArea( __area )
Return( __customer )


////////////////////////////////////////////////////////////////////////////
//|Autor	|Thiago de Jesus      			| 15-02-2016 | Crail
//|Funcao   |ManCustomer                     
//|Uso		|Valida e consulta Produtos existentes na Base do Protheus
////////////////////////////////////////////////////////////////////////////
User Function ManCustomer(__NewCustomer, __nopc, __type, __cpf_cnpj, __wsSoapFault, __customer)
	local __lret 		:= .T.                        
	local __area 		:= GetArea()
	local __nY   		:= 0
	local __filial		:= ""
	local __codigo 		:= ""
	local __loja 		:= ""
	local __pessoa 		:= ""
	local __nome 		:= ""
	local __nreduz 		:= ""
	local __endereco 	:= ""
	local __tipo 		:= ""
	local __estado 		:= ""
	local __cod_municipio:= ""
	local __municipio 	:= ""
	local __bairro 		:= ""  
	local __naturez       := ""
	local __telefone 	:= ""
	local __cnpj_cgc 	:= ""
	local __InsEstadual := ""
	local __CEP 		:= ""
	local __codpais 	:= ""
	local __cod_munic   := ""
	local __municip     := ""
	local __ddd     	:= ""
	local __email     	:= ""
	local __nRec		:= 0
	local __cust		:= ""
	Local __contato 	:= "" 
	Local __COMPL 		:= " "    	// salomao
	Local nChage 		:= "" 		// Julio Sousa 
	Local cTexto := ""
	Local  	lEnc := .F.
	
	If( __nopc == 3 ) //Inclusao
		//__codigo:= GetSx8Num("SA1","A1_COD") //Thiago
		__loja 	:= "01"
		dbSelectArea("SA1")
		SA1->( dbSetOrder(1) )
		While SA1->( dbSeek( xFilial("SA1")+__codigo+__loja ) )
			ConfirmSX8()
			__codigo := GetSx8Num("SA1","A1_COD")
		End
	ElseIf( __nopc == 4 .or. __nopc == 5 )
		__nRec  := SA1->( Recno() )

	EndIf

	//--11-11-17 - vicente lacerenza - Fit Gestao
	//-- se inclusao ou alteracao - solicitado por Bruno T. Araujo.
	If( __nopc == 3 .or. __nopc == 4 )
         
		if __nRec > 0 
	  		ConOut("Chips - Teste de exibição de texto no Console...")
			dbSelectArea('SA1')
			SA1->( dbGoTo( __nRec ) )
		  /*	If SA1->(RecLock( 'SA1', .F. ))
			   //	SA1->A1_GRPTRIB	:= "GCF"
				SA1->(MsUnlock()) 
				CONOUT("Registro lockou")
			else
				CONOUT("Registro nao lockou")
			Endif   
		    CONOUT("Caio - RECNO sa:") */
		else
		 	ConOut("nao encontrou recno: 0 ")
		Endif
	Endif



	If( ( __nopc == 3 .or. __nopc == 4 ) .And. Valtype(__NewCustomer:__ADATA)=="A" )
		If( len(__NewCustomer:__ADATA) > 1 )
			aDel (__NewCustomer:__ADATA, len(__NewCustomer:__ADATA))
			aSize(__NewCustomer:__ADATA, len(__NewCustomer:__ADATA)-1)
		EndIf

		For __nY := 1 to len(__NewCustomer:__ADATA)
			__filial		:= Iif(empty(__NewCustomer:__ADATA[__nY]:__filial),cFilAnt,__NewCustomer:__ADATA[__nY]:__filial)
			__codigo 		:= Iif(empty(__NewCustomer:__ADATA[__nY]:__codigo),__codigo,__NewCustomer:__ADATA[__nY]:__codigo)
			__loja 			:= Iif(empty(__NewCustomer:__ADATA[__nY]:__loja),__loja,__NewCustomer:__ADATA[__nY]:__loja)
			__pessoa 		:= Upper(__NewCustomer:__ADATA[__nY]:__pessoa)
			__nome 			:= Upper(TiraGraf(__NewCustomer:__ADATA[__nY]:__nome))
			__nreduz 		:= Upper(TiraGraf(__NewCustomer:__ADATA[__nY]:__nreduz))
			__endereco 		:= Upper(TiraGraf(__NewCustomer:__ADATA[__nY]:__endereco))
			__tipo 			:= Upper(Iif(empty(__NewCustomer:__ADATA[__nY]:__tipo),__type,__NewCustomer:__ADATA[__nY]:__tipo))
			__estado 		:= Upper(TiraGraf(alltrim(__NewCustomer:__ADATA[__nY]:__estado)))
			__cidade 		:= Upper(TiraGraf(alltrim(__NewCustomer:__ADATA[__nY]:__cidade)))
			__cod_municipio := __NewCustomer:__ADATA[__nY]:__cod_municipio
			__municipio 	:= __NewCustomer:__ADATA[__nY]:__municipio
			__bairro 		:= Upper(TiraGraf(__NewCustomer:__ADATA[__nY]:__bairro))
			__ddd			:= If( __NewCustomer:__ADATA[__nY]:__ddd == Nil, "", TiraGraf(__NewCustomer:__ADATA[__nY]:__ddd) )
			__telefone 		:= If( __NewCustomer:__ADATA[__nY]:__telefone == Nil, "", TiraGraf(__NewCustomer:__ADATA[__nY]:__telefone) )
			__cnpj_cgc 		:= Iif(empty(__NewCustomer:__ADATA[__nY]:__cnpj_cgc),__cpf_cnpj,__NewCustomer:__ADATA[__nY]:__cnpj_cgc)
			__InsEstadual 	:= Iif(empty(__NewCustomer:__ADATA[__nY]:__InsEstadual),"ISENTO",__NewCustomer:__ADATA[__nY]:__InsEstadual)
			__CEP 			:= TiraGraf(__NewCustomer:__ADATA[__nY]:__CEP)
			__codpais 		:= Iif(empty(__NewCustomer:__ADATA[__nY]:__codpais),"01058",__NewCustomer:__ADATA[__nY]:__codpais) 
			__email     	:= Iif(empty(__NewCustomer:__ADATA[__nY]:__email),"",__NewCustomer:__ADATA[__nY]:__email)
			__datadenascim  := Iif(empty(__NewCustomer:__ADATA[__nY]:__datadenascim)," ",__NewCustomer:__ADATA[__nY]:__datadenascim)
			__contato 		:= Iif(empty(__NewCustomer:__ADATA[__nY]:__contato),__contato,__NewCustomer:__ADATA[__nY]:__contato)
			__COMPL     	:= Iif(empty(__NewCustomer:__ADATA[__nY]:__COMPL),__COMPL,__NewCustomer:__ADATA[__nY]:__COMPL) //salomao
							        	
			CONOUT("TESTE APOS ARRAY DE CARREG VARIAVEIS - CAIO 1338" + __cnpj_cgc)
			If( !empty(__estado) )
				CC2->( dbSetorder(4) )
				If( CC2->( dBseek( xFilial("CC2")+Upper(__estado)+Upper(__cidade) ) ) )
					__cod_munic 	:= CC2->CC2_CODMUN
					__municip   	:= CC2->CC2_MUN
					__estado    	:= CC2->CC2_EST
					__cod_municipio := __cod_munic
					__municipio 	:= __municip
				EndIf
			EndIf
			exit
		Next __nY
		__cpf_cnpj := __cnpj_cgc
		///////////////////////////////////////////////////////////
		// Tratativas para MsExecAuto
		///////////////////////////////////////////////////////////

		
		If( __nopc == 3 )
			/*__cust :={;
			/*{"A1_COD"     ,__codigo                  	,Nil},;
			{"A1_LOJA"    ,__loja                    	,Nil},;
			{"A1_NOME"      ,AllTrim(__nome)           	,Nil},;
			{"A1_PESSOA"    ,__tipo     				,Nil},;
			{"A1_NREDUZ"    ,AllTrim(__nreduz)          ,Nil},;
			{"A1_END"       ,__endereco                	,Nil},;
			{"A1_TIPO"      ,"F"                     	,Nil},;
			{"A1_EST"       ,SubStr(__estado,1,2)       ,Nil},;
			{"A1_COD_MUN"   ,AllTrim(__cod_municipio)   ,Nil},;
			{"A1_MUN"       ,SubStr(__municip,1,15)   	,Nil},;
			{"A1_BAIRRO"    ,__bairro              		,Nil},;
			{"A1_CEP"       ,__CEP                   	,Nil},;
			{"A1_PAIS"      ,"105"                      ,Nil},;
			{"A1_CGC"       ,__cnpj_cgc                 ,Nil},;
			{"A1_TEL"       ,__telefone                 ,Nil},;
			{"A1_DDD"       ,__ddd                 		,Nil},;
			{"A1_DTNASC"    ,Ctod(__datadenascim)       ,Nil},;
			{"A1_EMAIL"     ,__email                  	,Nil},;
			{"A1_INSCR"     ,__InsEstadual              ,Nil},;
			{"A1_CODPAIS"   ,__codpais                  ,Nil},;
			{"A1_VENCLC"    ,Ctod("31/12/2049")         ,Nil},;
			{"A1_CONTATO"   , __contato                 ,Nil},;
			{"A1_CONTRIB"   ,"2"                        ,NiL},; 
			{"A1_GRPTRIB"   ,"GCF"			,Nil},;        //alterado surya
			{"A1_COMPLEM"   , __COMPL	                ,Nil},;    
			{"A1_XCANAL" 	, "000007"              													,Nil},; 
			{"A1_XSUBCAN"	, "000007"              													,Nil},;
			{"A1_INSCR"		, "ISENTO"                 													,Nil},;
			{"A1_CONTA" 	, "1120100100001"              												,Nil},;
			{"A1_RISCO" 	, "A"              															,Nil},;
			{"A1_LC" 		, "999999"                 													,Nil},;
			{"A1_CONTRIB" 	, "2"              													   		,Nil},;
			{"A1_FLST" 		, "1"              															,Nil},;
			{"A1_CLITIPO" 	, "3"              															,Nil},;
			{"A1_EMAIL2" 	, Iif(empty(__email),SA1->A1_EMAIL,__email)              					,Nil},;
			{"A1_DTSERAS" 	, dDatabase              													,Nil},;
			{"A1_PREF" 		, "1"              															,Nil},;
			{"A1_REGIAO" 	, nChage           															,Nil},;  
			{"A1_NATUREZ" 	, "1.01.001"          															,Nil},;
			{"A1_TABELA"    ,IIF(__tipo =="R",GetNewPar( "MV_MAGB2B"),GetNewPar( "MV_MAGB2C" ))	,Nil}}  */  
			
			//reclock inclusao Rodrigo
			RECLOCK("SA1", .T.) 
        
        SA1->A1_FILIAL               :=  " "             											
		SA1->A1_COD                 :=  GetSXENum("SA1", "A1_COD")// Iif(empty(__codigo),SA1->A1_COD,__codigo)                 				//,Iif(empty(__codigo),SA1->A1_COD,__codigo)
		SA1->A1_LOJA                :=  "01"              					    //Iif(empty(__loja),SA1->A1_LOJA,__loja)    
		SA1->A1_NOME              :=   Iif(empty(__nome),SA1->A1_NOME,__nome)  								 //Iif(empty(__nome),SA1->A1_NOME,__nome) 
		SA1->A1_PESSOA           :=  Iif(empty(__pessoa), SA1->A1_PESSOA , __pessoa)    													
		SA1->A1_NREDUZ           :=   Iif(empty(__nreduz),SA1->A1_NREDUZ,__nreduz)          					
		SA1->A1_END                 :=   Iif(empty(__endereco),SA1->A1_END,__endereco) 
		SA1->A1_ENDCOB                :=   Iif(empty(__endereco),SA1->A1_END,__endereco)
		SA1->A1_ENDREC                 :=   Iif(empty(__endereco),SA1->A1_END,__endereco) 
		SA1->A1_ENDENT                 :=   Iif(empty(__endereco),SA1->A1_END,__endereco)             			
		SA1->A1_TIPO                :=    Iif(empty(__tipo),SA1->A1_TIPO, __tipo)               											
		SA1->A1_EST                 :=    Iif(empty(__estado),SA1->A1_EST,__estado)       						  
		SA1->A1_COD_MUN       :=    alltrim(cValtochar(Iif(empty(__cod_municipio),SA1->A1_COD_MUN,__cod_municipio)))	//alltrim(cValtochar(Iif(empty(__cod_municipio),SA1->A1_COD_MUN,__cod_municipio)))
		SA1->A1_MUN                :=    Iif(empty(__municip),SA1->A1_MUN,__municip)   							
		SA1->A1_BAIRRO           :=    Iif(empty(__bairro),SA1->A1_BAIRRO,__bairro)
		SA1->A1_BAIRROE           :=    Iif(empty(__bairro),SA1->A1_BAIRRO,__bairro)
		SA1->A1_BAIRROC           :=    Iif(empty(__bairro),SA1->A1_BAIRRO,__bairro)                 				
		SA1->A1_CEP                 :=   Iif(empty(__CEP),SA1->A1_CEP,__CEP)                					
		SA1->A1_PAIS                  :=  SA1->A1_PAIS               							   				
		SA1->A1_CGC                  :=   __cnpj_cgc              			    //Iif(empty(__cnpj_cgc),SA1->A1_CGC,__cnpj_cgc)  
		SA1->A1_TEL                   :=   Iif(empty(__telefone),SA1->A1_TEL,__telefone)              		
		SA1->A1_DDD                  :=   Iif(empty(__ddd),SA1->A1_DDD,__ddd)                					
		SA1->A1_DTNASC           :=    SA1->A1_DTNASC      													      //dtos(SA1->A1_DTNASC)    - SA1->A1_DTNASC
		SA1->A1_EMAIL               :=    Iif(empty(__email),SA1->A1_EMAIL,__email)              				
		SA1->A1_INSCR               :=    Iif(empty(__InsEstadual),SA1->A1_INSCR,__InsEstadual)      			
		SA1->A1_CODPAIS          :=Iif(empty(__codpais),SA1->A1_CODPAIS,__codpais)            			
		SA1->A1_RISCO               :=   SA1->A1_RISCO              											
		SA1->A1_CONTATO         :=IIF(Empty(__contato), SA1->A1_CONTATO, __contato)		   				
		SA1->A1_GRPTRIB          :=   IIF(__estado =  "SP", "GSP", "GCF")																			
		SA1->A1_COMPLEM        := IIF(Empty(__COMPL), SA1->A1_COMPLEM, __COMPL)	       					 //salomao
		SA1->A1_TABELA            :=     IIF(SA1->A1_TIPO =="R",GetNewPar( "MV_MAGB2B"),GetNewPar( "MV_MAGB2C" ))  //20180103 - Julio Sousa - InserÃƒÂ§ÃƒÂ£o dos campos especificos para o cliente SURYA daqui para baixo no array
		SA1->A1_XCANAL            :=  	 "000007"              												
		SA1->A1_XSUBCAN         := 	     "000007"              												
		SA1->A1_CONTA             :=  	 "1120100100001"              											
		SA1->A1_RISCO              :=  	 "A"              														
		SA1->A1_LC                   :=  		 999999                 												
		SA1->A1_VENCLC          :=  	STOD( "31/12/2099")              												
		SA1->A1_CODPAIS         :=  	 "01058"              													
		SA1->A1_CONTRIB          :=  	 "2"              													   	
		SA1->A1_FLST                :=  		 "1"              														
		SA1->A1_CLITIPO            := 	 "3"              														
		SA1->A1_EMAIL2             :=  	 Iif(empty(__email),SA1->A1_EMAIL,__email)              			
		SA1->A1_DTSERAS         :=  dDatabase             												             //dtos(dDatabase) 
		SA1->A1_PREF               :=  		 "1"              														
		SA1->A1_NATUREZ		   := 	 "1.01.001"          														
		SA1->A1_REGIAO           :=  	 nChage           													
		  //	{"A1_XFORMA" 	, "1004"            															,Nil}}
       

			If FieldPos("A1_CLITIPO") > 0
				SA1->A1_CLITIPO := "3"		
			EndIf
			If FieldPos("A1_XCANAL") > 0
			    SA1->A1_XCANAL := "000016"	
			EndIf
			If FieldPos("A1_XSUBCAN") > 0
				SA1->A1_XSUBCAN:= "000016"
			EndIf
			If FieldPos("A1_XFORMA") > 0
				SA1->A1_XFORMA:= "1004"
			EndIf
	    Msunlock()
	    ConfirmSX8()		
		//SA1->( dbSetOrder(3) ) 
		//IF SA1->(DBSEEK(xFilial() + __cnpj_cgc, .T.))
	   //	If Found()
		lEnc := .T.
		//ENDIF
		//ENDIF
			
		ElseIf( __nopc == 4 )
			
			//---------------------------------------------------------------------------------------------------------
            // 20180103 - Julio Sousa - InserÃƒÂ§ÃƒÂ£o dos campos especificos para o cliente SURYA
			//---------------------------------------------------------------------------------------------------------
			//REGIÃƒÆ’O DO ESTADO
			IF __ESTADO == 'AM' .or. __ESTADO == 'RR' .or. __ESTADO == 'AP' .or.;
			 __ESTADO == 'PA' .or. __ESTADO == 'TO' .or. __ESTADO == 'RO' .or. __ESTADO == 'AC' 
				//NORTE
				nChage := "001"
			ELSEIF __ESTADO == 'PR' .or. __ESTADO == 'RS' .or. __ESTADO == 'SC'
				//SUL 
				nChage := "002"
			ELSEIF __ESTADO == 'SP' .or. __ESTADO == 'RJ' .or. __ESTADO == 'ES' .or. __ESTADO == 'MG'
				//SUDESTE
				nChage := "003"
			ELSEIF __ESTADO == 'MA' .or. __ESTADO == 'PI' .or. __ESTADO == 'CE' .or. __ESTADO == 'RN' .or.;
			 __ESTADO == 'PE' .or. __ESTADO == 'PB' .or. __ESTADO == 'SE' .or. __ESTADO == 'AL' .or. __ESTADO == 'BA'
				//NORDESTE
				nChage := "004"
			ELSEIF __ESTADO == 'MT' .or. __ESTADO == 'MS' .or. __ESTADO == 'ES' .or. __ESTADO == 'GO'
				//CENTRO OESTE
				nChage := "005"
			ENDIF
			//---------------------------------------------------------------------------------------------------------  

/*/ ALTERADO PARA RECLOCK		    __cust :={;
{"A1_FILIAL"    ," "             												,Nil},;
		    {"A1_COD"       ,Iif(empty(__codigo),SA1->A1_COD,__codigo)                 					,Nil},;  //,Iif(empty(__codigo),SA1->A1_COD,__codigo)
		   	{"A1_LOJA"      ,Iif(empty(__loja),SA1->A1_LOJA,__loja)              						,Nil},;      //Iif(empty(__loja),SA1->A1_LOJA,__loja)    
			{"A1_NOME"      ,"PAGSEGURO RODRIGO S TESTE 08"  									,Nil},;   //Iif(empty(__nome),SA1->A1_NOME,__nome) 
			{"A1_PESSOA"    ,SA1->A1_PESSOA     														,Nil},;
			{"A1_NREDUZ"    ,Iif(empty(__nreduz),SA1->A1_NREDUZ,__nreduz)          						,Nil},;
			{"A1_END"       ,Iif(empty(__endereco),SA1->A1_END,__endereco)              				,Nil},;
			{"A1_TIPO"      ,SA1->A1_TIPO               												,Nil},;
			{"A1_EST"       ,Iif(empty(__estado),SA1->A1_EST,__estado)       							,Nil},;
			{"A1_COD_MUN"   ,alltrim(cValtochar(Iif(empty(__cod_municipio),SA1->A1_COD_MUN,__cod_municipio)))				,Nil},;         //alltrim(cValtochar(Iif(empty(__cod_municipio),SA1->A1_COD_MUN,__cod_municipio)))
		   ;//	{"A1_MUN"       ,Iif(empty(__municip),SA1->A1_MUN,__municip)   								,Nil},;
			{"A1_BAIRRO"    ,Iif(empty(__bairro),SA1->A1_BAIRRO,__bairro)             					,Nil},;
			{"A1_CEP"       ,Iif(empty(__CEP),SA1->A1_CEP,__CEP)                						,Nil},;
		   ;//	{"A1_PAIS"      ,SA1->A1_PAIS               							   					,Nil},;
		   	{"A1_CGC"       ,__cnpj_cgc              				,Nil},;    //Iif(empty(__cnpj_cgc),SA1->A1_CGC,__cnpj_cgc)  
			;//{"A1_TEL"       ,Iif(empty(__telefone),SA1->A1_TEL,__telefone)              				,Nil},;
			;//{"A1_DDD"       ,Iif(empty(__ddd),SA1->A1_DDD,__ddd)                						,Nil},;
		    ;//{"A1_DTNASC"    ,dtos(SA1->A1_DTNASC)      														,Nil},;        //dtos(SA1->A1_DTNASC)    - SA1->A1_DTNASC
			{"A1_EMAIL"     ,Iif(empty(__email),SA1->A1_EMAIL,__email)              					,Nil},;
			{"A1_INSCR"     ,Iif(empty(__InsEstadual),SA1->A1_INSCR,__InsEstadual)      				,Nil},;
			{"A1_CODPAIS"   ,Iif(empty(__codpais),SA1->A1_CODPAIS,__codpais)            				,Nil},;
			{"A1_RISCO"     ,SA1->A1_RISCO              												,Nil},;
		   	{"A1_CONTATO"   ,IIF(Empty(__contato), SA1->A1_CONTATO, __contato)		   					,Nil},;
			;//{"A1_GRPTRIB"   ,"GCF"																		,Nil},;
			;//{"A1_COMPLEM"   ,IIF(Empty(__COMPL), SA1->A1_COMPLEM, __COMPL)	       						,Nil},; //salomao
			;//{"A1_TABELA"    ,IIF(SA1->A1_TIPO =="R",GetNewPar( "MV_MAGB2B"),GetNewPar( "MV_MAGB2C" ))	,Nil},;  // 20180103 - Julio Sousa - InserÃƒÂ§ÃƒÂ£o dos campos especificos para o cliente SURYA daqui para baixo no array
			{"A1_XCANAL" 	, "000007"              													,Nil},; 
			{"A1_XSUBCAN"	, "000007"              													,Nil},;
		  	{"A1_CONTA" 	, "1120100100001"              												,Nil},;
			{"A1_RISCO" 	, "A"              															,Nil},;
			;//{"A1_LC" 		, "999999"                 													,Nil},;
			{"A1_VENCLC" 	, "20993112"              													,Nil},;
			{"A1_CODPAIS" 	, "01058"              														,Nil},;
			{"A1_CONTRIB" 	, "2"              													   		,Nil},;
			{"A1_FLST" 		, "1"              															,Nil},;
			;//{"A1_CLITIPO" 	, "3"              															,Nil},;
			{"A1_EMAIL2" 	, Iif(empty(__email),SA1->A1_EMAIL,__email)              					,Nil}}
		   	;//{"A1_DTSERAS" 	,dtos(dDatabase)              													,Nil},;             //dtos(dDatabase) 
			;//{"A1_PREF" 		, "1"              															,Nil},; 
			;//{"A1_NATUREZ" 	, "1.01.001"          															,Nil},;
			;//{"A1_REGIAO" 	, nChage           															,Nil}} 
		  //	{"A1_XFORMA" 	, "1004"           															,Nil}}
			//---------------------------------------------------------------------------------------------------------   
			CONOUT( "dentro do iff carreg alteracao " + __cust[1][1] + " " +  __cust[1][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[2][1] + " " +  __cust[2][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[3][1] + " " +  __cust[3][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[4][1] + " " +  __cust[4][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[5][1] + " " +  __cust[5][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[6][1] + " " +  __cust[6][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[7][1] + " " +  __cust[7][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[8][1] + " " +  __cust[8][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[9][1] + " " +  __cust[9][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[10][1] + " " +  __cust[10][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[11][1] + " " +  __cust[11][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[12][1] + " " +  __cust[12][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[13][1] + " " +  __cust[13][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[14][1] + " " +  __cust[14][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[15][1] + " " +  __cust[15][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[16][1] + " " +  __cust[16][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[17][1] + " " +  __cust[17][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[18][1] + " " +  __cust[18][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[19][1] + " " +  __cust[19][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[20][1] + " " +  __cust[20][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[21][1] + " " +  __cust[21][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[22][1] + " " +  __cust[22][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[23][1] + " " +  __cust[23][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[24][1] + " " +  __cust[24][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[25][1] + " " +  __cust[25][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[26][1] + " " +  __cust[26][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[27][1] + " " +  __cust[27][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[28][1] + " " +  __cust[28][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[29][1] + " " +  __cust[29][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[30][1] + " " +  __cust[30][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[31][1] + " " +  __cust[31][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[32][1] + " " +  __cust[32][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[33][1] + " " +  __cust[33][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[34][1] + " " +  __cust[34][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[35][1] + " " +  __cust[35][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[36][1] + " " +  __cust[36][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[37][1] + " " +  __cust[37][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[38][1] + " " +  __cust[38][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[39][1] + " " +  __cust[39][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[40][1] + " " +  __cust[40][2])
			CONOUT( "dentro do iff carreg alteracao " + __cust[41][1] + " " +  __cust[41][2])
			//CONOUT( "dentro do iff carreg alteracao " + __cust[42][1] + " " +  __cust[42][2])
			//CONOUT( "dentro do iff carreg alteracao " + __cust[43][1] + " " +  __cust[43][2]) 
	       __cust := FWVetByDic( __cust, "SA1" )
CONOUT("Depois das variaveis" )
  
EndIf			
   */		
		lMSHelpAuto := .F.
		lMSErroAuto := .F.
		lAutoErrNoFile := .T.
	
		SA1->( dbSetOrder(3) ) 
		IF SA1->(DBSEEK(xFilial() + __cnpj_cgc, .T.))
		If Found()
		lEnc := .T.
        //RECLOCK RODRIGO
        RECLOCK("SA1", .F.) 
        ConOut("CHIPS - entrou na gravacao da alteracao")
        SA1->A1_FILIAL               :=  " "             											
		SA1->A1_COD                 :=   Iif(empty(__codigo),SA1->A1_COD,__codigo)                 				//,Iif(empty(__codigo),SA1->A1_COD,__codigo)
		SA1->A1_LOJA                :=   Iif(empty(__loja),SA1->A1_LOJA,__loja)              					    //Iif(empty(__loja),SA1->A1_LOJA,__loja)    
		SA1->A1_NOME              :=   Iif(empty(__nome),SA1->A1_NOME,__nome)  								 //Iif(empty(__nome),SA1->A1_NOME,__nome) 
		SA1->A1_PESSOA           :=  Iif(empty(__pessoa), SA1->A1_PESSOA , __pessoa)      													
		SA1->A1_NREDUZ           :=   Iif(empty(__nreduz),SA1->A1_NREDUZ,__nreduz)          					
		SA1->A1_END                 :=   Iif(empty(__endereco),SA1->A1_END,__endereco)
		SA1->A1_ENDCOB                :=   Iif(empty(__endereco),SA1->A1_END,__endereco)
		SA1->A1_ENDREC                 :=   Iif(empty(__endereco),SA1->A1_END,__endereco)
		SA1->A1_ENDENT                 :=   Iif(empty(__endereco),SA1->A1_END,__endereco)               			
		SA1->A1_TIPO                :=    Iif(empty(__tipo),SA1->A1_TIPO, __tipo)              											
		SA1->A1_EST                 :=    Iif(empty(__estado),SA1->A1_EST,__estado)       						  
		SA1->A1_COD_MUN       :=    alltrim(cValtochar(Iif(empty(__cod_municipio),SA1->A1_COD_MUN,__cod_municipio)))	//alltrim(cValtochar(Iif(empty(__cod_municipio),SA1->A1_COD_MUN,__cod_municipio)))
		SA1->A1_MUN                :=    Iif(empty(__municip),SA1->A1_MUN,__municip)   							
		SA1->A1_BAIRRO           :=    Iif(empty(__bairro),SA1->A1_BAIRRO,__bairro)
		SA1->A1_BAIRROE           :=    Iif(empty(__bairro),SA1->A1_BAIRRO,__bairro)
		SA1->A1_BAIRROC           :=    Iif(empty(__bairro),SA1->A1_BAIRRO,__bairro)             				
		SA1->A1_CEP                 :=   Iif(empty(__CEP),SA1->A1_CEP,__CEP)                					
		SA1->A1_PAIS                  :=  SA1->A1_PAIS               							   				
		SA1->A1_CGC                  :=   __cnpj_cgc              			    //Iif(empty(__cnpj_cgc),SA1->A1_CGC,__cnpj_cgc)  
		SA1->A1_TEL                   :=   Iif(empty(__telefone),SA1->A1_TEL,__telefone)              		
		SA1->A1_DDD                  :=   Iif(empty(__ddd),SA1->A1_DDD,__ddd)                					
		SA1->A1_DTNASC           :=    SA1->A1_DTNASC      													      //dtos(SA1->A1_DTNASC)    - SA1->A1_DTNASC
		SA1->A1_EMAIL               :=    Iif(empty(__email),SA1->A1_EMAIL,__email)              				
		SA1->A1_INSCR               :=    Iif(empty(__InsEstadual),SA1->A1_INSCR,__InsEstadual)      			
		SA1->A1_CODPAIS          :=Iif(empty(__codpais),SA1->A1_CODPAIS,__codpais)            			
		SA1->A1_RISCO               :=   SA1->A1_RISCO              											
		SA1->A1_CONTATO         :=IIF(Empty(__contato), SA1->A1_CONTATO, __contato)		   				
		SA1->A1_GRPTRIB          :=  IIF(__estado =  "SP", "GSP", "GCF")																	
		SA1->A1_COMPLEM        := IIF(Empty(__COMPL), SA1->A1_COMPLEM, __COMPL)	       					 //salomao
		SA1->A1_TABELA            :=     IIF(SA1->A1_TIPO =="R",GetNewPar( "MV_MAGB2B"),GetNewPar( "MV_MAGB2C" ))  //20180103 - Julio Sousa - InserÃƒÂ§ÃƒÂ£o dos campos especificos para o cliente SURYA daqui para baixo no array
		SA1->A1_XCANAL            :=  	 "000007"              												
		SA1->A1_XSUBCAN         := 	     "000007"              												
		SA1->A1_CONTA             :=  	 "1120100100001"              											
		SA1->A1_RISCO              :=  	 "A"              														
		SA1->A1_LC                   :=  		 999999                 												
		SA1->A1_VENCLC          :=  	STOD( "31/12/2099")              												
		SA1->A1_CODPAIS         :=  	 "01058"              													
		SA1->A1_CONTRIB          :=  	 "2"              													   	
		SA1->A1_FLST                :=  		 "1"              														
		SA1->A1_CLITIPO            := 	 "3"              														
		SA1->A1_EMAIL2             :=  	 Iif(empty(__email),SA1->A1_EMAIL,__email)              			
		SA1->A1_DTSERAS         :=  dDatabase             												             //dtos(dDatabase) 
		SA1->A1_PREF               :=  		 "1"              														
		SA1->A1_NATUREZ		   := 	 "1.01.001"          														
		SA1->A1_REGIAO           :=  	 nChage           													
		SA1->A1_XFORMA		   := "1004"
		
        Msunlock()
        ENDIF
 ConOut("CHIPS - gravou alteracao")      
ENDIF        
        
        //FIM RECLOCK
		//CC2->( dbSetorder(1) ) 
	   //	MSExecAuto( {|x,y| MATA030(x,y)}, __cust, 4 )   //RODRIGO - TROCA POR RECLOCK
       //conout("Passou no if do execauto" + __cnpj_cgc )

       // endif
  //		If lMSErroAuto
  //			aErroAuto := GetAutoGRLog() 
		    
 //			For __nY := 1 To Len(aErroAuto)
 //				__wsSoapFault += StrTran(StrTran(StrTran(aErroAuto[__nY],"<"," "),"-"," "),"/"," ")+" "
				//exit //TDJ001
				
 //			Next __nY       
			 
 //			CONOUT( lMSErroAuto )
 //		    CONOUT("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++CAIO")
//			conout(__wsSoapFault)
			
		//Else
EndIf		
		IF 	lEnc
			CONOUT("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
		    //CONOUT(__cust[4,2])
		    //CONOUT(__nopc)
		    CONOUT("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ GRAVOU")
			ConfirmSX8()   

		   

			aAdd( __customer,{ SA1->A1_FILIAL,alltrim(SA1->A1_COD),alltrim(SA1->A1_LOJA),SA1->A1_PESSOA,;
			alltrim(SA1->A1_NOME),alltrim(SA1->A1_NREDUZ),alltrim(SA1->A1_END),SA1->A1_TIPO,;
			SA1->A1_EST,SA1->A1_COD_MUN,SA1->A1_MUN,SA1->A1_BAIRRO,;
			SA1->A1_TEL,SA1->A1_CGC,SA1->A1_INSCR,SA1->A1_CEP,;
			SA1->A1_CODPAIS, SA1->A1_VENCLC, SA1->A1_COND, SA1->A1_TPFRET, AllTrim(SA1->A1_CONTATO),AllTrim(SA1->A1_COMPLEM) })//salomao
	  ELSE
	  
	  CONOUT("Cliente nÃ£o encontrado") 
	  ENDIF		
			
					

	ElseIf( __nopc == 5 .And. __nRec > 0 )
		SA1->( dbGoTo( __nRec ) )
		__cust :={;
		{"A1_FILIAL"    ,SA1->A1_FILIAL             								,Nil},;
		{"A1_COD"       ,Iif(empty(__codigo),SA1->A1_COD,__codigo)                	,Nil},;
		{"A1_LOJA"      ,Iif(empty(__loja),SA1->A1_LOJA,__loja)               		,Nil},;
		{"A1_NOME"      ,Iif(empty(__nome),SA1->A1_NOME,__nome)   					,Nil},;
		{"A1_PESSOA"    ,SA1->A1_PESSOA     										,Nil},;
		{"A1_NREDUZ"    ,Iif(empty(__nreduz),SA1->A1_NREDUZ,__nreduz)          		,Nil},;
		{"A1_END"       ,Iif(empty(__endereco),SA1->A1_END,__endereco)              ,Nil},;
		{"A1_TIPO"      ,SA1->A1_TIPO               								,Nil},;
		{"A1_EST"       ,Iif(empty(__estado),SA1->A1_EST,__estado)       			,Nil},;
		{"A1_COD_MUN"   ,Iif(empty(__cod_municipio),SA1->A1_COD_MUN,__cod_municipio),Nil},;
		{"A1_MUN"       ,Iif(empty(__municip),SA1->A1_MUN,__municip)   				,Nil},;
		{"A1_BAIRRO"    ,Iif(empty(__bairro),SA1->A1_BAIRRO,__bairro)             	,Nil},;
		{"A1_CEP"       ,Iif(empty(__CEP),SA1->A1_CEP,__CEP)                		,Nil},;
		{"A1_PAIS"      ,SA1->A1_PAIS               								,Nil},;
		{"A1_CGC"       ,Iif(empty(__cnpj_cgc),SA1->A1_CGC,__cnpj_cgc)              ,Nil},;
		{"A1_TEL"       ,Iif(empty(__telefone),SA1->A1_TEL,__telefone)              ,Nil},;
		{"A1_DDD"       ,Iif(empty(__ddd),SA1->A1_DDD,__ddd)                		,Nil},;
		{"A1_DTNASC"    ,SA1->A1_DTNASC       										,Nil},;
		{"A1_EMAIL"     ,Iif(empty(__email),SA1->A1_EMAIL,__email)              	,Nil},;
		{"A1_INSCR"     ,Iif(empty(__InsEstadual),SA1->A1_INSCR,__InsEstadual)      ,Nil},;
		{"A1_CODPAIS"   ,Iif(empty(__codpais),SA1->A1_CODPAIS,__codpais)            ,Nil},;
		{"A1_RISCO"     ,SA1->A1_RISCO              								,Nil},;
		{"A1_VENCLC"    ,SA1->A1_VENCLC         									,Nil},;
		{"A1_CONTATO"   ,IIF(Empty(__contato), SA1->A1_CONTATO, __contato)			,Nil},;
		{"A1_COMPLEM"   ,IIF(Empty(__COMPL), SA1->A1_COMPLEM, __COMPL)	   			,Nil}}
		lMSHelpAuto := .T.
		lMSErroAuto := .T.
		lAutoErrNoFile := .T.

		MSExecAuto( {|x,y| MATA030(x,y)},__cust,__nopc)
		If lMSErroAuto
			aErroAuto := GetAutoGRLog()
			For __nY := 1 To Len(aErroAuto)
				__wsSoapFault += StrTran(StrTran(StrTran(aErroAuto[__nY],"<"," "),"-"," "),"/"," ")+" "
				//exit //TDJ001
			Next __nY
		Else
			ConfirmSX8()

			aAdd( __customer,{ SA1->A1_FILIAL,alltrim(SA1->A1_COD),alltrim(SA1->A1_LOJA),SA1->A1_PESSOA,;
			alltrim(SA1->A1_NOME),alltrim(SA1->A1_NREDUZ),alltrim(SA1->A1_END),SA1->A1_TIPO,;
			SA1->A1_EST,SA1->A1_COD_MUN,SA1->A1_MUN,SA1->A1_BAIRRO,;
			SA1->A1_TEL,SA1->A1_CGC,SA1->A1_INSCR,SA1->A1_CEP,;
			SA1->A1_CODPAIS, SA1->A1_VENCLC, SA1->A1_COND, SA1->A1_TPFRET, AllTrim(SA1->A1_CONTATO),alltrim(SA1->A1_COMPLEM) })


		EndIf
	EndIf
CONOUT("fim")
	RestArea(__area)
Return( __lret )

////////////////////////////////////////////////////////////////////////////
//|Autor	|Thiago de Jesus      			| 12-02-2016 | Crail
//|Funcao   |ProdSearch                     
//|Uso		|Valida e consulta Produtos existentes na Base do Protheus
////////////////////////////////////////////////////////////////////////////
Static Function ProdSearch(	__filial,__codigo,__msblql,__rangeini,__rangefim,__descrfim,__wsSoapFault, __recursiva, __tabelaprc, __tblogista ) 
	local __product := {}
	local __query   := ""
	local __alias   := GetNextAlias()
	local __aqry    := {}
	local __area    := GetArea()
	local __nY      := 0
	local cWhere	:= ""
	local __afil    := {}
	local __aprd   	:= {}
	local __ablq	:= {}
	local __lrange  := .F.
	local __lrangeD := .F.
	local __range   := ""
	local __rangeD  := ""
	local cWhereFil := ""
	local cWherePrd := ""
	local cWhereBlq := ""
	local cWhereRIni:= ""
	local cWhereRFim:= ""
	local cWhereDIni:= ""
	local cWhereDFim:= ""
	local cWhereRec1:= ""
	local cWhereRec2:= ""
	local cRegMax	:= ""
	Local nValPrc	:= 0
	Local cArmPad	:= SUPERGETMV("FC_WEBARMZ",.T.,"17")
	default __filial	:= ""	
	default __codigo	:= ""
	default __msblql	:= ""
	default __rangeini	:= ""
	default __rangefim	:= ""
	default __descrfim	:= ""
	default __recursiva	:= ""

	If( !empty(__filial) .or. !empty(__codigo) .or. !empty(__msblql) )
		cWhereFil := Substr(__filial,1,(len(__filial)-1))   
		cWherePrd := Substr(__codigo,1,(len(__codigo)-1))   
		cWhereBlq := Substr(__msblql,1,(len(__msblql)-1))   
		cWhereFil := " SB2.B2_FILIAL IN ('"+cWhereFil+"') "
		cWhereFil := "%" + cWhereFil + "%"
		cWherePrd := " SB1.B1_COD IN ('"+cWherePrd+"') "
		cWherePrd := "%" + cWherePrd + "%"
		cWhereBlq := " SB1.B1_MSBLQL IN ('"+cWhereBlq+"') "
		cWhereBlq := "%" + cWhereBlq + "%"
	EndIf

	If( !empty(alltrim(__rangefim)) )
		cWhereRIni := "'"+iif(alltrim(__rangeini)==""," ",alltrim(__rangeini))+"'"
		cWhereRFim := "'"+alltrim(__rangefim)+"'"
		__lrange := .T.
	EndIf		

	If( !empty(cWhereRFim) )
		__range := " SB1.B1_COD BETWEEN "+cWhereRIni+" AND "+cWhereRFim+" "
		__range := "%" + __range + "%"
	EndIf

	If( !empty(alltrim(__descrfim)) )		
		cWhereDFim := "'%"+alltrim(__descrfim)+"%'"
		__lrangeD := .T.
	EndIf

	If( !empty(cWhereDFim) )
		__rangeD := " SB1.B1_DESC LIKE "+cWhereDFim+" "
		__rangeD := "%" + __rangeD + "%"
	EndIf

	If( __lrange )
		cWhereFil := "";cWherePrd := "";cWhereBlq := ""
	EndIf

	If( !empty( __recursiva ) )
		cWhereRec1 := " SB1.B1_XMAGBUS > '" + __recursiva + "' "
	Else
		cWhereRec1 := " SB1.B1_FILIAL = '" + xFilial( 'SB1' ) + "' "
	EndIf
	cWhereRec1 := "%" + cWhereRec1 + "%"

	If( !empty( __recursiva ) )
		cWhereRec2 := " SB1.B1_XMAGBUS = ' ' "
	Else
		cWhereRec2 := " SB1.B1_FILIAL = '" + xFilial( 'SB1' ) + "' "
	EndIf
	cWhereRec2 := "%" + cWhereRec2 + "%"

	/*If( empty( __recursiva ) )
		__query := " UPDATE SB1010 SET B1_XMAGBUS = ' ' WHERE B1_FILIAL = ' ' AND D_E_L_E_T_ = ' ' AND B1_XMAGBUS <> ' ' "

		TCSQLExec( __query )
	EndIf*/

	/*	If( empty( __recursiva ) )
	beginSQL alias '_REG'
	SELECT REPLACE(MAX(B1_XMAGBUS),'      ','000001') MAXIMO
	FROM %table:SB1% SB1
	WHERE B1_FILIAL = %xFilial:SB1%
	AND SB1.%NotDel%
	endSQL
	Else
	beginSQL alias '_REG'
	SELECT CAST( REPLACE(MAX(B1_XMAGBUS),'      ','000001')+ 1 AS CHAR ) MAXIMO
	FROM %table:SB1% SB1
	WHERE B1_FILIAL = %xFilial:SB1%
	AND SB1.%NotDel%
	endSQL
	EndIf*/
	/*
	beginSQL alias '_REG'
	SELECT CASE WHEN MAX(B1_XMAGBUS) = ' ' THEN '000001' ELSE RIGHT(REPLICATE('0',6)+RTRIM(LTRIM(CAST( B1_XMAGBUS + 1 AS CHAR ))),6) END AS MAXIMO
	FROM %table:SB1% SB1
	WHERE B1_FILIAL = %xFilial:SB1%
	AND SB1.%NotDel%
	GROUP BY B1_XMAGBUS 
	order by 1 desc
	endSQL


	cRegMax := AllTrim( _REG->MAXIMO )
	cRegMax := Right( Replicate( '0', 6 ) + cRegMax, 6 )
	_REG->( dbCloseArea() )*/

	If( empty(cWhereFil) .And. empty(cWherePrd) .And. empty(cWhereBlq) .And. empty(cWhereRFim) .And. empty(cWhereDFim) )
		Conout("BRUNO ND 1 - Recursiva" + __recursiva)
		beginSQL alias __alias
		//SELECT top 100 ISNULL(B2_FILIAL,SB1.B1_FILIAL) B2_FILIAL, B1_COD, replace(B1_DESC,'+','') B1_DESC, B1_GRUPO, BM_DESC, BM_GRUREL, BM_XMAGCOD, B1_PESBRU,
		SELECT ISNULL(B2_FILIAL,SB1.B1_FILIAL) B2_FILIAL, B1_COD, replace(B1_DESC,'+','') B1_DESC, B1_GRUPO, BM_DESC, BM_GRUREL, BM_XMAGCOD, B1_PESBRU, 
		B1_PRV1, ISNULL(SUM(B2_QATU - B2_QACLASS - B2_RESERVA),0) SALDO, B1_LOCPAD,B1_UM,B1_MSBLQL,B1_TIPO, SB1.R_E_C_N_O_ B1REC,B1_RASTRO    //LINHA ALTERADA RODRIGO
		//B1_PRV1, ISNULL(SUM(B2_QATU - B2_QACLASS - B2_RESERVA),0) SALDO,B1_LOCPAD,B1_UM,B1_MSBLQL,B1_TIPO, SB1.R_E_C_N_O_ B1REC        LINHA ORIGINAL RODRIGO   
		// IIF(SB1.B1_RASTRO = 'L',   ISNULL(SUM(B8_SALDO - B8_EMPENHO),0)   ,ISNULL(SUM(B2_QATU - B2_QACLASS - B2_RESERVA),0))
		//	B1_PRV1, IIF(SB1.B1_RASTRO = 'L',  SUM(B8_SALDO)  ,ISNULL(SUM(B2_QATU - B2_QACLASS - B2_RESERVA),0)) SALDO,B1_LOCPAD,B1_UM,B1_MSBLQL,B1_TIPO, SB1.R_E_C_N_O_ B1REC,B1_RASTRO, B8_EMPENHO    //LINHA ALTERADA RODRIGO
		FROM %table:SB1% SB1 LEFT JOIN %table:SBM% SBM
		ON SBM.BM_FILIAL=%xFilial:SBM%
		AND SBM.%NotDel%	
		AND SBM.BM_GRUPO = B1_GRUPO LEFT JOIN %table:SB2% SB2
		ON SB2.B2_FILIAL=%xFilial:SB2%   
		AND SB2.%NotDel%
		AND SB2.B2_COD = SB1.B1_COD 
	  	AND SB2.B2_LOCAL = %exp:cArmPad%
		WHERE SB1.B1_FILIAL = %xFilial:SB1%
		AND SB1.B1_XWEB = '1'
		AND SB1.%NotDel%
		AND (%exp:cWhereRec1% OR %exp:cWhereRec2%)
		AND SB1.B1_MSBLQL <> '1'

		GROUP BY B1_FILIAL,B2_FILIAL, B1_COD, B1_DESC, B1_GRUPO, BM_DESC, BM_GRUREL, 
		BM_XMAGCOD, B1_PESBRU, B1_PRV1,B1_LOCPAD,B1_UM,B1_MSBLQL,B1_TIPO, SB1.R_E_C_N_O_,B1_RASTRO
		ORDER BY 1, 2
		endSQL
	ElseIf( !empty(cWhereRFim) )
		Conout("BRUNO ND 2 - Recursiva" + __recursiva)
		beginSQL alias __alias
		SELECT top 100 ISNULL(B2_FILIAL,SB1.B1_FILIAL) B2_FILIAL, B1_COD, replace(B1_DESC,'+','') B1_DESC, B1_GRUPO, BM_DESC, BM_GRUREL, BM_XMAGCOD, B1_PESBRU, 
		B1_PRV1, ISNULL(SUM(B2_QATU - B2_QACLASS - B2_RESERVA),0) SALDO,B1_LOCPAD,B1_UM,B1_MSBLQL,B1_TIPO, SB1.R_E_C_N_O_ B1REC
		FROM %table:SB1% SB1 LEFT JOIN %table:SBM% SBM
		ON SBM.BM_FILIAL=%xFilial:SBM%
		AND SBM.%NotDel%	
		AND SBM.BM_GRUPO = B1_GRUPO LEFT JOIN %table:SB2% SB2
		ON SB2.B2_FILIAL=%xFilial:SB2%  
		AND SB2.%NotDel%
		AND SB2.B2_COD = SB1.B1_COD 
		AND SB2.B2_LOCAL = %exp:cArmPad%
		WHERE SB1.B1_FILIAL = %xFilial:SB1%
		AND SB1.B1_XWEB = '1'
		AND SB1.%NotDel%
		AND (%exp:cWhereRec1% OR %exp:cWhereRec2%)
		AND %exp:__range%
		GROUP BY B1_FILIAL,B2_FILIAL, B1_COD, B1_DESC, B1_GRUPO, BM_DESC, BM_GRUREL, 
		BM_XMAGCOD, B1_PESBRU, B1_PRV1,B1_LOCPAD,B1_UM,B1_MSBLQL,B1_TIPO, SB1.R_E_C_N_O_
		ORDER BY 1, 2
		endSQL
	ElseIf( !empty(cWhereDFim) )
		Conout("BRUNO ND 3 - Recursiva" + __recursiva)
		beginSQL alias __alias
		SELECT top 100 ISNULL(B2_FILIAL,SB1.B1_FILIAL) B2_FILIAL, B1_COD, replace(B1_DESC,'+','') B1_DESC, B1_GRUPO, BM_DESC, BM_GRUREL, BM_XMAGCOD, B1_PESBRU, 
		B1_PRV1, ISNULL(SUM(B2_QATU - B2_QACLASS - B2_RESERVA),0) SALDO,B1_LOCPAD,B1_UM,B1_MSBLQL,B1_TIPO, SB1.R_E_C_N_O_ B1REC
		FROM %table:SB1% SB1 LEFT JOIN %table:SBM% SBM
		ON SBM.BM_FILIAL=%xFilial:SBM%
		AND SBM.%NotDel%	
		AND SBM.BM_GRUPO = B1_GRUPO LEFT JOIN %table:SB2% SB2
		ON SB2.B2_FILIAL=%xFilial:SB2%  
		AND SB2.%NotDel%
		AND SB2.B2_COD = SB1.B1_COD 
		AND SB2.B2_LOCAL = %exp:cArmPad%
		WHERE SB1.B1_FILIAL = %xFilial:SB1%
		AND SB1.B1_XWEB = '1'
		AND SB1.%NotDel%
		AND %exp:cWhereRec1%
		AND %exp:__rangeD%
		GROUP BY B1_FILIAL,B2_FILIAL, B1_COD, B1_DESC, B1_GRUPO, BM_DESC, BM_GRUREL, 
		BM_XMAGCOD, B1_PESBRU, B1_PRV1,B1_LOCPAD,B1_UM,B1_MSBLQL,B1_TIPO, SB1.R_E_C_N_O_
		ORDER BY 1, 2
		endSQL
	Else
		Conout("BRUNO ND 4 - Recursiva" + __recursiva)
		beginSQL alias __alias
		SELECT top 100 ISNULL(B2_FILIAL,SB1.B1_FILIAL) B2_FILIAL, B1_COD, replace(B1_DESC,'+','') B1_DESC, B1_GRUPO, BM_DESC, BM_GRUREL, BM_XMAGCOD, B1_PESBRU, 
		B1_PRV1, ISNULL(SUM(B2_QATU - B2_QACLASS - B2_RESERVA),0) SALDO,B1_LOCPAD,B1_UM,B1_MSBLQL,B1_TIPO, SB1.R_E_C_N_O_ B1REC
		FROM %table:SB1% SB1 LEFT JOIN %table:SBM% SBM
		ON SBM.BM_FILIAL=%xFilial:SBM%
		AND SBM.%NotDel%	
		AND SBM.BM_GRUPO = B1_GRUPO LEFT JOIN %table:SB2% SB2
		ON %exp:cWhereFil%  
		AND SB2.%NotDel%
		AND SB2.B2_COD = SB1.B1_COD 
		AND SB2.B2_LOCAL = %exp:cArmPad%
		WHERE SB1.B1_FILIAL = %xFilial:SB1%
		AND SB1.B1_XWEB = '1'
		AND SB1.%NotDel%
		AND %exp:cWherePrd%
		AND %exp:cWhereBlq%
		AND %exp:cWhereRec1%
		GROUP BY B1_FILIAL,B2_FILIAL, B1_COD, B1_DESC, B1_GRUPO, BM_DESC, BM_GRUREL, 
		BM_XMAGCOD, B1_PESBRU, B1_PRV1,B1_LOCPAD,B1_UM,B1_MSBLQL,B1_TIPO, SB1.R_E_C_N_O_
		ORDER BY 1, 2
		endSQL
	EndIf

	If( (__alias)->( eof() ) )
		__wsSoapFault := "[WS-ERR-1000012] A consulta  retornou nenhum resultado. Refaca os filtros e tente novamente"
	EndIf

	aqry := GetLastQuery() 	   
	While (__alias)->( !eof() )      
		__nY++
		//---------------------------------------------------------------------------------------------------      
		aAdd( __product,{	(__alias)->B2_FILIAL,;
		alltrim((__alias)->B1_COD),;
		alltrim((__alias)->B1_DESC),;
		(__alias)->B1_GRUPO,;
		alltrim((__alias)->BM_DESC),;
		alltrim((__alias)->BM_GRUREL),;
		alltrim((__alias)->BM_XMAGCOD),;
		(__alias)->B1_PESBRU,;
		FITTabPre(__tabelaprc, __alias),;	//B2C IIF(	(__alias)->B1_RASTRO = 'L',IIF (QR1->B8_SALDO > 0, QR1->B8_SALDO - QR1->B8_EMPENHO, QR1->B8_SALDO) + IIF (QR2->B8_SALDO > 0,QR2->B8_SALDO - QR2->B8_EMPENHO, QR2->B8_SALDO) + IIF (QR3->B8_SALDO > 0, QR3->B8_SALDO - QR3->B8_EMPENHO, QR3->B8_SALDO), 	(__alias)->SALDO),;//(__alias)->SALDO - QR1->B8_EMPENHO,;//iif((__alias)->B1_RASTRO = 'L',	(__alias)->SALDO - (__alias)->B8_EMPENHO,	(__alias)->SALDO) ,;//iif((__alias)->B1_RASTRO = 'L',   B8_SALDO - B8_EMPENHO   ,B2_QATU - B2_QACLASS - B2_RESERVA),;  //(__alias)->SALDO,;
		(__alias)->SALDO,; //caio                            //10
		"17",; //B1_LOCPAD .'.
		(__alias)->B1_UM,;
		(__alias)->B1_TIPO,;
		(__alias)->B1_MSBLQL,;
		"000000",; //xMAGBUS cRegMax
		FITTabPre(__tabelaprc, __alias),;
		"",;//QR1->B8_DTVALID,;  //17
		"",;//QR1->B8_LOTECTL,;
		"",;//QR2->B8_DTVALID,;
		"",;//QR2->B8_LOTECTL,; //		IIF(	(__alias)->B1_RASTRO = 'L', IIF (QR2->B8_SALDO > 0, QR2->B8_SALDO - QR2->B8_EMPENHO,QR2->B8_SALDO), 	(__alias)->SALDO),;
		(__alias)->SALDO,;
		FITTabPre(__tblogista, __alias),;
		"",;//QR1->B8_DTVALID,; //23
		"",;//QR1->B8_LOTECTL,; //24
		0,;//IIF (QR1->B8_SALDO > 0, QR1->B8_SALDO - QR1->B8_EMPENHO, QR1->B8_SALDO),;   //25
		"",;//QR2->B8_DTVALID,; //26
		"",;//QR2->B8_LOTECTL,; //27
		0,;//IIF (QR2->B8_SALDO > 0,QR2->B8_SALDO - QR2->B8_EMPENHO, QR2->B8_SALDO) ,;   //28
		"",;//QR3->B8_DTVALID,; //29
		"",;//QR3->B8_LOTECTL,; //30
		0,;//IIF (QR3->B8_SALDO > 0, QR3->B8_SALDO - QR3->B8_EMPENHO, QR3->B8_SALDO),;   //31 IIF (QR3->B8_SALDO > 0, QR3->B8_SALDO - QR3->B8_EMPENHO, QR3->B8_SALDO),;   //31
		alltrim((__alias)->B1_RASTRO),;//32
		 })
		//nValPrc ,;  //
		/*dbSelectArea('SB1')
		SB1->( dbGoTo( (__alias)->B1REC ) )
		RecLock( 'SB1', .F. )
		SB1->B1_XMAGBUS	:= cRegMax
		MsUnlock()*/
	    (__alias)->( dbSkip() )
	End
	(__alias)->( dbCloseArea() )

	RestArea( __area )
Return( __product )

////////////////////////////////////////////////////////////////////////////
//|Autor	|Thiago de Jesus      			| 12-02-2016 | Crail
//|Funcao   |TiraGraf                     
//|Uso		|Rotina para tratativas de acentuaÃƒÂ§ÃƒÂ£o
////////////////////////////////////////////////////////////////////////////
Static Function TiraGraf( _sOrig ) 
	Local _sRet := _sOrig
	_sRet := StrTran(_sRet, "ÃƒÂ¡", "a")
	_sRet := StrTran(_sRet, "ÃƒÂ©", "e")
	_sRet := StrTran(_sRet, "ÃƒÂ­", "i")
	_sRet := StrTran(_sRet, "ÃƒÂ³", "o")
	_sRet := StrTran(_sRet, "ÃƒÂº", "u")
	_sRet := StrTran(_sRet, "ÃƒÂ", "A")
	_sRet := StrTran(_sRet, "Ãƒâ€°", "E")
	_sRet := StrTran(_sRet, "ÃƒÂ", "I")
	_sRet := StrTran(_sRet, "Ãƒâ€œ", "O")
	_sRet := StrTran(_sRet, "ÃƒÅ¡", "U")
	_sRet := StrTran(_sRet, "ÃƒÂ£", "a")
	_sRet := StrTran(_sRet, "ÃƒÂµ", "o")
	_sRet := StrTran(_sRet, "ÃƒÆ’", "A")
	_sRet := StrTran(_sRet, "Ãƒâ€¢", "O")
	_sRet := StrTran(_sRet, "ÃƒÂ¢", "a")
	_sRet := StrTran(_sRet, "ÃƒÂª", "e")
	_sRet := StrTran(_sRet, "ÃƒÂ®", "i")
	_sRet := StrTran(_sRet, "ÃƒÂ´", "o")
	_sRet := StrTran(_sRet, "ÃƒÂ»", "u")
	_sRet := StrTran(_sRet, "Ãƒâ€š", "A")
	_sRet := StrTran(_sRet, "ÃƒÅ ", "E")
	_sRet := StrTran(_sRet, "ÃƒÅ½", "I")
	_sRet := StrTran(_sRet, "Ãƒâ€", "O")
	_sRet := StrTran(_sRet, "Ãƒâ€º", "U")
	_sRet := StrTran(_sRet, "ÃƒÂ§", "c")
	_sRet := StrTran(_sRet, "Ãƒâ€¡", "C")
	_sRet := StrTran(_sRet, "ÃƒÂ ", "a")
	_sRet := StrTran(_sRet, "Ãƒâ‚¬", "A")
	_sRet := StrTran(_sRet, "Ã‚Âº", ".")
	_sRet := StrTran(_sRet, "Ã‚Âª", ".")
	_sRet := StrTran(_sRet, "+", " ")
	_sRet := StrTran(_sRet, "$", " ")
	_sRet := StrTran(_sRet, "!", " ")
	_sRet := StrTran(_sRet, "#", " ")
	_sRet := StrTran(_sRet, "%", " ")
	_sRet := StrTran(_sRet, "%", " ")
	_sRet := StrTran(_sRet, "Ã‚Â¨", " ")
	_sRet := StrTran(_sRet, "&", " ")
	_sRet := StrTran(_sRet, "*", " ")
	_sRet := StrTran(_sRet, "(", " ")
	_sRet := StrTran(_sRet, ")", " ")
	_sRet := StrTran(_sRet, "_", " ")
	_sRet := StrTran(_sRet, "-", " ")
	_sRet := StrTran(_sRet, ".", " ")
	_sRet := StrTran(_sRet, "/", " ")
	_sRet := StrTran(_sRet, "\", " ")
	_sRet := StrTran(_sRet, "?", " ")
	_sRet := StrTran(_sRet, "[", " ")
	_sRet := StrTran(_sRet, "]", " ")
	_sRet := StrTran(_sRet, "{", " ")
	_sRet := StrTran(_sRet, "}", " ")
	_sRet := StrTran(_sRet, ">", " ")
	_sRet := StrTran(_sRet, "<", " ")
	_sRet := StrTran(_sRet, "|", " ")
	_sRet := StrTran(_sRet, ":", " ")
	_sRet := StrTran(_sRet, Chr(157), " ")
	_sRet := StrTran(_sRet, Chr(9), " ")
	_sRet := StrTran(_sRet, Chr(13)+Chr(10), " ")
	_sRet := StrTran(_sRet, Chr(13), " ")
	_sRet := StrTran(_sRet, Chr(10), " ")   
	_sRet := StrTran(_sRet, ",", " ")
	_sRet := StrTran(_sRet, ";", " ")
	_sRet := NoAcento(_sRet)
Return( _sRet )


//_____________________________________________________________________________
/*/{Protheus.doc} ConveSearch
Faz a busca e retorna os dados da transportadora

@author Icaro Queiroz
@since 04 de Fevereiro de 2017
@version P11
@Owner FIT Gestao for Crail
/*/
//_____________________________________________________________________________
Static Function ConveSearch( __aArrConve,__wsSoapFault )
	local __query   	:= ""
	local __alias   	:= GetNextAlias()
	local __aqry    	:= {}
	local __area    	:= GetArea()
	local __nY      	:= 0
	local __adata   	:= {}
	local __Conveyor	:= {}
	local __cpf_cnpj	:= ""
	local __like_nome	:= ""
	local __cWhereNome  := ""	
	local __lrangeN     := .F.
	local __rangeN     	:= ""
	local __lseek
	local aqry			:= {}

	default __wsSoapFault:= ""
	default __aArrConve := {}

	If( len(__aArrConve:__ADATA) == 0 )
		__wsSoapFault := "Os parametros de pesquisa nÃƒÂ£o foram informados corretamente, efetue o envio dos dados correspondentes a transportadora."
		Return( __Conveyor )
	Else
		If( Valtype(__aArrConve:__ADATA)=="A" )
			If( len(__aArrConve:__ADATA) > 1 )		
				aDel (__aArrConve:__ADATA, len(__aArrConve:__ADATA))
				aSize(__aArrConve:__ADATA, len(__aArrConve:__ADATA)-1)
			EndIf

			For __nY := 1 to len(__aArrConve:__ADATA)
				__like_nome:= __aArrConve:__ADATA[__nY]:__BUSCA_NOME
				__cpf_cnpj := __aArrConve:__ADATA[__nY]:__CPF_CNPJ
				exit
			Next __nY        

			If( Valtype(__cpf_cnpj) == Nil .Or. empty(__cpf_cnpj) )
				__cpf_cnpj := Replace(Replace(Replace("08.658.317/0001-21",".",""),"/",""),"-","")
			EndIf

			If( len(Replace(Replace(Replace(__cpf_cnpj,".",""),"/",""),"-","")) == 14 )
				__type := "J"								
			Else	         
				__type := "F"
			EndIf
			__lret := cgc( Replace(Replace(Replace(__cpf_cnpj,".",""),"/",""),"-","") )

			If( __lret )
				SA4->( dbSetOrder(3) )
				__lseek := SA4->( dbSeek( xFilial("SA4")+__cpf_cnpj ) )	                 


				//Filtra por Nome
				If( !empty(alltrim(__like_nome)) )
					__cWhereNome := "'%"+alltrim(__like_nome)+"%'"
					__lrangeN := .T.
				EndIf
				If( !empty(__cWhereNome) )
					__rangeN := " SA4.A4_NOME LIKE "+__cWhereNome+" "
					__rangeN := "%" + __rangeN + "%"
				EndIf

				If( !empty(__rangeN) )
					beginSQL alias __alias
					SELECT SA4.* FROM %table:SA4% SA4
					WHERE SA4.A4_FILIAL = %xFilial:SA4%
					AND SA4.%NotDel%	
					AND %exp:__rangeN%					
					ORDER BY 1, 3
					endSQL

					aqry := GetLastQuery() 	
					While (__alias)->( !eof() ) 						
						aAdd( __Conveyor,{ (__alias)->A4_FILIAL,alltrim((__alias)->A4_COD),alltrim((__alias)->A4_NOME),alltrim((__alias)->A4_NREDUZ),;
						alltrim((__alias)->A4_CONTATO), alltrim((__alias)->A4_END),	alltrim((__alias)->A4_BAIRRO),(__alias)->A4_COD_MUN,;
						alltrim((__alias)->A4_MUN),	(__alias)->A4_EST,(__alias)->A4_DDD, (__alias)->A4_TEL,(__alias)->A4_CGC,(__alias)->A4_INSEST,;
						(__alias)->A4_CEP,	(__alias)->A4_CODPAIS })
						(__alias)->( dbSkip() )
					End
					(__alias)->( dbCloseArea() )
				Else
					SA4->( dbSetOrder(3) )
					SA4->( dbSeek( xFilial("SA4")+__cpf_cnpj ) )
					While SA4->( !eof() ) .And. SA4->A4_FILIAL+alltrim(SA4->A4_CGC) == xFilial("SA4")+alltrim(__cpf_cnpj)
						aAdd( __Conveyor,{ SA4->A4_FILIAL,alltrim(SA4->A4_COD),alltrim(SA4->A4_NOME),alltrim(SA4->A4_NREDUZ),;
						alltrim(SA4->A4_CONTATO), alltrim(SA4->A4_END),	alltrim(SA4->A4_BAIRRO),SA4->A4_COD_MUN,;
						alltrim(SA4->A4_MUN),	SA4->A4_EST,SA4->A4_DDD, SA4->A4_TEL,SA4->A4_CGC,SA4->A4_INSEST,;
						SA4->A4_CEP,	SA4->A4_CODPAIS })
						SA4->( dbSkip() )
					End
				EndIf
			EndIf
		EndIf		
	EndIf

	RestArea( __area )		
Return( __Conveyor )


//_____________________________________________________________________________
/*/{Protheus.doc} FITTabPre
Faz a busca conforme tabela de preco especificada para a operacao

@author Icaro Queiroz
@since 21 de Fevereiro de 2016
@owner FIT Gestao for Supadist
@use http://152.249.239.109:8049/ws/FITWSERVICE.apw?WSDL
/*/
//_____________________________________________________________________________
Static Function FITTabPre( cTabPrc, __alias )
	Local aArea		:= GetArea()
	Local nPreco	:= 0
	Local cSQL		:= ""

	//Default cTabPrc:= LTrim( GetNewPar( "MV_MAGB2C", "626" ) )
	Default __alias	:= ""

	cSQL := "SELECT TOP 1 DA1_PRCVEN, DA0_CODTAB, DA1_DATVIG " + CRLF
	cSQL += "  FROM " + RetSqlName( "DA1" ) + " DA1 " + CRLF
	cSQL += "  JOIN " + RetSqlName( "DA0" ) + " DA0  ON DA0.DA0_FILIAL = '" + xFilial( "DA0" ) + "' " + CRLF
	cSQL += "				AND  DA0.DA0_FILIAL = DA1.DA1_FILIAL " + CRLF
	cSQL += "				AND DA0.DA0_CODTAB = DA1.DA1_CODTAB " + CRLF
	cSQL += "				AND DA0.D_E_L_E_T_ = ' ' " + CRLF

	If !Empty( cTabPrc )
		cSQL += "				AND DA0.DA0_CODTAB = '" + cTabPrc + "' " + CRLF
	EndIf

	cSQL += "WHERE DA1.DA1_FILIAL = '" + xFilial( "DA1" ) + "' " + CRLF
	cSQL += "  AND DA1.D_E_L_E_T_ = ' ' " + CRLF
	//cSQL += "  AND (DA1_GRUPO = '" + (__alias)->B1_GRUPO + "' OR DA1.DA1_CODPRO = '" + (__alias)->B1_COD + "')" + CRLF   // alterado por Salomao 15112017 devido erro de preco
	cSQL += " AND DA1.DA1_CODPRO = '" + (__alias)->B1_COD + "'" + CRLF
	cSQL += "ORDER BY DA1_DATVIG DESC"

	//MemoWrit("c:\temp\FITTabPre.TXT",cSQL)

	TCQUERY cSQL NEW ALIAS "TMP"

	If TMP->( !Eof() ) .And. ValType( TMP->DA1_PRCVEN ) == "N" .And. TMP->DA1_PRCVEN > 0
		nPreco := TMP->DA1_PRCVEN
	Else
		nPreco := (__alias)->B1_PRV1
	EndIf

	TMP->( dBCloseArea() )
	dbSelectArea( "SB1" )

	RestArea( aArea )

Return( nPreco )     




Static Function TpCond(cCond, nValor)
local cTipo
local aPgt := condicao(nValor,cCond,, DDATABASE)  

do case 
	case len(aPgt) == 1
		cTipo := "3"
	otherwise
		cTipo := "21"
endcase	
return cTipo   

Static Function ValTot(cPedido)    
local nTot := 0
DbSelectArea("SC9")
DbSetOrder(1)
if Dbseek(xFilial("SC9")+cPedido)
	do while !EOF() .And. ALLTRIM(SC9->C9_PEDIDO) == ALLTRIM(cPedido) .And. SC9->C9_FILIAL == cFilAnt//itens     
		if alltrim(SC9->C9_BLEST) <> ""
			SC9->(DbSkip())
			loop
		endif
		if alltrim(SC9->C9_LOTECTL) == ""
			SC9->(DbSkip())
			loop
		endif
		if alltrim(SC9->C9_NFISCAL) <> ""
			SC9->(DbSkip())
			loop
		endif
		nTot += (SC9->C9_QTDLIB*SC9->C9_PRCVEN)
	SC9->(DbSkip())
	enddo
endif 
rETURN nTot

STATIC FUNCTION LiberOK(cPedido)
Local lRet 				:= .T.
Local cQuery 		:= ""   
Local _cAlias 		:= GetNextAlias()
cQuery := "SELECT * FROM "+RETSQLNAME( "SC9" )+" WHERE C9_NFISCAL = '' AND C9_BLEST = '02' AND D_E_L_E_T_ = '' AND C9_PEDIDO = '"+cPedido+"'"      
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), _cAlias, .F., .T. )
if  (_cAlias)->(!EOF())
	lRet := .F.
endif
If Select(_cAlias) >0
	dbSelectArea(_cAlias)
    dbCloseArea()    
EndIf
Return lRet               


Static Function RunCont(cPedido)

Local _lInicio	:= .T.
Local _lFim		:= .F.
local cArqTxt1 	:=  MV_PAR04
local cLin		:= ""
local n			:= 0 
local aPgto 	:= {}     
Local cCaminho	:= SuperGetMv("SB_CENDLOG",.t., "C:\Users\Admin\Desktop\Saida\")   
local lLote		:= .T.  
local nItem		:= 0 
local nAt		:= 0

cCaminho := "\Logisticae\Picking\"
cCaminho := iif(right(cCaminho,1) == "\",cCaminho,cCaminho+"\")  

If EmpTy(ALLTRIM(cCaminho))  
	conout("Arquivo de integração Logistica nao gerado! Caminho de Destino nao identificado")
	Return
EndIf

DbSelectArea("SC5")
DbSetOrder(1)
if Dbseek(xFilial("SC5")+cPedido)
	_lInicio := .T.
	_lFim    := .F.
	nQtdNf := 0   	
	
	if Empty(alltrim(SC5->C5_XMAGCOD))
		cArqTxt := cCaminho  
		cArqTxt := ALLTRIM(cArqTxt) +"PL"+ALLTRIM(SC5->C5_NUM)+".txt"   
	else
		cCaminho := "\Logisticae\Picking\"
		cCaminho := iif(right(cCaminho,1) == "\",cCaminho,cCaminho+"\")  
		cArqTxt := cCaminho 
		cArqTxt := ALLTRIM(cArqTxt) +"PL"+ALLTRIM(SC5->C5_NUM)+".txt"   	
	endif
	SC9->(dbsetOrder(1))  
	nCont  := 0
	nCont1 :=0
	if SC9->(dbseek(SC5->C5_FILIAL+SC5->C5_NUM))  
		do while !EOF() .And. ALLTRIM(SC9->C9_PEDIDO) == ALLTRIM(cPedido) .And. SC9->C9_FILIAL == cFilAnt//itens 
			nCont++
			if ALLTRIM(SC9->C9_BLEST) ==  "" 
				if alltrim(SC9->C9_LOTECTL)== '' .And. Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_RASTRO") = 'L' 
					lLote := .F.
		   			AutoGrLog("Pedido não gerado: "+SC9->C9_PEDIDO+". Motivo: Sem Lote em algum item") 				
					exit				
			   	endif 	
				if alltrim(SC9->C9_BLCRED) <> ''
			   		lLote := .F.                
		   			AutoGrLog("Pedido não gerado: "+SC9->C9_PEDIDO +". Motivo: Pedido com Bloqueio de Credito") 				
					exit
				endif 
			else
				nCont1++				
		   	endif
			SC9->(DbSkip())	
		ENDDO  
		if nCont == nCont1 
			AutoGrLog("Pedido não gerado: "+SC9->C9_PEDIDO +". Motivo: Pedido inteiro bloqueado por estoque")     
			lLote := .F.		
		endif
	ENDIF
	//lLote := .T.	
	if !lLote
		Mostraerro()
		return lLote
	endif
	nHdl 	:= fCreate(cArqTxt)
	If nHdl == -1
	    conout("O arquivo de nome nao pode ser executado! Verifique os parametros.","Atencao!")
	    Return
	Endif  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabeçalho fornecido pelo layout L01 2Alianca                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLin := "02" //TIPO REGISTRO
	
	If xFilial("SC5") == "01"
		cLin += "SURYARJ"+space(8)//CODIGO DEPOSITANTE
	Else
		cLin += "SURYASP"+space(8)//CODIGO DEPOSITANTE
    EndIf
   
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))+;
			space(15-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))))//CNPJ Cliente
   
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))+;
			space(15-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))))//CNPJ Cliente
	
	clin += substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_NOME")),1,40)+;
			space(40-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_NOME")),1,40)))) //nome cliente 
	if ALLTRIM(SC5->C5_XMAGCOD) = ''		
		nAt := At(",",Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END"))
		IIF(nAt == 0,nAt:=40,nAt:=nAt)		
		clin += Substr(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),1,nAt-1)+;
				space(40-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),1,nAt-1)))),1,40)  //end cliente     
		
		clin += Alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),nAt+1,10))+;
				space(10-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),nAt+1,10))))  //numero cliente   
	else
		cLin += Substr(Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END"))+" "+;
				Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_COMPLEM"),1,50)
	endif
	clin += alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_BAIRRO")),1,25))+;
			space(25-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_BAIRRO")),1,25))))     //Bairro
	
	clin += alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_MUN")),1,25))+;
			space(25-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_MUN")),1,25))))     //   Cidade
			
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_EST")) //estado
	
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CEP") ) +;
			space(9-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CEP")))) //CEP 
			
   	cLin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_COMPLEM") ) +;
			space(50-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_COMPLEM")))) // complemento
	
	cLin += space(15)//Inscrição estadual do cliente
	
	if ALLTRIM(SC5->C5_XMAGCOD) = ''
		cLin += 'PED' + space(2) // tipo documento       
	else
		cLin += 'PEX' + space(2) // tipo documento
	endif
	
	cLin += '1    '//serie
	
	cLin += ALLTRIM(SC5->C5_NUM)+space(4) //num doc    
	
	If xFilial("SC5") == "01"
		cLin += "0000000001" //codigo estabelecimento
	Else
		cLin += "0000000004" //codigo estabelecimento
    EndIf		  
	
	clin += Day2Str(SC5->C5_EMISSAO)+Month2Str(SC5->C5_EMISSAO)+Year2Str(SC5->C5_EMISSAO)  //emissao do documento
	
	clin += ALLTRIM(POSICIONE("SC6",1,SC5->C5_FILIAL+SC5->C5_NUM,"C6_CF"))+;
			SPACE(6-LEN(ALLTRIM(POSICIONE("SC6",1,SC5->C5_FILIAL+SC5->C5_NUM,"C6_CF")))) //natureza 6caractter
	                                                                                                            
	cLin += strzero(val(ALLTRIM(STRTRAN(Transform(ValTot(SC5->C5_NUM),"@E 9999999999.9999"),".",""))),20)// TOTAL DOS DOCUMENTOS
	
	cLin += replicate('0',20)// TOTAL DOS ITENS DO DOCUMENTO    
	
	cLin += replicate('0',20)// val icms
	
	cLin += replicate('0',20)// val st
	
	cLin += replicate('0',20)// val ip
	
	cLin += replicate('0',20)// base calc ICM
	
	cLin += replicate('0',20)// base calc st
	
	cLin += replicate('0',20)// base calc ipi
	
	cLin += replicate('0',20)// valor desconto
	
	cLin += replicate('0',20)// val acrescimo
	
	cLin += replicate('0',10)//  tipo frete
	
	cLin += alltrim(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP, "A4_CGC"))+;
			space(15-len(alltrim(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP, "A4_CGC"))))  //CNPJ Transp
			
	clin += strzero(val(ALLTRIM(STRTRAN(Transform(SC5->C5_PESOL,"@E 9999999999.9999"),".",""))),10)      // peso liquido        
	                                                                                                                                          
	clin += strzero(val(ALLTRIM(STRTRAN(Transform(SC5->C5_PBRUTO,"@E 9999999999.9999"),".",""))),10)      // peso liquido        C5_ESPECI1
	
	clin += strzero(val(ALLTRIM(Transform(SC5->C5_VOLUME1,"@E 9999999999"))),10)
			// 
	
	cLin += replicate("0",5)       //status do documento
	
	cLin += space(13) // document status hour
	
	cLin += Space(25) //replicador de documentos
	
	cLin += Space(25) //Informacao Adicional 1

	cLin += Space(25) //Informacao Adicional 2

	cLin += Space(25) //Informacao Adicional 3
	
	cLin += Space(100) //Observação do Documento
	
	cLin += replicate("0",5) //numero de linhas do documento
	
	cLin += replicate("0",8) // total de unidades do documento
	
	clin += CHR(13)+CHR(10)
	If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
		If !conout("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Return()
		EndIf
	EndIf

	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ITENS L02 2Alianca                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
	
	DbSelectArea("SC9")
	DbSetOrder(1)
	if Dbseek(xFilial("SC9")+cPedido)
		do while !EOF() .And. ALLTRIM(SC9->C9_PEDIDO) == ALLTRIM(cPedido) .And. SC9->C9_FILIAL == cFilAnt//itens     
			if alltrim(SC9->C9_BLEST) <> ""
				SC9->(DbSkip())
				loop
			endif
			nItem++
			n++ 
			cLin := "09"
			clin += strzero(nItem,3)    //item do documento
			clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))+;
				space(15-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))))//CNPJ Cliente
			if ALLTRIM(SC5->C5_XMAGCOD) = ''
				cLin += 'PED' + space(2) // tipo documento       
			else
				cLin += 'PEX' + space(2) // tipo documento
			endif
 			cLin += '11111'//serie
			cLin += ALLTRIM(SC5->C5_NUM)+space(4) //num doc    
   
			If xFilial("SC9") == "01"
				cLin += "SURYARJ"+space(8) //CODIGO DEPOSITANTE 
				cLin += "0000000001"       //codigo estabelecimento
			Else
				cLin += "SURYASP"+space(8) //CODIGO DEPOSITANTE 
				cLin += "0000000004"       //codigo estabelecimento
			EndIf
			
			cLin += ALLTRIM(SC9->C9_PRODUTO)+;
				space(15-len(alltrim(SC9->C9_PRODUTO)))//PRODUTO	
			cLin += strzero(val(ALLTRIM(STRTRAN(Transform(SC9->C9_QTDLIB,"@E 9999999999.9999"),".",""))),20) //qtd	
			clin += alltrim(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_UM"))+SPACE(3) // UM     
			cLin += replicate("0",20)  //fator segunda unidade de medida  
			cLin += '3'+space(9) //tipo logistico 
		   //	if Empty(alltrim(SC5->C5_ECVINCU))
			cLin += ALLTRIM(SC9->C9_LOTECTL)+;
						space(15-len(alltrim(SC9->C9_LOTECTL))) //dado logistico
		  /*	else 
				if Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_RASTRO") = 'L' 
					cLin += ALLTRIM(SC9->C9_LOTECTL)+"E"
				else
					cLin += ALLTRIM(SC9->C9_LOTECTL)
				endif
			endif   */		
			    
			cLin += strzero(val(ALLTRIM(STRTRAN(Transform(SC9->C9_PRCVEN,"@E 9999999999.9999"),",",""))),20) // valor item
			cLin += replicate("0",20) // aliq icm  
			cLin += replicate("0",20) // aliq ipi
			cLin += replicate("0",20) // aliq ST
			cLin += replicate("0",20) // fator base icm
			cLin += replicate("0",20) // aliq ipi reduz
			cLin += replicate("0",20) // fator base ipi
			cLin += replicate("0",20) // qtd atendida do item após a separação
			cLin += space(25)   // info 1
			clin += alltrim(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_CODBAR")) +;
					 space(25-len(alltrim(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_CODBAR"))))      // info 2
			cLin += space(25)   // info 3
			
			cLin += space(5)// classe do Produto
			cLin += CHR(13)+CHR(10)           
				If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
				If !conout("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Return()
				EndIf
			EndIf
		SC9->(DbSkip())
		enddo
	endif
	           
	//CADASTRO EMPRESA
	cLin := "16"
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))+;
			space(15-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))))//CNPJ Cliente     
			
	clin += substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_NOME")),1,40)+;
			space(40-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_NOME")),1,40)))) //nome cliente 
			
	nAt := At(",",Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END"))		
	clin += Substr(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),1,nAt-1)+;
			space(40-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),1,nAt-1)))),1,40)  //end cliente
			
	clin += Alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),nAt+1,10))+;
		space(10-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_END")),nAt+1,10))))  //numero cliente  
		
	clin += alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_BAIRRO")),1,25))+;
			space(25-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_BAIRRO")),1,25))))     //Bairro
			
	clin += alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_MUN")),1,25))+;
			space(25-len(alltrim(substr(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_MUN")),1,25))))     //   Cidade
			
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_EST")) //estado
	
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CEP") ) +;
			space(9-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CEP")))) //CEP 
	cLin += space(50) // complemento
	
	cLin += space(15)//Inscrição estadual do cliente
	
	cLin += space(10) // tipo empresa   
	
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_PESSOA")) //fisica ou juridica  
	
	clin += alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))+;
			space(15-len(alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CGC"))))//CNPJ Cliente 
				  
	cLin += space(25)   // info 1
	cLin += space(25)   // info 2
	cLin += space(25)   // info 3  
	cLin += CHR(13)+CHR(10) 			
	If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
		If !conout("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Return()
		EndIf
	EndIf		
	fClose(nHdl)  
	/*SC5->(RecLock("SC5",.F.))
		SC5->C5_XEMILOG := date()
		SC5->C5_XSTATUS :=  "1"
		SC5->(MsUnlock())
	SC5->(MsUnlock())*/
endif	
Return lLote

Static Function FT2All(cServer, nPorta, cUser, cPass,cPedido)      //chamado na linha 1109
Local cLocal := "\logisticae\Picking\"         
Local cFile 	:= ""  
Local cDirErroY,cDirErroM,cDirErroD,cDirOkY,cDirOkM,cDirOkD := ""
Local lRet := .F.
Default cServer 	:= "187.0.200.180"
Default nPorta 	:= 21//nPorta //21
Default cUser		:= "surya@2aliancas.com.br"
Default cPass	:= "2aliancas!!"

//Default cPedido	:= "309982"                
//aDir := directory(cLocal+"*.txt")
cPed		:= cPedido
cPedido		:= "pl"+ cPedido+".txt"
cFile 		:= cLocal + cPedido   
cDirErro 	:= cLocal+"Erros\"
cDirErroY 	:= cLocal+"Erros\"+ALLTRIM(str(Year(DATE())))
cDirErroM 	:= cLocal+"Erros\"+ALLTRIM(str(Year(DATE())))+"\"+StrZero(Month(DATE()),2) 
cDirErroD 	:= cLocal+"Erros\"+ALLTRIM(str(Year(DATE())))+"\"+StrZero(Month(DATE()),2)+"\"+strzero(day(DATE()),2) 
cDirOk		:= cLocal+"OK\"
cDirOkY  	:= cLocal+"OK\"+ALLTRIM(str(Year(DATE())))
cDirOkM  	:= cLocal+"OK\"+ALLTRIM(str(Year(DATE())))+"\"+StrZero(Month(DATE()),2) 
cDirOkD  	:= cLocal+"OK\"+ALLTRIM(str(Year(DATE())))+"\"+StrZero(Month(DATE()),2)+"\"+strzero(day(DATE()),2)

Private _cAmbAtual := Upper( AllTrim( GetEnvServer() ) )
FTPDisconnect()
If     FTPConnect( cServer, 21, cUser, cPass )
     Conout('FTP conectado!')
     Conout('Diretorio FTP',FTPGetCurDir())
     Conout('FTPDirChange',FTPDirChange('003/'))
     FTPGetCurDir()
     FTPDirChange('003/')
     
	If FTPUpLoad( cFile, cPedido)
		Conout('UpLoad Ok! '+ cPedido)  
		lRet := .T.    
		cDirOK := "\Dossie\"+cPed+"\"
		MakeDir(cDirOk)			
	    __CopyFile(cFile,cDirOK+cPedido)
		conout("PEDIDO: "+cFile+" JA SE ENCONTRA NA BASE...")
		If SC5->(DBSETORDER(1),DBSEEK(XFILIAL("SC5")+Substr(cPedido,3,6)))
		//if found()
			SC5->(RecLock("SC5",.F.))
			SC5->C5_XEMILOG := date()
			SC5->C5_XSTATUS :=  "1"
			SC5->(MsUnlock())
		EndIf
		//Ferase(cFile)
	Else
	    Conout('Falha UpLoad!'+cPedido)    
	    MakeDir(cDirErro)
	    MakeDir(cDirErroY)
	    MakeDir(cDirErroM)
	    MakeDir(cDirErroD)        
	     __CopyFile(cFile,cDirErroD+"\"+cPedido)
		conout("PEDIDO: "+cFile+" JA SE ENCONTRA NA BASE...")
		//Ferase(cFile)
	EndIf
     FTPDisconnect()
Else
     Conout('Falha Conexao!')
EndIf
Return lRet            

Static Function envEcom1(cPedido, cLogitica,cAssunto, cDest, cCopy)

			  oWorkFLW			 	 := TWEnviaEmail():New()	
			  oWorkFLW:cConta        := "suryabrasil@shared.mandic.net.br"					    
			  oWorkFLW:cSenha        := "75XQF9qg"						
			  oWorkFLW:cDestinatario := cDest
			  oWorkFLW:cCopia		 :=  cCopy
			  oWorkFLW:cServerSMTP   := "sharedrelay-cluster.mandic.net.br"						
			  oWorkFLW:cAssunto      := cAssunto
			  oWorkFLW:cDiretorio	 := "\workflow\html\AVECOM01.HTM"
			  
			  oWorkFLW:aDadosHTML   := { { '##cPedido##', cPedido} ,;
			  							 			   	  { '##cLogistica##'	   , cLogitica	} }  
			  oWorkFLW:EnviaEmail()
			  Conout('E-mail de erro e-commercel enviado com sucesso')  

Return      