#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Rwmake.ch" 
#INCLUDE "DEFEMPSB.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.  ³ M460FIM º Uso ³ Surya Brasil º Modulo ³ SIGAFAT º Data ³ 08/07/17 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³ PE pegar volume do pedido de venda apos IBEX enviar o mesmo		  º±±
±±º       ³                                                                   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor ³ Caio de Paula             º Contato ³(11) 98346-3154              º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460FIM()
Local aArea   	:= GetArea()
Local aAreaSE1 	:= SE1->(GetArea())
Local _cForma1	:= ""
Local nFrete	:= SC5->C5_FRETE
Local cTpFrete	:= SC5->C5_TPFRETE
Local cForma	:= ""
Local lVP		:= .f.
Local cCodVP	:= ""
Local lMagento	:= .F.
Local cPedido	:= SD2->D2_PEDIDO
Local cProd		:= SD2->D2_COD
Local lEspecie	:= SF2->F2_ESPECIE == "SPED"
LOcal aDadBCO	:= {}
Local nValor	:= 0
Local cBanco	:= ""
Local cAgencia	:= ""
Local cConta	:= ""
local cEmpresa	:= cEmpAnt 
Local cVale		:= ""
Local cChvBCO	:= alltrim(SuperGetMv("SB_CHVA6BO",.F.,"03307029999999"))
Local cChave 	:= xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC
Local cCond		:= SF2->F2_COND
Local nX		:= 0
//XFILIAL('SA6')+'237'+SPACE(TAMSX3('A6_COD')[1]-LEN('237'))+'0502'+SPACE(TAMSX3('A6_AGENCIA')[1]-LEN('0502'))+'75898'+SPACE(TAMSX3('A6_NUMCON')[1]-LEN('75898'))                                                                                           

IF cEmpresa == FC
	SC5->(RecLock("SC5",.F.))
	SC5->C5_XSTATUS	:= "3"
	SC5->C5_XDESCST := "Pedido de Venda Faturado"
	if empty(SC5->C5_NOTA) .AND. EMPTY(SC5->C5_SERIE) // Liberamento Parcial
			SC5->C5_NOTA 	:= SF2->F2_DOC
			SC5->C5_SERIE	:= SF2->F2_SERIE
	ENDIF
	SC5->(MsUnLock())
	//lVP			:= !Empty(Alltrim(SC5->C5_XVALEP))
	//cCodVP		:= Alltrim(SC5->C5_XVALEP)
	cForma		:= SC5->C5_XDCNDPG
	_cForma1	:= SC5->C5_XFORMA	
	lMagento	:= !Empty(Alltrim(SC5->C5_XMAGCOD))	
	cVale		:= alltrim(SuperGetMv("FC_CODVP",.F.,"VALEPRESENTE"))
	cBanco		:= substr(cChvBCO,1,3)
	cAgencia	:= substr(cChvBCO,4,TAMSX3('A6_AGENCIA')[1])
	cConta		:= ALLTRIM(substr(cChvBCO,TAMSX3('A6_AGENCIA')[1]+TAMSX3('A6_COD')[1]+1))
	IF cTpFrete == "F"
		// FUNCAO para reajustar frete no valor total do titulo
		aFrete		:= condicao(AjFrete(SF2->F2_DOC, SF2->F2_SERIE, nFrete,cTpFrete),cCond)
	ENDIF
	
	dbSelectArea("SE1")
	dbSetOrder(2)
	_cParcelaE1 := ""
	if dbSeek(cChave)
		While !Eof() .And. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == cChave 
			_cParcelaE1 += SE1->E1_PARCELA
			nX ++
			If SE1->E1_TIPO <> "NF "
				dbSkip()
				Loop
			EndIf
			IF cTpFrete == "F"
				nValor := aFrete[nX][2]
			endif
			RecLock("SE1",.F.)	
				SE1->E1_XIMPBOL := '2' 
				SE1->E1_XFORMA  := _cForma1
				if lMagento .And. cTpFrete == "F"
					SE1->E1_VALOR	:= 	nValor
					SE1->E1_SALDO	:= SE1->E1_VALOR
					SE1->E1_VLCRUZ	:= SE1->E1_VALOR	
				endif		   
			MsUnlock() 
			
			if lMagento
				aDadBCO := {SE1->E1_PREFIXO,; //1
								SE1->E1_NUM,;
								SE1->E1_PARCELA,;
								SE1->E1_TIPO,;
								cBanco,; //5
								cAgencia,;
								cConta,;
								SE1->E1_SALDO,;
								"ECO",; //MOTIVO DE BAIXA
								cForma,; //10
								SE1->E1_VENCREA,;
								SE1->E1_NATUREZ}	
				//u_EXEC070(aDadBCO) // baixa
				//U_EXEC040E(aDadBCO)		//Inclusao	
			endif	
			SE1->(dbSkip())
		EndDo
	endif*/
	/*if lMagento
		u_IncVP(cPedido)
		if lVP
			U_PagVP(SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_SERIE,SF2->F2_DOC,cCodVP)
		endif
	Endif*/
