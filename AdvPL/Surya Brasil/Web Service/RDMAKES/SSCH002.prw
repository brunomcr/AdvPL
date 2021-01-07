#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "APWEBEX.CH" 
#INCLUDE "ap5mail.ch" 
#INCLUDE "tbicode.ch"
#INCLUDE "DEFEMPSB.CH"     
#INCLUDE "Rwmake.ch"
#INCLUDE "fivewin.ch"
#INCLUDE "FWPrintSetup.ch"  
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "fileio.ch"
#INCLUDE "FISA095.CH" 


#DEFINE DS_MODALFRAME   128
#DEFINE IMP_SPOOL 2
#DEFINE VBOX       080
#DEFINE HMARGEM    030


/* ===============================================================================
Fonte	  -	SSCH002.prw
Descriï¿½ï¿½o - Rotina de Agendamento para gerar o PDF da DANFE, salvar na pasta Dossie
			do pedido, transmitir e Monitorar GNRE  e enviar para o Financeiro.
Autor	  - Vinicius Martins
Data	  - 23/04/2019
u_SSCH002({'03','00'})
=============================================================================== */
User Function SSCH002(aParam)
//User Function SSCH002()
Private xEmp 		:= aParam[1]
Private xFil 		:= aParam[2] 
RPCSetType(3)
If FindFunction('WFPREPENV')
	lAuto := .T.
	RPCSetType( 3 )						// Nï¿½o consome licensa de uso
	wfPrepENV(xEmp, xFil)
	//wfPrepENV("03", "00")
	conout("Preparou ambiente. . .")
Else
	lAuto := .T.
	RPCSetType( 3 )						// Nï¿½o consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil
	conout("Preparou ambiente. . .")
Endif         

//Imprimir e salvar Danfes           
If !SavDF()
		
endif

Return

//------------------------------------------------------------------
/*/{Protheus.doc} SavDF
Description: Verifica notas transmitidas para gerar etiqueta, danfe, 
transmitir GNRe, envia o doc gnre para o fiscal. Verifica as notas
pagas e enviar os documentos (etiqueta e danfe) para logistica.				                                  
                                                                
@return xRet Return Description                                 
@author Vinicius Martins                                               
@since 19/02/2019                                                   
/*/                                                             
//-------------------------------------------------------------------

Static Function SavDF()
Local lRet 		   		:= .T.
Local cQuery			:= ""
Local _cQuery			:= ""
Local cOrdem			:= ""
Local _cAlias 			:= GetNextAlias()
Local _cAliasSF6		:= GetNextAlias()
Local _cAliasSFT		:= GetNextAlias()
Local nFilGNRE1			:= GetMV("SB_FGNRE01")
Local nFilGNRE2			:= GetMV("SB_FGNRE02")
Local nAmbiente			:= GetMV("SB_GNREAMB")
Local cFiltro			:= GetMV("SB_XCANSAI")
local _cDestFat	    	:= GetMV("SB_DESTFAT")
local _cDest	    	:= GetMV("SB_DESTFTP")
local _cCopy	    	:= GetMV("SB_COPYFTP")
Local aRet    			:= {}
Local aRetGnre			:= {}
Local cRetGnre			:= ""
Local cCaminho			:= "\Dossie\"
Local nX				:= 0
Local cCanalSaida		:= ""
Local cEtiqueta			:= ""
Local cSerNF			:= GetMV("SB_SERNF")

//Alex, verificar se gravou tudo.
Local cDir 				:= ""
Local cPreDan			:= ""
Local cPrePed			:= ""
Local nLog				:= ""
Local nEtq				:= "" //"Etiqueta" de funcionario
Local cEtq				:= "Pedido de funcionário, não possui etiqueta. Verificar Dados Complementares da DANFE." // Etiqueta de Funcionário
Local cError   			:= ""
Local bError   			:= ErrorBlock({ |oError| cError := oError:Description})
Local lErro				:= .F.
Local cErrEtq			:= ""
Local cErrDnf			:= ""
Local lJob				:= ""

conout("Rotina geraï¿½ï¿½o arquivos. . .")
If File(cCaminho + 'GNRE.txt')
	FErase(cCaminho + 'GNRE.txt')
	nHandle := FCreate(cCaminho + 'GNRE.txt')
	fclose(nHandle) 
Else
	nHandle := FCreate(cCaminho + 'GNRE.txt')
	fclose(nHandle) 
EndIf
 
//Buscar os pedidos do dia
cOrdem := " ORDER BY 1"
cQuery += " SELECT DISTINCT"
cQuery += " F2_FIMP [AUTORIZADO], D2_PEDIDO [PEDIDO], A1_COD [COD_CLIENTE], F2_DOC [DOC], F2_SERIE [SERIE], CAST(LTRIM(RTRIM(A1_NOME)) AS CHAR(50)) [NOME_CLI]"
cQuery += " , CASE WHEN LEN(A1_END) > 50 THEN SUBSTRING(LTRIM(RTRIM(A1_END)),1,50) ELSE LTRIM(RTRIM(A1_END)) END AS [ENDERECO]"
cQuery += " , CASE WHEN LEN(A1_END) > 50 THEN SUBSTRING(LTRIM(RTRIM(A1_END)),50,50) + '#Complemento do Endereço: ' + RTRIM(LTRIM(A1_COMPLEM))" 
cQuery += " WHEN RTRIM(LTRIM(A1_COMPLEM)) = '' THEN '' ELSE '#Complemento do Endereï¿½o: ' + RTRIM(LTRIM(A1_COMPLEM)) END AS [OBS]"
cQuery += " , A1_BAIRRO [BAIRRO] , A1_EST [UF], LTRIM(RTRIM(A1_MUN)) [CIDADE], SUBSTRING(A1_CEP,1,5) + '-' + SUBSTRING(A1_CEP,6,3) [CEP]"
cQuEry += ", CASE WHEN LEN(A1_CGC)>=13 THEN "
cQuery += " SUBSTRING(A1_CGC,1,2) + '.' + SUBSTRING(A1_CGC,3,3) + '.' + SUBSTRING(A1_CGC,6,3)+'/'+SUBSTRING(A1_CGC,9,4) + '-' + SUBSTRING(A1_CGC,13,2)"
cQuery += "ELSE"
cQuery += " SUBSTRING(A1_CGC,1,3) + '.' + SUBSTRING(A1_CGC,4,3) + '.' + SUBSTRING(A1_CGC,7,3) + '-' + SUBSTRING(A1_CGC,10,2) END[CPF]"
//cQuery += " , F2_TRANSP [TRANSPORTADORA], C5_XCANSAI [CANAL_SAIDA], C5_XEMKTPL [ETIQUETA_MKTPLACE]"
cQuery += " , F2_TRANSP [TRANSPORTADORA], C5_XCANSAI [CANAL_SAIDA], ' ' [ETIQUETA_MKTPLACE], SC5.R_E_C_N_O_ [RECNO]"
cQuery += " FROM "+RetSQLTAB("SF2")
cQuery += " INNER JOIN "+RetSQLTab("SD2")
cQuery += " ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE"
cQuery += " INNER JOIN "+RetSQLTab("SA1")
cQuery += " ON SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.D_E_L_E_T_ = ''"
cQuery += " INNER JOIN "+RetSQLTab("SC5")
cQuery += " ON SC5.C5_NUM = SD2.D2_PEDIDO AND SD2.D2_SERIE = SC5.C5_SERIE AND SC5.D_E_L_E_T_ = '' "
cQuery += " WHERE SF2.D_E_L_E_T_ = ''"
cQuery += " AND F2_DAUTNFE >= convert(varchar(08),GETDATE()-6,112)  "
//cQuery += " AND F2_DAUTNFE >= '20191001'  "
cQuery += " AND F2_XIMP <> 'S' "
IF cSerNF != "" .AND. VALTYPE(cSerNF) == "C"	//Trata a sÃ©rie da NF atravÃ©s de parÃ¢metros
	cQuery += "  AND F2_SERIE = "+cSerNF+" "
