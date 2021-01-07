#include "PROTHEUS.CH"
#include "TOPCONN.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"

User FuncTion GSchFret(aParam)
// Rotina de importacao
// U_GSchFret({"99","01",.T.})        
xx:="1"
private yFil := aParam[2]

IF FindFunction("WFPREPENV")                                                 
	WFPREPENV(aParam[1], aParam[2])
ELSE
	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
ENDIF
// Define Variaveis
Private tTabOCO				// Tabela temporária do conhecimento
Private aCamposOCO := {}	// Campos da tabela intermediária de CTRC
Private a_Notifi   := {}    // Notificação Logistica / Cliente
/*
dbSelectArea("SZ4")
dbGoTop()
While !SZ4->(EOF())
	RecLock("SZ4", .F.)
	SZ4->Z4_MARKBR := ""
	MsUnlock()
	SZ4->(dbSkip())
EndDo
*/
Pergunte("GOFRT001",.F.)
// MV_PAR01 := Transportador De
// MV_PAR02 := Transportador Até
// MV_PAR03 := Filial Ocorrências
// MV_PAR04 := Dir. Importação
// MV_PAR05 := Dir. Backup OK
// MV_PAR06 := Dir. Backup Erros

CriaTbOco()         // Cria Temporario

Impoco()            // Importando arquivos ocorrencias

GFEDelTab(tTabOCO)  // Apaga temporario

Env_Not(a_Notifi)   // Envia Notificações de acordo com cadastro de ocorrencias

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} Importacao
EDI - Importação de Ocorrências
@author Francisco Godinho
@since 14/07/13
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function Impoco()
Local aDirImpor   := {}		// Array com os arquivos do diretorio
Local nCountFiles := 0  	// Contador dos arquivos do diretorio
Local lArquivoValido
Local cLayoutVer  := "" 	// Versão do Layout 3 ou 5
Local cFormatDt
Local cFormatTm
Local cNewNomeArq	:= ""
Local cDiretorio	:= AllTrim(MV_PAR04)
Local cDirOk		:= AllTrim(MV_PAR05)
Local cDirErro		:= AllTrim(MV_PAR06)
Private cFilialOcor
Private cNomeArq
Private nNRIMP		:= 0
Private nCountImpor := 0  	// Contador de arquivos importados
Private cMsgPreVal	:= ""	// Armazena as mensagens de pré-validações para o Campo Observação (Importação)

cFilialOcor := MV_PAR03

// Validação do diretório de importação
If Empty(cDiretorio)
	CONOUT("** " + "Diretório de importação deve ser informado.")
	Return
EndIf

aDirImpor := DIRECTORY(cDiretorio + "\*.TXT" )
// Verifica se existe arquivos no diretório informado
If Len(aDirImpor) == 0
	CONOUT("Nenhum arquivo encontrado no diretório " + cDiretorio, "Aviso")
	Return
Endif
// Data e Hora
cFormatDt := stuff(DTOC(date()),3,1,'')
cFormatDt := stuff(cFormatDt,5,1,'')

cFormatTm := stuff(Time(),3,1,'')
cFormatTm := stuff(cFormatTm,5,1,'')

CONOUT("- Início da importação")

