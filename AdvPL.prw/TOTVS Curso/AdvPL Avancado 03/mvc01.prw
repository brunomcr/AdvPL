#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

user function MVC01()  //Construção básica de um browse.

//Para a construção de uma aplicação que possui um Browse, o MVC utiliza a classe FWMBrowse
oBrowse:=FWMBrowse():New() //FWMBrowse. Esta classe exibe um objeto browse que é construído
							// a partir de metadados (dicionário). 
//Definimos a tabela que será exibida na Browse utilizando o método SetAlias. As colunas, ordens, etc.. 
//A exibição é obtidos pelo metadados (dicionários). 	
oBrowse:SetAlias('SB1')
//Definimos o título que será exibido como método SetDescription.
oBrowse:SetDescription ('Meus Produtos') // SetDescription. Definimos o título que será exibido como método. 
 

//Se quisermos definir um filtro para o Browse utilizamos o método SetFilterDefault,
// que possui a seguinte sintaxe: 

//oBrowse:SetFilterDefault("B1_TIPO=='ME'")

/*Desabilitação de detalhes do Browse (DisableDetails) 
Automaticamente para o Browse são exibidos, em detalhes, os dados da linha posicionada.
 Para desabilitar esta característica utilizamos o método DisableDetails.
*/
//oBrowse:DisableDetails()
//oBrowse:DisableDetails()

/*Para o uso de legendas no Browse utilizamos o método AddLegend, que possui a seguinte sintaxe: 
AddLegend(  <cRegra>, <cCor>, <cDescrição>  ) 
Exemplo: 
oBrowse:AddLegend( "ZA0_TIPO=='1'", "YELLOW", "Autor"  ) 
oBrowse:AddLegend( "ZA0_TIPO=='2'", "BLUE"  , "Interprete"  ) 
cRegra  é a expressão em AdvPL para definir a legenda. 
cCor   é o parâmetro que define a cor de cada item da legenda. 
cDescrição  é a que será exibida para cada item da legenda 
Observação:   
 Cada uma das legendas se tornará automaticamente uma opção de filtro. 
 Cuidado ao montar as regras da legenda. Se houverem regras conflitantes será exibida a legenda
 correspondente à 1ª regra que for satisfeita. 

*/
oBrowse:AddLegend( "B1_TIPO=='ME'", "YELLOW",  "Mercadoria"  ) 
oBrowse:AddLegend( "B1_TIPO=='GE'", "BLUE"  ,  "Garantia estendida"  )
oBrowse:AddLegend( "B1_TIPO=='EM'", "GREEN"  , "Embalagem"  )
oBrowse:AddLegend( "B1_TIPO=='PA'", "RED"  ,   "Produto acabado"  )
oBrowse:AddLegend( "B1_TIPO=='MC'", "ORANGE",  "Material de consumo"  )





//Com esta estrutura básica construímos uma aplicação com Browse. 
//E ao final ativamos a classe.
oBrowse:Activate() // Ativa a classe.

return()



//Return FWMVCMenu('Mcar2')

Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE "Pesquisar"  	ACTION 'AxPesqui()'    OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.MVC01" OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"    	ACTION "VIEWDEF.MVC01" OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"    	ACTION "VIEWDEF.MVC01" OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Excluir"    	ACTION "VIEWDEF.MVC01" OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE "Imprimir" 	ACTION "VIEWDEF.MVC01" OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE "Legenda" 		ACTION "u_Lx()"        OPERATION 9 ACCESS 0

Return aRotina	


User Function Lx()

Private cCadastro:="Legenda"
BrwLegenda(cCadastro,"", {{"BR_AZUL","ME - Consumidor final"},;
								{"BR_LARANJA","GE - Garantia estendida"},;
								{"BR_VERDE","EM - Embalagem"},;
								{"BR_VERMELHO","PA - Produto acabado"},;
								{"BR_LARANJA","MC - Material de consumo"}})

Return .T.	


//--------------------------------------------------------------------------------------

Static Function ModelDef

Local oStruZA0 := FWFormStruct( 1, 'SB1' ) //Com a função FWFormStruct a estrutura será criada a partir do metadado.
                 //1 para Modelo de dados (Model) e 2 para interface (View);  
                 //'SB1 Alias da tabela no metadado; 

Local oModel // Modelo de dados que será construído 

//Construindo o Model 
oModel := MPFormModel():New( 'MVC01M' ) 


/*MPFormModel é a classe utilizada para a construção de um objeto de modelo de dados (Model). 
Devemos dar um identificador (ID) para o modelo como um todo e também um para cada componente.  
Essa é uma característica do MVC, todo componente do modelo ou da interface devem ter um ID,
como formulários, GRIDs, boxes, etc. 
COMP011M é o identificador (ID) dado ao Model, é importante ressaltar com relação ao identificador (ID) do Model:  
Se a aplicação é uma Function, o identificador (ID) do modelo de dados (Model) pode ter o mesmo nome da função principal e esta prática é recomendada para facilitar a codificação. Por exemplo, se estamos escrevendo a função XPTO, o identificador (ID) do modelo de dados (Model) poderá ser XPTO. 
Se a aplicação é uma User Function o identificador (ID) do modelo de dados (Model) NÃO 
16 - AdvPl utilizando MVC 
pode ter o mesmo nome da função principal, isso por causa dos pontos de entrada que já são criados
automaticamente quando desenvolvemos uma aplicação em MVC. Isso será mais detalhado à frente (ver capítulo 0 Pontos de entrada 
*/

