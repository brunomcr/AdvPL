#Include "Protheus.ch"


User Function XMODELO3()

Local aArea			:= GetArea()
Local aCorLeg		:= {{C210StrLeg(1),"BR_AZUL"	},; // 1 - Pedidos Fechados.
                    	{C210StrLeg(2),"BR_AMARELO"	}} // 2 - Pedidos em Aberto.
                    
Private cCad       	:= "Cadastro de Pedido de Venda"
Private aRotina	   	:= MenuDef() 
Private cCli       	:= ""
Private nTot       	:= 0
Private aCols  		:= {}
Private aHeader   	:= {}
Private aReg 	    := {}
Private bCam       := {|nField| FieldName(nField)}
Private aSiz       := {}
Private aInf       := {}
Private aObj       := {}
Private aPObj      := {}
Private aPGet      := {}
Private oDlg

//Retorna a área útil das janelas Protheus
aSiz := MsAdvSize()

// Será utilizado três áreas na janela
// 1ª - Enchoice, sendo 80 pontos pixel
// 2ª - MsGetDados, o que sobrar em pontos pixel é para o objeto
// 3ª - Rodapé que é a própria janela, sendo 15 pontos pixel

aAdd(aObj,{100,70,.T.,.F.})      //antonio
aAdd(aObj,{100,140,.T.,.F.})
aAdd(aObj,{100,10,.T.,.F.})

// Cálculo automático da dimensão dos objetos (altura/largura) em pixel
aInf  := {aSiz[1],aSiz[2],aSiz[3],aSiz[4],3,3}
aPObj := MsObjSize(aInf,aObj)//permite a montagem da janela maximizando a utilização do espaço da tela existente.

// Cálculo automático de dimensões dos objetos MSGET
aPGet := MsObjGetPos((aSiz[3] - aSiz[1]),315,{{004,024,240,270}}) //Esta função realiza o cálculo automático do posicionamento dos objetos GET conforme o dimensionamento da tela.

SC5->(DbSetOrder(1))
SC5->(DbGoTop())
MBrowse(,,,,"SC5",,,,,,aCorLeg)

RestArea(aArea)

Return



Static Function MenuDef()

Private aRotina := {{ "Pesquisar"  ,"AxPesqui" , 0 , 1},;
					{ "Visualizar" ,"U_C210AIE", 0 , 2},;
 					{ "Incluir"    ,"U_C210INC", 0 , 3},;
                    { "Alterar"    ,"U_C210AIE", 0 , 4},;
                    { "Excluir"    ,"U_C210AIE", 0 , 5},;
                    { "Legenda"    ,"U_C210LEG", 0 , 6}}
        
Return(aRotina)



Static Function C210StrLeg(nLeg)

Local cStrLeg := ""
Local aFilLEG := {}
Local aArea   := GetArea()

Static	nLeg := 0

Do Case
	
	Case nLeg == 1
		cStrLeg := "EMPTY(C5_NOTA)" 	//2 - PEDIDOS EM ABERTOS
	Case nLeg == 2
		cStrLeg := "!EMPTY(C5_NOTA)" 	//1 - PEDIDOS FECHADOS
	OtherWise
		cStrLeg := ""
		
End Case

RestArea(aArea)


Return cStrLeg



User Function C210LEG()

Local	aCores	:= {}
Local   aArea   := GetArea()

Aadd(aCores,{"BR_AZUL"		,"1 - Pedidos em Aberto"	})
Aadd(aCores,{"BR_AMARELO"	,"2 - Pedidos Fechados"		})

RestArea(aArea)

Return BrwLegenda("Cadastro de Pedido de Venda","Legenda",aCores)



User Function C210INC(cAlias, nReg, nOpc)

Local oDlg
Local oGet
Local nX          := 0
Local nOpcA       := 0 
Local cNumPed     := ""
Local aPedVen     := {}
Local aArea       := GetArea()
Local cNum		  := GetSXENum("SC5","C5_NUM")
Local nTamCmp 	  := Len(CriaVar("C5_NUM")) 
Local nCodSeq     := 0
Local cCodSeqPac  := ""
Local aVet		  := {}
Local aVetFil	  := {}
Local aVetFilItm  := {}
Local cCodItm	  := ""
Local cCodDad	  := ""
Local aVetPrdItm  := {}
Local cCodPrd	  := ""
Local aPreNt	  := {}
Local cColVei     := ""
Local cTFr		  := ""

Private aGets     := {}
Private aTela	  := {}
Private aHeader   := {}
Private aCols     := {}

RegToMemory("SC5",Iif(nOpc==3,.T.,.F.))

(cAlias)->(DbSetOrder(1))

For nX := 1 to FCount()
	M->&(Eval(bCam,nX)) := CriaVar(FieldName(nX),.T.)
Next nX

