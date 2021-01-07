#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE 'DIRECTRY.CH'
#INCLUDE "tbiconn.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"
#INCLUDE "LOJNFCE.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "RPTDEF.CH"

User FuncTion GCntFret()
Local aCores :=	{{ "Z4_CLASSI == 'A'" ,'BR_AMARELO' },;	// "Alerta"
				 { "Z4_CLASSI == 'U'" ,'DISABLE'    },;	// "Urgente"    
				 { "Z4_CLASSI == 'E'" ,'BR_BRANCO'  },; // "eNCERRADO
				 { "Z4_CLASSI == 'N'" ,'ENABLE'	 }}		// "Normal"
Private aRotina := MenuDef()
Private cCadastro := "Controle de Frete"

mBrowse( 6, 1,22,75,"SZ4",,,,,, aCores)

Return
// Rotina de importacao
User Function GOCOIMP()
Local aAreaSZ4 := SZ4->(GetArea())
local x 
Private tTabOCO				// Tabela temporária do conhecimento
Private aCamposOCO := {}	// Campos da tabela intermediária de CTRC
Private a_Notifi   := {}    // Notificação Logistica / Cliente
Private aDadosBol	:= {}
/*
dbSelectArea("SZ4")
dbGoTop()
While !SZ4->(EOF())
	RecLock("SZ4", .F.)
	SZ4->Z4_MARKBR := ""
	MsUnlock()
	SZ4->(dbSkip())
EndDo*/

RestArea(aAreaSZ4)
If Pergunte("GOFRT001",.T.)
	CriaTbOco()
	Processa({|| Impoco(@aDadosBol)},"Importando arquivos ocorrencias", "")
	GFEDelTab(tTabOCO)
Else
	Return .F.
EndIf

Env_Not(a_Notifi)

if len(aDadosBol) > 0
	For x := 1 to len(aDadosBol)
		RexImpBol(substr(aDadosBol[x],9,2),substr(aDadosBol[x],11,3),substr(aDadosBol[x],14,9),substr(aDadosBol[x],1,8))
		
		cPedido := POSICIONE("SD2",3,xFilial("SD2")+substr(aDadosBol[x],11,3)+substr(aDadosBol[x],14,9),'D2_PEDIDO')
		
		DBSelectArea("SC5")
		DBSetOrder(1)
		If MsSeek(xFilial("SC5") + cPedido)
			RecLock( 'SC5', .F. )
			SC5->C5_XSTATUS :=  "7"
			SC5->C5_XDESCST :=  "Pedido de Venda Concluído"
			MsUnlock()
		EndIf
		
	Next
EndIf

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} Importacao
EDI - Importação de Ocorrências
@author Francisco Godinho
@since 14/07/13
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function Impoco(aDadosBol)
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
Private GFELog117 := GFELog():New("EDI_Ocorrencias_Importacao", "EDI Ocorrências - Importação", SuperGetMV('MV_GFEEDIL',,'1'))
cFilialOcor := MV_PAR03
GFELog117:Add("Parâmetros" + CRLF + Replicate("-", 20))
GFELog117:Add("Transportador De..: " + MV_PAR01)
GFELog117:Add("Transportador Até.: " + MV_PAR02)
GFELog117:Add("Filial Ocorrências: " + cFilialOcor)
GFELog117:Add("Dir. Importação..: "  + MV_PAR04)
GFELog117:Add("Dir. Backup OK...: "  + MV_PAR05)
GFELog117:Add("Dir. Backup Erros: "  + MV_PAR06)
GFELog117:NewLine()
// Validação do diretório de importação
If Empty(cDiretorio)
	GFELog117:Add("** " + "Diretório de importação deve ser informado.")
	GFELog117:EndLog()
	MsgAlert("Diretório de importação deve ser informado.", "Aviso")
	Return
EndIf

aDirImpor := DIRECTORY(cDiretorio + "\*.TXT" )
// Verifica se existe arquivos no diretório informado
If Len(aDirImpor) == 0
	GFELog117:Add("** " + "Nenhum arquivo encontrado no diretório " + cDiretorio)
	GFELog117:EndLog()
	MsgAlert("Nenhum arquivo encontrado no diretório " + cDiretorio, "Aviso")
	Return
Endif
// Data e Hora
cFormatDt := stuff(DTOC(date()),3,1,'')
cFormatDt := stuff(cFormatDt,5,1,'')

