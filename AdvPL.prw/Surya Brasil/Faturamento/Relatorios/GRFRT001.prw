#INCLUDE "FIVEWIN.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GRFRT001  ³ Autor ³ Francisco C Godinho ³ Data ³09/08/2013  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao das Entregas - Uso Logistica, Release 4.           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GRFRT001()
Local oReport
//-- Interface de impressao
oReport := ReportDef()
oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Francisco C Godinho   ³ Data ³ 16/02/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±               
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport
#IFDEF TOP
	Local cAliasSF2 := GetNextAlias()
	Local cAliasZZL := GetNextAlias()
	Local cAliasZZI := GetNextAlias()
#ELSE
	Local cAliasSF2	:= "SF2"
	Local cAliasZZL	:= "ZZL"
	Local cAliasZZI := "ZZI"
#ENDIF
cPerg   := "GRFRETE002"
aHelpP 	:= aHelpE := aHelpS	:= {}

PutSx1(cPerg,"01","Emissao Inicial"    	,"Emissao Inicial"      ,"Emissao inicial"     ,"mv_ch1","D",08,0,0,"G",""                ,     ,,,"mv_par01",     ,     ,     ,  ,     ,     ,     ,  ,  ,  ,  ,  ,  ,  ,  ,  ,aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"02","Emissao Final"      	,"Emissao Final"        ,"Emissao  final"      ,"mv_ch2","D",08,0,0,"G",""                ,     ,,,"mv_par02",     ,     ,     ,  ,     ,     ,     ,  ,  ,  ,  ,  ,  ,  ,  ,  ,aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"03","Transp. Inicial ?"  	,"Transp. Inicial"      ,"Transp.  Final"      ,"mv_ch3","C",06,0,0,"G",""                ,"SA4",,,"mv_par03",     ,     ,     ,  ,     ,     ,     ,  ,  ,  ,  ,  ,  ,  ,  ,  ,aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"04","Transp. Final"      	,"Transp.  Final"       ,"Transp.  Final"      ,"mv_ch4","C",06,0,0,"G",""                ,"SA4",,,"mv_par04",     ,     ,     ,  ,     ,     ,     ,  ,  ,  ,  ,  ,  ,  ,  ,  ,aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"05","Filial NF"         	,"Filial NF"            ,"Filial NF"           ,"mv_ch5","C",02,0,0,"G",""                ,"XM0",,,"mv_par05",     ,     ,     ,  ,     ,     ,     ,  ,  ,  ,  ,  ,  ,  ,  ,  ,aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"06","Doc Inicial ?"   	,"Transp. Inicial"      ,"Transp.  Final"      ,"mv_ch6","C",06,0,0,"G",""                ,""   ,,,"mv_par06",     ,     ,     ,  ,     ,     ,     ,  ,  ,  ,  ,  ,  ,  ,  ,  ,aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"07","Doc Final"	 		,"Transp.  Final"       ,"Transp.  Final"      ,"mv_ch7","C",06,0,0,"G",""                ,""   ,,,"mv_par07",     ,     ,     ,  ,     ,     ,     ,  ,  ,  ,  ,  ,  ,  ,  ,  ,aHelpP,aHelpE,aHelpS)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01             // De Data                                        ³
//³ mv_par02             // Ate a Data                                     ³
//³ mv_par03             // Transportadora De                              ³
//³ mv_par04             // Ate Transportadora                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("GRFRT001","CONTROLE DE ENTREGAS - USO LOGISTICA",cPerg, {|oReport| ReportPrint(oReport,cAliasSF2,cAliasZZL,cAliasZZI)},"Este programa ira emitir a relacao de CONTROLE Entregas - EDI Proceda. Uso da Setor de Logistica.")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
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
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
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
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 1 Cabecalho                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
o_Cabec := TRSection():New(oReport,"Cabec",{"SF2","SF2TRB"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	//
o_Cabec:SetTotalInLine(.F.)
// Dados da Nota Fiscal / Entrega - Cabecalho do relatorio
// Fillial  NF	        Numero	    Serie       Docto.	Cliente	Nome	Estado	CIDADE	Transp. N.Fiscal	Transp. Ocorrencia
//	Nome	DT Emissao	Data Coleta	Dias Coleta	Data Ocorrencia	Dias Padrao
// REALIZADO PELA TRANSPORTADORA	Dias ate Entrega	Atrazo	Descricao	Observacoes

TRCell():New(o_Cabec,"CCLASSI"	 	,/*Tabela*/,RetTitle("ZZL_CLASSI") 	,PesqPict("ZZL","ZZL_CLASSI"),10,/*lPixel*/,{|| c_Classi })
//TRCell():New(o_Cabec,"FILOCO"	 	,/*Tabela*/,RetTitle("ZZL_FILOCO") 	,PesqPict("ZZL","ZZL_FILOCO"),TamSx3("ZZL_FILOCO"   )[1],/*lPixel*/,{|| c_FilOco	})
TRCell():New(o_Cabec,"CFILDOC"	 	,/*Tabela*/,RetTitle("ZZL_FILDC")  	,PesqPict("ZZL","ZZL_FILDC"	),TamSx3("ZZL_FILDC"	)[1],/*lPixel*/,{|| c_FilDoc	})
TRCell():New(o_Cabec,"CDOC"		 	,/*Tabela*/,RetTitle("F2_DOC"	)  	,PesqPict("SF2","F2_DOC"	),TamSx3("F2_DOC"		)[1],/*lPixel*/,{|| c_Doc	})
TRCell():New(o_Cabec,"CSERIE"  	 	,/*Tabela*/,RetTitle("F2_SERIE"	)	,PesqPict("SF2","F2_SERIE"	),TamSx3("F2_SERIE"		)[1],/*lPixel*/,{|| c_Serie	})
TRCell():New(o_Cabec,"CCLIENTE"	 	,/*Tabela*/,RetTitle("F2_CLIENTE")	,PesqPict("SF2","F2_CLIENTE"),TamSx3("F2_CLIENTE"	)[1],/*lPixel*/,{|| c_Cliente})
TRCell():New(o_Cabec,"CLOJA"	 	,/*Tabela*/,RetTitle("F2_LOJA"	)	,PesqPict("SF2","F2_LOJA"	),TamSx3("F2_LOJA"		)[1],/*lPixel*/,{|| c_Loja	})
TRCell():New(o_Cabec,"CNOMECLI"	 	,/*Tabela*/,RetTitle("A1_NOME")	    ,PesqPict("SA1","A1_NOME"	),TamSx3("A1_NOME"	    )[1],/*lPixel*/,{|| c_NomeCli})
TRCell():New(o_Cabec,"CMUNI"	 	,/*Tabela*/,RetTitle("A1_MUN")	    ,PesqPict("SA1","A1_MUN"	),TamSx3("A1_MUN"	    )[1],/*lPixel*/,{|| c_Muni})
TRCell():New(o_Cabec,"F2EST"	 	,/*Tabela*/,RetTitle("F2_EST"	)	,PesqPict("SF2","F2_EST"	),TamSx3("F2_EST"		)[1],/*lPixel*/,{|| c_Uf	})
TRCell():New(o_Cabec,"CTRANSP"	 	,/*Tabela*/,"Transp. N.Fiscal"	    ,PesqPict("SF2","F2_TRANSP" ),TamSx3("F2_TRANSP"	)[1],/*lPixel*/,{|| c_NfTrans})
TRCell():New(o_Cabec,"CNTRANS"	 	,/*Tabela*/,RetTitle("A4_NOME")	    ,PesqPict("SA4","A4_NOME"	),TamSx3("A4_NOME"	    )[1],/*lPixel*/,{|| c_NFNomTra})
TRCell():New(o_Cabec,"CTRANOCO"	 	,/*Tabela*/,"Transp. Ocorrencia"	,PesqPict("ZZL","ZZL_CDTRP" ),TamSx3("ZZL_CDTRP"	)[1],/*lPixel*/,{|| c_OcoTrans})
TRCell():New(o_Cabec,"CNOCOTRANS"	,/*Tabela*/,RetTitle("A4_NOME")	    ,PesqPict("SA4","A4_NOME"	),TamSx3("A4_NOME"	    )[1],/*lPixel*/,{|| c_OcNomTra})
TRCell():New(o_Cabec,"DEMISSAO"	 	,/*Tabela*/,RetTitle("F2_EMISSAO")	,PesqPict("SF2","F2_EMISSAO"),TamSx3("F2_EMISSAO"	)[1],/*lPixel*/,{|| d_Emissao})
TRCell():New(o_Cabec,"DCOLETA"	 	,/*Tabela*/,RetTitle("F2_XDTCOL")	,PesqPict("SF2","F2_XDTCOL"	),TamSx3("F2_XDTCOL"	)[1],/*lPixel*/,{|| d_Coleta})
TRCell():New(o_Cabec,"NDIASCOL"	 	,/*Tabela*/,"Dias Coleta"			,PesqPict("SD2","D2_TOTAL"	),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| n_DiaCol})
TRCell():New(o_Cabec,"DENTREG"	 	,/*Tabela*/,"Data Ocorrencia"       ,PesqPict("SF2","F2_EMISSAO"),TamSx3("F2_EMISSAO"	)[1],/*lPixel*/,{|| d_Entrega})
TRCell():New(o_Cabec,"NDIASMUN"	  	,/*Tabela*/,"Prazo Entrega"			,PesqPict("SD2","D2_TOTAL"	),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| n_DiaMun})
TRCell():New(o_Cabec,"DPREVENT"	  	,/*Tabela*/,"Previsao Entrega"		,PesqPict("SF2","F2_XDTCOL"	),TamSx3("F2_XDTCOL"	)[1],/*lPixel*/,{|| dDt_Prv})
TRCell():New(o_Cabec,"NDIASENT"	 	,/*Tabela*/,"Tempo Total Logistico",PesqPict("SD2","D2_TOTAL"	),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| n_DiaEnt})
TRCell():New(o_Cabec,"NDIASTRA"	    ,/*Tabela*/,"Tempo Transportadora"  ,PesqPict("SD2","D2_TOTAL"	),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| n_Diatra})
TRCell():New(o_Cabec,"LEADTIME"	 	,/*Tabela*/,"Atraso"			    ,PesqPict("SD2","D2_TOTAL"	),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| n_LeadTim})
TRCell():New(o_Cabec,"DESOCO"		,/*Tabela*/,RetTitle("ZZI_DESC")	,PesqPict("ZZI","ZZI_DESC")  ,TamSx3("ZZI_DESC"   	)[1],/*lPixel*/,{|| c_DescOco})
TRCell():New(o_Cabec,"OBSOCO"		,/*Tabela*/,RetTitle("ZZL_OBS")	    ,PesqPict("ZZL","ZZL_OBS")   ,TamSx3("ZZL_OBS"   	)[1],/*lPixel*/,{|| c_ObsOco})

