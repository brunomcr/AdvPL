#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"
#include "APWEBEX.CH" 
#include "ap5mail.ch" 
#INCLUDE "RWMAKE.CH"
#include "tbicode.ch"
#INCLUDE "DEFEMPSB.CH"
#include "fileio.ch"

#define DS_MODALFRAME   128


#define CRLF chr(13)+chr(10)
/* FUNCAO xPutSx1
Cria uma pergunta no arquivo SX1 que poderá ser usada pelas rotinas padrões.
Sintaxe:
PutSX1 - Criação de pergunta ( [cGrupo][cOrdem][cPergunt][cPerSpa][cPerEng][cVar][cTipo][nTamanho] [ nDecimal ] [ nPresel ][cGSC] [ cValid ] [ cF3 ] [ cGrpSxg ] [ cPyme ] 
[ cVar01 ] [ cDef01 ] [ cDefSpa1 ] [ cDefEng1 ] [ cCnt01 ] [ cDef02 ] [ cDefSpa2 ] [ cDefEng2 ] [ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] [ cDef04 ] [ cDefSpa4 ] 
[ cDefEng4 ] [ cDef05 ] [ cDefSpa5 ] [ cDefEng5 ] [ aHelpPor ] [ aHelpEng ] [ aHelpSpa ] [ cHelp ] )

Retorno: NAO HA

 

 	Nome	 	 	Tipo	 	 	Descrição	 	 	Default	 	 	Obrigatório	 	 	Referência	 
 	cGrupo	 	 	Caracter	 	 	Nome do grupo de pergunta	 	 	 	 	 	X	 	 	 	 
 	cOrdem	 	 	Caracter	 	 	Ordem de apresentação das perguntas na tela	 	 	 	 	 	X	 	 	 	 
 	cPergunt	 	 	Caracter	 	 	Texto da pergunta a ser apresentado na tela.	 	 	 	 	 	X	 	 	 	 
 	cPerSpa	 	 	Caracter	 	 	Texto em espanhol da pergunta a ser apresentado na tela.	 	 	 	 	 	X	 	 	 	 
 	cPerEng	 	 	Caracter	 	 	Texto em inglês da pergunta a ser apresentado na tela.	 	 	 	 	 	X	 	 	 	 
 	cVar	 	 	Caracter	 	 	Variavel do item.	 	 	 	 	 	X	 	 	 	 
 	cTipo	 	 	Caracter	 	 	Tipo do conteúdo de resposta da pergunta.	 	 	 	 	 	X	 	 	 	 
 	nTamanho	 	 	Nulo	 	 	Tamanho do campo para a resposta da pergunta.	 	 	 	 	 	X	 	 	 	 
 	nDecimal	 	 	Numérico	 	 	Número de casas decimais da resposta, se houver.	 	 	0	 	 	 	 	 	 	 
 	nPresel	 	 	Numérico	 	 	Valor que define qual o item do combo estará selecionado na apresentação da tela. Este campo somente poderá ser preenchido quando o parâmetro cGSC for preenchido com "C".	 	 	 	 	 	 	 	 	 	 
 	cGSC	 	 	Caracter	 	 	Estilo de apresentação da pergunta na tela: - "G" - formato que permite editar o conteúdo do campo. - "S" - formato de texto que não permite alteração. - "C" - formato que permite a opção de seleção de dados para o campo.	 	 	 	 	 	X	 	 	 	 
 	cValid	 	 	Caracter	 	 	Validação do item de pergunta.	 	 	 	 	 	 	 	 	 	 
 	cF3	 	 	Caracter	 	 	Nome da consulta F3 que poderá ser acionada pela pergunta.	 	 	 	 	 	 	 	 	 	 
 	cGrpSxg	 	 	Caracter	 	 	Código do grupo de campos relacionado a pergunta.	 	 	 	 	 	 	 	 	 	 
 	cPyme	 	 	Caracter	 	 	 	 	 	 	 	 	 	 	 	 	 
 	cVar01	 	 	Caracter	 	 	Nome do MV_PAR para a utilização nos programas.	 	 	 	 	 	 	 	 	 	 
 	cDef01	 	 	Caracter	 	 	Conteúdo em português do primeiro item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDefSpa1	 	 	Caracter	 	 	Conteúdo em espanhol do primeiro item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDefEng1	 	 	Caracter	 	 	Conteúdo em inglês do primeiro item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cCnt01	 	 	Caracter	 	 	Conteúdo padrão da pergunta.	 	 	 	 	 	 	 	 	 	 
 	cDef02	 	 	Caracter	 	 	Conteúdo em português do segundo item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDefSpa2	 	 	Caracter	 	 	Conteúdo em espanhol do segundo item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDefEng2	 	 	Caracter	 	 	Conteúdo em inglês do segundo item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDef03	 	 	Caracter	 	 	Conteúdo em português do terceiro item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDefSpa3	 	 	Caracter	 	 	Conteúdo em espanhol do terceiro item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDefEng3	 	 	Caracter	 	 	Conteúdo em inglês do terceiro item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDef04	 	 	Caracter	 	 	Conteúdo em português do quarto item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDefSpa4	 	 	Caracter	 	 	Conteúdo em espanhol do quarto item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDefEng4	 	 	Caracter	 	 	Conteúdo em inglês do quarto item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDef05	 	 	Caracter	 	 	Conteúdo em português do quinto item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDefSpa5	 	 	Caracter	 	 	Conteúdo em espanhol do quinto item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	cDefEng5	 	 	Caracter	 	 	Conteúdo em inglês do quinto item do objeto, caso seja Combo.	 	 	 	 	 	 	 	 	 	 
 	aHelpPor	 	 	Vetor	 	 	Help descritivo da pergunta em Português.	 	 	 	 	 	 	 	 	 	 
 	aHelpEng	 	 	Vetor	 	 	Help descritivo da pergunta em Inglês.	 	 	 	 	 	 	 	 	 	 
 	aHelpSpa	 	 	Vetor	 	 	Help descritivo da pergunta em Espanhol.	 	 	 	 	 	 	 	 	 	 
 	cHelp	 	 	Caracter	 	 	Nome do help equivalente, caso já exista algum no sistema.
 	*/

User Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,; 
     cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,; 
     cF3, cGrpSxg,cPyme,; 
     cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,; 
     cDef02,cDefSpa2,cDefEng2,; 
     cDef03,cDefSpa3,cDefEng3,; 
     cDef04,cDefSpa4,cDefEng4,; 
     cDef05,cDefSpa5,cDefEng5,; 
     aHelpPor,aHelpEng,aHelpSpa,cHelp) 

LOCAL aArea := GetArea() 
Local cKey 
Local lPort := .f. 
Local lSpa := .f. 
Local lIngl := .f. 

cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "." 

cPyme    := Iif( cPyme           == Nil, " ", cPyme          ) 
cF3      := Iif( cF3           == NIl, " ", cF3          ) 
cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     ) 
cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      ) 
cHelp      := Iif( cHelp          == Nil, "" , cHelp          ) 

dbSelectArea( "SX1" ) 
dbSetOrder( 1 ) 

// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes. 
// RFC - 15/03/2007 
cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " ) 

If !( DbSeek( cGrupo + cOrdem )) 

    cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt) 
     cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa) 
     cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng) 

     Reclock( "SX1" , .T. ) 

     Replace X1_GRUPO   With cGrupo 
     Replace X1_ORDEM   With cOrdem 
     Replace X1_PERGUNT With cPergunt 
     Replace X1_PERSPA With cPerSpa 
     Replace X1_PERENG With cPerEng 
     Replace X1_VARIAVL With cVar 
     Replace X1_TIPO    With cTipo 
     Replace X1_TAMANHO With nTamanho 
     Replace X1_DECIMAL With nDecimal 
     Replace X1_PRESEL With nPresel 
     Replace X1_GSC     With cGSC 
     Replace X1_VALID   With cValid 

     Replace X1_VAR01   With cVar01 

     Replace X1_F3      With cF3 
     Replace X1_GRPSXG With cGrpSxg 

     If Fieldpos("X1_PYME") > 0 
          If cPyme != Nil 
               Replace X1_PYME With cPyme 
          Endif 
     Endif 

     Replace X1_CNT01   With cCnt01 
     If cGSC == "C"               // Mult Escolha 
          Replace X1_DEF01   With cDef01 
          Replace X1_DEFSPA1 With cDefSpa1 
          Replace X1_DEFENG1 With cDefEng1 

          Replace X1_DEF02   With cDef02 
          Replace X1_DEFSPA2 With cDefSpa2 
          Replace X1_DEFENG2 With cDefEng2 

          Replace X1_DEF03   With cDef03 
          Replace X1_DEFSPA3 With cDefSpa3 
          Replace X1_DEFENG3 With cDefEng3 

          Replace X1_DEF04   With cDef04 
          Replace X1_DEFSPA4 With cDefSpa4 
          Replace X1_DEFENG4 With cDefEng4 

          Replace X1_DEF05   With cDef05 
          Replace X1_DEFSPA5 With cDefSpa5 
          Replace X1_DEFENG5 With cDefEng5 
     Endif 

     Replace X1_HELP With cHelp 

     PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 

     MsUnlock() 
Else 

   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT) 
   lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA) 
   lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG) 

   If lPort .Or. lSpa .Or. lIngl 
          RecLock("SX1",.F.) 
          If lPort 
        SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?" 
          EndIf 
          If lSpa 
               SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?" 
          EndIf 
          If lIngl 
               SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?" 
          EndIf 
          SX1->(MsUnLock()) 
     EndIf 
Endif 

RestArea( aArea ) 

Return

//Consulta Chave NFE
/*
***********************************************
* Progrma: ChkNFxChave   Autor: Caio de Paula  	*
* Descricao: Consulta Chave no Sefaz.   		*
* Data: 06/12/2017                          	*
* Parametros: cChaveNFe						  	*
***********************************************
*/
User Function ChkNFxChave(cChaveNFe)

Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cMensagem:= ""
Local oWS
Local _Ret := .T.

oWs:= WsNFeSBra():New()
oWs:cUserToken   := "TOTVS"
oWs:cID_ENT    := GetIdEnt()
ows:cCHVNFE		 := cChaveNFe
oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

If oWs:ConsultaChaveNFE()
	cMensagem := ""
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
		cMensagem += "Versão: "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
	EndIf
	cMensagem += "Ambiente: "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,"Produção","Homologação")+CRLF //"Produção"###"Homologação"
	cMensagem += "Retorno: "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
	cMensagem += "Msg NFe: "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
		cMensagem += "Protocolo: "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF	
	EndIf
	//Aviso("SPED",cMensagem,{"OK"},3) //Mensagem quando retorno "Autorizado" para a Chave NFE
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3) //Mensagem quando retorna ERRO para a Chave NFE   COMENTAR
	_Ret := .F.
EndIf

Return(_Ret)


//Verifica qual é a entidade
Static Function GetIdEnt() 
Local aArea := GetArea() 
Local cIdEnt := "" 
Local cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250) 
Local lMethodOk := .F. 
Local oWsSPEDAdm 

