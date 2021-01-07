//Bibliotecas
#Include "Protheus.ch"
#INCLUDE "DEFEMPSB.CH"
/*---------------------------------------------------------------------------------*
 | P.E.:  MT121BRW                                                                 |
 | Desc:  Adição de opções no Ações Relacionadas do Pedidos de Compra              |
 | Link:  http://tdn.totvs.com/pages/releaseview.action?pageId=51249528            |
 *---------------------------------------------------------------------------------*/
 
User Function MT121BRW()
local nPosEx	:= 0

aAdd(aRotina, {"Adiciona PA", "FinA050(,,3)", 0, 7, 0, Nil})
aAdd(aRotina, {"Rel PCxPAs", "u_SBC0001()", 0, 7, 0, Nil})
nPosEx := ASCAN(aRotina, { |x| UPPER(x[1]) == "EXCLUIR" })    
if nPosEx > 0
	aDel(aRotina,nPosEx)
	aSize(aRotina,len(aRotina)-1)
endif
Return