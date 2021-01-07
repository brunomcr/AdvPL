#Include "PROTHEUS.CH"
#Include "TOTVS.CH"

//Rotina que soma ou subtrai somente se for dia útil
//Obs.: Deve-se cadastrar os feriados na tabela genéria 63 (ex: 03/04/15 PAIXAO DE CRISTO ou 21/04 TRIRADENTES)

User Function x1_DiaUtil(dDataIni,nSoma)
//RpcSetEnv("01","01",,,"FAT",,)			//Descomentar para teste
//Default dDataIni := CtoD("22/04/2016")	//Descomentar para teste
//Default nSoma := -20						//Descomentar para teste

nDiaUtil:= 0
dData 	:= dDataIni

While nDiaUtil < nSoma
	dData++
	If dData == datavalida(dData)
		nDiaUtil++
	Endif
End

While nDiaUtil > nSoma
	dData--
	If dData == datavalida(dData)
		nDiaUtil--
	Endif
End

//MsgAlert(DtoC(dData))		//Descomentar para teste

Return(dData)


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Rotina que retorna o número de diasúteis entre duas datas
//Obs.: Deve-se cadastrar os feriados na tabela genéria 63 (ex: 03/04/15 PAIXAO DE CRISTO ou 21/04 TRIRADENTES)

User Function x2_DiaUtil(dData1,dData2)
//RpcSetEnv("01","01",,,"FAT",,)			//Descomentar para teste
//Default dData1 := CtoD("27/04/2015")	//Descomentar para teste
//Default dData2 := CtoD("16/04/2015")	//Descomentar para teste

nDiaUtil:= 0

While dData2 <> dData1
	dData2++
	If dData2 == datavalida(dData2)
		nDiaUtil++
	Endif
End

//MsgAlert(STR(nDiaUtil))		//Descomentar para teste

Return(nDiaUtil)