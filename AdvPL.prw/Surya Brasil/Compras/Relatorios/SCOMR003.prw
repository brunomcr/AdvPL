#INCLUDE "RWMAKE.CH"
#INCLUDE "protheus.ch"                                                                          
#INCLUDE "topconn.ch" 
#INCLUDE "TBICONN.CH"                                                                           

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Impress„o de Etiquetas (Imnpressora Zebra) SEDEX e SEDEX PAC
<Data>      : 25/10/2018
<Roina>		: SCOMR003
<Parametros>: Nenhum
<Retorno>   : Nenhum
<Processo>  : Surya Brasil
<Tipo> (Etiqueta ) : G
<Autor>     : Renan Rosario
<Obs>       :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
User Function SCOMR003()

Local aArea 	  := GetArea()
Local oPar        := NIL
Local oDesc		  := NIL
Local oCodigo	  := NIL
Local oSerie	  := NIL
Local oGrpPar	  := NIL
Local lRet 		  := .F.

Private cNota	  := Space(9) 
Private cSerie	  := Space(3)

DEFINE MSDIALOG oPar TITLE "Impress„o de Etiquetas em Impressora Zebra" FROM 000, 000  TO 190, 320 PIXEL STYLE DS_MODALFRAME
	
@ 005, 005 GROUP oGrpPar TO 090, 160 PROMPT "Informe o N˙mero da Nota a ser Impressa" OF oPar PIXEL

@ 015, 015 SAY oDesc PROMPT "N∞ da NOTA"  SIZE 030, 010  OF oPar PIXEL
@ 015, 050 MSGET oCodigo VAR cNota PICTURE "@!" F3 'SF2_ET' SIZE 038, 010  OF oPar PIXEL  
@ 035, 015 SAY oDesc PROMPT "Serie Nota" SIZE 030, 010  OF oPar PIXEL
@ 035, 050 MSGET oSerie VAR cSerie PICTURE "@!" SIZE 038, 010  WHEN .F. OF oPar PIXEL   
  
@ 014, 115 BMPBUTTON TYPE 01 ACTION lRet:=ETIQTELA(cNota, cSerie) 
@ 029, 115 BMPBUTTON TYPE 02 ACTION Close(oPar) 

oPar:lEscClose:=.F.
ACTIVATE MSDIALOG oPar CENTERED  

Return
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Funcao>: ETIQTELA
<Descricao> : Imprime a Etiqueta em Zebra
<Autor> : Renan Ros·rio
<Data> : 26/10/18
<Parametros> : Nil
<Retorno> : Nil
<Processo> : Compras
<Tipo> : 
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Static Function ETIQTELA(cNota, cSerie)
                        	
Local cPorta	:= "LPT3"     
Local aEtique   := {}
Local nX        := 0
Local nQuant	:= 0
Local nVolume	:= 0
Local _cModelo	:= "GC420t"

Default cNota	:= ""
Default cSerie	:= ""

aEtique 		:= ETIQARRY(cNota, cSerie)

If !Empty ( aEtique )
	
	nVolume			:= aEtique[1][12]

EndIf	

