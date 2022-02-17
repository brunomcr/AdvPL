#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} SPFCLOSE
Fechar arquivo de senha

@author Eurai Rapelli
@since 18/09/2014

@Example U_SPFCLOSE()
@Example U_SPFCLOSEX()
passo a passo
01. Renomear seu arquivo de senha sigapss e abrir sistema para ser recriado com user => admin e senha => em branco.

02. Compilar o fonte abaixo:

03. Abrir SIGACFG e ir no formulas.

04. Com formulas aberto, clicar em incluir e digitar a função U_SPFCLOSEX().

05. Sem fechar o formulas, deletar o arquivo sigapss.

06. Com seu arquivo renomeado anteriormente, voltar o nome para o padrão do sistema.

07. Voltar ao SIGACFG, fechar o formulas e ir até o cadastro de usuário.

08. Alterar senha.

PS: SIGAPSS fica na pasta /system/ do sistema.

/*/


User Function SPFCLOSE()

SPF_CLOSE("SIGAPSS.SPF")

Return( Nil )