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
//|Função: BInclui - Rotina de Inclusão
//+---------------------------------------

User Function AInclui(cAlias,nReg,nOpc)

Local nOpcao := AxInclui(cAlias,nReg,nOpc)

If nOpcao == 1
    MsgInfo("Inclusão efetuada com sucesso!")
Else
	  MsgInfo("Inclusão cancelada!")
EndIf	

Return Nil


//+-----------------------------------------
//|Função: BAltera - Rotina de Alteração
//+-----------------------------------------
User Function AAltera(cAlias,nReg,nOpc)

Local nOpcao := AxAltera(cAlias,nReg,nOpc)

If nOpcao == 1
	MsgInfo("Alteração efetuada com sucesso!")
Else
	MsgInfo("Alteração cancelada!")
Endif	

Return Nil


//+-----------------------------------------
//|Função: ADeleta - Rotina de Exclusão
//+-----------------------------------------
User Function ADeleta(cAlias,nReg,nOpc)

Local nOpcao := AxDeleta(cAlias,nReg,nOpc)

If nOpcao == 1
	MsgInfo("Exclusão efetuada com sucesso!")
Else
	MsgInfo("Exclusão cancelada!")
Endif	

Return Nil


//+-------------------------------------------
//|Função: ALegenda - Rotina de Legenda
//+-------------------------------------------
User Function ALegenda()

Local ALegenda :={}

AADD(aLegenda,{"BR_VERDE"	,"CD"	})
AADD(aLegenda,{"BR_AMARELO"	,"DVD"	})

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil