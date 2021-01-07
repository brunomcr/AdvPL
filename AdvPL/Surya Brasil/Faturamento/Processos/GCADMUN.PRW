#INCLUDE "rwmake.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDE "AvPrint.ch"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GCADMUN  ºAutor  ³Microsiga           º Data ³  04/13/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Municipios                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±³Por       ³                                                            º±±
±±³Alteracao ³                                                            º±±
±±³          ³                                                            º±±
±±³          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GCADMUN()

Private cCadastro := "Municipios EDI"

Private aRotina := MenuDef()

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZ2"

Private cFiltro := " Z2_DTFIM = '' "

dbSelectArea("SZ2")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,,,,,,,,,cFiltro)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros

Return

Static Function MenuDef()
Local aRotina

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
			 {"Visualizar","U_MOSTRAZ2(3)",0,2} ,;
			 {"Incluir","U_MOSTRAZ2(1)",0,3} ,;
			 {"Alterar","U_MOSTRAZ2(2)",0,4} ,;
			 {"Excluir","U_MOSTRAZ2(3)",0,5} }
             
Return aRotina             

User Function MOSTRAZ2(nOpc)

SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcao de acesso para o Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
IF nOpc == 1
	nOpcx:=3
ElseIf	nOpc == 2
	nOpcx:=4
Else
	nOpcx:=2
EndIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZ2")
nUsado:=0
aHeader:={}
cNaoContem := "Z2_FILIAL,Z2_EST,Z2_CODMUN,Z2_MUN"
//	Z2_DTINI	Z2_DTFIM

