#include "Protheus.ch"
#include "topconn.ch"  
#include "Totvs.ch"  
#include "tbiconn.ch"
#include "tbicode.ch"
#INCLUDE "fileio.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.  ³ SBP0010 º Uso ³ Surya Brasil º Modulo ³ SIGAEST º Data ³ 30/09/19 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³ Rotina para zerar os armazéns inativos.                    		  º±±
±±º       ³                                                                   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor ³ Alexsandro Salla             º Contato ³(11) 97961-7915           º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
    U_SBP0010({'01','00'})
    U_SBP00102({'08','01'})

    '07','08','09','12','13','14','22','32','33','55','56','88','95','96','97','99'
*/

User Function SBP0010(aParam)
Local xEmp      := aParam[1]
Local xFil      := aParam[2]
Local lThreadB8 := .F.
Local lThreadB2 := .F.

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

    nIx := 0
    lThreadB2 :=  STARTJOB("U_SBP00102", getenvserver(), .T., aParam)
    nIx := 0
    sleep(5000)
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
Local cAliasB2  := GetNextAlias()
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

    cArmzn    := GETMV("SB_ARMZERO")
     //cArmzn := "'03','YY','00'"


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
    cQueryB2 += "AND B2_COD = '12.1.EU'"
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
      
        lBloqArm    := xBlqArm((cAliasB2)->LOCAL,1)
        nBloq       := xBlqProd((cAliasB2)->COD,1,0)

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
                {"D3_EMISSAO"     ,dDataBase                                    ,Nil},;
                {"D3_CC"           ,''                                          ,Nil}}
                //Itens positivos
                aItemP := {{"D3_COD"       ,ALLTRIM((cAliasB2)->COD)            ,NIL},;
                {"D3_QUANT" ,(cAliasB2)->SALDO                                  ,NIL},;
                {"D3_LOCAL" ,(cAliasB2)->LOCAL                                  ,NIL},;
                {"D3_CUSTO1" , nCusto                                           ,NIL},;
                {"D3_IDENT" ,PROXNUM()                                          ,NIL},;
                {"D3_NUMSEQ" ,PROXNUM()                                         ,NIL},;
                {"D3_XMOV" ,"Ajuste de estoque automatico"                      ,NIL},;
                {"D3_USUARIO","Admin"                         ,NIL}}       
            ELSE
                //Cabeçalho Itens positivos.
                aCabP := {{"D3_FILIAL"     ,(cAliasB2)->FILIAL      ,Nil},;
                {"D3_DOC"          ,_cNumDoc                        ,Nil},;
                {"D3_TM"           ,cTpMvPSC                        ,Nil},;
                {"D3_EMISSAO"     ,dDataBase                        ,Nil},;
                {"D3_CC"           ,''                              ,Nil}}
                //Itens positivos
                aItemP := {{"D3_COD"       ,ALLTRIM((cAliasB2)->COD)           ,NIL},;
                {"D3_QUANT" ,(cAliasB2)->SALDO                                 ,NIL},;
                {"D3_LOCAL" ,(cAliasB2)->LOCAL                                 ,NIL},;
                {"D3_CUSTO1" ,nCusto                                           ,NIL},;
                {"D3_IDENT" ,PROXNUM()                                         ,NIL},;
                {"D3_NUMSEQ" ,PROXNUM()                                        ,NIL},;
                {"D3_XMOV" ,"Ajuste de estoque automatico"                     ,NIL},;
                {"D3_USUARIO","Admin"                           ,NIL}}  
            ENDIF
            BEGIN SEQUENCE
            aadd(aTotItm,aItemP)
            MSExecAuto({|x,y,z|MATA241(x,y,z)},aCabP,aTotItm,3)               
           // MATA241(aCabP,aItemP,3)
            END SEQUENCE
            ErrorBlock(bError)

            if lMsErroAuto
                //MostraErro()
                CONOUT("Erro ao gerar movimentação"+cError)
               // DisarmTransaction()
                //break
            Else
            
            CONOUT("Feito SD3 Positivos" +(cAliasB2)->COD+"_"+(cAliasB2)->LOCAL)
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
            {"D3_EMISSAO"     ,dDataBase                         ,Nil},;
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
            {"D3_EMISSAO"     ,dDataBase                         ,Nil},;
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
                CONOUT("Erro ao gerar movimentação "+cError)
               // DisarmTransaction()
                //break
            Else
                
                CONOUT("Feito SD3 Negativos" +(cAliasB2)->COD+"_"+(cAliasB2)->LOCAL)
            EndIF
        EndIf

            cError   	:= ""
            bError   	:= ErrorBlock({ |oError| cError := oError:Description})
    
      //  U_xAtuSald(xEmp, xFil,(cAliasB2)->COD, (cAliasB2)->LOCAL)
        IF  lBloqArm
            lBloqArm := xBlqArm((cAliasB2)->LOCAL,0)
        ENDIF
        
        IF  nBloq > 0
            nBloq := xBlqProd( (cAliasB2)->COD,0,nBloq)
        ENDIF

        aCabP   := {}
        aItemP  := {}
        aCabN   := {}
        aItemN  := {}
        aTotItm := {}
        (cAliasB2)->(DbSkip())
    END