For nX := 1 to nVolume
//While nVolume > nQuant
    
	MSCBPRINTER ( _cModelo, cPorta,,120, .F.,,,,,, .T. )
	//MSCBCHKSTATUS(.F.)
	//MSCBINFOETI ( "Etiqueta SEDEX", "MODELO SEDEX" )
	MSCBBEGIN( 1 , 6 )
	     
	//MSCBGRAFIC( 06 ,10 ,"SIGA" )		//Logo AXT
	//MSCBGRAFIC( 06 ,10 ,"SIGA" )		// Logo SEDEX/PAC
	MSCBBOX( 2, 1, 138, 71, 5 )
	     
	MSCBSAY( 12.00, 03.00, AllTrim ( SM0->M0_NOMECOM )				,"N"	,"B"	,"20"	,.T.	)
	     
	//Dados de Cliente
	//MSCBBOX( 2, 10, 130, 90, 5 )
	MSCBSAY( 05.00, 11.00, "Dados do CLiente"						,"N"	,"E"	,"18,0"	,.T.	)
	MSCBSAY( 05.00, 18.00, "Nome Cliente: " +aEtique[1][2]			,"N"	,"C"	,"13,4"	,.T.	)
	MSCBSAY( 05.00, 23.00, "EndereÁo: "+aEtique[1][3]				,"N"	,"C"	,"13,4"	,.T.	)
	MSCBSAY( 100.00,23.00, "Estado: "+aEtique[1][4]					,"N"	,"C"	,"13,4"	,.T.	)
	MSCBSAY( 05.00, 28.00, "Bairro: "+aEtique[1][6]					,"N"	,"C"	,"13,4"	,.T.	)
	MSCBSAY( 60.00, 28.00, "MunicÌpio: "+aEtique[1][5]				,"N"	,"C"	,"13,4"	,.T.	)
	MSCBSAY( 110.00,28.00, "Cep: "+aEtique[1][7]					,"N"	,"C"	,"13,4"	,.T.	)
	MSCBSAY( 05.00, 33.00, "DDD: "+aEtique[1][8]					,"N"	,"C"	,"13,4"	,.T.	)
	MSCBSAY( 25.00, 33.00, "Telefone: "+aEtique[1][9]				,"N"	,"C"	,"13,4"	,.T.	)           
	    
	//MSCBSAYBAR( 06, 24.50, AllTrim(aEtique[nX][10]),'N','MB07',06,.F.,.F.,,,2,2) //Numero de Postagem Codigo de Barraas
	     
	//Dados de Nota/Pedido
	//MSCBBOX( 2, 1, 130, 90, 5 )
	MSCBSAY( 05.00, 40.00, "Dados da Nota"							,"N"	,"E"	,"18,4"	,.T.	)
	MSCBSAY( 05.00, 47.00, "N˙mero da Nota: "+aEtique[1][10]		,"N"	,"C"	,"13,4"	,.T.	)
	MSCBSAY( 65.00, 47.00, "Serie: "+aEtique[1][11]					,"N"	,"C"	,"13,4"	,.T.	)
	MSCBSAY( 100.00, 47.00,"Pedido: "+aEtique[1][14]				,"N"	,"C"	,"13,4"	,.T.	)
	    
	//Dados de Transportadora
	MSCBSAY( 05.00,52.00,"Transportadora: "+aEtique[1][15]			,"N"	,"C"	,"13,4"	,.T.	)
	    	     
	//MSCBSAYBAR(08,50.00,AllTrim(aEtique[nX][6]),'N','MB07',06,.F.,.F.,,,2,2) //CEP em Barras
	   
	//Dados de Volume
	nQuant ++

	//MSCBBOX( 2, 1, 130, 90, 5 )
	MSCBSAY( 05.00,57.00,"Dados de Volume"														,"N"	,"E"	,"18,0"	,.T.	)
	MSCBSAY( 05.00,63.00,"Quantidade: "+ StrZero(nQuant , 3) +"/"+StrZero(aEtique[1][12] , 3)	,"N"	,"C"	,"13,4"	,.T.	)
	MSCBSAY( 60.00,63.00,"EspÈcie: "+ aEtique[1][13] 											,"N"	,"C"	,"13,4"	,.T.	)               
	
	//MSCBLineH( 01, 12.00, 50, 2 )
	//MSCBLineH( 01, 35.00, 50, 2 )
	MSCBEND()
	MSCBCLOSEPRINTER()
	    
Next nX
//EndDo

/*If !Empty ( aEtique )

	MSCBCLOSEPRINTER()

Else*/
If Empty ( aEtique )
	
	MsgAlert( "Nota n„o encontrada." )
		
EndIf

Return

/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Funcao>: ETIQARRY
<Descricao> : CustomizaÁ„o da Barra de FunÁıes Venda Assistida (SIGALOJA)
<Autor> : Renan Ros·rio
<Data> : 26/10/18
<Parametros> : Nil
<Retorno> : Nil
<Processo> : Compras
<Tipo> : 
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Static Function ETIQARRY(cNota, cSerie) 

