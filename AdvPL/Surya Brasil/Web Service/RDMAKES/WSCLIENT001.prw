#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    http://webservice.prepostagem.com.br/MpWebService.asmx?wsdl
Gerado em        07/17/19 16:58:06
Observacoes      Codigo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alteracoes neste arquivo podem causar funcionamento incorreto
                 e serao perdidas caso o codigo-fonte seja gerado novamente.
=============================================================================== */

User Function _SMMRGXN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSService1
------------------------------------------------------------------------------- */
 
WSCLIENT WSService1

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD PrePostarObjetoComRegistro
	WSMETHOD PrePostarObjeto
	WSMETHOD PrePostarObjetoV4
	WSMETHOD PrePostarObjetoV5
	WSMETHOD ValidarPostagem
	WSMETHOD RetornaOrcamento
	WSMETHOD RetornaEndereco
	WSMETHOD RetornaStatusDoObjeto
	WSMETHOD RetornaStatusCompletoDoObjeto
	WSMETHOD solicitarAutorizacaoDePostagem
	WSMETHOD PrePostarObjetoCompleto
	WSMETHOD RetornaEtiquetasParaImpressao
	WSMETHOD RetornaURLEtiquetas
	WSMETHOD AtualizaDadosAcc1
	WSMETHOD AtualizarRegistro
	WSMETHOD AtualizarRegistroContingencia
	WSMETHOD BuscaDadosPLP
	WSMETHOD RetornaObjetosPostados
	WSMETHOD BuscaEtiquetaPorPedido
	WSMETHOD BuscaEtiquetaPorNF
	WSMETHOD RetornaObjetosPostadosPorUsuario
	WSMETHOD RetornaPostadosPorUsuario
	WSMETHOD RetornaDadosPrePostagem
	WSMETHOD RetornaObjetosPostadosPorFilial

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   ccnpj                     AS string
	WSDATA   cnumeroCartao             AS string
	WSDATA   cnomeDestinatario         AS string
	WSDATA   cenderecoDestinatario     AS string
	WSDATA   nnumeroDestinatario       AS int
	WSDATA   ccomplementoDestinatario  AS string
	WSDATA   cbairroDestinatario       AS string
	WSDATA   cufDestinatario           AS string
	WSDATA   ccidadeDestinatario       AS string
	WSDATA   ccepDestinatario          AS string
	WSDATA   cnotaFiscal               AS string
	WSDATA   cPedido                   AS string
	WSDATA   ncodigoDoServico          AS int
	WSDATA   npesoReal                 AS int
	WSDATA   nvalorDeclarado           AS decimal
	WSDATA   naltura                   AS decimal
	WSDATA   nlargura                  AS decimal
	WSDATA   ncomprimento              AS decimal
	WSDATA   lavisoDeRecebimento       AS boolean
	WSDATA   cnumeroDeRegistro         AS string
	WSDATA   cemail                    AS string
	WSDATA   cconteudos                AS string
	WSDATA   ccelularDestinatario      AS string
	WSDATA   cusuario                  AS string
	WSDATA   csenha                    AS string
	WSDATA   oWSPrePostarObjetoComRegistroResult AS Service1_dadosTarifaRetorno
	WSDATA   oWSPrePostarObjetoResult  AS Service1_dadosTarifaRetorno
	WSDATA   lmaoPropria               AS boolean
	WSDATA	 lnumeroDeRegistro         AS boolean										 
	WSDATA   cobservacoes              AS string
	WSDATA   ldescConteudo             AS boolean
	WSDATA   oWSlistaConteudo          AS Service1_ArrayOfConteudo
	WSDATA   oWSPrePostarObjetoV4Result AS Service1_dadosTarifaRetorno
	WSDATA   ccpfCnpjDestinatario      AS string
	WSDATA   ndiametro                 AS decimal
	WSDATA   ntipoEmbalagem            AS int
	WSDATA   oWSPrePostarObjetoV5Result AS Service1_dadosTarifaRetorno
	WSDATA   oWSValidarPostagemResult  AS Service1_dadosTarifaRetorno
	WSDATA   ccepDestino               AS string
	WSDATA   oWSRetornaOrcamentoResult AS Service1_ArrayOfDadosTarifaRetorno
	WSDATA   ccep                      AS string
	WSDATA   oWSRetornaEnderecoResult  AS Service1_EnderecoMp
	WSDATA   cnumeroRegistro           AS string
	WSDATA   oWSRetornaStatusDoObjetoResult AS Service1_ArrayOfEventoObjeto
	WSDATA   oWSRetornaStatusCompletoDoObjetoResult AS Service1_ArrayOfEventoObjetoCompleto
	WSDATA   ccepRemetente             AS string
	WSDATA   oWSsolicitarAutorizacaoDePostagemResult AS Service1_dadosTarifaRetorno
	WSDATA   limpressoraZebra          AS boolean
	WSDATA   oWSPrePostarObjetoCompletoResult AS Service1_postagemRetorno
	WSDATA   oWSregistros              AS Service1_ArrayOfString
	WSDATA   cRetornaEtiquetasParaImpressaoResult AS base64Binary
	WSDATA   cRetornaURLEtiquetasResult AS string
	WSDATA   oWSnumeracaoIdRegistros   AS Service1_ArrayOfRetornaDados
	WSDATA   oWSAtualizaDadosAcc1Result AS Service1_ArrayOfRetornaDados
	WSDATA   cAtualizarRegistroResult  AS string
	WSDATA   cAtualizarRegistroContingenciaResult AS string
	WSDATA   oWSBuscaDadosPLPResult    AS Service1_ArrayOfObjetoPLP
	WSDATA   ccodigosDeRegistro        AS string
	WSDATA   oWSRetornaObjetosPostadosResult AS Service1_ArrayOfObjetoPLP
	WSDATA   cnumeroPedido             AS string
	WSDATA   oWSBuscaEtiquetaPorPedidoResult AS Service1_ArrayOfString
	WSDATA   cnumeroNF                 AS string
	WSDATA   oWSBuscaEtiquetaPorNFResult AS Service1_ArrayOfString
	WSDATA   cdataInicial              AS dateTime
	WSDATA   cdataFinal                AS dateTime
	WSDATA   cusuarioWS                AS string
	WSDATA   csenhaWs                  AS string
	WSDATA   oWSRetornaObjetosPostadosPorUsuarioResult AS Service1_ArrayOfRetornaDados
	WSDATA   oWSnumeroDosObjetos       AS Service1_ArrayOfString
	WSDATA   oWSRetornaPostadosPorUsuarioResult AS Service1_ArrayOfObjetosEConteudosRetorno
	WSDATA   oWSRetornaDadosPrePostagemResult AS Service1_PrePostadoRetorno
	WSDATA   nidFilial                 AS int
	WSDATA   oWSRetornaObjetosPostadosPorFilialResult AS Service1_ArrayOfNewCliente

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSService1
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20180402 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSService1
	::oWSPrePostarObjetoComRegistroResult := Service1_DADOSTARIFARETORNO():New()
	::oWSPrePostarObjetoResult := Service1_DADOSTARIFARETORNO():New()
	::oWSlistaConteudo   := Service1_ARRAYOFCONTEUDO():New()
	::oWSPrePostarObjetoV4Result := Service1_DADOSTARIFARETORNO():New()
	::oWSPrePostarObjetoV5Result := Service1_DADOSTARIFARETORNO():New()
	::oWSValidarPostagemResult := Service1_DADOSTARIFARETORNO():New()
	::oWSRetornaOrcamentoResult := Service1_ARRAYOFDADOSTARIFARETORNO():New()
	::oWSRetornaEnderecoResult := Service1_ENDERECOMP():New()
	::oWSRetornaStatusDoObjetoResult := Service1_ARRAYOFEVENTOOBJETO():New()
	::oWSRetornaStatusCompletoDoObjetoResult := Service1_ARRAYOFEVENTOOBJETOCOMPLETO():New()
	::oWSsolicitarAutorizacaoDePostagemResult := Service1_DADOSTARIFARETORNO():New()
	::oWSPrePostarObjetoCompletoResult := Service1_POSTAGEMRETORNO():New()
	::oWSregistros       := Service1_ARRAYOFSTRING():New()
	::oWSnumeracaoIdRegistros := Service1_ARRAYOFRETORNADADOS():New()
	::oWSAtualizaDadosAcc1Result := Service1_ARRAYOFRETORNADADOS():New()
	::oWSBuscaDadosPLPResult := Service1_ARRAYOFOBJETOPLP():New()
	::oWSRetornaObjetosPostadosResult := Service1_ARRAYOFOBJETOPLP():New()
	::oWSBuscaEtiquetaPorPedidoResult := Service1_ARRAYOFSTRING():New()
	::oWSBuscaEtiquetaPorNFResult := Service1_ARRAYOFSTRING():New()
	::oWSRetornaObjetosPostadosPorUsuarioResult := Service1_ARRAYOFRETORNADADOS():New()
	::oWSnumeroDosObjetos := Service1_ARRAYOFSTRING():New()
	::oWSRetornaPostadosPorUsuarioResult := Service1_ARRAYOFOBJETOSECONTEUDOSRETORNO():New()
	::oWSRetornaDadosPrePostagemResult := Service1_PREPOSTADORETORNO():New()
	::oWSRetornaObjetosPostadosPorFilialResult := Service1_ARRAYOFNEWCLIENTE():New()
Return

WSMETHOD RESET WSCLIENT WSService1
	::ccnpj              := NIL 
	::cnumeroCartao      := NIL 
	::cnomeDestinatario  := NIL 
	::cenderecoDestinatario := NIL 
	::nnumeroDestinatario := NIL 
	::ccomplementoDestinatario := NIL 
	::cbairroDestinatario := NIL 
	::cufDestinatario    := NIL 
	::ccidadeDestinatario := NIL 
	::ccepDestinatario   := NIL 
	::cnotaFiscal        := NIL 
	::cPedido            := NIL 
	::ncodigoDoServico   := NIL 
	::npesoReal          := NIL 
	::nvalorDeclarado    := NIL 
	::naltura            := NIL 
	::nlargura           := NIL 
	::ncomprimento       := NIL 
	::lavisoDeRecebimento := NIL 
	::cnumeroDeRegistro  := NIL 
										 
												 
	::cemail             := NIL 
	::cconteudos         := NIL 
	::ccelularDestinatario := NIL 
	::cusuario           := NIL 
	::csenha             := NIL 
	::oWSPrePostarObjetoComRegistroResult := NIL 
	::oWSPrePostarObjetoResult := NIL 
	::lmaoPropria        := NIL
	::lnumeroDeRegistro        := NIL 
	::cobservacoes       := NIL 
	::ldescConteudo      := NIL 
	::oWSlistaConteudo   := NIL 
	::oWSPrePostarObjetoV4Result := NIL 
	::ccpfCnpjDestinatario := NIL 
	::ndiametro          := NIL 
	::ntipoEmbalagem     := NIL 
	::oWSPrePostarObjetoV5Result := NIL 
	::oWSValidarPostagemResult := NIL 
	::ccepDestino        := NIL 
	::oWSRetornaOrcamentoResult := NIL 
	::ccep               := NIL 
	::oWSRetornaEnderecoResult := NIL 
	::cnumeroRegistro    := NIL 
	::oWSRetornaStatusDoObjetoResult := NIL 
	::oWSRetornaStatusCompletoDoObjetoResult := NIL 
	::ccepRemetente      := NIL 
	::oWSsolicitarAutorizacaoDePostagemResult := NIL 
	::limpressoraZebra   := NIL 
	::oWSPrePostarObjetoCompletoResult := NIL 
	::oWSregistros       := NIL 
	::cRetornaEtiquetasParaImpressaoResult := NIL 
	::cRetornaURLEtiquetasResult := NIL 
	::oWSnumeracaoIdRegistros := NIL 
	::oWSAtualizaDadosAcc1Result := NIL 
	::cAtualizarRegistroResult := NIL 
	::cAtualizarRegistroContingenciaResult := NIL 
	::oWSBuscaDadosPLPResult := NIL 
	::ccodigosDeRegistro := NIL 
	::oWSRetornaObjetosPostadosResult := NIL 
	::cnumeroPedido      := NIL 
	::oWSBuscaEtiquetaPorPedidoResult := NIL 
	::cnumeroNF          := NIL 
	::oWSBuscaEtiquetaPorNFResult := NIL 
	::cdataInicial       := NIL 
	::cdataFinal         := NIL 
	::cusuarioWS         := NIL 
	::csenhaWs           := NIL 
	::oWSRetornaObjetosPostadosPorUsuarioResult := NIL 
	::oWSnumeroDosObjetos := NIL 
	::oWSRetornaPostadosPorUsuarioResult := NIL 
	::oWSRetornaDadosPrePostagemResult := NIL 
	::nidFilial          := NIL 
	::oWSRetornaObjetosPostadosPorFilialResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSService1
Local oClone := WSService1():New()
	oClone:_URL          := ::_URL 
	oClone:ccnpj         := ::ccnpj
	oClone:cnumeroCartao := ::cnumeroCartao
	oClone:cnomeDestinatario := ::cnomeDestinatario
	oClone:cenderecoDestinatario := ::cenderecoDestinatario
	oClone:nnumeroDestinatario := ::nnumeroDestinatario
	oClone:ccomplementoDestinatario := ::ccomplementoDestinatario
	oClone:cbairroDestinatario := ::cbairroDestinatario
	oClone:cufDestinatario := ::cufDestinatario
	oClone:ccidadeDestinatario := ::ccidadeDestinatario
	oClone:ccepDestinatario := ::ccepDestinatario
	oClone:cnotaFiscal   := ::cnotaFiscal
	oClone:cPedido       := ::cPedido
	oClone:ncodigoDoServico := ::ncodigoDoServico
	oClone:npesoReal     := ::npesoReal
	oClone:nvalorDeclarado := ::nvalorDeclarado
	oClone:naltura       := ::naltura
	oClone:nlargura      := ::nlargura
	oClone:ncomprimento  := ::ncomprimento
	oClone:lavisoDeRecebimento := ::lavisoDeRecebimento
	oClone:cnumeroDeRegistro := ::cnumeroDeRegistro
																																	   
																																							   
	oClone:cemail        := ::cemail
	oClone:cconteudos    := ::cconteudos
	oClone:ccelularDestinatario := ::ccelularDestinatario
	oClone:cusuario      := ::cusuario
	oClone:csenha        := ::csenha
	oClone:oWSPrePostarObjetoComRegistroResult :=  IIF(::oWSPrePostarObjetoComRegistroResult = NIL , NIL ,::oWSPrePostarObjetoComRegistroResult:Clone() )
	oClone:oWSPrePostarObjetoResult :=  IIF(::oWSPrePostarObjetoResult = NIL , NIL ,::oWSPrePostarObjetoResult:Clone() )
	oClone:lmaoPropria   := ::lmaoPropria
	oClone:lnumeroDeRegistro   := ::lnumeroDeRegistro											  
	oClone:cobservacoes  := ::cobservacoes
	oClone:ldescConteudo := ::ldescConteudo
	oClone:oWSlistaConteudo :=  IIF(::oWSlistaConteudo = NIL , NIL ,::oWSlistaConteudo:Clone() )
	oClone:oWSPrePostarObjetoV4Result :=  IIF(::oWSPrePostarObjetoV4Result = NIL , NIL ,::oWSPrePostarObjetoV4Result:Clone() )
	oClone:ccpfCnpjDestinatario := ::ccpfCnpjDestinatario
	oClone:ndiametro     := ::ndiametro
	oClone:ntipoEmbalagem := ::ntipoEmbalagem
	oClone:oWSPrePostarObjetoV5Result :=  IIF(::oWSPrePostarObjetoV5Result = NIL , NIL ,::oWSPrePostarObjetoV5Result:Clone() )
	oClone:oWSValidarPostagemResult :=  IIF(::oWSValidarPostagemResult = NIL , NIL ,::oWSValidarPostagemResult:Clone() )
	oClone:ccepDestino   := ::ccepDestino
	oClone:oWSRetornaOrcamentoResult :=  IIF(::oWSRetornaOrcamentoResult = NIL , NIL ,::oWSRetornaOrcamentoResult:Clone() )
	oClone:ccep          := ::ccep
	oClone:oWSRetornaEnderecoResult :=  IIF(::oWSRetornaEnderecoResult = NIL , NIL ,::oWSRetornaEnderecoResult:Clone() )
	oClone:cnumeroRegistro := ::cnumeroRegistro
	oClone:oWSRetornaStatusDoObjetoResult :=  IIF(::oWSRetornaStatusDoObjetoResult = NIL , NIL ,::oWSRetornaStatusDoObjetoResult:Clone() )
	oClone:oWSRetornaStatusCompletoDoObjetoResult :=  IIF(::oWSRetornaStatusCompletoDoObjetoResult = NIL , NIL ,::oWSRetornaStatusCompletoDoObjetoResult:Clone() )
	oClone:ccepRemetente := ::ccepRemetente
	oClone:oWSsolicitarAutorizacaoDePostagemResult :=  IIF(::oWSsolicitarAutorizacaoDePostagemResult = NIL , NIL ,::oWSsolicitarAutorizacaoDePostagemResult:Clone() )
	oClone:limpressoraZebra := ::limpressoraZebra
	oClone:oWSPrePostarObjetoCompletoResult :=  IIF(::oWSPrePostarObjetoCompletoResult = NIL , NIL ,::oWSPrePostarObjetoCompletoResult:Clone() )
	oClone:oWSregistros  :=  IIF(::oWSregistros = NIL , NIL ,::oWSregistros:Clone() )
	oClone:cRetornaEtiquetasParaImpressaoResult := ::cRetornaEtiquetasParaImpressaoResult
	oClone:cRetornaURLEtiquetasResult := ::cRetornaURLEtiquetasResult
	oClone:oWSnumeracaoIdRegistros :=  IIF(::oWSnumeracaoIdRegistros = NIL , NIL ,::oWSnumeracaoIdRegistros:Clone() )
	oClone:oWSAtualizaDadosAcc1Result :=  IIF(::oWSAtualizaDadosAcc1Result = NIL , NIL ,::oWSAtualizaDadosAcc1Result:Clone() )
	oClone:cAtualizarRegistroResult := ::cAtualizarRegistroResult
	oClone:cAtualizarRegistroContingenciaResult := ::cAtualizarRegistroContingenciaResult
	oClone:oWSBuscaDadosPLPResult :=  IIF(::oWSBuscaDadosPLPResult = NIL , NIL ,::oWSBuscaDadosPLPResult:Clone() )
	oClone:ccodigosDeRegistro := ::ccodigosDeRegistro
	oClone:oWSRetornaObjetosPostadosResult :=  IIF(::oWSRetornaObjetosPostadosResult = NIL , NIL ,::oWSRetornaObjetosPostadosResult:Clone() )
	oClone:cnumeroPedido := ::cnumeroPedido
	oClone:oWSBuscaEtiquetaPorPedidoResult :=  IIF(::oWSBuscaEtiquetaPorPedidoResult = NIL , NIL ,::oWSBuscaEtiquetaPorPedidoResult:Clone() )
	oClone:cnumeroNF     := ::cnumeroNF
	oClone:oWSBuscaEtiquetaPorNFResult :=  IIF(::oWSBuscaEtiquetaPorNFResult = NIL , NIL ,::oWSBuscaEtiquetaPorNFResult:Clone() )
	oClone:cdataInicial  := ::cdataInicial
	oClone:cdataFinal    := ::cdataFinal
	oClone:cusuarioWS    := ::cusuarioWS
	oClone:csenhaWs      := ::csenhaWs
	oClone:oWSRetornaObjetosPostadosPorUsuarioResult :=  IIF(::oWSRetornaObjetosPostadosPorUsuarioResult = NIL , NIL ,::oWSRetornaObjetosPostadosPorUsuarioResult:Clone() )
	oClone:oWSnumeroDosObjetos :=  IIF(::oWSnumeroDosObjetos = NIL , NIL ,::oWSnumeroDosObjetos:Clone() )
	oClone:oWSRetornaPostadosPorUsuarioResult :=  IIF(::oWSRetornaPostadosPorUsuarioResult = NIL , NIL ,::oWSRetornaPostadosPorUsuarioResult:Clone() )
	oClone:oWSRetornaDadosPrePostagemResult :=  IIF(::oWSRetornaDadosPrePostagemResult = NIL , NIL ,::oWSRetornaDadosPrePostagemResult:Clone() )
	oClone:nidFilial     := ::nidFilial
	oClone:oWSRetornaObjetosPostadosPorFilialResult :=  IIF(::oWSRetornaObjetosPostadosPorFilialResult = NIL , NIL ,::oWSRetornaObjetosPostadosPorFilialResult:Clone() )
Return oClone

// WSDL Method PrePostarObjetoComRegistro of Service WSService1

