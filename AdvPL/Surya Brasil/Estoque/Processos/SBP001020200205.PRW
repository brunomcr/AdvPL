#include "Protheus.ch"
#include "topconn.ch"  
#include "Totvs.ch"  
#include "tbiconn.ch"
#include "tbicode.ch"
#INCLUDE "fileio.ch"


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…›››››››—›››››››››À›››››—››››››››››››››À››››››››—›››››››››À››››››—››››››››››ª±±
±±∫Prog.  ≥ SBP0010 ∫ Uso ≥ Surya Brasil ∫ Modulo ≥ SIGAEST ∫ Data ≥ 30/09/19 ∫±±
±±Ã›››››››ÿ››››››››› ›››››››››››››››››››› ›››››››››››››››››› ›››››››››››››››››π±±
±±∫Desc.  ≥ Rotina para zerar os armazÈns inativos.                    		  ∫±±
±±∫       ≥                                                                   ∫±±
±±Ã›››››››ÿ›››››››››››››››››››››››››››À›››››››››—›››››››››››››››››››››››››››››π±±
±±∫ Autor ≥ Alexsandro Salla             ∫ Contato ≥(11) 97961-7915           ∫±±
±±»››››››››››››››››››››››››››››››››››› ›››››››››››››››››››››››››››››››››››››››º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
/*
    U_SBP0010({'03','00'})
    U_SBP0010({'01','00'})
    U_SBP00102({'03','00'})
    u_xIguaB8({'03','00'})
    U_xAjsVlr({'03','00'})
    U_xRodAjst({'03','00'})
    U_xDelB9('03','00')
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
    Local lRetCus   := .F.
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
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        wfPrepENV(xEmp, xFil)
        //wfPrepENV("03", "00")
        conout("Preparou ambiente. . .")
    Else
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        Prepare Environment Empresa xEmp Filial xFil
        conout("Preparou ambiente. . .")
    Endif       

    conout("|______________________________________________________________|")
    conout("|                                                              |")
    conout("|           INICIO DO PROCESSAMENTO DO FONTE SBP0010           |")
    conout("|                                                              |")
    conout("|______________________________________________________________|")
    conout(dToS(Date()) + "_" + StrTran(Time(), ':', '-'))

    // ------------------------------------------------------------- PEGANDO ARMAZ…NS QUE N√O DEVEM SER INCLUÕDOS NA RELA«√O! -------------------
    cArmzn    := GETMV("SB_ARMZERO")
    //-------------------------------------------------------------- DEFININDO A QUANTIDADE DE EXECU«’ES DE SEGURAN«A DO ZERA B2! ---------------
    cContB2 += "SELECT COUNT(*)/100 + 5 [CONT] "
    cContB2 += "FROM "+RetSqlName("SB2")+" SB2 "
    cContB2 += "WHERE SB2.D_E_L_E_T_ = '' "
    cContB2 += "AND B2_QATU <> 0 "
    cContB2 += "AND B2_LOCAL NOT IN ("+cArmzn+") "
    cContB2 += "AND B2_FILIAL = '"+xFil+"' "
    cContB2 := changequery(cContB2)

    dbUseArea( .T., "TOPCONN", TcGenQry(,,cContB2), cAliasC2, .F., .T. )
    //---------------------------------------------------------------- DEFININDO A QUANTIDADE DE EXECU«’ES DE SEGURAN«A DO ZERA B9! ------------
    cContB9 += " SELECT COUNT(*)/100 + 5 [CONT] "
    cContB9 += " FROM "+RetSqlName("SB9")+" SB9 "
    cContB9 += " WHERE SB9.D_E_L_E_T_ = '' "
    cContB9 += " AND B9_DATA <> '' "
    cContB9 += " AND B9_LOCAL NOT IN ("+cArmzn+") "
    cContB9 += " AND B9_FILIAL = '"+xFil+"' "
    cContB9 += " AND B9_DATA > (SELECT MIN(B9_DATA) FROM "+RetSqlName("SB9")+" A WHERE A.B9_FILIAL = SB9.B9_FILIAL AND A.B9_COD = SB9.B9_COD AND A.D_E_L_E_T_ = '' AND SB9.B9_LOCAL = A.B9_LOCAL) "

    cContB9 := changequery(cContB9)

    dbUseArea( .T., "TOPCONN", TcGenQry(,,cContB9), cAliasC1, .F., .T. )

    nIx         := 0
    //----------------------------------------------------------------------------------------------------------------------------
    //Deleta os fechamentos(menos o primeiro registro de B9 que teoricamente È o saldo inicial!).---------------------------------
    //----------------------------------------------------------------------------------------------------------------------------
    WHILE  (cAliasC1)->CONT > nCont1
        IF nCont1 < 100
            lRetB9      := STARTJOB("U_xDelB9", getenvserver(), .T.,xEmp,xFil)
            sleep(100)
            nCont1 ++
        ELSE
            nCont1 := (cAliasC1)->CONT
            lRetB9      := STARTJOB("U_xDelB9", getenvserver(), .T.,xEmp,xFil)
            sleep(100)
            nCont1 ++
        ENDIF
    END
    //-----------------------------------------------------------------------------------------------------------------------------
    //Serù responsùvel zerar os itens negativos da SB2.--------------------------------------------------------------------------
    //-----------------------------------------------------------------------------------------------------------------------------
    //Ajusta Empenho
    
    While (cAliasC2)->CONT > nCont2
        lThreadB2   := STARTJOB("U_SBP00102", getenvserver(), .T., aParam)
        sleep(100)
        nCont2 ++
    END
    //----------------------------------------------------------------------------------------------------------------------------- |
    //Definindo a quantidade de execuÁıes da rotina que ser· respons·vel por zerar a SB8 e a SB2, ajustando assim as movimentaÁıes! |
    //----------------------------------------------------------------------------------------------------------------------------- |
    cContB8 += " SELECT COUNT(*)/100 + 5 [CONT] " 
    cContB8 += " FROM "+RetSqlName("SB8")+" SB8 "
    cContB8 += " WHERE SB8.D_E_L_E_T_ = '' "
    cContB8 += " AND B8_SALDO <> 0 "
    cContB8 += "AND B8_LOCAL NOT IN ("+cArmzn+") "
    cContB8 += "AND B8_FILIAL = '"+xFil+"' "
    cContB8 := changequery(cContB8)

    dbUseArea( .T., "TOPCONN", TcGenQry(,,cContB8), cAliasC3, .F., .T. )
    //Serù responsavel por zerar os itens da SB8
    nIx         := 0
    While (cAliasC3)->CONT > nCont3
        lThreadB8   := STARTJOB("U_xIguaB8", getenvserver(), .T., aParam)
        sleep(100)
        nCont3 ++
    END
    //---------------------------------------------------------------EXEC AUTO GERAL AP”S TODAS AS MOVIMENTA«’ES!
    DBSelectArea("SX1")
    DBSetOrder(1)      
    nSpace := Len(SX1->X1_GRUPO) - 6
    
    If DbSeek("MTA300"+Space(nSpace)+"01")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := '' //Local de?
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"02")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := 'ZZ' //Local atÈ?
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"03")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := '' //Produto de?
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"04")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := 'ZZZZZZZZZZZZ' //Produto atÈ?
        MsUnlock()
    Endif

    //Executa a operaÁ„o autom·tica
    lMsErroAuto := .F.
    MSExecAuto({|x| MATA300(x)}, lJob) //Refaz Saldos!
 
    //Se houve erro, salva um arquivo dentro da protheus data
    If lMsErroAuto
        cDiretorio := "\erros\"
        cArquivo   := "log_mata300_"+cProd+"_"+cLocal+"_"+ dToS(Date()) + "_" + StrTran(Time(), ':', '-')
        MostraErro(cDiretorio, cArquivo)
    EndIf 
    nIx := 0
    
    //----------------------------------------------------------------------------------------------------------------------------------
    //--------------------------------------------------------------REFAZ TODO O PROCESSO AP”S O EXECAUTO GERAL.------------------------
    //----------------------------------------------------------------------------------------------------------------------------------

    nCont2 := 0
    //Serù responsùvel zerar os itens negativos da SB2.
    While (cAliasC2)->CONT > nCont2
        lThreadB2   := STARTJOB("U_SBP00102", getenvserver(), .T., aParam)
        sleep(100)
        nCont2 ++
    END
    //Serù responsavel por zerar os itens da SB8
    nIx         := 0
    nCont3      := 0
    While (cAliasC3)->CONT > nCont3
        lThreadB8   := STARTJOB("U_xIguaB8", getenvserver(), .T., aParam)
        sleep(100)
        nCont3 ++
    END
    //-------------------------------------------------------------------------------------------------------------------------------
    //---------------------------------------------------------------REFAZ O EXECAUTO PARA ULTIMA VALIDA«√O!-------------------------
    //---------------------------------------------------------------AP”S EXECU«√O VALIDAR MANUALMENTE!------------------------------
    //-------------------------------------------------------------------------------------------------------------------------------
    DBSelectArea("SX1")
    DBSetOrder(1)      
    nSpace := Len(SX1->X1_GRUPO) - 6
    
    If DbSeek("MTA300"+Space(nSpace)+"01")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := ''//Local de?
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"02")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := 'ZZ' //Local atÈ?
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"03")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := '' //Produto de?
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"04")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := 'ZZZZZZZZZZZZ' //Produto atÈ?
        MsUnlock()
    Endif

    //Executa a operaÁ„o autom·tica
    lMsErroAuto := .F.
    MSExecAuto({|x| MATA300(x)}, lJob) //Refaz Saldos!
 
    //Se houve erro, salva um arquivo dentro da protheus data
    If lMsErroAuto
        cDiretorio := "\erros\"
        cArquivo   := "log_mata300_"+cProd+"_"+cLocal+"_"+ dToS(Date()) + "_" + StrTran(Time(), ':', '-')
        MostraErro(cDiretorio, cArquivo)
    EndIf 

    IF xEmp == "03"
        // RECALCULA O CUSTO M…DIO!
        lRetCus := STARTJOB("U_xAjsVlr", getenvserver(), .T., aParam)
    ENDIF

    //FIM
    conout("|______________________________________________________________|")
    conout("|                                                              |")
    conout("|              FIM DO PROCESSAMENTO DO FONTE SBP0010           |")
    conout("|                                                              |")
    conout("|______________________________________________________________|")
    Conout(dToS(Date()) + "_" + StrTran(Time(), ':', '-'))

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
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        wfPrepENV(xEmp, xFil)
        //wfPrepENV("03", "00")
        conout("Preparou ambiente. . .")
    Else
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
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
   
    IF !EMPTY(cArmzn) .AND. VALTYPE(cArmzn) == 'C' .AND. len(cArmzn) >= 4 //Verifica se os armazÈns foram definidos para evitar zerar TUDO!
        sleep(10)
        u_AjxEmp(xFil)
        sleep(10)
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

        U_xAtuSald(xEmp, xFil,(cAliasB2)->COD, (cAliasB2)->LOCAL)
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
                //CabeÁalho Itens positivos.
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
                //CabeÁalho Itens positivos.
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
               // MostraErro()
                CONOUT("Erro ao gerar movimentaùùo" +cError+" "+(cAliasB2)->COD+"_"+(cAliasB2)->LOCAL)
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
            //CabeÁalho Itens negativos
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
            //CabeÁalho Itens negativos
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
               // MostraErro()
                CONOUT("Erro ao gerar movimentaùùo "+cError+" "+(cAliasB2)->COD+"_"+(cAliasB2)->LOCAL)
               // DisarmTransaction()
                //break
            Else
                
                CONOUT("Feito SD3 Negativos " +(cAliasB2)->COD+"_"+(cAliasB2)->LOCAL)
            EndIF
        EndIf

            cError   	:= ""
            bError   	:= ErrorBlock({ |oError| cError := oError:Description})
    
        U_xAtuSald(xEmp, xFil,(cAliasB2)->COD, (cAliasB2)->LOCAL)
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
    Deleta os registros da SB9 dos armazùns inativos.
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
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        wfPrepENV(xEmp, xFil)
        //wfPrepENV("03", "00")
        conout("Preparou ambiente. . .")
    Else
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        Prepare Environment Empresa xEmp Filial xFil
        conout("Preparou ambiente. . .")
    Endif   


    cArmzn    := GETMV("SB_ARMZERO")

    cQueryB9 += " SELECT DISTINCT B9_FILIAL [FILIAL], B9_COD [COD], B9_LOCAL [LOCAL], B9_DATA [DATAB9], R_E_C_N_O_ [RECNO] "
    cQueryB9 += " FROM "+RetSqlName("SB9")+" SB9 "
    cQueryB9 += " WHERE SB9.D_E_L_E_T_ = '' "
    cQueryB9 += " AND B9_DATA <> '' "
   // cQueryB9 += " AND B9_DATA >= '20181201' "
    cQueryB9 += " AND B9_LOCAL NOT IN ("+cArmzn+") "
    cQueryB9 += " AND B9_DATA > (SELECT MIN(B9_DATA) FROM "+RetSqlName("SB9")+" A WHERE A.B9_FILIAL = SB9.B9_FILIAL AND A.B9_COD = SB9.B9_COD AND A.D_E_L_E_T_ = '' AND SB9.B9_LOCAL = A.B9_LOCAL) "
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

        U_xAtuSald(xEmp, xFil,(cAliasB9)->COD, (cAliasB9)->LOCAL)
        (cAliasB9)->(DbSkip())
    END

    IF lRet
        CONOUT("Excluiu os registros da B9")
    ENDIF

Return lRet

/*/{Protheus.doc} xDelBJ
    Deleta os registros da SBJ dos armazùns inativos.
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
    //cQueryBJ += " AND BJ_DATA >= '20181201' "
    cQueryBJ += " AND BJ_DATA > (SELECT MIN(BJ_DATA) FROM "+RetSqlName("SBJ")+" A WHERE A.BJ_FILIAL = SBJ.BJ_FILIAL AND A.BJ_COD = SBJ.BJ_COD AND A.D_E_L_E_T_ = '' AND SBJ.BJ_LOCAL = A.BJ_LOCAL)  "
    cQueryBJ += " AND BJ_LOCAL NOT IN ("+cArmzn+") "
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
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        wfPrepENV(xEmp, xFil)
        //wfPrepENV("03", "00")
        conout("Preparou ambiente. . .")
    Else
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
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
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        wfPrepENV(xEmp, xFil)
        //wfPrepENV("03", "00")
        conout("Preparou ambiente. . .")
    Else
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
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
    //Identifica que ser· executado via JOB
    Local lJob := .T.
    //DeclaraÁıes
    Local cPerg := ""
    //Try catch
    Local cError        := ""
    Local bError   		:= ErrorBlock({ |oError| cError := oError:Description})
    Local nLog          := 0
    Local nSpace        := 0
   //Prepara ambiente
    IF !EMPTY(lJob)
        IF lAuto
            RPCSetType(3)
            If FindFunction('WFPREPENV')
                RPCSetType( 3 )						// NÔøΩo consome licensa de uso
                wfPrepENV(cXEmp, cXFil)
                //wfPrepENV("03", "00")
                conout("Preparou ambiente. . .")
            Else
                RPCSetType( 3 )						// NÔøΩo consome licensa de uso
                Prepare Environment Empresa cXEmp Filial cXFil
                conout("Preparou ambiente. . .")
            Endif         
        ENDIF
    ENDIF
    CONOUT("Atualiza Saldo!")

    cPerg := "MTA300"
    /*
    u_zAtuPerg(cPerg, "MV_PAR01", cLocal)     //ArmazÈm De
    u_zAtuPerg(cPerg, "MV_PAR02", cLocal)     //ArmazÈm AtÈ
    u_zAtuPerg(cPerg, "MV_PAR03", cProd) //Produto De
    u_zAtuPerg(cPerg, "MV_PAR04", cProd) //Produto AtÈ
     Pergunte(cPerg, .F.)
    */
    
    DBSelectArea("SX1")
    DBSetOrder(1)      
    nSpace := Len(SX1->X1_GRUPO) - 6
    
    If DbSeek("MTA300"+Space(nSpace)+"01")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := cLocal
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"02")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := cLocal
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"03")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := cProd
        MsUnlock()
    Endif
    If DbSeek("MTA300"+Space(nSpace)+"04")
        RecLock("SX1",.F.)
            SX1->X1_CNT01 := cProd
        MsUnlock()
    Endif

    //Executa a operaÁ„o autom·tica
    lMsErroAuto := .F.
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
    //Parùmetros
    Local cArmzn    := ""
    Local cTpMvPC   := ""
	Local cTpMvPSC  := ""
	Local cTpMvNC   := ""
    Local cTpMvNSC  := ""
    Local dDataC    := ""


    If FindFunction('WFPREPENV')
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        wfPrepENV(xEmp, xFil)
        //wfPrepENV("03", "00")
        conout("Preparou ambiente. . .")
    Else
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
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

        
            //Cabeùalho Itens negativos
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
           // MostraErro()
            CONOUT("Erro ao gerar movimentaÁ„o "+cError + ALLTRIM((cAliasB8N)->COD) + "_"+(cAliasB8N)->LOCAL)
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
                //Cabeùalho Itens positivos.
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
              //  MostraErro()
                CONOUT("Erro ao gerar movimentaÁ„o "+cError + ALLTRIM((cAliasB8P)->COD) + "_"+ (cAliasB8P)->LOCAL )
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

        U_xAtuSald(xEmp, xFil,(cAliasB8P)->COD, (cAliasB8P)->LOCAL)
        conout("Passa registro! ")
        (cAliasB8P)->(DbSkip())
    
    end    
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
    (examples)
    @see (links_or_references)
    /*/
user Function xIguaB8(aParam)
    //Definiùùes padrùes
    Local xEmp      := aParam[1]
    Local xFil      := aParam[2]
    //Query
    Local cQueryIB8 := ""
    Local cAliasIB8 := GetNextAlias()    
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
    //Parùmetros
    Local cArmzn    := ""
    Local cTpMovSN  := ""
    Local cTpMovSP  := ""
    Local cTpMovEN  := ""
    Local cTpMovEP  := ""
    Local dDataC    := ""
    Local cLoc      := ""
    Local cLote     := ""
    Local cNmLote   := ""
    //Job Libera Lote
    Local lThrdLot  := ""
    //Cria o ambiente
    RPCSetType(3)
    If FindFunction('WFPREPENV')
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        wfPrepENV(xEmp, xFil)
        //wfPrepENV("03", "00")
        conout("Preparou ambiente. . .")
    Else
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        Prepare Environment Empresa xEmp Filial xFil
        conout("Preparou ambiente. . .")
    Endif   
     
    lThrdLot := STARTJOB("U_xLibLot", getenvserver(), .T., aParam)
    sleep(100)

    cArmzn      := GETMV("SB_ARMZERO")

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
        dDataC      := STOD(GETMV("SB_DTCORTE"))
       
        //Verifica a Validade!!!!!!!!!!
            dbSelectArea("SB8")
            dbGoTo((cAliasIB8)->RECNO)
            RECLOCK("SB8",.F.)
                SB8->B8_DTVALID := STOD("20501230")
            MSUNLOCK()

        
        //Verifica o custo!!!!!!!!
        nCusto      := ConsB2((cAliasIB8)->FILIAL,(cAliasIB8)->COD,(cAliasIB8)->LOCAL,(cAliasIB8)->SALDO)
        IF nCusto > 0
            nCusto := nCusto * ABS((cAliasIB8)->SALDO)
        ELSEIF nCusto < 0  
            nCusto := ABS(nCusto) * ABS((cAliasIB8)->SALDO)
        ELSE
            nCusto := 1
        ENDIF

        _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)
        cProd       := (cAliasIB8)->COD
        cLoc        := (cAliasIB8)->LOCAL
        cLote       := (cAliasIB8)->LOTE
        cNmLote     := (cAliasIB8)->NUMLOTE
        nBloq       := 0
        lBloqArm    := .F.
        lInc        := .F.
        conout("Inicio da movimentacao de ajuste da b8 com b2. "+ALLTRIM((cAliasIB8)->COD)+" | "+ALLTRIM((cAliasIB8)->LOCAL)+" | "+ALLTRIM((cAliasIB8)->LOTE))
        
        //Verifica se o armazùm estù bloqueado e libera caso sim
        lBloqArm    := xBlqArm((cAliasIB8)->LOCAL,1)
        sleep(15)

        //Tipo de movimento positivo.(saida)Lincoln
        IF (cAliasIB8)->SALDO > 0
            //Libera o item caso esteja bloqueado e retira o controle por lote(opcao 1)
            nBloq       := xBlqProd((cAliasIB8)->COD,1,0)
            sleep(10)
            lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc, (cAliasIB8)->SALDO, nCusto, cLote, cNmLote ,0)
            
            //Retorna o produto para o estado original.
            IF  nBloq > 0
                sleep(10)
                nBloq := xBlqProd( (cAliasIB8)->COD,0,nBloq)
            ENDIF
            nBloq       := 0
            //Garante que o produto esteja liberado e com controle de lote.
            nBloq       := xBlqProd((cAliasIB8)->COD,2,0)
            
            //Se incluiu o primeiro movimento de ajuste INCLUI O MOVIMENTO QUE ZERA B2 E B8!!!!!!
            IF !lInc
                U_xMovimen(xFil, _cNUMDOC, cTpMvPC , dDataC, cProd, cLoc, (cAliasIB8)->SALDO, nCusto, cLote, cNmLote ,1)
            ENDIF

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
        /*Todos os registros da B2 devem estar zerados, portanto incluù sempre!
        MAS quando o lote for negativo serù necessùrio fazer a entrada controlando lote
            e uma saùda sem controlar lote!
        */
            lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvNC, dDataC, cProd, cLoc, (cAliasIB8)->SALDO, nCusto, cLote, cNmLote ,1)
            //Retorna o produto para o estado original.
            IF  nBloq > 0
                sleep(10)
                nBloq := xBlqProd( (cAliasIB8)->COD,0,nBloq)
            ENDIF
            nBloq       := 0

            //Libera o item caso esteja bloqueado e retira o controle por lote(opcao 1)
            nBloq       := xBlqProd((cAliasIB8)->COD,1,0)
            sleep(10)
            If !lInc
                lInc := U_xMovimen(xFil, _cNUMDOC, cTpMvPC, dDataC, cProd, cLoc, (cAliasIB8)->SALDO, nCusto, cLote, cNmLote ,0)
            ENDIF
            //Retorna o produto para o estado original.
            IF  nBloq > 0
                sleep(10)
                nBloq := xBlqProd( (cAliasIB8)->COD,0,nBloq)
            ENDIF
            nBloq       := 0

        ENDIF
        //Volta armazùm para o estado original!
        IF  lBloqArm
            sleep(10)
            lBloqArm := xBlqArm((cAliasIB8)->LOCAL,0)
        ENDIF

        (cAliasIB8)->(DbSkip())
    END

