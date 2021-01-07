#INCLUDE "PROTHEUS.CH"
 
//Antigo SB_PICK

User Function SRFAT002(cAlias,nReg,nOpcx) //antigo SBR0003
PRIVATE wnrel	:=  "SB_PCK"
PRIVATE cString	:= "SB1"

PRIVATE LPrim   := .F. 
PRIVATE ncw     := 0
PRIVATE li      := 18000
PRIVATE nLinMax	:= 3500  // Número máximo de Linhas  A4 - 2250 // Oficio - 2800
PRIVATE nColMax	:= 3500  // Número máximo de Colunas A4 - 3310 // Oficio - 3955
PRIVATE nPag    := 0
Private nI      := 0
Private nPri    := 0
PRIVATE Tamanho		:=   "G"
PRIVATE titulo		:=  "PICK-LIST DE PEDIDOS DE VENDA"
PRIVATE aReturn 	:= {"Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
PRIVATE nomeprog	:= "SB_PICK"
PRIVATE cPerg   	:= "SB_PCK"
PRIVATE nLastKey	:= 0 
PRIVATE nReg		:= 0
PRIVATE cFiltro   	:= ""
PRIVATE nTotLido 	:= 0
PRIVATE nTotPag     := 0
PRIVATE nTotImp     := 0
PRIVATE nImpx       := 0     
PRIVATE cCLIENTE    := ""
PRIVATE cLOJA       := ""
PRIVATE cPEDIDO     := ""
PRIVATE cNOME       := ""
PRIVATE cEND        := ""
PRIVATE cMUN        := ""
PRIVATE cEST        := ""
PRIVATE cCEP        := ""
PRIVATE cBAIRRO     := ""   
PRIVATE cCGC        := ""   
PRIVATE cData1      := ""
PRIVATE cMENNOTA    := ""
PRIVATE cMENPAD     := ""
PRIVATE cMENFOR     := ""
PRIVATE cLOTECTL    := ""
PRIVATE cDTVALID    := ""
PRIVATE cTES        := ""
PRIVATE cNFVEDIC    := ""
PRIVATE cITVEDIC    := ""
Private cFCGC   := GetMv("MV_CNPJV")  
Private cForne  := Posicione("SA2",3,xFILIAL("SA2")+cFCGC,"A2_COD")
Private CFLoja  := Posicione("SA2",3,xFILIAL("SA2")+cFCGC,"A2_LOJA")
Private cTESCORP := SUBSTR(GetMv("MV_TESCORP"),5,3)   
PRIVATE cLOGOX   := ""
PRIVATE lEnd	:= .F.

PRIVATE oPrint
PRIVATE oFont8
PRIVATE oFont8n
PRIVATE oFont8c
PRIVATE oFont11c
PRIVATE oFont10
PRIVATE oFont10c
PRIVATE oFont14
PRIVATE oFont16n
PRIVATE oFont15
PRIVATE oFont14n
PRIVATE oFont12n
PRIVATE oFont24
PRIVATE oFont4
PRIVATE oFont6
PRIVATE oFont6n
PRIVATE oFont9
PRIVATE oFont11
PRIVATE oFont12 

CRIA_PERGUNTA()

If nLastKey == 27
   dbClearFilter()
   Return
Endif

Pergunte(cPerg,.F.)

wnRel 	:= SetPrint(cString, wnRel, cPerg,,,,,.F.,,,,.T.,.T.)
If nLastKey == 27
   dbClearFilter()
   Return
Endif


RptStatus({|lEnd| ROT_PRINCIPAL(@lEnd,wnRel,cString,nReg)},titulo, "Gerando o Relatório, Favor Aguardar......") 
Return .T. 
            
//===============================================================================================================
Static Function ROT_PRINCIPAL(lEnd,WnRel,cString,nReg)
//===============================================================================================================
oFont4    := TFont():New("Arial",5,4,.T.,.F.,5,.T.,5,.T.,.F.)
oFont6    := TFont():New("Arial",9,6,.T.,.F.,5,.T.,5,.T.,.F.)
oFont6n   := TFont():New("Arial",9,6,.T.,.T.,5,.T.,5,.T.,.F.)  //Negrito
oFont8    := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8n   := TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.)  //Negrito
oFont11c  := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8c   := TFont():New("Courier New",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10   := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.) //Font padrao utilizado para impressao de detalhe
oFont14   := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.) 
oFont20   := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21   := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n  := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.) //Negrito
oFont15   := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n  := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.) //Negrito
oFont12n  := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)     //Negrito 
oFont12n  := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)     //Negrito 
oFont24   := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9    := TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11   := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12   := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)

   oPrint := TMSPrinter():New("Análise ...")    

