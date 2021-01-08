#Include "aarray.ch"
#Include "json.ch"

Function FromJson(cJstr)
Return GetJsonVal(cJstr)[1]

Function ToJson (uAnyVar)
	Local cRet, nI, cType, aAsKeys
	
	cType := valType(uAnyVar)
	DO CASE
		case cType == "C"
			return '"'+ EscpJsonStr(uAnyVar) +'"'
		case cType == "N"
			return CvalToChar(uAnyVar)
		case cType == "L"
			return if(uAnyVar,"true","false") 
		case cType == "D"
			return '"'+ DtoS(uAnyVar) +'"'
		case cType == "U"
			return "null"
		case cType == "A"
			cRet := '['
			For nI := 1 to len(uAnyVar)
				if(nI != 1)
					cRet += ', '
				endif
				cRet += ToJson(uAnyVar[nI])
			Next
			return cRet + ']'
		case cType == "B"
			return '"Type Block"'
		case cType == "M"
			return '"Type Memo"'
		case cType =="O"
			if uAnyVar:cClassName == "SHASH"
				cRet := '{'
				For nI := 1 to len(uAnyVar:aData)
					if(nI != 1)
						cRet += ', '
					endif
					cRet += '"'+ EscpJsonStr(uAnyVar:aData[nI][SPROPERTY_KEY]) +'": '+ ToJson(uAnyVar:aData[nI][SPROPERTY_VALUE])
				Next
				return cRet + '}'
		   	endif
			return '"Type Object"'
#IFDEF __HARBOUR__
		case cType =="H"
			aAsKeys := hb_hkeys(uAnyVar)
			cRet := '{'
			For nI := 1 to len(aAsKeys)
				if(nI != 1)
					cRet += ', '
				endif
				cRet += '"'+ EscpJsonStr(aAsKeys[nI]) +'": '+ ToJson(uAnyVar[aAsKeys[nI]])
			Next
			return cRet + '}'
#ENDIF
	ENDCASE
Return '"Unknown Data Type ('+ cType +')"'

