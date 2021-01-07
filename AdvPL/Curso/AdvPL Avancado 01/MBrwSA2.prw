#Include "Protheus.ch"
#Include "parmtype.ch"
#Include "PROTHEUS.CH"

User Function MBrwSA2()

Local cAlias  			:= "SA2"
Local aCores  		:= {}
Local cFiltra 		:= cFiltra:="A2_FILIAL == '"+xFilial('SA2')+"' .And. A2_EST == 'SP'" // filtra para aparecer somente fornecedores(SA2) de SP
								//A2_FILIAL == 'SA2' .And. A2_EST == 'SP'

Private cCadastro	:= "Cadastro de Fornecedores"
Private aRotina  	:= {} //Buttons               
Private aIndexSA2	:= {}	
Private bFiltraBrw	:= { || FilBrowse(cAlias,@aIndexSA2,@cFiltra) } //

//Buttons 
AADD(aRotina,{"Pesquisar"	,"PesqBrw"		,0,1}) 
AADD(aRotina,{"Visualizar"	,"AxVisual"		,0,2})
AADD(aRotina,{"Incluir"		,"U_BInclui"	,0,3})
AADD(aRotina,{"Alterar"		,"U_BAltera"	,0,4})
AADD(aRotina,{"Excluir"		,"U_BDeleta"	,0,5})
AADD(aRotina,{"Legenda"		,"U_BLegenda"	,0,3})
AADD(aRotina,{"Todos"		,"U_MbrwTF"		,0,6})

//Legenda
AADD(aCores,{"A2_TIPO == 'F'"	,"BR_VERDE"		})
AADD(aCores,{"A2_TIPO == 'J'"	,"BR_AMARELO"	})
AADD(aCores,{"A2_TIPO == 'X'"	,"BR_LARANJA"	})
AADD(aCores,{"A2_TIPO == 'R'"	,"BR_MARRON"	})
AADD(aCores,{"Empty(A2_TIPO)"	,"BR_PRETO"		})

dbSelectArea(cAlias)//Select SA2
dbSetOrder(1) 		// Index 1 

//+------------------------------------------------------------
//| Cria o filtro na MBrowse utilizando a função FilBrowse
//+------------------------------------------------------------
Eval(bFiltraBrw) // Se comentar este código o filtro não funcional. A função eVal que executa o bloco de código.

dbGoTop()
mBrowse(6,1,22,75,cAlias,,,,,,aCores) // MBrowser

return

//+---------------------------------------
//|Função: BInclui - Rotina de Inclusão
//+---------------------------------------

User Function BInclui(cAlias,nReg,nOpc)

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
User Function BAltera(cAlias,nReg,nOpc)

Local nOpcao := AxAltera(cAlias,nReg,nOpc)

If nOpcao == 1
	MsgInfo("Alteração efetuada com sucesso!")
Else
	MsgInfo("Alteração cancelada!")
Endif	

Return Nil


//+-----------------------------------------
//|Função: BDeleta - Rotina de Exclusão
//+-----------------------------------------
User Function BDeleta(cAlias,nReg,nOpc)

Local nOpcao := AxDeleta(cAlias,nReg,nOpc)

If nOpcao == 1
	MsgInfo("Exclusão efetuada com sucesso!")
Else
	MsgInfo("Exclusão cancelada!")
Endif	

Return Nil


//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function BLegenda()

Local ALegenda :={}

AADD(aLegenda,{"BR_VERDE"	,"Pessoa Física"	})
AADD(aLegenda,{"BR_AMARELO"	,"Pessoa Jurídica"	})
AADD(aLegenda,{"BR_LARANJA"	,"Exportação"		})
AADD(aLegenda,{"BR_MARRON"	,"Fornecedor Rural"	})
AADD(aLegenda,{"BR_PRETO"	,"Não Classificado"	})

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

User Function MbrwTF()

cFiltra := NIL
mBrowse(6,1,22,75,cAlias,,,,,,aCores)

Return 

/*
//+-------------------------------------------
//|Função: MbrwMT - Rotina de Mostrar Tudo
//+-------------------------------------------
User Function MbrwTF()

Local cAlias  		:= "SA2"
Local aCores  		:= {}

Private cCadastro	:= "Cadastro de Fornecedores"
Private aRotina  	:= {} //Buttons

//Buttons 
AADD(aRotina,{"Pesquisar"	,"PesqBrw"		,0,1}) 
AADD(aRotina,{"Visualizar"	,"AxVisual"		,0,2})
AADD(aRotina,{"Incluir"		,"U_BInclui"	,0,3})
AADD(aRotina,{"Alterar"		,"U_BAltera"	,0,4})
AADD(aRotina,{"Excluir"		,"U_BDeleta"	,0,5})
AADD(aRotina,{"Legenda"		,"U_BLegenda"	,0,3})
AADD(aRotina,{"Todos"		,"U_MbrwTF"		,0,6})

//Legenda
AADD(aCores,{"A2_TIPO == 'F'"	,"BR_VERDE"		})
AADD(aCores,{"A2_TIPO == 'J'"	,"BR_AMARELO"	})
AADD(aCores,{"A2_TIPO == 'X'"	,"BR_LARANJA"	})
AADD(aCores,{"A2_TIPO == 'R'"	,"BR_MARRON"	})
AADD(aCores,{"Empty(A2_TIPO)"	,"BR_PRETO"		})

dbSelectArea(cAlias)//Select SA2
dbSetOrder(1) 		// Index 1 
dbGoTop()
mBrowse(6,1,22,75,cAlias,,,,,,aCores) // MBrowser

return
*/