oEntrega := TRSection():New(o_Cabec,"Ocorrencias",{"ZZL","ZZLTRB"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	//
oEntrega:SetTotalInLine(.F.)

TRCell():New(oEntrega,"CCLASSI"		,/*Tabela*/,RetTitle("ZZL_CLASSI") 	,PesqPict("ZZL","ZZL_CLASSI"),10,/*lPixel*/,{|| c_Classi })
// TRCell():New(oEntrega,"FILOCO"		,/*Tabela*/,RetTitle("ZZL_FILOCO") 	,PesqPict("ZZL","ZZL_FILOCO"),TamSx3("ZZL_FILOCO"   )[1],/*lPixel*/,{|| c_FilOco	})
TRCell():New(oEntrega,"CFILDOC"		,/*Tabela*/,RetTitle("ZZL_FILDC")  	,PesqPict("ZZL","ZZL_FILDC"	),TamSx3("ZZL_FILDC"	)[1],/*lPixel*/,{|| c_FilDoc	})
TRCell():New(oEntrega,"CDOC"		,/*Tabela*/,RetTitle("F2_DOC"	)  	,PesqPict("SF2","F2_DOC"	),TamSx3("F2_DOC"		)[1],/*lPixel*/,{|| c_Doc	})
TRCell():New(oEntrega,"CSERIE"  	,/*Tabela*/,RetTitle("F2_SERIE"	)	,PesqPict("SF2","F2_SERIE"	),TamSx3("F2_SERIE"		)[1],/*lPixel*/,{|| c_Serie	})
TRCell():New(oEntrega,"CCLIENTE"	,/*Tabela*/,RetTitle("F2_CLIENTE")	,PesqPict("SF2","F2_CLIENTE"),TamSx3("F2_CLIENTE"	)[1],/*lPixel*/,{|| c_Cliente})
TRCell():New(oEntrega,"CLOJA"		,/*Tabela*/,RetTitle("F2_LOJA"	)	,PesqPict("SF2","F2_LOJA"	),TamSx3("F2_LOJA"		)[1],/*lPixel*/,{|| c_Loja	})
TRCell():New(oEntrega,"CNOMECLI"	,/*Tabela*/,RetTitle("A1_NOME")	    ,PesqPict("SA1","A1_NOME"	),TamSx3("A1_NOME"	    )[1],/*lPixel*/,{|| c_NomeCli})
TRCell():New(oEntrega,"CMUNI"		,/*Tabela*/,RetTitle("A1_MUN")	    ,PesqPict("SA1","A1_MUN"	),TamSx3("A1_MUN"	    )[1],/*lPixel*/,{|| c_Muni})
TRCell():New(oEntrega,"F2EST"		,/*Tabela*/,RetTitle("F2_EST"	)	,PesqPict("SF2","F2_EST"	),TamSx3("F2_EST"		)[1],/*lPixel*/,{|| c_Uf	})
TRCell():New(oEntrega,"CTRANSP"		,/*Tabela*/,"Transp. N.Fiscal"	    ,PesqPict("SF2","F2_TRANSP" ),TamSx3("F2_TRANSP"	)[1],/*lPixel*/,{|| c_NfTrans})
TRCell():New(oEntrega,"CNTRANS"		,/*Tabela*/,RetTitle("A4_NOME")	    ,PesqPict("SA4","A4_NOME"	),TamSx3("A4_NOME"	    )[1],/*lPixel*/,{|| c_NFNomTra})
TRCell():New(oEntrega,"CTRANOCO"	,/*Tabela*/,"Transp. Ocorrencia"	,PesqPict("ZZL","ZZL_CDTRP" ),TamSx3("ZZL_CDTRP"	)[1],/*lPixel*/,{|| c_OcoTrans})
TRCell():New(oEntrega,"CNOCOTRANS"	,/*Tabela*/,RetTitle("A4_NOME")	    ,PesqPict("SA4","A4_NOME"	),TamSx3("A4_NOME"	    )[1],/*lPixel*/,{|| c_OcNomTra})
TRCell():New(oEntrega,"DEMISSAO"	,/*Tabela*/,RetTitle("F2_EMISSAO")	,PesqPict("SF2","F2_EMISSAO"),TamSx3("F2_EMISSAO"	)[1],/*lPixel*/,{|| d_Emissao})
TRCell():New(oEntrega,"DCOLETA"		,/*Tabela*/,RetTitle("F2_XDTCOL")	,PesqPict("SF2","F2_XDTCOL"	),TamSx3("F2_XDTCOL"	)[1],/*lPixel*/,{|| d_Coleta})
TRCell():New(oEntrega,"NDIASCOL"	,/*Tabela*/,"Dias Coleta"			,PesqPict("SD2","D2_TOTAL"	),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| n_DiaCol})
TRCell():New(oEntrega,"DENTREG"		,/*Tabela*/,"Data Ocorrencia"       ,PesqPict("SF2","F2_EMISSAO"),TamSx3("F2_EMISSAO"	)[1],/*lPixel*/,{|| d_Entrega})
TRCell():New(oEntrega,"NDIASMUN"	,/*Tabela*/,"Prazo Entrega"			,PesqPict("SD2","D2_TOTAL"	),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| n_DiaMun})
TRCell():New(oEntrega,"DPREVENT"  	,/*Tabela*/,"Previsao Entrega"		,PesqPict("SF2","F2_XDTCOL"	),TamSx3("F2_XDTCOL"	)[1],/*lPixel*/,{|| dDt_Prv})
TRCell():New(oEntrega,"NDIASENT"	,/*Tabela*/,"Tempo Total Logistico",PesqPict("SD2","D2_TOTAL"	),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| n_DiaEnt})
TRCell():New(oEntrega,"NDIASTRA"	,/*Tabela*/,"Tempo Transportadora"  ,PesqPict("SD2","D2_TOTAL"	),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| n_Diatra})
TRCell():New(oEntrega,"LEADTIME"	,/*Tabela*/,"Atraso"			    ,PesqPict("SD2","D2_TOTAL"	),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| n_LeadTim})
TRCell():New(oEntrega,"DESOCO"		,/*Tabela*/,RetTitle("ZZI_DESC")	,PesqPict("ZZI","ZZI_DESC")  ,TamSx3("ZZI_DESC"   	)[1],/*lPixel*/,{|| c_DescOco})
TRCell():New(oEntrega,"OBSOCO"		,/*Tabela*/,RetTitle("ZZL_OBS")	    ,PesqPict("ZZL","ZZL_OBS")   ,TamSx3("ZZL_OBS"   	)[1],/*lPixel*/,{|| c_ObsOco})
// Define Alinhamento das colunas

