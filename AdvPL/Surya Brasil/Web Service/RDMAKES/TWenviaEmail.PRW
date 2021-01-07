#Include "Protheus.ch"
#Include "Totvs.ch"   
#INCLUDE "Ap5Mail.ch"

//__________________________________________________________________________________________________________________
//                                                                                                  				|
// Autor 	 : Jessé Augusto |  Data: 08/04/2017 																	|
//__________________________________________________________________________________________________________________|
//                                                                                                  				|   
// Descrição : Administra o processo de envio de E-mmail															|
//                                                                                                  				|
//__________________________________________________________________________________________________________________|  
  
Class TWEnviaEmail From LongNameClass             
                

    Data oServer           		// Objeto responsável por instanciar a Classe de gerenciamento de e-mail
    Data oMessage		   		// Objeto que torna viável a configurações do conteúdo da mensagem de e-mail
			
    Data cConta			   		// Conta Remetente
    Data cSenha            		// Senha da Conta do Remetente
    Data cDestinatario     		// Constas que contém os e-mails destinatários   
    Data cCopia					// Endereços de Destino que receberão uma cópia do e-mail
    Data cAssunto          		// Assunto do e-mail
    Data cMensagem         		// Mensagem 
    Data cDiretorio        		// Diretório utilizado envio de anexo
    Data cArquivo 		   		// Arquivo HTML a ser utilizado
    Data cAnexo	           		// Anexo do email
    Data cServerSMTP       		// Servidor SMTP
    Data cPorta	           		// Porta SMRP   
    Data aDadosHTML				// 
    
			
    Method New() Constructor    // Método Construtor
    Method EnviaEmail()	   		// Gerencia o processo de envio do e-mail		

    
	   
End Class
       
    
/**/                               
Method New() Class TWEnviaEmail
 
	                                                    
	::oServer		:= Nil
	::oMessage		:= Nil
	
    ::cConta        := ""
    ::cSenha        := ""
	::cDestinatario := "" 
	::cCopia		:= ""	
	::cServerSMTP	:= ""
    ::cAssunto      := ""
    ::cMensagem     := ""
    ::cDiretorio	:= ""
    ::cArquivo		:= ""        
    ::cAnexo		:= ""
    ::cPorta		:='587'	  
    
    ::aDadosHTML	:= {}

Return          


