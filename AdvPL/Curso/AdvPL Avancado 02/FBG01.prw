#include 'protheus.ch'
#include 'parmtype.ch'


User Function FBG01() 
 
Local xAutoCab := {} 
 
AADD(xAutoCab,{"A1_FILIAL" ,xFilial("SA1")  , Nil})
AADD(xAutoCab,{"A1_COD"   , "000303"        , Nil})
AADD(xAutoCab,{"A1_LOJA"  , "01"            , Nil})
AADD(xAutoCab,{"A1_NOME"  , "SONIA DIAS "  , Nil})
AADD(xAutoCab,{"A1_NREDUZ"  , "SONIAS"    , Nil})
AADD(xAutoCab,{"A1_END"  , "RUA MATHIAS"   , Nil})
AADD(xAutoCab,{"A1_TIPO" , "R"      , Nil})
AADD(xAutoCab,{"A1_EST" , "MG"      , Nil})
AADD(xAutoCab,{"A1_MUN" , "BELO HORIZONTE"   , Nil}) 
 
BeginTran() //

lMsErroAuto := .F.
MsExecAuto({|x,y| MATA030(x,y)}, xAutoCab, 3) // FUNCAO a ser usada MATA030 , INCLUI as informacoes xAutoCab, 3 eh a opcao de incluir 
If lMsErroAuto
         DisarmTransaction() //Evita a gravação de dados.
         Alert("Ocorreu um Erro!!!")
         	Else
         	  MsgInfo("Atualizado com Sucesso!!")
               EndTran()
EndIf 
////
MsUnlockAll() 

	
return
return