oPrint:SetPortrait()     // Modo Retrato          
oPrint:SetPaperSize(9) // 5=Papel Oficio
  
li:= 18000   
IF Select("RS_SX9") > 0 
    DbSelectArea("RS_SX9")
    DbCloseArea() 
Endif
cQuery   :="SELECT C9_CLIENTE,C9_LOJA,C9_PEDIDO,A1_NOME,A1_END,A1_MUN,A1_EST,A1_CEP,A1_BAIRRO,A1_CGC,C5_MENNOTA,C5_MENPAD "
cQuery   +=" FROM "+RetSqlName("SC9") +" SC9 (NOLOCK)"
cQuery   +=" , "+RetSqlName("SA1") +" SA1 (NOLOCK)"
cQuery   +=" , "+RetSqlName("SC5") +" SC5 (NOLOCK)"
cQuery   +=" WHERE SC9.D_E_L_E_T_ = ' '"
cQuery   +=" AND SA1.D_E_L_E_T_ = ' '"
cQuery   +=" AND C9_FILIAL = '"+XFILIAL("SC9")+"'"        
cQuery   +=" AND C5_FILIAL = '"+XFILIAL("SC5")+"'"        
cQuery   +=" AND C9_CLIENTE = A1_COD"
cQuery   +=" AND C9_LOJA = A1_LOJA"         
cQuery   +=" AND C9_CLIENTE = C5_CLIENTE"
cQuery   +=" AND C9_LOJA = C5_LOJACLI"         
cQuery   +=" AND C9_PEDIDO = C5_NUM"         
cQuery   +=" AND C9_PEDIDO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'" 
cQuery   +=" GROUP BY C9_CLIENTE,C9_LOJA,C9_PEDIDO,A1_NOME,A1_END,A1_MUN,A1_EST,A1_CEP,A1_BAIRRO,A1_CGC,C5_MENNOTA,C5_MENPAD" 
cQuery   +=" UNION ALL "
cQuery   +=" SELECT C9_CLIENTE,C9_LOJA,C9_PEDIDO,A2_NOME,A2_END,A2_MUN,A2_EST,A2_CEP,A2_BAIRRO,A2_CGC,C5_MENNOTA,C5_MENPAD "
cQuery   +=" FROM "+RetSqlName("SC9") +" SC9 (NOLOCK)"
cQuery   +=" , "+RetSqlName("SA2") +" SA1 (NOLOCK)"
cQuery   +=" , "+RetSqlName("SC5") +" SC5 (NOLOCK)"
cQuery   +=" WHERE SC9.D_E_L_E_T_ = ' '"
cQuery   +=" AND SA1.D_E_L_E_T_ = ' '"
cQuery   +=" AND C9_FILIAL = '"+XFILIAL("SC9")+"'"        
cQuery   +=" AND C5_FILIAL = '"+XFILIAL("SC5")+"'"        
cQuery   +=" AND C9_CLIENTE = A2_COD"
cQuery   +=" AND C9_LOJA = A2_LOJA"         
cQuery   +=" AND C9_CLIENTE = C5_CLIENTE"
cQuery   +=" AND C9_LOJA = C5_LOJACLI"         
cQuery   +=" AND C9_PEDIDO = C5_NUM"   
cQuery   +=" AND A2_COD = '"+cForne+"'"      
cQuery   +=" AND A2_LOJA = '"+CFLoja+"' "
cQuery   +=" AND C9_PEDIDO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'" 
cQuery   +=" GROUP BY C9_CLIENTE,C9_LOJA,C9_PEDIDO,A2_NOME,A2_END,A2_MUN,A2_EST,A2_CEP,A2_BAIRRO,A2_CGC,C5_MENNOTA,C5_MENPAD" 
cQuery   +=" ORDER BY C9_PEDIDO" 
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "RS_SX9", .F., .T.)  		
dbselectarea("RS_SX9")    
DbGoTop()  
While (!RS_SX9->(EOF()))  
       cCLIENTE := RS_SX9->C9_CLIENTE
       cLOJA    := RS_SX9->C9_LOJA
       cPEDIDO  :=  RS_SX9->C9_PEDIDO
       cNOME    := RS_SX9->A1_NOME
       cEND     := RS_SX9->A1_END
       cMUN     := RS_SX9->A1_MUN
       cEST     := RS_SX9->A1_EST
       cCEP     := RS_SX9->A1_CEP
       cBAIRRO  := RS_SX9->A1_BAIRRO       
       cCGC     := RS_SX9->A1_CGC
       nPri := 0
       cMENNOTA := RS_SX9->C5_MENNOTA
       cMENPAD  := RS_SX9->C5_MENPAD
       cMENFOR  := Posicione("SM4",1,xFILIAL("SM4")+cMENPAD,"M4_FORMULA")

       li:= SB_IMP_DETALHE(li)             
       If nPri = 1                 
          li:= SB_IMP_MSG(li)                
          li:= IMP_RODAPE(li)	  
          oPrint:EndPage()                          
       Endif    
      RS_SX9->(DbSkip())      
