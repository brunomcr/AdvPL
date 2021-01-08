#include "protheus.ch"
#include 'FILEIO.CH'
#INCLUDE "DEFEMPSB.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.  ³ FT080MRN º Uso ³ Surya Brasil º Modulo ³ SIGAFAT º Data ³ 08/05/17 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³  PE para inclusão da tabela de desconto automatica a partir de um  º±±
±±º       ³  arquivo csv. Deve-se entrar na tela e incluir o cabeçalho.        º±±
±±º       ³  Depois em acoes relacionadas para importar o arquivo 			   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor ³ Caio de Paula             º Contato ³(11) 98346-3154               º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FT080MRN
Local aRet := {}
Local oGetdados := PARAMIXB[1]
	aAdd(aRet, {'Importa Tab. Desc',{|| GFATA01(oGetdados)},"Importação de Itens de Regra de Desconto","Importa Itens"} )
Return aRet

Static Function GFATA01(oGetDad)
local aPerg := {}
local aResp
local nHandle


aAdd(aPerg, {6,"Arquivo a ser importado",SPACE(50),"","File(mv_par01)","", 55 ,.T.,"Arquivo .CSV |*.CSV"})      

If !ParamBox(aPerg,"Importacao de descontos",@aResp, , , , , , ,FunName(),.T., .T.) .Or.;
	!(MsgNoYes("Confima a importação do arquivo?", "Atenção"))
	Return
Endif

nHandle := fopen(mv_par01 , FO_READWRITE + FO_SHARED )
If nHandle == -1
	MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
Else
	Processa({ || ProcImp(nHandle) }, "Processando importaçao..." )
	
	oGetDad:refresh()
	fclose(nHandle) // Fecha arquivo
Endif

Return

Static Function ProcImp(nHandle)
Local cLinha
Local aLinha
Local nTamCodPro := Len(ACP->ACP_CODPRO) 

	ProcRegua(0)

	fReadLn(nHandle,@cLinha,500)
	
	While .T.
		IncProc()
	    If !("ACP_"$cLinha)
        
	        aLinha := Separa(cLinha, ";")
	        // Aproveita a linha existente 
			 GdFieldPut("ACP_CODPRO", Pad(aLinha[1],nTamCodPro))
			 GdFieldPut("ACP_PERDES", Val(aLinha[2]))
			 M->ACP_CODPRO := Pad(aLinha[1],nTamCodPro)
			 EvalTrigger()
			 
			  // Se a linha lida não contém valores válidos, abandona a importação
			 If ! Ft080LOk() .Or. !(A093Prod().And.Ft080GrPrd())
		        Exit
		     Endif
		     // Verifica se conseguiu ler mais uma linha do arquivo, para incluir nova linha na tela
		     If fReadLn(nHandle,@cLinha,500)
		 		  // Adiciona no Grid a linha lida
			     oGetDad:AddLine()
			  Else
			  	  Exit 
			  Endif
		 Else
		    fReadLn(nHandle,@cLinha,500)
		 Endif
	End
Return