#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "ERROR.CH"
#INCLUDE "TRYEXCEPTION.CH" 
#INCLUDE "TOPCONN.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WSSTART   �Autor  �Denis D Almeida     � Data �  13/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel pela subida das Threads e Conex�es da    ���
���          �Empresa para acesso WEB                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Web Services                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function WSSTART()
	Local cWebFilial  	:= Alltrim(GetJobProfString('WebFilial'  , '-1'))
	Local cWebEmpresa 	:= Alltrim(GetJobProfString('WebEmpresa' , '-1'))
	Local aTables 		:= {'SB1','SB2','ZBM','DA1','DA0','SA1','CC2'}
	
	If cWebFilial == '-1' .OR. cWebEmpresa == '-1'
		conout('Configura��o invalida de Filial. Verificar webfilial/webempresa nos Jobs')
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