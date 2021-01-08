#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.  ³BOLETBRA º Uso ³ Surya Brasil º Modulo ³ SIGAFAT º Data ³ 08/02/18 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³ IMPRESSAO DO BOLETO JUNTO COM A IMPRESSAO DA DANFE	        	  º±±
±±º       ³                                                                   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor ³ Caio de Paula             º Contato ³(11) 98346-3154              º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

User Function BOLETBRA(lDanfe, aParam,oDanfe)
//
LOCAL   nOpc := 0
PRIVATE Exec    := .F.
//
cPerg     :="BOLETOBCO" 
DbselectArea("SE1")
DbSetOrder(1)
Processa({|lEnd|MontaRel(aParam,oDanfe,lDanfe)})                   
Return()
/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??un?o    ?ontaRel()   ?escri?o?ontagem e Impressao de boleto Gra- ??
??         ?            ?        ?ico do Banco. 		              ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
Static Function MontaRel(aParam,oDanfe,LDANFE)
LOCAL   oPrint
LOCAL   n := 0
LOCAL aBitmap := "BANCO.BMP"
lOCAL c_ChvA6	:= SuperGetMV("SB_CHVA6BO",.t.,'')  //parametro com o banco utilizado
LOCAL aDadosEmp    := {	AllTrim(SM0->M0_NOMECOM)                            ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                                              ,; //[2]Endere?
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                    ,; //[5]Telefones
"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
Subs(SM0->M0_CGC,13,2)                                                     ,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco  := {}
LOCAL aDatSacado
LOCAL aBolText     := {"",;
"Mora ao dia de 0.1% "                                   ,;
"Apos o vencimento cobrar multa de 2% "} //"Sujeito a Protesto apos 05 (cinco) dias do vencimento"}

// "Ap? o vencimento cobrar multa de R$ "

LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0
LOCAL cParcela	   := ""
LOCAL lSubs		   := .F.
LOCAL aArea		   := GetArea()


//oPrint:= TMSPrinter():New( "Boleto Laser" )
//oPrint:SetPortrait() // ou SetLandscape()
//oPrint:StartPage()   // Inicia uma nova p?ina 


// aDadosBanco Carregados Previamente antes do laco
// [1]Numero do Banco
// [2]Nome do Banco
// [3]Ag?cia
// [4]Conta Corrente
// [5]D?ito da conta corrente
// [6]Codigo da Carteira

//Carrega o ultimo banco selecionado 
if lDanfe
	DbSelectArea("SA6")
	DbSetOrder(1)
	MsSeek(&c_ChvA6)
	If Found() 	
			AADD( aDadosBanco,SA6->A6_COD )// [1]
			AADD( aDadosBanco,SA6->A6_NREDUZ)  //[2]  //A6_NOME completo //A6_NREDUZ reduzido
			AADD( aDadosBanco,SA6->A6_AGENCIA) // [3] 
			AADD( aDadosBanco,SA6->A6_NUMCON )// [4]	
			AADD( aDadosBanco,SA6->A6_DVCTA )// [5]    
	   		AADD( aDadosBanco,"09" )// [6]    
	   		AADD( aDadosBanco,"09" )// [7]   // Bradesco usa carteira com 2 digitos entao, pego os 2 primeiros, tiro os espacos, transformo e valor e adiciono 0 a esquerda se precisar
	    	lSubs:= .T.
	Else
		MsgAlert("Nao foi selecionado nenhum banco para operacao com boletos!","Atencao!")
		Return
	EndIf
endif
//
RestArea(aArea)
// 
DBSEEK(xFilial("SE1")+aParam[1]+aParam[2]) 
Do While !EOF() .and. E1_PREFIXO+Alltrim(E1_NUM) >= aParam[1]+Alltrim(aParam[2]) .and. E1_PREFIXO+Alltrim(E1_NUM) <= aParam[1]+Alltrim(aParam[3])
	oDanfe:StartPage()

	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)	
	//
	If Empty(SA1->A1_ENDCOB) 
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;     // [1]Raz? Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     // [2]C?igo
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;     // [3]Endere?
		AllTrim(SA1->A1_MUN )                             ,;     // [4]Cidade
		SA1->A1_EST                                       ,;     // [5]Estado
		SA1->A1_CEP                                       ,;     // [6]CEP
		SA1->A1_CGC									  	  ,;     // [7]CGC
		IIF(SA1->(FieldPos("A1_BLEMAIL"))<>0,SA1->A1_BLEMAIL,""),;  // [8]BOLETO por EMAIL
		Alltrim(SA1->A1_EMAIL)						  	  }      // [9]EMAIL
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)              ,;   // [1]Raz? Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]C?igo
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endere?
		AllTrim(SA1->A1_MUNC)	                              ,;   // [4]Cidade
		SA1->A1_ESTC	                                      ,;   // [5]Estado
		SA1->A1_CEPC                                         ,;   // [6]CEP
		SA1->A1_CGC									  	  ,;     // [7]CGC
		IIF(SA1->(FieldPos("A1_BLEMAIL"))<>0,SA1->A1_BLEMAIL,""),;  // [8]BOLETO por EMAIL
		Alltrim(SA1->A1_EMAIL)						  	  }      // [9]EMAIL
	Endif

	DbSelectArea("SE1")

	If E1_PARCELA < aParam[4]
		
		DBSKIP()
		LOOP
	ENDIF
	//
	If E1_PARCELA > aParam[5]    

		DBSKIP()
		LOOP
	ENDIF
	//
	If Alltrim(E1_TIPO) <> 'NF' .AND. Alltrim(E1_TIPO) <> 'FT' .AND. Alltrim(E1_TIPO) <> 'DP' 
	
	
		DBSKIP()
		LOOP
	ENDIF
	//
  //	IF SE1->E1_SALDO <= 0                                                                                             

