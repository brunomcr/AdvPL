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
Fonte	  -	WSFAT002
Descrição - Tela para gerar a etiqueta manualmente.
Autor	  - Vinicius Martins
Data	  - 18/04/2019
=============================================================================== */
User Function WSSTAT01()
//Local oButton1
//Local oButton2                                 
Local oGet1
Local cGet1 := SC5->C5_NUM
Local oSay1
/*
Private xEmp 		:= "03" //aParam[1]
Private xFil 		:= "00" //aParam[2]

RPCSetType(3)
If FindFunction('WFPREPENV')
	lAuto := .T.      
	RPCSetType( 3 )						// Não consome licensa de uso
	//wfPrepENV(xEmp, xFil)	
	wfPrepENV("03", "00")
Else
	lAuto := .T.
	RPCSetType( 3 )						// Não consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil	
Endif
*/
Private oDlg

  DEFINE MSDIALOG oDlg TITLE "Status Correios" FROM 000, 000  TO 380, 550 COLORS 0, 16777215 PIXEL

    fWBrowse1()
    @ 007, 025 SAY oSay1 PROMPT "Pedido:" SIZE 033, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 005, 045 MSGET oGet1 VAR cGet1 SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return

//------------------------------------------------ 
Static Function fWBrowse1()
//------------------------------------------------ 
Local oWBrowse1
Local aWBrowse1 := {}
Local _cAlias := GetNextAlias()

cPedido = SC5->C5_NUM

	cQuery := ""
	cQuery += " SELECT Z4_DTOCOR = CASE WHEN Z4_DTOCOR <> '' THEN CONVERT (VARCHAR, CONVERT (DATETIME, Z4_DTOCOR ), 103) end + ' - ' + Z4_HROCOR, Z4_OBS " 
	cQuery += " FROM SZ4030 SZ4"
	cQuery += " JOIN SC5030 SC5"
	cQuery += " ON Z4_NRDC = C5_NOTA AND Z4_SERDC = C5_SERIE AND SC5.D_E_L_E_T_ = ''"
	cQuery += " WHERE SZ4.D_E_L_E_T_ = ''"
	cQuery += " AND SC5.C5_NUM = '"+cPedido+"'"
	cQuery += " ORDER BY Z4_DTOCOR DESC"
	
	cQuery := changequery(cQuery)

	If Select(_cAlias) > 0 
	    DbSelectArea(_cAlias)
	    DbCloseArea() 
	Endif

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), (_cAlias), .F., .T. ) 
	
	DBSelectArea((_cAlias)) 	//ABRE O ARQUIVO TEMPORARIO
	dbGoTop()             	// ALINHA NO PRIMEIRO REGISTRO
	
	While (_cAlias)->(!EOF())
	
	 	Aadd(aWBrowse1, { (_cAlias)->Z4_DTOCOR  ,; 
		 				  (_cAlias)->Z4_OBS })
		  
		(_cAlias)->(dbSkip()) 
	EndDo

	If Empty(aWBrowse1)
		Aadd(aWBrowse1, { "","" } ) 
	EndIf

    @ 021, 025 LISTBOX oWBrowse1 Fields HEADER "Data Ocorrência","Descrição Ocorrencia" SIZE 230, 150 OF oDlg PIXEL ColSizes 60,60
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      aWBrowse1[oWBrowse1:nAt,1],;
      aWBrowse1[oWBrowse1:nAt,2];
    }}
    // DoubleClick event
    //oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
    // oWBrowse1:DrawSelect()}

Return


/* ===============================================================================
Fonte	  -	WSSTATCO
Descrição - Fonte responsável por consumir o Web Service dos Correios
			para capturar o status do pedido
Autor	  - Vinicius Martins
Data	  - 13/03/2019
=============================================================================== */
User Function WSSTATCO(aparam)
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
cQuery += " AND C5_XSTATUS NOT IN ('7','10') "
cQuery += " AND C5_XCANSAI IN ('2','5','6','7','8','9','A')"
cQuery += " AND C5_TRANSP IN ('04162','04669')"
cQuery += " AND SC5.D_E_L_E_T_ = ''"
cQuery += " order by SC5.R_E_C_N_O_ "
//cQuery += " AND F2_EMISSAO >= CONVERT(DATE, GETDATE()-3,112) "
//cQuery += " AND C5_NOTA+C5_SERIE IN ('000021404003','000021423003')"

cQuery := changequery(cQuery)

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), (_cAlias), .F., .T. )

