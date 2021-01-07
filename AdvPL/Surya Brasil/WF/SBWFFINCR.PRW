#Include "Rwmake.ch"
#Include "TopConn.ch"
#Include "TBIConn.ch"
/*/

Autor Caio de Paula Data   10/08/18 
Geracao de E-Mail com os titulos a receber vencendo no dia
seguinte a Geracao do e-mail, para envio ao depto de contas
a receber e Diretoria                                        

Uso exclusivo para o cliente SURYA                       

/*/
User Function RFINM01(aParam)

// aParam[1] == Empresa
// aParam[2] == Filial
// aParam[3] == A/V -- Informa ao Pgm se sao Titulos (A) Vencer ou (V)encidos 
//-
// verificacao de ambiente para rodar em JOB                           
//-
_lAgend := .F.
return
If Type('__LocalDriver') == "U"
	_lAgend := .T.
	Prepare Environment Empresa aParam[1] Filial aParam[2] FUNNAME "RFINM01"
	CONOUT("Iniciando Processo Agendado - RFINM01")
Else
	aParam := {"03","00","A"}
EndIf

If aParam[3] == "A"
	CriaQry("A")
Else
	CriaQry("V")
EndIf

CONOUT("Fim do Processo Agendado - RFINM01")

Return



STATIC FUNCTION CRIAQRY(cTipo)

Local oProcess, oHtml
Local _lOk   := .F.
Local _cErro := ""
Local _nTent := 0

aStru := {}
aAdd(aStru,{"E1_EMISSAO","D",08,0})
aAdd(aStru,{"E1_VENCREA","D",08,0})
aAdd(aStru,{"E1_VALOR"  ,"N",14,2})

_cQuery := "SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA, A1_NOME, A1_TEL, A1_EMAIL, E1_EMISSAO, E1_VENCREA, E1_VALOR, "
_cQuery += " E1_SITUACA, E1_PORTADO, "

_cQuery += " (SELECT ISNULL(MAX(A6_NOME),' ') FROM "+RetSqlName("SA6")+ " SA6 " 
_cQuery += " WHERE A6_FILIAL = '"+xFilial("SA6")+"' "
_cQuery += " AND A6_COD = E1_PORTADO "
_cQuery += " AND SA6.D_E_L_E_T_ = ' ') AS BANCO "

_cQuery += " FROM "
_cQuery += RetSqlName("SE1")+" SE1 "
_cQuery += " INNER JOIN " + RetSqlName("SA1")+" SA1 ON "
_cQuery += " A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
_cQuery += " WHERE "
_cQuery += " E1_FILIAL = '"+xFilial("SE1")+"' "
_cQuery += " AND E1_TIPO NOT IN ('RA','NCC','AB-') "
_cQuery += " AND E1_SALDO > 0 "
_cQuery += " AND SE1.D_E_L_E_T_ = ' ' "

If cTipo == "A"
	_cQuery += " AND E1_VENCREA = '"+Dtos(dDataBase+1)+"' "
Else
	_cQuery += " AND E1_VENCREA < '"+Dtos(dDataBase)+"' "
EndIf

_cQuery += " ORDER BY E1_VENCREA, E1_CLIENTE, E1_LOJA "

_cQuery := ChangeQuery(_cQuery)

//MEMOWRIT( "TESTE"+cTipo+".SQL", _cQuery )

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'QUERY', .F., .T.)

For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('QUERY', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

_lFirst   := .T.
_lEnvMail := .F.
dbSelectArea("QUERY")
dbGotop()
While !Eof()  
	
	_cCarteira := xRetCart(QUERY->E1_SITUACA) + IIF(QUERY->E1_SITUACA<>'0'," - Banco: "+QUERY->BANCO,"")
	
	If _lFirst
		_lFirst 		:= .F.
		_lEnvMail 	:= .T.
		_cEmail 		:= SuperGetMv("SB_XFINM01",.F.,"caio.santos@suryabrasil.com") // Parametro que contem os Emails que receberao este relatorio
		oProcess 	:= TWFProcess():New( "000003", "Arquivo do Financeiro " )
		If cTipo == "A"
			oProcess :NewTask( "CTA A RECEBER" , "\WORKFLOW\HTML\RFINWF01.HTM")
		Else
			oProcess :NewTask( "CTA A RECEBER" , "\WORKFLOW\HTML\RFINWF02.HTM")
		EndIf
		oHtml    	:= oProcess:oHTML
		oHtml			:ValByName( "cUnidade"	,	SM0->M0_NOME)
	EndIf
	
	aAdd( (oHtml:ValByName( "it.serie"   )), QUERY->E1_PREFIXO	)
	aAdd( (oHtml:ValByName( "it.numero"  )), QUERY->E1_NUM   	)
	aAdd( (oHtml:ValByName( "it.parcela" )), QUERY->E1_PARCELA	)
	aAdd( (oHtml:ValByName( "it.clifor"  )), QUERY->E1_CLIENTE	)
	aAdd( (oHtml:ValByName( "it.nome"    )), QUERY->A1_NOME		)
	aAdd( (oHtml:ValByName( "it.contato" )), QUERY->A1_EMAIL+ " - "+QUERY->A1_TEL	)
	aAdd( (oHtml:ValByName( "it.carteira")), _cCarteira )
	aAdd( (oHtml:ValByName( "it.emissao" )), QUERY->E1_EMISSAO )
	aAdd( (oHtml:ValByName( "it.vencto"  )), QUERY->E1_VENCREA )
	aAdd( (oHtml:ValByName( "it.valor"   )), Transform(QUERY->E1_VALOR, '@E 99,999,999.99') )
	
	dbSelectArea("QUERY")
	dbSkip()
EndDo

If _lEnvMail
	If cTipo == "A"
		oProcess:cSubject		:= 'Titulos a Receber em: '+Dtoc(dDatabase+1)
	Else
		oProcess:cSubject		:= 'Titulos a Receber Vencidos '
	EndIf
	oProcess:cTo     		:= _cEmail
	oProcess:cBody			:= "Relatorio Referente ao Contas a Receber"
	oProcess:Start()
	oProcess:Finish()
EndIf

dbSelectArea("QUERY")
dbCloseArea()

Return

Static Function xRetCart(cCarteira)
_cRet := ""
If cCarteira = "0" 
	_cRet := "Carteira"
ElseIf cCarteira = "1" 
	_cRet := "Cobranca Simples"
ElseIf cCarteira = "2" 
	_cRet := "Cobranca Descontada"
ElseIf cCarteira = "3" 
	_cRet := "Caucionada"
ElseIf cCarteira = "4" 
	_cRet := "Vinculada"
ElseIf cCarteira = "5" 
	_cRet := "Advogado"
ElseIf cCarteira = "6" 
	_cRet := "Judicial"
ElseIf cCarteira = "7" 
	_cRet := "Caucao Descontada"
ElseIf cCarteira = "F" 
	_cRet := "Protesto"
ElseIf cCarteira = "G" 
	_cRet := "Acordo"
ElseIf cCarteira = "H"
	_cRet := "Cobranca Cartorio"
EndIf

Return(_cRet)