C020aHEADER()
C020aCOLS(nOpc)

DEFINE MSDIALOG oDlg TITLE cCad FROM;
aSiz[7],aSiz[1] TO aSiz[6],aSiz[5] OF oMainWnd PIXEL
	EnChoice(cAlias,nReg,nOpc, , , , , aPObj[1])
	
	oGet := MsGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4],;
	nOpc,"U_C020LOK(3)",".T.","+C6_ITEM",.T.)
	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
{|| Iif(C020TOK(nOpc) .And. Obrigatorio(aGets,aTela),(nOpcA := 1, oDlg:End()),NIL)},;
{|| oDlg:End(),,,,}) 

If nOpcA == 1 .And. nOpc ==3
	C020GRV(nOpc)
EndIf 

RestArea(aArea)

Return



Static Function C020aHEADER()

Local aArea := GetArea()

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC6")

While !Eof() .And. X3_ARQUIVO == "SC6"
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
		aAdd(aHeader, { Trim(X3Titulo()),;
		X3_CAMPO,;
		X3_PICTURE,;
		X3_TAMANHO,;
		X3_DECIMAL,;
		X3_VALID,;
		X3_USADO,;
		X3_TIPO,;
		X3_ARQUIVO,;
		X3_CONTEXT })
	EndIf
	DbSkip()
EndDo

RestArea(aArea)

Return



Static Function C020aCOLS(nOpc)                                        

Local aArea   := GetArea()
Local cChav   := ""
Local cAlias  := "SC6"
Local nI      := 0 
Local nJ      := 0

If nOpc <> 3

	cChav := SC5->C5_NUM
	
	DbSelectArea("SC6")
	DbSetOrder(1)
	If (dbSeek(xFilial("SC6")+cChav))
	
		While !Eof() .And. SC6->(C6_FILIAL + C6_NUM) == xFilial("SC6") + cChav
		
			aAdd (aReg, SC6->(RecNo() ) )
			aAdd (aCols, Array(Len(aHeader)+1 ) )
			For nI := 1 To Len(aHeader)
				If aHeader[nI,10] == "V"
					aCols[Len(aCols),nI] := CriaVar(aHeader[nI,2],.T.)
				Else
					aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
				EndIf
			Next nI
			aCols[Len(aCols),Len(aHeader)+1] := .F.
			dbSkip()
		EndDo
    EndIf
Else
    
	aAdd(aCols,Array(Len(aHeader) + 1))
	For nI := 1 to Len(aHeader)
			aCols[1,nI] := CriaVar(aHeader[nI,2], .T.)   
	Next nI   
	aCols[1, GdFieldPos("C6_ITEM")]    := StrZero(1,2)
	aCols[1, Len( aHeader )+1 ]        := .F.
	
EndIf

RestArea(aArea)

Return


User Function C020LOK(nOpc,aColsVal)

Local nI    := 0
Local lRet  := .T.
Local aArea :=GetArea()  
Local lVer  := .F.

Local cMens := "Produto Inexistente no Cadastro, Favor Verificar!!"


For nI := 1 To Len(aCols)
	If aCols[nI,Len(aHeader)+1]
		Loop
	EndIf
    
	If !aCols[nI,Len(aHeader)+1]
		If Empty(Posicione("SB1", 1, xFilial("SB1") +aCols[n,GdFieldPos("C6_PRODUTO")],"B1_DESC"))
			MsgAlert(cMens,cCad)
			lRet := .F.
		EndIf
	EndIf
    
Next nI

RestArea(aArea)

Return(lRet)


Static Function C020TOK(nOpc)

Local nI   := 0
Local lRet := .T. 
Local lVer := .F.      
Local aArea:=GetArea()


For nI:= 1 To Len(aCols)
	If aCols[nI,Len(aHeader)+1]
		Loop
	EndIf
	If Empty(aCols[nI,GdFieldPos("C6_PRODUTO")]) .And. lRet
		MsgAlert("Campo PRODUTO preenchimento obrigatorio",cCad)          
		lRet := .F.
	EndIf
Next nI                

RestArea(aArea)

Return (lRet)



Static Function C020GRV(nOpc,aAlt)   

Local nX    	:= 0
Local nI    	:= 0  
Local nCon		:= 0
Local aArea 	:=GetArea()

// Se for Inclusão
If nOpc == 3 
    // Grava os Itens
	SC5->(DbSetOrder(1))
	For nX:=1 To Len(aCols)
		If !aCols[nX,Len(aCols[nX])]
			RecLock ("SC6", .T.)
				For nI := 1 To Len(aHeader)
					FieldPut(FieldPos(Trim(aHeader[nI,2] ) ), aCols[nX,nI])
				Next nI
				SC6->C6_FILIAL  := xFilial("SC6")
				SC6->C6_NUM		:= M->C5_NUM
			MsUnLock()
		EndIf   
		
	Next nX	
    
	//Grava Cabeçalho
	DbSelectArea("SC5")
	RecLock ("SC5",.T.)
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX,xFilial("SC5")) 
			Else
				FieldPut(nX, M->&(Eval(bCam,nX)))
			EndIf
		Next nX
	MsUnLock()
    