ENDIF

Return  .T.

/*/{Protheus.doc} User Function SBP00101
    Procura saldos da B8 que precisam ser zerados!
    Caso informado 3 e 4 parametros será realizado o ajuste por item e local.

    @type  Function
    @author user
    @since 01/10/2019
    @version version
    @param aParam(EMPRESA, FILIAL, PRODUTO*, ARMAZEM*)
    @return 
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function SBP00101(aParam)
Local xEmp      := aParam[1]
Local xFil      := aParam[2]
Local xProdut   := ""
Local xArmzn    :=  ""
Local cAliasB8  := GetNextAlias()
Local cArmzn    := ""
Local cQueryB8  := ""
Local lThread1  := .F.
Local lThread2  := .F.
Local aCabN     := {}
Local aCabP     := {}
Local aItemN    := {}
Local aItemP    := {}
Local nP        := 0
Local nN        := 0
Local nIx       := 0
Local aTotItm   := {}
//Tratativa de erros
Local cError   	:= ""
Local bError   	:= ErrorBlock({ |oError| cError := oError:Description})
Local nLog      := 0
Local cData     := "" 
Local cDir      := "\erros\"
Local cDtLote   := ""
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
    cArmzn := GETMV("SB_ARMZERO")
     // cArmzn := "'03','YY','00'"

    //Caso fosse utilizar apóso B2
IF Len(aParam) > 2
    xProdut   := aParam[3]
    xArmzn    := aParam[4]
ENDIF

IF !EMPTY(cArmzn) .AND. VALTYPE(cArmzn) == 'C' .AND. len(cArmzn) >= 4
        
    cQueryB8 := "SELECT B8_FILIAL [FILIAL], B8_PRODUTO [COD], "
    cQueryB8 += "B8_LOCAL [LOCAL], B8_QTDORI[ORIGINAL],B8_SALDO [SALDO], B8_LOTECTL [LOTE], B8_DATA [DATALOTE], SB8.R_E_C_N_O_ [RECNO], B8_DTVALID [DATAVENC] "
    cQueryB8 += "FROM "+RetSqlName("SB8")+" SB8 "
    cQueryB8 += "WHERE B8_LOCAL NOT IN ("+cArmzn+")"
    cQueryB8 += " AND SB8.D_E_L_E_T_ = '' AND B8_SALDO <> 0"
    cQueryB8 += " AND B8_FILIAL = '"+xFil+"' "
    
    If LEN(aParam) > 2
        cQueryB8 += " AND B8_LOCAL = '"+xArmzn+"' "
        cQueryB8 += " AND B8_PRODUTO = '"+xProdut+"' "
    ENDIF

    cQueryB8 += " ORDER BY B8_FILIAL, B8_PRODUTO, B8_LOCAL"
    cQueryB8 := changequery(cQueryB8)
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryB8), cAliasB8, .F., .T. )

    while !(cAliasB8)->(Eof())
        lThread1  := .F.
        lThread2  := .F.
        //Numeração do Documento
        _cNUMDOC  := GETSXENUM("SD3","D3_DOC",NIL)
        //Atualiza Saldo
     //   U_xAtuSald(xEmp, xFil,(cAliasB8)->COD, (cAliasB8)->LOCAL)
        cDtLote := (cAliasB8)->DATAVENC
        //Torna o lote válido
        DbSelectArea("SB8")
        DbGoTo( (cAliasB8)->RECNO )
        RecLock("SB8",.F.)
        SB8->B8_DTVALID := dDataBase
        MsUnlock()

        IF (cAliasB8)->SALDO > 0
            //Cabeçalho Itens positivos.
            aCabP := {{"D3_FILIAL"     ,(cAliasB8)->FILIAL   ,Nil},;
                {"D3_DOC"          ,_cNumDoc,Nil},;
                {"D3_TM"           ,'501'               ,Nil},;
                {"D3_EMISSAO"     ,STOD((cAliasB8)->DATALOTE)           ,Nil},;
                {"D3_CC"           ,''                ,Nil}}
            //Itens positivos
            aItemP := {{"D3_COD"       ,ALLTRIM((cAliasB8)->COD)            ,NIL},;
            {"D3_QUANT" ,(cAliasB8)->SALDO                                 ,NIL},;
            {"D3_LOCAL" ,(cAliasB8)->LOCAL                                 ,NIL},;
            {"D3_CUSTO1", 1                                                ,NIL},;
            {"D3_IDENT" ,PROXNUM()                                         ,NIL},;
            {"D3_NUMSEQ" ,PROXNUM()                                        ,NIL},;
            {"D3_LOTECTL" ,(cAliasB8)->LOTE                                ,NIL},;
            {"D3_XMOV" ,"Ajuste de estoque automatico"                     ,NIL},;
            {"D3_USUARIO","AJUSTE  "                                       ,NIL}}         
           
            aadd(aTotItm,aItemP)
            MSExecAuto({|x,y,z|MATA241(x,y,z)},aCabP,aTotItm,3)               
           //MATA241(aCabP,aItemP,3)

            if lMsErroAuto
                //MostraErro()
                CONOUT("Erro ao gerar movimentação")
               // DisarmTransaction()
              //  break
            Else
                
                CONOUT("Feito SD3 Positivos" +(cAliasB8)->COD+"_"+(cAliasB8)->LOCAL)
            EndIf
            
        ELSE
            //Cabeçalho Itens negativos
                aCabN := {{"D3_FILIAL"     ,(cAliasB8)->FILIAL    ,Nil},;
                {"D3_DOC"          ,_cNumDoc           ,Nil},;
                {"D3_TM"           ,'001'               ,Nil},;
                {"D3_EMISSAO"     ,STOD((cAliasB8)->DATALOTE)           ,Nil},;
                {"D3_CC"           ,''                ,Nil}}
                
            //Items negativos
            aItemN := {{"D3_COD"       ,ALLTRIM((cAliasB8)->COD)         ,NIL},;
            {"D3_QUANT" ,((cAliasB8)->SALDO*(-1)+(cAliasB8)->ORIGINAL)     ,NIL},;
            {"D3_LOCAL" ,(cAliasB8)->LOCAL                                 ,NIL},;
            {"D3_CUSTO1", 1                                                ,NIL},;
            {"D3_IDENT" ,PROXNUM()                                         ,NIL},;
            {"D3_NUMSEQ" ,PROXNUM()                                        ,NIL},;
            {"D3_LOTECTL" ,(cAliasB8)->LOTE                                ,NIL},;
            {"D3_XMOV" ,"Ajuste de estoque automatico"                     ,NIL},;
            {"D3_USUARIO","AJUSTE  "                                       ,NIL}}   
            
            BEGIN SEQUENCE
            aadd(aTotItm,aItemN)
             //Itens Negativos     
            MSExecAuto({|x,y,z|MATA241(x,y,z)},aCabN,aTotItm,3)
           // MATA241(aCabP,aItemP,3)
            END SEQUENCE   
            ErrorBlock(bError)
        
            If lMsErroAuto
                //MostraErro()
                CONOUT("Erro ao gerar movimentação "+cError)
               // DisarmTransaction()
              //break
            Else
              
              CONOUT("Feito SD3 Negativos" +(cAliasB8)->COD+"_"+(cAliasB8)->LOCAL)
            EndIf

            cError   	:= ""
            bError   	:= ErrorBlock({ |oError| cError := oError:Description})

            dbSelectArea("SB8")
            
            IF !EMPTY(SB8->(DBGOTO( (cAliasB8)->RECNO )))
                RecLock("SB8", .F.)
                dbDelete()
                MsUnLock()
            ELSE 
                aCabP   := {}
                aItemP  := {}
                aCabN   := {}
                aItemN  := {}
                aTotItm := {}
                (cAliasB8)->(DbSkip())
                LOOP
            ENDIF
            
            lThread1 := STARTJOB("U_xProcD5", getenvserver(), .T., xEmp,xFil,(cAliasB8)->COD,(cAliasB8)->LOCAL,(cAliasB8)->LOTE,_cNumDoc)
            lThread2 := STARTJOB("U_xProcB8", getenvserver(), .T., xEmp,xFil,(cAliasB8)->COD,(cAliasB8)->LOCAL,(cAliasB8)->LOTE,_cNumDoc, (cAliasB8)->DATALOTE)
            sleep(15000)

            while (!lThread1 .AND. !lThread2 ) .OR. nIx <= 12
                sleep(10000)
                nIx ++
                IF nIx >= 12 .AND. (!lThread1 .AND. !lThread2 )
                    (cAliasB8)->(DbSkip())
                    LOOP
                ENDIF
            end

        ENDIF
        DbGoTo( (cAliasB8)->RECNO )
        RecLock("SB8",.F.)
        SB8->B8_DTVALID := cDtLote
        MsUnlock()
        //roda saldo atual
        U_xAtuSald(xEmp, xFil,(cAliasB8)->COD, (cAliasB8)->B8_LOCAL)

        aCabP   := {}
        aItemP  := {}
        aCabN   := {}
        aItemN  := {}
        aTotItm := {}
        (cAliasB8)->(DbSkip())
    end


ENDIF


Return .T.


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
u_zAtuPerg(cPerg, "MV_PAR01", cLocal)     //Armazém De
u_zAtuPerg(cPerg, "MV_PAR02", cLocal)     //Armazém Até
u_zAtuPerg(cPerg, "MV_PAR03", cProd) //Produto De
u_zAtuPerg(cPerg, "MV_PAR04", cProd) //Produto Até
Pergunte(cPerg, .F.)
 
//Executa a operação automática
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
            RecLock("NNR",.F.)
                NNR->NNR_MSBLQL := "2"
            MsUnlock()
            lRet := .T.
        ENDIF
    ELSE
        DbSelectArea("NNR")
        IF DbGoTo( (cAliasNr)->RECNO)
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
                RECLOCK("SB1",.F.)
                    SB1->B1_MSBLQL := "2"
                    SB1->B1_RASTRO := "N"
                MSUNLOCK()
                nRet := 1
            ELSEIF SB1->B1_RASTRO == 'L'
                 RECLOCK("SB1",.F.)
                    SB1->B1_RASTRO := "N"
                 MSUNLOCK()
                nRet := 2
            ELSEIF SB1->B1_MSBLQL == '1' 
                RECLOCK("SB1",.F.)
                    SB1->B1_MSBLQL := "2"
                MSUNLOCK()
                nRet := 3
            ENDIF
       
    ELSE
        DbSelectArea("SB1")
        DbGoTo( (cAliasB1)->RECNO )
            IF nOp2 == 1
                RECLOCK("SB1",.F.)
                    SB1->B1_MSBLQL := "1"
                    SB1->B1_RASTRO := "L"
                MSUNLOCK()
                nRet := 1
            ELSEIF nOp2 == 2
                RECLOCK("SB1",.F.)
                    SB1->B1_RASTRO := "L"
                MSUNLOCK()
                nRet := 2
            ELSEIF nOp2 == 3
                RECLOCK("SB1",.F.)
                    SB1->B1_MSBLQL := "1"
                MSUNLOCK()
                nRet := 3
            ENDIF 
    ENDIF
Return nRet



