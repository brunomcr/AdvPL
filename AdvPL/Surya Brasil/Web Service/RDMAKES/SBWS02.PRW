#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TRYEXCEPTION.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "aarray.ch"
#INCLUDE "shash.ch"    

//----------------------------------------------------------------------------//
// Informa o saldo.
//----------------------------------------------------------------------------//
WsStruct WSPed
	WsData __cPedido		AS String
	WsData __cCodSRO		AS String
	WsData __cCHVNFE		AS String	
EndWSStruct


WsService Postagem Description "Fornece o cod rastreio."

	WsData cPedido    		As String	
	WsData __login			AS String
	WsData __pws  			AS String	 
	
	WsData oException		AS String
	WsData cMsgSoapFault	AS String
	WsData lWsMethodRet		AS Boolean
	
	WsData aPed	 	 	AS array OF WSPed

	WsMethod BuscaSRO      Description "Busca o cod Rastreio do Pedido Magento."

EndWsService

WsMethod BuscaSRO WsReceive cPedido, __login,__pws WsSend aPed WsService Postagem
	local nX				:= 0
	local __wsSoapFault		:= ""
	Local nX3Prod			:= TAMSX3("C5_XMAGCOD")[1]
	local __Autetication	:= {}
	local _cPed				:= Self:cPedido+Space(nX3Prod-Len(Self:cPedido)) 
	local _cChVNF			:= ""
   	TRYEXCEPTION
   	__Autetication := aClone( __wblogin( Self:__login,Self:__pws ) )
	If( len(__Autetication) > 0 )
		If( !__Autetication[3] )
			SetSoapFault("[WS_SOAPFAULT]-ERR-5000012-WSMethod [WSCustomers]", AllTrim(__Autetication[1]))
			Return( .F. )
		EndIf
	EndIf
	dbSelectArea("SC5")
	SC5->(dbOrderNickName("XMAGCOD"))
	if dbSeek(xFilial("SC5") + _cPed)
		_cChVNF := Posicione("SF2",1,SC5->C5_FILIAL+SC5->C5_NOTA+"003","F2_CHVNFE")
		AAdd( Self:aPed, WSClassNew("WSPed") )
		Self:aPed[1]:__cPedido 		:= SC5->C5_XMAGCOD
		Self:aPed[1]:__cCodSRO 		:= SC5->C5_XRASTRE
		Self:aPed[1]:__cCHVNFE 		:= _cChVNF
	else
		Conout("WSPOSTAGEM|Pedido magento nao encontrado: "+_cPed)
	endif     
	CATCHEXCEPTION USING Self:oException
	If ( ValType( Self:oException ) == "O" )
		Self:cMsgSoapFault := ""
		Self:cMsgSoapFault += IF( !Empty( Self:oException:Description )	, Self:oException:Description	, "" )
		Self:cMsgSoapFault += IF( !Empty( Self:oException:ErrorStack )		, Self:oException:ErrorStack 	, "" )
		SetSoapFault("[WS_SOAPFAULT]-ERR-4000012-WSMethod [WSProduct]", alltrim(Self:cMsgSoapFault))
	EndIf
	Self:lWsMethodRet := .F.			
	ENDEXCEPTION             
Return .T.


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
			__codigo := __userinfo[1][1]  //C   	Numero de identificao sequencial com o tamanho de 6 caracteres
			__nomusr := __userinfo[1][2]  //C    	Nome do usuario			
			__nomcpl := __userinfo[1][4]  //C   	Nome completo do usuario
			__depart := __userinfo[1][12] //C   	Departamento
			__cargo  := __userinfo[1][13] //C    	Cargo
			__email  := __userinfo[1][14] //C    	E-mail						
			__usrblq := __userinfo[1][17] //L    	Usuario bloqueado			
			__empfil := __userinfo[1][22] //C    	Empresa, filial e matricula
			__ainfsis:= __userinfo[1][23] //A    	Informacoes do sistema 			
			__dtinclu:= __userinfo[1][24] //D    	Data de inclusao no sistema
			__nivel  := __userinfo[1][25] //C    	Nivel global de campo			
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

