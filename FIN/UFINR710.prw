#Include "FINR710.CH"
#Include "PROTHEUS.CH"

Static lFWCodFil := FindFunction("FWCodFil")

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FinR710	³ Autor ³ Wagner Xavier 	    ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Bordero de Pagamento.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FinR710(void)						  					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UFINR710()

Local oReport
Local aAreaR4	:= GetArea()

oReport := ReportDef()
oReport:PrintDialog()

RestArea(aAreaR4)  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Marcio Menon		   º Data ³  27/07/06 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Grupo de perguntas do relatorio                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 												              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local cReport 	:= "FINR710" 				// Nome do relatorio
Local cDescri 	:= STR0001 + STR0002   	//"Este programa tem a fun‡„o de emitir os borderos de pagamen-" ### "tos."
Local cTitulo 	:= STR0003 					//"Emiss„o de Borderos de Pagamentos"
Local cPerg		:= "UIN710"					// Nome do grupo de perguntas

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("UIN710",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para parametros								 ³
//³ mv_par01				// Do Bordero									 ³
//³ mv_par02				// At‚ o Bordero								 ³
//³ mv_par03				// Data para d‚bito							 ³
//³ mv_par04				// Qual Moeda									 ³
//³ mv_par05				// Outras Moedas								 ³
//³ mv_par06				// Converte por								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a data para debito com a data base do sistema			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX1")

If dbSeek (Padr( "UIN710" , Len( X1_GRUPO ) , ' ' )+"03")  // Busca a pergunta para mv_par03
	Reclock("SX1",.F.)
	Replace X1_CNT01 With "'"+dtoc(dDataBase)+"'"
	MsUnlock()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New(cReport, cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cDescri) 

oReport:HideHeader()		//Oculta o cabecalho do relatorio
oReport:SetLandscape() //:SetPortrait()	//Imprime o relatorio no formato retrato
oReport:HideFooter()		//Oculta o rodape do relatorio

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                                        ³
//³                      Definicao das Secoes                              ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 01                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport, STR0054 , {"SEA"})	//"CABECALHO"

TRCell():New(oSection1, "CABEC", "", STR0054 , "", 80,/*lPixel*/,/*CodeBlock*/)		//"CABECALHO"

oSection1:SetHeaderSection(.F.)	//Nao imprime o cabecalho da secao
oSection1:SetPageBreak(.T.)		//Salta a pagina na quebra da secao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 02                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1, STR0041 , {"SEA","SA6","SEF","SA2","SE2"})		//"BORDERO"

TRCell():New(oSection2, "EA_PREFIXO", "SEA", STR0042 , PesqPict("SEA","EA_PREFIXO"), TamSX3("EA_PREFIXO")[1],/*lPixel*/,/*CodeBlock*/)	//"PRF"
TRCell():New(oSection2, "EA_NUM"    , "SEA", STR0043 , PesqPict("SEA","EA_NUM")    , TamSX3("EA_NUM")[1]    ,/*lPixel*/,/*CodeBlock*/)	//"NUMERO"
TRCell():New(oSection2, "EA_PARCELA", "SEA", STR0044 , PesqPict("SEA","EA_PARCELA"), TamSX3("EA_PARCELA")[1],/*lPixel*/,/*CodeBlock*/)	//"PC"

//Customizado gilson
TRCell():New(oSection2, "E2_TIPO"   , "SE2", OemToAnsi("Tipo")    , PesqPict("SE2","E2_TIPO")    , TamSX3("E2_TIPO")[1],/*lPixel*/,/*CodeBlock*/)	//Tipo
TRCell():New(oSection2, "E2_FORNECE", "SE2", OemToAnsi("Fornece") , PesqPict("SE2","E2_FORNECE") , TamSX3("E2_FORNECE")[1],/*lPixel*/,/*CodeBlock*/)	//Fornece
TRCell():New(oSection2, "E2_LOJA"   , "SE2", OemToAnsi("Loja")    , PesqPict("SE2","E2_LOJA")    , TamSX3("E2_LOJA")[1],/*lPixel*/,/*CodeBlock*/)	//Loja


TRCell():New(oSection2, "BENEF"     , ""   , STR0045 , PesqPict("SA2","A2_NOME")   , 33,/*lPixel*/,/*CodeBlock*/)								//"B E N E F I C I A R I O"
TRCell():New(oSection2, "A6_NREDUZ" , "SA6", STR0046 , PesqPict("SA6","A6_NREDUZ") , 15,/*lPixel*/,/*CodeBlock*/)								//"BANCO"
TRCell():New(oSection2, "EF_NUM"    , "SEF", STR0047 , PesqPict("SEF","EF_NUM")    , TamSX3("EF_NUM")[1]    ,/*lPixel*/,/*CodeBlock*/)	//"HISTORICO"
TRCell():New(oSection2, "A2_BANCO"  , "SA2", STR0048 , PesqPict("SA2","A2_BANCO")  , TamSX3("A2_BANCO")[1]  ,/*lPixel*/,/*CodeBlock*/)	//"BCO"
TRCell():New(oSection2, "A2_AGENCIA", "SA2", STR0049 , PesqPict("SA2","A2_AGENCIA"), TamSX3("A2_AGENCIA")[1],/*lPixel*/,/*CodeBlock*/)	//"AGENC"
TRCell():New(oSection2, "A2_NUMCON" , "SA2", STR0050 , PesqPict("SA2","A2_NUMCON") , TamSX3("A2_NUMCON")[1] ,/*lPixel*/,/*CodeBlock*/)	//"NUMERO CONTA"
TRCell():New(oSection2, "A2_CGC"  	 , "SA2", STR0051 , "@R 99999999/9999999"       , 20,/*lPixel*/,/*CodeBlock*/) 								//"CNPJ/CPF"
TRCell():New(oSection2, "E2_VENCREA", "SE2", STR0052 , PesqPict("SE2","E2_VENCREA"), TamSX3("E2_VENCREA")[1],/*lPixel*/,/*CodeBlock*/)	//"DT.VENC"
TRCell():New(oSection2, "VALORPAGAR", ""   , STR0053 , TM(0,17), 18,/*lPixel*/,/*CodeBlock*/)															//"VALOR A PAGAR"

//TRCell():New(oSection2, "NUMPEDIDO",  ""   , OemtOAnsi("Pedido(s)")    , "" , 15,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection2, "APROVADOR",  ""   , OemtOAnsi("APROVADOR(es) P.C.") , "" , 45,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection2, "LIB_PAGA" , ""    , OemtOAnsi("Liberador")    , "" , 18,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection2, "DTA_PAGA" , ""    , OemtOAnsi("Data Lib.")    , "" , 12,/*lPixel*/,/*CodeBlock*/)


oSection2:SetTotalInLine (.F.) 	//O totalizador da secao sera impresso em coluna
oSection2:SetHeaderBreak(.T.)   //Imprime o cabecalho das celulas apos a quebra

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrint ºAutor³ Marcio Menon       º Data ³  27/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime o objeto oReport definido na funcao ReportDef.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPO1 - Objeto TReport do relatorio                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1) 
Local oSection2 	:= oReport:Section(1):Section(1)
Local oBreak1
Local oFunction1
Local cChave      := ""
Local cFiltro     := ""
Local cAliasSea	:= "SEA"
Local cJoin 		:= ""
Local lBaixa		:= .F.
Local lCheque     := .F.
Local lAbatimento := .F.
Local cLoja  		:= ""
Local nVlrPagar	:= 0
Local cModelo   	:= CriaVar("EA_MODELO")
Local cNumConta	:= CriaVar("EA_NUMCON")
Local lSeaEof     := .F.