BEGIN SEQUENCE 
	IF !( CTIsReady(cURL) ) 
		BREAK 
	EndIF 

	cURL := AllTrim(cURL)+"/SPEDADM.apw" 

	IF !( CTIsReady(cURL) ) 
		BREAK 
	EndIF 

	oWsSPEDAdm := WsSPEDAdm():New() 

	oWsSPEDAdm:cUSERTOKEN := "TOTVS" 

	oWsSPEDAdm:oWsEmpresa:cCNPJ := SM0->( IF(M0_TPINSC==2 .Or. Empty(M0_TPINSC),M0_CGC,"") ) 
	oWsSPEDAdm:oWsEmpresa:cCPF := SM0->( IF(M0_TPINSC==3,M0_CGC,"") ) 
	oWsSPEDAdm:oWsEmpresa:cIE := SM0->M0_INSC 
	oWsSPEDAdm:oWsEmpresa:cIM := SM0->M0_INSCM 
	oWsSPEDAdm:oWsEmpresa:cNOME := SM0->M0_NOMECOM 
	oWsSPEDAdm:oWsEmpresa:cFANTASIA := SM0->M0_NOME 
	oWsSPEDAdm:oWsEmpresa:cENDERECO := FisGetEnd(SM0->M0_ENDENT)[1] 
	oWsSPEDAdm:oWsEmpresa:cNUM := FisGetEnd(SM0->M0_ENDENT)[3] 
	oWsSPEDAdm:oWsEmpresa:cCOMPL := FisGetEnd(SM0->M0_ENDENT)[4] 
	oWsSPEDAdm:oWsEmpresa:cUF := SM0->M0_ESTENT 
	oWsSPEDAdm:oWsEmpresa:cCEP := SM0->M0_CEPENT 
	oWsSPEDAdm:oWsEmpresa:cCOD_MUN := SM0->M0_CODMUN 
	oWsSPEDAdm:oWsEmpresa:cCOD_PAIS := "1058" 
	oWsSPEDAdm:oWsEmpresa:cBAIRRO := SM0->M0_BAIRENT 
	oWsSPEDAdm:oWsEmpresa:cMUN := SM0->M0_CIDENT 
	oWsSPEDAdm:oWsEmpresa:cCEP_CP := NIL 
	oWsSPEDAdm:oWsEmpresa:cCP := NIL 
	oWsSPEDAdm:oWsEmpresa:cDDD := Str(FisGetTel(SM0->M0_TEL)[2],3) 
	oWsSPEDAdm:oWsEmpresa:cFONE := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15)) 
	oWsSPEDAdm:oWsEmpresa:cFAX := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15)) 
	oWsSPEDAdm:oWsEmpresa:cEMAIL := UsrRetMail(RetCodUsr()) 
	oWsSPEDAdm:oWsEmpresa:cNIRE := SM0->M0_NIRE 
	oWsSPEDAdm:oWsEmpresa:dDTRE := SM0->M0_DTRE 
	oWsSPEDAdm:oWsEmpresa:cNIT := SM0->( IF(M0_TPINSC==1,M0_CGC,"") ) 
	oWsSPEDAdm:oWsEmpresa:cINDSITESP := "" 
	oWsSPEDAdm:oWsEmpresa:cID_MATRIZ := "" 
	oWsSPEDAdm:oWsOutrasInscricoes:oWsInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New() 

	oWsSPEDAdm:_URL := cURL 

	lMethodOk := oWsSPEDAdm:AdmEmpresas() 

	DEFAULT lMethodOk := .F. 

	IF !( lMethodOk ) 
		cError := IF( Empty( GetWscError(3) ) , GetWscError(1) , GetWscError(3) ) 
		BREAK   
	EndIF 

	cIdEnt := oWsSPEDAdm:cAdmEmpresasResult 

END SEQUENCE 

RestArea(aArea) 

Return( cIdEnt )

/*
*************************************************
* Progrma: Form044   Autor: Caio de Paula  	*
* Descricao: função que gera os dados que vao	* 
* no rel de pedidos de compra  					*
* Data: 06/12/2017                           	*
* Parametros: cFornece, cLoja			    	*
*************************************************
*/

User Function Form044(cFornece,cLoja)
Local cRet:= ""
cRet := "Os Dados Bancarios para Pagamento são: "+;
		"Banco: "+Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_BANCO")+;
		" - Agencia: "+Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_AGENCIA")+;
		" - Conta: "+Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_NUMCON")
Return cRet



/*
*************************************************
* Progrma: transftp   Autor: Caio de Paula  	*
* Descricao: função trata FTP					* 
* no rel de pedidos de compra  					*
* Data: 06/12/2017                           	*
* Parametros: cServer, nPorta cUser, cPass   	*
*************************************************
*/
User Function transftp(cServer, nPorta, cUser, cPass)
Local cLocal := "\tmp\"
cServer := "" //'ftp://ftp.2aliancas.com.br/'
nPorta := ""//nPorta //21
cUser      := ""//'surya@2aliancas.com.br'
cPass      := ""//'2aliancas!!'

              
Private _cAmbAtual := Upper( AllTrim( GetEnvServer() ) )

