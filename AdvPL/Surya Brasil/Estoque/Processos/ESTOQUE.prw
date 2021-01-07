#include "Protheus.ch"
#include "topconn.ch"  
#include "Totvs.ch"  
#include "tbiconn.ch"
#include "tbicode.ch"
#INCLUDE "fileio.ch"


/*/{Protheus.doc} User Function xEstoque
    (long_description)
    @type  Function
    @author user
    @since 09/12/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xEstoque(aParam)
    Local xEmp      := aParam[1]
    Local xFil      := aParam[2]
    //Declara Query
    Local cQueryB8   := ""
    Local cQueryB2   := ""
    Local cAliasB8   := ""
    Local cAliasB2   := ""


Return return_var