oEntrega:Cell("CCLASSI"):SetHeaderAlign("CENTER")
//oEntrega:Cell("FILOCO"):SetHeaderAlign("CENTER")
oEntrega:Cell("CFILDOC"):SetHeaderAlign("CENTER")
oEntrega:Cell("CNOCOTRANS"):SetHeaderAlign("LEFT")
oEntrega:Cell("CMUNI"):SetHeaderAlign("LEFT")
oEntrega:Cell("CDOC"):SetHeaderAlign("LEFT")
oEntrega:Cell("CSERIE"):SetHeaderAlign("LEFT")
oEntrega:Cell("CCLIENTE"):SetHeaderAlign("LEFT")
oEntrega:Cell("CLOJA"):SetHeaderAlign("LEFT")
oEntrega:Cell("F2EST"):SetHeaderAlign("CENTER")
oEntrega:Cell("CNOMECLI"):SetHeaderAlign("LEFT")
oEntrega:Cell("DEMISSAO"):SetHeaderAlign("CENTER")
oEntrega:Cell("DCOLETA"):SetHeaderAlign("CENTER")
oEntrega:Cell("DENTREG"):SetHeaderAlign("LEFT")
oEntrega:Cell("NDIASCOL"):SetHeaderAlign("RIGHT")
oEntrega:Cell("NDIASENT"):SetHeaderAlign("RIGHT")
oEntrega:Cell("CTRANSP"):SetHeaderAlign("LEFT")
oEntrega:Cell("CNTRANS"):SetHeaderAlign("LEFT")
oEntrega:Cell("CTRANOCO"):SetHeaderAlign("LEFT")
oEntrega:Cell("DESOCO"):SetHeaderAlign("LEFT")
oEntrega:Cell("OBSOCO"):SetHeaderAlign("LEFT")
oEntrega:Cell("NDIASTRA"):SetHeaderAlign("RIGHT")
oEntrega:Cell("NDIASMUN"):SetHeaderAlign("RIGHT")
oEntrega:Cell("DPREVENT"):SetHeaderAlign("LEFT")
oEntrega:Cell("LEADTIME"):SetHeaderAlign("RIGHT")