//		DBSKIP()
 //		LOOP
 //	ENDIF
	//
	//IF  SE1->(FieldPos("E1_IMPBOL"))<> 0 .And. SE1->E1_IMPBOL == "S" .And. !lSubs   

	//	DBSKIP()
	//	LOOP
	//ENDIF
	IF !EMPTY(E1_NUMBCO) .And. !EMPTY(E1_PORTADO)  
		//If E1_IMPBOL == "S" .AND. SUBSTR(ALLTRIM(E1_PORTADO),1,3) <> aDadosBanco[1]

		//	DBSKIP()
		//	LOOP
   		//EndIf
	ENDIF
	//
	//Posiciona o SA6 (Bancos)
	if !lDanfe
		DbSelectArea("SA6")
		DbSetOrder(1)
		DbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
		If Found()				
			AADD( aDadosBanco,SA6->A6_COD )// [1]
			AADD( aDadosBanco,SA6->A6_NREDUZ)  //[2]  //A6_NOME completo //A6_NREDUZ reduzido
			AADD( aDadosBanco,SA6->A6_AGENCIA) // [3] 
			AADD( aDadosBanco,SA6->A6_NUMCON )// [4]	
			AADD( aDadosBanco,SA6->A6_DVCTA )// [5]    
	   		AADD( aDadosBanco,"09" )// [6]    
	   		AADD( aDadosBanco,"09" )// [7]   // Bradesco usa carteira com 2 digitos entao, pego os 2 primeiros, tiro os espacos, transformo e valor e adiciono 0 a esquerda se precisar
	    	lSubs:= .T.
		Else
			MsgAlert("Nao foi selecionado nenhum banco para operacao com boletos!","Atencao!")
			Return
		EndIf
	endif
	//
	If  Subs(Trim(SE1->E1_PARCELA),1,1) == "P" 
		cParcela:= StrZero(Val(Subs(Trim(SE1->E1_PARCELA),2,3)), 2 )
	Else
		If Empty(SE1->E1_PARCELA) 
			cParcela:= "00"
		Else
			cParcela:= StrZero(Val(Trim(SE1->E1_PARCELA)),2)		
		EndIf
	EndIf
	//
	//
	DbSelectArea("SE1")
	_cNossoNum := strzero(Val(Alltrim(SE1->E1_NUM)),9) + cParcela //Composicao Filial + Titulo + Parcela
		
	//If aMarked[i]
	_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	
	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",Subs(aDadosBanco[3],1,4),aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(SE1->E1_SALDO - _nVlrAbat),Datavalida(SE1->E1_VENCTO,.T.),aDadosBanco[6])
	
	aDadosTit   := {SE1->E1_NUM+cParcela						,;  // [1] N?ero do t?ulo
	E1_EMISSAO                              					,;  // [2] Data da emiss? do t?ulo
	ArrumaAno(Date())                   				     	,;  // [3] Data da emiss? do boleto
	ArrumaAno(E1_VENCREA)      	 								,;  // [4] Data do vencimento
	(E1_SALDO - _nVlrAbat)                  					,;  // [5] Valor do t?ulo
	CB_RN_NN[3]		                         					,;  // [6] Nosso n?ero (Ver f?mula para calculo)
	E1_PREFIXO                               					,;  // [7] Prefixo da NF
	"DM"	                               						}   // [8] Tipo do Titulo
	//
	 
	Impress(oDanfe,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,aParam)
	n := n + 1
	//EndIf

	
	dbSkip()
	IncProc()
	i := i + 1 
	oDanfe:Endpage()