Else
	cQuery += "  AND F2_SERIE = '003'"
ENDIF
cQuery += "  AND C5_XCANSAI IN ("+cFiltro+")"
cQuery += cOrdem

//cQuery := "SELECT C5_XCANSAI [CANAL_SAIDA], 'S' AS AUTORIZADO, C5_XEMKTPL [ETIQUETA_MKTPLACE], C5_NUM [PEDIDO], * FROM SC5030 WHERE C5_NUM IN ('316430','316289')"
cQuery := changequery(cQuery)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), _cAlias, .F., .T. )

Do While  (_cAlias)->(!EOF())

cCanalSaida := (_cAlias)->CANAL_SAIDA
lErro := .F.
If !ExistDir("\Dossie\"+(_cAlias)->PEDIDO) 
	MakeDir("\Dossie\"+(_cAlias)->PEDIDO)
EndIf
If (_cAlias)->AUTORIZADO == "N"
	envEcom2("Nfe Rejeitada", "ATENÇÃO - REJEIÇÃO AO TRANSMITIR NFe", "Ocorreu uma rejeição na transmissão da NFe: " + (_cAlias)->DOC + " SÃ©rie: " +(_cAlias)->SERIE + ". Favor verificar no MONITOR do Protheus.",'',_cDestFat, _cCopy)

	//Adiciona S no campo F2_XIMP para nï¿½o fazer a transmissï¿½o novamente
	dbSelectArea("SF2")
	dbSetOrder(1)
	If MsSeek(xFilial("SF2") + (_cAlias)->DOC + (_cAlias)->SERIE )
		RecLock( "SF2", .F. )
		SF2->F2_XIMP := 'S'
		SF2->(MsUnlock())
	EndIf
	(_cAlias)->(dbSkip())
	LOOP
ElseIf (_cAlias)->AUTORIZADO == "S"
		//Monta os diretÃ³rios dos arquivos
		cDir := "\Dossie\"+(_cAlias)->PEDIDO+"\"
		cPrePed := "etiqueta_"+(_cAlias)->PEDIDO+".pdf"
		cPreDan	:= "danfe_"+(_cAlias)->SERIE+(_cAlias)->DOC+".pdf"

	If cCanalSaida $ '2|9|A'
		//----------------------------------------------------//
		//Etiqueta - Gera a etiqueta e salva na pasta /Dossie/
		//----------------------------------------------------//
		BEGIN SEQUENCE
			U_WSFAT001( .T., (_cAlias)->PEDIDO,  (_cAlias)->DOC,alltrim((_cAlias)->NOME_CLI),alltrim((_cAlias)->ENDERECO), alltrim((_cAlias)->BAIRRO), (_cAlias)->UF, alltrim((_cAlias)->CIDADE),  (_cAlias)->CEP, (_cAlias)->CPF, alltrim((_cAlias)->OBS), alltrim((_cAlias)->TRANSPORTADORA))
			conout("Gerou Etiqueta do pedido: "+ (_cAlias)->PEDIDO)
			Sleep( 15000 )
		END SEQUENCE

	
		//Verifica se gerou a etiqueta.
		IF !FILE(cDir+cPrePed)
			ErrorBlock(bError)
			lErro := .T.
			cData := SUBSTR(DTOC(date()),1,2) + SUBSTR(DTOC(date()),4,2) + SUBSTR(DTOC(date()),7,4) + "_"+SUBSTR(Time(),1,2)+SUBSTR(Time(),4,2)+SUBSTR(Time(),7,2)
			nLog := FCREATE(cDir+"ErrorLog_"+cData+".txt")
			cErrEtq := cError
			if nLog = -1
				conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
				CONOUT("Etiqueta do pedido " + (_cAlias)->PEDIDO+" nao foi gerada: "+cError)
			else
				FWrite(nLog,"Data: " + cData + CRLF + " Ocorreu o seguinte erro ao Gerar a etiqueta: " + CRLF + cError)
				FClose(nLog)
			endif
		ENDIF

		//Zera a Mensagem de erro.
		cError   := ""
		bError   := ErrorBlock({ |oError| cError := oError:Description})

		//----------------------------------------------------//
		//Danfe - Gera a Danfe e salva na pasta /Dossie/
		//----------------------------------------------------//
		BEGIN SEQUENCE
		GeraPDF( (_cAlias)->DOC,(_cAlias)->SERIE,(_cAlias)->PEDIDO)
		conout("Gerou Danfe. . .")
		Sleep( 10000 )
		END SEQUENCE

		IF !FILE(cDir+cPreDan)
			ErrorBlock(bError)
			lErro := .T.
			cData := SUBSTR(DTOC(date()),1,2) + SUBSTR(DTOC(date()),4,2) + SUBSTR(DTOC(date()),7,4) + "_"+SUBSTR(Time(),1,2)+SUBSTR(Time(),4,2)+SUBSTR(Time(),7,2)
			nLog := FCREATE(cDir+"ErrorLog_"+cData+".txt")
			cErrDnf := cError
			if nLog = -1
				conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
				CONOUT("DANFE do pedido " + (_cAlias)->PEDIDO+" nao foi gerada: "+cError)
			else
				FWrite(nLog, "Data: " +cData+ CRLF + " Ocorreu o seguinte erro ao Gerar a DANFE: " + CRLF + CRLF +" "+ cError)
				FClose(nLog)
			endif
		ENDIF

		//Zera a Mensagem de erro.
		cError   := ""
		bError   := ErrorBlock({ |oError| cError := oError:Description})

		
		//Salvar arquivo etiqueta e danfe no FTP
			IF FILE(cDir+cPreDan) .AND. FILE(cDir+cPrePed)		//Verifica se nÃ£o houve erro com a geraÃ§Ã£o dos arquivos.
				//Adiciona S no campo F2_XIMP para nï¿½o fazer a transmissï¿½o novamente
				/*dbSelectArea("SF2")
				dbSetOrder(1)
				If MsSeek(xFilial("SF2") + (_cAlias)->DOC + (_cAlias)->SERIE )
					RecLock( "SF2", .F. )
					SF2->F2_XIMP := 'S'
					SF2->(MsUnlock())
				EndIf	*/
			FTPCon( (_cAlias)->PEDIDO, (_cAlias)->DOC, (_cAlias)->SERIE)
			ELSE				
			//Se houver erro Pula o registro antes de marcar a flag da NF e segue a execuÃ§Ã£o.
			//Assim mantÃ©m a NF na fila de execuÃ§Ã£o das prÃ³ximas chamadas.
			//envEcom2("DANFE OU ETIQUETA NAO GERADA", "ATENÇÃO - OCORREU UM PROBLEMA AO GERAR DANFE/ETIQUETA", "Ocorreram os seguintes erros ao gerar a DANFE/Etiqueta do pedido: " + (_cAlias)->PEDIDO+" ."+CRLF+"Etiqueta: " +cErrEtq+CRLF+"Danfe: "+cErrDnf+CRLF+" Os dados nÃ£o foram enviados ao ftp.",'',_cDestFat, _cCopy)
			envEcom2("DANFE OU ETIQUETA NAO GERADA", "ATENÇÃO - OCORREU UM PROBLEMA AO GERAR DANFE/ETIQUETA", "Ocorreram os seguintes erros ao gerar a DANFE/Etiqueta do pedido: " + (_cAlias)->PEDIDO+" ."+CRLF+"Etiqueta: " +cErrEtq+CRLF+"Danfe: "+cErrDnf+CRLF+" Os dados não foram enviados ao ftp.",'',"alexsandro.lima@suryabrasil.com", "alexsandro.lima@suryabrasil.com")
			(_cAlias)->(dbSkip())
			LOOP
		ENDIF

	ElseIf  cCanalSaida $ '6|7|8'
		//---------------------------------------------------------------------||
		//Etiqueta - Converte a Hash no pedido e salva na pasta /Dossie/C5_NUM ||
		//---------------------------------------------------------------------||
		BEGIN SEQUENCE
			lJob := STARTJOB("U_xEtqMktPl",getenvserver(),.T.,xEmp,xFil,(_cAlias)->RECNO,.T.)
			CONOUT("Passou pelo job de etiqueta do marketplace")
		END SEQUENCE
		Sleep(5000)
		//Verifica se gerou a etiqueta.
		If !FILE(cDir+cPrePed)
			ErrorBlock(bError)
			lErro := .T.
			cData := SUBSTR(DTOC(date()),1,2) + SUBSTR(DTOC(date()),4,2) + SUBSTR(DTOC(date()),7,4) + "_"+SUBSTR(Time(),1,2)+SUBSTR(Time(),4,2)+SUBSTR(Time(),7,2)
			nLog  := FCREATE(cDir+"ErroThreadMktPlace"+cData+".txt")

			if nLog = -1
				conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
				CONOUT("Ocorreu um erro ao executar a thread de etiqueta de mktplace"+cError)
			else
				FWrite(nLog, "Data: " +cData+ CRLF + " Ocorreu o seguinte erro ao Gerar a Etiqueta: " + CRLF + CRLF +" "+ cError)
				FClose(nLog)
			endif
			//Envia o E-mail notificando a falha no processo
			envEcom2("ETIQUETA MARKETPLACE NAO GERADA!", "ATENÇÃO - OCORREU UM PROBLEMA AO GERAR A ETIQUETA DO MARKETPLACE", "Ocorreram os seguintes erros ao gerar a Etiqueta do pedido: " + (_cAlias)->PEDIDO+" ."+CRLF+"Etiqueta: " +cError+CRLF,'',_cDestFat, _cCopy)
			//envEcom2("ETIQUETA MARKETPLACE NAO GERADA!", "ATENÇÃO - OCORREU UM PROBLEMA AO GERAR A ETIQUETA DO MARKETPLACE", "Ocorreram os seguintes erros ao gerar a Etiqueta do pedido: " + (_cAlias)->PEDIDO+" ."+CRLF+"Etiqueta: " +cError+CRLF,'',"alexsandro.lima@suryabrasil.com", "alexsandro.lima@suryabrasil.com")
			
			(_cAlias)->(dbSkip()) //Pula o registro atual sem remover o mesmo da lista de chamadas.
			LOOP
		EndIf
		//Zera a Mensagem de erro.
		cError   := ""
		bError   := ErrorBlock({ |oError| cError := oError:Description})
		
		//----------------------------------------------------//
		//Danfe - Gera a Danfe e salva na pasta /Dossie/
		//----------------------------------------------------//
		BEGIN SEQUENCE
		GeraPDF( (_cAlias)->DOC,(_cAlias)->SERIE,(_cAlias)->PEDIDO)
		conout("Gerou Danfe. . .")
		Sleep( 10000 )
		END SEQUENCE

		IF !FILE(cDir+cPreDan)
			ErrorBlock(bError)
			lErro := .T.
			cData := SUBSTR(DTOC(date()),1,2) + SUBSTR(DTOC(date()),4,2) + SUBSTR(DTOC(date()),7,4) + "_"+SUBSTR(Time(),1,2)+SUBSTR(Time(),4,2)+SUBSTR(Time(),7,2)
			nLog := FCREATE(cDir+"ErrorLog_"+cData+".txt")
			cErrDnf := cError
			if nLog = -1
				conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
				CONOUT("DANFE do pedido " + (_cAlias)->PEDIDO+" nao foi gerada: "+cError)
			else
				FWrite(nLog, "Data: " +cData+ CRLF + " Ocorreu o seguinte erro ao Gerar a DANFE: " + CRLF + CRLF +" "+ cError)
				FClose(nLog)
			endif
			//Envia o E-mail notificando a falha no processo
			envEcom2("ETIQUETA MARKETPLACE NAO GERADA!", "ATENÇÃO - OCORREU UM PROBLEMA AO GERAR A ETIQUETA DO MARKETPLACE", "Ocorreram os seguintes erros ao gerar a Etiqueta do pedido: " + (_cAlias)->PEDIDO+" ."+CRLF+"Etiqueta: " +cError+CRLF,'',_cDestFat, _cCopy)
			//envEcom2("DANFE MARKETPLACE NAO GERADA!", "ATENÇÃO - OCORREU UM PROBLEMA AO GERAR A DANFE DE UM PEDIDO DO MARKETPLACE", "Ocorreram os seguintes erros ao gerar a DANFE do pedido: " + (_cAlias)->PEDIDO+" ."+CRLF+"DANFE: " +cError+CRLF,'',"alexsandro.lima@suryabrasil.com", "alexsandro.lima@suryabrasil.com")
			
			(_cAlias)->(dbSkip()) //Pula o registro atual sem remover o mesmo da lista de chamadas.
			LOOP				
		ENDIF

		//Zera a Mensagem de erro.
		cError   := ""
		bError   := ErrorBlock({ |oError| cError := oError:Description})

		//Salvar arquivo etiqueta e danfe no FTP
			IF !lErro		//Verifica se nÃ£o houve erro com a geraÃ§Ã£o dos arquivos.
				//Adiciona S no campo F2_XIMP para nï¿½o fazer a transmissï¿½o novamente
				/*dbSelectArea("SF2")
				dbSetOrder(1)
				If MsSeek(xFilial("SF2") + (_cAlias)->DOC + (_cAlias)->SERIE )
					RecLock( "SF2", .F. )
					SF2->F2_XIMP := 'S'
					SF2->(MsUnlock())
				EndIf*/
			FTPCon( (_cAlias)->PEDIDO, (_cAlias)->DOC, (_cAlias)->SERIE)
			ELSE				
			//Se houver erro Pula o registro antes de marcar a flag da NF e segue a execuÃ§Ã£o.
			//Assim mantÃ©m a NF na fila de execuÃ§Ã£o das prÃ³ximas chamadas.
			//envEcom2("DANFE OU ETIQUETA NAO GERADA", "ATENÇÃO - OCORREU UM PROBLEMA AO GERAR DANFE/ETIQUETA", "Ocorreram os seguintes erros ao gerar a DANFE/Etiqueta do pedido: " + (_cAlias)->PEDIDO+" ."+CRLF+"Etiqueta: " +cErrEtq+CRLF+"Danfe: "+cErrDnf+CRLF+" Os dados nÃ£o foram enviados ao ftp.",'',_cDestFat, _cCopy)
			envEcom2("DANFE OU ETIQUETA NAO GERADA", "ATENÃ‡ÃƒO - OCORREU UM PROBLEMA AO GERAR DANFE/ETIQUETA", "Ocorreram os seguintes erros ao gerar a DANFE/Etiqueta do pedido: " + (_cAlias)->PEDIDO+" ."+CRLF+"Etiqueta: " +cErrEtq+CRLF+"Danfe: "+cErrDnf+CRLF+" Os dados nÃ£o foram enviados ao ftp.",'',"alexsandro.lima@suryabrasil.com", "alexsandro.lima@suryabrasil.com")
			(_cAlias)->(dbSkip())
			LOOP
		ENDIF
	ELSEIF  cCanalSaida $ '5|'
		//Pedidos de funcionários!!
		BEGIN SEQUENCE
			GeraPDF( (_cAlias)->DOC,(_cAlias)->SERIE,(_cAlias)->PEDIDO)
			conout("Gerou Danfe. . .")
			Sleep( 10000 )
		END SEQUENCE
		//Verifica se não houve problemas para gerar a danfe.
		IF !FILE(cDir+cPreDan)
			ErrorBlock(bError)
			lErro := .T.
			cData := SUBSTR(DTOC(date()),1,2) + SUBSTR(DTOC(date()),4,2) + SUBSTR(DTOC(date()),7,4) + "_"+SUBSTR(Time(),1,2)+SUBSTR(Time(),4,2)+SUBSTR(Time(),7,2)
			nLog := FCREATE(cDir+"ErrorLog_"+cData+".txt")
			cErrDnf := cError
			if nLog = -1
				conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
				CONOUT("DANFE do pedido " + (_cAlias)->PEDIDO+" nao foi gerada: "+cError)
			else
				FWrite(nLog, "Data: " +cData+ CRLF + " Ocorreu o seguinte erro ao Gerar a DANFE: " + CRLF + CRLF +" "+ cError)
				FClose(nLog)
			endif
			//Envia o E-mail notificando a falha no processo
			//envEcom2("ETIQUETA MARKETPLACE NAO GERADA!", "ATENÇÃO - OCORREU UM PROBLEMA AO GERAR A ETIQUETA DO MARKETPLACE", "Ocorreram os seguintes erros ao gerar a Etiqueta do pedido: " + (_cAlias)->PEDIDO+" ."+CRLF+"Etiqueta: " +cError+CRLF,'',_cDestFat, _cCopy)
			envEcom2("DANFE FUNCIONARIO NAO GERADA!", "ATENÇÃO - OCORREU UM PROBLEMA AO GERAR A DANFE DE UM PEDIDO PARA FUNCIONARIOS!", "Ocorreram os seguintes erros ao gerar a DANFE do pedido: " + (_cAlias)->PEDIDO+" ."+CRLF+"DANFE: " +cError+CRLF,'',"alexsandro.lima@suryabrasil.com", "alexsandro.lima@suryabrasil.com")
			
			(_cAlias)->(dbSkip()) //Pula o registro atual sem remover o mesmo da lista de chamadas.
			LOOP				
		ENDIF

		//Zera a Mensagem de erro.
		cError   := ""
		bError   := ErrorBlock({ |oError| cError := oError:Description})

		BEGIN SEQUENCE
			xGeraPdf("etiqueta_"+(_cAlias)->PEDIDO,cDir)
			conout("Etiqueta de funcionario.....")
			sleep(10000)
		END SEQUENCE

		//Verifica se gerou a etiqueta.
		IF !FILE(cDir+cPrePed)
			ErrorBlock(bError)
			lErro := .T.
			cData := SUBSTR(DTOC(date()),1,2) + SUBSTR(DTOC(date()),4,2) + SUBSTR(DTOC(date()),7,4) + "_"+SUBSTR(Time(),1,2)+SUBSTR(Time(),4,2)+SUBSTR(Time(),7,2)
			nLog := FCREATE(cDir+"ErrorLog_"+cData+".txt")
			cErrEtq := cError
			if nLog = -1
				conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
				CONOUT("Etiqueta do pedido " + (_cAlias)->PEDIDO+" nao foi gerada: "+cError)
			else
				FWrite(nLog,"Data: " + cData + CRLF + " Ocorreu o seguinte erro ao Gerar a etiqueta: " + CRLF + cError)
				FClose(nLog)
			endif
		ENDIF

		//Zera a Mensagem de erro.
		cError   := ""
		bError   := ErrorBlock({ |oError| cError := oError:Description})
		
		IF !lErro
			FTPCon( (_cAlias)->PEDIDO, (_cAlias)->DOC, (_cAlias)->SERIE)
		ENDIF

	EndIf
ENDIF
(_cAlias)->(dbSkip())
ENDDO
		//Comentado por Alexsandro Salla 24/10/2019
		//Remover a geração de GNRE		
/*
	//Verificar se Documento gera GNRE
	__cQuery := ""
	__cQuery += " SELECT FT_NFISCAL [DOC], FT_SERIE [SERIE], FT_ESTADO [UF], SUM(FT_DIFAL) FT_DIFAL, SUM(FT_VFCPDIF) FT_VFCPDIF, SUM(FT_ICMSRET) FT_ICMSRET "
	__cQuery += " FROM " + RetSQLTAB("SFT")
	__cQuery += " WHERE D_E_L_E_T_ = '' " 
	__cQuery += " AND FT_NFISCAL = '" + (_cAlias)->DOC + "' " 
	__cQuery += " AND FT_SERIE = '"+ (_cAlias)->SERIE +"' "
	__cQuery += " GROUP BY FT_NFISCAL, FT_SERIE, FT_ESTADO "
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,__cQuery), _cAliasSFT, .F., .T. )
	dbSelectArea(_cAliasSFT)
	dbGoTop()
	
	conout("Verifica se tem GNRe. . .")
	//Estados que nï¿½o possuem GNRE
	If (_cAliasSFT)->FT_DIFAL == 0 .and. (_cAliasSFT)->FT_VFCPDIF == 0 .and. (_cAliasSFT)->FT_ICMSRET == 0

			If ExistDir(cCaminho + (_cAlias)->PEDIDO)
				aFiles := {}
				aArqXml := Directory(cCaminho + (_cAlias)->PEDIDO +"\*.pdf*", "D")
				
				aEval(aArqXml, {|x| aadd(aFiles,cCaminho + (_cAlias)->PEDIDO+"\"+x[1])})
				aEval(aFiles, { |x| FZIP(cCaminho + (_cAlias)->PEDIDO + "\" + (_cAlias)->PEDIDO + ".zip",aFiles,"\Dossie\")},1,len(aArqXml))
		
				envEcom2("Pedido - "+(_cAlias)->PEDIDO, "ATENÃ‡ÃƒO - ANEXO ARQUIVOS DO PEDIDO " + (_cAlias)->PEDIDO, "Favor verificar os arquivos em anexo." , cCaminho+(_cAlias)->PEDIDO+"\"+(_cAlias)->PEDIDO+".zip",_cDest,_cCopy)
				
				FErase(cCaminho+(_cAlias)->PEDIDO+"\"+(_cAlias)->PEDIDO+".zip")
				
				dbSelectArea(_cAliasSFT)
				dbCloseArea()
				
				//Adiciona S no campo F2_XIMP para nï¿½o fazer a transmissï¿½o novamente
				dbSelectArea("SF2")
				dbSetOrder(1)
				If MsSeek(xFilial("SF2") + (_cAlias)->DOC + (_cAlias)->SERIE )
					RecLock( "SF2", .F. )
					SF2->F2_XIMP := 'S'
					MsUnlock()
					SF2->(MsUnlock())
				EndIf
				
				//Salvar arquivo etiqueta e danfe no FTP
				FTPCon( (_cAlias)->PEDIDO, (_cAlias)->DOC, (_cAlias)->SERIE)
				
			EndIf
	
	//Excessï¿½es Fiscais - Estados com GNRE que nï¿½o transmitem pelo Protheus
	Elseif (_cAliasSFT)->UF $ "RJ-ES-BA-MT" .or. ( (_cAliasSFT)->UF $ "PR-GO" .and.  (_cAliasSFT)->FT_VFCPDIF <> 0)
			
			envEcom2("Nfe Autorizada rotina automatica", "ATENÇÃO - NFe AUTORIZADA", "O processo de transmissï¿½o da NFe " + (_cAlias)->DOC + " Sï¿½rie " +(_cAlias)->SERIE + " foi efetuada com sucesso. Por favor, prossiga com o processo de transmissï¿½o da GNRe.",cCaminho+(_cAlias)->PEDIDO+"\danfe_"+(_cAlias)->SERIE+(_cAlias)->DOC+".pdf",_cDestFat, _cCopy)
			
			//Adiciona S no campo F2_XIMP para nï¿½o fazer a transmissï¿½o novamente
			dbSelectArea("SF2")
			dbSetOrder(1)
			If MsSeek(xFilial("SF2") + (_cAlias)->DOC + (_cAlias)->SERIE )
				RecLock( "SF2", .F. )
				SF2->F2_XIMP := 'S'
				SF2->(MsUnlock())
			EndIf
			
	Else
			//----------------------------------------------------//
			//GNRE - Buscar da SF6 / Transmite e imprime
			//----------------------------------------------------//
			conout("Query GNRe. . .")
			_cQuery := ""
			_cQuery += " SELECT F6_NUMERO [NUM_GNRE], F6_DOC [DOC], F6_EST [ESTADO]  "
			_cQuery += " FROM "+RetSQLTab("SF6")
			_cQuery += " WHERE SF6.D_E_L_E_T_ = '' AND F6_DOC = '" + (_cAlias)->DOC + "' AND F6_SERIE = '"+ (_cAlias)->SERIE +"' AND F6_CLIFOR = '"+(_cAlias)->COD_CLIENTE+"'"
			_cQuery += " AND SF6.F6_EST NOT IN ("+nFilGNRE1+")"
			_cQuery += " AND CONCAT(F6_EST,F6_CODREC) NOT IN ("+nFilGNRE2+") "
			_cQuery += cOrdem
			_cQuery := changequery(_cQuery)
			
			dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), _cAliasSF6, .F., .T. )
			dbSelectArea(_cAliasSF6)
			dbGoTop()
			
			If Empty( (_cAliasSF6)->DOC )
				envEcom2("Documento nÃ£o gerou GNRE", "GNRE NÃƒO GERADA", "O documento " + (_cAlias)->DOC + " SÃ©rie " + (_cAlias)->SERIE + " nÃ£o gerou GNRE.", "" ,_cDestFat, _cCopy) //surya
				//dbSelectArea(_cAliasSF6)
				//dbCloseArea()
				(_cAlias)->(dbSkip())
				
			EndIf
			
			aRet:={}
			while (_cAliasSF6)->(!EOF())
					aadd(aRet, (_cAliasSF6)->NUM_GNRE)
					nHandle := fopen(cCaminho + 'GNRE.txt', FO_READWRITE + FO_SHARED)
					FSeek(nHandle, 0, FS_END)
					FWrite(nHandle, "-" + (_cAliasSF6)->NUM_GNRE)
					fclose(nHandle)
					(_cAliasSF6)->(dbSkip()) 
			enddo
			/*
			If !Empty(aRet)
				//----- GNRE - Transmissï¿½o -----//
				u_GnreTrans(aRet[1],aRet[len(aRet)],nAmbiente, ,(_cAlias)->UF)
				Sleep( 10000 )
				
				//----- GNRE - Monitora atï¿½ retornar -----//
				While cRetGnre <> "5"
					aRetGnre := u_getListBox(Padr(GetNewPar("MV_SPEDURL","http://"),250), aRet[1], aRet[len(aRet)], nAmbiente, '', (_cAlias)->UF )
					cRetGnre := aRetGnre[1][7]
					If cRetGnre == "3" .or. cRetGnre == "4"
						Exit
					ElseIf cRetGnre == "5"
					
						dbSelectArea("SF6")
						SF6->(dbSetOrder(1))
					
						if dbseek(xFilial("SF6") + (_cAliasSF6)->ESTADO + (_cAliasSF6)->NUM_GNRE )
							RecLock("SF6")
							SF6->F6_GNREWS := "S"
							SF6->F6_RECIBO := aRetGnre[1][8]   
							SF6->F6_CDBARRA:= aRetGnre[1][10]
							SF6->F6_NUMCTRL:= aRetGnre[1][9]
							MsUnlock()		
						endif	
					EndIf 
				Enddo
				
				//----- GNRE - Envia documento para impressora -----//
				u_Fisa095Imp( aRet[1], aRet[len(aRet)] )
				
			EndIf
			
			//Adiciona S no campo F2_XIMP para nï¿½o fazer a transmissï¿½o novamente
			dbSelectArea("SF2")
			dbSetOrder(1)
			If MsSeek(xFilial("SF2") + (_cAlias)->DOC + (_cAlias)->SERIE )
				RecLock("SF2", .F. )
				SF2->F2_XIMP := 'S'
				SF2->(MsUnlock())
			EndIf
		
			If Select(_cAliasSF6) > 0
				dbSelectArea(_cAliasSF6)
				dbCloseArea()
			EndIf
		
		EndIf
		
	EndIf
	
	If Select(_cAliasSFT) > 0
		dbSelectArea(_cAliasSFT)
		dbCloseArea()
	EndIf
	
	(_cAlias)->(dbSkip())
	
Enddo
*/
//If !empty(aRet)
	//Envia e-mail para Fiscal informando que os arquivos GNRE foram enviados para impressosa 
//	envEcom2("Arquivos GNRe enviados para impressora", "ARQUIVOS GNRE GERADOS COM SUCESSO!", "Os arquivos das GNREs em anexo foram gerados e enviados para impressora.",cCaminho + 'GNRE.txt',_cDestFat, _cCopy) //surya
//End

If Select(_cAlias) > 0
	dbSelectArea(_cAlias)
    dbCloseArea()    
EndIf

Return lRet        

/* ===============================================================================
Fonte	  -	SSCH002.prw
Funï¿½ï¿½o	  - SSCH003
Descriï¿½ï¿½o - Verifica se tem titulo pago no dia atual, caso tenha, envia os arquivos
			da Danfe e do pedido para Logistica.
Autor	  - Vinicius Martins
Data	  - 23/04/2019
=============================================================================== */

User Function SSCH003(aParam)
Local _cQuery		:= ""
Local cCaminho		:= ""
Local aFiles		:= {}
Local aArqXml		:= {}
Local _cAliasSE2	:= GetNextAlias()
Local cLocal		:= "/Dossie/"
local _cDest	    	:= GetMV("SB_DESTFTP")
local _cCopy	    	:= GetMV("SB_COPYFTP")

Private xEmp 		:= aParam[1]
Private xFil 		:= aParam[2] 

RPCSetType(3)
If FindFunction('WFPREPENV')
	lAuto := .T.
	RPCSetType( 3 )						// Nï¿½o consome licensa de uso
	wfPrepENV(xEmp, xFil)
Else
	lAuto := .T.
	RPCSetType( 3 )						// Nï¿½o consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil	
Endif

_cQuery := ""
_cQuery += " SELECT DISTINCT D2_PEDIDO [PEDIDO] "
_cQuery += " FROM " + RetSQLTab("SE2")
_cQuery += " JOIN " + RetSQLTab("SF6")
_cQuery += " ON SF6.F6_NUMERO = CONCAT(SE2.E2_PREFIXO,SE2.E2_NUM) AND SF6.D_E_L_E_T_ = '' "
_cQuery += " JOIN " + RetSQLTab("SD2")
_cQuery += " ON SD2.D2_DOC = SF6.F6_DOC AND SD2.D2_SERIE = SF6.F6_SERIE AND SD2.D_E_L_E_T_ = '' "
_cQuery += " WHERE SE2.D_E_L_E_T_ = '' "
_cQuery += " AND E2_BAIXA >= convert(varchar(08),GETDATE(),112) "
//_cQuery += " AND D2_PEDIDO = '312210' "
_cQuery += " ORDER BY 1 "
_cQuery := changequery(_cQuery)

dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), _cAliasSE2, .F., .T. )
dbSelectArea(_cAliasSE2)
dbGoTop()