If     FTPConnect( cServer, nPorta, cUser, cPass )
     Conout('FTP conectado!')
     Conout('Diretorio FTP',FTPGetCurDir())
     Conout('FTPDirChange',FTPDirChange('web/tmp/'))
     FTPGetCurDir()
     FTPDirChange('web/tmp/')
     
     aDirFTP := FTPDIRECTORY( "", )      
     For I:= 1 to LEn(aDirFTP)
          If FTPErase(aDirFTP[1])     
               Conout('Exclusão Ok! ' + aDirFTP[1])
          Else
               Conout('Falha Exclusão!')
          EndIf                  
     Next

     aDirLoc := DIRECTORY( cLocal + "*.txt", )

     For I:=1 to Len(aDirLoc)
          If FTPUpLoad( cLocal + aDirLoc[1], aDirLoc[1] )
               Conout('UpLoad Ok! '+ aDirLoc[1])
          Else
               Conout('Falha UpLoad!'+aDirLoc[1])
          EndIf
     Next

     FTPDisconnect()
Else
     Conout('Falha Conexao!')
EndIf
RETURN
//GERA DADOS PA APROV SCR
/*
*************************************************
* Progrma: GrvLibDoc   Autor: Caio de Paula  	*
* Descricao: Chamada por PE FA050FIN			* 
* no rel de pedidos de compra  					*
* Data: 06/12/2017                           	*
* Parametros: aDadosPa  						*
*************************************************
*/
User Function GrvLibDoc(aDadosPa)
Local aDadSCR	:= {}
DbSelectArea("SAL")
DbSetOrder(1)
if DbSeek(aDadosPa[1]+aDadosPa[10])
	do While !EOF() .And. SAL->AL_COD == aDadosPa[10]
		Aadd(aDadSCR,{aDadosPa[1],aDadosPa[3]+aDadosPa[4]+aDadosPa[5],aDadosPa[2],SAL->AL_USER,SAL->AL_APROV,;
			SAL->AL_NIVEL,"02",aDadosPa[8],aDadosPa[9],aDadosPa[11],SAL->AL_COD,aDadosPa[12]})
	dbskip()
	Enddo
	U_GrSCRMan(aDadSCR)
Else
	MsgAlert("Erro ao incluir PA. Favor Procurar o Administrador!")
endif
Return

/*
***********************************************
* Progrma: GrSCRMan   Autor: Caio de Paula  	*
* Descricao: rotina gerar dados na SCR mata094	*
* Especifica para rotina MATA094 LIb de Doctos 	*
* Data: 06/12/2017                           	*
* Parametros: Array com Dados				  	*
***********************************************
*/
User Function GrSCRMan(aDadSCR)
Local i := 0
For i = 1 to Len(aDadSCR)
	SCR->(RecLock("SCR",.T.))
		SCR->CR_FILIAL 	:= aDadSCR[i][1]
		SCR->CR_NUM		:= aDadSCR[i][2]
		SCR->CR_TIPO	:= aDadSCR[i][3]
		SCR->CR_USER	:= aDadSCR[i][4]
		SCR->CR_APROV	:= aDadSCR[i][5]
		SCR->CR_NIVEL	:= aDadSCR[i][6]
		SCR->CR_STATUS	:= aDadSCR[i][7]
		SCR->CR_TOTAL	:= aDadSCR[i][8]
		SCR->CR_EMISSAO	:= aDadSCR[i][9]
		SCR->CR_MOEDA	:= aDadSCR[i][12]
		SCR->CR_OBS		:= aDadSCR[i][10]
		SCR->CR_GRUPO	:= aDadSCR[i][11]
		SCR->CR_ESCALON	:= .F.
		SCR->CR_ESCALSP := .F.
	SCR->(MsUnlock())
Next
Return


//--------------------------------------------------------------
/*/{Protheus.doc} TlApr094                                    
Description  tela de aprovação documentos SCR em compras                                                   
                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author TESTE - caio                                         
@since 28/05/2018                                                   
/*/                                                             
//--------------------------------------------------------------
User Function TlApr094() 
local nOpc		:= 0 
local nRecno   	:= SCR->(Recno())  
local c_Fil		:= SCR->CR_FILIAL  
local cStat		:= ""    
Local aMotivo	                      
Static oDlg
Static oButton1
Static oButton2
Static oButton3
Static oGet1
Static cGet1 := SCR->CR_TIPO
Static oGet2
Static cGet2 := SUBSTR(SCR->CR_NUM,1,3)
Static oGet3
Static cGet3 := SUBSTR(SCR->CR_NUM,4,9)
Static oGet4
Static cGet4 := SUBSTR(SCR->CR_NUM,13,2)
Static oGet5
Static cGet5 := space(30)
Static oGet6
Static cGet6 := SCR->CR_OBS
Static oGet7
Static cGet7 := iif(SCR->CR_MOEDA <> 1,xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,1,dDataBase),SCR->CR_TOTAL)
Static oGet8
Static cGet8 := SCR->CR_EMISSAO
Static oGet9
Static cGet9 := space(TamSX3("E2_NOMFOR")[1])
Static oSay1
Static oSay2
Static oSay3
Static oSay4
Static oSay5
Static oSay6
Static oSay7
Static oSay8
Static oSay9

DbSelectArea("SE2")
DbSetOrder(1)
if DbSeek(SCR->CR_FILIAL+substr(SCR->CR_NUM,1,14)+SCR->CR_TIPO)
	cGet5	:= Substr(FWLeUserlg("E2_USERLGI"),1,30)
	cGet9	:= SE2->E2_NOMFOR
else
	MsgAlert("Algum erro ocorreu, favor contatar o Administrador!")
	Return