Private nJuros := 0
Private dBaixa := CriaVar("E2_BAIXA")

cChave := SEA->(IndexKey())

#IFDEF TOP

	cAliasSea 		:= GetNextAlias()
	
	cChave 	:= "%"+SqlOrder(cChave)+"%"

	oSection1:BeginQuery()

	BeginSql Alias cAliasSea
		SELECT 	SEA.EA_FILIAL, SEA.EA_FILORIG, SEA.EA_NUMBOR, SEA.EA_CART, SEA.EA_FILORIG, SEA.EA_PREFIXO, SEA.EA_NUM,
					SEA.EA_PARCELA, SEA.EA_TIPO, SEA.EA_FORNECE, SEA.EA_LOJA, SEA.EA_MODELO , SEA.EA_PORTADO, SEA.EA_AGEDEP,
					SEA.EA_NUMCON, SEA.EA_DATABOR
		FROM
			%table:SEA% SEA
		WHERE
			SEA.EA_FILIAL = %xfilial:SEA% AND
			SEA.EA_NUMBOR >= %Exp:mv_par01% AND 
			SEA.EA_NUMBOR <= %Exp:mv_par02% AND 
			SEA.EA_CART = 'P' AND
			SEA.%notDel%
		ORDER BY %Exp:cChave%
	EndSql
	oSection1:EndQuery()
	oSection2:SetParentQuery()
		
