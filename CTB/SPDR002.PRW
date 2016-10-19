#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

User Function SPDR002()

Private oReport
Private cTRAB := GetNextAlias()

//Define as Perguntas
Private cPerg     := "SPR002"
PutSx1(cPerg,"01",OemToAnsi("Informe Plano Ref."),OemToAnsi("Informe Plano Ref."),OemToAnsi("Informe Plano Ref."),"mv_ch1","C",03,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{ OemToAnsi("Informe o Plano Referencial"),OemToAnsi("a ser utilizado")}, {}, {} )
Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()

Return


Static Function ReportDef()

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
oReport := TReport():New("SPDR002","Inconsistência de Referencias SPED",cPerg, {|oReport| ReportPrint(oReport,cTRAB)},"Inconsistência de Referencias SPED")
//oReport:SetPortrait() 
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oCabec := TRSection():New(oReport,"",{"CT1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oCabec:SetLineStyle(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 1 - Cabecalho do Pedido                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oConta := TRCell():New(oCabec,"CONTA"		,/*Tabela*/	,"Conta Contabil"	,"@!"	,TamSx3("CT1_CONTA")[1],.F.,{|| (cTRAB)->CT1_CONTA})
oDescr := TRCell():New(oCabec,"DESCRICAO"	,/*Tabela*/	,"Descrição"		,		,TamSx3("CT1_DESC01")[1],.F.,{||(cTRAB)->CT1_DESC01})
oCtaRef:= TRCell():New(oCabec,"REFERENCIA"	,/*Tabela*/	,"Conta Referência"	,"@!"	,TamSx3("CVN_CTAREF")[1],.F.,{||(cTRAB)->CVN_CTAREF})
oDscRef:= TRCell():New(oCabec,"DESCREF"		,/*Tabela*/	,"Descrição"		,		,TamSx3("CVN_DSCCTA")[1],.F.,{||(cTRAB)->CVN_DSCCTA})
oDtaVig:= TRCell():New(oCabec,"VIGENCIA"	,/*Tabela*/	,"Data Vigência"	,"@!"	,TamSx3("CVN_DTVIGF")[1],.F.,{||(cTRAB)->CVN_DTVIGF})
oNtaCta:= TRCell():New(oCabec,"NATUREZA"	,/*Tabela*/	,"Natureza"			,"@!"	,TamSx3("CT1_NTSPED")[1],.F.,{||(cTRAB)->CT1_NTSPED})

Return(oReport)


Static Function ReportPrint(oReport,cAliasSC9,cAliasSC5,cAliasSF2,cALiasSB1,cAliasSA1,cAliasSC6)
*************************************************************************************************
*
***
Local lFirst := .T.
Local cQuery := ""

cQuery += " SELECT CT1_CONTA, CT1_DESC01, ISNULL(CVN_CTAREF,'NÃO INFORMADO') AS CVN_CTAREF, ISNULL(CVN_DSCCTA,'') AS CVN_DSCCTA,"
cQuery += " CONVERT(VARCHAR,CAST(ISNULL(CVN_DTVIGF,'') AS SMALLDATETIME),3)AS CVN_DTVIGF, "
cQuery += " CT1_NTSPED+(CASE CT1_NTSPED 
cQuery += "               WHEN '01' THEN '-CONTA DE ATIVO' "
cQuery += "               WHEN '02' THEN '-CONTA DE PASSIVO' "
cQuery += "               WHEN '03' THEN '-PATRIMONIO LIQUIDO' "
cQuery += "               WHEN '04' THEN '-CONTA DE RESULTADO' "
cQuery += "               WHEN '05' THEN '-CONTA DE COMPENSACAO' "
cQuery += "               WHEN '09' THEN '-OUTRAS'"
cQuery += "               ELSE 'INVÁLIDO OU NÃO INFORMADO' END) AS CT1_NTSPED"
cQuery += " FROM "+RetSqlName("CT1")+" A LEFT JOIN "+RetSqlName("CVD")+" B ON B.D_E_L_E_T_='' AND CVD_CONTA=CT1_CONTA AND CVD_FILIAL=CT1_FILIAL AND CVD_CODPLA='"+MV_PAR01+"'"

cQuery += " LEFT JOIN "+RetSqlName("CVN")+" C ON C.D_E_L_E_T_='' AND CVD_CTAREF=CVN_CTAREF"
cQuery += " WHERE A.D_E_L_E_T_=''"
cQuery += " AND CT1_FILIAL='"+xFilial("CT1")+"'"
cQuery += " AND CT1_CLASSE='2'"
cQuery += " AND (CVN_CTAREF IS NULL OR ISNULL(CVN_DTVIGF,'')='20081231') AND CT1_NATCTA < '05'" 
cQuery += " ORDER BY CT1_CONTA"


dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTRAB,.F.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(oReport:Title())
oReport:SetMeter((cTRAB)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cTRAB)->(Eof())

	If oReport:Row() > 2500 .or. lfirst
		oReport:EndPage(.T.)
		oReport:SkipLine(1)
	EndIf	
	lFirst := .F.

    oReport:Section(1):PrintLine()

	dbSelectArea(cTRAB)
	dbSkip()

	oReport:IncMeter()

EndDo
oReport:Section(1):Finish()

Return