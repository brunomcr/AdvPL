#INCLUDE "FIVEWIN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SBF0003  º Autor ³ Caio de Paula      º Data ³  07/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Faturamento com Devoluções  por periodo       º±±
±±º          ³ com impostos                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Golden - Comercial                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SBRFAT03()
local oReport
local cMenTit := "" 
MsgAlert("Devido ao relatorio apresentar varias colunas, imprimir para o Excel")
oReport := ReportDef()
oReport:PrintDialog()
Return               

Static Function ReportDef()
local oReport 
local cPerg 	:= "SBF0003"
Private c_Cfop 	:=  Alltrim(SuperGetMV("SB_CODCFO",.F.,"5102,6102,6108,6110,5119,6119,5401,6401,5403,6403,6404,5405,5501,5502,6502,6922,5922"))

AjustaSx1(cPerg)
//If !PERGUNTE(cPerg,.T.)
//	Return
//Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01             // De Data                                        ³
//³ mv_par02             // Ate a Data                                     ³
//³ mv_par03             // De Produto                                     ³
//³ mv_par04             // Ate o Produto                                  ³
//³ mv_par05             // De Grupo                                       ³
//³ mv_par06             // Ate o Grupo                                    ³
//³ mv_par07             // Lista de Preço                                 ³
//³ mv_par08             // Tipo de Produto                                ³
//³ mv_par09             // De Vendedor                                    ³
//³ mv_par10             // Ate Vendedor                                   ³
//³ mv_par11             // De Supervisor                                  ³
//³ mv_par12             // Ate Supervisor                                 ³
//³ mv_par13             // De Gerente                                     ³
//³ mv_par14             // Ate Gerente                                    ³
//³ mv_par15             // Data do Custo                                  ³
//³ mv_par16             // De Cliente                                     ³
//³ mv_par17             // Ate Cliente                                    ³
//³ mv_par18             // De Estado                                      ³
//³ mv_par19             // Ate Estado                                     ³
//³ mv_par20             // Deduz devolução Sim ou Nao                     ³
//³ mv_par21             // Listar produtos nao vendido                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMenTit := " Somente CFOP do Parametro [SB_CODCFO]: "+c_Cfop
//oReport := TReport():New("GRVENDAS01","Estatisticas de Vendas (Produto)",cPerg, {|oReport| ReportPrint(oReport,cAliasSD1,cAliasSD2,cAliasSB1)},"Este programa ira emitir a relacao de vendas," + " " + "totalizando por produto.")
oReport := TReport():New(cPerg,cPerg,cPerg, {|oReport| ReportPrint(oReport)},"Este programa ira emitir a relacao de vendas," + " totalizando por produto."+cMenTit)
oReport:SetLandscape() 
oReport:SetDevice(4)
oReport:SetEnvironment(2)
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 1 Cabecalho                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oCabec := TRSection():New(oReport,"Cabec",{"SF2","TRB"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	//
oCabec:SetTotalInLine(.F.) 

TRCell():New(oCabec,"CCODCLI"		,,RetTitle("A1_COD"		),PesqPict("SA1","A1_COD")		,TamSx3("A1_COD"		)[1],,{||cCodCli	})
TRCell():New(oCabec,"CLOJACLI"   	,,RetTitle("A1_LOJA"	),PesqPict("SA1","A1_LOJA")		,TamSx3("A1_LOJA"		)[1],,{||cLojaCli	})
TRCell():New(oCabec,"CNOMECLI"		,,RetTitle("A1_NOME"	),PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME"		)[1],,{||cNomeCli	})
TRCell():New(oCabec,"CREGIAO"		,,RetTitle("A1_REGIAO"	),PesqPict("SA1","A1_REGIAO")	,TamSx3("A1_REGIAO"	)[1]+10 ,,{||cRegiao 	})
TRCell():New(oCabec,"CESTADO"		,,RetTitle("A1_EST"		),PesqPict("SA1","A1_EST")		,TamSx3("A1_EST"		)[1],,{||cEstado 	})
TRCell():New(oCabec,"CCIDADE"	    ,,RetTitle("A1_MUN"		),PesqPict("SA1","A1_MUN")		,TamSx3("A1_MUN"		)[1],,{||cCidade	})
TRCell():New(oCabec,"CFILIAL"		,,RetTitle("F2_FILIAL"	),PesqPict("SF2","F2_FILIAL")	,TamSx3("F2_FILIAL"		)[1],,{||c_Filial	})
TRCell():New(oCabec,"CNFISCAL"		,,RetTitle("F2_DOC"		),PesqPict("SF2","F2_DOC")		,TamSx3("F2_DOC"		)[1],,{||cNFiscal	})
TRCell():New(oCabec,"CSERIE"		,,RetTitle("F2_SERIE"	),PesqPict("SF2","F2_SERIE")	,TamSx3("F2_SERIE"		)[1],,{||cSerie		})
TRCell():New(oCabec,"CCONDPGTO"		,,RetTitle("F2_COND"	),PesqPict("SF2","F2_COND")		,TamSx3("F2_COND"		)[1],,{||cCond 		})
TRCell():New(oCabec,"DEMISSAO"		,,RetTitle("F2_EMISSAO"	),PesqPict("SF2","F2_EMISSAO")	,TamSx3("F2_EMISSAO"	)[1],,{||dEmissao	})
TRCell():New(oCabec,"CCANAL"	    ,,RetTitle("A1_XCANAL"	),PesqPict("SA1","A1_XCANAL")	,TamSx3("A1_XCANAL"		)[1],,{||CCANAL		})
TRCell():New(oCabec,"CTABELA"		,,RetTitle("A1_TABELA"	),PesqPict("SA1","A1_TABELA")	,TamSx3("A1_TABELA"		)[1],,{||cTabela	})
TRCell():New(oCabec,"CITEM"	   		,,RetTitle("D2_ITEM"	),PesqPict("SD2","D2_ITEM")		,TamSx3("D2_ITEM"		)[1],,{||cItem		})
TRCell():New(oCabec,"CPRODUTO"		,,RetTitle("D2_COD"		),PesqPict("SD2","D2_COD")		,TamSx3("D2_COD"		)[1],,{||cProduto	})
TRCell():New(oCabec,"CDESC"	   		,,RetTitle("B1_DESC"	),PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC"		)[1],,{||cDesc		})
TRCell():New(oCabec,"CGRUPO"		,,RetTitle("D2_GRUPO"	),PesqPict("SD2","D2_GRUPO")	,TamSx3("D2_GRUPO"		)[1],,{||cGrupo		})
TRCell():New(oCabec,"CGDESC"		,,RetTitle("BM_DESC"	),PesqPict("SBM","BM_DESC")		,TamSx3("BM_DESC"		)[1],,{||cGDesc		})
TRCell():New(oCabec,"NQUANT"		,,RetTitle("D2_QUANT"	),PesqPict("SD2","D2_QUANT")	,TamSx3("D2_QUANT"		)[1],,{||nQuant		})
TRCell():New(oCabec,"NPRCVEN"		,,RetTitle("D2_PRCVEN"	),PesqPict("SD2","D2_PRCVEN")	,TamSx3("D2_PRCVEN"		)[1],,{||nPrcVen	})
TRCell():New(oCabec,"NTOTAL"		,,"Valor Mercadoria"	 ,PesqPict("SD2","D2_TOTAL")	,TamSx3("D2_TOTAL"		)[1],,{||nTotal		})
TRCell():New(oCabec,"NVALICM"		,,RetTitle("D2_VALICM"	),PesqPict("SD2","D2_VALICM")	,TamSx3("D2_VALICM"		)[1],,{||nValIcm	})
TRCell():New(oCabec,"NVALIPI"		,,RetTitle("D2_VALIPI"	),PesqPict("SD2","D2_VALIPI")	,TamSx3("D2_VALIPI"		)[1],,{||nValIpi	})
TRCell():New(oCabec,"NICMRET"		,,RetTitle("D2_ICMSRET"	),PesqPict("SD2","D2_ICMSRET")	,TamSx3("D2_ICMSRET"	)[1],,{||nIcmRet	})
TRCell():New(oCabec,"NVALCOF"		,,"COFINS"				 ,PesqPict("SD2","D2_VALIMP5")	,TamSx3("D2_VALIMP5"	)[1],,{||nValCof	})
TRCell():New(oCabec,"NVALPIS"		,,"PIS"					 ,PesqPict("SD2","D2_VALIMP6")	,TamSx3("D2_VALIMP6"	)[1],,{||nValPIS	})
TRCell():New(oCabec,"NPRCIMP"		,,"Preço sem Impostos"	 ,PesqPict("SD2","D2_PRCVEN")	,TamSx3("D2_PRCVEN"		)[1],,{||nPrcImp	})
TRCell():New(oCabec,"CVEND"	   		,,RetTitle("F2_VEND1"	),PesqPict("SF2","F2_VEND1")	,TamSx3("F2_VEND1"		)[1],,{||cVend		})
TRCell():New(oCabec,"CNVEND"		,,RetTitle("A3_NOME"	),PesqPict("SA3","A3_NOME")		,TamSx3("A3_NOME"		)[1],,{||cNVend		})
TRCell():New(oCabec,"CSUPER"		,,RetTitle("A3_SUPER"	),PesqPict("SA3","A3_SUPER")	,TamSx3("A3_SUPER"		)[1],,{||cSuper		})
TRCell():New(oCabec,"CNOMSUP"		,,RetTitle("A3_NOME"	),PesqPict("SA3","A3_NOME")		,TamSx3("A3_NOME"		)[1],,{||cNomSup	})
TRCell():New(oCabec,"CPEDIDO"		,,RetTitle("C5_NUM"		),PesqPict("SC5","C5_NUM")		,TamSx3("C5_NUM"		)[1],,{||cPedido	})
TRCell():New(oCabec,"CPEDCLI"		,,RetTitle("C5_XMAGCOD"	),PesqPict("SC5","C5_XMAGCOD")	,TamSx3("C5_XMAGCOD"	)[1],,{||cPedcli	})
TRCell():New(oCabec,"CSUBCAN"		,,RetTitle("A1_XSUBCAN"	),PesqPict("SA1","A1_XSUBCAN")	,TamSx3("A1_XSUBCAN"	)[1],,{||CSUBCAN	})
TRCell():New(oCabec,"CLGRUPO"		,,RetTitle("D2_GRUPO"	),PesqPict("SD2","D2_GRUPO")	,TamSx3("D2_GRUPO"		)[1],,{||cLGrupo	})
TRCell():New(oCabec,"CLDESC"		,,RetTitle("BM_DESC"	),PesqPict("SBM","BM_DESC")		,TamSx3("BM_DESC"		)[1],,{||cLDesc		})
TRCell():New(oCabec,"CSGRUPO"		,,RetTitle("D2_GRUPO"	),PesqPict("SD2","D2_GRUPO")	,TamSx3("D2_GRUPO"		)[1],,{||cSGrupo	})
TRCell():New(oCabec,"CSDESC"		,,RetTitle("BM_DESC"	),PesqPict("SBM","BM_DESC")		,TamSx3("BM_DESC"		)[1],,{||cSDesc		})

//colocar linha e grupo cor/sabor canal e subcanal(cliente) consolidar distribuidoras

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 1 Itens		                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProduto := TRSection():New(oCabec,"Produto",{"SF2","TRB"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	//
oProduto:SetTotalInLine(.F.)

TRCell():New(oProduto,"CCODCLI"		,,RetTitle("A1_COD"		),PesqPict("SA1","A1_COD")		,TamSx3("A1_COD"		)[1],,{||cCodCli	})//1
TRCell():New(oProduto,"CLOJACLI"   	,,RetTitle("A1_LOJA"	),PesqPict("SA1","A1_LOJA")		,TamSx3("A1_LOJA"		)[1],,{||cLojaCli	})//2
TRCell():New(oProduto,"CNOMECLI"	,,RetTitle("A1_NOME"	),PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME"		)[1],,{||cNomeCli	})//3 
TRCell():New(oProduto,"CREGIAO"		,,RetTitle("A1_REGIAO"	),PesqPict("SA1","A1_REGIAO")	,TamSx3("A1_REGIAO"	)[1]+10 ,,{||cRegiao 	})
TRCell():New(oProduto,"CESTADO"		,,RetTitle("A1_EST"		),PesqPict("SA1","A1_EST")		,TamSx3("A1_EST"		)[1],,{||cEstado 	})//4
TRCell():New(oProduto,"CCIDADE"	    ,,RetTitle("A1_MUN"		),PesqPict("SA1","A1_MUN")		,TamSx3("A1_MUN"		)[1],,{||cCidade	})//5 
TRCell():New(oProduto,"CFILIAL"		,,RetTitle("F2_FILIAL"	),PesqPict("SF2","F2_FILIAL")	,TamSx3("F2_FILIAL"		)[1],,{||c_Filial	})
TRCell():New(oProduto,"CNFISCAL"	,,RetTitle("F2_DOC"		),PesqPict("SF2","F2_DOC")		,TamSx3("F2_DOC"		)[1],,{||cNFiscal	})//6
TRCell():New(oProduto,"CSERIE"		,,RetTitle("F2_SERIE"	),PesqPict("SF2","F2_SERIE")	,TamSx3("F2_SERIE"		)[1],,{||cSerie		})//7
TRCell():New(oProduto,"CCONDPGTO"	,,RetTitle("F2_COND"	),PesqPict("SF2","F2_COND")		,TamSx3("F2_COND"		)[1],,{||cCond		})//8
TRCell():New(oProduto,"DEMISSAO"	,,RetTitle("F2_EMISSAO"	),PesqPict("SF2","F2_EMISSAO")	,TamSx3("F2_EMISSAO"	)[1],,{||dEmissao	})//9 
TRCell():New(oProduto,"CCANAL"		,,RetTitle("A1_XCANAL"	),PesqPict("SA1","A1_XCANAL")	,TamSx3("A1_XCANAL"		)[1],,{||CCANAL		})
TRCell():New(oProduto,"CTABELA"		,,RetTitle("A1_TABELA"	),PesqPict("SA1","A1_TABELA")	,TamSx3("A1_TABELA"		)[1],,{||cTabela	})
TRCell():New(oProduto,"CITEM"		,,RetTitle("D2_ITEM"	),PesqPict("SD2","D2_ITEM")		,TamSx3("D2_ITEM"		)[1],,{||cItem		})//10
TRCell():New(oProduto,"CPRODUTO"	,,RetTitle("D2_COD"		),PesqPict("SD2","D2_COD")		,TamSx3("D2_COD"		)[1],,{||cProduto	})//11
TRCell():New(oProduto,"CDESC"		,,RetTitle("B1_DESC"	),PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC"		)[1],,{||cDesc		})//12
TRCell():New(oProduto,"CGRUPO"		,,RetTitle("D2_GRUPO"	),PesqPict("SD2","D2_GRUPO")	,TamSx3("D2_GRUPO"		)[1],,{||cGrupo		})//13
TRCell():New(oProduto,"CGDESC"		,,RetTitle("BM_DESC"	),PesqPict("SBM","BM_DESC")		,TamSx3("BM_DESC"		)[1],,{||cGDesc		})//14
TRCell():New(oProduto,"NQUANT"		,,RetTitle("D2_QUANT"	),PesqPict("SD2","D2_QUANT")	,TamSx3("D2_QUANT"		)[1],,{||nQuant		})//15
TRCell():New(oProduto,"NPRCVEN"		,,RetTitle("D2_PRCVEN"	),PesqPict("SD2","D2_PRCVEN")	,TamSx3("D2_PRCVEN"		)[1],,{||nPrcVen	})//16
TRCell():New(oProduto,"NTOTAL"		,,"Valor Mercadoria"	 ,PesqPict("SD2","D2_TOTAL")	,TamSx3("D2_TOTAL"		)[1],,{||nTotal		})//17
TRCell():New(oProduto,"NVALICM"		,,RetTitle("D2_VALICM"	),PesqPict("SD2","D2_VALICM")	,TamSx3("D2_VALICM"		)[1],,{||nValIcm	})//18
TRCell():New(oProduto,"NVALIPI"		,,RetTitle("D2_VALIPI"	),PesqPict("SD2","D2_VALIPI")	,TamSx3("D2_VALIPI"		)[1],,{||nValIpi	})//19
TRCell():New(oProduto,"NICMRET"		,,RetTitle("D2_ICMSRET"	),PesqPict("SD2","D2_ICMSRET")	,TamSx3("D2_ICMSRET"	)[1],,{||nIcmRet	})//20
TRCell():New(oProduto,"NVALCOF"		,,"COFINS"				 ,PesqPict("SD2","D2_VALIMP5")	,TamSx3("D2_VALIMP5"	)[1],,{||nValCof	})//21
TRCell():New(oProduto,"NVALPIS"		,,"PIS"					 ,PesqPict("SD2","D2_VALIMP6")	,TamSx3("D2_VALIMP6"	)[1],,{||nValPIS	})//22
TRCell():New(oProduto,"NPRCIMP"		,,"Preço sem Impostos"	 ,PesqPict("SD2","D2_PRCVEN")	,TamSx3("D2_PRCVEN"		)[1],,{||nPrcImp	})
TRCell():New(oProduto,"CVEND"  		,,RetTitle("F2_VEND1"	),PesqPict("SF2","F2_VEND1")	,TamSx3("F2_VEND1"		)[1],,{||cVend		})//23
TRCell():New(oProduto,"CNVEND"		,,RetTitle("A3_NOME"	),PesqPict("SA3","A3_NOME")		,TamSx3("A3_NOME"		)[1],,{||cNVend		})//24
TRCell():New(oProduto,"CSUPER"		,,RetTitle("A3_SUPER"	),PesqPict("SA3","A3_SUPER")	,TamSx3("A3_SUPER"		)[1],,{||cSuper		})//25  
TRCell():New(oProduto,"CNOMSUP"		,,RetTitle("A3_NOME"	),PesqPict("SA3","A3_NOME")		,TamSx3("A3_NOME"		)[1],,{||cNomSup	})//26
TRCell():New(oProduto,"CPEDIDO"		,,RetTitle("C5_NUM"		),PesqPict("SC5","C5_NUM")		,TamSx3("C5_NUM"		)[1],,{||cPedido	})//27
TRCell():New(oProduto,"CPEDCLI"		,,RetTitle("C5_XMAGCOD"	),PesqPict("SC5","C5_XMAGCOD")	,TamSx3("C5_XMAGCOD"		)[1],,{||cPedcli	})//28
TRCell():New(oProduto,"CSUBCAN"		,,RetTitle("A1_XSUBCAN"	),PesqPict("SA1","A1_XSUBCAN")	,TamSx3("A1_XSUBCAN"	)[1],,{||CSUBCAN	})//29
TRCell():New(oProduto,"CLGRUPO"		,,RetTitle("D2_GRUPO"	),PesqPict("SD2","D2_GRUPO")	,TamSx3("D2_GRUPO"		)[1],,{||cLGrupo	})//30
TRCell():New(oProduto,"CLDESC"		,,RetTitle("BM_DESC"	),PesqPict("SBM","BM_DESC")		,TamSx3("BM_DESC"		)[1],,{||cLDesc		})//31
TRCell():New(oProduto,"CSGRUPO"		,,RetTitle("D2_GRUPO"	),PesqPict("SD2","D2_GRUPO")	,TamSx3("D2_GRUPO"		)[1],,{||cSGrupo	})
TRCell():New(oProduto,"CSDESC"		,,RetTitle("BM_DESC"	),PesqPict("SBM","BM_DESC")		,TamSx3("BM_DESC"		)[1],,{||cSDesc		})


// Alinhamento a direita das colunas de valor
oProduto:Cell("CCODCLI"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CLOJACLI"	):SetHeaderAlign("RIGHT")
oProduto:Cell("CNOMECLI"	):SetHeaderAlign("RIGHT")  
oProduto:Cell("CREGIAO"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CESTADO"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CCIDADE"		):SetHeaderAlign("RIGHT") 
oProduto:Cell("CFILIAL"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CNFISCAL"	):SetHeaderAlign("RIGHT")
oProduto:Cell("CSERIE"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CCONDPGTO"	):SetHeaderAlign("RIGHT")
oProduto:Cell("DEMISSAO"	):SetHeaderAlign("RIGHT")
oProduto:Cell("CCANAL"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CTABELA"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CITEM"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CPRODUTO"	):SetHeaderAlign("RIGHT")
oProduto:Cell("CDESC"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CGRUPO"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CGDESC"		):SetHeaderAlign("RIGHT")
oProduto:Cell("NQUANT"		):SetHeaderAlign("RIGHT")
oProduto:Cell("NPRCVEN"		):SetHeaderAlign("RIGHT")
oProduto:Cell("NTOTAL"		):SetHeaderAlign("RIGHT")
oProduto:Cell("NVALICM"		):SetHeaderAlign("RIGHT")
oProduto:Cell("NVALIPI"		):SetHeaderAlign("RIGHT")
oProduto:Cell("NICMRET"		):SetHeaderAlign("RIGHT")
oProduto:Cell("NVALCOF"		):SetHeaderAlign("RIGHT")
oProduto:Cell("NVALPIS"		):SetHeaderAlign("RIGHT")
oProduto:Cell("NPRCIMP"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CVEND"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CNVEND"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CSUPER"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CNOMSUP"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CPEDIDO"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CPEDCLI"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CSUBCAN"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CLGRUPO"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CLDESC"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CSGRUPO"		):SetHeaderAlign("RIGHT")
oProduto:Cell("CSDESC"		):SetHeaderAlign("RIGHT")

// Imprimie Cabecalho no Topo da Pagina Secao 1
oReport:Section(1):SetHeaderPage(.F.)
// Inibe Imprimie Cabecalho no Topo da Pagina Secao 2
oReport:Section(1):Section(1):SetHeaderPage(.F.)

oReport:Section(1):SetEditCell(.F.)
//oProduto:Section(1):Section(1):SetEditCell(.F.)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Caio de Paula		    ³ Data ³ 08/02/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport) 
local cAliasQry := "TRB"
local cOrder	:= ""
local cVendSQL	:= ""
Local cSuperSQL	:= ""
Local cCliSQL	:= ""
Local cFilSQL	:= ""
LOCAL cArmSQL	:= ""
local cQuery	:= ""  
local aQuery	:= {}
local cServer	:= "MSSQL"
local cBD		:= "COSMETIC"
local cIP		:= "192.168.2.5"
local cPorta	:= "7892"
local nConecta	:= 0
local c_Cfop	:= Alltrim(SuperGetMV("MV_XCODCFO",.F.,"5102,6102,6108,6110,5119,6119,5401,6401,5403,6403,6404,5405,5501,5502,6502"))
c_Cfop	:= ALLTRIM(StrTran(c_Cfop,","," ','"))

oReport:Section(1):BeginQuery()	
	
if MV_PAR07 == 1 .Or. MV_PAR07 == 2
	cOrder		:= "F2_CLIENTE,F2_LOJA"
	cQuery := "SELECT SF2.F2_CLIENTE , SF2.F2_LOJA ,SA1.A1_NOME,SA1.A1_REGIAO, SA1.A1_EST , SA1.A1_MUN , SF2.F2_FILIAL,SF2.F2_DOC , SF2.F2_SERIE , SF2.F2_COND, D2_EMISSAO ,"
	cQuery += "SD2.D2_QUANT ,D2_PRCVEN , D2_TOTAL , D2_VALICM , D2_VALIPI , D2_ICMSRET ,D2_VALIMP5 , D2_VALIMP6 ,SF2.F2_VEND1 , SA3.A3_NOME , "
	cQuery += "SA3.A3_SUPER , SD2.D2_ITEM, SD2.D2_COD , SB1.B1_DESC , SD2.D2_GRUPO , SBM.BM_DESC , SA1.A1_SATIV1, SC5.C5_XMAGCOD, SC5.C5_NUM, SA1.A1_XCANAL, SA1.A1_TABELA, SA1.A1_XSUBCAN, "
	cQuery += "SB1.B1_XSUBGR1, SB1.B1_XSUBGR4 "
	cQuery += "FROM "+RetSqlName("SD2")+" SD2 INNER JOIN "+RetSqlName("SF2")+" SF2 ON(SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_FILIAL = SD2.D2_FILIAL) "
	cQuery += "INNER JOIN "+RetSqlName("SC6")+" SC6 ON(SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D2_FILIAL = SC6.C6_FILIAL) "
	cQuery += "INNER JOIN "+RetSqlName("SC5")+" SC5 ON(SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_FILIAL = SC5.C5_FILIAL) "
	cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON(SF2.F2_CLIENTE = SA1.A1_COD) "
	cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 ON(SF2.F2_VEND1 = SA3.A3_COD) "
	cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON(SD2.D2_COD = SB1.B1_COD) "
	cQuery += "INNER JOIN "+RetSqlName("SBM")+" SBM ON(SD2.D2_GRUPO = SBM.BM_GRUPO) "
	cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON(SD2.D2_TES = SF4.F4_CODIGO) "
	cQuery += "WHERE SD2.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND "
	cQuery += "SA3.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' AND SBM.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' 	AND SC5.D_E_L_E_T_ = '' "
	if ALLTRIM(MV_PAR09) != ""
		cVendSQL := "'"+ALLTRIM(StrTran(MV_PAR09,";","','"))+"' "
		cVendSQL := iif(right(cVendSQL,4) == ",'' ",substr(cVendSQL,1,len(cVendSQL)-4),cVendSQL)	 
		cQuery += "AND SF2.F2_VEND1 IN ("+cVendSQL+") " 
	endif
	if ALLTRIM(MV_PAR10) != ""
		cSuperSQL	:= "'"+ALLTRIM(StrTran(MV_PAR10,";","','"))+"' "
		cSuperSQL := iif(right(cSuperSQL,4) == ",'' ",substr(cSuperSQL,1,len(cSuperSQL)-4),cSuperSQL)
		cQuery += "AND SA3.A3_SUPER IN ("+cSuperSQL+") "  
	ENDIF
	if ALLTRIM(MV_PAR11) != ""
		cCliSQL	:= "'"+ALLTRIM(StrTran(MV_PAR11,";","','"))+"' "
		cCliSQL := iif(right(cCliSQL,4) == ",'' ",substr(cCliSQL,1,len(cCliSQL)-4),cCliSQL)
		cQuery += "AND SD2.D2_CLIENTE IN ("+cCliSQL+") "  
	ENDIF
	if MV_PAR16 == 2
		cQuery += "AND SF4.F4_ESTOQUE = 'S' " 	
	elseif MV_PAR16 == 3 
		cQuery += "AND SF4.F4_ESTOQUE = 'N' " 
	endif
	cQuery += "AND SD2.D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += "AND D2_CF IN ('"+c_Cfop+"') "   // ('5102','6102','6108', '6110','5119', '6119', '5401', '6401', '5403', '6403', '6404', '5405','5501','5502','6502','6922','5922')
	cQuery += "AND SD2.D2_EMISSAO Between '"+DTOS(MV_PAR01)+"' And '"+DTOS(MV_PAR02)+"' "
	cQuery += "AND SD2.D2_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	if ALLTRIM(MV_PAR15) != ""
		cFilSQL	:= "'"+ALLTRIM((StrTran(MV_PAR15,";","','")))+"' "
		cFilSQL := iif(right(cFilSQL,4) == ",'' ",substr(cFilSQL,1,len(cFilSQL)-4),cFilSQL)
		cQuery += "AND SF2.F2_FILIAL  IN ("+cFilSQL+") "   
	endif	
	IF !EMPTY(MV_PAR17)
		cQuery += "AND SA1.A1_REGIAO ='"+MV_PAR17+"' "
	ENDIF                                               
	cQuery += "AND SD2.D2_TP = '"+MV_PAR08+"' AND  SF2.F2_EST BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
	if ALLTRIM(MV_PAR14) != ""
		cArmSQL	:= "'"+ALLTRIM((StrTran(MV_PAR14,";","','")))+"' "
		cArmSQL := iif(right(cArmSQL,4) == ",'' ",substr(cArmSQL,1,len(cArmSQL)-4),cArmSQL)
		cQuery += "AND SD2.D2_LOCAL  IN ("+cArmSQL+") "   
	endif
	cQuery += "GROUP BY SF2.F2_CLIENTE, SF2.F2_LOJA, SA1.A1_NOME, SF2.F2_DOC, SF2.F2_SERIE, SD2.D2_EMISSAO, SF2.F2_FILIAL, A1_REGIAO, "
	cQuery += "SF2.F2_VEND1, SA3.A3_NOME, SA3.A3_SUPER, SA1.A1_EST, SA1.A1_MUN, SD2.D2_QUANT, SD2.D2_PRCVEN,SD2.D2_TOTAL, "
	cQuery += "SD2.D2_COD, SD2.D2_GRUPO, SB1.B1_DESC, SBM.BM_DESC, SA1.A1_SATIV1, SF2.F2_COND, SC5.C5_XMAGCOD, SA1.A1_XCANAL, SA1.A1_TABELA, "
	cQuery += "SD2.D2_VALICM,SD2.D2_VALIPI,SD2.D2_ICMSRET,SD2.D2_VALIMP5,SD2.D2_VALIMP6,SD2.D2_ITEM,SC5.C5_NUM,SA1.A1_XSUBCAN, "
	cQuery += "SB1.B1_XSUBGR1, SB1.B1_XSUBGR4 "
	cQuery += "ORDER BY "+ cOrder 
	
	If Select(cAliasQry) > 0
		(cAliasQry)->(DbCloseArea())
	EndIf
				
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(cAliasQry),.T.,.T.)    
	 
	DbSelectArea(cAliasQry)
	do While !(cAliasQry)->(EOF())
		AADD(aQuery,	{(cAliasQry)->(F2_CLIENTE),;        //1
						(cAliasQry)->(F2_LOJA),;           //2
						(cAliasQry)->(A1_NOME),;           //3
						(cAliasQry)->(F2_DOC),;            //4
						(cAliasQry)->(F2_SERIE),;          //5
						(cAliasQry)->(D2_EMISSAO),;        //6
						(cAliasQry)->(F2_VEND1),;          //7
						(cAliasQry)->(A3_NOME),;         	//8
						(cAliasQry)->(A3_SUPER),;        	//9
						(cAliasQry)->(A1_EST),;          	//10
						(cAliasQry)->(A1_MUN),;			//11
						CVALTOCHAR((cAliasQry)->(D2_QUANT)),; 		//12
						CVALTOCHAR((cAliasQry)->(D2_PRCVEN)),;    	//13
						CVALTOCHAR((cAliasQry)->(D2_TOTAL)),;      	//14
						(cAliasQry)->(D2_COD),;        	//15      
						(cAliasQry)->(D2_GRUPO),;			//16
						(cAliasQry)->(B1_DESC),;        	//17
						(cAliasQry)->(BM_DESC),;        	//18
						(cAliasQry)->(A1_SATIV1),;    	//19
						(cAliasQry)->(F2_COND),;        	//20
						(cAliasQry)->(C5_XMAGCOD),;		//21
						CVALTOCHAR((cAliasQry)->(D2_VALICM)),;      	//22
						CVALTOCHAR((cAliasQry)->(D2_VALIPI)),;		//23
						CVALTOCHAR((cAliasQry)->(D2_ICMSRET)),;     	//24
						CVALTOCHAR((cAliasQry)->(D2_VALIMP5)),;     	//25
						CVALTOCHAR((cAliasQry)->(D2_VALIMP6)),;     	//26
						(cAliasQry)->(D2_ITEM),;        	//27
						(cAliasQry)->(C5_NUM),;                        //28
						(cAliasQry)->(A1_XCANAL),;                          //29
						(cAliasQry)->(A1_TABELA),;                               //30
						(cAliasQry)->(A1_XSUBCAN),;                         //31
						(cAliasQry)->(F2_FILIAL),;						//32
						(cAliasQry)->(A1_REGIAO),;					//33
						(cAliasQry)->(B1_XSUBGR1),;					//34
						(cAliasQry)->(B1_XSUBGR4),;				//35
						})			//32
		(cAliasQry)->(DbSkip())		
	enddo     
	If Select(cAliasQry) > 0
		(cAliasQry)->(DbCloseArea())
	EndIf
	nConecta := u_AbreObco(cServer, cBD, cIP,cPorta)
		cOrder		:= "F2_CLIENTE,F2_LOJA"
		cQuery := "SELECT SF2.F2_CLIENTE , SF2.F2_LOJA ,SA1.A1_NOME,SA1.A1_REGIAO, SA1.A1_EST , SA1.A1_MUN , SF2.F2_FILIAL,SF2.F2_DOC , SF2.F2_SERIE , SF2.F2_COND, D2_EMISSAO ,"
		cQuery += "SD2.D2_QUANT ,D2_PRCVEN , D2_TOTAL , D2_VALICM , D2_VALIPI , D2_ICMSRET ,D2_VALIMP5 , D2_VALIMP6 ,SF2.F2_VEND1 , SA3.A3_NOME , "
		cQuery += "SA3.A3_SUPER , SD2.D2_ITEM, SD2.D2_COD , SB1.B1_DESC , SD2.D2_GRUPO , SBM.BM_DESC , SA1.A1_SATIV1, SC5.C5_XMAGCOD, SC5.C5_NUM, SA1.A1_XCANAL, SA1.A1_TABELA, SA1.A1_XSUBCAN, "
		cQuery += "SB1.B1_XSUBGR1, SB1.B1_XSUBGR4 "
		cQuery += "FROM SD2080 SD2 INNER JOIN SF2080 SF2 ON(SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_FILIAL = SD2.D2_FILIAL) "
		cQuery += "INNER JOIN SC6080 SC6 ON(SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D2_FILIAL = SC6.C6_FILIAL) "
		cQuery += "INNER JOIN SC5080 SC5 ON(SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_FILIAL = SC5.C5_FILIAL) "
		cQuery += "INNER JOIN SA1080 SA1 ON(SF2.F2_CLIENTE = SA1.A1_COD) "
		cQuery += "INNER JOIN SA3080 SA3 ON(SF2.F2_VEND1 = SA3.A3_COD) "
		cQuery += "INNER JOIN SB1080 SB1 ON(SD2.D2_COD = SB1.B1_COD) "
		cQuery += "INNER JOIN SBM080 SBM ON(SD2.D2_GRUPO = SBM.BM_GRUPO) "
		cQuery += "INNER JOIN SF4080 SF4 ON(SD2.D2_TES = SF4.F4_CODIGO) "
		cQuery += "WHERE SD2.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND "
		cQuery += "SA3.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' AND SBM.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' 	AND SC5.D_E_L_E_T_ = '' "
		if ALLTRIM(MV_PAR09) != ""
			cVendSQL := "'"+ALLTRIM(StrTran(MV_PAR09,";","','"))+"' "
			cVendSQL := iif(right(cVendSQL,4) == ",'' ",substr(cVendSQL,1,len(cVendSQL)-4),cVendSQL)	 
			cQuery += "AND SF2.F2_VEND1 IN ("+cVendSQL+") " 
		endif
		if ALLTRIM(MV_PAR10) != ""
			cSuperSQL	:= "'"+ALLTRIM(StrTran(MV_PAR10,";","','"))+"' "
			cSuperSQL := iif(right(cSuperSQL,4) == ",'' ",substr(cSuperSQL,1,len(cSuperSQL)-4),cSuperSQL)
			cQuery += "AND SA3.A3_SUPER IN ("+cSuperSQL+") "  
		ENDIF
		if ALLTRIM(MV_PAR11) != ""
			cCliSQL	:= "'"+ALLTRIM(StrTran(MV_PAR11,";","','"))+"' "
			cCliSQL := iif(right(cCliSQL,4) == ",'' ",substr(cCliSQL,1,len(cCliSQL)-4),cCliSQL)
			cQuery += "AND SD2.D2_CLIENTE IN ("+cCliSQL+") "  
		ENDIF
		if MV_PAR16 == 2
			cQuery += "AND SF4.F4_ESTOQUE = 'S' " 	
		elseif MV_PAR16 == 3 
			cQuery += "AND SF4.F4_ESTOQUE = 'N' " 
		endif
		cQuery += "AND SD2.D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
		cQuery += "AND D2_CF IN ('"+c_Cfop+"') "   // ('5102','6102','6108', '6110','5119', '6119', '5401', '6401', '5403', '6403', '6404', '5405','5501','5502','6502','6922','5922')
		cQuery += "AND SD2.D2_EMISSAO Between '"+DTOS(MV_PAR01)+"' And '"+DTOS(MV_PAR02)+"' "
		cQuery += "AND SD2.D2_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		if ALLTRIM(MV_PAR15) != ""
			cFilSQL	:= "'"+ALLTRIM((StrTran(MV_PAR15,";","','")))+"' "
			cFilSQL := iif(right(cFilSQL,4) == ",'' ",substr(cFilSQL,1,len(cFilSQL)-4),cFilSQL)
			cQuery += "AND SF2.F2_FILIAL  IN ("+cFilSQL+") "   
		endif	
		IF !EMPTY(MV_PAR17)
			cQuery += "AND SA1.A1_REGIAO ='"+MV_PAR17+"' "
		ENDIF                                               
		cQuery += "AND SD2.D2_TP = '"+MV_PAR08+"' AND  SF2.F2_EST BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
		if ALLTRIM(MV_PAR14) != ""
			cArmSQL	:= "'"+ALLTRIM((StrTran(MV_PAR14,";","','")))+"' "
			cArmSQL := iif(right(cArmSQL,4) == ",'' ",substr(cArmSQL,1,len(cArmSQL)-4),cArmSQL)
			cQuery += "AND SD2.D2_LOCAL  IN ("+cArmSQL+") "   
		endif
		cQuery += "GROUP BY SF2.F2_CLIENTE, SF2.F2_LOJA, SA1.A1_NOME, SF2.F2_DOC, SF2.F2_SERIE, SD2.D2_EMISSAO, SF2.F2_FILIAL, A1_REGIAO, "
		cQuery += "SF2.F2_VEND1, SA3.A3_NOME, SA3.A3_SUPER, SA1.A1_EST, SA1.A1_MUN, SD2.D2_QUANT, SD2.D2_PRCVEN,SD2.D2_TOTAL, "
		cQuery += "SD2.D2_COD, SD2.D2_GRUPO, SB1.B1_DESC, SBM.BM_DESC, SA1.A1_SATIV1, SF2.F2_COND, SC5.C5_XMAGCOD, SA1.A1_XCANAL, SA1.A1_TABELA, "
		cQuery += "SD2.D2_VALICM,SD2.D2_VALIPI,SD2.D2_ICMSRET,SD2.D2_VALIMP5,SD2.D2_VALIMP6,SD2.D2_ITEM,SC5.C5_NUM,SA1.A1_XSUBCAN, "
		cQuery += "SB1.B1_XSUBGR1, SB1.B1_XSUBGR4 "
		cQuery += "ORDER BY "+ cOrder 
		
		If Select(cAliasQry) > 0
			(cAliasQry)->(DbCloseArea())
		EndIf
					
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(cAliasQry),.T.,.T.)    
		 
		DbSelectArea(cAliasQry)
		do While !(cAliasQry)->(EOF())
			AADD(aQuery,	{(cAliasQry)->(F2_CLIENTE),;        //1
							(cAliasQry)->(F2_LOJA),;           //2
							(cAliasQry)->(A1_NOME),;           //3
							(cAliasQry)->(F2_DOC),;            //4
							(cAliasQry)->(F2_SERIE),;          //5
							(cAliasQry)->(D2_EMISSAO),;        //6
							(cAliasQry)->(F2_VEND1),;          //7
							(cAliasQry)->(A3_NOME),;         	//8
							(cAliasQry)->(A3_SUPER),;        	//9
							(cAliasQry)->(A1_EST),;          	//10
							(cAliasQry)->(A1_MUN),;			//11
							CVALTOCHAR((cAliasQry)->(D2_QUANT)),; 		//12
							CVALTOCHAR((cAliasQry)->(D2_PRCVEN)),;    	//13
							CVALTOCHAR((cAliasQry)->(D2_TOTAL)),;      	//14
							(cAliasQry)->(D2_COD),;        	//15      
							(cAliasQry)->(D2_GRUPO),;			//16
							(cAliasQry)->(B1_DESC),;        	//17
							(cAliasQry)->(BM_DESC),;        	//18
							(cAliasQry)->(A1_SATIV1),;    	//19
							(cAliasQry)->(F2_COND),;        	//20
							(cAliasQry)->(C5_XMAGCOD),;		//21
							CVALTOCHAR((cAliasQry)->(D2_VALICM)),;      	//22
							CVALTOCHAR((cAliasQry)->(D2_VALIPI)),;		//23
							CVALTOCHAR((cAliasQry)->(D2_ICMSRET)),;     	//24
							CVALTOCHAR((cAliasQry)->(D2_VALIMP5)),;     	//25
							CVALTOCHAR((cAliasQry)->(D2_VALIMP6)),;     	//26
							(cAliasQry)->(D2_ITEM),;        	//27
							(cAliasQry)->(C5_NUM),;                        //28
							(cAliasQry)->(A1_XCANAL),;                          //29
							(cAliasQry)->(A1_TABELA),;                               //30
							(cAliasQry)->(A1_XSUBCAN),;                         //31
							(cAliasQry)->(F2_FILIAL),;						//32
							(cAliasQry)->(A1_REGIAO),;					//33
							(cAliasQry)->(B1_XSUBGR1),;					//34
							(cAliasQry)->(B1_XSUBGR4),;				//35
							})			//32
				(cAliasQry)->(DbSkip())		
		enddo     
		If Select(cAliasQry) > 0
			(cAliasQry)->(DbCloseArea())
		EndIf
		 //TCQuery cQry NEW ALIAS "QRY"   dbSelectArea("QRY")  QRY->(DbGoTop()) 
                    // Processamento desejado.
 
	U_FechOBD(nConecta)   
endif
if MV_PAR07 == 1 .Or. MV_PAR07 == 3
	AADD(aQuery, {"Devolucoes",,,,,,,,,,,,,,,,,,,,,,,,,,,})
	
	cQuery := "SELECT SD1.D1_FORNECE, SD1.D1_LOJA, SA1.A1_NOME, SD1.D1_FILIAL,SD1.D1_DOC,A1_REGIAO,  "
	cQuery += "SD1.D1_SERIE, SD1.D1_DTDIGIT, SA1.A1_VEND, SA3.A3_NOME, " 
	cQuery += "SA3.A3_SUPER AS 'GESTOR', (SUM(D1_TOTAL) *-1) AS 'VALMERCDEVOLVIDO', SA1.A1_EST, "
	cQuery += "SA1.A1_MUN, (SUM(SD1.D1_QUANT)*-1) AS 'QTDE', AVG(SD1.D1_VUNIT) AS 'UNIT', (SUM(D1_VALICM) *-1) AS 'ICMS', (SUM(D1_VALIPI) *-1) AS 'IPI', "
	cQuery += "(SUM(D1_ICMSRET) *-1) AS 'ICMSST', (SUM(D1_VALIMP5) *-1) AS 'COFINS', (SUM(D1_VALIMP6)*-1) AS 'PIS', SD1.D1_COD, "
	cQuery += "SB1.B1_DESC, (SUM(D1_CUSTO)*-1),SD1.D1_ITEM, SD1.D1_GRUPO, A1_SATIV1, SBM.BM_DESC , SA1.A1_XCANAL, SA1.A1_TABELA, SA1.A1_XSUBCAN, "
	cQuery += "SB1.B1_XSUBGR1, SB1.B1_XSUBGR4 "
	//cQuery += "(SELECT (ISNULL(SUM(D2_TOTAL),0)*-1) FROM SD2010 SD2 WHERE SD1.D1_FORNECE = SD2.D2_CLIENTE AND SD2.D_E_L_E_T_='' "
	//cQuery += "AND SD2.D2_EMISSAO Between '"+DTOS(MV_PAR01)+"' And '"+DTOS(MV_PAR02)+"') AS 'VALMERCFATURADO' "   chenrique
	cQuery += "FROM "+RetSqlName("SD1")+" SD1 INNER JOIN "+RetSqlName("SA1")+" SA1 ON(SD1.D1_FORNECE = SA1.A1_COD) "
	cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 ON(SA1.A1_VEND = SA3.A3_COD) "
	cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON(SD1.D1_COD = SB1.B1_COD) "
	cQuery += "INNER JOIN "+RetSqlName("SBM")+" SBM ON(SD1.D1_GRUPO = SBM.BM_GRUPO) "
	cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON(SD1.D1_TES = SF4.F4_CODIGO) "
	cQuery += "WHERE SD1.D1_DTDIGIT Between '"+DTOS(MV_PAR01)+"' And '"+DTOS(MV_PAR02)+"' "
	if ALLTRIM(MV_PAR11) != ""
		cCliSQL	:= "'"+ALLTRIM(StrTran(MV_PAR11,";","','"))+"' "
		cCliSQL := iif(right(cCliSQL,4) == ",'' ",substr(cCliSQL,1,len(cCliSQL)-4),cCliSQL)
		cQuery += "AND SD1.D1_FORNECE IN ("+cCliSQL+") "  
	ENDIF
	if ALLTRIM(MV_PAR09) != ""
		cVendSQL		:= "'"+ALLTRIM(StrTran(MV_PAR09,";","','"))+"' "
		cVendSQL := iif(right(cVendSQL,4) == ",'' ",substr(cVendSQL,1,len(cVendSQL)-4),cVendSQL) 
		cQuery += "AND SA1.A1_VEND IN ("+cVendSQL+") " 
	endif 
	if ALLTRIM(MV_PAR10) != ""
		cSuperSQL	:= "'"+ALLTRIM(StrTran(MV_PAR10,";","','"))+"' "
		cSuperSQL := iif(right(cSuperSQL,4) == ",'' ",substr(cSuperSQL,1,len(cSuperSQL)-4),cSuperSQL)
		cQuery += "AND SA3.A3_SUPER IN ("+cSuperSQL+") "  
	ENDIF
	if ALLTRIM(MV_PAR15) != ""
		cFilSQL	:= "'"+ALLTRIM(StrTran(MV_PAR15,";","','"))+"' "  
		cFilSQL := iif(right(cFilSQL,4) == ",'' ",substr(cFilSQL,1,len(cFilSQL)-4),cFilSQL) 
		cQuery += "AND SD1.D1_FILIAL  IN ("+cFilSQL+") "   
	endif	
	if MV_PAR16 == 2
		cQuery += "AND SF4.F4_ESTOQUE = 'S' " 	
	elseif MV_PAR16 == 3 
		cQuery += "AND SF4.F4_ESTOQUE = 'N' " 
	endif
	IF !EMPTY(MV_PAR17)
		cQuery += "AND SA1.A1_REGIAO ='"+MV_PAR17+"' "
	ENDIF	
	cQuery += "AND SD1.D1_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery += "AND SD1.D1_TIPO = 'D' " 
	cQuery += "AND SD1.D1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += "AND SA1.A1_EST BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
	cQuery += "AND SD1.D1_CF IN ('"+c_Cfop+"') "  
	cQuery += "AND SD1.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_=''  AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' AND SBM.D_E_L_E_T_='' "
	cQuery += "GROUP BY A1_REGIAO, "
	cQuery += "SD1.D1_FORNECE, SA1.A1_NOME, SA1.A1_VEND, SA3.A3_NOME, SD1.D1_COD, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_ITEM, SD1.D1_GRUPO, A1_SATIV1,SA3.A3_SUPER, SA1.A1_XSUBCAN, SD1.D1_FILIAL, " 
	cQuery += "SD1.D1_DTDIGIT, SD1.D1_LOJA,SD1.D1_SEGUM, SA1.A1_EST, SA1.A1_MUN, SB1.B1_DESC, SB1.B1_GRUPO,SBM.BM_DESC, SA1.A1_XCANAL, SA1.A1_TABELA,SB1.B1_XSUBGR1, SB1.B1_XSUBGR4 "
	cQuery += " ORDER BY SD1.D1_DOC, SD1.D1_SERIE" 
	If Select(cAliasQry) > 0
		(cAliasQry)->(DbCloseArea())
	EndIf
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(cAliasQry),.T.,.T.)    
 
	DbSelectArea((cAliasQry))
	do While !((cAliasQry))->(EOF())
		AADD(aQuery,	{(cAliasQry)->(D1_FORNECE),;     	//1
						(cAliasQry)->(D1_LOJA),;         	//2
						(cAliasQry)->(A1_NOME),;        	//3
						(cAliasQry)->(D1_DOC),;          	//4
						(cAliasQry)->(D1_SERIE),;        	//5
						(cAliasQry)->(D1_DTDIGIT),;      	//6
						(cAliasQry)->(A1_VEND),;        	//7
						(cAliasQry)->(A3_NOME),;         	//8
						(cAliasQry)->(GESTOR),;        	//9
						(cAliasQry)->(A1_EST),;          	//10
						(cAliasQry)->(A1_MUN),;			//11
						CVALTOCHAR((cAliasQry)->(QTDE)),; 			//12
						CVALTOCHAR((cAliasQry)->(UNIT)),; 		   	//13
						CVALTOCHAR((cAliasQry)->(VALMERCDEVOLVIDO)),;	//14
						(cAliasQry)->(D1_COD),;        	//15      
						(cAliasQry)->(D1_GRUPO),;			//16
						(cAliasQry)->(B1_DESC),;        	//17
						(cAliasQry)->(BM_DESC),;        	//18
						(cAliasQry)->(A1_SATIV1),;    	//19
						'NIL',;  				    	//20
						'NIL',;							//21
						CVALTOCHAR((cAliasQry)->(ICMS)),;  	    	//22
						CVALTOCHAR((cAliasQry)->(IPI)),;				//23
						CVALTOCHAR((cAliasQry)->(ICMSST)),;  		   	//24
						CVALTOCHAR((cAliasQry)->(COFINS)),;  		   	//25
						CVALTOCHAR((cAliasQry)->(PIS)),;   		  	//26
						(cAliasQry)->(D1_ITEM),;        	//27
						'NIL',;                                       //28
						(cAliasQry)->(A1_XCANAL),;                       //29
						(cAliasQry)->(A1_TABELA),;			                  //30
						(cAliasQry)->(A1_XSUBCAN),;                              //31
						(cAliasQry)->(D1_FILIAL),;                               //32
						(cAliasQry)->(A1_REGIAO),;// 33
						(cAliasQry)->(B1_XSUBGR1),;					//34
						(cAliasQry)->(B1_XSUBGR4),;				//35
						})                                    
	(cAliasQry)->(DbSkip())	
	enddo 
	If Select((cAliasQry)) > 0
		(cAliasQry)->(DbCloseArea())
	EndIf
	nConecta := u_AbreObco(cServer, cBD, cIP,cPorta)
		cQuery := "SELECT SD1.D1_FORNECE, SD1.D1_LOJA, SA1.A1_NOME, SD1.D1_FILIAL,SD1.D1_DOC,A1_REGIAO,  "
		cQuery += "SD1.D1_SERIE, SD1.D1_DTDIGIT, SA1.A1_VEND, SA3.A3_NOME, " 
		cQuery += "SA3.A3_SUPER AS 'GESTOR', (SUM(D1_TOTAL) *-1) AS 'VALMERCDEVOLVIDO', SA1.A1_EST, "
		cQuery += "SA1.A1_MUN, (SUM(SD1.D1_QUANT)*-1) AS 'QTDE', AVG(SD1.D1_VUNIT) AS 'UNIT', (SUM(D1_VALICM) *-1) AS 'ICMS', (SUM(D1_VALIPI) *-1) AS 'IPI', "
		cQuery += "(SUM(D1_ICMSRET) *-1) AS 'ICMSST', (SUM(D1_VALIMP5) *-1) AS 'COFINS', (SUM(D1_VALIMP6)*-1) AS 'PIS', SD1.D1_COD, "
		cQuery += "SB1.B1_DESC, (SUM(D1_CUSTO)*-1),SD1.D1_ITEM, SD1.D1_GRUPO, A1_SATIV1, SBM.BM_DESC , SA1.A1_XCANAL, SA1.A1_TABELA, SA1.A1_XSUBCAN, "
		cQuery += "SB1.B1_XSUBGR1, SB1.B1_XSUBGR4 "
		//cQuery += "(SELECT (ISNULL(SUM(D2_TOTAL),0)*-1) FROM SD2010 SD2 WHERE SD1.D1_FORNECE = SD2.D2_CLIENTE AND SD2.D_E_L_E_T_='' "
		//cQuery += "AND SD2.D2_EMISSAO Between '"+DTOS(MV_PAR01)+"' And '"+DTOS(MV_PAR02)+"') AS 'VALMERCFATURADO' "   chenrique
		cQuery += "FROM SD1080 SD1 INNER JOIN SA1080 SA1 ON(SD1.D1_FORNECE = SA1.A1_COD) "
		cQuery += "INNER JOIN SA3080 SA3 ON(SA1.A1_VEND = SA3.A3_COD) "
		cQuery += "INNER JOIN SB1080 SB1 ON(SD1.D1_COD = SB1.B1_COD) "
		cQuery += "INNER JOIN SBM080 SBM ON(SD1.D1_GRUPO = SBM.BM_GRUPO) "
		cQuery += "INNER JOIN SF4080 SF4 ON(SD1.D1_TES = SF4.F4_CODIGO) "
		cQuery += "WHERE SD1.D1_DTDIGIT Between '"+DTOS(MV_PAR01)+"' And '"+DTOS(MV_PAR02)+"' "
		if ALLTRIM(MV_PAR11) != ""
			cCliSQL	:= "'"+ALLTRIM(StrTran(MV_PAR11,";","','"))+"' "
			cCliSQL := iif(right(cCliSQL,4) == ",'' ",substr(cCliSQL,1,len(cCliSQL)-4),cCliSQL)
			cQuery += "AND SD1.D1_FORNECE IN ("+cCliSQL+") "  
		ENDIF
		if ALLTRIM(MV_PAR09) != ""
			cVendSQL		:= "'"+ALLTRIM(StrTran(MV_PAR09,";","','"))+"' "
			cVendSQL := iif(right(cVendSQL,4) == ",'' ",substr(cVendSQL,1,len(cVendSQL)-4),cVendSQL) 
			cQuery += "AND SA1.A1_VEND IN ("+cVendSQL+") " 
		endif 
		if ALLTRIM(MV_PAR10) != ""
			cSuperSQL	:= "'"+ALLTRIM(StrTran(MV_PAR10,";","','"))+"' "
			cSuperSQL := iif(right(cSuperSQL,4) == ",'' ",substr(cSuperSQL,1,len(cSuperSQL)-4),cSuperSQL)
			cQuery += "AND SA3.A3_SUPER IN ("+cSuperSQL+") "  
		ENDIF
		if ALLTRIM(MV_PAR15) != ""
			cFilSQL	:= "'"+ALLTRIM(StrTran(MV_PAR15,";","','"))+"' "  
			cFilSQL := iif(right(cFilSQL,4) == ",'' ",substr(cFilSQL,1,len(cFilSQL)-4),cFilSQL) 
			cQuery += "AND SD1.D1_FILIAL  IN ("+cFilSQL+") "   
		endif	
		if MV_PAR16 == 2
			cQuery += "AND SF4.F4_ESTOQUE = 'S' " 	
		elseif MV_PAR16 == 3 
			cQuery += "AND SF4.F4_ESTOQUE = 'N' " 
		endif
		IF !EMPTY(MV_PAR17)
			cQuery += "AND SA1.A1_REGIAO ='"+MV_PAR17+"' "
		ENDIF	
		cQuery += "AND SD1.D1_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		cQuery += "AND SD1.D1_TIPO = 'D' " 
		cQuery += "AND SD1.D1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
		cQuery += "AND SA1.A1_EST BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
		cQuery += "AND SD1.D1_CF IN ('"+c_Cfop+"') "  
		cQuery += "AND SD1.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_=''  AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' AND SBM.D_E_L_E_T_='' "
		cQuery += "GROUP BY A1_REGIAO, "
		cQuery += "SD1.D1_FORNECE, SA1.A1_NOME, SA1.A1_VEND, SA3.A3_NOME, SD1.D1_COD, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_ITEM, SD1.D1_GRUPO, A1_SATIV1,SA3.A3_SUPER, SA1.A1_XSUBCAN, SD1.D1_FILIAL, " 
		cQuery += "SD1.D1_DTDIGIT, SD1.D1_LOJA,SD1.D1_SEGUM, SA1.A1_EST, SA1.A1_MUN, SB1.B1_DESC, SB1.B1_GRUPO,SBM.BM_DESC, SA1.A1_XCANAL, SA1.A1_TABELA,SB1.B1_XSUBGR1, SB1.B1_XSUBGR4 "
		cQuery += " ORDER BY SD1.D1_DOC, SD1.D1_SERIE" 
		If Select(cAliasQry) > 0
			(cAliasQry)->(DbCloseArea())
		EndIf
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),(cAliasQry),.T.,.T.)    
	 
		DbSelectArea((cAliasQry))
		do While !((cAliasQry))->(EOF())
			AADD(aQuery,	{(cAliasQry)->(D1_FORNECE),;     	//1
							(cAliasQry)->(D1_LOJA),;         	//2
							(cAliasQry)->(A1_NOME),;        	//3
							(cAliasQry)->(D1_DOC),;          	//4
							(cAliasQry)->(D1_SERIE),;        	//5
							(cAliasQry)->(D1_DTDIGIT),;      	//6
							(cAliasQry)->(A1_VEND),;        	//7
							(cAliasQry)->(A3_NOME),;         	//8
							(cAliasQry)->(GESTOR),;        	//9
							(cAliasQry)->(A1_EST),;          	//10
							(cAliasQry)->(A1_MUN),;			//11
							CVALTOCHAR((cAliasQry)->(QTDE)),; 			//12
							CVALTOCHAR((cAliasQry)->(UNIT)),; 		   	//13
							CVALTOCHAR((cAliasQry)->(VALMERCDEVOLVIDO)),;	//14
							(cAliasQry)->(D1_COD),;        	//15      
							(cAliasQry)->(D1_GRUPO),;			//16
							(cAliasQry)->(B1_DESC),;        	//17
							(cAliasQry)->(BM_DESC),;        	//18
							(cAliasQry)->(A1_SATIV1),;    	//19
							'NIL',;  				    	//20
							'NIL',;							//21
							CVALTOCHAR((cAliasQry)->(ICMS)),;  	    	//22
							CVALTOCHAR((cAliasQry)->(IPI)),;				//23
							CVALTOCHAR((cAliasQry)->(ICMSST)),;  		   	//24
							CVALTOCHAR((cAliasQry)->(COFINS)),;  		   	//25
							CVALTOCHAR((cAliasQry)->(PIS)),;   		  	//26
							(cAliasQry)->(D1_ITEM),;        	//27
							'NIL',;                                       //28
							(cAliasQry)->(A1_XCANAL),;                       //29
							(cAliasQry)->(A1_TABELA),;			                  //30
							(cAliasQry)->(A1_XSUBCAN),;                              //31
							(cAliasQry)->(D1_FILIAL),;                               //32
							(cAliasQry)->(A1_REGIAO),;// 33
							(cAliasQry)->(B1_XSUBGR1),;					//34
							(cAliasQry)->(B1_XSUBGR4),;				//35
							})                                    
		(cAliasQry)->(DbSkip())	
		enddo 
		If Select((cAliasQry)) > 0
			(cAliasQry)->(DbCloseArea())
		EndIf
	U_FechOBD(nConecta)
endif
oReport:Section(1):Cell("CCODCLI"		):Hide()
oReport:Section(1):Cell("CLOJACLI"		):Hide()
oReport:Section(1):Cell("CNOMECLI"		):Hide()
oReport:Section(1):Cell("CREGIAO"		):Hide()
oReport:Section(1):Cell("CESTADO"		):Hide()
oReport:Section(1):Cell("CCIDADE"		):Hide()
oReport:Section(1):Cell("CFILIAL"		):Hide()
oReport:Section(1):Cell("CNFISCAL"		):Hide()
oReport:Section(1):Cell("CSERIE"		):Hide()
oReport:Section(1):Cell("CCONDPGTO"		):Hide()
oReport:Section(1):Cell("DEMISSAO"		):Hide()  
oReport:Section(1):Cell("CCANAL"		):Hide()  
oReport:Section(1):Cell("CTABELA"		):Hide()
oReport:Section(1):Cell("CITEM"	  		):Hide()
oReport:Section(1):Cell("CPRODUTO"		):Hide()
oReport:Section(1):Cell("CDESC"			):Hide()
oReport:Section(1):Cell("CGRUPO"		):Hide()
oReport:Section(1):Cell("CGDESC"		):Hide()
oReport:Section(1):Cell("NQUANT"		):Hide()
oReport:Section(1):Cell("NPRCVEN"		):Hide()
oReport:Section(1):Cell("NTOTAL"		):Hide()
oReport:Section(1):Cell("NVALICM"		):Hide()
oReport:Section(1):Cell("NVALIPI"		):Hide()
oReport:Section(1):Cell("NICMRET"		):Hide()
oReport:Section(1):Cell("NVALCOF"		):Hide()
oReport:Section(1):Cell("NVALPIS"		):Hide()
oReport:Section(1):Cell("NPRCIMP"		):Hide()
oReport:Section(1):Cell("CVEND"			):Hide()
oReport:Section(1):Cell("CNVEND"		):Hide()
oReport:Section(1):Cell("CSUPER"		):Hide()
oReport:Section(1):Cell("CNOMSUP"		):Hide()
oReport:Section(1):Cell("CPEDIDO"		):Hide()
oReport:Section(1):Cell("CPEDCLI"		):Hide()
oReport:Section(1):Cell("CSUBCAN"		):Hide()
oReport:Section(1):Cell("CLGRUPO"		):Hide()
oReport:Section(1):Cell("CLDESC"		):Hide()
oReport:Section(1):Cell("CSGRUPO"		):Hide()
oReport:Section(1):Cell("CSDESC"		):Hide()

oReport:Section(1):Section(1):Init()
for i=1 to len(aQuery)  
	oReport:IncMeter()
	if aQuery[i][1] == "Devolucoes"
		oReport:SkipLine()
		oReport:PrintText(aQuery[i][1])
		oReport:SkipLine()	
		loop
	endif 
    c_Filial		:= aQuery[i][32] 
	cCodCli		:= aQuery[i][1] 
	cLojaCli	:= aQuery[i][2]
	cNomeCli	:= aQuery[i][3] 
	cRegiao		:= PegaReg(aQuery[i][33],"REGIAO")
	cEstado		:= aQuery[i][10]  
	cCidade 	:= aQuery[i][11]  
	cNFiscal 	:= aQuery[i][4]
	cSerie 		:= aQuery[i][5]
	cCond  		:= aQuery[i][20] 
	dEmissao 	:= STOD(aQuery[i][6]) 
	CCANAL		:= aQuery[i][29]
	cTabela		:= aQuery[i][30]
	CSUBCAN		:= aQuery[i][31]
	cItem   	:= aQuery[i][27]
	cProduto 	:= aQuery[i][15]
	cDesc  		:= aQuery[i][17]
	cGrupo 		:= aQuery[i][16]
	cGDesc  	:= aQuery[i][18]
	nQuant 		:= val(aQuery[i][12])
	nPrcVen 	:= val(aQuery[i][13])
	nTotal  	:= val(aQuery[i][14])
	nValIcm 	:= val(aQuery[i][22])
	nValIpi		:= val(aQuery[i][23])
	nIcmRet 	:= val(aQuery[i][24]) 
	nValCof  	:= val(aQuery[i][25])
	nValPIS 	:= val(aQuery[i][26])
	nPrcImp		:= (val(aQuery[i][14])-val(aQuery[i][22])-val(aQuery[i][25])-val(aQuery[i][26]))/val(aQuery[i][12])
	cVend    	:= aQuery[i][7]
	cNVend   	:= aQuery[i][8]
	cSuper   	:= aQuery[i][9]
	cNomSup		:= Posicione("SA3",1,xFilial("SA3")+aQuery[i][9],"A3_NOME")
	cPedido 	:= aQuery[i][28]
	cPedcli   	:= aQuery[i][21]
	CLGRUPO		:= aQuery[i][34]
	CLDESC		:= PegaReg(aQuery[i][34],"LINHA")
	CSGRUPO		:= aQuery[i][35]
	CSDESC		:= PegaReg(aQuery[i][35],"COR")
	
	oReport:Section(1):Section(1):PrintLine() 
	oReport:Section(1):Cell("CCODCLI"		):Show()
	oReport:Section(1):Cell("CLOJACLI"		):Show()
	oReport:Section(1):Cell("CNOMECLI"		):Show()
	oReport:Section(1):Cell("CREGIAO"		):Show()
	oReport:Section(1):Cell("CESTADO"		):Show()
	oReport:Section(1):Cell("CCIDADE"		):Show()
	oReport:Section(1):Cell("CFILIAL"		):Show()
	oReport:Section(1):Cell("CNFISCAL"		):Show()
	oReport:Section(1):Cell("CSERIE"		):Show()
	oReport:Section(1):Cell("CCONDPGTO"		):Show()
	oReport:Section(1):Cell("DEMISSAO"		):Show()
	oReport:Section(1):Cell("CCANAL"		):Show()  
	oReport:Section(1):Cell("CTABELA"		):Show()
	oReport:Section(1):Cell("CITEM"	  		):Show()
	oReport:Section(1):Cell("CPRODUTO"		):Show()
	oReport:Section(1):Cell("CDESC"			):Show()
	oReport:Section(1):Cell("CGRUPO"		):Show()
	oReport:Section(1):Cell("CGDESC"		):Show()
	oReport:Section(1):Cell("NQUANT"		):Show()
	oReport:Section(1):Cell("NPRCVEN"		):Show()
	oReport:Section(1):Cell("NTOTAL"		):Show()
	oReport:Section(1):Cell("NVALICM"		):Show()
	oReport:Section(1):Cell("NVALIPI"		):Show()
	oReport:Section(1):Cell("NICMRET"		):Show()
	oReport:Section(1):Cell("NVALCOF"		):Show()
	oReport:Section(1):Cell("NVALPIS"		):Show()
	oReport:Section(1):Cell("NPRCIMP"		):Show()
	oReport:Section(1):Cell("CVEND"			):Show()
	oReport:Section(1):Cell("CNVEND"		):Show()
	oReport:Section(1):Cell("CSUPER"		):Show()
	oReport:Section(1):Cell("CNOMSUP"		):Show()
	oReport:Section(1):Cell("CPEDIDO"		):Show()
	oReport:Section(1):Cell("CPEDCLI"		):Hide()
	oReport:Section(1):Cell("CSUBCAN"		):Show()
	oReport:Section(1):Cell("CLGRUPO"		):Show()
	oReport:Section(1):Cell("CLDESC"		):Show()
	oReport:Section(1):Cell("CSGRUPO"		):Show()
	oReport:Section(1):Cell("CSDESC"		):Show()
next
oReport:section(1):Finish()
oReport:Section(1):section(1):Finish()		
Return

Static Function AjustaSx1(cPerg)
Private aHelpP 	:= {}
Private aHelpE 	:= {}
Private aHelpS	:= {}
u_xPutSx1(cPerg,"01","Emissao Inicial"    	,"Emissao Inicial" 	,"Emissao inicial"	,"mv_ch1","D",08,0,0,"G",""	,     		,,,"mv_par01",		,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"02","Emissao Final"      	,"Emissao Final"    ,"Emissao  final"  	,"mv_ch2","D",08,0,0,"G",""	,     		,,,"mv_par02",     	,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"03","Produto Inicial?"	,"Produto Inicial"  ,"Produto Final"   	,"mv_ch3","C",15,0,0,"G",""	,"SB1"		,,,"mv_par03",     	,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"04","Produto Final"      	,"Produto Final"    ,"Produto Final"   	,"mv_ch4","C",15,0,0,"G",""	,"SB1"		,,,"mv_par04",     	,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"05","Grupo Inicial?"    	,"Grupo Inicial"    ,"Grupo Inicial"  	,"mv_ch5","C",04,0,0,"G",""	,"SBM"		,,,"mv_par05",    	,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"06","Grupo Final"        	,"Grupo Final"      ,"Grupo Final"    	,"mv_ch6","C",04,0,0,"G",""	,"SBM"		,,,"mv_par06",    	,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"07","Considera ?" 	 	,"Considera" 		,"Considera"   		,"mv_ch7","N",01,0,0,"C",""	,"  " 		,,,"mv_par07" ,"Ambas",,,,"Faturamento",,,"Devolucao",,,,,,,,,{"Informe se deseja Dev, Venda ou Ambos","",""},{},{})
u_xPutSx1(cPerg,"08","Tipo Produto ?"     	,"Tipo Produto"		,"Tipo produto" 	,"mv_ch8","C",02,0,0,"G","","02 "		,,,"mv_par08",	    ,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"09","Vendedor ?"       	,"Vendedor de"     	,"Vendedor de"      ,"mv_ch9","C",04,0,0,"R","","SA3"		,,,"mv_par09",  	,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"10","Gestor ?"    	    ,"Gestor de"		,"Gestor de"   		,"mv_cha","C",04,0,0,"R","","SA3"		,,,"mv_par10",    	,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"11","Cliente ?"        	,"Cliente de ?"     ,"Cliente de ?"		,"mv_chb","C",06,0,0,"R","","SA1"		,,,"mv_par11",	    ,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"12","Estado de ?"        	,"Estado de ?"      ,"Estado de ?"		,"mv_chc","C",02,0,0,"G","","12 "		,,,"mv_par12", 	    ,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"13","Estado Ate"         	,"Estado Ate"       ,"Estado Ate"      	,"mv_chd","C",02,0,0,"G","","12 "		,,,"mv_par13",  	,,,,     ,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)
u_xPutSx1(cPerg,"14","Local ?"        		,"Local ?"     		,"Local ?"          ,"mv_che","C",02,0,0,"R","","Z2"		,,,"mv_par14",    	,,,,     ,,,,,,,,,,,,{"Informe o Armazem","",""},{},{})
u_xPutSx1(cPerg,"15","Filial ?"       		,"Filial ?"     	,"Filial ?"        	,"mv_chf","C",02,0,0,"R","","SM0EMP"	,,,"mv_par15",    	,,,,     ,,,,,,,,,,,,{"Informe a Filial","",""},{},{}) 
u_xPutSx1(cPerg,"16","Mov. Estoque ?" 	 	,"Mov. Estoque ?"	,"Mov. Estoque ?"	,"mv_chg","N",01,0,0,"C",""	,"  " 		,,,"mv_par16" ,"Ambas",,,,"Venda Normal",,,"Venda Programada",,,,,,,,,{"Informe se deseja ver movimentacao de estoque","",""},{},{})
u_xPutSx1(cPerg,"17","Regiao ?" 	   		,"Regiao"			,"Regiao"			,"mv_chh","C",03,0,0,"C",""	,"A2" 		,,,"mv_par17" ,,,,,,,,,,,,,,,,,{},{},{})

	
Return  

Static Function PegaReg(ctxt,cBusca)
Local cREg	:= ""
if cBusca == "REGIAO"
	cREg  := Posicione("SX5",1,xFilial("SX5")+"A2"+ctxt ,"X5_DESCRI")
elseif cBusca == "LINHA"
	cREg  := Posicione("SX5",1,xFilial("SX5")+"ZM"+ctxt ,"X5_DESCRI")
elseIF cBusca == "COR"
	cREg  := Posicione("SX5",1,xFilial("SX5")+"ZP"+ctxt ,"X5_DESCRI")
endif
Return(cReg)