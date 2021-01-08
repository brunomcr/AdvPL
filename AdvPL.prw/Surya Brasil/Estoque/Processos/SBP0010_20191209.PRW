#include "Protheus.ch"
#include "topconn.ch"  
#include "Totvs.ch"  
#include "tbiconn.ch"
#include "tbicode.ch"
#INCLUDE "fileio.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝ»±±
±±ºProg.  ³ SBP0010 º Uso ³ Surya Brasil º Modulo ³ SIGAEST º Data ³ 30/09/19 º±±
±±ÌÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.  ³ Rotina para zerar os armazéns inativos.                    		  º±±
±±º       ³                                                                   º±±
±±ÌÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±º Autor ³ Alexsandro Salla             º Contato ³(11) 97961-7915           º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
    U_SBP0010({'03','00'})
    U_SBP00102({'01','00'})
    U_xZerB2({'03','00'})
    '07','08','09','12','13','14','22','32','33','55','56','88','95','96','97','99'
    '13','85','10','70','ZZ','80','81','97','75','5 ','  ','56','40','55','05','17','02','66','18','86','90','77','76','08','16','91','30','04','03','72','60','99','21','26','24','50','11','12','45','35','95'
*/

User Function SBP0010(aParam)
Local xEmp      := aParam[1]
Local xFil      := aParam[2]
Local lThreadB2 := .F.
Local lRetB9    := .F.
Local lRetBJ    := .F.
Local lThreadB8 := .F.
Local cArmzn    := ""
Local cContB2   := ""
Local cContB9   := ""
Local cContB8   := ""
Local cAliasC1  := GetNextAlias()
Local cAliasC2  := GetNextAlias()
Local cAliasC3  := GetNextAlias()
Local nCont1    := 0
Local nCont2    := 0
Local nCont3    := 0
//Cria o ambiente
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

    cArmzn    := GETMV("SB_ARMZERO")

    cContB2 += "SELECT COUNT(*)/100 + 5 [CONT] "
    cContB2 += "FROM "+RetSqlName("SB2")+" SB2 "
    cContB2 += "WHERE SB2.D_E_L_E_T_ = '' "
    cContB2 += "AND B2_QATU <> 0 "
    cContB2 += "AND B2_LOCAL NOT IN ("+cArmzn+") "
    cContB2 += "AND B2_FILIAL = '"+xFil+"' "
    cContB2 := changequery(cContB2)

    dbUseArea( .T., "TOPCONN", TcGenQry(,,cContB2), cAliasC2, .F., .T. )

    cContB9 += " SELECT COUNT(*)/100 + 5 [CONT] "
    cContB9 += " FROM "+RetSqlName("SB9")+" SB9 "
    cContB9 += " WHERE SB9.D_E_L_E_T_ = '' "
    cContB9 += " AND B9_DATA <> '' "
    cContB9 += " AND B9_LOCAL NOT IN ("+cArmzn+") "
    cContB9 += " AND B9_FILIAL = '"+xFil+"' "
    cContB9 += " AND B9_DATA >= '20181201' "

    cContB9 := changequery(cContB9)

    dbUseArea( .T., "TOPCONN", TcGenQry(,,cContB9), cAliasC1, .F., .T. )

    nIx         := 0
    //Deleta os fechamentos.
    WHILE  (cAliasC1)->CONT > nCont1
        lRetB9      := STARTJOB("U_xDelB9", getenvserver(), .T.,xEmp,xFil)
        sleep(100)
        nCont1 ++
    END
    /*
    //Ser� respons�vel zerar os itens negativos da SB2.
    While (cAliasC2)->CONT > nCont2
        lThreadB2   := STARTJOB("U_SBP00102", getenvserver(), .T., aParam)
        sleep(100)
        nCont2 ++
    END
*/
    cContB8 += " SELECT COUNT(*)/100 + 5 [CONT] " 
    cContB8 += " FROM "+RetSqlName("SB8")+" SB8 "
    cContB8 += " WHERE SB8.D_E_L_E_T_ = '' "
    cContB8 += " AND B8_SALDO <> 0 "
    cContB8 += "AND B8_LOCAL NOT IN ("+cArmzn+") "
    cContB8 += "AND B8_FILIAL = '"+xFil+"' "
    cContB8 := changequery(cContB8)

    dbUseArea( .T., "TOPCONN", TcGenQry(,,cContB8), cAliasC3, .F., .T. )
    //Ser� responsavel por zerar os itens da SB8
    nIx         := 0
    While (cAliasC3)->CONT > nCont3
        lMsErroAuto := .F.
        conout("Antes do exeauto do saldo...")
        MSExecAuto({|x| MATA300(x)}, .T.)
        If lMsErroAuto
            Conout("Erro ao realizar o execauto do refaz saldos!")
        ENDIF
    
        lThreadB8   := STARTJOB("U_xIguaB8", getenvserver(), .T., aParam)
        sleep(100)
        nCont3 ++
    END
    
   // lRetB8      := STARTJOB("U_xAJB8",getenvserver(),.T.,xEmp,xFil)
    //nIx         := 0
    //lThreadB2   := .F.
    //nIx         := 0
   // lThreadB2   := STARTJOB("U_SBP00102", getenvserver(), .T., aParam)
    //nIx         := 0
   // U_SBP00101(aParam)
    nIx := 0
RETURN



