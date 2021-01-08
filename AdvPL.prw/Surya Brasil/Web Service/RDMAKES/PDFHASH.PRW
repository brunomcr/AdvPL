#INCLUDE "protheus.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE 'DIRECTRY.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"
#INCLUDE "LOJNFCE.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "fileio.ch"

 /*/{Protheus.doc} xLeHash
    (long_description)
    @type  Function
    @author Alexsandro Salla
    @since 23/09/2019
    @version version
    @param 
    @return 
    @example
    U_xLeHash()
    @see (links_or_references)
    /*/
User Function xLeHash()
    Local cQuery        := ""
    Local cAliasC5      := GetNextAlias()
    Local cDocHash      := ""
    Local cLocal	    :="\Dossie\teste\hash"
    Local cRetorno      := ""
    Local nArqPdf       := ""
    Local cDir          := "\Dossie\teste\"
    Local cArqOk        := ""
    Local cDecode64     := ""
    Local cDecode641    := ""
    Local oFile         := ""
    Local aReg       := {}
    Local cLinhas       := ""
    Local nI            := 0
    Local nMax          := 0
   
    cQuery := "SELECT DISTINCT C5_FILIAL[FILIAL], C5_NUM[PEDIDO], R_E_C_N_O_ [RECNO]"
    cQuery += "FROM SC5030 "
    cQuery += "WHERE C5_XEMKTPL != '' AND D_E_L_E_T_ = '' "
    
    cQuery := changequery(cQuery)
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), (cAliasC5), .F., .T. )
    
    dbSelectArea(cAliasC5)
	dbGoTop()
    While (cAliasC5)->(!EoF())
     aadd(aReg,(cAliasC5)->RECNO)
     (cAliasC5)->(DbSkip())
    End
   dbCloseArea()

   nI := 99

    USE SC5030 ALIAS SC5 SHARED NEW VIA "TOPCONN"
    for nI := 1 to Len(aReg)
        SC5->(DBGOTO( aReg[nI] ))
        IF !EMPTY(SC5->C5_XEMKTPL)
            cDocHash := SC5->C5_XEMKTPL
            cArqOk := cDir+"etiqueta_mktplace_"+SC5->C5_NUM+".pdf"
            cDecode64      := Decode64(cDocHash,cArqOk,.F.)
            nArqPdf := FCREATE(cArqOk)
            FWrite(nArqPdf,cDecode64)
            //FWrite(cDocHash,cDecode64)
            FClose(nArqPdf)
        ENDIF
    NEXT
    DBCLOSEAREA()

    nI := 1

Return 



 /*/{Protheus.doc} xEtqMktPl
    (long_description)
    @type  Function
    @author user
    @since 25/09/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
USER Function xEtqMktPl(xEmp,xFil,cRecno,lAuto)
    //Variaveis para salvar arquivo em .PDF
	Local cLocal		:= "\Dossie\"
	Local cArqPdf	    := ""
    Local cArqOk    	:= ""
    Local cDocHash      := ""
    //Try catch
    Local cError   		:= ""
    Local bError   		:= ErrorBlock({ |oError| cError := oError:Description})
    Local nLog          := 0
   
    IF !EMPTY(lAuto)
        IF lAuto
            RPCSetType(3)
            If FindFunction('WFPREPENV')
                lAuto := .T.
                RPCSetType( 3 )						// Nï¿½o consome licensa de uso
                wfPrepENV(xEmp, xFil)
                //wfPrepENV("03", "00")
                conout("Preparou ambiente. . . Etiqueta MarketPlace")
            Else
                lAuto := .T.
                RPCSetType( 3 )						// Nï¿½o consome licensa de uso
                Prepare Environment Empresa xEmp Filial xFil
                conout("Preparou ambiente. . . Etiqueta MarketPlace")
            Endif         
        ENDIF
    ENDIF

    BEGIN SEQUENCE
        USE SC5030 ALIAS SC5 SHARED NEW VIA "TOPCONN"
        SC5->(DBGOTO( cRecno ))
        IF !EMPTY(SC5->C5_XEMKTPL)
            cDocHash := SC5->C5_XEMKTPL
            cArqOk := cLocal+SC5->C5_NUM+"\etiqueta_"+SC5->C5_NUM+".pdf"
            cDecode64      := Decode64(cDocHash,cArqOk,.F.)
            nArqPdf := FCREATE(cArqOk)
            SLEEP(1000)
            FWrite(nArqPdf,cDecode64)
            SLEEP(5000)
            FClose(nArqPdf)
        ELSE 
            IF !File(cLocal+SC5->C5_NUM+"\EtiquetaMktPlace.txt")
                nLog := FCREATE(cLocal+SC5->C5_NUM+"\EtiquetaMktPlace.txt")
            ELSE
                nLog := FREAD(cLocal+SC5->C5_NUM+"\EtiquetaMktPlace.txt")
            ENDIF    
           
            cMsgErro := "Não há o hash de etiqueta informado no Pedido de vendas. "+SC5->C5_NUM
            IF nLog = -1
                conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
                CONOUT(cMsgErro)
            ELSE
                FWRITE(nLog,CRLF+cMsgErro+CRLF)
                FClose(nLog)
            ENDIF
        ENDIF
        DBCLOSEAREA()
    END SEQUENCE
    ErrorBlock(bError)
            
    IF !EMPTY(cError)
        IF !File(cLocal+SC5->C5_NUM+"\EtiquetaMktPlace.txt")
            nLog := FCREATE(cLocal+SC5->C5_NUM+"\EtiquetaMktPlace.txt")
        ELSE
            nLog := FREAD(cLocal+SC5->C5_NUM+"\EtiquetaMktPlace.txt")
        ENDIF    
        
        if nLog = -1
            conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
            CONOUT("Erro ao criar etiqueta do pedido"+SC5->C5_NUM+"Erro: "+cError)
        else
            FWrite(nLog,CRLF+"Erro ao criar etiqueta do pedido"+SC5->C5_NUM+"Erro: "+cError+CRLF)
            FClose(nLog)
        endif
    ENDIF
Return 