Return 

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
        IF (cAliasCB2)->SALDO > 0

            lThreadB2   := STARTJOB("U_SBP00102", getenvserver(), .T., aParam)
            sleep(100)
        ELSEIF (cAliasCB2)->SALDO < 0
            lThreadB2   := STARTJOB("U_SBP00102", getenvserver(), .T., aParam)
            sleep(100)
        ENDIF

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
        //CabeÁalho Itens positivos.
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
                //CabeÁalho Itens positivos.
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
    If EMPTY(cLote)
        cLote := " "
    ENDIF

    aadd(aTotItm,aItem)
    conout("xMovimen......: " +cCodProd + " "+ cLocal + " Lote: "+ cLote)
    MSExecAuto({|x,y,z|MATA241(x,y,z)},aCab,aTotItm,3)
    
    
    IF lMsErroAuto
        aErro := GetAutoGRLog()
        For nW := 1 To Len(aErro)
            cRet += aErro[nW] +CRLF
        Next nW

        conout("Erro ao gerar a movimentaùùo do item "+cCodProd + " "+ cLocal + " Lote: "+ cLote)
        conout(cRet)
    ELSE
        conout("Movimentaùùo incluùda com sucesso! |"+cCodProd + " "+ cLocal + " Lote: "+ cLote)
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

            U_xAtuSald(cEmp, xFilial,cCodProd, cLocal)
        ENDIF
    ENDIF
    aCab    := {}
    aItem   := {}
    aTotItm := {}
    aErro   := {}
    cRet    := ""
    
