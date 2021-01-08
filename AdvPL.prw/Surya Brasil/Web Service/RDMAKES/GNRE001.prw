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
#INCLUDE "FISA095.CH" 

#define DS_MODALFRAME   128
#DEFINE IMP_SPOOL 2
#DEFINE VBOX       080
#DEFINE HMARGEM    030


/*{Protheus.doc} GnreTrans
Obtem o codigo da entidade apos enviar o post para o Totvs Service SOA

@author Simone dos Santos de Oliveira
@since 24.06.2015
@version 11.80

@param		cGNREIni	Número GNRE inicial
@param		cGNREFim	Número GNRE final
@param		cAmbiente	Ambiente de Transmissão (1-Produção / 2-Homologação)

*/
User function GnreTrans(cGNREIni,cGNREFim,cAmbiente, lEnd, cUf)

local aXML			:= {}
local aGNRE			:= {}
local aFieldDt		:= {}   
local aGnreOk		:= {}                                                     
local cRetorno		:= ""
local cAliasSF6		:= "SF6"
local cFiltro		:= ""
local cIndex		:= ""
local cNumGNRE		:= ""
local cIdGNRE		:= ""
local cWhere		:= ""
local lStatus		:= .F.
local nA			:= 0
local nX			:= 0
local nY			:= 0
local nB			:= 0

default cGNREIni	:= ""
default cGNREFim	:= ""
default cAmbiente	:= "" 

if !(empty(cGNREIni) .and. empty(cGNREFim) .and. empty(cAmbiente))

	dbSelectArea("SF6")
	SF6->(dbSetOrder(1))
	#IFDEF TOP

		if (TcSrvType ()<>"AS/400")
			lQuery    := .T.
			cAliasSF6 := GetNextAlias()

			aadd(aFieldDt,"F6_DTVENC")
			aadd(aFieldDt,"F6_DTPAGTO")	
			
			cWhere := "%"		
			cWhere += "SF6.F6_FILIAL='"+xFilial ("SF6")+"' AND"
			cWhere += " SF6.F6_NUMERO>='"+ cGNREIni +"' AND SF6.F6_NUMERO<='"+ cGNREFim +"' "
			cWhere += " AND (SF6.F6_TIPOIMP ='3' OR SF6.F6_TIPOIMP ='B') "
			if !empty(cUf)
			 	cWhere += "AND SF6.F6_EST = '"+cUf+"'"
			endif		
			cWhere += "AND SF6.D_E_L_E_T_ = '' "  	
			cWhere += "%"	
				

			BeginSql Alias cAliasSF6
				SELECT * FROM
					%Table:SF6% SF6
				WHERE
					%Exp:cWhere%
					
				ORDER BY %Order:SF6%
			EndSql
			for nX := 1 To Len(aFieldDt)
				TcSetField(cAliasSF6,aFieldDt[nX],"D",8,0)
			next nX
		else
	#EndIf
			cIndex  := CriaTrab(NIL,.F.)
			cFiltro := 'F6_FILIAL=="'+xFilial ("SF6")+'".And.'
			cFiltro += 'F6_NUMERO>="'+ cGNREIni +'".And. F6_NUMERO<="'+ cGNREFim +'" '
			cFiltro += '.And. (F6_TIPOIMP =="3" .Or. F6_TIPOIMP =="B")'
			cFiltro += '.And. F6_OPERNF =="2" '
			cFiltro += '.And. F6_EST == "'+cUf+'" '
			indregua (cAliasSF6, cIndex, SF6->(IndexKey ()),, cFiltro)
			nIndex := retindex(cAliasSF6)
			#IFNDEF TOP
				dbSetIndex(cIndex+OrdBagExt())
			#ENDIF
			dbSelectArea (cAliasSF6)
			dbSetOrder (nIndex+1)
	#IFDEF TOP
		endif
	#EndIf  

dbSelectArea (cAliasSF6)
(cAliasSF6)->(dbGoTop ())

	while !(cAliasSF6)->(eof ()) .And. (xFilial("SF6") == (cAliasSF6)->F6_FILIAL)
		
		IncProc("(2/2) " + STR0056 + (cAliasSF6)->F6_NUMERO) //"Transmitindo XML da GNRE: "
				
		aadd(aXML,{})
		nY := Len(aXML)
		aXML[nY] := ExecBlock("GnreXMLEnv",.F.,.F.,{cAliasSF6})
	
		(cAliasSF6)->(dbSkip())
	enddo
                     
	if len(aXML) > 0 
	
		dbSelectArea("SF6")
		SF6->(dbSetOrder(1))
		
		//Gravo o Id na tabela SF6
		for nB:= 1 to len( aXML )
		
			cIdGN	  := alltrim( aXML[nB,1] )
			cUFGnre   := alltrim( substr(cIdGN,1,2)  )
			cNumGN	  := alltrim( substr(cIdGN,3,len(cIdGN)-2))
			cXml	  := aXML[nB,2]
		
			if dbSeek(xFilial("SF6")+cUFGnre+cNumGN)
				RecLock("SF6",.F.)
					SF6->F6_IDTSS  := cIdGN
					SF6->F6_XMLENV := cXml
				MsUnlock()				
			endif
		next
		
		//Transmissão da GNRE
		cRetorno := RemesGnre(cAmbiente, aXML, @aGnreOk, cUf ) 
		
		//Atualiza o Status da GNRE		
		if len( aGnreOk ) > 0					
			for nY:=1 to len( aGnreOk )
			
				cIdGNRE  := alltrim( aGnreOk[nY,1] )
				cUFOk    := alltrim( substr(cIdGNRE,1,2)  )
				cNumGNRE := alltrim( substr(cIdGNRE,3,len(cIdGNRE)-2))
				
					
				if dbSeek(xFilial("SF6")+cUFOk+cNumGNRE)
					RecLock("SF6",.F.)
						SF6->F6_GNREWS := "T"
						SF6->F6_AMBIWS := cAmbiente
						SF6->F6_IDTSS  := cIdGNRE
					MsUnlock()				
				endif
			next 
		endif
	endif 
endif

#IFDEF TOP
	dbSelectArea(cAliasSF6)
	dbCloseArea()
#ELSE
	dbSelectArea(cAliasSF6)
	RetIndex(cAliasSF6)
	ferase(nIndex+OrdBagExt())
#ENDIF


return cRetorno

//-------------------------------------------------------------------
/*/{Protheus.doc} RemessaGnre
Função de Transmissão da GNRE para o TSS

@author Simone dos Santos de Oliveira
@since 24.06.2015
@version 11.80

@param		cAmbiente	Ambiente de Transmissão (1-Produção / 2-Homologação)
@param		aXML 		Array com Informações a serem transmitidas 
@param		aGnreOk	Array com as Gnres transmitidas


/*/
//-------------------------------------------------------------------
static function RemesGnre(cAmbiente, aXML, aGnreOk, cUf )