#ELSE

	cFiltro := "EA_FILIAL == '" + xFilial("SEA") + "' .And. "
	cFiltro += "EA_NUMBOR >= '" + mv_par01 + "' .And. "
	cFiltro += "EA_NUMBOR <= '" + mv_par02 + "' .And. "
	cFiltro += "EA_CART = 'P'"

	TRPosition():New(oSection2,"SE2",1,{|| If( Empty((cAliasSea)->EA_FILORIG) .AND. !Empty(xFilial("SE2")),;
																xFilial("SE2")+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+AllTrim((cAliasSea)->EA_LOJA),;
																(cAliasSea)->EA_FILORIG+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+AllTrim((cAliasSea)->EA_LOJA)) } )
	oSection1:SetFilter(cFiltro,cChave)

#ENDIF

oSection1:SetLineCondition( { ||	 MV_PAR05 == 1 .Or. SE2->E2_NUMBOR == (cAliasSea)->EA_NUMBOR } )
oSection2:SetLineCondition( { ||	 MV_PAR05 == 1 .Or. SE2->E2_MOEDA == MV_PAR04 } )

TRPosition():New(oSection2,"SE2",1,{|| If( Empty((cAliasSea)->EA_FILORIG) .AND. !Empty(xFilial("SE2")),;
															xFilial("SE2")+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+AllTrim((cAliasSea)->EA_LOJA),;
															(cAliasSea)->EA_FILORIG+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+AllTrim((cAliasSea)->EA_LOJA)) } )

oSection2:OnPrintLine( { || lBaixa := Fr710BxVL(cAliasSea, IIf (Empty((cAliasSea)->EA_LOJA), "", (cAliasSea)->EA_LOJA)), If(!lBaixa, lBaixa := Fr710BxBA(cAliasSea), Nil ),;
									 lCheque := (!Empty(SE5->E5_NUMCHEQ) .And. SEF->(MsSeek(xFilial("SEF")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ))),;
								    Fr710Config(cAliasSea, oSection2), .T. } )

oReport:OnPageBreak( { || ReportCabec(oReport, cModelo := (cAliasSea)->EA_MODELO, cAliasSea, lBaixa, lSeaEof) } )

oSection2:Cell("BENEF"):SetBlock( { || cNumConta := (cAliasSea)->EA_NUMCON, Fr710Benef(cAliasSea, lBaixa, lCheque, lAbatimento) } )

oSection2:Cell("A2_CGC" ):SetBlock( { || Transform(SA2->A2_CGC, IIF(Len(Alltrim(SA2->A2_CGC))>11,"@R 99999999/9999-99","@R 999999999-99")) } )

oSection2:Cell("E2_VENCREA"):SetBlock( { || SE2->E2_VENCREA } )

oSection2:Cell("E2_TIPO"):SetBlock( { || SE2->E2_TIPO } )
oSection2:Cell("E2_FORNECE"):SetBlock( { || SE2->E2_FORNECE } )
oSection2:Cell("E2_LOJA"):SetBlock( { || SE2->E2_LOJA } )


oSection2:Cell("VALORPAGAR"):SetBlock( { || Fr710VPagar(cAliasSea, lBaixa, lCheque, lAbatimento) } )

oBreak1 := TRBreak():New(oSection1, { || (cAliasSea)->EA_NUMBOR }, STR0007)

oFunction1 := TRFunction():New(oSection2:Cell("VALORPAGAR"),,"SUM", oBreak1,,,,.F.,.F.)	

oBreak1:OnPrintTotal( { || ReportTxtAut(oReport, cModelo, cNumConta, oFunction1:GetLastValue()), "" } )