Return lMsErroAuto

User Function xLibLot(aParam) 
    //Definiùùes padrùes
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
      RPCSetType( 3 )						// NÔøΩo consome licensa de uso
      wfPrepENV(xEmp, xFil)
      //wfPrepENV("03", "00")
      conout("Preparou ambiente Liberacao de lotes. . .")
  Else
      lAuto := .T.
      RPCSetType( 3 )						// NÔøΩo consome licensa de uso
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

/*/{Protheus.doc} User Function xAjsVlr
    (long_description)
    @type  Function
    @author user
    @since 11/12/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xAjsVlr(aParam)
    //Definiùùes padrùes
    Local xEmp      := aParam[1]
    Local xFil      := aParam[2]
    //Declara Query
    Local cQueryB2  := ""
    Local cAliasB2  := ""
    //Declara Par‚metros
    Local cTpMvEC   := ""
    Local cTpMvSC   := ""
    Local cTpMvNSC  := ""
    Local cTpMvNC   := ""
    //Declara Auxiliares
    Local cCodP     := ""
    Local nVatu     := 0
    Local cLoc      := ""
    Local nVal      := 0
    Local nQatu     := 0
    Local nCusto    := 0
    Local lInc      := .F.
    //CUSTOMEDIO
    Local PARAMIXB1 := .T. // - Caso a rotina seja rodada em batch(.T.), sen„o (.F.)
    Local PARAMIXB2 := {xFil} // - Lista com as filiais a serem consideradas (Batch)
    Local PARAMIXB3 := .T. // - Se considera o custo em partes do processamento
    Local PARAMIXB4 := {} // -Parametros para execuÁ„o da rotina

    RPCSetType(3)
    If FindFunction('WFPREPENV')
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        wfPrepENV(xEmp, xFil)
        //wfPrepENV("03", "00")
        conout("Preparou ambiente Liberacao de lotes. . .")
    Else
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        Prepare Environment Empresa xEmp Filial xFil
        conout("Preparou ambiente Liberacao de lotes. . .")
    Endif   
    

    cTpMvEC     := GETMV("SB_TPMVEC") // Tipo de movimento Itens Negativos COM CUSTO APENAS CUSTO
    cTpMvSC    := GETMV("SB_TPMVSC") // Tipo de movimento Itens Negativos SEM CUSTO APENAS CUSTO
    cTpMvNSC    := GETMV("SB_TPMVNSC") // Tipo de movimento Itens Negativos SEM CUSTO
    cTpMvNC     := GETMV("SB_TPMVNC") // Tipo de movimento Itens Negativos COM CUSTO

    cAliasB2 := GetNextAlias()
    
    cQueryB2 := " SELECT B2_FILIAL [FILIAL], B2_COD [COD] , B2_LOCAL [ARMAZEM], B2_QATU [QATU], B2_VATU1 [VATU] "
    cQueryB2 += " FROM "+RetSqlName("SB2")+" SB2"
    cQueryB2 += " WHERE (B2_VATU1 <> 0 OR B2_QATU <> 0) "
    cQueryB2 += " AND B2_COD NOT BETWEEN 'MK0000' AND 'MK9999' "
    cQueryB2 += " AND B2_FILIAL = '"+xFil+"' "
    cQueryB2 += " AND D_E_L_E_T_ = '' "
    cQueryB2 += " ORDER BY 5 "
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryB2), cAliasB2, .F., .T. )

    WHILE !(cAliasB2)->(EoF())

        cCod        := (cAliasB2)->COD
        cLoc        := (cAliasB2)->ARMAZEM
        nQatu       := (cAliasB2)->QATU
        nVatu       := (cAliasB2)->VATU
        CONOUT(cCod+"--------------------------------------")
        nCusto      := STARTJOB("U_xD1Vl", getenvserver(), .T.,aParam,cCod)

        _cNUMDOC    := GETSXENUM("SD3","D3_DOC",NIL)

        //Para os casos onde o armazÈm est· zerado e ainda possuÌ valor.
        IF nQatu == 0 .AND. nVatu != 0
            IF nVatu > 0 
                lInc := U_xMovimen(xFil,_cNUMDOC,cTpMvSC,dDataBase,cCod,cLoc,0,nVatu,,,1)
            ELSEIF nVatu < 0
                lInc := U_xMovimen(xFil,_cNUMDOC,cTpMvEC,dDataBase,cCod,cLoc,0,nVatu,,,1)
            ENDIF

            //Para os casos onde ainda resta saldo no armazÈm!
        ELSEIF nQatu > 0 
                //Quando o valor for zerado apenas faz a quantidade atual  x o custo obtido pela rotina.
            IF nVatu == 0 .AND. nCusto != 0
                nVal := nQatu * nCusto
                lInc := U_xMovimen(xFil,_cNUMDOC,cTpMvEC,dDataBase,cCod,cLoc,0,nVal,,,1)

                //Quando o valor atual for menor que zero È necess·rio incluir o valor + o valor com base no custo retornado pela rotina.
            ELSEIF nVatu < 0 .AND. nCusto != 0
                nVal := (nQatu * nCusto) + ABS(nVatu)
                lInc := U_xMovimen(xFil,_cNUMDOC,cTpMvEC,dDataBase,cCod,cLoc,0,nVal,,,1)

                //Quando o valor atual for maior que zero È necess·rio realizar uma entrada ou saÌda da quantidade.
            ELSEIF nVatu > 0 .AND. nCusto != 0
                nVal := nQatu * nCusto

                IF nVal != nVatu
                    IF nVal > nVatu
                        nVal := nVal - nVatu
                        lInc := U_xMovimen(xFil,_cNUMDOC,cTpMvEC,dDataBase,cCod,cLoc,0,nVal,,,1)
                    ELSE
                        nVal := nVatu - nVal
                        lInc := U_xMovimen(xFil,_cNUMDOC,cTpMvSC,dDataBase,cCod,cLoc,0,nVal,,,1)
                    ENDIF
                ELSE
                    cCod        := ""
                    cLocal      := ""
                    nQatu       := 0
                    nVatu       := 0
                    nVal        := 0
                    (cAliasB2)->(DbSkip())
                    LOOP
                ENDIF
            ENDIF
        
        ELSEIF  nQatu < 0 
            IF nVatu == 0 
                lBloqArm    := xBlqArm(cLoc,1)
                sleep(15)
                nBloq       := xBlqProd(cCod,1,0)
                sleep(10)

                //J· zera o saldo em estoque!
                lInc := U_xMovimen(xFil,_cNUMDOC,cTpMvNSC,dDataBase,cCod,cLoc,nQatu,0,,,1)
            
                
                IF  lBloqArm
                    sleep(10)
                    lBloqArm := xBlqArm(cLoc,0)
                ENDIF
                
                IF  nBloq > 0
                    sleep(10)
                    nBloq := xBlqProd(cCod,0,nBloq)
                ENDIF

            ELSEIF nVatu > 0 

                nVal := (nQatu * nCusto) + ABS(nVatu)
                lInc := U_xMovimen(xFil,_cNUMDOC,cTpMvSC,dDataBase,cCod,cLoc,0,nVal,,,1)

                lBloqArm    := xBlqArm(cLoc,1)
                sleep(15)
                nBloq       := xBlqProd(cCod,1,0)
                sleep(10)

                //J· zera o saldo em estoque!
                lInc := U_xMovimen(xFil,_cNUMDOC,cTpMvNSC,dDataBase,cCod,cLoc,nQatu,0,,,1)

                IF  lBloqArm
                    sleep(10)
                    lBloqArm := xBlqArm(cLoc,0)
                ENDIF
                
                IF  nBloq > 0
                    sleep(10)
                    nBloq := xBlqProd(cCod,0,nBloq)
                ENDIF
            
            ELSEIF nVatu < 0 

                nVal := ABS(nVatu)
                                
                //J· zera o saldo em estoque!
                lBloqArm    := xBlqArm(cLoc,1)
                sleep(15)
                nBloq       := xBlqProd(cCod,1,0)
                sleep(10)
                lInc := U_xMovimen(xFil,_cNUMDOC,cTpMvNC,dDataBase,cCod,cLoc,nQatu,nVal,,,1)

                IF  lBloqArm
                    sleep(10)
                    lBloqArm := xBlqArm(cLoc,0)
                ENDIF
                
                IF  nBloq > 0
                    sleep(10)
                    nBloq := xBlqProd(cCod,0,nBloq)
                ENDIF
                
            ENDIF

        ENDIF

        //Zera Tudo
        cCod        := ""
        cLocal      := ""
        nQatu       := 0
        nVatu       := 0
        nVal        := 0

        //Parte pra prÛxima.
        (cAliasB2)->(DbSkip())
    END

    dData := LastDay(Date()) // Pega o ultimo dia do mÍs corrente
    //PARAMIXB4 := { dData ,1,1,1,0,2," " ,"ZZZZZZZZZZZZZZZ" ,2,2,2,3,2,1,1,1,2,1,2,1,2} //Parametros
    PARAMIXB4 := { dData ,2,2,1,0,1," " ,"ZZZZZZZZZZZZZZZ" ,2,2,2,3,2,1,2,2,1,2,2,2,2} //Parametros
    MSExecAuto({|x,y,z,w|mata330(x,y,z,w)},PARAMIXB1,PARAMIXB2,PARAMIXB3,PARAMIXB4)
    lMsErroAuto := .F.

    if lMsErroAuto
        // MostraErro()
         CONOUT("Erro ao realizar o custo mÈdio.")
        // DisarmTransaction()
         //break
     Else
     
     CONOUT("Feito Recalculo do custo MÈdio")
     EndIf
Return 

/*/{Protheus.doc} User Function xD1Vl
    (long_description)
    @type  Function
    @author user
    @since 13/12/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xD1Vl(aParam,cCod)
    //Definiùùes padrùes
    Local xEmp      := aParam[1]
    Local xFil      := aParam[2]
    //Declara Query
    Local cQuery    := ""
    Local cALiasD1  := ""
    //Auxiliar
    nRet            := 0
    
    RPCSetType(3)
    If FindFunction('WFPREPENV')
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        wfPrepENV(xEmp, xFil)
        //wfPrepENV("03", "00")
        conout("Preparou ambiente Liberacao de lotes. . .")
    Else
        lAuto := .T.
        RPCSetType( 3 )						// NÔøΩo consome licensa de uso
        Prepare Environment Empresa xEmp Filial xFil
        conout("Preparou ambiente Liberacao de lotes. . .")
    Endif   
    
    cAliasD1 := GetNextAlias()

    cQuery += " SELECT D1_FILIAL [FILIAL], D1_COD [COD], ROUND(D1_VUNIT,2) [CUSTO] "
    cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
    cQuery += " WHERE SD1.D_E_L_E_T_ = '' "
    cQuery += " AND D1_FORNECE = '000062' "
    cQuery += " AND D1_LOJA = '01' "
    cQuery += "  AND D1_FILIAL = '"+xFil+"' "
    cQuery += " AND D1_COD = '"+cCod+"' "
    cQuery += "  AND D1_EMISSAO = (SELECT MAX(D1_EMISSAO) FROM "+RetSqlName("SD1")+" A WHERE A.D1_FILIAL = SD1.D1_FILIAL AND A.D1_COD = SD1.D1_COD AND A.D_E_L_E_T_ = '' AND A.D1_FORNECE = '000062' AND A.D1_LOJA = '01') "
    cQuery += "  ORDER BY D1_COD "
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasD1, .F., .T. )

    IF !(cAliasD1)->(EoF())
        nRet := (cAliasD1)->CUSTO
    ELSE
        nRet := 0
    ENDIF

