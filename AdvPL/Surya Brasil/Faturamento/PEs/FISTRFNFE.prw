#INCLUDE "DEFEMPSB.CH"
#INCLUDE "protheus.ch"
/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  � FISTRFNFE� Autor � Carlos Lima        � Data �  30/07/12   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escri噭o � Ponto de Entrada para impressao da CC-e.                   罕�
北�          � Layout nosso enquanto aguarda padrao da SEFAZ              罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       �                                                            罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

User Function FISTRFNFE()
aadd(aRotina,{'Monitor GNRE','u_xTsts' , 0 , 3,0,NIL})
aadd(aRotina,{'Imprime CC-e','U_CPRTCCE' , 0 , 3,0,NIL})
Return Nil              
User Function xTsts()
Private cUF := ""
Fisa095Mnt()
Return
/////////////////////////////////////////////
User Function CPRTCCE()
/////////////////////////////////////////////
#include "protheus.ch"
#include "rwmake.ch"
#include "font.ch"
#include "colors.ch"
#include "totvs.ch"
#Include "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPrintSetup.ch" 


Local   iw1,iw2,nLin
Local   xBitMap := "\system\FCSANTOS.bmp" //FisxLogo("1")     ///Logotipo da empresa
Local   MMEMO1  := MMEMO2 := ""
Local   xCGC    := "" 
Local   aArea   := GetArea()
Private cPerg   := "CPRNCCE   "

ValidPerg()

lRsp := Pergunte(cPerg,.T.)

IF ( !lRsp )
	Return
ENDIF

dbSelectArea("SF2")
dbSetOrder(1)
dbSeek(xFilial("SF2")+mv_par02+mv_par03)

cChvNfe  := SF2->F2_CHVNFE
dEmissao := SF2->F2_EMISSAO

IF ( EOF() .OR. EMPTY(cChvNfe) )
	MsgStop("Aten玢o! Nota Fiscal n鉶 existe ou Nota Fiscal Inutilizada.")
	RestArea(aArea)
	Return
ENDIF

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
xDestinatario := SA1->A1_NOME
IF ( !EMPTY(SA1->A1_CGC) )
	xCGC := IIF(LEN(SA1->A1_CGC) > 11 , TRANSF(SA1->A1_CGC,"@R 99.999.999/9999-99") , TRANSF(SA1->A1_CGC,"@R 999.999.999-99") )
ENDIF	

//////////////////////////////////////////////////////////////
Private _cTopAlias := "NFEFCSANTOS"         //DEFINI茿O DO SHEMA DE AMBIENTE ALIAS
Private _cTopDB    := "MSSQL"       //BANCO DE DADOS UTILIZADO
Private _cTopSrv   := "192.168.2.5" //= IP DO SERVIDOR
Private _cTopSrvN  := "192.168.2.5"
Private cTopServer
Private cTopAlias

cTop         := GetPvProfString("NFEFCSANTOS","TOPALIAS",_cTopAlias,GetAdv97())
cTopData     := GetPvProfString("MSSQL","TOPDATABASE",_cTopDB,GetAdv97())
cTopAlias    := cTopData + "/" + cTop              
cTopServer   := GetPvProfString("192.168.2.5","TOPSERVER",_cTopSrv,GetAdv97())

LjMsgRun("Conectando em " + cTopAlias + " " + cTopServer,,,)
TCConType("TCPIP")                                          
nCon := TCLINK(AllTrim(cTopAlias),AllTrim(cTopServer),7890)

If nCon < 0
     MsgStop("Erro conectando SPED: " + alltrim(Str(nCon)) + " - " + AllTrim(cTopAlias) + "-" + AllTrim(cTopServer))
     Return .f.
endif
//////////////////////////////////////////////////////////////



///
///TOP 1 - para pegar sempre a ultima carta de correcao da nf-e
///
cQry := "SELECT TOP 1 ID_EVENTO,TPEVENTO,SEQEVENTO,AMBIENTE,DATE_EVEN,TIME_EVEN,VERSAO,VEREVENTO,VERTPEVEN,VERAPLIC,CORGAO,CSTATEVEN,CMOTEVEN,"
cQry += "PROTOCOLO,NFE_CHV,ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),XML_ERP)),'') AS TMEMO1,"
cQry += "ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),XML_RET)),'') AS TMEMO2 "
cQry += "FROM SPED150 "
cQry += "WHERE D_E_L_E_T_ = ' ' AND STATUS = 6 "
cQry += "AND NFE_CHV = '"+cChvNfe+"' "
cQry += "ORDER BY LOTE DESC"

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

TcSetField("TMP","DATE_EVEN","D",08,0)

dbSelectArea("TMP")
dbGoTop()