Method EnviaEmail() Class TWEnviaEmail     

	Local nK := 0

	//__________________________________________________________________________________________________________________
	//                                                       															|
	// Instancia a Classe responsável pelo gerenciamento de envio de e-mail												| 
	//__________________________________________________________________________________________________________________|    
    
    ::oServer := TMailManager():New()
    
	//__________________________________________________________________________________________________________________
	//                                                       															|
	// Usa SSL na conexao 									 															| 
	//__________________________________________________________________________________________________________________| 
	
	::oServer:SetUseSSL(.T.)
	::oServer:SetUseTLS(.T.)     
	//::oServer:SetUseTLS(.F.)     
	
	
	//__________________________________________________________________________________________________________________
	//                                                       															|
	// Inicia as configurações correspondente a Conta de E-mail atual                                                   | 
	//__________________________________________________________________________________________________________________|
	 
	::oServer:Init( 	""					,;  // Indica o endereço ou alias do servidor de e-mail IMAP/POP/MAPI
					 	::cServerSMTP		,;  // Servidor de SMTP  
					 	Alltrim(::cConta)	,;  // Conta para conexao com servidor SMTP  
					 	Alltrim(::cSenha)	,;  // Password da conta para conexao com o servidor SMTP 
					 	0					,;  // Indica a porta de comunicação para conexão IMAP/POP/MAPI
					 	Val(::cPorta) )         // Indica o Indica a porta de comunicação para conexão SMTP (Padrão 25).
	
	//__________________________________________________________________________________________________________________ 
	//                                                                                                                  |
	// Determina um período de tempo de time out com servidor de 1min        											| 
	//__________________________________________________________________________________________________________________|
	
	If (::oServer:SetSmtpTimeOut( 60 ) != 0 )
	    
		 Conout("Falha ao setar o time out")
	  	 
	  	 Return 
	EndIf 
	
	//__________________________________________________________________________________________________________________
	//                                                                                                                  |
	// Realiza a conexão SMTP 																							| 
	//__________________________________________________________________________________________________________________|
	
	If ::oServer:SmtpConnect() <> 0
	    
	     ::oServer:SmtpDisconnect()
	 	
	 	 Conout("[ERROR]Falha ao conectar: " + ::oServer:GetErrorString(::oServer:SmtpConnect()))
	    
	     Return 
	Endif
	
    //__________________________________________________________________________________________________________________ 
    //                                                                                                                  | 
	// Realiza o processo de Autenticacao junto ao Servidor                      										|
	//__________________________________________________________________________________________________________________|
	
	If ::oServer:SmtpAuth(::cConta, ::cSenha) <> 0
	
	     ::oServer:SmtpDisconnect()
	 	
	 	 Conout("[ERROR]Falha ao autenticar: " + ::oServer:GetErrorString(::oServer:smtpAuth(::cConta, ::cSenha)))
	    
	     Return 
	Endif
    
    
    //__________________________________________________________________________________________________________________
    //                                                                                                                  |
	// Instancia a Classe responsável pela criação da Mensagem	  														|                                                           
	//                                                                                                                  |
	//__________________________________________________________________________________________________________________|  
	
	::oMessage := TMailMessage():New()                                                                                     
	
	::oMessage:Clear()  
    
    
	//__________________________________________________________________________________________________________________
	//                                                                                                                  |
	// Determina o conteúdo da mensagem, assim como outras caracaterísticas (Assunto, Destinatário,Mensagem) 			|
	//__________________________________________________________________________________________________________________|
	
	::oMessage:cFrom 	:= ::cConta
	::oMessage:cTo 		:= ::cDestinatario	
	::oMessage:cCc		:= ::cCopia
	::oMessage:cSubject := ::cAssunto
	::oMessage:cBody 	:= ::cMensagem
  	
  	//__________________________________________________________________________________________________________________
	//                                                                                                                  |
	// Obtém o Layout do arquivo HTML a ser utilizado no envio da mensagem                                              |
	//                                                                                                                  |
	//__________________________________________________________________________________________________________________|                                        
  	
  	::oMessage:cBody := MemoRead(::cDiretorio ) 
  	                                 
  	
  	//__________________________________________________________________________________________________________________
	//                                                                                                                  |
	// Atribuição de valores à estética do corpo do e-mail                                                              |
	//__________________________________________________________________________________________________________________|  
  	For nK := 1 TO Len( ::aDadosHTML )
	    
	     ::oMessage:cBody := StrTran( ::oMessage:cBody, ::aDadosHTML[nK, 1], ::aDadosHTML[nK, 2])
	Next
  	
  	::oMessage:MsgBodyType( "text/html" )
  	                    
  	//__________________________________________________________________________________________________________________
	//                                                                                                                  |
	// Anexa o Arquivo a ser enviado junto ao e-mail  																	|                                                                 
	//                                                                                                                  |
	//__________________________________________________________________________________________________________________|
	If ::cAnexo <> ""
		::oMessage:AttachFile( ::cAnexo )
	Endif
	

	if ::oMessage:Send( ::oServer ) <> 0

	    Conout( "[ERROR]Nao conseguiu enviar o e-mail: " + ::oServer:GetErrorString( ::oMessage:Send( ::oServer ) ) )
		
		Return 
	  
	Endif
  	
  	
  	//__________________________________________________________________________________________________________________
  	//                                                                                                                  |
	// Desconecta do servidor 																							|
	//__________________________________________________________________________________________________________________|
	
	If ::oServer:SmtpDisconnect() != 0

	     Conout("Erro ao desconectar do servidor SMTP")
	    
	     Return 
	EndIf 
  	  	           
	//__________________________________________________________________________________________________________________
	//                                                                                                                  | 
	// Desaloca os objetos criados da memória após todo o processamento                                                 |
	//__________________________________________________________________________________________________________________|	
	  	  	 
	FreeObj(::oServer)  	  					
	FreeObj(::oMessage)
  
Return