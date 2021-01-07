#include "msobject.ch"
#include "shash.ch"

CLASS SHASH

	DATA aData
	DATA cClassName

	METHOD NEW() CONSTRUCTOR

	METHOD ClassName()

	METHOD GetAt( uPropertyKey )
	METHOD Get( uPropertyKey , uDefaultValue )
	METHOD Set( uPropertyKey , uValue )
	METHOD Remove( uPropertyKey )
	METHOD GetAll( )

ENDCLASS

User Function SHASH()
Return( SHASH():New() )


METHOD New() CLASS SHASH

	Self:aData			:= Array( 0 )
	Self:cClassName		:= "SHASH"

Return( Self )


METHOD ClassName() CLASS SHASH
Return( Self:cClassName )


METHOD GetAt( uPropertyKey ) CLASS SHASH

	Local nATProperty	:= 0

	BEGIN SEQUENCE

		nATProperty		:= aScan( Self:aData, { |aValues| ( Compare( aValues[ SPROPERTY_KEY ] , uPropertyKey ) ) } )

	END SEQUENCE

Return( nATProperty )


METHOD Get( uPropertyKey , uDefaultValue ) CLASS SHASH

	Local uPropertyValue	:= "@__PROPERTY_NOT_FOUND__@"

	Local nProperty

	BEGIN SEQUENCE

		nProperty			:= Self:GetAt( @uPropertyKey )
		IF ( nProperty == 0 )
			BREAK
		EndIF

		uPropertyValue		:= Self:aData[ nProperty ][ SPROPERTY_VALUE ]

	END SEQUENCE

	IF ( Compare( uPropertyValue , "@__PROPERTY_NOT_FOUND__@" ) )
		IF !Empty( uDefaultValue )
			uPropertyValue	:= uDefaultValue
		Else
			uPropertyValue	:= NIL
		EndIF	
	EndIF

Return( uPropertyValue )

METHOD Set( uPropertyKey , uValue ) CLASS SHASH

	Local lSuccess			:= .F.
	
	Local nProperty

	BEGIN SEQUENCE

		nProperty			:= Self:GetAt( @uPropertyKey )

		IF ( nProperty == 0 )
			aAdd( Self:aData , Array( SPROPERTY_ELEMENTS ) )
			nProperty		:= Len( Self:aData )
		EndIF	

		Self:aData[ nProperty ][ SPROPERTY_KEY   ] := uPropertyKey
		Self:aData[ nProperty ][ SPROPERTY_VALUE ] := uValue

		lSuccess			:= .T.

	END SEQUENCE

Return( lSuccess )

METHOD Remove( uPropertyKey ) CLASS SHASH

	Local lSuccess		:= .F.
	
	Local nProperty

	BEGIN SEQUENCE

		nProperty		:= Self:GetAt( @uPropertyKey )
		IF ( nProperty == 0 )
			BREAK
		EndIF

		lSuccess		:= .T.

		aDel( Self:aData , nProperty )
		aSize( Self:aData , Len( Self:aData[ nSession ][ SPROPERTY_POSITION ] ) - 1 )

	END SEQUENCE

Return( lSuccess )

METHOD GetAll() CLASS SHASH
Return( Self:aData )