#define STR0035 "Ambiente"
#define STR0050 "Protocolo"
#define STR0068 "Cod.Ret.NFe"
#define STR0069 "Msg.Ret.NFe"
#define STR0107 "Consulta NF"
#define STR0114 "Ok"
#define STR0056 "Produ��o"
#define STR0057 "Homologa��o"
#define STR0129 "Vers�o da mensagem"
#define CRLF chr(13)+chr(10)
#define DS_MODALFRAME   128

#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDE "AvPrint.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#INCLUDE "DEFEMPSB.CH"
#Include "TbiConn.ch"


/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Prog.  � SBP0001 � Uso � Surya Brasil � Modulo � Compras � Data � 08/02/17 ���
�����������������������������������������������������������������������������͹��
���Desc.  � Rotina de gest�o dos documentos de entradas importados via XML    ���
���       �                                                                   ���
�����������������������������������������������������������������������������͹��
��� Autor � Caio de Paula             � Contato �(11) 98346-3154              ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-

*/

User FuncTion SBP0001()
Private oOk       := LoadBitmap( GetResources()	, 	"CHECKED" 		)
Private oNo       := LoadBitmap( GetResources()	, 	"UNCHECKED" 	)
Private oVerde    := LoadBitmap( GetResources()	,	"BR_VERDE"		)
Private oVermelho := LoadBitmap( GetResources()	,	"BR_VERMELHO"	)
Private oAzul     := LoadBitmap( GetResources()	,	"BR_AZUL"		)
Private oDlg
Private oLbx
Private oList
Private oFnt1
Private oPrn
Private cLine     := ""
Private bMyLine
Private cCadastro  := "Verificacao Status NFE - Xml"
Private cAlias := "SZ1"
Private errStr  := ""
Private warnStr := ""
Private lChkSefaz := SuperGetMv("SB_CHKSEFA",.T.,.F.)

PRIVATE n	       := 1
PRIVATE aCab	   := {}
PRIVATE aCampos	   := {}
Static __nVez := 0


PRIVATE aRotina := MenuDef()

// 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Gera��o pr�-nota"
aCores := { {	"SZ1->Z1_STATUS == '0'", "BR_AZUL"}  ,{"SZ1->Z1_STATUS == '1'" , "BR_LARANJA"	}	,;
			{	"SZ1->Z1_STATUS == '2'", "BR_PRETO"} ,{"SZ1->Z1_STATUS == '3'" , "BR_VERMELHO"	}	,;
			{	"SZ1->Z1_STATUS == '4'", "BR_MARROM"},{"SZ1->Z1_STATUS == '5'" , "BR_AMARELO"	}	,;
			{	"SZ1->Z1_STATUS == '6'", "BR_VERDE"} ,{"SZ1->Z1_STATUS == '7'" , "BR_CINZA"		}	,;
			{	"SZ1->Z1_STATUS == '8'", "BR_VIOLETA"	} ,{"SZ1->Z1_STATUS == '9'" , "BR_CANCEL"		}	}
			
SZ1->(dbSetOrder(1))

mBrowse( 6, 1,22,75,"SZ1",,,,,,aCores)

Return(.T.)

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Prog.  �CPPRENFE � Uso � Surya Brasil � Modulo � Compras � Data � 08/02/17 ���
�����������������������������������������������������������������������������͹��
���Desc.  � Fun��o que da inicio na gera��o de um documento fiscal de entrada ���
���       �                                                                   ���
�����������������������������������������������������������������������������͹��
��� Autor � Caio de Paula             � Contato �(11) 98346-3154              ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User FuncTion CPPRENFE()
Local nI 			:= 1
Local nX 			:= 1
Local c_Fornece		:= POSICIONE("SA1",3,xfilial("SA1")+SZ1->Z1_CGC,"A1_COD")
Local c_Loja 		:= POSICIONE("SA1",3,xfilial("SA1")+SZ1->Z1_CGC,"A1_LOJA")
Public __xDtXml 	:= Ctod("")
Private _cXml  		:= SZ1->Z1_CHAVE
Private nTotMerc 	:= 0


//Default c_Fornece	:= POSICIONE("SA1",3,xfilial("SA1")+SZ1->Z1_CGC,"A1_COD")
//Default c_Loja 		:= POSICIONE("SA1",3,xfilial("SA1")+SZ1->Z1_CGC,"A1_LOJA")

//&& Bacalhau do chico para fechar tela!!!
/*
__nVez++

If (__nVez%2) == 0
	__nVez:= 0
	Return
EndIf
*/

/*aRotBkp  := aRotina
aRotina := MenuDef2()*/

_cCnpj			:= SZ1->Z1_CGC
_cFilial		:= SZ1->Z1_FILIAL
_cDoc			:= SZ1->Z1_DOC
_cSerie			:= SZ1->Z1_SERIE
_cFilial		:= SZ1->Z1_FILIAL
cNomeFor		:= ""
cChaveNfe		:= SZ1->Z1_CHAVE
_F1_CHVNFE		:= SZ1->Z1_CHAVE
cEspecie		:= SZ1->Z1_ESPECIE
cTipo			:= SZ1->Z1_TIPO
			


If SZ1->Z1_TIPO == 'N' .AND. alltrim(SZ1->Z1_ESPECIE) $ 'SPED|CTE'
		
	c_Fornece	:= POSICIONE("SA2",3,xfilial("SA2")+SZ1->Z1_CGC,"A2_COD")
	c_Loja 		:= POSICIONE("SA2",3,xfilial("SA2")+SZ1->Z1_CGC,"A2_LOJA")
			
ElseIf SZ1->Z1_TIPO == 'D' .AND. SZ1->Z1_ESPECIE $ 'SPED'
		
	c_Fornece	:= POSICIONE("SA1",3,xfilial("SA1")+SZ1->Z1_CGC,"A1_COD")
	c_Loja 		:= POSICIONE("SA1",3,xfilial("SA1")+SZ1->Z1_CGC,"A1_LOJA")	
			
EndIf

// Chamada de Valida��o se j� existe o documento de Entrada/Saida
VerfNF(_cFilial, _cDoc, _cSerie, c_Fornece, c_Loja)

If SZ1->Z1_STATUS $ "6/3"
	
	MsgAlert("Pr�-Nota j� gerado na Base, " + _cXml + "!")
	conout("Documento j� gerado..."+ _cXml)
	Return

EndIf

If cTipo == "N"

	If ALLTRIM(cEspecie) $ "SATCE|NFCE"
	
		DbSelectArea("SA1")
		DbSetOrder(3)
	
		If DbSeek(xFilial("SA2") + _cCnpj )
	
			cFornec := Alltrim(SA1->A1_COD)
			cLoja   := Alltrim(SA1->A1_LOJA)
			cNomeFor:= Alltrim(SA1->A1_NOME)
	
		Else
		
			DbSelectArea("SZ1")
			RecLock("SZ1",.F.)
				SZ1->Z1_STATUS := "5"
			MsUnlock()
			Return
		
		EndIf
			
	Else
	
		DbSelectArea("SA2")
		DbSetOrder(3)
	
		If DbSeek(xFilial("SA2") + _cCnpj )
	
			cFornec := Posicione("SA2",3,xFilial("SA2") + _cCnpj , "A2_COD")
			cLoja   := Posicione("SA2",3,xFilial("SA2") + _cCnpj , "A2_LOJA")
			cNomeFor:= Alltrim(SA2->A2_NOME)
	
		Else
		
			DbSelectArea("SZ1")
			RecLock("SZ1",.F.)
				SZ1->Z1_STATUS := "5"
			MsUnlock()
			Return
		
		EndIf
			
	EndIf
	
Else

	DbSelectArea("SA1")
	DbSetOrder(3)
	
	If DbSeek(xFilial("SA1") + _cCnpj )
	
		cFornec := Posicione("SA1",3,xFilial("SA1") + _cCnpj , "A1_COD")
		cLoja   := Posicione("SA1",3,xFilial("SA1") + _cCnpj , "A1_LOJA")
		cNomeFor:= Alltrim(SA1->A1_NOME)

	Else
	
		// Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-nota   
		DbSelectArea("SZ1")
		RecLock("SZ1",.F.)
			SZ1->Z1_STATUS := "5"
		MsUnlock()		
		Return
	
	EndIf		

EndIf

cXMLFile    := SZ1->Z1_XML
cXML := SZ1->Z1_XML   // MEMOREAD( cXMLFile )
cXML := StrTran(cXML,CHR(13),'')
cXML := StrTran(cXML,CHR(10),'')

If '>' # Substr(cXML,Len(cXML),1)

	cXML := cXML +">"

EndIf


If AllTrim(cEspecie) $ "CTE/CTRC" //Entrada

	u_GeraCte(cXml)

ElseIf AllTrim(cEspecie) $ "SPED"//Entrada

	u_GeraNFe(cXml)

ElseIf AllTrim(cEspecie) $ "SATCE|NFCE" //Saida

	u_GeraCfe(cXml,cEspecie)

EndIf

/*aRotina := aRotBkp*/

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CPNfeLeg  �Autor  �Francisco C Godinho � Data �  04/01/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Legenda do Status                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CPNfeLeg()

BrwLegenda(cCadastro, "Legenda", {	{	"BR_AZUL"    	, "Inclusao - 0" 						} 	,;
									{	"BR_LARANJA" 	, "Pre-Validado - 1"					} 	,;
									{	"BR_PRETO"   	, "Status Sefaz - 2"					}	,;
									{	"BR_VERMELHO"	, "Documento de Entrada - 3"			}	,;
									{	"BR_MARROM"  	, "Depara - 4"							} 	,;
									{	"BR_AMARELO" 	, "Bloqueio Cadastro - 5"				} 	,;
									{	"BR_VERDE"   	, "Pre-Nota Gerada - 6"					} 	,;
									{	"BR_CINZA"   	, "Problema na Geração pré-nota - 7"	} 	,;
									{	"BR_VIOLETA"  	, "Documento de Saída - 8"				}	,;
									{	"BR_CANCEL"  	, "Fornecedor/Cliente Nao encontrado - 9"}	} )


//0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Gera��o pr�-nota

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   �Autor  �Francisco C Godinho � Data �  04/01/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Menu                                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()
PRIVATE aRotina	:= {}

/*aRotina		:= {{ OemToAnsi("Pesquisar") , "AxPesqui"       , 0 , 1},;
				{ OemToAnsi("Visualiza")       , "AxVisual"      	, 0 , 2},;
				{ OemToAnsi("Pesq. SEFAZ")     , "U_VldXml()"    	, 0 , 2},;
				{ OemToAnsi("Gera NF") , "U_CPLIBSCH()"  	, 0 , 3},;
				{ OemToAnsi("Importar Xml")    , "U_CPIMPXML()"  	, 0 , 3},;
				{ OemToAnsi("Gera CTE")        , "U_USCHNCTE({"+cEmpAnt+","+cFilAnt+",.F.})"  	, 0 , 3},; 
				{ OemToAnsi("Historico")       , "U_CPCTRVIS(1)"  	, 0 , 2},;
				{ OemToAnsi("Consulta Resumida"),"U_VISCTE"       , 0 , 2},;				
				{"Legenda"                     , "U_CPNfeLeg()"   	, 0, 2},;
				{ OemToAnsi("Excluir")       , "AxDeleta"      	, 0 , 5}  }*/
				
aRotina		:= {{ OemToAnsi( "Pesquisar"				) 			, "AxPesqui"       									, 0	, 1},;
				{ OemToAnsi( "Visualiza"				)      		, "AxVisual"      									, 0	, 2},;				
				{ OemToAnsi( "Pre-Nota"					)    		, "U_CPPRENFE()"		   							, 0	, 3},; //Gera Pre nota
				{ OemToAnsi( "Classificar"				)		   	, "U_AxClas()" 		 								, 0	, 2},;	// Classifica Nota									
				{ OemToAnsi( "Legenda"					)			, "U_CPNfeLeg()" 		  							, 0	, 5},; 
				{ OemToAnsi( "Estorna Classificacao"	)			, "U_Ax140EstCl()" 									, 0	, 6},;	// Estorna Classifica��o	
				{ OemToAnsi( "Pesq. SEFAZ"				)    		, "U_VldXml()"  		  							, 0	, 7},;	
				{ OemToAnsi( "Gera NF Automatico"		)   		, "U_NFAuto()"  		  							, 0	, 7},;	 
				{ OemToAnsi( "Importa Xml"				)			, "U_SBP0002({'"+cEmpAnt+"','"+cFilAnt+"',.F.})"	, 0 , 8},;	
				{ OemToAnsi( "Dupurar Xmls"				)   		, "U_DepSZ1()"  		  							, 0	, 8},;				
				{ OemToAnsi( "Excluir"					)       	, "AxDeleta"      									, 0	, 8}}
				
Return( aRotina )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PItemPC �                          o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     � 															  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PItemPC(cVar,cA100For,cLoja,cQtd)

Local cSeek			:= ""
Local nOpca			:= 0
Local aArea			:= GetArea()
Local aAreaSA2		:= SA2->(GetArea())
Local aAreaSC7		:= SC7->(GetArea())
Local aAreaSB1		:= SB1->(GetArea())
Local aRateio       := {0,0,0}
Local aNew			:= {}
Local aTamCab		:= {}
Local lGspInUseM	:= If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local aButtons		:= { {'PESQUISA',{||A103VisuPC(aArrSldo[oQual:nAt][2])},OemToAnsi("Visualiza"),OemToAnsi("Pedido")},; 
						{'pesquisa',{||APesqP(aCab,aCampos,aArrayF4,oQual)},OemToAnsi("Pesquisar")} } 
Local aEstruSC7		:= SC7->( dbStruct() )
Local bSavSetKey	:= SetKey(VK_F4,Nil)
Local bSavKeyF5		:= SetKey(VK_F5,Nil)
Local bSavKeyF6		:= SetKey(VK_F6,Nil)
Local bSavKeyF7		:= SetKey(VK_F7,Nil)
Local bSavKeyF8		:= SetKey(VK_F8,Nil)
Local bSavKeyF9		:= SetKey(VK_F9,Nil)
Local bSavKeyF10	:= SetKey(VK_F10,Nil)
Local bSavKeyF11	:= SetKey(VK_F11,Nil)
Local nFreeQt		:= 0
//Local nPosPRD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })
//Local nPosPDD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_PEDIDO" })
//Local nPosITM		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMPC" })
//Local nPosQTD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT" })

Local cQuery		:= ""
Local cAliasSC7		:= "SC7"
Local cCpoObri		:= ""
Local nSavQual
Local nPed			:= 0
Local nX			:= 0
Local nAuxCNT		:= 0
Local lMt103Vpc		:= ExistBlock("MT103VPC")
Local lMt100C7D		:= ExistBlock("MT100C7D")
Local lMt100C7C		:= ExistBlock("MT100C7C")
Local lMt103Sel		:= ExistBlock("MT103SEL")
Local nMT103Sel     := 0
Local nSelOk        := 1
Local lRet103Vpc	:= .T.
Local lContinua		:= .T.
Local lQuery		:= .F.
Local oQual
Local oDlg
Local oPanel
Local aUsButtons  := {}

PRIVATE n	       := 1
PRIVATE aCab	   := {}
PRIVATE aCampos	   := {}
PRIVATE aArrSldo   := {}
PRIVATE aArrayF4   := {}

PRIVATE aPedido	   := {}
PRIVATE lNfMedic   := .F.
PRIVATE lConsMedic := .F.
PRIVATE aHeadSDE   := {}
PRIVATE aColsSDE   := {}
PRIVATE aGets      := {}
PRIVATE lConsLoja	:= .T.
Private n_Qtd := Val(cQtd)
lUsaFiscal := .T.

//���������������������������������������������������������������������Ŀ
//� Impede de executar a rotina quando a tecla F3 estiver ativa		    �
//�����������������������������������������������������������������������
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf
//������������������������������������������������������������������������Ŀ
//� Adiciona botoes do usuario na EnchoiceBar                              �
//��������������������������������������������������������������������������
If ExistBlock( "MTIPCBUT" )
	If ValType( aUsButtons := ExecBlock( "MTIPCBUT", .F., .F. ) ) == "A"
		AEval( aUsButtons, { |x| AAdd( aButtons, x ) } )
	EndIf
EndIf

