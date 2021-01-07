#include 'protheus.ch'
#include 'parmtype.ch'


User Function MkBrwSA1()

Local aCpos				:= {}
Local aCampos			:= {}
Local nI				:= 0 
Local cAlias			:= "SA1"

Private aRotina     	:= {}
Private cCadastro   	:= "Cadastro de Clientes"    
Private aRecSel 		:= {}	

// Button
AADD(aRotina,{"Visualizar Lote","U_VisLote",0,5})
 
AADD(aCpos,	"A1_ZOK"	)	//aCpos[1]
AADD(aCpos,	"A1_FILIAL"	)	//aCpos[2]
AADD(aCpos,	"A1_COD"	)	//aCpos[3]
AADD(aCpos,	"A1_LOJA"	)	//aCpos[4]
AADD(aCpos,	"A1_NOME"	)	//aCpos[5]
AADD(aCpos,	"A1_TIPO"	)	//aCpos[6]

dbSelectArea("SX3")
dbSetOrder(2)  // O segundo índice da Sx3 é a ordem dos campos.
For nI := 1 To Len(aCpos)
  	 If dbSeek(aCpos[nI]) //Localiza um registro com determinado valor da expressão da chave de índice.
  	 	aAdd(aCampos,{X3_CAMPO,"",IF(nI==1,"",Trim(X3_TITULO)),;  // Nome do campo, titulo do campo e a picture.
   			 Trim(X3_PICTURE)})
	 EndIf
Next

DbSelectArea(cAlias)
DbSetOrder(1)
MarkBrow(cAlias,aCpos[1],"A1_TIPO == ' '",aCampos,.F.,GetMark(,"SA1","A1_ZOK"))

Return Nil


User Function VisLote() // Funcao para o Botao Visualizar Lote,
	
Local cMarca	:= ThisMark()
Local nX		:= 0
Local lInvert	:= ThisInv()
Local cTexto  	:= ""
Local cEOL		:= CHR(10)+CHR(13)  //CHR (determina quando faz a quebra da linha "enter")
Local oDlg         
Local oMemo

DbSelectArea("SA1")
DbGoTop()

While SA1->(!EOF())//!EOF final de arquivo.

	If SA1->A1_ZOK == cMarca .AND. !lInvert
  		aAdd(aRecSel,{SA1->(Recno()),SA1->A1_COD, SA1->A1_LOJA, SA1->A1_NREDUZ})
 	ElseIf SA1->A1_ZOK != cMarca .AND. lInvert 
  		aAdd(aRecSel,{SA1->(Recno()),SA1->A1_COD,SA1->A1_LOJA, SA1->A1_NREDUZ})
 	EndIf

 SA1->(dbSkip())// forma o loop para passar linha a linha dando SKIP para a proxima linha no final do IF

EndDo

If Len(aRecSel) > 0
	cTexto := "Código  | Loja | Nome Reduzido        "+cEol
	//		  "1234567890123456789012345678901234567890
	//		  "CCCCCC |  LL  | NNNNNNNNNNNNNNNNNNNN +cEol
	
	For nX := 1 to Len(aRecSel)
		cTexto += aRecSel[nX][2]+Space(1)+"|"+Space(2)		//Codigo
		cTexto += aRecSel[nX][3]+ Space(3)+"|"				//Loja
       	cTexto += Space(1)+SUBSTRING(aRecSel[nX][4],1,20)+Space(1) //Nome reduzido
       	cTexto += cEOL
	Next nX
	
	

 	DEFINE MSDIALOG oDlg TITLE "Clientes Selecionados" From 000,000 ;
                 TO 350,400 PIXEL
	@ 005,005 GET oMemo  VAR cTexto MEMO SIZE 150,150 OF oDlg PIXEL
	oMemo:bRClicked := {||AllwaysTrue()}
     DEFINE SBUTTON  FROM 005,165 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE ;
      OF oDlg PIXEL 
	    ACTIVATE MSDIALOG oDlg CENTER
	    
	    LimpaMarca()
	    aRecSel:={} // limpa o ARecSel para nao ficar acumulando registro

EndIf

If nOpca == 1
	MsgInfo("Dados Processados!!!")
EndIf

Return



Static Function LimpaMarca()

Local nX := 0

For nX := 1 to Len(aRecSel)
	SA1->(DbGoto(aRecSel[nX][1]))
	RecLock("SA1",.F.)
		SA1->A1_ZOK := Space(2)
	MsUnLock()	
	
	//aRecSel:={} //Dá erro.
Next nX

Return