oSection2:SetParentFilter({|cParam| (cAliasSea)->EA_NUMBOR == cParam },{|| (cAliasSea)->EA_NUMBOR } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a impressao.						 								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//oSection2:Cell("NUMPEDIDO"):SetBlock( { || GetDadosCust("NUMPEDIDO",(cAliasSea)->EA_FORNECE,(cAliasSea)->EA_LOJA,(cAliasSea)->EA_NUM,(cAliasSea)->EA_PREFIXO) } )
oSection2:Cell("APROVADOR"):SetBlock( { || GetDadosCust("APROVADOR",(cAliasSea)->EA_FORNECE,(cAliasSea)->EA_LOJA,(cAliasSea)->EA_NUM,(cAliasSea)->EA_PREFIXO) } )
oSection2:Cell("LIB_PAGA"):SetBlock(  { || SE2->E2_USUALIB } )
oSection2:Cell("DTA_PAGA"):SetBlock(  { || SE2->E2_DATALIB } )


oSection1:Print()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fr710BxVL ºAutor  ³ Marcio Menon       º Data ³  28/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se existe movimentação bancaria ou baixas que     º±±
±±º          ³ movimentam banco.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fr710BxVL(cAliasSea, cLoja, lBaixa)
Local sFilial
Local cChave := ""

// Borderos gerados em versao anterior
IF Empty((cAliasSea)->EA_FILORIG) .AND. !Empty(xFilial("SE2"))
	cChave := xFilial("SE2")+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+cLoja
Else //Borderos gerados a partir da versao 7.10
	cChave := (cAliasSea)->EA_FILORIG+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+cLoja
Endif
DbSelectArea("SE2")
dbSetOrder(1)
MsSeek(cChave)

If (xFilial("SE2") <> "  " .and. xFilial("SE5") <> "  ") .or. (xFilial("SE2") == "  " .and. xFilial("SE5") <> "  ")
	sFilial := SE2->E2_FILIAL
Else
	sFilial := xFilial("SE5")
EndIf 

dbSelectArea("SE5")
dbSetOrder(2)
SE5->(MsSeek(sFilial+"VL"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE+SE2->E2_LOJA ))

While SE5->(!Eof()) .and. ;
		SE5->E5_FILIAL		== sFilial	 .and. ;
		SE5->E5_TIPODOC	== "VL"            .and. ;
		SE5->E5_PREFIXO	== SE2->E2_PREFIXO .and. ;
		SE5->E5_NUMERO		== SE2->E2_NUM 	 .and. ;
		SE5->E5_PARCELA	== SE2->E2_PARCELA .and. ;
		SE5->E5_TIPO		== SE2->E2_TIPO	 .and. ;
		SE5->E5_DATA		== SE2->E2_BAIXA	 .and. ;
		SE5->E5_CLIFOR		== SE2->E2_FORNECE .and. ;
		SE5->E5_LOJA		== cLoja

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ S¢ considera baixas que nao possuem estorno   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
		If SubStr( SE5->E5_DOCUMEN,1,6 ) == (cAliasSea)->EA_NUMBOR .And. SE5->E5_MOTBX != "PCC"
			lBaixa := .T.
			Exit
		Endif
	EndIf
	SE5->(dbSkip())
Enddo

Return lBaixa

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fr710BxBA ºAutor  ³ Marcio Menon       º Data ³  28/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se existe baixa automatica ou baixa que nao tenha º±±
±±º          ³ movimentacao bancaria.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr710BxBA(cAliasSea, lBaixa)
Local sFilial
Local cChave := ""

// Borderos gerados em versao anterior
IF Empty((cAliasSea)->EA_FILORIG) .AND. !Empty(xFilial("SE2"))
	cChave := xFilial("SE2")+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+(cAliasSea)->EA_LOJA
Else //Borderos gerados a partir da versao 7.10
	cChave := (cAliasSea)->EA_FILORIG+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+(cAliasSea)->EA_LOJA
Endif   

DbSelectArea("SE2")
dbSetOrder(1)
MsSeek(cChave)

If (xFilial("SE2") <> "  " .and. xFilial("SE5") <> "  ") .or. (xFilial("SE2") == "  " .and. xFilial("SE5") <> "  ")
	sFilial := SE2->E2_FILIAL
Else
	sFilial := xFilial("SE5")
EndIf 

dbSelectArea("SE5")
dbSetOrder(2)

If (SE5->(MsSeek( sFilial +"BA"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE+SE2->E2_LOJA)))
	While SE5->(!Eof()) .and. ;
			SE5->E5_FILIAL		== sFilial	 .and. ;
			SE5->E5_TIPODOC	== "BA"            .and. ;
			SE5->E5_PREFIXO	== SE2->E2_PREFIXO .and. ;
			SE5->E5_NUMERO		== SE2->E2_NUM 	 .and. ;
			SE5->E5_PARCELA	== SE2->E2_PARCELA .and. ;
			SE5->E5_TIPO		== SE2->E2_TIPO	 .and. ;
			SE5->E5_DATA		== SE2->E2_BAIXA	 .and. ;
			SE5->E5_CLIFOR		== SE2->E2_FORNECE .and. ;
			SE5->E5_LOJA		== SE2->E2_LOJA

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ S¢ considera baixas que nao possuem estorno   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
			If SubStr( SE5->E5_DOCUMEN,1,6 ) == (cAliasSea)->EA_NUMBOR .And. SE5->E5_MOTBX != "PCC"
				lBaixa := .T.
				Exit
			Endif
		EndIf
		SE5->(dbSkip())
	Enddo
Endif

Return lBaixa

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fr710BenefºAutor  ³  Marcio Menon      º Data ³  28/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o campo Beneficiario conforme o modelo do          º±±
±±º          ³ bordero.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fr710Benef(cAliasSea, lBaixa, lCheque, lAbatimento)

Local cBenef 		:= ""
Local cChave      := ""

// Localiza o fornecedor do titulo que esta no bordero
// Borderos gerados em versao anterior
IF Empty((cAliasSea)->EA_FILORIG) .AND. !Empty(xFilial("SA2"))
	cChave := xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA
Else //Borderos gerados a partir da versao 7.10
	If !Empty((cAliasSea)->EA_FILORIG) .AND. !Empty(xFilial("SA2"))	
		cChave := (cAliasSea)->EA_FILORIG+SE2->E2_FORNECE+SE2->E2_LOJA
	Else	
		cChave := xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA
	Endif
Endif

SA2->(MsSeek(cChave))

If (cAliasSea)->EA_MODELO $ "CH/02"
	If !lAbatimento
		If lCheque
			cBenef := SEF->EF_BENEF
		ElseIf lBaixa
			cBenef := SE5->E5_BENEF
		Else
			cBenef := SA2->A2_NOME
		Endif
	EndIf
Else
	cBenef := SA2->A2_NOME
Endif

Return cBenef

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fr710VPagar ºAutor  ³ Marcio Menon       º Data ³  28/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz os calculos dos valores a pagar dos titulos.		       º±±
±±º          ³ 						                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fr710VPagar(cAliasSea, lBaixa, lCheque, lAbatimento)

Local nAbat  		:= 0
Local nVlrPagar	:= 0

If lAbatimento
	nAbat 	:= SE2->E2_SALDO
Else
	nAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua calculo dos juros do titulo posicionado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fa080Juros(1)	
If lBaixa
	If ! lAbatimento
		nVlrPagar := Round(NoRound(xMoeda(SE5->E5_VALOR,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,(cAliasSea)->EA_DATABOR,dDataBase),MsDecimais(1)+1),MsDecimais(1)+1),MsDecimais(1))
		nAbat := 0
	EndIf
