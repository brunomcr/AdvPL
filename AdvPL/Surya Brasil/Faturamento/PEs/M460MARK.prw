//Bibliotecas
#Include 'RwMake.ch'
#Include 'Protheus.ch'
#Include 'TopConn.ch'
#INCLUDE "DEFEMPSB.CH"
 
//Constantes
#Define STR_PULA        Chr(13)+Chr(10)
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  M460MARK                                                                                      |
 | Desc:  Não permite usuário marcar registros para faturar, caso o pedido tenha remessa                |
 | Links: http://tdn.totvs.com/pages/releaseview.actionçpageId=6784189                                  |
 *------------------------------------------------------------------------------------------------------*/
  
User Function M460MARK()
Local aArea        	:= GetArea()
Local aAreaC9    	:= SC9->(GetArea())
Local aAreaC5    	:= SC5->(GetArea())
Local lRet       	 	:= .T.   
Local cMarca    		:= ParamIXB[1]
Local lInverte    		:= ParamIXB[2]
Local cSQL        	:= ""
Local cMens        	:= ""
Local cMensBoni 	:= ""
Local cMensAux 	:= ""
Local cPedsMark 	:= "" 
Local cItem			:= ""   
Local lValP			:= .F.   
Local lItem				:= .F.
Local lEst				:= .F.
Local lDup				:= .F.
Local cSerie			:= ParamIXB[3]
Local cPedido		:= ""   
Local cVale			:= alltrim(SuperGetMv("FC_CODVP",.F.,"VALEPRESENTE"))

     
return(lRet)     
/*Pergunte("MT461A", .F.)
     
//Criando a consulta
cSQL += " SELECT "                                                                                                            					+ STR_PULA
cSQL += "  C9_PEDIDO AS PEDIDO, C9_PRODUTO AS PRODUTO,F4_DUPLIC AS DUPL,F4_ESTOQUE AS ESTOQUE"	     			+ STR_PULA
cSQL += " FROM "+RetSQLName("SC9")+" SC9 "                                                                          			+ STR_PULA
cSQL += "   INNER JOIN "+RetSQLName("SC6")+" SC6 ON ("                                                         			+ STR_PULA
cSQL += "   SC6.D_E_L_E_T_='' " + STR_PULA
cSQL += "   AND C6_FILIAL = C9_FILIAL AND C6_PRODUTO = C9_PRODUTO  " + STR_PULA
cSQL += "   AND C6_NUM = C9_PEDIDO AND C6_ITEM = C9_ITEM  " + STR_PULA
cSQL += "   ) "                                                                                          
cSQL += "   INNER JOIN SF4030 SF4 ON (    " + STR_PULA
cSQL += "   SF4.D_E_L_E_T_ = '' " + STR_PULA
cSQL += "   AND C6_TES = F4_CODIGO " + STR_PULA
cSQL += "   ) "                                                                                                               + STR_PULA
cSQL += " WHERE SC9.D_E_L_E_T_ = '' "                                                                                     + STR_PULA
cSQL += "  AND C9_FILIAL='"+FWxFilial("SC9")+"' "                                                                        + STR_PULA
cSQL += "  AND C9_OK"+Iif(lInverte, "<>", "=")+ "'"+cMarca+"' "                                                        + STR_PULA
cSQL += "  AND C9_CLIENTE >= '" + MV_PAR07 + "' AND C9_CLIENTE <= '" + MV_PAR08 + "' "                                + STR_PULA
cSQL += "  AND C9_LOJA >= '" + MV_PAR09 + "' AND C9_LOJA <= '" + MV_PAR10 + "' "                                        + STR_PULA
cSQL += "  AND C9_DATALIB >= '" + DTOS(MV_PAR11) + "' AND C9_DATALIB <= '" + DTOS(MV_PAR12) + "' "                + STR_PULA
cSQL += "  AND C9_PEDIDO >= '" + MV_PAR05 + "' AND C9_PEDIDO <= '" + MV_PAR06 + "' "                                + STR_PULA
cSQL += "  AND C9_BLEST = '' AND C9_BLCRED = ''"                                                                            + STR_PULA  
cSQL := ChangeQuery(cSQL)   
//Executando a Cláusula
//TCQuery cSQL NEW ALIAS QRY_SC9    
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"QRY_SC9",.T.,.T.)
//Indo ao top e verificando se há registros
QRY_SC9->(DbGoTop())
Do while !QRY_SC9->(Eof())
	If FC = cEmpAnt
		cItem := QRY_SC9->(PRODUTO)
		if alltrim(cItem) == cVale
			lValP 	:=	.T.  
			if QRY_SC9->(ESTOQUE) == "S"
		  		lEst		:= .T.     
		 	endif 
		 	if QRY_SC9->(DUPL) == "S"
		  		lDup		:= .T.
		 	endif		
		Else
			lItem	:= .T.
		Endif
	endif
	DbSelectArea("FIE")
	DbSetOrder(1)
	if DbSeek(xFilial("FIE")+'R'+SC9->C9_PEDIDO)
		DbSelectArea("SE1")
		DbSetOrder(1)
		if Dbseek(xFilial("SE1")+FIE_PREFIX+FIE_NUM+FIE_PARCEL+FIE_TIPO)
			IF FIE->(Reclock("FIE",.F.))
				Replace FIE->FIE_VALOR with SE1->E1_VALOR
				FIE->(MsUnlock())
			endif
		endif
	Endif
	QRY_SC9->(Dbskip())
Enddo  
QRY_SC9->(DbCloseArea())
If FC = cEmpAnt
	if lValP .And. lItem
		lRet := .F. 
		MsgAlert("Vale Presente e Produto Acabado selecionados para faturar na mesma nota"+ STR_PULA + ;
						"Favor Separar a marcação" ,"PEDIDO COM VALE-PRESENTE")
		Return lRet
	Endif 
	If lValP .And. alltrim(cSerie) <> "UNI"
		lRet := .F. 
		MsgAlert("Vale Presente deve ser faturado exclusivamente com a serie UNI" ,"PEDIDO COM VALE-PRESENTE")	
		Return lRet
	Endif 
	If lValP .And. lEst
		lRet := .F. 
		MsgAlert("TES para vale-presente nao deve gerar estoque" ,"PEDIDO COM VALE-PRESENTE")	
		Return lRet
	Endif   
Endif 
RestArea(aAreaC5)
RestArea(aAreaC9)
RestArea(aArea)*/
     
//Restaurando a pergunta do botão Prep.Doc.
//Pergunte("MT460A", .F.) 
//Return lRet