// Imprimie Cabecalho no Topo da Pagina Secao 1
oReport:Section(1):SetHeaderPage(.F.)
// Inibe Imprimie Cabecalho no Topo da Pagina Secao 2
oReport:Section(1):Section(1):SetHeaderPage(.F.)
oReport:Section(1):SetEditCell(.F.)
Return(oReport)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Francisco C Godinho   ³ Data ³ 21/08/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
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
Static Function ReportPrint(oReport,cAliasSD1,cAliasSD2,cAliasSB1)
Local lEncerrado := .F.
Local aRegistros := {}
Local aNaoImprime := {}
Local nLinha := 1

#IFDEF TOP
	Local nj	:= 0
	Local cWhere:= ""
#ELSE
	Local cCondicao := ""
#ENDIF
// Define Variaveis de impressao
c_Classi  := c_FilDoc  := c_FilOco   := c_Doc      := c_Serie  := c_Cliente := c_Loja   := c_Uf := c_OcNomTra := ""
c_Muni    := c_NomeCli := c_NfTrans := c_NFNomTra := c_OcoTrans := c_CodOco := c_DescOco := c_ObsOco := ""
d_Emissao :=  d_Coleta := d_Entrega := dDt_Prv := Ctod("")
n_LeadTim := n_DiaCol  :=  n_DiaEnt := n_DiaTra := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o bloco de codigo que retornara o      ³
//³ conteudo de impressao da celula.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):Section(1):Cell("CCLASSI"	):SetBlock({||  c_Classi})
//oReport:Section(1):Section(1):Cell("FILOCO"		):SetBlock({||  c_FilOco})
oReport:Section(1):Section(1):Cell("CFILDOC"	):SetBlock({||  c_FilDoc})
oReport:Section(1):Section(1):Cell("CDOC"		):SetBlock({||  c_Doc	})
oReport:Section(1):Section(1):Cell("CSERIE"  	):SetBlock({||  c_Serie	})
oReport:Section(1):Section(1):Cell("CCLIENTE"	):SetBlock({||  c_Cliente})
oReport:Section(1):Section(1):Cell("CLOJA"		):SetBlock({||  c_Loja	})
oReport:Section(1):Section(1):Cell("F2EST"		):SetBlock({||  c_Uf	})
oReport:Section(1):Section(1):Cell("CNOMECLI"	):SetBlock({||  c_NomeCli})
oReport:Section(1):Section(1):Cell("DEMISSAO"	):SetBlock({||  d_Emissao})
oReport:Section(1):Section(1):Cell("DCOLETA"	):SetBlock({||  d_Coleta})
oReport:Section(1):Section(1):Cell("DENTREG"	):SetBlock({||  d_Entrega})
oReport:Section(1):Section(1):Cell("NDIASCOL"	):SetBlock({||  n_DiaCol})
oReport:Section(1):Section(1):Cell("NDIASENT"	):SetBlock({||  n_DiaEnt})
oReport:Section(1):Section(1):Cell("CTRANSP"	):SetBlock({||  c_NfTrans})
oReport:Section(1):Section(1):Cell("CNTRANS"	):SetBlock({||  c_NFNomTra})
oReport:Section(1):Section(1):Cell("CTRANOCO"	):SetBlock({||  c_OcoTrans})
oReport:Section(1):Section(1):Cell("DESOCO"	 	):SetBlock({||  c_DescOco})
oReport:Section(1):Section(1):Cell("OBSOCO"	 	):SetBlock({||  c_ObsOco})
oReport:Section(1):Section(1):Cell("NDIASMUN" 	):SetBlock({||  n_DiaMun}) 
oReport:Section(1):Section(1):Cell("DPREVENT"	):SetBlock({||  dDt_Prv})
oReport:Section(1):Section(1):Cell("NDIASTRA" 	):SetBlock({||  n_DiaTra})
oReport:Section(1):Section(1):Cell("LEADTIME" 	):SetBlock({||  n_LeadTim})
oReport:Section(1):Section(1):Cell("CNOCOTRANS"):SetBlock({||  c_OcNomTra})
oReport:Section(1):Section(1):Cell("CMUNI"     ):SetBlock({||  c_Muni})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona ordem dos arquivos consultados no   ³
//³ processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF2->(dbsetorder(1))
SA1->(dbSetOrder(1))
SA4->(dbSetOrder(1))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com parametros    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(oReport:Title() + "LEADTIME DE ENTREGAS - USO LOGISTICA")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01             // De Data               ³
//³ mv_par02             // Ate a Data            ³
//³ mv_par03             // Transportadora De     ³
//³ mv_par04             // Ate Transportadora    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SF2")
DbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta filtro para processar as vendas         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("SF2TRB") >  0
	SF2TRB->(DbCloseArea())
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query para SQL                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStru  := dbStruct()
cQuery := "SELECT F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_EST,A1_NOME,F2_EMISSAO,F2_XDTCOL,F2_TRANSP,A1_CGC,F2_FILIAL,ZZL_CLASSI,ISNULL(ZZL.R_E_C_N_O_,0) AS REGZZL " + CRLF
cQuery += "FROM " + RetSqlTab("SF2") + CRLF
cQuery += "   INNER JOIN "+ RetSqlTab("SA1")+" ON "  + CRLF
cQuery += "      SF2.F2_CLIENTE = A1_COD " + CRLF
cQuery += "      AND SF2.F2_LOJA = A1_LOJA " + CRLF

