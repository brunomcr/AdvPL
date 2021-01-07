#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "ERROR.CH"
#INCLUDE "TRYEXCEPTION.CH" 
#INCLUDE "TOPCONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWSSTART   บAutor  ณDenis D Almeida     บ Data ณ  13/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsแvel pela subida das Threads e Conex๕es da    บฑฑ
ฑฑบ          ณEmpresa para acesso WEB                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Web Services                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WSSTART()
	Local cWebFilial  	:= Alltrim(GetJobProfString('WebFilial'  , '-1'))
	Local cWebEmpresa 	:= Alltrim(GetJobProfString('WebEmpresa' , '-1'))
	Local aTables 		:= {'SB1','SB2','ZBM','DA1','DA0','SA1','CC2'}
	
	If cWebFilial == '-1' .OR. cWebEmpresa == '-1'
		conout('Configura็ใo invalida de Filial. Verificar webfilial/webempresa nos Jobs')
		Return .f.
	EndIf  
	
	TCSetDummy(.t.)
	RpcSetType(3)
	If FindFunction('WFPREPENV')
	     wfPrepENV( cWebEmpresa, cWebFilial)
	Else
	     RpcSetEnv ( cWebEmpresa, cWebFilial,,,"MAK",,aTables)
	EndIf
	InitPublic()
	SetsDefault()
	SetModulo("SIGACOM","COM")
	
	conout("*___________________________________________*")
	conout("*            Web Services Protheus          *")
	conout("*Ambiente iniciado com sucesso( WSStart )*   ") 
	conout("*WebEmpresa = "+cWebEmpresa+"			 *   ")
	conout("*WebFilial  = "+cWebFilial+"			 *   ")
	conout("*___________________________________________*")
Return( .t. )