Return nRet

/*/{Protheus.doc} User Function xRodAjst
    (long_description)
    @type  Function
    @author user
    @since 16/12/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xRodAjst(aParam)
    Local xEmp      := aParam[1]
    Local xFil      := aParam[2] 
    Local nI        := 0
    Local lRetAjs   := .F.

    While nI <= 20
        lRetAjs      := STARTJOB("U_xAjsVlr", getenvserver(), .T.,aParam)
    nI++
    END


Return 

User Function AjxEmp(xFil)
LOCAL __query := ""
lOCAL cArmzn    := SUPERGETMV("SB_ARMZERO",.f.,'')
__query := " UPDATE SB2030 SET B2_QEMP = 0,B2_RESERVA =0, B2_QPEDVEN = 0,B2_QEMP2 =0,B2_RESERV2=0,B2_QTSEGUM = 0
__query += " from SB2030 WHERE D_E_L_E_T_ = '' AND B2_FILIAL = '"+xFil+"' AND B2_LOCAL NOT IN ("+cArmzn+") "
//__query += " and B2_COD = '"+cProd+"' AND B2_LOCAL='"+cLocal+"'"

TCSQLExec( __query )
SLEEP( 20 )
__query := " UPDATE SB8030 SET B8_EMPENHO = 0, B8_EMPENH2=0
__query += " from SB8030 WHERE D_E_L_E_T_ = '' AND B8_FILIAL = '"+xFil+"' AND B8_LOCAL NOT IN ("+cArmzn+") "
//__query += " and B8_PRODUTO = '"+cProd+"' AND B8_LOCAL='"+cLocal+"'"
TCSQLExec( __query )
SLEEP( 20 )
__query := " UPDATE SC6030 SET C6_QTDEMP2 = 0, C6_QTDRESE=0, C6_QTDEMP=0,C6_RESERVA=''
__query += " from SC6030 WHERE D_E_L_E_T_ = '' AND C6_FILIAL = '"+xFil+"' AND C6_LOCAL NOT IN ("+cArmzn+") "
__query += " AND (C6_QTDRESE<>0 OR C6_QTDEMP<>0 OR C6_RESERVA<>'' OR C6_QTDEMP2<>0)"
TCSQLExec( __query )
SLEEP( 20 )
RETURN