local aErroGnre		:= {} 
local cRetorno		:= ""
local cHoraIni		:= Time()
local dDataIni		:= date()
local nX			:= 0  
local nY			:= 0
local cIdEnt		:= GetIdEnt()

private cURL      := Padr(GetNewPar("MV_SPEDURL","http://"),250)

default cAmbiente	:= ""
default aXML		:= {}
default aGnreOk		:= {}


if len( aXML ) > 0
	oWS := WSTSSGNRE():New()
	oWS:cUSERTOKEN:= "TOTVS"
	oWS:cIDENT 	:= cIdEnt
	oWS:cAMBIENTE := cAmbiente
	oWS:cUF		:= cUf
	oWS:_URL		:= AllTrim(cURL)+"/TSSGNRE.apw"
   	oWS:oWSDOCS:oWSDOCUMENTOS := TSSGNRE_ARRAYOFREMESSADOCUMENTO():New()
		
	
	for nX:= 1 to len(aXML)
		aadd(oWS:OWSDOCS:OWSDOCUMENTOS:OWSREMESSADOCUMENTO,TSSGNRE_REMESSADOCUMENTO():NEW())
	     			 oWS:OWSDOCS:OWSDOCUMENTOS:OWSREMESSADOCUMENTO[nX]:CID := aXML[nX][1]
			         oWS:OWSDOCS:OWSDOCUMENTOS:OWSREMESSADOCUMENTO[nX]:CXML:= aXML[nX][2]
	next
	     
 	lOk := oWS:REMESSA()
 	
    if (lOk <> nil .Or. lOk )
    	for nY:= 1 to len( oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC )   
    	   	
	    	if type("oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC["+Str(nY)+"]:LSUCESSO")<>"U" 
	    		if !(oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC[nY]:LSUCESSO)
	  
					aadd(aErroGnre,{oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC[nY]:CID + " - " + oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC[1]:CERRO})
					
	                //Utilizar futuramente para tela de erro de schema na transmissão
	                //oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC[1]:CERRO 		
	    		else	
					aadd(aGnreOk,{oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC[nY]:CID})
				endif 
			endif
		next
		
		cRetorno := STR0028+CRLF //"Você concluíu com sucesso a transmissão do Protheus para o Totvs Services SPED." 
		cRetorno += STR0029+CRLF+CRLF //"Consulte o Status da(s) GNRE(s) utilizando a rotina 'Monitor'."	
		cRetorno += STR0030 +AllTrim(Str(Len(aGnreOk),18))+STR0031+IntToHora(SubtHoras(dDataIni,cHoraIni,Date(),Time()))+CRLF+CRLF//"Foram transmitidas "####" GNRE(s) em "#####
		
	else
		//Aviso("GNRE","Houve erro durante a transmissão para o Totvs Services SPED."	,{""},3)//"Houve erro durante a transmissão para o Totvs Services SPED."
		envEcom2("Erro - Transmissão GNRE", "ATENÇÃO - ERRO AO TRANSMITIR GNRE", "Houve erro durante a transmissão da Gnre: " + aXML[1][1],'')
	endif
	   
	if len( aErroGnre ) > 0
		cRetorno += STR0033+ CRLF+CRLF //"As GNRes abaixo foram recusadas, verifique a rotina 'Monitor' para saber os motivos."
		
		for nX:= 1 to len ( aErroGnre )
			cRetorno += aErroGnre[nX,1] + CRLF +  CRLF
		next
	endif      
    	
endif

return(cRetorno)                     


//-------------------------------------------------------------------
/*/{Protheus.doc} getListBox
Função que executa Monitoramento e retorna array para o listbox

@author Simone dos Santos de Oliveira
@since 24.06.2015
@version 11.80

@param		cURL		Endereço do Web Wervice no TSS 

/*/
//-------------------------------------------------------------------
User function getListBox(cUrl, cGnreIni, cGnreFim, cAmbGNRE, aRetErro, cUF)

local oOk			:= LoadBitMap(GetResources(), "ENABLE")
local oNo			:= LoadBitMap(GetResources(), "DISABLE")

local aRetorno		:= {}
local aListBox		:= {}
local aRetErro		:= {}
local aIdTss		:= {}
local cAviso		:= ''
local cIdIni		:= ''
local cIdFim		:= ''
local cId			:= ''
local cProtocolo	:= ''
local cRecomendacao	:= ''
local cAmbiente		:= ''
local cStatusTSS	:= ''  
local cNumControl	:= ''    
local cCodBarras	:= ''
local cWhere		:= ''
local cFiltro		:= ''
local cIndex		:= ''
local cAliasSF6		:= 'F0N'
local nX			:= 0
local nY			:= 0
local nA			:= 0

default cAmbGNRE	:= ''
default cGnreIni	:= ''
default cGnreFim	:= ''
default cUrl		:= ''


