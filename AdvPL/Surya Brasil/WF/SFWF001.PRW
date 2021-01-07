#include "protheus.ch"
#include 'FILEIO.CH'
#INCLUDE "DEFEMPSB.CH"

User Function SFWF001()
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