Endif

RestaRea(aAreaSE1)
RestArea(aArea)
Return


//************************************** AJUSTA FRETE
Static Function AjFrete(cDoc, cSerie, nFrete,cTpFrete)
Local nSaldo	:= 0
Local cTes		:= ""

if cTpFrete == "F"
	DbSelectArea("SD2")
	DbSetOrder(3)
	if DbSeek(xFilial("SD2")+cDoc+cSerie)
		Do While !SD2->(EOF()) .And. SD2->D2_DOC == cDoc .And. SD2->D2_SERIE== cSerie
			cTes := Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_DUPLIC")
			if cTes == "S"
				nSaldo	+= SD2->D2_TOTAL
			Endif		
			SD2->(dbskip())
		Enddo
		nSaldo := nSaldo + nFrete
	endif	
Endif
Return nSaldo

//**************************************
//
//INCLUI VALE PRESENTE
User Function IncVP(cPedido)
Local cVale		:= alltrim(SuperGetMv("FC_CODVP",.F.,"VALEPRESENTE"))
Local nValor	:= 0
DbSelectArea("SC6")
DbSetOrder(1)
if DbSeek(xFilial("SC6")+cPedido)
	Do While !SC6->(EOF()) .And. SC6->C6_NUM = cPedido
		if SC6->C6_PRODUTO == cVale
			U_IncMDD(cCodigo, nValor, dDtIni, dDtFim)
		Endif
		SC6->(dbskip())
	Enddo
endif
Return 

//**************************************
//
//BAIXA TITULO
User Function EXEC070(aDadBco) 
Local aBaixa := {}
Private lMsErroAuto := .F. 
aBaixa := {{"E1_PREFIXO"  ,aDadBco[1]             ,Nil    },;
           {"E1_NUM"      ,aDadBco[2]             ,Nil    },;
           {"E1_PARCELA"  ,aDadBco[3]             ,Nil    },;
           {"E1_TIPO"     ,"NF"            		  ,Nil    },;
           {"AUTMOTBX"    ,aDadBco[9]             ,Nil    },;
           {"AUTBANCO"    ,aDadBco[5]             ,Nil    },;
           {"AUTAGENCIA"  ,aDadBco[6]             ,Nil    },;
           {"AUTCONTA"    ,aDadBco[7]             ,Nil    },;
           {"AUTDTBAIXA"  ,dDataBase              ,Nil    },;
           {"AUTDTCREDITO",dDataBase              ,Nil    },;
           {"AUTHIST"     ,"Baixa Automatica Ecom",Nil    },;
           {"AUTJUROS"    ,0                      ,Nil,.T.},;
           {"AUTVALREC"   ,aDadBco[8]                    ,Nil    }}
 
MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3) 
IF lMsErroAuto
	DisarmTransaction()
	conout("ERRO - ECOMM-FIN, Fina070")
    Break
Endif
 