Function EscpJsonStr(cJsStr)
	cJsStr := StrTran(cJsStr, '\', '\\')
	cJsStr := StrTran(cJsStr, '"', '\"')
	cJsStr := StrTran(cJsStr, CHR_FF, '\f')
	cJsStr := StrTran(cJsStr, CHR_LF, '\n')
	cJsStr := StrTran(cJsStr, CHR_CR, '\r')
	cJsStr := StrTran(cJsStr, CHR_HT, '\t')
Return cJsStr


Function JsonPrettify(cJstr, nTab)
	Local nConta, cBefore, cTab
	Local cLetra := ""
	Local lInString := .F.
	Local cNewJsn := ""
	Local nIdentLev := 0
	Default nTab := -1

	if nTab > 0
		cTab := REPLICATE(" ", nTab)
	else
	    cTab := CHR_HT
	endif
		

	For nConta:= 1 To Len(cJstr)
	
		cBefore := cLetra
		cLetra := SubStr(cJstr, nConta, 1)		
		
		if cLetra == "{" .or. cLetra == "["
			if !lInString
				nIdentLev++
				cNewJsn += cLetra + CRLF + REPLICATE( cTab, nIdentLev)
			else
				cNewJsn += cLetra
			endif
		elseif cLetra == "}" .or. cLetra == "]"
			if !lInString
				nIdentLev--
				cNewJsn += CRLF + REPLICATE(cTab, nIdentLev) + cLetra
			else
				cNewJsn += cLetra
			endif
		elseif cLetra == ","
	   		if !lInString
				cNewJsn += cLetra + CRLF + REPLICATE(cTab, nIdentLev)
			else
				cNewJsn += cLetra
			endif
		elseif cLetra == ":"
	   		if !lInString
				cNewJsn += ": "
			else
				cNewJsn += cLetra
			endif
		elseif cLetra == " " .or. cLetra == CHR_LF .or. cLetra == CHR_HT
			if lInString
				cNewJsn += cLetra
			endif
		elseif cLetra == '"'
	   		if cBefore != "\"
				lInString := !lInString
			endif
			cNewJsn += cLetra
		else
			cNewJsn += cLetra
		endif
	Next
Return cNewJsn


Function JsonMinify(cJstr)
	Local nConta, cBefore
	Local cLetra := ""
	Local lInString := .F.
	Local cNewJsn := ""
	Local lInLineCommt := .F.
	Local lMultLineCommt := .F.

	For nConta:= 1 To Len(cJstr)
	
		cBefore := cLetra
		cLetra := SubStr(cJstr, nConta, 1)
		
		if lInLineCommt
			if cLetra == CHR_LF // \n
				lInLineCommt := .F.
			endif
		elseif lMultLineCommt
			if cBefore == "*" .and. cLetra == "/"
				lMultLineCommt := .F.
			endif
		elseif !lInString .and. cLetra == "/" .and. SubStr(cJstr, nConta+1, 1) == "/"
			lInLineCommt := .T.
		elseif !lInString .and. cLetra == "/" .and. SubStr(cJstr, nConta+1, 1) == "*"
			lMultLineCommt := .T.
		
		// real json
		elseif cLetra == "{" .or. cLetra == "["
			cNewJsn += cLetra
		elseif cLetra == "}" .or. cLetra == "]"
			cNewJsn += cLetra
		elseif cLetra == ","
			cNewJsn += cLetra
		elseif cLetra == ":"
			cNewJsn += cLetra
		elseif cLetra == " " .or. cLetra == CHR_LF .or. cLetra == CHR_HT .or. cLetra == CHR_CR
			if lInString
				cNewJsn += cLetra
			endif
		elseif cLetra == '"'
	   		if cBefore != "\"
				lInString := !lInString
			endif
			cNewJsn += cLetra
		else
			cNewJsn += cLetra
		endif
	Next
Return cNewJsn



Function ReadJsonFile(cFileName, lStripComments)
	Default lStripComments := .T.
	if !File(cFileName)
		Return Nil
	endif

	if lStripComments
		Return FromJson(JsonMinify(MemoRead(cFileName, .F.)))
	else
		Return FromJson(MemoRead(cFileName, .F.))
	endif
Return


Static Function GetJsonVal(cJstr) 
	Local nConta
	Local cLetra := ""
	Local aTmp
    
	BEGIN SEQUENCE

		For nConta:= 1 To Len(cJstr)
		
			cLetra := SubStr(cJstr, nConta, 1)
	
			if cLetra == '"'
				aTmp := JsonStr(SubStr(cJstr, nConta))
				BREAK
			elseif at(cLetra, "0123456789.-") > 0
				aTmp := JsonNum(SubStr(cJstr, nConta))
				BREAK
			elseif cLetra == "["
				aTmp := JsonArr(SubStr(cJstr, nConta))
				BREAK
			elseif cLetra == "{"
				aTmp := JsonObj(SubStr(cJstr, nConta))
				BREAK
			elseif at(cLetra, "TtFfNn") > 0 //True, False or Null
				aTmp := JsonTFN(SubStr(cJstr, nConta))
				BREAK
			endif
	
		Next
		
	END SEQUENCE
	
	if len(aTmp) > 0
		if aTmp[2] < 0
		     return {Nil, -1}
		endif
	    
		return {aTmp[1], nConta + aTmp[2] -1}
	
	endif
	
Return {Nil, -1}


Static Function JsonArr(cJstr)
	Local nConta
	Local cLetra := ""
	Local lNeedComma := .F.
	Local aRet := {}
	Local aTmp
    
	BEGIN SEQUENCE 

		For nConta:= 2 To Len(cJstr)
		
			cLetra := SubStr(cJstr, nConta, 1)
			
			if !lNeedComma .and. at(cLetra, '"{[0123456789.-') > 0
				aTmp := GetJsonVal(SubStr(cJstr, nConta))
				if aTmp[2] < 0
					return {Nil, -1} // Error Code
				endif
				AADD(aRet, aTmp[1])
				nConta := nConta + aTmp[2] -1
				lNeedComma := .T.
			elseif lNeedComma .and. cLetra == ','
				lNeedComma := .F.
			elseif cLetra == ']'
				return {aRet, nConta}
			endif
	
		Next
	
	END SEQUENCE
	
Return {Nil, -1}


Static Function JsonObj(cJstr)
	Local nConta
	Local cLetra := ""
	Local cTmpStr := ""
	Local nStep := 1
	Local aTmp
	Local aaRet := array(#)
	
	BEGIN SEQUENCE

		For nConta:= 2 To Len(cJstr)
		
			cLetra := SubStr(cJstr, nConta, 1)
			
			if nStep == 1 .and. cLetra == '"'
					aTmp := JsonStr(SubStr(cJstr, nConta))
					if aTmp[2] < 0
						return {Nil, -1} // Error Code
					endif
					nConta := nConta + aTmp[2] -1
					cTmpStr := aTmp[1]
					nStep := 2
	
			elseif nStep == 2 .and. cLetra == ':'
				nStep := 3
				
			elseif nStep == 3 .and. at(cLetra, '"{[0123456789.-TtFfNn') > 0
				aTmp := GetJsonVal(SubStr(cJstr, nConta))
				if aTmp[2] < 0
					return {Nil, -1} // Error Code
				endif
				nConta := nConta + aTmp[2] -1
				nStep := 4
			elseif nStep == 4 .and. cLetra == ','
				aaRet[#cTmpStr] := aTmp[1]
				nStep := 1
			elseif nStep == 4 .and. cLetra == '}'
				aaRet[#cTmpStr] := aTmp[1]
				return {aaRet, nConta}
			endif
	
		Next
	
	END SEQUENCE
	
Return {Nil, -1}


Static Function JsonStr(cJstr)
	Local nConta
	Local cLetra := ""
	Local cTmpStr := ""
	Local nUnic
	
	BEGIN SEQUENCE

		For nConta:= 2 To Len(cJstr)
		
			cLetra := SubStr(cJstr, nConta, 1)
			
			if cLetra == "\"
				nConta++
				cLetra := SubStr(cJstr, nConta, 1)
				if cLetra == 'b'
					cTmpStr += CHR_BS
				elseif cLetra == 'f'
					cTmpStr += CHR_FF
				elseif cLetra == 'n'
					cTmpStr += CHR_LF
				elseif cLetra == 'r'
					cTmpStr += CHR_CR
				elseif cLetra == 't'
					cTmpStr += CHR_HT
				elseif cLetra == 'u'
					nUnic := CTON(UPPER(SubStr(cJstr, nConta+1, 4)),16)
					if nUnic <= 255
						cTmpStr += chr(nUnic)
					else
						cTmpStr += '?'
					endif
					nConta += 4
				else
					cTmpStr += cLetra
				endif
			
			elseif cLetra == '"'
				return {cTmpStr, nConta}
			else
				cTmpStr += cLetra
			endif
	
		Next
	
	END SEQUENCE
	
Return {Nil, -1}


Static Function JsonNum(cJstr)
	Local nConta, nNum, aTmp
	Local cLetra := ""
	Local cTmpStr := ""
	Local lNegExp := .F.
	
	BEGIN SEQUENCE

		For nConta:= 1 To Len(cJstr)
		
			cLetra := SubStr(cJstr, nConta, 1)
	
			if at(cLetra, '0123456789.-') > 0
				cTmpStr += cLetra
	
			elseif len(cLetra) > 0 .and. UPPER(cLetra) == 'E'
				nNum := val(cTmpStr)
				cTmpStr := ""
				nConta++
				cLetra := SubStr(cJstr, nConta, 1)
				if cLetra == '-'
					lNegExp := .T.
					nConta++
				elseif cLetra == '+'
					nConta++
				endif
				cLetra := SubStr(cJstr, nConta, 1)
				
				while at(cLetra, '0123456789') > 0 
					cTmpStr += cLetra
					nConta++
					cLetra := SubStr(cJstr, nConta, 1)
				end
				
				if lNegExp
					//nNum := nNum / val('1'+REPLICATE( '0', val(cTmpStr) ))
					if val(cTmpStr) != 0
						nNum := nNum * val('0.'+REPLICATE( '0', val(cTmpStr)-1) + '1')
					endif
				else
					nNum := nNum * val('1'+REPLICATE( '0', val(cTmpStr) ))
				endif
				
				return {nNum, nConta-1}
				
			elseif len(cLetra) > 0
				return {val(cTmpStr), nConta-1}
			endif
	
		Next
	
	END SEQUENCE
	
Return {Nil, -1}


Static Function JsonTFN(cJstr)
	Local cTmpStr
    
	BEGIN SEQUENCE

	    cTmpStr := lower(SubStr(cJstr, 1, 5))
	    
	    if cTmpStr == "false"
	    	return {.F., 5}
	    endif
	    
	    cTmpStr := SubStr(cTmpStr, 1, 4)
	    
	    if cTmpStr == "true"
	    	return {.T., 4}   	
	    elseif cTmpStr == "null"
	    	return {Nil, 4}
	    endif 
    
	END SEQUENCE

Return {Nil, -1}