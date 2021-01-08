#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"
#include "APWEBEX.CH" 
#include "ap5mail.ch" 
#INCLUDE "RWMAKE.CH"
#include "tbicode.ch"
#INCLUDE "DEFEMPSB.CH"
#define DS_MODALFRAME   128
//U_cupHist({'03','00'})
//U_cupHist({'08','01'})
User Function CupHist(aParam)
	Local cQuery	:= ""
	Local aArray	:= ""
	Local cCaminho 	:= "\data\"
	Local dData		:= ctod("  /  /    ") 
	Local dDataini	:= ctod("  /  /    ") 
	Local dDatafim	:= ctod("  /  /    ") 
	Local aArq		:= {}
	Local xEmp 		:= aParam[1]
	Local xFil		:= aParam[2]
	Local cEmpresa	:= ""
	RPCSetType(3)
	If FindFunction('WFPREPENV')
		lAuto := .T.      
		RPCSetType( 3 )						// Não consome licensa de uso
		wfPrepENV(xEmp, xFil)	
		//wfPrepENV("03", "00")
	Else
		lAuto := .T.
		RPCSetType( 3 )						// Não consome licensa de uso
		Prepare Environment Empresa xEmp Filial xFil	
	Endif
	//dData 	:= dDatabase
	//dDataini 	:= dDatabase
	cEmpresa	:= cEmpAnt
	dDataini	:= STOD("20180101")
	dDatafim	:= dDatabase
	Set(_SET_DATEFORMAT, 'dd/mm/yyyy')
	cCaminho 	:= iif(right(cCaminho,1) == "\",cCaminho,cCaminho+"\") 
	
	If EmpTy(ALLTRIM(cCaminho))  
		conout("Arquivo de integração CLOSEUP nao gerado! Caminho de Destino nao identificado")
		Return
	EndIf

	WHILE dDataini <= dDataFim

		dData	:= dDataini

		cQuery := "SELECT A1_COD+A1_LOJA[CLIENTE], A1_CGC, A1_NREDUZ, A1_NOME, A1_END,A1_COMPLEM,A1_CEP,A1_MUN, A1_EST, '('+RTRIM(A1_DDD)+')'+'-'+A1_TEL[TEL], "
		cQuery += "''[FAX],A1_PRICOM,A1_EMAIL,''[WEBSITE], "
		cQuery += "B1_COD,B1_CODBAR,B1_DESC,'VEDIC HINDUS'[FABRICANTE],B1_UPRC,B1_POSIPI, "
		cQuery += "D2_TIPO, SUM(D2_QUANT)[QTD] "
		cQuery += "FROM "+RetSQLName("SD2")+" SD2 INNER JOIN "+RetSQLName("SA1")+" SA1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA "
		cQuery += "INNER JOIN "+RetSQLName("SB1")+" SB1 ON B1_COD = D2_COD "
		cQuery += "INNER JOIN "+RetSQLName("SC5")+" SC5 ON D2_PEDIDO = C5_NUM AND D2_FILIAL = C5_FILIAL "
		cQuery += "WHERE SD2.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
		cQuery += "and D2_TIPO = 'N' "
		IF cEmpresa == FC
			cQuery += " AND C5_XCANSAI IN ('1','3','4') "
		ENDIF
		//cQuery += "and D2_EMISSAO = CONVERT(varchar,GETDATE(),112) "
		cQuery += "and D2_EMISSAO BETWEEN '" + DTOS(dDataini)+"' AND '"+DTOS(dDataini)+"'"
		cQuery += "GROUP BY A1_COD,A1_LOJA,A1_CGC, A1_NREDUZ, A1_NOME, A1_END,A1_COMPLEM,A1_CEP,A1_MUN, A1_EST,A1_DDD,A1_TEL,A1_PRICOM,A1_EMAIL, "
		cQuery += "B1_COD,B1_CODBAR,B1_DESC,B1_UPRC,B1_POSIPI,D2_TIPO "
		cQuery += "ORDER BY 1,15 "
		
		aArray := u_QryArr(cQuery)

		If Len(aArray) > 0
			AADD(aArq,ArquivoC(aArray,dData,dDataini,dDataini))
			AADD(aArq,ArquivoP(aArray,dData,dDataini,dDataini))
			AADD(aArq,ArquivoV(aArray,dData,dDataini,dDataini))

			For i=1 to len(aArq)
				IF !FT2All(, , , ,aArq[i],dDataini) 
					CONOUT("ERRO DE CONEXAO NO FTP")
				ENDIF
			next

		ENDIF
		dDataini := DAYSUM(dDataini,1)
		aArq := {}
	END

Return

Static Function ArquivoC(aArray,dData,dDataini,dDataFim)
Local lRet := .T.
Local _lInicio	:= .T.
Local _lFim		:= .F.
local cLin		:= ""
local n			:= 0 
Local cCaminho	:= "\data\"   
Local cCodigo	:= ALLTRIM(SuperGetMv("SB_CLOSEUP",.F.,"3668"))
Local cEmpresa	:= cEmpAnt 
Local aArrayCli	:= {}
Local cFile		:= "C"+cCodigo+"M"+strzero(month(dData),2)+".D" +strzero(day(dData),2)

if cEmpresa == FC .OR. cEmpresa == COSMETIC
	//Arquivo do Tipo 
	nQtdNf := 0   	
	cArqTxt := cCaminho  
	cArqTxt := ALLTRIM(cArqTxt) +"C"+cCodigo+"M"+strzero(month(dData),2)+".D" +strzero(day(dData),2) 	
	nHdl 	:= fCreate(cArqTxt)
	if nHdl == -1
		conout("O arquivo de nome nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cabeçalho fornecido pelo layout                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLin := "10" //TIPO REGISTRO
		
	cLin +=  cCodigo// cod closeup  
	clin += alltrim(SUBSTR(SM0->M0_NOME,1,30))+;
			space(30-len(alltrim(SUBSTR(SM0->M0_NOME,1,30))))//Razao Social
	
	cLin += SM0->M0_CGC // CNPJ   
   
	cLin += strtran(dtoc(dDataini),"/","")//data inicio
	
	cLin += strtran(dtoc(dDataFim),"/","")//data Fim
	
	cLin += strtran(dtoc(dData),"/","")//data geracao do arquivo

	cLin+= "1" //fixo
	
	cLin+= space(100) //filler
	
	cLin+= space(171) //filler
	
	cLin+= "CUPbrcli1" //Controle interno CLOSE UP
	clin += CHR(13)+CHR(10)
	If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
		lRet := .F.
		conout("Erro geracao do ARQUIVOC:"+dtoc(dData))
		Return()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Detalhamento fornecido pelo layout                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	for i := 1 to len(aArray)
		if aScan(aArrayCli,ALLTRIM(aArray[i][1]))> 0
			loop
		endif
		AADD(aArrayCli,ALLTRIM(aArray[i][1]))
		cLin := "2" //TIPO
		
		cLin +=  replicate("0",14-len(ALLTRIM(aArray[i][1])))+ALLTRIM(aArray[i][1])// cod clIENTE 
		
		clin += alltrim(SUBSTR(aArray[i][2],1,14))+;
				space(14-len(alltrim(SUBSTR(aArray[i][2],1,14))))//CNPJ CLIENTE
		
		cLin += "1" // TIPO CNPJ   
	   
		clin += alltrim(SUBSTR(aArray[i][3],1,40))+;
				space(40-len(alltrim(SUBSTR(aArray[i][3],1,40))))//nome fantasia
				
		clin += alltrim(SUBSTR(aArray[i][4],1,40))+;
				space(40-len(alltrim(SUBSTR(aArray[i][4],1,40))))//Razao social
				
		cLin += "1" // Flag endereço
		
		clin += alltrim(SUBSTR(aArray[i][5],1,70))+;
				space(70-len(alltrim(SUBSTR(aArray[i][5],1,70))))//ENDERECO
				
		clin += alltrim(SUBSTR(aArray[i][6],1,20))+;
				space(20-len(alltrim(SUBSTR(aArray[i][6],1,20))))//COMPLEMENTO
				
		clin += alltrim(SUBSTR(aArray[i][7],1,8))+;
				space(8-len(alltrim(SUBSTR(aArray[i][7],1,8))))//CEP
				
		clin += alltrim(SUBSTR(aArray[i][8],1,30))+;
				space(30-len(alltrim(SUBSTR(aArray[i][8],1,30))))//CIDADE
		
		clin += alltrim(SUBSTR(aArray[i][9],1,2))+;
				space(2-len(alltrim(SUBSTR(aArray[i][9],1,2))))//ESTADO 2
				
		clin += alltrim(SUBSTR(aArray[i][10],1,20))+;
				space(20-len(alltrim(SUBSTR(aArray[i][10],1,20))))//TELEFONE 20
				
		clin += alltrim(SUBSTR(aArray[i][11],1,20))+;
				space(20-len(alltrim(SUBSTR(aArray[i][11],1,20))))//FAX 20
				
		clin += strtran(dtoc(STOD(aArray[i][12])),"/","") //DTCADASTRO 8 DDMMAAAA
				
		clin += alltrim(SUBSTR(aArray[i][13],1,35))+;
				space(35-len(alltrim(SUBSTR(aArray[i][13],1,35))))//EMAIL 35
				
		clin += alltrim(SUBSTR(aArray[i][14],1,25))+;
				space(25-len(alltrim(SUBSTR(aArray[i][14],1,25))))//URL 25
		
		clin += SPACE(5)//FILLER 5
				
		clin += "C" //CONTROLE CLOSEUP C		
		
		clin += CHR(13)+CHR(10)
		If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
			lRet := .F.
			Return()
		EndIf
	next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ trailer                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLin := "3" //TIPO
	cLin += "0" //fixo
	cLin +=  cCodigo// cod closeup  
	cLin += strzero(len(aArrayCli)+2,8)
	cLin += SPACE(200)//FILLER 200
	cLin += SPACE(132)//FILLER 132
	cLin += "CUPbrcli3"
	clin += CHR(13)+CHR(10)
	If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
		lRet := .F.
		Return()
	EndIf
	fClose(nHdl)	
endif							
Return cFile

/*/ 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±± 
±±ºFuncao    ³ QryArr   ºAutor ³                    º Data ³   / /      º±± 
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±± 
±±ºDescricao ³ Funcao para rodar uma Query e retornar como Array          º±± 
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±± 
±±ºParametros³ cQuery - Query SQL a ser executado                         º±± 
±±ºRetorno   ³ aTrb   - Array com o conteudo da Query                     º±± 
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±± 
±±ºUso       ³ Especifico Del Valle                                       º±± 
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/ 
User Function QryArr(cQuery) 

Local aRet    := {} 
Local aRet1   := {} 
Local nRegAtu := 0 
Local x       := 0 

cQuery := ChangeQuery(cQuery)         

if Select("_TRB")  > 0    
	DbSelectArea("_TRB")   
	_TRB->(DbCloseArea()) 
endif
TCQUERY cQuery NEW ALIAS "_TRB" 

dbSelectArea("_TRB") 
aRet1   := Array(Fcount()) 
nRegAtu := 1 

While !Eof() 
      
     For x:=1 To Fcount() 
          aRet1[x] := FieldGet(x) 
     Next 
     Aadd(aRet,aclone(aRet1)) 
      
     dbSkip() 
     nRegAtu += 1 
Enddo 

if Select("_TRB")  > 0    
	DbSelectArea("_TRB")   
	_TRB->(DbCloseArea()) 
endif

Return(aRet) 


//gera arquivo Produto
Static Function ArquivoP(aArray,dData,dDataini,dDataFim)
Local lRet := .T.
Local _lInicio	:= .T.
Local _lFim		:= .F.
local cLin		:= ""
local n			:= 0 
Local cCaminho	:= "\data\"   
Local cCodigo	:= ALLTRIM(SuperGetMv("SB_CLOSEUP",.F.,"3668"))
Local cEmpresa	:= cEmpAnt 
Local aArrayPrd	:= {}
Local nQuant    := 0
Local cFile		:= "P"+cCodigo+"M"+strzero(month(dData),2)+".D"+strzero(day(dData),2) 

if cEmpresa == FC .OR. cEmpresa == COSMETIC
	//Arquivo do Tipo 
	nQtdNf := 0   	
	cArqTxt := cCaminho  
	cArqTxt := ALLTRIM(cArqTxt) +"P"+cCodigo+"M"+strzero(month(dData),2)+".D"+strzero(day(dData),2)  	
	nHdl 	:= fCreate(cArqTxt)
	if nHdl == -1
		conout("O arquivo de nome nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cabeçalho fornecido pelo layout                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLin := "70" //TIPO REGISTRO
		
	cLin +=  cCodigo// cod closeup  
	clin += alltrim(SUBSTR(SM0->M0_NOME,1,30))+;
			space(30-len(alltrim(SUBSTR(SM0->M0_NOME,1,30))))//Razao Social
	
	cLin += SM0->M0_CGC // CNPJ   
   
	cLin += strtran(dtoc(dDataini),"/","")//data inicio
	
	cLin += strtran(dtoc(dDataFim),"/","")//data Fim
	
	cLin += strtran(dtoc(dData),"/","")//data geracao do arquivo

	cLin+= "1" //fixo
	
	cLin+= space(118) //filler
	
	cLin+= "CUPbrpro7" //Controle interno CLOSE UP
	clin += CHR(13)+CHR(10)
	If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
		lRet := .F.
		conout("Erro geracao do ARQUIVOP:"+dtoc(dData))
		Return()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Detalhamento fornecido pelo layout                 ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aSort(aArray, , , {|x, y| x[15] < y[15]})
    for i := 1 to len(aArray)
		if aScan(aArrayPrd,ALLTRIM(aArray[i][15])) > 0
			IF i != len(aArray)				
            	If aArray[i][15] == aArray[i+1][15]
					loop
				ENDIF
			ENDIF
		ELSE
			IF i== len(aArray)
				AADD(aArrayPrd,ALLTRIM(aArray[i][15]))
			ELSE
				If aArray[i][15] == aArray[i+1][15]
					AADD(aArrayPrd,ALLTRIM(aArray[i][15]))
					loop
				else
					AADD(aArrayPrd,ALLTRIM(aArray[i][15]))
				ENDIF
			ENDIF
		endif	
		cLin := "8 0" //TIPO
		
		cLin +=  replicate("0",13-len(ALLTRIM(STRTRAN(aArray[i][15],".",""))))+ALLTRIM(strtran(aArray[i][15],".",""))// cod Produto
        
        cLin += "0"

		clin += alltrim(SUBSTR(aArray[i][16],1,13))+;
				space(13-len(alltrim(SUBSTR(aArray[i][16],1,13))))//EAN
		
		cLin += "1" // TIPO COD BAR 1= EAN 2=OUTROS
	   
		clin += alltrim(SUBSTR(aArray[i][17],1,70))+;
				space(70-len(alltrim(SUBSTR(aArray[i][17],1,70))))//DESC PROD

		cLin += SPACE(8) // Filler 
				
		clin += alltrim(SUBSTR(aArray[i][18],1,40))+;
				space(40-len(alltrim(SUBSTR(aArray[i][18],1,40))))//fabricante
					
		clin += strzero((round(aArray[i][19],2)*100),9) // ult preco
				
		clin += space(20)//tipo produto
				
		clin += alltrim(SUBSTR(aArray[i][20],1,15))+;
				space(15-len(alltrim(SUBSTR(aArray[i][20],1,15))))//Class fiscal
		
		clin += space(8)
				
		clin += "P" //CONTROLE CLOSEUP P
		
		clin += CHR(13)+CHR(10)
		If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
			lRet := .F.
			Return()
		EndIf
	next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ trailer                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLin := "9" //TIPO
	cLin += "0" //fixo
	cLin +=  cCodigo// cod closeup  
	cLin += strzero(len(aArrayPrd)+2,8)
	cLin += SPACE(179)//FILLER 179
	cLin += "CUPbrpro9"
	clin += CHR(13)+CHR(10)
	If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
		lRet := .F.
		Return()
	EndIf
	fClose(nHdl)	
endif							
Return cFile



//Arquivo Vendas
//gera arquivo Produto
Static Function ArquivoV(aArray,dData,dDataini,dDataFim)
Local lRet := .T.
Local _lInicio	:= .T.
Local _lFim		:= .F.
local cLin		:= ""
local n			:= 0 
Local cCaminho	:= "\data\"   
Local cCodigo	:= ALLTRIM(SuperGetMv("SB_CLOSEUP",.F.,"3668"))
Local cEmpresa	:= cEmpAnt 
Local nQuant    := 0
Local cFile		:= "V"+cCodigo+"M"+strzero(month(dData),2)+".D"+strzero(day(dData),2) 

if cEmpresa == FC .OR. cEmpresa == COSMETIC
	//Arquivo do Tipo 
	nQtdNf := 0   	
	cArqTxt := cCaminho  
	cArqTxt := ALLTRIM(cArqTxt) +cFile 	
	nHdl 	:= fCreate(cArqTxt)
	if nHdl == -1
		conout("O arquivo de nome nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cabeçalho fornecido pelo layout                 			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLin := "40" //TIPO REGISTRO
		
	cLin +=  cCodigo// cod closeup  

	 
	cLin += strtran(dtoc(dDataini),"/","")//data inicio
	
	cLin += strtran(dtoc(dDataFim),"/","")//data Fim
	
	cLin += strtran(dtoc(dData),"/","")//data geracao do arquivo

	cLin+= "D" //fixo
	
	cLin+= space(3) //filler
	
	cLin+= "CUPbrven4" //Controle interno CLOSE UP
	clin += CHR(13)+CHR(10)
	If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
		lRet := .F.
		conout("Erro geracao do ARQUIVOV:"+dtoc(dData))
		Return()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Detalhamento fornecido pelo layout                 ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    for i := 1 to len(aArray)
		cLin := "5" //TIPO

		cLin += strzero(day(dData),2)
		
		cLin +=  replicate("0",14-len(alltrim(aArray[i][1])))+alltrim(aArray[i][1]) //Cliente
        
		cLin += "1" //flag do cliente
		
		cLin += "0" //fixo

		clin += replicate("0",13-len(ALLTRIM(STRTRAN(aArray[i][15],".",""))))+;
					ALLTRIM(strtran(aArray[i][15],".",""))// cod Produto
		
		cLin += "1" // Flag do Produto
	   
		clin += "N" //flad de venda N ou D (normal ou dev)

		cLin += STRZERO(aArray[i][22],8) // Quantidade	
		nQuant += aArray[i][22]

		clin += "V" //CONTROLE CLOSEUP P
		
		clin += CHR(13)+CHR(10)
		If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
			lRet := .F.
			Return()
		EndIf
	next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ trailer                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLin := "6" //TIPO
	cLin += "0" //fixo
	cLin +=  cCodigo// cod closeup  
	cLin += strzero(len(aArray)+2,8)
	cLin += strzero(nQuant,10)
	cLin += strzero(0,10)
	cLin += "CUPbrven6"
	clin += CHR(13)+CHR(10)
	If fWrite(nHdl,cLin, Len(cLin)) != Len(cLin)
		lRet := .F.
		Return()
	EndIf
	fClose(nHdl)	
endif							
Return cFile

Static Function FT2All(cServer, nPorta, cUser, cPass,cFile2,dAnoA)      //chamado na linha 1109
Local cLocal := "\data\"         
Local cFile 	:= cLocal+cFile2 
Local lRet := .F.
Local cAno		:= CVALTOCHAR( Year(dAnoA) ) + "/"
lOCAL cEmpresa := cEmpAnt
Default cServer 	:= "ftp.close-upinternational.com.br"
Default nPorta 	:= 21//nPorta //21
Default cUser		:= "gruposurya_dmd"
Default cPass	:= "LJKHBikg2i3g"
Private _cAmbAtual := Upper( AllTrim( GetEnvServer() ) )

FTPDisconnect()
If     FTPConnect( cServer, 21, cUser, cPass )
    Conout('FTP conectado!')
	Conout('Diretorio FTP',FTPGetCurDir())
	if cEmpresa == FC
		Conout('FTPDirChange',FTPDirChange('FCSANTOS/'+cAno))
		FTPGetCurDir()	 
		FTPDirChange('FCSANTOS/')
	elseif cEmpresa == COSMETIC
		Conout('FTPDirChange',FTPDirChange('COSMETIC/'+cAno))
		FTPGetCurDir()	 
		FTPDirChange('COSMETIC/')
    ENDIF 
     
	If FTPUpLoad( cFile, cFile2)
		Conout('UpLoad Ok! '+ cFile2)  
		lRet := .T.    								    
		if Ferase(cFile) == -1
		CONOUT("Falha na delecao do arquivo"+cFile2)
		endif

	Else
	    Conout('Falha UpLoad!'+cFile2)    	    		
	EndIf
     FTPDisconnect()
Else
     Conout('Falha Conexao! '+cFile2)
EndIf
Return lRet 