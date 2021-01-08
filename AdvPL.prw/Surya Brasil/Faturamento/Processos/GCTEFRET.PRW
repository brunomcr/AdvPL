#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDE "AvPrint.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#include "Totvs.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GCTEFRET ºAutor  ³Francisco C Godinho º Data ³  04/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Fretes CT-e x Ocorrencia x Doc. Origem            º±±
±±º          ³ Apenas para Frete s/ Vendas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User FuncTion GCTEFRET()
Local nI := 1
Local nX := 1
Private nTotMerc := 0
Private cCadastro:= "Consulta EDI - Logistica"

aRotina := MenuDef()

SF2->(dbSetOrder(1))

aFixe := {}
AADD(aFixe,{ "Nota Fiscal" ,"F2_DOC"})
AADD(aFixe,{ "Serie"       ,"F2_SERIE"})
AADD(aFixe,{ "Emissao"     ,"F2_EMISSAO"})
AADD(aFixe,{ "Nome Transportadora","POSICIONE('SA4',1,xFilial('SA4')+F2_TRANSP,'A4_NOME')"})
AADD(aFixe,{ "Data Coleta"      ,"F2_XDTCOL"})

mBrowse( 6, 1,22,75,"SF2",aFixe,,30)

Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef   ºAutor  ³Francisco C Godinho º Data ³  04/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Menu                                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef()
PRIVATE aRotina	:= {}
aRotina		:= {{ OemToAnsi("Pesquisar")     	, "AxPesqui"       	, 0 , 1},;
{ OemToAnsi("Visualiza")     	, "U_ConsNFS()"  	, 0 , 2},;
{ OemToAnsi("Ocorrencias")  	, "U_GVISOCO(1)"    , 0 , 2},;
{ OemToAnsi("Inclui Ocorrencias"),"U_GINCOCO(1)"    , 0 , 3},;
{ OemToAnsi("Relatorio")    	, "U_GOREL10()"    	, 0 , 2},;
{ OemToAnsi("Inclui Coleta")	, "U_FATA18A()"		, 0,  5},;
{ "Alterar"                     , "U_SF2Manut"      , 0 , 4}  }


Return( aRotina )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GVISOCO  ºAutor  ³Francisco C Godinho º Data ³  04/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Visualiza Historio de ocorrencias                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User FuncTion GVISOCO()

PRIVATE oVerde    := LoadBitmap(GetResources(),"BR_VERDE")
PRIVATE oVermelho := LoadBitmap(GetResources(),"BR_VERMELHO")
PRIVATE oAmarelo  := LoadBitmap(GetResources(),"BR_AMARELO")
PRIVATE oEncerrado:= LoadBitmap(GetResources(),"BR_BRANCO")
PRIVATE aListBox  := {}
c_Doc := AllTrim(SF2->F2_DOC)
c_Ser := SF2->F2_SERIE
c_FilDoc := SF2->F2_FILIAL

cQuery := "SELECT R_E_C_N_O_ AS REG "
cQuery += " FROM " + RetSqlName("SZ4")
cQuery += " WHERE D_E_L_E_T_ = ''"
cQuery += " AND Z4_FILDC = '" + c_FilDoc + "'"
cQuery += " AND Z4_SERDC = '" + c_Ser + "'"
cQuery += " AND Z4_NRDC = '" +  c_Doc + "'"
cQuery += " ORDER BY Z4_DTOCOR,Z4_HROCOR "

cQuery := changequery(cQuery)

If Select("QRY") <> 0
	dbSelectArea("QRY")
	dbCloseArea("QRY")
EndIf

TCQUERY cQuery NEW ALIAS "QRY"