Else
	If ! lAbatimento
		nVlrPagar := Round(NoRound(xMoeda(SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,(cAliasSea)->EA_DATABOR,dDataBase),MsDecimais(1)+1),MsDecimais(1)+1),MsDecimais(1))
	Endif
Endif

Return nVlrPagar

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportCabec ºAutor  ³ Marcio Menon       º Data ³  28/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta o cabecalho do relatorio.								       º±±
±±º          ³ 						                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportCabec(oReport, cModelo, cAliasSea, lBaixa, lSeaEof)

Local cStartPath	:= GetSrvProfString("Startpath","")
Local cLogo			:= ""
Local cTexto 		:= ""
Local lHlpNoTab 	:= .F.

//Se a quebra de secao for na impressao do texto da autorizacao
//Volta o registro para imprimir o cabecalho
If (cAliasSea)->(EOF())
    lSeaEof := .T.
	(cAliasSea)->(dbSkip(-1))	
	cModelo := (cAliasSea)->EA_MODELO
EndIf

If lBaixa
	SA6->(MsSeek(xFilial("SA6")+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA)))
Else
	SA6->(MsSeek(xFilial("SA6")+(cAliasSea)->(EA_PORTADO+EA_AGEDEP+EA_NUMCON)))
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o modelo do documento.					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lHlpNoTab := IIf(Empty(cModelo),.F.,.T.)
If cModelo $ "CH/02"
	cTexto := Tabela("58",@cModelo,lHlpNoTab)