cQuery += "   LEFT OUTER JOIN "+ RetSqlTab("ZZL")+" ON "  + CRLF
cQuery += "      F2_FILIAL = ZZL_FILOCO AND "  + CRLF
cQuery += "      F2_DOC = ZZL_NRDC AND F2_SERIE = ZZL_SERDC AND ZZL.D_E_L_E_T_ =''" + CRLF
//cQuery += "      AND ZZL_DTOCOR+ZZL_HROCOR = (SELECT MAX(ZZL_DTOCOR+ZZL_HROCOR) FROM "+ RetSqlName("ZZL")+" ZZL1 WHERE LEFT(F2_DOC,6) = RIGHT(ZZL_NRDC,6) AND F2_SERIE = ZZL_SERDC AND ZZL1.D_E_L_E_T_='') " + CRLF

cQuery += "WHERE SF2.D_E_L_E_T_ ='' AND SF2.F2_TRANSP BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "+ CRLF
cQuery += " AND SF2.F2_DOC BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' "+ CRLF
cQuery += "      AND SF2.F2_EMISSAO BETWEEN '" + Dtos(mv_par01) + "' AND '" + Dtos(mv_par02) + "' "  + CRLF
If ! EmPty(MV_PAR05)
	cQuery += "      AND SF2.F2_FILIAL = '" + MV_PAR05 + "' " + CRLF
EndIf
cQuery += "      AND SF2.F2_SERIE = '3' " + CRLF //AND SF2.F2_DOC = '086162'
cQuery += "      AND A1_CGC NOT IN ('64109499000152','64109499000403','64109499000314','64109499000586') " // (Nossa Filial de SP) ou (Nossa Filial do RJ) ou (Nossa Filial de SC) ou ES
//cQuery += "GROUP BY F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_EST,A1_NOME,F2_EMISSAO,F2_XDTCOL,F2_TRANSP,ZZL_CODOCO,ZZI_DESC,ZZL_DTOCOR,ZZL_CDTRP,ZZL_OBS,ZZL_FILOCO,ZZL_CLASSI,ZZL_FILDC,A1_CGC"  + CRLF
cQuery += "ORDER BY SF2.F2_DOC,SF2.F2_SERIE,ZZL_DTOCOR,ZZL_HROCOR " + CRLF

cQuery := ChangeQuery(cQuery)

MEMOWRIT("GRfrt001.SQL",cQuery)

MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SF2TRB', .F., .T.)},OemToAnsi("Selecionando Registros..."))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se aglutinara produtos de Grade ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter(RecCount())		// Total de Elementos da regua
// Inibe impressao primeira secao oCabec
oReport:Section(1):Cell("CCLASSI"	):Hide()
oReport:Section(1):Cell("CFILDOC"	):Hide()
//oReport:Section(1):Cell("FILOCO"	):Hide()
oReport:Section(1):Cell("CDOC"		):Hide()
oReport:Section(1):Cell("CSERIE"  	):Hide()
oReport:Section(1):Cell("CCLIENTE"	):Hide()
oReport:Section(1):Cell("CLOJA"		):Hide()
oReport:Section(1):Cell("F2EST"		):Hide()
oReport:Section(1):Cell("CNOMECLI"	):Hide()
oReport:Section(1):Cell("DEMISSAO"	):Hide()
oReport:Section(1):Cell("DCOLETA"	):Hide()
oReport:Section(1):Cell("DENTREG"	):Hide()
oReport:Section(1):Cell("NDIASCOL"	):Hide()
oReport:Section(1):Cell("NDIASENT"	):Hide()
oReport:Section(1):Cell("CTRANSP"	):Hide()
oReport:Section(1):Cell("CNTRANS"	):Hide()
oReport:Section(1):Cell("CTRANOCO"	):Hide()
oReport:Section(1):Cell("DESOCO"	):Hide()
oReport:Section(1):Cell("OBSOCO"	):Hide()
oReport:Section(1):Cell("NDIASMUN" 	):Hide() 
oReport:Section(1):Cell("DPREVENT" 	):Hide() 
oReport:Section(1):Cell("NDIASTRA" 	):Hide()
oReport:Section(1):Cell("LEADTIME" 	):Hide()
oReport:Section(1):Cell("CNOCOTRANS"):Hide()
oReport:Section(1):Cell("CMUNI"     ):Hide()

// Inicia segunda secao oEntrega
oReport:Section(1):Section(1):Init()
DbSelectArea("SF2TRB")
SF2TRB->(DbGoTop())                                                                                     

AADD(aRegistros,{SF2TRB->F2_DOC,SF2TRB->F2_SERIE,SF2TRB->F2_CLIENTE,SF2TRB->ZZL_CLASSI,SF2TRB->REGZZL})

While !oReport:Cancel() .And. ! SF2TRB->(Eof())
    
	If nLinha <> 1 .and. SF2TRB->F2_DOC == aRegistros[nLinha-1,1] .and. SF2TRB->F2_SERIE == aRegistros[nLinha-1,2] .and. SF2TRB->F2_CLIENTE == aRegistros[nLinha-1,3]
		AADD(aRegistros,{SF2TRB->F2_DOC,SF2TRB->F2_SERIE,SF2TRB->F2_CLIENTE,SF2TRB->ZZL_CLASSI,SF2TRB->REGZZL})
		nLinha ++
		SF2TRB->(DbSkip())
	Else
		If len(aRegistros) > 1
			For nW := 1 to len(aRegistros)
				If aRegistros[nW,4]="E"
					lEncerrado := .T.
				EndIf
			Next
			If lEncerrado
				For nW := 1 to len(aRegistros)
					If aRegistros[nW,4]<>"E" .and. aScan(aNaoImprime,aRegistros[nW,5])=0
						AADD(aNaoImprime,aRegistros[nW,5])
					EndIf
				Next
				lEncerrado := .F.
			Else
				For nW := 1 to len(aRegistros)-1
					AADD(aNaoImprime,aRegistros[nW,5])
				Next
			EndIf
			
			aRegistros := {}
			nLinha := 1
			AADD(aRegistros,{SF2TRB->F2_DOC,SF2TRB->F2_SERIE,SF2TRB->F2_CLIENTE,SF2TRB->ZZL_CLASSI,SF2TRB->REGZZL})        
			
		Else
			aRegistros := {}
			nLinha := 1
			AADD(aRegistros,{SF2TRB->F2_DOC,SF2TRB->F2_SERIE,SF2TRB->F2_CLIENTE,SF2TRB->ZZL_CLASSI,SF2TRB->REGZZL})        
		EndIf
		
		nLinha ++
		SF2TRB->(DbSkip())
	EndIf