If lContinua

	//If MaFisFound('NF') .Or. !lUsaFiscal
	//	If cTipo == 'N'
			#IFDEF TOP
				DbSelectArea("SC7")
				If TcSrvType() <> "AS/400"

					If Empty(cVar)
						DbSetOrder(9)
					Else
						DbSetOrder(6)
					EndIf

					lQuery    := .T.
					cAliasSC7 := "QRYSC7"

					cQuery	  := "SELECT "
					For nAuxCNT := 1 To Len( aEstruSC7 )
						If nAuxCNT > 1
							cQuery += ", "
						EndIf
						cQuery += aEstruSC7[ nAuxCNT, 1 ]
					Next
					cQuery += ", R_E_C_N_O_ RECSC7 FROM"
					cQuery += RetSqlName("SC7") + " SC7 "
					cQuery += "WHERE "
					cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND "

					If Empty(cVar)
						If lConsLoja
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_LOJA = '"+cLoja+"' AND "
						Else
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
						Endif	
					Else
						If lConsLoja
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_LOJA = '"+cLoja+"' AND "
							cQuery += "C7_PRODUTO = '"+cVar+"' AND "
						Else
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_PRODUTO = '"+cVar+"' AND "
						Endif
					Endif

					//���������������������������������������������������������������������Ŀ
					//� Filtra os pedidos de compras de acordo com os contratos             �
					//�����������������������������������������������������������������������

					If lConsMedic
						If lNfMedic
							//���������������������������������������������������������������������Ŀ
							//� Traz apenas os pedidos oriundos de medicoes                         �
							//�����������������������������������������������������������������������
							cQuery += "C7_CONTRA<>'"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
							cQuery += "C7_MEDICAO<>'" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "		    		
						Else
							//���������������������������������������������������������������������Ŀ
							//� Traz apenas os pedidos que nao possuem medicoes                     �
							//�����������������������������������������������������������������������
							cQuery += "C7_CONTRA='"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
							cQuery += "C7_MEDICAO='" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "		    		
						EndIf
					EndIf 					
					//����������������������������������������������������������Ŀ
					//� Filtra os Pedidos Bloqueados e Previstos.                �
					//������������������������������������������������������������
					cQuery += "C7_TPOP <> 'P' AND "
					If SuperGetMV("MV_RESTNFE") == "S"
						cQuery += "C7_CONAPRO <> 'B' AND "
					EndIf					
					cQuery += "SC7.C7_ENCER='"+Space(Len(SC7->C7_ENCER))+"' AND "					
					cQuery += "SC7.C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' AND "					

					cQuery += "SC7.D_E_L_E_T_ = ' '"
					cQuery += "ORDER BY "+SqlOrder(SC7->(IndexKey()))	

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
					For nX := 1 To Len(aEstruSC7)
						If aEstruSC7[nX,2]<>"C"
							TcSetField(cAliasSC7,aEstruSC7[nX,1],aEstruSC7[nX,2],aEstruSC7[nX,3],aEstruSC7[nX,4])
						EndIf
					Next nX										
				Else
			#ENDIF			
				If Empty(cVar)
					DbSelectArea("SC7")
					DbSetOrder(9)
					If lConsLoja
						cCond := "C7_FILENT+C7_FORNECE+C7_LOJA"
						cSeek := cA100For+cLoja
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					Else
						cCond := "C7_FILENT+C7_FORNECE"
						cSeek := cA100For
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					EndIf
				Else
					DbSelectArea("SC7")
					DbSetOrder(6)
					If lConsLoja
						cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE+C7_LOJA"
						cSeek := cVar+cA100For+cLoja
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					Else
						cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE"
						cSeek := cVar+cA100For
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					EndIf
				EndIf
				#IFDEF TOP
				EndIf
				#ENDIF

			If Empty(cVar)
				cCpoObri := "C7_LOJA|C7_PRODUTO|C7_QUANT|C7_DESCRI|C7_TIPO|C7_LOCAL|C7_OBS"
			Else
				cCpoObri := "C7_LOJA|C7_QUANT|C7_DESCRI|C7_TIPO|C7_LOCAL|C7_OBS"
			Endif				

			If (cAliasSC7)->(!Eof())

				DbSelectArea("SX3")
				DbSetOrder(2)

				If lNfMedic .And. lConsMedic

					MsSeek("C7_MEDICAO")

					AAdd(aCab,x3Titulo())
					Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
					aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

					MsSeek("C7_CONTRA")

					AAdd(aCab,x3Titulo())
					Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
					aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

					MsSeek("C7_PLANILH")

					AAdd(aCab,x3Titulo())
					Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
					aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

				EndIf 			

				MsSeek("C7_NUM")

				AAdd(aCab,x3Titulo())
				Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
				aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

				DbSelectArea("SX3")
				DbSetOrder(1)
				MsSeek("SC7")
				
				While !Eof() .And. SX3->X3_ARQUIVO == "SC7"
				
					IF ( SX3->X3_BROWSE=="S".And.X3Uso(SX3->X3_USADO).And. AllTrim(SX3->X3_CAMPO)<>"C7_PRODUTO" .And. AllTrim(SX3->X3_CAMPO)<>"C7_NUM" .And.;				
							If( lConsMedic .And. lNfMedic, AllTrim(SX3->X3_CAMPO)<>"C7_MEDICAO" .And. AllTrim(SX3->X3_CAMPO)<>"C7_CONTRA" .And. AllTrim(SX3->X3_CAMPO)<>"C7_PLANILH", .T. )).Or.;
							(AllTrim(SX3->X3_CAMPO) $ cCpoObri)
				
						AAdd(aCab,x3Titulo())
						Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
						aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
				
					EndIf
					dbSkip()		
				
				Enddo					

				DbSelectArea(cAliasSC7)
				
				Do While If(lQuery, ;
						(cAliasSC7)->(!Eof()), ;
						(cAliasSC7)->(!Eof()) .And. xFilEnt(cFilial)+cSeek == &(cCond))

					//��������������������������������������������������������������������Ŀ
					//� Filtra os Pedidos Bloqueados, Previstos e Eliminados por residuo   �
					//����������������������������������������������������������������������
					If !lQuery					
						If (SuperGetMV("MV_RESTNFE") == "S" .And. (cAliasSC7)->C7_CONAPRO == "B") .Or. ;					
								(cAliasSC7)->C7_TPOP == "P" .Or. !Empty((cAliasSC7)->C7_RESIDUO)
							dbSkip()
							Loop
					
						EndIf
					
					Endif

					nFreeQT := 0

					nPed    := aScan(aPedido,{|x| x[1] = (cAliasSC7)->C7_NUM+(cAliasSC7)->C7_ITEM})

					nFreeQT -= If(nPed>0,aPedido[nPed,2],0)
                    /*
					For nAuxCNT := 1 To Len( aCols )
						If (nAuxCNT # n) .And. ;
							cVar == (cAliasSC7)->C7_PRODUTO) .And. ;
							!ATail( aCols[ nAuxCNT ] )							
//							.And. ;
//							(aCols[ nAuxCNT,nPosPDD ] == (cAliasSC7)->C7_NUM) .And. ;
//							(aCols[ nAuxCNT,nPosITM ] == (cAliasSC7)->C7_ITEM) .And. ;
//							!ATail( aCols[ nAuxCNT ] )
							nFreeQT += aCols[ nAuxCNT,nPosQTD ]
						EndIf
					Next
					*/
					
					lRet103Vpc := .T.
                    /*
					If lMt103Vpc
						If lQuery
							('SC7')->(dbGoto((cAliasSC7)->RECSC7))
						EndIf															
						lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
					Endif
                    */
					If lRet103Vpc
						If ((nFreeQT := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE-(cAliasSC7)->C7_QTDACLA-nFreeQT)) > 0)
			
							If nFreeQT >= n_Qtd
							Aadd(aArrayF4,Array(Len(aCampos)))							

							SB1->(DbSetOrder(1))
							SB1->(MsSeek(xFilial("SB1")+(cAliasSC7)->C7_PRODUTO))							
			
							For nX := 1 to Len(aCampos)

								If aCampos[nX][3] != "V"
			
									If aCampos[nX][2] == "N"
			
										If Alltrim(aCampos[nX][1]) == "C7_QUANT"
			
											aArrayF4[Len(aArrayF4)][nX] :=Transform(nFreeQt,PesqPict("SC7",aCampos[nX][1]))
			
										ElseIf Alltrim(aCampos[nX][1]) == "C7_QTSEGUM"
			
											aArrayF4[Len(aArrayF4)][nX] :=Transform(ConvUm(SB1->B1_COD,nFreeQt,nFreeQt,2),PesqPict("SC7",aCampos[nX][1]))
			
										Else
			
											aArrayF4[Len(aArrayF4)][nX] := Transform((cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
			
										Endif											
			
									Else
			
										aArrayF4[Len(aArrayF4)][nX] := (cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1])))								
			
									Endif	
			
								Else
			
									aArrayF4[Len(aArrayF4)][nX] := CriaVar(aCampos[nX][1],.T.)
			
									If Alltrim(aCampos[nX][1]) == "C7_CODGRP"
			
										aArrayF4[Len(aArrayF4)][nX] := SB1->B1_GRUPO                            									
			
									EndIf
			
									If Alltrim(aCampos[nX][1]) == "C7_CODITE"
			
										aArrayF4[Len(aArrayF4)][nX] := SB1->B1_CODITE
			
									EndIf
			
								Endif

							Next

								aAdd(aArrSldo, {nFreeQT, IIF(lQuery,(cAliasSC7)->RECSC7,(cAliasSC7)->(RecNo()))})
                            
                            EndIf
			
							If lMT100C7D
			
								If lQuery
			
									('SC7')->(dbGoto((cAliasSC7)->RECSC7))
			
								EndIf									
			
								aNew := ExecBlock("MT100C7D", .f., .f., aArrayF4[Len(aArrayF4)])
			
								If ValType(aNew) = "A"
			
									aArrayF4[Len(aArrayF4)] := aNew
			
								EndIf
			
							EndIf
			
						EndIf
			
					Endif
			
					(cAliasSC7)->(dbSkip())
			
				EndDo

				If ExistBlock("MT100C7L")
					
					ExecBlock("MT100C7L", .F., .F., { aArrayF4, aArrSldo })
			
				EndIf

				If !Empty(aArrayF4)

					//����������������������������������������������������������Ŀ
					//� Monta dinamicamente o bline do CodeBlock                 �
					//������������������������������������������������������������
					DEFINE MSDIALOG oDlg FROM 30,20  TO 265,521 TITLE OemToAnsi("Selecionar Pedido de Compra ( por item )") Of oMainWnd PIXEL

					If lMT100C7C
						
						aNew := ExecBlock("MT100C7C", .f., .f., aCab)
						
						If ValType(aNew) == "A"
						
							aCab := aNew      
							    
							DbSelectArea("SX3")
			 				DbSetOrder(2)								
							
							For nX := 1 to Len(aCab)
							
						    	If aScan(aCampos,{|x| x[1]= aCab[nX]})==0
        						
						    		If SX3->(MsSeek(aCab[nX]))				
        						 	
        						 		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
        						 	
        						 	EndIf
   						
        						EndIf
							
							Next nX
														
						EndIf

					EndIf

					@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED //"Botoes"
					oPanel:Align := CONTROL_ALIGN_TOP

					oQual := TWBrowse():New( 29,4,243,85,,aCab,aTamCab,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
					oQual:SetArray(aArrayF4)
					oQual:bLine := { || aArrayF4[oQual:nAT] }
					OQual:nFreeze := 1 

					oQual:Align := CONTROL_ALIGN_ALLCLIENT

					If !Empty(cVar)

						@ 6  ,4   SAY OemToAnsi("Produto") Of oPanel PIXEL SIZE 47 ,9 
						@ 4  ,30  MSGET cVar PICTURE PesqPict('SB1','B1_COD') When .F. Of oPanel PIXEL SIZE 80,9

					Else

						@ 6  ,4   SAY OemToAnsi("Selecione o Pedido de Compra") Of oPanel PIXEL SIZE 120 ,9 

					EndIf

					ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nSavQual:=oQual:nAT,nOpca:=1,oDlg:End()},{||oDlg:End()},,aButtons)
					
					If nOpca == 1

						DbSelectArea("SC7")
						MsGoto(aArrSldo[nSavQual][2])
						
   				        // Verifica se o Produto existe Cadastrado na Filial de Entrada
					    DbSelectArea("SB1")
						DbSetOrder(1)
						MsSeek(xFilEnt(xFilial("SC7"))+SC7->C7_PRODUTO)

						If !Eof()

							aListBox[oList:nAT,4] := SC7->C7_NUM
							aListBox[oList:nAT,5] := SC7->C7_ITEM                                       
							oList:Refresh()                
							//oList:lNewLine:=.F.
							/*
							If	!ATail( aCols[ n ] )
								NfePC2Acols(aArrSldo[nSavQual][2],n,aArrSldo[nSavQual][1],,,@aRateio,aHeadSDE,@aColsSDE)
	        				Else
								NfePC2Acols(aArrSldo[nSavQual][2],n+1,aArrSldo[nSavQual][1],,,@aRateio,aHeadSDE,@aColsSDE)        				
	        				EndIf
							//���������������������������������������������������������������������������������������Ŀ
							//� Impede que o item do PC seja deletado pela getdados da NFE na movimentacao das setas. �
							//�����������������������������������������������������������������������������������������
							If ValType( oGetDAtu ) == "O"
								oGetDAtu:lNewLine := .F.
							Else
								If Type( "oGetDados" ) == "O"
									oGetDados:lNewLine:=.F.
								EndIf
							EndIf
							*/

						Else

  						   Aviso("Busca Pedido de Compra","Pedido de Compra n�o encontrado ou Bloqueado",{"Ok"},2)

						EndIf

					EndIf

				Else

					//Help(" ",1,"A103F4")
					Aviso("Busca Pedido de Compra","Pedido de Compra n�o encontrado ou Bloqueado",{"Ok"},2)

				EndIf

			Else

				Aviso("Busca Pedido de Compra","Pedido de Compra n�o encontrado ou Bloqueado",{"Ok"},2)

			EndIf

Endif

If lQuery
	DbSelectArea(cAliasSC7)
	dbCloseArea()
	DbSelectArea("SC7")
Endif	

SetKey(VK_F4,bSavSetKey)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
RestArea(aAreaSA2)
RestArea(aAreaSC7)
RestArea(aAreaSB1)
RestArea(aArea)

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �aPesqP    � Autor � Francisco C Godinho   � Data �06.04.2010 ���
��������������������������������������������������������������������������Ĵ��
���          �Seek no browse de itens de pedidos de compra                 ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1 : Array das descricoes dos cabecalhos                  ���
���          �ExpA2 : Array com os campos                                  ���
���          �ExpA3 : Array com os conteudos                               ���
���          �ExpO4 : Objeto do listbox                                    ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo abrir uma janela de pesquisa   ���
���          �em browses de getdados poisicionando na llinha caso encontre ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

Static Function aPesqP(aCab,aCampos,aArrayF4,oQual)

Local aCpoBusca	:= {}
Local aCpoPict	:= {}
Local aComboBox	:= { AllTrim( "Exata" ) , AllTrim( "Parcial" ) , AllTrim( "Contem" ) }

Local bAscan	:= { || .F. }

Local cPesq		:= Space(30)
Local cBusca	:= ""
Local cTitulo	:= OemtoAnsi("Pesquisar")
Local cOpcAsc	:= aComboBox[1]	//"Exata"
Local cAscan	:= ""

Local nOpca		:= 0
Local nPos		:= 0
Local nx		:= 0
Local nTipo		:= 1
Local nBusca	:= Iif(oQual:nAt == Len(aArrayF4) .Or. oQual:nAt == 1, oQual:nAt, oQual:nAt+1 )

Local oDlg
Local oBusca
Local oPesq1
Local oPesq2
Local oPesq3
Local oPesq4
Local oComboBox

For nX := 1 to Len(aCampos)
	AAdd(aCpoBusca,aCab[nX])
	AAdd(aCpoPict,aCampos[nX][4])
Next	

If Len(aCampos) > 0 .And. Len(aArrayF4) > 0

	DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo)  FROM 00,0 TO 100,490 OF oMainWnd PIXEL

	@ 05,05 MSCOMBOBOX oBusca VAR cBusca ITEMS aCpoBusca SIZE 206, 36 OF oDlg PIXEL ON CHANGE (nTipo := oBusca:nAt,ChgPic(nTipo,aCampos,@cPesq,@oPesq1,@oPesq2,@oPesq3,@oPesq4))
	@ 022,005 MSGET oPesq1 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL
	@ 022,005 MSGET oPesq2 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL
	@ 022,005 MSGET oPesq3 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL
	@ 022,005 MSGET oPesq4 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL

	oPesq1:Hide()
	oPesq2:Hide()
	oPesq3:Hide()	
	oPesq4:Hide()		

	Do Case
	Case aCampos[1][2] == "C"

		DbSelectArea("SX3")
		DbSetOrder(2)
		If MsSeek(aCampos[1][1])
			If !Empty(SX3->X3_F3)
				oPesq2:cF3 := SX3->X3_F3
				oPesq1:Hide()				
				oPesq2:Show()				
				oPesq3:Hide()
				oPesq4:Hide()
			Else	
				oPesq1:Show()			
				oPesq2:Hide()
				oPesq3:Hide()				
				oPesq4:Hide()				
			Endif
		Endif		

	Case aCampos[1][2] == "D"
		oPesq1:Hide()
		oPesq2:Hide()				
		oPesq3:Show()
		oPesq4:Hide()						
	Case aCampos[1][2] == "N"
		oPesq1:Hide()
		oPesq2:Hide()				
		oPesq3:Hide()
		oPesq4:Show()						
	EndCase

	cPesq := CriaVar(aCampos[1][1],.F.)
	cPict := aCampos[1][4]

	DEFINE SBUTTON oBut1 FROM 05, 215 TYPE 1 ACTION ( nOpca := 1, oDlg:End() ) ENABLE of oDlg		 	
	DEFINE SBUTTON oBut1 FROM 20, 215 TYPE 2 ACTION ( nOpca := 0, oDlg:End() )  ENABLE of oDlg		

	@ 037,005 SAY OemtoAnsi("Tipo") SIZE 050,10 OF oDlg PIXEL 
	@ 037,030 MSCOMBOBOX oComboBox VAR cOpcAsc ITEMS aComboBox SIZE 050,10 OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpca == 1

		Do Case

		Case aCampos[nTipo][2] == "C"
			IF ( cOpcAsc == aComboBox[1] )	//Exata
				cAscan := Padr( Upper( cPesq ) , TamSx3(aCampos[nTipo][1])[1] )
				bAscan := { |x| cAscan == Upper( x[ nTipo ] ) }
			ElseIF ( cOpcAsc == aComboBox[2] )	//Parcial
				cAscan := Upper( AllTrim( cPesq ) )
				bAscan := { |x| cAscan == Upper( SubStr( Alltrim( x[nTipo] ) , 1 , Len( cAscan ) ) ) }
			ElseIF ( cOpcAsc == aComboBox[3] )	//Contem
				cAscan := Upper( AllTrim( cPesq ) )
				bAscan := { |x| cAscan $ Upper( Alltrim( x[nTipo] ) ) }
			EndIF

			nPos := Ascan( aArrayF4 , bAscan )
		Case aCampos[nTipo][2] == "N"		
			nPos := Ascan(aArrayF4,{|x| Transform(cPesq,PesqPict("SC7",aCampos[nTipo][1])) == x[nTipo]},nBusca)	
		Case aCampos[nTipo][2] == "D"
			nPos := Ascan(aArrayF4,{|x| Dtos(cPesq) == Dtos(x[nTipo])},nBusca)
		EndCase

		If nPos > 0
			oQual:bLine := { || aArrayF4[oQual:nAT] }
			oQual:nFreeze := 1
			oQual:nAt := nPos                		
			oQual:Refresh()
			oQual:SetFocus()
		Else
			Help(" ",1,"REGNOIS")	
		Endif	

	EndIf

Endif

Return

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �ChgPic    � Autor � Francisco C Godinho   � Data �04.04.2010 ���
��������������������������������������������������������������������������Ĵ��
���          �Atualiza picture na funcao aPesqP                            ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1 : Posicao do campo no Array                            ���
���          �ExpA2 : Array com os dados dos campos                        ���
���          �ExpX3 : Pesquisa                                             ���
���          �ExpO4 : Objeto de pesquisa                                   ���
���          �ExpO5 : Objeto de pesquisa                                   ���
���          �ExpO6 : Objeto de pesquisa                                   ���
���          �ExpO7 : Objeto de pesquisa                                   ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo tratar a picture do campo sele ���
���          �cionado na funcao GdSeek                                     ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function ChgPic(nTipo,aCampos,cPesq,oPesq1,oPesq2,oPesq3,oPesq4)