/*/{Protheus.doc} User Function SBP00102
    (long_description)
    @type  Function
    @author user
    @since 03/10/2019
    @version version
    @param aParam
    @return 
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function SBP00102(aParam)
    Local xEmp      := aParam[1]
    Local xFil      := aParam[2]
    Local xProdut   := ""
    Local xArmzn    := ""
    Local cAliasB2  := ""
    Local cArmzn    := ""
    Local cQueryB2  := ""
    Local aCabN     := {}
    Local aCabP     := {}
    Local aItemN    := {}
    Local aItemP    := {}
    Local cProd     := ""
    Local cLocal    := ""
    Local nI        := 0
    Local nCusto    := 0
    Local aTotItm   := {}
    Local nBloq     := 0
    Local lBloqArm  := .F.
    Local cTpMovSN  := ""
    Local cTpMovSP  := ""
    Local cTpMovEN  := ""
    Local cTpMovEP  := ""
    Local dDataC    := ""
    //Erros
    Local cError   	:= ""
    Local bError   	:= ErrorBlock({ |oError| cError := oError:Description})
    Local nLog      := 0
    Local cData     := "" 
    Local cDir      := "\erros\"

    Private lMsErroAuto := .F.

    IF Len(aParam) > 2
    xProdut := aParam[3]
    xArmzn := aParam[4]
    ENDIF
    //Cria o ambiente
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
    dDataC    := dDataBase
    cAliasB2  := GetNextAlias()
    cArmzn    := GETMV("SB_ARMZERO")
     //cArmzn := "'03','YY','00'"
    dDataC    := STOD(GETMV("SB_DTCORTE"))

    cTpMvPC     := GETMV("SB_TPMVPC") // Tipo de movimento Itens Positivos COM CUSTO
    cTpMvPSC    := GETMV("SB_TPMVPSC") // Tipo de movimento Itens Positivos SEM CUSTO
    cTpMvNC     := GETMV("SB_TPMVNC") // Tipo de movimento Itens Negativos COM CUSTO
    cTpMvNSC    := GETMV("SB_TPMVNSC") // Tipo de movimento Itens Negativos SEM CUSTO
   
    IF !EMPTY(cArmzn) .AND. VALTYPE(cArmzn) == 'C' .AND. len(cArmzn) >= 4 //Verifica se os armazéns foram definidos para evitar zerar TUDO!
        cQueryB2 := "SELECT B2_FILIAL [FILIAL] "
        cQueryB2 += ", B2_COD [COD] "
        cQueryB2 += ", B2_LOCAL [LOCAL] "
        cQueryB2 += ", B2_QATU [SALDO] "
        cQueryB2 += ", B2_VATU1 [VATU] "
        cQueryB2 += ", SB2.R_E_C_N_O_ [RECNO] "
        cQueryB2 += "FROM "+RetSqlName("SB2")+" SB2 "
        cQueryB2 += "WHERE SB2.D_E_L_E_T_ = '' "
        cQueryB2 += "AND B2_QATU <> 0 "
        cQueryB2 += "AND B2_LOCAL NOT IN ("+cArmzn+") "
        cQueryB2 += "AND B2_FILIAL = '"+xFil+"' "
        cQueryB2 += "ORDER BY FILIAL, COD "
        cQueryB2 := changequery(cQueryB2)

        dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryB2), cAliasB2, .F., .T. )

    WHILE !(cAliasB2)->(EoF())
        lThread1    := .F.
        lThread2    := .F.
        _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
        cProd       := (cAliasB2)->COD
        nBloq       := 0
        lBloqArm    := .F.

    //    U_xAtuSald(xEmp, xFil,(cAliasB2)->COD, (cAliasB2)->LOCAL)
        sleep(10)
        lBloqArm    := xBlqArm((cAliasB2)->LOCAL,1)
        sleep(15)
        nBloq       := xBlqProd((cAliasB2)->COD,1,0)
        sleep(10)
        IF (cAliasB2)->SALDO > 0
            IF (cAliasB2)->VATU < 0 
                nCusto := ((cAliasB2)->VATU*(-1)) 
            ELSE 
                nCusto := ((cAliasB2)->VATU) 
            ENDIF
            If nCusto != 0
                //Cabeçalho Itens positivos.
                aCabP := {{"D3_FILIAL"     ,(cAliasB2)->FILIAL                  ,Nil},;
                {"D3_DOC"          ,_cNumDoc                                    ,Nil},;
                {"D3_TM"           ,cTpMvPC                                     ,Nil},;
                {"D3_EMISSAO"     ,dDataC                                      ,Nil},;
                {"D3_CC"           ,''                                          ,Nil}}
                //Itens positivos
                aItemP := {{"D3_COD"       ,ALLTRIM((cAliasB2)->COD)            ,NIL},;
                {"D3_QUANT" ,(cAliasB2)->SALDO                                  ,NIL},;
                {"D3_LOCAL" ,(cAliasB2)->LOCAL                                  ,NIL},;
                {"D3_CUSTO1" , nCusto                                           ,NIL},;
                {"D3_IDENT" ,PROXNUM()                                          ,NIL},;
                {"D3_NUMSEQ" ,PROXNUM()                                         ,NIL},;
                {"D3_XMOV" ,"Ajuste de estoque automatico"                      ,NIL},;
                {"D3_USUARIO","Admin"                                           ,NIL}}       
            ELSE
                //Cabeçalho Itens positivos.
                aCabP := {{"D3_FILIAL"     ,(cAliasB2)->FILIAL                  ,Nil},;
                {"D3_DOC"          ,_cNumDoc                                    ,Nil},;
                {"D3_TM"           ,cTpMvPSC                                    ,Nil},;
                {"D3_EMISSAO"     ,dDataC                                       ,Nil},;
                {"D3_CC"           ,''                                          ,Nil}}
                //Itens positivos
                aItemP := {{"D3_COD"       ,ALLTRIM((cAliasB2)->COD)           ,NIL},;
                {"D3_QUANT" ,(cAliasB2)->SALDO                                 ,NIL},;
                {"D3_LOCAL" ,(cAliasB2)->LOCAL                                 ,NIL},;
                {"D3_CUSTO1" ,nCusto                                           ,NIL},;
                {"D3_IDENT" ,PROXNUM()                                         ,NIL},;
                {"D3_NUMSEQ" ,PROXNUM()                                        ,NIL},;
                {"D3_XMOV" ,"Ajuste de estoque automatico"                     ,NIL},;
                {"D3_USUARIO","Admin"                                          ,NIL}}  
            ENDIF
            BEGIN SEQUENCE
            aadd(aTotItm,aItemP)
            MSExecAuto({|x,y,z|MATA241(x,y,z)},aCabP,aTotItm,3)               
           // MATA241(aCabP,aItemP,3)
           sleep(10)
            END SEQUENCE
            ErrorBlock(bError)

            if lMsErroAuto
                //MostraErro()
                CONOUT("Erro ao gerar movimenta��o" +cError+" "+(cAliasB2)->COD+"_"+(cAliasB2)->LOCAL)
               // DisarmTransaction()
                //break
            Else
            
            CONOUT("Feito SD3 Positivos " +(cAliasB2)->COD+"_"+(cAliasB2)->LOCAL)
            EndIf
        
            cError   	:= ""
            bError   	:= ErrorBlock({ |oError| cError := oError:Description})

        ELSE
        IF (cAliasB2)->VATU < 0 
            nCusto := ((cAliasB2)->VATU*(-1)) 
        ELSE 
            nCusto := (cAliasB2)->VATU 
        ENDIF 
        
        IF nCusto != 0
            //Cabeçalho Itens negativos
            aCabN := {{"D3_FILIAL"     ,(cAliasB2)->FILIAL       ,Nil},;
            {"D3_DOC"          ,_cNumDoc                         ,Nil},;
            {"D3_TM"           ,cTpMvNC                          ,Nil},;
            {"D3_EMISSAO"     ,dDataC                         ,Nil},;
            {"D3_CC"           ,''                               ,Nil}}
            
            //Items negativos
            aItemN := {{"D3_COD"       ,ALLTRIM((cAliasB2)->COD)           ,NIL},;
            {"D3_QUANT" ,((cAliasB2)->SALDO*(-1))                          ,NIL},;
            {"D3_LOCAL" ,(cAliasB2)->LOCAL                                 ,NIL},;
            {"D3_CUSTO1", nCusto                                           ,NIL},;
            {"D3_IDENT" ,PROXNUM()                                         ,NIL},;
            {"D3_NUMSEQ",PROXNUM()                                         ,NIL},;
            {"D3_XMOV" ,"Ajuste de estoque automatico"                     ,NIL},;
            {"D3_USUARIO","Administrador"                                  ,NIL}}
        ELSE
            //Cabeçalho Itens negativos
            aCabN := {{"D3_FILIAL"     ,(cAliasB2)->FILIAL       ,Nil},;
            {"D3_DOC"          ,_cNumDoc                         ,Nil},;
            {"D3_TM"           ,cTpMvNSC                         ,Nil},;
            {"D3_EMISSAO"     ,dDataC                         ,Nil},;
            {"D3_CC"           ,''                               ,Nil}}
            //Items negativos
            aItemN := {{"D3_COD"       ,ALLTRIM((cAliasB2)->COD)           ,NIL},;
            {"D3_QUANT" ,((cAliasB2)->SALDO*(-1))                          ,NIL},;
            {"D3_LOCAL" ,(cAliasB2)->LOCAL                                 ,NIL},;
            {"D3_IDENT" ,PROXNUM()                                         ,NIL},;
            {"D3_NUMSEQ",PROXNUM()                                         ,NIL},;
            {"D3_XMOV" ,"Ajuste de estoque automatico"                     ,NIL},;
            {"D3_USUARIO","Administrador"                                  ,NIL}}            
        ENDIF
            BEGIN SEQUENCE
            aadd(aTotItm,aItemN)
            //Itens Negativos     
            MSExecAuto({|x,y,z|MATA241(x,y,z)},aCabN,aTotItm,3)
         //  MATA241(aCabP,aItemP,3)
            END SEQUENCE   
            ErrorBlock(bError)
    
            If lMsErroAuto
                //MostraErro()
                CONOUT("Erro ao gerar movimenta��o "+cError+" "+(cAliasB2)->COD+"_"+(cAliasB2)->LOCAL)
               // DisarmTransaction()
                //break
            Else
                
                CONOUT("Feito SD3 Negativos " +(cAliasB2)->COD+"_"+(cAliasB2)->LOCAL)
            EndIF
        EndIf

            cError   	:= ""
            bError   	:= ErrorBlock({ |oError| cError := oError:Description})
    
      //  U_xAtuSald(xEmp, xFil,(cAliasB2)->COD, (cAliasB2)->LOCAL)
        IF  lBloqArm
            sleep(10)
            lBloqArm := xBlqArm((cAliasB2)->LOCAL,0)
        ENDIF
        
        IF  nBloq > 0
            sleep(10)
            nBloq := xBlqProd( (cAliasB2)->COD,0,nBloq)
        ENDIF

        aCabP   := {}
        aItemP  := {}
        aCabN   := {}
        aItemN  := {}
        aTotItm := {}
        nIx := 0
        (cAliasB2)->(DbSkip())
    END

    ENDIF
nIx := 0
Return  .T.


/*/{Protheus.doc} xDelB9
    Deleta os registros da SB9 dos armaz�ns inativos.
    para novo calculo de saldo atual e ajustes.

    @type  User Function
    @author user
    @since 17/10/2019
    @version version
    @param cCodProd, cLocP
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xDelB9(xEmp,xFil)
    Local nCont     := 0
    Local nI        := 0
    Local lRet      := .T.
    local lRetBJ    := .F.
    Local cAliasB9  := GetNextAlias()
    Local cQueryB9  := ""
    Local cArmzn    := ""

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


    cArmzn    := GETMV("SB_ARMZERO")

    cQueryB9 += " SELECT DISTINCT B9_FILIAL [FILIAL], B9_COD [COD], B9_LOCAL [LOCAL], B9_DATA [DATAB9], R_E_C_N_O_ [RECNO] "
    cQueryB9 += " FROM "+RetSqlName("SB9")+" SB9 "
    cQueryB9 += " WHERE SB9.D_E_L_E_T_ = '' "
   // cQueryB9 += " AND B9_DATA <> '' "
    cQueryB9 += " AND B9_DATA >= '20181201' "
   // cQueryB9 += " AND B9_LOCAL NOT IN ("+cArmzn+") "

    cQueryB9 += " AND B9_FILIAL = '"+xFil+"' "

    cQueryB9 := changequery(cQueryB9)
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryB9), cAliasB9, .F., .T. )

    while !(cAliasB9)->(EoF())
        lRetBJ  := .F.
        DbSelectArea("SB9")
        DbGoTo((cAliasB9)->RECNO)

        RecLock('SB9',.F.)
            SB9->(DbDelete())
        SB9->(MsUnlock())
                
        lRet := .T.

        lRetBJ := U_xDelBJ(xFil,(cAliasB9)->COD, (cAliasB9)->LOCAL)

        (cAliasB9)->(DbSkip())
    END

    IF lRet
        CONOUT("Excluiu os registros da B9")
    ENDIF

Return lRet