if !(empty(cUrl) .And. empty(cGnreIni) .And. empty(cGnreFim) .And. empty(cAmbGNRE))
	
	//Id para enviar para o TSS
	if empty(cUF)
		dbselectarea('SF6')
		SF6->(dbsetorder(1))
	
		#IFDEF TOP
	
			if (TcSrvType ()<>"AS/400")
				lQuery    := .T.
				cAliasSF6 := GetNextAlias()
	
				cWhere := "%"		
				cWhere += "SF6.F6_FILIAL = '"+xFilial ("SF6")+"' AND"
				cWhere += " SF6.F6_NUMERO>= '"+ cGnreIni +"' AND SF6.F6_NUMERO<= '"+ cGnreFim +"' "
				cWhere += " AND SF6.F6_IDTSS <> '' AND SF6.D_E_L_E_T_ = ''" 
				cWhere += "%"	
	
	
				BeginSql Alias cAliasSF6
					SELECT SF6.F6_FILIAL, SF6.F6_EST, SF6.F6_NUMERO, SF6.F6_IDTSS
					FROM %Table:SF6% SF6 WHERE %Exp:cWhere% ORDER BY %Order:SF6%
				EndSql
				
			else
		#EndIf
				cIndex  := CriaTrab(NIL,.F.)
				cFiltro := 'F6_FILIAL=="'+xFilial ("SF6")+'".And.'
				cFiltro += 'F6_NUMERO >="'+ cGnreIni +'".And. SF6.F6_NUMERO <="'+ cGnreFim +'" '
				cFiltro += '.And. F6_IDTSS <> "" '
				indregua (cAliasSF6, cIndex, SF6->(IndexKey ()),, cFiltro)
				nIndex := retindex(cAliasSF6)
				#IFNDEF TOP
					dbSetIndex(cIndex+OrdBagExt())
				#ENDIF
				dbSelectArea (cAliasSF6)
				dbSetOrder (nIndex+1)
		#IFDEF TOP
			endif
		#EndIf  
	
	
		dbSelectArea (cAliasSF6)
		(cAliasSF6)->(dbGoTop ())
		 
		while !(cAliasSF6)->(eof ())
			
			aadd(aIdTss,{})	
			nA := len(aIdTss)
				
			aadd(aIdTss[nA],alltrim((cAliasSF6)->F6_IDTSS))
			
			(cAliasSF6)->(dbSkip())
		enddo	
		
		if len(aIdTss) > 0 //pego o primeiro e o ultimo id
			cIdIni		:= aIdTss[1,1]
			cIdFim		:= aIdTss[len(aIdTss),1]
		endif
		
	else // Informou UF
	
		cIdIni	:= cUF + cGnreIni
		cIdFim	:= cUF + cGnreFim

	endif
	Sleep( 30000 ) //Surya
	//Comunicação com o TSS
	aRetorno	:= RetMonitor(cUrl, cIdIni, cIdFim, cAmbGNRE ,@cAviso)

	if empty(cAviso)
	
		for nX := 1 to len(aRetorno)
			
			cId				:= alltrim( aRetorno[nX][1] )
			cAmbiente		:= alltrim( aRetorno[nX][2] )
			cRecomendacao	:= alltrim( aRetorno[nX][3] )
			cProtocolo		:= alltrim( aRetorno[nX][4]	) 
			cStatusTSS		:= alltrim( aRetorno[nX][7]	)	
			cErroXML		:= alltrim( aRetorno[nX][14])
			cNumControl		:= alltrim( aRetorno[nX][15]) 
			cCodBarras		:= alltrim( aRetorno[nX][16])
			
							
			aadd(aListBox,{	iif(cStatusTSS<>"5",oNo,oOk),;
								cId,;
								iif(cAmbiente == "1","Produção","Homologação"),; 							
								cProtocolo,;
								cRecomendacao,;
								cNumControl,;
								cStatusTSS,;
								cProtocolo,;
								cNumControl,;
								cCodBarras,;
							}) //len(alistbox[1])
								
			//Se tiver erro, gravo o Id e o XML para apresentar nas Mensagens do lote
			if ! empty( cErroXML )
				aadd(aRetErro,{ cId, cErroXML})
			endif
			
			//Se o retorno for Não autorizado / Autorizado pela SEFAZ atualizo a SF6
			if cStatusTSS $"4#5"
	
				dbSelectArea("SF6")
				SF6->(dbSetOrder(1))
					
				if dbseek(xFilial("SF6")+ subStr(cId,1,2)+ subStr(cId,3,len(cId)-2))
					RecLock("SF6")
						SF6->F6_GNREWS := iif(cStatusTSS=='5',"S","N")
						SF6->F6_RECIBO := cProtocolo   
						SF6->F6_CDBARRA:= cCodBarras
						SF6->F6_NUMCTRL:= cNumControl
					MsUnlock()		
				endif							
			endif
		next
    
	    if empty(aListBox[1,2])
	    	Aviso("GNRE",STR0045,{STR0025}) //"Nao ha dados"   
	    endif
	else
		Aviso("GNRE",STR0045,{STR0025})	 //"Nao ha dados"
	endif
endif

if empty( cUF )
	#IFDEF TOP
		dbSelectArea(cAliasSF6)
		dbCloseArea()
	#ELSE
		dbSelectArea(cAliasSF6)
		RetIndex(cAliasSF6)
		ferase(nIndex+OrdBagExt())
	#ENDIF
endif

Return aListBox

//-------------------------------------------------------------------
/*/{Protheus.doc} RetMonitor
Função que executa Monitoramento

@author Simone dos Santos de Oliveira
@since 24.06.2015
@version 11.80

@param		cURL		Endereço do Web Wervice no TSS 

/*/
//-------------------------------------------------------------------
static function RetMonitor(cUrl, cIdIni, cIdFim, cAmbGNRE ,cAviso)

local aRetMnt		:= {}
local cIdGNRE		:= ""   
local cAmb			:= ""  
local cDesc			:= ""  
local cRecibo		:= ""  
local cResultado	:= ""  
local cLote			:= ""  
local cStatus		:= ""  
local cHrEnvSef		:= ""  
local cHrEnvTSS		:= ""  
local cHrRecSef		:= "" 
local cXMLErro		:= ""  
local cNumContro	:= "" 
local cCodBarras	:= ""
local dDtEnvSef		:= SToD ("  /  /  ")
local dDtEnvTSS		:= SToD ("  /  /  ")
local dDtRecSef		:= SToD ("  /  /  ")  
local lOk			:= .F. 
local nX			:= 0 

Local cIdEnt 		:= GetIdEnt() //Surya

default cUrl		:= ""
default cIdIni		:= ""
default cIdFim 		:= ""
default cAmbGNRE	:= ""
default cAviso		:= "" 


oWS:= WSTSSGNRE():New()
oWS:cUSERTOKEN:= "TOTVS"
oWS:cIDENT 	:= cIdEnt
oWS:cAMBIENTE := cAmbGNRE
oWS:_URL		:= AllTrim(cURL)+"/TSSGNRE.apw"
oWS:cIDINI		:= cIdIni
oWS:cIDFIM		:= cIdFim
oWS:oWSMONITORRESULT:oWSDOCUMENTOS := TSSGNRE_ARRAYOFMONITORRETDOC():New()

aadd(oWS:oWSMONITORRESULT:oWSDOCUMENTOS:oWSMONITORRETDOC,TSSGNRE_MONITORRETDOC():New())

 	lOk := oWS:MONITOR()
 	 	
 	if (lOk <> nil .Or. lOk) .And. type("oWS:OWSMONITORRESULT:OWSDOCUMENTOS:OWSMONITORRETDOC")<>"U"	
    
    	oRetorno:=	oWS:OWSMONITORRESULT:OWSDOCUMENTOS:OWSMONITORRETDOC
    		
   		for nX:= 1 to len( oRetorno ) 
			
			cIdGNRE	:= oRetorno[nX]:CID   
			cAmb		:= oRetorno[nX]:CAMBIENTE
			cDesc		:= oRetorno[nX]:CDESCRICAO
			cRecibo		:= oRetorno[nX]:CRECIBO	
			cResultado	:= oRetorno[nX]:CRESULTADO
			cLote		:= oRetorno[nX]:CLOTE
			cStatus		:= oRetorno[nX]:CSTATUS
			cHrEnvSef	:= oRetorno[nX]:CHRENVSEF
			cHrEnvTSS	:= oRetorno[nX]:CHRENVTSS
			cHrRecSef	:= oRetorno[nX]:CHRRECSEF
			dDtEnvSef	:= oRetorno[nX]:DDTENVSEF
			dDtEnvTSS	:= oRetorno[nX]:DDTENVTSS
			dDtRecSef	:= oRetorno[nX]:DDTRECSEF  
			cXMLErro	:= oRetorno[nX]:CXMLERRO
			cNumContro	:= oRetorno[nX]:CNUMCONTRO
			cCodBarras	:= oRetorno[nX]:CCODBARRAS
			                                           
			//dados para atualizaçao da base
			aadd(aRetMnt, {	cIdGNRE,;
								cAmb,;
								cDesc,;
								cRecibo,;	
								cResultado,;
								cLote,;
								cStatus,;
								cHrEnvSef,;
								cHrEnvTSS,;
								cHrRecSef,;
								dDtEnvSef,;
								dDtEnvTSS,;
								dDtRecSef,;
								cXMLErro,;
								cNumContro,;
								cCodBarras})
								
			If cStatus = "4" //Surya
				cErro := substr(cXMLErro,at("<DESCRICAO>",cXMLErro)+11,at("</DESCRICAO>",cXMLErro))
				cErro := substr(cErro,1,at("</DESCRICAO>",cErro)-1)
				envEcom2("GNRe - Rejeição da Sefaz", "ATENÇÃO - REJEIÇÃO DA SEFAZ PARA O DOCUMENTO " + cIdGNRE, "Rejeição: " + cErro,'')
			ElseIf cStatus = "3" //Surya
				//cErro := substr(cXMLErro,at("<DESCRICAO>",cXMLErro)+11,at("</DESCRICAO>",cXMLErro))
				//cErro := substr(cErro,1,at("</DESCRICAO>",cErro)-1)
				envEcom2("GNRe - Falha de Schema", "ATENÇÃO - VERIFICAR XML DO DOCUMENTO " + cIdGNRE, "",'')
			EndIf
			
		Next 
		
	Else
		cAviso := iif( empty(getWscError(3)),getWscError(1),getWscError(3) )
	EndIf  