Local cPict   := ""
Local aArea   := GetArea()
Local aAreaSX3:= SX3->(GetArea())
Local bRefresh


DbSelectArea("SX3")
DbSetOrder(2)
If MsSeek(aCampos[nTipo][1])

	Do case

	Case aCampos[nTipo][2] == "C"
		If !Empty(SX3->X3_F3)
			oPesq2:cF3 := SX3->X3_F3
			oPesq1:Hide()
			oPesq2:Show()			
			oPesq3:Hide()
			oPesq4:Hide()			
			bRefresh := { || oPesq2:oGet:Picture := cPict,oPesq2:Refresh() }
		Else	
			oPesq1:Show()
			oPesq2:Hide()
			oPesq3:Hide()			
			oPesq4:Hide()			                                     			
			bRefresh := { || oPesq1:oGet:Picture := cPict,oPesq1:Refresh() }		
		Endif

	Case aCampos[nTipo][2] == "D"
		oPesq1:Hide()
		oPesq2:Hide()
		oPesq3:Show()			
		oPesq4:Hide()			                                                    		
		bRefresh := { || oPesq3:oGet:Picture := cPict,oPesq3:Refresh() }				
	Case aCampos[nTipo][2] == "N"
		oPesq1:Hide()
		oPesq2:Hide()
		oPesq3:Hide()
		oPesq4:Show()
		bRefresh := { || oPesq4:oGet:Picture := cPict,oPesq4:Refresh() }				
	EndCase

Endif		

If nTipo > 0
	cPesq := CriaVar(aCampos[nTipo][1],.F.)
	cPict := aCampos[nTipo][4]
EndIf							

Eval(bRefresh)

RestArea(aAreaSX3)
RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �aChkPc  �Autor  �                  o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FuncTion aChkPc(alistbox)
Local _lRet := .T.
Local nP := 1
For nP := 1 To Len(alistbox)
//	If EmpTy(alistbox[nP][3]) 
//		Alert("Informar Centro Custos...")
//		_lRet := .F.
//		Exit
//	EndIf	
	If EmpTy(alistbox[nP][4])
		Alert("Selecionar Pedido de Compras...")
		_lRet := .F.
		Exit
	EndIf	
Next
Return(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraZZR  �Autor  �                 o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FuncTion GeraZZR(cFornec,cLoja,cProd,cDesCPrd,_cFilial )    
DbSelectArea("ZZR")
Reclock("ZZR",.T.)

ZZR->ZZR_FILIAL := _cFilial
ZZR->ZZR_CLIFOR := cFornec
ZZR->ZZR_LOJA   := cLoja
ZZR->ZZR_TIPONF := "1" // Pre-Nota
ZZR->ZZR_PRODUT := cProd
ZZR->ZZR_DESCF  := cDesCPrd
ZZR->ZZR_COD    := ""
//ZZR->ZZR_TES    := ""
//ZZR->ZZR_HORA   := Time() 
//ZZR->ZZR_DTA    := dDatabase

MsUnlock()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldF1Xml  �Autor  �                o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User FuncTion VldF1Xml()
Local lRet := .T.

If lRet
	
	If Alltrim(Upper(FunName()) ) == "CPVISNFEE"
		If Type("_cXml") <> "U"
			If !Empty(_cXml)
				DDEMISSAO := __xDtXml
				CNFISCAL := Substr(_cXml,26,9)
				//CSERIE   := Substr(cXml,25,1)
//				CSERIE   := Alltrim(Str(Val(Substr(_cXml,23,3)),3,0))
				CSERIE   := Alltrim(Str(Val(Substr(_cXml,23,3)),3,0))+Space(2)
				CSERIE   := Substr(CSERIE,1,3)
				CSERIE   := If(Val(CSERIE) <> 0, CSERIE,"   ")
				CESPECIE := "SPED"
				
				_cCnpj   := Substr(_cXml,7,14)
				
				DbSelectArea("SA2")
				DbSetOrder(3)
				If DbSeek(xFilial("SA2") + _cCnpj )
					If SA2->A2_MSBLQL <> "1"
						CA100FOR := SA2->A2_COD
						CLOJA    := SA2->A2_LOJA
						CUFORIG  := SA2->A2_EST
						C103TIPO := "N"
					Else
						Alert("Fornecedor: "+SA2->A2_COD+"-"+SA2->A2_LOJA+" Bloqueado...")
						Return(.F.)
					EndIf
				EndIf
				SA2->(DbSetOrder(1))
			EndIf
		EndIf
	EndIf
EndIf
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef2  �Autor  �                o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef2()
PRIVATE aRotina	:= {	{ "Pesquisar"				,"AxPesqui"		, 0 , 1, 0, .F. },; //	
						{ "Visualizar"				,"A140NFiscal"	, 0 , 2, 0, Nil },; //
						{ "Incluir"					,"A140NFiscal"	, 0 , 3, 0, Nil },; //
						{ "Alterar"					,"A140NFiscal"	, 0 , 4, 0, Nil	},; //
						{ "Excluir"					,"A140NFiscal"	, 0 , 5, 0, Nil	},; //
						{ "Imprimir"				,"A140Impri"  	, 0 , 4, 0, Nil	},; //
						{ "Estorna Classificacao"	,"A140EstCla" 	, 0 , 5, 0, Nil	},; //
						{ "Legenda"					,"A103Legenda"	, 0 , 2, 0, .F. } }	//

//������������������������������������������������������������������������Ŀ
//� Ponto de entrada utilizado para inserir novas opcoes no array aRotina  �
//��������������������������������������������������������������������������
If ExistBlock("MTA140MNU")
	ExecBlock("MTA140MNU",.F.,.F.)
EndIf
Return(aRotina)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ChkNFeChave  �Autor  �             o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ChkNFeChave(cXml)

Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cMensagem:= ""
Local oWS
Local _lRet := .T.

//������������������������������������������������������������������������Ŀ
//�Obtem o codigo da entidade                                              �
//���������������������������������������������������������������������������
cIdEnt := GetIdEnt()

cChaveNFe := Alltrim(cXml)

oWs:= WsNFeSBra():New()
oWs:cUserToken   := "TOTVS"
oWs:cID_ENT      := cIdEnt
ows:cCHVNFE		 := cChaveNFe
oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

If oWs:ConsultaChaveNFE()
	
	cMensagem := ""
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
		cMensagem += STR0129+": "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
	EndIf                
	cMensagem += STR0035+": "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,STR0056,STR0057)+CRLF //"Produ��o"###"Homologa��o"
	cMensagem += STR0068+": "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
	cMensagem += STR0069+": "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
	cRetorno := oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
		cMensagem += STR0050+": "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF	
	EndIf
	Aviso(STR0107,cMensagem,{STR0114},3)
	If Alltrim(cRetorno) <> '100'
///		If Alltrim(cRetorno) == '226'
//			Aviso("Consulta NF","Status Sefaz -> "+cRetorno+" Nota fiscal esta inutilizada na base da dados do Sefaz.",{"Aten��o"},3)
//		Else
//			Aviso("Consulta NF","Status Sefaz -> "+cRetorno,{"Aten��o"},3)
//		EndIf
		_lRet := .F.
	EndIf

Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
	_lRet := .F.
EndIf
	
Return(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetIdEnt  �Autor  �                o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://10.0.0.105:80"),250)
Local oWs
//������������������������������������������������������������������������Ŀ
//�Obtem o codigo da entidade                                              �
//��������������������������������������������������������������������������
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Aten��o"},3)
EndIf

RestArea(aArea)
Return(cIdEnt)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldXml  �Autor  �                  o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User FuncTion VldXml()
Local lRet := .T.
Local nOpca:= 0
Private lChkSefaz := SuperGetMv("MV_CHVNFE",.T.,.F.)
Private oDlgXml

cXml := Space(44)

nOpca := 0


DEFINE DIALOG oDlgXml Of GetWndDefault() FROM  12, 20 TO 15,75 TITLE "Passe o Leitor Codigo de Barras da DANFE"

@ .1,.5 MSGET cXml  VALID  !EmpTy(cXml)
DEFINE SBUTTON FROM 45,265 TYPE 2 ENABLE OF oDlgXml;
ACTION  oDlgXml:End()

ACTIVATE MSDIALOG oDlgXml CENTERED


DbSelectArea("SZ1")
DbSetOrder(1)
IF DbSeek(xFilial("SZ1") + cXml )
	
	IF lChkSefaz
		lRet := ChkNFeChave(cXml)
		If lRet
			_cStatus := "1" // Pre-validado
		Else
			_cStatus := "2" // Problema Sefaz
		EndIf
		RecLock("SZ1",.F.)
		SZ1->Z1_STATUS := _cStatus
		MsUnlock()
	EndIf
Else
	Conout("Xml N�o ENCONTRADO!","Alerta")
	lRet := .F.
EndIf

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CPIMPXML�                          o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     � 															  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User FuncTion CPIMPXML()   

MsAguarde({|| x_ImpXml()},"Importando XML ...")

Alert("Importacao finalizada...")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �x_ImpXml  �Autor  �                o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/            
Static FuncTion x_ImpXml()

Local nX
Private a_Xml 	:= {}  
_cFilial 		:= cFilAnt
cPathXml 		:= SuperGetMv("GO_PCTXML",,"\xml_ctrc\")

//conout("Path <GO_PCTXML> : "+cPathXml)

cDirXml :=cPathXml
aXML := Directory(cDirXml+"*.XML")
For nX := 1 to Len(aXML)
		
	cXMLFile := cDirXml+aXML[nX][1]
	xGrvSZ1(cXMLFile,_cFilial,cDirXml)
	
Next

If Len(a_Xml) > 0

	AIMSGENV(a_Xml)
	  
EndIf

Return()
                     
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AIMSGENV  �Autor  �                o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
//////////////////////////////////////////////////////////////////////////////////////
//Rotina que envia email para usuarios pre-determinados, sobre os desenhos enviados //
//////////////////////////////////////////////////////////////////////////////////////
Static Function AIMSGENV(a_Xml)  
Local cSubject		:= ""
Local cxDes			:= ""
Local cxNomDes		:= ""
Local cEmailXml		:= AllTrim(SuperGetMv("GO_MAILXML",,"chenrique@lampadasgolden.com.br")) // 
Local cMail			:= ""
Local cSMTP			:= ""
Local cOBS			:= 'e-Mail Enviado automaticamente atrav�s do Schedule de importacao XML - Protheus'
Local xArea			:= GetArea() //Area atual utilizada
Local nRegistro		:= "" 
Local nP
nRegistro:=Recno()

_cFrom   :=GetMv("MV_RELFROM")

// Autentica Servidor
_cServer :=GetMv("MV_RELSERV")
_cUser   :=GetMv("MV_RELACNT")
_cPass   :=GetMv("MV_RELAPSW")

mMensagem := "<BODY>"
mMensagem := mMensagem + "<DIV><FONT face=Arial size=2>Os seguintes xml nao foram importados pelo sistema e foram removidos para pasta: "+cDirErro+"<BR></FONT></DIV>"
mMensagem+= "<BR>"  //</STRONG>

For nP:= 1 To Len(a_Xml)

    _cXml 	 := a_Xml[nP]

    If !Empty(_cXml)    
	
		mMensagem:= mMensagem+"<BR><STRONG><DIV><FONT face=Arial size=2>"
		mMensagem+= "&nbsp;&nbsp;&nbsp;"
		mMensagem+= "Chave :&nbsp;"+ALLTRIM(_cXml)
		mMensagem+= "<BR>"  //</STRONG>
	
	EndIf
	
Next  

//mMensagem := mMensagem + "</STRONG><BR>Enviado Para..    : <STRONG>"+UPPER(cPara)+"<BR></STRONG>&nbsp; "
mMensagem := mMensagem + "<BR><STRONG>OBS: </STRONG>"+cOBS+"<BR>&nbsp; </DIV>" 
mMensagem := mMensagem + "<DIV>&nbsp;</DIV></BODY>"

cSubject := "Aviso Xml removidos para a pasta:  " + cDirErro + "."

CONNECT SMTP SERVER _cServer ACCOUNT _cUser PASSWORD _cPass RESULT _lResult

// CONNECT SMTP SERVER cSMTP ACCOUNT cEmailPms PASSWORD "0721"

SEND MAIL FROM _cFrom to cEmailXml SUBJECT cSubject  BODY mMensagem

DISCONNECT SMTP SERVER
RestArea(xArea)
Return

/*Static Function AjustaSx1(cPerg)
PutSX1(cPerg,"01"   ,"CNPJ ?"		,"CNPJ ?"	 	,"CNPJ ?"	    ,"mv_ch1"	,"c"	,14		,0		,0		,"G","","  ","","","mv_par01","","","","","","","","","","","","","","","","",{"Informe o CNPJ DA TRANSP","",""},{},{})
PutSX1(cPerg,"02"   ,"Status ?"		,"Status ?"	 	,"Status ?"		,"mv_ch2"	,"c"    ,1		,0		,0		,"G","","  ","","","mv_par02","","","","","","","","","","","","","","","","",{"2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;7=Problema na Gera��o pr�-nota","",""},{},{})

Return*/

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Prog.  � GeraCTe � Uso � Surya Brasil � Modulo � Compras � Data � 08/02/17 ���
�����������������������������������������������������������������������������͹��
���Desc.  � Fun��o para criar aCabec e aItens para gerar Documento de         ���
���       � Entrada CTE                                                       ���
�����������������������������������������������������������������������������͹��
��� Autor � Caio de Paula             � Contato �(11) 98346-3154              ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function GeraCTE(cXML)

Local errStr  		:= ""
Local warnStr 		:= ""
Local l_Saida 		:= .F.
Local l_Entrada		:= .F.
Local nQtd			:=1
Local n_Reg			:= SZ1->(RECNO())
Local c_CGC			:= SZ1->Z1_CGC
Local _nBaseIcms	:= 0

_cFilial			:= SZ1->Z1_FILIAL
_cDoc				:= SZ1->Z1_DOC
_cSerie				:= SZ1->Z1_SERIE
CCHAVENFE			:= SZ1->Z1_CHAVE
oXml 				:= XmlParser ( cXML, "_", @errStr, @warnStr )
cTag1 				:= "<cteProc"
cTag2 				:= "<CTe"
cTag3 				:= "<infCte"
cTag4 				:= "<infNF"
cTipoNf				:= "N"
nPosTag1 			:= At(cTag1,cXML)
nPosTag2 			:= At(cTag2,cXML)
nPosTag3 			:= At(cTag3,cXML)
nPosTag4 			:= At(cTag4,cXML)
_c_Prod 			:= ""
xx 					:= "1"

// Checa Integridade do xml ctrc e a existencia das tags a serem lidas
If (nPosTag1 == 0 .And. nPosTag3 == 0 ) .And. nPosTag2 == 0  .And. nPosTag4 == 0 // .And. nPosTag5 > 0

	Conout("Nao foi possivel gerar Nota do CTE: "+cChaveNfe +" <CTE>.")
	RecLock("SZ1",.F.)
		SZ1->Z1_STATUS := "7" // estrutura
	MsUnlock()
	Return
	
EndIf

lCteproc := .F.

If nPosTag1 > 0

	lCteproc := .T.

EndIf

If lCteproc

	x_NomeXml := oXml:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT

Else

	x_NomeXml := oXml:_CTE:_INFCTE:_EMIT:_XNOME:TEXT

EndIf

If lCteproc

	oDest   :=oXML:_CTEPROC:_CTE:_INFCTE:_DEST
	oRem	:=oXML:_CTEPROC:_CTE:_INFCTE:_REM    
		
	If Type("oRem:_CPF") <> "U"
		c_RemCNPJ  := oRem:_CPF:TEXT
	Else
		c_RemCNPJ  := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT
	EndIf
	If Type("oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4") <> "U"
		If Type("oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ")  <> "U"   
			c_DestCNPJ := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT
		Else
			c_DestCNPJ := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_CPF:TEXT
		EndIf	
	Else	
		If Type("oDest:_CPF") <> "U"
			c_DestCNPJ := oDest:_CPF:TEXT
		Else
			c_DestCNPJ := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
		EndIf
	EndIf
	nVlrFrete := val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT)
	dEmissao  := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	_xDtEmiss := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	If Type("oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00") <> "U"
		_nValIcm := Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)
		_nAliqIcm := Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
		_nBaseIcms:= Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)
    EndIf