IF ( EOF() )
	MsgStop("Aten玢o! N鉶 existe Carta de Corre玢o para a Nota Fiscal informada.")
	TMP->(dbCloseArea())
	RestArea(aArea)                                                    
	
	Return
ENDIF
	
MMEMO1     := TMP->TMEMO1     ///Relativo ao envio
MMEMO2     := TMP->TMEMO2     ///Retorno da SEFAZ
MNFE_CHV   := TMP->NFE_CHV
MID_EVENTO := TMP->ID_EVENTO
MTPEVENTO  := STR(TMP->TPEVENTO,6)
MSEQEVENTO := STR(TMP->SEQEVENTO,1)
MAMBIENTE  := STR(TMP->AMBIENTE,1)+IIF(TMP->AMBIENTE==1," - Produ玢o", IIF(TMP->AMBIENTE==2," - Homologa玢o" , ""))
MDATE_EVEN := DTOC(TMP->DATE_EVEN)
MTIME_EVEN := TMP->TIME_EVEN
MVERSAO    := STR(TMP->VERSAO,4,2)
MVEREVENTO := STR(TMP->VEREVENTO,4,2)
MVERTPEVEN := STR(TMP->VERTPEVEN,4,2)
MVERAPLIC  := TMP->VERAPLIC
MCORGAO    := STR(TMP->CORGAO,2)+IIF(TMP->CORGAO==13 , " - AMAZONAS",IIF(TMP->CORGAO==35 , " - SAO PAULO" , ""))
MCSTATEVEN := STR(TMP->CSTATEVEN,3)
MCMOTEVEN  := TMP->CMOTEVEN
MPROTOCOLO := STR(TMP->PROTOCOLO,15)

TMP->(dbCloseArea())

RestArea(aArea)

xFone := RTRIM(SM0->M0_TEL)
xFone := STRTRAN(xFone,"(","")
xFone := STRTRAN(xFone,")","")
xFone := STRTRAN(xFone,"-","")
xFone := STRTRAN(xFone," ","")
*
xFax := RTRIM(SM0->M0_FAX)
xFax := STRTRAN(xFax,"(","")
xFax := STRTRAN(xFax,")","")
xFax := STRTRAN(xFax,"-","")
xFax := STRTRAN(xFax," ","")
	
xRazSoc := RTRIM(SM0->M0_NOMECOM)
xEnder  := RTRIM(SM0->M0_ENDENT) + " - " + RTRIM(SM0->M0_BAIRENT) + " - " + RTRIM(SM0->M0_CIDENT) + "/" + SM0->M0_ESTENT
xFone   := "Fone / Fax: " + TRANSF(xFone,"@R (99)9999-9999") + IIF(!EMPTY(SM0->M0_FAX) , " / " + TRANSF(xFax,"@R (99)9999-9999") , "" )
xCnpj   := "C.N.P.J.: " + TRANSF(SM0->M0_CGC,"@R 99.999.999/9999-99")
xIE     := "I.Estadual: "+SM0->M0_INSC

////
////Extrai dados do Memo
////
MDHEVENTO := ""
iw1 := AT("<dhRegEvento>" , MMEMO2 )
iw2 := AT("</dhRegEvento>" , MMEMO2 )
IF ( iw1 > 0 )
	iw3 := ( iw2 - iw1 )
	MDHEVENTO += SUBS(MMEMO2 , ( iw1+13 ) , ( iw2 - ( iw1 + 13 ) ) )
ENDIF
*
MDESCEVEN := ""
iw1 := AT("<xEvento>" , MMEMO2 )
iw2 := AT("</xEvento>" , MMEMO2 )
IF ( iw1 > 0 )
	iw3 := ( iw2 - iw1 )
	MDESCEVEN += SUBS(MMEMO2 , ( iw1+9 ) , ( iw2 - ( iw1 + 9 ) ) )
ENDIF
*
aCorrec   := {}
MCORRECAO := ""
iw1 := AT("<xCorrecao>" , MMEMO1 )
iw2 := AT("</xCorrecao>" , MMEMO1 )
IF ( iw1 > 0 )
	iw3 := ( iw2 - iw1 )
	MCORRECAO += SUBS(MMEMO1 , ( iw1+11 ) , ( iw2 - ( iw1 + 11 ) ) ) 
	MCORRECAO += SPACE(10)
	iw1 := 1
	DO WHILE !EMPTY(SUBS(MCORRECAO,iw1,10))
		AADD(aCorrec , SUBS(MCORRECAO,iw1,105) )
		iw1 += 105     ///Nro de caracteres da linha - fica a criterio
	ENDDO