Return aRetMnt

//-------------------------------------------------------------------
/*/{Protheus.doc} Fisa095Imp
Realiza impressão da GNRE

@author Simone dos Santos de Oliveira
@since 07/03/2016
@version 1.0

/*/
//-------------------------------------------------------------------
User function Fisa095Imp(cGNREIni,cGNREFim)

local oImpGNRE
local oSetup

Local cIdEnt 		:= GetIdEnt() //Surya 

local aDevice    := {}

local cFilePrint := "GNRE"//"GNRE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")
local cSession   := GetPrinterSession()

local nDevice
local nRet 			:= 0
local nHRes  		:= 0
local nVRes  		:= 0

private cURL      := Padr(GetNewPar("MV_SPEDURL","http://"),250) //Surya

AADD(aDevice,"DISCO") // 1
AADD(aDevice,"SPOOL") // 2
AADD(aDevice,"EMAIL") // 3
AADD(aDevice,"EXCEL") // 4
AADD(aDevice,"HTML" ) // 5
AADD(aDevice,"PDF"  ) // 6
                                                                        
nLocal  		:= if(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 ) //nLocal  		:= if(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nOrientation 	:= 1 //Retrato
cDevice     	:= "SPOOL" //"PDF"//if(empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
nPrintType    := ascan(aDevice,{|x| x == cDevice })

If IsReadyGNRE( cUrl )
	
	lAdjustToLegacy := .F. // Inibe legado de resolucao com a TMSPrinter
	oImpGNRE := FWMSPrinter():New(cFilePrint, IMP_SPOOL, lAdjustToLegacy, , .T.) //FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, '\Dossie\', .T.)
	
	// ----------------------------------------------
	// Cria e exibe tela de Setup Customizavel
	// OBS: Utilizar include "FWPrintSetup.ch"
	// ----------------------------------------------
	nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN + PD_DISABLEORIENTATION
	
	if findfunction("PRTGNRE")
		if ( !oImpGNRE:lInJob )
			oSetup := FWPrintSetup():New(nFlags, "GNRE")
			// ----------------------------------------------
			// Define saida
			// ----------------------------------------------
			oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
			oSetup:SetPropert(PD_ORIENTATION , nOrientation)
			oSetup:SetPropert(PD_DESTINATION , nLocal)
			oSetup:SetPropert(PD_MARGIN      , {60,60,60,60}) 
			oSetup:SetPropert(PD_PAPERSIZE   , 2)
	
		endif
		
			//Salva os Parametros no Profile  
	        //fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==1   ,"SERVER"   ,"CLIENT"       ), .T. )

	        PrtGNRE(cIdEnt, oImpGNRE, oSetup, cFilePrint, cGNREIni,cGNREFim)		
	else
		msginfo("RDMAKE FISA119 nao encontrado, relatorio nao sera impresso!")
	endif	
endif

oImpGNRE:= nil
oSetup  := nil

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} PrtGNRE
Rotina de impressao GNRE

@author Simone dos Santos de Oliveira
@since 07/03/2016

/*/
//-------------------------------------------------------------------
static function PrtGNRE(cIdEnt, oImpGNRE, oSetup, cFilePrint, cGNREIni,cGNREFim)

local aArea      := GetArea()
local lExistGnre := .F. 

private nConsNeg := 0.4 // Constante para concertar o calculo retornado pelo GetTextWidth para fontes em negrito.
private nConsTex := 0.5 // Constante para concertar o calculo retornado pelo GetTextWidth.

oImpGNRE:SetResolution(78) //Tamanho estipulado para a impressao da GNRE
oImpGNRE:SetPortrait()
oImpGNRE:SetPaperSize(DMPAPER_A4)
oImpGNRE:SetMargin(60,60,60,60)
//oImpGNRE:lServer := oSetup:GetProperty(PD_DESTINATION)==AMB_SERVER

// ----------------------------------------------
// Define saida de impressao
// ----------------------------------------------

//if oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
	oImpGNRE:nDevice := IMP_SPOOL
	// ----------------------------------------------
	// Salva impressora selecionada
	// ----------------------------------------------
	//fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
	//oImpGNRE:cPrinter := oSetup:aOptions[PD_VALUETYPE]
	oImpGNRE:cPrinter := "\\192.168.2.1\Kyocera 306i Quantic"
//elseif oSetup:GetProperty(PD_PRINTTYPE) == IMP_PDF
//	oImpGNRE:nDevice := IMP_PDF
	// ----------------------------------------------
	// Define para salvar o PDF
	// ----------------------------------------------
//	oImpGNRE:cPathPDF := '\Dossie\' //oSetup:aOptions[PD_VALUETYPE]
//endif

private PixelX := oImpGNRE:nLogPixelX()
private PixelY := oImpGNRE:nLogPixelY()


GnreProc(@oImpGNRE,'',cIdEnt,@lExistGnre,cGNREIni,cGNREFim)

if lExistGnre
	oImpGNRE:lInJob 	:= .T.
	oImpGNRE:lServer 	:= .T.
	//oImpGNRE:cPathPDF := '\Dossie\'
	oImpGNRE:Preview()//Visualiza antes de imprimir
else
	Aviso('GNRE','Nenhuma GNRE a ser impressa nos parametros utilizados.',{'OK'},3)
	envEcom2("Erro - Geração arquivo GNRe", "ATENÇÃO - ERRO AO GERAR ARQUIVO GNRE", "Houve erro durante a geração do arquivo GNRe: " + cGNREIni,'') //surya
endif

freeobj(oImpGNRE)
oImpGNRE := nil
RestArea(aArea)
return(.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} GnreProc
Rotina de impressao GNRE

@author Simone dos Santos de Oliveira
@since 07/03/2016

/*/
//-------------------------------------------------------------------
static function GnreProc(oImpGNRE,lEnd,cIdEnt,lExistGnre,cGNREIni,cGNREFim) 