EndDo

If len(aRegistros) > 1
	For nW := 1 to len(aRegistros)
		If aRegistros[nW,4]="E"
			lEncerrado := .T.
		EndIf
	Next
	If lEncerrado
		For nW := 1 to len(aRegistros)
			If aRegistros[nW,4]<>"E" .and. aScan(aNaoImprime,aRegistros[nW,5])=0
				AADD(aNaoImprime,aRegistros[nW,5])
			EndIf
		Next
	Else
		For nW := 1 to len(aRegistros)-1
			AADD(aNaoImprime,aRegistros[nW,5])
		Next
	EndIf
EndIf 

SF2TRB->(DbGoTop())
While !oReport:Cancel() .And. ! SF2TRB->(Eof()) 

	If aScan(aNaoImprime,SF2TRB->REGZZL)=0
	
		oReport:IncMeter()
		
		c_FilDoc   := SF2TRB->F2_FILIAL
		c_Doc      := SF2TRB->F2_DOC
		c_Serie    := SF2TRB->F2_SERIE
		c_Cliente  := SF2TRB->F2_CLIENTE
		c_Loja	   := SF2TRB->F2_LOJA
		c_Uf	   := SF2TRB->F2_EST
		c_NomeCli  := SF2TRB->A1_NOME
		c_NfTrans  := SF2TRB->F2_TRANSP
		c_NFNomTra := Posicione("SA4",1,xFilial("SA4") + c_NfTrans  , "A4_NOME")
		d_Emissao  := Dtoc(Stod(SF2TRB->F2_EMISSAO))
		d_Coleta   := Dtoc(Stod(SF2TRB->F2_XDTCOL))
		c_CodMun   := Posicione("SA1",1,xFilial("SA1") + c_Cliente + c_Loja , "A1_COD_MUN")
		c_Muni     := Posicione("SA1",1,xFilial("SA1") + c_Cliente + c_Loja , "A1_MUN")
		n_DiaMun   := PesqMun(c_Uf, c_CodMun, Stod(SF2TRB->F2_EMISSAO),c_FilDoc ) // Posicione("SZ6",1,xFilial("SZ6") + c_CodMun , "Z6_PRAZO") // Z6_FILIAL+Z6_CODMUN
		DbSelectArea("SF2TRB")
		n_DtValid  := Stod(SF2TRB->F2_XDTCOL)
		c_FilOco   := ''
		c_Classi   := ''
		c_OcoTrans := ''
		c_OcNomTra := ''
		c_CodOco   := ''
		c_DescOco  := ''
		d_Entrega  := ''
		d__Entrega := ''
		c_ObsOco   := ''
		n_DiaTra:= 0
		n_LeadTim := 0
		
		If !Empty(n_DtValid)
			dDt_Prv := n_DtValid
			
			/*For nX := 1 to n_DiaMun
				dDt_Prv := DataValida(dDt_Prv + 1)
			Next*/
			
			dDt_Prv := U_x1_DiaUtil(dDt_Prv,n_DiaMun)
			
			If dDataBase > dDt_Prv
				n_LeadTim := DateDiffDay(dDataBase,dDt_Prv)					//Atraso := dDataBase - DtPrevista
			Else
				n_LeadTim := DateDiffDay(dDt_Prv,dDataBase)*(-1)			//Atraso := DtPrevista - dDataBase
			EndIf
		Else
			n_LeadTim :=  99999
		EndIF
		If  SF2TRB->REGZZL > 0 .and. aScan(aNaoImprime,SF2TRB->REGZZL)=0
			DbSelectArea("ZZL")
			DbGoTo(SF2TRB->REGZZL)
			
			c_FilDoc   := ZZL->ZZL_FILDC
			c_FilOco   := ZZL->ZZL_FILOCO
			c_Classi   := If(ZZL->ZZL_CLASSI == "A","Alert",If(ZZL->ZZL_CLASSI =="U","Urgente",If(ZZL->ZZL_CLASSI =="N","Normal","Encerrado")))
			
			Iif(c_Classi == "Encerrado",lEncerrado := .T.,.F.)
			
			c_OcoTrans := Substr(Alltrim(ZZL->ZZL_CDTRP)+Space(6),1,6)
			c_OcNomTra := Posicione("SA4",1,xFilial("SA4") + c_OcoTrans , "A4_NOME")
			c_CodOco   := ZZL->ZZL_CODOCO
			c_DescOco  := Posicione("ZZI",1,xFilial("ZZI") + c_CodOco , "ZZI_DESC")
			
			d_Entrega  := ZZL->ZZL_DTOCOR
			d__Entrega := ZZL->ZZL_DTOCOR
			c_ObsOco   := ZZL->ZZL_OBS
			
			If n_DiaMun > 1
				/*For nDias := 1 To n_DiaMun
					n_DtValid    := Datavalida( n_DtValid + 1)
				Next*/
				n_DtValid := U_x1_DiaUtil(n_DtValid,n_DiaMun)
			Else
				//n_DtValid    := Datavalida( n_DtValid + 1)
				n_DtValid := U_x1_DiaUtil(n_DtValid,1)
			EndIf
			d_DtCol := Stod(SF2TRB->F2_XDTCOL)
			d_DtEmi := Stod(SF2TRB->F2_EMISSAO)
			n_DiaCol:= 0
			If ! EmpTy(d_DtCol)
				//While d_DtCol <> d_DtEmi
				If d_DtEmi > d_DtCol
				   	msgAlert("Nota com informações de COLETA incorretas - Nota : "+c_Doc)
				   	
				Else
					n_DiaCol := U_x2_DiaUtil(d_DtCol,d_DtEmi)
				Endif
					//d_DtEmi += 1
					//If Dow(d_DtEmi) > 1 .and. Dow(d_DtEmi) < 7
					//	n_DiaCol ++
					//EndIf
					
					//Loop
				//EndDo
			  //If Dow(d_DtEmi) > 1 .and. Dow(d_DtEmi) < 7
			//		n_DiaCol += 1
			 //	EndIf
			   //	n_DiaCol := d_DtCol - d_DtEmi
			EndIf
			xx := "1"
			// n_DiaCol   := If( ! EmpTy(SF2TRB->F2_XDTCOL), Stod(SF2TRB->F2_XDTCOL) - Stod(SF2TRB->F2_EMISSAO)	, 0 ) // dDatabase - Stod(SF2TRB->F2_EMISSAO))
			n_DiaEnt:= 0
			d_DtEnt := If( ! EmpTy(d__Entrega) ,d__Entrega,dDatabase)
			d_DtEmi := Stod(SF2TRB->F2_EMISSAO)
			//While d_DtEnt <> d_DtEmi 
				If d_DtEmi > d_DtEnt
				   	msgAlert("Nota com informações de Entrega incorretas - Nota : "+c_Doc)
				   	
			    Else
					n_DiaEnt := U_x2_DiaUtil(d_DtEnt,d_DtEmi)
				Endif
				/*If Dow(d_DtEmi) > 1 .and. Dow(d_DtEmi) < 7
					n_DiaEnt ++
				EndIf
				d_DtEmi += 1
				Loop
			EndDo
			If Dow(d_DtEmi) > 1 .and. Dow(d_DtEmi) < 7
			n_DiaEnt += 1
			EndIf */
			xx := "1"
			//			n_DiaEnt   := If( ! EmpTy(d__Entrega) , Stod(d__Entrega) - Stod(SF2TRB->F2_EMISSAO)  , dDatabase - Stod(SF2TRB->F2_EMISSAO))
			n__DiaMun  := If( ! EmpTy(n_DtValid)  , n_DtValid - Stod(SF2TRB->F2_EMISSAO)      	 , 0                                   )
			
			d_DtCol := Stod(SF2TRB->F2_XDTCOL)
			dDt_Prv := d_DtCol
			If ! EmPtY(d_DtCol)
				d_DtEnt := If( ! EmpTy(d__Entrega) ,d__Entrega,dDatabase)
				n_DiaTra:= 0
				//While d_DtEnt <> d_DtCol   
				    If d_DtCol > d_DtEnt
				    	msgAlert("Nota com informações de coleta incorretas - Nota : "+c_Doc)
				    	
				    Else
   						n_DiaTra := U_x2_DiaUtil(d_DtEnt,d_DtCol)
				    Endif
				/*		If Dow(d_DtCol) > 1 .and. Dow(d_DtCol) < 7
							n_DiaTra ++
						EndIf
						d_DtCol += 1
						
					Loop
				EndDo
				If Dow(d_DtCol) > 1 .and. Dow(d_DtCol) < 7
					n_DiaTra += 1
				EndIf*/
				For nX := 1 to n_DiaMun
					dDt_Prv := DataValida(dDt_Prv + 1)
				Next
				
				If !Empty(d_Entrega)
					If d_Entrega >= dDt_Prv
						If c_Classi <> "Encerrado"
							n_LeadTim := DateDiffDay(dDataBase,dDt_Prv)			//Atraso := dDataBase - DtPrevista
						Else
							n_LeadTim := DateDiffDay(d_Entrega,dDt_Prv)			//Atraso := DtOcorrencia - DtPrevista
						EndIf
					Else
						If c_Classi <> "Encerrado"
							If dDataBase > dDt_Prv
								n_LeadTim := DateDiffDay(dDataBase,dDt_Prv)			//Atraso := dDataBase - DtPrevista
							Else
								n_LeadTim := DateDiffDay(dDt_Prv,dDataBase)*(-1)		//Atraso := DtPrevista - dDataBase
							EndIf
						Else
							n_LeadTim := DateDiffDay(dDt_Prv,d_Entrega)*(-1)		//Atraso := DtPrevista - DtOcorrencia
						EndIf
					EndIf
				Else
					If dDataBase > dDt_Prv
						n_LeadTim := DateDiffDay(dDataBase,dDt_Prv)				//Atraso := dDataBase - DtPrevista
					Else
						n_LeadTim := DateDiffDay(dDt_Prv,dDataBase)*(-1)		//Atraso := DtPrevista - dDataBase
					EndIf
				EndIf
			Else
				n_LeadTim := 99999
			EndIf
			//n_LeadTim  := If( n__DiaMun > 0 , n_DiaEnt - n__DiaMun , 0)
			/*			If n_LeadTim < 0
			n_LeadTim := 0
			EndIf
			*/      
			d_Entrega  := Dtoc(d_Entrega)   
			dDt_Prv		:=Dtoc(dDt_Prv)
					
			oReport:Section(1):Section(1):PrintLine()
			
			oReport:Section(1):Section(1):Cell("CCLASSI"	):Show()
			oReport:Section(1):Section(1):Cell("CFILDOC"	):Show()
			//oReport:Section(1):Section(1):Cell("FILOCO"    ):Show()
			oReport:Section(1):Section(1):Cell("CDOC"		):Show()
			oReport:Section(1):Section(1):Cell("CSERIE"  	):Show()
			oReport:Section(1):Section(1):Cell("CCLIENTE"	):Show()
			oReport:Section(1):Section(1):Cell("CLOJA"		):Show()
			oReport:Section(1):Section(1):Cell("F2EST"		):Show()
			oReport:Section(1):Section(1):Cell("CNOMECLI"	):Show()
			oReport:Section(1):Section(1):Cell("DEMISSAO"	):Show()
			oReport:Section(1):Section(1):Cell("DCOLETA"	):Show()
			oReport:Section(1):Section(1):Cell("DENTREG"	):Show()
			oReport:Section(1):Section(1):Cell("NDIASCOL"	):Show()
			oReport:Section(1):Section(1):Cell("NDIASENT"	):Show()
			oReport:Section(1):Section(1):Cell("CTRANSP"	):Show()
			oReport:Section(1):Section(1):Cell("CNTRANS"	):Show()
			oReport:Section(1):Section(1):Cell("CTRANOCO"	):Show()
			oReport:Section(1):Section(1):Cell("DESOCO"    ):Show()
			oReport:Section(1):Section(1):Cell("OBSOCO"    ):Show()
			oReport:Section(1):Section(1):Cell("NDIASMUN" 	):Show()  
			oReport:Section(1):Section(1):Cell("DPREVENT" 	):Show()  
			oReport:Section(1):Section(1):Cell("NDIASTRA" 	):Show()
			oReport:Section(1):Section(1):Cell("LEADTIME" 	):Show()
			oReport:Section(1):Section(1):Cell("CNOCOTRANS"):Show()
			oReport:Section(1):Section(1):Cell("CMUNI"     ):Show()
	
		Else
			If ! EmpTy(d_Coleta)
				d_DtCol := Stod(SF2TRB->F2_XDTCOL)
		   		d_DtEmi := Stod(SF2TRB->F2_EMISSAO)
				n_DiaCol:= 0
				If ! EmpTy(d_DtCol)
				
					If d_DtEmi > d_DtCol
					   	msgAlert("Nota com informações de COLETA incorretas - Nota : "+c_Doc)
					   	
					Else
						n_DiaCol := U_x2_DiaUtil(d_DtCol,d_DtEmi)
						n_DiaTra := U_x2_DiaUtil(dDataBase,d_DtCol)
					Endif
				   /*	While d_DtCol <> d_DtEmi  
						if d_DtEmi > d_DtCol
							exit
						endif
						d_DtEmi += 1
						If Dow(d_DtEmi) > 1 .and. Dow(d_DtEmi) < 7
							n_DiaCol ++
						EndIf
						
						Loop
					EndDo*/
				EndIf
			Else
				d_DtEmi := Stod(SF2TRB->F2_EMISSAO)
				d_DtCol := CtoD("//")
				n_DiaCol := 99
			EndIf
			
			n_DiaEnt := U_x2_DiaUtil(dDataBase,d_DtEmi)
								
			oReport:Section(1):Section(1):PrintLine()
			
			oReport:Section(1):Section(1):Cell("CCLASSI"	):Show()
			oReport:Section(1):Section(1):Cell("CFILDOC"	):Show()
			//	oReport:Section(1):Section(1):Cell("FILOCO"	    ):Show()
			oReport:Section(1):Section(1):Cell("CDOC"		):Show()
			oReport:Section(1):Section(1):Cell("CSERIE"  	):Show()
			oReport:Section(1):Section(1):Cell("CCLIENTE"	):Show()
			oReport:Section(1):Section(1):Cell("CLOJA"		):Show()
			oReport:Section(1):Section(1):Cell("F2EST"		):Show()
			oReport:Section(1):Section(1):Cell("CNOMECLI"	):Show()
			oReport:Section(1):Section(1):Cell("DEMISSAO"	):Show()
			oReport:Section(1):Section(1):Cell("DCOLETA"	):Show()
			oReport:Section(1):Section(1):Cell("DENTREG"	):Show()
			oReport:Section(1):Section(1):Cell("NDIASCOL"	):Show()
			oReport:Section(1):Section(1):Cell("NDIASENT"	):Show()
			oReport:Section(1):Section(1):Cell("CTRANSP"	):Show()
			oReport:Section(1):Section(1):Cell("CNTRANS"	):Show()
			oReport:Section(1):Section(1):Cell("CTRANOCO"	):Show()
			oReport:Section(1):Section(1):Cell("DESOCO"    ):Show()
			oReport:Section(1):Section(1):Cell("OBSOCO"    ):Show()
			oReport:Section(1):Section(1):Cell("NDIASMUN" 	):Show()
			oReport:Section(1):Section(1):Cell("NDIASTRA" 	):Show()
			oReport:Section(1):Section(1):Cell("LEADTIME" 	):Show()
			oReport:Section(1):Section(1):Cell("CNOCOTRANS"):Show()
			oReport:Section(1):Section(1):Cell("CMUNI"     ):Show()
		EndIf
		DbSelectArea("SF2TRB")
		SF2TRB->(DbSkip())
	Else
		SF2TRB->(DbSkip())
	EndIf
	
