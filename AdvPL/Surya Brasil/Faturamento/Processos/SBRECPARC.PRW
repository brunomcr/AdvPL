//Bibliotecas
#include "TOTVS.CH"
#include "TBICONN.CH"
#include "RPTDEF.CH"
#include "TOPCONN.CH"
#Include "FWPrintSetup.ch" 


/*{Protheus.doc} User Function SBRECPARC
    (Funcao para gerar recebibo dos parceiros)
    @type  Function
    @author Bruno Real
    @since 25/11/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function SBRECPARC()  //(cCupom,nTotal) 

//Banco e consulta
local cAlias   := "SA2"     //GetNextAlias()   
local cQuery   := ""
//Objeto de Impressao
Local oRecibo  := ""        // Objeto de retorno da class FWMsPrinter
//Arquivo e local
Local cCaminho := ""        // Diretório onde o arquivo de relatório será salvo |||| C:\TOTVS\Protheus\protheus_data\Programa Parceiros\Recibo
Local cArquivo := ""        // Nome do arquivo de relatório a ser criado
//Variáveis auxiliares
Private dData  := Date()
Private cHora  := Time()

//Variaveis de Ambiente
Private xEmp   := "99"      // 99 TESTE	
Private xFil   := "00"      // 00 FILIAL


/*-----------------------------------------------------------------------------
// PREPARA AMBIENTE com "WorfFlow Protheus" se nao "Prepare Environment"	 //
-----------------------------------------------------------------------------*/
RPCSetType(3)					// Nao consome licensa de uso
If FindFunction('WFPREPENV')	
	lAuto := .T.      
	RPCSetType( 3 )				// Nao consome licensa de uso
	wfPrepENV(xEmp , xFil)	
Else
	lAuto := .T.
	RPCSetType( 3 )				// Nao consome licensa de uso
	Prepare Environment Empresa xEmp Filial xFil	
Endif

//Definindo o diretório como a temporária do S.O. e o nome do arquivo com a data e hora (sem dois pontos)
cCaminho  := "C:/TOTVS/Protheus/protheus_data/Programa Parceiros/Recibo/"   //GetTempPath()                                              // = "C:\Users\tecno\AppData\Local\Temp\"
cArquivo  := "recibo_" + dToS(dData) + "_" + StrTran(cHora, ':', '-')       // = "recibo_20201127_11-29-05"

/*-----------------------------------------------------------------------------
//Criando o objeto do FWMSPrinter
-----------------------------------------------------------------------------*/
//lAdjustToLegacy := .F.              // Inibe legado de resolução com a TMSPrinter
//lDisabeSetup    := .T.              // Se .T. não exibe a tela de Setup, ficando à cargo do programador definir quando e se será feita sua chamada. Default é .F.
//lViewPDF        := .T.              // Quando o tipo de impressão for PDF, define se arquivo será exibido após a impressão.

oRecibo := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., .F., , "", , , , .T.)

//Setando os atributos necessários do relatório
oRecibo:SetResolution(72)          // Define resolução do relatório.
oRecibo:SetPortrait()              // Define a orientação do relatório como retrato
oRecibo:SetPaperSize(DMPAPER_A4)   // Define o tamanho que será adotado pela página a ser impressa
oRecibo:SetMargin(60,60,60,60)     // Define a margem do relatório.

//oRecibo:cPathPDF := cCaminho

//Montando Consulta
cQuery := "SELECT "
cQuery += "[PARCEIRO]=SA2.A2_NOME, "
cQuery += "[CPF_PARCEIRO]=SA2.A2_CGC , "
cQuery += "[EMAIL_PARC]=SA2.A2_EMAIL, "
//cQuery += "[ONG]=SA2.A2_XONG, "
//cQuery += "[CNPJONG]=SA2.A2_XCNPJON, "
//cQuery += "[NOMEONG]=SA2.A2_NOMEONG, "
//cQuery += "[INFLUENCER]=SA2.A2_XINFLUE, "
//cQuery += "[INSTAGRAM]=SA2.A2_XINSTAG, "
//cQuery += "[FACEBOOK]=SA2.A2_XFACEBO, "
//cQuery += "[TWITTER]=SA2.A2_XTWITTE, "
//cQuery += "[YOUTUBE]=SA2.A2_XYOUTUB, "
cQuery += "[BANCO]=SA2.A2_BANCO, "
cQuery += "[AGENCIA]=SA2.A2_AGENCIA, "
cQuery += "[CONTA]=SA2.A2_CONTA, "
//cQuery += "[CGCFAV]=SA2.A2_XCGCFAV, "
//cQuery += "[NOMFAV]=SA2.A2_XNOMFAV, "
cQuery += "[TEL]=SA2.A2_TEL "
//cQuery += "[COMOCONHECEU]=SA2.A2_XCOMO "
cQuery += "FROM SA2990 SA2 " //"FROM SA2030 SA2 "
cQuery += "WHERE SA2.D_E_L_E_T_ = '' "
//cQuery += "AND A2_XCUPOM='"+cCupom+"'"
cQuery := changeQuery(cQuery) //Verifica qual é o SGDB em uso, e realiza os ajustes necessários na Query 

//Seleciona a tabela a ser usada com a consulta criada
if Select(cAlias) <> 0	
	(cAlias)->(DbCloseArea())
endif

MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)},"Selecionando Registros...")
(cAlias)->(dbgotop())

oRecibo:Say( 10, 10, "texto para visualização")

oRecibo:EndPage()
oRecibo:Preview()

FreeObj(oRecibo)

Return


