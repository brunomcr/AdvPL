#include "protheus.ch"
#INCLUDE "DEFEMPSB.CH"
#DEFINE CRLF Chr(13)+Chr(10)

USER FUNCTION PE01NFESEFAZ()
Local aProd     	:= PARAMIXB[1]
Local cMensCli  	:= PARAMIXB[2]
Local cMensFis  	:= PARAMIXB[3]
Local aDest     	:= PARAMIXB[4]
Local aNota     	:= PARAMIXB[5]
Local aInfoItem 	:= PARAMIXB[6]
Local aDupl     	:= PARAMIXB[7]
Local aTransp   	:= PARAMIXB[8]
Local aEntrega  	:= PARAMIXB[9]
Local aRetirada 	:= PARAMIXB[10]
Local aVeiculo  	:= PARAMIXB[11]
Local aReboque  	:= PARAMIXB[12]
Local aNfVincRur	:= PARAMIXB[13]
Local aEspVol     	:= PARAMIXB[14]
Local aNfVinc     	:= PARAMIXB[15]
Local AdetPag    	:= PARAMIXB[16]
Local aRetorno      := {}
Local cEmpresa		:= cEmpAnt

IF cEmpresa == FC
	cMensCli :=  U_xMenEnt(aDest[1]) + " " + cMensCli
ENDIF

aProd		:= U_IncLote(aProd,aNota,aDest)



//O retorno deve ser exatamente nesta ordem e passando o conteúdo completo dos arrays
//pois no rdmake nfesefaz é atribuido o retorno completo para as respectivas variáveis
//Ordem:
//      aRetorno[1] -> aProd
//      aRetorno[2] -> cMensCli
//      aRetorno[3] -> cMensFis
//      aRetorno[4] -> aDest
//      aRetorno[5] -> aNota
//      aRetorno[6] -> aInfoItem
//      aRetorno[7] -> aDupl
//      aRetorno[8] -> aTransp
//      aRetorno[9] -> aEntrega
//      aRetorno[10] -> aRetirada
//      aRetorno[11] -> aVeiculo
//      aRetorno[12] -> aReboque
//      aRetorno[13] -> aNfVincRur
//      aRetorno[14] -> aEspVol
//      aRetorno[15] -> aNfVinc
//      aRetorno[16] -> AdetPag
aadd(aRetorno,aProd) 
aadd(aRetorno,cMensCli)
aadd(aRetorno,cMensFis)
aadd(aRetorno,aDest)
aadd(aRetorno,aNota)
aadd(aRetorno,aInfoItem)
aadd(aRetorno,aDupl)
aadd(aRetorno,aTransp)
aadd(aRetorno,aEntrega)
aadd(aRetorno,aRetirada)
aadd(aRetorno,aVeiculo)
aadd(aRetorno,aReboque)
aadd(aRetorno,aNfVincRur)
aadd(aRetorno,aEspVol)
aadd(aRetorno,aNfVinc)
aadd(aRetorno,AdetPag)
 
RETURN aRetorno



User Function IncLote(aProd,aNota,ACli)
Local _aProd	:= aProd
Local n			:= 0
Local cDoc		:= aNota[2]
Local cSerie	:= aNota[1]
Local dDtVal	:= CTOD("  /  /  ")
Local cCli		:= ""
Local cLoja		:= "" //
Local cPed		:= Posicione("SD2",3,xFilial("SD2")+cDoc+cSerie,"D2_PEDIDO")
Local lForn		:= .F. //ALLTRIM(Posicione("SC5",1,xFilial("SC5")+cPed,"C5_TIPO")) == "B" //
Local cTpCli	:= ""
DbSelectArea("SC5")
DbSetOrder(1)
			
If DbSeek(xFilial("SC5") + cPed )

	If ALLTRIM ( SC5->C5_TIPO ) == 'B'
		
		lForn := .T.
		
	Else
	
		lForn := .F.
		
	EndIf

EndIf

If aNota[5] == "D"

	cCli	:= Posicione("SA2",3,xFilial("SA2")+aCli[1],"A2_COD")
	cLoja	:= Posicione("SA2",3,xFilial("SA2")+aCli[1],"A2_LOJA")

Else

	If lForn
	
		cCli	:= Posicione("SA2",3,xFilial("SA2")+aCli[1],"A2_COD")
		cLoja	:= Posicione("SA2",3,xFilial("SA2")+aCli[1],"A2_LOJA")
	
	Else
	
		cCli	:= Posicione("SA1",3,xFilial("SA1")+aCli[1],"A1_COD")
		cLoja	:= Posicione("SA1",3,xFilial("SA1")+aCli[1],"A1_LOJA")
		IF cEmpAnt == FC
			cTpCli	:= Posicione("SA1",3,xFilial("SA1")+aCli[1],"A1_XCANAL")
		ENDIF
	EndIf

EndIf

For n = 1 to len(_aProd)

	dDtVal		:= Posicione("SD2",3,xFilial("SD2")+cDoc+cSerie+cCli+cLoja+_aProd[n][2]+strzero(_aProd[n][1],2),"D2_DTVALID")
	cLote		:= Posicione("SD2",3,xFilial("SD2")+cDoc+cSerie+cCli+cLoja+_aProd[n][2]+strzero(_aProd[n][1],2),"D2_LOTECTL")

	IF Empty(dDTVal) .AND. !Empty ( cLote )

		msgalert("Erro ao incluir a validade do lote. Excluir a nota e tentar novamente."+CRLF+;
		" Caso o erro persista, chamar o administrador")

	EndIf
	
	_aProd[n][4] := substr(_aProd[n][4],1,78)+ ;
	" |Lote|: " + ALLtrim(_aProd[n][19]) + " |DtValid|: " +	 Dtoc(dDtVal)
	IF cEmpAnt == "03" .AND. cTpCli == "000007" .AND. SUBSTR(_aProd[n][7],2,3) == "910"
		_aProd[n][4] += " BRINDE"
	ENDIF
Next

Return _aProd


/*/{Protheus.doc} User Function xMenEnt
	Retorna para os dados adcionais o endereço de entrega do cliente
	@type  Function
	@author user
	@since 03/10/2019
	@version version
	@param cCgcCli
	@return cRet
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function xMenEnt(cCgcCli)
	Local cQuery 	:= ""
	Local cAliasA1 	:= GetNextAlias()
	Local cRet		:= ""
	Local cEnd 		:= ""
	Local cEst 		:= ""
	Local cMun 		:= ""
	Local cBairro 	:= ""
	Local cCep 		:= ""
	Local cComp 	:= ""
	Local cCanal	:= ""
	Local cEndEnt 	:= ""
	Local cEstE 	:= ""
	Local cMunE 	:= ""
	Local cBairroE 	:= ""
	Local cCepE 	:= ""
	Local cCompEnt 	:= ""

	cQuery := "SELECT TOP 1 A1_END [ENDE] "
	cQuery += ", A1_EST [EST], A1_MUN [MUN], A1_BAIRRO [BAIRRO] "
	cQuery += ", A1_CEP [CEP], A1_COMPLEM [COMPLEMEN] , A1_ENDENT [ENDENT] "
	cQuery += ", A1_ESTE [ESTE], A1_MUNE[MUNE], A1_BAIRROE[BAIRROE] "
	cQuery += ",A1_CEPE [CEPE], A1_COMPENT [COMPENT], A1_XCANAL [CANAL]  "
	cQuery += "FROM " + RetSqlName("SA1")+ " SA1 "
	cQuery += "WHERE A1_CGC = '"+cCgcCli+"' "
	cQuery += "AND SA1.D_E_L_E_T_ = '' "
	
	cQuery := changequery(cQuery)
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasA1, .F., .T. )
	
	If !(cAliasA1)->(EoF())
		cEnd := (cAliasA1)->ENDE
		cEst := (cAliasA1)->EST
		cMun := (cAliasA1)->MUN
		cBairro := (cAliasA1)->BAIRRO
		cCep := (cAliasA1)->CEP
		cComp := (cAliasA1)->COMPLEMEN
		cCanal := (cAliasA1)->CANAL

		cEndEnt := (cAliasA1)->ENDENT
		cEstE := (cAliasA1)->ESTE
		cMunE := (cAliasA1)->MUNE
		cBairroE := (cAliasA1)->BAIRROE
		cCepE := (cAliasA1)->CEPE
		cCompEnt := (cAliasA1)->COMPENT
	ELSE
		(cAliasA1)->(dbGoTop())
		cEnd := (cAliasA1)->ENDE
		cEst := (cAliasA1)->EST
		cMun := (cAliasA1)->MUN
		cBairro := (cAliasA1)->BAIRRO
		cCep := (cAliasA1)->CEP
		cComp := (cAliasA1)->COMPLEMEN
		cCanal := (cAliasA1)->CANAL
		
		cEndEnt := (cAliasA1)->ENDENT
		cEstE := (cAliasA1)->ESTE
		cMunE := (cAliasA1)->MUNE
		cBairroE := (cAliasA1)->BAIRROE
		cCepE := (cAliasA1)->CEPE
		cCompEnt := (cAliasA1)->COMPENT
	EndIf

	IF cCanal != '000007'
		If !EMPTY(cEndEnt)
			cRet := "Endereco de Entrega: " + ALLTRIM(cEndEnt) +" "+ALLTRIM(cCompEnt)+" - "+ALLTRIM(cCepE)+ " - "+ALLTRIM(cEstE)+" - "+ALLTRIM(cMunE)+" - "+ALLTRIM(cBairroE)
		ELSE
			cRet := "Endereco de Entrega: " + ALLTRIM(cEnd) +" "+ALLTRIM(cComp)+" - "+ALLTRIM(cCep)+ " - "+ALLTRIM(cEst)+" - "+ALLTRIM(cMun)+" - "+ALLTRIM(cBairro)
		ENDIF
	ELSE
		cRet := " "
	ENDIF
Return cRet