ENDIF
*
aCondic   := {}
MCONDICAO := ""
iw1 := AT("<xCondUso>" , MMEMO1 )
iw2 := AT("</xCondUso>" , MMEMO1 )
IF ( iw1 > 0 )
	///As linha comentadas abaixo retirei pois nao achei bom qdo impressa
	///
	///iw3 := ( iw2 - iw1 )
	///MCONDICAO += SUBS(MMEMO1 , ( iw1+10 ) , ( iw2 - ( iw1 + 10 ) ) )
	///MCONDICAO += SPACE(10)
	///iw1 := 1
	///DO WHILE !EMPTY(SUBS(MCONDICAO,iw1,10))
	///	AADD(aCondic , SUBS(MCONDICAO,iw1,137) )  
	///	iw1 += 137     ///Nro de caracteres da linha
	///ENDDO
	AADD(aCondic , "A Carta de Correcao e disciplinada pelo paragrafo 1o-A do art. 7o do Convenio S/N, de 15 de dezembro de 1970 e pode ser utilizada para" )
	AADD(aCondic , "regularizacao  de  erro ocorrido na  emissao de  documento  fiscal, desde que o erro nao esteja relacionado com:  I - as variaveis que" )
	AADD(aCondic , "determinam o valor do imposto tais como: base de calculo, aliquota, diferenca de preco, quantidade, valor da operacao ou da prestacao;" )
	AADD(aCondic , "II - a correcao de dados cadastrais que implique mudanca do remetente ou do destinatario; III - a data de emissao ou de saida.        " )
ENDIF


// Cria um novo objeto para impressao
oPrint := TMSPrinter():New("Impress鉶 da Carta de Corre玢o Eletronica - CC-e")

// Cria os objetos com as configuracoes das fontes
//                                              Negrito  Subl  Italico
oFont08  := TFont():New( "Times New Roman",,08,,.f.,,,,,.f.,.f. )
oFont08b := TFont():New( "Times New Roman",,08,,.t.,,,,,.f.,.f. )
oFont09  := TFont():New( "Times New Roman",,09,,.f.,,,,,.f.,.f. )
oFont10  := TFont():New( "Times New Roman",,10,,.f.,,,,,.f.,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f.,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f.,.f. )
oFont11  := TFont():New( "Times New Roman",,11,,.f.,,,,,.f.,.f. )
oFont11b := TFont():New( "Times New Roman",,11,,.t.,,,,,.f.,.f. )
oFont12  := TFont():New( "Times New Roman",,12,,.f.,,,,,.f.,.f. )
oFont12b := TFont():New( "Times New Roman",,12,,.t.,,,,,.f.,.f. )
oFont13b := TFont():New( "Times New Roman",,13,,.t.,,,,,.f.,.f. )
oFont14  := TFont():New( "Times New Roman",,14,,.f.,,,,,.f.,.f. )
oFont24b := TFont():New( "Times New Roman",,24,,.t.,,,,,.f.,.f. )

// Mostra a tela de Setup
oPrint:Setup()

oPrint:SetPortrait()
oPrint:SetPaperSize(9)       ///(DMPAPER_A4)
   
// Inicia uma nova pagina
oPrint:StartPage()

oPrint:SetFont(oFont24b)
oPrint:SayBitMap(100,116,xBitMap,600,280)

oPrint:Say(120,780,xRazSoc,oFont11b ,140)
oPrint:Say(180,780,xEnder,oFont11 ,140)
oPrint:Say(230,780,xFone,oFont11 ,140)
oPrint:Say(280,780,xCnpj,oFont11 ,140)
oPrint:Say(330,780,xIE,oFont11 ,140)
*
oPrint:Box(100,1890,390,2400)

oPrint:Line(150,1890,150,2400)
oPrint:Say(104,2020,"Carta de Corre玢o",oFont11b ,160)
oPrint:Say(170,1920,"S閞ie: "+mv_par01,oFont11b ,100)
oPrint:Say(240,1920,"N.Fiscal: "+mv_par02,oFont11b ,100)
oPrint:Say(310,1920,"Dt.Emiss鉶: "+DTOC(dEmissao),oFont11b ,100)

oPrint:Box(420,100,2000,2400)

oPrint:Say(440,110,"Tipo do evento",oFont12b ,100)
oPrint:Say(440,850,"Data e hora",oFont12b ,100)
oPrint:Say(440,1890,"Protocolo",oFont12b ,100)
oPrint:Say(490,110,"Carta de Corre玢o NFe",oFont11 ,100)
oPrint:Say(490,850,MDATE_EVEN+"  "+MTIME_EVEN,oFont11 ,140)
oPrint:Say(490,1890,MPROTOCOLO,oFont11 ,140)