For nCountFiles := 1 To Len(aDirImpor)
	lArquivoValido := .T.
	cNomeArq  	:= aDirImpor[nCountFiles][1]

	CONOUT("[" + ALLTRIM(STR(nCountFiles)) + "] Arquivo: " + cNomeArq)
	FT_FUSE(cDiretorio + "\" + cNomeArq)
	FT_FGOTOP()
	cBuffer := FT_FREADLN()
	// Verifica se é um arquivo válido. Identificador '000' e sigla 'COCO'
	If SubStr(cBuffer,01,03) == "000" .And. SubStr(cBuffer,84,03) != "OCO"
		CONOUT("Arquivo '" + cNomeArq + "' inválido.")
		FT_FUSE()
		lArquivoValido := .F.
	EndIf
	// Validação da versão do Layout
	If lArquivoValido
		FT_FSKIP()
		cBuffer := FT_FREADLN()
		// Identifica a versão Layout do arquivo
		cLayoutVer := SubStr(cBuffer, 01, 03)
		// Valida a versão do layout do arquivo
		If (cLayoutVer != "340" .AND. cLayoutVer != "540") .OR. Empty(cLayoutVer)
			CONOUT("Arquivo '" + cNomeArq + "' com formato inválido ou layout incompatível com o sistema.")
			FT_FUSE() // Fecha o arquivo
			lArquivoValido := .F.
		EndIf
	EndIf
	// Leitura do Arquivo e Gravação do Arquivo
	If lArquivoValido
		If cLayoutVer == "340"
			LOcoPro3()
		EndIf
		// Fecha o Arquivo
		FT_FUSE()
		// Gravação para na tabela intermediária
		GerarSZ4()
	EndIf
	// Transferência do arqivos para os diretórios de Ok e NOk
	cNewNomeArq := cFormatDt + "_" + cFormatTm + "_" + cNomeArq
	If lArquivoValido //se chegar ao fim do arquivo sem erros
		If (FRename(cDiretorio + "\" + cNomeArq, cDirOk + "\" + cNewNomeArq) == -1)
			CONOUT("Erro ao mover arquivo '" + cDiretorio + "\" + cNomeArq  + "' para o diretório " + cDirOk + "\" + cNewNomeArq)
		EndIf
	Else
		If (FRename(cDiretorio + "\" + cNomeArq, cDirErro + "\" + cNewNomeArq) == -1)
			CONOUT("Erro ao mover arquivo '" + cDiretorio + "\" + cNomeArq  + "' para o diretório " + cDirErro + "\" + cNewNomeArq)
		EndIf
	EndIf
Next

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} CriaTbOco
Criação das tabelas temporárias
@author Francisco Godinho
@since 11/07/13
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function CriaTbOco()
aCamposOCO := {	{"Z4_FILIAL", "C", TamSx3("Z4_FILIAL")[1], 0}	,{"Z4_NRIMP" , "C", 16, 0},;
				{"Z4_FILOCO", "C", TamSx3("Z4_FILIAL")[1], 0}	,{"Z4_CDTRP" , "C", 14, 0},;
				{"Z4_DTOCOR", "D", 8 , 0}                      ,{"Z4_HROCOR", "C", 5 , 0},;
				{"Z4_FILDC" , "C", TamSx3("Z4_FILIAL")[1], 0}	,{"Z4_EMISDC", "C", 14, 0},;
				{"Z4_SERDC" , "C", 3 , 0}						,{"Z4_NRDC"  , "C", 9 , 0},;
				{"Z4_CODOCO", "C", 2 , 0}						,{"Z4_OBS"   , "C", 70, 0},;
				{"Z4_EDISIT", "C", 1,  0}						,{"Z4_EDIMSG", "M", 10, 0},;
				{"Z4_EDINRL", "N", 5 , 0}						,{"Z4_EDILIN", "M", 999, 0},;
				{"Z4_EDIARQ", "C", 200, 0}						,{"Z4_CODOBS", "N", 2 , 0};
			  }

tTabOCO := GFECriaTab({aCamposOCO,{"Z4_FILIAL+Z4_NRIMP"}})

Return
//-------------------------------------------------------------------
/*/{Protheus.doc} LOcoPro3
EDI - Importação de Documento de Frete
@author Francisco Godinho
@since 10/06/10
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function LOcoPro3()
Local nContLinhas := 0 		// Contador de Linhas do arquivo
Local lFlag     := .T.
Local lSelecao  := .T.
Local cCGCTrp
Local cCdTrp
Local cCdEmis
Local cFilDc
Local cBuffer   := ""
While !FT_FEOF()
	nContLinhas++
	// Verificação da faixa do Transportador
	If SubStr(cBuffer,01,03) == "341"
		lSelecao := .F.
		cCGCTrp := AllTrim(SubStr(cBuffer,04,14))
		cCdTrp  := Posicione("SA4", 3, xFilial("SA4") + cCGCTrp, "A4_COD")
		CONOUT("CGC Transportador: " + AllTrim(SubStr(cBuffer,04,14)))
		If Empty(cCdTrp)
			CONOUT("** " + "Emitente não encontrado com CNPJ/CPF: " + cCGCTrp)
		EndIf
		// Log e pré-validação do Emitente
		If Empty(MV_PAR01) .AND. Empty(MV_PAR02)
			lSelecao := .T.
		ElseIf cCdTrp >= MV_PAR01 .AND. cCdTrp <= MV_PAR02
			lSelecao := .T.
		Else
			CONOUT("** Transportador fora da faixa")
		EndIf
		If lSelecao
			CONOUT("Cod Transportador: " + cCdTrp)
		EndIf
	EndIf
	If SubStr(cBuffer,01,03) == "342" .And. lSelecao
		// Código do emissor do Documento de Carga
		cCdEmis := Posicione("SA1",3,xFilial('SA1')+SubStr(cBuffer,04,14),"A1_COD")
		cCdLoja := Posicione("SA1",3,xFilial('SA1')+SubStr(cBuffer,04,14),"A1_LOJA")
		If Empty(cCdEmis)
			CONOUT("** " + "Emitente não encontrado com CNPJ/CPF: " + SubStr(cBuffer,04,14), 1)
		EndIf
		// Filial do Documento de Carga com base no Emissor do CNPJ/CPF da Nota
		CONOUT("# Buscando a filial do documento de carga pelo emissor: " + SubStr(cBuffer,04,14), 1)
		cFilDc := ""
		SM0->( dbGoTop() )
		While !SM0->( EOF() )
			If SM0->M0_CGC == ALLTRIM(SubStr(cBuffer,04,14))
				cFilDc := SM0->M0_CODFIL
				CONOUT("- Filial encontrada: " + cFilDc, 1)
				Exit
			EndIf
			dbSelectArea("SM0")
			SM0->( dbSkip() )
		EndDo
		If Empty(cFilDc)
			CONOUT("** " + "Filial não encontrada para a empresa de CNPJ:" + SubStr(cBuffer,04,14), 1)
			cFilDc := cFilialOcor
		Else
			cFilialOcor := cFilDc 
		EndIf
		c_DocCte := StrZero(Val(SubStr(cBuffer,21,08)),9)
		c_SerCte := SubStr(cBuffer,18,03)
		c_CGCTra := SubStr(cBuffer,04,14)
		cMsgPreVal := ""
		nCountImpor++
		nNRIMP++
		
		RecLock((tTabOCO),.T.)
			(tTabOCO)->Z4_FILIAL  := xFilial("SZ4")
			(tTabOCO)->Z4_FILOCO  := Iif(!Empty(cFilialOcor),cFilialOcor,xFilial())
			(tTabOCO)->Z4_CDTRP   := cCdTrp
			(tTabOCO)->Z4_NRIMP   := ALLTRIM(STR(nNRIMP))
			(tTabOCO)->Z4_FILDC   := cFilDc
			(tTabOCO)->Z4_EMISDC  := SubStr(cBuffer,04,14)
			(tTabOCO)->Z4_SERDC   := SubStr(cBuffer,18,03)
			If SF2->(DbSeek(Iif(!Empty(cFilialOcor),cFilialOcor,xFilial())+StrZero(Val(SubStr(cBuffer,21,08)),9)+SubStr(cBuffer,18,03)))
				(tTabOCO)->Z4_NRDC    := StrZero(Val(SubStr(cBuffer,21,08)),9)
			Else
				(tTabOCO)->Z4_NRDC    := StrZero(Val(SubStr(cBuffer,23,06)),6)
			EndIf
			(tTabOCO)->Z4_CODOCO  := SubStr(cBuffer,29,02)
			d_DtOco := StoD(SubStr(SubStr(cBuffer,31,08),5,4)+SubStr(SubStr(cBuffer,31,08),3,2)+SubStr(SubStr(cBuffer,31,08),1,2))
			c_Hoco  :=SubStr(cBuffer,39,2)+":"+SubStr(cBuffer,41,2)
			If EmpTy(d_DtOco)
				d_DtOco := StoD(SubStr(SubStr(cBuffer,32,08),5,4)+SubStr(SubStr(cBuffer,32,08),3,2)+SubStr(SubStr(cBuffer,32,08),1,2))
				c_Hoco  :=SubStr(cBuffer,40,2)+":"+SubStr(cBuffer,42,2)
			EndIf   
			c_Obs :=""
			If d_DtOco > dDatabase
				c_Obs := "DATA INFORMADA MAIOR QUE A ATUAL"
			EndIf	
			(tTabOCO)->Z4_DTOCOR  := d_DtOco
			(tTabOCO)->Z4_HROCOR  := c_Hoco
			(tTabOCO)->Z4_CODOBS  := Val(SubStr(cBuffer,43,2))
			(tTabOCO)->Z4_OBS     := c_Obs + SubStr(cBuffer,45,70)
			(tTabOCO)->Z4_EDISIT  := '1'
			(tTabOCO)->Z4_EDILIN  := cBuffer
			(tTabOCO)->Z4_EDIARQ  := cNomeArq
			(tTabOCO)->Z4_EDINRL  := nContLinhas
		MsUnLock((tTabOCO))
		lFlag := .T.
		// Pré-Validações -------------------------
		If Empty((tTabOCO)->Z4_CDTRP)
			cMsgPreVal += "- "  + "Transportador não encontrado. CNPJ/CPF: " + cCGCTrp + CRLF
		EndIf
		If Empty((tTabOCO)->Z4_FILDC)
			cMsgPreVal += "- "  + "Filial da Nota não encontrada. CNPJ/CPF:" + SubStr(cBuffer,04,14) + CRLF
		EndIf
		If Empty((tTabOCO)->Z4_EMISDC)
			cMsgPreVal += "- "  + "Emissor da nota não encontrado. CNPJ/CPF: " + SubStr(cBuffer,04,14) + CRLF
		EndIf
		If !Empty(cMsgPreVal)
			RecLock((tTabOCO))
			(tTabOCO)->Z4_EDIMSG := cMsgPreVal
			(tTabOCO)->Z4_EDISIT := '2'
			MsUnlock()
		EndIf
	EndIf
	FT_FSKIP() //próximo registro no arquivo txt
	If FT_FEOF()
		lFimArquivo := .T.
	EndIf
	cBuffer := FT_FREADLN() //lendo linha
EndDo
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GerarSZ4
Geração da tabela intermediária SZ4
@author Francisco Godinho
@since 13/07/13
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function GerarSZ4()
Local nI
Local cNRIMP
dbSelectArea((tTabOCO))
dbGoTop()
// Conhecimentos
While !(tTabOCO)->(EOF())
	cNRIMP := GETSXENUM("SZ4", "Z4_NRIMP")
//	c_Chave := xFilial("SZ4") + (tTabOCO)->Z4_CDTRP + (tTabOCO)->Z4_NRDC + (tTabOCO)->Z4_SERDC
	c_Chave := xFilial("SZ4") + (tTabOCO)->Z4_CDTRP + (tTabOCO)->Z4_NRDC + (tTabOCO)->Z4_SERDC + (tTabOCO)->Z4_CODOCO

	DbSelectArea("SZ4")
	DbSetOrder(5) 	// Z4_FILIAL+Z4_CDTRP+Z4_NRDC+Z4_SERDC+Z4_CODOCO
	If ! DbSeek(c_Chave)
		RecLock("SZ4", .T.)
		SZ4->Z4_FILIAL := xFilial("SZ4")
		SZ4->Z4_NRIMP  := cNRIMP
	Else
		RecLock("SZ4", .F.)
	EndIf	
		SZ4->Z4_MARKBR := "" // oBrowse117:Mark()
		SZ4->Z4_USUIMP	:= USRRETNAME(RETCODUSR())
		SZ4->Z4_DTIMP  := DDATABASE
		SZ4->Z4_ALTER  := "2"
		// Grava todos os campos, com execção do Z4_FILIAL e Z4_NRIMP
		For nI := 3 To Len(aCamposOCO)
			&("SZ4->" + aCamposOCO[nI][1] + " := (tTabOCO)->" + aCamposOCO[nI][1])
		Next
	MsUnlock("SZ4")
	c_Classi := Posicione("SZ3",1,xFilial("SZ3") + SZ4->Z4_CODOCO,"Z3_CLASSI")
	DbSelectArea("SZ4")
	RecLock("SZ4", .F.)
		SZ4->Z4_CLASSI := c_Classi
	MsUnlock("SZ4")

	ConfirmSX8()
	
	c_MailLo := Posicione("SZ3",1,xFilial("SZ3") + SZ4->Z4_CODOCO,"Z3_MAILLO")
	c_MailCl := Posicione("SZ3",1,xFilial("SZ3") + SZ4->Z4_CODOCO,"Z3_MAILCL")
	If c_MailLo == "S" .Or. c_MailCl == "S"
		aadd(a_Notifi,{SZ4->(Recno()),c_MailLo,c_MailCl})
	EndIf	
	(tTabOCO)->(dbSkip())
EndDo
dbSelectArea((tTabOCO))
Zap
Return Nil

Static FuncTion Env_Not(a_Notifi)

aMsg	:= {}
l_MailCli := l_Maillog := .F.
// Verifica se Notifica Logistica
For nN := 1 To Len(a_Notifi)
	n_RegSZ4  := a_Notifi[nN][1]
	c_MailLog := a_Notifi[nN][2]
	c_MailCli := a_Notifi[nN][3]
	If c_MailLog == "S"
		l_Maillog := .T.
		DbSelectArea("SZ4")
		DbGoTo(n_RegSZ4)
		
		c_DescOco := Posicione("SZ3",1,xFilial("SZ3") + SZ4->Z4_CODOCO,"Z3_DESC")   
		c_DecTran := Alltrim(Posicione("SA4",1,xFilial("SA4") + Z4_CDTRP,"A4_NREDUZ"))
		cTitle:= "Notificação EDI " + Alltrim(SZ4->Z4_EDIARQ) + " Transportadora: "  + c_DecTran
		AADD(aMsg, "Doc No: " + Alltrim(SZ4->Z4_NRDC) + "/" + SZ4->Z4_SERDC+ " Filial: " + SZ4->Z4_FILDC + " Ocorrencia: " + c_DescOco)
	EndIf
Next	
If l_Maillog 
	cTo := Alltrim(SuperGetMV("SB_MAILLOG",.F.,"caio.santos@suryabrasil.com"))
	U_MailNotify(cTo, cTitle, aMsg)
	CONOUT('Notificacao')
	CONOUT('cTo '+cTo)
	CONOUT('cTitle '+cTitle)
EndIf
// Verifica se Notifica cliente
aMsg	:= {}
For nN := 1 To Len(a_Notifi)
	n_RegSZ4  := a_Notifi[nN][1]
	c_MailLog := a_Notifi[nN][2]
	c_MailCli := a_Notifi[nN][3]
	If c_MailCli == "S"
		l_MailCli := .T.
		DbSelectArea("SZ4")
		DbGoTo(n_RegSZ4)
		
		c_DescOco := Posicione("SZ3",1,xFilial("SZ3") + SZ4->Z4_CODOCO,"Z3_DESC")   
		c_DecTran := Alltrim(Posicione("SA4",1,xFilial("SA4") + Z4_CDTRP,"A4_NREDUZ"))
		cTitle:= "Notificação EDI " + Alltrim(SZ4->Z4_EDIARQ) + " Transportadora: "  + c_DecTran
		AADD(aMsg, "Doc No: " + Alltrim(SZ4->Z4_NRDC) + "/" + SZ4->Z4_SERDC+ " Filial: " + SZ4->Z4_FILDC + " Ocorrencia: " + c_DescOco)
	EndIf
Next	
If l_MailCli
	cTo := Alltrim(SuperGetMV("GO_MAILLOG",.F.,"caio.santos@suryabrasil.com"))
	U_MailNotify(cTo, cTitle, aMsg)
	CONOUT('Notificacao')
	CONOUT('cTo '+cTo)
	CONOUT('cTitle '+cTitle)
EndIf

Return