/*/{Protheus.doc} xDelBJ
    Deleta os registros da SBJ dos armaz�ns inativos.
    para novo calculo de saldo atual e ajustes.
    @type  User Function
    @author user
    @since 18/10/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xDelBJ(xFil,cProd, cLocal)
    Local nCont     := 0
    Local nI        := 0
    Local lRet      := .T.
    Local cAliasBJ  := GetNextAlias()
    Local cQueryBJ  := ""
    Local cArmzn    := ""

    cArmzn          := GETMV("SB_ARMZERO")

    cQueryBJ += " SELECT DISTINCT BJ_FILIAL [FILIAL], BJ_COD [COD], BJ_DATA [DATABJ], R_E_C_N_O_ [RECNO] "
    cQueryBJ += " FROM "+RetSqlName("SBJ")+" SBJ "
    cQueryBJ += " WHERE SBJ.D_E_L_E_T_ = '' "
    //cQueryBJ += " AND BJ_DATA <> '' "
    cQueryBJ += " AND BJ_DATA >= '20181201' "
    //cQueryBJ += " AND BJ_LOCAL NOT IN ("+cArmzn+") "
    cQueryBJ += " AND BJ_FILIAL = '"+xFil+"' "
    cQueryBJ += " AND BJ_COD   = '"+cProd+"' "
    cQueryBJ += " AND BJ_LOCAL = '"+cLocal+"' "

    cQueryBJ := changequery(cQueryBJ)
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryBJ), cAliasBJ, .F., .T. )

    while !(cAliasBJ)->(EoF())
        DbSelectArea("SBJ")
        DbGoTo((cAliasBJ)->RECNO)

        RecLock('SBJ',.F.)
            SBJ->(DbDelete())
        SBJ->(MsUnlock())
                
        lRet := .T.

        (cAliasBJ)->(DbSkip())
    END

    IF lRet
        CONOUT("Excluiu os registros da BJ")
    ENDIF

    (cAliasBJ)->(DBCLOSEAREA())
Return lRet


/*/{Protheus.doc} User Function xProcB8
    (long_description)
    @type  Function
    @author user
    @since 01/10/2019
    @version version
    @param xEmp,xFil,cProd,cLocal,cLote,cNumDoc
    @return 
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xProcB8(xEmp,xFil,cProd,cLocal,cLote,cNumDoc,cDtLote)
    Local cQueryB8x := ""
    Local cAliasB8x := GetNextAlias()

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

    cQueryB8x := "SELECT B8_FILIAL [FILIAL], B8_PRODUTO [COD],B8_LOCAL [LOCAL], B8_LOTECTL [LOTE], B8_DOC [DOC], SB8.R_E_C_N_O_ [RECNO] "  
    cQueryB8x += " FROM "+RetSqlName("SB8")+" SB8 "
    cQueryB8x += "WHERE SB8.D_E_L_E_T_ = '' "
    cQueryB8x += "AND  B8_FILIAL = '"+xFil+"' "
    cQueryB8x += "AND B8_PRODUTO = '"+cProd+"' "
    cQueryB8x += "AND B8_LOCAL = '"+cLocal+"' "
    cQueryB8x += "AND B8_LOTECTL = '"+cLote+"' "
    cQueryB8x += "AND B8_DOC = '"+cNumDoc+"' "

    cQueryB8x := changequery(cQueryB8x)
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryB8x), cAliasB8x, .F., .T. )

    while !(cAliasB8x)->(EoF())
        DbSelectArea("SB8")

        IF !EMPTY(SB8->(DbGoTo( (cAliasB8x)->RECNO ) ) )
                RecLock("SB8", .F.)
            IF !EMPTY( SB8->B8_NUMLOTE )
                SB8->B8_NUMLOTE := ""
            ENDIF
            SB8->B8_DATA := STOD(cDtLote)
            MsUnLock()
        ENDIF

        (cAliasB8x)->(DbSkip())
    end

Return .T.


/*/{Protheus.doc} User Function ProcD5
    (long_description)
    @type  Function
    @author user
    @since 01/10/2019
    @version version
    @param xEmp,xFil,cProd,cLocal,cLote
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xProcD5(xEmp,xFil,cProd,cLocal,cLote,cNumDoc)
    Local cQueryD5 := ""
    Local cAliasD5 := GetNextAlias()
    
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

    cQueryD5 := "SELECT D5_FILIAL [FILIAL], D5_DOC [DOC], D5_PRODUTO [COD]"
    cQueryD5 += ",D5_LOCAL [LOCAL]"
    cQueryD5 += ",D5_LOTECTL [LOTE], SD5.R_E_C_N_O_ [RECNO] "
    cQueryD5 += "FROM "+RetSqlName("SD5")+" SD5 "
    cQueryD5 += "WHERE SD5.D_E_L_E_T_ = '' "
    cQueryD5 += "AND D5_DOC = '"+cNumDoc+"' "
    cQueryD5 += "AND D5_PRODUTO = '"+cProd+"' "
    cQueryD5 += "AND D5_LOCAL = '"+cLocal+"' "
    IF !EMPTY(cLote)
        cQueryD5 += "AND D5_LOTECTL =  '"+cLote+"'   "
    ENDIF
    cQueryD5 := changequery(cQueryD5)
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryD5), cAliasD5, .F., .T. )
    
    while !(cAliasD5)->(Eof())
        dbSelectArea("SD5")
        IF !EMPTY(SD5->(DbGoto( (cAliasD5)->RECNO )))
            IF !EMPTY( SD5->D5_NUMLOTE )
                RecLock("SD5", .F.)
                 SD5->D5_NUMLOTE := ""
                MsUnLock()
            ENDIF
        ENDIF
        (cAliasD5)->(DbSkip())
    end

Return .T.


/*/{Protheus.doc} User Function xAtuSald
    (long_description)
    @type  Function
    @author user
    @since 30/09/2019
    @version version
    @param cXEmp, cXFil,cProd, cLocal
    @return 
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xAtuSald(cXEmp, cXFil,cProd, cLocal)
    //Identifica que será executado via JOB
    Local lJob := .T.
    //Declarações
    Local cPerg := ""
    //Try catch
    Local cError        := ""
    Local bError   		:= ErrorBlock({ |oError| cError := oError:Description})
    Local nLog          := 0
   //Prepara ambiente
    IF !EMPTY(lJob)
        IF lAuto
            RPCSetType(3)
            If FindFunction('WFPREPENV')
                RPCSetType( 3 )						// Nï¿½o consome licensa de uso
                wfPrepENV(cXEmp, cXFil)
                //wfPrepENV("03", "00")
                conout("Preparou ambiente. . .")
            Else
                RPCSetType( 3 )						// Nï¿½o consome licensa de uso
                Prepare Environment Empresa cXEmp Filial cXFil
                conout("Preparou ambiente. . .")
            Endif         
        ENDIF
    ENDIF
    CONOUT("Atualiza Saldo!")

    cPerg := "MTA300"
    /*u_zAtuPerg(cPerg, "MV_PAR01", cLocal)     //Armazém De
    u_zAtuPerg(cPerg, "MV_PAR02", cLocal)     //Armazém Até
    u_zAtuPerg(cPerg, "MV_PAR03", cProd) //Produto De
    u_zAtuPerg(cPerg, "MV_PAR04", cProd) //Produto Até*/
    Pergunte(cPerg, .F.)
        MV_PAR01 := cLocal
        MV_PAR02 := cLocal
        MV_PAR03 := cProd
        MV_PAR04 := cProd
     //Chama a pergunta em mem�ria
    // Pergunte(cPerg, .F., /*cTitle*/, /*lOnlyView*/, /*oDlg*/, /*lUseProf*/, @aPergAux)
    //Executa a operação automática
    lMsErroAuto := .F.
    conout("Antes do exeauto do saldo...")
    MSExecAuto({|x| MATA300(x)}, lJob)
 
    //Se houve erro, salva um arquivo dentro da protheus data
    If lMsErroAuto
    cDiretorio := "\erros\"
    cArquivo   := "log_mata300_"+cProd+"_"+cLocal+"_"+ dToS(Date()) + "_" + StrTran(Time(), ':', '-')
    MostraErro(cDiretorio, cArquivo)
    EndIf   
Return .T.

/*/{Protheus.doc} Static Function xBlqArm
    (long_description)
    @type  Function
    @author user
    @since 07/10/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function xBlqArm(cLocal,nOp)
    Local cAliasNr := GetNextAlias()
    Local cQueryNr := ""
    Local lRet := .F.
   conout("Verifica armazem!")

    cQueryNr := " SELECT NNR_FILIAL [FILIAL], NNR_CODIGO [LOCAL] "
    cQueryNr += "   ,NNR_MSBLQL [BLOQ], NNR.R_E_C_N_O_ [RECNO] "
    cQueryNr += " FROM "+RetSqlName("NNR")+" NNR "
    cQueryNr += " WHERE NNR.D_E_L_E_T_ = '' "
    cQueryNr += " AND NNR_CODIGO = '"+cLocal+"' "
    cQueryNr += " AND NNR_FILIAL = '"+xFilial("NNR")+"' "
    
    cQueryNr := changequery(cQueryNr)
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryNr), cAliasNr, .F., .T. )
    
    (cAliasNr)->(dbGoTop())

   IF nOp == 1
        If (cAliasNr)->BLOQ == '1'
            DbSelectArea("NNR")
            DbGoTo( (cAliasNr)->RECNO )
            conout("Desbloqueando Armazem! "+ NNR->NNR_CODIGO)
            RecLock("NNR",.F.)
                NNR->NNR_MSBLQL := "2"
            MsUnlock()
            lRet := .T.
        ELSE
            lRet := .F.
        ENDIF
    ELSE
        DbSelectArea("NNR")
        IF DbGoTo( (cAliasNr)->RECNO)
            conout("Bloqueando Armazem!" + NNR->NNR_CODIGO)
            RecLock("NNR",.F.)
            NNR->NNR_MSBLQL := "1"
            MsUnlock()
        ENDIF
        lRet := .T.
    ENDIF

Return lRet


/*/{Protheus.doc} xBlqProd
    (long_description)
    @type  Static Function
    @author user
    @since 07/10/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function xBlqProd(cProd,nOp,nOp2)
    Local cAliasB1 := GetNextAlias()
    Local cQueryB1 := ""
    Local nRet     := 0
    conout("Verifica Produtos!")
    cQueryB1 := "SELECT B1_FILIAL [FILIAL] ,B1_COD [COD] ,B1_MSBLQL [BLOQ] "
    cQueryB1 += " ,B1_RASTRO [RASTRO] ,SB1.R_E_C_N_O_ [RECNO] "
    cQueryB1 += " FROM "+RetSqlName("SB1")+" SB1 "
    cQueryB1 += " WHERE SB1.D_E_L_E_T_ = '' "
    cQueryB1 += " AND B1_COD = '"+cProd+"' "
    cQueryB1 += " AND B1_FILIAL = '"+xFilial("SB1")+"' "
    
    cQueryB1 := changequery(cQueryB1)
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryB1), cAliasB1, .F., .T. )

    IF nOp == 1
        DbSelectArea("SB1")
        DbGoTo( (cAliasB1)->RECNO )
            IF SB1->B1_MSBLQL == '1' .AND.  SB1->B1_RASTRO == 'L'
                conout("Desabilitando Lote e bloqueio de produto! " +SB1->B1_COD)
                RECLOCK("SB1",.F.)
                    SB1->B1_MSBLQL := "2"
                    SB1->B1_RASTRO := "N"
                MSUNLOCK()
                nRet := 1
            ELSEIF SB1->B1_RASTRO == 'L'
                conout("Desabilitando lote! "  +SB1->B1_COD)
                 RECLOCK("SB1",.F.)
                    SB1->B1_RASTRO := "N"
                 MSUNLOCK()
                nRet := 2
            ELSEIF SB1->B1_MSBLQL == '1' 
                conout("Desbloqueando produto! "  +SB1->B1_COD)
                RECLOCK("SB1",.F.)
                    SB1->B1_MSBLQL := "2"
                MSUNLOCK()
                nRet := 3
            ENDIF
    ELSEIF nOp == 2
        DbSelectArea("SB1")
        DbGoTo( (cAliasB1)->RECNO )
            IF SB1->B1_MSBLQL == '1'
                conout("Desbloqueando produto! "  + SB1->B1_COD)
                RECLOCK("SB1",.F.)
                    SB1->B1_MSBLQL := "2"
                    SB1->B1_MSBLQL := "L"
                MSUNLOCK()
                nRet := 3
            ELSE
            conout("Habilitando Lote produto! "  + SB1->B1_COD)
            RECLOCK("SB1",.F.)
                SB1->B1_MSBLQL := "2"
                SB1->B1_MSBLQL := "L"
            MSUNLOCK()
             nRet := 2
            ENDIF
    ELSE
        DbSelectArea("SB1")
        DbGoTo( (cAliasB1)->RECNO )
            IF nOp2 == 1
                conout("Bloqueando produto e habilitando lote! " +SB1->B1_COD)
                RECLOCK("SB1",.F.)
                    SB1->B1_MSBLQL := "1"
                    SB1->B1_RASTRO := "L"
                MSUNLOCK()
                nRet := 1
            ELSEIF nOp2 == 2
                conout("Habilitando lote! " +SB1->B1_COD)
                RECLOCK("SB1",.F.)
                    SB1->B1_RASTRO := "L"
                MSUNLOCK()
                nRet := 2
            ELSEIF nOp2 == 3
                conout("Bloqueando produto! " +SB1->B1_COD)
                RECLOCK("SB1",.F.)
                    SB1->B1_MSBLQL := "1"
                MSUNLOCK()
                nRet := 3
            ENDIF 
    ENDIF