While !Eof() .And. (x3_arquivo == "SZ2")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. ! Alltrim(x3_campo) $ cNaoContem
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,"",;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	dbSkip()
End
Private nPosI := Ascan(aHeader, {|E| Trim(E[2]) == "Z2_DTINI"})
Private nPosF := Ascan(aHeader, {|E| Trim(E[2]) == "Z2_DTFIM"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
xx:="1"
If nOpcx == 3 // Inclusao
	aCols      := {}
	_Z2_EST	   := Space(TamSx3("Z2_EST")[1])
	_Z2_CODMUN := Space(TamSx3("Z2_CODMUN")[1])
	_Z2_MUN	   := Space(TamSx3("Z2_MUN")[1])
	aAdd(aCols,Array(Len(aHeader)+1))
	For nX := 1 To Len(aHeader)
		aCols[1][nX] := CriaVar(aHeader[nX][2])
	Next nX
	aCols[1][Len(aHeader)+1] := .F.

Else
// ALTERACAO EXCLUSAO VISUALIZACAO
	_Z2_EST	   := SZ2->Z2_EST	
	_Z2_CODMUN := SZ2->Z2_CODMUN
	_Z2_MUN	   := SZ2->Z2_MUN
//	_Z2_PRAZO  := SZ2->Z2_PRAZO
	aCols := {}
	DbSelectArea("SZ2"); DbSetOrder(3)
	SZ2->(DbSeek(xFilial("SZ2") + _Z2_EST + _Z2_CODMUN, .F.))
	While SZ2->(!Eof()) .And. SZ2->Z2_FILIAL == xFilial("SZ2") .And.;
	   SZ2->Z2_EST == _Z2_EST .And. SZ2->Z2_CODMUN == _Z2_CODMUN
		Aadd(aCols, Array(nUsado + 1))
		For _ni := 1 To nUsado
			aCols[Len(aCols), _ni] := FieldGet(FieldPos(aHeader[_ni, 2]))
		Next
		aCols[Len(aCols), nUsado + 1] := .F.
		SZ2->(DbSkip())
	Enddo
EndIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Cabecalho do Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//dData	:= MsDate()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Rodape do Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLinGetD:=0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:="CADASTRO PRAZO CIDADES EDI"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.
// Z2_FILIAL	Z2_EST	Z2_CODMUN	Z2_MUN	Z2_PRAZO	D_E_L_E_T_	R_E_C_N_O_	Z2_DTINI	Z2_DTFIM
IF nOpcx == 3  // Inclusao
	AADD(aC,{"_Z2_EST"	    ,{15,20},"Estado"	    ,"@!" ,'ExistCpo("SX5","12" + _Z2_EST)'                 ,"12"    ,})
	AADD(aC,{"_Z2_CODMUN"	,{15,80},"Cod. Mun. ZF"	,"@!" ,'Vazio() .Or. ExistCpo("CC2",_Z2_EST+_Z2_CODMUN) .Or. U_Z2MUN()',"CC2ZZ2",})
	AADD(aC,{"_Z2_MUN"	    ,{28,10},"Municipio   "	,"@!" ,''                                      ,        ,.F.})
Else
	AADD(aC,{"_Z2_EST"	    ,{15,20},"Estado"	    ,"@!" ,'ExistCpo("SX5","12"+_Z2_EST)'                   ,"12"    ,.F.})
	AADD(aC,{"_Z2_CODMUN"	,{15,80},"Cod. Mun. ZF"	,"@!" ,'Vazio() .Or. ExistCpo("CC2",_Z2_EST+_Z2_CODMUN)',"CC2ZZ2",.F.})
	AADD(aC,{"_Z2_MUN"	    ,{28,10},"Municipio   "	,"@!" ,''                                      ,        ,.F.})
EndIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Rodape do Modelo 2         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

// AADD(aR,{"cNomeFor"	,{120,10},"Nome: "	,"@!",,,.F.})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com coordenadas da GetDados no modelo2                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCGD:={54,5,118,315}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados da Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLinhaOk:="ExecBlock('Z2LinOk',.f.,.f.)"
cTudoOk:="ExecBlock('Z2TudOk',.f.,.f.)"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Modelo2                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente

If lRetMod2
	IF nOpcx == 3  // Inclusao
		DbSelectArea("SZ2"); DbSetOrder(3)
		For ii := 1 To Len(aCols)
			If !(aCols[ii, Len(aCols[ii])])              // Linha Nao Deletada
				dDtIni := aCols[ii,nPosI]
				dDtFim := aCols[ii,nPosF]
				If ! DbSeek(xFilial("SZ2") + _Z2_EST + _Z2_CODMUN + Dtos(dDtIni) ,.F.)
					RecLock("SZ2", .T.)
				Else
					RecLock("SZ2", .F.)
				EndIf	
				SZ2->Z2_FILIAL := xFilial("SZ2")
				SZ2->Z2_EST    := _Z2_EST
				SZ2->Z2_CODMUN := _Z2_CODMUN
				SZ2->Z2_MUN    := _Z2_MUN
				For jj := 1 To Len(aHeader)
					FieldPut(FieldPos(Alltrim(aHeader[jj, 2])), aCols[ii, jj])
				Next
				SZ2->(MsUnlock())
			Endif
		Next
	ElseIF nOpcx == 4  // Alteracao
		DbSelectArea("SZ2"); DbSetOrder(3) 
		xx:= "1"
		For ii := 1 To Len(aCols)
			dDtIni := aCols[ii,nPosI]
			dDtFim := aCols[ii,nPosF]
			If DbSeek(xFilial("SZ2") + _Z2_EST + _Z2_CODMUN + Dtos(dDtIni) ,.F.)
				If !(aCols[ii, Len(aCols[ii])])              // Linha Nao Deletada
					RecLock("SZ2", .F.)
					SZ2->Z2_EST    := _Z2_EST
					SZ2->Z2_CODMUN := _Z2_CODMUN
					SZ2->Z2_MUN    := _Z2_MUN
					For jj := 1 To Len(aHeader)
						FieldPut(FieldPos(Alltrim(aHeader[jj, 2])), aCols[ii, jj])
					Next
					SZ2->(MsUnlock())
				Else
					RecLock("SZ2", .F.)
					SZ2->(DbDelete())
					SZ2->(MsUnlock())
				EndIF
			Else
				If !(aCols[ii, Len(aCols[ii])])              // Linha Nao Deletada
					RecLock("SZ2", .T.)
					SZ2->Z2_FILIAL := xFilial("SZ2")
					SZ2->Z2_EST    := _Z2_EST
					SZ2->Z2_CODMUN := _Z2_CODMUN
					SZ2->Z2_MUN    := _Z2_MUN
					For jj := 1 To Len(aHeader)
						FieldPut(FieldPos(Alltrim(aHeader[jj, 2])), aCols[ii, jj])
					Next
					SZ2->(MsUnlock())
				Endif
			Endif
		Next
	ElseIf nOpcx == 2  // Exclusao
	    /*
		DbSelectArea("SZK"); DbSetOrder(2)
		SZK->(DbSeek(xFilial("SZK") + cFornece + cLoja, .F.))
		While SZK->(!Eof()) .And. SZK->ZK_FILIAL == xFilial("SZK") .And.;
			SZK->ZK_FORNECE + SZK->ZK_LOJAFOR == cFornece + cLoja
			RecLock("SZK", .F.)
			SZK->(DbDelete())
			SZK->(MsUnlock())
			DbSkip()
		EndDO
		*/
	Endif
Endif

Return

User Function Z2linok() // Valida Linha
lRet := .T.

cDtIni := aCols[n,nPosI]

If ! (aCols[n, Len(aCols[n])])              // Linha Nao Deletada
	For nL:=1 To Len(aCols)
		If ! (aCols[nL, Len(aCols[nL])])              // Linha Nao Deletada
			If aCols[nL,nPosI] == cDtIni .And. nL <> n
				Alert("Data Inicial ja lancada...")
				lRet := .F.
			EndIF
		EndIF
	Next
EndIF

Return(lRet)

User Function Z2tudok() // Valida Ok
lRet := .T.
cDtIni := aCols[n,nPosI]

If ! (aCols[n, Len(aCols[n])])              // Linha Nao Deletada
	For nL:=1 To Len(aCols)
		If ! (aCols[nL, Len(aCols[nL])])              // Linha Nao Deletada
			If aCols[nL,nPosI] == cDtIni .And. nL <> n
				Alert("Data Inicial ja lancada...")
				lRet := .F.
			EndIF
		EndIF
	Next
EndIF

/*
// Checar campos nao preenchidos
If lRet
	For nM:=1 To Len(aCols)
		If !(aCols[nM, Len(aCols[nM])])              // Linha Nao Deletada
			For jj := 1 To Len(aHeader)
				If EmpTy(aCols[nM, jj])
					Alert("Campo Obrigatorio nao Preenchido...")
					lRet := .F.
				EndIF
			Next
			If ! lRet
				Exit
			EndIF
		EndIF
	Next
EndIF
*/
Return(lRet)      

User FuncTion Z2MUN()

_Z2_MUN := Posicione("CC2",1,xFilial("CC2") + _Z2_EST + _Z2_CODMUN,"CC2_MUN")

Return(.T.)