EndDo

Return nil
//
/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??un?o    ?mpress      ?escri?o?mpressao de Boleto Grafico do Banco??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
Static Function Impress(oDanfe,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,aParam)
LOCAL _nTxper := GETMV("MV_TXPER")
LOCAL nDacNN  
LOCAL oFont2n
LOCAL oFont8
LOCAL oFont9
LOCAL oFont10
LOCAL oFont15n
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL i := 0
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2080,1900,2180,2300}     // 2000 - 2100
LOCAL aCoords7 := {2350,1900,2420,2300}     // 2270 - 2340
LOCAL aCoords8 := {2700,1900,2770,2300}     // 2620 - 2690
LOCAL oBrush
//

If Valtype(aBitmap) == "C" .And. Len(aBitmap) > 0
	aBmp:= aBitMap
Else
	aBmp := "BANCO.BMP"
EndIf
aBmp2 	:= "BANCO.BMP"
//
//Par?etros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
//
oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
//
oBrush := TBrush():New("",5)//4
//
//oDanfe:StartPage()   // Inicia uma nova p?ina

// LOGOTIPO     
If File(aBmp2) .And. aDatSacado[8] <> "1"
//	oDanfe:SayBitmap( 0040,0100,alltrim(aDadosBanco[1])+aBmp2,0300,0100 )
	oDanfe:SayBitmap( 001,002,aBmp2,080,020 )