EndDo

oReport:section(1):Finish()
oReport:Section(1):section(1):Finish()
Return

Static FuncTion PesqMun(c_Uf, c_CodMun, dDtEmis, c_FilDoc )
Local _nPrazo := 0

cQuery := "SELECT * "
cQuery += " FROM "+RetSqlName("SZ6")+" "
cQuery += " WHERE D_E_L_E_T_ <> '*'"
cQuery += " AND Z6_FILIAL = '" + c_FilDoc + "'"
cQuery += " AND Z6_EST = '" + c_Uf + "' "
cQuery += " AND Z6_CODMUN = '" + c_CodMun + "' "
//cQuery += " AND '" + Dtos(dDtEmis) + "' BETWEEN Z6_DTINI AND Z6_DTFIM "
//cQuery += " AND Z6_DTINI <='" + Dtos(dDtEmis) + "' AND Z6_DTFIM =''"
cQuery += " AND Z6_DTFIM =''"

If Select("TRB") > 0           // Verificar se o Alias ja esta aberto.
	DbSelectArea("TRB")        // Se estiver, devera ser fechado.
	TRB->(DbCloseArea())
EndIf
_cQuery := ChangeQuery(cQuery)

DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), "TRB", .T., .F. )

dbSelectArea("TRB")

TRB->(dbGotop())
If  ! TRB->(EOF())
	_nPrazo  := TRB->Z6_PRAZO
