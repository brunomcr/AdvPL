#include "Totvs.ch"  
#include "Protheus.ch"
#INCLUDE "DEFEMPSB.CH"

#DEFINE STR000 "*************************** ATENÇÃO ***************************"
#DEFINE STR001 "Os dados abaixo não conferem com a Chave digitada:"+Chr(13)+Chr(10)
#DEFINE STR002 "ESTADO DO CADASTRO"+Chr(13)+Chr(10)
#DEFINE STR003 "MES E/OU ANO DE EMISSÃO"+Chr(13)+Chr(10)
#DEFINE STR004 "CNPJ DO CADASTRO OU CNPJ AUXILIAR (QUANDO FOR NF AVULSA)"+Chr(13)+Chr(10)
#DEFINE STR005 "MODELO DO DOCUMENTO FISCAL"+Chr(13)+Chr(10)
#DEFINE STR006 "SERIE DO DOCUMENTO"+Chr(13)+Chr(10)
#DEFINE STR007 "NÚMERO DO DOCUMENTO"+Chr(13)+Chr(10)
#DEFINE STR008 "Preencha a Chave da Nota corretamente!"+Chr(13)+Chr(10)
#DEFINE STR009 "Espécie do Documento não condiz com dados digitados!"+Chr(13)+Chr(10)
#DEFINE STR010 "Preencha a Natureza!"+Chr(13)+Chr(10)
#DEFINE STR011 "Natureza selecionada não permitida!"+Chr(13)+Chr(10)
#DEFINE STR012 "Há itens com armazém inválido para a Natureza selecionada!"+Chr(13)+Chr(10)
#DEFINE STR013 "A Natureza selecionada obriga o preenchimento dos Campos: "+Chr(13)+Chr(10)+"'Código de Retenção' e 'Gera DIRF = SIM'"+Chr(13)+Chr(10)
#DEFINE STR014 "Proibida a entrada direta de mercadoria no armazém de venda!"+Chr(13)+Chr(10)+"Selecione outro armazém."

