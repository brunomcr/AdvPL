#include "Protheus.ch"
#INCLUDE "DEFEMPSB.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA410LEG  บAutor  ณ  Caio de Paula     บ Data ณ  11/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada alteracao de legenda pedido de venda      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User FuncTion MA410LEG()
local cEmpresa	:= cEmpAnt 
Local a_Ret := {}//ParamIxb

If cEmpresa == FC

	Aadd(a_Ret,{"BR_VERDE","Pedido de Venda em Aberto"})
	Aadd(a_Ret,{"BR_VERDE_ESCURO","Pedido de Venda Aprovado"})
	Aadd(a_Ret,{"BR_AMARELO","Pedido de Venda Liberado"})
	Aadd(a_Ret,{"BR_MARRON_OCEAN","Picking Enviado"})
	Aadd(a_Ret,{"BR_LARANJA","Picking Separado"})
	Aadd(a_Ret,{"BR_VIOLETA","Pedido de Venda Faturado"})
	Aadd(a_Ret,{"BR_AZUL_CLARO","Somente NFe Enviado"})
	Aadd(a_Ret,{"BR_AZUL","Somente Etiqueta Enviado"})
	Aadd(a_Ret,{"BR_CINZA","NFe e Etiqueta enviados"})
	Aadd(a_Ret,{"BR_PINK","Pedido de Venda Coletado"})
	Aadd(a_Ret,{"BR_VERMELHO","Pedido de Venda Entregue"})
	Aadd(a_Ret,{"BR_PRETO","Objeto de Rastreio Inativo"})
	Aadd(a_Ret,{"BR_MARROM","Concluํdo com Residuo Eliminado"})
	Aadd(a_Ret,{"BR_BRANCO","Residuo"})

Else 
	a_Ret := ParamIxb
EndIf
Return(a_Ret)