Elseif cModelo $ "CT/30"
	cTexto := Tabela("58",@cModelo,lHlpNoTab)
Elseif cModelo $ "CP/31"
	cTexto := Tabela("58",@cModelo,lHlpNoTab)
ElseIf cModelo $ "CC/01/03/04/05/10/41/43"
	cTexto := Tabela("58",@cModelo,lHlpNoTab) 
Else
	cTexto := Tabela("58",@cModelo,lHlpNoTab)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho.									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:ThinLine()

cLogo := cStartPath + "LGRL" + SM0->M0_CODIGO + IIf( lFWCodFil, SM0->M0_CODFIL,'' ) + ".BMP" 	// Empresa+Filial

If !File( cLogo )
	cLogo := cStartPath + "LGRL" + SM0->M0_CODIGO + ".BMP" 						// Empresa
endif

oReport:SkipLine()
oReport:SayBitmap (oReport:Row(),005,cLogo,291,057)
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:ThinLine()
oReport:SkipLine()
oReport:SkipLine()
//Texto do tipo de bordero
oReport:PrintText(SM0->M0_NOME + PadC(OemToAnsi(STR0034),100) + OemToAnsi(STR0035)+DtoC(dDataBase)+" - "+TIME())
oReport:PrintText(Space(Len(SM0->M0_NOME)) + PadC(cTexto,100) + OemToAnsi(STR0036) + (cAliasSea)->EA_NUMBOR)
oReport:SkipLine()
oReport:SkipLine()
//Dados do Banco
oReport:PrintText(Pad(OemToAnsi(STR0037) + SA6->A6_NOME,100))
oReport:PrintText(Pad(OemToAnsi(STR0038) + SA6->A6_AGENCIA + STR0040 + SA6->A6_NUMCON,100))
oReport:PrintText(Pad(SA6->A6_END + " "  + SA6->A6_MUN + " " + SA6->A6_EST,100))
oReport:SkipLine()
oReport:SkipLine()
oReport:ThinLine()

If lSeaEof
	(cAliasSea)->(dbSkip())
EndIf

Return ""

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fr710Config ºAutor  ³ Marcio Menon       º Data ³  01/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibe ou oculta as colunas do relatorio, conforme o modelo   º±±
±±º          ³ do bordero.			                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fr710Config(cAliasSea, oSection2)

Do Case

Case	(cAliasSea)->EA_MODELO $ "CH/02"
   
	oSection2:Cell("EF_NUM"    ):Enable()	
	oSection2:Cell("EF_NUM"    ):SetBlock({ || "CH. " + SEF->EF_NUM})
	oSection2:Cell("A2_BANCO"  ):Disable()	
	oSection2:Cell("A2_AGENCIA"):Disable()	
	oSection2:Cell("A2_NUMCON" ):Disable()	
	oSection2:Cell("A2_CGC"    ):Disable()	

Case	(cAliasSea)->EA_MODELO $ "CT/30"

	oSection2:Cell("A6_NREDUZ" ):Disable()	
	oSection2:Cell("A2_BANCO"  ):Disable()	
	oSection2:Cell("A2_AGENCIA"):Disable()	
	oSection2:Cell("A2_NUMCON" ):Disable()	
	oSection2:Cell("A2_CGC"    ):Disable()	
   //Verifica se existe numero de cheque
	If (SEF->(MsSeek(xFilial("SEF") + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA + SE5->E5_NUMCHEQ)))
		oSection2:Cell("EF_NUM"    ):SetTitle("NUM. CHEQUE")
		oSection2:Cell("EF_NUM"    ):SetBlock({ || SEF->EF_NUM})
		oSection2:Cell("EF_NUM"    ):Enable()	
	Else
		oSection2:Cell("EF_NUM"    ):SetTitle("")
	EndIf
		
Case	(cAliasSea)->EA_MODELO $ "CT/31"

	oSection2:Cell("A6_NREDUZ" ):Enable()	
	oSection2:Cell("A2_BANCO"  ):Disable()	
	oSection2:Cell("A2_AGENCIA"):Disable()	
	oSection2:Cell("A2_NUMCON" ):Disable()	
	oSection2:Cell("A2_CGC"    ):Disable()	
   //Verifica se existe numero de cheque
	If (SEF->(MsSeek(xFilial("SEF") + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA + SE5->E5_NUMCHEQ)))
		oSection2:Cell("EF_NUM"    ):SetTitle("NUM. CHEQUE")
		oSection2:Cell("EF_NUM"    ):SetBlock({ || SEF->EF_NUM})
		oSection2:Cell("EF_NUM"    ):Enable()	
	Else
		oSection2:Cell("EF_NUM"    ):SetTitle("NUM. CHEQUE")
	EndIf