aTit := {"Classificacao"          ,"Sequencial da Importacao","Numero do Docto de Carga","Serie do Docto","Data da Ocorrencia",;
		"Horario da Ocorrencia"  , "Descricao Ocorrencia",    "Observação",;
		"Codigo do Transportador", "Emissor do Docto de Carga","Codigo Ocorrencia EDI"  ,"Situacao EDI"            ,;         
         "Numero da Linha Arquivo","Conteudo Linha Arquivo"   ,"Arquivo Importacao"     ,"Data Importacao Arquivo",;
         "C¾digo da ObservaþÒo"   ,"Usu Imp."                 ,"Alterado?"              ,"Filial Ocorrencias","Filial Documento de Carga"}

DbSelectArea("QRY")
QRY->(DbGoTop())
While ! QRY->(Eof())
	n_Reg :=QRY->REG
	DbSelectArea("SZ4")
	DbGoTo(n_Reg)

	c_Transp := "Transportadora: " + Alltrim(SZ4->Z4_CDTRP) + " - " + Posicione("SA4",1,xFilial("SA4") + SZ4->Z4_CDTRP,"A4_NOME")

	c_Msg := Posicione("SZ3",1,xFilial("SZ3") + SZ4->Z4_CODOCO ,"Z3_DESC")
	c_EdiLin := SZ4->Z4_EDILIN
	AAdd( aListBox, { 	SZ4->Z4_CLASSI,SZ4->Z4_NRIMP,SZ4->Z4_NRDC,SZ4->Z4_SERDC,SZ4->Z4_DTOCOR,SZ4->Z4_HROCOR ,;
	                    c_Msg         ,SZ4->Z4_OBS   ,SZ4->Z4_CDTRP ,SZ4->Z4_EMISDC,;
						SZ4->Z4_CODOCO,SZ4->Z4_EDISIT,;
						SZ4->Z4_EDINRL,c_EdiLin       ,SZ4->Z4_EDIARQ,SZ4->Z4_DTIMP ,;
						SZ4->Z4_CODOBS,SZ4->Z4_USUIMP,SZ4->Z4_ALTER,SZ4->Z4_FILOCO,SZ4->Z4_FILDC,n_Reg } )
	DbSelectArea("QRY")
	QRY->(DbSkip())
EndDo