Endif


  DEFINE MSDIALOG oDlg TITLE "Aprovação de Pedidos Financeiros" FROM 000, 000  TO 250, 430 COLORS 0, 16777215 PIXEL

    @ 013, 004 SAY oSay1 PROMPT "Tipo:" SIZE 013, 011 OF oDlg COLORS 0, 16777215 PIXEL
    @ 013, 018 MSGET oGet1 VAR cGet1 SIZE 016, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 013, 040 SAY oSay2 PROMPT "Prefixo:" SIZE 023, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 013, 061 MSGET oGet2 VAR cGet2 SIZE 023, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 013, 090 SAY oSay3 PROMPT "Numero:" SIZE 023, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 013, 114 MSGET oGet3 VAR cGet3 SIZE 043, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 013, 162 SAY oSay4 PROMPT "Parcela:" SIZE 023, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 013, 185 MSGET oGet4 VAR cGet4 SIZE 015, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 033, 004 SAY oSay5 PROMPT "Usuario:" SIZE 022, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 032, 036 MSGET oGet5 VAR cGet5 SIZE 092, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 050, 004 SAY oSay6 PROMPT "Descrição:" SIZE 031, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 050, 036 MSGET oGet6 VAR cGet6 SIZE 164, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 068, 004 SAY oSay7 PROMPT "Valor:" SIZE 016, 012 OF oDlg COLORS 0, 16777215 PIXEL
    @ 068, 023 MSGET oGet7 VAR cGet7 PICTURE "@E 999,999.99" SIZE 052, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 068, 082 SAY oSay8 PROMPT "Emissao:" SIZE 032, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 068, 116 MSGET oGet8 VAR cGet8 SIZE 043, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F. 
    @ 089, 004 SAY oSay9 PROMPT "Fornecedor:" SIZE 030, 011 OF oDlg COLORS 0, 16777215 PIXEL
    @ 088, 036 MSGET oGet9 VAR cGet9 SIZE 164, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    @ 104, 074 BUTTON oButton1 PROMPT "Aprovar" SIZE 038, 011 OF oDlg PIXEL ACTION (nOpc := 1, oDlg:End())
    @ 104, 118 BUTTON oButton2 PROMPT "Rejeitar" SIZE 038, 010 OF oDlg PIXEL ACTION (nOpc := 2, oDlg:End())
    @ 104, 163 BUTTON oButton3 PROMPT "Cancelar" SIZE 038, 011 OF oDlg PIXEL ACTION (nOpc := 0, oDlg:End())
  ACTIVATE MSDIALOG oDlg
  
if nOpc == 1 //03 - 05 Aprovar
	DbSelectArea("SCR")
	DbSetOrder(1)
	if DbSeek(c_Fil+"PA"+cGet2+cGet3+cGet4)
		Do While !EOF() .And. alltrim(CR_NUM) == Alltrim(cGet2+cGet3+cGet4)
			SCR->(RecLock("SCR",.F.))
				SCR->CR_DATALIB := DDATABASE
				SCR->CR_USERLIB	:= __cUserID
				if SCR->CR_USER == __cUserID
					cStat 			:= "03"
					SCR->CR_STATUS 	:= "03"
					SCR->CR_VALLIB 	:= SCR->CR_TOTAL
					SCR->CR_TIPOLIM := "D"
					SCR->CR_LIBAPRO := Posicione("SAL",4,c_Fil+SCR->CR_GRUPO+__cUserID,"AL_APROV")
				else
					SCR->CR_STATUS := "05"
				endif					
			SCR->(MsUnlock())
		dbskip()
		Enddo
	else
		MsgAlert("Algum erro ocorreu, favor contatar o Administrador!")
	endif		
elseif nOpc == 2 //06 - 05 Rejeitar
	u_TELREJM(@aMotivo)
  	DbSelectArea("SCR")
	DbSetOrder(1)
	if DbSeek(c_Fil+"PA"+cGet2+cGet3+cGet4)
		Do While !EOF() .And. alltrim(CR_NUM) == Alltrim(cGet2+cGet3+cGet4)
			SCR->(RecLock("SCR",.F.))
				SCR->CR_DATALIB := DDATABASE
				SCR->CR_USERLIB	:= __cUserID
				if SCR->CR_USER == __cUserID
					cStat 			:= "06"
					SCR->CR_STATUS 	:= "06"
					SCR->CR_LIBAPRO := Posicione("SAL",4,c_Fil+SCR->CR_GRUPO+__cUserID,"AL_APROV")
				else
					SCR->CR_STATUS := "05"
				endif
				//MSMM(,,,aMotivo,1,,,"SCR","CR_OBS")
				SCR->CR_OBS	:= aMotivo						
			SCR->(MsUnlock())
		dbskip()
		Enddo
	else
		MsgAlert("Algum erro ocorreu, favor contatar o Administrador!")
	endif
Endif
Return cStat

User Function TELREJM(aMotivo)
Local nOpc	:= 0
Private oDlg2
Private oMotivo
Private oButton1 
Private oGroup1
Private oSay1
DEFINE MSDIALOG oDlg2 TITLE "Rejeicao Pagamento Antecipado" FROM 000, 000  TO 205, 350 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
	oDlg2:lEscClose := .F.
	@ 005, 002 GROUP oGroup1 TO 100, 170 PROMPT "Motivo da Rejeicao    " OF oDlg2 COLOR 0, 16777215 PIXEL
	@ 024, 008 Get oMotivo VAR aMotivo MEMO SIZE 157, 039 OF oDlg2 COLORS 0, 16777215 PIXEL
	@ 013, 008 SAY oSay1 PROMPT "Informe aqui o Motivo da Rejeicao do PA: "SIZE 120, 008 OF oDlg2 COLORS 0, 16777215 PIXEL
	@ 008, 033 BUTTON "Confirma" SIZE 033, 012 OF oDlg2 Action(iif(Empty(Alltrim(aMotivo)),MsgAlert("Escreva o motivo da Rejeicao"),oDlg2:End()))