EndIf


// Se for Alteração
If nOpc == 4
	//Grava os itens conforme as alterações
	SC6->(DbSetOrder(1))
	For nX := 1 To Len(aCols)
		If nX <= Len(aReg)
			SC6->(DbGoTo(aReg[nX]))
			RecLock("SC6",.F.)
				If aCols[nX, Len(aHeader)+1]
					dbDelete()
				EndIf
		Else	
				If !aCols[nX,Len(aHeader)+1]
					RecLock("SC6",.T.)
				EndIf
		EndIf
		
		If !aCols[nX,Len(aHeader)+1]
			For nI:= 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[nI,2] ) ),aCols[nX,nI])
			Next nI
			SC6->C6_FILIAL  := xFilial("SC6")
			SC6->C6_NUM	 	:= M->C5_NUM
		EndIf					         
		MsUnLock()
	
	Next nX
	
	// Grava o Cabeçalho
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
		For nX:=1 To FCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX, xFilial("SC5"))
			Else
				FieldPut(nX, M->&(Eval(bCam,nX) ) )
			EndIf
		Next
	MsUnLock()

EndIf 

// Se for Exclusão
If nOpc == 5
	
	// Deleta os Itens 
	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+M->C5_NUM)
	While !Eof() .And. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6") + M->C5_NUM
		RecLock("SC6")
			dbDelete()
		MsUnLock()
		dbSkip()
	EndDo
	
	// Deleta o Cabeçalho
	dbSelectArea("SC5")
	RecLock("SC5",.F.)
		dbDelete()
	MsUnLock()  
	
EndIf

RestArea(aArea)

Return



User Function C210AIE(cAlias, nReg, nOpc)

Local oDlg
Local oGet
Local nX        := 0
Local nOpcA     := 0   
Local nOpcAux   := 2    
Local aCmpEdt		
Local bOk		:= {|| Iif( Obrigatorio( oMsmGet:aGets, oMsmGet:aTela) , ( lOk := .T., oDlg:End() ), lOk := .F. ) }
Local bCancel  	:= {|| lOk := .F., oDlg:End() }
Local cNumPed   := "" 
Local aArea     :=GetArea()

Private aColsVal:= {}
Private aHeader := {}
Private aCols   := {}
Private aGets   := {}
Private aTela   := {}
Private aReg    := {}

DbSelectArea(cAlias)
DbSetOrder(1)            


RegToMemory("SC5",Iif(nOpc==3,.T.,.F.))

For nX:= 1 To PCount()
	M->&(Eval(bCam,nX) ) := FieldGet(nX)
Next nX

If nOpc == 5 .or. nOpc == 4

	C020aHEADER()
	C020aCOLS(nOpc,cNumPed)
	aColsVal:= aClone(aCols)
		
	DEFINE MSDIALOG oDlg TITLE cCad FROM;
	aSiz[7],aSiz[1] TO aSiz[6],aSiz[5] OF oMainWnd PIXEL
	   	EnChoice(cAlias,nReg,nOpc, , , , ,aPObj[1])
		
		oGet := MSGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4],;
		nOpc,"U_C020LOK(4,aColsVal)",".T.","+C6_ITEM",.T.)
			
	ACTIVATE MSDIALOG oDlg ON INIT EnChoiceBar(oDlg,;
	{|| Iif(C020TOK(nOpc) ,(nOpcA := 1, oDlg:End()),NIL)},;
	{|| oDlg:End(),,,,}) 

	If nOpcA == 1 .And. (nOpc == 4 .Or. nOpc == 5 )  
		C020GRV(nOpc,aReg)
	EndIf

Else

	C020aHEADER()
	C020aCOLS(nOpc,cNumPed)
	aColsVal:= aClone(aCols)
	
	DEFINE MSDIALOG oDlg TITLE cCad FROM;
	aSiz[7],aSiz[1] TO aSiz[6],aSiz[5] OF oMainWnd PIXEL
	   	EnChoice(cAlias,nReg,nOpc, , , , ,aPObj[1])
	
		oGet := MSGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4],;
		nOpc,"U_C020LOK(4,aColsVal)",".T.","+C6_ITEM",.T.)
		
	ACTIVATE MSDIALOG oDlg ON INIT EnChoiceBar(oDlg,;
	{|| Iif(C020TOK(nOpc) ,(nOpcA := 1, oDlg:End()),NIL)},;
	{|| oDlg:End(),,,,}) 
	
EndIf
	
RestArea(aArea)

Return