If Len(aListBox) > 0
	//ASort( aListBox, , , { |x,y| y[4] > x[4] } )
	aSize := MSADVSIZE()
	DEFINE MSDIALOG oDlgRet TITLE OemToAnsi("Ocorrencias") From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
	oDlgRet:lMaximized := .T.
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	oPanel := TPanel():New(0,0,'',oDlgRet,, .T., .T.,, ,20,20,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP
	
	oPanelB := TPanel():New(0,0,'',oDlgRet,, .T., .T.,, ,45,45,.T.,.T. )
	oPanelB:Align := CONTROL_ALIGN_BOTTOM
	
	
	oListH := TWBrowse():New( 30, 38, 190, 126,,aTit,,oDlgRet,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
	
	oListH:SetArray(aListBox)
	oListH:bLine := { || { IF(aListBox[oListH:nAt,1]=="U",oVermelho,IF(aListBox[oListH:nAT,1]=="A",oAmarelo,IF(aListBox[oListH:nAt,1]=="N",oVerde,oEncerrado))),;
	aListBox[oListH:nAT,2],aListBox[oListH:nAT,3], aListBox[oListH:nAT,4],;
	aListBox[oListH:nAT,5], aListBox[oListH:nAT,6],aListBox[oListH:nAT,7], aListBox[oListH:nAT,8],;
	aListBox[oListH:nAT,9], aListBox[oListH:nAT,10],aListBox[oListH:nAT,11], aListBox[oListH:nAT,12],;
	aListBox[oListH:nAT,13], aListBox[oListH:nAT,14],aListBox[oListH:nAT,15], aListBox[oListH:nAT,16],;
	aListBox[oListH:nAT,17], aListBox[oListH:nAT,18],aListBox[oListH:nAT,19], aListBox[oListH:nAT,20], aListBox[oListH:nAT,21]  } }
	
	oListH:bLDblClick := {|| (nPos:=oListH:nAt,MarcaDes(oListH:nColPos,oListH:nAt) ) }
	oListh:cToolTip := "[Duplo click ou Enter para digitar na coluna Observação.]..."
	//Objeto 1: Verde (nao efetivado)
	oBmp1 := TBitmap():New(5,002,10,10,"BR_AMARELO",,,oPanelB,,,,,,,,,.T.,,)
	oSay1 := TSay():New(5,011, {||"Alerta"},oPanelB,,,,,,.T.,,,080,10,,,,,,.T.)
	
	//Objeto 2: Amarelo (Efetivado)
	oBmp2 := TBitmap():New(15,002,10,10,"DISABLE",,,oPanelB,,,,,,,,,.T.,,)
	oSay2 := TSay():New(15,011, {||"Urgente"},oPanelB,,,,,,.T.,,,080,10,,,,,,.T.)
	
	//Objeto 2: Amarelo (Efetivado)
	oBmp3 := TBitmap():New(25,002,10,10,"ENABLE",,,oPanelB,,,,,,,,,.T.,,)
	oSay3 := TSay():New(25,011, {||"Normal"},oPanelB,,,,,,.T.,,,080,10,,,,,,.T.)
	
	//Objeto 4: Branco
	oBmp4 := TBitmap():New(35,002,10,10,"BR_BRANCO",,,oPanelB,,,,,,,,,.T.,,)
	oSay4 := TSay():New(35,011, {||"Encerrado"},oPanelB,,,,,,.T.,,,080,10,,,,,,.T.)
	
	DEFINE SBUTTON oBut2 FROM 6, 20 TYPE 2 ACTION ( nOpca := 0, oDlgRet:End() )  ENABLE of oPanel
	@ 6, 51 Say  oSay Prompt c_Transp Size  300, 08 Of oPanel Pixel
	
	oListH:Align := CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oDlgRet CENTERED
	
Else
	Alert("Nenhuma ocorrencia foi encontrada...")
EndIf
Return(.T.)

*---------------------------*
Static FuncTion MarcaDes(nPos,nLinha)
//Duplo click na celula
*--------------------------*
// Cria validacao se necessario
// Parametro da funcao // lEditCell(aCampos,oBrowse,cPict,nCol,cF3,lReadOnly,bValid,aItems)

If nPos == 12
	n_Recno := aListBox[nLinha][22]
	cPict := PesqPict("SZ4","Z4_OBS",TamSx3("Z4_OBS")[1])
	lEditCell(aListBox,oListH,cPict,oListH:nColPos)
	DbSelectArea("SZ4")
	DbGoTo(n_Recno)
	RecLock("SZ4", .F.)
	SZ4->Z4_OBS := aListBox[nLinha][12]
	MsUnlock()
	
EndIF
oListH:refresh()

Return

User FuncTion GINCOCO()
/* Parametros AxInclui
ExpC1 = Alias do arquivo
ExpN2 = Numero do registro
ExpN3 = Numero da opcao selecionada
ExpA4 = Array com os campos a serem mostrados
ExpC5 = Funcao de validacao para confirmacao dos dados
ExpL6 = Controle da CondPad
ExpC7 = Funcao a ser chamada durante a transacao
ExpA8 = Array com os botoes da EnchoiceBar
ExpA9 = Array de codeblock de execucao
ExpAA = Array da rotina automatica
ExpAB = Inicializa os campos virtuais?
*/
// Z4_FILIAL	Z4_MARKBR	Z4_NRIMP	Z4_EDINRL	Z4_EDILIN	Z4_EDIARQ	Z4_DTIMP	Z4_ALTER	Z4_EDISIT	Z4_EDIMSG	Z4_USUIMP	Z4_FILOCO	Z4_CODOCO	Z4_DTOCOR	Z4_HROCOR	Z4_CODOBS	Z4_OBS		Z4_CDTRP	Z4_CLASSI
Local a_Area   := GetArea()

DbSelectArea("SZ4")
aButtons := {}
nOpcA:=0

aAcho := {"Z4_NRIMP","Z4_DTIMP","Z4_USUIMP","Z4_CODOCO","Z4_DTOCOR","Z4_OBS","Z4_CDTRP","Z4_FILDC","Z4_EMISDC","Z4_SERDC","Z4_NRDC","Z4_EDIARQ"}
aAlter:= {"Z4_OBS","Z4_CODOCO","Z4_DTOCOR"}
c_Chave := xFilial("SZ4") + SF2->F2_TRANSP + STRZERO(Val(SF2->F2_DOC),9) + SF2->F2_SERIE + "ZZ"
Begin Transaction
DbSelectArea("SZ4")
DbSetOrder(5) 	// Z4_FILIAL+Z4_CDTRP+Z4_NRDC+Z4_SERDC+Z4_CODOCO
IF ! DbSeek(c_Chave)  
    nOpc := 4
	nOpcA := AxInclui( "SZ4", SZ4->(Recno())          , nOpc,aAcho ,"U_LeSF2SZ4()",aAlter,"U_SZ4Val()")
	If nOpcA == 1
		c_Classi := Posicione("SZ3",1,xFilial("SZ3") + SZ4->Z4_CODOCO,"Z3_CLASSI")
		DbSelectArea("SZ4")
		RecLock("SZ4", .F.)
		SZ4->Z4_MARKBR := ""
		SZ4->Z4_USUIMP	:= USRRETNAME(RETCODUSR())
		SZ4->Z4_DTIMP  := DDATABASE
		SZ4->Z4_DTOCOR := SZ4->Z4_DTOCOR
		SZ4->Z4_ALTER  := "2"
		SZ4->Z4_CLASSI := c_Classi
		MsUnlock("SZ4")
		//ConfirmSX8()
		MsgInfo("Ocorrencia inluida com sucesso.","Informação")
	EndIf
EndIf
End Transaction

RestArea(a_Area)
Return


User FuncTion LeSF2SZ4()
Local a_Area2 := GetArea()

DbSelectArea("SF2")
M->Z4_FILDC  := SF2->F2_FILIAL
M->Z4_EMISDC := Posicione("SA4",1,xFilial("SA4") + SF2->F2_TRANSP,"A4_CGC")
M->Z4_SERDC  := SF2->F2_SERIE
M->Z4_NRDC	  := AllTrim(SF2->F2_DOC)
M->Z4_NRIMP  := GETSXENUM("SZ4", "Z4_NRIMP")
M->Z4_CODOCO := "ZZ"
M->Z4_DTIMP  := dDatabase
M->Z4_USUIMP := USRRETNAME(RETCODUSR())
M->Z4_DTOCOR := dDatabase
M->Z4_CDTRP  := SF2->F2_TRANSP
M->Z4_HROCOR := Left(Time(),5)
M->Z4_FILOCO := SF2->F2_FILIAL
M->Z4_EDIARQ := "INCLUSAO MANUAL"
M->Z4_CLASSI := Posicione("SZ3",1,xFilial("SZ3") + M->Z4_CODOCO ,"Z3_CLASSI")                                                                                                   
RestArea(a_Area2)
Return

User FuncTion SZ4Val()
Local l_Ret := .T.

Return(l_Ret)

// Consulta Nota Fiscal
User Function ConsNFS()
Local aSavSX3   := SX3->(GetArea())
Local aSavSD2   := SD2->(GetArea())
Local cCadastro := "Consulta N.Fiscal"
c_NOTA  := SF2->F2_DOC
c_SERIE := SF2->F2_SERIE
If Empty(c_NOTA) .And. Empty(c_SERIE)
	MsgInfo("Não há nota fiscal a visualizar",cCadastro)
	Return
Endif
dbSelectArea("SD2")
DbSetOrder(3) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
If dbSeek(xFilial("SD2") + c_NOTA + c_SERIE )
	Con_NFSaida(SD2->(Recno()))
Else
	MsgInfo("Nenhuma nota fiscal encontrada",cCadastro)
	Return
EndIf
Return

// Visualiza Nota Fiscal
Static Function Con_NFSaida(nRecNo)
Local aSavSD2 := SD2->(GetArea())
dbSelectArea("SD2")
dbSetOrder(3)
dbGoTo(nRecNo)
A920NFSAI("SD2",nRecNo,0)
RestArea(aSavSD2)
Return

User Function SF2Manut(cAlias, nReg, nOpc)
Local aCamposSF2 := {"F2_DOC","F2_SERIE","F2_CLIENTE","F2_LOJA","F2_EMISSAO","F2_TRANSP"}
Local aAlteraSF2 := {"F2_TRANSP"}
Local nOpca := AxAltera(cAlias,nReg,nOpc,aCamposSF2,aAlteraSF2,,, )
Return(Nil)
                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA18A   ³ Autor ³ Fabio Veiga Oliva     ³ Data ³ 09.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Tela de alteracao de dados da nota fiscal.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FATA18A()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cNF        := SF2->F2_DOC
Local _cSerie     := SF2->F2_SERIE
Local _cNomcli    := Space(60)
Local _cCliente   := ""
If !SF2->F2_TIPO $"D/B"
   _cNomcli := POSICIONE("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME")
Else
   _cNomcli := POSICIONE("SA2",1,xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_NOME")
EndIf
_cCliente   := Alltrim(SF2->F2_CLIENTE)+"/"+SF2->F2_LOJA+" - "+_cNomcli
Private _dColeta  := SF2->F2_XDTCOL
Private _cHora    := SF2->F2_XHRCOL
/*/
Private _nPesbrut := SF2->F2_PBRUTO
Private _cEspecie := SF2->F2_ESPECI1
Private _dSaida   := SF2->F2_DTLANC
Private _cImpress := SF2->F2_IMPRESS
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 151,252 To 562,834 Dialog oDlg1 Title OemToAnsi("Dados da Nota Fiscal") 
@ 012,017 Say OemToAnsi("Nota Fiscal:")   Size 35,8
@ 012,098 Say OemToAnsi("Serie:")         Size 35,8
@ 035,017 Say OemToAnsi("Cliente:")       Size 35,8
@ 057,017 Say OemToAnsi("Data Coleta:")        Size 35,8
@ 080,017 Say OemToAnsi("Hora Coleta:")  Size 35,8
/*/
@ 102,017 Say OemToAnsi("Peso Bruto:")    Size 35,8
@ 124,017 Say OemToAnsi("Especie:")       Size 35,8
@ 146,017 Say OemToAnsi("NF. Impressa:")       Size 35,8
@ 170,017 Say OemToAnsi("Data Coleta:")       Size 35,8
/*/
@ 012,054 Get _cNF      Size 30,10        When .F.
@ 012,136 Get _cSerie   Size 23,10        When .F.
@ 035,054 Get _cCliente Size 163,10       When .F.
@ 057,054 Get _dColeta  Picture "@!" Size 45,10
@ 080,054 Get _cHora    Picture "99:99:99" Size 45,10
/*/
@ 102,054 Get _nPesbrut Picture "@E 999,999.99" Size 45,10
@ 124,054 Get _cEspecie Size 45,10
@ 146,054 Get _cImpress Size 5,10 Valid Pertence("S/N")
@ 170,054 Get _dSaida   Size 45,10
/*/
@ 190,094 BMPBUTTON TYPE 01 Action U_FATA18B()
@ 190,156 BMPBUTTON TYPE 02 Action Close(oDlg1)
Activate Dialog oDlg1 CENTERED     
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA02A   ³ Autor ³ Fabio Veiga Oliva     ³ Data ³ 09.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava a alteracao de dados da nota fiscal.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FATA18B()
RecLock("SF2",.F.)
SF2->F2_XDTCOL  := _dColeta
SF2->F2_XHRCOL    := _cHora 
MsUnlock()      
Close(oDlg1)
Retur