Return nRet

/*/{Protheus.doc} User Function xAJB8
    (long_description)
    @type  Function
    @author user
    @since 18/10/2019
    @version version
    @param xFil
    @return 

    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xAJB8(xEmp,xFil)
    Local cQueryB8N := ""
    Local cAliasB8N := GetNextAlias()
    Local cQueryB8P := ""
    Local cAliasB8P := GetNextAlias()
    Local aCabP     := {}
    Local aItemP    := {}
    Local aCabN     := {}
    Local aItemN    := {}
    Local aTotItm   := {}
    Local nCusto    := 0
    Local nBloq     := 0
    Local lBloqArm  := .F.
    //Par�metros
    Local cArmzn    := ""
    Local cTpMvPC   := ""
	Local cTpMvPSC  := ""
	Local cTpMvNC   := ""
    Local cTpMvNSC  := ""
    Local dDataC    := ""


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
        
    cArmzn      := GETMV("SB_ARMZERO")
	cTpMvPC     := GETMV("SB_TPMVPC") // Tipo de movimento Itens Positivos COM CUSTO
	cTpMvPSC    := GETMV("SB_TPMVPSC") // Tipo de movimento Itens Positivos SEM CUSTO
	cTpMvNC     := GETMV("SB_TPMVNC") // Tipo de movimento Itens Negativos COM CUSTO
    cTpMvNSC    := GETMV("SB_TPMVNSC") // Tipo de movimento Itens Negativos SEM CUSTO
    dDataC      := STOD(GETMV("SB_DTCORTE"))

    cQueryB8N += " SELECT B8_FILIAL [FILIAL], B8_PRODUTO [COD], B8_LOCAL [LOCAL], B8_LOTECTL [LOTE], B8_SALDO [SALDO], B8_DATA [DTLOTE], SB8.R_E_C_N_O_ [RECNO] "
    cQueryB8N += " FROM "+RetSqlName("SB8")+" SB8 "
    cQueryB8N += " WHERE SB8.D_E_L_E_T_ = '' "
    cQueryB8N += " AND B8_SALDO < 0 "
    cQueryB8N += " AND B8_LOCAL NOT IN ("+cArmzn+") "

    cQueryB8N := changequery(cQueryB8N)
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryB8N), cAliasB8N, .F., .T. )


    while !(cAliasB8N)->(EoF())    
        _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
        lBloqArm    := xBlqArm((cAliasB8N)->LOCAL,1)
        nBloq       := xBlqProd((cAliasB8N)->COD,2,0)

        
            //Cabe�alho Itens negativos
            aCabN := {{"D3_FILIAL"     ,(cAliasB8N)->FILIAL       ,Nil},;
            {"D3_DOC"          ,_cNumDoc                         ,Nil},;
            {"D3_TM"           ,cTpMvNSC                         ,Nil},;
            {"D3_EMISSAO"     ,dDataC                         ,Nil},;
            {"D3_CC"           ,''                               ,Nil}}
            //Itens negativos
            aItemN := {{"D3_COD"       ,ALLTRIM((cAliasB8N)->COD)           ,NIL},;
            {"D3_QUANT" ,((cAliasB8N)->SALDO*(-1))                          ,NIL},;
            {"D3_LOCAL" ,(cAliasB8N)->LOCAL                                 ,NIL},;
            {"D3_LOTECTL" ,(cAliasB8N)->LOTE                                 ,NIL},;
            {"D3_IDENT" ,PROXNUM()                                         ,NIL},;
            {"D3_NUMSEQ",PROXNUM()                                         ,NIL},;
            {"D3_XMOV" ,"Ajuste de estoque automatico"                     ,NIL},;
            {"D3_USUARIO","Administrador"                                  ,NIL}}            

        aadd(aTotItm,aItemN)
        MSExecAuto({|x,y,z| MATA241(x,y,z)},aCabN,aTotItm,3)        
        sleep(100)
        If lMsErroAuto
            //MostraErro()
            CONOUT("Erro ao gerar movimentação "+cError + ALLTRIM((cAliasB8N)->COD) + "_"+(cAliasB8N)->LOCAL)
            // DisarmTransaction()
            //break
        Else  
            CONOUT("Feito SD3 Negativos" +(cAliasB8N)->COD+"_"+(cAliasB8N)->LOCAL)
        EndIF

        IF  lBloqArm
            lBloqArm := xBlqArm((cAliasB8N)->LOCAL,0)
        ENDIF
            
        IF  nBloq > 0
            nBloq := xBlqProd( (cAliasB8N)->COD,0,nBloq)
        ENDIF

        aCabP   := {}
        aItemP  := {}
        aCabN   := {}
        aItemN  := {}
        aTotItm := {}
        
        (cAliasB8N)->(DbSkip())
    end


    cQueryB8P += " SELECT B8_FILIAL [FILIAL], B8_PRODUTO [COD], B8_LOCAL [LOCAL], B8_LOTECTL [LOTE], B8_SALDO [SALDO], B8_DATA [DTLOTE], SB8.R_E_C_N_O_ [RECNO], (SELECT B2_VATU1 FROM "+RetSqlName("SB2")+" SB2 WHERE B2_COD = B8_PRODUTO AND B2_LOCAL = B8_LOCAL AND SB2.D_E_L_E_T_ = '') [VB2], (SELECT B2_QATU FROM "+RetSqlName("SB2")+" SB2 WHERE B2_COD = B8_PRODUTO AND B2_LOCAL = B8_LOCAL AND SB2.D_E_L_E_T_ = '')[QB2] "
    cQueryB8P += " FROM "+RetSqlName("SB8")+" SB8 "
    cQueryB8P += " WHERE SB8.D_E_L_E_T_ = '' "
    cQueryB8P += " AND B8_SALDO > 0 "
    cQueryB8P += " AND B8_LOCAL NOT IN ("+cArmzn+") "

    cQueryB8P := changequery(cQueryB8P)
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryB8P), cAliasB8P, .F., .T. )

    while !(cAliasB8N)->(EoF())    
        lBloqArm    := xBlqArm((cAliasB8P)->LOCAL,1)
        nBloq       := xBlqProd((cAliasB8P)->COD,2,0)
            IF (cAliasB8P)->VB2 < 0 .AND. (cAliasB8P)->QB2 > 0
                nCusto := (((cAliasB8P)->VB2*(-1)) /  (cAliasB8P)->QB2) * (cAliasB8P)->SALDO
            ELSEIF (cAliasB8P)->VB2 < 0 .AND. (cAliasB8P)->QB2 == 0
                nCusto := ((cAliasB8P)->VB2*(-1))
            ELSEIF (cAliasB8P)->VB2 > 0 .AND. (cAliasB8P)->QB2 > 0
                nCusto := ((cAliasB8P)->VB2 /  (cAliasB8P)->QB2) * (cAliasB8P)->SALDO
            ELSE
                nCusto := ((cAliasB8P)->VB2) 
            ENDIF
            If nCusto <= 0
                nCusto := 1
            ENDIF
                //Cabe�alho Itens positivos.
                aCabP := {{"D3_FILIAL"     ,(cAliasB8P)->FILIAL    ,Nil},;
                {"D3_DOC"          ,_cNumDoc                       ,Nil},;
                {"D3_TM"           ,cTpMvPC                        ,Nil},;
                {"D3_EMISSAO"     ,dDataC                          ,Nil},;
                {"D3_CC"           ,''                             ,Nil}}
                //Itens positivos
                aItemP := {{"D3_COD"       ,ALLTRIM((cAliasB8P)->COD)          ,NIL},;
                {"D3_QUANT" ,(cAliasB8P)->SALDO                                ,NIL},;
                {"D3_LOCAL" ,(cAliasB8P)->LOCAL                                ,NIL},;
                {"D3_CUSTO1" ,nCusto                                           ,NIL},;
                {"D3_LOTECTL" ,(cAliasB8P)->LOTE                               ,NIL},;
                {"D3_IDENT" ,PROXNUM()                                         ,NIL},;
                {"D3_NUMSEQ" ,PROXNUM()                                        ,NIL},;
                {"D3_XMOV" ,"Ajuste de estoque automatico"                     ,NIL},;
                {"D3_USUARIO","Admin"                           ,NIL}}  
            aadd(aTotItm,aItemP)
            MSExecAuto({|x,y,z|MATA241(x,y,z)},aCabP,aTotItm,3)         

            If lMsErroAuto
                //MostraErro()
                CONOUT("Erro ao gerar movimentação "+cError + ALLTRIM((cAliasB8P)->COD) + "_"+ (cAliasB8P)->LOCAL )
                // DisarmTransaction()
                //break
            Else     
                CONOUT("Feito SD3 Negativos" +(cAliasB8P)->COD+"_"+(cAliasB8P)->LOCAL)
            EndIF
            
            IF  lBloqArm
                lBloqArm := xBlqArm((cAliasB8P)->LOCAL,0)
            ENDIF
        
            IF  nBloq > 0
                nBloq := xBlqProd( (cAliasB8P)->COD,0,nBloq)
            ENDIF

        aCabP   := {}
        aItemP  := {}
        aCabN   := {}
        aItemN  := {}
        aTotItm := {}

//        U_xAtuSald(xEmp, xFil,(cAliasB8P)->COD, (cAliasB8P)->LOCAL)
        conout("Passa registro! ")
        (cAliasB8P)->(DbSkip())
    
    end    

    lMsErroAuto := .F.
    conout("Antes do exeauto do saldo...")
    MSExecAuto({|x| MATA300(x)}, .T.)
    If lMsErroAuto
        Conout("Erro ao realizar o execauto do refaz saldos!")
    ENDIF

Return .T.




 /*/{Protheus.doc} xIguaB8
    (long_description)
    @type  Function
    @author user
    @since 04/11/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    U_xIguaB8({'03','00'})
    /*/
user Function xIguaB8(aParam)
    //Defini��es padr�es
    Local xEmp      := aParam[1]
    Local xFil      := aParam[2]
    //Query
    Local cQueryIB8 := ""
    Local cAliasIB8 := ""  
    Local cAliasB2  := ""
    Local cQueryB2  := ""
    //Controladores
    Local nI        := 0
    Local nBloq     := 0
    Local lBloqArm  := .F.
    //ExectAuto
    Local aCabN     := {}
    Local aCabP     := {}
    Local aItemN    := {}
    Local aItemP    := {}
    Local cProd     := ""
    Local cLocal    := ""
    Local nCusto    := 0
    Local aTotItm   := {}
    Local _cNUMDOC  := ""
    Local aVetor    := {}
    //Par�metros
    Local cArmzn    := ""
    Local cTpMovSN  := ""
    Local cTpMovSP  := ""
    Local cTpMovEN  := ""
    Local cTpMovEP  := ""
    Local dDataC    := STOD("20181231")
    Local cLoc      := ""
    Local cLote     := ""
    Local cNmLote   := ""
    Local aSaldo    := {}
    //Job Libera Lote
    Local lThrdLot  := ""
    //Cria o ambiente
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
     
    lThrdLot := STARTJOB("U_xLibLot", getenvserver(), .T., aParam)
    sleep(100)

    dDataC      := STOD(GETMV("SB_DTCORTE"))
    cArmzn      := GETMV("SB_ARMZERO")
    cAliasIB8 := GetNextAlias()  
    cAliasB2 := GetNextAlias()  
    while dDatabase >= dDataC
        cQueryIB8 += " SELECT B8_FILIAL [FILIAL], B8_PRODUTO [COD], B8_LOCAL [LOCAL], B8_SALDO [SALDO], B8_DATA [DATALO] ,B8_LOTECTL [LOTE], B8_NUMLOTE [NUMLOTE], B8_DTVALID[VALIDADE], SB8.R_E_C_N_O_ [RECNO] " 
        cQueryIB8 += " FROM "+RetSqlName("SB8")+" SB8 "
        cQueryIB8 += " WHERE SB8.D_E_L_E_T_ = '' "
        cQueryIB8 += " AND B8_SALDO <> 0 "
        cQueryIB8 += "AND B8_LOCAL NOT IN ("+cArmzn+") "
        cQueryIB8 += "AND B8_FILIAL = '"+xFil+"' "
        cQueryIB8 += "ORDER BY FILIAL, COD "
        cQueryIB8 := changequery(cQueryIB8)

        dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryIB8), cAliasIB8, .F., .T. )

        WHILE !(cAliasIB8)->(EoF())

            cTpMvPC     := GETMV("SB_TPMVPC") // Tipo de movimento Itens Positivos COM CUSTO
            cTpMvPSC    := GETMV("SB_TPMVPSC") // Tipo de movimento Itens Positivos SEM CUSTO
            cTpMvNC     := GETMV("SB_TPMVNC") // Tipo de movimento Itens Negativos COM CUSTO
            cTpMvNSC    := GETMV("SB_TPMVNSC") // Tipo de movimento Itens Negativos SEM CUSTO

        
            //Verifica a Validade!!!!!!!!!!
                dbSelectArea("SB8")
                dbGoTo((cAliasIB8)->RECNO)
                RECLOCK("SB8",.F.)
                    SB8->B8_DTVALID := STOD("20501230")
                MSUNLOCK()

            
            _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
            cProd       := (cAliasIB8)->COD
            cLoc        := (cAliasIB8)->LOCAL
            cLote       := (cAliasIB8)->LOTE
            cNmLote     := (cAliasIB8)->NUMLOTE
            aSaldo      := CalcEstL(cProd,cLoc,dDataC,cLote,,,.T.)
            nBloq       := 0
            lBloqArm    := .F.
            lInc        := .F.

            //Verifica o custo!!!!!!!!
            nCusto      := ConsB2((cAliasIB8)->FILIAL,cProd,cLoc,aSaldo[1])
            IF nCusto == 0
                nCusto := 1
            ENDIF

            conout("Inicio da movimentacao de ajuste da b8 com b2. "+ALLTRIM((cAliasIB8)->COD)+" | "+ALLTRIM((cAliasIB8)->LOCAL)+" | "+ALLTRIM((cAliasIB8)->LOTE))
            
            //Verifica se o armaz�m est� bloqueado e libera caso sim
            lBloqArm    := xBlqArm((cAliasIB8)->LOCAL,1)
            sleep(15)

            //Tipo de movimento positivo.
            IF aSaldo[1] > 0
                //Libera o item caso esteja bloqueado e retira o controle por lote(opcao 1)
                nBloq       := xBlqProd((cAliasIB8)->COD,1,0)
                sleep(10)
                DbSelectArea("SB2")
                DbSetOrder(1)
                IF DbSeek(xFil+cProd+cLoc) .AND. SB2->B2_QATU == 0
                    lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc, aSaldo[1], nCusto, "", cNmLote ,0)
                ELSEIF DbSeek(xFil+cProd+cLoc) .AND. SB2->B2_QATU < 0
                    lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc, ABS(SB2->B2_QATU)+ aSaldo[1], nCusto, "", cNmLote ,0)
                ELSEIF DbSeek(xFil+cProd+cLoc) .AND. (aSaldo[1] - ABS(SB2->B2_QATU)) < 0
                    lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc, ABS((aSaldo[1] - ABS(SB2->B2_QATU))), nCusto, "", cNmLote ,0)
                ENDIF
                //Retorna o produto para o estado original.
                IF  nBloq > 0
                    sleep(10)
                    nBloq := xBlqProd( (cAliasIB8)->COD,0,nBloq)
                ENDIF
                nBloq       := 0
                //Garante que o produto esteja liberado e com controle de lote.
                nBloq       := xBlqProd((cAliasIB8)->COD,2,0)
                
                //Se incluiu o primeiro movimento de ajuste INCLUI O MOVIMENTO QUE ZERA B2 E B8!!!!!!
                /*IF !lInc
                    U_xMovimen(xFil, _cNUMDOC, cTpMvPC , dDataC, cProd, cLoc, aSaldo[1], nCusto, cLote, cNmLote ,1)
                ENDIF
                */
                //Realiza a sa�da de qualquer forma.
                lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvPC , dDataC, cProd, cLoc, aSaldo[1], nCusto, cLote, cNmLote ,1)
                //Retorna o produto para o estado original.
                IF  nBloq > 0
                    sleep(10)
                    nBloq := xBlqProd( (cAliasIB8)->COD,0,nBloq)
                ENDIF
                nBloq       := 0

            ELSE
                //Garante que o produto esteja liberado e com controle de lote.(opcao 2)
                nBloq       := xBlqProd((cAliasIB8)->COD,2,0)
                sleep(10)
                /*Todos os registros da B2 devem estar zerados, portanto inclu� sempre!
                 MAS quando o lote for negativo ser� necess�rio fazer a entrada controlando lote
                e uma sa�da sem controlar lote!
                */
                lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc, aSaldo[1], nCusto, cLote, cNmLote ,1)
                //Retorna o produto para o estado original.
                IF  nBloq > 0
                    sleep(10)
                    nBloq := xBlqProd( (cAliasIB8)->COD,0,nBloq)
                ENDIF
                nBloq       := 0
                
                /*
                //Libera o item caso esteja bloqueado e retira o controle por lote(opcao 1)
                nBloq       := xBlqProd((cAliasIB8)->COD,1,0)
                sleep(10)
                
                If !lInc
                    lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvPC, dDataC, cProd, cLoc, aSaldo[1], nCusto, cLote, cNmLote ,0)
                ENDIF
                //Retorna o produto para o estado original.
                IF  nBloq > 0
                    sleep(10)
                    nBloq := xBlqProd( (cAliasIB8)->COD,0,nBloq)
                ENDIF
                
                nBloq       := 0
                */

            ENDIF
            //Volta armaz�m para o estado original!
            IF  lBloqArm
                sleep(10)
                lBloqArm := xBlqArm((cAliasIB8)->LOCAL,0)
            ENDIF
            (cAliasIB8)->(DbSkip())
        END
        cQueryB2 := "SELECT B2_FILIAL [FILIAL] "
        cQueryB2 += ", B2_COD [COD] "
        cQueryB2 += ", B2_LOCAL [LOCAL] "
        cQueryB2 += ", B2_QATU [SALDO] "
        cQueryB2 += ", B2_VATU1 [VATU] "
        cQueryB2 += ", SB2.R_E_C_N_O_ [RECNO] "
        cQueryB2 += "FROM "+RetSqlName("SB2")+" SB2 "
        cQueryB2 += "WHERE SB2.D_E_L_E_T_ = '' "
        cQueryB2 += "AND B2_LOCAL NOT IN ("+cArmzn+") "
        cQueryB2 += "AND B2_FILIAL = '"+xFil+"' "
        cQueryB2 += "ORDER BY FILIAL, COD "
        cQueryB2 := changequery(cQueryB2)

        dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryB2), cAliasB2, .F., .T. )

    WHILE !(cAliasB2)->(EoF())


            cProd       := (cAliasB2)->COD
            cLoc        := (cAliasB2)->LOCAL
            nBloq       := 0
            lBloqArm    := .F.
            aSaldo := CalcEst(cProd, cLoc, dDataC) 
            
            nBloq       := xBlqProd(cProd,1,0)
            sleep(10)

            If aSaldo[1] > 0
                _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
               lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvPC, dDataC, cProd, cLoc, aSaldo[1], nCusto, "", cNmLote ,0)
            ELSEIF aSaldo[1] < 0
                _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
                lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc, aSaldo[1], nCusto, "", cNmLote ,0)
            ENDIF
            
            //Retorna o produto para o estado original.
            IF  nBloq > 0
                sleep(10)
                nBloq := xBlqProd(cProd,0,nBloq)
            ENDIF
            
            nBloq       := 0
            aSaldo      := {}
            (cAliasB2)->(DbSkip())
        END
        RestArea(cAliasB2)
        RestArea(cAliasIB8)
        dDataC := MonthSum(dDataC,1)
    end