/*
Criação de um componente de formulários no modelo de dados (AddFields) 
O método AddFields adiciona um componente de formulário ao modelo. 
A estrutura do modelo de dados (Model) deve iniciar, obrigatoriamente, com um componente de formulário. 
Exemplo: 
*/
//oModel:AddFields( 'ZA0MASTER', /*cOwner*/, oStruZA0 )  
//Devemos dar um identificador (ID) para cada componente do modelo.  
//ZA0MASTER é o identificador (ID) dado ao componente de formulário no modelo, 
//oStruZA0 é a estrutura que será usada no formulário e que foi construída anteriormente utilizando
//FWFormStruct, note que o segundo parâmetro (owner) não foi informado, isso porque este é o
//1º componente do modelo, é o Pai do modelo de dados (Model) e portanto não tem um componente superior
//ou owner. 


oModel:AddFields( 'ZA0MASTER', /*cOwner*/, oStruZA0 ) 

// Descrição dos componentes do modelo de dados (SetDescription) 
//Sempre definindo uma descrição para os componentes do modelo.  
//Com o método SetDescription adicionamos a descrição ao modelo de dados (Model), essa descrição será usada
//em vários lugares como em Web Services por exemplo.
//Adicionamos a descrição do modelo de dados: 
oModel:SetDescription( 'Modelo de dados de Autor/Interprete' ) 
//Para um modelo que só contêm um componente parece ser redundante darmos uma descrição para o modelo de dados
//(Model) como um todo e uma para o componente, mas quando estudarmos outros modelos onde haverá mais de um
//componente esta ação ficará mais clara. 
//Adicionamos a descrição dos componentes do modelo de dados: 
oModel:GetModel( 'ZA0MASTER' ):SetDescription( 'Dados de Autor/Interprete' )

//Finalização de ModelDef 
//Ao final da função ModelDef, deve ser retornado o objeto de modelo de dados (Model) gerado na função.
Return oModel 

//--------------------------------------------



Static Function ViewDef()

Local oStruZA0 := FWFormStruct( 2, 'SB1' )

//A interface (View) é responsável por possibilitar a interação do usuário, ou seja,
//é o responsável por exibir os dados.  
//O ViewDef contêm a definição de toda a parte visual da aplicação. 
//A interface (View) sempre trabalha baseada em um modelo de dados (Model). Criaremos um objeto de modelo de dados baseado no ModelDef que desejamos.  
//Com a função FWLoadModel obtemos o modelo de dados (Model) que está
//definido em um fonte, no nosso caso é o próprio fonte, mas nada impediria que usássemos o modelo
//de qualquer outro fonte em MVC, com isso podemos reaproveitar um mesmo modelo de dados (Model)
//em mais de uma interface (View). 
Local oModel := FWLoadModel( 'MVC01' ) //MVC01 é nome do fonte de onde queremos obter o modelo de dados (Model). 
//Iniciando a construção da interface (View) 
oView := FWFormView():New() 
//FWFormView é a classe que deverá ser usada para a construção de um objeto de interface (View). 
//Definimos qual o modelo de dados (Model) que será utilizado na interface (View). 
oView:SetModel( oModel ) 
//Criação de um componente de formulários na interface (AddField) 
//Adicionamos no nosso interface (View) um controle do tipo formulário (antiga Enchoice),
//para isso usamos o método AddField 
//A interface (View) deve iniciar, obrigatoriamente, com um componente do tipo formulário. 
//Devemos dar um identificador (ID) para cada componente do interface (View).
//VIEW_ZA0 é o identificador (ID) dado ao componente da interface (View), oStruZA0 é a estrutura que será
//usada e ZA0MASTER é identificador (ID) do componente do modelo de dados (Model) vinculado a este componente
//da interface (View). 
//Cada componente da interface (View) deve ter um componente do modelo de dados (Model) relacionado,
//isso equivale a dizer que os dados do ZA0MASTER serão exibidos na interface (View) no componente VIEW_ZA0

oView:AddField( 'VIEW_ZA0', oStruZA0, 'ZA0MASTER' ) 

//Exibição dos dados na interface (CreateHorizontalBox / CreateVerticalBox) 
//Sempre precisamos criar um contêiner1, um objeto, para receber algum elemento da interface (View).
//Em MVC criaremos sempre box horizontal ou vertical para isso. 
//O método para criação de um box horizontal é: 
oView:CreateHorizontalBox( 'TELA' , 100 ) 
//Devemos dar um identificador (ID) para cada componente da interface (View). 
//TELA é o identificador (ID) dado ao box e o número 100 representa o percentual da tela que será utilizado pelo Box. 
//No MVC não há referências a coordenadas absolutas de tela, os componentes visuais são sempre All Client,
//ou seja, ocuparão todo o contêiner onde for inserido.

//Relacionando o componente da interface (SetOwnerView) 
//Precisamos relacionar o componente da interface (View) com um box para exibição, para isso usamos o método
// SetOwnerView.
oView:SetOwnerView( 'VIEW_ZA0', 'TELA' ) 
//oView:SetOwnerView( 'VIEW_ZA0', 'TELA' ) 
// Finalização da ViewDef 
//Ao final da função ViewDef, deve ser retornado o objeto de interface (View) gerado 


Return oView 
