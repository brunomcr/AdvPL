#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"  
#include "Totvs.ch"  
#include "Protheus.ch"          

#define STR0035 "Ambiente"
#define STR0050 "Protocolo"
#define STR0068 "Cod.Ret.NFe"
#define STR0069 "Msg.Ret.NFe"
#define STR0107 "Consulta NF"
#define STR0114 "Ok"
#define STR0056 "Produção"
#define STR0057 "Homologação"
#define STR0129 "Versão da mensagem"
#define CRLF chr(13)+chr(10)
#define DS_MODALFRAME   128
#define ANO STRZERO(YEAR( DATE() ))
#define MES STRZERO(MONTH( DATE() ))
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �CoSheduleXml�Autor  �Microsiga           � Data �  01/07/10   ���
���������������������������������������������������������������������������͹��
���Desc.     � Shedule leitura xml Notas entradas diretorio                 ���
���          �    Leitura xml Especie SPED                                  ���
���������������������������������������������������������������������������͹��
���Uso       � AP                                                           ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/    

User Function SBP0002(aParam)     //u_SBP0002({"01","03",.T.}) //fc ({"03","00",.T.})
Local aStru    	:= {}
Local cCodEmp  	:= ""
Local cCodFil  	:= ""
Local cGrupoIni	:= ""
Local cGrupoFim	:= ""
Local cProdIni 	:= ""
Local cProdFim 	:= ""
Local cFamDev  	:= ""
Local cCatDev  	:= ""
Local cCNPJ    	:= ""
Local cQuery   	:= ""
Local cCursor  	:= "SZX"
Local cLocal	:= ""
Local lQuery   	:= .F.
Local nX       	:= 0     
//Local aParam	:= {"03","00",.T.}


Private a_Xml 	:= {}
Private lAut 	:= aParam[3]
Private	xEmp 	:= aParam[1]
Private	xFil 	:= aParam[2]
Private aAut 	:= {}
If ValType(xEmp) == "A"
	aadd(aAut,xEmp)
	lAut := NIL
	xEmp := NIL
	xFil := NIL
	lAut := aAut[1][3]
	xEmp := aAut[1][1]
	xFil := aAut[1][2]
ENDIF

//Private cXMLFILE 	:= cGetFile("Arquivos XML|*.XML|Todos os Arquivos|*.*",OemToAnsi("Leitura Xml N.Entrada ..."),,,.T.,GETF_NETWORKDRIVE)

If lAut

	RPCSetType(3)
	    
	If FindFunction('WFPREPENV')
	
		lAuto := .T.      
		RPCSetType( 3 )						// N�o consome licensa de uso
		wfPrepENV(xEmp, xFil)
		
	Else
	
		lAuto := .T.
		RPCSetType( 3 )						// N�o consome licensa de uso
		Prepare Environment Empresa xEmp Filial xFil
		
	Endif
EndIF		
xx 	:= "1"

//RpcSetEnv("01","04",'FAT',,,GetEnvServer(),{"SF1","SF2","SF4","SD1","SD2","SZX","SA1","SA2"})

//cMes := StrZero(Month(dDatabase),2)
//cAno := _cPathEst := SuperGetMv("CO_ANOXML",,"2010")
//nPosSM0 := SM0->(Recno())  

