#include "protheus.ch"      
#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GOREL10  º Autor ³ Adriana Colafati   º Data ³  20/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Ocorrências de Entrega                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MV_PAR01 => Filial					                      º±±
±±º			 ³ MV_PAR02 => Serie					                      º±±
±±º			 ³ MV_PAR03 => Documento De				                      º±±
±±º			 ³ MV_PAR04 => Documento Ate			                      º±±
±±º			 ³ MV_PAR05 => Emissao De						              º±±
±±º			 ³ MV_PAR06 => Emissao Ate				                      º±±
±±º			 ³ MV_PAR07 => Transportadora De		                      º±±
±±º			 ³ MV_PAR08 => Transportadora Ate		                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GOREL10()
Local oReport

//If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel	
	Pergunte("GOREL10",.F.)	
	oReport := ReportDef()	
	oReport:PrintDialog()	
//EndIf

Return

Static Function ReportDef()
Local oReport
Local oSection1
Local oBreak
Local aTitulo := {"","Relatório de Ocorrências de Entrega",""}
Local cDados := ""
Public aDados := {"","","","","","","","","","","","","",""}

If Select("GOREL10") > 0
   GOREL10->(dbCloseArea())
EndIf

oReport := TReport():New("GOREL10","OCORRÊNCIA DE ENTREGAS","GOREL10",{|oReport| PrintReport(oReport)},"Relatório de Ocorrências de Entrega.")

oReport:SetCustomText(aTitulo)

oSection1 := TRSection():New(oReport,"OCORRÊNCIA DE ENTREGAS",{"SF2","SA1","SA4","SZ4","SZ3"})
																		//[8] Descrição Classificação