EndDo       
if aReturn[5] == 3     
   Eject
Endif
If aReturn[5] == 1   // Se Saída para disco, ativa SPOOL
   Set Printer TO
   dbCommitAll()
   //ourspool(wnrel)
Endif
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return .T.

//===============================================================================================================
Static Function SB_IMP_DETALHE(li)
//=============================================================================================================== 
local nTotLib := 0      
IF Select("RS_DETAIL") > 0 
    DbSelectArea("RS_DETAIL")
    DbCloseArea() 
Endif

cQuery :="SELECT C9_PRODUTO,B1_DESC,C9_LOCAL,C9_LOTECTL,C9_NUMLOTE,C9_DTVALID,C9_QTDLIB,C9_ITEM,B1_UM,C9_PEDIDO,B1_RASTRO,C9_NFISCAL"
cQuery +=", C9_PRCVEN " 
cQuery +=" FROM "+RetSqlName("SC9") +" SC9 (NOLOCK)"
cQuery +=", "+RetSqlName("SB1") +" SB1 (NOLOCK)"
cQuery+=" WHERE SC9.D_E_L_E_T_ = ' '"
cQuery +=" AND SB1.D_E_L_E_T_ = ' '"
cQuery +=" AND C9_FILIAL = '"+XFILIAL("SC9")+"'"
cQuery +=" AND B1_FILIAL = '"+XFILIAL("SB1")+"'"
cQuery +=" AND C9_PRODUTO = B1_COD"
cQuery +=" AND C9_CLIENTE = '"+cCLIENTE+"'"
cQuery +=" AND C9_LOJA = '"+cLOJA+"'"
cQuery +=" AND C9_PEDIDO = '"+cPEDIDO+"'""
cQuery +=" ORDER BY C9_ITEM "
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "RS_DETAIL", .F., .T.)  		
 dbselectarea("RS_DETAIL")    