local aAreaSF6		:= {}
local aPerg   		:= {}
local aGnre			:= {}
local aArea			:= GetArea()
local aParam  		:= {space(len(SF6->F6_NUMERO)),space(len(SF6->F6_NUMERO)),Space(Len(SF6->F6_EST))}

local cNaoAut		:= ''
local cAliasGNRE	:= GetNextAlias() 
//local cGnreIni		:= ''
//local cGnreFim		:= ''
local cUFGnre		:= ''
local cWhere		:= ''
local cAutoriza  	:= ''
//local cCondicao		:= ''
local cIndex	 	:= ''
//local cParGnreImp	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"FISA119IMP"
//local cTela			:= "Impressao GNRE " 
local cIdGuia		:= ''
local cXmlGnre		:= ''

local lQuery		:= .F.
local lOkParam		:= .T. //Surya

local oGnre			:= nil

//local nLenNotas
local nIndex		:= 0
local nX			:= 0

MV_PAR01 := cGNREIni //MV_PAR01 := aParam[01] := PadR(ParamLoad(cParGnreImp,aPerg,1,aParam[01]),len(SF6->F6_NUMERO)) 
MV_PAR02 := cGNREFim //MV_PAR02 := aParam[02] := PadR(ParamLoad(cParGnreImp,aPerg,2,aParam[02]),len(SF6->F6_NUMERO))
//MV_PAR03 := aParam[03] := PadR(ParamLoad(cParGnreImp,aPerg,3,aParam[03]),Len(SF6->F6_EST))

if lOkParam
	
	cGnreIni	:= alltrim(MV_PAR01)
	cGnreFim	:= alltrim(MV_PAR02)
	cUFGnre		:= ''
	
	dbSelectArea("SF6")
	dbSetOrder(1)	
	
	#IFDEF TOP
				
		lQuery		:= .T.
		
		cWhere := "%"		
		cWhere += "SF6.F6_FILIAL = '"+xFilial ("SF6")+"' AND"
		cWhere += " SF6.F6_NUMERO>= '"+ cGnreIni +"' AND SF6.F6_NUMERO<= '"+ cGnreFim +"' " 
		if ! empty(cUFGnre)
			cWhere		+= " AND SF6.F6_EST = '" + cUFGnre + "' " 
		endif 
		cWhere		+= " AND SF6.F6_GNREWS = 'S' "  //Somente autorizada
		cWhere		+= " AND SF6.D_E_L_E_T_ = ''" 
		cWhere		+= ' %' 
		

		BeginSql Alias cAliasGNRE
			SELECT	* FROM  %Table:SF6% SF6 WHERE %Exp:cWhere% ORDER BY %Order:SF6%
		EndSql
							
	#ELSE
		cIndex    		:= CriaTrab(NIL, .F.)
		cChave			:= IndexKey(1)
		cCondicao 		:= 'F6_FILIAL == "' + xFilial("SF6") + '" .And. '
		cCondicao 		+= 'SF6->F6_NUMERO >= "'+ cGnreIni+'" .And. '
		cCondicao 		+= 'SF6->F6_NUMERO <="'+ cGnreFim+'" .And. '
		if ! empty(cUFGnre)
			cCondicao	+= 'SF6->F6_EST =="'+ cUFGnre+'" .And. '
		endif
		cCondicao		+= 'SF6->F6_GNREWS == "S"  '
		IndRegua(cAliasGNRE, cIndex, cChave, , cCondicao)
		nIndex := RetIndex(cAliasMDF)
        dbsetindex(cIndex + OrdBagExt())
        dbsetorder(nIndex + 1)
		dbgotop()
	
	#ENDIF
	
	while !(cAliasGNRE)->(Eof())
		
		aadd(aGnre,{})
		aadd(atail(aGnre),(cAliasGNRE)->F6_IDTSS)  //id TSS
		aadd(atail(aGnre),(cAliasGNRE)->F6_CDBARRA)//Codigo de Barras
		aadd(atail(aGnre),(cAliasGNRE)->F6_NUMCTRL)//Codigo de Barras
		
		nRecno	:= (cAliasGNRE)->R_E_C_N_O_
	
		dbselectarea('SF6')
		//Tratamento para campo Memo
		SF6->(dbgoto(nRecno))	
		
		aadd(atail(aGnre),SF6->F6_XMLENV) //XML enviado para TSS
		
		dbclosearea('SF6')
				 				
		(cAliasGNRE)->(dbSkip())
		
	enddo	
		
	if len(aGnre) > 0
		aAreaSF6 := SF6->(GetArea())
				
		for nX := 1 to len(aGnre)
			
			if ! empty( aGnre[nX][2])  //Codigo de Barras
				
				cIdGuia  := alltrim(aGnre[nX][1])
				cAutoriza:= alltrim(aGnre[nX][2])
				cNumCtrl := alltrim(aGnre[nX][3])
				cXmlGnre := alltrim(aGnre[nX][4])   //xml enviado TSS
				
				ImpDetGnre(@oImpGNRE,cAutoriza,cXmlGnre,cNumCtrl)
				lExistGnre := .T.
				
				oGnre      := nil
			else
			
				cNaoAut += aGnre[nX][1]+aGnre[nX][2]+CRLF
			
			endif
			
		next nX
		
		RestArea(aAreaSF6)
		delclassintf()
	endif
	if !lQuery
		dbclearfilter()
		ferase(cIndex+OrdBagExt())
	endif
	if !Empty(cNaoAut)
		Aviso('GNRE','As seguintes GNREs foram autorizadas, porem nao contem Codigo de Barras: '+CRLF+CRLF+cNaoAut ,{'Ok'},3) 
	endif

endif

RestArea(aArea)
return(.T.)


//----------------------------------------------------------------------
/*/{Protheus.doc} ImpDetGnre
Controle do Fluxo do relatorio.

@author Simone Oliveira
@since 10/03/2016
@version 1.0 

/*/
//-----------------------------------------------------------------------
static function ImpDetGnre(oImpGNRE, cAutoriza, cXmlGnre, cNumCtrl)
	
