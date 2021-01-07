#INCLUDE "protheus.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE 'DIRECTRY.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "RPTDEF.CH"

/* ===============================================================================
Fonte	  -	WSOBJPOS
Descrição - Fonte responsável por consumir o Web Service dos Correios
			para capturar o status do pedido
Autor	  - Vinicius Martins
Data	  - 13/03/2019
=============================================================================== */
User Function WSOBJPOS(aparam)
//User Function WSSTATCO()
//Variaveis contendo as informações para consumir o WS - Método PrePostarObjetoV5
Local ccnpj 					:= '04.457.868/0001-76' //'73.186.116/0001-30' -> homolog 
Local cnumeroCartao 			:= '0066844347' // '0067059090' -> homolog
Local cnumeroRegistro			:= ''
Local cusuario 					:= 'SuryaWS' // 'HomologacaoMP' -> homolog
Local csenha 					:= 'Duh4PAbbQ14c5zl' // 'Dej6PFEcPiNGyHm1JK' -> homolog
Local cQuery					:= ""
Local _cAlias 					:= GetNextAlias()
Local cNota						:= ""
Local cSerie					:= ""
Local dDtOco
Local cHoraOco					:= ""
//Variaveis contendo as informações para consumir o WS - RetornaEtiquetasParaImpressao
Local _oWs
Local x
Local aRegistros 				:= {}	

Private xEmp 					:= aParam[1]
Private xFil 					:= aParam[2]

RPCSetType(3)
If FindFunction('WFPREPENV')
	lAuto := .T.      
	RPCSetType( 3 )						// Não consome licensa de uso
	wfPrepENV(xEmp, xFil)	
	//wfPrepENV("03", "00")
Else
	lAuto := .T.
	RPCSetType( 3 )						// Não consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil	
Endif

cQuery := ""
cQuery += " SELECT "
cQuery += " C5_NUM, C5_CLIENTE, C5_LOJAENT, C5_LOJACLI, C5_CLIENT, C5_TRANSP, C5_TIPOCLI, C5_XRASTRE, C5_NOTA, C5_SERIE, C5_XSTATUS, "
cQuery += " DATEDIFF(DAY,CONVERT(DATE,F2_EMISSAO,112), CONVERT(DATE, GETDATE(),112)) DATA_BASE"
cQuery += " FROM SC5030 SC5"
cQuery += " JOIN SF2030 SF2"
cQuery += " ON C5_NOTA = F2_DOC AND C5_SERIE = F2_SERIE AND SF2.D_E_L_E_T_ = ''"
cQuery += " WHERE SC5.D_E_L_E_T_ = ''"
cQuery += " AND RTRIM(LTRIM(C5_XRASTRE)) <> '' "
cQuery += " AND C5_XSTATUS IN ('7') "
cQuery += " AND C5_XCANSAI IN ('2','9','A')"
cQuery += " AND C5_TRANSP IN ('04162','04669')"
cQuery += " AND SC5.D_E_L_E_T_ = '' AND C5_XVFRETE = 0"
//cQuery += " AND C5_XRASTRE = 'OG723365184BR'"
cQuery += " order by SC5.R_E_C_N_O_ "
//cQuery += " AND F2_EMISSAO >= CONVERT(DATE, GETDATE()-3,112) "
//cQuery += " AND C5_NOTA+C5_SERIE IN ('000021404003','000021423003')"

cQuery := changequery(cQuery)

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), (_cAlias), .F., .T. )

Do While  (_cAlias)->(!EOF())

	If Len( alltrim((_cAlias)->C5_XRASTRE )) > 1
		// Criando o objeto Web Service
		_oWs := WSService1():New()
		//_oWs:ccnpj					:= ccnpj
		//_oWs:cnumeroCartao			:= cnumeroCartao
		_oWs:ccodigosDeRegistro 		:= alltrim((_cAlias)->C5_XRASTRE)
		_oWs:cusuario				:= cusuario
		_oWs:csenha					:= csenha
		
		//Executa o método para retornar os status
		_oWs:RetornaObjetosPostados()//(ccnpj,cnumeroCartao,cnumeroRegistro,cusuario,csenha)
		//Resultado
		aRegistros 	:= _oWs:oWSRetornaObjetosPostadosResult
		cPedido		:= (_cAlias)->C5_NUM
		For x=1 to len(aRegistros:OWSObjetoPLP)
			dbSelectArea("SC5")
			dbSetOrder(1)
			dbSeek(xFilial("SC5")+cPedido)
			RecLock("SC5", .F.)
				SC5->C5_XVFRETE := aRegistros:OWSOBJETOPLP[x]:NVALOR			
			SC5->(MsUnlock())
			Next		
	EndIf	
(_cAlias)->(dbSkip())
Enddo
	
Return