Do While  (_cAlias)->(!EOF())

	If Len( alltrim((_cAlias)->C5_XRASTRE )) > 1
		// Criando o objeto Web Service
		_oWs := WSService1():New()
		_oWs:ccnpj					:= ccnpj
		_oWs:cnumeroCartao			:= cnumeroCartao
		_oWs:cnumeroRegistro		:= alltrim(StrTran((_cAlias)->C5_XRASTRE,"BR",""))
		_oWs:cusuario				:= cusuario
		_oWs:csenha					:= csenha
		
		//Executa o método para retornar os status
		_oWs:RetornaStatusDoObjeto()//(ccnpj,cnumeroCartao,cnumeroRegistro,cusuario,csenha)
		//Resultado
		aRegistros := _oWs:oWSRetornaStatusDoObjetoResult
		
		For x=1 to len(aRegistros:oWSEventoObjeto)
			
			cPedido		:= (_cAlias)->C5_NUM
			cNota		:= (_cAlias)->C5_NOTA
			cSerie		:= (_cAlias)->C5_SERIE
			dDtOco		:= stod(StrTran(substr(aRegistros:oWSEventoObjeto[x]:CDATAEVENTO,1,10),"-","")) //StrTran(substr(aRegistros:oWSEventoObjeto[x]:CDATAEVENTO,1,10),"-","")
			dDtOco		:= Year2Str(dDtOco) + Month2Str(dDtOco) + Day2Str(dDtOco)
			cHoraOco	:= substr(aRegistros:oWSEventoObjeto[x]:CDATAEVENTO,12,5)
			
			dbSelectArea("SZ4")
			dbSetOrder(7)
			If Empty(aRegistros:oWSEventoObjeto[x]:CTIPO ) .And. (_cAlias)->DATA_BASE <= 3
				conout("Pedido ainda sem ocorrências!")
				Loop
				
			ElseIf !dbseek(xFilial("SZ4") + cNota + cSerie + dDtOco + cHoraOco )
				cNRIMP := GETSXENUM("SZ4", "Z4_NRIMP")
				RecLock('SZ4', .T. )
				SZ4->Z4_FILIAL	:= xFilial("SZ4")
				SZ4->Z4_MARKBR	:= ""
				SZ4->Z4_NRIMP	:= cNRIMP //GETSXENUM("SZ4", "Z4_NRIMP", "Z4_NRIMP",1)
				//SZ4->Z4_NRIMP	:= GETSX8NUM("SZ4", "Z4_NRIMP", "Z4_NRIMP",1)
				SZ4->Z4_EDINRL	:= x
				SZ4->Z4_EDILIN	:= '' //MemoWrite(aRegistros:oWSEventoObjeto[x])//aRegistros:oWSEventoObjeto[x]
				SZ4->Z4_EDIARQ	:= "WS Correios"
				SZ4->Z4_DTIMP	:= dDataBase
				SZ4->Z4_ALTER	:= "2"
				SZ4->Z4_EDISIT	:= "1"
				SZ4->Z4_EDIMSG	:= ""
				SZ4->Z4_USUIMP	:= "ws_correios"
				SZ4->Z4_FILOCO	:= xFilial("SZ4")
				SZ4->Z4_CODOCO	:= Iif(alltrim(aRegistros:oWSEventoObjeto[x]:CDESCRICAO) == "Entregue","01","")
				SZ4->Z4_DTOCOR	:= stod(StrTran(substr(aRegistros:oWSEventoObjeto[x]:CDATAEVENTO,1,10),"-",""))
				SZ4->Z4_HROCOR	:= substr(aRegistros:oWSEventoObjeto[x]:CDATAEVENTO,12,5)
				SZ4->Z4_CODOBS	:= 0
				SZ4->Z4_OBS		:= alltrim(aRegistros:oWSEventoObjeto[x]:CDESCRICAO)
				SZ4->Z4_FILDC	:= xFilial("SZ4")
				SZ4->Z4_EMISDC	:= SM0->M0_CGC
				SZ4->Z4_SERDC	:= (_cAlias)->C5_SERIE
				SZ4->Z4_NRDC	:= (_cAlias)->C5_NOTA
				SZ4->Z4_CDTRP	:= alltrim((_cAlias)->C5_TRANSP)
				SZ4->Z4_CLASSI	:= ""
				SZ4->Z4_ORIGEM	:= "WS_Correrios"
				SZ4->Z4_TIPO	:= alltrim(aRegistros:oWSEventoObjeto[x]:CTIPO)
				SZ4->Z4_CODEV	:= alltrim(aRegistros:oWSEventoObjeto[x]:CSTATUS)
				
				SZ4->(MsUnlock())
				
				ConfirmSX8()
				
				If x ==  1 //len(aRegistros:oWSEventoObjeto)
					
					Do Case 
						Case alltrim(aRegistros:oWSEventoObjeto[x]:CDESCRICAO) == "Entregue"
							dbSelectArea("SC5")
							dbSetOrder(1)
							dbSeek(xFilial("SC5")+cPedido)
							RecLock("SC5", .F.)
							SC5->C5_XSTATUS := "7"
							SC5->C5_XDESCST := "Objeto Entregue"
							SC5->(MsUnlock())
						Case alltrim(aRegistros:oWSEventoObjeto[x]:CDESCRICAO) == "Objeto postado"
							dbSelectArea("SC5")
							dbSetOrder(1)
							dbSeek(xFilial("SC5")+cPedido)
							RecLock("SC5", .F.)
							SC5->C5_XSTATUS := "6"
							SC5->C5_XDESCST := "Objeto postado"
							SC5->(MsUnlock())
						Case alltrim(aRegistros:oWSEventoObjeto[x]:CSTATUS) == ""
							dbSelectArea("SC5")
							dbSetOrder(1)
							dbSeek(xFilial("SC5")+cPedido)
							RecLock("SC5", .F.)
							SC5->C5_XSTATUS := "10"
							SC5->C5_XDESCST := "Objeto de Rastreio Inativo"
							SC5->(MsUnlock())				
					EndCase
				EndIf
				
			EndIf
			
		Next
		
	EndIf
	
(_cAlias)->(dbSkip())
Enddo
	
Return