Return
//**************************************
//
//INCLUI VALE-PRESENTE
User Function IncMDD(cCodigo, nValor, dDtIni, dDtFim)
Local cVale		:= alltrim(SuperGetMv("FC_CODVP",.F.,"VALEPRESENTE"))
DbSelectArea("MDD")
DbSetOrder(1)
If DbSeek(xFilial("MDD")+cCodigo)
	MsgAlert("Vale-Presente ja utilizado, nao será inserido!")
Else
	Reclock("MDD",.T.)
		MDD->MDD_CODIGO	:= cCodigo
		MDD->MDD_PROD	:= cVale
		MDD->MDD_LOJA	:= "000001"
		MDD->MDD_VALOR	:= nValor
		MDD->MDD_DTINI	:= dDtIni
		MDD->MDD_DTFIM	:= dDtFim
		MDD->MDD_Status	:= "1"
	MsUnlock()
Endif
Return



USER FUNCTION EXEC040E(aDadBCO)
LOCAL aArray := {}
Local cCliente	:= SuperGetMV("FC_CLIEC",.F.,"011241")
Local dDataVenc := CTOD("  /  /  ")

if substr(aDadBCO[10],6,2) == "CC"
	dDataVenc	:= SumDay(aDadBCO[11],Posicione("SAE",1,xFilial("SAE")+"010","AE_DIAS"))
	dDataVenc	:= DataValida(dDataVenc,.T.)
elseif substr(aDadBCO[10],6,2) == "BL"
	dDataVenc	:= SumDay(aDadBCO[11],Posicione("SAE",1,xFilial("SAE")+"011","AE_DIAS"))
	dDataVenc	:= DataValida(dDataVenc,.T.)
elseif substr(aDadBCO[10],6,2) == "DP"
	dDataVenc	:= SumDay(aDadBCO[11],Posicione("SAE",1,xFilial("SAE")+"012","AE_DIAS"))
	dDataVenc	:= DataValida(dDataVenc,.T.)
elseif substr(aDadBCO[10],6,2) == "TF"
	dDataVenc	:= SumDay(aDadBCO[11],Posicione("SAE",1,xFilial("SAE")+"013","AE_DIAS"))
	dDataVenc	:= DataValida(dDataVenc,.T.)
endif


PRIVATE lMsErroAuto := .F.
 
aArray := { { "E1_PREFIXO"  , "AUT"             , NIL },;
            { "E1_NUM"      , aDadBCO[2]        , NIL },;
            { "E1_PARCELA"  , aDadBCO[3]        , NIL },;
            { "E1_NATUREZ"  , aDadBCO[12]       , NIL },;
            { "E1_CLIENTE"  , cCliente          , NIL },;
            { "E1_TIPO"  	, aDadBCO[4]        , NIL },;
            { "E1_EMISSAO"  , dDatabase, NIL },;
            { "E1_VENCTO"   , dDataVenc, NIL },;
            { "E1_VENCREA"  , dDataVenc, NIL },;
            { "E1_ORIGEM"  , "MATA460", NIL },;
            { "E1_VALOR"    , aDadBCO[8]              , NIL } }
 
MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
 
 
If lMsErroAuto
    DisarmTransaction()
	conout("ERRO - ECOMM-FIN, Fina040")
    Break    
else
	U_EXE040EA(aDadBCO)
Endif
 
Return


USER FUNCTION EXE040EA(aDadBCO)
LOCAL aArray := {}
Local cCliente		:= SuperGetMV("FC_CLIEC",.F.,"011241")
Local nTx,NvALOR			:= 0
Local cNaturez		:= SuperGetMV("FC_NATAB",.F.,"5.01.003")
PRIVATE lMsErroAuto := .F.
if substr(aDadBCO[10],6,2) == "CC"
	nTx	:= Posicione("SAE",1,xFilial("SAE")+"010","AE_TAXA")
	NvALOR	:= aDadBCO[8]*(nTx/100)
elseif substr(aDadBCO[10],6,2) == "BL"
	nTx	:= Posicione("SAE",1,xFilial("SAE")+"011","AE_TAXA")
	NvALOR	:= aDadBCO[8]*(nTx/100)
