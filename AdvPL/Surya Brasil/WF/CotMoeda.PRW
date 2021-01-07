#INCLUDE "Protheus.CH"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"


User Function CotacaoMoedas()
  //Variaveis Locais
Local oCotacaoMoedas:= Nil
Local cRetCotMoeda	:= ""
Local cAvisos		:= ""
Local cErros		:= ""
Local cReplace		:= ""
Local oXMLCotMoeda	:= Nil
Local dDataCotacao	:= StoD("")  
Local nCotacaoMoeda	:= 0
Local n				:= 0
Local lAtzDolar		:= .F.
Local aMoeda		:= {10813,21620}	//dolar compra, euro compra	
Local aCotacao		:= {}
Local xEmp			:= "01"
Local xFil			:= "00"
/*RPCSetType(3)    
If FindFunction('WFPREPENV')
	lAuto := .T.      
	RPCSetType( 3 )						// Não consome licensa de uso
	wfPrepENV(xEmp, xFil)
Else
	lAuto := .T.
	RPCSetType( 3 )						// Não consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil
Endif*/

//Instanciacao do WsClient de Moeda do Fonte WCCotacaoMoedas.prw
oCotacaoMoedas   := WSFachadaWSSGSService():New()
//Setado o Codigo 10813 respectivo ao Dolar (Compra)
For n=1 to len(aMoeda)
	oCotacaoMoedas:nin0 := aMoeda[n]
	//Verificamos se o metodo getUltimoValorXML do WsClient WSFachadaWSSGSService foi consumido com sucesso
	If (oCotacaoMoedas:getUltimoValorXML())
		//Obtem o retorno de cotacao da Moeda no formato XML
		cRetCotMoeda := oCotacaoMoedas:cgetUltimoValorXMLReturn 
		//Utiliza a funcao XmlParser para converter o retorno XML do WS para uma variavel do Tipo Objeto
		oXMLCotMoeda :=  XmlParser(cRetCotMoeda, cReplace, @cErros, @cAvisos)  
		//Verifica se houve erro ao consumir o WS
		If AllTrim(cErros) == ""
			//Obtem a Data da Ultima Cotacao
			dDataCotacao := StoD(oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_ANO:TEXT + AjDzero(oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_MES:TEXT) + AjDzero(oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_DIA:TEXT))
			//Obtem o Valor da Ultima Cotacao
			nCotacaoMoeda := Val(StrTran(oXMLCotMoeda:_RESPOSTA:_SERIE:_VALOR:TEXT, ",", "."))
			//Abre o Ordena a Tabela de Moedas - SM2
			Aadd(aCotacao,{dDataCotacao,nCotacaoMoeda,AvalMoeda(aMoeda[n])})			
			//Operacao realizada com sucesso
			lAtzDolar := .T.
		EndIf
	EndIf
Next
if lAtzDolar
	For n = 1 to len(aCotacao)
		DBSelectArea("SM2")
		SM2->(DBSetOrder(1))
		IF DBSeek(DtoS(aCotacao[n][1]))
			RecLock("SM2", .F.)
		ELSE
		 	RecLock("SM2", .T.)
		ENDIF 
			//Atualiza a Data, Valor (no caso o Dolar e a Moeda 2, mas isso depende da configuracao), e a nao abertura da Tela de Cotacao na entrada do sistema
			SM2->M2_DATA  			:= aCotacao[n][1]
			SM2->&(aCotacao[n][3])	:= aCotacao[n][2]
			SM2->M2_INFORM  		:= "S"
			//Libera o registro alterado
		SM2->(MsUnLock())
	Next
endif
Return ()
Static function AvalMoeda(nMoeda)
Local cMoeda	:= ""
if nMoeda == 10813
	cMoeda	:= "M2_MOEDA2"
elseif nMoeda == 21620
	cMoeda	:= "M2_MOEDA4"
endif
Return(cMoeda)
Static Function AjDzero(cData)
Local cdAj
if Valtype(cData) <> "N"
	cdAj	:= strzero(val(cData),2)
else
	cdAj	:= strzero(cData,2)
endif
Return cdAj
