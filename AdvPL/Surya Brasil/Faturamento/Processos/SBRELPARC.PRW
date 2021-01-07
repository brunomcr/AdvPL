#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"
#include "APWEBEX.CH" 
#include "ap5mail.ch" 



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SBRELPARC	บ Autor ณ Caio de Paula      บ Data ณ  12/06/20   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rela็ใo de NF para schedule por Cupom                       บฑฑ
ฑฑบ          ณ                                                            	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function SBRELPARC()
local cAlias  		:= GetNextAlias()
local cQuery		:= ""  
local datade		:= CTOD("  /  /  ")
local dataate		:= CTOD("  /  /  ")
//local datade		:= cAno+"0201"
//local dataate		:= cAno+"0229"
local cCupom		:= ""
local nTotal		:= 0
local nTotCom   	:= 0
local nCol			:= 8
local aDadosExcel	:= {}
local cAuditMail    := ""           
local cSepara       := ""
Local mesext        := ""  

Private xEmp 		:= aParam[1]
Private xFil 		:= aParam[2] 
RPCSetType(3)
If FindFunction('WFPREPENV')
	lAuto := .T.
	RPCSetType( 3 )						// Nรฏยฟยฝo consome licensa de uso
	wfPrepENV(xEmp, xFil)
	//wfPrepENV("03", "00")
	conout("Preparou ambiente. . .")
Else
	lAuto := .T.
	RPCSetType( 3 )						// Nรฏยฟยฝo consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil
	conout("Preparou ambiente. . .")
Endif 

Private _lEnviado    := .F.
Private _cUsuario    := Upper(AllTrim(cUserName))
cAuditMail    := SuperGetMV("SB_MAILECOM",.t.,"caio.santos@suryabrasil.com")  
cSepara       := SuperGetMv("SB_SEPPART",.F.,";")
datade := FirstDate(MonthSub(dDatabase,1))
dataate:= LastDate(datade)
mesext := MesExtenso(MONTH(datade))
cQuery := "SELECT "
cQuery += "[CUPOM]=SC5.C5_XCUPOM, "
cQuery += "[CLIENTE]= SA1.A1_NOME, "
cQuery += "[PEDIDO]=SC5.C5_XMAGCOD, "
cQuery += "[NOTA_FISCAL]=SF2.F2_DOC, "
cQuery += "[VALOR]=SF2.F2_VALMERC, "
cQuery += "[DATAFATURA]=SF2.F2_EMISSAO, "
cQuery += "[STATUS]= 'FATURADO' , "
cQuery += "[PARCEIRO]=SA2.A2_NOME, "
cQuery += "[CPF_PARCEIRO]=SA2.A2_CGC , "
cQuery += "[EMAIL_PARC]=SA2.A2_EMAIL, "
cQuery += "[ONG]=SA2.A2_XONG, "
cQuery += "[CNPJONG]=SA2.A2_XCNPJON, "
cQuery += "[NOMEONG]=SA2.A2_NOMEONG, "
cQuery += "[INFLUENCER]=SA2.A2_XINFLUE, "
cQuery += "[INSTAGRAM]=SA2.A2_XINSTAG, "
cQuery += "[FACEBOOK]=SA2.A2_XFACEBO, "
cQuery += "[TWITTER]=SA2.A2_XTWITTE, "
cQuery += "[YOUTUBE]=SA2.A2_XYOUTUB, "
cQuery += "[BANCO]=SA2.A2_BANCO, "
cQuery += "[AGENCIA]=SA2.A2_AGENCIA, "
cQuery += "[CONTA]=SA2.A2_CONTA, "
cQuery += "[CGCFAV]=SA2.A2_XCGCFAV, "
cQuery += "[NOMFAV]=SA2.A2_XNOMFAV, "
cQuery += "[TEL]=SA2.A2_TEL, "
cQuery += "[COMOCONHECEU]=SA2.A2_XCOMO "
cQuery += "FROM SF2030 SF2 "
cQuery += "INNER JOIN SA1030 SA1 ON (SF2.F2_CLIENTE = SA1.A1_COD) "
cQuery += "INNER JOIN SC5030 SC5 ON (SF2.F2_DOC = SC5.C5_NOTA AND SF2.F2_SERIE = SC5.C5_SERIE) "
cQuery += "INNER JOIN SA2030 SA2 ON (UPPER(LTRIM(RTRIM(SC5.C5_XCUPOM))) = UPPER(LTRIM(RTRIM(SA2.A2_XCUPOM))))"
cQuery += "WHERE SF2.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' "
cQuery += "AND SF2.F2_EMISSAO BETWEEN '"+DTOS(datade)+"' AND '"+DTOS(dataate)+"' "
cQuery += "AND SC5.C5_XCANSAI = '2' AND C5_XCUPOM <> '' "
cQuery += "ORDER BY SC5.C5_XCUPOM,SC5.C5_XMAGCOD"
cQuery := changeQuery(cQuery)


