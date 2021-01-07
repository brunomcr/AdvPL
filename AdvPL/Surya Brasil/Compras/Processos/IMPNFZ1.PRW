#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDE "AvPrint.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"
#Include "TbiConn.ch"
#include "tbicode.ch"
#include "Totvs.ch"  
#INCLUDE "XMLXFUN.CH"


/*/{Protheus.doc} IMPNFZ1
	(long_description) 
	@type  User Function
	@author Alexsandro Salla
	@since 16/09/2019
	@version 1.0
	@param param_name, param_type, param_descr
	@return 
	@example
	 U_IMPNFZ1({"03","00"})
	@see (links_or_references)
	/*/

User Function IMPNFZ1(aParam)
Local aDocZ1 	:= {}
Local aAreaZ1 	:= ""
Local cAliasZ1 	:= getNextAlias()
Local cQryZ1	:= ""
Local cXML 		:= ""
Local cXMLFile	:= ""
Local cTpNF 	:= ""
Local cEspec 	:= ""
Local nRecno	:= 0
Private	xEmp 	:= aParam[1][1]
Private	xFil 	:= aParam[1][2]
   
If FindFunction('WFPREPENV')
	RPCSetType(3)						// N�o consome licensa de uso
	wfPrepENV(xEmp, xFil)
Else						// N�o consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil	
Endif
aAreaZ1 	:= SZ1->(GetArea())

cQryZ1 := " SELECT Z1_FILIAL [FILIAL] "
cQryZ1 += " , Z1_DOC [DOC] "
cQryZ1 += " , Z1_SERIE [SERIE] "
cQryZ1 += " , Z1_CGC [CGC] "
cQryZ1 += " , Z1_STATUS [STATUS]"
cQryZ1 += " , Z1_TIPO [TIPO]"
cQryZ1 += " , Z1_ESPECIE [ESPECIE]"
cQryZ1 += " , SZ1.R_E_C_N_O_ [RECNO]"
//cQryZ1 += " , ISNULL(CONVERT(VARCHAR(MAX),CONVERT(VARBINARY(MAX),Z1_XML)),'') [XML], Z1_XML [X]"
cQryZ1 += " FROM "+RetSqlName("SZ1")+ " SZ1"
cQryZ1 += " WHERE SZ1.D_E_L_E_T_ = '' "
cQryZ1 += " AND Z1_STATUS = '0' "
cQryZ1 += " AND Z1_EMISSAO BETWEEN CONVERT(VARCHAR(8), GETDATE() - 90, 112) "
cQryZ1 += "                            AND CONVERT(VARCHAR(8), GETDATE(), 112) "
	
//cQryZ1 := ChangeQuery(cQryZ1)
//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryZ1),cAliasZ1,.T.,.T.)
//dbSelectArea(cAliasZ1)

IF TCSQLExec(cQryZ1) >= 0
	PLSQuery(cQryZ1, cAliasZ1)
ELSE
	RETURN
ENDIF
dbSelectArea(cAliasZ1)
(cAliasZ1)->(DBGOTOP())

While !(cAliasZ1)->(EoF())
	cFilZ1		:= (cAliasZ1)->(FILIAL)
	cDocZ1		:= (cAliasZ1)->(DOC)
	cSerieZ1	:= (cAliasZ1)->(SERIE)
	cTpNF 		:= (cAliasZ1)->(TIPO)
	cEspec		:= (cAliasZ1)->(ESPECIE)
	nRecno		:= (cAliasZ1)->(RECNO)
	IF STARTJOB( "U_IMPNFZ101", getenvserver(), .T.,cEmpAnt,cFilZ1,cDocZ1,cSerieZ1,cTpNF,cEspec,nRecno)
		CONOUT("A nota fiscal "+cDocZ1+" - "+cSerieZ1+" foi incluida na sf1.")
	ELSE
	CONOUT("Erro ao inlcuir a nota fiscal "+cDocZ1+" - "+cSerieZ1+" na sf1.")
	ENDIF

(cAliasZ1)->(DBSKIP())
End
(cAliasZ1)->(dbCloseArea())
Return 



/*/{Protheus.doc} IMPNFZ101
	(long_description)
	@type  Static Function
	@author user
	@since 17/09/2019
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function IMPNFZ101(cEmpZ1,cFilZ1,cDoc,cSerie,cTpNF,cEspec,nRecno)
Local lAuto		:= .T.
Local cVldCFOP 	:= ""
Local errStr  	:= ""
Local warnStr 	:= ""
Local oXml 		:= NIL
Local cError   := ""
Local bError   := ErrorBlock({ |oError| cError := oError:Description})
Local lRet := .T.

	/*If FindFunction('WFPREPENV')
		RPCSetType(3)						// N�o consome licensa de uso
		wfPrepENV(cEmpZ1, cFilZ1)
	Else						// N�o consome licensa de uso
		Prepare Environment Empresa cEmpZ1 Filial cFilZ1	
	Endif
*/
	RPCSetType(3)		
	Prepare Environment Empresa cEmpZ1 Filial cFilZ1 Modulo "COM"
		CONOUT(cEmpAnt+cFilAnt+" Abriu a thread!")
//DbSelectArea("SZ1")
//DbSetOrder(1)
USE SZ1010 ALIAS SZ1 SHARED NEW VIA "TOPCONN"
Conout("Abriu a área da tabelas.")

SZ1->(DBGOTO(nRecno))
	conout("Posicionou no registro.")
	IF ALLTRIM(cEspec) $ "SPED" 
		oXML := XMLparser(SZ1->Z1_XML, "_", @cError, @cWarning )
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
	ENDIF

	IF cTpNF == "N" .AND. ALLTRIM(cEspec) $ "CTE"
	BEGIN SEQUENCE
		U_GeraCTe(SZ1->Z1_XML,lAuto)
	END SEQUENCE
	ELSEIF cTpNF == "N" .AND. ALLTRIM(cEspec) $ "SPED" .AND. substr(cVldCFOP,2,3) == '907'
	BEGIN SEQUENCE	
		U_GeraNFE(SZ1->Z1_XML,lAuto)
	END SEQUENCE
	ELSE	
	CONOUT("Este documento não pode ser automatizado!!!!!!")
	ENDIF

	ErrorBlock(bError)
	If ! Empty(cError)
	CONOUT("ERRO AO EXECUTAR A ROTINA...."+cEmpAnt+"|"+cFilAnt+"|"+cTpNF+"|"+cDoc+"|"+cSerie)
	CONOUT("Houve um erro..:  "+CRLF+CRLF+cError)
	lRet := .F.
	EndIf

	oXML := NIL
	
DBCLOSEAREA()
RESET ENVIRONMENT
Return lRet