oPrint:Say(580,110,"Identifica玢o do destinat醨io",oFont11b ,200)
oPrint:Say(580,1430,"CNPJ/CPF",oFont11b ,200)
oPrint:Say(630,110,xDestinatario,oFont11b ,800)
oPrint:Say(630,1430,xCGC,oFont11b ,260)

oPrint:Say(740,110,"DADOS DO EVENTO DA CARTA DE CORRE敲O",oFont11b ,250)
oPrint:Say(800,110,"Vers鉶 do evento",oFont11b ,100)
oPrint:Say(800,670,"Id evento",oFont11b ,100)
oPrint:Say(800,1890,"Tipo do evento",oFont11b ,100)
oPrint:Say(850,110,MVERSAO,oFont11 ,80)
oPrint:Say(850,670,MID_EVENTO,oFont11 ,400)
oPrint:Say(850,1890,MTPEVENTO,oFont11 ,120)

oPrint:Say(940,110,"Identifica玢o do ambiente",oFont11b ,140)
oPrint:Say(940,670,"C骴igo do 髍g鉶 de recep玢o do evento",oFont11b ,240)
oPrint:Say(940,1430,"Chave de acesso da NF-e vinculada ao evento",oFont11b ,250)
oPrint:Say(990,110,MAMBIENTE,oFont11 ,80)
oPrint:Say(990,670,MCORGAO,oFont11 ,240)
oPrint:Say(990,1430,MNFE_CHV,oFont11 ,880)

oPrint:Say(1050,110,"Data e hora do recebimento do evento",oFont11b ,400)
oPrint:Say(1050,1430,"Sequencial do evento",oFont11b ,100)
oPrint:Say(1050,1890,"Vers鉶 do tipo do evento",oFont11b ,200)
oPrint:Say(1100,110,MDHEVENTO,oFont11 ,200)
oPrint:Say(1100,1430,MSEQEVENTO,oFont11 ,20)
oPrint:Say(1100,1890,MVERTPEVEN,oFont11 ,200)

oPrint:Say(1170,110,"Vers鉶 do aplicativo que",oFont11b ,100)
oPrint:Say(1210,110,"recebeu o evento",oFont11b ,100)
oPrint:Say(1170,670,"C骴igo de status do registro do evento",oFont11b ,300)
oPrint:Say(1170,1430,"Descri玢o literal do status de registro do evento",oFont11b ,300)
oPrint:Say(1260,110,MVERAPLIC,oFont11 ,80)
oPrint:Say(1220,670,MCSTATEVEN,oFont11 ,60)
oPrint:Say(1220,1430,MCMOTEVEN,oFont11 ,300)

oPrint:Say(1340,110,"Descri玢o do evento",oFont11b ,100)
oPrint:Say(1390,110,MDESCEVEN,oFont11 ,100)

///
///Deixei um gap de 4 linhas para o texto - se o texto for maior ter� que alterar a linha onde comeca a Condicao de Uso
///
oPrint:Say(1450,110,"Texto da Carta de Corre玢o",oFont11b ,300)
nLin := 1450
FOR iw1:=1 TO LEN(aCorrec)
	 nLin += 50
	 oPrint:Say(nLin,110,aCorrec[iw1],oFont11 ,2000)
NEXT
*
oPrint:Say(1700,110,"Condi珲es de uso",oFont11b ,100)

nLin := 1700
FOR iw2:=1 TO LEN(aCondic)
	 nLin += 50
	 oPrint:Say(nLin,110,aCondic[iw2],oFont11 ,2000)
NEXT

oPrint:EndPage()

oPrint:Preview()

Return .F. 

/////////////////////////////////////////////////////////
Static Function ValidPerg()
/////////////////////////////////////////////////////////
   _sAlias := Alias()
   DbSelectArea("SX1")
   DbSetOrder(1)
   aRegs :={} //Grupo|Ordem| Pegunt                         | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01          | DefSPA1 | DefEng1 | CNT01 | var02 | Def02           | DefSPA2 | DefEng2 | CNT02 | var03 | Def03    | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
   aAdd(aRegs,{ cPerg,"01" , "S閞ie                       ?",   ""   ,  ""    , "mv_ch1" , "C" ,   03   ,   0   ,   0   , "G" , "          "  , "mv_par01", "            " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"02" , "Nota Fiscal                 ?",   ""   ,  ""    , "mv_ch2" , "C" ,   09   ,   0   ,   0   , "G" , "          "  , "mv_par02", "            " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   	For i:=1 to Len(aRegs)
			If !DbSeek(cPerg+aRegs[i,2])
				RecLock("SX1",.T.)
				For j:=1 to FCount()
					If j <= Len(aRegs[i])
						FieldPut(j,aRegs[i,j])
					Endif
				Next
				MsUnlock()
			Endif
		Next
		dbSelectArea(_sAlias)
Return