if Select(cAlias) <> 0	
	(cAlias)->(DbCloseArea())
endif
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)},"Selecionando Registros...")
(cAlias)->(dbgotop())

Do While (cAlias)->(!eof())
	cCupom	    := alltrim((cAlias)->(CUPOM))
    aPartner    := {(cAlias)->(CUPOM),(cAlias)->(PARCEIRO),(cAlias)->(CPF_PARCEIRO),(cAlias)->(TEL),;
                (cAlias)->(EMAIL_PARC),(cAlias)->(ONG),(cAlias)->(CNPJONG),(cAlias)->(NOMEONG),;
                (cAlias)->(INFLUENCER),(cAlias)->(INSTAGRAM),(cAlias)->(FACEBOOK),;
                (cAlias)->(TWITTER),(cAlias)->(YOUTUBE),(cAlias)->(BANCO),(cAlias)->(AGENCIA),;
                (cAlias)->(CONTA),(cAlias)->(CGCFAV),(cAlias)->(NOMFAV),(cAlias)->(COMOCONHECEU)}        
          
    aDadosExcel := {}
    aAdd(aDadosExcel, {"CUPOM","CLIENTE", "PEDIDO","NOTA","VALOR","% COMISSAO","VALOR COMISSAO","DATA"})
        nTotal	:= 0
        nTotCom := 0
    While (cAlias)->(!eof()) .and. cCupom == alltrim((cAlias)->(CUPOM))
        aAdd(aDadosExcel,{(cAlias)->(CUPOM),(cAlias)->(CLIENTE),(cAlias)->(PEDIDO),;
            (cAlias)->(NOTA_FISCAL),cValtoChar(ROUND((cAlias)->(VALOR),2)),iif(aPartner[6]=="1","20%","10 %"),;
            cValtoChar(ROUND(iif(aPartner[6]=="1",(cAlias)->(VALOR)*0.2,(cAlias)->(VALOR)*0.1),2)),;
            AjustaData((cAlias)->(DATAFATURA))}) 

        nTotal	   += (cAlias)->(VALOR)
        nTotCom    += iif(aPartner[6]=="1",(cAlias)->(VALOR)*0.2,(cAlias)->(VALOR)*0.1)
        (cAlias)->(dbskip())
    enddo
    aAdd(aDadosExcel,{"TOTAL","","","",TRANSFORM(nTotal,"@E 999999.99"),iif(aPartner[6]=="1","20%","10 %"),;
        TRANSFORM(nTotCom,"@E 999999.99"),""})		
    //geraexcel
    //_pcOrigem	:= NIL
    _pcOrigem   := ""
    //_pcDestino 	:= aPartner[5]
    //_pcDestino	+= ","+cAuditMail
    _pcDestino 	:= "parceiros@suryabrasil.com" //aPartner[5]
    _pcSubject 	:= "Surya Brasil: Relatorio de Comissao   #"+UPPER(mesext)+"# CUPOM: "+ UPPER(cCupom)
    _pcBody		:= GeraBody(aPartner,mesext,nTotCom)	
    _plAutomatico := .T.
    _pcBcc		:= ""
    _pcArquivo := U_Run_Excel(aDadosExcel,nCol,cSepara) 
    //_pcArquivo := NIL
    //enviaporemail
    U_SBENVMAIL(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
enddo
RESET ENVIRONMENT
Return    

Static Function AjustaData(cData)
local ano
local dia
local mes
ano := substr(cData,1,4)
mes := substr(cData,5,2)
dia := substr(cData,7,2)
cData := dia+"/"+mes+"/"+ano
Return(cData)

Static Function Gerabody(aPartner,cmesext,nTotCom)
Local cTemplate		:= "/workflow/html/ERelParc.html"
Local cHtml         := ""
Local _pcBody       := ""
cHTML	:= MemoRead(cTemplate)					//Le o HTML

//Monta o HTML
_pcBody := UpStrTran(cHTML   ,"%PARCEIRO%"	,Alltrim(aPartner[2])       )
_pcBody := UpStrTran(_pcBody ,"%CUPOM%"		,Alltrim(aPartner[1])       )
_pcBody := UpStrTran(_pcBody ,"%mes%"		,Alltrim(cmesext)           )
_pcBody := UpStrTran(_pcBody ,"%Total%"	    ,TRANSFORM(nTotCom,"@E 999999.99"))
_pcBody := UpStrTran(_pcBody ,"%Bco%"	    ,Alltrim(aPartner[14])      )
_pcBody := UpStrTran(_pcBody ,"%Agencia%"	,Alltrim(aPartner[15])      )
_pcBody := UpStrTran(_pcBody ,"%CC%"	    ,Alltrim(aPartner[16])      )
_pcBody := UpStrTran(_pcBody ,"%CPFFAV%"	,Alltrim(aPartner[17])      )
_pcBody := UpStrTran(_pcBody ,"%NOMEDEP%"	    ,Alltrim(aPartner[18])      )
Return _pcBody