DbGoTop()  
li:= 500000
SetRegua(RecCount()) 
nTotLib:= 0
While (!RS_DETAIL->(EOF()))
	nTotLib := RS_DETAIL->C9_PRCVEN*RS_DETAIL->C9_QTDLIB
    cLOTECTL := RS_DETAIL->C9_LOTECTL
    cDTVALID := RS_DETAIL->C9_DTVALID           
    cTES     := POSICIONE("SC6",1,XFILIAL("SC6")+RS_DETAIL->C9_PEDIDO+RS_DETAIL->C9_ITEM+RS_DETAIL->C9_PRODUTO,"C6_TES")             
    If ALLTRIM(cTESCORP) = cTES
    	cNFVEDIC := POSICIONE("SC6",1,XFILIAL("SC6")+RS_DETAIL->C9_PEDIDO+RS_DETAIL->C9_ITEM+RS_DETAIL->C9_PRODUTO,"C6_NFVEDIC")
        cITVEDIC := POSICIONE("SC6",1,XFILIAL("SC6")+RS_DETAIL->C9_PEDIDO+RS_DETAIL->C9_ITEM+RS_DETAIL->C9_PRODUTO,"C6_ITVEDIC")         
        cLOTECTL := POSICIONE("SD1",1,XFILIAL("SD1")+cNFVEDIC+"002"+cForne+CFLoja+RS_DETAIL->C9_PRODUTO+cITVEDIC,"D1_LOTECTL")
        cDTVALID := DTOS(POSICIONE("SD1",1,XFILIAL("SD1")+cNFVEDIC+"002"+cForne+CFLoja+RS_DETAIL->C9_PRODUTO+cITVEDIC,"D1_DTVALID"))
    Endif   
    If(ALLTRIM(RS_DETAIL->B1_RASTRO) <> "" .AND. ALLTRIM(RS_DETAIL->B1_RASTRO) <> "N" .AND. ALLTRIM(RS_DETAIL->C9_LOTECTL) <> "" .AND. RS_DETAIL->C9_QTDLIB > 0) .OR. (ALLTRIM(RS_DETAIL->B1_RASTRO) <> "L" .AND. ALLTRIM(RS_DETAIL->B1_RASTRO) <> "S" .AND. RS_DETAIL->C9_QTDLIB > 0)
    	IncRegua()
        nTotImp := nTotImp + 1                                           
        If lEnd
        	@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
            Goto Bottom
            Exit
        Endif  
        li:= li+40
        If nPri = 1
        	If li > nLinMax
        		li:= IMP_RODAPE(li)	  
                oPrint:EndPage()  
                nPag:=nPag+ 1
                li:= IMP_CABEC(ncw,nPag)
            Endif
        Endif   
        If li > nLinMax 
        	nPag:=nPag+ 1
            li:=IMP_CABEC(ncw,nPag)            
        Endif                       
        nPri   := 1                        
        cData1 := SUBSTR(cDTVALID,7,2)+"/"+SUBSTR(cDTVALID,5,2)+"/"+SUBSTR(cDTVALID,3,2)           
        oPrint:Say (li,0020,RS_DETAIL->C9_LOCAL           ,oFont11c,,,,,) //pedido
        oPrint:Say (li,0100,RS_DETAIL->C9_PRODUTO         ,oFont11c,,,,,) //pedido
        oPrint:Say (li,0400,RS_DETAIL->B1_DESC             ,oFont11c,,,,,) //produto
        oPrint:Say (li,1200,+RS_DETAIL->B1_UM+"  " +cLOTECTL,oFont11c,,,,,) //data 
        oPrint:Say (li,1570,+cData1                     ,oFont11c,,,,,) //data      
        oPrint:Say (li,1680,(Transform((RS_DETAIL->C9_QTDLIB),"@E 9,999,999.9999")),oFont11c,,,,,) // preço unitário       RS_DETAIL->(DbSkip()) 
        oPrint:Say (li,2150,RS_DETAIL->C9_NFISCAL           ,oFont11c,,,,,) //Nota Fiscal
    Endif
    RS_DETAIL->(DbSkip())           
EndDo 
li:= li+40
If nPri = 1
	If li > nLinMax
		li:= IMP_RODAPE(li)	  
        oPrint:EndPage()  
        nPag:=nPag+ 1
        li:= IMP_CABEC(ncw,nPag)
    Endif
Endif   
If li > nLinMax 
   	nPag:=nPag+ 1
    li:=IMP_CABEC(ncw,nPag)            