ACTIVATE MSDIALOG oDlg2
Return


//envia email de aprovacao ou desaprovacao de documentos em compras
/*
***********************************************
* Progrma: Env094   Autor: Caio de Paula  		*
* Descricao: rotina para envio de email  		*
* Especifica para rotina MATA094 LIb de Doctos 	*
* Data: 06/12/2017                           	*
* Parametros: EMail Origem, EMail Destino,   	*
*             Subject, Body, Anexo, .T., Bcc  	*
***********************************************
*/
User Function Env094(cNum,cTipo ,cStatus)
Local _pcOrigem		:= ""
Local _pcDestino	:= ""
Local _pcSubject	:= ""
Local _pcBody		:= ""
Local _pcArquivo	:= ""
Local _plAutomatico	:= ""
Local _pcBcc		:= ""
Local cDescSta		:= iif(cStatus=="03","Liberado","Rejeitado")
Local cGrpAprov		:= POSICIONE("SCR",1,xFilial("SCR")+cTipo+cNum,"CR_GRUPO")
Local cMotRej		:= POSICIONE("SCR",1,xFilial("SCR")+cTipo+cNum,"CR_OBS")

	_pcOrigem	:= ""
	_pcDestino 	:= u_MailSAL(cGrpAprov,cStatus)
	IF cTipo == "PC"
		DbSelectArea("SC7")
		DbSetOrder(1)
		if DbSeek(xFilial("SC7")+cNum)
			DbSelectArea("SC1")
			DbSetOrder(1)
			if DbSeek(xFilial("SC1")+SC7->C7_NUMSC)
				_pcDestino += UsrRetMail(SC1->C1_USER)
			endif
		endif
	Endif
	_pcSubject 	:= "Protheus - Aprovacao/Rejeicao de Documentos"
	//_pcDestino	:= "caio.santos@suryabrasil.com"
	_pcBody		:= "<h2><strong>Empresa "+ FWLoadSM0()[1][7] +"</h2><br>"
	_pcBody		:= "<h2><strong>O documento "+Alltrim(cNum)+ " foi " + cDescSta
	_pcBody		+= "</h2></strong><br><br>"
	if cStatus <> "03"
		_pcBody		+= "<strong>Motivo: "+cMotRej+"</strong><br><br>"
	endif
	_pcBody		+= "<u>Favor continuar com os procedimentos</u>"	
	_plAutomatico := .T.
	_pcBcc		:= ""
	_pcArquivo := NIL
	//enviaporemail
	U_SBENVMAIL(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
Return

/*
***********************************************
* Progrma: SBENVMAIL   Autor: Caio de Paula  *
* Descricao: rotina para envio de email.   *
* Data: 06/12/2017                           *
* Parametros: EMail Origem, EMail Destino,    *
*             Subject, Body, Anexo, .T., Bcc  *
***********************************************
*/ 
//Função para enviar email
User Function SBENVMAIL(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArq,_plAutomatico,_pcBcc,_cAccount,_cPassword)
// Variaveis da funcao
//**************************************************************


Private _nTentativas := 0
Private _pcOrigem 	 := IIF(Empty(_pcOrigem),GetMV("MV_RELFROM"),_pcOrigem)
Private _cSMTPServer := GetMV("MV_RELSERV")//+":25"
Private _cAccount    := IIF(Empty(_cAccount),GetMV("MV_RELACNT"),_cAccount)
Private _cPassword   := IIF(Empty(_cPassword),GetMV("MV_RELPSW"),_cPassword)
Private _lEnviado    := .F.

// Validacao dos campos do email
//**************************************************************
If _pcBcc == NIL
	_pcBcc := ""
EndIf

_pcBcc := StrTran(_pcBcc," ","")

If _pcOrigem == NIL
	
EndIf

_pcOrigem := StrTran(_pcOrigem," ","")

If _pcDestino == NIL
	_pcDestino := "caio.santos@suryabrasil.com"
EndIf

_pcDestino := StrTran(_pcDestino," ","")

If _pcSubject == NIL
	_pcSubject := "Sem Subject (ENVMAIL)"
EndIf

If _pcBody == NIL
	_pcBody := "Sem Body (ENVMAIL)"
EndIf

If _pcArq == NIL
	_pcArq := ""
EndIf

For _nAux := 1 To 10
	_pcOrigem := StrTran(_pcOrigem," ;","")
	_pcOrigem := StrTran(_pcOrigem,"; ","")
	_pcOrigem := StrTran(_pcOrigem,";;","")	
Next
If _plAutomatico == NIL
	_plAutomatico := .F.
EndIf
if left(_pcOrigem,1) == ";"
	_pcOrigem := substr(_pcOrigem,2,len(_pcOrigem))
endif
// Executa a funcao, mostrando a tela de envio (.T.) ou nao (.F.)
//**************************************************************
	_lEnviado := U_EnvEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArq,_plAutomatico,_pcBcc,_cAccount,_cPassword)
	
Return _lEnviado