Local cQuery	:= ""
Local aDADOS    := {}
Local ARQTRB    := ""

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Selecionando dados com Query       ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cQuery := " SELECT DISTINCT SC5.C5_TRANSP, SA4.A4_NOME DESC_TRANS, SA1.A1_NOME NOMECLI, SA1.A1_END ENDERECO,				" +CRLF
cQuery += "		SA1.A1_EST ESTADO,SA1.A1_MUN MUNICIPIO, SA1.A1_BAIRRO BAIRRO, SA1.A1_CEP CEP, SA1.A1_DDD DDD,				" +CRLF
cQuery += "		SA1.A1_TEL TELEFONE, SF2.F2_DOC NOTA, SF2.F2_SERIE SERIE, SF2.F2_VOLUME1 VOLOUME, SF2.F2_ESPECI1 ESPECIE,	" +CRLF
cQuery += "		SC6.C6_NUM PEDIDO, SF2.F2_FILIAL FILIAL																		" +CRLF

cQuery += " FROM "+RetSqlName("SF2")+" SF2								" +CRLF

cQuery += " INNER JOIN  "+RetSqlName("SA1")+"  SA1 ON 					" +CRLF
cQuery += " 	SA1.A1_COD			= SF2.F2_CLIENTE					" +CRLF
cQuery += " 	AND SA1.A1_LOJA		= SF2.F2_LOJA						" +CRLF
cQuery += " 	AND SA1.D_E_L_E_T_	<> '*'								" +CRLF

cQuery+=" INNER JOIN  "+RetSqlName("SC6")+"  SC6 ON 					" +CRLF
cQuery+="		SC6.C6_NOTA			= SF2.F2_DOC						" +CRLF
cQuery+="		AND SC6.C6_FILIAL	= SF2.F2_FILIAL						" +CRLF
cQuery+="		AND SC6.C6_SERIE	= SF2.F2_SERIE						" +CRLF
cQuery+="		AND SC6.D_E_L_E_T_	<> '*'								" +CRLF

cQuery+=" INNER JOIN  "+RetSqlName("SC5")+"  SC5 ON 					" +CRLF
cQuery+="		SC5.C5_NUM			= SC6.C6_NUM						" +CRLF
cQuery+="		AND SC5.C5_FILIAL	= SC6.C6_FILIAL						" +CRLF
cQuery+="		AND SC5.D_E_L_E_T_	<> '*'								" +CRLF

cQuery+=" INNER JOIN  "+RetSqlName("SA4")+"  SA4 ON 					" +CRLF
cQuery+="		SA4.A4_COD			= SC5.C5_TRANSP						" +CRLF
cQuery+="		AND SA4.D_E_L_E_T_ <> '*'								" +CRLF

cQuery+=" WHERE SF2.D_E_L_E_T_ <> '*'									" +CRLF
cQuery+="		AND SF2.F2_DOC 		= '"+ AllTrim ( cNota ) +"'			" +CRLF
cQuery+="		AND SF2.F2_SERIE 	= '"+ AllTrim ( cSerie ) +"'		" +CRLF
  
cQuery := CHANGEQUERY(cQuery)	
ARQTRB := GetNextAlias()

If Select(ARQTRB) >0

	dbSelectArea(ARQTRB)
    dbCloseArea()
    
EndIf

dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cQuery) ,ARQTRB, .T., .F.)

DbSelectArea(ARQTRB)
(ARQTRB)->(DbGoTop())

                                                                     
DBSelectArea((ARQTRB)) 	//ABRE O ARQUIVO TEMPORARIO
dbGoTop()             	// ALINHA NO PRIMEIRO REGISTRO

While (ARQTRB)->(!EOF())
  
        aAdd(aDADOS,{   (ARQTRB)->FILIAL		,;
        				(ARQTRB)->NOMECLI		,;     				
        				(ARQTRB)->ENDERECO		,;
        				(ARQTRB)->ESTADO 		,;
        				(ARQTRB)->MUNICIPIO		,;
        				(ARQTRB)->BAIRRO		,;
        				(ARQTRB)->CEP			,; 
        				(ARQTRB)->DDD			,;
        				(ARQTRB)->TELEFONE		,;
        				(ARQTRB)->NOTA			,;
        				(ARQTRB)->SERIE			,;
        				(ARQTRB)->VOLOUME		,;
        				(ARQTRB)->ESPECIE		,;
        				(ARQTRB)->PEDIDO		,;
        				(ARQTRB)->DESC_TRANS	})

		(ARQTRB)->(dbSkip()) //PULA PARA O PROXIMO REGISTRO DO ARQUIVO TEMPORARIO
		   	
EndDo

Return (aDADOS)  