//PE que é usado para validar CHAVE NFE X CNPJ X UF X MES/ANO X NUMERO X SERIE - ARMAZEM X NATUREZA (DEVOLUÇÃO)
User Function MT100TOK()
Local lRet := .T.
/*
Local cNatureza := MaFisRet(,"NF_NATUREZA")
Local cCodCli := IIF(FUNNAME()="MATA103",CA100FOR+CLOJA,"")
Local cCGCCli := IIF(cTipo<>"D",Posicione("SA2",1,xFilial("SA2")+cCodCli,"A2_CGC"),"")
Local aCNPJFilial := {}
Local cAlias, cCampo, cCampoAux
Local cMensagem := STR001
Local lMsg := .F. 
Local cChaveNFe := IIF(FUNNAME()="MATA103",aNfeDanfe[13],"") //Chave NF-e
Local nX, nRegSM0 := 0
Local nPosLocal	:= aScan(aHeader,{|x|AllTrim(x[2]) == "D1_LOCAL"})
Local nPosTES	:= aScan(aHeader,{|x|AllTrim(x[2]) == "D1_TES"})
Local aTES
Local lNat := .F.
Local aUF := {	{"11","Rondônia","RO"},{"12","Acre","AC"},{"13","Amazonas","AM"},{"14","Roraima","RR"},{"15","Pará","PA"},{"16","Amapá","AP"},;
				{"17","Tocantins","TO"},{"21","Maranhão","MA"},{"22","Piauí","PI"},{"23","Ceará","CE"},{"24","Rio Grande do Norte","RN"},;
				{"25","Paraíba","PB"},{"26","Pernambuco","PE"},{"27","Alagoas","AL"},{"28","Sergipe","SE"},{"29","Bahia","BA"},{"31","Minas Gerais","MG"},;
				{"32","Espírito Santo","ES"},{"33","Rio de Janeiro","RJ"},	{"35","São Paulo","SP"},{"41","Paraná","PR"},{"42","Santa Catarina","SC"},;
				{"43","Rio Grande do Sul","RS"},{"50","Mato Grosso do Sul","MS"},{"51","Mato Grosso","MT"},{"52","Goiás","GO"},{"53","Distrito Federal","DF"}}
//If !lMT100TOK
	nRegSM0 := SM0->(Recno())
    
	DbSelectArea("SM0")
	DbSetOrder(1)
	DbGoTop()
	While !EoF() .and. SM0->M0_CODIGO == cEmpAnt
		AADD(aCNPJFilial,SM0->M0_CGC)
		SM0->(DbSkip())
	EndDo
	
	SM0->(DbGoTo(nRegSM0))
	
	//Verifica se trata-se de uma NF de uma das nossas filiais
	If aScan(aCNPJFilial,cCGCCli) == 0

		If FUNNAME()="MATA103"
			If (AllTrim(cEspecie) == "SPED" .and. cFormul == "N") .or. (AllTrim(cEspecie) == "CTE")
				
				If Empty(cChaveNFe) .or. Len(cChaveNFe) <> 44 .or. !U_ChkNFxChave(cChaveNFe)
					cMensagem := STR008
					lMsg := .T.
				Else
				
					//++++++++++++++++++++++++++++++++++
					//Verifica o Estado                +
					//++++++++++++++++++++++++++++++++++
					For nX := 1 to Len(aUF) Step 1
						If aUF[nX][3] == AllTrim(cUFOrig)
							If aUF[nX][1] != SubStr(cChaveNFe,1,2)
								lMsg := .T.
								cMensagem += STR002
							EndIf
						EndIf	
					Next
					
					//++++++++++++++++++++++++++++++++++
					//Verifica Mês e Ano               +
					//++++++++++++++++++++++++++++++++++
					If SubStr(AllTrim(Str(YEAR(dDEmissao))),3,2)+StrZero(MONTH(dDEmissao),2) != SubStr(cChaveNFe,3,4)
						lMsg := .T.
						cMensagem += STR003
					EndIf
				
					//++++++++++++++++++++++++++++++++++
					//Verifica CNPJ                    +
					//++++++++++++++++++++++++++++++++++
					If cTipo == "D"
						cAlias := "SA1"
						cCampo := "SA1->A1_CGC"
						cCampoAux := "SA1->A1_XCGC"
					Else
						cAlias := "SA2"
						cCampo := "SA2->A2_CGC"
					EndIf
					
					DbSelectArea(cAlias)
					(cAlias)->(DbGoTop())
					DbSetOrder(1)
					DbSeek(xFilial(cAlias)+cA100For+cLoja)
					
					If AllTrim(&(cCampo)) != SubStr(cChaveNFe,7,14)
						If cAlias == "SA1"
							If AllTrim(&(cCampoAux)) != SubStr(cChaveNFe,7,14)
								lMsg := .T.
								cMensagem += STR004
							EndIf
						Else
							lMsg := .T.
							cMensagem += STR004
						EndIf
					EndIf
				
					//++++++++++++++++++++++++++++++++++
					//Verifica Serie                   +
					//++++++++++++++++++++++++++++++++++	
					If (EMPTY(cSerie)) .or. (StrZero(Val(cSerie),3) != SubStr(cChaveNFe,23,3)) .or. (SubStr(Alltrim(cSerie),1,1) == '0' .and. Len(Alltrim(cSerie))>1 )
						lMsg := .T.
						cMensagem += STR006
					EndIf
					
					//++++++++++++++++++++++++++++++++++
					//Verifica Número do Documento     +
					//++++++++++++++++++++++++++++++++++	
					If StrZero(Val(cNFiscal),9) != SubStr(cChaveNFe,26,9)
						lMsg := .T.
						cMensagem += STR007
					EndIf	
				EndIf		
					
			ElseIf !Empty(cChaveNFe) .and. AllTrim(cEspecie) <> "SPED"
				cMensagem := STR009
				lMsg := .T.
			EndIf
	    
			If lMsg
				MsgAlert(cMensagem,STR000)
				lRet := .F.
				lMsg := .F.
			EndIf
	    
		EndIf
		
		If cTipo == "D" .and. procname(11) <> "A103DEVOL"	//Verifica se está abrindo a tela do RETORNAR, para não validar o Armazem e Natureza neste momento 

			//Se for Entrada diferente do nossos CNPJs - Irá proibir entrada no armazém 11 (Venda)
	    	For nX := 1 to Len(aCols) Step 1
				If aCols[nX][nPosLocal] $ "11"
					lMsg := .T.
					cMensagem := STR014   
				EndIf
			Next
            
			If !lMsg
				For nX := 1 to Len(aCols) Step 1
					aTES := Posicione("SF4",1,xFilial("SF4")+Alltrim(aCols[nX][nPosTES]),"F4_DUPLIC")
				Next
				                      
				If ValType(aTES) == "A"
					If aScan(aTES,"S") > 0
						lNat := .T.
					EndIf
				ElseIf ValType(aTES) == "C"
					If aTES == "S"
						lNat := .T.
					EndIf
				Else
					lNat := .F.
				EndIf
				
				If lNat
					If Empty(cNatureza)
						cMensagem := STR010
						lMsg := .T.
					ElseIf !AllTrim(cNatureza) $ "DEFEITO/MERC.BOAS"
						cMensagem := STR011
						lMsg := .T.
					ElseIf AllTrim(cNatureza) == "DEFEITO"
						For nX := 1 to Len(aCols) Step 1
							If !aCols[nX][nPosLocal] $ "08"
								lMsg := .T.
								cMensagem := STR012   
							EndIf
						Next
					ElseIf AllTrim(cNatureza) == "MERC.BOAS"
						For nX := 1 to Len(aCols) Step 1
							If !aCols[nX][nPosLocal] $ "06"
								lMsg := .T.
								cMensagem := STR012   
							EndIf
						Next
					EndIf
				Else
					For nX := 1 to Len(aCols) Step 1
						If !aCols[nX][nPosLocal] $ "06/08"
							lMsg := .T.
							cMensagem := STR012   
						EndIf
					Next
	    		EndIf
	
				If cTipo == "D" .and. cFormul == "S" .and. AllTrim(cEspecie) <> "SPED"
					lMsg := .T.
					cMensagem := STR009
				EndIf
			EndIf
	
			If lMsg
				MsgAlert(cMensagem,STR000)
				lRet := .F.
				lMsg := .F.
			EndIf
	
		EndIf
		
		If !Empty(cNatureza)		//Valida se a Natureza selecionada deve gerar DIRF
			aCamposSED := GetAdvFVal("SED",{"ED_CALCIRF","ED_CALCCSL","ED_CALCCOF","ED_CALCPIS"},xFilial("SED")+AllTrim(cNatureza),1)
			If aScan(aCamposSED,"S") > 0
				If Empty(cDirf) .or. Empty(cCodRet) .or. AllTrim(cDirf) == "2"
					lMsg := .T.
					cMensagem := STR013
				EndIf
			EndIf
			
			If lMsg
				MsgAlert(cMensagem,STR000)
				lRet := .F.
				lMsg := .F.
			EndIf
		EndIf

	EndIf
//EndIf
*/	
Return(lRet)