elseif substr(aDadBCO[10],6,2) == "DP"
	nTx	:= Posicione("SAE",1,xFilial("SAE")+"012","AE_TAXA")
	NvALOR	:= aDadBCO[8]*(nTx/100)
elseif substr(aDadBCO[10],6,2) == "TF"
	nTx	:= Posicione("SAE",1,xFilial("SAE")+"013","AE_TAXA")
	NvALOR	:= aDadBCO[8]*(nTx/100)
endif
 
aArray := { { "E1_PREFIXO"  , "AUT"             , NIL },;
            { "E1_NUM"      , aDadBCO[2]        , NIL },;
            { "E1_PARCELA"  , aDadBCO[3]        , NIL },;
            { "E1_NATUREZ"  , cNaturez       	, NIL },;
            { "E1_TIPO"  	, "AB-"        		, NIL },;
            { "E1_VALOR"	, NvALOR		, nil },;
            { "E1_SALDO"	, NvALOR		, nil },;
            { "E1_VLCRUZ"   , NvALOR       , NIL } }
 
MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
 
 
If lMsErroAuto
    DisarmTransaction()
	conout("ERRO - ECOMM-FIN, Fina040")
    Break
Endif
 
Return

User Function PagVP(cCliente,cLoja,cSerie,cDoc,cCodVP)
Local cValVP	:= 0
Local dDtFim	:= CTOD("  /  /  ")
Local aRecNF	:= {}
Local aRecVP	:= {}
local lContinua:= .T.
dbSelectArea("MDD")
dbSetOrder(1)
If dbSeek(xFilial("MDD"+cCodVP))
	cValVP	:= MDD->MDD_VALOR
	dDtFim	:= MDD->MDD_DTFIM
else
	msgAlert("Vale-Presente do pedido nao foi utilizado. Verificar!")
	Return 
Endif
if dDtFim < dDatabase
	msgAlert("Vale-Presente fora da vigencia ou inativa. Nao Utilizado")
	Return 
Endif
PRIVATE lMsErroAuto := .F.
 
aArray := { { "E1_PREFIXO"  , "CVP"             	 , NIL },;
            { "E1_NUM"      , Replicate("0",9-len(cCodVP))+cCodVP , NIL },;
            { "E1_NATUREZ"  , aDadBCO[12]       , NIL },;
            { "E1_CLIENTE"  , cCliente          , NIL },;
            { "E1_TIPO"  	, "NCC"        , NIL },;
            { "E1_EMISSAO"  , dDatabase, NIL },;
            { "E1_VENCTO"   , dDataVenc, NIL },;
            { "E1_VENCREA"  , dDataVenc, NIL },;
            { "E1_ORIGEM"   , "M460FIM", NIL },;
            { "E1_VALOR"    , cValVP            , NIL } }
 
MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
 
 
If lMsErroAuto
    DisarmTransaction()
	conout("ERRO - ECOMM-FIN, Fina040")
	lContinua	:= .F.
    Break
else
	aRecVP	:= {SE1->(RECNO())}
Endif

if lContinua
	dbSelectArea("SE1")
	dbSetOrder(2)
	cChave := xFilial("SE1")+cCliente+cLoja +"AUT" + cDoc
	_cParcelaE1 := ""
	if dbSeek(cChave)
		While !Eof() .And. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == cChave
			if SE1->E1_TIPO <> 'NF'
				SE1->(dbSkip())
				loop
			endif
			aRecNF	:= {SE1->(RECNO())}
			SE1->(dbSkip())
		EndDo
	Endif
	
	If !MaIntBxCR(3,aRecNF,,aRecVP,,{ .F.,.F.,.F.,.F.,.F.,.F.},,,,,dDatabase )
		Help("XAFCMPAD",1,"HELP","XAFCMPAD","Não foi possível a compensação"+CRLF+" do titulo do adiantamento",1,0)
	ENDIF
Endif
Return