Case	(cAliasSea)->EA_MODELO $ "CC/01/03/04/05/10/41/43"

	oSection2:Cell("A6_NREDUZ" ):Enable()	
	oSection2:Cell("A2_BANCO"  ):Enable()	
	oSection2:Cell("A2_AGENCIA"):Enable()	
	oSection2:Cell("A2_NUMCON" ):Enable()	
	oSection2:Cell("A2_CGC"    ):Enable()	
	oSection2:Cell("EF_NUM"    ):Disable()	

EndCase

Return
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportTxtAutºAutor  ³ Marcio Menon       º Data ³  01/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o Total Geral por extenso e as mensagens de	       º±±
±±º          ³ autorizacao, conforme o modelo do bordero.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportTxtAut(oReport, cModelo, cNumConta, nVlrSecao)

Local nCount

oReport:SkipLine()
oReport:PrintText(Extenso(nVlrSecao,.F.,MV_PAR04))
oReport:SkipLine()

If cModelo $ "CH/02"
	//"AUTORIZAMOS V.SAS. A EMITIR OS CHEQUES NOMINATIVOS AOS BENEFICIARIOS EM REFERENCIA,"
	oReport:PrintText(STR0008)
	//"DEBITANDO EM NOSSA CONTA CORRENTE NO DIA "
	oReport:PrintText(STR0009 + DtoC( mv_par03 ))
	//"PELO VALOR ACIMA TOTALIZADO."
	oReport:PrintText(STR0010)
Elseif cModelo $ "CT/30"
	//"AUTORIZAMOS V.SAS. A PAGAR OS TITULOS ACIMA RELACIONADOS EM NOSSA"
	oReport:PrintText(STR0011)
	//"CONTA MOVIMENTO NO DIA "###", PELO VALOR ACIMA TOTALIZADO."
	oReport:PrintText(STR0012 + DtoC( mv_par03 ) + OemToAnsi(STR0013))	
Elseif cModelo $ "CP/31"
	//"AUTORIZAMOS V.SAS. A PAGAR OS TITULOS EM REFERENCIA, LEVANDO A DEBITO DE NOSSA"
	oReport:PrintText(STR0014)
	//"CONTA CORRENTE NUM. "###" NO DIA "###" PELO VALOR ACIMA TOTALIZADO."
	oReport:PrintText(STR0015 + cNumConta + OemToAnsi(STR0016) + DtoC( mv_par03 ) + OemToAnsi(STR0017))	
Elseif cModelo $ "CC/01/03/04/05/10/41/43"
	//"AUTORIZAMOS V.SAS. A EMITIREM ORDEM DE PAGAMENTO, OU DOC PARA OS BANCOS/CONTAS ACIMA."
	oReport:PrintText(STR0018)
	//"DOS TITULOS RESPECTIVOS DEBITANDO EM NOSSA C/CORRENTE NUM "
	oReport:PrintText(STR0019 + cNumConta)  
	//"NO DIA "### " PELO VALOR ACIMA TOTALIZADO."
	oReport:PrintText(STR0020 + dToC( mv_par03 ) + OemToAnsi(STR0021))   	
Else
	//"AUTORIZAMOS V.SAS. A PAGAR OS TITULOS EM REFERENCIA, LEVANDO A DEBITO DE NOSSA"
	oReport:PrintText(STR0022)  
	//"CONTA CORRENTE NUM. "###" NO DIA "###" PELO VALOR ACIMA TOTALIZADO."
	oReport:PrintText(STR0023 + cNumConta + OemToAnsi(STR0016) + DtoC( mv_par03 ) + OemToAnsi(STR0017))   	
EndIf

For nCount := 1 to 5
	oReport:SkipLine()
Next