Endif                       
nPri   := 1
oPrint:Line(li,00,li,nColMax)
oPrint:Say (li,0020,"TOTAL R$:"          ,oFont11c,,,,,)
oPrint:Say (li,1680,(Transform(nTotLib,"@E 9,999,999.99")),oFont11c,,,,,)
dbSelectArea("RS_DETAIL")
dbCloseArea()

Return (li)                

//===============================================================================================================
Static Function IMP_LOGO(cLogo,cTipo)
//===============================================================================================================
Local  cStartPath := GetSrvProfString("Startpath","")
Local cLogox      := ""
If cEmpAnt = "01"
   cLogox := "LOGO-VEDIC.bmp"  
Endif   
If cEmpAnt = "03"
   cLogox := "LOGO-WWAC.bmp"  
Endif                  
If cEmpAnt = "06"
   cLogox := "LOGO-GEMMINES.bmp"  
Endif
If cEmpAnt = "07"
   cLogox := "LOGO-RCG.bmp"  
Endif
cLogo := "1"
cTipo  := If(cTipo == NIL, "1", cTipo)
If cTipo  == "1"
//   cLogo := cStartPath+"lgrl"+cEmpAnt+cFilAnt+".bmp"
   cLogo := cStartPath+cLogox
   If !File( cLogo )
      //cLogo := cStartPath+"lgrl"+cEmpAnt+".bmp"
      cLogo := cStartPath+cLogox
   endif
Else
   cLogo := cStartPath+cLogox
   //cLogo := cStartPath + "icone_rip.bmp"
Endif
Return(NIL)

//===============================================================================================================
Static Function IMP_CABEC(ncw,nPag)
//===============================================================================================================
Local cFileLogo	:= ""


nRow1:= 0
oPrint :StartPage() // Inicia Nova página
nTotPag ++                   // Somar 1 no Total de Páginas Impressas
IMP_LOGO(@cFileLogo,"1")  

oPrint:Line(00,00,00,nColMax)   //1 Linha horizontal
oPrint:Line(00,3010,170,3010)   //2 Linha vertical
If File(cFilelogo)
   oPrint:SayBitmap(100,10, cFileLogo,274,200) //-- Tem que estar abaixo do RootPath 060,080,200,170
Endif 

oPrint:say(010, 310,"Parâmetros:", oFont8n)
oPrint:say(040, 310,"Pedido  de "+MV_PAR01+" ate "+MV_PAR02, oFont8n)
oPrint:say(100, 330,ALLTRIM(SM0->M0_NOME), oFont11c)
oPrint:say(200, 330,"NR:"+ALLTRIM(cPEDIDO), oFont11c)
oPrint:Line(00,720,310,720)     //1 Linha vertical 
oPrint:Line(00,290,310,290)     //1 Linha vertical 
oPrint:Line(00,1980,310,1980)     //1 Linha vertical 
oPrint:say(040, 2020,"Página: ", oFont8n,,,,0) // A-4=3050 / Oficio=3670
oPrint:say(040, 2220,STRZERO(nPag,4), oFont8)    
oPrint:say(070, 2020,"Emissão: ", oFont8n,,,,0)
oPrint:say(070, 2220,DTOC(dDataBase), oFont8)
oPrint:say(100, 2020,"Horário: ", oFont8n,,,,0)
oPrint:say(100, 2220,Left(Time(),5), oFont8)             
oPrint:say(130, 2020,"Relat: ", oFont8n,,,,0)  
oPrint:say(130, 2220,wnrel, oFont8c)  
li:= 200          
oPrint:say(0050,800, Titulo, oFont12n)
oPrint:say(100,800, "Cliente: "+ALLTRIM(cCLIENTE)+"-"+ALLTRIM(cLOJA)+"-"+SUBSTR(ALLTRIM(cNOME),1,35), oFont11c)
oPrint:say(150,800, "Endereco: "+SUBSTR(ALLTRIM(cEND)+" - "+ALLTRIM(cBAIRRO),1,50), oFont11c)
oPrint:say(200, 800, "Cidade: "+ALLTRIM(cMUN)+" - "+ALLTRIM(cEST)+"  CEP :"+SUBSTR(cCEP,1,5)+"-"+SUBSTR(cCEP,6,3), oFont11c)
oPrint:say(250, 800, iif(len(ALLTRIM(cCGC))>11,"CNPJ: "+(Transform((cCGC),"@R 99.999.999/9999-99")),"CPF: "+(Transform((cCGC),"@R 999.999.999-99"))), oFont11c)