Else
	oDest   :=oXML:_CTE:_INFCTE:_DEST
	oRem	:=oXML:_CTE:_INFCTE:_REM     
	If Type("oRem:_CPF") <> "U"
		c_RemCNPJ  := oRem:_CPF:TEXT
	Else
		c_RemCNPJ  := oXML:_CTE:_INFCTE:_REM:_CNPJ:TEXT
	EndIf
	If Type("oXml:_CTE:_INFCTE:_IDE:_TOMA4") <> "U"
		If Type("oXml:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ")  <> "U"   
			c_DestCNPJ := oXml:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT
		Else
			c_DestCNPJ := oXml:_CTE:_INFCTE:_IDE:_TOMA4:_CPF:TEXT
		EndIf	  
	Else	
		If Type("oDest:_CPF") <> "U"
			c_DestCNPJ := oDest:_CPF:TEXT
		Else
			c_DestCNPJ := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT

		EndIf
    EndIf
	nVlrFrete  := val(oXml:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT)
	_xDtEmiss  := oXml:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	dEmissao   := oXml:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	If Type("oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00") <> "U"
		_nValIcm   := Val(oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)
		_nAliqIcm  := Val(oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
		_nBaseIcms := Val(oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)
	EndIf
EndIf
DbSelectArea("SA2")
DbSetOrder(3)
If DbSeek(xFilial("SA2") + c_CGC )
	cFornec := SA2->A2_COD
	cLoja   := SA2->A2_LOJA
	c_UFEmit:= SA2->A2_EST
	cNomeFor:= SA2->A2_NOME
	_cCPgto:= SA2->A2_COND
	l_UFTra := If(c_UFEmit == SM0->M0_ESTCOB,.T.,.F.) // UF da Transportadora
else
	Conout("Fornecedor n�o encontrado. Favor cadastrar como Fornecedor: " + c_CGC )
endif
nVlUnit   := nVlrFrete
nValMerc  := nVlrFrete  
nDespesa  := 0
If _nBaseIcms > 0 
	If  _nBaseIcms >= nVlrFrete //ANTES: _nBaseIcms >= nVlrFrete
		nDespesa  := (_nBaseIcms - nVlrFrete)
	EndIf	
EndIf
__xDtXml := Ctod(Substr(_xDtEmiss,9,2)+"/"+Substr(_xDtEmiss,6,2) +"/"+Left(_xDtEmiss,4))
dbSelectArea("SM0")
nRegSM0 := SM0->(Recno())
dbSetOrder(1)
SM0->(DbGoTop())
If c_RemCNPJ == SM0->M0_CGC // Se remetente do Frete for  frete s/ Venda
	l_Saida := .T.
	_cEmp := SM0->M0_CODIGO
	_cFil := SM0->M0_CODFIL
	
	//aAdd(aSM0,{SM0->M0_CODIGO, SM0->M0_CODFIL,SM0->M0_CGC})
elseIf c_DestCNPJ == SM0->M0_CGC // Se Destino do Frete for  frete s/ Compra
	l_Entrada := .T.
	_cEmp := SM0->M0_CODIGO
	_cFil := SM0->M0_CODFIL
	
	// aAdd(aSM0,{SM0->M0_CODIGO, SM0->M0_CODFIL,SM0->M0_CGC})
EndIf
If !l_Entrada .And. ! l_Saida
	Conout("Remetente ou Destinario n�o pertence a empresa")
	RecLock("SZ1",.F.)
		SZ1->Z1_STATUS := "7" // estrutura
	MsUnlock()
	Return
endif
	// Pega documento de Origem
aDocOrigem :=  NFORIG(oXml,cXML,lCteproc)
__cCFOP		:= CteCFOP(oXml,cXML,lCteproc)
l_DocOrig := .F.               
c_LogDocO := "Documento Original ja lancado na NF: "
For nD:= 1 To Len(aDocOrigem)
	c_DocRef := aDocOrigem[nD][1]
	c_SerRef := aDocOrigem[nD][2]

	// Verifica se o numero na base com 6 ou 9 digitos
	c_Doc6p :=  Substr(StrZero(Val(c_DocRef),6)+ Space(9),1,9)
	c_Doc9p :=  Substr(StrZero(Val(c_DocRef),9)+ Space(9),1,9)
	If !Empty(c_SerRef) //.And. Alltrim(c_SerRef) 
		c_SerRef := StrZero(Val(c_SerRef),3)
	EndIf	
	DbSelectArea("SF2") // 
	DbSetOrder(1)       // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	If DbSeek(_cFilial + c_Doc6p + c_SerRef)
		c_DocRef := c_Doc6p
		d_DtEmiR := SF2->F2_EMISSAO
	ElseIf  DbSeek(_cFilial + c_Doc9p + c_SerRef )
		c_DocRef := c_Doc9p
		d_DtEmiR := SF2->F2_EMISSAO
	EndIf	


	cQuery := "Select * from " + RetSqlName("SD1")
	cQuery += " where D1_DOC = '"+_cDoc+"' AND D1_NFORI ='" + c_DocRef + "' and D1_SERIORI = '" + c_SerRef + "' AND D_E_L_E_T_ = ''"  

	cQuery := changequery(cQuery)

	If Select("QRY") <> 0
		dbSelectArea("QRY")
		dbCloseArea()
	EndIf         

	TCQUERY cQuery NEW ALIAS "QRY" 

	dbSelectArea("QRY")
	dbGoTop()
	do While !EOF()
		l_DocOrig := .T.
		Conout("Documento Original "+ c_DocRef + "-"+c_SerRef +" ja lancado na NF: " + QRY->D1_DOC +"/"+QRY->D1_SERIE )
		c_LogDocO +=  QRY->D1_DOC +"/"+QRY->D1_SERIE + " "
		QRY->(DbSkip())
    EndDo
Next
xx := "1"
If l_DocOrig
	DbSelectArea("SZ1")
	RecLock("SZ1",.F.)
	SZ1->Z1_STATUS := "7"
	MsUnlock()
EndIf
If l_Saida
	CONOUT("Origem Vendas...")
	xx := "1"
	_aItens   := {}
	nVlrNF    := nValMerc / Len(aDocOrigem)
	//_nBaseIcms := _nBaseIcms   / Len(aDocOrigem)
	//_nValIcm   := _nValIcm     / Len(aDocOrigem)
	nVlUnit   := nVlrNF
	nValMerc  := nVlrNF
	For nD:= 1 To Len(aDocOrigem)
		cDocRef := aDocOrigem[nD][1]
		cSerRef := aDocOrigem[nD][2]
		cProdFret := SuperGetMv("SB_PFRETES",.F.,"XPTO")		
		_cNat     := ""
		_cItemCtb := ""
        _cTes := ""        
		Aadd(_aItens,{"N",cFornec,cLoja,cProdFret,_cNat,_cTes,"","",nQtd,nVlUnit,nValMerc,cDocRef,cSerRef,"","",_cDoc,_cSerie})			
	Next
    xx:= "1"
	lGeraReg :=  ProcDocE("N",_cFil, cFornec, cLoja,_cDoc,_cSerie,cChaveNfe,_aItens,__xDtXml,"CTE",__cCFOP)
ElseIf l_Entrada    
    CONOUT("Origem Compras..." )                 
	_aItens   := {}
	nVlrNF    := nValMerc / Len(aDocOrigem)
	//_nBaseIcms := _nBaseIcms   / Len(aDocOrigem)
	//_nValIcm   := _nValIcm     / Len(aDocOrigem)
	nVlUnit   := nVlrNF
	nValMerc  := nVlrNF
	For nD:= 1 To Len(aDocOrigem)
		cDocRef := aDocOrigem[nD][1]
		cSerRef := aDocOrigem[nD][2]
		cProdFret := SuperGetMv("SB_PFRETEE",.F.,"XPTO")		
		_cNat     := ""
		_cItemCtb := ""
        _cTes := ""
		Aadd(_aItens,{"N",cFornec,cLoja,cProdFret,_cNat,_cTes,"","",nQtd,nVlUnit,nValMerc,cDocRef,cSerRef,"","",_cDoc,_cSerie})			
	Next
    xx:= "1"
	lGeraReg :=  ProcDocE("N",_cFil, cFornec, cLoja,_cDoc,_cSerie,cChaveNfe,_aItens,__xDtXml,"CTE",__cCFOP)
EndIf    
oXml := Nil
DelClassIntf()
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValProd  �Autor  �                 o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function ValProd(cProd)
local lRet := .F.
if Existchav("SB1",xFilial("SB1")+cProd,1)
	lRet := .T.
endif      
//Private _DESCdigit	:=Alltrim(GetAdvFVal("SB1","B1_DESC",XFilial("SB1")+cEdit1,1,""))
//Private _NCMdigit	:=GetAdvFVal("SB1","B1_POSIPI",XFilial("SB1")+cEdit1,1,"")
Return 	lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraSA5  �Autor  �                 o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function GeraSA5(cFornec,  cLoja,  cProd,  cDesCPrd ,_cFilial)

Local lRet := .T.
Local oEdit1
Local cEdit1 := space(TamSX3('B1_COD')[1])

DEFINE MSDIALOG _oDlg TITLE "INCLUIR DE/PARA CODIGO FORNECEDOR" FROM C(177),C(192) TO C(340),C(659) PIXEL STYLE DS_MODALFRAME
	_oDlg:lEscClose := .F.
	// Cria as Groups do Sistema
	@ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg
	
	// Cria Componentes Padroes do Sistema
	@ C(012),C(027) Say "Produto: "+cProd Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(020),C(027) Say "Descricao: "+cDesCPrd Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd(cEdit1)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(040),C(027) Say "Produto digitado: "+cEdit1 Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(048),C(027) Say "Descricao: "+Alltrim(GetAdvFVal("SB1","B1_DESC",XFilial("SB1")+cEdit1,1,""))Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Chkproc:=.T.,_oDlg:End())
	oEdit1:SetFocus()
	
ACTIVATE MSDIALOG _oDlg CENTERED

If Chkproc

	If SA5->(dbSetOrder(1), dbSeek(xFilial("SA5")+cFornec+cLoja+cEdit1))

		RecLock("SA5",.F.)

	Else

		Reclock("SA5",.T.)

	Endif

		SA5->A5_FILIAL 	:= xFilial("SA5")
		SA5->A5_FORNECE := cFornec
		SA5->A5_LOJA 	:= cLoja
		SA5->A5_NOMEFOR := Posicione("SA2",1,xFilial("SA2")+cFornec+cLoja,"A2_NOME")
		SA5->A5_PRODUTO := cEdit1 
		SA5->A5_NOMPROD := Posicione("SB1",1,xFilial("SB1")+cEdit1,"B1_DESC")
		SA5->A5_DESCPRF := cDesCPrd
		SA5->A5_CODPRF  := cProd
	SA5->(MsUnlock())
	
	_c_Prod := cEdit1

Else

	Conout("ERRO!!!"+CRLF+"Contatar Administrador")
	lRet := .F.

EndIf

Return lRet

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Prog.  � GeraNFe � Uso � Surya Brasil � Modulo � Compras � Data � 08/02/17 ���
�����������������������������������������������������������������������������͹��
���Desc.  � Fun��o para criar aCabec e aItens para gerar Documento de         ���
���       � Entrada SPED                                                      ���
�����������������������������������������������������������������������������͹��
��� Autor � Caio de Paula             � Contato �(11) 98346-3154              ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function GeraNFe(cXml, lAuto)
Local oXML		
Local cError 		:= ""
Local cWarning 		:= ""
Local errStr 		:= ""
Local warnStr 		:= ""
Local cFornLib		:= SuperGetMv("SB_FLIBXML",.T.,"")
Local lLotEmp		:= SuperGetMv("SB_FLOTXML",.T.,".F.")
//Alex
Local aDocDev		:= {}

//Private VarItem		:= {}
cXMLFile	:= cXml
_cCnpj   	:= SZ1->Z1_CGC                                        
_cFilial  	:= SZ1->Z1_FILIAL
_cDoc      	:= SZ1->Z1_DOC
_cSerie    	:= SZ1->Z1_SERIE
cFilAnt   	:= SZ1->Z1_FILIAL
cNomeFor   	:= ""
cChaveNfe  	:= SZ1->Z1_CHAVE
_F1_CHVNFE 	:= SZ1->Z1_CHAVE
dDEmissao  	:= SZ1->Z1_EMISSAO
cTipo		:= SZ1->Z1_TIPO
cTipoNf		:= SZ1->Z1_TIPO
cEspecie	:= ALLTRIM(SZ1->Z1_ESPECIE)
c_Fornece	:= Posicione("SA2",3,xFilial("SA2")+_cCnpj,"A2_COD")
c_Loja		:= Posicione("SA2",3,xFilial("SA2")+_cCnpj,"A2_LOJA")
a_Email    	:= {}
cTag1 		:= "|Lote|"
cTag2		:= "|DtValid|"
nPosTag1 	:= At(cTag1,cXML)
lLote 		:= .F.
_c_Prod 	:= ""
_c_Lote 	:= ""
nTotMerc 	:= 0

//Alex
IF EMPTY(lAuto)
	lAuto := .F.
ENDIF

If nPosTag1 > 0

	lLote := .T. 

EndIf

DbSelectArea("SF1")
DbSetOrder(1)

if Dbseek(_cFilial+_cDoc+_cSerie+c_Fornece+c_Loja)	
	If EMPTY(SF1->F1_STATUS)
		DbSelectArea("SZ1")
		RecLock("SZ1",.F.)
			SZ1->Z1_STATUS := "6"
		MsUnlock()
	ELSE
		DbSelectArea("SZ1")
		RecLock("SZ1",.F.)
			SZ1->Z1_STATUS := "3"
		MsUnlock()
	ENDIF
endif
Private _cXml  := SZ1->Z1_CHAVE
If SZ1->Z1_STATUS == "6" .Or. SZ1->Z1_STATUS == "3" 
	Conout("Pre-Nota ou Documento ja gerado. DANFE: " + cChaveNfe)
	Return
EndIf

if cTipo == 'N'
	DbSelectArea("SA2")
	DbSetOrder(3)
	If DbSeek(xFilial("SA2") + _cCnpj )
		cFornec := Posicione("SA2",3,xFilial("SA2") + _cCnpj , "A2_COD")
		cLoja   := Posicione("SA2",3,xFilial("SA2") + _cCnpj , "A2_LOJA")
		cNomeFor:= Alltrim(SA2->A2_NOME)
	else
		DbSelectArea("SZ1")
		RecLock("SZ1",.F.)
			SZ1->Z1_STATUS := "5"
		MsUnlock()
		Conout("Documento n�o gerado! Fornecedor n�o encontrado")
		Return
	endif
Elseif cTipo == 'D'
	DbSelectArea("SA1")
	DbSetOrder(3)
	If DbSeek(xFilial("SA1") + _cCnpj )
		cFornec := Posicione("SA1",3,xFilial("SA1") + _cCnpj , "A1_COD")
		cLoja   := Posicione("SA1",3,xFilial("SA1") + _cCnpj , "A1_LOJA")
		cNomeFor:= Alltrim(SA1->A1_NOME)		
	Else		
		DbSelectArea("SZ1")
		RecLock("SZ1",.F.)
			SZ1->Z1_STATUS := "5"
		MsUnlock()
		Conout("Documento n�o gerado! Cliente n�o encontrado")
		Return
	EndIf
	
	//Return
EndIf



cXML := StrTran(cXML,CHR(13),'')
cXML := StrTran(cXML,CHR(10),'')

If '>' # Substr(cXML,Len(cXML),1)
	cXML := cXML +">"
EndIf

oXml := XmlParser ( cXML, "_", @errStr, @warnStr )

If oXml == Nil .Or. (Len(errStr) > 0) .Or. (Len(WarnStr) > 0)	
	DbSelectArea("SZ1")
	RecLock("SZ1",.F.)
		SZ1->Z1_STATUS := "7" // Estrutura Xml
	MsUnlock()
	Conout("Erro estrutura xml: "+ cChaveNfe)
	Return
EndIf
// Checa se o xml nao se referente a SPED
IF ALLTRIM(SZ1->Z1_ESPECIE) <> "SPED"
	Conout("Nao foi possivel gerar Nota da DANFE: "+cChaveNfe +" <SPED>.")
	Return
EndIf                                            
cChaveNfe :=  Alltrim(Substr(oXml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4,45))
if SZ1->Z1_STATUS <> "1"
 /*	If  ! ChkNFeChave(cChaveNfe) 
		DbSelectArea("SZ1")
		RecLock("SZ1",.F.)
			SZ1->Z1_STATUS := "8" // Estrutura Xml
		MsUnlock()
		Conout("Chave invalida no Sefaz")
		Return
	EndIf  */
endif   
_aItens := {}
__xDtXml := dDEmissao 
VarItem := oXml:_NFEPROC:_NFE:_INFNFE:_DET
__cCFOP		:= NFeCFOP(oXml,cXML)
_lPrenota := .F.
lDep := .T.
if cFornec $ cFornLib
	lDep := .F.
endif
cChkFor := cFornec + cLoja
/*if Valtype(VarItem) == "O"
	XmlNode2Arr( VarItem, "_DET" )
endif*/
If ValType(VarItem) =='A'
	nTotMerc := 0
	For nI := 1 To Len(VarItem)
		cProd   	:= VarItem[nI]:_PROD:_CPROD:TEXT
		cProd   	:= Substr(cProd + Space(25),1,25)
		cDesCPrd	:= VarItem[nI]:_PROD:_XPROD:TEXT
		nQtd    	:= VarItem[nI]:_PROD:_QCOM:TEXT
		nQtd    	:= Val(nQtd)
		nQtd    	:= If(nQtd ==0,1,nQtd)
		nVlUnit 	:= VarItem[nI]:_PROD:_VUNCOM:TEXT
		nValMerc	:= VarItem[nI]:_PROD:_VPROD:TEXT
		nValMerc	:= Val(nValMerc)
		nVlUnit 	:= nValMerc / nQtd   //
		nTotMerc	+= nValMerc
		cLote		:= ""
		dDtaValid	:= CTOD("//")
		if lLote .And. lLotEmp
			cLote		:= VarItem[nI]:_PROD:_XPROD:TEXT
			cLote		:= alltrim(substr(cLote,at(cTag1,cLote)+7,at(cTag2,cLote)-(at(cTag1,cLote)+7)))
			_c_Lote		:= VarItem[nI]:_PROD:_XPROD:TEXT
			dDtaValid	:= ctod(alltrim(substr(_c_Lote,at(cTag2,_c_Lote)+;
							10,len(_c_Lote)- (at(cTag2,_c_Lote)+9))))		
		endif
		// Verifica se existe depara
		if cTipo == 'N'
			DbSelectArea("SA5")
			DbSetOrder(14) // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
			If ! DbSeek(xFilial("SA5") + cFornec + cLoja + alltrim(cProd) )
				IF !lAuto
					If GeraSA5(cFornec,  cLoja,  cProd,  cDesCPrd ,_cFilial,@_c_Prod)
						DbSetOrder(1) // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
						If ! DbSeek(xFilial("SA5") + cFornec + cLoja + _c_Prod )
							DbSelectArea("SZ1")
							RecLock("SZ1",.F.)
								SZ1->Z1_STATUS := "4" // Depara
							MsUnlock()
							lDep := .F.
							Return
						else
							If ! EmpTy(A5_PRODUTO)				
								_cProd  := SA5->A5_PRODUTO
								_cTes   := ""
								_cCfo   := ""
								Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",cLote,dDtaValid,_cDoc,_cSerie})
								_lPrenota := .T.
							EndIf	
						endif
					else		
						DbSelectArea("SZ1")
						RecLock("SZ1",.F.)
							SZ1->Z1_STATUS := "4" // Depara
						MsUnlock()
						lDep := .F.
						Return
					endif
				ENDIF
			Else
				If ! EmpTy(ALLTRIM(A5_PRODUTO))
					_cProd  := SA5->A5_PRODUTO
					_cTes   := ""
					_cCfo   := ""
					Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",cLote,dDtaValid,_cDoc,_cSerie})
					_lPrenota := .T.
				EndIf
			EndIf
		elseif cTipo == 'D'
			DbSelectArea("SA7")
			DbSetOrder(3) // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
			If ! DbSeek(xFilial("SA7") + cFornec + cLoja + cProd )
				If !lAuto 
					IF GeraSA7(cFornec,  cLoja,  cProd,  cDesCPrd ,_cFilial)
						DbSetOrder(3) // A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
						If ! DbSeek(xFilial("SA7") + cFornec + cLoja + cProd )
							DbSelectArea("SZ1")
							RecLock("SZ1",.F.)
								SZ1->Z1_STATUS := "4" // Depara
							MsUnlock()
							lDep := .F.
							Return
						else
							If ! EmpTy(A7_PRODUTO)				
								_cProd  := SA7->A7_PRODUTO
								_cTes   := ""
								_cCfo   := ""
								//Alex
								//Roda procura Nf original Dev
								aDocDev := NFORIGDEV(oXml,cXML,_cProd,nQtd)
								IF aDocDev[1] != "xxx"
									Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,aDocDev[1],aDocDev[2],cLote,dDtaValid,_cDoc,_cSerie})
								ELSE
									Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",cLote,dDtaValid,_cDoc,_cSerie})
								ENDIF
								_lPrenota := .T.
							EndIf	
						endif
					else			
						DbSelectArea("SZ1")
						RecLock("SZ1",.F.)
							SZ1->Z1_STATUS := "4" // Depara
						MsUnlock()
						lDep := .F.
						Return
					endif
				ENDIF
			Else
				If ! EmpTy(A7_PRODUTO)				
					_cProd  := SA7->A7_PRODUTO
					_cTes   := ""
					_cCfo   := ""
					//Alex
					//Roda procura Nf original Dev
					aDocDev := NFORIGDEV(oXml,cXML,_cProd,nQtd)
					IF aDocDev[1] != "xxx"
						Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,aDocDev[1],aDocDev[2],cLote,dDtaValid,_cDoc,_cSerie})
					ELSE
						Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",cLote,dDtaValid,_cDoc,_cSerie})
					ENDIF
					_lPrenota := .T.
				EndIf
			EndIf
		endif
	Next
