#include 'protheus.ch'
#include 'parmtype.ch'

user function BRW01()

Local cAlias  		:= "SZ1"
Local aCores  		:= {}

Private cCadastro	:= "Cadastro de Produtos Persolnalizados"
Private aRotina  	:= {} //Buttons               

//Buttons 
AADD(aRotina,{"Pesquisar"	,"PesqBrw"		,0,1}) 
AADD(aRotina,{"Visualizar"	,"AxVisual"		,0,2})
AADD(aRotina,{"Incluir"		,"U_AInclui"	,0,3})
AADD(aRotina,{"Alterar"		,"U_AAltera"	,0,4})
AADD(aRotina,{"Excluir"		,"U_ADeleta"	,0,5})
AADD(aRotina,{"Legenda"		,"U_ALegenda"	,0,3})

//Legenda
AADD(aCores,{"Z1_LIST == '1'"	,"BR_VERDE", "CD"		})
AADD(aCores,{"Z1_LIST == '2'"	,"BR_AMARELO", "DVD"	})


dbSelectArea(cAlias)//Select cAlias
dbSetOrder(1) 		// Index 1 
dbGoTop()
mBrowse(6,1,22,75,cAlias,,,,,,aCores) // MBrowser
	
return

//+---------------------------------------
//|Fun��o: BInclui - Rotina de Inclus�o
//+---------------------------------------

User Function AInclui(cAlias,nReg,nOpc)

Local nOpcao := AxInclui(cAlias,nReg,nOpc)

If nOpcao == 1
    MsgInfo("Inclus�o efetuada com sucesso!")
Else
	  MsgInfo("Inclus�o cancelada!")
EndIf	

Return Nil


//+-----------------------------------------
//|Fun��o: BAltera - Rotina de Altera��o
//+-----------------------------------------
User Function AAltera(cAlias,nReg,nOpc)

Local nOpcao := AxAltera(cAlias,nReg,nOpc)

If nOpcao == 1
	MsgInfo("Altera��o efetuada com sucesso!")
Else
	MsgInfo("Altera��o cancelada!")
Endif	

Return Nil


//+-----------------------------------------
//|Fun��o: ADeleta - Rotina de Exclus�o
//+-----------------------------------------
User Function ADeleta(cAlias,nReg,nOpc)

Local nOpcao := AxDeleta(cAlias,nReg,nOpc)

If nOpcao == 1
	MsgInfo("Exclus�o efetuada com sucesso!")
Else
	MsgInfo("Exclus�o cancelada!")
Endif	

Return Nil


//+-------------------------------------------
//|Fun��o: ALegenda - Rotina de Legenda
//+-------------------------------------------
User Function ALegenda()

Local ALegenda :={}

AADD(aLegenda,{"BR_VERDE"	,"CD"	})
AADD(aLegenda,{"BR_AMARELO"	,"DVD"	})

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil