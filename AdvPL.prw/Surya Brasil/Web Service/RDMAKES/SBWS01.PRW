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
WsStruct WSEstProd
	WsData __cProd		AS String
	WsData __cLote		AS String	Optional
	WsData __DtValid	AS String	Optional
	WsData __Saldo		AS Float	
EndWSStruct

WsStruct WSLote
	WsData cLote		AS String	Optional		
EndWSStruct
WSSTRUCT WSLotes
  WSDATA xLote AS ARRAY OF WSLote Optional
ENDWSSTRUCT



WsService SaldoProduto Description "Fornece o saldo de um Produto."

	WsData cProd    		As String	
	WsData cLoc   	 		As String
	WsData cRastro			As String
	WsData __login			AS String
	WsData __pws  			AS String	 
	
	WsData oException		AS String
	WsData cMsgSoapFault	AS String
	WsData lWsMethodRet		AS Boolean
	
	WsData Lotes      		As WSLotes
	WsData aProd	 	 	AS array OF WSEstProd
//B8_PRODUTO, B8_LOTECTL,B8_DTVALID,(B8_SALDO-B8_EMPENHO)[DISPONIVEL]    

	WsMethod BuscaSaldo      Description "Busca o saldo do Produto."

EndWsService

WsMethod BuscaSaldo WsReceive cProd, Lotes, cLoc, cRastro, __login,__pws WsSend aProd WsService SaldoProduto
	local nX				:= 0
	local __wsSoapFault		:= ""
	Local nX3Prod			:= TAMSX3("B8_PRODUTO")[1]
	Local nSaldo 			:= 0
	local __Autetication	:= {}
	local _cProd			:= Self:cProd+Space(nX3Prod-Len(Self:cProd)) 
	local aProduto			:= {}
	Local cLotes			:= ""
	local oLotes			:= Lotes:xLote
   	TRYEXCEPTION
   	__Autetication := aClone( __wblogin( Self:__login,Self:__pws ) )
	If( len(__Autetication) > 0 )
		If( !__Autetication[3] )
			SetSoapFault("[WS_SOAPFAULT]-ERR-5000012-WSMethod [WSCustomers]", AllTrim(__Autetication[1]))
			Return( .F. )
		EndIf
	EndIf
	For nX = 1 to len(oLotes)
		cLotes += ",'"+oLotes[nX]:cLote+"'"
	Next
	cLotes := Substr(cLotes,2,len(cLotes))
	Self:aProd 	:= {}
	if Self:cRastro == "S"
		aProduto := BproxLot(_cProd,Self:cLoc,cLotes)		
		if	Len(aProduto)==0
			AAdd( Self:aProd, WSClassNew("WSEstProd") )
			Self:aProd[1]:__cProd 		:= "INEXISTENTE"
			Self:aProd[1]:__cLote 		:= "INEXISTENTE"
			Self:aProd[1]:__DtValid 	:= "INEXISTENTE"
			Self:aProd[1]:__Saldo 		:= 0
		else
			For nX = 1 to Len(aProduto)	
				AAdd( Self:aProd, WSClassNew("WSEstProd") )
				Self:aProd[nX]:__cProd 		:= aProduto[nX][1]
				Self:aProd[nX]:__cLote 		:= aProduto[nX][2]
				Self:aProd[nX]:__DtValid 	:= DTOC(aProduto[nX][3])
				Self:aProd[nX]:__Saldo 		:= aProduto[nX][4]
			Next
		endif			
	else
		dbSelectArea("SB2")
		if dbSeek(xFilial("SB2") + _cProd + Self:cLoc)
			nSaldo := SaldoSb2()
			AAdd( Self:aProd, WSClassNew("WSEstProd") )
			Self:aProd[1]:__cProd 		:= SB2->B2_COD
			Self:aProd[1]:__cLote 		:= ""
			Self:aProd[1]:__DtValid 	:= ""
			Self:aProd[1]:__Saldo 		:= nSaldo
		else
			Conout("WSSaldoProduto|Produto nao encontrado na SB2: "+_cProd)
		endif
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

Static Function BproxLot(cProd,cLocal,cLotes)
local aProd 	:= {}
local cQuery 	:= {}
local dValid	:= CTOD("  /  /  ")

//dValid	:= Posicione("SB8",3,xFilial("SB8")+cProd+cLocal+cLote,"B8_DTVALID")

cQuery	:= 	"SELECT TOP 1 B8_PRODUTO, B8_LOTECTL,B8_DTVALID,(B8_SALDO-B8_EMPENHO)[DISPONIVEL] "
cQuery 	+= 	"FROM "+RetSqlTab("SB8")+ " "
cQuery 	+= 	"WHERE SB8.B8_FILIAL='"+xFilial("SB8")+"' AND SB8.D_E_L_E_T_=' ' "
cQuery 	+=	"AND B8_PRODUTO = '" +alltrim(cProd)+ "' AND B8_LOCAL = '"+cLocal+ "' " 
cQuery	+=	"AND B8_LOTECTL Not IN ("+cLotes+") AND (B8_SALDO - B8_EMPENHO) > 0 "
cQuery	+=	"ORDER BY 3"
//
cQuery := ChangeQuery(cQuery)
If SELECT("TSB8") > 0
	TSB8->(DbCloseArea())
EndIf	
//
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSB8")
//
DbSelectArea("TSB8")
If ! TSB8->(Eof())
	AADD(aProd,{TSB8->B8_PRODUTO,TSB8->B8_LOTECTL,STOD(TSB8->B8_DTVALID),TSB8->DISPONIVEL})	
ENDIF	
If SELECT("TSB8") > 0
	TSB8->(DbCloseArea())
EndIf	
Return(aProd)

