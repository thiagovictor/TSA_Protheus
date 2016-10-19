#Include "FiveWin.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SintegMG  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 01.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Arquivo Magnetico do Sintegra de MG - Registro Tipo 88A     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SintegMG()

Local aArea		:= GetArea()
Local aStru88  	:= {}
Local cArq88	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Registro Tipo 88A - Sintegra Minas Gerais                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aStru88,{"A88_CNPJ"	,"C",014,0})
AADD(aStru88,{"A88_IE"		,"C",014,0})
AADD(aStru88,{"A88_DTEMIS"	,"D",008,0})	//Data de Emissao
AADD(aStru88,{"A88_UF"		,"C",002,0})
AADD(aStru88,{"A88_MODELO"	,"C",002,0})
AADD(aStru88,{"A88_SERIE"	,"C",003,0})
AADD(aStru88,{"A88_NF"		,"C",006,0})
AADD(aStru88,{"A88_CFOP"	,"C",004,0})
AADD(aStru88,{"A88_SUBSER"	,"C",002,0})	//Sub-Serie
AADD(aStru88,{"A88_VALCON"	,"N",013,2})
AADD(aStru88,{"A88_VALICM"	,"N",013,2})
AADD(aStru88,{"A88_NFEMP"	,"C",007,0})	//Nota de Empenho
AADD(aStru88,{"A88_DTEMP"	,"D",008,0})	//Data da Nota de Empenho
AADD(aStru88,{"A88_CODEX"	,"C",007,0})	//Codigo da Unidade Executora
AADD(aStru88,{"A88_DI"		,"C",010,0})	//Declaracao de Importacao
AADD(aStru88,{"A88_NFIMP"	,"C",006,0})	//Nota Fiscal emitida na Entrada da mercadoria ou bem importado

cArq88 := CriaTrab(aStru88)
dbUseArea(.T.,__LocalDriver,cArq88,"R88")
IndRegua("R88",cArq88,"A88_CNPJ+A88_IE+A88_NF+A88_SERIE")

RestArea(aArea)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GravaMG88A ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 01.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rotina de gravacao do Registro 88A                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GravaMG88A(aArrayF3,cCNPJ,cIE,cChaveAux,cCfoAux,cChaveAux2,nI)

Local aNFEmp := MGEmp(Alltrim(aArrayF3[nI][Len(aArrayF3[nI])]))	//NF Empenho
Local nX     := 0

For nX := 1 To Len(aNFEmp)
	If (cChaveAux == aArrayF3[nI][24] .Or. nI==1) .Or. (cCfoAux<>aArrayF3[nI][05]) .Or. (cChaveAux2 <> aArrayF3[nI][08])
	    RecLock("R88",.T.)
		R88->A88_CNPJ	:= cCNPJ
		R88->A88_IE		:= cIE
	    R88->A88_DTEMIS	:= aArrayF3[nI][10]
	    R88->A88_UF		:= aArrayF3[nI][22]
		R88->A88_MODELO	:= AModNot(aArrayF3[nI][7])
		R88->A88_SERIE	:= aArrayF3[nI][2]
		R88->A88_NF		:= aArrayF3[nI][1]
		R88->A88_CFOP	:= aArrayF3[nI][5]
		R88->A88_SUBSER	:= Space(02)
		R88->A88_NFEMP	:= StrZero(Val(aNFemp[nX][1]),7)	//Nota de Empenho
		R88->A88_DTEMP	:= aNFemp[nX][2]					//Data da Nota de Empenho
		R88->A88_CODEX	:= StrZero(Val(aNFemp[nX][3]),7)	//Codigo da Unidade Executora
		R88->A88_DI		:= MGDI(aArrayF3,nI)				//Declaracao de Importacao
		R88->A88_NFIMP	:= "000000"							//Nota Fiscal emitida na Entrada da mercadoria ou bem importado
		MsUnlock()
	Endif
	RecLock("R88",.F.)
	R88->A88_VALCON		+=	aArrayF3[nI][17]
	R88->A88_VALICM		+=	aArrayF3[nI][16]
	MsUnlock()
Next
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MGEmp      ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 01.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna Numero, Data e Codigo da Executora da NF de Empenho  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MGEmp(cCpoEmp)

Local aNFEmp := {}
Local aEmp   := {}
Local nPos   := 0

cCpoEmp := StrTran(cCpoEmp,"-",";")
While (nPos:=At(";",cCpoEmp)) > 0
	If nPos > 0
		AADD(aEmp,IIf("/"$Left(cCpoEmp,nPos-1),Ctod(Left(cCpoEmp,nPos-1)),Left(cCpoEmp,nPos-1)))
		If Len(aEmp)==3
			AADD(aNFEmp,aEmp)
			aEmp := {}
	    Endif
	    cCpoEmp := Substr(cCpoEmp,nPos+1)
	Endif
Enddo
AADD(aEmp,Alltrim(cCpoEmp))
If Len(aEmp)==3
	AADD(aNFEmp,aEmp)
Endif

Return(aNFEmp)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MGDI       ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 01.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna a Declaracao de Importacao                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MGDI(aArrayF3,nI)

Local aArea  := GetArea()
Local cCpoDI := GetNewPar("MV_DI","")
Local cDI    := ""

If Left(aArrayF3[nI][5],1) < "5" .And. !Empty(cCpoDI)
	dbSelectArea("SD1")
	dbSetOrder(1)
	If dbSeek(xFilial("SD1")+aArrayF3[nI][1]+aArrayF3[nI][2]+aArrayF3[nI][3]+aArrayF3[nI][4]) 
		cDI := &cCpoDI
		If ValType(cDI)=="N"
			cDI := StrZero(cDI,10)
		Else
			cDI := StrZero(Val(cDI),10)	
		Endif
    Endif
Endif

RestArea(aArea)

Return(cDI)