_cFilial 	:= xFil
nMesAte 	:= Month(dDatabase) - 1
_lTudo 		:= .T.  // MsgYesNo("Processa apenas o mes corrente ?","Confirma.")///#
cPathXml 	:= SuperGetMv("SB_PATHXML",.F.,"\xml\")

conout("Path <SB_PATHXML> : "+cPathXml)

cDirXml 	:=cPathXml

cDirErro  	:= cDirXml+"invalidos\"
cDirOk    	:= cDirXml+"processados\"
cDirTam    	:= cDirXml+"bytes\"

MakeDir(cDirErro)
MakeDir(cDirOk)
MakeDir(cDirTam)

conout("Dir OK : "+cDirOk)
conout("Dir Erro: "+cDirErro)

aXML := Directory(cDirXml+"*.XML")

For nX := 1 to Len(aXML)

	// IncProc("Processando Filial: "+_cFilial+" - Mes: "+cMes)
	lProcessou := .F.
	cXMLFile := cDirXml+aXML[nX][1]  

	If !lAut

		MsAguarde( {|| xGrvSZ1(cXMLFile,_cFilial,cDirXml,lAut)},"Importando XML..." )   

	Else

		xGrvSZ1(cXMLFile,_cFilial,cDirXml,lAut)

	EndIf	

Next

/*If Len(a_Xml) > 0
	AIMSGENV(a_Xml)  
EndIf*/ 

Return()

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �xGrvSZ1	  �Autor  �Microsiga           � Data �  01/07/10   ���
���������������������������������������������������������������������������͹��
���Desc.     � Grava SZ1								                    ���
���������������������������������������������������������������������������͹��
���Uso       � AP                                                           ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/ 
Static FuncTion xGrvSZ1(cXMLFile,_cFil,cDirXml,lAuto)

Local lRetorno		:= .T.
Local nX       		:= 0
Local oRetorno
Local oXML
Local cError 		:= ""
Local cWarning 		:= ""               
Local errStr 		:= ""
Local warnStr 		:= ""
Local cNome			:= "" 
Local cStatus		:= "0"
Local lValida		:= .T.
//Alex
Local cVldCFOP 		:= ""
Local aPrdXML		:= {}
Local lVldDev 		:= .F.

//conout("Parametros  <cXMLFile>: "+cXMLFile)
nTAMMAXXML 			:= 200000 //- Tamanho maximo do XML em  bytes
cNewArq   			:= Substr(cXMLFile,Rat("\",cXMLFile)+1,Len(Alltrim(cXMLFile)))
aGlobalStack 		:= {}
cXML 				:= MEMOREAD( cXMLFile )      

If empty(cXml)

	__CopyFile(cXMLFile,cDirErro+cNewArq)
	Ferase(cXMLFile)
	Return .F.

EndIf

cXML := StrTran(cXML,CHR(13),'')
cXML := StrTran(cXML,CHR(10),'')      

If LEN(cXML) > nTAMMAXXML	

	__CopyFile(cXMLFile,cDirTam+cNewArq)
	Ferase(cXMLFile)
	Return .F.

EndIf



// Checa Integridade do xml e a existencia das tags a serem lidas
cTag1 		:= "<nfeProc"
cTag2 		:= "<NFe"
cTag3 		:= "<CNPJ"
cTag4 		:= "<dhEmi" 
cTag6 		:= "<dEmi"
cTag5 		:= "<protNFe"
cTag8		:= "<NFref
cTag9 		:= "<cteProc"
cTag10 		:= "<CTe"
cTag11 		:= "<infCte"
cTag12 		:= "<infNF"
cTag13 		:= "<CFe"
cTag14 		:= "<InfCFe"
cTag15 		:= "<CFeCanc"
nPosTag1 	:= At(cTag1,cXML)
nPosTag2 	:= At(cTag2,cXML)
nPosTag3	 := At(cTag3,cXML)
nPosTag4 	:= At(cTag4,cXML)
nPosTag5 	:= At(cTag5,cXML) 
nPosTag6 	:= At(cTag6,cXML)
nPosTag8 	:= At(cTag8,cXML) 
nPosTag9 	:= At(cTag9,cXML)
nPosTag10 	:= At(cTag10,cXML) 
nPosTag11 	:= At(cTag11,cXML)
nPosTag12 	:= At(cTag12,cXML) 
nPosTag13 	:= At(cTag13,cXML)
nPosTag14 	:= At(cTag14,cXML)
nPosTag15 	:= At(cTag15,cXML)


If nPosTag15 > 0

__CopyFile(cXMLFile,cDirErro+cNewArq)
  	Ferase(cXMLFile)
	Return .F.

EndIf
                                               
If nPostag1 > 0

	oXml := Nil
	oXml := XmlParserFile( cXMLFile, "_", @errStr, @warnStr )
	
	cChaveNfe :=  Alltrim(Substr(oXml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4,45))
	//NFe42150917560684000189550010000242581370472427    
	//12345678901234567890123456789012345678901234567890
	//nPosTag6 := At(cTag6,cXML) 
	xx := "XX"                                   // Ponto de parada debug
	
	
	// CREATE oXML XMLFILE cXMLFile
	
	
	//������������������������������������������Ŀ
	//�Le as Tags necessarias para a tabela SZX  �
	//��������������������������������������������
	If nPosTag6 > 0 .And. nPosTag4 = 0

		dEmissao   := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT

	Else

		dEmissao   := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT

	EndIf
	
	//	nMes    := Substr(dEmissao,RAt("-",dEmissao)+1,RAt("-",dEmissao) - At("-",dEmissao) -1)
	nMes    := Substr(dEmissao,At("-",dEmissao)+1,2)
	nDia    := Substr(dEmissao,9,2)
	nAno    := Substr(dEmissao,1,At("-",dEmissao)-1)
	
	dEmissao:= Ctod(StrZero(Val(nDia),2)+"/"+StrZero(Val(nMes),2)+"/"+StrZero(Val(nAno),4))
	
	If oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ == NIL 
	
		c_DestCNPJ   := oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT
	
	Else
	
		c_DestCNPJ   := oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
	
	EndIf
	
	lNota := .F.
	_cNotaXml := "2"
	
	l_SM0 := .F.
	
	dbSelectArea("SM0")
	nRegSM0 := SM0->(Recno())
	dbSetOrder(1)
	SM0->(DbGoTop())
	
	While SM0->(!Eof())
	
		If c_DestCNPJ == SM0->M0_CGC 
	
			l_SM0 := .T.
			_cEmp := SM0->M0_CODIGO
			_cFil := SM0->M0_CODFIL    
			cFilant:= SM0->M0_CODFIL    
			Exit
					// aAdd(aSM0,{SM0->M0_CODIGO, SM0->M0_CODFIL,SM0->M0_CGC})
		EndIf
	
		SM0->(dbSkip())
	
	Enddo
	
	If  ! l_SM0
	
		SM0->(DbGoTo(nRegSM0))
		//aadd(a_Xml,cChaveNfe+ " - CNPJ Destinatario nao e a Surya" )
	
		__CopyFile(cXMLFile,cDirErro+cNewArq)
	
	  	Ferase(cXMLFile)
		Return .F.
	
	EndIf
	
	/*If ! ChkNFeChave(cChaveNfe)	
		//aadd(a_Xml,cChaveNfe+ " - NF-e NAO VALIDADA NA SEFAZ" )
		__CopyFile(cXMLFile,cDirErro+cNewArq)
		Ferase(cXMLFile)	
		Return .F.
	EndIf*/
	
	If oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ == NIL
	                  
		cCnpj   := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CPF:TEXT
		
	Else
	
		cCnpj   := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
		
	EndIf
	
	cCnpj       := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
	cCnpj    	:= StrTran(cCnpj,'.','')
	cCnpj    	:= StrTran(cCnpj,'/','')
	cCnpj    	:= StrTran(cCnpj,'-','')
	cCliFor  	:= "S"
	cCodCF   	:= ""
	cLoj     	:= ""
	_CtipoNF 	:= "N"
	cStatus  	:= "0"
	oDet       	:= oXML:_NFEPROC:_NFE:_INFNFE:_DET
	
	// ============================================================================================####
	// ===========						Alex 11/09/2019									==========#####
	// ===========	IF Substituído, ao invés de chumbar o DEV, pois toda devolução deve ==========#####
	// ===========	referenciar a nf original, todavia os retornos simbólicos também 	==========#####
	// ===========	possuem a tag, por isso validar a CFOP também					 	==========#####
	// ============================================================================================####
	//IF "DEV" $ oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT
	
	//Pega o Código CFOP
	If ValType(oXml:_NFEPROC:_NFE:_INFNFE:_DET) <> Nil	
	aPrdXML := oXml:_NFEPROC:_NFE:_INFNFE:_DET
		If ValType(aPrdXML) == "A"
			cVldCFOP := aPrdXML[1]:_PROD:_CFOP:TEXT
		Else
			cVldCFOP := aPrdXML:_PROD:_CFOP:TEXT
		EndIf
	Else
		CONOUT(" CFOP NfeProc... n�o encontrado - Estrutura")
	EndIf

	IF  (XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_IDE,"_NFREF") <> Nil) .AND. SUBSTR(cVldCFOP,2,3) <> "907"
		_CtipoNF := "D"
		lVldDev := .T.
	EndIf
	
	If _cTipoNf == "N"
	
		DbSelectArea("SA2")
		DbSetOrder(3)
		
		If DbSeek(xFilial("SA2") + cCnpj )
		
			cCliFor	:= "F"
			cCodCF 	:= SA2->A2_COD
			cLoj   	:= SA2->A2_LOJA	
			cNome	:= SA2->A2_NREDUZ
				
			If SA2->A2_MSBLQL == "1"
			
				cStatus := "5"
				
			EndIf
			
			_cNotaXml :=  "2" //Posicione("SA2",1,xFilial("SA2")+cCodCF+cLoj,"A2_XXML")
			//_cTes       :=  Posicione("SA2",1,xFilial("SA2")+cCodCF+cLoj,"A2_XTES")
			// Verifica se gera Nota fiscal

			If _cNotaXml == "1"  // 1=Sim 2-Nao

				lNota := .F.//.T.

			EndIf

		Else

			cStatus := "9"

		EndIf

	ElseIf _cTipoNf == "D"
	
		DbSelectArea("SA1")
		DbSetOrder(3)
	
		If DbSeek(xFilial("SA1") + cCnpj )
		
			cCliFor	:= "C"
			cCodCF 	:= SA1->A1_COD
			cLoj   	:= SA1->A1_LOJA	
			cNome	:= SA1->A1_NREDUZ
		
			If SA1->A1_MSBLQL == "1"
		
				cStatus := "5"
		
			EndIf
		
			_cNotaXml :=  "2" //Posicione("SA2",1,xFilial("SA2")+cCodCF+cLoj,"A2_XXML")
			//_cTes       :=  Posicione("SA2",1,xFilial("SA2")+cCodCF+cLoj,"A2_XTES")
			// Verifica se gera Nota fiscal
		
			If _cNotaXml == "1"  // 1=Sim 2-Nao
		
				lNota := .F.//.T.
		
			EndIf
		
		Else
		
			cStatus := "9"
		
		EndIf
	
	EndIf
	
	cChave  := oXml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT
	cChave  := Substr(cChave,4,45)
	//cChave  := oXML:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT
	cChave  := StrTran(cChave,'-','')
	cChave  := StrTran(cChave,'.','')
	cChave  := StrTran(cChave,'/','')+Space(10)
	cChave  := Substr(cChave,1,45)
	
	CSERIE   := Alltrim(Str(Val(Substr(cChave,23,3)),3,0))
	
	cDoc     := Substr(cChave,26,9)
	
	conout("Chave NFE: "+cChave)
	
	lValida	:= ValidaSZ1 ( StrZero(Val(cDoc),9), StrZero(Val(CSERIE),3), cCnpj, cCodCF, cLoj, cXMLFile )
	
	If !lValida // Fun��o para valida��o se XML j� foi importado. 	

		__CopyFile(cXMLFile,cDirErro+cNewArq)
		Ferase(cXMLFile)	
		Return .F.
		
	EndIf

	// Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-nota   
	DbSelectArea("SZ1")
	DbSetOrder(4)
	
	IF !DbSeek(xFilial("SZ1")+ cChave )
	
		Reclock("SZ1",.T.)
			SZ1->Z1_FILIAL 	:= xFilial("SZ1")
			SZ1->Z1_CHAVE  	:= cChave
			SZ1->Z1_CGC    	:= cCnpj
			SZ1->Z1_NOME    := cNome
			SZ1->Z1_EMISSAO := dEmissao
			SZ1->Z1_DOC    	:= StrZero(Val(cDoc),9)
			SZ1->Z1_SERIE  	:= StrZero(Val(CSERIE),3)
			SZ1->Z1_XML     := cXML
			SZ1->Z1_STATUS 	:= cStatus
			SZ1->Z1_ESPECIE := "SPED"
			SZ1->Z1_TIPO 	:= _cTipoNf
		MsUnlock()
	
		_nPosIniICM	:=At("<pICMS",cXML)    
		_nPosFimICM :=At("</pICMS",cXML)
		_nPosIniICM += 7
		nAliqICM := val(Substr(cXML, _nPosIniICM, _nPosFimICM - _nPosIniICM))
		
		RecLock("SZ1",.F.)
			SZ1->Z1_ALIQICM := If(nAliqICM == 0,"S","N")
			SZ1->Z1_ESPECIE := "SPED"
		MsUnlock()	
		//u_CPPRENFE()

		//Se o CFOP for final 907 é um retorno simbólico, 
		//portanto deve-se criar o documento de entrada, 
		//assim é validado junto ao lDet no GeraNFE
		//Alex	
		XX := 0
		/*If substr(cVldCFOP,2,3) == '907' .Or. lVldDev
			U_GeraNFe(cXML,lAuto) 
		EndIf*/
	Else
	
		//�������������������������������������������������������������������Ŀ
		//�Copia o arquivo para a pasta processados e apaga arquivo lido      �
		//���������������������������������������������������������������������
		c_XML := SZ1->Z1_XML
		_nPosIniICM	:=At("<pICMS",c_XML)    
		_nPosFimICM :=At("</pICMS",c_XML)
		_nPosIniICM += 7
		
		nAliqICM := Val(Substr(c_XML, _nPosIniICM, _nPosFimICM - _nPosIniICM))
		
		RecLock("SZ1",.F.)
			SZ1->Z1_ALIQICM := If(nAliqICM == 0,"S","N")
			SZ1->Z1_ESPECIE := "SPED"
		MsUnlock() 
		
		__CopyFile(cXMLFile,cDirOk+cNewArq)
		conout("XML: "+cXMLFile+" JA SE ENCONTRA NA BASE...")
		Ferase(cXMLFile)
		Return
		
	EndIf
	
  /*	If cStatus <> "X"
	
		DbSelectArea("SZ1")
		DbSetOrder(4)
		DbSeek(xFilial("SZ1")+ cChave )
		Reclock("SZ1",.F.)
			SZ1->Z1_STATUS := "5"
		MsUnlock()	
	EndIf   */
	
	//conout("Copia Arquivo: "+cXMLFile)
	//conout("Para: "+cDirOk+cNewArq)
	
	//�������������������������������������������������������������������Ŀ
	//�Copia o arquivo para a pasta processados e apaga arquivo lido      �
	//���������������������������������������������������������������������
	__CopyFile(cXMLFile,cDirOk+cNewArq)
	Ferase(cXMLFile)
	oXml := Nil
	DelClassIntf()
	
ElseIf nPosTag10 > 0

	oXml 		:= Nil
	oXml 		:= XmlParser ( cXML, "_", @errStr, @warnStr )
	cNewArq   	:= Substr(cXMLFile,Rat("\",cXMLFile)+1,Len(Alltrim(cXMLFile)))	
	cChaveNfe 	:= ""
	cTag1 		:= "<cteProc"
	cTag2 		:= "<CTe"
	cTag3 		:= "<infCte"
	cTag4 		:= "<infNF"
	nPosTag1	:= At(cTag1,cXML)
	nPosTag2 	:= At(cTag2,cXML)
	nPosTag3 	:= At(cTag3,cXML)
	nPosTag4 	:= At(cTag4,cXML) 
	lCteproc 	:= .F.
	l_Ok 		:= .T.
	
	If nPosTag1 > 0  // Layout CT-e <CTEPROC
	
		lCteproc := .T.
	
	ElseIf nPosTag2 > 0
	
		lCteproc := .F.
	
	Else
	
		l_Ok := .F.		
		__CopyFile(cXMLFile,cDirErro+cNewArq)	
	  	Ferase(cXMLFile)

	EndIf
	
	xx := "XX"                                   // Ponto de parada debug	
	If oXml == NIL .or. !Empty(errStr) .or. !Empty(warnStr)
	
		l_Ok := .F.		
		__CopyFile(cXMLFile,cDirErro+cNewArq)	
	  	Ferase(cXMLFile)
	  	
	EndIf
	
	If ! l_Ok
			
		Return .F.
	
	EndIf
	
	xx:= "1"

	If lCteproc
	
		cChaveNfe  := oXML:_CTEPROC:_CTE:_INFCTE:_ID:TEXT
		cChaveNfe  := Substr(cChaveNfe,4,45)
	
	Else
	
		cChaveNfe  := oXml:_CTE:_INFCTE:_ID:TEXT
		cChaveNfe  := Substr(cChaveNfe,4,45)
	
	EndIf
	
	/*	If !ChkNFeChave(cChaveNfe)
	
		conout(cChaveNfe+ " - " + "Nota nao validada no SEFAZ" )
		__CopyFile(cXMLFile,cDirErro+cNewArq)	
	  	Ferase(cXMLFile)
	  	Return .F.
	
	EndIf*/
	
	//������������������������������������������Ŀ
	//�Le as Tags necessarias para a tabela SZ1  �
	//��������������������������������������������
	
	If lCteproc
	
		dEmissao   := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
		//	nMes    := Substr(dEmissao,RAt("-",dEmissao)+1,RAt("-",dEmissao) - At("-",dEmissao) -1)
		nMes    := Substr(dEmissao,At("-",dEmissao)+1,2)
		nDia    := Substr(dEmissao,RAt("-",dEmissao)+1,2)
		nAno    := Substr(dEmissao,1,At("-",dEmissao)-1)
	
	Else
	
		dEmissao   := oXml:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
		nMes    := Substr(dEmissao,At("-",dEmissao)+1,2)
		nDia    := Substr(dEmissao,RAt("-",dEmissao)+1,2)
		nAno    := Substr(dEmissao,1,At("-",dEmissao)-1)
	
	EndIf
	
	dEmissao:= Ctod(StrZero(Val(nDia),2)+"/"+StrZero(Val(nMes),2)+"/"+StrZero(Val(nAno),4))
	
	If lCteproc
	
		cCnpj := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT    
	
	Else
	
		cCnpj := oXml:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
	
	EndIf
		
	cCnpj    := StrTran(cCnpj,'.','')
	cCnpj    := StrTran(cCnpj,'/','')
	cCnpj    := StrTran(cCnpj,'-','')
	cCliFor  := "S"
	cCodCF   := ""
	cLoj     := ""
	_CtipoNF := "N"
	cStatus  := "0"
	lNota    := .F.
	DbSelectArea("SA2")
	DbSetOrder(3)
	
	If DbSeek(xFilial("SA2") + cCnpj )
	
		cCliFor := "F"
		cCodCF  := SA2->A2_COD
		cLoj    := SA2->A2_LOJA
		_CtipoNF := "N"
		cNome	:= SA2->A2_NREDUZ
	
		If SA2->A2_MSBLQL == "1"
	
			cStatus := "5"
	
		EndIf
	
	Else
	
		__CopyFile(cXMLFile,cDirErro+cNewArq)	
	  	Ferase(cXMLFile)
	  	Conout("CTE sem cadastro de Fornecedor: "+ cChaveNfe+" CNPJ: "+cCnpj)
	
	EndIf
	
	xx:= "1"
	
	If lCteproc
	
		cChave  := oXML:_CTEPROC:_CTE:_INFCTE:_ID:TEXT
		cChave  := Substr(cChave,4,45)
	
	Else
	
		cChave  := oXml:_CTE:_INFCTE:_ID:TEXT
		cChave  := Substr(cChave,4,45)
	
	EndIf
	
	cChave  := StrTran(cChave,'-','')
	cChave  := StrTran(cChave,'.','')
	cChave  := StrTran(cChave,'/','')+Space(10)
	cChave  := Substr(cChave,1,45)
	CSERIE   := Alltrim(Str(Val(Substr(cChave,23,3)),3,0))
	cDoc     := Substr(cChave,26,9)
	
	lValida	:= ValidaSZ1 ( StrZero(Val(cDoc),9), StrZero(Val(CSERIE),3), cCnpj, cCodCF, cLoj, cXMLFile )
	
	If !lValida // Fun��o para valida��o se XML j� foi importado. 	

		__CopyFile(cXMLFile,cDirErro+cNewArq)
		Ferase(cXMLFile)	
		Return .F.
		
	EndIf
	
	// Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-nota   
	DbSelectArea("SZ1")
	DbSetOrder(1)
	
	IF ! DbSeek(xFilial("SZ1")+ cChave )
	
		Reclock("SZ1",.T.)
			SZ1->Z1_FILIAL	:= xFilial("SZ1")
			SZ1->Z1_CHAVE  	:= cChave
			SZ1->Z1_CGC    	:= cCnpj
			SZ1->Z1_EMISSAO := dEmissao
			SZ1->Z1_DOC    	:= StrZero(Val(cDoc),9)
			SZ1->Z1_SERIE  	:= StrZero(Val(CSERIE),3)
			SZ1->Z1_XML    	:= cXML
			SZ1->Z1_STATUS 	:= cStatus
			SZ1->Z1_ESPECIE	:= "CTE  "
			SZ1->Z1_TIPO	:= _CtipoNF
			SZ1->Z1_NOME	:= cNome
		MsUnlock()			
		//u_CPPRENFE()
		//Alex
			/* U_GeraCte(cXML,lAuto)*/
		
	Else
			
		__CopyFile(cXMLFile,cDirOk+cNewArq)
		conout("XML: "+cXMLFile+" JA SE ENCONTRA NA BASE...")
		Ferase(cXMLFile)
		Return
	
	EndIf
	//�������������������������������������������������������������������Ŀ
	//�Copia o arquivo para a pasta processados e apaga arquivo lido      �
	//���������������������������������������������������������������������
	__CopyFile(cXMLFile,cDirOk+cNewArq)
	
	/*Alex
		GeraCTE(cXML)
	*/

	 Ferase(cXMLFile)
	
	oXml := Nil
	DelClassIntf()

ElseIf nPosTag13 > 0	
	
	oXml 		:= Nil
	oXml 		:= XmlParser ( cXML, "_", @errStr, @warnStr )
	cNewArq   	:=  Substr(cXMLFile,Rat("\",cXMLFile)+1,Len(Alltrim(cXMLFile)))	
	cChaveNfe 	:= ""
	cTag1 		:= "<cfeProc"
	cTag2 		:= "<CFe"
	cTag3 := "<infCFe"
	cTag4 := "<infNF"
	nPosTag1 := At(cTag1,cXML)
	nPosTag2 := At(cTag2,cXML)
	nPosTag3 := At(cTag3,cXML)
	nPosTag4 := At(cTag4,cXML)
	l_Ok	:= .T.
	
	If nPosTag1 > 0  // Layout CT-e <CFEPROC
	
		lCFeproc := .T.
	
	ElseIf nPosTag2 > 0
	
		lCFeproc := .F.
	
	Else
	
		l_Ok := .F.		
		__CopyFile(cXMLFile,cDirErro+cNewArq)	
	  	Ferase(cXMLFile)
	
	EndIf
	
	xx := "XX"                                   // Ponto de parada debug	
	If oXml == NIL .or. !Empty(errStr) .or. !Empty(warnStr)
	
		l_Ok := .F.		
		__CopyFile(cXMLFile,cDirErro+cNewArq)	
	  	Ferase(cXMLFile)
	
	EndIf
	
	If ! l_Ok		
	
		Return .F.
	
	EndIf
	
	xx:= "1"

	If lCfeproc
	
		cChaveNfe  := oXML:_CFEPROC:_CFE:_INFCFE:_ID:TEXT
		cChaveNfe  := Substr(cChaveNfe,4,45)
	
	Else
	
		cChaveNfe  := oXml:_CFE:_INFCFE:_ID:TEXT
		cChaveNfe  := Substr(cChaveNfe,4,45)
		
	EndIf
	
	If oXml:_CFE:_INFCFE:_IDE:_MOD:TEXT == "59"
	
		cEspecie	:= "SATCE"
		
	ElseIf oXml:_CFE:_INFCFE:_IDE:_MOD:TEXT == "65"
		
		cEspecie	:= "NFCE"
	
	EndIf
	
	/*	If !ChkNFeChave(cChaveNfe)
		conout(cChaveNfe+ " - " + "Nota nao validada no SEFAZ" )
		__CopyFile(cXMLFile,cDirErro+cNewArq)	
	  	Ferase(cXMLFile)
	  	Return .F.
	EndIf*/
	
	//������������������������������������������Ŀ
	//�Le as Tags necessarias para a tabela SZ1  �
	//��������������������������������������������
	If lCfeproc
	
		dEmissao   	:= oXML:_CFEPROC:_CFE:_INFCFE:_IDE:_DHEMI:TEXT
		//	nMes    := Substr(dEmissao,RAt("-",dEmissao)+1,RAt("-",dEmissao) - At("-",dEmissao) -1)
		nMes    	:= Substr(dEmissao,At("-",dEmissao)+1,2)
		nDia    	:= Substr(dEmissao,RAt("-",dEmissao)+1,2)
		nAno    	:= Substr(dEmissao,1,At("-",dEmissao)-1)
	
	Else
	
		dEmissao   	:= oXml:_CFE:_INFCFE:_IDE:_DEMI:TEXT
		nMes    	:= Substr(dEmissao,5,2)
		nDia    	:= Substr(dEmissao,7,2)
		nAno    	:= Substr(dEmissao,1,4)
	
	EndIf
	
	dEmissao	:= Ctod(StrZero(Val(nDia),2)+"/"+StrZero(Val(nMes),2)+"/"+StrZero(Val(nAno),4))
	cCodCF		:= SuperGetMV("MV_CLIPAD",.F.,"003737")
	cLoj     	:= SuperGetMV("MV_LOJAPAD",.F.,"01")
	cNome		:= Posicione("SA1",1,xFilial("SA1")+cCodCF+cLoj,"A1_NREDUZ")		
	cCnpj    	:= Posicione("SA1",1,xFilial("SA1")+cCodCF+cLoj,"A1_CGC")
	cCnpj    	:= StrTran(cCnpj,'/','')
	cCnpj    	:= StrTran(cCnpj,'-','')
	cCliFor  	:= "S"
	cCodCF   	:= ""
	cLoj     	:= ""
	_CtipoNF 	:= "N"
	cStatus  	:= "0"
	lNota    	:= .F.
	
	xx:= "1"
	If lCFEproc
	
		cChave  := oXML:_CFEPROC:_CFE:_INFCFE:_ID:TEXT
		cChave  := Substr(cChave,4,45)
		CSERIE   := SuperGetMV("SB_SERCFE",.f.,"005")
		cDoc     := oXml:_CFEPROC:_CFE:_INFCFE:_IDE:_NCFE:TEXT
		cDoc	:= strzero(val(cDoc),9)
	
	Else
		
		cChave  := oXml:_CFE:_INFCFE:_ID:TEXT
		cChave  := Substr(cChave,4,45)
		CSERIE   := SuperGetMV("SB_SERCFE",.f.,"005")
		cDoc     := oXml:_CFE:_INFCFE:_IDE:_NCFE:TEXT
		cDoc	:= strzero(val(cDoc),9)
	
	EndIf
	
	cChave  := StrTran(cChave,'-','')
	cChave  := StrTran(cChave,'.','')
	cChave  := StrTran(cChave,'/','')+Space(10)
	cChave  := Substr(cChave,1,45)
	
	lValida	:= ValidaSZ1 ( StrZero(Val(cDoc),9), StrZero(Val(CSERIE),3), cCnpj, cCodCF, cLoj, cXMLFile )
	
	If !lValida // Fun��o para valida��o se XML j� foi importado. 	

		__CopyFile(cXMLFile,cDirErro+cNewArq)
		Ferase(cXMLFile)	
		Return .F.
		
	EndIf
	
	// Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-nota   
	DbSelectArea("SZ1")
	DbSetOrder(1)
	
	IF ! DbSeek(xFilial("SZ1")+ cChave )
	
		Reclock("SZ1",.T.)
			SZ1->Z1_FILIAL	:= xFilial("SZ1")
			SZ1->Z1_CHAVE  	:= cChave
			SZ1->Z1_CGC    	:= cCnpj
			SZ1->Z1_EMISSAO := dEmissao
			SZ1->Z1_DOC    	:= StrZero(Val(cDoc),9)
			SZ1->Z1_SERIE  	:= StrZero(Val(CSERIE),3)
			SZ1->Z1_XML    	:= cXML
			SZ1->Z1_STATUS 	:= cStatus
			SZ1->Z1_ESPECIE	:= cEspecie
			SZ1->Z1_TIPO	:= _CtipoNF
			SZ1->Z1_NOME	:= cNome
		MsUnlock()			
	/*Alex
		U_GeraCfe(SZ1->Z1_XML, SZ1->Z1_ESPECIE )
	*/

	Else		
	
		__CopyFile(cXMLFile,cDirOk+cNewArq)
		conout("XML: "+cXMLFile+" JA SE ENCONTRA NA BASE...")
		Ferase(cXMLFile)
		Return
	
	EndIf
	
	//�������������������������������������������������������������������Ŀ
	//�Copia o arquivo para a pasta processados e apaga arquivo lido      �
	//���������������������������������������������������������������������
	__CopyFile(cXMLFile,cDirOk+cNewArq)
	
	 Ferase(cXMLFile)
	
	oXml := Nil
	DelClassIntf()

EndIf

Return

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �ChkNFeChave �Autor  �Microsiga           � Data �  01/07/10   ���
���������������������������������������������������������������������������͹��
���Desc.     � Checa se chave da NFE � Valida.			                    ���
���������������������������������������������������������������������������͹��
���Uso       � AP                                                           ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function ChkNFeChave(cXml)

Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cMensagem:= ""
Local oWS
Local _lRet := .T.

//������������������������������������������������������������������������Ŀ
//�Obtem o codigo da entidade                                              �
//��������������������������������������������������������������������������
cIdEnt := GetIdEnt()

cChaveNFe := Alltrim(cXml)

oWs:= WsNFeSBra():New()
oWs:cUserToken   := "TOTVS"
oWs:cID_ENT      := cIdEnt
ows:cCHVNFE		 := cChaveNFe
oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

If oWs:ConsultaChaveNFE()
	
	cMensagem := ""
	
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
	
		cMensagem += STR0129+": "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
	
	EndIf                
	
	cMensagem += STR0035+": "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,STR0056,STR0057)+CRLF //"Produ��o"###"Homologa��o"
	cMensagem += STR0068+": "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
	cMensagem += STR0069+": "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
	cRetorno := oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE
	
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
	
		cMensagem += STR0050+": "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF	
	
	EndIf
	
	//Aviso(STR0107,cMensagem,{STR0114},3)
	
	If Alltrim(cRetorno) <> '100'
	
	//		If Alltrim(cRetorno) == '226'
	//			Aviso("Consulta NF","Status Sefaz -> "+cRetorno+" Nota fiscal esta inutilizada na base da dados do Sefaz.",{"Aten��o"},3)
	//		Else
	//			Aviso("Consulta NF","Status Sefaz -> "+cRetorno,{"Aten��o"},3)
	//		EndIf
	
		_lRet := .F.
	
	EndIf

Else

  //	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
	_lRet := .F.
	
EndIf
	
Return(_lRet)

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �GetIdEnt    �Autor  �Microsiga           � Data �  01/07/10   ���
���������������������������������������������������������������������������͹��
���Desc.     � Obtem o codigo da entidade    			                    ���
���������������������������������������������������������������������������͹��
���Uso       � AP                                                           ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://10.0.0.105:80"),250)
Local oWs

//������������������������������������������������������������������������Ŀ
//�Obtem o codigo da entidade                                              �
//��������������������������������������������������������������������������
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"

If oWs:ADMEMPRESAS()

	cIdEnt  := oWs:cADMEMPRESASRESULT
	
Else

  //	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Aten��o"},3)

EndIf

RestArea(aArea)

Return(cIdEnt)
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �GetIdEnt    �Autor  �Microsiga           � Data �  01/07/10   ���
���������������������������������������������������������������������������͹��
���Desc.     � Obtem o codigo da entidade    			                    ���
���������������������������������������������������������������������������͹��
���Uso       � AP                                                           ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function ValidaSZ1 ( _cDoc, _CSERIE, _cCnpj, _cCodCF, _cLoj, _cXMLFile )

Local lRet		:= .T.

If SZ1->(dbSetOrder(1), dbSeek( xFilial( "SZ1" )+  _cDoc + _CSERIE+ _cCnpj ) ) 
//Existchav("SZ1",xFilial("SZ1") + _cDoc + _CSERIE + _cCnpj, 1)
	
	If !SF2->(dbSetOrder(1), dbSeek( xFilial( "SF2" )+  _cDoc + _CSERIE+ _cCodCF+ _cLoj ) )
		
		conout ("XML: "+_cXMLFile+" NOTA SE ENCONTRA NA BASE...")
		lRet := .F.
		
	Else
		
		conout ("XML: "+_cXMLFile+" NOTA N�O SE ENCONTRA NA BASE... SOMENTE NA NA SZ1")
		lRet := .F.
		
	EndIf
	
EndIf 

Return lRet