Do While  (_cAliasSE2)->(!EOF())
	
	If ExistDir(cLocal + (_cAliasSE2)->PEDIDO)
		aFiles := {}
		aArqXml := Directory(cLocal + (_cAliasSE2)->PEDIDO +"\*.pdf*", "D")
		
		aEval(aArqXml, {|x| aadd(aFiles,cLocal + (_cAliasSE2)->PEDIDO+"\"+x[1])})
		aEval(aFiles, { |x| FZIP(cLocal + (_cAliasSE2)->PEDIDO + "\" + (_cAliasSE2)->PEDIDO + ".zip",aFiles,"\Dossie\")},1,len(aArqXml))

		envEcom2("Pedido - "+(_cAliasSE2)->PEDIDO, "ATENÃ‡ÃƒO - ANEXO ARQUIVOS DO PEDIDO " + (_cAliasSE2)->PEDIDO, "Favor verificar os arquivos em anexo." , cLocal+(_cAliasSE2)->PEDIDO+"\"+(_cAliasSE2)->PEDIDO+".zip",_cDest,_cCopy)
		
		FErase(cLocal+(_cAliasSE2)->PEDIDO+"\"+(_cAliasSE2)->PEDIDO+".zip")
		
	EndIf

	(_cAliasSE2)->(dbSkip())
	
Enddo

Return


Static Function GeraPDF(cNota,cSerie,cPedido)
	local cIdEnt:=GetIdEnt()
	local cFilePrint		:= "DANFE_"+cSerie+cNota
	local cCaminho			:="\Dossie\"+cPedido+"\"
	local _cDest	    	:= GetMV("SB_DESTFAT")
	local _cCopy	    	:= GetMV("SB_COPYFTP")
	//Local cCaminho := "E:\TESTEPROTHEUS\FCDOSSANTOS\protheus_data\Dossie\"+cPedido+"\"
	Local oSetup
	local nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
	//Alex Validar arquivos pdf
	Local aArqDnf := ""
	Local nI := 0
	private mv_par01:=cNota //de nf
	private mv_par02:=cNota //ate nf
	private mv_par03:=cSerie //serie
	private mv_par04:= 2 //tipo: 2-saida/1-entrada
	private mv_par05:=2//imprime no verso

	oSetup:=FWPrintSetup():New(nFlags, "DANFE")
	oSetup:SetPropert(PD_PRINTTYPE , 6)//ou 1 verificar
	oSetup:SetPropert(PD_ORIENTATION , 1)
	oSetup:SetPropert(PD_DESTINATION , 1)
	oSetup:SetPropert(PD_MARGIN , {60,60,60,60})
	oSetup:SetPropert(PD_PAPERSIZE , 2)
	oSetup:aOptions[PD_VALUETYPE]:=cCaminho

	FErase(oSetup:aOptions[PD_VALUETYPE]+cFilePrint+".pdf")
	oDanfe := FWMSPrinter():New(cFilePrint, IMP_SPOOL, .F. ,cCaminho, .T., , , , , .F., ,.F. , ) //FWMSPrinter():New(cFilePrint, IMP_PDF, .F. ,cCaminho, .T., , , , , .F., ,.F. , )
	oDanfe:lInJob:= .T.
	oDanfe:lServer := .T.
	oDanfe:lPDFAsPNG := .T.
	u_PrtNfSefS(cIdEnt,,,oDanfe, oSetup, cFilePrint)
	
	Sleep( 15000 ) //Surya

oDanfe := Nil
FreeObj(oSetup)
oSetup := Nil

aArqDnf := DIRECTORY(cCaminho+cFilePrint+".pdf","D")
//Valida se o arquivo existe e caso nÃ£o tenta 11 vezes  incluir o registro.
//Caso nÃ£o consiga envia um e-mail.

while (! File(cCaminho+cFilePrint+".pdf") .OR. aArqDnf[1][2] <= 30000) .And. nI <= 10
	oSetup:=FWPrintSetup():New(nFlags, "DANFE")
	oSetup:SetPropert(PD_PRINTTYPE , 6)//ou 1 verificar
	oSetup:SetPropert(PD_ORIENTATION , 1)
	oSetup:SetPropert(PD_DESTINATION , 1)
	oSetup:SetPropert(PD_MARGIN , {60,60,60,60})
	oSetup:SetPropert(PD_PAPERSIZE , 2)
	oSetup:aOptions[PD_VALUETYPE]:=cCaminho

	FErase(oSetup:aOptions[PD_VALUETYPE]+cFilePrint+".pdf")
	oDanfe := FWMSPrinter():New(cFilePrint, IMP_SPOOL, .F. ,cCaminho, .T., , , , , .F., ,.F. , ) //FWMSPrinter():New(cFilePrint, IMP_PDF, .F. ,cCaminho, .T., , , , , .F., ,.F. , )
	oDanfe:lInJob:= .T.
	oDanfe:lServer := .T.
	oDanfe:lPDFAsPNG := .T.
	u_PrtNfSefS(cIdEnt,,,oDanfe, oSetup, cFilePrint)
	
	Sleep( 15000 ) //Surya

	oDanfe := Nil
	FreeObj(oSetup)
	oSetup := Nil
	nI++
	aArqDnf := {}
	aArqDnf := DIRECTORY(cCaminho+cFilePrint+".pdf","D")
	If nI >= 10  .And. ! File(cCaminho+cFilePrint+".pdf") 
		envEcom2("Erro - Geração arquivo Danfe", "ATENÇÃO - ERRO AO GERAR ARQUIVO DA DANFE", "A danfe da nota fiscal " + cNota + " Série: " +cSerie + ", NÃO FOI GERADA!!!! Verifique a pasta Dossie! Data: "+DTOC(DATE())+ " , Hora: "+TIME(),'',_cDest, _cCopy)
			//envEcom2("Erro - GeraÃ§Ã£o arquivo Danfe", "ATENNÃ‡ÃƒO - ERRO AO GERAR ARQUIVO DA DANFE", "Houve erro durante a geraÃ§Ã£o do arquivo da Danfe: " + cNota + " SÃ©rie: " +cSerie + ", Data: "+DTOC(DATE())+ " , Hora: "+TIME(),'',"alexsandro.lima@suryabrasil.com", "alexsandro.lima@suryabrasil.com")
	
	ElseIf nI >= 10 .AND. aArqDnf[1][2] <= 30000
		FERASE(cCaminho+cFilePrint+".pdf")
			envEcom2("Erro - Geração arquivo Danfe", "ATENÇÃO - ERRO AO GERAR ARQUIVO DA DANFE", "A danfe da nota fiscal " + cNota + " Série: " +cSerie + ", foi gerada com erros e por isso foi excluída! Verifique a pasta Dossie! Data: "+DTOC(DATE())+ " , Hora: "+TIME(),'',_cDest, _cCopy)
			//envEcom2("Erro - GeraÃ§Ã£o arquivo Danfe", "ATENNÃ‡ÃƒO - ERRO AO GERAR ARQUIVO DA DANFE", "Houve erro durante a geraÃ§Ã£o do arquivo da Danfe: " + cNota + " SÃ©rie: " +cSerie + ", Data: "+DTOC(DATE())+ " , Hora: "+TIME(),'',"alexsandro.lima@suryabrasil.com", "alexsandro.lima@suryabrasil.com")
	EndIf
end	

return

/*************************
Obter Entidade da Empresa
**************************/
Static Function GetIdEnt()

Local aArea := GetArea()
Local cIdEnt := ""
Local cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local lMethodOk := .F.
Local oWsSPEDAdm

BEGIN SEQUENCE

IF !( CTIsReady(cURL) )
BREAK
EndIF

cURL := AllTrim(cURL)+"/SPEDADM.apw"

IF !( CTIsReady(cURL) )
BREAK
EndIF

oWsSPEDAdm := WsSPEDAdm():New()

oWsSPEDAdm:cUSERTOKEN := "TOTVS"
oWsSPEDAdm:oWsEmpresa:cCNPJ := SM0->( IF(M0_TPINSC==2 .Or. Empty(M0_TPINSC),M0_CGC,"") )
oWsSPEDAdm:oWsEmpresa:cCPF	:= SM0->( IF(M0_TPINSC==3,M0_CGC,"") )
oWsSPEDAdm:oWsEmpresa:cIE	:= SM0->M0_INSC
oWsSPEDAdm:oWsEmpresa:cIM	:= SM0->M0_INSCM
oWsSPEDAdm:oWsEmpresa:cNOME	:= SM0->M0_NOMECOM
oWsSPEDAdm:oWsEmpresa:cFANTASIA	:= SM0->M0_NOME
oWsSPEDAdm:oWsEmpresa:cENDERECO	:= FisGetEnd(SM0->M0_ENDENT)[1]
oWsSPEDAdm:oWsEmpresa:cNUM	:= FisGetEnd(SM0->M0_ENDENT)[3]
oWsSPEDAdm:oWsEmpresa:cCOMPL := FisGetEnd(SM0->M0_ENDENT)[4]
oWsSPEDAdm:oWsEmpresa:cUF	:= SM0->M0_ESTENT
oWsSPEDAdm:oWsEmpresa:cCEP	:= SM0->M0_CEPENT
oWsSPEDAdm:oWsEmpresa:cCOD_MUN	:= SM0->M0_CODMUN
oWsSPEDAdm:oWsEmpresa:cCOD_PAIS	:= "1058"
oWsSPEDAdm:oWsEmpresa:cBAIRRO	:= SM0->M0_BAIRENT
oWsSPEDAdm:oWsEmpresa:cMUN	:= SM0->M0_CIDENT
oWsSPEDAdm:oWsEmpresa:cCEP_CP	:= NIL
oWsSPEDAdm:oWsEmpresa:cCP := NIL
oWsSPEDAdm:oWsEmpresa:cDDD := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWsSPEDAdm:oWsEmpresa:cFONE := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWsSPEDAdm:oWsEmpresa:cFAX := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWsSPEDAdm:oWsEmpresa:cEMAIL := UsrRetMail(RetCodUsr())
oWsSPEDAdm:oWsEmpresa:cNIRE := SM0->M0_NIRE
oWsSPEDAdm:oWsEmpresa:dDTRE := SM0->M0_DTRE
oWsSPEDAdm:oWsEmpresa:cNIT := SM0->( IF(M0_TPINSC==1,M0_CGC,"") )
oWsSPEDAdm:oWsEmpresa:cINDSITESP	:= ""
oWsSPEDAdm:oWsEmpresa:cID_MATRIZ	:= ""
oWsSPEDAdm:oWsOutrasInscricoes:oWsInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWsSPEDAdm:_URL := cURL

lMethodOk := oWsSPEDAdm:AdmEmpresas()

DEFAULT lMethodOk := .F.

IF !( lMethodOk )
cError := IF( Empty( GetWscError(3) ) , GetWscError(1) , GetWscError(3) )
BREAK
EndIF

cIdEnt := oWsSPEDAdm:cAdmEmpresasResult

END SEQUENCE

RestArea(aArea)

Return( cIdEnt )

/******************************/
/* Funï¿½ï¿½o para envio de e-mail*/
/******************************/
Static Function envEcom2(cAssunto, cMensagem1, cMensagem2, cAnexo, cDest, cCopy)
			  oWorkFLW			 	 := TWEnviaEmail():New()
			  oWorkFLW:cConta        := "suryabrasil@shared.mandic.net.br"					    
			  oWorkFLW:cSenha        := "75XQF9qg"						
			  oWorkFLW:cDestinatario := cDest
			  oWorkFLW:cCopia		 := cCopy    
			  oWorkFLW:cServerSMTP   := "sharedrelay-cluster.mandic.net.br"						
			  oWorkFLW:cDiretorio	 := "\workflow\html\Error_Generic.txt"
			  oWorkFLW:cAnexo		 := cAnexo
			 
			  oWorkFLW:cAssunto      := cAssunto
			  oWorkFLW:aDadosHTML    := { { "##cAtencao##" ,cMensagem1 },;
			  							{ "##cMensagem##"  , cMensagem2} }
			  
			  oWorkFLW:EnviaEmail()
			  //Conout('E-mail de erro e-commerce enviado com sucesso')  
Return


Static Function FTPCon(cPedido, cNota, cSerie)
//User Function FTPCon()



Local cCaminho			:= "\Dossie\"
Local nX				:= 0
Local cServer 			:= "187.0.200.180"
Local nPorta 			:= 21 //nPorta 
Local cUser				:= "surya@2aliancas.com.br"
Local cPass				:= "2aliancas!!"
//Local aDir				:= {}
//Local cPedido			:= "315612"
//Local cNota				:= "000021881"
//Local cSerie			:= "003"
//aDir := Directory(cCaminho+cPedido+"\*.pdf*","D")

If	FTPConnect( cServer, nPorta, cUser, cPass )
	Conout('FTP conectado!')
	Conout('Diretorio FTP',FTPGetCurDir())
    Conout('FTPDirChange',FTPDirChange('/PDF/ETIQUETA'))
    FTPGetCurDir()
    FTPDirChange('/PDF/ETIQUETA')
	//aDir	:= FTPDIRECTORY( "*.pdf", )    
	FtpSetType(1)
	If !FTPUpload(cCaminho+cPedido+"\etiqueta_"+cPedido+".pdf", "etiqueta_"+cPedido+".pdf") 
    	conout("Problemas ao copiar etiqueta "+ cPedido) 
		lRet := .F.
		dbSelectArea("SF2")
		dbSetOrder(1)
		If MsSeek(xFilial("SF2") + cNota + cSerie )
			RecLock( "SF2", .F. )
				SF2->F2_XIMP := 'N'
			SF2->(MsUnlock())
		EndIf
	ELSE
		conout("Enviado ao FTP : "+ cPedido) 
		dbSelectArea("SF2")
		dbSetOrder(1)
		If MsSeek(xFilial("SF2") + cNota + cSerie  )
			RecLock( "SF2", .F. )
				SF2->F2_XIMP := 'S'
			SF2->(MsUnlock())
		EndIf
    EndIf
    FTPDisconnect()
       
    dbSelectArea("SC5")
	dbSetOrder(1)  
    If dbseek(xFilial("SC5")+cPedido)
		RecLock("SC5", .F.)  
		SC5->C5_XSTATUS := "5"
		MsUnlock()
	EndIf
	
EndIf

If	FTPConnect( cServer, nPorta, cUser, cPass )
	Conout('FTP conectado!')
	Conout('Diretorio FTP',FTPGetCurDir())
    Conout('FTPDirChange',FTPDirChange('PDF'))
    FTPGetCurDir()
    FTPDirChange('PDF')
	//aDir	:= FTPDIRECTORY( "*.pdf", )
	FtpSetType(1)
	If !FTPUpload(cCaminho+cPedido+"\danfe_"+cSerie+cNota+".pdf", "danfe_"+cSerie+cNota+".pdf") 
    	conout("Problemas ao copiar danfe "+ cSerie+" - "+cNota)
		lRet := .F.
		dbSelectArea("SF2")
		dbSetOrder(1)
		If MsSeek(xFilial("SF2") + cNota + cSerie  )
			RecLock( "SF2", .F. )
				SF2->F2_XIMP := 'N'
			SF2->(MsUnlock())
		EndIf
    EndIf
    FTPDisconnect()
    
    dbSelectArea("SC5")
	dbSetOrder(1)
    If dbseek(xFilial("SC5")+cPedido)
    	If SC5->C5_XSTATUS == "5"
    		RecLock("SC5", .F.) 
    		SC5->C5_XSTATUS :=  "9"
    		MsUnlock()
    	Else
    		RecLock("SC5", .F.) 
    		SC5->C5_XSTATUS :=  "4"
    		MsUnlock()
    	EndIf
	EndIf

EndIf

Return


Static Function xGeraPdf(cFile,cLocal) 
	/*cFile,cLocal,cMsg*/
	Local lAdjustToLegacy := .F.
	Local lDisableSetup  := .T.
	//Local cLocal          := "c:\teste\"
	Local oPrinter
	Local cFilePrint := ""
	Local cFileP := cFile+".PD_"
	//oPrinter := FWMSPrinter():New('orcamento_000000.PD_', IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	oPrinter := FWMSPrinter():New(cFileP, IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	oPrinter:Box( 60, 280, 20, 20, "-4")
	oPrinter:Say(32,25,"Pedido de Funcionário!")
	oPrinter:Say(44,25,"Por favor se atentar as informações complementares da NF")
	//cFilePrint := cLocal+"orcamento_000000.PD_"
	cFilePrint := cLocal+cFileP
	File2Printer( cFilePrint, "PDF" )
    oPrinter:cPathPDF:= cLocal 
	oPrinter:Preview()
Return