WSMETHOD PrePostarObjetoComRegistro WSSEND ccnpj,cnumeroCartao,cnomeDestinatario,cenderecoDestinatario,nnumeroDestinatario,ccomplementoDestinatario,cbairroDestinatario,cufDestinatario,ccidadeDestinatario,ccepDestinatario,cnotaFiscal,cPedido,ncodigoDoServico,npesoReal,nvalorDeclarado,naltura,nlargura,ncomprimento,lavisoDeRecebimento,cnumeroDeRegistro,cemail,cconteudos,ccelularDestinatario,cusuario,csenha WSRECEIVE oWSPrePostarObjetoComRegistroResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PrePostarObjetoComRegistro xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nomeDestinatario", ::cnomeDestinatario, cnomeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoDestinatario", ::cenderecoDestinatario, cenderecoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDestinatario", ::nnumeroDestinatario, nnumeroDestinatario , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("complementoDestinatario", ::ccomplementoDestinatario, ccomplementoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("bairroDestinatario", ::cbairroDestinatario, cbairroDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ufDestinatario", ::cufDestinatario, cufDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cidadeDestinatario", ::ccidadeDestinatario, ccidadeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cepDestinatario", ::ccepDestinatario, ccepDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("notaFiscal", ::cnotaFiscal, cnotaFiscal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Pedido", ::cPedido, cPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("codigoDoServico", ::ncodigoDoServico, ncodigoDoServico , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("pesoReal", ::npesoReal, npesoReal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("valorDeclarado", ::nvalorDeclarado, nvalorDeclarado , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("altura", ::naltura, naltura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("largura", ::nlargura, nlargura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("comprimento", ::ncomprimento, ncomprimento , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("avisoDeRecebimento", ::lavisoDeRecebimento, lavisoDeRecebimento , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDeRegistro", ::cnumeroDeRegistro, cnumeroDeRegistro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("conteudos", ::cconteudos, cconteudos , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("celularDestinatario", ::ccelularDestinatario, ccelularDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PrePostarObjetoComRegistro>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/PrePostarObjetoComRegistro",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSPrePostarObjetoComRegistroResult:SoapRecv( WSAdvValue( oXmlRet,"_PREPOSTAROBJETOCOMREGISTRORESPONSE:_PREPOSTAROBJETOCOMREGISTRORESULT","dadosTarifaRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PrePostarObjeto of Service WSService1

WSMETHOD PrePostarObjeto WSSEND ccnpj,cnumeroCartao,cnomeDestinatario,cenderecoDestinatario,nnumeroDestinatario,ccomplementoDestinatario,cbairroDestinatario,cufDestinatario,ccidadeDestinatario,ccepDestinatario,cnotaFiscal,cPedido,ncodigoDoServico,npesoReal,nvalorDeclarado,naltura,nlargura,ncomprimento,lavisoDeRecebimento,lnumeroDeRegistro,cemail,cconteudos,ccelularDestinatario,cusuario,csenha WSRECEIVE oWSPrePostarObjetoResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PrePostarObjeto xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nomeDestinatario", ::cnomeDestinatario, cnomeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoDestinatario", ::cenderecoDestinatario, cenderecoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDestinatario", ::nnumeroDestinatario, nnumeroDestinatario , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("complementoDestinatario", ::ccomplementoDestinatario, ccomplementoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("bairroDestinatario", ::cbairroDestinatario, cbairroDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ufDestinatario", ::cufDestinatario, cufDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cidadeDestinatario", ::ccidadeDestinatario, ccidadeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cepDestinatario", ::ccepDestinatario, ccepDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("notaFiscal", ::cnotaFiscal, cnotaFiscal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Pedido", ::cPedido, cPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("codigoDoServico", ::ncodigoDoServico, ncodigoDoServico , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("pesoReal", ::npesoReal, npesoReal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("valorDeclarado", ::nvalorDeclarado, nvalorDeclarado , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("altura", ::naltura, naltura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("largura", ::nlargura, nlargura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("comprimento", ::ncomprimento, ncomprimento , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("avisoDeRecebimento", ::lavisoDeRecebimento, lavisoDeRecebimento , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDeRegistro", ::lnumeroDeRegistro, lnumeroDeRegistro , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("conteudos", ::cconteudos, cconteudos , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("celularDestinatario", ::ccelularDestinatario, ccelularDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PrePostarObjeto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/PrePostarObjeto",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSPrePostarObjetoResult:SoapRecv( WSAdvValue( oXmlRet,"_PREPOSTAROBJETORESPONSE:_PREPOSTAROBJETORESULT","dadosTarifaRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PrePostarObjetoV4 of Service WSService1

WSMETHOD PrePostarObjetoV4 WSSEND ccnpj,cnumeroCartao,cnomeDestinatario,cenderecoDestinatario,nnumeroDestinatario,ccomplementoDestinatario,cbairroDestinatario,cufDestinatario,ccidadeDestinatario,ccepDestinatario,cnotaFiscal,cPedido,ncodigoDoServico,npesoReal,nvalorDeclarado,naltura,nlargura,ncomprimento,lavisoDeRecebimento,lmaoPropria,lnumeroDeRegistro,cemail,cobservacoes,ccelularDestinatario,ldescConteudo,oWSlistaConteudo,cusuario,csenha WSRECEIVE oWSPrePostarObjetoV4Result WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PrePostarObjetoV4 xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nomeDestinatario", ::cnomeDestinatario, cnomeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoDestinatario", ::cenderecoDestinatario, cenderecoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDestinatario", ::nnumeroDestinatario, nnumeroDestinatario , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("complementoDestinatario", ::ccomplementoDestinatario, ccomplementoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("bairroDestinatario", ::cbairroDestinatario, cbairroDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ufDestinatario", ::cufDestinatario, cufDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cidadeDestinatario", ::ccidadeDestinatario, ccidadeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cepDestinatario", ::ccepDestinatario, ccepDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("notaFiscal", ::cnotaFiscal, cnotaFiscal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Pedido", ::cPedido, cPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("codigoDoServico", ::ncodigoDoServico, ncodigoDoServico , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("pesoReal", ::npesoReal, npesoReal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("valorDeclarado", ::nvalorDeclarado, nvalorDeclarado , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("altura", ::naltura, naltura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("largura", ::nlargura, nlargura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("comprimento", ::ncomprimento, ncomprimento , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("avisoDeRecebimento", ::lavisoDeRecebimento, lavisoDeRecebimento , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("maoPropria", ::lmaoPropria, lmaoPropria , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDeRegistro", ::lnumeroDeRegistro, lnumeroDeRegistro , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("observacoes", ::cobservacoes, cobservacoes , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("celularDestinatario", ::ccelularDestinatario, ccelularDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("descConteudo", ::ldescConteudo, ldescConteudo , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("listaConteudo", ::oWSlistaConteudo, oWSlistaConteudo , "ArrayOfConteudo", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PrePostarObjetoV4>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/PrePostarObjetoV4",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSPrePostarObjetoV4Result:SoapRecv( WSAdvValue( oXmlRet,"_PREPOSTAROBJETOV4RESPONSE:_PREPOSTAROBJETOV4RESULT","dadosTarifaRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PrePostarObjetoV5 of Service WSService1

WSMETHOD PrePostarObjetoV5 WSSEND ccnpj,cnumeroCartao,cnomeDestinatario,cenderecoDestinatario,nnumeroDestinatario,ccomplementoDestinatario,cbairroDestinatario,cufDestinatario,ccidadeDestinatario,ccepDestinatario,ccpfCnpjDestinatario,cnotaFiscal,cPedido,ncodigoDoServico,npesoReal,nvalorDeclarado,naltura,nlargura,ncomprimento,ndiametro,ntipoEmbalagem,lavisoDeRecebimento,lmaoPropria,lnumeroDeRegistro,cemail,cobservacoes,ccelularDestinatario,ldescConteudo,oWSlistaConteudo,cusuario,csenha WSRECEIVE oWSPrePostarObjetoV5Result WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PrePostarObjetoV5 xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nomeDestinatario", ::cnomeDestinatario, cnomeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoDestinatario", ::cenderecoDestinatario, cenderecoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDestinatario", ::nnumeroDestinatario, nnumeroDestinatario , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("complementoDestinatario", ::ccomplementoDestinatario, ccomplementoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("bairroDestinatario", ::cbairroDestinatario, cbairroDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ufDestinatario", ::cufDestinatario, cufDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cidadeDestinatario", ::ccidadeDestinatario, ccidadeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cepDestinatario", ::ccepDestinatario, ccepDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cpfCnpjDestinatario", ::ccpfCnpjDestinatario, ccpfCnpjDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("notaFiscal", ::cnotaFiscal, cnotaFiscal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Pedido", ::cPedido, cPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("codigoDoServico", ::ncodigoDoServico, ncodigoDoServico , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("pesoReal", ::npesoReal, npesoReal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("valorDeclarado", ::nvalorDeclarado, nvalorDeclarado , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("altura", ::naltura, naltura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("largura", ::nlargura, nlargura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("comprimento", ::ncomprimento, ncomprimento , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("diametro", ::ndiametro, ndiametro , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("tipoEmbalagem", ::ntipoEmbalagem, ntipoEmbalagem , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("avisoDeRecebimento", ::lavisoDeRecebimento, lavisoDeRecebimento , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("maoPropria", ::lmaoPropria, lmaoPropria , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDeRegistro", ::lnumeroDeRegistro, lnumeroDeRegistro , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("observacoes", ::cobservacoes, cobservacoes , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("celularDestinatario", ::ccelularDestinatario, ccelularDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("descConteudo", ::ldescConteudo, ldescConteudo , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("listaConteudo", ::oWSlistaConteudo, oWSlistaConteudo , "ArrayOfConteudo", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PrePostarObjetoV5>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/PrePostarObjetoV5",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSPrePostarObjetoV5Result:SoapRecv( WSAdvValue( oXmlRet,"_PREPOSTAROBJETOV5RESPONSE:_PREPOSTAROBJETOV5RESULT","dadosTarifaRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ValidarPostagem of Service WSService1

WSMETHOD ValidarPostagem WSSEND ccnpj,cnumeroCartao,cnomeDestinatario,cenderecoDestinatario,nnumeroDestinatario,ccomplementoDestinatario,cbairroDestinatario,cufDestinatario,ccidadeDestinatario,ccepDestinatario,ccpfCnpjDestinatario,cnotaFiscal,cPedido,ncodigoDoServico,npesoReal,nvalorDeclarado,naltura,nlargura,ncomprimento,ndiametro,ntipoEmbalagem,lavisoDeRecebimento,lmaoPropria,lnumeroDeRegistro,cemail,cobservacoes,ccelularDestinatario,ldescConteudo,oWSlistaConteudo,cusuario,csenha WSRECEIVE oWSValidarPostagemResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet
			 

BEGIN WSMETHOD

cSoap += '<ValidarPostagem xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nomeDestinatario", ::cnomeDestinatario, cnomeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoDestinatario", ::cenderecoDestinatario, cenderecoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDestinatario", ::nnumeroDestinatario, nnumeroDestinatario , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("complementoDestinatario", ::ccomplementoDestinatario, ccomplementoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("bairroDestinatario", ::cbairroDestinatario, cbairroDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ufDestinatario", ::cufDestinatario, cufDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cidadeDestinatario", ::ccidadeDestinatario, ccidadeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cepDestinatario", ::ccepDestinatario, ccepDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cpfCnpjDestinatario", ::ccpfCnpjDestinatario, ccpfCnpjDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("notaFiscal", ::cnotaFiscal, cnotaFiscal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Pedido", ::cPedido, cPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("codigoDoServico", ::ncodigoDoServico, ncodigoDoServico , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("pesoReal", ::npesoReal, npesoReal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("valorDeclarado", ::nvalorDeclarado, nvalorDeclarado , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("altura", ::naltura, naltura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("largura", ::nlargura, nlargura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("comprimento", ::ncomprimento, ncomprimento , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("diametro", ::ndiametro, ndiametro , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("tipoEmbalagem", ::ntipoEmbalagem, ntipoEmbalagem , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("avisoDeRecebimento", ::lavisoDeRecebimento, lavisoDeRecebimento , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("maoPropria", ::lmaoPropria, lmaoPropria , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDeRegistro", ::lnumeroDeRegistro, lnumeroDeRegistro , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("observacoes", ::cobservacoes, cobservacoes , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("celularDestinatario", ::ccelularDestinatario, ccelularDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("descConteudo", ::ldescConteudo, ldescConteudo , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("listaConteudo", ::oWSlistaConteudo, oWSlistaConteudo , "ArrayOfConteudo", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ValidarPostagem>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/ValidarPostagem",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSValidarPostagemResult:SoapRecv( WSAdvValue( oXmlRet,"_VALIDARPOSTAGEMRESPONSE:_VALIDARPOSTAGEMRESULT","dadosTarifaRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornaOrcamento of Service WSService1

WSMETHOD RetornaOrcamento WSSEND ccnpj,cnumeroCartao,ccepDestino,npesoReal,nvalorDeclarado,naltura,nlargura,ncomprimento,lavisoDeRecebimento,cusuario,csenha WSRECEIVE oWSRetornaOrcamentoResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornaOrcamento xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cepDestino", ::ccepDestino, ccepDestino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("pesoReal", ::npesoReal, npesoReal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("valorDeclarado", ::nvalorDeclarado, nvalorDeclarado , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("altura", ::naltura, naltura , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("largura", ::nlargura, nlargura , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("comprimento", ::ncomprimento, ncomprimento , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("avisoDeRecebimento", ::lavisoDeRecebimento, lavisoDeRecebimento , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornaOrcamento>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/RetornaOrcamento",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSRetornaOrcamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAORCAMENTORESPONSE:_RETORNAORCAMENTORESULT","ArrayOfDadosTarifaRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornaEndereco of Service WSService1

WSMETHOD RetornaEndereco WSSEND ccep,cusuario,csenha WSRECEIVE oWSRetornaEnderecoResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornaEndereco xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cep", ::ccep, ccep , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornaEndereco>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/RetornaEndereco",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSRetornaEnderecoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAENDERECORESPONSE:_RETORNAENDERECORESULT","EnderecoMp",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornaStatusDoObjeto of Service WSService1

WSMETHOD RetornaStatusDoObjeto WSSEND ccnpj,cnumeroCartao,cnumeroRegistro,cusuario,csenha WSRECEIVE oWSRetornaStatusDoObjetoResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornaStatusDoObjeto xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroRegistro", ::cnumeroRegistro, cnumeroRegistro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornaStatusDoObjeto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/RetornaStatusDoObjeto",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSRetornaStatusDoObjetoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNASTATUSDOOBJETORESPONSE:_RETORNASTATUSDOOBJETORESULT","ArrayOfEventoObjeto",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Method RetornaStatusCompletoDoObjeto of Service WSService1

WSMETHOD RetornaStatusCompletoDoObjeto WSSEND ccnpj,cnumeroCartao,cnumeroRegistro,cusuario,csenha WSRECEIVE oWSRetornaStatusCompletoDoObjetoResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornaStatusCompletoDoObjeto xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroRegistro", ::cnumeroRegistro, cnumeroRegistro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornaStatusCompletoDoObjeto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/RetornaStatusCompletoDoObjeto",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSRetornaStatusCompletoDoObjetoResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNASTATUSCOMPLETODOOBJETORESPONSE:_RETORNASTATUSCOMPLETODOOBJETORESULT","ArrayOfEventoObjetoCompleto",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method solicitarAutorizacaoDePostagem of Service WSService1
  
							   
													  
			 
			  
			   
				  
				  
		   

WSMETHOD solicitarAutorizacaoDePostagem WSSEND ccnpj,cnumeroCartao,cnomeDestinatario,cenderecoDestinatario,nnumeroDestinatario,ccomplementoDestinatario,cbairroDestinatario,cufDestinatario,ccidadeDestinatario,ccepRemetente,ccepDestinatario,cnotaFiscal,cPedido,ncodigoDoServico,nvalorDeclarado,lavisoDeRecebimento,cemail,ccelularDestinatario,cusuario,csenha WSRECEIVE oWSsolicitarAutorizacaoDePostagemResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet
		   

BEGIN WSMETHOD
											 
	  

cSoap += '<solicitarAutorizacaoDePostagem xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nomeDestinatario", ::cnomeDestinatario, cnomeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoDestinatario", ::cenderecoDestinatario, cenderecoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDestinatario", ::nnumeroDestinatario, nnumeroDestinatario , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("complementoDestinatario", ::ccomplementoDestinatario, ccomplementoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("bairroDestinatario", ::cbairroDestinatario, cbairroDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ufDestinatario", ::cufDestinatario, cufDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cidadeDestinatario", ::ccidadeDestinatario, ccidadeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cepRemetente", ::ccepRemetente, ccepRemetente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cepDestinatario", ::ccepDestinatario, ccepDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("notaFiscal", ::cnotaFiscal, cnotaFiscal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Pedido", ::cPedido, cPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("codigoDoServico", ::ncodigoDoServico, ncodigoDoServico , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("valorDeclarado", ::nvalorDeclarado, nvalorDeclarado , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("avisoDeRecebimento", ::lavisoDeRecebimento, lavisoDeRecebimento , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("celularDestinatario", ::ccelularDestinatario, ccelularDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</solicitarAutorizacaoDePostagem>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/solicitarAutorizacaoDePostagem",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSsolicitarAutorizacaoDePostagemResult:SoapRecv( WSAdvValue( oXmlRet,"_SOLICITARAUTORIZACAODEPOSTAGEMRESPONSE:_SOLICITARAUTORIZACAODEPOSTAGEMRESULT","dadosTarifaRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PrePostarObjetoCompleto of Service WSService1

WSMETHOD PrePostarObjetoCompleto WSSEND ccnpj,cnumeroCartao,cnomeDestinatario,cenderecoDestinatario,nnumeroDestinatario,ccomplementoDestinatario,cbairroDestinatario,cufDestinatario,ccidadeDestinatario,ccepDestinatario,cnotaFiscal,cPedido,ncodigoDoServico,npesoReal,nvalorDeclarado,naltura,nlargura,ncomprimento,lavisoDeRecebimento,lmaoPropria,lnumeroDeRegistro,cemail,cobservacoes,ccelularDestinatario,ldescConteudo,oWSlistaConteudo,limpressoraZebra,cusuario,csenha WSRECEIVE oWSPrePostarObjetoCompletoResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PrePostarObjetoCompleto xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nomeDestinatario", ::cnomeDestinatario, cnomeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoDestinatario", ::cenderecoDestinatario, cenderecoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDestinatario", ::nnumeroDestinatario, nnumeroDestinatario , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("complementoDestinatario", ::ccomplementoDestinatario, ccomplementoDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("bairroDestinatario", ::cbairroDestinatario, cbairroDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ufDestinatario", ::cufDestinatario, cufDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cidadeDestinatario", ::ccidadeDestinatario, ccidadeDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cepDestinatario", ::ccepDestinatario, ccepDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("notaFiscal", ::cnotaFiscal, cnotaFiscal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Pedido", ::cPedido, cPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("codigoDoServico", ::ncodigoDoServico, ncodigoDoServico , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("pesoReal", ::npesoReal, npesoReal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("valorDeclarado", ::nvalorDeclarado, nvalorDeclarado , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("altura", ::naltura, naltura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("largura", ::nlargura, nlargura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("comprimento", ::ncomprimento, ncomprimento , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("avisoDeRecebimento", ::lavisoDeRecebimento, lavisoDeRecebimento , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("maoPropria", ::lmaoPropria, lmaoPropria , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroDeRegistro", ::lnumeroDeRegistro, lnumeroDeRegistro , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("observacoes", ::cobservacoes, cobservacoes , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("celularDestinatario", ::ccelularDestinatario, ccelularDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("descConteudo", ::ldescConteudo, ldescConteudo , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("listaConteudo", ::oWSlistaConteudo, oWSlistaConteudo , "ArrayOfConteudo", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("impressoraZebra", ::limpressoraZebra, limpressoraZebra , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PrePostarObjetoCompleto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/PrePostarObjetoCompleto",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSPrePostarObjetoCompletoResult:SoapRecv( WSAdvValue( oXmlRet,"_PREPOSTAROBJETOCOMPLETORESPONSE:_PREPOSTAROBJETOCOMPLETORESULT","postagemRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornaEtiquetasParaImpressao of Service WSService1

WSMETHOD RetornaEtiquetasParaImpressao WSSEND ccnpj,cnumeroCartao,oWSregistros,limpressoraZebra,cusuario,csenha WSRECEIVE cRetornaEtiquetasParaImpressaoResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet
Local nX := 1

BEGIN WSMETHOD

cSoap += '<RetornaEtiquetasParaImpressao xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
//cSoap += WSSoapValue("registros", ::oWSregistros, oWSregistros , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "<registros>"
	for nX := 1 to len(oWSregistros)
		cSoap += WSSoapValue("string", ::oWSregistros[nX], oWSregistros[nX] , "string", .F. , .F., 0 , NIL, .F.)
	next
cSoap += "</registros>"
cSoap += WSSoapValue("impressoraZebra", ::limpressoraZebra, limpressoraZebra , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornaEtiquetasParaImpressao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/RetornaEtiquetasParaImpressao",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::cRetornaEtiquetasParaImpressaoResult :=  WSAdvValue( oXmlRet,"_RETORNAETIQUETASPARAIMPRESSAORESPONSE:_RETORNAETIQUETASPARAIMPRESSAORESULT:TEXT","base64Binary",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornaURLEtiquetas of Service WSService1

WSMETHOD RetornaURLEtiquetas WSSEND ccnpj,cnumeroCartao,oWSregistros,limpressoraZebra,cusuario,csenha WSRECEIVE cRetornaURLEtiquetasResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornaURLEtiquetas xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroCartao", ::cnumeroCartao, cnumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("registros", ::oWSregistros, oWSregistros , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("impressoraZebra", ::limpressoraZebra, limpressoraZebra , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornaURLEtiquetas>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/RetornaURLEtiquetas",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::cRetornaURLEtiquetasResult :=  WSAdvValue( oXmlRet,"_RETORNAURLETIQUETASRESPONSE:_RETORNAURLETIQUETASRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizaDadosAcc1 of Service WSService1

WSMETHOD AtualizaDadosAcc1 WSSEND oWSnumeracaoIdRegistros,cusuario,csenha WSRECEIVE oWSAtualizaDadosAcc1Result WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AtualizaDadosAcc1 xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("numeracaoIdRegistros", ::oWSnumeracaoIdRegistros, oWSnumeracaoIdRegistros , "ArrayOfRetornaDados", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AtualizaDadosAcc1>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/AtualizaDadosAcc1",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSAtualizaDadosAcc1Result:SoapRecv( WSAdvValue( oXmlRet,"_ATUALIZADADOSACC1RESPONSE:_ATUALIZADADOSACC1RESULT","ArrayOfRetornaDados",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarRegistro of Service WSService1

WSMETHOD AtualizarRegistro WSSEND cnumeroDeRegistro,npesoReal,naltura,nlargura,ncomprimento,cusuario,csenha WSRECEIVE cAtualizarRegistroResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AtualizarRegistro xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("numeroDeRegistro", ::cnumeroDeRegistro, cnumeroDeRegistro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("pesoReal", ::npesoReal, npesoReal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("altura", ::naltura, naltura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("largura", ::nlargura, nlargura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("comprimento", ::ncomprimento, ncomprimento , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AtualizarRegistro>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/AtualizarRegistro",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::cAtualizarRegistroResult :=  WSAdvValue( oXmlRet,"_ATUALIZARREGISTRORESPONSE:_ATUALIZARREGISTRORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarRegistroContingencia of Service WSService1

WSMETHOD AtualizarRegistroContingencia WSSEND cnumeroDeRegistro,ccepDestino,npesoReal,naltura,nlargura,ncomprimento,cusuario,csenha WSRECEIVE cAtualizarRegistroContingenciaResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AtualizarRegistroContingencia xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("numeroDeRegistro", ::cnumeroDeRegistro, cnumeroDeRegistro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cepDestino", ::ccepDestino, ccepDestino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("pesoReal", ::npesoReal, npesoReal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("altura", ::naltura, naltura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("largura", ::nlargura, nlargura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("comprimento", ::ncomprimento, ncomprimento , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AtualizarRegistroContingencia>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/AtualizarRegistroContingencia",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::cAtualizarRegistroContingenciaResult :=  WSAdvValue( oXmlRet,"_ATUALIZARREGISTROCONTINGENCIARESPONSE:_ATUALIZARREGISTROCONTINGENCIARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscaDadosPLP of Service WSService1

WSMETHOD BuscaDadosPLP WSSEND cnumeroDeRegistro,cusuario,csenha WSRECEIVE oWSBuscaDadosPLPResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscaDadosPLP xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("numeroDeRegistro", ::cnumeroDeRegistro, cnumeroDeRegistro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscaDadosPLP>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/BuscaDadosPLP",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSBuscaDadosPLPResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCADADOSPLPRESPONSE:_BUSCADADOSPLPRESULT","ArrayOfObjetoPLP",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornaObjetosPostados of Service WSService1

WSMETHOD RetornaObjetosPostados WSSEND ccodigosDeRegistro,cusuario,csenha WSRECEIVE oWSRetornaObjetosPostadosResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornaObjetosPostados xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("codigosDeRegistro", ::ccodigosDeRegistro, ccodigosDeRegistro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornaObjetosPostados>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/RetornaObjetosPostados",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSRetornaObjetosPostadosResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAOBJETOSPOSTADOSRESPONSE:_RETORNAOBJETOSPOSTADOSRESULT","ArrayOfObjetoPLP",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscaEtiquetaPorPedido of Service WSService1

WSMETHOD BuscaEtiquetaPorPedido WSSEND cnumeroPedido,cusuario,csenha WSRECEIVE oWSBuscaEtiquetaPorPedidoResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscaEtiquetaPorPedido xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("numeroPedido", ::cnumeroPedido, cnumeroPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscaEtiquetaPorPedido>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/BuscaEtiquetaPorPedido",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSBuscaEtiquetaPorPedidoResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCAETIQUETAPORPEDIDORESPONSE:_BUSCAETIQUETAPORPEDIDORESULT","ArrayOfString",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscaEtiquetaPorNF of Service WSService1

WSMETHOD BuscaEtiquetaPorNF WSSEND cnumeroNF,cusuario,csenha WSRECEIVE oWSBuscaEtiquetaPorNFResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscaEtiquetaPorNF xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("numeroNF", ::cnumeroNF, cnumeroNF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscaEtiquetaPorNF>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/BuscaEtiquetaPorNF",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSBuscaEtiquetaPorNFResult:SoapRecv( WSAdvValue( oXmlRet,"_BUSCAETIQUETAPORNFRESPONSE:_BUSCAETIQUETAPORNFRESULT","ArrayOfString",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornaObjetosPostadosPorUsuario of Service WSService1

WSMETHOD RetornaObjetosPostadosPorUsuario WSSEND cdataInicial,cdataFinal,cusuarioWS,csenhaWs WSRECEIVE oWSRetornaObjetosPostadosPorUsuarioResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornaObjetosPostadosPorUsuario xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("dataInicial", ::cdataInicial, cdataInicial , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataFinal", ::cdataFinal, cdataFinal , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuarioWS", ::cusuarioWS, cusuarioWS , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senhaWs", ::csenhaWs, csenhaWs , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornaObjetosPostadosPorUsuario>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/RetornaObjetosPostadosPorUsuario",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSRetornaObjetosPostadosPorUsuarioResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAOBJETOSPOSTADOSPORUSUARIORESPONSE:_RETORNAOBJETOSPOSTADOSPORUSUARIORESULT","ArrayOfRetornaDados",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornaPostadosPorUsuario of Service WSService1

WSMETHOD RetornaPostadosPorUsuario WSSEND oWSnumeroDosObjetos,cusuarioWS,csenhaWs WSRECEIVE oWSRetornaPostadosPorUsuarioResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornaPostadosPorUsuario xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("numeroDosObjetos", ::oWSnumeroDosObjetos, oWSnumeroDosObjetos , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuarioWS", ::cusuarioWS, cusuarioWS , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senhaWs", ::csenhaWs, csenhaWs , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornaPostadosPorUsuario>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/RetornaPostadosPorUsuario",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSRetornaPostadosPorUsuarioResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAPOSTADOSPORUSUARIORESPONSE:_RETORNAPOSTADOSPORUSUARIORESULT","ArrayOfObjetosEConteudosRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornaDadosPrePostagem of Service WSService1

WSMETHOD RetornaDadosPrePostagem WSSEND cnumeroRegistro,cusuario,csenha WSRECEIVE oWSRetornaDadosPrePostagemResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornaDadosPrePostagem xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("numeroRegistro", ::cnumeroRegistro, cnumeroRegistro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("usuario", ::cusuario, cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("senha", ::csenha, csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornaDadosPrePostagem>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/RetornaDadosPrePostagem",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSRetornaDadosPrePostagemResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNADADOSPREPOSTAGEMRESPONSE:_RETORNADADOSPREPOSTAGEMRESULT","PrePostadoRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RetornaObjetosPostadosPorFilial of Service WSService1

WSMETHOD RetornaObjetosPostadosPorFilial WSSEND cdataInicial,cdataFinal,nidFilial WSRECEIVE oWSRetornaObjetosPostadosPorFilialResult WSCLIENT WSService1
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RetornaObjetosPostadosPorFilial xmlns="http://webservice.prepostagem.com.br/MpWebService.asmx">'
cSoap += WSSoapValue("dataInicial", ::cdataInicial, cdataInicial , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataFinal", ::cdataFinal, cdataFinal , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("idFilial", ::nidFilial, nidFilial , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RetornaObjetosPostadosPorFilial>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx/RetornaObjetosPostadosPorFilial",; 
	"DOCUMENT","http://webservice.prepostagem.com.br/MpWebService.asmx",,,; 
	"http://webservice.prepostagem.com.br/MpWebService.asmx")

::Init()
::oWSRetornaObjetosPostadosPorFilialResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNAOBJETOSPOSTADOSPORFILIALRESPONSE:_RETORNAOBJETOSPOSTADOSPORFILIALRESULT","ArrayOfNewCliente",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure dadosTarifaRetorno

WSSTRUCT Service1_dadosTarifaRetorno
	WSDATA   cnumeroRegistro           AS string OPTIONAL
	WSDATA   cavisoCorreios            AS string OPTIONAL
	WSDATA   cDescricaoServico         AS string OPTIONAL
	WSDATA   ccodigo                   AS string OPTIONAL
	WSDATA   cmMsgErro                 AS string OPTIONAL
	WSDATA   nvalor                    AS double
	WSDATA   nvalorAvisoRecebimento    AS double
	WSDATA   nvalorValorDeclarado      AS double
	WSDATA   nvalorMaoPropria          AS double
	WSDATA   nprazoEntrega             AS int
	WSDATA   centregaDomiciliar        AS string OPTIONAL
	WSDATA   centregaSabado            AS string OPTIONAL
	WSDATA   nerro                     AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_dadosTarifaRetorno
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_dadosTarifaRetorno
Return

WSMETHOD CLONE WSCLIENT Service1_dadosTarifaRetorno
	Local oClone := Service1_dadosTarifaRetorno():NEW()
	oClone:cnumeroRegistro      := ::cnumeroRegistro
	oClone:cavisoCorreios       := ::cavisoCorreios
	oClone:cDescricaoServico    := ::cDescricaoServico
	oClone:ccodigo              := ::ccodigo
	oClone:cmMsgErro            := ::cmMsgErro
	oClone:nvalor               := ::nvalor
	oClone:nvalorAvisoRecebimento := ::nvalorAvisoRecebimento
	oClone:nvalorValorDeclarado := ::nvalorValorDeclarado
	oClone:nvalorMaoPropria     := ::nvalorMaoPropria
	oClone:nprazoEntrega        := ::nprazoEntrega
	oClone:centregaDomiciliar   := ::centregaDomiciliar
	oClone:centregaSabado       := ::centregaSabado
	oClone:nerro                := ::nerro
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_dadosTarifaRetorno
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cnumeroRegistro    :=  WSAdvValue( oResponse,"_NUMEROREGISTRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cavisoCorreios     :=  WSAdvValue( oResponse,"_AVISOCORREIOS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDescricaoServico  :=  WSAdvValue( oResponse,"_DESCRICAOSERVICO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodigo            :=  WSAdvValue( oResponse,"_CODIGO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cmMsgErro          :=  WSAdvValue( oResponse,"_MMSGERRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nvalor             :=  WSAdvValue( oResponse,"_VALOR","double",NIL,"Property nvalor as s:double on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nvalorAvisoRecebimento :=  WSAdvValue( oResponse,"_VALORAVISORECEBIMENTO","double",NIL,"Property nvalorAvisoRecebimento as s:double on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nvalorValorDeclarado :=  WSAdvValue( oResponse,"_VALORVALORDECLARADO","double",NIL,"Property nvalorValorDeclarado as s:double on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nvalorMaoPropria   :=  WSAdvValue( oResponse,"_VALORMAOPROPRIA","double",NIL,"Property nvalorMaoPropria as s:double on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nprazoEntrega      :=  WSAdvValue( oResponse,"_PRAZOENTREGA","int",NIL,"Property nprazoEntrega as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::centregaDomiciliar :=  WSAdvValue( oResponse,"_ENTREGADOMICILIAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::centregaSabado     :=  WSAdvValue( oResponse,"_ENTREGASABADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nerro              :=  WSAdvValue( oResponse,"_ERRO","int",NIL,"Property nerro as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfDadosTarifaRetorno

WSSTRUCT Service1_ArrayOfDadosTarifaRetorno
	WSDATA   oWSdadosTarifaRetorno     AS Service1_dadosTarifaRetorno OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfDadosTarifaRetorno
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfDadosTarifaRetorno
	::oWSdadosTarifaRetorno := {} // Array Of  Service1_DADOSTARIFARETORNO():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfDadosTarifaRetorno
	Local oClone := Service1_ArrayOfDadosTarifaRetorno():NEW()
	oClone:oWSdadosTarifaRetorno := NIL
	If ::oWSdadosTarifaRetorno <> NIL 
		oClone:oWSdadosTarifaRetorno := {}
		aEval( ::oWSdadosTarifaRetorno , { |x| aadd( oClone:oWSdadosTarifaRetorno , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfDadosTarifaRetorno
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_DADOSTARIFARETORNO","dadosTarifaRetorno",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSdadosTarifaRetorno , Service1_dadosTarifaRetorno():New() )
			::oWSdadosTarifaRetorno[len(::oWSdadosTarifaRetorno)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure EnderecoMp

WSSTRUCT Service1_EnderecoMp
	WSDATA   clogradouro               AS string OPTIONAL
	WSDATA   nnumero                   AS int
	WSDATA   ccomplemento              AS string OPTIONAL
	WSDATA   ccomplemento2             AS string OPTIONAL
	WSDATA   cbairro                   AS string OPTIONAL
	WSDATA   ccidade                   AS string OPTIONAL
	WSDATA   cestado                   AS string OPTIONAL
	WSDATA   ccep                      AS string OPTIONAL
	WSDATA   ncodErro                  AS int
	WSDATA   cmsgErro                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_EnderecoMp
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_EnderecoMp
Return

WSMETHOD CLONE WSCLIENT Service1_EnderecoMp
	Local oClone := Service1_EnderecoMp():NEW()
	oClone:clogradouro          := ::clogradouro
	oClone:nnumero              := ::nnumero
	oClone:ccomplemento         := ::ccomplemento
	oClone:ccomplemento2        := ::ccomplemento2
	oClone:cbairro              := ::cbairro
	oClone:ccidade              := ::ccidade
	oClone:cestado              := ::cestado
	oClone:ccep                 := ::ccep
	oClone:ncodErro             := ::ncodErro
	oClone:cmsgErro             := ::cmsgErro
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_EnderecoMp
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::clogradouro        :=  WSAdvValue( oResponse,"_LOGRADOURO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nnumero            :=  WSAdvValue( oResponse,"_NUMERO","int",NIL,"Property nnumero as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ccomplemento       :=  WSAdvValue( oResponse,"_COMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccomplemento2      :=  WSAdvValue( oResponse,"_COMPLEMENTO2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cbairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cestado            :=  WSAdvValue( oResponse,"_ESTADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccep               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ncodErro           :=  WSAdvValue( oResponse,"_CODERRO","int",NIL,"Property ncodErro as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cmsgErro           :=  WSAdvValue( oResponse,"_MSGERRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfEventoObjeto

WSSTRUCT Service1_ArrayOfEventoObjeto
	WSDATA   oWSEventoObjeto           AS Service1_EventoObjeto OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfEventoObjeto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfEventoObjeto
	::oWSEventoObjeto      := {} // Array Of  Service1_EVENTOOBJETO():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfEventoObjeto
	Local oClone := Service1_ArrayOfEventoObjeto():NEW()
	oClone:oWSEventoObjeto := NIL
	If ::oWSEventoObjeto <> NIL 
		oClone:oWSEventoObjeto := {}
		aEval( ::oWSEventoObjeto , { |x| aadd( oClone:oWSEventoObjeto , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfEventoObjeto
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_EVENTOOBJETO","EventoObjeto",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSEventoObjeto , Service1_EventoObjeto():New() )
			::oWSEventoObjeto[len(::oWSEventoObjeto)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfEventoObjetoCompleto

WSSTRUCT Service1_ArrayOfEventoObjetoCompleto
	WSDATA   oWSEventoObjetoCompleto   AS Service1_EventoObjetoCompleto OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfEventoObjetoCompleto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfEventoObjetoCompleto
	::oWSEventoObjetoCompleto := {} // Array Of  Service1_EVENTOOBJETOCOMPLETO():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfEventoObjetoCompleto
	Local oClone := Service1_ArrayOfEventoObjetoCompleto():NEW()
	oClone:oWSEventoObjetoCompleto := NIL
	If ::oWSEventoObjetoCompleto <> NIL 
		oClone:oWSEventoObjetoCompleto := {}
		aEval( ::oWSEventoObjetoCompleto , { |x| aadd( oClone:oWSEventoObjetoCompleto , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfEventoObjetoCompleto
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_EVENTOOBJETOCOMPLETO","EventoObjetoCompleto",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSEventoObjetoCompleto , Service1_EventoObjetoCompleto():New() )
			::oWSEventoObjetoCompleto[len(::oWSEventoObjetoCompleto)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure postagemRetorno

WSSTRUCT Service1_postagemRetorno
	WSDATA   cpdfEtiqueta              AS base64Binary OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_postagemRetorno
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_postagemRetorno
Return

WSMETHOD CLONE WSCLIENT Service1_postagemRetorno
	Local oClone := Service1_postagemRetorno():NEW()
	oClone:cpdfEtiqueta         := ::cpdfEtiqueta
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_postagemRetorno
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cpdfEtiqueta       :=  WSAdvValue( oResponse,"_PDFETIQUETA","base64Binary",NIL,NIL,NIL,"SB",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfString
/*
WSSTRUCT Service1_ArrayOfString
	WSDATA   cstring                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfString
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfString
	::cstring              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfString
	Local oClone := Service1_ArrayOfString():NEW()
	oClone:cstring              := IIf(::cstring <> NIL , aClone(::cstring) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_ArrayOfString
	Local cSoap := ""
	aEval( ::cstring , {|x| cSoap := cSoap  +  WSSoapValue("string", x , x , "string", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfString
	Local oNodes1 :=  WSAdvValue( oResponse,"_STRING","string",{},NIL,.T.,"S",NIL,"a") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::cstring ,  x:TEXT  ) } )
Return
*/
// WSDL Data Structure ArrayOfRetornaDados

WSSTRUCT Service1_ArrayOfRetornaDados
	WSDATA   oWSRetornaDados           AS Service1_RetornaDados OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfRetornaDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfRetornaDados
	::oWSRetornaDados      := {} // Array Of  Service1_RETORNADADOS():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfRetornaDados
	Local oClone := Service1_ArrayOfRetornaDados():NEW()
	oClone:oWSRetornaDados := NIL
	If ::oWSRetornaDados <> NIL 
		oClone:oWSRetornaDados := {}
		aEval( ::oWSRetornaDados , { |x| aadd( oClone:oWSRetornaDados , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_ArrayOfRetornaDados
	Local cSoap := ""
	aEval( ::oWSRetornaDados , {|x| cSoap := cSoap  +  WSSoapValue("RetornaDados", x , x , "RetornaDados", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfRetornaDados
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_RETORNADADOS","RetornaDados",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRetornaDados , Service1_RetornaDados():New() )
			::oWSRetornaDados[len(::oWSRetornaDados)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfObjetoPLP

WSSTRUCT Service1_ArrayOfObjetoPLP
	WSDATA   oWSObjetoPLP              AS Service1_ObjetoPLP OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfObjetoPLP
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfObjetoPLP
	::oWSObjetoPLP         := {} // Array Of  Service1_OBJETOPLP():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfObjetoPLP
	Local oClone := Service1_ArrayOfObjetoPLP():NEW()
	oClone:oWSObjetoPLP := NIL
	If ::oWSObjetoPLP <> NIL 
		oClone:oWSObjetoPLP := {}
		aEval( ::oWSObjetoPLP , { |x| aadd( oClone:oWSObjetoPLP , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfObjetoPLP
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OBJETOPLP","ObjetoPLP",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSObjetoPLP , Service1_ObjetoPLP():New() )
			::oWSObjetoPLP[len(::oWSObjetoPLP)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfObjetosEConteudosRetorno

WSSTRUCT Service1_ArrayOfObjetosEConteudosRetorno
	WSDATA   oWSObjetosEConteudosRetorno AS Service1_ObjetosEConteudosRetorno OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfObjetosEConteudosRetorno
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfObjetosEConteudosRetorno
	::oWSObjetosEConteudosRetorno := {} // Array Of  Service1_OBJETOSECONTEUDOSRETORNO():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfObjetosEConteudosRetorno
	Local oClone := Service1_ArrayOfObjetosEConteudosRetorno():NEW()
	oClone:oWSObjetosEConteudosRetorno := NIL
	If ::oWSObjetosEConteudosRetorno <> NIL 
		oClone:oWSObjetosEConteudosRetorno := {}
		aEval( ::oWSObjetosEConteudosRetorno , { |x| aadd( oClone:oWSObjetosEConteudosRetorno , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfObjetosEConteudosRetorno
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_OBJETOSECONTEUDOSRETORNO","ObjetosEConteudosRetorno",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSObjetosEConteudosRetorno , Service1_ObjetosEConteudosRetorno():New() )
			::oWSObjetosEConteudosRetorno[len(::oWSObjetosEConteudosRetorno)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure PrePostadoRetorno

WSSTRUCT Service1_PrePostadoRetorno
	WSDATA   cRegistro                 AS string OPTIONAL
	WSDATA   cDataPrePostagem          AS dateTime
	WSDATA   cDescricaoServico         AS string OPTIONAL
	WSDATA   cCodigoServico            AS string OPTIONAL
	WSDATA   cPedido                   AS string OPTIONAL
	WSDATA   cNotaFiscal               AS string OPTIONAL
	WSDATA   nValor                    AS decimal
	WSDATA   nPrazoEntrega             AS int
	WSDATA   nErro                     AS int
	WSDATA   cMsgErro                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_PrePostadoRetorno
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_PrePostadoRetorno
Return

WSMETHOD CLONE WSCLIENT Service1_PrePostadoRetorno
	Local oClone := Service1_PrePostadoRetorno():NEW()
	oClone:cRegistro            := ::cRegistro
	oClone:cDataPrePostagem     := ::cDataPrePostagem
	oClone:cDescricaoServico    := ::cDescricaoServico
	oClone:cCodigoServico       := ::cCodigoServico
	oClone:cPedido              := ::cPedido
	oClone:cNotaFiscal          := ::cNotaFiscal
	oClone:nValor               := ::nValor
	oClone:nPrazoEntrega        := ::nPrazoEntrega
	oClone:nErro                := ::nErro
	oClone:cMsgErro             := ::cMsgErro
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_PrePostadoRetorno
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cRegistro          :=  WSAdvValue( oResponse,"_REGISTRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataPrePostagem   :=  WSAdvValue( oResponse,"_DATAPREPOSTAGEM","dateTime",NIL,"Property cDataPrePostagem as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDescricaoServico  :=  WSAdvValue( oResponse,"_DESCRICAOSERVICO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoServico     :=  WSAdvValue( oResponse,"_CODIGOSERVICO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPedido            :=  WSAdvValue( oResponse,"_PEDIDO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNotaFiscal        :=  WSAdvValue( oResponse,"_NOTAFISCAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,"Property nValor as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPrazoEntrega      :=  WSAdvValue( oResponse,"_PRAZOENTREGA","int",NIL,"Property nPrazoEntrega as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nErro              :=  WSAdvValue( oResponse,"_ERRO","int",NIL,"Property nErro as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cMsgErro           :=  WSAdvValue( oResponse,"_MSGERRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfNewCliente

WSSTRUCT Service1_ArrayOfNewCliente
	WSDATA   oWSNewCliente             AS Service1_NewCliente OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfNewCliente
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfNewCliente
	::oWSNewCliente        := {} // Array Of  Service1_NEWCLIENTE():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfNewCliente
	Local oClone := Service1_ArrayOfNewCliente():NEW()
	oClone:oWSNewCliente := NIL
	If ::oWSNewCliente <> NIL 
		oClone:oWSNewCliente := {}
		aEval( ::oWSNewCliente , { |x| aadd( oClone:oWSNewCliente , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfNewCliente
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_NEWCLIENTE","NewCliente",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSNewCliente , Service1_NewCliente():New() )
			::oWSNewCliente[len(::oWSNewCliente)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure EventoObjetoCompleto

WSSTRUCT Service1_EventoObjetoCompleto
	WSDATA   cDetalhesRetirar          AS string OPTIONAL
	WSDATA   cCodigoRetirar            AS string OPTIONAL
	WSDATA   cCepRetirar               AS string OPTIONAL
	WSDATA   cEnderecoRetirar          AS string OPTIONAL
	WSDATA   cNumeroRetirar            AS string OPTIONAL
	WSDATA   cCidadeRetirar            AS string OPTIONAL
	WSDATA   cUFRetirar                AS string OPTIONAL
	WSDATA   cBairroRetirar            AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_EventoObjetoCompleto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_EventoObjetoCompleto
Return

WSMETHOD CLONE WSCLIENT Service1_EventoObjetoCompleto
	Local oClone := Service1_EventoObjetoCompleto():NEW()
	oClone:cDetalhesRetirar     := ::cDetalhesRetirar
	oClone:cCodigoRetirar       := ::cCodigoRetirar
	oClone:cCepRetirar          := ::cCepRetirar
	oClone:cEnderecoRetirar     := ::cEnderecoRetirar
	oClone:cNumeroRetirar       := ::cNumeroRetirar
	oClone:cCidadeRetirar       := ::cCidadeRetirar
	oClone:cUFRetirar           := ::cUFRetirar
	oClone:cBairroRetirar       := ::cBairroRetirar
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_EventoObjetoCompleto
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cDetalhesRetirar   :=  WSAdvValue( oResponse,"_DETALHESRETIRAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoRetirar     :=  WSAdvValue( oResponse,"_CODIGORETIRAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCepRetirar        :=  WSAdvValue( oResponse,"_CEPRETIRAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEnderecoRetirar   :=  WSAdvValue( oResponse,"_ENDERECORETIRAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumeroRetirar     :=  WSAdvValue( oResponse,"_NUMERORETIRAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCidadeRetirar     :=  WSAdvValue( oResponse,"_CIDADERETIRAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cUFRetirar         :=  WSAdvValue( oResponse,"_UFRETIRAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cBairroRetirar     :=  WSAdvValue( oResponse,"_BAIRRORETIRAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RetornaDados

WSSTRUCT Service1_RetornaDados
	WSDATA   oWSConteudoDescrito       AS Service1_ArrayOfConteudo OPTIONAL
	WSDATA   cVersao                   AS string OPTIONAL
	WSDATA   cTipoPesquisa             AS string OPTIONAL
	WSDATA   cTipoResultado            AS string OPTIONAL
	WSDATA   cDiretoriaRegional        AS string OPTIONAL
	WSDATA   ccodigoSto                AS string OPTIONAL
	WSDATA   nidPlp                    AS int
	WSDATA   nidPlpSara                AS int
	WSDATA   cTransportadora           AS string OPTIONAL
	WSDATA   cNomeCliente              AS string OPTIONAL
	WSDATA   cidCliVisual              AS string OPTIONAL
	WSDATA   cidDptoVisual             AS string OPTIONAL
	WSDATA   cNomeDpto                 AS string OPTIONAL
	WSDATA   cNumeroContrato           AS string OPTIONAL
	WSDATA   cNumeroCartao             AS string OPTIONAL
	WSDATA   cnumeroAdministrativo     AS string OPTIONAL
	WSDATA   cenderecoRemetente        AS string OPTIONAL
	WSDATA   cnumeroCnpjRemetente      AS string OPTIONAL
	WSDATA   cCepRemetente             AS string OPTIONAL
	WSDATA   ccomplementoRemetente     AS string OPTIONAL
	WSDATA   cbairroRemetente          AS string OPTIONAL
	WSDATA   ccidadeRemetente          AS string OPTIONAL
	WSDATA   cufRemetente              AS string OPTIONAL
	WSDATA   cfaturado                 AS string OPTIONAL
	WSDATA   cacao_Bloqueio            AS string OPTIONAL
	WSDATA   ctipo_Bloqueio            AS string OPTIONAL
	WSDATA   cmsg_Bloqueio             AS string OPTIONAL
	WSDATA   cMsgErro                  AS string OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cNotaFiscal               AS string OPTIONAL
	WSDATA   cPedido                   AS string OPTIONAL
	WSDATA   cContrato                 AS string OPTIONAL
	WSDATA   cDestinatario             AS string OPTIONAL
	WSDATA   cCpfCnpj                  AS string OPTIONAL
	WSDATA   cEndereco                 AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCidade                   AS string OPTIONAL
	WSDATA   cUf                       AS string OPTIONAL
	WSDATA   cCep                      AS string OPTIONAL
	WSDATA   cAr                       AS string OPTIONAL
	WSDATA   cmp                       AS string OPTIONAL
	WSDATA   cTipo                     AS string OPTIONAL
	WSDATA   cmaoPropria               AS string OPTIONAL
	WSDATA   coutrosFormatos           AS string OPTIONAL
	WSDATA   carDigital                AS string OPTIONAL
	WSDATA   cpostaRestante            AS string OPTIONAL
	WSDATA   ccelularDestinatario      AS string OPTIONAL
	WSDATA   cavisoCorreios            AS string OPTIONAL
	WSDATA   cservicoAdicional         AS string OPTIONAL
	WSDATA   cprioridadePostagem       AS string OPTIONAL
	WSDATA   cRegistroARDigital        AS string OPTIONAL
	WSDATA   cPedidoEcommerce          AS string OPTIONAL
	WSDATA   cchaveNfe                 AS string OPTIONAL
	WSDATA   cpdfNotaFiscal            AS base64Binary OPTIONAL
	WSDATA   cpdfEtiqueta              AS base64Binary OPTIONAL
	WSDATA   nnumeroRemetente          AS int
	WSDATA   nIdCartao                 AS int
	WSDATA   nidCliente                AS int
	WSDATA   nIdDepartamento           AS int
	WSDATA   nqtdAtivacaoRastreio      AS int
	WSDATA   nqtdAtivacaoEmail         AS int
	WSDATA   nIdUsuario                AS int
	WSDATA   nQtd                      AS int
	WSDATA   nServico                  AS int
	WSDATA   n_servico_auxiliar        AS int
	WSDATA   nPeso                     AS int
	WSDATA   nCubico                   AS int
	WSDATA   nLimite_cubico            AS int
	WSDATA   nDH                       AS int
	WSDATA   nIdEtiquetas              AS int
	WSDATA   nNumeroDestinatario       AS int
	WSDATA   nIdDados                  AS int
	WSDATA   nPrazoEntrega             AS int
	WSDATA   netiquetaLogica           AS int
	WSDATA   nobjetoFinalizado         AS int
	WSDATA   nobjetoTratatoSVP         AS int
	WSDATA   nitem                     AS int
	WSDATA   nlote                     AS int
	WSDATA   nIdSequenciaARDigital     AS int
	WSDATA   nIdArquivoARDigital       AS int
	WSDATA   ntipoRegistro             AS int
	WSDATA   nobjeto_bloqueado         AS int
	WSDATA   oWSorigemDosDados         AS Service1_OrigemDeEntradaDosDados
	WSDATA   nLargura                  AS decimal
	WSDATA   nAltura                   AS decimal
	WSDATA   nComprimento              AS decimal
	WSDATA   nDiametro                 AS decimal
	WSDATA   nValorDcl                 AS decimal
	WSDATA   nvlrAdicional             AS decimal
	WSDATA   nvlrMaoPropria            AS decimal
	WSDATA   nVlrPostagem              AS decimal
	WSDATA   nvlrCorreioWebService     AS decimal
	WSDATA   nvlrServicoAdicionalWebService AS decimal
	WSDATA   npeso_sara                AS decimal
	WSDATA   ncubico_sara              AS decimal
	WSDATA   nvlr_sara                 AS decimal
	WSDATA   nvlr_declarado_sara       AS decimal
	WSDATA   ccepObjSara               AS string OPTIONAL
	WSDATA   cpesoObjSara              AS string OPTIONAL
	WSDATA   ccubicoObjSara            AS string OPTIONAL
	WSDATA   calturaObjSara            AS string OPTIONAL
	WSDATA   clarguraObjSara           AS string OPTIONAL
	WSDATA   ccompObjSara              AS string OPTIONAL
	WSDATA   cdiametroObjSara          AS string OPTIONAL
	WSDATA   ctipoObjSara              AS string OPTIONAL
	WSDATA   cVlorDclObjSara           AS string OPTIONAL
	WSDATA   cVlrObjSara               AS string OPTIONAL
	WSDATA   lareaDeRisco              AS boolean
	WSDATA   cDataDeImpressao          AS dateTime
	WSDATA   cDataDeRetirada           AS dateTime
	WSDATA   cDataDevencimento         AS dateTime
	WSDATA   cDataPlp                  AS dateTime
	WSDATA   cdt_postagem_sara         AS dateTime
	WSDATA   cData_Postagem_sara       AS dateTime
	WSDATA   cData_Ocorrencia          AS dateTime
	WSDATA   cData_Postagem_Sro        AS dateTime
	WSDATA   cDataCriacao              AS dateTime
	WSDATA   cDataTratamentoSVP        AS dateTime
	WSDATA   cDataDeTratamento         AS dateTime
	WSDATA   cDataEnvioArDigital       AS dateTime
	WSDATA   oWS_DadosDoRemetente      AS Service1_TarifacaoCliente OPTIONAL
	WSDATA   lContinua                 AS boolean
	WSDATA   lTemEtiqueta              AS boolean
	WSDATA   ndescricaoConteudo        AS int
	WSDATA   lregistroJaExistente      AS boolean
	WSDATA   nObjetoTratado            AS int
	WSDATA   oWSObjeto                 AS Service1_EventoObjeto OPTIONAL
	WSDATA   oWSObservacoes            AS Service1_ArrayOfString OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_RetornaDados
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_RetornaDados
Return

WSMETHOD CLONE WSCLIENT Service1_RetornaDados
	Local oClone := Service1_RetornaDados():NEW()
	oClone:oWSConteudoDescrito  := IIF(::oWSConteudoDescrito = NIL , NIL , ::oWSConteudoDescrito:Clone() )
	oClone:cVersao              := ::cVersao
	oClone:cTipoPesquisa        := ::cTipoPesquisa
	oClone:cTipoResultado       := ::cTipoResultado
	oClone:cDiretoriaRegional   := ::cDiretoriaRegional
	oClone:ccodigoSto           := ::ccodigoSto
	oClone:nidPlp               := ::nidPlp
	oClone:nidPlpSara           := ::nidPlpSara
	oClone:cTransportadora      := ::cTransportadora
	oClone:cNomeCliente         := ::cNomeCliente
	oClone:cidCliVisual         := ::cidCliVisual
	oClone:cidDptoVisual        := ::cidDptoVisual
	oClone:cNomeDpto            := ::cNomeDpto
	oClone:cNumeroContrato      := ::cNumeroContrato
	oClone:cNumeroCartao        := ::cNumeroCartao
	oClone:cnumeroAdministrativo := ::cnumeroAdministrativo
	oClone:cenderecoRemetente   := ::cenderecoRemetente
	oClone:cnumeroCnpjRemetente := ::cnumeroCnpjRemetente
	oClone:cCepRemetente        := ::cCepRemetente
	oClone:ccomplementoRemetente := ::ccomplementoRemetente
	oClone:cbairroRemetente     := ::cbairroRemetente
	oClone:ccidadeRemetente     := ::ccidadeRemetente
	oClone:cufRemetente         := ::cufRemetente
	oClone:cfaturado            := ::cfaturado
	oClone:cacao_Bloqueio       := ::cacao_Bloqueio
	oClone:ctipo_Bloqueio       := ::ctipo_Bloqueio
	oClone:cmsg_Bloqueio        := ::cmsg_Bloqueio
	oClone:cMsgErro             := ::cMsgErro
	oClone:cEmail               := ::cEmail
	oClone:cNotaFiscal          := ::cNotaFiscal
	oClone:cPedido              := ::cPedido
	oClone:cContrato            := ::cContrato
	oClone:cDestinatario        := ::cDestinatario
	oClone:cCpfCnpj             := ::cCpfCnpj
	oClone:cEndereco            := ::cEndereco
	oClone:cComplemento         := ::cComplemento
	oClone:cBairro              := ::cBairro
	oClone:cCidade              := ::cCidade
	oClone:cUf                  := ::cUf
	oClone:cCep                 := ::cCep
	oClone:cAr                  := ::cAr
	oClone:cmp                  := ::cmp
	oClone:cTipo                := ::cTipo
	oClone:cmaoPropria          := ::cmaoPropria
	oClone:coutrosFormatos      := ::coutrosFormatos
	oClone:carDigital           := ::carDigital
	oClone:cpostaRestante       := ::cpostaRestante
	oClone:ccelularDestinatario := ::ccelularDestinatario
	oClone:cavisoCorreios       := ::cavisoCorreios
	oClone:cservicoAdicional    := ::cservicoAdicional
	oClone:cprioridadePostagem  := ::cprioridadePostagem
	oClone:cRegistroARDigital   := ::cRegistroARDigital
	oClone:cPedidoEcommerce     := ::cPedidoEcommerce
	oClone:cchaveNfe            := ::cchaveNfe
	oClone:cpdfNotaFiscal       := ::cpdfNotaFiscal
	oClone:cpdfEtiqueta         := ::cpdfEtiqueta
	oClone:nnumeroRemetente     := ::nnumeroRemetente
	oClone:nIdCartao            := ::nIdCartao
	oClone:nidCliente           := ::nidCliente
	oClone:nIdDepartamento      := ::nIdDepartamento
	oClone:nqtdAtivacaoRastreio := ::nqtdAtivacaoRastreio
	oClone:nqtdAtivacaoEmail    := ::nqtdAtivacaoEmail
	oClone:nIdUsuario           := ::nIdUsuario
	oClone:nQtd                 := ::nQtd
	oClone:nServico             := ::nServico
	oClone:n_servico_auxiliar   := ::n_servico_auxiliar
	oClone:nPeso                := ::nPeso
	oClone:nCubico              := ::nCubico
	oClone:nLimite_cubico       := ::nLimite_cubico
	oClone:nDH                  := ::nDH
	oClone:nIdEtiquetas         := ::nIdEtiquetas
	oClone:nNumeroDestinatario  := ::nNumeroDestinatario
	oClone:nIdDados             := ::nIdDados
	oClone:nPrazoEntrega        := ::nPrazoEntrega
	oClone:netiquetaLogica      := ::netiquetaLogica
	oClone:nobjetoFinalizado    := ::nobjetoFinalizado
	oClone:nobjetoTratatoSVP    := ::nobjetoTratatoSVP
	oClone:nitem                := ::nitem
	oClone:nlote                := ::nlote
	oClone:nIdSequenciaARDigital := ::nIdSequenciaARDigital
	oClone:nIdArquivoARDigital  := ::nIdArquivoARDigital
	oClone:ntipoRegistro        := ::ntipoRegistro
	oClone:nobjeto_bloqueado    := ::nobjeto_bloqueado
	oClone:oWSorigemDosDados    := IIF(::oWSorigemDosDados = NIL , NIL , ::oWSorigemDosDados:Clone() )
	oClone:nLargura             := ::nLargura
	oClone:nAltura              := ::nAltura
	oClone:nComprimento         := ::nComprimento
	oClone:nDiametro            := ::nDiametro
	oClone:nValorDcl            := ::nValorDcl
	oClone:nvlrAdicional        := ::nvlrAdicional
	oClone:nvlrMaoPropria       := ::nvlrMaoPropria
	oClone:nVlrPostagem         := ::nVlrPostagem
	oClone:nvlrCorreioWebService := ::nvlrCorreioWebService
	oClone:nvlrServicoAdicionalWebService := ::nvlrServicoAdicionalWebService
	oClone:npeso_sara           := ::npeso_sara
	oClone:ncubico_sara         := ::ncubico_sara
	oClone:nvlr_sara            := ::nvlr_sara
	oClone:nvlr_declarado_sara  := ::nvlr_declarado_sara
	oClone:ccepObjSara          := ::ccepObjSara
	oClone:cpesoObjSara         := ::cpesoObjSara
	oClone:ccubicoObjSara       := ::ccubicoObjSara
	oClone:calturaObjSara       := ::calturaObjSara
	oClone:clarguraObjSara      := ::clarguraObjSara
	oClone:ccompObjSara         := ::ccompObjSara
	oClone:cdiametroObjSara     := ::cdiametroObjSara
	oClone:ctipoObjSara         := ::ctipoObjSara
	oClone:cVlorDclObjSara      := ::cVlorDclObjSara
	oClone:cVlrObjSara          := ::cVlrObjSara
	oClone:lareaDeRisco         := ::lareaDeRisco
	oClone:cDataDeImpressao     := ::cDataDeImpressao
	oClone:cDataDeRetirada      := ::cDataDeRetirada
	oClone:cDataDevencimento    := ::cDataDevencimento
	oClone:cDataPlp             := ::cDataPlp
	oClone:cdt_postagem_sara    := ::cdt_postagem_sara
	oClone:cData_Postagem_sara  := ::cData_Postagem_sara
	oClone:cData_Ocorrencia     := ::cData_Ocorrencia
	oClone:cData_Postagem_Sro   := ::cData_Postagem_Sro
	oClone:cDataCriacao         := ::cDataCriacao
	oClone:cDataTratamentoSVP   := ::cDataTratamentoSVP
	oClone:cDataDeTratamento    := ::cDataDeTratamento
	oClone:cDataEnvioArDigital  := ::cDataEnvioArDigital
	oClone:oWS_DadosDoRemetente := IIF(::oWS_DadosDoRemetente = NIL , NIL , ::oWS_DadosDoRemetente:Clone() )
	oClone:lContinua            := ::lContinua
	oClone:lTemEtiqueta         := ::lTemEtiqueta
	oClone:ndescricaoConteudo   := ::ndescricaoConteudo
	oClone:lregistroJaExistente := ::lregistroJaExistente
	oClone:nObjetoTratado       := ::nObjetoTratado
	oClone:oWSObjeto            := IIF(::oWSObjeto = NIL , NIL , ::oWSObjeto:Clone() )
	oClone:oWSObservacoes       := IIF(::oWSObservacoes = NIL , NIL , ::oWSObservacoes:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_RetornaDados
	Local cSoap := ""
	cSoap += WSSoapValue("ConteudoDescrito", ::oWSConteudoDescrito, ::oWSConteudoDescrito , "ArrayOfConteudo", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Versao", ::cVersao, ::cVersao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoPesquisa", ::cTipoPesquisa, ::cTipoPesquisa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoResultado", ::cTipoResultado, ::cTipoResultado , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DiretoriaRegional", ::cDiretoriaRegional, ::cDiretoriaRegional , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("codigoSto", ::ccodigoSto, ::ccodigoSto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idPlp", ::nidPlp, ::nidPlp , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idPlpSara", ::nidPlpSara, ::nidPlpSara , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Transportadora", ::cTransportadora, ::cTransportadora , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NomeCliente", ::cNomeCliente, ::cNomeCliente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idCliVisual", ::cidCliVisual, ::cidCliVisual , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idDptoVisual", ::cidDptoVisual, ::cidDptoVisual , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NomeDpto", ::cNomeDpto, ::cNomeDpto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroContrato", ::cNumeroContrato, ::cNumeroContrato , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroCartao", ::cNumeroCartao, ::cNumeroCartao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numeroAdministrativo", ::cnumeroAdministrativo, ::cnumeroAdministrativo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("enderecoRemetente", ::cenderecoRemetente, ::cenderecoRemetente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numeroCnpjRemetente", ::cnumeroCnpjRemetente, ::cnumeroCnpjRemetente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CepRemetente", ::cCepRemetente, ::cCepRemetente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("complementoRemetente", ::ccomplementoRemetente, ::ccomplementoRemetente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("bairroRemetente", ::cbairroRemetente, ::cbairroRemetente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cidadeRemetente", ::ccidadeRemetente, ::ccidadeRemetente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ufRemetente", ::cufRemetente, ::cufRemetente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("faturado", ::cfaturado, ::cfaturado , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("acao_Bloqueio", ::cacao_Bloqueio, ::cacao_Bloqueio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("tipo_Bloqueio", ::ctipo_Bloqueio, ::ctipo_Bloqueio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("msg_Bloqueio", ::cmsg_Bloqueio, ::cmsg_Bloqueio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("MsgErro", ::cMsgErro, ::cMsgErro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NotaFiscal", ::cNotaFiscal, ::cNotaFiscal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Pedido", ::cPedido, ::cPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Contrato", ::cContrato, ::cContrato , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Destinatario", ::cDestinatario, ::cDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CpfCnpj", ::cCpfCnpj, ::cCpfCnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Endereco", ::cEndereco, ::cEndereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Complemento", ::cComplemento, ::cComplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Cidade", ::cCidade, ::cCidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Uf", ::cUf, ::cUf , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Cep", ::cCep, ::cCep , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Ar", ::cAr, ::cAr , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("mp", ::cmp, ::cmp , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Tipo", ::cTipo, ::cTipo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("maoPropria", ::cmaoPropria, ::cmaoPropria , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("outrosFormatos", ::coutrosFormatos, ::coutrosFormatos , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("arDigital", ::carDigital, ::carDigital , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("postaRestante", ::cpostaRestante, ::cpostaRestante , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("celularDestinatario", ::ccelularDestinatario, ::ccelularDestinatario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("avisoCorreios", ::cavisoCorreios, ::cavisoCorreios , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("servicoAdicional", ::cservicoAdicional, ::cservicoAdicional , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("prioridadePostagem", ::cprioridadePostagem, ::cprioridadePostagem , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RegistroARDigital", ::cRegistroARDigital, ::cRegistroARDigital , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PedidoEcommerce", ::cPedidoEcommerce, ::cPedidoEcommerce , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("chaveNfe", ::cchaveNfe, ::cchaveNfe , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("pdfNotaFiscal", ::cpdfNotaFiscal, ::cpdfNotaFiscal , "base64Binary", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("pdfEtiqueta", ::cpdfEtiqueta, ::cpdfEtiqueta , "base64Binary", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numeroRemetente", ::nnumeroRemetente, ::nnumeroRemetente , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdCartao", ::nIdCartao, ::nIdCartao , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idCliente", ::nidCliente, ::nidCliente , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdDepartamento", ::nIdDepartamento, ::nIdDepartamento , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("qtdAtivacaoRastreio", ::nqtdAtivacaoRastreio, ::nqtdAtivacaoRastreio , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("qtdAtivacaoEmail", ::nqtdAtivacaoEmail, ::nqtdAtivacaoEmail , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdUsuario", ::nIdUsuario, ::nIdUsuario , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Qtd", ::nQtd, ::nQtd , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Servico", ::nServico, ::nServico , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("_servico_auxiliar", ::n_servico_auxiliar, ::n_servico_auxiliar , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Peso", ::nPeso, ::nPeso , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Cubico", ::nCubico, ::nCubico , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Limite_cubico", ::nLimite_cubico, ::nLimite_cubico , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DH", ::nDH, ::nDH , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdEtiquetas", ::nIdEtiquetas, ::nIdEtiquetas , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NumeroDestinatario", ::nNumeroDestinatario, ::nNumeroDestinatario , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdDados", ::nIdDados, ::nIdDados , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PrazoEntrega", ::nPrazoEntrega, ::nPrazoEntrega , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("etiquetaLogica", ::netiquetaLogica, ::netiquetaLogica , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("objetoFinalizado", ::nobjetoFinalizado, ::nobjetoFinalizado , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("objetoTratatoSVP", ::nobjetoTratatoSVP, ::nobjetoTratatoSVP , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("item", ::nitem, ::nitem , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("lote", ::nlote, ::nlote , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdSequenciaARDigital", ::nIdSequenciaARDigital, ::nIdSequenciaARDigital , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IdArquivoARDigital", ::nIdArquivoARDigital, ::nIdArquivoARDigital , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("tipoRegistro", ::ntipoRegistro, ::ntipoRegistro , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("objeto_bloqueado", ::nobjeto_bloqueado, ::nobjeto_bloqueado , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("origemDosDados", ::oWSorigemDosDados, ::oWSorigemDosDados , "OrigemDeEntradaDosDados", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Largura", ::nLargura, ::nLargura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Altura", ::nAltura, ::nAltura , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Comprimento", ::nComprimento, ::nComprimento , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Diametro", ::nDiametro, ::nDiametro , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorDcl", ::nValorDcl, ::nValorDcl , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("vlrAdicional", ::nvlrAdicional, ::nvlrAdicional , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("vlrMaoPropria", ::nvlrMaoPropria, ::nvlrMaoPropria , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("VlrPostagem", ::nVlrPostagem, ::nVlrPostagem , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("vlrCorreioWebService", ::nvlrCorreioWebService, ::nvlrCorreioWebService , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("vlrServicoAdicionalWebService", ::nvlrServicoAdicionalWebService, ::nvlrServicoAdicionalWebService , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("peso_sara", ::npeso_sara, ::npeso_sara , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cubico_sara", ::ncubico_sara, ::ncubico_sara , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("vlr_sara", ::nvlr_sara, ::nvlr_sara , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("vlr_declarado_sara", ::nvlr_declarado_sara, ::nvlr_declarado_sara , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cepObjSara", ::ccepObjSara, ::ccepObjSara , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("pesoObjSara", ::cpesoObjSara, ::cpesoObjSara , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cubicoObjSara", ::ccubicoObjSara, ::ccubicoObjSara , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("alturaObjSara", ::calturaObjSara, ::calturaObjSara , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("larguraObjSara", ::clarguraObjSara, ::clarguraObjSara , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("compObjSara", ::ccompObjSara, ::ccompObjSara , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("diametroObjSara", ::cdiametroObjSara, ::cdiametroObjSara , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("tipoObjSara", ::ctipoObjSara, ::ctipoObjSara , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("VlorDclObjSara", ::cVlorDclObjSara, ::cVlorDclObjSara , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("VlrObjSara", ::cVlrObjSara, ::cVlrObjSara , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("areaDeRisco", ::lareaDeRisco, ::lareaDeRisco , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataDeImpressao", ::cDataDeImpressao, ::cDataDeImpressao , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataDeRetirada", ::cDataDeRetirada, ::cDataDeRetirada , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataDevencimento", ::cDataDevencimento, ::cDataDevencimento , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataPlp", ::cDataPlp, ::cDataPlp , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("dt_postagem_sara", ::cdt_postagem_sara, ::cdt_postagem_sara , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Data_Postagem_sara", ::cData_Postagem_sara, ::cData_Postagem_sara , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Data_Ocorrencia", ::cData_Ocorrencia, ::cData_Ocorrencia , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Data_Postagem_Sro", ::cData_Postagem_Sro, ::cData_Postagem_Sro , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataCriacao", ::cDataCriacao, ::cDataCriacao , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataTratamentoSVP", ::cDataTratamentoSVP, ::cDataTratamentoSVP , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataDeTratamento", ::cDataDeTratamento, ::cDataDeTratamento , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataEnvioArDigital", ::cDataEnvioArDigital, ::cDataEnvioArDigital , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("_DadosDoRemetente", ::oWS_DadosDoRemetente, ::oWS_DadosDoRemetente , "TarifacaoCliente", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Continua", ::lContinua, ::lContinua , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TemEtiqueta", ::lTemEtiqueta, ::lTemEtiqueta , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("descricaoConteudo", ::ndescricaoConteudo, ::ndescricaoConteudo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("registroJaExistente", ::lregistroJaExistente, ::lregistroJaExistente , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ObjetoTratado", ::nObjetoTratado, ::nObjetoTratado , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Objeto", ::oWSObjeto, ::oWSObjeto , "EventoObjeto", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Observacoes", ::oWSObservacoes, ::oWSObservacoes , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_RetornaDados
	Local oNode1
	Local oNode84
	Local oNode122
	Local oNode128
	Local oNode129
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_CONTEUDODESCRITO","ArrayOfConteudo",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSConteudoDescrito := Service1_ArrayOfConteudo():New()
		::oWSConteudoDescrito:SoapRecv(oNode1)
	EndIf
	::cVersao            :=  WSAdvValue( oResponse,"_VERSAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTipoPesquisa      :=  WSAdvValue( oResponse,"_TIPOPESQUISA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTipoResultado     :=  WSAdvValue( oResponse,"_TIPORESULTADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDiretoriaRegional :=  WSAdvValue( oResponse,"_DIRETORIAREGIONAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodigoSto         :=  WSAdvValue( oResponse,"_CODIGOSTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nidPlp             :=  WSAdvValue( oResponse,"_IDPLP","int",NIL,"Property nidPlp as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nidPlpSara         :=  WSAdvValue( oResponse,"_IDPLPSARA","int",NIL,"Property nidPlpSara as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cTransportadora    :=  WSAdvValue( oResponse,"_TRANSPORTADORA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeCliente       :=  WSAdvValue( oResponse,"_NOMECLIENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cidCliVisual       :=  WSAdvValue( oResponse,"_IDCLIVISUAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cidDptoVisual      :=  WSAdvValue( oResponse,"_IDDPTOVISUAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeDpto          :=  WSAdvValue( oResponse,"_NOMEDPTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumeroContrato    :=  WSAdvValue( oResponse,"_NUMEROCONTRATO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumeroCartao      :=  WSAdvValue( oResponse,"_NUMEROCARTAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cnumeroAdministrativo :=  WSAdvValue( oResponse,"_NUMEROADMINISTRATIVO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cenderecoRemetente :=  WSAdvValue( oResponse,"_ENDERECOREMETENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cnumeroCnpjRemetente :=  WSAdvValue( oResponse,"_NUMEROCNPJREMETENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCepRemetente      :=  WSAdvValue( oResponse,"_CEPREMETENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccomplementoRemetente :=  WSAdvValue( oResponse,"_COMPLEMENTOREMETENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cbairroRemetente   :=  WSAdvValue( oResponse,"_BAIRROREMETENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccidadeRemetente   :=  WSAdvValue( oResponse,"_CIDADEREMETENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cufRemetente       :=  WSAdvValue( oResponse,"_UFREMETENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cfaturado          :=  WSAdvValue( oResponse,"_FATURADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cacao_Bloqueio     :=  WSAdvValue( oResponse,"_ACAO_BLOQUEIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctipo_Bloqueio     :=  WSAdvValue( oResponse,"_TIPO_BLOQUEIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cmsg_Bloqueio      :=  WSAdvValue( oResponse,"_MSG_BLOQUEIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMsgErro           :=  WSAdvValue( oResponse,"_MSGERRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNotaFiscal        :=  WSAdvValue( oResponse,"_NOTAFISCAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPedido            :=  WSAdvValue( oResponse,"_PEDIDO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cContrato          :=  WSAdvValue( oResponse,"_CONTRATO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDestinatario      :=  WSAdvValue( oResponse,"_DESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCpfCnpj           :=  WSAdvValue( oResponse,"_CPFCNPJ","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEndereco          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cComplemento       :=  WSAdvValue( oResponse,"_COMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cBairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cUf                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCep               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAr                :=  WSAdvValue( oResponse,"_AR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cmp                :=  WSAdvValue( oResponse,"_MP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTipo              :=  WSAdvValue( oResponse,"_TIPO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cmaoPropria        :=  WSAdvValue( oResponse,"_MAOPROPRIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::coutrosFormatos    :=  WSAdvValue( oResponse,"_OUTROSFORMATOS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::carDigital         :=  WSAdvValue( oResponse,"_ARDIGITAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cpostaRestante     :=  WSAdvValue( oResponse,"_POSTARESTANTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccelularDestinatario :=  WSAdvValue( oResponse,"_CELULARDESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cavisoCorreios     :=  WSAdvValue( oResponse,"_AVISOCORREIOS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cservicoAdicional  :=  WSAdvValue( oResponse,"_SERVICOADICIONAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cprioridadePostagem :=  WSAdvValue( oResponse,"_PRIORIDADEPOSTAGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRegistroARDigital :=  WSAdvValue( oResponse,"_REGISTROARDIGITAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPedidoEcommerce   :=  WSAdvValue( oResponse,"_PEDIDOECOMMERCE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cchaveNfe          :=  WSAdvValue( oResponse,"_CHAVENFE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cpdfNotaFiscal     :=  WSAdvValue( oResponse,"_PDFNOTAFISCAL","base64Binary",NIL,NIL,NIL,"SB",NIL,NIL) 
	::cpdfEtiqueta       :=  WSAdvValue( oResponse,"_PDFETIQUETA","base64Binary",NIL,NIL,NIL,"SB",NIL,NIL) 
	::nnumeroRemetente   :=  WSAdvValue( oResponse,"_NUMEROREMETENTE","int",NIL,"Property nnumeroRemetente as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nIdCartao          :=  WSAdvValue( oResponse,"_IDCARTAO","int",NIL,"Property nIdCartao as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nidCliente         :=  WSAdvValue( oResponse,"_IDCLIENTE","int",NIL,"Property nidCliente as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nIdDepartamento    :=  WSAdvValue( oResponse,"_IDDEPARTAMENTO","int",NIL,"Property nIdDepartamento as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nqtdAtivacaoRastreio :=  WSAdvValue( oResponse,"_QTDATIVACAORASTREIO","int",NIL,"Property nqtdAtivacaoRastreio as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nqtdAtivacaoEmail  :=  WSAdvValue( oResponse,"_QTDATIVACAOEMAIL","int",NIL,"Property nqtdAtivacaoEmail as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nIdUsuario         :=  WSAdvValue( oResponse,"_IDUSUARIO","int",NIL,"Property nIdUsuario as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nQtd               :=  WSAdvValue( oResponse,"_QTD","int",NIL,"Property nQtd as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nServico           :=  WSAdvValue( oResponse,"_SERVICO","int",NIL,"Property nServico as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::n_servico_auxiliar :=  WSAdvValue( oResponse,"__SERVICO_AUXILIAR","int",NIL,"Property n_servico_auxiliar as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPeso              :=  WSAdvValue( oResponse,"_PESO","int",NIL,"Property nPeso as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nCubico            :=  WSAdvValue( oResponse,"_CUBICO","int",NIL,"Property nCubico as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nLimite_cubico     :=  WSAdvValue( oResponse,"_LIMITE_CUBICO","int",NIL,"Property nLimite_cubico as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nDH                :=  WSAdvValue( oResponse,"_DH","int",NIL,"Property nDH as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nIdEtiquetas       :=  WSAdvValue( oResponse,"_IDETIQUETAS","int",NIL,"Property nIdEtiquetas as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumeroDestinatario :=  WSAdvValue( oResponse,"_NUMERODESTINATARIO","int",NIL,"Property nNumeroDestinatario as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nIdDados           :=  WSAdvValue( oResponse,"_IDDADOS","int",NIL,"Property nIdDados as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPrazoEntrega      :=  WSAdvValue( oResponse,"_PRAZOENTREGA","int",NIL,"Property nPrazoEntrega as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::netiquetaLogica    :=  WSAdvValue( oResponse,"_ETIQUETALOGICA","int",NIL,"Property netiquetaLogica as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nobjetoFinalizado  :=  WSAdvValue( oResponse,"_OBJETOFINALIZADO","int",NIL,"Property nobjetoFinalizado as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nobjetoTratatoSVP  :=  WSAdvValue( oResponse,"_OBJETOTRATATOSVP","int",NIL,"Property nobjetoTratatoSVP as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nitem              :=  WSAdvValue( oResponse,"_ITEM","int",NIL,"Property nitem as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nlote              :=  WSAdvValue( oResponse,"_LOTE","int",NIL,"Property nlote as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nIdSequenciaARDigital :=  WSAdvValue( oResponse,"_IDSEQUENCIAARDIGITAL","int",NIL,"Property nIdSequenciaARDigital as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nIdArquivoARDigital :=  WSAdvValue( oResponse,"_IDARQUIVOARDIGITAL","int",NIL,"Property nIdArquivoARDigital as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ntipoRegistro      :=  WSAdvValue( oResponse,"_TIPOREGISTRO","int",NIL,"Property ntipoRegistro as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nobjeto_bloqueado  :=  WSAdvValue( oResponse,"_OBJETO_BLOQUEADO","int",NIL,"Property nobjeto_bloqueado as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode84 :=  WSAdvValue( oResponse,"_ORIGEMDOSDADOS","OrigemDeEntradaDosDados",NIL,"Property oWSorigemDosDados as tns:OrigemDeEntradaDosDados on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode84 != NIL
		::oWSorigemDosDados := Service1_OrigemDeEntradaDosDados():New()
		::oWSorigemDosDados:SoapRecv(oNode84)
	EndIf
	::nLargura           :=  WSAdvValue( oResponse,"_LARGURA","decimal",NIL,"Property nLargura as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nAltura            :=  WSAdvValue( oResponse,"_ALTURA","decimal",NIL,"Property nAltura as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nComprimento       :=  WSAdvValue( oResponse,"_COMPRIMENTO","decimal",NIL,"Property nComprimento as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nDiametro          :=  WSAdvValue( oResponse,"_DIAMETRO","decimal",NIL,"Property nDiametro as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValorDcl          :=  WSAdvValue( oResponse,"_VALORDCL","decimal",NIL,"Property nValorDcl as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nvlrAdicional      :=  WSAdvValue( oResponse,"_VLRADICIONAL","decimal",NIL,"Property nvlrAdicional as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nvlrMaoPropria     :=  WSAdvValue( oResponse,"_VLRMAOPROPRIA","decimal",NIL,"Property nvlrMaoPropria as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nVlrPostagem       :=  WSAdvValue( oResponse,"_VLRPOSTAGEM","decimal",NIL,"Property nVlrPostagem as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nvlrCorreioWebService :=  WSAdvValue( oResponse,"_VLRCORREIOWEBSERVICE","decimal",NIL,"Property nvlrCorreioWebService as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nvlrServicoAdicionalWebService :=  WSAdvValue( oResponse,"_VLRSERVICOADICIONALWEBSERVICE","decimal",NIL,"Property nvlrServicoAdicionalWebService as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::npeso_sara         :=  WSAdvValue( oResponse,"_PESO_SARA","decimal",NIL,"Property npeso_sara as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ncubico_sara       :=  WSAdvValue( oResponse,"_CUBICO_SARA","decimal",NIL,"Property ncubico_sara as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nvlr_sara          :=  WSAdvValue( oResponse,"_VLR_SARA","decimal",NIL,"Property nvlr_sara as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nvlr_declarado_sara :=  WSAdvValue( oResponse,"_VLR_DECLARADO_SARA","decimal",NIL,"Property nvlr_declarado_sara as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ccepObjSara        :=  WSAdvValue( oResponse,"_CEPOBJSARA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cpesoObjSara       :=  WSAdvValue( oResponse,"_PESOOBJSARA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccubicoObjSara     :=  WSAdvValue( oResponse,"_CUBICOOBJSARA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::calturaObjSara     :=  WSAdvValue( oResponse,"_ALTURAOBJSARA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::clarguraObjSara    :=  WSAdvValue( oResponse,"_LARGURAOBJSARA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccompObjSara       :=  WSAdvValue( oResponse,"_COMPOBJSARA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdiametroObjSara   :=  WSAdvValue( oResponse,"_DIAMETROOBJSARA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctipoObjSara       :=  WSAdvValue( oResponse,"_TIPOOBJSARA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cVlorDclObjSara    :=  WSAdvValue( oResponse,"_VLORDCLOBJSARA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cVlrObjSara        :=  WSAdvValue( oResponse,"_VLROBJSARA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lareaDeRisco       :=  WSAdvValue( oResponse,"_AREADERISCO","boolean",NIL,"Property lareaDeRisco as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::cDataDeImpressao   :=  WSAdvValue( oResponse,"_DATADEIMPRESSAO","dateTime",NIL,"Property cDataDeImpressao as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDataDeRetirada    :=  WSAdvValue( oResponse,"_DATADERETIRADA","dateTime",NIL,"Property cDataDeRetirada as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDataDevencimento  :=  WSAdvValue( oResponse,"_DATADEVENCIMENTO","dateTime",NIL,"Property cDataDevencimento as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDataPlp           :=  WSAdvValue( oResponse,"_DATAPLP","dateTime",NIL,"Property cDataPlp as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cdt_postagem_sara  :=  WSAdvValue( oResponse,"_DT_POSTAGEM_SARA","dateTime",NIL,"Property cdt_postagem_sara as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cData_Postagem_sara :=  WSAdvValue( oResponse,"_DATA_POSTAGEM_SARA","dateTime",NIL,"Property cData_Postagem_sara as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cData_Ocorrencia   :=  WSAdvValue( oResponse,"_DATA_OCORRENCIA","dateTime",NIL,"Property cData_Ocorrencia as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cData_Postagem_Sro :=  WSAdvValue( oResponse,"_DATA_POSTAGEM_SRO","dateTime",NIL,"Property cData_Postagem_Sro as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDataCriacao       :=  WSAdvValue( oResponse,"_DATACRIACAO","dateTime",NIL,"Property cDataCriacao as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDataTratamentoSVP :=  WSAdvValue( oResponse,"_DATATRATAMENTOSVP","dateTime",NIL,"Property cDataTratamentoSVP as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDataDeTratamento  :=  WSAdvValue( oResponse,"_DATADETRATAMENTO","dateTime",NIL,"Property cDataDeTratamento as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDataEnvioArDigital :=  WSAdvValue( oResponse,"_DATAENVIOARDIGITAL","dateTime",NIL,"Property cDataEnvioArDigital as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	oNode122 :=  WSAdvValue( oResponse,"__DADOSDOREMETENTE","TarifacaoCliente",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode122 != NIL
		::oWS_DadosDoRemetente := Service1_TarifacaoCliente():New()
		::oWS_DadosDoRemetente:SoapRecv(oNode122)
	EndIf
	::lContinua          :=  WSAdvValue( oResponse,"_CONTINUA","boolean",NIL,"Property lContinua as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::lTemEtiqueta       :=  WSAdvValue( oResponse,"_TEMETIQUETA","boolean",NIL,"Property lTemEtiqueta as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::ndescricaoConteudo :=  WSAdvValue( oResponse,"_DESCRICAOCONTEUDO","int",NIL,"Property ndescricaoConteudo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::lregistroJaExistente :=  WSAdvValue( oResponse,"_REGISTROJAEXISTENTE","boolean",NIL,"Property lregistroJaExistente as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::nObjetoTratado     :=  WSAdvValue( oResponse,"_OBJETOTRATADO","int",NIL,"Property nObjetoTratado as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode128 :=  WSAdvValue( oResponse,"_OBJETO","EventoObjeto",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode128 != NIL
		::oWSObjeto := Service1_EventoObjeto():New()
		::oWSObjeto:SoapRecv(oNode128)
	EndIf
	oNode129 :=  WSAdvValue( oResponse,"_OBSERVACOES","ArrayOfString",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode129 != NIL
		::oWSObservacoes := Service1_ArrayOfString():New()
		::oWSObservacoes:SoapRecv(oNode129)
	EndIf
Return

// WSDL Data Structure ObjetoPLP

WSSTRUCT Service1_ObjetoPLP
	WSDATA   nnumeroPLP                AS long
	WSDATA   cregistro                 AS string OPTIONAL
	WSDATA   ccodServico               AS string OPTIONAL
	WSDATA   ntipoObjeto               AS int
	WSDATA   nvalor                    AS decimal
	WSDATA   ccartaoPostagem           AS string OPTIONAL
	WSDATA   cnomeDestinatario         AS string OPTIONAL
	WSDATA   clogradouroDestinatario   AS string OPTIONAL
	WSDATA   nnumeroDestinatario       AS int
	WSDATA   ccomplementoDestinatario  AS string OPTIONAL
	WSDATA   cbairroDestinatario       AS string OPTIONAL
	WSDATA   ccidadeDestinatario       AS string OPTIONAL
	WSDATA   cufDestinatario           AS string OPTIONAL
	WSDATA   ccepDestinatario          AS string OPTIONAL
	WSDATA   ccepRemetente             AS string OPTIONAL
	WSDATA   cpesoReal                 AS string OPTIONAL
	WSDATA   cpesoCubico               AS string OPTIONAL
	WSDATA   nvalorDeclarado           AS decimal
	WSDATA   ccomprovante              AS string OPTIONAL
	WSDATA   naltura                   AS decimal
	WSDATA   nlargura                  AS decimal
	WSDATA   ncomprimento              AS decimal
	WSDATA   ndiametro                 AS decimal
	WSDATA   nadicionalAR              AS int
	WSDATA   nadicionalMP              AS int
	WSDATA   cdataPostagem             AS dateTime
	WSDATA   cdataPesquisa             AS dateTime
	WSDATA   cmsgErro                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ObjetoPLP
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ObjetoPLP
Return

WSMETHOD CLONE WSCLIENT Service1_ObjetoPLP
	Local oClone := Service1_ObjetoPLP():NEW()
	oClone:nnumeroPLP           := ::nnumeroPLP
	oClone:cregistro            := ::cregistro
	oClone:ccodServico          := ::ccodServico
	oClone:ntipoObjeto          := ::ntipoObjeto
	oClone:nvalor               := ::nvalor
	oClone:ccartaoPostagem      := ::ccartaoPostagem
	oClone:cnomeDestinatario    := ::cnomeDestinatario
	oClone:clogradouroDestinatario := ::clogradouroDestinatario
	oClone:nnumeroDestinatario  := ::nnumeroDestinatario
	oClone:ccomplementoDestinatario := ::ccomplementoDestinatario
	oClone:cbairroDestinatario  := ::cbairroDestinatario
	oClone:ccidadeDestinatario  := ::ccidadeDestinatario
	oClone:cufDestinatario      := ::cufDestinatario
	oClone:ccepDestinatario     := ::ccepDestinatario
	oClone:ccepRemetente        := ::ccepRemetente
	oClone:cpesoReal            := ::cpesoReal
	oClone:cpesoCubico          := ::cpesoCubico
	oClone:nvalorDeclarado      := ::nvalorDeclarado
	oClone:ccomprovante         := ::ccomprovante
	oClone:naltura              := ::naltura
	oClone:nlargura             := ::nlargura
	oClone:ncomprimento         := ::ncomprimento
	oClone:ndiametro            := ::ndiametro
	oClone:nadicionalAR         := ::nadicionalAR
	oClone:nadicionalMP         := ::nadicionalMP
	oClone:cdataPostagem        := ::cdataPostagem
	oClone:cdataPesquisa        := ::cdataPesquisa
	oClone:cmsgErro             := ::cmsgErro
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ObjetoPLP
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nnumeroPLP         :=  WSAdvValue( oResponse,"_NUMEROPLP","long",NIL,"Property nnumeroPLP as s:long on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cregistro          :=  WSAdvValue( oResponse,"_REGISTRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodServico        :=  WSAdvValue( oResponse,"_CODSERVICO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ntipoObjeto        :=  WSAdvValue( oResponse,"_TIPOOBJETO","int",NIL,"Property ntipoObjeto as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nvalor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,"Property nvalor as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ccartaoPostagem    :=  WSAdvValue( oResponse,"_CARTAOPOSTAGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cnomeDestinatario  :=  WSAdvValue( oResponse,"_NOMEDESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::clogradouroDestinatario :=  WSAdvValue( oResponse,"_LOGRADOURODESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nnumeroDestinatario :=  WSAdvValue( oResponse,"_NUMERODESTINATARIO","int",NIL,"Property nnumeroDestinatario as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ccomplementoDestinatario :=  WSAdvValue( oResponse,"_COMPLEMENTODESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cbairroDestinatario :=  WSAdvValue( oResponse,"_BAIRRODESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccidadeDestinatario :=  WSAdvValue( oResponse,"_CIDADEDESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cufDestinatario    :=  WSAdvValue( oResponse,"_UFDESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccepDestinatario   :=  WSAdvValue( oResponse,"_CEPDESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccepRemetente      :=  WSAdvValue( oResponse,"_CEPREMETENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cpesoReal          :=  WSAdvValue( oResponse,"_PESOREAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cpesoCubico        :=  WSAdvValue( oResponse,"_PESOCUBICO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nvalorDeclarado    :=  WSAdvValue( oResponse,"_VALORDECLARADO","decimal",NIL,"Property nvalorDeclarado as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ccomprovante       :=  WSAdvValue( oResponse,"_COMPROVANTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::naltura            :=  WSAdvValue( oResponse,"_ALTURA","decimal",NIL,"Property naltura as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nlargura           :=  WSAdvValue( oResponse,"_LARGURA","decimal",NIL,"Property nlargura as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ncomprimento       :=  WSAdvValue( oResponse,"_COMPRIMENTO","decimal",NIL,"Property ncomprimento as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ndiametro          :=  WSAdvValue( oResponse,"_DIAMETRO","decimal",NIL,"Property ndiametro as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nadicionalAR       :=  WSAdvValue( oResponse,"_ADICIONALAR","int",NIL,"Property nadicionalAR as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nadicionalMP       :=  WSAdvValue( oResponse,"_ADICIONALMP","int",NIL,"Property nadicionalMP as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cdataPostagem      :=  WSAdvValue( oResponse,"_DATAPOSTAGEM","dateTime",NIL,"Property cdataPostagem as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cdataPesquisa      :=  WSAdvValue( oResponse,"_DATAPESQUISA","dateTime",NIL,"Property cdataPesquisa as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cmsgErro           :=  WSAdvValue( oResponse,"_MSGERRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ObjetosEConteudosRetorno

WSSTRUCT Service1_ObjetosEConteudosRetorno
	WSDATA   cNumeroDoRegistro         AS string OPTIONAL
	WSDATA   oWSConteudoDasPostagens   AS Service1_ArrayOfNewPostagensConteudos OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ObjetosEConteudosRetorno
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ObjetosEConteudosRetorno
Return

WSMETHOD CLONE WSCLIENT Service1_ObjetosEConteudosRetorno
	Local oClone := Service1_ObjetosEConteudosRetorno():NEW()
	oClone:cNumeroDoRegistro    := ::cNumeroDoRegistro
	oClone:oWSConteudoDasPostagens := IIF(::oWSConteudoDasPostagens = NIL , NIL , ::oWSConteudoDasPostagens:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ObjetosEConteudosRetorno
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cNumeroDoRegistro  :=  WSAdvValue( oResponse,"_NUMERODOREGISTRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_CONTEUDODASPOSTAGENS","ArrayOfNewPostagensConteudos",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSConteudoDasPostagens := Service1_ArrayOfNewPostagensConteudos():New()
		::oWSConteudoDasPostagens:SoapRecv(oNode2)
	EndIf
Return

// WSDL Data Structure NewCliente

WSSTRUCT Service1_NewCliente
	WSDATA   nCodigo                   AS int
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cNomeFantasia             AS string OPTIONAL
	WSDATA   cCpfCnpj                  AS string OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cLogotipo                 AS string OPTIONAL
	WSDATA   cusuarioSigepWeb          AS string OPTIONAL
	WSDATA   csenhaSigepWeb            AS string OPTIONAL
	WSDATA   cNomeFilial               AS string OPTIONAL
	WSDATA   ccnpjFilial               AS string OPTIONAL
	WSDATA   oWSEndereco               AS Service1_NewDadosEndereco OPTIONAL
	WSDATA   oWSDepartamento           AS Service1_ArrayOfNewClienteDepartamento OPTIONAL
	WSDATA   oWSEventos                AS Service1_ArrayOfNewEventoObjeto OPTIONAL
	WSDATA   oWSConteudos              AS Service1_ArrayOfNewPostagensConteudos OPTIONAL
	WSDATA   cDataInicial              AS dateTime
	WSDATA   cDataFinal                AS dateTime
	WSDATA   nIdDoCliente              AS int
	WSDATA   nIdFilial                 AS int
	WSDATA   nIdDepartamento           AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_NewCliente
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_NewCliente
Return

WSMETHOD CLONE WSCLIENT Service1_NewCliente
	Local oClone := Service1_NewCliente():NEW()
	oClone:nCodigo              := ::nCodigo
	oClone:cNome                := ::cNome
	oClone:cNomeFantasia        := ::cNomeFantasia
	oClone:cCpfCnpj             := ::cCpfCnpj
	oClone:cEmail               := ::cEmail
	oClone:cLogotipo            := ::cLogotipo
	oClone:cusuarioSigepWeb     := ::cusuarioSigepWeb
	oClone:csenhaSigepWeb       := ::csenhaSigepWeb
	oClone:cNomeFilial          := ::cNomeFilial
	oClone:ccnpjFilial          := ::ccnpjFilial
	oClone:oWSEndereco          := IIF(::oWSEndereco = NIL , NIL , ::oWSEndereco:Clone() )
	oClone:oWSDepartamento      := IIF(::oWSDepartamento = NIL , NIL , ::oWSDepartamento:Clone() )
	oClone:oWSEventos           := IIF(::oWSEventos = NIL , NIL , ::oWSEventos:Clone() )
	oClone:oWSConteudos         := IIF(::oWSConteudos = NIL , NIL , ::oWSConteudos:Clone() )
	oClone:cDataInicial         := ::cDataInicial
	oClone:cDataFinal           := ::cDataFinal
	oClone:nIdDoCliente         := ::nIdDoCliente
	oClone:nIdFilial            := ::nIdFilial
	oClone:nIdDepartamento      := ::nIdDepartamento
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_NewCliente
	Local oNode11
	Local oNode12
	Local oNode13
	Local oNode14
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeFantasia      :=  WSAdvValue( oResponse,"_NOMEFANTASIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCpfCnpj           :=  WSAdvValue( oResponse,"_CPFCNPJ","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLogotipo          :=  WSAdvValue( oResponse,"_LOGOTIPO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cusuarioSigepWeb   :=  WSAdvValue( oResponse,"_USUARIOSIGEPWEB","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csenhaSigepWeb     :=  WSAdvValue( oResponse,"_SENHASIGEPWEB","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeFilial        :=  WSAdvValue( oResponse,"_NOMEFILIAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccnpjFilial        :=  WSAdvValue( oResponse,"_CNPJFILIAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode11 :=  WSAdvValue( oResponse,"_ENDERECO","NewDadosEndereco",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode11 != NIL
		::oWSEndereco := Service1_NewDadosEndereco():New()
		::oWSEndereco:SoapRecv(oNode11)
	EndIf
	oNode12 :=  WSAdvValue( oResponse,"_DEPARTAMENTO","ArrayOfNewClienteDepartamento",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode12 != NIL
		::oWSDepartamento := Service1_ArrayOfNewClienteDepartamento():New()
		::oWSDepartamento:SoapRecv(oNode12)
	EndIf
	oNode13 :=  WSAdvValue( oResponse,"_EVENTOS","ArrayOfNewEventoObjeto",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode13 != NIL
		::oWSEventos := Service1_ArrayOfNewEventoObjeto():New()
		::oWSEventos:SoapRecv(oNode13)
	EndIf
	oNode14 :=  WSAdvValue( oResponse,"_CONTEUDOS","ArrayOfNewPostagensConteudos",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode14 != NIL
		::oWSConteudos := Service1_ArrayOfNewPostagensConteudos():New()
		::oWSConteudos:SoapRecv(oNode14)
	EndIf
	::cDataInicial       :=  WSAdvValue( oResponse,"_DATAINICIAL","dateTime",NIL,"Property cDataInicial as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDataFinal         :=  WSAdvValue( oResponse,"_DATAFINAL","dateTime",NIL,"Property cDataFinal as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nIdDoCliente       :=  WSAdvValue( oResponse,"_IDDOCLIENTE","int",NIL,"Property nIdDoCliente as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nIdFilial          :=  WSAdvValue( oResponse,"_IDFILIAL","int",NIL,"Property nIdFilial as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nIdDepartamento    :=  WSAdvValue( oResponse,"_IDDEPARTAMENTO","int",NIL,"Property nIdDepartamento as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfConteudo

WSSTRUCT Service1_ArrayOfConteudo
	WSDATA   oWSConteudo               AS Service1_Conteudo OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfConteudo
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfConteudo
	::oWSConteudo          := {} // Array Of  Service1_CONTEUDO():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfConteudo
	Local oClone := Service1_ArrayOfConteudo():NEW()
	oClone:oWSConteudo := NIL
	If ::oWSConteudo <> NIL 
		oClone:oWSConteudo := {}
		aEval( ::oWSConteudo , { |x| aadd( oClone:oWSConteudo , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_ArrayOfConteudo
	Local cSoap := ""
	aEval( ::oWSConteudo , {|x| cSoap := cSoap  +  WSSoapValue("Conteudo", x , x , "Conteudo", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfConteudo
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CONTEUDO","Conteudo",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSConteudo , Service1_Conteudo():New() )
			::oWSConteudo[len(::oWSConteudo)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Enumeration OrigemDeEntradaDosDados

WSSTRUCT Service1_OrigemDeEntradaDosDados
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_OrigemDeEntradaDosDados
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Bilng" )
	aadd(::aValueList , "Tray" )
	aadd(::aValueList , "Loja_Integrada" )
	aadd(::aValueList , "Magento" )
	aadd(::aValueList , "Meracdo_Livre" )
	aadd(::aValueList , "Seller_Center" )
	aadd(::aValueList , "Digitacao_Prepostagem" )
	aadd(::aValueList , "Importacao_Prepostagem" )
	aadd(::aValueList , "SmartIn" )
	aadd(::aValueList , "Web_Service" )
	aadd(::aValueList , "Importacao_Balanca" )
	aadd(::aValueList , "Vetx" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Service1_OrigemDeEntradaDosDados
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_OrigemDeEntradaDosDados
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Service1_OrigemDeEntradaDosDados
Local oClone := Service1_OrigemDeEntradaDosDados():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure TarifacaoCliente

WSSTRUCT Service1_TarifacaoCliente
	WSDATA   cnome_Fantasia            AS string OPTIONAL
	WSDATA   crazao_Social             AS string OPTIONAL
	WSDATA   cemail                    AS string OPTIONAL
	WSDATA   ctelefone                 AS string OPTIONAL
	WSDATA   cusuarioSigepWeb          AS string OPTIONAL
	WSDATA   csenhaSigepWeb            AS string OPTIONAL
	WSDATA   cusuarioReversa           AS string OPTIONAL
	WSDATA   csenhaReversa             AS string OPTIONAL
	WSDATA   cusuarioWebService        AS string OPTIONAL
	WSDATA   csenhaWebService          AS string OPTIONAL
	WSDATA   ccnpj                     AS string OPTIONAL
	WSDATA   cnomeDpto                 AS string OPTIONAL
	WSDATA   cdadosDr                  AS string OPTIONAL
	WSDATA   cnumeroContrato           AS string OPTIONAL
	WSDATA   ccodigoAdm                AS string OPTIONAL
	WSDATA   ccodigo_Sto               AS string OPTIONAL
	WSDATA   cnumeroCartaoPostagem     AS string OPTIONAL
	WSDATA   cnomeChancela             AS string OPTIONAL
	WSDATA   cmsgErro                  AS string OPTIONAL
	WSDATA   cnomeDaLoja               AS string OPTIONAL
	WSDATA   ckeyLoja                  AS string OPTIONAL
	WSDATA   curlLoja                  AS string OPTIONAL
	WSDATA   ctokenLoja                AS string OPTIONAL
	WSDATA   cstatusPedido             AS string OPTIONAL
	WSDATA   nidMercadoLivre           AS long
	WSDATA   csecurityKeyMercadoLivre  AS string OPTIONAL
	WSDATA   curlRedirectMercadoLivre  AS string OPTIONAL
	WSDATA   lliberado                 AS boolean
	WSDATA   nidCliente                AS int
	WSDATA   nidClienteExt             AS int
	WSDATA   nidFilial                 AS int
	WSDATA   nidCartao                 AS int
	WSDATA   nidContrato               AS int
	WSDATA   nidDepartamento           AS int
	WSDATA   nidDepartamentoExt        AS int
	WSDATA   nprazo_para_postagem      AS int
	WSDATA   nidCartaoAvista           AS int
	WSDATA   ncriarCliente             AS int
	WSDATA   oWScontrato               AS Service1_Contrato OPTIONAL
	WSDATA   oWS_dadosEndereco         AS Service1_Endereco OPTIONAL
	WSDATA   nqtd_Dias                 AS int
	WSDATA   cdata_de_vencimento       AS dateTime
	WSDATA   nidPacote                 AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_TarifacaoCliente
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_TarifacaoCliente
Return

WSMETHOD CLONE WSCLIENT Service1_TarifacaoCliente
	Local oClone := Service1_TarifacaoCliente():NEW()
	oClone:cnome_Fantasia       := ::cnome_Fantasia
	oClone:crazao_Social        := ::crazao_Social
	oClone:cemail               := ::cemail
	oClone:ctelefone            := ::ctelefone
	oClone:cusuarioSigepWeb     := ::cusuarioSigepWeb
	oClone:csenhaSigepWeb       := ::csenhaSigepWeb
	oClone:cusuarioReversa      := ::cusuarioReversa
	oClone:csenhaReversa        := ::csenhaReversa
	oClone:cusuarioWebService   := ::cusuarioWebService
	oClone:csenhaWebService     := ::csenhaWebService
	oClone:ccnpj                := ::ccnpj
	oClone:cnomeDpto            := ::cnomeDpto
	oClone:cdadosDr             := ::cdadosDr
	oClone:cnumeroContrato      := ::cnumeroContrato
	oClone:ccodigoAdm           := ::ccodigoAdm
	oClone:ccodigo_Sto          := ::ccodigo_Sto
	oClone:cnumeroCartaoPostagem := ::cnumeroCartaoPostagem
	oClone:cnomeChancela        := ::cnomeChancela
	oClone:cmsgErro             := ::cmsgErro
	oClone:cnomeDaLoja          := ::cnomeDaLoja
	oClone:ckeyLoja             := ::ckeyLoja
	oClone:curlLoja             := ::curlLoja
	oClone:ctokenLoja           := ::ctokenLoja
	oClone:cstatusPedido        := ::cstatusPedido
	oClone:nidMercadoLivre      := ::nidMercadoLivre
	oClone:csecurityKeyMercadoLivre := ::csecurityKeyMercadoLivre
	oClone:curlRedirectMercadoLivre := ::curlRedirectMercadoLivre
	oClone:lliberado            := ::lliberado
	oClone:nidCliente           := ::nidCliente
	oClone:nidClienteExt        := ::nidClienteExt
	oClone:nidFilial            := ::nidFilial
	oClone:nidCartao            := ::nidCartao
	oClone:nidContrato          := ::nidContrato
	oClone:nidDepartamento      := ::nidDepartamento
	oClone:nidDepartamentoExt   := ::nidDepartamentoExt
	oClone:nprazo_para_postagem := ::nprazo_para_postagem
	oClone:nidCartaoAvista      := ::nidCartaoAvista
	oClone:ncriarCliente        := ::ncriarCliente
	oClone:oWScontrato          := IIF(::oWScontrato = NIL , NIL , ::oWScontrato:Clone() )
	oClone:oWS_dadosEndereco    := IIF(::oWS_dadosEndereco = NIL , NIL , ::oWS_dadosEndereco:Clone() )
	oClone:nqtd_Dias            := ::nqtd_Dias
	oClone:cdata_de_vencimento  := ::cdata_de_vencimento
	oClone:nidPacote            := ::nidPacote
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_TarifacaoCliente
	Local cSoap := ""
	cSoap += WSSoapValue("nome_Fantasia", ::cnome_Fantasia, ::cnome_Fantasia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("razao_Social", ::crazao_Social, ::crazao_Social , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("email", ::cemail, ::cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("telefone", ::ctelefone, ::ctelefone , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("usuarioSigepWeb", ::cusuarioSigepWeb, ::cusuarioSigepWeb , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("senhaSigepWeb", ::csenhaSigepWeb, ::csenhaSigepWeb , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("usuarioReversa", ::cusuarioReversa, ::cusuarioReversa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("senhaReversa", ::csenhaReversa, ::csenhaReversa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("usuarioWebService", ::cusuarioWebService, ::cusuarioWebService , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("senhaWebService", ::csenhaWebService, ::csenhaWebService , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cnpj", ::ccnpj, ::ccnpj , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("nomeDpto", ::cnomeDpto, ::cnomeDpto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("dadosDr", ::cdadosDr, ::cdadosDr , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numeroContrato", ::cnumeroContrato, ::cnumeroContrato , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("codigoAdm", ::ccodigoAdm, ::ccodigoAdm , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("codigo_Sto", ::ccodigo_Sto, ::ccodigo_Sto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numeroCartaoPostagem", ::cnumeroCartaoPostagem, ::cnumeroCartaoPostagem , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("nomeChancela", ::cnomeChancela, ::cnomeChancela , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("msgErro", ::cmsgErro, ::cmsgErro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("nomeDaLoja", ::cnomeDaLoja, ::cnomeDaLoja , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("keyLoja", ::ckeyLoja, ::ckeyLoja , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("urlLoja", ::curlLoja, ::curlLoja , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("tokenLoja", ::ctokenLoja, ::ctokenLoja , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("statusPedido", ::cstatusPedido, ::cstatusPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idMercadoLivre", ::nidMercadoLivre, ::nidMercadoLivre , "long", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("securityKeyMercadoLivre", ::csecurityKeyMercadoLivre, ::csecurityKeyMercadoLivre , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("urlRedirectMercadoLivre", ::curlRedirectMercadoLivre, ::curlRedirectMercadoLivre , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("liberado", ::lliberado, ::lliberado , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idCliente", ::nidCliente, ::nidCliente , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idClienteExt", ::nidClienteExt, ::nidClienteExt , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idFilial", ::nidFilial, ::nidFilial , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idCartao", ::nidCartao, ::nidCartao , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idContrato", ::nidContrato, ::nidContrato , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idDepartamento", ::nidDepartamento, ::nidDepartamento , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idDepartamentoExt", ::nidDepartamentoExt, ::nidDepartamentoExt , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("prazo_para_postagem", ::nprazo_para_postagem, ::nprazo_para_postagem , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idCartaoAvista", ::nidCartaoAvista, ::nidCartaoAvista , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("criarCliente", ::ncriarCliente, ::ncriarCliente , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("contrato", ::oWScontrato, ::oWScontrato , "Contrato", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("_dadosEndereco", ::oWS_dadosEndereco, ::oWS_dadosEndereco , "Endereco", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("qtd_Dias", ::nqtd_Dias, ::nqtd_Dias , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("data_de_vencimento", ::cdata_de_vencimento, ::cdata_de_vencimento , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("idPacote", ::nidPacote, ::nidPacote , "int", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_TarifacaoCliente
	Local oNode39
	Local oNode40
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cnome_Fantasia     :=  WSAdvValue( oResponse,"_NOME_FANTASIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::crazao_Social      :=  WSAdvValue( oResponse,"_RAZAO_SOCIAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cemail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctelefone          :=  WSAdvValue( oResponse,"_TELEFONE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cusuarioSigepWeb   :=  WSAdvValue( oResponse,"_USUARIOSIGEPWEB","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csenhaSigepWeb     :=  WSAdvValue( oResponse,"_SENHASIGEPWEB","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cusuarioReversa    :=  WSAdvValue( oResponse,"_USUARIOREVERSA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csenhaReversa      :=  WSAdvValue( oResponse,"_SENHAREVERSA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cusuarioWebService :=  WSAdvValue( oResponse,"_USUARIOWEBSERVICE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::csenhaWebService   :=  WSAdvValue( oResponse,"_SENHAWEBSERVICE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccnpj              :=  WSAdvValue( oResponse,"_CNPJ","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cnomeDpto          :=  WSAdvValue( oResponse,"_NOMEDPTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdadosDr           :=  WSAdvValue( oResponse,"_DADOSDR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cnumeroContrato    :=  WSAdvValue( oResponse,"_NUMEROCONTRATO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodigoAdm         :=  WSAdvValue( oResponse,"_CODIGOADM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodigo_Sto        :=  WSAdvValue( oResponse,"_CODIGO_STO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cnumeroCartaoPostagem :=  WSAdvValue( oResponse,"_NUMEROCARTAOPOSTAGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cnomeChancela      :=  WSAdvValue( oResponse,"_NOMECHANCELA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cmsgErro           :=  WSAdvValue( oResponse,"_MSGERRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cnomeDaLoja        :=  WSAdvValue( oResponse,"_NOMEDALOJA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ckeyLoja           :=  WSAdvValue( oResponse,"_KEYLOJA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::curlLoja           :=  WSAdvValue( oResponse,"_URLLOJA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ctokenLoja         :=  WSAdvValue( oResponse,"_TOKENLOJA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cstatusPedido      :=  WSAdvValue( oResponse,"_STATUSPEDIDO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nidMercadoLivre    :=  WSAdvValue( oResponse,"_IDMERCADOLIVRE","long",NIL,"Property nidMercadoLivre as s:long on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::csecurityKeyMercadoLivre :=  WSAdvValue( oResponse,"_SECURITYKEYMERCADOLIVRE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::curlRedirectMercadoLivre :=  WSAdvValue( oResponse,"_URLREDIRECTMERCADOLIVRE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lliberado          :=  WSAdvValue( oResponse,"_LIBERADO","boolean",NIL,"Property lliberado as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::nidCliente         :=  WSAdvValue( oResponse,"_IDCLIENTE","int",NIL,"Property nidCliente as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nidClienteExt      :=  WSAdvValue( oResponse,"_IDCLIENTEEXT","int",NIL,"Property nidClienteExt as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nidFilial          :=  WSAdvValue( oResponse,"_IDFILIAL","int",NIL,"Property nidFilial as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nidCartao          :=  WSAdvValue( oResponse,"_IDCARTAO","int",NIL,"Property nidCartao as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nidContrato        :=  WSAdvValue( oResponse,"_IDCONTRATO","int",NIL,"Property nidContrato as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nidDepartamento    :=  WSAdvValue( oResponse,"_IDDEPARTAMENTO","int",NIL,"Property nidDepartamento as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nidDepartamentoExt :=  WSAdvValue( oResponse,"_IDDEPARTAMENTOEXT","int",NIL,"Property nidDepartamentoExt as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nprazo_para_postagem :=  WSAdvValue( oResponse,"_PRAZO_PARA_POSTAGEM","int",NIL,"Property nprazo_para_postagem as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nidCartaoAvista    :=  WSAdvValue( oResponse,"_IDCARTAOAVISTA","int",NIL,"Property nidCartaoAvista as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ncriarCliente      :=  WSAdvValue( oResponse,"_CRIARCLIENTE","int",NIL,"Property ncriarCliente as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode39 :=  WSAdvValue( oResponse,"_CONTRATO","Contrato",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode39 != NIL
		::oWScontrato := Service1_Contrato():New()
		::oWScontrato:SoapRecv(oNode39)
	EndIf
	oNode40 :=  WSAdvValue( oResponse,"__DADOSENDERECO","Endereco",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode40 != NIL
		::oWS_dadosEndereco := Service1_Endereco():New()
		::oWS_dadosEndereco:SoapRecv(oNode40)
	EndIf
	::nqtd_Dias          :=  WSAdvValue( oResponse,"_QTD_DIAS","int",NIL,"Property nqtd_Dias as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cdata_de_vencimento :=  WSAdvValue( oResponse,"_DATA_DE_VENCIMENTO","dateTime",NIL,"Property cdata_de_vencimento as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nidPacote          :=  WSAdvValue( oResponse,"_IDPACOTE","int",NIL,"Property nidPacote as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure EventoObjeto

WSSTRUCT Service1_EventoObjeto
	WSDATA   cnumero                   AS string OPTIONAL
	WSDATA   cTipo                     AS string OPTIONAL
	WSDATA   cStatus                   AS string OPTIONAL
	WSDATA   cDataEvento               AS dateTime
	WSDATA   cDataDaBusca              AS dateTime
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   cRecebedor                AS string OPTIONAL
	WSDATA   cDocumento                AS string OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   cLocal                    AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCodigo                   AS string OPTIONAL
	WSDATA   cCidade                   AS string OPTIONAL
	WSDATA   cUf                       AS string OPTIONAL
	WSDATA   cSto                      AS string OPTIONAL
	WSDATA   cLocalDestino             AS string OPTIONAL
	WSDATA   cCodigoDestino            AS string OPTIONAL
	WSDATA   cCidadeDestino            AS string OPTIONAL
	WSDATA   cBiarroDestino            AS string OPTIONAL
	WSDATA   cUfDestino                AS string OPTIONAL
	WSDATA   lnovoStatus               AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_EventoObjeto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_EventoObjeto
Return

WSMETHOD CLONE WSCLIENT Service1_EventoObjeto
	Local oClone := Service1_EventoObjeto():NEW()
	oClone:cnumero              := ::cnumero
	oClone:cTipo                := ::cTipo
	oClone:cStatus              := ::cStatus
	oClone:cDataEvento          := ::cDataEvento
	oClone:cDataDaBusca         := ::cDataDaBusca
	oClone:cDescricao           := ::cDescricao
	oClone:cRecebedor           := ::cRecebedor
	oClone:cDocumento           := ::cDocumento
	oClone:cComentario          := ::cComentario
	oClone:cLocal               := ::cLocal
	oClone:cBairro              := ::cBairro
	oClone:cCodigo              := ::cCodigo
	oClone:cCidade              := ::cCidade
	oClone:cUf                  := ::cUf
	oClone:cSto                 := ::cSto
	oClone:cLocalDestino        := ::cLocalDestino
	oClone:cCodigoDestino       := ::cCodigoDestino
	oClone:cCidadeDestino       := ::cCidadeDestino
	oClone:cBiarroDestino       := ::cBiarroDestino
	oClone:cUfDestino           := ::cUfDestino
	oClone:lnovoStatus          := ::lnovoStatus
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_EventoObjeto
	Local cSoap := ""
	cSoap += WSSoapValue("numero", ::cnumero, ::cnumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Tipo", ::cTipo, ::cTipo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Status", ::cStatus, ::cStatus , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataEvento", ::cDataEvento, ::cDataEvento , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataDaBusca", ::cDataDaBusca, ::cDataDaBusca , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Descricao", ::cDescricao, ::cDescricao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Recebedor", ::cRecebedor, ::cRecebedor , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Documento", ::cDocumento, ::cDocumento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Comentario", ::cComentario, ::cComentario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Local", ::cLocal, ::cLocal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Codigo", ::cCodigo, ::cCodigo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Cidade", ::cCidade, ::cCidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Uf", ::cUf, ::cUf , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Sto", ::cSto, ::cSto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("LocalDestino", ::cLocalDestino, ::cLocalDestino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoDestino", ::cCodigoDestino, ::cCodigoDestino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CidadeDestino", ::cCidadeDestino, ::cCidadeDestino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("BiarroDestino", ::cBiarroDestino, ::cBiarroDestino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("UfDestino", ::cUfDestino, ::cUfDestino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("novoStatus", ::lnovoStatus, ::lnovoStatus , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_EventoObjeto
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cnumero            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTipo              :=  WSAdvValue( oResponse,"_TIPO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cStatus            :=  WSAdvValue( oResponse,"_STATUS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataEvento        :=  WSAdvValue( oResponse,"_DATAEVENTO","dateTime",NIL,"Property cDataEvento as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDataDaBusca       :=  WSAdvValue( oResponse,"_DATADABUSCA","dateTime",NIL,"Property cDataDaBusca as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRecebedor         :=  WSAdvValue( oResponse,"_RECEBEDOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDocumento         :=  WSAdvValue( oResponse,"_DOCUMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cComentario        :=  WSAdvValue( oResponse,"_COMENTARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLocal             :=  WSAdvValue( oResponse,"_LOCAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cBairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigo            :=  WSAdvValue( oResponse,"_CODIGO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cUf                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSto               :=  WSAdvValue( oResponse,"_STO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLocalDestino      :=  WSAdvValue( oResponse,"_LOCALDESTINO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoDestino     :=  WSAdvValue( oResponse,"_CODIGODESTINO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCidadeDestino     :=  WSAdvValue( oResponse,"_CIDADEDESTINO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cBiarroDestino     :=  WSAdvValue( oResponse,"_BIARRODESTINO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cUfDestino         :=  WSAdvValue( oResponse,"_UFDESTINO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lnovoStatus        :=  WSAdvValue( oResponse,"_NOVOSTATUS","boolean",NIL,"Property lnovoStatus as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfNewPostagensConteudos

WSSTRUCT Service1_ArrayOfNewPostagensConteudos
	WSDATA   oWSNewPostagensConteudos  AS Service1_NewPostagensConteudos OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfNewPostagensConteudos
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfNewPostagensConteudos
	::oWSNewPostagensConteudos := {} // Array Of  Service1_NEWPOSTAGENSCONTEUDOS():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfNewPostagensConteudos
	Local oClone := Service1_ArrayOfNewPostagensConteudos():NEW()
	oClone:oWSNewPostagensConteudos := NIL
	If ::oWSNewPostagensConteudos <> NIL 
		oClone:oWSNewPostagensConteudos := {}
		aEval( ::oWSNewPostagensConteudos , { |x| aadd( oClone:oWSNewPostagensConteudos , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfNewPostagensConteudos
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_NEWPOSTAGENSCONTEUDOS","NewPostagensConteudos",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSNewPostagensConteudos , Service1_NewPostagensConteudos():New() )
			::oWSNewPostagensConteudos[len(::oWSNewPostagensConteudos)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure NewDadosEndereco

WSSTRUCT Service1_NewDadosEndereco
	WSDATA   cLogradouro               AS string OPTIONAL
	WSDATA   cNumero                   AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCidade                   AS string OPTIONAL
	WSDATA   cEstado                   AS string OPTIONAL
	WSDATA   cCep                      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_NewDadosEndereco
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_NewDadosEndereco
Return

WSMETHOD CLONE WSCLIENT Service1_NewDadosEndereco
	Local oClone := Service1_NewDadosEndereco():NEW()
	oClone:cLogradouro          := ::cLogradouro
	oClone:cNumero              := ::cNumero
	oClone:cComplemento         := ::cComplemento
	oClone:cBairro              := ::cBairro
	oClone:cCidade              := ::cCidade
	oClone:cEstado              := ::cEstado
	oClone:cCep                 := ::cCep
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_NewDadosEndereco
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cLogradouro        :=  WSAdvValue( oResponse,"_LOGRADOURO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumero            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cComplemento       :=  WSAdvValue( oResponse,"_COMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cBairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEstado            :=  WSAdvValue( oResponse,"_ESTADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCep               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfNewClienteDepartamento

WSSTRUCT Service1_ArrayOfNewClienteDepartamento
	WSDATA   oWSNewClienteDepartamento AS Service1_NewClienteDepartamento OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfNewClienteDepartamento
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfNewClienteDepartamento
	::oWSNewClienteDepartamento := {} // Array Of  Service1_NEWCLIENTEDEPARTAMENTO():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfNewClienteDepartamento
	Local oClone := Service1_ArrayOfNewClienteDepartamento():NEW()
	oClone:oWSNewClienteDepartamento := NIL
	If ::oWSNewClienteDepartamento <> NIL 
		oClone:oWSNewClienteDepartamento := {}
		aEval( ::oWSNewClienteDepartamento , { |x| aadd( oClone:oWSNewClienteDepartamento , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfNewClienteDepartamento
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_NEWCLIENTEDEPARTAMENTO","NewClienteDepartamento",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSNewClienteDepartamento , Service1_NewClienteDepartamento():New() )
			::oWSNewClienteDepartamento[len(::oWSNewClienteDepartamento)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfNewEventoObjeto

WSSTRUCT Service1_ArrayOfNewEventoObjeto
	WSDATA   oWSNewEventoObjeto        AS Service1_NewEventoObjeto OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfNewEventoObjeto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfNewEventoObjeto
	::oWSNewEventoObjeto   := {} // Array Of  Service1_NEWEVENTOOBJETO():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfNewEventoObjeto
	Local oClone := Service1_ArrayOfNewEventoObjeto():NEW()
	oClone:oWSNewEventoObjeto := NIL
	If ::oWSNewEventoObjeto <> NIL 
		oClone:oWSNewEventoObjeto := {}
		aEval( ::oWSNewEventoObjeto , { |x| aadd( oClone:oWSNewEventoObjeto , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfNewEventoObjeto
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_NEWEVENTOOBJETO","NewEventoObjeto",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSNewEventoObjeto , Service1_NewEventoObjeto():New() )
			::oWSNewEventoObjeto[len(::oWSNewEventoObjeto)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure Conteudo

WSSTRUCT Service1_Conteudo
	WSDATA   nquantidade               AS int
	WSDATA   cdescricao                AS string OPTIONAL
	WSDATA   nvalor                    AS decimal
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_Conteudo
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_Conteudo
Return

WSMETHOD CLONE WSCLIENT Service1_Conteudo
	Local oClone := Service1_Conteudo():NEW()
	oClone:nquantidade          := ::nquantidade
	oClone:cdescricao           := ::cdescricao
	oClone:nvalor               := ::nvalor
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_Conteudo
	Local cSoap := ""
	cSoap += WSSoapValue("quantidade", ::nquantidade, ::nquantidade , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("descricao", ::cdescricao, ::cdescricao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("valor", ::nvalor, ::nvalor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_Conteudo
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nquantidade        :=  WSAdvValue( oResponse,"_QUANTIDADE","int",NIL,"Property nquantidade as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nvalor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,"Property nvalor as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure Contrato

WSSTRUCT Service1_Contrato
	WSDATA   nidContrato               AS int
	WSDATA   cnumero                   AS string OPTIONAL
	WSDATA   ccodigo_Adm               AS string OPTIONAL
	WSDATA   nano_Do_contrato          AS int
	WSDATA   cdados_DR                 AS string OPTIONAL
	WSDATA   cdata_Vencimento          AS dateTime
	WSDATA   ndias_vencido             AS int
	WSDATA   oWScartoes_Postagem       AS Service1_ArrayOfCartao_Postagem OPTIONAL
	WSDATA   oWSdepartamento           AS Service1_Departamento OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_Contrato
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_Contrato
Return

WSMETHOD CLONE WSCLIENT Service1_Contrato
	Local oClone := Service1_Contrato():NEW()
	oClone:nidContrato          := ::nidContrato
	oClone:cnumero              := ::cnumero
	oClone:ccodigo_Adm          := ::ccodigo_Adm
	oClone:nano_Do_contrato     := ::nano_Do_contrato
	oClone:cdados_DR            := ::cdados_DR
	oClone:cdata_Vencimento     := ::cdata_Vencimento
	oClone:ndias_vencido        := ::ndias_vencido
	oClone:oWScartoes_Postagem  := IIF(::oWScartoes_Postagem = NIL , NIL , ::oWScartoes_Postagem:Clone() )
	oClone:oWSdepartamento      := IIF(::oWSdepartamento = NIL , NIL , ::oWSdepartamento:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_Contrato
	Local cSoap := ""
	cSoap += WSSoapValue("idContrato", ::nidContrato, ::nidContrato , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numero", ::cnumero, ::cnumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("codigo_Adm", ::ccodigo_Adm, ::ccodigo_Adm , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ano_Do_contrato", ::nano_Do_contrato, ::nano_Do_contrato , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("dados_DR", ::cdados_DR, ::cdados_DR , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("data_Vencimento", ::cdata_Vencimento, ::cdata_Vencimento , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("dias_vencido", ::ndias_vencido, ::ndias_vencido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cartoes_Postagem", ::oWScartoes_Postagem, ::oWScartoes_Postagem , "ArrayOfCartao_Postagem", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("departamento", ::oWSdepartamento, ::oWSdepartamento , "Departamento", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_Contrato
	Local oNode8
	Local oNode9
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nidContrato        :=  WSAdvValue( oResponse,"_IDCONTRATO","int",NIL,"Property nidContrato as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cnumero            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodigo_Adm        :=  WSAdvValue( oResponse,"_CODIGO_ADM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nano_Do_contrato   :=  WSAdvValue( oResponse,"_ANO_DO_CONTRATO","int",NIL,"Property nano_Do_contrato as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cdados_DR          :=  WSAdvValue( oResponse,"_DADOS_DR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdata_Vencimento   :=  WSAdvValue( oResponse,"_DATA_VENCIMENTO","dateTime",NIL,"Property cdata_Vencimento as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::ndias_vencido      :=  WSAdvValue( oResponse,"_DIAS_VENCIDO","int",NIL,"Property ndias_vencido as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode8 :=  WSAdvValue( oResponse,"_CARTOES_POSTAGEM","ArrayOfCartao_Postagem",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode8 != NIL
		::oWScartoes_Postagem := Service1_ArrayOfCartao_Postagem():New()
		::oWScartoes_Postagem:SoapRecv(oNode8)
	EndIf
	oNode9 :=  WSAdvValue( oResponse,"_DEPARTAMENTO","Departamento",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWSdepartamento := Service1_Departamento():New()
		::oWSdepartamento:SoapRecv(oNode9)
	EndIf
Return

// WSDL Data Structure Endereco

WSSTRUCT Service1_Endereco
	WSDATA   cendereco                 AS string OPTIONAL
	WSDATA   ccomplemento              AS string OPTIONAL
	WSDATA   cbairro                   AS string OPTIONAL
	WSDATA   cuf                       AS string OPTIONAL
	WSDATA   ccidade                   AS string OPTIONAL
	WSDATA   creferencia               AS string OPTIONAL
	WSDATA   ccep                      AS string OPTIONAL
	WSDATA   nnumero                   AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_Endereco
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_Endereco
Return

WSMETHOD CLONE WSCLIENT Service1_Endereco
	Local oClone := Service1_Endereco():NEW()
	oClone:cendereco            := ::cendereco
	oClone:ccomplemento         := ::ccomplemento
	oClone:cbairro              := ::cbairro
	oClone:cuf                  := ::cuf
	oClone:ccidade              := ::ccidade
	oClone:creferencia          := ::creferencia
	oClone:ccep                 := ::ccep
	oClone:nnumero              := ::nnumero
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_Endereco
	Local cSoap := ""
	cSoap += WSSoapValue("endereco", ::cendereco, ::cendereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("complemento", ::ccomplemento, ::ccomplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("bairro", ::cbairro, ::cbairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("uf", ::cuf, ::cuf , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cidade", ::ccidade, ::ccidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("referencia", ::creferencia, ::creferencia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cep", ::ccep, ::ccep , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numero", ::nnumero, ::nnumero , "int", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_Endereco
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cendereco          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccomplemento       :=  WSAdvValue( oResponse,"_COMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cbairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cuf                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::creferencia        :=  WSAdvValue( oResponse,"_REFERENCIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccep               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nnumero            :=  WSAdvValue( oResponse,"_NUMERO","int",NIL,"Property nnumero as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure NewPostagensConteudos

WSSTRUCT Service1_NewPostagensConteudos
	WSDATA   cConteudo                 AS string OPTIONAL
	WSDATA   nQuantidade               AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   nValor                    AS decimal
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_NewPostagensConteudos
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_NewPostagensConteudos
Return

WSMETHOD CLONE WSCLIENT Service1_NewPostagensConteudos
	Local oClone := Service1_NewPostagensConteudos():NEW()
	oClone:cConteudo            := ::cConteudo
	oClone:nQuantidade          := ::nQuantidade
	oClone:cDescricao           := ::cDescricao
	oClone:nValor               := ::nValor
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_NewPostagensConteudos
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cConteudo          :=  WSAdvValue( oResponse,"_CONTEUDO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nQuantidade        :=  WSAdvValue( oResponse,"_QUANTIDADE","int",NIL,"Property nQuantidade as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nValor             :=  WSAdvValue( oResponse,"_VALOR","decimal",NIL,"Property nValor as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure NewClienteDepartamento

WSSTRUCT Service1_NewClienteDepartamento
	WSDATA   nidDepartamento           AS int
	WSDATA   ncodigo                   AS int
	WSDATA   nCodigoVisualPost         AS int
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cNomeRemetente            AS string OPTIONAL
	WSDATA   oWSEndereco               AS Service1_NewDadosEndereco OPTIONAL
	WSDATA   oWSPostagens              AS Service1_ArrayOfNewPostagens OPTIONAL
	WSDATA   oWSContratoCliente        AS Service1_newContratoClientes OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_NewClienteDepartamento
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_NewClienteDepartamento
Return

WSMETHOD CLONE WSCLIENT Service1_NewClienteDepartamento
	Local oClone := Service1_NewClienteDepartamento():NEW()
	oClone:nidDepartamento      := ::nidDepartamento
	oClone:ncodigo              := ::ncodigo
	oClone:nCodigoVisualPost    := ::nCodigoVisualPost
	oClone:cNome                := ::cNome
	oClone:cNomeRemetente       := ::cNomeRemetente
	oClone:oWSEndereco          := IIF(::oWSEndereco = NIL , NIL , ::oWSEndereco:Clone() )
	oClone:oWSPostagens         := IIF(::oWSPostagens = NIL , NIL , ::oWSPostagens:Clone() )
	oClone:oWSContratoCliente   := IIF(::oWSContratoCliente = NIL , NIL , ::oWSContratoCliente:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_NewClienteDepartamento
	Local oNode6
	Local oNode7
	Local oNode8
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nidDepartamento    :=  WSAdvValue( oResponse,"_IDDEPARTAMENTO","int",NIL,"Property nidDepartamento as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ncodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property ncodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nCodigoVisualPost  :=  WSAdvValue( oResponse,"_CODIGOVISUALPOST","int",NIL,"Property nCodigoVisualPost as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeRemetente     :=  WSAdvValue( oResponse,"_NOMEREMETENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode6 :=  WSAdvValue( oResponse,"_ENDERECO","NewDadosEndereco",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode6 != NIL
		::oWSEndereco := Service1_NewDadosEndereco():New()
		::oWSEndereco:SoapRecv(oNode6)
	EndIf
	oNode7 :=  WSAdvValue( oResponse,"_POSTAGENS","ArrayOfNewPostagens",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSPostagens := Service1_ArrayOfNewPostagens():New()
		::oWSPostagens:SoapRecv(oNode7)
	EndIf
	oNode8 :=  WSAdvValue( oResponse,"_CONTRATOCLIENTE","newContratoClientes",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode8 != NIL
		::oWSContratoCliente := Service1_newContratoClientes():New()
		::oWSContratoCliente:SoapRecv(oNode8)
	EndIf
Return

// WSDL Data Structure NewEventoObjeto

WSSTRUCT Service1_NewEventoObjeto
	WSDATA   nidDados                  AS int
	WSDATA   nidStatus                 AS int
	WSDATA   cnumero                   AS string OPTIONAL
	WSDATA   cTipo                     AS string OPTIONAL
	WSDATA   cStatus                   AS string OPTIONAL
	WSDATA   cDataEvento               AS dateTime
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   cRecebedor                AS string OPTIONAL
	WSDATA   cDocumento                AS string OPTIONAL
	WSDATA   cComentario               AS string OPTIONAL
	WSDATA   cLocal                    AS string OPTIONAL
	WSDATA   cCodigo                   AS string OPTIONAL
	WSDATA   cCidade                   AS string OPTIONAL
	WSDATA   cUf                       AS string OPTIONAL
	WSDATA   cSto                      AS string OPTIONAL
	WSDATA   lnovoStatus               AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_NewEventoObjeto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_NewEventoObjeto
Return

WSMETHOD CLONE WSCLIENT Service1_NewEventoObjeto
	Local oClone := Service1_NewEventoObjeto():NEW()
	oClone:nidDados             := ::nidDados
	oClone:nidStatus            := ::nidStatus
	oClone:cnumero              := ::cnumero
	oClone:cTipo                := ::cTipo
	oClone:cStatus              := ::cStatus
	oClone:cDataEvento          := ::cDataEvento
	oClone:cDescricao           := ::cDescricao
	oClone:cRecebedor           := ::cRecebedor
	oClone:cDocumento           := ::cDocumento
	oClone:cComentario          := ::cComentario
	oClone:cLocal               := ::cLocal
	oClone:cCodigo              := ::cCodigo
	oClone:cCidade              := ::cCidade
	oClone:cUf                  := ::cUf
	oClone:cSto                 := ::cSto
	oClone:lnovoStatus          := ::lnovoStatus
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_NewEventoObjeto
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nidDados           :=  WSAdvValue( oResponse,"_IDDADOS","int",NIL,"Property nidDados as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nidStatus          :=  WSAdvValue( oResponse,"_IDSTATUS","int",NIL,"Property nidStatus as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cnumero            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTipo              :=  WSAdvValue( oResponse,"_TIPO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cStatus            :=  WSAdvValue( oResponse,"_STATUS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataEvento        :=  WSAdvValue( oResponse,"_DATAEVENTO","dateTime",NIL,"Property cDataEvento as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRecebedor         :=  WSAdvValue( oResponse,"_RECEBEDOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDocumento         :=  WSAdvValue( oResponse,"_DOCUMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cComentario        :=  WSAdvValue( oResponse,"_COMENTARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLocal             :=  WSAdvValue( oResponse,"_LOCAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigo            :=  WSAdvValue( oResponse,"_CODIGO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cUf                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSto               :=  WSAdvValue( oResponse,"_STO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lnovoStatus        :=  WSAdvValue( oResponse,"_NOVOSTATUS","boolean",NIL,"Property lnovoStatus as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfCartao_Postagem

WSSTRUCT Service1_ArrayOfCartao_Postagem
	WSDATA   oWSCartao_Postagem        AS Service1_Cartao_Postagem OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfCartao_Postagem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfCartao_Postagem
	::oWSCartao_Postagem   := {} // Array Of  Service1_CARTAO_POSTAGEM():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfCartao_Postagem
	Local oClone := Service1_ArrayOfCartao_Postagem():NEW()
	oClone:oWSCartao_Postagem := NIL
	If ::oWSCartao_Postagem <> NIL 
		oClone:oWSCartao_Postagem := {}
		aEval( ::oWSCartao_Postagem , { |x| aadd( oClone:oWSCartao_Postagem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_ArrayOfCartao_Postagem
	Local cSoap := ""
	aEval( ::oWSCartao_Postagem , {|x| cSoap := cSoap  +  WSSoapValue("Cartao_Postagem", x , x , "Cartao_Postagem", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfCartao_Postagem
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CARTAO_POSTAGEM","Cartao_Postagem",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCartao_Postagem , Service1_Cartao_Postagem():New() )
			::oWSCartao_Postagem[len(::oWSCartao_Postagem)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure Departamento

WSSTRUCT Service1_Departamento
	WSDATA   nid_departamento          AS int
	WSDATA   cdescricao                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_Departamento
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_Departamento
Return

WSMETHOD CLONE WSCLIENT Service1_Departamento
	Local oClone := Service1_Departamento():NEW()
	oClone:nid_departamento     := ::nid_departamento
	oClone:cdescricao           := ::cdescricao
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_Departamento
	Local cSoap := ""
	cSoap += WSSoapValue("id_departamento", ::nid_departamento, ::nid_departamento , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("descricao", ::cdescricao, ::cdescricao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_Departamento
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nid_departamento   :=  WSAdvValue( oResponse,"_ID_DEPARTAMENTO","int",NIL,"Property nid_departamento as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cdescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfNewPostagens

WSSTRUCT Service1_ArrayOfNewPostagens
	WSDATA   oWSNewPostagens           AS Service1_NewPostagens OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_ArrayOfNewPostagens
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_ArrayOfNewPostagens
	::oWSNewPostagens      := {} // Array Of  Service1_NEWPOSTAGENS():New()
Return

WSMETHOD CLONE WSCLIENT Service1_ArrayOfNewPostagens
	Local oClone := Service1_ArrayOfNewPostagens():NEW()
	oClone:oWSNewPostagens := NIL
	If ::oWSNewPostagens <> NIL 
		oClone:oWSNewPostagens := {}
		aEval( ::oWSNewPostagens , { |x| aadd( oClone:oWSNewPostagens , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_ArrayOfNewPostagens
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_NEWPOSTAGENS","NewPostagens",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSNewPostagens , Service1_NewPostagens():New() )
			::oWSNewPostagens[len(::oWSNewPostagens)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure newContratoClientes

WSSTRUCT Service1_newContratoClientes
	WSDATA   nidContrato               AS int
	WSDATA   cdescricaoChancela        AS string OPTIONAL
	WSDATA   cnumeroDoContrato         AS string OPTIONAL
	WSDATA   cdadoDiretoriaRegional    AS string OPTIONAL
	WSDATA   ccodidoAdministrativo     AS string OPTIONAL
	WSDATA   nanoDoContrato            AS int
	WSDATA   cdataDeVencimentoContrato AS dateTime
	WSDATA   lusarCnpjFilialNaEtiqueta AS boolean
	WSDATA   oWScartoesDoCliente       AS Service1_newCartoesCliente OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_newContratoClientes
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_newContratoClientes
Return

WSMETHOD CLONE WSCLIENT Service1_newContratoClientes
	Local oClone := Service1_newContratoClientes():NEW()
	oClone:nidContrato          := ::nidContrato
	oClone:cdescricaoChancela   := ::cdescricaoChancela
	oClone:cnumeroDoContrato    := ::cnumeroDoContrato
	oClone:cdadoDiretoriaRegional := ::cdadoDiretoriaRegional
	oClone:ccodidoAdministrativo := ::ccodidoAdministrativo
	oClone:nanoDoContrato       := ::nanoDoContrato
	oClone:cdataDeVencimentoContrato := ::cdataDeVencimentoContrato
	oClone:lusarCnpjFilialNaEtiqueta := ::lusarCnpjFilialNaEtiqueta
	oClone:oWScartoesDoCliente  := IIF(::oWScartoesDoCliente = NIL , NIL , ::oWScartoesDoCliente:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_newContratoClientes
	Local oNode9
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nidContrato        :=  WSAdvValue( oResponse,"_IDCONTRATO","int",NIL,"Property nidContrato as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cdescricaoChancela :=  WSAdvValue( oResponse,"_DESCRICAOCHANCELA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cnumeroDoContrato  :=  WSAdvValue( oResponse,"_NUMERODOCONTRATO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cdadoDiretoriaRegional :=  WSAdvValue( oResponse,"_DADODIRETORIAREGIONAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::ccodidoAdministrativo :=  WSAdvValue( oResponse,"_CODIDOADMINISTRATIVO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nanoDoContrato     :=  WSAdvValue( oResponse,"_ANODOCONTRATO","int",NIL,"Property nanoDoContrato as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cdataDeVencimentoContrato :=  WSAdvValue( oResponse,"_DATADEVENCIMENTOCONTRATO","dateTime",NIL,"Property cdataDeVencimentoContrato as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::lusarCnpjFilialNaEtiqueta :=  WSAdvValue( oResponse,"_USARCNPJFILIALNAETIQUETA","boolean",NIL,"Property lusarCnpjFilialNaEtiqueta as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	oNode9 :=  WSAdvValue( oResponse,"_CARTOESDOCLIENTE","newCartoesCliente",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWScartoesDoCliente := Service1_newCartoesCliente():New()
		::oWScartoesDoCliente:SoapRecv(oNode9)
	EndIf
Return

// WSDL Data Structure Cartao_Postagem

WSSTRUCT Service1_Cartao_Postagem
	WSDATA   nid_cartao                AS int
	WSDATA   nid_cliente               AS int
	WSDATA   nid_contrato              AS int
	WSDATA   ntipo                     AS int
	WSDATA   cnumero                   AS string OPTIONAL
	WSDATA   lativo                    AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_Cartao_Postagem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_Cartao_Postagem
Return

WSMETHOD CLONE WSCLIENT Service1_Cartao_Postagem
	Local oClone := Service1_Cartao_Postagem():NEW()
	oClone:nid_cartao           := ::nid_cartao
	oClone:nid_cliente          := ::nid_cliente
	oClone:nid_contrato         := ::nid_contrato
	oClone:ntipo                := ::ntipo
	oClone:cnumero              := ::cnumero
	oClone:lativo               := ::lativo
Return oClone

WSMETHOD SOAPSEND WSCLIENT Service1_Cartao_Postagem
	Local cSoap := ""
	cSoap += WSSoapValue("id_cartao", ::nid_cartao, ::nid_cartao , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("id_cliente", ::nid_cliente, ::nid_cliente , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("id_contrato", ::nid_contrato, ::nid_contrato , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("tipo", ::ntipo, ::ntipo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numero", ::cnumero, ::cnumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ativo", ::lativo, ::lativo , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_Cartao_Postagem
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nid_cartao         :=  WSAdvValue( oResponse,"_ID_CARTAO","int",NIL,"Property nid_cartao as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nid_cliente        :=  WSAdvValue( oResponse,"_ID_CLIENTE","int",NIL,"Property nid_cliente as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nid_contrato       :=  WSAdvValue( oResponse,"_ID_CONTRATO","int",NIL,"Property nid_contrato as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ntipo              :=  WSAdvValue( oResponse,"_TIPO","int",NIL,"Property ntipo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cnumero            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lativo             :=  WSAdvValue( oResponse,"_ATIVO","boolean",NIL,"Property lativo as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure NewPostagens

WSSTRUCT Service1_NewPostagens
	WSDATA   nIdPostagem               AS int
	WSDATA   cNomedestinatario         AS string OPTIONAL
	WSDATA   oWSEnderecoDestinatario   AS Service1_NewDadosEndereco OPTIONAL
	WSDATA   naltura                   AS decimal
	WSDATA   nLargura                  AS decimal
	WSDATA   nComprimento              AS decimal
	WSDATA   nValorDeclarado           AS decimal
	WSDATA   nPeso                     AS decimal
	WSDATA   nCubico                   AS decimal
	WSDATA   cNumeroPedido             AS string OPTIONAL
	WSDATA   cNumeroNotaFiscal         AS string OPTIONAL
	WSDATA   cObservacao               AS string OPTIONAL
	WSDATA   cDescricaoServico         AS string OPTIONAL
	WSDATA   nCodigoServico            AS int
	WSDATA   cNumeroRegistro           AS string OPTIONAL
	WSDATA   nValorPostagem            AS decimal
	WSDATA   lAvisoRecebimento         AS boolean
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   nNumeroPlp                AS long
	WSDATA   nDiasPrazo                AS int
	WSDATA   cDataCriacao              AS dateTime
	WSDATA   lobjetoJaTratado          AS boolean
	WSDATA   ccelularDoDestinatario    AS string OPTIONAL
	WSDATA   nidCartaoPostagem         AS int
	WSDATA   nidDoDepartamento         AS int
	WSDATA   lmaoPropria               AS boolean
	WSDATA   lpostaRestante            AS boolean
	WSDATA   lavisodeRecebimentoDigital AS boolean
	WSDATA   lobjetoJaTratadoSvp       AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_NewPostagens
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_NewPostagens
Return

WSMETHOD CLONE WSCLIENT Service1_NewPostagens
	Local oClone := Service1_NewPostagens():NEW()
	oClone:nIdPostagem          := ::nIdPostagem
	oClone:cNomedestinatario    := ::cNomedestinatario
	oClone:oWSEnderecoDestinatario := IIF(::oWSEnderecoDestinatario = NIL , NIL , ::oWSEnderecoDestinatario:Clone() )
	oClone:naltura              := ::naltura
	oClone:nLargura             := ::nLargura
	oClone:nComprimento         := ::nComprimento
	oClone:nValorDeclarado      := ::nValorDeclarado
	oClone:nPeso                := ::nPeso
	oClone:nCubico              := ::nCubico
	oClone:cNumeroPedido        := ::cNumeroPedido
	oClone:cNumeroNotaFiscal    := ::cNumeroNotaFiscal
	oClone:cObservacao          := ::cObservacao
	oClone:cDescricaoServico    := ::cDescricaoServico
	oClone:nCodigoServico       := ::nCodigoServico
	oClone:cNumeroRegistro      := ::cNumeroRegistro
	oClone:nValorPostagem       := ::nValorPostagem
	oClone:lAvisoRecebimento    := ::lAvisoRecebimento
	oClone:cEmail               := ::cEmail
	oClone:nNumeroPlp           := ::nNumeroPlp
	oClone:nDiasPrazo           := ::nDiasPrazo
	oClone:cDataCriacao         := ::cDataCriacao
	oClone:lobjetoJaTratado     := ::lobjetoJaTratado
	oClone:ccelularDoDestinatario := ::ccelularDoDestinatario
	oClone:nidCartaoPostagem    := ::nidCartaoPostagem
	oClone:nidDoDepartamento    := ::nidDoDepartamento
	oClone:lmaoPropria          := ::lmaoPropria
	oClone:lpostaRestante       := ::lpostaRestante
	oClone:lavisodeRecebimentoDigital := ::lavisodeRecebimentoDigital
	oClone:lobjetoJaTratadoSvp  := ::lobjetoJaTratadoSvp
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_NewPostagens
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nIdPostagem        :=  WSAdvValue( oResponse,"_IDPOSTAGEM","int",NIL,"Property nIdPostagem as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cNomedestinatario  :=  WSAdvValue( oResponse,"_NOMEDESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode3 :=  WSAdvValue( oResponse,"_ENDERECODESTINATARIO","NewDadosEndereco",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSEnderecoDestinatario := Service1_NewDadosEndereco():New()
		::oWSEnderecoDestinatario:SoapRecv(oNode3)
	EndIf
	::naltura            :=  WSAdvValue( oResponse,"_ALTURA","decimal",NIL,"Property naltura as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nLargura           :=  WSAdvValue( oResponse,"_LARGURA","decimal",NIL,"Property nLargura as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nComprimento       :=  WSAdvValue( oResponse,"_COMPRIMENTO","decimal",NIL,"Property nComprimento as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValorDeclarado    :=  WSAdvValue( oResponse,"_VALORDECLARADO","decimal",NIL,"Property nValorDeclarado as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPeso              :=  WSAdvValue( oResponse,"_PESO","decimal",NIL,"Property nPeso as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nCubico            :=  WSAdvValue( oResponse,"_CUBICO","decimal",NIL,"Property nCubico as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cNumeroPedido      :=  WSAdvValue( oResponse,"_NUMEROPEDIDO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumeroNotaFiscal  :=  WSAdvValue( oResponse,"_NUMERONOTAFISCAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cObservacao        :=  WSAdvValue( oResponse,"_OBSERVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDescricaoServico  :=  WSAdvValue( oResponse,"_DESCRICAOSERVICO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCodigoServico     :=  WSAdvValue( oResponse,"_CODIGOSERVICO","int",NIL,"Property nCodigoServico as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cNumeroRegistro    :=  WSAdvValue( oResponse,"_NUMEROREGISTRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nValorPostagem     :=  WSAdvValue( oResponse,"_VALORPOSTAGEM","decimal",NIL,"Property nValorPostagem as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::lAvisoRecebimento  :=  WSAdvValue( oResponse,"_AVISORECEBIMENTO","boolean",NIL,"Property lAvisoRecebimento as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nNumeroPlp         :=  WSAdvValue( oResponse,"_NUMEROPLP","long",NIL,"Property nNumeroPlp as s:long on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nDiasPrazo         :=  WSAdvValue( oResponse,"_DIASPRAZO","int",NIL,"Property nDiasPrazo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDataCriacao       :=  WSAdvValue( oResponse,"_DATACRIACAO","dateTime",NIL,"Property cDataCriacao as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::lobjetoJaTratado   :=  WSAdvValue( oResponse,"_OBJETOJATRATADO","boolean",NIL,"Property lobjetoJaTratado as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::ccelularDoDestinatario :=  WSAdvValue( oResponse,"_CELULARDODESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nidCartaoPostagem  :=  WSAdvValue( oResponse,"_IDCARTAOPOSTAGEM","int",NIL,"Property nidCartaoPostagem as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nidDoDepartamento  :=  WSAdvValue( oResponse,"_IDDODEPARTAMENTO","int",NIL,"Property nidDoDepartamento as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::lmaoPropria        :=  WSAdvValue( oResponse,"_MAOPROPRIA","boolean",NIL,"Property lmaoPropria as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::lpostaRestante     :=  WSAdvValue( oResponse,"_POSTARESTANTE","boolean",NIL,"Property lpostaRestante as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::lavisodeRecebimentoDigital :=  WSAdvValue( oResponse,"_AVISODERECEBIMENTODIGITAL","boolean",NIL,"Property lavisodeRecebimentoDigital as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::lobjetoJaTratadoSvp :=  WSAdvValue( oResponse,"_OBJETOJATRATADOSVP","boolean",NIL,"Property lobjetoJaTratadoSvp as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure newCartoesCliente

WSSTRUCT Service1_newCartoesCliente
	WSDATA   nidDoCartao               AS int
	WSDATA   ntipoDoCartao             AS int
	WSDATA   cnumeroDoCartao           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service1_newCartoesCliente
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service1_newCartoesCliente
Return

WSMETHOD CLONE WSCLIENT Service1_newCartoesCliente
	Local oClone := Service1_newCartoesCliente():NEW()
	oClone:nidDoCartao          := ::nidDoCartao
	oClone:ntipoDoCartao        := ::ntipoDoCartao
	oClone:cnumeroDoCartao      := ::cnumeroDoCartao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service1_newCartoesCliente
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nidDoCartao        :=  WSAdvValue( oResponse,"_IDDOCARTAO","int",NIL,"Property nidDoCartao as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::ntipoDoCartao      :=  WSAdvValue( oResponse,"_TIPODOCARTAO","int",NIL,"Property ntipoDoCartao as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cnumeroDoCartao    :=  WSAdvValue( oResponse,"_NUMERODOCARTAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