//oReport:PrintText("-----------------------------------"+Space(30)+"-----------------------------------",/*nRow*/,900)
//oReport:PrintText(SM0->M0_NOMECOM+Space(25)+SM0->M0_NOMECOM,/*nRow*/,900)
oReport:PrintText("______________________________  _____/____/_____"+Space(30)+"______________________________  _____/____/_____"+Space(30)+"______________________________  _____/____/_____",/*nRow*/,150)
//oReport:PrintText("          TESOURARIA                            "+Space(30)+"       CONTROLLER BRASIL                        "+Space(30)+"       CONTROLLER LATAM                         ",/*nRow*/,150)
oReport:PrintText("      GERENTE CAF                               "+Space(30)+"      AUX. ADM CAF                              "+Space(30)+"      DIRETORIA                                 ",/*nRow*/,150)



Return ""


Static Function GetDadosCust(cParam,cFornece,cLoja,cNumero,cPrefixo)
********************************************************************************************
*
***
Local uRet 
Local aAreaOld  := GetArea()
Local cAliasTmp := GetNextAlias()

Do Case
   Case cParam == "NUMPEDIDO"
	    BeginSql Alias cAliasTmp
           SELECT D1_PEDIDO FROM %table:SF1% SF1 , %table:SD1% SD1
           WHERE SF1.F1_FILIAL  = %xfilial:SF1%
           AND   SD1.D1_FILIAL  = %xfilial:SD1%
           AND   SF1.%notDel%
           AND   SD1.%notDel%
           AND   F1_FORNECE = %Exp:cFornece%
           AND   F1_LOJA    = %Exp:cLoja%
           AND   F1_DOC     = %Exp:cNumero%
           AND   F1_PREFIXO = %Exp:cPrefixo%
           AND   F1_DOC   = D1_DOC
           AND   F1_SERIE = D1_SERIE
           AND   F1_FORNECE = D1_FORNECE
           AND   F1_LOJA    = D1_LOJA
           ORDER BY D1_PEDIDO 
        EndSql
        uRet := ""
        dbSelectArea(cAliasTmp)
        (cAliasTmp)->(dbGotop())
        While !(cAliasTmp)->(Eof())
            uRet += Alltrim((cAliasTmp)->D1_PEDIDO)+','
            (cAliasTmp)->(dbSkip())
        End
        uRet := Left(uRet,Len(uRet)-1)
        dbSelectArea(cAliasTmp)
        (cAliasTmp)->(dbCloseArea())
   Case cParam == "APROVADOR"
	    BeginSql Alias cAliasTmp
           SELECT CR_USERLIB
           FROM %table:SF1% SF1 , %table:SD1% SD1 , %table:SCR% SCR
           WHERE SF1.F1_FILIAL  = %xfilial:SF1%
           AND   SD1.D1_FILIAL  = %xfilial:SD1%
           AND   SCR.CR_FILIAL  = %xfilial:SCR%
           AND   SF1.%notDel%
           AND   SD1.%notDel%
           AND   SCR.%notDel%
           AND   F1_FORNECE = %Exp:cFornece%
           AND   F1_LOJA    = %Exp:cLoja%
           AND   F1_DOC     = %Exp:cNumero%
           AND   F1_PREFIXO = %Exp:cPrefixo%
           AND   F1_DOC   = D1_DOC
           AND   F1_SERIE = D1_SERIE
           AND   F1_FORNECE = D1_FORNECE
           AND   F1_LOJA    = D1_LOJA
           AND   D1_PEDIDO  = CR_NUM  
           AND   CR_LIBAPRO != %Exp:''%
           GROUP BY CR_NIVEL,CR_USERLIB
        EndSql
        uRet := ""
        dbSelectArea(cAliasTmp)
        (cAliasTmp)->(dbGotop())
        While !(cAliasTmp)->(Eof())
            uRet += Alltrim(RetName((cAliasTmp)->CR_USERLIB))+','
            (cAliasTmp)->(dbSkip())
        End
        dbSelectArea(cAliasTmp)
        (cAliasTmp)->(dbCloseArea())

        uRet := Left(uRet,Len(uRet)-1)
EndCase            
RestArea(aAreaOld)

Return(uRet)



Static function RetName(cCodUser)
**************************************************************************
*
**
Local cName    := ""
Local aUsuario := {}
Local cUserOld := __CUSERID

PswOrder(1)
PswSeek(cCodUser,.T.)
aUsuario:= PswRet()
cName   := Upper(Alltrim(aUsuario[1,4]))

PswSeek(cUserOld,.T.)
Return(cName)