EndIf
Return(_nPrazo)
                    
/*User Function CPrev(dColeta, cCliente,dEmissao, c_FilDoc)
local	n_DiaMun   := 0
local 	n_DtValid  := IIF(Empty(dColeta),dEmissao,dColeta)
local	dDt_Prv := CtoD("//")
local c_Uf := POSICIONE("SA1",1,XFILIAL("SA1")+CCLIENTE,"A1_EST")
local c_CodMun :=POSICIONE("SA1",1,XFILIAL("SA1")+CCLIENTE,"A1_COD_MUN")

n_DiaMun   := PesqMun(c_Uf, c_CodMun, dEmissao,c_FilDoc ) // Posicione("SZ6",1,xFilial("SZ6") + c_CodMun , "Z6_PRAZO") // Z6_FILIAL+Z6_CODMUN

If !Empty(dColeta)
	dDt_Prv := U_x1_DiaUtil(n_DtValid,n_DiaMun)
EndIf

/*
if dDt_Prv != ctod("")
	if n_DiaMun > 0		
		For nX := 1 to n_DiaMun
			dDt_Prv := DataValida(dDt_Prv + 1)
		Next
	else
		n_DiaMun  := Posicione("SZ6",1,xFilial("SZ6") + c_CodMun , "Z6_PRAZO") 
		if n_DiaMun > 0	
			For nX := 1 to n_DiaMun
				dDt_Prv := DataValida(dDt_Prv + 1)
			Next  
		else
			dDt_Prv := ctod("") 
		endif
	endif
else
	dDt_Prv := ctod("")
endif
*/
//Return(dDt_Prv)