/*
***********************************************
* Progrma: EnvEmail   Autor: Caio de Paula  	*
* Descricao: Subrotina para envio de email.   	*
* Data: 06/12/2017                           	*
* Parametros: EMail Origem, EMail Destino,    	*
*             Subject, Body, Anexo, .T., Bcc  	*
***********************************************
*/ 
User Function EnvEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,aAnexos,_plAutomatico,_pcBcc,_cAccount,_cPassword)
// Veriaveis da funcao
//**************************************************************
Local _nTentMax := 50  // Tentativas maximas
Local _nSecMax  := 30  // Segundos maximos  
Local _cTime    := (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
Local _nAuxTime := 0
Local cLog		:= ""
Local lUsaTLS	:= .T.
Local lRet		:= .T.
Local nPort		:= "587"
// O que ocorrer primeiro (segundos ou tentativas), ele para.
//**************************************************************
_cTime += _nSecMax

If !_plAutomatico
	ProcRegua(_nTentMax)
EndIf

// Exibe mensagem no console/Log
//**************************************************************
//ConOut("ENVMAIL=> ***** Envio de Email ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject))
cLog += "ENVMAIL=> ***** Envio de Email ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)
For _nTentativas := 1 To _nTentMax
	
	If !_plAutomatico
		IncProc("Tentativa "+AllTrim(Str(_nTentativas)))
	EndIf
	//ConOut("ENVMAIL=> ***Tentativa "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject))
	cLog += "ENVMAIL=> ***Tentativa "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)
	
	CONNECT SMTP SERVER _cSMTPServer ACCOUNT _cAccount PASSWORD _cPassword RESULT _lEnviado
	
	If _lEnviado
		If !MailAuth(_cAccount,_cPassword)
        	Get Mail Error cErrorMsg
          	Help("",1,"AVG0001056",,"Error: "+cErrorMsg,2,0)
          	Disconnect Smtp Server Result _lEnviado
          	if !_lEnviado
               Get Mail Error cErrorMsg
               Help("",1,"AVG0001056",,"Error: "+cErrorMsg,2,0)
          	endif
          	Return ( .f. )
     	EndIf
		If Empty(_pcBcc)
			If Empty(aAnexos)
				SEND MAIL FROM _pcOrigem TO _pcDestino SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado
			Else
				SEND MAIL FROM _pcOrigem TO _pcDestino SUBJECT _pcSubject BODY _pcBody ATTACHMENT aAnexos FORMAT TEXT RESULT _lEnviado
			EndIf
		Else
			If Empty(aAnexos)
				SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado
			Else
				SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody ATTACHMENT aAnexos FORMAT TEXT RESULT _lEnviado
			EndIf
		EndIf
		DISCONNECT SMTP SERVER
	EndIf
	
	If _lEnviado .Or. _cTime <= (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
		_nTentativas := _nTentMax
	EndIf	
Next
If !Empty(aAnexos)
	if valtype(aAnexos)=='A'
		for i=1 to len(aAnexos)
			FErase(aAnexos[i])
		next
	else
		FErase(_pcArquivo)
	endif
endif
cLog += "ENVMAIL=> ***** Resultado de Envio "+IIf(_lEnviado,"T","F")+" / "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)
If !Empty(cLog)
        cLog := "EnvMail - "+dToC(Date())+ " " + Time() + CRLF + ;
            "Funcao - " + FunName() + CRLF + CRLF +;
            "Existem mensagens de aviso: "+ CRLF +;
            cLog
        ConOut(cLog)
ENDIF
Return lRet //(IIf(_lEnviado,"T","F"))

//gera arquivo em excel
/*
***********************************************
* Progrma: Run_Excel   Autor: Caio de Paula  	*
* Descricao: Subrotina para envio de email.   	*
* Data: 06/12/2017                           	*
* Parametros: aDadosExcel = Array com os dados 	*
*             nCol = Numero de colunas no CSV	*
***********************************************
*/ 
User Function Run_Excel(aDadosExcel,nCol,cSepara)
LOCAL cDirDocs   := MsDocPath() 
Local aStru		:= {}
Local cArquivo := CriaTrab(,.F.)
//Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX
local _pcArquivo	
local cSeparador := cSepara
ProcRegua(Len(aDaDosExcel))

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

If nHandle > 0
	

	For nX := 1 to Len(aDadosExcel)
  
		IncProc("Aguarde! Gerando arquivo de integracao com Excel...") // 
		cBuffer := ""
		For nY := 1 to nCol  //Numero de Colunas do Vetor

            cBuffer += aDadosExcel[nX,nY] + cSeparador

		Next 
		fWrite(nHandle, cBuffer+cCrLf ) // Pula linha
		
	Next
	
	IncProc("Aguarde! Abrindo o arquivo...") // 
	
	fClose(nHandle)

   //	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	_pcArquivo :=cDirDocs+"\"+cArquivo+".CSV"
	
 /*	If ! ApOleClient( 'MsExcel' ) 
		MsgAlert( 'MsExcel nao instalado' ) //
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)     */
Else
	MsgAlert( "Falha na criacao do arquivo" ) // 
Endif	

Return(_pcArquivo)

/*
***********************************************
* Progrma: Run_Excel   Autor: Caio de Paula  	*
* Descricao: Retorna email que ira receber apos	*
*  Liberação ou rejeicao do MATA094				*
* Data: 06/12/2017                           	*
* Parametros: cGrpAprov = Grupo de aprov do Doc	*
			Status = Status se rejeicao ou lib	*
***********************************************
*/ 

user Function MailSAL(cGrpAprov,cStatus)
Local cMails 	:= ""
Local aUsers	:= {}
Local aDadosU	:= {}
Local cGrpLib	:= SupergetMV("SB_GRDOCLI",.F.,"000006")
Local cGrpRej	:= SupergetMV("SB_GRDOCRE",.F.,"000006")
DbSelectArea("SAL")
DbSetOrder(1)
If Dbseek(xFilial("SAL")+cGrpAprov)
	Do While !EOF() .And. AL_COD == cGrpAprov
		cMails += UsrRetMail( AL_USER )+";"
		Aadd(aUsers,AL_USER)
	SAL->(DbSkip())
	Enddo
	cMails := Substr(cMails,1,Len(Alltrim(cMails))-1)