Return 

/*/{Protheus.doc} User Function xZerB2
    (long_description)
    @type  Function
    @author user
    @since 25/11/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    U_xZerB2({'03','00'})
    /*/
User Function xZerB2(aParam)
    //Defini��es padr�es
    Local xEmp      := aParam[1]
    Local xFil      := aParam[2]
    //Query
    Local cQueryIB8 := ""
    Local cAliasIB8 := ""  
    Local cAliasB2  := ""
    Local cQueryB2  := ""
     //Par�metros
    Local cArmzn    := ""
    Local cTpMovSN  := ""
    Local cTpMovSP  := ""
    Local cTpMovEN  := ""
    Local cTpMovEP  := ""
    Local dDataC    := STOD("20181231")
    Local cLoc      := ""
    Local cLote     := ""
    Local cNmLote   := ""
    Local aSaldo    := {}
    Local aSaldoL   := {}
    Local nCusto    := 0

    //Cria o ambiente
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
    
    dDataC      := STOD(GETMV("SB_DTCORTE"))
    cArmzn      := GETMV("SB_ARMZERO")
    cTpMvPC     := GETMV("SB_TPMVPC") // Tipo de movimento Itens Positivos COM CUSTO
    cTpMvPSC    := GETMV("SB_TPMVPSC") // Tipo de movimento Itens Positivos SEM CUSTO
    cTpMvNC     := GETMV("SB_TPMVNC") // Tipo de movimento Itens Negativos COM CUSTO
    cTpMvNSC    := GETMV("SB_TPMVNSC") // Tipo de movimento Itens Negativos SEM CUSTO
    cAliasB2    := GetNextAlias()

    cQueryB2 := "SELECT B2_FILIAL [FILIAL] "
    cQueryB2 += ", B2_COD [COD] "
    cQueryB2 += ", B2_LOCAL [LOCAL] "
    cQueryB2 += ", B2_QATU [SALDO] "
    cQueryB2 += ", B2_VATU1 [VATU] "
    cQueryB2 += ", B2_CM1 [CM] "
    cQueryB2 += ", SB2.R_E_C_N_O_ [RECNO] "
    cQueryB2 += "FROM "+RetSqlName("SB2")+" SB2 "
    cQueryB2 += "WHERE SB2.D_E_L_E_T_ = '' "
    cQueryB2 += "AND B2_LOCAL NOT IN ("+cArmzn+") "
    cQueryB2 += "AND B2_FILIAL = '"+xFil+"' "
    cQueryB2 += "ORDER BY FILIAL, COD "
    cQueryB2 := changequery(cQueryB2)

    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryB2), cAliasB2, .F., .T. )
    WHILE dDatabase >= dDataC
        WHILE !(cAliasB2)->(EoF())
            cProd       := (cAliasB2)->COD
            cLoc        := (cAliasB2)->LOCAL
            nBloq       := 0
            lBloqArm    := .F.
            aSaldo      := CalcEst(cProd, cLoc, dDataC) 
            nCusto      := ABS((cAliasB2)->CM)
            
            IF nCusto == 0
                nCusto := 1
            ENDIF
            nIX := 0
            IF aSaldo[1] != 0
                IF aSaldo[1] != (cAliasB2)->SALDO
                    IF aSaldo[1] >  (cAliasB2)->SALDO
                        IF (cAliasB2)->SALDO < 0 
                            //Se for negativo ele faz uma entrada.
                            nBloq       := xBlqProd(cProd,1,0)
                            sleep(10)
                            _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
                            lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc,ABS((cAliasB2)->SALDO)+ABS(aSaldo[1]),nCusto*(ABS((cAliasB2)->SALDO)+ABS(aSaldo[1])) , "", cNmLote ,0)
                            //Retorna o produto para o estado original.
                            IF  nBloq > 0
                                sleep(10)
                                nBloq := xBlqProd(cProd,0,nBloq)
                            ENDIF   
                        ELSE
                            //Se for menor ele faz uma entrada
                            nBloq       := xBlqProd(cProd,1,0)
                            sleep(10)
                            _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
                            lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc,ABS(aSaldo[1]),nCusto*ABS(aSaldo[1]) , "", cNmLote ,0)
                            //Retorna o produto para o estado original.
                            IF  nBloq > 0
                                sleep(10)
                                nBloq := xBlqProd(cProd,0,nBloq)
                            ENDIF
                        ENDIF
                    ENDIF 
                ENDIF

                dbSelectArea("SB8")
                DbSetOrder(1)
                //Verifica o saldo Por lote.
                IF DbSeek(xFil+cProd+cLoc) 
                    WHILE !SB8->(EoF())
                        //Pega o Saldo por lote!
                        aSaldoL := CalcEstL(cProd,cLoc,dDataC,SB8->B8_LOTECTL,,,.T.)
                        //Verifica se o movimento ser� de entrada ou sa�da.
                        IF  aSaldoL[1] > 0
                            IF SB8->B8_SALDO <= 0 
                                lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc,abs(aSaldoL[1]),nCusto*ABS(aSaldoL[1]) , SB8->B8_LOTECTL, cNmLote ,1)
                            ENDIF
                            Conout("O saldo do produto "+cProd+" no Armazem "+cLoc+" do lote "+SB8->B8_LOTECTL+" e "+ STR(aSaldo[1]))
                            //Verifica se existe saldo na B2 o suficiente para realizar a sa�da do lote.
                            If (CalcEst(cProd, cLoc, dDataC)[1] - aSaldoL[1]) < 0
                                conout("O saldo da B2( "+STR( CalcEst(cProd, cLoc, dDataC)[1])+" ) � inferior ao saldo de saida ( "+ STR(aSaldo[1])+" )")
                                //Se n�o existir o saldo ele faz uma entrada sem controlar lote para que seja possivel movimentar.
                                nBloq       := xBlqProd(cProd,1,0)
                                sleep(10)

                                _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
                                lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc,ABS(CalcEst(cProd, cLoc, dDataC)[1])+abs(aSaldoL[1]),nCusto*(ABS(CalcEst(cProd, cLoc, dDataC)[1])+ABS(aSaldoL[1])) , "", cNmLote ,0)
                                    //Retorna o produto para o estado original.
                                    IF  nBloq > 0
                                        sleep(10)
                                        nBloq := xBlqProd(cProd,0,nBloq)
                                    ENDIF   
                            ENDIF
                             //Realiza a sa�da do produto controlando lote.
                             conout("Realiza a sa�da de "+ STR(aSaldo[1])+ " unidades do produto "+cProd+" do Armazem "+cLoc+" do Lote "+SB8->B8_LOTECTL)
                            _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
                            lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvPC, dDataC, cProd, cLoc, aSaldoL[1], nCusto*ABS(aSaldoL[1]),SB8->B8_LOTECTL, cNmLote ,1)
                        ELSEIF  aSaldoL[1] < 0
                            _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
                            lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc, ABS(aSaldoL[1]), nCusto*ABS(aSaldoL[1]),SB8->B8_LOTECTL, cNmLote ,1)
                        ENDIF
                        SB8->(DbSkip(1))
                    END
                ENDIF    
                // VERIFICA O SALDO NA B2 AP�S PASSAR PELA B8.
                // ASSIM MANTEM A B2 ZERADA E A B8 ZERADA!
                aSaldo := CalcEst(cProd, cLoc, dDataC) 
                If aSaldo[1] > 0
                    nBloq       := xBlqProd(cProd,1,0)
                    sleep(10)    

                    _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
                    lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvPC, dDataC, cProd, cLoc, aSaldo[1], nCusto*ABS(aSaldo[1]), "", cNmLote ,0)

                    IF  nBloq > 0
                        sleep(10)
                        nBloq := xBlqProd(cProd,0,nBloq)
                    ENDIF
                ELSEIF aSaldo[1] < 0
                    nBloq       := xBlqProd(cProd,1,0)
                    sleep(10)    

                    _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
                    lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc, aSaldo[1], nCusto*ABS(aSaldo[1]), "", cNmLote ,0)
                    
                    IF  nBloq > 0
                        sleep(10)
                        nBloq := xBlqProd(cProd,0,nBloq)
                    ENDIF

                ENDIF
                
            ENDIF
            //Zera Variaveis e troca de registro!
            nBloq       := 0
            aSaldo      := {}
            (cAliasB2)->(DbSkip())
        END

        dDataC := MonthSum(dDataC,1)
    END
    RestArea(cAliasB2)