TRCell():New(oSection1,cDados		,"GOREL10","Classif.",,,,{||xPosSZ4(8,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})
TRCell():New(oSection1,"F2_FILIAL"	,"GOREL10",)
TRCell():New(oSection1,"F2_DOC"	 	,"GOREL10",)
TRCell():New(oSection1,"F2_SERIE"	,"GOREL10",)
TRCell():New(oSection1,"F2_CLIENTE"	,"GOREL10",)
TRCell():New(oSection1,"F2_LOJA"	,"GOREL10",)
TRCell():New(oSection1,"A1XNOME"	,"GOREL10","Nome")
TRCell():New(oSection1,"A1XMUN"	   	,"GOREL10","Municipio")
TRCell():New(oSection1,"F2_EST"	   	,"GOREL10",)
TRCell():New(oSection1,"F2_TRANSP" 	,"GOREL10",)
TRCell():New(oSection1,"A4_NOME"   	,"GOREL10",)
TRCell():New(oSection1,cDados	 	,"GOREL10","Transp.Ocorren.",,,,{||xPosSZ4(2,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})		//[2] Código Transportadora
TRCell():New(oSection1,cDados	 	,"GOREL10","Nome",,,,{||xPosSZ4(9,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})					//[9] Transp. da Ocorrência
TRCell():New(oSection1,cDados	 	,"GOREL10","Emissao Pedido",,,,{||xPosSZ4(15,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})					//[9] Transp. da Ocorrência
TRCell():New(oSection1,"F2_EMISSAO"	,"GOREL10",)
TRCell():New(oSection1,"F2_XDTCOL"	,"GOREL10",)
TRCell():New(oSection1,cDados		,"GOREL10","Dias Coleta",,,,{||xPosSZ4(10,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})			//[10]Dias para Coleta
TRCell():New(oSection1,cDados		,"GOREL10","Dt Ocorrência",,,,{||xPosSZ4(3,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})			//[3] Data Ocorrência
TRCell():New(oSection1,"Z2_PRAZO"	,"GOREL10",)
TRCell():New(oSection1,cDados		,"GOREL10","Prev. Entrega",,,,{||xPosSZ4(11,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})			//[11]Prev. de Entrega
TRCell():New(oSection1,cDados		,"GOREL10","Tempo Logistico",,,,{||xPosSZ4(12,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})		//[12]Tempo Logistico
TRCell():New(oSection1,cDados		,"GOREL10","Tempo Transp.",,,,{||xPosSZ4(13,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})			//[13]Tempo Transopradora
TRCell():New(oSection1,cDados		,"GOREL10","Tempo Total",,,,{||xPosSZ4(16,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})			//[13]Tempo Transopradora
TRCell():New(oSection1,cDados	 	,"GOREL10","Atraso",,,,{||xPosSZ4(14,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})				//[14]Atraso
TRCell():New(oSection1,cDados	 	,"GOREL10","Descrição Ocorrência",,,,{||xPosSZ4(7,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})	//[7] Descrição Ocorrência
TRCell():New(oSection1,cDados		,"GOREL10","Observação",,,,{||xPosSZ4(6,GOREL10->F2_FILIAL,GOREL10->F2_DOC,GOREL10->F2_SERIE,GOREL10->Z2_PRAZO,GOREL10->F2_EMISSAO,GOREL10->F2_XDTCOL)})			//[6] Observações

Return oReport

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)
Local aCNPJFilial := {}
Local cCNPJFilial := " A1_CGC NOT IN ("

nRegSM0 := SM0->(Recno())
    
DbSelectArea("SM0")
DbSetOrder(1)
DbGoTop()
While !EoF() .and. SM0->M0_CODIGO == cEmpAnt
	AADD(aCNPJFilial,SM0->M0_CGC)
	SM0->(DbSkip())
EndDo

SM0->(DbGoTo(nRegSM0))

For nX:=1 to Len(aCNPJFilial) Step 1
	cCNPJFilial += "'"+aCNPJFilial[nX]+"'"
Next

cCNPJFilial := STRTRAN(cCNPJFilial,"''","','")

cCNPJFilial += ")"

cCNPJFilial := "% "+cCNPJFilial+" %"

MakeSqlExpr("GOREL10")
oSection1:BeginQuery()

BeginSQL ALIAS "GOREL10"

/* 	++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++ 		QUERY ORIGINAL 		++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++   

	SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,A1_NOME AS 'A1XNOME',A1_MUN  AS 'A1XMUN',
		F2_EST,F2_TRANSP,A4_NOME,F2_EMISSAO,F2_XDTCOL,Z2_PRAZO
	FROM  SF2010 SF2
		INNER JOIN SA1010 SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_=''
		INNER JOIN SA4010 SA4 ON F2_TRANSP=A4_COD AND SA4.D_E_L_E_T_=''
		INNER JOIN SZ2010 SZ2 ON (F2_FILIAL = Z2_FILIAL AND F2_EST=Z2_EST AND A1_COD_MUN=Z2_CODMUN AND SZ2.D_E_L_E_T_='') AND
								 ((F2_EMISSAO between Z2_DTINI and Z2_DTFIM) OR (Z2_DTINI <= F2_EMISSAO and Z2_DTFIM=''))
	WHERE SF2.D_E_L_E_T_ =''
		AND F2_FILIAL = '01' AND F2_SERIE = '3'
		AND F2_DOC BETWEEN '000000001' AND 'ZZZZZZZZZ'
		AND F2_EMISSAO BETWEEN '20150101' AND '20150131'
		AND F2_TRANSP BETWEEN '' AND 'ZZZZZZ'
		AND A1_CGC NOT IN ('64109499000152','64109499000403','64109499000314','64109499000586')
	ORDER BY F2_DOC,F2_SERIE
	
	*/ 

	SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,A1_NOME AS 'A1XNOME',A1_MUN AS 'A1XMUN',
		F2_EST,F2_TRANSP,A4_NOME,F2_EMISSAO,F2_XDTCOL,Z2_PRAZO
	FROM  %table:SF2% SF2
		INNER JOIN %table:SA1% SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.%notDel%
		INNER JOIN %table:SA4% SA4 ON F2_TRANSP=A4_COD AND SA4.%notDel%
		INNER JOIN %table:SZ2% SZ2 ON (F2_FILIAL = Z2_FILIAL AND F2_EST=Z2_EST AND A1_COD_MUN=Z2_CODMUN AND SZ2.%notDel%) AND 
									  ((F2_EMISSAO between Z2_DTINI and Z2_DTFIM) OR (Z2_DTINI <= F2_EMISSAO and Z2_DTFIM=''))
	WHERE SF2.%notDel%
		AND F2_FILIAL = %exp:MV_PAR01% AND F2_SERIE = %exp:MV_PAR02%
		AND F2_DOC BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
		AND F2_EMISSAO BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
		AND F2_TRANSP BETWEEN %exp:MV_PAR07% AND %exp:MV_PAR08%
		AND %Exp:cCNPJFilial%
	ORDER BY F2_DOC,F2_SERIE

EndSQL

oSection1:EndQuery()  

oSection1:SetHeaderBreak(.F.)

oSection1:SetParentQuery()

oSection1:Print() 


Return
      

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Static Function xSoma(campo1,campo2)

Local cCampo

cCampo := ALLTRIM(Str(campo1-campo2))

Return cCampo

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Static Function xPosSZ4(nCampo,cFilDoc,cDoc,cSerie,cPrazo,dEmissao,dColeta)
Local aRegistros := {}
Local lEncerrado := .F.
Local aGOREL10 := {"","","","","","","","","","","","","",""}

/*aGOREL10
[1] Classificação
[2] Código Transportadora
[3] Data Ocorrência
[4] Hora Ocorrência
[5] Código da Ocorrência
[6] Observações
[7] Descrição Ocorrência
[8] Descrição Classificação
[9] Transp. da Ocorrência
[10]Dias para Coleta
[11]Prev. de Entrega                              ä
[12]Tempo Logistico
[13]Tempo Transopradora
[14]Atraso    
[15]Emissao PEdido
[16]Tempo Total
*/

If nCampo == 8	//Verifica se é a primeira coluna, se não for basta retornar o conteúodo da coluna posicionada
	
	DbSelectArea("SZ4")
	DbSetOrder(6)
	DbSeek(xFilial("SZ4")+cFilDoc+cDoc+cSerie)
	
	While !EoF() .and. cFilDoc==Z4_FILDC .and. cDoc==Z4_NRDC .and. cSerie==Z4_SERDC
	
		AADD(aRegistros,{Z4_CLASSI,Z4_CDTRP,Z4_DTOCOR,Z4_HROCOR,Z4_CODOCO,Z4_OBS})
	
		If Z4_CLASSI ="E"
			lEncerrado := .T.
		EndIf
		
		SZ4->(DbSkip())
	EndDo
	
	DbCloseArea("SZ4")
	
	If Len(aRegistros) > 0		//Se tiver ocorrência para a NF
		aGOREL10 := {}
		If lEncerrado	//Se existir ocorrência do tipo Encerrada (só deve levar a encerrada, senão ocorrência mais nova)
			For nW := 1 to len(aRegistros) Step 1
				If aRegistros[nW,1]="E"
					AADD(aGOREL10,aRegistros[nW])
				EndIf
			Next
		Else
			aGOREL10 := aRegistros
		EndIf
		
		//[1] Classificação
		//[2] Código Transportadora
		//[3] Data Ocorrência
		//[4] Hora Ocorrência
		//[5] Código da Ocorrência
		//[6] Observações
					
	//	Alinha array para deixar a ocorrência mais nova em primeiro
		aSort(aGOREL10,,,{|x,y| (DtoS(x[3])+x[4]) > (DtoS(y[3])+y[4]) })
	
		DbSelectArea("SZ3")
		DbSetOrder(1)
		DbSeek(xFilial("SZ3")+aGOREL10[1,5])
			
		AADD(aGOREL10[1],Z3_DESC)	   			//[7] Descrição Ocorrência
	//	AADD(aGOREL10[1],X3CBOX(Z3_CLASSI))	//[8] Descrição Classificação 
		AADD(aGOREL10[1],Z3_CLASSI)			//[8] Descrição Classificação 
		                                                                                    
		//[9] Transp. da Ocorrência
		AADD(aGOREL10[1],Alltrim(Posicione("SA4",1,xFilial("SA4")+aGOREL10[1,2],"A4_NOME")))
	    
	    If aGOREL10[1,3] <= Date()	//Verifica se a Ocorrência não é maior que data atual
			If !Empty(dColeta)
				If dColeta >= dEmissao .and. dColeta <= aGOREL10[1,3]
					//[10]Dias para Coleta (Coleta - Emissao)
					AADD(aGOREL10[1],U_x2_DiaUtil(dColeta,dEmissao))
				
					//[11]Prev. de Entrega (Coleta + Prazo)
					AADD(aGOREL10[1],U_x1_DiaUtil(dColeta,cPrazo))
					                                                                                               
					//[12]Tempo Logistico (Se "E", Emissao - Dt Ocorrencia, Emissao - Dt Atual)
					AADD(aGOREL10[1],IIF(aGOREL10[1,1]=='E',;
										U_x2_DiaUtil(aGOREL10[1,3],dEmissao),;
										U_x2_DiaUtil(Date(),dEmissao);
										))
				
					//[13]Tempo Transopradora (Se "E", Coleta - Dt Ocorrencia, Coleta - Dt Atual)
					AADD(aGOREL10[1],IIF(aGOREL10[1,1]=='E',;
										U_x2_DiaUtil(aGOREL10[1,3],dColeta),;
										U_x2_DiaUtil(Date(),dColeta);
										))
					
					//[14]Atraso (Se "E", Previsao - Dt Ocorrencia, Previsao - Dt Atual)
					AADD(aGOREL10[1],IIF(aGOREL10[1,1]=='E',;
										IIF(aGOREL10[1,3]>aGOREL10[1,11],;
											Val(xSoma(aGOREL10[1,3],aGOREL10[1,11])),;
											U_x2_DiaUtil(aGOREL10[1,11],aGOREL10[1,3])*-1),;
										IIF(Date()>aGOREL10[1,11],;
											Val(xSoma(Date(),aGOREL10[1,11])),;
											U_x2_DiaUtil(aGOREL10[1,11],Date())*-1);
										))                       
					//[15]Emissao do Pedido de Venda
					AADD(aGOREL10[1], PedEm(cFilDoc,cDoc,cSerie))
					
					//[16]Emissao do Pedido de Venda
					AADD(aGOREL10[1],IIF(aGOREL10[1,1]=='E',;
									U_x2_DiaUtil(aGOREL10[1,3],PedEm(cFilDoc,cDoc,cSerie)),;
									U_x2_DiaUtil(Date(),PedEm(cFilDoc,cDoc,cSerie));
									))
				Else
					AADD(aGOREL10[1],"INVALIDO")		//[10]Dias para Coleta
					AADD(aGOREL10[1],"")				//[11]Prev. de Entrega
					AADD(aGOREL10[1],"")				//[12]Tempo Logistico
					AADD(aGOREL10[1],"")				//[13]Tempo Transopradora
					AADD(aGOREL10[1],"9999")			//[14]Atraso
				EndIf
			Else
				AADD(aGOREL10[1],"INVALIDO")		//[10]Dias para Coleta
				AADD(aGOREL10[1],"")				//[11]Prev. de Entrega
				AADD(aGOREL10[1],"")				//[12]Tempo Logistico
				AADD(aGOREL10[1],"")				//[13]Tempo Transopradora
   				AADD(aGOREL10[1],"9999")			//[14]Atraso
			EndIf
	
		Else
			aGOREL10[1,3] := "INVALIDO"			//[3]Data Ocorrência
			AADD(aGOREL10[1],"")	   			//[10]Dias para Coleta
			AADD(aGOREL10[1],"")				//[11]Prev. de Entrega
			AADD(aGOREL10[1],"")				//[12]Tempo Logistico
			AADD(aGOREL10[1],"")				//[13]Tempo Transopradora
			AADD(aGOREL10[1],"9999")			//[14]Atraso
		EndIf
		
	Else 	//Se não tiver ocorrência
		aGOREL10 := {{"","","","","","NÃO HÁ OCORRÊNCIA PARA ESTA NOTA","","","","","","","",""}}
		
		If dColeta >= dEmissao
			aGOREL10[1,10] := IIF(!Empty(dColeta),U_x2_DiaUtil(dColeta,dEmissao),"")	  				//[10]Dias para Coleta (Coleta - Emissao)
			aGOREL10[1,11] := IIF(!Empty(dColeta),U_x1_DiaUtil(dColeta,cPrazo),"")						//[11]Prev. de Entrega (Coleta + Prazo)
			aGOREL10[1,14] := IIF(!Empty(dColeta),IIF(Date()>aGOREL10[1,11],Val(xSoma(Date(),aGOREL10[1,11])),U_x2_DiaUtil(aGOREL10[1,11],Date())*-1),"9999")		//[14]Atraso
		Else
			aGOREL10[1,10] := "INVALIDO"		//[10]Dias para Coleta (Coleta - Emissao)
			aGOREL10[1,14] := "9999"			//[14]Atraso
		EndIf
	EndIf
	
	aDados := aGOREL10[1] 	//Retorna somente a ocorrência mais nova ou Encerrada
EndIf
	
Return(aDados[nCampo])

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CPrev	º Autor ³ Adriana Colafati   º Data ³  20/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Coluna na SF2 com a Previsão de Entrega                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CPrev(dColeta, cCliente,dEmissao, c_FilDoc)
local	n_DiaMun   := 0
local 	n_DtValid  := IIF(Empty(dColeta),dEmissao,dColeta)
local	dDt_Prv := CtoD("//")
local c_Uf := POSICIONE("SA1",1,XFILIAL("SA1")+CCLIENTE,"A1_EST")
local c_CodMun :=AllTrim(POSICIONE("SA1",1,XFILIAL("SA1")+CCLIENTE,"A1_COD_MUN"))

If Select("xGOREL102") > 0           // Verificar se o Alias ja esta aberto.
	DbSelectArea("xGOREL102")        // Se estiver, devera ser fechado.
	xGOREL102->(DbCloseArea())
EndIf

cQUERY := " SELECT Z2_PRAZO FROM "+RetSqlName("SZ2")+" "
cQUERY += " WHERE "
cQUERY += " ('"+c_FilDoc+"' = Z2_FILIAL AND '"+c_Uf+"'=Z2_EST AND '"+c_CodMun+"'=Z2_CODMUN AND D_E_L_E_T_='') AND "
cQUERY += " (('"+DtoS(dEmissao)+"' between Z2_DTINI and Z2_DTFIM) OR (Z2_DTINI <= '"+DtoS(dEmissao)+"' and Z2_DTFIM=''))"

TCQUERY cQuery New Alias "xGOREL102"

n_DiaMun := xGOREL102->Z2_PRAZO

If !Empty(dColeta)
	dDt_Prv := U_x1_DiaUtil(n_DtValid,n_DiaMun)
EndIf

Return(dDt_Prv)                                                      

Static Function PedEm(cFilDoc,cDoc,cSerie) 
LOCAL dEmissao := CtoD("//")
LOCAL cQUERY := ""

cQUERY := "SELECT C5_EMISSAO FROM "+ RetSqlTab('SC5')+" INNER JOIN " +RetSqlTab("SD2")+" ON SC5.C5_FILIAL = SD2.D2_FILIAL AND SC5.C5_NUM = SD2.D2_PEDIDO "
cQUERY += " WHERE SD2.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' AND SD2.D2_FILIAL = '"+cFilDoc+"' "  
cQUERY += " AND SD2.D2_DOC = '"+cDoc+"'  AND SD2.D2_SERIE =  '"+cSerie+"' "  
If Select("GOREL1015") > 0           // Verificar se o Alias ja esta aberto.
	DbSelectArea("GOREL1015")        // Se estiver, devera ser fechado.
	GOREL1015->(DbCloseArea())
EndIf 
TCQUERY cQuery New Alias "GOREL1015"
if !EOF()
	dEmissao := STOD(GOREL1015->(C5_EMISSAO))
Endif
If Select("GOREL1015") > 0           // Verificar se o Alias ja esta aberto.
	DbSelectArea("GOREL1015")        // Se estiver, devera ser fechado.
	GOREL1015->(DbCloseArea())
EndIf 

Return dEmissao