private oFont07    	:= TFont():New('Arial',07,07,,.F.,,,,.T.,.F.)	//Fonte Arial 07
private oFont07N   	:= TFont():New('Arial',07,07,,.T.,,,,.T.,.F.)	//Fonte Arial 07
private oFont08		:= TFont():New('Arial',08,08,,.F.,,,,.T.,.F.)
private oFont08N	:= TFont():New('Arial',08,08,,.T.,,,,.T.,.F.)
private oFont10		:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.)
private oFont10N	:= TFont():New('Arial',10,10,,.T.,,,,.T.,.F.)
private oFont12N   	:= TFont():New('Arial',12,12,,.T.,,,,.T.,.F.)	//Fonte Arial 12 Negrito
private oFont14N   	:= TFont():New('Arial',14,14,,.T.,,,,.T.,.F.)	//Fonte Arial 14 Negrito

PrtGnreWS(@oImpGNRE, cAutoriza, cXmlGnre, cNumCtrl)

return(.T.)


//-----------------------------------------------------------------------
/*/{Protheus.doc} PrtDamdfe
Impressao do formulario DANFE grafico conforme laytout no formato retrato

@author Simone Oliveira
@since 10/03/2016
@version 1.0 

@return .T.
/*/
//-----------------------------------------------------------------------
static function PrtGnreWS(oImpGNRE, cAutoriza, cXmlGnre, cNumCtrl)

local oGnreXml:= nil

local cCab			:= 'Guia Nacional de Recolhimento de Tributos Estaduais - GNRE'
local cUfFav		:= ''
local cCodRec		:= ''
local cRazEmi		:= ''
local cCnpjCpfEm	:= ''
local cEndEmi		:= ''
local cMunEmi		:= ''
local cUfEmi		:= ''	
local cCepEmi		:= ''	
local cTelEmi		:= ''	
local cDocOrig		:= ''
local cCnpjCpfDs	:= ''
local cMunDest		:= ''
local cPerRef		:= ''
local cParcela		:= ''
local cValPrinc		:= ''
local cConvenio		:= ''
local cProduto		:= ''
local cAtuMon		:= ''
local cInfCompl		:= ''
local cJuros		:= ''
local cMulta		:= ''
local cTotRec		:= ''
local cVia			:= ''
local cDtVenc		:= ''

local nX			:= 0
local nBox1			:= 0
local nBox2			:= 0
local nBox3			:= 0
local nBox4			:= 0
local nSay1			:= 0
local nSay2			:= 0

//Inicializacao do objeto grafico 
if oImpGNRE == nil
	lPreview := .T.
	oImpGNRE 	:= FWMSPrinter():New('GNRE', IMP_SPOOL)
	oImpGNRE:SetPortrait()
	oImpGNRE:Setup()
endif
	
//Inicializacao da pagina do objeto grafico
oImpGNRE:StartPage()
nHPage := oImpGNRE:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oImpGNRE:nVertRes()
nVPage *= (300/PixelY)
nVPage -= VBOX