Else
	cProd   := oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT
	cDesCPrd:= oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT
	nQtd    := oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT
	nQtd    := Val(nQtd)
	nQtd    := If(nQtd == 0 ,1,nQtd)
	
	nValMerc:= oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT
	nValMerc:= Val(nValMerc)
	nTotMerc+= nValMerc
	nVlUnit := nValMerc / nQtd   //oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT
	cLote	:= ""
	dDtaValid:= CTOD("//")
	if lLote   .and. lLotEmp
		cLote		:= VarItem:_PROD:_XPROD:TEXT
		cLote		:= alltrim(substr(cLote,at(cTag1,cLote)+7,at(cTag2,cLote)-(at(cTag1,cLote)+7)))
		_c_Lote		:= VarItem:_PROD:_XPROD:TEXT
		dDtaValid	:= ctod(alltrim(substr(_c_Lote,at(cTag2,_c_Lote)+;
							10,len(_c_Lote)- (at(cTag2,_c_Lote)+9))))		
	endif
	// Verifica se existe depara
	if cTipo == 'N'
		DbSelectArea("SA5")
		DbSetOrder(14) // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
		If ! DbSeek(xFilial("SA5") + cFornec + cLoja + cProd )
			IF !lAuto
				If GeraSA5(cFornec,  cLoja,  cProd,  cDesCPrd ,_cFilial,@_c_Prod)
					DbSetOrder(14) // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
					If ! DbSeek(xFilial("SA5") + cFornec + cLoja + _c_Prod )
						RecLock("SZ1",.F.)
							SZ1->Z1_STATUS := "4" // Depara
						MsUnlock()
						lDep := .F.
						Return
					else
						If ! EmpTy(A5_PRODUTO)				
							_cProd  := SA5->A5_PRODUTO
							_cTes   := ""
							_cCfo   := ""
							Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",cLote,dDtaValid,_cDoc,_cSerie})
							_lPrenota := .T.
						EndIf	
					endif
				else			
					DbSelectArea("SZ1")
					RecLock("SZ1",.F.)
						SZ1->Z1_STATUS := "4" // Depara
					MsUnlock()
					lDep := .F.
					Return
				endif
			ENDIF
		Else
			If ! EmpTy(A5_PRODUTO)				
				_cProd  := SA5->A5_PRODUTO
				_cTes   := ""
				_cCfo   := ""
				Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",cLote,dDtaValid,_cDoc,_cSerie})
				_lPrenota := .T.
			EndIf
		EndIf
	elseif cTipo == 'D'
		DbSelectArea("SA7")
		DbSetOrder(3) // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
		If ! DbSeek(xFilial("SA7") + cFornec + cLoja + cProd )
			If !lAuto
				IF GeraSA7(cFornec,  cLoja,  cProd,  cDesCPrd ,_cFilial)
					DbSetOrder(3) // A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
					If ! DbSeek(xFilial("SA7") + cFornec + cLoja + cProd )
						RecLock("SZ1",.F.)
							SZ1->Z1_STATUS := "4" // Depara
						MsUnlock()
						lDep := .F.
						Return
					else
						If ! EmpTy(A7_PRODUTO)				
							_cProd  := SA7->A7_PRODUTO
							_cTes   := ""
							_cCfo   := ""
							//Alex
							//Roda procura Nf original Dev
							aDocDev := NFORIGDEV(oXml,cXML,_cProd,nQtd)
							IF aDocDev[1] != "xxx"
								Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,aDocDev[1],aDocDev[2],cLote,dDtaValid,_cDoc,_cSerie})
							ELSE
								Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",cLote,dDtaValid,_cDoc,_cSerie})
							ENDIF
							_lPrenota := .T.
						EndIf	
					endif
				else			
					DbSelectArea("SZ1")
					RecLock("SZ1",.F.)
						SZ1->Z1_STATUS := "4" // Depara
					MsUnlock()
					lDep := .F.
					Return
				endif
			ENDIF
		Else
			If ! EmpTy(A7_PRODUTO)				
				_cProd  := SA7->A7_PRODUTO
				_cTes   := ""
				_cCfo   := ""
				aDocDev := NFORIGDEV(oXml,cXML,_cProd,nQtd)
				IF aDocDev[1] != "xxx"
					Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,aDocDev[1],aDocDev[2],cLote,dDtaValid,_cDoc,_cSerie})
				ELSE
					Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",cLote,dDtaValid,_cDoc,_cSerie})
				ENDIF
				_lPrenota := .T.
			EndIf
		EndIf
	endif
EndIf

If lDep .AND. cTipo != 'D'
	If _lPreNota
		nTamCC  := TamSx3("D1_CC")[1]
		nTamPed := TamSx3("D1_PEDIDO")[1]
		nTamIpc := TamSx3("D1_ITEMPC")[1]
		_bValid := {|| ExistCpo("CTT")}
		If Len(_aItens) > 0
			nOpcp := 0
			aListBox := {}			
			For nX := 1 To Len(_aItens)
				cPrd := _aItens[nX][4]
				nQtd := _aItens[nX][9]
				cDescPrd := Posicione("SB1",1,xFilial("SB1") + cPrd ,"B1_DESC")
				aadd(aListBox,{cPrd,Substr(cDescPrd,1,50),Transform(nQtd,"@E 999,999,999"),Space(nTamPed),Space(nTamIpc)})
			Next
			ASort( aListBox, , , { |x,y| y[1] > x[1] } )
			lTdOk := .F.
			While ! lTdOk
				DEFINE MSDIALOG oDlgRet TITLE "Produtos Lidos no XML: " FROM 09,0 TO 33.8,80 OF oMainWnd
	
				DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	
					@  0, -25 BITMAP oBmp RESNAME "PEDIDOS" oF oDlgRet SIZE 55, 1000 NOBORDER WHEN .F. PIXEL
	
					@ 03, 40 SAY "Fornecedor: " + cFornec+" - "+cLoja FONT oBold PIXEL
					@ 13, 40 SAY cNomeFor FONT oBold PIXEL
					@ 03, 30 TO 24 ,310 LABEL '' OF oDlgRet   PIXEL
	
					@ 25,030 LISTBOX oList Update FIELDS HEADER ;
					OemToAnsi("Produto"),;
					OemToAnsi("Descricao"),;
					OemToAnsi("Quantidade"),;
					OemToAnsi("Pedido"),;
					OemToAnsi("Item PC"),;
					COLSIZES 15,50,35,25,10;
					SIZE 280,135 OF oDlgRet PIXEL ON DBLCLICK (nPos:=oList:nAt,If(oList:nColPos == 6,lEditCell(aListBox,oList,"@!",oList:nColPos,'CTT',,_bValid),""),oList:Refresh(),oList:nAt:=nPos);
					CENTERED;
					
					oList:SetArray(aListBox)
					oList:bLine := { || {aListBox[oList:nAt,01],;
					aListBox[oList:nAt,02],;
					aListBox[oList:nAt,03],;
					aListBox[oList:nAt,04],;
					aListBox[oList:nAt,05]}}
					
					
					DEFINE SBUTTON oBut3 FROM 172, 147 TYPE 12 ACTION PItemPC( aListBox[oList:nAT,1],cFornec,cLoja,aListBox[oList:nAt,03])  ENABLE of oDlgRet
					DEFINE SBUTTON oBut1 FROM 172, 179 TYPE 1 ACTION ( nOpcp := 1, oDlgRet:End() )  ENABLE of oDlgRet
					DEFINE SBUTTON oBut2 FROM 172, 212 TYPE 2 ACTION ( nOpcp := 0, oDlgRet:End() )  ENABLE of oDlgRet
					oBut3:CCAPTION := "P.Compra"
					
				ACTIVATE MSDIALOG oDlgRet CENTERED
				If nOpcp == 1
					if empty(alltrim(alistbox[1][4]))
						Conout("Pedido de compra n�o encontrado ou n�o Aprovado")
						Return
					endif
					lContinua := .T.
					lChkPc := .T.
					If lChkPc
						lContinua :=  aChkPc(alistbox)
					EndIf	
					If lContinua
						For nX:=1 To Len(_aItens)
						//	_aItens[nX][10] := alistbox[nX][3]
							_aItens[nX][7] := alistbox[nX][4]  // Pedido
							_aItens[nX][8] := alistbox[nX][5]  // Item PC
						Next
						lTdOk := .T.
						lGeraReg :=  ProcDocE(cTipo,_cFilial, cFornec, cLoja,_cDoc,_cSerie,cChaveNfe,_aItens,__xDtXml,cEspecie,__cCFOP)
						DbSelectArea("SZ1")
						If ! lGeraReg
							RecLock("SZ1",.F.)
							SZ1->Z1_STATUS := "7"
							MsUnlock()
						Else
							RecLock("SZ1",.F.)
							SZ1->Z1_STATUS := "6"
							MsUnlock()
						EndIf
					EndIf
				Else
					Conout("N�o foi incluido o pedido de compra. ou o mesmo econtra-se bloqueado"+ CRLF+"Favor Incluir")
					lTdOk := .T.
					
				EndIf
			EndDo			
		EndIf
	EndIf
else
	lTdOk := .T.
	lGeraReg :=  ProcDocE(cTipo,_cFilial, cFornec, cLoja,_cDoc,_cSerie,cChaveNfe,_aItens,__xDtXml,cEspecie,__cCFOP)
	DbSelectArea("SZ1")
	/*If ! lGeraReg
		RecLock("SZ1",.F.)
		SZ1->Z1_STATUS := "7"
		MsUnlock()
	Else
		RecLock("SZ1",.F.)
		SZ1->Z1_STATUS := "6"
		MsUnlock()
	EndIf*/
EndIf
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraSA7  �Autor  �                 o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
//GeraSA7
Static Function GeraSA7(cCli,  cLoja,  cProd,  cDesCPrd ,_cFilial)

Local lRet := .T.
Local oEdit1
Local cEdit1 := space(TamSX3('A7_CODCLI')[1])


DEFINE MSDIALOG _oDlg TITLE "INCLUIR DE/PARA CODIGO CLIENTE" FROM C(177),C(192) TO C(340),C(659) PIXEL STYLE DS_MODALFRAME
	
	_oDlg:lEscClose := .F.
	// Cria as Groups do Sistema
	@ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg
	
	// Cria Componentes Padroes do Sistema
	@ C(012),C(027) Say "Produto: "+cProd Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(020),C(027) Say "Descricao: "+cDesCPrd Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd(cEdit1)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(040),C(027) Say "Produto digitado: "+cEdit1 Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(048),C(027) Say "Descricao: "+Alltrim(GetAdvFVal("SB1","B1_DESC",XFilial("SB1")+cEdit1,1,""))Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
	@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Chkproc:=.T.,_oDlg:End())
	oEdit1:SetFocus()
	
ACTIVATE MSDIALOG _oDlg CENTERED


If Chkproc

	If SA7->(dbSetOrder(1), dbSeek(xFilial("SA7")+cCli+cLoja+cEdit1))

		RecLock("SA7",.F.)

	Else

		Reclock("SA7",.T.)

	Endif

		SA7->A7_FILIAL := xFilial("SA7")
		SA7->A7_CLIENTE := cCli
		SA7->A7_LOJA 	:= cLoja
		SA7->A7_PRODUTO := cEdit1
		SA7->A7_DESCCLI := cDesCPrd
		SA7->A7_CODCLI  := cProd
	SA7->(MsUnlock())
	
Else

	Conout("ERRO!!!"+CRLF+"Contatar Administrador")
	lRet := .F.

EndIf
Return lRet

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A140EstCla � Autor �Patricia A. Salomao   � Data �01/08/2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Estorno da Classificacao da Nota Fiscal.                    ���
���          �Executa a funcao de exclusao do MATA103;Porem, nao exclui o ���
���          �SD1/SF1;Apenas limpa o conteudo os campos D1_TES e F1_STATUS���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpX1 := A140ExcCla( ExpC1, ExpN1, ExpN2 )                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 -> Alias do arquivo                                  ���
���          � ExpN1 -> Recno do registro                                 ���
���          � ExpN2 -> Opcao Selecionada                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA140                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function Ax140EstCl()
/*
_cCnpj		:= SZ1->Z1_CGC
_cFilial	:= SZ1->Z1_FILIAL
_cDoc		:= SZ1->Z1_DOC
_cSerie		:= SZ1->Z1_SERIE
cChaveNfe	:= SZ1->Z1_CHAVE
cEspecie	:= SZ1->Z1_ESPECIE
cTipo		:= SZ1->Z1_TIPO
nRecno		:= 0
	:= Posicione("SA2",3,xFilial("SA2")+_cCnpj,"A2_COD")
cLoja		:= Posicione("SA2",3,xFilial("SA2")+_cCnpj,"A2_LOJA")
if SZ1->Z1_STATUS != "3"
	Conout("N�o � documento de entrada para ser estornado")
endif
cAlias		:= "SF1"
DbSelectArea(cAlias)
DbSetOrder(1)
if Dbseek(_cFilial+_cDoc+_cSerie+cFornece+cLoja)	
	nRecno := SF1->(RecNo())
	If SF1->F1_STATUS != "A"
	    Help("",1,"A140ESTORN")
	ElseIf SF1->F1_TIPO $ "NDB"
		A103NFiscal(cAlias,nRecno,5,,.T.)
		RecLock("SZ1",.F.)
			SZ1->Z1_STATUS = '6'
		MsUnlock()
	Else
		Help("",1,"A140NCLASS")
	EndIF
else
	Aviso("Erro para estornar o documento",{"OK"})
endif*/
Conout("Rotina n�o funcional! "+CRLF+"Favor Estornar pelo Documento de Entrada!")
Return .T.

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A140EstCla � Autor �Patricia A. Salomao   � Data �01/08/2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Estorno da Classificacao da Nota Fiscal.                    ���
���          �Executa a funcao de exclusao do MATA103;Porem, nao exclui o ���
���          �SD1/SF1;Apenas limpa o conteudo os campos D1_TES e F1_STATUS���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpX1 := A140ExcCla( ExpC1, ExpN1, ExpN2 )                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 -> Alias do arquivo                                  ���
���          � ExpN1 -> Recno do registro                                 ���
���          � ExpN2 -> Opcao Selecionada                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA140                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function AxClas()
/*_cCnpj		:= SZ1->Z1_CGC
_cFilial	:= SZ1->Z1_FILIAL
_cDoc		:= SZ1->Z1_DOC
_cSerie		:= SZ1->Z1_SERIE
cChaveNfe	:= SZ1->Z1_CHAVE
cEspecie	:= SZ1->Z1_ESPECIE
cTipo		:= SZ1->Z1_TIPO
nRecno		:= 0
cFornece	:= Posicione("SA2",3,xFilial("SA2")+_cCnpj,"A2_COD")
cLoja		:= Posicione("SA2",3,xFilial("SA2")+_cCnpj,"A2_LOJA")
PRIVATE INCLUI := .F.
PRIVATE ALTERA := .T.
lIntegracao := .F.
if SZ1->Z1_STATUS != "6"
	Conout("N�o � pr�-nota para ser classificada")
	return
endif
cAlias		:= "SF1"
DbSelectArea(cAlias)
DbSetOrder(1)
if Dbseek(_cFilial+_cDoc+_cSerie+cFornece+cLoja)	
	nRecno := SF1->(RecNo())
	A103NFiscal(cAlias,nRecno,4,.T.)	
	//A100Classi(cAlias,nRecno,4)
	SF1->(DbGoTo(nRecno))
	If !Empty(SF1->F1_STATUS)
		RecLock("SZ1",.F.)
			SZ1->Z1_STATUS = '3'
		MsUnlock()
	endif
else
	Aviso("Pre-Nota n�o encontrada",{"OK"})
endif
DbselectArea("SZ1")*/
Conout("Rotina n�o funcional! "+CRLF+"Favor classifar pelo Documento de Entrada!")
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NFORIG   �Autor  �Microsiga           � Data �     08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Pega as Origens do Frete no xml                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � USCHNCTE                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FuncTion NFORIG(oXml,cXML,lCteproc)
Local a_Docs := {}