oPrint:Line(0310,00,0310,nColMax) //1 Linha horizontal   
li := 0350
oPrint:Say (li,0020,"ARM"           ,oFont11c,,,,,) 
oPrint:Say (li,0100,"PRODUTO"       ,oFont11c,,,,,) 
oPrint:Say (li,0400,"DESCRIÇÃO"     ,oFont11c,,,,,) 
oPrint:Say (li,1200,"UM LOTE"       ,oFont11c,,,,,) 
oPrint:Say (li,1570,"VALIDADE"      ,oFont11c,,,,,) 
oPrint:Say (li,1850,"QUANTIDADE",oFont11c,,,,,)
oPrint:Say (li,2150,"NFISCAL",oFont11c,,,,,) 
li:= li+40
oPrint:Line(li,00,li,nColMax) //1 Linha horizontal       
li:= li+30
Return(li)	

Static Function SB_IMP_MSG(li)

If (li+300) > nLinMax
   li:= IMP_RODAPE(li)	  
   oPrint:EndPage()  
   nPag:=nPag+ 1
   li:= IMP_CABEC(ncw,nPag)
Endif   
li := li + 150 
oPrint:say(li,200, "FAVOR SEPARAR OS PRODUTOS CONFORME NÚMEROS DE LOTE E DATAS DE VALIDADE", oFont11c)
li := li + 100 
oPrint:say(li, 050, "CASO ENCONTRE DIVERGENCIA ENTRE FISICO E PICKLIST POR FAVOR ENTRAR EM CONTATO COM O FATURAMENTO.", oFont11c)          
nPri    := 0 
li := li + 200  
cMENNOTA := UPPER(ALLTRIM(cMENNOTA)+"/"+ALLTRIM(cMENFOR))
nReg := INT(LEN(ALLTRIM(cMENNOTA))/80)+1
For nPri := 1 TO nReg
oPrint:say(li, 200, SUBSTR(cMENNOTA,(nPri*80)-79,80), oFont11c)          
   li := li + 50
Next nI    

Return (li)
//===============================================================================================================
Static Function IMP_RODAPE(li)
//===============================================================================================================
nLinMax := nLinMax + 30
oPrint:Line(nLinMax,00 ,nLinMax,nColMax) 
oPrint:say (nLinMax,00 ,"Relatório: " ,  oFont6n)
oPrint:say (nLinMax,110,"SB_PCK/PCS", oFont6) 
oPrint:say (nLinMax,500,"Registros Impressos: " +ALLTRIM(str(nTotImp)) + " / Total de Registros Impressos: " + ALLTRIM(str(nTotLido)), oFont6n) 
oPrint:EndPage()       
nLinMax := 2350
Return .T.

//===============================================================================================================
Static Function CRIA_PERGUNTA()             
//===============================================================================================================
Local aHelp := {}  
dbSelectArea("SX1")
dbSetOrder(1)

AAdd( aHelp, {{"Informe o Pedido (de)              " },{""},{""}})
AAdd( aHelp, {{"Informe o Pedido (até)             " },{""},{""}})   

PutSx1(cPerg, "01", "Número do Pedido (de)?   " ,"","","mv_ch1","C",06,00,00,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelp[1,1],aHelp[1,2],aHelp[1,3],"")
PutSx1(cPerg, "02", "Número do Pedido (até)?  " ,"","","mv_ch2","C",06,00,00,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelp[2,1],aHelp[2,2],aHelp[2,3],"")
Return()