Return .T.
 
/*/{Protheus.doc} ConsB2
    (long_description)
    @type  Static Function
    @author user
    @since 04/11/2019
    @version version
    @param param_name
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function ConsB2(filial,cod,local,saldo)
    Local cConsB2   := ""
    Local cAliasCB2 := GetNextAlias()
    Local nRet      := 0
    Local lThreadB2 := .F.
    Local aParam := {}
    aadd(aParam,FWCodEmp())
    aadd(aParam,filial)

    cConsB2 := "SELECT DISTINCT B2_COD [COD], B2_LOCAL [LOCAL], B2_QATU [SALDO], B2_VATU1 [VALOR], B2_CM1 [CUSTO] "
    cConsB2 += " FROM "+RetSqlName("SB2")+" SB2 "
    cConsB2 += " WHERE SB2.D_E_L_E_T_ = '' "
    cConsB2 += " AND B2_FILIAL = '"+filial+"' "
    cConsB2 += " AND B2_COD = '"+cod+"' "
    cConsB2 += " AND B2_LOCAL = '"+local+"' "
    cConsB2 := changequery(cConsB2)

    dbUseArea( .T., "TOPCONN", TcGenQry(,,cConsB2), cAliasCB2, .F., .T. )

    IF !(cAliasCB2)->(EoF())
       /* IF (cAliasCB2)->SALDO > 0
            lThreadB2   := STARTJOB("U_SBP00102", getenvserver(), .T., aParam)
            sleep(100)
        ELSEIF (cAliasCB2)->SALDO < 0
            lThreadB2   := STARTJOB("U_SBP00102", getenvserver(), .T., aParam)
            sleep(100)
        ENDIF
        */
        IF (cAliasCB2)->VALOR <> 0
            nRet := ABS((cAliasCB2)->VALOR) / ABS(saldo)
        ELSE
            nRet := ABS((cAliasCB2)->CUSTO) * ABS(saldo)
        ENDIF

        IF nRet <= 0
            IF nRet < 0 
                nRet := ABS(nRet)
            ELSE
                nRet := 1
            ENDIF
        ENDIF
    ELSE
        nRet := 1
    ENDIF

    IF nRet > 100000
            nRet := 100000
    ENDIF