//Verifica se é cte a nf de origem de um cte.
If lCteproc
	CONOUT(" NFORIG CteProc...")
	n_Chave := AT("<infNFe><chave>",cXML) // Verifica se foi informado a chave da NF-e na Origem
    IIF(n_Chave < 1, n_Chave := AT("<infCteComp><chave>",cXML),n_Chave := n_Chave)
	If n_Chave > 0
		If Type("oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE") <> "U"
			aRef := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE
			If ValType(aRef) == "A"
				For nI := 1 To Len(aRef)
					cXMLNFRef := aRef[nI]:_CHAVE:TEXT // oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE[nI]:_CHAVE:TEXT
					cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
					cSerRef   := Substr(cXMLNfRef,23,3)
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				Next
			Else
				cXMLNfRef := oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE:_CHAVE:TEXT
				cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
				cSerRef   := Substr(cXMLNfRef,23,3)
				cSerRef   := STRTRAN(cSerRef,"0","")
				cSerRef   := Substr(cSerRef+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			EndIf
		elseif Type("oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE") <> "U"	  
			aRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE
			If ValType(aRef) == "A"
				For nI := 1 To Len(aRef)
					cXMLNFRef := aRef[nI]:_CHAVE:TEXT // oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE[nI]:_CHAVE:TEXT
					cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
					cSerRef   := Substr(cXMLNfRef,23,3)
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				Next
			Else
				cXMLNfRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT
				cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
				cSerRef   := Substr(cXMLNfRef,23,3)
				cSerRef   := STRTRAN(cSerRef,"0","")
				cSerRef   := Substr(cSerRef+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			EndIf		
		elseif Type("oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF") <> "U"	  
			aRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF
			If ValType(aRef) == "A"
				For nI := 1 To Len(aRef)
					cDocRef   := Substr(Alltrim(StrZero(Val(aRef[nI]:_NDOC:TEXT),6,0))+Space(9),1,9)
					cSerRef   := aRef[nI]:_SERIE:TEXT
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				Next
			Else
				cDocRef   := Substr(Alltrim(StrZero(Val(aRef:_NDOC:TEXT),6,0))+Space(9),1,9)
				cSerRef   := aRef:_SERIE:TEXT
				cSerRef   := STRTRAN(cSerRef,"0","")
				cSerRef   := Substr(Alltrim(aRef:_SERIE:TEXT)+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			EndIf
			elseif Type("oXML:_CTEPROC:_CTE:_INFCTE:_INFCTECOMP") <> "U"	  
				aRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTECOMP
				If ValType(aRef) == "A"
					For nI := 1 To Len(aRef)
						cXMLNFRef := aRef[nI]:_CHAVE:TEXT // oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE[nI]:_CHAVE:TEXT
						cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
						cSerRef   := Substr(cXMLNfRef,23,3)
						cSerRef   := STRTRAN(cSerRef,"0","")
						cSerRef   := Substr(cSerRef+Space(3),1,3)
						aadd(a_Docs,{cDocRef,cSerRef})
					Next
				Else
					cXMLNfRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTECOMP:_CHAVE:TEXT
					cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
					cSerRef   := Substr(cXMLNfRef,23,3)
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				EndIf						
		EndIf
	Else   //aqui entra o else se nao esta pela chave
		If Type("oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF") <> "U"
			aRef := oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF
			If ValType(aRef) == "A"
				For nI := 1 To Len(aRef)
					cDocRef   := Substr(Alltrim(StrZero(Val(aRef[nI]:_NDOC:TEXT),6,0))+Space(9),1,9)
					cSerRef   := aRef[nI]:_SERIE:TEXT
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				Next
			Else
				cDocRef   := Substr(Alltrim(StrZero(Val(aRef:_NDOC:TEXT),6,0))+Space(9),1,9)
				cSerRef   := aRef:_SERIE:TEXT
				cSerRef   := STRTRAN(cSerRef,"0","")
				cSerRef   := Substr(Alltrim(aRef:_SERIE:TEXT)+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			EndIf
		elseif Type("oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE") <> "U" 
			aRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE
			If ValType(aRef) == "A"
				For nI := 1 To Len(aRef)
					cDocRef   := Substr(Alltrim(StrZero(Val(aRef[nI]:_NDOC:TEXT),6,0))+Space(9),1,9)
					cSerRef   := aRef[nI]:_SERIE:TEXT
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				Next
			Else
				cDocRef   := Substr(Alltrim(StrZero(Val(aRef:_NDOC:TEXT),6,0))+Space(9),1,9)
				cSerRef   := aRef:_SERIE:TEXT
				cSerRef   := STRTRAN(cSerRef,"0","")
				cSerRef   := Substr(Alltrim(aRef:_SERIE:TEXT)+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			EndIf 
		elseif Type("oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF") <> "U"	  
			aRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF
			If ValType(aRef) == "A"
				For nI := 1 To Len(aRef)
					cDocRef   := Substr(Alltrim(StrZero(Val(aRef[nI]:_NDOC:TEXT),6,0))+Space(9),1,9)
					cSerRef   := aRef[nI]:_SERIE:TEXT
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				Next
			Else
				cDocRef   := Substr(Alltrim(StrZero(Val(aRef:_NDOC:TEXT),6,0))+Space(9),1,9)
				cSerRef   := aRef:_SERIE:TEXT
				cSerRef   := STRTRAN(cSerRef,"0","")
				cSerRef   := Substr(Alltrim(aRef:_SERIE:TEXT)+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			EndIf
		elseif Type("oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS") <> "U"	  
			aRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS
			If ValType(aRef) == "A"
				For nI := 1 To Len(aRef)
					cDocRef   := Substr(Alltrim(StrZero(Val(substr(aRef[nI]:_NDOC:TEXT,1,6)),6,0))+Space(9),1,9)
					cSerRef   := right(aRef[nI]:_NDOC:TEXT,1)
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				Next
			Else
				cDocRef   := Substr(Alltrim(StrZero(Val(substr(aRef:_NDOC:TEXT,1,6)),6,0))+Space(9),1,9)
				cSerRef   := right(aRef:_NDOC:TEXT,1)
				cSerRef   := IIF(Len(cSerRef)>1,STRTRAN(cSerRef,"0",""),cSerRef)
				cSerRef   := Substr(Alltrim(cSerRef)+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			EndIf
		endif
	EndIf
Else
	If Type("oXml:_CTE:_INFCTE:_REM:_INFNF:_NDOC") <> "U"
		aRef := oXml:_CTE:_INFCTE:_REM:_INFNF
		If ValType(aRef) == "A"
			For nI := 1 To Len(aRef)
				cDocRef   := Substr(Alltrim(StrZero(Val(aRef[nI]:_NDOC:TEXT),6,0))+Space(9),1,9)
				cSerRef   := aRef[nI]:_SERIE:TEXT
				cSerRef   := STRTRAN(cSerRef,"0","")
				cSerRef   := Substr(cSerRef+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			Next
		Else
			cDocRef   := Substr(Alltrim(StrZero(Val(aRef:_NDOC:TEXT),6,0))+Space(9),1,9)
			cSerRef   := aRef:_SERIE:TEXT
			cSerRef   := STRTRAN(cSerRef,"0","")
			cSerRef   := Substr(Alltrim(aRef:_SERIE:TEXT)+Space(3),1,3)
			aadd(a_Docs,{cDocRef,cSerRef})
		EndIf
     Else
		Conout(" NFORIG infCte...")
	EndIf
EndIf
xx:="1"

//a_Docs[1] := StrZero(Val(a_Docs[1,1]),9)
nTamDoc := TamSx3("D1_DOC")[1]
nTamSer := TamSx3("D1_SERIE")[1]

For nI := 1 To Len(a_Docs)
	a_Docs[nI,1] := StrZero(Val(a_Docs[nI,1]),nTamDoc)
	a_Docs[nI,2] := Pad(a_Docs[nI,2],nTamSer)
Next

Return(a_Docs) 

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Prog.  �ProcDocE � Uso � Surya Brasil � Modulo � Compras � Data � 08/02/17 ���
�����������������������������������������������������������������������������͹��
���Desc.  � Fun��o para para gerar Documento de Entrada                       ���
���       �                                                                   ���
�����������������������������������������������������������������������������͹��
��� Autor � Caio de Paula             � Contato �(11) 98346-3154              ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Static FuncTion ProcDocE(cTipo,_cFilial,_cFornece,_cLoja,_cDoc,_cSerie,cChaveNfe,_aItens,__xDtXml,cEspecie,cCFOP)
Local _lRet 			:= .T. 
Local _aLinha			:= {}
Local aItSD1			:= {}
Local nI 				:= 1       
Local _cNumItem 		:= ""
Local _cTes				:= ""
Local lNota				:= .F.
Local aArrCab			:= {}
Local aItens			:= {}

PRIVATE aRotina := MenuDef2()

_cTes := RetTES(cCFOP,cEspecie)
lNota := iif(Empty(alltrim(_cTes)),.F.,.T.)
AADD(aArrCab,{_cFilial,_cFornece,_cLoja,StrZero(Val(_cDoc),9),Iif(Val(_cSerie) == 0," ",_cSerie),cChaveNfe,__xDtXml,cEspecie,cTipo})

If Len(_aItens) > 0	

	_aCab	:= GArrCab(aArrCab)
	aItSD1	:= GArrIt(_aItens,_cTes,cEspecie,lNota,_cFilial)
	lMsErroAuto := .f.
	
	SB1->(dbSetOrder(1))
	SF4->(dbSetOrder(1))

	If ! lNota

		MsExecAuto({|w,x,y,z|MATA140(w,x,y,z)},_aCab,aItSD1,3,Nil)

		IF !lMSErroAuto

			_cMsg := "Pre-nota gerada com sucesso!"
			_lRet := .T.
			_cMsg += " Nf " +_cDoc

			If IsInCallStack("U_CPPRENFE")
			
				msgalert(_cMsg,"Informa��o")
			
			Else
			 
			 	CONOUT(_cMsg)
			EndIf
			
			If	SZ1->(RecLock("SZ1",.F.))
			
				SZ1->Z1_STATUS := "6"
				SZ1->(MsUnlock())
			
			EndIf			 
		
		Else
			DbSelectArea("SF1")
			DbSetOrder(2)  // F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC
		
			If DbSeek(xFilial("SF1") + _cFornece + _cLoja + _cDoc )
		
				_cMsg := "Pre-nota gerada com sucesso!"
				_lRet := .T.
				_cMsg += " Nf " +_cDoc
		
				If IsInCallStack("U_CPPRENFE")
		
					msgalert(_cMsg,"Informa��o")
		
				Else
		
				 	CONOUT(_cMsg)
		
				EndIf
		
				If	SZ1->(RecLock("SZ1",.F.))
					SZ1->Z1_STATUS := "6"
					SZ1->(MsUnlock())
				
				EndIf
			
			Else
			
				Mostraerro()
				DisarmTransaction()      
				_lRet := .F.
			
				If	SZ1->(RecLock("SZ1",.F.))
				
					SZ1->Z1_STATUS := "7"
					SZ1->(MsUnlock())
				
				EndIf
				
			Endif
			
		Endif
		
	Else
	
		//MsExecAuto({|w,x,y,z|MATA103(w,x,y,z)},_aCab,aItSD1,3,Nil)
		MATA103(_aCab, aItSD1,3,.F.)
	
		IF !lMSErroAuto
			
			_cMsg := "Nota de Entrada gerada com sucesso: "
			_lRet := .T.
			
			If IsInCallStack("U_CPPRENFE")
			
				msgalert(_cMsg + _cDoc)
			
			Else
			
			 	CONOUT(_cMsg + _cDoc)
			
			EndIf
			 
			 If	SZ1->(RecLock("SZ1",.F.))
				
				SZ1->Z1_STATUS := "3"
				SZ1->(MsUnlock())
				
			EndIf
			
		Else
		
			DbSelectArea("SF1")
			DbSetOrder(2)  // F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC
	
			If DbSeek(xFilial("SF1") + _cFornece + _cLoja + _cDoc )
				_cMsg := "Nota de Entrada gerada com sucesso!"
				_lRet := .T.
				_cMsg += " Nf " +_cDoc
	
				If IsInCallStack("U_CPPRENFE")
				 
				 	msgalert(_cMsg + _cDoc)
				
				Else
				
				 	CONOUT(_cMsg + _cDoc)
				
				EndIf
				
				If	SZ1->(RecLock("SZ1",.F.))
				
					SZ1->Z1_STATUS := "3"
					SZ1->(MsUnlock())
				
				EndIf
				
			Else
			
				Mostraerro()
				DisarmTransaction()      
				_lRet := .F.
				
				If	SZ1->(RecLock("SZ1",.F.))
				
					SZ1->Z1_STATUS := "7"
					SZ1->(MsUnlock())
				
				EndIf
			
			Endif
		
		Endif
	
	Endif
Else

	If !lNota
	
		If IsInCallStack("U_CPPRENFE")
		
			msgalert("Pre-Nota - N�O FOI GERADA!","Alerta")
		
		Else
		
		 	CONOUT("Pre-Nota - N�O FOI GERADA!")
		
		EndIf
	_lRet := .F.
	
	Else
	
		If IsInCallStack("U_CPPRENFE")
		
			msgalert("Nota - N�O FOI GERADA!","Alerta")
		
		Else
		 
		 	CONOUT("Nota - N�O FOI GERADA!")
		
		EndIf
		
		_lRet := .F.
		
	Endif
	
	If	SZ1->(RecLock("SZ1",.F.))
	
		SZ1->Z1_STATUS := "7"
		SZ1->(MsUnlock())
	
	EndIf

EndIf

Return(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RetTES   �Autor  �                 o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function RetTES(cCFOP,cEspecie)
Local cTes := ""

If !Empty(alltrim(cCFOP)) .Or. ALLTRIM(cEspecie) == "CTE"

	do Case

		Case substr(cCFOP,2,3) == "906"

			cTes := SuperGetMv("SB_TES1906",.F.,"")

		Case substr(cCFOP,2,3) == "907"

			cTes := SuperGetMv("SB_TES1907",.F.,"")

		Case ALLTRIM(cEspecie) == "CTE"

			cTes := SuperGetMv("SB_TESCTE",.F.,"")

		OtherWise

			cTes		:= ""

	End Case
	
EndIf

Return cTes               
/*
Static Function ReTXMLbd(cNota, cSerie)   
local cXML	 := ""
local cQuery := ""
USE SPED050 ALIAS SPED050 SHARED NEW VIA "TOPCONN" 
IF NetErr() 
   conout("Falha ao abrir SPED050") 
Endif            

cQuery := "SELECT  AS RECNO FROM SPED050 WHERE ORDER BY"

//Ao abrir a query, voc� posiciona no registro correspondente da SPED050 usando SPED050->(DBGOTO(QRY->RECNO)) 
//
//Se voce abrir a SPED050 na m�o, feche-a depois usando DBCloseArea() 


Return cXML*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GArrCab  �Autor  �                 o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GArrCab(aArrCab)
Local aCabec	:= {}
AAdd( aCabec, { "F1_FILIAL"		, aArrCab[1][1]					, nil } )   	// Filial				: Obrigatorio
AAdd( aCabec, { "F1_DOC"		, aArrCab[1][4]					, nil } )   	// Numero da NF			: Obrigatorio
AAdd( aCabec, { "F1_SERIE"		, Strzero(val(aArrCab[1][5]),3)	, nil } )   	// Serie da NF		    : Obrigatorio
AAdd( aCabec, { "F1_FORNECE"	, aArrCab[1][2]					, nil } )   	// Codigo do Fornecedor	: Obrigatorio
AAdd( aCabec, { "F1_LOJA"		, aArrCab[1][3]					, nil } )   	// Loja do Fornecedor	: Obrigatorio
AAdd( aCabec, { "F1_EMISSAO"	, aArrCab[1][7]					, nil } )    	// Emissao da NF		: Obrigatorio
AAdd( aCabec, { "F1_TIPO"		, IIF(!EMPTY(Alltrim(aArrCab[1][9])),Alltrim(aArrCab[1][9]),"N") 							, nil } )  		// Tipo da NF			: Obrigatorio
AAdd( aCabec, { "F1_FORMUL"		, "N"    						, nil } )  		// Formulario Proprio	: Obrigatorio	
AAdd( aCabec, { "F1_ESPECIE"	, aArrCab[1][8] 				, nil } )  		// Especie				: Obrigatorio
AAdd( aCabec, { "F1_CHVNFE"		, aArrCab[1][6]					, nil } )    	// Chave Nfe			: Obrigatorio
if alltrim(aArrCab[1][8]) = "CTE"
	AAdd( aCabec, { "F1_TPCTE"	, "N"							, nil } )    	// Tipo Cte			: Obrigatorio
endif
Return aCabec

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GArrIt   �Autor  �                 o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GArrIt(_aItens,_cTes,cEspecie,lNota,_cFilial)
/*Posicoes Array Itens
[1]TipoNF
[2]Fornecedor,
[3]Loja,
[4]Produto,
[5]Natureza,
[6]TES,
[7]Pedido Compra,
[8]Item PC,
[9]Quantidade,
[10]Valor Unitario,
[11]Valor Mercadoria,
[12]Documento Original,
[13]Serie Original,
[14]cLote,
[15]dDtaValid
[16]Documento
[17]Serie
*/
//Nao utilizar tes do array

Local aLinha,aItens		:={}
Local nI				:= 0
Local lPC				:= .F.
Local lNfOrig			:= !Empty(alltrim(_aItens[1][12])) //ver
Local lLote				:= !Empty(alltrim(_aItens[1][14]))
Local lDupl				:= iif(Posicione("SF4",1, xFilial("SF4")+_cTes,"F4_DUPLIC")=="S",.T.,.F.)	
Local _cPedido,_cItemPc	:= ""
Local _cLote,_cCC		:= ""
Local _cLocal,_cNFOri	:= ""
Local _cCConta,_cFilial	:= ""
Local _cDoc, _cSerie	:= ""
Local _cFornece,_cLoja	:= ""
Local _cNaturez,_cCond	:= ""
Local _cNumItem,_cProd	:= ""
Local _nQtd,_nValUni	:= 0
Local _dDtaValid		:= CTOD("  /  /  ")

For nI:=1 To Len(_aItens)

	lPC			:= !Empty(alltrim(_aItens[nI][7]))
	_cNumItem	:= StrZero(nI, 4)
	_cProd   	:= _aItens[nI][4]
	_nQtd    	:= _aItens[nI][9]
	_nValUni 	:= _aItens[nI][10]
	_cDoc 		:= _aItens[nI][16]
	_cSerie		:= strZero(val(_aItens[nI][17]),3)
	_cFornece	:= _aItens[nI][2]
	_cLoja		:= _aItens[nI][3]
	_cCConta  	:= Posicione("SB1",1, xFilial("SB1") + _cProd,"B1_CONTA")
	_cNaturez	:= Posicione("SA2",1, xFilial("SA2") + _cFornece+_cLoja,"A2_NATUREZ")
	_cNFOri  	:= strZero(val(_aItens[nI][12]),9)
	_cSerOri  	:= strZero(val(_aItens[nI][13]),3)
	_cLote	 	:= _aItens[nI][14]
	_dDtaValid	:= _aItens[nI][15]
	_cFilial	:= cFilAnt

	If lPC
	
		_cPedido	:= _aItens[nI][7]
		_cItemPc	:= _aItens[nI][8]
		DbSelectArea("SC7")	
		DbSetOrder(1)
	
		If DbSeek(xFilial("SC7") +alltrim(_cPedido) + alltrim(_cItemPc) )
	
				_cCC     := SC7->C7_CC
				_cLocal  := SC7->C7_LOCAL
	
		EndIf	
	
	EndIf
	
	_cCC     	:= If(EmpTy(alltrim(_cCC)), Posicione("SB1",1, xFilial("SB1") + _cProd,"B1_CC"),_cCC)
	_cLocal  	:= If(EmpTy(alltrim(_cLocal)), Posicione("SB1",1, xFilial("SB1") + _cProd,"B1_LOCPAD"),_cLocal)
	_aLinha  	:= {}
	_nTotal 	:= ROUND ( _nValUni * _nQtd, 2 )
	
    AAdd(_aLinha, {"D1_FILIAL"	,_cFilial   ,nil } ) // filial
	AAdd(_aLinha, {"D1_ITEM"	,_cNumItem  ,nil } ) // Item  			 : Obrigatorio
	AAdd(_aLinha, {"D1_DOC"		,_cDoc      ,nil } ) // Docto			 : Obrigatorio
	AAdd(_aLinha, {"D1_SERIE"	,_cSerie    ,nil } ) // Serie			 : Obrigatorio
	AAdd(_aLinha, {"D1_FORNECE"	,_cFornece  ,nil } ) // Fornece			 : Obrigatorio
	AAdd(_aLinha, {"D1_LOJA"	,_cLoja     ,nil } ) // loja			 : Obrigatorio
	AAdd(_aLinha, {"D1_COD"		,_cProd     ,nil } ) // Produto			 : Obrigatorio
	AAdd(_aLinha, {"D1_QUANT"	,_nQtd      ,nil } ) // Quantidade		 : Obrigatorio
	AAdd(_aLinha, {"D1_VUNIT"	,_nValUni   ,nil } ) // Valor Unitario	 : Obrigatorio
	AAdd(_aLinha, {"D1_CONTA"	,_cCConta   ,nil } ) // Conta Contabil	 : Obrigatorio
	AAdd(_aLinha, {"D1_TOTAL"	,_nTotal   ,nil } ) // Conta Contabil	 : Obrigatorio
	
	If !Empty(Alltrim(_cCC))
	
		AAdd(_aLinha, {"D1_CC"	    ,_cCC       ,nil } ) // C.Custos 		 : Obrigatorio
	
	EndIf
	
	AAdd(_aLinha, {"D1_LOCAL"	,_cLocal    ,nil } ) // Local   		 : Obrigatorio
	
	If lNota
	
		AAdd(_aLinha, {"D1_TES"		,_cTes	    ,nil} ) // TES				 : Obrigatorio		
	
		If lDupl
	
			AAdd(_aLinha, {"D1_NATFIN"  ,_cNaturez  ,nIL } ) // Natureza Financ. : Obrigatorio
	
		EndIf
	
	EndIf
	
	If lPC
	
		AAdd(_aLinha, {"D1_PEDIDO"  ,_cPedido   ,nil } ) // Pedido Compras   : Obrigatorio
		AAdd(_aLinha, {"D1_ITEMPC"  ,_cItemPc   ,nil } ) // Item do P.Compra : Obrigatorio
	
	EndIf
	
	If lLote
	
		AAdd(_aLinha, {"D1_LOTECTL"	,_cLote		,nil }) //Lote
		AAdd(_aLInha, {"D1_DTVALID" ,_dDtaValid ,nil }) //data de validade
	
	EndIf
	
	If lNfOrig
		
		AAdd(_aLinha, {"D1_NFORI"   , _cNFOri    ,nil } ) // Pedido Compras   	: Obrigatorio
		AAdd(_aLinha, {"D1_SERIORI" , _cSerOri   ,nil } ) // Item do P.Compra 	: Obrigatorio

	EndIf

	aadd(_aLinha, {"AUTDELETA"  ,"N"        ,Nil } ) // Incluir sempre no �ltimo elemento do array de cada item
	
	
	AAdd( aItens, AClone(_aLinha) )
	
Next

Return aItens

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFAuto   �Autor  �                 o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function NFAuto()

Local cCadastro 	:= 	OemToAnsi("Gera Documento Automaticamente")
Local aSays			:=	{}, aButtons	:={}
Local nOpca     	:= 	0 
Local cPerg			:= 	"ZZ1SF1"

aADD( aSays,OemToAnsi( " Este programa tem como objetivo apurar os Xmls importados"				)	)
aADD( aSays,OemToAnsi( " Ir� fazer os lan�amentos dos documentos de entrada"					)	)
aADD( aSays,OemToAnsi( " Todos os tipos conforme a parametriza��o entrar�o como tipo Pr� Nota"	)	)
aADD( aSays,OemToAnsi( " Exce��es que ja entrar�o classificadas:"								)	)
aADD( aSays,OemToAnsi( " Documentos Fiscais de esp�cie CTE"										)	)
aADD( aSays,OemToAnsi( " Documentos Fiscais de esp�cie SPED que s�o notas de Armazenagem"		)	)

AjustaSx1(	cPerg	)

aADD( aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch()		}	}	)
aADD( aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch()		}	}	)
aADD( aButtons, { 5,.T.,{|| Pergunte( cPerg,.T. )		}	}	)

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1

	If EMPTY( ALLTRIM( MV_PAR02 ) ) .AND. MV_PAR05 <> 1
	
		Conout( "Especie Obrigatoria" )
		Return
		
	EndIf
	 
	If EMPTY( MV_PAR03 ) .Or. EMPTY( MV_PAR04 )
	 
		Conout("Datas Obrigatorias")
		Return
		
	EndIf
	 
	If MV_PAR04 < MV_PAR03
	 
		Conout( "A data final nao pode ser menor que a data inicial!" )
		Return
		
	EndIf
	 
     ProcDE()
     
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSx1�Autor  �                 o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSx1(cPerg)

U_xPutSX1( cPerg,"01"   	,"CNPJ Fornecedor:	"	,"CNPJ Fornecedor:	"	,"CNPJ Fornecedor:	"	,"mv_ch1"	,"C"	,14		,0		,0		,"G"	,""	,"  "	,""	,""	,"MV_PAR01"	,""		,""		,""		,""	,""			,""			,""			,"","","","","","","","","",{"","",""},{},{})
U_xPutSX1( cPerg,"02"   	,"Especie: "		 	,"Especie: "	 		,"Especie "		     	,"mv_ch2"	,"C"    ,6		,0		,0		,"G"	,""	,"  "	,""	,""	,"MV_PAR02"	,""		,""		,""		,""	,""			,""			,""			,"","","","","","","","","",{"","",""},{},{})
U_xPutSX1( cPerg,"03"   	,"Emissao Inicial"   	,"Emissao Inicial"		,"Emissao Inicial"	 	,"mv_ch3"	,"D"	,08		,0		,0		,"G"	,""	,"  "	,""	,""	,"MV_PAR03"	,""		,""		,""		,""	,""			,""			,""			,"","","","","","","","","",{"","",""},{},{})
U_xPutSx1( cPerg,"04"		,"Emissao Final"	 	,"Emissao Final"    	,"Emissao Final"	 	,"mv_ch4"	,"D"	,08		,0		,0		,"G"	,""	,"  "	,""	,""	,"MV_PAR04"	,""		,""		,  		,  	,  			,  			,  			,  ,  ,  ,  ,  ,  ,  ,  ,  ,{"","",""},{},{})
U_xPutSX1( cPerg,"05"   	,"Tipo de Nota: "		,"Tipo de Nota: " 		,"Tipo de Nota"	     	,"mv_ch5"	,"C"    ,1		,0		,0		,"G"	,""	,"  "	,""	,""	,"MV_PAR05"	,"Saida","Saida","Saida",""	,"Entrada"	,"Entrada"  ,"Entrada"	,"","","","","","","","","",{"","",""},{},{})

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcDE  �                          o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     �    					                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcDE()

Local nX										:= 0
Local nRecno									:= 0
Local nTCPEsp									:= TamSX3("Z1_ESPECIE")[1]
LocaL cEspec									:= Iif( MV_PAR05 == 1, "SATCE", AllTrim( MV_PAR02 )+space( nTCPEsp-Len( ALLTRIM( MV_PAR02 ) ) ) ) //ALLTRIM(MV_PAR02)+space(nTCPEsp-len(ALLTRIM(MV_PAR02)))
Local cWhile									:= ""
Local aDocs										:= {}
Local _cFilial,_cDoc,_cSerie,c_Fornece,c_Loja 	:= ""

If MV_PAR05 <> 1

	If !EMPTY ( Alltrim( MV_PAR01 ) )
	
		cWhile := " SZ1->(!EOF()) .And. alltrim(SZ1->Z1_ESPECIE) == ALLTRIM(MV_PAR02) .And. ALLTRIM(SZ1->Z1_CGC) == ALLTRIM(MV_PAR01)"
		
	Else
	
		cWhile := " SZ1->(!EOF()) .And. alltrim(SZ1->Z1_ESPECIE) == ALLTRIM(MV_PAR02)"
		
	EndIf

ElseIf MV_PAR05 == 1

	If !EMPTY ( Alltrim( MV_PAR01 ) )
	
		cWhile := " SZ1->(!EOF()) .And. AllTrim(SZ1->Z1_ESPECIE) == 'SATCE' .And. ALLTRIM(SZ1->Z1_CGC) == ALLTRIM(MV_PAR01)"
		
	Else
	
		cWhile := " SZ1->(!EOF()) .And. AllTrim(SZ1->Z1_ESPECIE) == 'SATCE'"
		
	EndIf
	
EndIf

DbSelectArea("SZ1")
DbSetOrder(5)

If DbSeek(xFilial("SZ1")+cEspec+ALLTRIM(MV_PAR01))

	While &cWhile
	
		nX++
		
		If MV_PAR05 == 2
		
			If Alltrim(SZ1->Z1_ESPECIE) <> ALLTRIM(MV_PAR02)
			
				SZ1->(DbSkip())		
				LOOP
				
			EndIf
			
		ElseIf MV_PAR05 == 1
		
			If Alltrim(SZ1->Z1_ESPECIE) <> "SATCE"
			
				SZ1->(DbSkip())		
				LOOP
				
			EndIf
			
		EndIf	
		
		If !EMPTY ( AllTrim( MV_PAR01 ) )
		
			If AllTrim( SZ1->Z1_CGC ) <> AllTrim( MV_PAR01 )
			
				SZ1->(DbSkip())
				loop
				
			EndIf
			
		EndIf
		
		If SZ1->Z1_EMISSAO < MV_PAR03 .OR. SZ1->Z1_EMISSAO > MV_PAR04
		
			SZ1->(DbSkip())
			LOOP
			
		EndIf
		
		_cFilial	:= SZ1->Z1_FILIAL
		_cDoc		:= SZ1->Z1_DOC
		_cSerie		:= SZ1->Z1_SERIE
		
		If SZ1->Z1_TIPO == 'N' .AND. alltrim(SZ1->Z1_ESPECIE) $ 'SPED|CTE'
				
			c_Fornece	:= POSICIONE("SA2",3,xfilial("SA2")+SZ1->Z1_CGC,"A2_COD")
			c_Loja 		:= POSICIONE("SA2",3,xfilial("SA2")+SZ1->Z1_CGC,"A2_LOJA")
					
		ElseIf SZ1->Z1_TIPO == 'D' .AND. SZ1->Z1_ESPECIE $ 'SPED '
				
			c_Fornece	:= POSICIONE("SA1",3,xfilial("SA1")+SZ1->Z1_CGC,"A1_COD")
			c_Loja 		:= POSICIONE("SA1",3,xfilial("SA1")+SZ1->Z1_CGC,"A1_LOJA")	
					
		EndIf
		
		If VerfNF( _cFilial,_cDoc,_cSerie,c_Fornece,c_Loja )
		
			SZ1->(DbSkip())
			loop
			
		EndIf
		
		aADD( aDocs,SZ1->(Recno() ) )
		SZ1->( DbSkip() )
		
	End	
	
	For nX = 1 to Len( aDocs )
	
		SZ1->( DbGoTo( aDocs[nX] ) )
		
		If AllTrim(SZ1->Z1_ESPECIE) $ "CTE/CTRC" //Entrada
		
			FWMsgRun( ,{ || U_GeraCte( SZ1->Z1_XML ) },"Processando a rotina...",'Processando NF: ' + SZ1->Z1_DOC )
			
		ElseIf AllTrim(SZ1->Z1_ESPECIE) $ "SPED" //Entrada
		
			FWMsgRun( ,{ || U_GeraNFe(SZ1->Z1_XML)},"Processando a rotina...",'Processando NF: ' + SZ1->Z1_DOC )
			
		ElseIf AllTrim(SZ1->Z1_ESPECIE) $ "SATCE|NFCE" //Saida
			
			FWMsgRun( ,{ || U_GeraCfe(SZ1->Z1_XML, SZ1->Z1_ESPECIE )},"Processando a rotina...",'Processando NF: ' + SZ1->Z1_DOC)
					
		EndIf
				
	Next
				
Else

	Conout("N�o foram encontrados registros para processar")
	
EndIf

Conout('Processo Finalizado')
	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerfNF  �                          o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     � Analisa se ja foi feita entrada da nota por outra Rotina   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VerfNF(_cFilial,_cDoc,_cSerie,c_Fornece,c_Loja )

Local lRet	:= .T.

DbSelectArea("SF1")
DbSetOrder(1)
If Dbseek(_cFilial+_cDoc+_cSerie+c_Fornece+c_Loja)	
	If EMPTY(SF1->F1_STATUS)	
		DbSelectArea("SZ1")
		RecLock("SZ1",.F.)
			SZ1->Z1_STATUS := "6"
		MsUnlock()		
	Else	
		DbSelectArea("SZ1")
		RecLock("SZ1",.F.)
			SZ1->Z1_STATUS := "3"
		MsUnlock()		
	EndIf	
Else
	DbSelectArea("SZ1")
	RecLock("SZ1",.F.)
		SZ1->Z1_STATUS := "0"
	MsUnlock()
	lRet := .F.	
EndIf
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CteCFOP �                          o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     � 															  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FuncTion CteCFOP(oXml,cXML,lCteproc)
Local cCF := ""

If lCteproc

	CONOUT(" CFOP CteProc...")
	n_Chave := AT("<CFOP>",cXML) // Verifica se foi informado a chave da NF-e na Origem

    If n_Chave > 0

		If Type("oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_CFOP") <> "U"

			cCF := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_CFOP:TEXT

		Else
		
			CONOUT(" CFOP CteProc... n�o encontrado - Estrutura")
		
		EndIf	
		
     Else
     
		CONOUT(" CFOP CteProc... n�o encontrado - TAG")
	
	EndIf
	
Else

	CONOUT(" CFOP CteProc... nao � CTE")

EndIf

Return cCF

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NfeCFOP �                          o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     � 															  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FuncTion NfeCFOP(oXml,cXml)

Local cCF := ""
Local aProd := {}

CONOUT(" CFOP Nfe")
n_Chave := AT("<CFOP>",cXML) // Verifica se foi informado CFOP no XML	

If n_Chave > 0

	If ValType(oXml:_NFEPROC:_NFE:_INFNFE:_DET) <> Nil
		
		aProd := oXml:_NFEPROC:_NFE:_INFNFE:_DET
		
		If ValType(aProd) == "A"
		
			cCF := aProd[1]:_PROD:_CFOP:TEXT
		
		Else
		
			cCF := aProd:_PROD:_CFOP:TEXT
		
		EndIf
	
	Else
	
		CONOUT(" CFOP NfeProc... n�o encontrado - Estrutura")
	
	EndIf	
	
Else

	CONOUT(" CFOP NfeProc... n�o encontrado - TAG")

EndIf

Return cCF

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DepSZ1 �                          o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     � 															  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DepSZ1()

Local c_Fornece	:= ""
Local c_Loja	:= ""

DbSelectArea("SZ1")
DbGoTop()

Do While !EOF()
	
	If SZ1->Z1_TIPO == 'N' .AND. alltrim(SZ1->Z1_ESPECIE) $ 'SPED|CTE'
		
		c_Fornece	:= POSICIONE("SA2",3,xfilial("SA2")+SZ1->Z1_CGC,"A2_COD")
		c_Loja 		:= POSICIONE("SA2",3,xfilial("SA2")+SZ1->Z1_CGC,"A2_LOJA")
		lENt		:= .T.
				
	ElseIf SZ1->Z1_TIPO == 'D' .AND. SZ1->Z1_ESPECIE $ 'SPED'
			
		c_Fornece	:= POSICIONE("SA1",3,xfilial("SA1")+SZ1->Z1_CGC,"A1_COD")
		c_Loja 		:= POSICIONE("SA1",3,xfilial("SA1")+SZ1->Z1_CGC,"A1_LOJA")
		lENt		:= .T.	
				
	EndIf
	
	FWMsgRun(,{|| VerfNF( SZ1->Z1_FILIAL,SZ1->Z1_DOC,SZ1->Z1_SERIE,c_Fornece,c_Loja )}, "Processando a rotina...",'Processando XML: ' + SZ1->Z1_CHAVE)
	SZ1->(DbSkip())
	
Enddo

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraCfe �                          o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     � 															  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GeraCfe(cXml,cEspecie)

Local errStr  		:= ""
Local warnStr 		:= ""
Local l_Saida 		:= .F.
Local l_Entrada		:= .F.
Local nQtd			:= 1
Local n_Reg			:= SZ1->(RECNO())
Local c_CGC			:= SZ1->Z1_CGC
Local _nBaseIcms	:= 0
Local lSat			:= .F.
Local c_RemCNPJ		:= ""
Local cProd   		:= ""
Local cDesCPrd		:= ""
Local nQtd    		:= 0
Local nVlUnit 		:= 0
Local nValMerc		:= 0
Local nTotMerc		:= 0	

_cFilial			:= SZ1->Z1_FILIAL
_cDoc				:= SZ1->Z1_DOC
_cSerie				:= SZ1->Z1_SERIE
CCHAVENFE			:= SZ1->Z1_CHAVE
cEspecie			:= SZ1->Z1_ESPECIE
x_NomeXml			:= SZ1->Z1_NOME
__xDtXml			:= SZ1->Z1_EMISSAO
oXml 				:= XmlParser ( cXML, "_", @errStr, @warnStr )

If alltrim(cEspecie) = "SATCE"

	cTag1 	:= "<infCte"
	cTag2 	:= "<CFe"
	lSat	:= .T.
	
Else

	cTag1 	:= "<infNfe"
	cTag2 	:= "<Nfe"
	
EndIf

cTipoNf		:= "N"
nPosTag1 	:= At(cTag1,cXML)
nPosTag2 	:= At(cTag2,cXML)
_c_Prod 	:= ""
xx 			:= "1"

// Checa Integridade do xml ctrc e a existencia das tags a serem lidas
If (nPosTag1 == 0 .And. nPosTag2 == 0) // .And. nPosTag5 > 0

	Conout("Nao foi possivel gerar Nota do CFE: "+cChaveNfe +" <CFE>.")
	RecLock("SZ1",.F.)
		SZ1->Z1_STATUS := "7" // estrutura
	MsUnlock()
	Return
	
EndIf

DbSelectArea("SA1")
DbSetOrder(3)

If DbSeek(xFilial("SA1") + c_CGC )

	cFornec := SA1->A1_COD
	cLoja   := SA1->A1_LOJA
	c_UFEmit:= SA1->A1_EST
	cNomeFor:= SA1->A1_NOME
	_cCPgto:= SA1->A1_COND
	
Else

	Conout("Cliente n�o encontrado. Favor cadastrar como Cliente: " + c_CGC )
	Return()
	
EndIf

If lSat

	c_RemCNPJ	:= oXml:_CFE:_INFCFE:_EMIT:_CNPJ:TEXT
	//XmlNode2Arr (oXml:_cFE:_INFCFE:_DET, "_DET")
	//VarItem 	:= aClone(oXml:_cFE:_INFCFE:_DET)
	 
Else //fazer ainda

EndIf

dbSelectArea("SM0")
nRegSM0 		:= SM0->( Recno() )
dbSetOrder(1)
SM0->( DbGoTop() )

If c_RemCNPJ == SM0->M0_CGC // Se remetente for a surya

	l_Saida := .T.
	_cEmp := SM0->M0_CODIGO
	_cFil := SM0->M0_CODFIL
	
EndIf

l_Saida := .T. //retirar
_cFil :=  "00"

If !l_Saida

	Conout("Remetente ou Destinario n�o pertence a empresa")
	RecLock("SZ1",.F.)
		SZ1->Z1_STATUS := "7" // estrutura
	MsUnlock()
	Return
	
Else

	If VALTYPE (oXml:_cFE:_INFCFE:_DET) == "A"//Len(VarItem) > 1
	
		xx := "1"
		_aItens   := {}
		//nVlrNF    := nValMerc / Len(aDocOrigem)
		//nValMerc  := nVlrNF
		
		For nI:= 1 To LEN (oXml:_cFE:_INFCFE:_DET) //Len(VarItem)
		
			cProd   	:= ALLTRIM ( oXml:_cFE:_INFCFE:_DET[nI]:_PROD:_CPROD:TEXT ) 		//ALLTRIM(VarItem[nI]:_PROD:_CPROD:TEXT)
			cProd   	:= Substr(cProd + SPACE(TAMSX3('A7_CODCLI')[1]-LEN(cProd)),1,TAMSX3('A7_CODCLI')[1])
			cDesCPrd	:= oXml:_cFE:_INFCFE:_DET[nI]:_PROD:_XPROD:TEXT 					//VarItem[nI]:_PROD:_XPROD:TEXT
			nQtd    	:= oXml:_cFE:_INFCFE:_DET[nI]:_PROD:_QCOM:TEXT						//VarItem[nI]:_PROD:_QCOM:TEXT
			nQtd    	:= Val(nQtd)
			nQtd    	:= If(nQtd == 0,1,nQtd)
			nVlUnit 	:= oXml:_cFE:_INFCFE:_DET[nI]:_PROD:_VUNCOM:TEXT					//VarItem[nI]:_PROD:_VUNCOM:TEXT
			nValMerc	:= oXml:_cFE:_INFCFE:_DET[nI]:_PROD:_VPROD:TEXT 					//VarItem[nI]:_PROD:_VPROD:TEXT
			nValMerc	:= Val(nValMerc)
			nTotMerc	+= nValMerc
			
			DbSelectArea("SA7")
			DbSetOrder(3) // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
			
			If ! DbSeek(xFilial("SA7") + cFornec + cLoja + alltrim(cProd) )
				
				If GeraSA7(cFornec,  cLoja,  cProd,  cDesCPrd ,_cFilial)
				
					DbSetOrder(3) // A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
					
					If ! DbSeek(xFilial("SA7") + cFornec + cLoja + cProd )
						DbSelectArea("SZ1")
						RecLock("SZ1",.F.)
							SZ1->Z1_STATUS := "4" // Depara
						MsUnlock()
						lDep := .F.
						Return
					
					Else
					
						If !EmpTy(A7_PRODUTO)				
							
							_cProd  := SA7->A7_PRODUTO
							Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",,,_cDoc,_cSerie})
							_lPrenota := .T.
							
						EndIf
							
					EndIf
					
				Else
							
					DbSelectArea("SZ1")
					RecLock("SZ1",.F.)
						SZ1->Z1_STATUS := "4" // Depara
					MsUnlock()
					lDep := .F.
					Return
					
				EndIf

			Else
				If ! EmpTy(A7_PRODUTO)
								
					_cProd  := SA7->A7_PRODUTO
					Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",,,_cDoc,_cSerie})
					_lPrenota := .T.
				
				Else
							
					DbSelectArea("SZ1")
					RecLock("SZ1",.F.)
						SZ1->Z1_STATUS := "4" // Depara
					MsUnlock()
					lDep := .F.
					Return
				
				EndIf
			
			EndIf						
		
		Next
	    
	    xx:= "1"
	    
	Else
	
		_aItens   	:= {}
		cProd   	:= ALLTRIM(oXml:_cFE:_INFCFE:_DET:_PROD:_CPROD:TEXT) 		//ALLTRIM(VarItem[1]:_PROD:_CPROD:TEXT)
		cProd   	:= Substr(cProd + SPACE(TAMSX3('A7_CODCLI')[1]-LEN(cProd)),1,TAMSX3('A7_CODCLI')[1])
		cDesCPrd	:= oXml:_cFE:_INFCFE:_DET:_PROD:_XPROD:TEXT 					//VarItem[1]:_PROD:_XPROD:TEXT
		nQtd    	:= oXml:_cFE:_INFCFE:_DET:_PROD:_QCOM:TEXT					//VarItem[1]:_PROD:_QCOM:TEXT
		nQtd    	:= Val(nQtd)
		nQtd    	:= If(nQtd ==0,1,nQtd)
		nVlUnit 	:= oXml:_cFE:_INFCFE:_DET:_PROD:_VUNCOM:TEXT					//VarItem[1]:_PROD:_VUNCOM:TEXT
		nValMerc	:= oXml:_cFE:_INFCFE:_DET:_PROD:_VPROD:TEXT					//VarItem[1]:_PROD:_VPROD:TEXT
		nValMerc	:= Val(nValMerc)
		nTotMerc	+= nValMerc
		
		DbSelectArea("SA7")
		DbSetOrder(3) // A7_FILIAL+A7_CLIENTE_LOJA+A7_CODCLI
		
		If ! DbSeek(xFilial("SA7") + cFornec + cLoja + alltrim(cProd) )
		
			If GeraSA7(cFornec,  cLoja,  cProd,  cDesCPrd ,_cFilial)
		
				DbSetOrder(3) // A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
		
				If ! DbSeek(xFilial("SA7") + cFornec + cLoja + cProd )
					DbSelectArea("SZ1")
					RecLock("SZ1",.F.)
						SZ1->Z1_STATUS := "4" // Depara
					MsUnlock()
					lDep := .F.
					Return
	
				Else
				
					If ! EmpTy(A7_PRODUTO)				
				
						_cProd  := SA7->A7_PRODUTO
				
						Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",,,_cDoc,_cSerie})
						_lPrenota := .T.
				
					EndIf	
				
				EndIf
				
			Else
						
				DbSelectArea("SZ1")
				RecLock("SZ1",.F.)
					SZ1->Z1_STATUS := "4" // Depara
				MsUnlock()
				lDep := .F.
				Return
			
			EndIf
			
		Else
		
			If ! EmpTy(A7_PRODUTO)				
				_cProd  := SA7->A7_PRODUTO
				Aadd(_aItens,{cTipoNf,cFornec,cLoja,_cProd,"","","","",nQtd,nVlUnit,nValMerc,"","",,,_cDoc,_cSerie})
				_lPrenota := .T.
		
			Else			
			
				DbSelectArea("SZ1")
			
				RecLock("SZ1",.F.)
			
					SZ1->Z1_STATUS := "4" // Depara
			
				MsUnlock()
				lDep := .F.
				Return
			
			EndIf			
		
		EndIf
		
	Endif
	
	lGeraReg :=  ProcDocS("N",_cFil, cFornec, cLoja,_cDoc,_cSerie,cChaveNfe,_aItens,__xDtXml,cEspecie,)

EndIf    

oXml := Nil
DelClassIntf()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcDocS �                         o � Data �  04/01/10     ���
�������������������������������������������������������������������������͹��
���Desc.     � 															  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcDocS(cTipo,_cFilial,_cCliente,_cLoja,_cDoc,_cSerie,cChaveNfe,_aItens,__xDtXml,cEspecie,cCFOP)

Local 	_lRet 			:= .T. 
Local 	_aLinha			:= {}
Local 	aItSD1			:= {}
Local 	nI 				:= 1       
Local 	_cNumItem 		:= ""
Local 	_cTes			:= SuperGetMV("SB_TESXLJ",.F.,"")
Local 	lNota			:= .F.
Local 	aCabec			:= {}
Local 	aItens			:= {}
Local 	cCond			:= ""

PRIVATE aRotina 		:= MenuDef2()
PRIVATE lMSErroAuto		:= .F.

cCond := Posicione("SA1",1,xfilial("SA1")+_cCliente+_cLoja,"A1_COND")

/*aadd(aCabec		,	{ "F2_TIPO"   		,cTipo			}	)
//aadd(aCabec,{"F2_FORMUL" ,"N"})
aadd(aCabec		,	{ "F2_DOC"    		,_cDoc			}	)
aadd(aCabec		,	{ "F2_SERIE"  		,_cSerie		}	)
aadd(aCabec		,	{ "F2_EMISSAO"		,__xDtXml		}	)
aadd(aCabec		,	{ "F2_CLIENTE"		,_cCliente		}	)
aadd(aCabec		,	{ "F2_LOJA"   		,_cLoja			}	)
aadd(aCabec		,	{ "F2_ESPECIE"		,cEspecie		}	)
aadd(aCabec		,	{ "F2_COND"			,cCond			}	)
//aadd(aCabec,{"F2_CHVNFE",cChaveNfe})*/

aadd(aCabec		,{ "F2_TIPO"   			, cTipo			} )
aadd(aCabec		,{ "F2_FORMUL" 			, "N"			} )
aadd(aCabec		,{ "F2_DOC"    			, (_cDoc)		} )
aadd(aCabec		,{ "F2_SERIE"  			, _cSerie		} )
aadd(aCabec		,{ "F2_EMISSAO"			, __xDtXml		} )
aadd(aCabec		,{ "F2_CLIENTE"			, _cCliente		} )
aadd(aCabec		,{ "F2_LOJA"   			, _cLoja		} )
aadd(aCabec		,{ "F2_ESPECIE"			, cEspecie		} )
aadd(aCabec		,{ "F2_COND"			, cCond			} )
aadd(aCabec		,{ "F2_DESCONT"			, 0				} )
aadd(aCabec		,{ "F2_FRETE"			, 0				} )
aadd(aCabec		,{ "F2_SEGURO"			, 0				} ) 
aadd(aCabec		,{ "F2_DESPESA"			, 0				} )

For nI := 1 To len(_aItens)

   	aItens 		:= {}
   	_cProd   	:= _aItens[nI][4]
   	_nQtd    	:= _aItens[nI][9]
   	_nValUni 	:= Val(_aItens[nI][10])
   	_cDoc 		:= _aItens[nI][16]
   	_cSerie		:= strZero(Val(_aItens[nI][17]),3)
   	_cFornece	:= _aItens[nI][2]
   	_cLoja		:= _aItens[nI][3]
   	_cCConta  	:= Posicione("SB1",1, xFilial("SB1") + _cProd,"B1_CONTA")
   	_cNaturez	:= Posicione("SA1",1, xFilial("SA1") + _cFornece+_cLoja,"A1_NATUREZ")
   	_cFilial	:= cFilAnt
   	_cCC     	:= Posicione("SB1",1, xFilial("SB1") + _cProd,"B1_CC")
	_cLocal  	:= "01"
	_cTes		:= MaTesInt(2,"01",_cCliente,_cLoja,If(cTipo$"DB","F","C"),_cProd)
	   
	aAdd( _aLinha,{ "D2_ITEM"		,StrZero(nI,2)				,Nil	}	)
	aAdd( _aLinha,{ "D2_COD"  		,_cProd						,Nil	}	)
	aAdd( _aLinha,{ "D2_QUANT"		,_nQtd						,Nil	}	)
	aAdd( _aLinha,{ "D2_PRCVEN"		,_nValUni					,Nil	}	)
	aAdd( _aLinha,{ "D2_TOTAL"		,Round(_nQtd*_nValUni,2)	,Nil	}	)	
	aAdd( _aLinha,{ "D2_LOCAL"		,_cLocal    				,Nil 	} 	) // Local  : Obrigatorio
	aAdd( _aLinha,{ "D2_TES"		,_cTes	    				,Nil	} 	) // TES	: Obrigatorio	
	
	//If !Empty(Alltrim(_cCC))
		//AAdd(_aLinha, {"D2_CCUSTO"	    ,_cCC       ,nil } ) // C.Custos 		 : Obrigatorio
	//EndIf	
	//aAdd(_aLinha, {"AUTDELETA"  ,"N"        ,Nil } ) // Incluir sempre no �ltimo elemento do array de cada item
	
	aAdd(aItens,_aLinha)
	
Next nI

//-- Teste de Inclusao
//MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItens,3) //Inclusao 
MATA920(aCabec,aItens)

IF !lMSErroAuto

	_cMsg := "Nota de Entrada gerada com sucesso: "
	_lRet := .T.
	
	If IsInCallStack("U_CPPRENFE")
	
		msgalert(_cMsg + _cDoc)
		
	Else
	
	 	CONOUT(_cMsg + _cDoc)
	 	
	EndIf
		 
	 If	SZ1->(RecLock("SZ1",.F.))
	 
		SZ1->Z1_STATUS := "8"
		SZ1->(MsUnlock())
		
	EndIf
	
Else

	DbSelectArea("SF2")
	DbSetOrder(2)  // F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC
	
	If DbSeek(xFilial("SF2") + _cFornece + _cLoja + _cDoc )
	
		_cMsg := "Nota de Entrada gerada com sucesso!"
		_lRet := .T.
		_cMsg += " Nf " +_cDoc
		
		If IsInCallStack("U_CPPRENFE")
		
		 	msgalert(_cMsg + _cDoc)
		 	
		Else
		
		 	CONOUT(_cMsg + _cDoc)
		 	
		EndIf
		
		If	SZ1->(RecLock("SZ1",.F.))
		
			SZ1->Z1_STATUS := "8"
			SZ1->(MsUnlock())
			
		EndIf
		
	Else
	
		Mostraerro()
		DisarmTransaction()      
		_lRet := .F.
		
		If	SZ1->(RecLock("SZ1",.F.))
		
			SZ1->Z1_STATUS := "7"
			SZ1->(MsUnlock())
			
		EndIf
		
	Endif
	
Endif

Return(.T.)


STATIC Function NFORIGDEV(oXml,cXML,_cProd,nQtd)
private a_DocDev := {}
private cQryDev := ""
private cAliasSD2 := GetNextAlias()

 aadd(a_DocDev,"xxx")

cQryDev := "SELECT D2_DOC [DOC], D2_SERIE [SERIE], D2_COD [PROD], D2_QUANT [QTD], D2_QTDEDEV [QTDDEV] "
cQryDev += "FROM " +RetSqlName("SD2")+" SD2 "
cQryDev += "WHERE SD2.D_E_L_E_T_ = '' "
cQryDev += "AND SD2.D2_FILIAL = '"+xFilial("SD2")+"' "
cQryDev += "AND (SELECT TOP 1 CONCAT(D2_DOC,D2_SERIE,D2_COD) FROM SD2030 SSD2 WHERE SSD2.D2_DOC = SD2.D2_DOC "
cQryDev += "			AND SSD2.D2_SERIE = SD2.D2_SERIE "
cQryDev += "			AND SSD2.D2_ITEM = SD2.D2_ITEM "
cQryDev += "			AND SSD2.D2_COD = SD2.D2_COD "
cQryDev += "			AND SSD2.D_E_L_E_T_ = '') IN ( "

n_Chave := AT("<infNFE><ide><NFref><refNFe",cXML) // Verifica se foi informado a chave da NF-e na Origem
IIF(n_Chave < 1, n_Chave := AT("<NFref><refNFe>",cXML),n_Chave := n_Chave)
IF n_Chave > 0
	IF (XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_IDE,"_NFREF") <> Nil)
		aRef := oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF
		IF VALTYPE(aRef) == "A"
			FOR nI := 1 to Len(aRef)
				cXMLNFRef := aRef[nI]:_REFNFE:TEXT

				cDocRef   := Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))
				cSerRef   := Alltrim(Substr(cXMLNfRef,23,3))
		
				cQryDev  += " '"+cDocRef+cSerRef+_cProd+"' "
				IF nI != Len(aRef)
					cQryDev += ", "
				ENDIF
			NEXT
		ELSE
			cXMLNFRef := oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT
			cDocRef   := Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))
			cSerRef   := AllTrim(Substr(cXMLNfRef,23,3))
			IF LEN(cDocRef) < 9
				for nZ := 1 to (9 - LEN(cDocRef))
					cDocRef := "0"+cDocRef
				next
			ENDIF
			cQryDev  += " '"+cDocRef+cSerRef+_cProd+"' "
		ENDIF
		cQryDev	+= ")"

		cQryDev := ChangeQuery(cQryDev)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryDev),cAliasSD2,.T.,.T.)
		dbSelectArea(cAliasSD2)
		While !(cAliasSD2)->(Eof())
			IF ((cAliasSD2)->QTDDEV + nQtd) <= (cAliasSD2)->QTD 
				a_DocDev[1] :=  (cAliasSD2)->DOC
				aadd(a_DocDev, (cAliasSD2)->SERIE)
				dbCloseArea()
				Return a_DocDev
			ELSE
				CONOUT("Quantidade devolvida superior ao documento original....")
			ENDIF
		END
	
	ELSE
		CONOUT("Tag de referência não existe....")
	ENDIF

ENDIF
dbCloseArea()
Return a_DocDev