cFormatTm := stuff(Time(),3,1,'')
cFormatTm := stuff(cFormatTm,5,1,'')

GFELog117:Add("- Início da importação")
GFELog117:NewLine()
GFELog117:Save()

ProcRegua(Len(aDirImpor))

For nCountFiles := 1 To Len(aDirImpor)
	lArquivoValido := .T.
	cNomeArq  	:= aDirImpor[nCountFiles][1]
	GFELog117:Add(Replicate("-", 80))
	GFELog117:Add("[" + ALLTRIM(STR(nCountFiles)) + "] Arquivo: " + cNomeArq)
	FT_FUSE(cDiretorio + "\" + cNomeArq)
	FT_FGOTOP()
	cBuffer := FT_FREADLN()
	// Verifica se é um arquivo válido. Identificador '000' e sigla 'COCO'
	If SubStr(cBuffer,01,03) == "000" .And. SubStr(cBuffer,84,03) != "OCO"
		GFELog117:Add("  ** Arquivo com Registro '000', Identificador de intercambio diferente de 'OCO'")
		GFELog117:Add("  ** Linha: " + cBuffer)
		MsgAlert("Arquivo '" + cNomeArq + "' inválido.", "Aviso")
		FT_FUSE()
		GFELog117:NewLine()
		GFELog117:Save()
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
			GFELog117:Add("** " + "Arquivo '" + cNomeArq + "' com formato inválido ou layout incompatível com o sistema.", 1)
			GFELog117:Save()
			MsgAlert("Arquivo '" + cNomeArq + "' com formato inválido ou layout incompatível com o sistema.", "Aviso")
			FT_FUSE() // Fecha o arquivo
			lArquivoValido := .F.
		EndIf
	EndIf
	// Leitura do Arquivo e Gravação do Arquivo
	If lArquivoValido
		IncProc()
		If cLayoutVer == "340"
			LOcoPro3(@aDadosBol, @lArquivoValido)
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
			GFELog117:Add("** " + "Erro ao mover arquivo '" + cDiretorio + "\" + cNomeArq  + "' para o diretório " + cDirOk + "\" + cNewNomeArq)
			MsgAlert(             "Erro ao mover arquivo '" + cDiretorio + "\" + cNomeArq  + "' para o diretório " + cDirOk + "\" + cNewNomeArq, "Aviso")
		EndIf
	Else
		If (FRename(cDiretorio + "\" + cNomeArq, cDirErro + "\" + cNewNomeArq) == -1)
			GFELog117:Add("** " + "Erro ao mover arquivo '" + cDiretorio + "\" + cNomeArq  + "' para o diretório " + cDirErro + "\" + cNewNomeArq)
			MsgAlert(             "Erro ao mover arquivo '" + cDiretorio + "\" + cNomeArq  + "' para o diretório " + cDirErro + "\" + cNewNomeArq, "Aviso")
		EndIf
	EndIf
	GFELog117:NewLine()
	GFELog117:Add(Replicate("-", 50))
	GFELog117:NewLine()
Next
GFELog117:EndLog()
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
Static Function LOcoPro3(aDados, lArquivo)
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
		GFELog117:Add("CGC Transportador: " + AllTrim(SubStr(cBuffer,04,14)))
		If Empty(cCdTrp)
			GFELog117:Add("** " + "Emitente não encontrado com CNPJ/CPF: " + cCGCTrp)
			lArquivo := .F.
			Alert("Emitente não encontrado com CNPJ/CPF " + cCGCTrp)
			Return
		EndIf
		// Log e pré-validação do Emitente
		If Empty(MV_PAR01) .AND. Empty(MV_PAR02)
			lSelecao := .T.
		ElseIf cCdTrp >= MV_PAR01 .AND. cCdTrp <= MV_PAR02
			lSelecao := .T.
		Else
			GFELog117:Add("** Transportador fora da faixa")
		EndIf
		If lSelecao
			GFELog117:Add("Cod Transportador: " + cCdTrp)
		EndIf
	EndIf
	If SubStr(cBuffer,01,03) == "342" .And. lSelecao
		// Código do emissor do Documento de Carga
		cCdEmis := Posicione("SA1",3,xFilial('SA1')+SubStr(cBuffer,04,14),"A1_COD")
		cCdLoja := Posicione("SA1",3,xFilial('SA1')+SubStr(cBuffer,04,14),"A1_LOJA")
		If Empty(cCdEmis)
			GFELog117:Add("** " + "Emitente não encontrado com CNPJ/CPF: " + SubStr(cBuffer,04,14), 1)
		EndIf
		// Filial do Documento de Carga com base no Emissor do CNPJ/CPF da Nota
		GFELog117:Add("# Buscando a filial do documento de carga pelo emissor: " + SubStr(cBuffer,04,14), 1)
		cFilDc := ""
		SM0->( dbGoTop() )
		While !SM0->( EOF() )
			If SM0->M0_CGC == ALLTRIM(SubStr(cBuffer,04,14))
				cFilDc := SM0->M0_CODFIL
				GFELog117:Add("- Filial encontrada: " + cFilDc, 1)
				Exit
			EndIf
			dbSelectArea("SM0")
			SM0->( dbSkip() )
		EndDo
		If Empty(cFilDc)
			GFELog117:Add("** " + "Filial não encontrada para a empresa de CNPJ:" + SubStr(cBuffer,04,14), 1)
			cFilDc := cFilialOcor
			lArquivo := .F.
			Alert(" Filial não encontrada para a empresa de CNPJ:" + SubStr(cBuffer,04,14))
			Return
		Else
			cFilialOcor := cFilDc 
		EndIf
		GFELog117:Add("Documento de Carga: ", 1)
		GFELog117:Add("> CGC Emissor.: " + SubStr(cBuffer,04,14), 2)
		GFELog117:Add("> Filial......: " + cFilDc				, 2)
		GFELog117:Add("> Emissor.....: " + cCdEmis				, 2)
		GFELog117:Add("> Série.......: " + SubStr(cBuffer,18,03), 2)
		GFELog117:Add("> Número......: " + SubStr(cBuffer,21,08), 2)
		GFELog117:Save()
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
			(tTabOCO)->Z4_SERDC   := StrZero(Val(SubStr(cBuffer,18,03)),3)
			(tTabOCO)->Z4_NRDC    := StrZero(Val(SubStr(cBuffer,21,08)),9)
			(tTabOCO)->Z4_CODOCO  := SubStr(cBuffer,29,02)
			xx := "1"
			d_DtOco := StoD(SubStr(SubStr(cBuffer,31,08),5,4)+SubStr(SubStr(cBuffer,31,08),3,2)+SubStr(SubStr(cBuffer,31,08),1,2))
			c_Hoco  :=SubStr(cBuffer,39,2)+":"+SubStr(cBuffer,41,2)
			If EmpTy(d_DtOco)
				d_DtOco := StoD(SubStr(SubStr(cBuffer,32,08),5,4)+SubStr(SubStr(cBuffer,32,08),3,2)+SubStr(SubStr(cBuffer,32,08),1,2))
				c_Hoco  :=SubStr(cBuffer,40,2)+":"+SubStr(cBuffer,42,2)
			EndIf   
			xx := "1"
			c_Obs :=""
			If d_DtOco > dDatabase
				c_Obs := "DATA INFORMADA MAIOR QUE A ATUAL"
			EndIf	
			(tTabOCO)->Z4_DTOCOR  := d_DtOco // StoD(SubStr(SubStr(cBuffer,32,08),5,4)+SubStr(SubStr(cBuffer,32,08),3,2)+SubStr(SubStr(cBuffer,32,08),1,2))
			(tTabOCO)->Z4_HROCOR  := c_Hoco
			(tTabOCO)->Z4_CODOBS  := Val(SubStr(cBuffer,43,2))
			(tTabOCO)->Z4_OBS     := c_Obs + SubStr(cBuffer,45,70)
			(tTabOCO)->Z4_EDISIT  := '1'
			(tTabOCO)->Z4_EDILIN  := cBuffer
			(tTabOCO)->Z4_EDIARQ  := cNomeArq
			(tTabOCO)->Z4_EDINRL  := nContLinhas
		MsUnLock((tTabOCO))
		if SubStr(cBuffer,29,02) == "01"
			if aScan(aDados,DtoS(d_DtOco)+Iif(!Empty(cFilialOcor),cFilialOcor,xFilial())+StrZero(Val(SubStr(cBuffer,18,03)),3)+StrZero(Val(SubStr(cBuffer,21,08)),9)) == 0
				aADD(aDados,DtoS(d_DtOco)+Iif(!Empty(cFilialOcor),cFilialOcor,xFilial())+StrZero(Val(SubStr(cBuffer,18,03)),3)+StrZero(Val(SubStr(cBuffer,21,08)),9))
			endif
		endif
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
	GFELog117:NewLine()
	GFELog117:Save()
EndDo
Return

Static Function MenuDef()
Local aRotina := {	{ OemToAnsi("Pesquisar" )      , "AxPesqui"  	  	, 0 , 1,,.F.},;
                   	{ OemToAnsi("Visualiza" )      , "AxVisual"  	  	, 0 , 2} ,;
					{ OemToAnsi("Imp.Ocorrencias") , "U_GOCOIMP()" 	  	, 0 , 3} ,;
                   	{ OemToAnsi("Excluir" )        , "U_GOEXOCO()" 	  	, 0 , 3} ,;
					{ OemToAnsi("Legenda")         , "U_FrtLegenda()"	, 0 , 2}  }
Return(aRotina)


User Function FrtLegenda()
Local aLegenda := {}
Local aCores :=	{{ "U_a_aCores() == 'A'" ,'BR_AMARELO' },;	// "Alert"
				 { "U_a_aCores() == 'U'" ,'DISABLE'    },;	// "Urgente"
				 { "U_a_aCores() == 'N'" ,'ENABLE'	 }}		// "Normal"

aAdd(aLegenda, {"BR_VERMELHO",	"Urgente"})
aAdd(aLegenda, {"ENABLE",		"Normal"})
aAdd(aLegenda, {'BR_AMARELO', 	"Alerta"})
BrwLegenda (cCadastro, "Legenda", aLegenda) 

Return .T.

User FuncTion GOEXOCO()
Local c_Permissao := SuperGetMV("GO_EXCOCO",.F.,"000000")
If ! __cUserId $ c_Permissao
	Alert("Usuario sem permissão para exclusão...")
	Return
EndIf
DbSelectArea("SZ4")
RecLock("SZ4",.F.)
	DbDelete()
MsUnlock()

Alert("Excluído com sucesso!")

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
//	c_Chave := xFilial("SZ4") + (tTabOCO)->Z4_CDTRP + (tTabOCO)->Z4_NRDC + (tTabOCO)->Z4_SERDC
	c_Chave := xFilial("SZ4") + (tTabOCO)->Z4_CDTRP + (tTabOCO)->Z4_NRDC + (tTabOCO)->Z4_SERDC + (tTabOCO)->Z4_CODOCO

	DbSelectArea("SZ4")
	DbSetOrder(5) 	// Z4_FILIAL+Z4_CDTRP+Z4_NRDC+Z4_SERDC+Z4_CODOCO
	If ! DbSeek(c_Chave)
	
		cNRIMP := GETSXENUM("SZ4", "Z4_NRIMP")
		
		RecLock("SZ4", .T.)
		SZ4->Z4_FILIAL := xFilial("SZ4")
		SZ4->Z4_NRIMP  := cNRIMP

		SZ4->Z4_MARKBR := "" // oBrowse117:Mark()
		SZ4->Z4_USUIMP	:= USRRETNAME(RETCODUSR())
		SZ4->Z4_DTIMP  := DDATABASE
		SZ4->Z4_ALTER  := "2"
		// Grava todos os campos, com execção do Z4_FILIAL e Z4_NRIMP
		For nI := 3 To Len(aCamposOCO)
			&("SZ4->" + aCamposOCO[nI][1] + " := (tTabOCO)->" + aCamposOCO[nI][1])
		Next             
		
		c_Classi := Posicione("SZ3",1,xFilial("SZ3") + SZ4->Z4_CODOCO,"Z3_CLASSI")
		SZ4->Z4_CLASSI := c_Classi
		MsUnlock("SZ4")
		ConfirmSX8()
		
	Else
		RecLock("SZ4", .F.)
		SZ4->Z4_MARKBR := "" // oBrowse117:Mark()
		SZ4->Z4_USUIMP := USRRETNAME(RETCODUSR())
		SZ4->Z4_DTIMP  := DDATABASE
		SZ4->Z4_ALTER  := "2"
		// Grava todos os campos, com execção do Z4_FILIAL e Z4_NRIMP
		For nI := 3 To Len(aCamposOCO)
			&("SZ4->" + aCamposOCO[nI][1] + " := (tTabOCO)->" + aCamposOCO[nI][1])
		Next             
		
		c_Classi := Posicione("SZ3",1,xFilial("SZ3") + SZ4->Z4_CODOCO,"Z3_CLASSI")
		SZ4->Z4_CLASSI := c_Classi
		MsUnlock("SZ4")
		
	EndIf	
	
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
	cTo := Alltrim(SuperGetMV("GO_MAILLOG",.F.,"godinho.francisco@gmail.com"))
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
	cTo := Alltrim(SuperGetMV("GO_MAILLOG",.F.,"godinho.francisco@gmail.com"))
	U_MailNotify(cTo, cTitle, aMsg)
	CONOUT('Notificacao')
	CONOUT('cTo '+cTo)
	CONOUT('cTitle '+cTitle)
EndIf

Return

User FuncTion a_aCores()
Local aArea := GetArea()

c_Classi := Posicione("SZ3",1,xFilial("SZ3") + SZ4->Z4_CODOCO,"Z3_CLASSI")

RestArea(aArea)

Return(c_Classi)


Static Function RexImpBol(cFil,cSerie,cNum,cData)   
local aParam		:= {}
local cparcFirst	:= ""
local cparcLast		:= ""  
local lDanfe		:= .T.  
local cimpBol		:= ''
LOCAL cQuery		:= ''
lOCAL cBanco		:= ""
Local cAliasTemp := GetNextAlias()

cQuery :="SELECT * " 
cQuery +=" FROM "+RetSqlName("SE1") +" SE1 (NOLOCK)"
cQuery +=" JOIN "+RetSqlName("SA1") +" SA1  (NOLOCK)"
cQuery +=" ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = '' "
cQuery +=" WHERE SE1.D_E_L_E_T_ = ' '"
cQuery +=" AND E1_FILIAL = '"+cFil+"'"
cQuery +=" AND E1_PREFIXO = '"+cSerie+"'"
cQuery +=" AND E1_NUM = '"+cNum+"' 
cQuery +=" AND E1_TIPO = 'NF' AND E1_XIMPBOL <> '1' AND E1_XFORMA = '1000' " 
cQuery +=" AND A1_XBOLENT = '1' "
cQuery +=" ORDER BY E1_PARCELA	DESC" 
If Select(cAliasTemp) > 0           // Verificar se o Alias ja esta aberto.
	DbSelectArea(cAliasTemp)        // Se estiver, devera ser fechado.
	(cAliasTemp)->(DbCloseArea())
EndIf 
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTemp, .F., .T.)  		
dbselectarea(cAliasTemp)    
DbGoTop()  
li:= 500000
//SetRegua(RecCount()) 

If !EOF()
	AADD(aParam, (cAliasTemp)->(E1_PREFIXO))//[1]
	AADD(aParam, (cAliasTemp)->(E1_NUM))
	AADD(aParam, (cAliasTemp)->(E1_NUM))
	if !Empty(alltrim((cAliasTemp)->(E1_PARCELA)))
		AADD(aParam, cValtoChar( val((cAliasTemp)->(E1_PARCELA))+1-val((cAliasTemp)->(E1_PARCELA))) )//[4]
	else
		AADD(aParam, (cAliasTemp)->(E1_PARCELA))
	endif
	AADD(aParam, (cAliasTemp)->(E1_PARCELA))
	AADD(aParam, (cAliasTemp)->(E1_XIMPBOL)) //[6]
	AADD(aParam, POSICIONE('SA1',1,xFilial('SA1')+(cAliasTemp)->E1_CLIENTE+(cAliasTemp)->E1_LOJA,'A1_EMAIL')) //[7]
	AADD(aParam, POSICIONE('SA1',1,xFilial('SA1')+(cAliasTemp)->E1_CLIENTE+(cAliasTemp)->E1_LOJA,'A1_NOME')) //[8]
	cBanco	:= (cAliasTemp)->(E1_PORTADO)
Endif

if len(aParam) <= 0
	conout("Verifique os parametros","HELP: DADOS NAO ENCONTRADOS")
	Return()
endif
 
DbSelectArea('SE1')
DbSetOrder(1)
DbSeek((cAliasTemp)->E1_FILIAL+(cAliasTemp)->E1_PREFIXO+(cAliasTemp)->E1_NUM )
cCond := Posicione("SC5",1,SE1->E1_FILIAL+SE1->E1_PEDIDO,"C5_CONDPAG")
nValor:= Posicione("SF2",1,SE1->E1_FILIAL+SE1->E1_NUM+SE1->E1_SERIE,"F2_VALBRUT")
Acond := CONDICAO(nValor,cCond ,,StoD(cData))
i:=0
do while (cAliasTemp)->E1_FILIAL+(cAliasTemp)->E1_PREFIXO+(cAliasTemp)->E1_NUM = SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM .and. !EOF()
	i++
	Reclock("SE1",.F.)
		SE1->E1_VENCREA := Acond[i,1]
	MsUnlock()
	SE1->(dbskip())
enddo

if len(aParam) > 0 .And. !Empty(alltrim(cBanco))
	SelBol(aParam,cBanco)
endif 

Return


Static Function SelBol(aParam, cBanco)
Local oBoleto
Local lAdjustToLegacy	:= .F.
Local cFilePrint	:= ""
//Local cPathInServer := "E:\TotvsProducao\_Aplicacao\FCDOSSANTOS\protheus_data\data\"
Local cPathInServer := "\data\"
Local _pcSubject := ""
Local _pcBody := ""
Local _pcDestino := aParam[7]
Local _cEmailCopy := Alltrim(SuperGetMV("SB_MAILBOL",.F.,"contasareceber@suryabrasil.com"))
//Local _pcDestino := "alexsandro.lima@suryabrasil.com"

cFilePrint	:= "BOL"+cBanco+aParam[1]+aParam[2]
lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
lDisableSetup  := .T.

oBoleto := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, "\data\", lDisableSetup, , , , , .F., ,.F.,)// Ordem obrigátoria de configuração do relatório

oBoleto:SetResolution(78) //Tamanho estipulado para a Danfe
oBoleto:SetPortrait()
oBoleto:SetPaperSize(DMPAPER_A4)
oBoleto:SetMargin(60,60,60,60)
//oBoleto:lServer := .T.
oBoleto:cPathPDF := cPathInServer
oBoleto:lViewPDF := .F.

Do Case
	Case cBanco == "237"
		U_BOLETBRA(.F., aParam,oBoleto)  
	Case cBanco	== "033"
		U_BOLETSAN(.F., aParam,oBoleto)   
EndCase

oBoleto:EndPage()

oBoleto:Preview()

FreeObj(oBoleto)

//Enviar boleto para o Cliente
_pcSubject 	:= "BOLETO SURYA BRASIL REF. TITULO "+aParam[2]

_pcBody := "<STRONG>Aviso de vencimento de fatura</STRONG><br><br>"
_pcBody += "Prezado(a) <STRONG>"+aParam[8]+"</STRONG>,<br><br>"
_pcBody += "Em anexo encontra-se seu(s) boleto(s) para pagamento.<br><br>"
_pcBody += "Boleto referente a NF: "+ aParam[2] +" e serie: "+ aParam[1] +" foi gerado com base na data de entrega informada pelo transportador e está disponível para pagamento.<br><br>"
_pcBody += "Segue boleto em Anexo.<br><br>"
_pcBody += "Cordialmente,<br><br>"
_pcBody += "Surya Brasil<br><br>"
_pcBody += "Este e-mail foi enviado pelo sistema automático da Surya Brasil. Favor não respondê-lo, por não ser um e-mail monitorado."

//SBENVMAIL(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc,_cAccount,_cPassword)
//Função que envia e-mail
If U_SBENVMAIL("",_pcDestino, _pcSubject, _pcBody,"\data\"+cFilePrint+".pdf",.T.,_cEmailCopy)
	u_CriaLog("geraboleto","Boleto enviado ao cliente: " + alltrim(aParam[8]) + " e-mail: " + _pcDestino + " em " + DtoS(Date()) + " - " +  Time() )
Else
	u_CriaLog("geraboleto","Erro de envio do boleto ao cliente: " + alltrim(aParam[8]) + " e-mail: " + _pcDestino + " em " + DtoS(Date()) + " - " +  Time() )
EndIf

//Apagar boleto
FErase(cPathInServer+cFilePrint+".pdf")

Return