for nX:= 1 to 2 //Gera via Banco e Contribuinte

	//Alimentando as variaveis
	if ! empty( cXmlGnre )
		oGnreXml := XmlParser(NoAcentReco(cXmlGnre),"","","")
	else //Tratamento casa haja algum erro no retorno do xml
		Alert('Nao ha dados para imprimir.')
		return
	endif

	// ----------------------------------------------
	// Variaveis de Posicionamento
	// ----------------------------------------------
	nBox1	:= iif(nX==1,0,nBox1 + 50)
	nBox2	:= 000
	nBox3	:= iif(nX==1, 20, nBox3 + 50)
	nBox4	:= 450
	
	nSay1	:= iif(nX==1, 13, nBox1 + 13)
	nSay2	:= iif(nX==1, 80, nBox2 + 80)


	// ----------------------------------------------
	// BOX: Cabecalho
	// ----------------------------------------------
	oImpGNRE:Box(nBox1,000,nBox3,450,'-6')	
	oImpGNRE:Say(nSay1, nSay2, cCab, oFont12N)  
		
	// ----------------------------------------------
	// BOX: UF Favorecida
	// ----------------------------------------------
	cUfFav 	:= alltrim( oGnreXml:_gnre:_identgnre:_uf:text )
	
	nSay1	:= nBox1 + 8
	nSay1A	:= nBox1 + 16
	
	oImpGNRE:Box(nBox1,450,nBox3,520,'-6')
	oImpGNRE:Say(nSay1, 453, 'UF Favorecida', oFont07N)
	oImpGNRE:Say(nSay1A, 453, cUfFav, oFont08)
	
	// ----------------------------------------------
	// BOX: Codigo da Receita
	// ----------------------------------------------
	cCodRec	:= alltrim( oGnreXml:_gnre:_identgnre:_receita:text )
		
	oImpGNRE:Box(nBox1,520,nBox3,600,'-6')
	oImpGNRE:Say(nSay1, 523, 'Codigo da Receita', oFont07N) 
	oImpGNRE:Say(nSay1A, 523, cCodRec, oFont08)  
	
	
	// ----------------------------------------------
	// BOX: Dados do Contribuinte Emitente
	// ----------------------------------------------	
	cRazEmi	:= alltrim( oGnreXml:_gnre:_emitente:_nome:text )
	
	//cnpj/cpf/ie
	if ! empty( oGnreXml:_gnre:_emitente:_cnpjcpf:text )
		cCnpjCpfEm	:= transform(oGnreXml:_gnre:_emitente:_cnpjcpf:text,iif(len(oGnreXml:_gnre:_emitente:_cnpjcpf:text)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99"))
	else
		cCnpjCpfEm	:= alltrim( oGnreXml:_gnre:_emitente:_ie:text )
	endif
	
	cEndEmi	:= alltrim( oGnreXml:_gnre:_emitente:_endereco:text )
	cMunEmi	:= alltrim( oGnreXml:_gnre:_emitente:_descmun:text )
	cUfEmi		:= alltrim( oGnreXml:_gnre:_emitente:_uf:text )
	cCepEmi	:= alltrim( oGnreXml:_gnre:_emitente:_cep:text )
	
	cTelEmi	:= alltrim( oGnreXml:_gnre:_emitente:_telefone:text )
	cTelEmi	:= transform(cTelEmi, iif(len(cTelEmi) == 11, '@R (99) 99999-9999', '@R (99) 9999-9999' ))
	
	oImpGNRE:Box(nBox1 + 20,000,nBox3 + 060,450,'-6')	
	oImpGNRE:Say(nBox1 + 28, 0180, 'Dados do Contribuinte Emitente' , oFont07N)
	oImpGNRE:Say(nBox1 + 36, 0005, 'Razão Social:' , oFont07N)
	oImpGNRE:Say(nBox1 + 46, 0005, cRazEmi , oFont08)
	oImpGNRE:Say(nBox1 + 36, 0350, 'CNPJ/CPF/Insc. Est.:' , oFont07N)
	oImpGNRE:Say(nBox1 + 46, 0350, cCnpjCpfEm , oFont08)
	oImpGNRE:Say(nBox1 + 54, 0005, 'Endereço:' , oFont07N)
	oImpGNRE:Say(nBox1 + 54, 0045, cEndEmi , oFont08)
	oImpGNRE:Say(nBox1 + 64, 0005, 'Município:' , oFont07N)
	oImpGNRE:Say(nBox1 + 64, 0045, cMunEmi , oFont08)
	oImpGNRE:Say(nBox1 + 64, 0350, 'UF:' , oFont07N)
	oImpGNRE:Say(nBox1 + 64, 0365, cUfEmi , oFont08)
	oImpGNRE:Say(nBox1 + 74, 0005, 'CEP:' , oFont07N)
	oImpGNRE:Say(nBox1 + 74, 0025, cCepEmi , oFont08)
	oImpGNRE:Say(nBox1 + 74, 0350, 'Telefone:' , oFont07N)
	oImpGNRE:Say(nBox1 + 74, 0385, cTelEmi , oFont08)
		
	// ----------------------------------------------
	// BOX: Número de Controle
	// ----------------------------------------------
	oImpGNRE:Box(nBox1 + 20,450,nBox3 + 020,600,'-6')
	oImpGNRE:Say(nBox1 + 28, 0453, 'Nº de Controle', oFont07N) 
	oImpGNRE:Say(nBox1 + 36, 0528, cNumCtrl, oFont08)  
	
	// ----------------------------------------------
	// BOX: Data de Vencimento
	// ----------------------------------------------
	cDtVenc := substr(oGnreXml:_gnre:_identgnre:_vencimento:text,7,2)+'/'+ substr(oGnreXml:_gnre:_identgnre:_vencimento:text,5,2)+'/'+ substr(oGnreXml:_gnre:_identgnre:_vencimento:text,1,4)
		
	oImpGNRE:Box(nBox1 + 40,450, nBox3 + 040,600,'-6')
	oImpGNRE:Say(nBox1 + 48, 0453, 'Data de Vencimento', oFont07N) 
	oImpGNRE:Say(nBox1 + 56, 0558, cDtVenc, oFont08)  
	
	// ----------------------------------------------
	// BOX: Nº Documento de Origem
	// ----------------------------------------------
	cDocOrig := transform(oGnreXml:_gnre:_identgnre:_docorig:text,'@R 999999999')
	
	oImpGNRE:Box(nBox1 + 60,450,nBox3 +  060,600,'-6')
	oImpGNRE:Say(nBox1 + 68, 0453, 'Nº Documento de Origem', oFont07N) 
	oImpGNRE:Say(nBox1 + 76, 0558, cDocOrig, oFont08)
	
	
	// ----------------------------------------------
	// BOX: Dados do Destinatario
	// ----------------------------------------------
	//cnpj/cpf/ie
	if ! empty( oGnreXml:_gnre:_destinatario:_cnpjcpf:text )
		cCnpjCpfDs	:= transForm(oGnreXml:_gnre:_destinatario:_cnpjcpf:text,iif(len(oGnreXml:_gnre:_destinatario:_cnpjcpf:text)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99")) 
	else
		cCnpjCpfDs	:= alltrim( oGnreXml:_gnre:_destinatario:_ie:text )
	endif
	
	cMunDest := alltrim( oGnreXml:_gnre:_destinatario:_descmun:text )
	
	
	oImpGNRE:Box(nBox1 + 080, 000, nBox3 + 090, 450, '-6')	
	oImpGNRE:Say(nBox1 + 088, 0180, 'Dados do Destinatário' , oFont07N)
	oImpGNRE:Say(nBox1 + 096, 0005, 'CNPJ/CPF/Insc. Est.:' , oFont07N)
	oImpGNRE:Say(nBox1 + 096, 0080, cCnpjCpfDs , oFont08)
	oImpGNRE:Say(nBox1 + 106, 0005, 'Município:' , oFont07N)
	oImpGNRE:Say(nBox1 + 106, 0080, cMunDest , oFont08)
	
	
	// ----------------------------------------------
	// BOX: Periodo de Referencia
	// ----------------------------------------------
	cPerRef := alltrim( oGnreXml:_gnre:_referencia:_mes:text ) + '/' + alltrim( oGnreXml:_gnre:_referencia:_ano:text )
	
	oImpGNRE:Box(nBox1 + 080,450,nBox3 + 080,530,'-6')
	oImpGNRE:Say(nBox1 + 088, 0453, 'Período de Referência', oFont07N) 
	oImpGNRE:Say(nBox1 + 096, 0500, cPerRef, oFont08) 
	
	
	// ----------------------------------------------
	// BOX: Parcela
	// ----------------------------------------------
	cParcela := alltrim( oGnreXml:_gnre:_referencia:_parcela:text )
	
	oImpGNRE:Box(nBox1 + 080,530,nBox3 + 080,600,'-6')
	oImpGNRE:Say(nBox1 + 088, 0533, 'Parcela', oFont07N) 
	oImpGNRE:Say(nBox1 + 096, 0588, cParcela, oFont08) 
	
	
	// ----------------------------------------------
	// BOX: Valor Principal
	// ----------------------------------------------
	cMascara	:= '@e 9,999,999,999,999.99'
	cValPrinc	:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_principal:text), cMascara)),len(cMascara))
	
	oImpGNRE:Box(nBox1 + 100,450,nBox3 + 100,600,'-6')
	oImpGNRE:Say(nBox1 + 108, 0453, 'Valor Principal', oFont07N) 
	oImpGNRE:SayAlign( nBox1 + 108,0500,cValPrinc,oFont08, 96, 19, , 1)
	
	
	// ----------------------------------------------
	// BOX: Reservado a Fiscalizacao
	// ----------------------------------------------
	cConvenio	:= alltrim( oGnreXml:_gnre:_identgnre:_convenio:text )
	cProduto	:= alltrim( oGnreXml:_gnre:_identgnre:_produto:text )
	
	oImpGNRE:Box(nBox1 + 110, 000, nBox3 + 130, 450, '-6')	
	oImpGNRE:Say(nBox1 + 118, 0180, 'Reservado a Fiscalização' , oFont07N)
	oImpGNRE:Say(nBox1 + 128, 0005, 'Convênio/Protocolo:' , oFont07N)
	oImpGNRE:Say(nBox1 + 128, 0080, cConvenio , oFont08)
	oImpGNRE:Say(nBox1 + 138, 0005, 'Produto:' , oFont07N)
	oImpGNRE:Say(nBox1 + 138, 0080, cProduto , oFont08) 
	
	// ----------------------------------------------
	// BOX: Atualização Monetaria
	// ----------------------------------------------
	cAtuMon	:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_atumonetaria:text), cMascara)),len(cMascara))
	
	oImpGNRE:Box(nBox1 + 120,450,nBox3 + 120,600,'-6')
	oImpGNRE:Say(nBox1 + 128, 0453, 'Atualização Monetária', oFont07N) 
	oImpGNRE:SayAlign( nBox1 + 128,0500,cAtuMon,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: Informações Complementares
	// ----------------------------------------------
	cInfCompl := alltrim( oGnreXml:_gnre:_identgnre:_informacoes:text )
	
	oImpGNRE:Box(nBox1 + 140, 000, nBox3 + 180, 450, '-6')	
	oImpGNRE:Say(nBox1 + 148, 0005, 'Informações Complementares' , oFont07N)
	oImpGNRE:Say(nBox1 + 158, 0005, cInfCompl , oFont08)
	oImpGNRE:Say(nBox1 + 194, 0005, 'Documento Válido para pagamento até ' , oFont08N)
	oImpGNRE:Say(nBox1 + 194, 0200, cDtVenc , oFont08) 
	
	// ----------------------------------------------
	// BOX: Juros
	// ----------------------------------------------
	cJuros:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_juros:text), cMascara)),len(cMascara))
	
	oImpGNRE:Box(nBox1 + 140,450,nBox3 + 140,600,'-6')
	oImpGNRE:Say(nBox1 + 148, 0453, 'Juros', oFont07N) 
	oImpGNRE:SayAlign( nBox1 + 148,0500,cJuros,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: Multa
	// ----------------------------------------------
	cMulta:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_multa:text), cMascara)),len(cMascara))
		
	oImpGNRE:Box(nBox1 + 160,450,nBox3 + 160,600,'-6')
	oImpGNRE:Say(nBox1 + 168, 0453, 'Multa', oFont07N) 
	oImpGNRE:SayAlign( nBox1 + 168,0500,cMulta,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: Total a Recolher
	// ----------------------------------------------
	cTotRec:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_total:text), cMascara)),len(cMascara))
		
	oImpGNRE:Box(nBox1 + 180,450,nBox3 + 180,600,'-6')
	oImpGNRE:Say(nBox1 + 188, 0453, 'Total a Recolher', oFont07N) 
	oImpGNRE:SayAlign( nBox1 + 188,0500,cTotRec,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: Código de Barras
	// ----------------------------------------------
	cCodBar := alltrim(cAutoriza)
	cCodBar1 := substr(cCodBar,1,11) + ' '+ substr(cCodBar,12,1) + ' ' + substr(cCodBar,13,11) + ' ' + substr(cCodBar,24,1) + ' '+ substr(cCodBar,25,11) + ' ' +substr(cCodBar,36,1) + ' ' + substr(cCodBar,37,11) + ' ' + substr(cCodBar,48,1)
	oImpGNRE:say(nBox1 + 212, 0035, cCodBar1 , oFont10N)
	nFontSize := 40
	oImpGNRE:Code128C(nBox1 + 255,0005,Alltrim(cCodBar), nFontSize )
	
	//Via Boleto
	if nX == 1 
		oImpGNRE:say(nBox1 + 215, 0555, '1ª via - Banco' , oFont07)
	else
		oImpGNRE:say(nBox1 + 215, 0540, '2ª via - Contribuinte' , oFont07)
	endif 
	
	//Atribuo a ultima posiçao no nBox 1 para a via do contribuinte
	
	if nX == 1
	    //linha pontilhada
		oImpGNRE:say(nBox1 + 300, 0000, replicate(' - ',100) , oFont07)
			
		nBox1 := 280
		nBox3 += 280
	endif
	
next

oImpGNRE:EndPage()

return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NoAcentRecoºAutor  ³Danilo.Santos          º Data ³ 20/09/16º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao responsavel por retirar caracteres especiais das     º±±
±±º          ³String                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NoAcentReco(cXmlGnre)

Local cByte,ni
Local s1:= "áéíóú" + "ÁÉÍÓÚ" + "âêîôû" + "ÂÊÎÔÛ" + "äëïöü" + "ÄËÏÖÜ" + "àèìòù" + "ÀÈÌÒÙ"  + "ãõÃÕ" + "çÇ"
Local s2:= "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU"  + "aoAO" + "cC"
Local nPos:=0, nByte
Local cRet:=''
Default cXmlGnre := ""

cXmlGnre := (StrTran(cXmlGnre,"&","&amp;")) 

For ni := 1 To Len(cXmlGnre)
	cByte := Substr(cXmlGnre,ni,1)
	nByte := ASC(cByte)
	If nByte > 122 .Or. nByte < 48 .Or. ( nByte > 57 .And. nByte < 65 ) .Or. ( nByte > 90 .And. nByte < 97 )
		nPos := At(cByte,s1)
		If nPos > 0
			cByte := Substr(s2,nPos,1)
		Else
			If cByte $ "<"
				cByte := "<"
			Elseif cByte $ ">"
				cByte := ">"
			Elseif cByte $ "/"
				cByte := "/"
			Endif

		EndIf
	EndIf
	cRet+=cByte
Next

Return(AllTrim(cRet))


Static Function envEcom1(cAssunto, cMensagem)

			  oWorkFLW			 	 := TWEnviaEmail():New()
			  oWorkFLW:cConta        := "suryabrasil@shared.mandic.net.br"					    
			  oWorkFLW:cSenha        := "75XQF9qg"
			  oWorkFLW:cDestinatario := "vinicius.martins@suryabrasil.com"  
			  oWorkFLW:cServerSMTP   := "sharedrelay-cluster.mandic.net.br"						
			 
			  oWorkFLW:cAssunto      := cAssunto
			  oWorkFLW:cMensagem	 := cMensagem
			  
			  oWorkFLW:EnviaEmail()
			  //Conout('E-mail de erro e-commerce enviado com sucesso')
Return


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

/* */
Static Function envEcom2(cAssunto, cMensagem1, cMensagem2, cAnexo)

			local _cDestFat	    := SUPERGETMV("SB_DESTFAT",.T.,"fiscal@suryabrasil.com;ecommerce@suryabrasil.com")
			local _cCopy	    := SUPERGETMV("SB_COPYFTP",.T.,"tecnologia@suryabrasil.com")

			oWorkFLW			 	:= TWEnviaEmail():New()
			oWorkFLW:cConta        	:= "suryabrasil@shared.mandic.net.br"					    
			oWorkFLW:cSenha        	:= "75XQF9qg"						
			oWorkFLW:cDestinatario 	:= _cDestFat
			oWorkFLW:cCopia		 	:= _cCopy
			oWorkFLW:cServerSMTP   	:= "sharedrelay-cluster.mandic.net.br"						
			oWorkFLW:cDiretorio	 	:= "\workflow\html\Error_Generic.txt"
			oWorkFLW:cAnexo		 	:= cAnexo
			 
			oWorkFLW:cAssunto      := cAssunto
			oWorkFLW:aDadosHTML    := { { "##cAtencao##" ,cMensagem1 },;
										{ "##cMensagem##",cMensagem2} }
			  
			oWorkFLW:EnviaEmail()
Return