//	oDanfe:Say  (0084,200,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
Else
	oDanfe:Say  (001,002,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
EndIf
//          
                           


cAgCC := LEFT(aDadosBanco[3],4)
cAgCC += "-9" 

oDanfe:Say  (015,480,"Comprovante de Entrega",oFont10)  


oDanfe:Say  (029,002 ,"Beneficiário"                                        	,oFont8)
oDanfe:Say  (038,002 ,aDadosEmp[1]                                 		,oFont10) //Nome + CNPJ
oDanfe:Say  (029,271,"Agencia/Codigo Beneficiário"                         	,oFont8)
oDanfe:Say  (038,271,cAgCC+"/0000"+aDadosBanco[4]+"-"+aDadosBanco[5]  	,oFont10)
oDanfe:Say  (029,381,"Nro.Documento"                                  	,oFont8)
oDanfe:Say  (038,381,aDadosTit[1]		         						,oFont10) //Numero+Parcela

oDanfe:Say  (047,002 ,"Pagador"                                         		,oFont8)
oDanfe:Say  (056,002 ,aDatSacado[1]                                    		,oFont10)	//Nome
oDanfe:Say  (047,271,"Vencimento"                                      		,oFont8)
oDanfe:Say  (056,271,aDadosTit[4]			                           		,oFont10)
oDanfe:Say  (047,381,"Valor do Documento"                          	   		,oFont8)
oDanfe:Say  (056,400,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99"))	,oFont10)

oDanfe:Say  (070,002,"Recebi(emos) o bloqueto/titulo"                 ,oFont10)
oDanfe:Say  (080,002,"com as caracteristicas acima."             		,oFont10)
oDanfe:Say  (067,271,"Data"                                           ,oFont8)
oDanfe:Say  (067,351,"Assinatura"                                 	,oFont8)
oDanfe:Say  (087,271,"Data"                                           ,oFont8)
oDanfe:Say  (087,351,"Entregador"                                 	,oFont8)
//Linhas Horizontal  
oDanfe:Line (022,002,022,600) 
oDanfe:Line (040,002,040,480)
oDanfe:Line (060,002,060,480)
oDanfe:Line (080,270,080,480)
oDanfe:Line (100,002,100,600)
//Linhas   Vertical
oDanfe:Line (022,270,100,270)
oDanfe:Line (060,350,100,350)
oDanfe:Line (022,380,060,380)
oDanfe:Line (022,480,100,480)         


//
oDanfe:Say  (030,482,"(  ) Mudou-se"                                	,oFont8)
oDanfe:Say  (038,482,"(  ) Ausente"                                   ,oFont8)
oDanfe:Say  (046,482,"(  ) Nao existe nao indicado"                  	,oFont8)
oDanfe:Say  (054,482,"(  ) Recusado"                                	,oFont8)
oDanfe:Say  (062,482,"(  ) Nao procurado"                             ,oFont8)
oDanfe:Say  (070,482,"(  ) Endereco insuficiente"                  	,oFont8)
oDanfe:Say  (078,482,"(  ) Desconhecido"                            	,oFont8)
oDanfe:Say  (086,482,"(  ) Falecido"                                  ,oFont8)
oDanfe:Say  (094,482,"(  ) Outros(anotar no verso)"                  	,oFont8)
//
For i := 2 to 600 step 20
	oDanfe:Line( 110, i, 110, i+15)
Next i   


//


// LOGOTIPO
If File(alltrim(aDadosBanco[1])+aBmp).And. aDatSacado[8] <> "1"
	oDanfe:SayBitmap( 132,002,alltrim(aDadosBanco[1])+aBmp,002,002 )
//	Fonte 10 suporta somente 16 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
	Do Case
	Case Len(aDadosBanco[2]) < 17
 		oDanfe:Say  (132,002,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
	Case Len(aDadosBanco[2]) < 19
		oDanfe:Say  (132,002,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
	OtherWise	
		oDanfe:Say  (132,002,aDadosBanco[2],oFont8 )	// [2]Nome do Banco
	EndCase	
Else
//	Fonte 15 suporta somente 12 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
	Do Case
	Case Len(aDadosBanco[2]) < 13
		oDanfe:Say  (132,002,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
	Case Len(aDadosBanco[2]) < 17
		oDanfe:Say  (132,002,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
	OtherWise
		If Len(aDadosBanco[2]) > 25	
			oDanfe:Say  (132,002,Subs(aDadosBanco[2],1,25),oFont9 )	// [2]Nome do Banco 
		Else
	   		oDanfe:Say  (132,002,aDadosBanco[2],oFont9 )	// [2]Nome do Banco 
		EndIf
	EndCase	
EndIf
//
oDanfe:Say  (133,122,aDadosBanco[1]+"-2",oFont24 )	// [1]Numero do Banco
oDanfe:Say  (133,180,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
//   

//Segunda parte do boleto
//linhas horizontais      
oDanfe:Line (140,002,140,600)
oDanfe:Line (165,002,165,600 )
oDanfe:Line (190,002,190,600 )
oDanfe:Line (206,002,206,600 )
oDanfe:Line (222,002,222,600 )
oDanfe:Line (238,480,238,600 )
oDanfe:Line (254,480,254,600 )
oDanfe:Line (270,480,270,600 )
oDanfe:Line (286,480,286,600 ) 
oDanfe:Line (302,002,302,600 )
oDanfe:Line (355,002,355,600 )
   

//   linhas verticais
oDanfe:Line (140,120,113, 120)
oDanfe:Line (140,175,113, 175) 
oDanfe:Line (190,110,222,110)
oDanfe:Line (206,180,222,180)
oDanfe:Line (190,250,222,250)
oDanfe:Line (190,300,206,300)
oDanfe:Line (190,350,222,350)
oDanfe:Line (140,480,302,480) 


//
oDanfe:Say  (147,002 ,"Local de Pagamento"                             					,oFont8)
oDanfe:Say  (152,080 ,"Pagavel em qualquer Banco ate o Vencimento."        		   		,oFont9)
oDanfe:Say  (161,080 ,"Apos o Vencimento pague somente no "+Alltrim(aDadosBanco[2])+"."   ,oFont9) //Nome do banco  
//
oDanfe:Say  (147,482,"Vencimento"                                     ,oFont8)
oDanfe:Say  (157,500,aDadosTit[4]                               ,oFont10)      
//
oDanfe:Say  (172,002 ,"Beneficiário"                                        ,oFont8)
oDanfe:Say  (182,002 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
//
oDanfe:Say  (172,482,"Agencia/Codigo Beneficiário"                         ,oFont8)
oDanfe:Say  (182,500,cAgCC+"/0000"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)


//
oDanfe:Say  (197,002 ,"Data do Documento"                              ,oFont8)
oDanfe:Say  (206,002 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
//
oDanfe:Say  (197,112 ,"Nro.Documento"                                  ,oFont8)
oDanfe:Say  (206,120 ,aDadosTit[1]										,oFont10) //Numero+Parcela
//
oDanfe:Say  (197,252,"Especie Doc."                                   ,oFont8)
oDanfe:Say  (206,260,aDadosTit[8]										,oFont10) //Tipo do Titulo
//
oDanfe:Say  (197,302,"Aceite"                                         ,oFont8)
oDanfe:Say  (206,325,"N"                                             ,oFont10)
//
oDanfe:Say  (197,352,"Data do Processamento"                          ,oFont8)
oDanfe:Say  (206,365,aDadosTit[3]                               ,oFont10) // Data impressao         
//
nDacNN:= DACNN(aDadosBanco[6]+aDadosTit[6])
nDacNN:= IIF(ValType(nDacNN) == "N",Alltrim(Str(nDacNN)),nDacNN)
oDanfe:Say  (197,482,"Carteira/Nosso Numero"                                   ,oFont8)
oDanfe:Say  (206,500,aDadosBanco[7]+"/"+aDadosTit[6]+"-"+Alltrim( nDacNN )	,oFont10)  
    



//
oDanfe:Say  (213,002 ,"Uso do Banco"                                   ,oFont8)
//
oDanfe:Say  (213,112 ,"Carteira"                                       ,oFont8)
oDanfe:Say  (221,135 ,aDadosBanco[7]                                  	,oFont10)
//
oDanfe:Say  (213,182 ,"Especie"                                        ,oFont8)
oDanfe:Say  (221,200 ,"R$"                                             ,oFont10)
//
oDanfe:Say  (213,252,"Quantidade"                                     ,oFont8)
oDanfe:Say  (213,352,"Valor"                                          ,oFont8)
//
oDanfe:Say  (213,482,"Valor do Documento"                          	,oFont8)
oDanfe:Say  (221,500,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)        
//
oDanfe:Say  (229,002 ,"Instrucoes (Todas informacoes deste bloqueto sao de exclusiva responsabilidade do Beneficiário)",oFont8)
oDanfe:Say  (250,002 ,aBolText[2],oFont10)
oDanfe:Say  (260,002 ,aBolText[3],oFont10)    


//
oDanfe:Say  (229,482,"(-)Desconto/Abatimento"                         ,oFont8)
oDanfe:Say  (245,482,"(-)Outras Deducoes"                             ,oFont8)
oDanfe:Say  (261,482,"(+)Mora/Multa"                                  ,oFont8)
oDanfe:Say  (277,482,"(+)Outros Acrescimos"                           ,oFont8)
oDanfe:Say  (293,482,"(=)Valor Cobrado"                               ,oFont8)
//
oDanfe:Say  (309,002 ,"Pagador"                                         ,oFont8)
oDanfe:Say  (315,100 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oDanfe:Say  (325,100 ,aDatSacado[3]                                    ,oFont10)
oDanfe:Say  (335,100 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
if Len(Alltrim(aDatSacado[7])) == 14
	oDanfe:Say  (345,100 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
else
	oDanfe:Say  (345,100 ,"C.P.F.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF
endif
oDanfe:Say  (345,490,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)
//
oDanfe:Say  (349,002 ,"Pagador/Avalista"                               ,oFont8)
oDanfe:Say  (362,350,"Autenticacao Mecanica -"                        ,oFont8)
oDanfe:Say  (362,482,"Recibo do Pagador"								,oFont10)             





// terceira Parte do boleto
For i := 2 to 600 step 20
	oDanfe:Line( 465, i, 465, i+15)
Next i   


//


// LOGOTIPO
If File(alltrim(aDadosBanco[1])+aBmp).And. aDatSacado[8] <> "1"
	oDanfe:SayBitmap( 487,002,alltrim(aDadosBanco[1])+aBmp,002,002 )
//	Fonte 10 suporta somente 16 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
	Do Case
	Case Len(aDadosBanco[2]) < 17
 		oDanfe:Say  (487,002,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
	Case Len(aDadosBanco[2]) < 19
		oDanfe:Say  (487,002,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
	OtherWise	
		oDanfe:Say  (487,002,aDadosBanco[2],oFont8 )	// [2]Nome do Banco
	EndCase	
Else
//	Fonte 15 suporta somente 12 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
	Do Case
	Case Len(aDadosBanco[2]) < 13
		oDanfe:Say  (487,002,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
	Case Len(aDadosBanco[2]) < 17
		oDanfe:Say  (487,002,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
	OtherWise
		If Len(aDadosBanco[2]) > 25	
			oDanfe:Say  (487,002,Subs(aDadosBanco[2],1,25),oFont9 )	// [2]Nome do Banco 
		Else
	   		oDanfe:Say  (487,002,aDadosBanco[2],oFont9 )	// [2]Nome do Banco 
		EndIf
	EndCase	
EndIf
//
oDanfe:Say  (488,122,aDadosBanco[1]+"-2",oFont24 )	// [1]Numero do Banco
oDanfe:Say  (488,180,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
//   

//linhas horizontais      
oDanfe:Line (495,002,495,600 )
oDanfe:Line (520,002,520,600 )
oDanfe:Line (545,002,545,600 )
oDanfe:Line (565,002,565,600 )
oDanfe:Line (585,002,585,600 )
oDanfe:Line (605,480,605,600 )
oDanfe:Line (625,480,625,600 )
oDanfe:Line (645,480,645,600 )
oDanfe:Line (665,480,665,600 ) 
oDanfe:Line (685,002,685,600 )
oDanfe:Line (735,002,735,600 )
   

//   linhas verticais
oDanfe:Line (495,120,468, 120)
oDanfe:Line (495,175,468, 175) 

oDanfe:Line (545,110,585,110)
oDanfe:Line (565,180,585,180)
oDanfe:Line (545,250,585,250)
oDanfe:Line (545,300,565,300)
oDanfe:Line (545,350,585,350)
oDanfe:Line (495,480,685,480) 


//
oDanfe:Say  (502,002 ,"Local de Pagamento"                             					,oFont8)
oDanfe:Say  (507,080 ,"Pagavel em qualquer Banco ate o Vencimento."        		   		,oFont9)
oDanfe:Say  (516,080 ,"Apos o Vencimento pague somente no "+Alltrim(aDadosBanco[2])+"."   ,oFont9) //Nome do banco  
//

oDanfe:Say  (502,482,"Vencimento"                                     ,oFont8)
oDanfe:Say  (512,500,aDadosTit[4]                               ,oFont10)      
//
oDanfe:Say  (527,002 ,"Beneficiário"                                        ,oFont8)
oDanfe:Say  (537,002 ,aDadosEmp[1]	,oFont9) //Nome  
oDanfe:Say  (527,250 ,"Endereço"                                        ,oFont8)
oDanfe:Say  (536,252 ,aDadosEmp[2]	,oFont8) //Endereço        
oDanfe:Say  (542,252 ,aDadosEmp[3]	,oFont8) //Endereço
oDanfe:Say  (527,370 ,"CNPJ"                                        ,oFont8)
oDanfe:Say  (537,372 ,substr(aDadosEmp[6],10,len(alltrim(aDadosEmp[6]))-10)	,oFont8) // CNPJ         


//
oDanfe:Say  (527,482,"Agencia/Codigo Beneficiário"                         ,oFont8)
oDanfe:Say  (537,500,cAgCC+"/0000"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)


//
oDanfe:Say  (552,002 ,"Data do Documento"                              ,oFont8)
oDanfe:Say  (561,002 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
//
oDanfe:Say  (552,112 ,"Nro.Documento"                                  ,oFont8)
oDanfe:Say  (561,120 ,aDadosTit[1]										,oFont10) //Numero+Parcela
//
oDanfe:Say  (552,252,"Especie Doc."                                   ,oFont8)
oDanfe:Say  (561,260,aDadosTit[8]										,oFont10) //Tipo do Titulo
//
oDanfe:Say  (552,302,"Aceite"                                         ,oFont8)
oDanfe:Say  (561,325,"N"                                             ,oFont10)
//
oDanfe:Say  (552,352,"Data do Processamento"                          ,oFont8)
oDanfe:Say  (561,365,aDadosTit[3]                               ,oFont10) // Data impressao         
//
nDacNN:= DACNN(aDadosBanco[6]+aDadosTit[6])
nDacNN:= IIF(ValType(nDacNN) == "N",Alltrim(Str(nDacNN)),nDacNN)
oDanfe:Say  (552,482,"Carteira/Nosso Numero"                                   ,oFont8)
oDanfe:Say  (561,500,aDadosBanco[7]+"/"+aDadosTit[6]+"-"+Alltrim( nDacNN )	,oFont10)  
//
oDanfe:Say  (572,002 ,"Uso do Banco"                                   ,oFont8)
//
oDanfe:Say  (572,112 ,"Carteira"                                       ,oFont8)
oDanfe:Say  (582,135 ,aDadosBanco[7]                                  	,oFont10)
//
oDanfe:Say  (572,182 ,"Especie"                                        ,oFont8)
oDanfe:Say  (582,200 ,"R$"                                             ,oFont10)
//
oDanfe:Say  (572,252,"Quantidade"                                     ,oFont8)
oDanfe:Say  (572,352,"Valor"                                          ,oFont8)
//
oDanfe:Say  (572,482,"Valor do Documento"                          	,oFont8)
oDanfe:Say  (582,500,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10) 

      
//
oDanfe:Say  (592,002 ,"Instrucoes (Todas informacoes deste bloqueto sao de exclusiva responsabilidade do Beneficiário)",oFont8)
oDanfe:Say  (613,002 ,aBolText[2],oFont10)
oDanfe:Say  (623,002 ,aBolText[3],oFont10)    
//
oDanfe:Say  (592,482,"(-)Desconto/Abatimento"                         ,oFont8)
oDanfe:Say  (612,482,"(-)Outras Deducoes"                             ,oFont8)
oDanfe:Say  (632,482,"(+)Mora/Multa"                                  ,oFont8)
oDanfe:Say  (652,482,"(+)Outros Acrescimos"                           ,oFont8)
oDanfe:Say  (672,482,"(=)Valor Cobrado"                               ,oFont8)
//
oDanfe:Say  (692,002 ,"Pagador"                                         ,oFont8)
oDanfe:Say  (698,100 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oDanfe:Say  (708,100 ,aDatSacado[3]                                    ,oFont10)
oDanfe:Say  (718,100 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
if Len(Alltrim(aDatSacado[7])) == 14
	oDanfe:Say  (728,100 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
else
	oDanfe:Say  (728,100 ,"C.P.F.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF
endif
oDanfe:Say  (728,490,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)
//
oDanfe:Say  (732,002 ,"Pagador/Avalista"                               ,oFont8)
oDanfe:Say  (742,350,"Autenticacao Mecanica -"                        ,oFont8)
oDanfe:Say  (742,482,"Recibo do Pagador"								,oFont10)             

//oDanfe:FWMsBar("INT25"  ,680,060,CB_RN_NN[1]  ,oDanfe,.F.,CLR_BLACK,.T., 0.028,2.5,,,,.F.)
oDanfe:FWMsBar("INT25"  ,63,5,CB_RN_NN[1]  ,oDanfe,.F.,CLR_BLACK,.T., 0.04,1.6,,,,.F.)
 

//Grava informacoes no titulo referentes ao boleto para o banco utilizado
// Nosso Numero deve conter 11 posicoes no arquivo de remessa do CNAB de cobranca
//													  				   TAM [11]                TAM[9]   TAM[2]
//O campo nosso numero do Cnab devera carregar as informacoes do campo E1_NUMBCO ou concatenar E1_NUM + E1_PARCELA
nDacNN:= DACNN(aDadosBanco[6]+aDadosTit[6])
nDacNN:= IIF(ValType(nDacNN) == "N",Alltrim(Str(nDacNN)),nDacNN)
RecLock("SE1",.F.)
	//SE1->E1_IMPBOL  := "S"
 	SE1->E1_NUMBCO	:=	aDadosTit[6]+nDacNN   // Nosso n?ero (Ver f?mula para calculo)
 //	SE1->E1_PORTADO	:= 	aDadosBanco[1]
 //	SE1->E1_AGEDEP 	:=  aDadosBanco[3]
//	SE1->E1_CONTA	:=  aDadosBanco[4]+aDadosBanco[5]
//	SE1->E1_SITUACA	:=	"1"//Substr(aDadosBanco[6],2,1)
	SE1->E1_XIMPBOL	:= '1'
	SE1->E1_CODBAR	:= CB_RN_NN[1]
MsUnlock()
//
Return 
/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??un?o    ?Modulo10    ?escri?o?az a verificacao e geracao do digi-??
??         ?            ?        ?o Verificador no Modulo 10.        ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)
/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??un?o    ?Modulo11    ?escri?o?az a verificacao e geracao do digi-??
??         ?            ?        ?o Verificador no Modulo 11.        ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)

/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??un?o    ?DACNN       ?escri?o?az a verificacao e geracao do digi-??
??         ?            ?        ?o Verificador no Modulo 11 para NN.??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
Static Function DACNN(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 7
		P := 1
	End
	L := L - 1
End  

Do Case
	Case mod(D,11) == 1  // Se o Resto for 1 a subtracao sera 11 - 1 e resultara 10 - despresa-se o 0 e para 1 sempre considera P como DAC
		D := "P"
	Case mod(D,11) == 0  // Se o Resto for 0 nao efetua subtracao e atribui 0 ao DAC
		D := 0
	OtherWise   // Para as demais situacoes efetua a subtracao normalmente
		D := 11 - (mod(D,11))
EndCase 

Return(D)
//
//Retorna os strings para inpress? do Boleto
//CB = String para o c?.barras, RN = String com o n?ero digit?el
//Cobran? n? identificada, n?ero do boleto = T?ulo + Parcela
//
//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)
//
//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )
//
/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??un?o    ?et_cBarra   ?escri?o?era a codificacao da Linha digitav.??
??         ?            ?        ?erando o codigo de barras.         ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto, cCarteira)
//
LOCAL bldocnufinal := cNroDoc//strzero(val(cNroDoc),8)
LOCAL blvalorfinal := IIF(TamSx3("E1_SALDO")[2] == 2, strzero((nValor*100),10), strzero(int(nValor*100),10) )
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
 
//
//-------- Definicao do NOSSO NUMERO
NN	 := bldocnufinal
s    := cCarteira + bldocnufinal 
dvnn := DACNN(s)// digito verifacador Carteira + Nosso Num
DACNN:= AllTrim(IIF(ValType(dvnn) == "N",Str(dvnn),dvnn))
//
//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + _cfator + blvalorfinal + SubS(cAgencia,1,4) + cCarteira + NN + StrZero(Val(cConta),7) + "0"
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
//
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
//
// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := cBanco + SubS(cAgencia,1,4) + SubS(cCarteira,1,1)
dv   := modulo10(s)
RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := SubStr(cCarteira, 2, 1) + SubStr(NN,1,4) + SubStr(NN, 5, 5)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SubStr(NN, 10, 2) + StrZero(Val(cConta),7) + "0"
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + '  '
//
// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
RN   := RN + _cfator + blvalorfinal
//
Return({CB,RN,NN})
Static Function ArrumaAno(_dDataValida)
	 
	local _cDataAno := year(_dDataValida)
	local _cDataDia := Day(_dDataValida)
	local _cDataMes := Month(_dDataValida)
	if len(CVALTOCHAR(_cDataMes)) == 1
	_cDataMes := "0"+CVALTOCHAR(_cDataMes)
	else 
	_cDataMes := CVALTOCHAR(_cDataMes)
	endif
	
	if len(CVALTOCHAR(_cDataDia)) == 1
	_cDataDia := "0"+CVALTOCHAR(_cDataDia)
	else 
	_cDataDia := CVALTOCHAR(_cDataDia)
	endif 
	
	if len(CVALTOCHAR(_cDataAno)) == 2
	_cDataAno := "20"+CVALTOCHAR(_cDataAno)
	else 
	_cDataAno := CVALTOCHAR(_cDataAno)
	endif	
	_dDataValida := _cDataDia+"/"+_cDataMes+"/"+_cDataAno
	
return _dDataValida