Endif
if cStatus <> nil
	if cStatus == "03"
		aDadosU := FWSFGrpUsers(cGrpLib)
		For i = 1 to len(aDadosU)
			cMails += ";"+UsrRetMail( aDadosU[i] )
		Next
	else
		aDadosU := FWSFGrpUsers(cGrpRej)
		For i = 1 to len(aDadosU)
			cMails += ";"+UsrRetMail( aDadosU[i] )
		Next
	endif
Endif
Return cMails

User Function xTestx
Local aDados := FWSFGrpUsers('000001')
	//X31UPDTABLE("SZ1")
Return

User Function RelacPAPC(aDadosPa)
local nX	:= 0
Local oGet1
Local cGet1 := space(TamSX3("C7_NUM")[1])
Local oSay2
Local oSButton1
Local oSButton2
Local nOpca := 0
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "PA x PC" FROM 000, 000  TO 120, 165 COLORS 0, 16777215 PIXEL

    @ 012, 012 SAY oSay2 PROMPT "Pedido de Compra" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 022, 012 MSGET oGet1 VAR cGet1 SIZE 048, 010 OF oDlg COLORS 0, 16777215 F3 "SC7" VALID U_VALPC(cGet1) PIXEL
    DEFINE SBUTTON oSButton1 FROM 036, 043 TYPE 02 ACTION (nOpca := 2, oDlg:End())  OF oDlg ENABLE
    DEFINE SBUTTON oSButton2 FROM 036, 012 TYPE 01 ACTION (nOpca := 1, oDlg:End())  OF oDlg ENABLE

  ACTIVATE MSDIALOG oDlg CENTERED	
If nOpca == 1
	RecLock("FIE",.T.)
		FIE->FIE_FILIAL 	:= aDadosPa[1]
		FIE->FIE_CART		:= "P"
		FIE->FIE_PEDIDO		:= cGet1
		FIE->FIE_PREFIX		:= aDadosPa[3]
		FIE->FIE_NUM		:= aDadosPa[4]
		FIE->FIE_PARCEL		:= aDadosPa[5]
		FIE->FIE_TIPO		:= aDadosPa[2]
		FIE->FIE_FORNEC		:= aDadosPa[6]
		FIE->FIE_LOJA		:= aDadosPa[7]
		FIE->FIE_VALOR		:= aDadosPa[8]
		FIE->FIE_SALDO		:= aDadosPa[8]	
	MsUnlock()
	MsgAlert("O Pedido: "+cGet1+" foi relacionado ao PA")
	AADD(aDadosPa,cGet1)	
	U_SBC0002(aDadosPa)
endif
Return
User Function VALPC(cGet1)
Local lRet := .F.
if ExistCpo("SC7",Alltrim(cGet1))
	lRet := .T.
Endif
Return lRet
//Inclusão de coluna do SA1
User function ColSA1(cSeekOrd1,cCampo)
Return POSICIONE("SA1", 1, xFilial("SA1") + &(cSeekOrd1), cCampo)
//Inclusão de coluna do SB1
User function ColSB1(cSeekOrd1,cCampo)
Return POSICIONE("SB1", 1, xFilial("SB1") + &(cSeekOrd1), cCampo)


/*
***********************************************
* Progrma: CriaLog    Autor: Caio de Paula  	*
* Descricao: Retorna email que ira receber apos	*
*  Liberação ou rejeicao do MATA094				*
* Data: 03/07/2019                           	*
* Parametros: cGrpAprov = Grupo de aprov do Doc	*
			Status = Status se rejeicao ou lib	*
***********************************************
*/ 
User Function CriaLog(cNomArq,cTexto)
//local cNomArq := 'teste'
//local cTexto := 'teste2'
Local cFile := "\system\"+cNomArq+dToS(Date())+".log"
Local nH 

if !file(cFile)
	nH := fCreate(cFile) 
	If nH == -1 
		Conout("Falha ao criar arquivo - erro "+str(ferror()))
		Return 
	Endif 
	// Escreve o texto mais a quebra de linha CRLF 
	fWrite(nH, Funname()+"-"+cTexto + chr(13)+chr(10) ) 

	fClose(nH) 

else    
 nH := fopen(cFile , FO_READWRITE + FO_SHARED )
  If nH == -1
    Conout('Erro de abertura : FERROR '+str(ferror(),4))
  Else
    FSeek(nH, 0, FS_END)         // Posiciona no fim do arquivo
    FWrite(nH, Funname()+"-"+cTexto + chr(13)+chr(10) , Len(Funname()+"-"+cTexto + chr(13)+chr(10)) ) // Insere texto no arquivo
    fclose(nH)                   // Fecha arquivo
  Endif
 EndIf

Return

User Function zTiraZeros(cTexto)//tira zeros a esquerda
    Local aArea     := GetArea()
    Local cRetorno  := ""
    Local lContinua := .T.
    Default cTexto  := ""
 
    //Pegando o texto atual
    cRetorno := Alltrim(cTexto)
 
    //Enquanto existir zeros a esquerda
    While lContinua
        //Se a priemira posição for diferente de 0 ou não existir mais texto de retorno, encerra o laço
        If SubStr(cRetorno, 1, 1) <> "0" .Or. Len(cRetorno) ==0
            lContinua := .f.
        EndIf
         
        //Se for continuar o processo, pega da próxima posição até o fim
        If lContinua
            cRetorno := Substr(cRetorno, 2, Len(cRetorno))
        EndIf
    EndDo
     
    RestArea(aArea)
Return cRetorno