Return nRet


/*/{Protheus.doc} xMovimen
    (long_description)
    @type  Static Function
    @author user
    @since 04/11/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xMovimen(xFilial, cNumDoc, cTpMov, dDataC, cCodProd, cLocal, nSaldo, nCusto, cLote ,cNmLote ,nOp)
    Local aCab      := {}
    Local aItem     := {}
    Local aTotItm   := {}
    Local aErro     := {}
    Local cRet      := ""
    Local cQryD5    := ""
    Local cAliasD5  := GetNextAlias()
    Local cQryDB8   := ""
    Local cAliasDB8 := GetNextAlias()
    Local cEmp      := FWCodEmp()
    lMsErroAuto := .F.

    IF nOp == 0 //Itens Positivos com Custo sem Controle de Lote
        //Cabeçalho Itens positivos.
        aCab := {{"D3_FILIAL"     ,xFilial                              ,Nil},;
        {"D3_DOC"          ,cNumDoc                                     ,Nil},;
        {"D3_TM"           ,cTpMov                                      ,Nil},;
        {"D3_EMISSAO"     ,dDataC                                      ,Nil},;
        {"D3_CC"           ,''                                          ,Nil}}
        //Itens positivos
        aItem := {{"D3_COD"       ,ALLTRIM(cCodProd)                    ,NIL},;
        {"D3_QUANT" ,ABS(nSaldo)                                         ,NIL},;
        {"D3_LOCAL" ,cLocal                                             ,NIL},;
        {"D3_CUSTO1" , ABS(nCusto)                                      ,NIL},;
        {"D3_IDENT" ,PROXNUM()                                          ,NIL},;
        {"D3_NUMSEQ" ,PROXNUM()                                         ,NIL},;
        {"D3_XMOV" ,"Ajuste de estoque automatico"                      ,NIL},;
        {"D3_USUARIO","Admin"                                           ,NIL}}       

    ELSEIF nOp == 1 //Controlando lote
                //Cabeçalho Itens positivos.
                aCab := {{"D3_FILIAL"     ,xFilial                              ,Nil},;
                {"D3_DOC"          ,cNumDoc                                     ,Nil},;
                {"D3_TM"           ,cTpMov                                      ,Nil},;
                {"D3_EMISSAO"     ,dDataC                                      ,Nil},;
                {"D3_CC"           ,''                                          ,Nil}}
                //Itens positivos
                aItem := {{"D3_COD"       ,ALLTRIM(cCodProd)                    ,NIL},;
                {"D3_LOCAL" ,cLocal                                             ,NIL},;
                {"D3_CUSTO1" , ABS(nCusto)                                      ,NIL},;                   
                {"D3_QUANT" ,ABS(nSaldo)                                        ,NIL},;   
                {"D3_LOTECTL" , cLote                                           ,NIL},;
                {"D3_NUMLOTE" , ALLTRIM(cNmLote)                                ,NIL},;
                {"D3_IDENT" ,PROXNUM()                                          ,NIL},;
                {"D3_NUMSEQ" ,PROXNUM()                                         ,NIL},;
                {"D3_XMOV" ,"Ajuste de estoque automatico"                      ,NIL},;
                {"D3_USUARIO","Admin"                                           ,NIL}} 
                 // {"D3_CUSTO1" , ABS(nCusto)                                      ,NIL},;      
    ENDIF
    aadd(aTotItm,aItem)
    conout("xMovimen......: " +cCodProd + " "+ cLocal + " Lote: "+ cLote)
    MSExecAuto({|x,y,z|MATA241(x,y,z)},aCab,aTotItm,3)
    
    
    IF lMsErroAuto
        aErro := GetAutoGRLog()
        For nW := 1 To Len(aErro)
            cRet += aErro[nW] +CRLF
        Next nW
        conout("Erro ao gerar a movimenta��o do item "+cCodProd + " "+ cLocal + " Lote: "+ cLote)
        conout(cRet)
    ELSE
        conout("Movimenta��o inclu�da com sucesso! |"+cCodProd + " "+ cLocal + " Lote: "+ cLote)
        IF nOp == 1
            cQryD5 += " SELECT SD5.R_E_C_N_O_ [RECNO] FROM "+RetSqlName("SD5")+" SD5 "
            cQryD5 += " WHERE D5_LOTECTL = '"+ALLTRIM(cLote)+"' "
            cQryD5 += " AND D5_PRODUTO = '"+ALLTRIM(cCodProd)+"' "
            cQryD5 += " AND D5_DOC = '"+cNumDoc+"' "
            cQryD5 += " AND SD5.D_E_L_E_T_ = '' "
            cQryD5 := changequery(cQryD5)

            dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryD5), cAliasD5, .F., .T. )
        
            WHILE !(cAliasD5)->(EoF())
                    dbSelectArea("SD5")
                    DbGoTo((cAliasD5)->RECNO)
                    RecLock("SD5",.F.)
                        SD5->D5_NUMLOTE := ""
                    MsUnlock()
                    (cAliasD5)->(DbSkip())
            END

            cQryDB8 += " SELECT SB8.R_E_C_N_O_ [RECNO] FROM "+RetSqlName("SB8")+" SB8 "
            cQryDB8 += " WHERE B8_LOTECTL = '"+ALLTRIM(cLote)+"' "
            cQryDB8 += " AND B8_PRODUTO = '"+ALLTRIM(cCodProd)+"' "
            cQryDB8 += " AND B8_DOC = '"+cNumDoc+"' "
            cQryDB8 += " AND SB8.D_E_L_E_T_ = '' "
            cQryDB8 := changequery(cQryDB8)

            dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryDB8), cAliasDB8, .F., .T. )

            WHILE !(cAliasDB8)->(EoF())
                dbSelectArea("SB8")
                DbGoTo((cAliasDB8)->RECNO)
                RecLock("SB8",.F.)
                SB8->( DbDelete())
                MsUnlock()
                (cAliasDB8)->(DbSkip())
            END

            //U_xAtuSald(cEmp, xFilial,cCodProd, cLocal)
        ENDIF
    ENDIF
    aCab    := {}
    aItem   := {}
    aTotItm := {}
    aErro   := {}
    cRet    := ""
    
Return lMsErroAuto


User Function xLibLot(aParam) 
    //Defini��es padr�es
    Local xEmp      := aParam[1]
    Local xFil      := aParam[2]

    Local aVetor    := {}
    Local cQryTotDD := ""          
    Local cQryDD    := ""
    Local cAliasDD  := ""
    Local cDocDD    := ""
    Local cProd     := ""
    Local cLote     := ""
    Local cLocal    := ""
    Local cArmzn    := ""
    Local nTot      := 0
    Local nI        := 0
  //Cria o ambiente
  RPCSetType(3)
  If FindFunction('WFPREPENV')
      lAuto := .T.
      RPCSetType( 3 )						// Nï¿½o consome licensa de uso
      wfPrepENV(xEmp, xFil)
      //wfPrepENV("03", "00")
      conout("Preparou ambiente Liberacao de lotes. . .")
  Else
      lAuto := .T.
      RPCSetType( 3 )						// Nï¿½o consome licensa de uso
      Prepare Environment Empresa xEmp Filial xFil
      conout("Preparou ambiente Liberacao de lotes. . .")
  Endif   
   
    cArmzn:= GETMV("SB_ARMZERO")

    cAliasDD  := GetNextAlias()

    cQryDD += " SELECT DD_DOC [DOC], DD_PRODUTO [PROD],DD_LOCAL[LOCAL],DD_LOTECTL[LOTE] FROM "+RetSQLName("SDD")+" SDD "
    cQryDD += " WHERE SDD.D_E_L_E_T_ = '' "
    cQryDD += " AND DD_LOCAL NOT IN ("+cArmzn+") "
    cQryDD += " AND DD_FILIAL = '"+xFil+"' "
    cQryDD += " AND DD_SALDO <> 0 "
  //  cQryDD := changequery(cQryDD)
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryDD), cAliasDD, .F., .T. )

    WHILE !(cAliasDD)->(EoF())
        cDocDD    := (cAliasDD)->DOC
        cProd     := (cAliasDD)->PROD
        cLocal    := (cAliasDD)->LOCAL
        cLote     := (cAliasDD)->LOTE
        lMsErroAuto := .F.  
        //--- Exemplo: Bloqueio --- //
        aVetor := {{"DD_DOC",cDocDD ,NIL},;
                    {"DD_PRODUTO",cProd ,NIL},;
                    {"DD_LOCAL",cLocal ,NIL},;
                    {"DD_LOTECTL",cLote ,NIL}}                                          	
        MSExecAuto({|x, y| mata275(x, y)},aVetor, 4)  
        If lMsErroAuto    
           //Mostraerro()
            CONOUT("Ocorreu um erro ao liberar o lote!!")
        else    
            conout("Lote liberado!")
        Endif
        (cAliasDD)->(DbSkip())
    END

Return .T.   



/*/{Protheus.doc} User Function xEstAtu
    (long_description)
    @type  Function
    @author user
    @since 21/11/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    U_xEstAtu()
    /*/
User Function xEstAtu()
    Local aSaldos := {}
    Local aSaldos2 := {}
    Local aSaldos3 := {}
    Local aSaldos4 := {}
    Local aSaldos5 := {}
    Local aSaldos6 := {}
    Local aSaldos7 := {}
    aSaldos := CalcEst("15.1.I.P.E.F   ", "71", STOD("20181231"))
    Alert(aSaldos[1])
    aSaldos2 := CalcEstL("15.1.I.P.E.F   ", "71", STOD("20181231"),'0515032410',,,.T.)
    aSaldos3 := CalcEstL("15.1.I.P.E.F   ", "71", STOD("20181231"),'0516033708',,,.T.)
    aSaldos4 := CalcEstL("15.1.I.P.E.F   ", "71", STOD("20181231"),'0516033710',,,.T.)
    aSaldos5 := CalcEstL("15.1.I.P.E.F   ", "71", STOD("20181231"),'0916034008',,,.T.)
    aSaldos6 := CalcEstL("15.1.I.P.E.F   ", "71", STOD("20181231"),'0117034330',,,.T.)
    //aSaldos7 := CalcEstL("15.1.I.P.E.F   ", "71", STOD("20181231"),'0515032410',,,.T.)
    alert(aSaldos2[1]+CRLF+aSaldos3[1]+CRLF+aSaldos4[1]+CRLF+aSaldos5[1]+CRLF+aSaldos6[1])
    
Return 








/*/{Protheus.doc} User Function xAtSldM()
    (long_description)
    @type  Function
    @author user
    @since 03/10/2019
    @version version
    @param aParam
    @return 
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xAtSldM(aParam)
        //Inicializa��o!!!
    Local xEmp      := aParam[1]
    Local xFil      := aParam[2]
        //Alias e Query
    Local cAliasB2  := ""
    Local cArmzn    := ""
    Local cQueryB2  := ""
        //ExecAuto (provavelmente n�o vai ser utilizado mais!!)    
    Local aCabN     := {}
    Local aCabP     := {}
    Local aItemN    := {}
    Local aItemP    := {}
    Local aTotItm   := {}
        //Tipos de Movimenta��o
    Local cTpMovSN  := ""
    Local cTpMovSP  := ""
    Local cTpMovEN  := ""
    Local cTpMovEP  := ""
        //Facilitadores !!
    Local cProd     := ""
    Local cLocal    := ""
    Local nCusto    := 0
    Local nQtdPrd   := 0
    Local dDataC    := ""
    local aSaldo    := {}
    Local aSaldoL   := {}
        //Contadores
    Local nI        := 0
    Local nContL    := 0
    Local nContDt   := 0
        //Controladores de fun��o!!
    Local nBloq     := 0
    Local lBloqArm  := .F.
        //Erros
    Local cError   	:= ""
    Local bError   	:= ErrorBlock({ |oError| cError := oError:Description})
    Local nLog      := 0
    Local cData     := "" 
    Local cDir      := "\erros\"
    Private lMsErroAuto := .F.
    
    //Cria o ambiente
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
    cAliasB2  := GetNextAlias()
    cArmzn    := GETMV("SB_ARMZERO")
    //cArmzn := "'03','YY','00'"
    dDataC    := STOD(GETMV("SB_DTCORTE"))
    nContDt   := DateDiffMonth(dDatabase,dDataC)

    cTpMvPC     := GETMV("SB_TPMVPC") // Tipo de movimento Itens Positivos COM CUSTO
    cTpMvPSC    := GETMV("SB_TPMVPSC") // Tipo de movimento Itens Positivos SEM CUSTO
    cTpMvNC     := GETMV("SB_TPMVNC") // Tipo de movimento Itens Negativos COM CUSTO
    cTpMvNSC    := GETMV("SB_TPMVNSC") // Tipo de movimento Itens Negativos SEM CUSTO
        
    While nContDt > 0
        IF !EMPTY(cArmzn) .AND. VALTYPE(cArmzn) == 'C' .AND. len(cArmzn) >= 4 //Verifica se os armazéns foram definidos para evitar zerar TUDO!
            cQueryB2 := "SELECT B2_FILIAL [FILIAL] "
            cQueryB2 += ", B2_COD [COD] "
            cQueryB2 += ", B2_LOCAL [LOCAL] "
            cQueryB2 += ", B2_QATU [SALDO] "
            cQueryB2 += ", B2_VATU1 [VATU] "
            cQueryB2 += ", SB2.R_E_C_N_O_ [RECNO] "
            cQueryB2 += "FROM "+RetSqlName("SB2")+" SB2 "
            cQueryB2 += "WHERE SB2.D_E_L_E_T_ = '' "
            cQueryB2 += "AND B2_QATU <> 0 "
            cQueryB2 += "AND B2_LOCAL NOT IN ("+cArmzn+") "
            cQueryB2 += "AND B2_FILIAL = '"+xFil+"' "
            cQueryB2 += "ORDER BY FILIAL, COD "
            cQueryB2 := changequery(cQueryB2)
        
            dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryB2), cAliasB2, .F., .T. )
        
            WHILE !(cAliasB2)->(EoF())
                lThread1    := .F.
                lThread2    := .F.

                cProd       := (cAliasB2)->COD
                cLocal      := (cAliasB2)->LOCAL
                nBloq       := 0
                lBloqArm    := .F.
                aSaldoL     := {}

                aSaldo := CalcEst(cProd, (cAliasB2)->LOCAL, dDataC)
                nQtdPrd := aSaldo[1]

                If nQtdPrd > 0
                    dbSelectArea("SB8")
                    DbSetOrder(1)
                    DbSeek(xFil+cProd+cLocal)
                    While !SB8->(Eof()) .AND. SB8->B8_SALDO <> 0
                        //Pega o proximo numero da SD3
                        _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
                        //Calcula o Custo da movimenta��o!
                        nCusto := ABS( (cAliasB2)->VATU / aSaldoL[nContL][1] )
                        aSaldoL := CalcEstL(SB8->B8_PRODUTO,SB8->B8_LOCAL,dDataC,SB8->B8_LOTECTL,,,.T.)

                        If aSaldoL[1] > 0
                            xMovimen(xFil, _cNUMDOC, cTpMvPC, dDataC, cProd, cLocal, aSaldoL[1], nCusto, SB8->B8_LOTECTL ,"",1)
                        ELSE
                            xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLocal, aSaldoL[1], nCusto, SB8->B8_LOTECTL ,"",1)
                        ENDIF
                    END
                ENDIF
                //U_xAtuSald(xEmp, xFil,(cAliasB2)->COD, (cAliasB2)->LOCAL)
                //sleep(10)
                //lBloqArm    := xBlqArm((cAliasB2)->LOCAL,1)
                //sleep(15)
                nBloq       := xBlqProd((cAliasB2)->COD,1,0)
                sleep(10)
                    
                IF  lBloqArm
                    sleep(10)
                    lBloqArm := xBlqArm((cAliasB2)->LOCAL,0)
                ENDIF
                    
                IF  nBloq > 0
                    sleep(10)
                    nBloq := xBlqProd( (cAliasB2)->COD,0,nBloq)
                ENDIF
            
                aCabP   := {}
                aItemP  := {}
                aCabN   := {}
                aItemN  := {}
                aTotItm := {}
                nIx := 0
                    
                U_xAtuSald(xEmp, xFil,(cAliasB2)->COD, (cAliasB2)->LOCAL)

                (cAliasB2)->(DbSkip())
            END
        ENDIF

        dDataC := MonthSum(dDataC,1)
        nContDt --
    END
    nIx := 0
Return  .T.