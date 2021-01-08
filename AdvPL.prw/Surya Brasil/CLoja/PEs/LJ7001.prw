#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Funcao>: LJ7001
<Descricao> : Esse ponto de entrada È chamado antes do inÌcio da gravaÁ„o do orÁamento. Utilizado para validaÁıes no final da venda.
<Autor> : Renan Ros·rio
<Data> : 26/09/18
<Parametros> : Nil
<Retorno> : Nil
<Processo> : Loja
<Tipo> : 
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
User Function LJ7001()

Local lRet 			:= .T.
Local oEdit1
Local nEdit1 		:= 0
Local _cTITULO		:= 'Surya Solidaria'
Local cFonec		:= SuperGetMV( "MV_LJFORIA" )
Local cLoja			:= SuperGetMV( "MV_LJLOJIA" )
Local CDESCPRD		:= SuperGetMV( "MV_XLJFORDE" )
Local _cNum			:= ''
Local _cCliente		:= ''
Local lYesNo		:= .F.	
Local __nTroco		:= Lj7T_Troco(2)
Local nParTipo      := PARAMIXB[1] //(1-orcamento  2-venda  3-pedido) 

If Empty ( SL1->L1_NUM )
	 
	_cNum := M->LQ_NUM

Else
		
	__cNum := SL1->L1_NUM
		
EndIf	

DbSelectArea("MGK")
				
If MGK->( dbSetOrder( 3 ), dbSeek( xFilial( "MGK" ) + AllTrim ( _cNum  ) ) )

	lYesNo		:= .F.
	Alert ('Existe uma DoaÁ„o realizada para este Pedido'+CRLF+' no Valor de' + MGK->MGK_VALOR+'.' )
	 
Else

	lYesNo				:= MsgYesNo( 'Deseja realizar doaÁ„o?', 'Surya Solidaria' )

EndIf

If lYesNo //MsgYesNo( 'Deseja realizar doaÁ„o?', 'Surya Solidaria' )
	
	If __nTroco > 0 // ValidaÁ„o se Existe Troco
		
		nEdit1 := __nTroco
		
	EndIf	
	
		
	DEFINE MSDIALOG _oDlg TITLE _cTITULO FROM C(177),C(192) TO C(340),C(659) PIXEL STYLE DS_MODALFRAME
		
		_oDlg:lEscClose := .F.
		
		// Cria as Groups do Sistema
		@ C(002),C(003) TO C(071),C(186) LABEL "Dig. Valor de DoaÁ„o " PIXEL OF _oDlg
		
		// Cria Componentes Padroes do Sistema
		@ C(012),C(027) Say "Fornecedor	 : "+cFonec Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg 
		@ C(020),C(027) Say "Descricao	 : "+cDesCPrd Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
		@ C(028),C(027) Say "Valor DoaÁ„o : "Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
		//@ C(028),C(070) MsGet oEdit1 Var nEdit1 F3 "SB1" Valid(ValProd(cEdit1)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
		@ C(028),C(070) MsGet oEdit1 Var nEdit1 Valid( ValnTroco ( nEdit1, __nTroco ) ) Size C(060),C(009) COLOR CLR_HBLUE OF _oDlg PIXEL PICTURE "@E 999,999,999.99"
		
		//Bot„o Gravar
		@ C(004),C(194) Button "Salvar" Size C(037),C(012) PIXEL OF _oDlg Action(Chkproc:=.T.,_oDlg:End())
		oEdit1:SetFocus()
			
	ACTIVATE MSDIALOG _oDlg CENTERED
		
		
	If SL1->( dbSetOrder( 1 ), dbSeek( xFilial( "SL1" ) + _cNum ) ) .AND. lYesNo
			
		RecLock("SL1",.F.)
				
			SL1->L1_VLRARR     	:= nEdit1
			SL1->L1_TROCO1		:= __nTroco - nEdit1
					
		SL1->(MsUnlock())
		
		GRAVAMGK ( nEdit1, _cNum )
		
	ElseIf lYesNo
	
		M->LQ_VLRARR 			:= nEdit1
		M->LQ_TROCO1			:= __nTroco - nEdit1
			
		Conout ( "ERRO!!!"+CRLF+"Venda n„o entcontrado: " + _cNum )
		lRet 	:= .T.
		GRAVAMGK ( nEdit1, _cNum )
		
	EndIf
	
EndIf	
	
Return lRet

/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Funcao>: ValnTroco
<Descricao> : ValidaÁ„o de Troco 
<Autor> : Renan Ros·rio
<Data> : 26/09/18
<Parametros> : Nil
<Retorno> : Nil
<Processo> : Loja
<Tipo> : 
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Static Function ValnTroco( nEdit1, __nTroco )

Local lRet := .F.

If nEdit1 <= __nTroco

	lRet := .T.
	
EndIf      

Return 	lRet

/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Funcao>: ValnTroco
<Descricao> : ValidaÁ„o de Troco 
<Autor> : Renan Ros·rio
<Data> : 26/09/18
<Parametros> : Nil
<Retorno> : Nil
<Processo> : Loja
<Tipo> : 
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Static Function GRAVAMGK( nEdit1, _cNum )

Local _lRec			:= .F.
Local cIDMGK 		:= '' //GetSxeNum("MGK","MGK_NUM","MGK_NUM" + xFilial( "MGK" ) )
Local cIDATU		:= '' //SOMA1(ALLTRIM (cIDMGK))
Local cTime			:= ''
Local cHour			:= ''
Local _cCliente		:= M->LQ_CLIENTE
Local _cLoja		:= M->LQ_LOJA
Local lNum			:= .F.
Local aArea  		:= GetArea()
Local _cAlias 		:= GetNextAlias()
Local _cQuery		:= ''

_cQuery		:= "SELECT TOP 1 MGK_NUM NUM"	+CRLF
_cQuery 	+= "	FROM "+RETSQLNAME( "MGK" )+" MGK "	+CRLF
_cQuery		+= "	ORDER BY NUM DESC"

dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), _cAlias, .F., .T. )
		
RestArea(aArea)
		
cIDATU 	:= SOMA1(ALLTRIM ( ( _cAlias )->NUM ) ) //cAlias->NUM
		
DbSelectArea("MGK")	
//DbSetOrder(1)
				
If MGK->( dbSetOrder( 3 ), dbSeek( xFilial( "MGK" ) + _cNum ) )
			
	RecLock("MGK", .F.)
	lNum	:= .F.
			
Else
	
	RecLock("MGK", .T.)
	lNum	:= .T.
	
EndIf	
	
	ConfirmSx8()
	
		cTime := Time()
		cHour := SubStr( cTime, 1, 5 ) 
		
		If lNum 
		
			MGK->MGK_FILIAL    	:= xFilial( "MGK" )
			MGK->MGK_NUM	   	:= AllTrim ( cIDATU )
		
		EndIf
			 
		MGK->MGK_DATA	   	:= dDataBase //DTOS ( Date() )
		MGK->MGK_HORA	   	:= cHour 
		MGK->MGK_NUMORC	   	:= _cNum
		MGK->MGK_CODCLI	   	:= AllTrim ( _cCliente )  
		MGK->MGK_LOJA	   	:= AllTrim ( _cLoja )
		MGK->MGK_VALOR	   	:= nEdit1
	//	MGK->MGK_FORMPG	   	:= 
		MGK->MGK_TRANSM		:= 'N'
	
					
	MGK->(MsUnlock())
	
Return