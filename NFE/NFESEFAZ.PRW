#DEFINE MAXMENLIN 125
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
 

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥XmlNFeSef ≥ Autor ≥ Eduardo Riera         ≥ Data ≥13.02.2007≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Rdmake de exemplo para geracao da Nota Fiscal Eletronica do ≥±±
±±≥          ≥SEFAZ - Versao T01.00                                       ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥String da Nota Fiscal Eletronica                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ExpC1: Tipo da NF                                           ≥±±
±±≥          ≥       [0] Entrada                                          ≥±±
±±≥          ≥       [1] Saida                                            ≥±±
±±≥          ≥ExpC2: Serie da NF                                          ≥±±
±±≥          ≥ExpC3: Numero da nota fiscal                                ≥±±
±±≥          ≥ExpC4: Codigo do cliente ou fornecedor                      ≥±±
±±≥          ≥ExpC5: Loja do cliente ou fornecedor                        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥   DATA   ≥ Programador   ≥Manutencao efetuada                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥          ≥               ≥                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function XmlNfeSef(cTipo,cSerie,cNota,cClieFor,cLoja)

Local nX         := 0
Local nY		 := 0

Local oWSNfe   

Local cString    := ""
Local cAliasSE1  := "SE1"
Local cAliasSE2  := "SE2"
Local cAliasSD1  := "SD1"
Local cAliasSD2  := "SD2"
Local cNatOper   := ""
Local cModFrete  := ""
Local cScan      := ""
Local cEspecie   := ""
Local cMensCli   := ""
Local cMensFis   := ""
Local cNFe       := ""
Local cMV_LJTPNFE:= SuperGetMV("MV_LJTPNFE", ," ")
Local cMVSUBTRIB := ""
Local cLJTPNFE	 := ""
Local cWhere	 := ""
Local cMunISS	 := ""
Local cCodIss	 := ""
Local cValIPI    := ""
Local cNCM	     := ""

Local nPosI		 :=	0
Local nPosF	     :=	0
Local nBaseIrrf  := 0
Local nValIrrf   := 0
Local nValIPI    := 0
Local nValAux    := 0
Local nValPisZF  := 0
Local nValCofZF	 := 0

Local lQuery     := .F.
Local lCalSol	 := .F.
Local lEasy		 := SuperGetMV("MV_EASY") == "S" 
Local lEECFAT	 := SuperGetMv("MV_EECFAT")
Local lNatOper   := GetNewPar("MV_SPEDNAT",.F.)
Local lInfAdZF   := GetNewPar("MV_INFADZF",.F.)
Local lOk		 := .T.   

Local aNota     := {}
Local aDupl     := {}
Local aDest     := {}
Local aEntrega  := {}
Local aProd     := {}
Local aICMS     := {}
Local aICMSST   := {}
Local aIPI      := {}
Local aPIS      := {}
Local aCOFINS   := {}
Local aPISST    := {}
Local aCOFINSST := {}
Local aISSQN    := {}
Local aISS      := {}
Local aCST      := {}
Local aRetido   := {}
Local aTransp   := {}
Local aImp      := {}
Local aVeiculo  := {}
Local aReboque  := {}
Local aEspVol   := {}
Local aNfVinc   := {}
Local aPedido   := {}
Local aTotal    := {0,0}
Local aOldReg   := {}
Local aOldReg2  := {}
Local aMed		:= {}
Local aArma		:= {}
Local aveicProd	:= {}
Local aIEST		:= {}
Local lAddMsg   := .T.
Local aDI		:= {}
Local aAdi		:= {}
Local aExp		:= {}
Local aPisAlqZ	:= {}
Local aCofAlqZ	:= {}
Local aIPIDev	:= {}
Local aIPIAux	:= {}
Local aNotaServ := {}
Local nPisRet   := 0
Local nCofRet   := 0
Local nInssRet  := 0
Local nIrRet    := 0
Local nCsllRet  := 0
Local nDedu     := 0
Local nIssRet   := 0
Local nTotRet   := 0
Local cDescServ := SuperGetMV("MV_NFESERV", ,"2")
Local cConjug   := AllTrim(SuperGetMv("MV_NFECONJ",,""))
Local cServ     := ""
Local aAreaSF3  := {}
Local cMunPres  := ""
Local aRetServ  := {}
Local cRetISS   := ""
Local cTipoNF   := ""
Local cDocEnt   := ""
Local cSerEnt   := ""
Local cFornece  := ""
Local cLojaEnt  := ""
Local cTipoNFEnt:= ""
Local cPedido   := ""
Local cItemPC   := ""
Local cNFOri    := ""
Local cSerOri   := ""
Local cItemOri  := ""
Local cProd     := ""
Local cTribMun  := ""
Local cModXML   := ""
Local lIpiDev   := GetNewPar("MV_IPIDEV",.T.)
Private aUF     := {}

DEFAULT cTipo   := PARAMIXB[1,1]
DEFAULT cSerie  := PARAMIXB[1,3]
DEFAULT cNota   := PARAMIXB[1,4]
DEFAULT cClieFor:= PARAMIXB[1,5]
DEFAULT cLoja   := PARAMIXB[1,6]
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Preenchimento do Array de UF                                            ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"EX","99"})

DbSelectArea ("SX6")
SX6->(DbSetOrder (1))
If (SX6->(DbSeek (xFilial ("SX6")+"MV_SUBTRI")))
	Do While !SX6->(Eof ()) .And. xFilial ("SX6")==SX6->X6_FIL .And. "MV_SUBTRI"$SX6->X6_VAR
		If !Empty(SX6->X6_CONTEUD)
			cMVSUBTRIB += "/"+AllTrim (SX6->X6_CONTEUD)
		EndIf
		SX6->(DbSkip ())
	EndDo
EndIf

If cTipo == "1"
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Posiciona NF                                                            ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	dbSelectArea("SF2")
	dbSetOrder(1)
	If MsSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja)	
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥Tratamento temporario do CTe                                            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ			
		If FunName() == "SPEDCTE" .Or. AModNot(SF2->F2_ESPECIE)=="57"
			cNFe := "CTe35080944990901000143570000000000200000168648"
			cString := '<infNFe versao="T02.00" modelo="57" >'
			cString += '<CTe xmlns="http://www.portalfiscal.inf.br/cte"><infCte Id="CTe35080944990901000143570000000000200000168648" versao="1.02"><ide><cUF>35</cUF><cCT>000016864</cCT><CFOP>6353</CFOP><natOp>ENTREGA NORMAL</natOp><forPag>1</forPag><mod>57</mod><serie>0</serie><nCT>20</nCT><dhEmi>2008-09-12T10:49:00</dhEmi><tpImp>2</tpImp><tpEmis>2</tpEmis><cDV>8</cDV><tpAmb>2</tpAmb><tpCTe>0</tpCTe><procEmi>0</procEmi><verProc>1.12a</verProc><cMunEmi>3550308</cMunEmi><xMunEmi>Sao Paulo</xMunEmi><UFEmi>SP</UFEmi><modal>01</modal><tpServ>0</tpServ><cMunIni>3550308</cMunIni><xMunIni>Sao Paulo</xMunIni><UFIni>SP</UFIni><cMunFim>3550308</cMunFim><xMunFim>Sao Paulo</xMunFim><UFFim>SP</UFFim><retira>1</retira><xDetRetira>TESTE</xDetRetira><toma03><toma>0</toma></toma03></ide><emit><CNPJ>44990901000143</CNPJ><IE>00000000000</IE><xNome>FILIAL SAO PAULO</xNome><xFant>Teste</xFant><enderEmit><xLgr>Av. Teste, S/N</xLgr><nro>0</nro><xBairro>Teste</xBairro><cMun>3550308</cMun><xMun>Sao Paulo</xMun><CEP>00000000</CEP><UF>SP</UF></enderEmit></emit><rem><CNPJ>58506155000184</CNPJ><IE>115237740114</IE><xNome>CLIENTE SP</xNome><xFant>CLIENTE SP</xFant><enderReme><xLgr>R</xLgr><nro>0</nro><xBairro>BAIRRO NAO CADASTRADO</xBairro><cMun>3550308</cMun><xMun>SAO PAULO</xMun><CEP>77777777</CEP><UF>SP</UF></enderReme><infOutros><tpDoc>00</tpDoc><dEmi>2008-09-17</dEmi></infOutros></rem><dest><CNPJ></CNPJ><IE></IE><xNome>CLIENTE RJ</xNome><enderDest><xLgr>R</xLgr><nro>0</nro><xBairro>BAIRRO NAO CADASTRADO</xBairro><cMun>3550308</cMun><xMun>RIO DE JANEIRO</xMun><CEP>44444444</CEP><UF>RJ</UF></enderDest></dest><vPrest><vTPrest>1.93</vTPrest><vRec>1.93</vRec></vPrest><imp><ICMS><CST00><CST>00</CST><vBC>250.00</vBC><pICMS>18.00</pICMS><vICMS>450.00</vICMS></CST00></ICMS></imp><infCteComp><chave>35080944990901000143570000000000200000168648</chave><vPresComp><vTPrest>10.00</vTPrest></vPresComp><impComp><ICMSComp><CST00Comp><CST>00</CST><vBC>10.00</vBC><pICMS>10.00</pICMS><vICMS>10.00</vICMS></CST00Comp></ICMSComp></impComp></infCteComp></infCte></CTe>'
			cString += '</infNFe>'
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥Tratamento Nota de Servico ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		ElseIf FunName() == "SPEDNFSE"
	  	  	
	  	  	//Modelo do XML ISSNET ou BH
	  	  	cModXML:= mv_par04

	  	  	aadd(aNotaServ,SF2->F2_SERIE)
		  	aadd(aNotaServ,SF2->F2_DOC)
			aadd(aNotaServ,SF2->F2_EMISSAO)

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Posiciona cliente  ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ	
		    dbSelectArea("SA1")
			dbSetOrder(1)
			MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
			aadd(aDest,AllTrim(SA1->A1_CGC))
			aadd(aDest,SA1->A1_NOME)
			aadd(aDest,FisGetEnd(SA1->A1_END)[1])
			aadd(aDest,ConvType(IIF(FisGetEnd(SA1->A1_END)[2]<>0,FisGetEnd(SA1->A1_END)[2],"SN")))
			aadd(aDest,FisGetEnd(SA1->A1_END)[4])
			aadd(aDest,SA1->A1_BAIRRO)
			If !Upper(SA1->A1_EST) == "EX"
				aadd(aDest,SA1->A1_COD_MUN)
			Else
				aadd(aDest,"99999")			
			EndIf
			aadd(aDest,Upper(SA1->A1_EST))
			aadd(aDest,SA1->A1_CEP)
			aadd(aDest,SA1->A1_DDD+SA1->A1_TEL)
			aadd(aDest,SA1->A1_INSCRM)
			aadd(aDest,SA1->A1_EMAIL)
			

			dbSelectArea("SF3")
			dbSetOrder(4)
			MsSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)			
				
			While !Eof() .And. xFilial("SF3") == SF3->F3_FILIAL .And.;
				SF2->F2_SERIE == SF3->F3_SERIE .And.;
				SF2->F2_DOC == SF3->F3_NFISCAL .And. !Empty(SF3->F3_CODISS) .And. SF3->F3_TIPO=="S"

	             //Natureza da OperaÁ„o
				If SF3->(FieldPos("F3_ISSST"))>0
					cNatOper:= SF3->F3_ISSST
				EndIf
				 
				 //Tipo de RPS - O sistema de BH ainda n„o est· recebendo Notas Conjugadas
				 //If SF2->F2_ESPECIE $ cConjug
				 	//cTipoRps:="2" //RPS - Conjugada (Mista)
				 If !Empty(SF2->F2_PDV)
				 	cTipoRps:="3" //Cupom
				 Else
				 	cTipoRps:="1" //RPS
				 EndIf
				 
				   
						
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Pega os impostos de retencao somente quando houver a retenÁ„o, ≥
				//≥ou seja, os titulos de retenÁ„o que existirem                  ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	            dbSelectArea("SE1")
				SE1->(dbSetOrder(2))                   
				If SE1->(dbSeek(xFilial("SE1")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_SERIE+SF3->F3_NFISCAL))
					nTotRet:=SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"V",SE1->E1_BAIXA,,@nIrRet,@nCsllRet,@nPisRet,@nCofRet,@nInssRet)
	            EndIf    
	            
	            aadd(aRetServ,{nIrRet,nCsllRet,nPisRet,nCofRet,nInssRet,nTotRet})
	            
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Pega as deduÁıes ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ			
				  If SF3->(FieldPos("F3_ISSSUB"))>0
				  	nDedu+= SF3->F3_ISSSUB
				  EndIf

				  If SF3->(FieldPos("F3_ISSMAT"))>0
				  	nDedu+= SF3->F3_ISSMAT
				  EndIf
	           
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Obtem os dados do ServiÁo ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				If SX5->(dbSeek(xFilial("SX5")+"60"+SF3->F3_CODISS))
				    //Verifico se a DescriÁ„o È composta do pedido de Venda ou SX5
					If cDescServ$"1"
						SC6->(dbSetOrder(4))
						SC5->(dbSetOrder(1))
						MsSeek(xFilial("SC6")+SF3->F3_NFISCAL+SF3->F3_SERIE)
						MsSeek(xFilial("SC5")+SC6->C6_NUM)
						
					    cServ := SC5->C5_MENNOTA
					    If Empty(cServ)
					    	cServ := SX5->X5_DESCRI
					    EndIf
				    Else
				    	cServ := SX5->X5_DESCRI
				    EndIf	
				EndIf
                     
		        
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Verifica se recolhe ISS Retido ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				If SF3->(FieldPos("F3_RECISS"))>0
				  If SF3->F3_RECISS $"1S"
					cRetIss :="1"
			    	nIssRet := SF3->F3_VALICM
			      Else
					cRetIss :="2"
			    	nIssRet := 0
				  Endif
				ElseIf SA1->A1_RECISS $"1S"
					cRetIss :="1"
			    	nIssRet := SF3->F3_VALICM
			    Else
					cRetIss :="2"
			    	nIssRet := 0
				EndIf
				
								
			 	cMunPres:= aDest[07]
				cMunPres:= ConvType(aUF[aScan(aUF,{|x| x[1] == aDest[08]})][02]+cMunPres)

				dbSelectArea("SD2")
				dbSetOrder(3)
				MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)


				dbSelectArea("SB1")
				dbSetOrder(1)
				MsSeek(xFilial("SB1")+SD2->D2_COD) 
				If SB1->(FieldPos("B1_TRIBMUN"))>0
					cTribMun:= SB1->B1_TRIBMUN
				EndIf
			
				aadd(aISSQN,{SF3->F3_CODISS,SF3->F3_VALCONT,SF3->F3_CNAE,SF3->F3_ALIQICM,SF3->F3_VALICM,SF3->F3_VALOBSE,cTribMun})
				
		        cString := ""
				cString += NFSeIde(aNotaServ,cNatOper,cTipoRPS,cModXML)
				cString += NFSeServ(aISSQN[1],aRetServ[1],nDedu,nIssRet,cRetIss,cServ,cMunPres,cModXML)
				cString += NFSePrest(cModXML)
				cString += NFSeTom(aDest,cModXML)
			
				Exit
		    EndDo	
     	
		Else
			aadd(aNota,SF2->F2_SERIE)
			aadd(aNota,IIF(Len(SF2->F2_DOC)==6,"000","")+SF2->F2_DOC)
			aadd(aNota,SF2->F2_EMISSAO)
			aadd(aNota,cTipo)
			aadd(aNota,SF2->F2_TIPO)
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Posiciona cliente ou fornecedor                                         ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ	
			If !SF2->F2_TIPO $ "DB" 
			    dbSelectArea("SA1")
				dbSetOrder(1)
				MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
				
				aadd(aDest,AllTrim(SA1->A1_CGC))
				aadd(aDest,SA1->A1_NOME)
				aadd(aDest,MyGetEnd(SA1->A1_END,"SA1")[1])
				aadd(aDest,ConvType(IIF(MyGetEnd(SA1->A1_END,"SA1")[2]<>0,MyGetEnd(SA1->A1_END,"SA1")[2],"SN")))
				aadd(aDest,IIF(SA1->(FieldPos("A1_COMPLEM")) > 0 .And. !Empty(SA1->A1_COMPLEM),SA1->A1_COMPLEM,MyGetEnd(SA1->A1_END,"SA1")[4]))
				aadd(aDest,SA1->A1_BAIRRO)
				If !Upper(SA1->A1_EST) == "EX"
					aadd(aDest,SA1->A1_COD_MUN)
					aadd(aDest,SA1->A1_MUN)				
				Else
					aadd(aDest,"99999")			
					aadd(aDest,"EXTERIOR")
				EndIf
				aadd(aDest,Upper(SA1->A1_EST))
				aadd(aDest,SA1->A1_CEP)
				aadd(aDest,IIF(Empty(SA1->A1_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")))
				aadd(aDest,IIF(Empty(SA1->A1_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR" )))
				aadd(aDest,SA1->A1_DDD+SA1->A1_TEL)
				If !Upper(SA1->A1_EST) == "EX"
					aadd(aDest,VldIE(SA1->A1_INSCR,IIF(SA1->(FIELDPOS("A1_CONTRIB"))>0,SA1->A1_CONTRIB<>"2",.T.)))
				Else
					aadd(aDest,"")											
				EndIf
				aadd(aDest,SA1->A1_SUFRAMA)
				aadd(aDest,SA1->A1_EMAIL)
				
				If SF2->(FieldPos("F2_CLIENT"))<>0 .And. !Empty(SF2->F2_CLIENT+SF2->F2_LOJENT) .And. SF2->F2_CLIENT+SF2->F2_LOJENT<>SF2->F2_CLIENTE+SF2->F2_LOJA
				    dbSelectArea("SA1")
					dbSetOrder(1)
					MsSeek(xFilial("SA1")+SF2->F2_CLIENT+SF2->F2_LOJENT)
					
					aadd(aEntrega,SA1->A1_CGC)
					aadd(aEntrega,MyGetEnd(SA1->A1_END,"SA1")[1])
					aadd(aEntrega,ConvType(IIF(MyGetEnd(SA1->A1_END,"SA1")[2]<>0,MyGetEnd(SA1->A1_END,"SA1")[2],"SN")))
					aadd(aEntrega,MyGetEnd(SA1->A1_END,"SA1")[4])
					aadd(aEntrega,SA1->A1_BAIRRO)
					aadd(aEntrega,SA1->A1_COD_MUN)
					aadd(aEntrega,SA1->A1_MUN)
					aadd(aEntrega,Upper(SA1->A1_EST))
					
				EndIf
						
			Else
			    dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)	
		
				aadd(aDest,AllTrim(SA2->A2_CGC))
				aadd(aDest,SA2->A2_NOME)
				aadd(aDest,MyGetEnd(SA2->A2_END,"SA2")[1])
				aadd(aDest,ConvType(IIF(MyGetEnd(SA2->A2_END,"SA2")[2]<>0,MyGetEnd(SA2->A2_END,"SA2")[2],"SN")))
				aadd(aDest,IIF(SA2->(FieldPos("A2_COMPLEM")) > 0 .And. !Empty(SA2->A2_COMPLEM),SA2->A2_COMPLEM,MyGetEnd(SA2->A2_END,"SA2")[4]))				
				aadd(aDest,SA2->A2_BAIRRO)
				If !Upper(SA2->A2_EST) == "EX"
					aadd(aDest,SA2->A2_COD_MUN)
					aadd(aDest,SA2->A2_MUN)				
				Else
					aadd(aDest,"99999")			
					aadd(aDest,"EXTERIOR")
				EndIf			
				aadd(aDest,Upper(SA2->A2_EST))
				aadd(aDest,SA2->A2_CEP)
				aadd(aDest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
				aadd(aDest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")))
				aadd(aDest,SA2->A2_DDD+SA2->A2_TEL)
				If !Upper(SA2->A2_EST) == "EX"				
					aadd(aDest,VldIE(SA2->A2_INSCR))
				Else
					aadd(aDest,"")							
				EndIf					
				aadd(aDest,"")//SA2->A2_SUFRAMA
				aadd(aDest,SA2->A2_EMAIL)
		
			EndIf
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Posiciona transportador                                                 ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			If !Empty(SF2->F2_TRANSP)
				dbSelectArea("SA4")
				dbSetOrder(1)
				MsSeek(xFilial("SA4")+SF2->F2_TRANSP)
				
				aadd(aTransp,AllTrim(SA4->A4_CGC))
				aadd(aTransp,SA4->A4_NOME)
				aadd(aTransp,VldIE(SA4->A4_INSEST))
				aadd(aTransp,SA4->A4_END)
				aadd(aTransp,SA4->A4_MUN)
				aadd(aTransp,Upper(SA4->A4_EST)	)
		
				If !Empty(SF2->F2_VEICUL1)
					dbSelectArea("DA3")
					dbSetOrder(1)
					MsSeek(xFilial("DA3")+SF2->F2_VEICUL1)
					
					aadd(aVeiculo,DA3->DA3_PLACA)
					aadd(aVeiculo,DA3->DA3_ESTPLA)
					aadd(aVeiculo,"")//RNTC
					
					If !Empty(SF2->F2_VEICUL2)
					
						dbSelectArea("DA3")
						dbSetOrder(1)
						MsSeek(xFilial("DA3")+SF2->F2_VEICUL2)
					
						aadd(aReboque,DA3->DA3_PLACA)
						aadd(aReboque,DA3->DA3_ESTPLA)
						aadd(aReboque,"") //RNTC
						
					EndIf					
				EndIf
			EndIf
			dbSelectArea("SF2")
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Volumes / Especie Nota de Saida                                         ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			cScan := "1"
			While ( !Empty(cScan) )
				cEspecie := Upper(FieldGet(FieldPos("F2_ESPECI"+cScan)))
				If !Empty(cEspecie)
					nScan := aScan(aEspVol,{|x| x[1] == cEspecie})
					If ( nScan==0 )
						aadd(aEspVol,{ cEspecie, FieldGet(FieldPos("F2_VOLUME"+cScan)) , SF2->F2_PLIQUI , SF2->F2_PBRUTO})
					Else
						aEspVol[nScan][2] += FieldGet(FieldPos("F2_VOLUME"+cScan))
					EndIf
				EndIf
				cScan := Soma1(cScan,1)
				If ( FieldPos("F2_ESPECI"+cScan) == 0 )
					cScan := ""
				EndIf
			EndDo
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Procura duplicatas                                                      ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			
			If !Empty(SF2->F2_DUPL)	
				cLJTPNFE := (StrTran(cMV_LJTPNFE," ,"," ','"))+" "
				cWhere := cLJTPNFE
				dbSelectArea("SE1")
				dbSetOrder(1)	
				#IFDEF TOP
					lQuery  := .T.
					cAliasSE1 := GetNextAlias()
					BeginSql Alias cAliasSE1
						COLUMN E1_VENCORI AS DATE
						SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCORI,E1_VALOR,E1_ORIGEM
						FROM %Table:SE1% SE1
						WHERE
						SE1.E1_FILIAL = %xFilial:SE1% AND
						SE1.E1_PREFIXO = %Exp:SF2->F2_PREFIXO% AND 
						SE1.E1_NUM = %Exp:SF2->F2_DUPL% AND 
						((SE1.E1_TIPO = %Exp:MVNOTAFIS%) OR
						 (SE1.E1_ORIGEM = 'LOJA701' AND SE1.E1_TIPO IN (%Exp:cWhere%))) AND
						SE1.%NotDel%
						ORDER BY %Order:SE1%
					EndSql
					
				#ELSE
					MsSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC)
				#ENDIF
				While !Eof() .And. xFilial("SE1") == (cAliasSE1)->E1_FILIAL .And.;
					SF2->F2_PREFIXO == (cAliasSE1)->E1_PREFIXO .And.;
					SF2->F2_DOC == (cAliasSE1)->E1_NUM
					If 	(cAliasSE1)->E1_TIPO = MVNOTAFIS .OR. ((cAliasSE1)->E1_ORIGEM = 'LOJA701' .AND. (cAliasSE1)->E1_TIPO $ cWhere)
					
						aadd(aDupl,{(cAliasSE1)->E1_PREFIXO+(cAliasSE1)->E1_NUM+(cAliasSE1)->E1_PARCELA,(cAliasSE1)->E1_VENCORI,(cAliasSE1)->E1_VALOR})
					
					EndIf
					dbSelectArea(cAliasSE1)
					dbSkip()
			    EndDo
			    If lQuery
			    	dbSelectArea(cAliasSE1)
			    	dbCloseArea()
			    	dbSelectArea("SE1")
			    EndIf
			Else
				aDupl := {}
			EndIf
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Analisa os impostos de retencao                                         ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			If SF2->(FieldPos("F2_VALPIS"))<>0 .and. SF2->F2_VALPIS>0
				aadd(aRetido,{"PIS",0,SF2->F2_VALPIS})
			EndIf
			If SF2->(FieldPos("F2_VALCOFI"))<>0 .and. SF2->F2_VALCOFI>0
				aadd(aRetido,{"COFINS",0,SF2->F2_VALCOFI})
			EndIf
			If SF2->(FieldPos("F2_VALCSLL"))<>0 .and. SF2->F2_VALCSLL>0
				aadd(aRetido,{"CSLL",0,SF2->F2_VALCSLL})
			EndIf
			If SF2->(FieldPos("F2_VALIRRF"))<>0 .and. SF2->F2_VALIRRF>0
				aadd(aRetido,{"IRRF",SF2->F2_BASEIRR,SF2->F2_VALIRRF})
			EndIf	
			If SF2->(FieldPos("F2_BASEINS"))<>0 .and. SF2->F2_BASEINS>0
				aadd(aRetido,{"INSS",SF2->F2_BASEINS,SF2->F2_VALINSS})
			EndIf
			/*
			If SF2->(FieldPos("F2_ICMRET"))<>0 .and. SF2->F2_ICMSRET>0
				aadd(aRetido,{"ICMSST",SF2->F2_BRICMS,SF2->F2_ICMSRET})
			EndIf
			*/
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Pesquisa itens de nota                                                  ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ	
			dbSelectArea("SD2")
			dbSetOrder(3)	
			#IFDEF TOP
				lQuery  := .T.
				cAliasSD2 := GetNextAlias()
				If SD2->(FieldPos("D2_DESCZFC"))<>0 .AND. SD2->(FieldPos("D2_DESCZFP"))<>0
					BeginSql Alias cAliasSD2
						SELECT D2_FILIAL,D2_SERIE,D2_DOC,D2_CLIENTE,D2_LOJA,D2_COD,D2_TES,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_TIPO,D2_ITEM,D2_CF,
							D2_QUANT,D2_TOTAL,D2_DESCON,D2_VALFRE,D2_SEGURO,D2_PEDIDO,D2_ITEMPV,D2_DESPESA,D2_VALBRUT,D2_VALISS,D2_PRUNIT,
							D2_CLASFIS,D2_PRCVEN,D2_CODISS,D2_DESCZFR,D2_PREEMB,D2_DESCZFC,D2_DESCZFP
						FROM %Table:SD2% SD2
						WHERE
						SD2.D2_FILIAL = %xFilial:SD2% AND
						SD2.D2_SERIE = %Exp:SF2->F2_SERIE% AND 
						SD2.D2_DOC = %Exp:SF2->F2_DOC% AND 
						SD2.D2_CLIENTE = %Exp:SF2->F2_CLIENTE% AND 
						SD2.D2_LOJA = %Exp:SF2->F2_LOJA% AND 
						SD2.%NotDel%
						ORDER BY %Order:SD2%
					EndSql
				Else
					BeginSql Alias cAliasSD2
						SELECT D2_FILIAL,D2_SERIE,D2_DOC,D2_CLIENTE,D2_LOJA,D2_COD,D2_TES,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_TIPO,D2_ITEM,D2_CF,
							D2_QUANT,D2_TOTAL,D2_DESCON,D2_VALFRE,D2_SEGURO,D2_PEDIDO,D2_ITEMPV,D2_DESPESA,D2_VALBRUT,D2_VALISS,D2_PRUNIT,
							D2_CLASFIS,D2_PRCVEN,D2_CODISS,D2_DESCZFR,D2_PREEMB
						FROM %Table:SD2% SD2
						WHERE
						SD2.D2_FILIAL = %xFilial:SD2% AND
						SD2.D2_SERIE = %Exp:SF2->F2_SERIE% AND 
						SD2.D2_DOC = %Exp:SF2->F2_DOC% AND 
						SD2.D2_CLIENTE = %Exp:SF2->F2_CLIENTE% AND 
						SD2.D2_LOJA = %Exp:SF2->F2_LOJA% AND 
						SD2.%NotDel%
						ORDER BY %Order:SD2%
					EndSql
				EndIf	
			#ELSE
				MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
			#ENDIF
			lAddMsg := .T.
			While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
				SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
				SF2->F2_DOC == (cAliasSD2)->D2_DOC
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Verifica a natureza da operacao                                         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)				
				If !lNatOper
					If Empty(cNatOper)
						cNatOper := SF4->F4_TEXTO
					EndIf
				Else	
					dbSelectArea("SX5")
					dbSetOrder(1)
					dbSeek(xFilial("SX5")+"13"+SF4->F4_CF)
					If Empty(cNatOper)
						cNatOper := AllTrim(SubStr(SX5->X5_DESCRI,1,55))
	    			EndIf
	    		EndIf 
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Verifica as notas vinculadas                                            ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				If !Empty((cAliasSD2)->D2_NFORI) 
					If (cAliasSD2)->D2_TIPO $ "DBN"
						dbSelectArea("SD1")
						dbSetOrder(1)
						If MsSeek(xFilial("SD1")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
							dbSelectArea("SF1")
							dbSetOrder(1)
							MsSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
							If SD1->D1_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								MsSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								MsSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
							EndIf
							
							aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA1->A1_CGC),IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA2->A2_CGC)),SM0->M0_ESTCOB,SF1->F1_ESPECIE})
						EndIf
					Else
						aOldReg  := SD2->(GetArea())
						aOldReg2 := SF2->(GetArea())
						dbSelectArea("SD2")
						dbSetOrder(3)
						If MsSeek(xFilial("SD2")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
							dbSelectArea("SF2")
							dbSetOrder(1)
							MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
							If !SD2->D2_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								MsSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								MsSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
							EndIf
							
							aadd(aNfVinc,{SF2->F2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF2->F2_ESPECIE})
						EndIf
						RestArea(aOldReg)
						RestArea(aOldReg2)
					EndIf
				EndIf
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Obtem os dados do produto                                               ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ			
				dbSelectArea("SB1")
				dbSetOrder(1)
				MsSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)
				
				dbSelectArea("SB5")
				dbSetOrder(1)
				MsSeek(xFilial("SB5")+(cAliasSD2)->D2_COD)
				//Veiculos Novos
				If AliasIndic("CD9")			
					dbSelectArea("CD9")
					dbSetOrder(1)
					MsSeek(xFilial("CD9")+"S"+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_ITEM)
				EndIf			
				//Medicamentos
				If AliasIndic("CD7")			
					dbSelectArea("CD7")
					dbSetOrder(1)
					MsSeek(xFilial("CD7")+"S"+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_ITEM)
				EndIf
				// Armas de Fogo
				If AliasIndic("CD8")						
					dbSelectArea("CD8")
					dbSetOrder(1) 
					MsSeek(xFilial("CD8")+"S"+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_ITEM)
				EndIf
						
				//Desconto Zona Franca PIS e COFINS 
				If	SD2->(FieldPos("D2_DESCZFC"))<>0 .AND. SD2->(FieldPos("D2_DESCZFP"))<>0
					If (cAliasSD2)->D2_DESCZFC > 0	
						nValCofZF += (cAliasSD2)->D2_DESCZFC
					EndIf
					If (cAliasSD2)->D2_DESCZFP > 0	
						nValPisZF += (cAliasSD2)->D2_DESCZFP
					EndIf
				EndIf 
							
				// Msg Zona Franca de Manaus / ALC
				dbSelectArea("SF3")
				dbSetOrder(4)
				If MsSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)			
					If !SF3->F3_DESCZFR == 0 
						If lInfAdZF .And. (nValPisZF > 0 .Or. nValCofZF > 0)
							cMensFis := "Descontos Ref. a Zona Franca de Manaus / ALC. ICMS - R$ "+str(SF3->F3_VALOBSE-SF2->F2_DESCONT-nValPisZF-nValCofZF,13,2)+", PIS - R$ "+ str(nValPisZF,13,2) +"e COFINS - R$ " +str(nValCofZF,13,2) 											
						ElseIF !lInfAdZF .And. (nValPisZF > 0 .Or. nValCofZF > 0) 
							cMensFis := "Desconto Ref. ao ICMS - Zona Franca de Manaus / ALC. R$ "+str(SF3->F3_VALOBSE-SF2->F2_DESCONT-nValPisZF-nValCofZF,13,2)
					    Else
					    	cMensFis := "Total do desconto Ref. a Zona Franca de Manaus / ALC. R$ "+str(SF3->F3_VALOBSE-SF2->F2_DESCONT,13,2)
					    EndIF
					EndIf 			
				EndIf	
				
				dbSelectArea("SC5")
				dbSetOrder(1)
				MsSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO)
				
				dbSelectArea("SC6")
				dbSetOrder(1)
				MsSeek(xFilial("SC6")+(cAliasSD2)->D2_PEDIDO+(cAliasSD2)->D2_ITEMPV+(cAliasSD2)->D2_COD)
				/*
				If !AllTrim(SC5->C5_MENNOTA) $ cMensCli
					cMensCli += AllTrim(SC5->C5_MENNOTA)
				EndIf
				If !Empty(SC5->C5_MENPAD) .And. !AllTrim(FORMULA(SC5->C5_MENPAD)) $ cMensFis
					cMensFis += AllTrim(FORMULA(SC5->C5_MENPAD))
				EndIf
                */
                cMensCli += GetMsgNota('S',@lAddMsg)							
				cModFrete := IIF(SC5->C5_TPFRETE=="C","0","1")
				
				If Empty(aPedido)
					aPedido := {"",AllTrim(SC6->C6_PEDCLI),""}
				EndIf
			
				aadd(aProd,	{Len(aProd)+1,;
								(cAliasSD2)->D2_COD,;
								IIf(Val(SB1->B1_CODBAR)==0,"",Str(Val(SB1->B1_CODBAR),Len(SB1->B1_CODBAR),0)),;
								IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI),;
								SB1->B1_POSIPI,;
								SB1->B1_EX_NCM,;
								(cAliasSD2)->D2_CF,;
								SB1->B1_UM,;
								(cAliasSD2)->D2_QUANT,;
								IIF(!(cAliasSD2)->D2_TIPO$"IP",Iif(!(cAliasSD2)->D2_TIPO$"D",(cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR,(cAliasSD2)->D2_TOTAL),0),;
								IIF(Empty(SB5->B5_UMDIPI),SB1->B1_UM,SB5->B5_UMDIPI),;
								IIF(Empty(SB5->B5_CONVDIPI),(cAliasSD2)->D2_QUANT,SB5->B5_CONVDIPI*(cAliasSD2)->D2_QUANT),;
								(cAliasSD2)->D2_VALFRE,;
								(cAliasSD2)->D2_SEGURO,;
								((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR),;
								IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN+(((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR)/(cAliasSD2)->D2_QUANT),0),;
								IIF(SB1->(FieldPos("B1_CODSIMP"))<>0,SB1->B1_CODSIMP,""),; //codigo ANP do combustivel
								IIF(SB1->(FieldPos("B1_CODIF"))<>0,SB1->B1_CODIF,"")}) //CODIF
				aadd(aCST,{IIF(!Empty((cAliasSD2)->D2_CLASFIS),SubStr((cAliasSD2)->D2_CLASFIS,2,2),'50'),;
				           IIF(!Empty((cAliasSD2)->D2_CLASFIS),SubStr((cAliasSD2)->D2_CLASFIS,1,1),'0')})
				aadd(aICMS,{})
				aadd(aIPI,{})
				aadd(aICMSST,{})
				aadd(aPIS,{})
				aadd(aPISST,{})
				aadd(aCOFINS,{})
				aadd(aCOFINSST,{})
				aadd(aISSQN,{})
				aadd(aAdi,{})
				aadd(aDi,{})
				
				cNCM := SB1->B1_POSIPI			
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Tratamento para TAG ExportaÁ„o quando existe a integraÁ„o com a EEC     ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ				
				If lEECFAT .And. !Empty((cAliasSD2)->D2_PREEMB)
					aadd(aExp,(GETNFEEXP((cAliasSD2)->D2_PREEMB)))				
				Else
					aadd(aExp,{})
				EndIf
				If AliasIndic("CD7")
					aadd(aMed,{CD7->CD7_LOTE,CD7->CD7_QTDLOT,CD7->CD7_FABRIC,CD7->CD7_VALID,CD7->CD7_PRECO})
				Else
					aadd(aMed,{})
	   			EndIf
	   			If AliasIndic("CD8")
					aadd(aArma,{CD8->CD8_TPARMA,CD8->CD8_NUMARMA,CD8->CD8_DESCR})                       
				Else
					aadd(aArma,{})
				EndIf			
				If AliasIndic("CD9")
					aadd(aveicProd,{IIF(CD9->CD9_TPOPER$"03",1,IIF(CD9->CD9_TPOPER$"1",2,IIF(CD9->CD9_TPOPER$"2",3,IIF(CD9->CD9_TPOPER$"9",0,"")))),;
									CD9->CD9_CHASSI,CD9->CD9_CODCOR,CD9->CD9_DSCCOR,CD9->CD9_POTENC,CD9->CD9_CM3POT,CD9->CD9_PESOLI,;
					                CD9->CD9_PESOBR,CD9->CD9_SERIAL,CD9->CD9_TPCOMB,CD9->CD9_NMOTOR,CD9->CD9_CMKG,CD9->CD9_DISTEI,CD9->CD9_RENAVA,;
					                CD9->CD9_ANOMOD,CD9->CD9_ANOFAB,CD9->CD9_TPPINT,CD9->CD9_TPVEIC,CD9->CD9_ESPVEI,CD9->CD9_CONVIN,CD9->CD9_CONVEI,;
					                CD9->CD9_CODMOD})
				Else
				    aadd(aveicProd,{})
				EndIf			
				dbSelectArea("CD2")
				If !(cAliasSD2)->D2_TIPO $ "DB"
					dbSetOrder(1)
				Else
					dbSetOrder(2)
				EndIf
				If !MsSeek(xFilial("CD2")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+PadR((cAliasSD2)->D2_ITEM,4)+(cAliasSD2)->D2_COD)
	
				EndIf
				While !Eof() .And. xFilial("CD2") == CD2->CD2_FILIAL .And.;
					"S" == CD2->CD2_TPMOV .And.;
					SF2->F2_SERIE == CD2->CD2_SERIE .And.;
					SF2->F2_DOC == CD2->CD2_DOC .And.;
					SF2->F2_CLIENTE == IIF(!(cAliasSD2)->D2_TIPO $ "DB",CD2->CD2_CODCLI,CD2->CD2_CODFOR) .And.;
					SF2->F2_LOJA == IIF(!(cAliasSD2)->D2_TIPO $ "DB",CD2->CD2_LOJCLI,CD2->CD2_LOJFOR) .And.;
					(cAliasSD2)->D2_ITEM == SubStr(CD2->CD2_ITEM,1,Len((cAliasSD2)->D2_ITEM)) .And.;
					(cAliasSD2)->D2_COD == CD2->CD2_CODPRO
					
					Do Case
						Case AllTrim(CD2->CD2_IMP) == "ICM"
							aTail(aICMS) := {CD2->CD2_ORIGEM,;
											   CD2->CD2_CST,;
											   CD2->CD2_MODBC,;
							                   IiF(CD2->CD2_PREDBC>0,IiF(CD2->CD2_PREDBC > 100,0,100-CD2->CD2_PREDBC),CD2->CD2_PREDBC),;
											   CD2->CD2_BC,;
											   CD2->CD2_ALIQ,;
											   CD2->CD2_VLTRIB,;
											   0,;
											   CD2->CD2_QTRIB,;
											   CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "SOL"
							aTail(aICMSST) := {CD2->CD2_ORIGEM,;
												CD2->CD2_CST,;
												CD2->CD2_MODBC,;
												IiF(CD2->CD2_PREDBC>0,IiF(CD2->CD2_PREDBC > 100,0,100-CD2->CD2_PREDBC),CD2->CD2_PREDBC),;
												CD2->CD2_BC,;
												CD2->CD2_ALIQ,;
												CD2->CD2_VLTRIB,;
												CD2->CD2_MVA,;
												CD2->CD2_QTRIB,;
												CD2->CD2_PAUTA}
							lCalSol := .T.
						Case AllTrim(CD2->CD2_IMP) == "IPI"
							aTail(aIPI) := {"",;
											 "",;
											 0,;
											 "999",;
											 CD2->CD2_CST,;
											 CD2->CD2_BC,;
											 CD2->CD2_QTRIB,;
											 CD2->CD2_PAUTA,;
											 CD2->CD2_ALIQ,;
											 CD2->CD2_VLTRIB,;
											 CD2->CD2_MODBC,;
											 IiF(CD2->CD2_PREDBC>0,IiF(CD2->CD2_PREDBC > 100,0,100-CD2->CD2_PREDBC),CD2->CD2_PREDBC)}
							nValIPI := CD2->CD2_VLTRIB
							If !lIpiDev
							   If (cAliasSD2)->D2_TIPO=="D" .And. !Empty(nValIPI)
								   aAdd(aIPIDev, {nValIPI,cNCM})
			                       nValIPI := 0
			                       cNCM	:= "" 
							       aTail(aIPI) := {"","",0,"999",CD2->CD2_CST,0,0,CD2->CD2_PAUTA,0,0,CD2->CD2_MODBC,0}				
							   EndIf
							EndIf							
						Case AllTrim(CD2->CD2_IMP) == "PS2"
							If (cAliasSD2)->D2_VALISS==0
								aTail(aPIS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
							Else
								If Empty(aISS)
									aISS := {0,0,0,0,0}
								EndIf
								aISS[04]+= CD2->CD2_VLTRIB	
							EndIf
						Case AllTrim(CD2->CD2_IMP) == "CF2"
							If (cAliasSD2)->D2_VALISS==0
								aTail(aCOFINS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
							Else
								If Empty(aISS)
									aISS := {0,0,0,0,0}
								EndIf
								aISS[05] += CD2->CD2_VLTRIB	
							EndIf
						Case AllTrim(CD2->CD2_IMP) == "PS3" .And. (cAliasSD2)->D2_VALISS==0
							aTail(aPISST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "CF3" .And. (cAliasSD2)->D2_VALISS==0
							aTail(aCOFINSST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "ISS"
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[01] += (cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON
							aISS[02] += CD2->CD2_BC
							aISS[03] += CD2->CD2_VLTRIB	
							cMunISS := ConvType(aUF[aScan(aUF,{|x| x[1] == aDest[09]})][02]+aDest[07])
							cCodIss := AllTrim((cAliasSD2)->D2_CODISS)
							If AliasIndic("CDN") .And. CDN->(dbSeek(xFilial("CDN")+cCodIss))
								cCodIss := AllTrim(CDN->CDN_CODLST)
							EndIf
							aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,cMunISS,cCodIss}
					EndCase
					dbSelectArea("CD2")
					dbSkip()
				EndDo
				aTotal[01] += (cAliasSD2)->D2_DESPESA
				aTotal[02] += (cAliasSD2)->D2_VALBRUT	

				If lCalSol			
					dbSelectArea("SF3")
					dbSetOrder(4)
					If MsSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
						If At (SF3->F3_ESTADO, cMVSUBTRIB)>0					  
							nPosI	:=	At (SF3->F3_ESTADO, cMVSUBTRIB)+2
							nPosF	:=	At ("/", SubStr (cMVSUBTRIB, nPosI))-1
							nPosF	:=	IIf(nPosF<=0,len(cMVSUBTRIB),nPosF)
							aAdd (aIEST, SubStr (cMVSUBTRIB, nPosI, nPosF))	//01 - IE_ST
						EndIf
					EndIf
				EndIf
				IF Empty(aPis[Len(aPis)]) .And. SF4->F4_CSTPIS=="06"
					aadd(aPisAlqZ,{SF4->F4_CSTPIS})
				Else
					aadd(aPisAlqZ,{})
				EndIf
				IF Empty(aCOFINS[Len(aCOFINS)]) .And. SF4->F4_CSTCOF=="06"
					aadd(aCofAlqZ,{SF4->F4_CSTCOF})
				Else               
					aadd(aCofAlqZ,{})
				EndIf				
								
				dbSelectArea(cAliasSD2)
				dbSkip()
		    EndDo

			If Len(aIPIDev)>0
		    	nX := 1
				Do While lOk
	
				   nValAux := aIPIDev[nX][1]               
				   cNCMAux := aIPIDev[nX][2]
				   
				   npos := aScan( aIPIAux,{|x| x[2]==cNCMAux})
				   IF npos >0			
						aIPIAux[npos][1]+=nValAux
			       Else
						AaDd(aIPIAux,{nValAux,cNCMAux})		       
			       EndIf
				
					nX += 1
					If nX > Len(aIPIDev)
						lOk := .F.
					EndIf
				EndDo
	
				For nX := 1 To Len(aIPIAux)
					cValIPI  := AllTrim(Str(aIPIAux[nX][1],15,2))
					cMensCli += "(Valor do IPI: R$ "+cValIPI+" - "+"ClassificaÁ„o fiscal: "+aIPIAux[nX][2]+")"+CRLF
					cValIPI  := ""
					cNCMAux  := ""
				Next nX
			EndIf
			
		    If lQuery
		    	dbSelectArea(cAliasSD2)
		    	dbCloseArea()
		    	dbSelectArea("SD2")
		    EndIf
		EndIf
	EndIf
Else
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MsSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥Tratamento temporario do CTe                                            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ			
		If FunName() == "SPEDCTE" .Or. AModNot(SF1->F1_ESPECIE)=="57"
			cNFe := "CTe35080944990901000143570000000000200000168648"
			cString := '<infNFe versao="T02.00" modelo="57" >'
			cString += '<CTe xmlns="http://www.portalfiscal.inf.br/cte"><infCte Id="CTe35080944990901000143570000000000200000168648" versao="1.02"><ide><cUF>35</cUF><cCT>000016864</cCT><CFOP>6353</CFOP><natOp>ENTREGA NORMAL</natOp><forPag>1</forPag><mod>57</mod><serie>0</serie><nCT>20</nCT><dhEmi>2008-09-12T10:49:00</dhEmi><tpImp>2</tpImp><tpEmis>2</tpEmis><cDV>8</cDV><tpAmb>2</tpAmb><tpCTe>0</tpCTe><procEmi>0</procEmi><verProc>1.12a</verProc><cMunEmi>3550308</cMunEmi><xMunEmi>Sao Paulo</xMunEmi><UFEmi>SP</UFEmi><modal>01</modal><tpServ>0</tpServ><cMunIni>3550308</cMunIni><xMunIni>Sao Paulo</xMunIni><UFIni>SP</UFIni><cMunFim>3550308</cMunFim><xMunFim>Sao Paulo</xMunFim><UFFim>SP</UFFim><retira>1</retira><xDetRetira>TESTE</xDetRetira><toma03><toma>0</toma></toma03></ide><emit><CNPJ>44990901000143</CNPJ><IE>00000000000</IE><xNome>FILIAL SAO PAULO</xNome><xFant>Teste</xFant><enderEmit><xLgr>Av. Teste, S/N</xLgr><nro>0</nro><xBairro>Teste</xBairro><cMun>3550308</cMun><xMun>Sao Paulo</xMun><CEP>00000000</CEP><UF>SP</UF></enderEmit></emit><rem><CNPJ>58506155000184</CNPJ><IE>115237740114</IE><xNome>CLIENTE SP</xNome><xFant>CLIENTE SP</xFant><enderReme><xLgr>R</xLgr><nro>0</nro><xBairro>BAIRRO NAO CADASTRADO</xBairro><cMun>3550308</cMun><xMun>SAO PAULO</xMun><CEP>77777777</CEP><UF>SP</UF></enderReme><infOutros><tpDoc>00</tpDoc><dEmi>2008-09-17</dEmi></infOutros></rem><dest><CNPJ></CNPJ><IE></IE><xNome>CLIENTE RJ</xNome><enderDest><xLgr>R</xLgr><nro>0</nro><xBairro>BAIRRO NAO CADASTRADO</xBairro><cMun>3550308</cMun><xMun>RIO DE JANEIRO</xMun><CEP>44444444</CEP><UF>RJ</UF></enderDest></dest><vPrest><vTPrest>1.93</vTPrest><vRec>1.93</vRec></vPrest><imp><ICMS><CST00><CST>00</CST><vBC>250.00</vBC><pICMS>18.00</pICMS><vICMS>450.00</vICMS></CST00></ICMS></imp><infCteComp><chave>35080944990901000143570000000000200000168648</chave><vPresComp><vTPrest>10.00</vTPrest></vPresComp><impComp><ICMSComp><CST00Comp><CST>00</CST><vBC>10.00</vBC><pICMS>10.00</pICMS><vICMS>10.00</vICMS></CST00Comp></ICMSComp></impComp></infCteComp></infCte></CTe>'
			cString += '</infNFe>'
		Else				
			aadd(aNota,SF1->F1_SERIE)
			aadd(aNota,IIF(Len(SF1->F1_DOC)==6,"000","")+SF1->F1_DOC)
			aadd(aNota,SF1->F1_EMISSAO)
			aadd(aNota,cTipo)
			aadd(aNota,SF1->F1_TIPO)			
			If SF1->F1_TIPO $ "DB" 
			    dbSelectArea("SA1")
				dbSetOrder(1)
				MsSeek(xFilial("SA1")+cClieFor+cLoja)
				
				aadd(aDest,AllTrim(SA1->A1_CGC))
				aadd(aDest,SA1->A1_NOME)
				aadd(aDest,MyGetEnd(SA1->A1_END,"SA1")[1])
				aadd(aDest,ConvType(IIF(MyGetEnd(SA1->A1_END,"SA1")[2]<>0,MyGetEnd(SA1->A1_END,"SA1")[2],"SN")))
				aadd(aDest,MyGetEnd(SA1->A1_END,"SA1")[4])
				aadd(aDest,SA1->A1_BAIRRO)
				If !Upper(SA1->A1_EST) == "EX"
					aadd(aDest,SA1->A1_COD_MUN)
					aadd(aDest,SA1->A1_MUN)				
				Else
					aadd(aDest,"99999")			
					aadd(aDest,"EXTERIOR")
				EndIf
				aadd(aDest,Upper(SA1->A1_EST))
				aadd(aDest,SA1->A1_CEP)
				aadd(aDest,IIF(Empty(SA1->A1_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")))
				aadd(aDest,IIF(Empty(SA1->A1_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR" )))
				aadd(aDest,SA1->A1_DDD+SA1->A1_TEL)
				If !Upper(SA1->A1_EST) == "EX"
					aadd(aDest,VldIE(SA1->A1_INSCR,IIF(SA1->(FIELDPOS("A1_CONTRIB"))>0,SA1->A1_CONTRIB<>"2",.T.)))
				Else
					aadd(aDest,"")											
				EndIf
				aadd(aDest,SA1->A1_SUFRAMA)
				aadd(aDest,SA1->A1_EMAIL)
									
			Else
			    dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial("SA2")+cClieFor+cLoja)
		
				aadd(aDest,AllTrim(SA2->A2_CGC))
				aadd(aDest,SA2->A2_NOME)
				aadd(aDest,MyGetEnd(SA2->A2_END,"SA2")[1])
				aadd(aDest,ConvType(IIF(MyGetEnd(SA2->A2_END,"SA2")[2]<>0,MyGetEnd(SA2->A2_END,"SA2")[2],"SN")))
				aadd(aDest,MyGetEnd(SA2->A2_END,"SA2")[4])
				aadd(aDest,SA2->A2_BAIRRO)
				If !Upper(SA2->A2_EST) == "EX"
					aadd(aDest,SA2->A2_COD_MUN)
					aadd(aDest,SA2->A2_MUN)				
				Else
					aadd(aDest,"99999")			
					aadd(aDest,"EXTERIOR")
				EndIf			
				aadd(aDest,Upper(SA2->A2_EST))
				aadd(aDest,SA2->A2_CEP)
				aadd(aDest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
				aadd(aDest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")))
				aadd(aDest,SA2->A2_DDD+SA2->A2_TEL)
				If !Upper(SA2->A2_EST) == "EX"				
					aadd(aDest,VldIE(SA2->A2_INSCR))
				Else
					aadd(aDest,"")							
				EndIf
				aadd(aDest,"")//SA2->A2_SUFRAMA
				aadd(aDest,SA2->A2_EMAIL)
		
			EndIf
					
			If SF1->F1_TIPO $ "DB" 
			    dbSelectArea("SA1")
				dbSetOrder(1)
				MsSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)	
			Else
			    dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)	
			EndIf

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Verifica Duplicatas da nota de entrada                                  ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ		
			If !Empty(SF1->F1_DUPL)	
				dbSelectArea("SE2")
				dbSetOrder(1)	
				#IFDEF TOP
					lQuery  := .T.
					cAliasSE2 := GetNextAlias()
					BeginSql Alias cAliasSE2
						COLUMN E2_VENCORI AS DATE
						SELECT E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_VENCORI,E2_VALOR,E2_ORIGEM
						FROM %Table:SE2% SE2
						WHERE
						SE2.E2_FILIAL = %xFilial:SE2% AND
						SE2.E2_PREFIXO = %Exp:SF1->F1_PREFIXO% AND 
						SE2.E2_NUM = %Exp:SF1->F1_DUPL% AND 
						SE2.E2_TIPO = %Exp:MVNOTAFIS% AND 
						SE2.%NotDel%
						ORDER BY %Order:SE2%
					EndSql
					
				#ELSE
					MsSeek(xFilial("SE2")+SF1->F1_PREFIXO+SF1->F1_DOC)
				#ENDIF
				While !Eof() .And. xFilial("SE2") == (cAliasSE2)->E2_FILIAL .And.;
					SF1->F1_PREFIXO == (cAliasSE2)->E2_PREFIXO .And.;
					SF1->F1_DOC == (cAliasSE2)->E2_NUM
					If 	(cAliasSE2)->E2_TIPO = MVNOTAFIS				
						aadd(aDupl,{(cAliasSE2)->E2_PREFIXO+(cAliasSE2)->E2_NUM+(cAliasSE2)->E2_PARCELA,(cAliasSE2)->E2_VENCORI,(cAliasSE2)->E2_VALOR})				
					EndIf
					dbSelectArea(cAliasSE2)
					dbSkip()
			    EndDo
			    If lQuery
			    	dbSelectArea(cAliasSE2)
			    	dbCloseArea()
			    	dbSelectArea("SE2")
			    EndIf
			Else
				aDupl := {}
			EndIf

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Analisa os impostos de retencao                                         ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			If SF1->(FieldPos("F1_VALPIS"))<>0 .And. SF1->F1_VALPIS>0
				aadd(aRetido,{"PIS",0,SF1->F1_VALPIS})
			EndIf
			If SF1->(FieldPos("F1_VALCOFI"))<>0 .And. SF1->F1_VALCOFI>0
				aadd(aRetido,{"COFINS",0,SF1->F1_VALCOFI})
			EndIf
			If SF1->(FieldPos("F1_VALCSLL"))<>0 .And. SF1->F1_VALCSLL>0
				aadd(aRetido,{"CSLL",0,SF1->F1_VALCSLL})
			EndIf
			If SF1->(FieldPos("F1_INSS"))<>0 .and. SF1->F1_INSS>0
				aadd(aRetido,{"INSS",SF1->F1_BASEINS,SF1->F1_INSS})
			EndIf
			dbSelectArea("SF1")
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Volumes / Especie Nota de Entrada                                       ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			cScan := "1"
			If (FieldPos("F1_ESPECI"+cScan))>0
				While ( !Empty(cScan) )
					cEspecie := Upper(FieldGet(FieldPos("F1_ESPECI"+cScan)))
					If !Empty(cEspecie)
						nScan := aScan(aEspVol,{|x| x[1] == cEspecie})
						If ( nScan==0 )
							aadd(aEspVol,{ cEspecie, FieldGet(FieldPos("F1_VOLUME"+cScan)) , SF1->F1_PLIQUI , SF1->F1_PBRUTO})
						Else
							aEspVol[nScan][2] += FieldGet(FieldPos("F1_VOLUME"+cScan))
						EndIf
					EndIf
					cScan := Soma1(cScan,1)
					If ( FieldPos("F1_ESPECI"+cScan) == 0 )
						cScan := ""
					EndIf
				EndDo
			EndIf
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Posiciona transportador                                                 ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			If FieldPos("F1_TRANSP") > 0 .And. !Empty(SF1->F1_TRANSP)
				dbSelectArea("SA4")
				dbSetOrder(1)
				MsSeek(xFilial("SA4")+SF1->F1_TRANSP)
				
				aadd(aTransp,AllTrim(SA4->A4_CGC))
				aadd(aTransp,SA4->A4_NOME)
				aadd(aTransp,SA4->A4_INSEST)
				aadd(aTransp,SA4->A4_END)
				aadd(aTransp,SA4->A4_MUN)
				aadd(aTransp,Upper(SA4->A4_EST)	)
			EndIf


			dbSelectArea("SD1")
			dbSetOrder(1)	
			#IFDEF TOP
				lQuery  := .T.
				cAliasSD1 := GetNextAlias()
				BeginSql Alias cAliasSD1
					SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_ITEM,D1_TES,D1_TIPO,
							D1_NFORI,D1_SERIORI,D1_ITEMORI,D1_CF,D1_QUANT,D1_TOTAL,D1_VALDESC,D1_VALFRE,
							D1_SEGURO,D1_DESPESA,D1_CODISS,D1_VALISS,D1_VALIPI,D1_ICMSRET,D1_VUNIT,D1_CLASFIS,
							D1_VALICM,D1_TIPO_NF,D1_PEDIDO,D1_ITEMPC,D1_VALIMP5,D1_VALIMP6,D1_BASEIRR,D1_VALIRR
					FROM %Table:SD1% SD1
					WHERE
					SD1.D1_FILIAL = %xFilial:SD1% AND
					SD1.D1_SERIE = %Exp:SF1->F1_SERIE% AND 
					SD1.D1_DOC = %Exp:SF1->F1_DOC% AND 
					SD1.D1_FORNECE = %Exp:SF1->F1_FORNECE% AND 
					SD1.D1_LOJA = %Exp:SF1->F1_LOJA% AND 
					SD1.D1_FORMUL = 'S' AND 
					SD1.%NotDel%
					ORDER BY %Order:SD1%
				EndSql
					
			#ELSE
				MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			#ENDIF
			While !Eof() .And. xFilial("SD1") == (cAliasSD1)->D1_FILIAL .And.;
				SF1->F1_SERIE == (cAliasSD1)->D1_SERIE .And.;
				SF1->F1_DOC == (cAliasSD1)->D1_DOC .And.;
				SF1->F1_FORNECE == (cAliasSD1)->D1_FORNECE .And.;
				SF1->F1_LOJA ==  (cAliasSD1)->D1_LOJA
				
	
				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(xFilial("SF4")+(cAliasSD1)->D1_TES)
				If !lNatOper
					If Empty(cNatOper)
						cNatOper := SF4->F4_TEXTO					
					EndIf
				Else
					dbSelectArea("SX5")
					dbSetOrder(1)
					dbSeek(xFilial("SX5")+"13"+SF4->F4_CF)
					If Empty(cNatOper)
						cNatOper := AllTrim(SubStr(SX5->X5_DESCRI,1,55))
	    			EndIf
	    		EndIf
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Verifica as notas vinculadas                                            ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ			
				If !Empty((cAliasSD1)->D1_NFORI) 
					If !(cAliasSD1)->D1_TIPO $ "DBN"
						aOldReg  := SD1->(GetArea())
						aOldReg2 := SF1->(GetArea())
						dbSelectArea("SD1")
						dbSetOrder(1)
						If MsSeek(xFilial("SD1")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
							dbSelectArea("SF1")
							dbSetOrder(1)
							MsSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
							If SD1->D1_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								MsSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								MsSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
							EndIf
							
							aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA1->A1_CGC),IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA2->A2_CGC)),SM0->M0_ESTCOB,SF1->F1_ESPECIE})
						EndIf
						RestArea(aOldReg)
						RestArea(aOldReg2)
					Else					
						dbSelectArea("SD2")
						dbSetOrder(3)
						If MsSeek(xFilial("SD2")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
							dbSelectArea("SF2")
							dbSetOrder(1)
							MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
							If !SD2->D2_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								MsSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								MsSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
							EndIf
							
							aadd(aNfVinc,{SD2->D2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF2->F2_ESPECIE})
							
						EndIf
					EndIf
				
				EndIf
				
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Obtem os dados do produto                                               ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ			
				dbSelectArea("SB1")
				dbSetOrder(1)
				MsSeek(xFilial("SB1")+(cAliasSD1)->D1_COD)
				//Veiculos Novos
				If AliasIndic("CD9")			
					dbSelectArea("CD9")
					dbSetOrder(1)
					MsSeek(xFilial("CD9")+"E"+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_ITEM)
				EndIf			
				//Medicamentos
				If AliasIndic("CD7")
					dbSelectArea("CD7")
					dbSetOrder(1)
					MsSeek(xFilial("CD7")+"E"+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_ITEM)
				EndIf
	            // Armas de Fogo
	            If AliasIndic("CD8")
					dbSelectArea("CD8")
					dbSetOrder(1)
					MsSeek(xFilial("CD8")+"E"+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_ITEM)
				EndIf
				
				dbSelectArea("SB5")
				dbSetOrder(1)
				MsSeek(xFilial("SB5")+(cAliasSD1)->D1_COD)
									
				cModFrete := IIF(SF1->F1_FRETE>0,"0","1")
							
				aadd(aProd,	{Len(aProd)+1,;
								(cAliasSD1)->D1_COD,;
								IIf(Val(SB1->B1_CODBAR)==0,"",Str(Val(SB1->B1_CODBAR),Len(SB1->B1_CODBAR),0)),;
								SB1->B1_DESC,;
								SB1->B1_POSIPI,;
								SB1->B1_EX_NCM,;
								(cAliasSD1)->D1_CF,;
								SB1->B1_UM,;
								(cAliasSD1)->D1_QUANT,;
								IIF(!(cAliasSD1)->D1_TIPO$"IP",Iif(!(cAliasSD1)->D1_TIPO$"D",(cAliasSD1)->D1_TOTAL+(cAliasSD1)->D1_VALDESC,(cAliasSD1)->D1_TOTAL),0),;
								IIF(Empty(SB5->B5_UMDIPI),SB1->B1_UM,SB5->B5_UMDIPI),;
								IIF(Empty(SB5->B5_CONVDIPI),(cAliasSD1)->D1_QUANT,SB5->B5_CONVDIPI*(cAliasSD1)->D1_QUANT),;
								(cAliasSD1)->D1_VALFRE,;
								(cAliasSD1)->D1_SEGURO,;
								(cAliasSD1)->D1_VALDESC,;
								IIF(!(cAliasSD1)->D1_TIPO$"IP",(cAliasSD1)->D1_VUNIT,0),;
								IIF(SB1->(FieldPos("B1_CODSIMP"))<>0,SB1->B1_CODSIMP,""),; //codigo ANP do combustivel
								IIF(SB1->(FieldPos("B1_CODIF"))<>0,SB1->B1_CODIF,"")}) //CODIF
				aadd(aCST,{IIF(!Empty((cAliasSD1)->D1_CLASFIS),SubStr((cAliasSD1)->D1_CLASFIS,2,2),'50'),;
							IIF(!Empty((cAliasSD1)->D1_CLASFIS),SubStr((cAliasSD1)->D1_CLASFIS,1,1),'0')})
				aadd(aICMS,{})
				aadd(aIPI,{})
				aadd(aICMSST,{})
				aadd(aPIS,{})
				aadd(aPISST,{})
				aadd(aCOFINS,{})
				aadd(aCOFINSST,{})
				aadd(aISSQN,{})
				aadd(aExp,{})				
				If lEasy  .And. !Empty((cAliasSD1)->D1_TIPO_NF)

					cTipoNF 	:= (cAliasSD1)->D1_TIPO
					cDocEnt 	:= (cAliasSD1)->D1_DOC
					cSerEnt 	:= (cAliasSD1)->D1_SERIE
					cFornece	:= (cAliasSD1)->D1_FORNECE
					cLojaEnt	:= (cAliasSD1)->D1_LOJA
					cTipoNFEnt	:= (cAliasSD1)->D1_TIPO_NF
					cPedido 	:= (cAliasSD1)->D1_PEDIDO
					cItemPC 	:= (cAliasSD1)->D1_ITEMPC
					cNFOri  	:= (cAliasSD1)->D1_NFORI
					cSerOri 	:= (cAliasSD1)->D1_SERIORI
					cItemOri	:= (cAliasSD1)->D1_ITEMORI
					cProd   	:= (cAliasSD1)->D1_COD

					If !cTipoNF$"IP"
						//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
						//≥Tratamento para TAG ImportaÁ„o quando existe a integraÁ„o com a EIC  (Se a nota for primeira ou unica)|
						//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
						aadd(aDI,(GetNFEIMP(.F.,cDocEnt,cSerEnt,cFornece,cLojaEnt,cTipoNFEnt,cPedido,cItemPC)))
					Else
						//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
						//≥Tratamento para TAG ImportaÁ„o quando existe a integraÁ„o com a EIC  (Se a nota for complementar)     |
						//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
						aadd(aDI,(GetNFEIMP(.F.,cNFOri,cSerOri,cFornece,cLojaEnt,cTipoNFEnt, ,cItemOri)))
					EndIf
					aAdi := aDI				
				Else
					aadd(aAdi,{})
					aadd(aDi,{})
				EndIf

				If (cAliasSD1)->D1_BASEIRR > 0  .And. (cAliasSD1)->D1_VALIRR > 0 
					nBaseIrrf += (cAliasSD1)->D1_BASEIRR
					nValIrrf  += (cAliasSD1)->D1_VALIRR 
				EndIf	

				If AliasIndic("CD7")
					aadd(aMed,{CD7->CD7_LOTE,CD7->CD7_QTDLOT,CD7->CD7_FABRIC,CD7->CD7_VALID,CD7->CD7_PRECO})
				Else
					aadd(aMed,{})
				EndIf
				If AliasIndic("CD8")
					aadd(aArma,{CD8->CD8_TPARMA,CD8->CD8_NUMARMA,CD8->CD8_DESCR})
				Else
					aadd(aArma,{})
				EndIf
				If AliasIndic("CD9")
					aadd(aveicProd,{CD9->CD9_TPOPER,CD9->CD9_CHASSI,CD9->CD9_CODCOR,CD9->CD9_DSCCOR,CD9->CD9_POTENC,CD9->CD9_CM3POT,CD9->CD9_PESOLI,;
					                CD9->CD9_PESOBR,CD9->CD9_SERIAL,CD9->CD9_TPCOMB,CD9->CD9_NMOTOR,CD9->CD9_CMKG,CD9->CD9_DISTEI,CD9->CD9_RENAVA,;
					                CD9->CD9_ANOMOD,CD9->CD9_ANOFAB,CD9->CD9_TPPINT,CD9->CD9_TPVEIC,CD9->CD9_ESPVEI,CD9->CD9_CONVIN,CD9->CD9_CONVEI,;
					                CD9->CD9_CODMOD})
				Else
				    aadd(aveicProd,{})
				EndIf
				dbSelectArea("CD2")
				If !(cAliasSD1)->D1_TIPO $ "DB"			
					dbSetOrder(2)
				Else
					dbSetOrder(1)
				EndIf
				MsSeek(xFilial("CD2")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA+PadR((cAliasSD1)->D1_ITEM,4)+(cAliasSD1)->D1_COD)
				While !Eof() .And. xFilial("CD2") == CD2->CD2_FILIAL .And.;
					"E" == CD2->CD2_TPMOV .And.;
					SF1->F1_SERIE == CD2->CD2_SERIE .And.;
					SF1->F1_DOC == CD2->CD2_DOC .And.;
					SF1->F1_FORNECE == IIF(!(cAliasSD1)->D1_TIPO $ "DB",CD2->CD2_CODFOR,CD2->CD2_CODCLI) .And.;
					SF1->F1_LOJA == IIF(!(cAliasSD1)->D1_TIPO $ "DB",CD2->CD2_LOJFOR,CD2->CD2_LOJCLI) .And.;				
					(cAliasSD1)->D1_ITEM == SubStr(CD2->CD2_ITEM,1,Len((cAliasSD1)->D1_ITEM)) .And.;
					(cAliasSD1)->D1_COD == CD2->CD2_CODPRO
					
					Do Case
						Case AllTrim(CD2->CD2_IMP) == "ICM"
							aTail(aICMS) := {CD2->CD2_ORIGEM,;
											  CD2->CD2_CST,;
											  CD2->CD2_MODBC,; 
							                  IiF(CD2->CD2_PREDBC>0,IiF(CD2->CD2_PREDBC > 100,0,100-CD2->CD2_PREDBC),;// Tratamento para obter o percentual da reduÁ„o de base do icms nota interna e importacao(integracao com EIC)
							                  IiF(Len(aAdI[1])>0 .And. !Empty(aAdi[1][14][03]),IiF((aAdi[1][14][03]) > 100,0,aAdi[1][14][03]),CD2->CD2_PREDBC)),;
											  CD2->CD2_BC,;
											  CD2->CD2_ALIQ,;
											  CD2->CD2_VLTRIB,;
											  0,;
											  CD2->CD2_QTRIB,;
											  CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "SOL"
							aTail(aICMSST) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MVA,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "IPI"
							aTail(aIPI) := {"","",0,"999",CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_QTRIB,CD2->CD2_PAUTA,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MODBC,CD2->CD2_PREDBC}
						Case AllTrim(CD2->CD2_IMP) == "ISS"
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[01] += (cAliasSD1)->D1_TOTAL
							aISS[02] += CD2->CD2_BC
							aISS[03] += CD2->CD2_VLTRIB					
						Case AllTrim(CD2->CD2_IMP) == "PS2"
							If (cAliasSD1)->D1_VALISS==0
								aTail(aPIS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
							Else
								If Empty(aISS)
									aISS := {0,0,0,0,0}
								EndIf
								aISS[04]          += CD2->CD2_VLTRIB	
							EndIf
						Case AllTrim(CD2->CD2_IMP) == "CF2"
							If (cAliasSD1)->D1_VALISS==0
								aTail(aCOFINS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
							Else
								If Empty(aISS)
									aISS := {0,0,0,0,0}
								EndIf
								aISS[05] += CD2->CD2_VLTRIB	
							EndIf
						Case AllTrim(CD2->CD2_IMP) == "PS3" .And. (cAliasSD1)->D1_VALISS==0
							aTail(aPISST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "CF3" .And. (cAliasSD1)->D1_VALISS==0
							aTail(aCOFINSST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "ISS"
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[01] += (cAliasSD1)->D1_TOTAL
							aISS[02] += CD2->CD2_BC
							aISS[03] += CD2->CD2_VLTRIB	
							aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,"",AllTrim((cAliasSD1)->D1_CODISS)}
					EndCase
					
					dbSelectArea("CD2")
					dbSkip()
				EndDo
				
				IF Empty(aPis[Len(aPis)]) .And. SF4->F4_CSTPIS=="06"
					aadd(aPisAlqZ,{SF4->F4_CSTPIS})
				Else
					aadd(aPisAlqZ,{})
				EndIf
				IF Empty(aCOFINS[Len(aCOFINS)]) .And. SF4->F4_CSTCOF=="06"
					aadd(aCofAlqZ,{SF4->F4_CSTCOF})
				Else 
					aadd(aCofAlqZ,{})
				EndIf								

				aTotal[01] += (cAliasSD1)->D1_DESPESA
				aTotal[02] += ((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC+(cAliasSD1)->D1_VALFRE+(cAliasSD1)->D1_SEGURO+(cAliasSD1)->D1_DESPESA;
								+IIF((cAliasSD1)->D1_TIPO$"IP",0,(cAliasSD1)->D1_VALIPI)+(cAliasSD1)->D1_ICMSRET;
								+IIF(SF4->F4_AGREG$"IB",(cAliasSD1)->D1_VALICM,0);
								+IIF(SF4->F4_AGRPIS=="1",(cAliasSD1)->D1_VALIMP6,0);
								+IIF(SF4->F4_AGRCOF=="1",(cAliasSD1)->D1_VALIMP5,0));
								-(IIF(SF4->F4_AGREG$"D",(cAliasSD1)->D1_VALICM,0))
				dbSelectArea(cAliasSD1)
				dbSkip()
		    EndDo	
			If nBaseIrrf > 0 .And. nValIrrf > 0
				aadd(aRetido,{"IRRF",nBaseIrrf,nValIrrf})
			EndIf
		    If lQuery
		    	dbSelectArea(cAliasSD1)
		    	dbCloseArea()
		    	dbSelectArea("SD1")
		    EndIf
		EndIf
	EndIf
EndIf
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Geracao do arquivo XML                                                  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If !Empty(aNota)
	cString := ""
	cString += NfeIde(@cNFe,aNota,cNatOper,aDupl,aNfVinc)
	cString += NfeEmit(aIEST)
	cString += NfeDest(aDest)
	cString += NfeLocalEntrega(aEntrega)
	For nX := 1 To Len(aProd)
		cString += NfeItem(aProd[nX],aICMS[nX],aICMSST[nX],aIPI[nX],aPIS[nX],aPISST[nX],aCOFINS[nX],aCOFINSST[nX],aISSQN[nX],aCST[nX],aMed[nX],aArma[nX],aveicProd[nX],aDI[nX],aAdi[nX],aExp[nX],aPisAlqZ[nX],aCofAlqZ[nX])
	Next nX
	cString += NfeTotal(aTotal,aRetido)
	cString += NfeTransp(cModFrete,aTransp,aImp,aVeiculo,aReboque,aEspVol)
	cString += NfeCob(aDupl)
	cString += NfeInfAd(cMensCli,cMensFis,aPedido,aExp)
	cString += "</infNFe>"
EndIf	
Return({cNfe,EncodeUTF8(cString)})

Static Function NfeIde(cChave,aNota,cNatOper,aDupl,aNfVinc)

Local cString:= ""
Local cNFVinc:= ""
Local cModNot:= ""
Local lAvista:= Len(aDupl)==1 .And. aDupl[01][02]<=DataValida(aNota[03]+1,.T.)
Local lDSaiEnt := GetNewPar("MV_DSAIENT", .T.)
Local nX     := 0

cChave := aUF[aScan(aUF,{|x| x[1] == SM0->M0_ESTCOB})][02]+FsDateConv(aNota[03],"YYMM")+SM0->M0_CGC+"55"+StrZero(Val(aNota[01]),3)+StrZero(Val(aNota[02]),9)+Inverte(StrZero(Val(aNota[02]),9))

cString += '<infNFe versao="T01.00">'
cString += '<ide>'
cString += '<cUF>'+ConvType(aUF[aScan(aUF,{|x| x[1] == SM0->M0_ESTCOB})][02],02)+'</cUF>'
cString += '<cNF>'+ConvType(Inverte(StrZero(Val(aNota[02]),Len(aNota[02]))),09)+'</cNF>'
cString += '<natOp>'+ConvType(cNatOper)+'</natOp>'
cString += '<indPag>'+IIF(lAVista,"0",IIf(Len(aDupl)==0,"2","1"))+'</indPag>'
cString += '<serie>'+ConvType(Val(aNota[01]),3)+'</serie>'
cString += '<nNF>'+ConvType(Val(aNota[02]),9)+'</nNF>'
cString += '<dEmi>'+ConvType(aNota[03])+'</dEmi>
cString += NfeTag('<dSaiEnt>',Iif(lDSaiEnt, "", ConvType(aNota[03])))
cString += '<tpNF>'+aNota[04]+'</tpNF>'



If !Empty(aNfVinc)

	cModNot := AModNot(aNfVinc[1][06])
	
	If cModNot == '02'
		aNfVinc   := {}
	EndIf

	cString += '<NFRef>'
	For nX := 1 To Len(aNfVinc)
		If !(ConvType(aUF[aScan(aUF,{|x| x[1] == aNfVinc[nX][05]})][02],02)+;
				FsDateConv(aNfVinc[nX][01],"YYMM")+;
				aNfVinc[nX][04]+;
				AModNot(aNfVinc[nX][06])+;
				ConvType(Val(aNfVinc[nX][02]),3)+;
				ConvType(Val(aNfVinc[nX][03]),9) $ cNFVinc )
			cString += '<RefNF>'
			cString += '<cUF>'+ConvType(aUF[aScan(aUF,{|x| x[1] == aNfVinc[nX][05]})][02],02)+'</cUF>'
			cString += '<AAMM>'+FsDateConv(aNfVinc[nX][01],"YYMM")+'</AAMM>'
			cString += '<CNPJ>'+aNfVinc[nX][04]+'</CNPJ>'
			cString += '<mod>'+AModNot(aNfVinc[nX][06])+'</mod>'
			cString += '<serie>'+ConvType(Val(aNfVinc[nX][02]),3)+'</serie>'
			cString += '<nNF>'+ConvType(Val(aNfVinc[nX][03]),9)+'</nNF>'
			cString += '<cNF>'+Inverte(StrZero(Val(aNfVinc[nX][03]),9))+'</cNF>'
			cString += '</RefNF>'
	
			cNFVinc += ConvType(aUF[aScan(aUF,{|x| x[1] == aNfVinc[nX][05]})][02],02)+;
				FsDateConv(aNfVinc[nX][01],"YYMM")+;
				aNfVinc[nX][04]+;
				AModNot(aNfVinc[nX][06])+;
				ConvType(Val(aNfVinc[nX][02]),3)+;
				ConvType(Val(aNfVinc[nX][03]),9)
		EndIf						
	Next nX
	cString += '</NFRef>'
EndIf
cString += '<tpNFe>'+IIF(!Empty(aNfVinc).And. !(aNota[5]$"NDB"),"2","1")+'</tpNFe>'
cString += '</ide>'

Return( cString )

Static Function NfeEmit(aIEST)

Local cString := ""
Local lEndFis := GetNewPar("MV_SPEDEND",.F.)

DEFAULT aIEST	 := {}

cString := '<emit>'
cString += '<CNPJ>'+SM0->M0_CGC+'</CNPJ>
cString += '<Nome>'+ConvType(SM0->M0_NOMECOM)+'</Nome>'
cString += NfeTag('<Fant>',ConvType(SM0->M0_NOME))
cString += '<enderEmit>'
cString += '<Lgr>'+IIF(!lEndFis,ConvType(FisGetEnd(SM0->M0_ENDCOB)[1]),ConvType(FisGetEnd(SM0->M0_ENDENT)[1]))+'</Lgr>'
cString += '<nro>'+IIF(!lEndFis,ConvType(IIF(FisGetEnd(SM0->M0_ENDCOB)[2]<>0,FisGetEnd(SM0->M0_ENDCOB)[2],"SN")),ConvType(IIF(FisGetEnd(SM0->M0_ENDENT)[2]<>0,FisGetEnd(SM0->M0_ENDENT)[2],"SN")))+'</nro>'
cEndEmit :=  IIF(!lEndFis,Iif(!Empty(SM0->M0_COMPCOB),SM0->M0_COMPCOB,ConvType(FisGetEnd(SM0->M0_ENDCOB)[4]) ) ,;
						  Iif(!Empty(SM0->M0_COMPENT),SM0->M0_COMPENT,ConvType(FisGetEnd(SM0->M0_ENDENT)[4]) ) )
cString += NfeTag('<Cpl>',cEndEmit)
//cString += NfeTag('<Cpl>',IIF(!lEndFis,ConvType(FisGetEnd(SM0->M0_ENDCOB)[4]),ConvType(FisGetEnd(SM0->M0_ENDENT)[4])))
cString += '<Bairro>'+IIF(!lEndFis,ConvType(SM0->M0_BAIRCOB),ConvType(SM0->M0_BAIRENT))+'</Bairro>'
cString += '<cMun>'+ConvType(SM0->M0_CODMUN)+'</cMun>'
cString += '<Mun>'+IIF(!lEndFis,ConvType(SM0->M0_CIDCOB),ConvType(SM0->M0_CIDENT))+'</Mun>'
cString += '<UF>'+IIF(!lEndFis,ConvType(SM0->M0_ESTCOB),ConvType(SM0->M0_ESTENT))+'</UF>'
cString += NfeTag('<CEP>',IIF(!lEndFis,ConvType(SM0->M0_CEPCOB),ConvType(SM0->M0_CEPENT)))
cString += NfeTag('<cPais>',"1058")
cString += NfeTag('<Pais>',"BRASIL")
cString += NfeTag('<fone>',ConvType(FisGetTel(SM0->M0_TEL)[3],18))
cString += '</enderEmit>'
cString += '<IE>'+ConvType(VldIE(SM0->M0_INSC))+'</IE>'
If !Empty(aIEST)
	cString += NfeTag('<IEST>',aIEST[01])
Else
    cString += NfeTag('<IEST>',"")
EndIf

cString += NfeTag('<IM>',SM0->M0_INSCM)
cString += NfeTag('<CNAE>',ConvType(SM0->M0_CNAE))
cString += '</emit>'
Return(cString)

Static Function NfeDest(aDest)

Local cString:= ""

cString := '<dest>'
If Len(AllTrim(aDest[01]))==14
	cString += '<CNPJ>'+AllTrim(aDest[01])+'</CNPJ>'
ElseIf Len(AllTrim(aDest[01]))<>0
	cString += '<CPF>' +AllTrim(aDest[01])+'</CPF>'
Else
	cString += '<CNPJ></CNPJ>'
EndIf
cString += '<Nome>'+ConvType(aDest[02])+'</Nome>'
cString += '<enderDest>'
cString += '<Lgr>'+ConvType(aDest[03])+'</Lgr>'
cString += '<nro>'+ConvType(aDest[04])+'</nro>'
cString += NfeTag('<Cpl>',ConvType(aDest[05]))
cString += '<Bairro>'+ConvType(aDest[06])+'</Bairro>'
cString += '<cMun>'+ConvType(aUF[aScan(aUF,{|x| x[1] == aDest[09]})][02]+aDest[07])+'</cMun>'
cString += '<Mun>'+ConvType(aDest[08])+'</Mun>'
cString += '<UF>'+ConvType(aDest[09])+'</UF>'
cString += NfeTag('<CEP>',aDest[10])
cString += NfeTag('<cPais>',aDest[11])
cString += NfeTag('<Pais>',aDest[12])
cString += NfeTag('<fone>',ConvType(FisGetTel(aDest[13])[3],18))
cString += '</enderDest>'
cString += '<IE>'+ConvType(aDest[14])+'</IE>'
cString += NfeTag('<IESUF>',aDest[15])
cString += NfeTag('<EMAIL>',aDest[16])
cString += '</dest>'
Return(cString)

Static Function NfeLocalEntrega(aEntrega)

Local cString:= ""

If !Empty(aEntrega) .And. Len(AllTrim(aEntrega[01]))==14
	cString := '<entrega>'
	cString += '<CNPJ>'+AllTrim(aEntrega[01])+'</CNPJ>'
	cString += '<Lgr>'+ConvType(aEntrega[02])+'</Lgr>'
	cString += '<nro>'+ConvType(aEntrega[03])+'</nro>'
	cString += NfeTag('<Cpl>',ConvType(aEntrega[04]))
	cString += '<Bairro>'+ConvType(aEntrega[05])+'</Bairro>'
	cString += '<cMun>'+ConvType(aUF[aScan(aUF,{|x| x[1] == aEntrega[08]})][02]+aEntrega[06])+'</cMun>'
	cString += '<Mun>'+ConvType(aEntrega[07])+'</Mun>'
	cString += '<UF>'+ConvType(aEntrega[08])+'</UF>'
	cString += '</entrega>'
EndIf
Return(cString)

Static Function NfeItem(aProd,aICMS,aICMSST,aIPI,aPIS,aPISST,aCOFINS,aCOFINSST,aISSQN,aCST,aMed,aArma,aveicProd,aDI,aAdi,aExp,aPisAlqZ,aCofAlqZ)

Local cString    := ""
DEFAULT aICMS    := {}
DEFAULT aICMSST  := {}
DEFAULT aIPI     := {}
DEFAULT aPIS     := {}
DEFAULT aPISST   := {}
DEFAULT aCOFINS  := {}
DEFAULT aCOFINSST:= {}
DEFAULT aISSQN   := {}
DEFAULT aMed     := {}
DEFAULT aArma    := {}
DEFAULT aveicProd:= {}
DEFAULT aDI		 := {}
DEFAULT aAdi	 := {}
DEFAULT aExp	 := {}

cString += '<det nItem="'+ConvType(aProd[01])+'">'
cString += '<prod>'
cString += '<cProd>'+ConvType(aProd[02])+'</cProd>'
cString += '<ean>'+ConvType(aProd[03])+'</ean>'
cString += '<Prod>'+ConvType(aProd[04],120)+'</Prod>'
cString += NfeTag('<NCM>',ConvType(aProd[05]))
cString += NfeTag('<EXTIPI>',ConvType(aProd[06]))
cString += '<CFOP>'+ConvType(aProd[07])+'</CFOP>'
cString += '<uCom>'+ConvType(aProd[08])+'</uCom>'
cString += '<qCom>'+ConvType(aProd[09],12,4)+'</qCom>'
cString += '<vUnCom>'+ConvType(aProd[16],16,4)+'</vUnCom>'
cString += '<vProd>' +ConvType(aProd[10],15,2)+'</vProd>'
cString += '<eantrib>'+ConvType(aProd[03])+'</eantrib>'
cString += '<uTrib>'+ConvType(aProd[11])+'</uTrib>'
cString += '<qTrib>'+ConvType(aProd[12],12,4)+'</qTrib>'
cString += '<vUnTrib>'+ConvType(aProd[10]/aProd[12],16,4)+'</vUnTrib>'
cString += NfeTag('<vFrete>',ConvType(aProd[13],15,2))
cString += NfeTag('<vSeg>'  ,ConvType(aProd[14],15,2))
cString += NfeTag('<vDesc>' ,ConvType(aProd[15],15,2))

//Ver II - Average - Tag da DeclaraÁ„o de ImportaÁ„o aDI
If Len(aDI)>0
	cString += '<DI>'
	cString += '<nDI>'+ConvType(aDI[04][03])+'</nDI>'
	cString += '<dtDi>'+ConvType(aDI[05][03])+ '</dtDi>'      
	cString += '<LocDesemb>'+ConvType(aDI[06][03])+ '</LocDesemb>'
	cString += '<UFDesemb>'+ConvType(aDI[07][03])+ '</UFDesemb>'
	cString += '<dtDesemb>'+ConvType(aDI[08][03])+ '</dtDesemb>'
	cString += '<Exportador>'+ConvType(aDI[09][03])+ '</Exportador>'
	If Len(aAdi)>0
		cString += '<adicao>'
		cString += '<Adicao>'+ConvType(aAdi[10][03])+ '</Adicao>'
		cString += '<SeqAdic>'+ConvType(aAdi[11][03])+ '</SeqAdic>'
		cString += '<Fabricante>'+ConvType(aAdi[12][03])+ '</Fabricante>'
		cString += '<vDescDI>'+ConvType(aAdi[13][03])+ '</vDescDI>'
		cString += '</adicao>'
	EndIf
	cString += '</DI>'
EndIf

If !Empty(aProd[17])
	cString += '<comb>'	
	cString += NfeTag('<cprodanp>',ConvType(aProd[17]))
	cString += NfeTag('<codif>',ConvType(aProd[18]))
	cString += '</comb>'                            
	//Tratamento da CIDE - Ver com a Average
	//Tratamento de ICMS-ST - Ver com fisco
EndIf

//Veiculos Novos
If !Empty(aveicProd) .And. !Empty(aveicProd[01])
	cString += '<veicProd>'	
	cString += '<tpOp>'+ConvType(aveicProd[01])+'</tpOp>'
	cString += NfeTag('<chassi>' ,ConvType(aveicProd[02],17))
	cString += NfeTag('<cCor>'   ,ConvType(aveicProd[03],4))
	cString += NfeTag('<xCor>'   ,ConvType(aveicProd[04],40))
	cString += NfeTag('<pot>'    ,ConvType(aveicProd[05],4))
	cString += NfeTag('<cm3>'    ,ConvType(aveicProd[06],4))
	cString += NfeTag('<pesol>'  ,ConvType(aveicProd[07],9))
	cString += NfeTag('<pesob>'  ,ConvType(aveicProd[08],9))
	cString += NfeTag('<nserie>' ,ConvType(aveicProd[09],9))
	cString += NfeTag('<tpcomb>' ,ConvType(aveicProd[10],8))
	cString += NfeTag('<nmotor>' ,ConvType(aveicProd[11],21))
	cString += NfeTag('<cmkg>'   ,ConvType(aveicProd[12],9))
	cString += NfeTag('<dist>'   ,ConvType(aveicProd[13],4))
	cString += NfeTag('<renavam>',ConvType(aveicProd[14],9))
	cString += NfeTag('<anomod>' ,ConvType(aveicProd[15],4))
	cString += NfeTag('<anofab>' ,ConvType(aveicProd[16],4))
	cString += NfeTag('<tppint>' ,ConvType(aveicProd[17],1))
	cString += NfeTag('<tpveic>' ,ConvType(aveicProd[18],2))
	cString += '<espvei>'+ConvType(aveicProd[19])+'</espvei>'
	cString += NfeTag('<vin>'    ,ConvType(aveicProd[20],1))
	cString += NfeTag('<condvei>',ConvType(aveicProd[21],1))
	cString += NfeTag('<cmod>'   ,ConvType(aveicProd[22],6))
	cString += '</veicProd>'                            
EndIf 


//Medicamentos
If !Empty(aMed) .And. !Empty(aMed[01])
	cString += '<med>'	
	cString += '<Lote>'+ConvType(aMed[01],20)+'</Lote>'
	cString += NfeTag('<qLote>',ConvType(aMed[02],11,3))
	cString += NfeTag('<dtFab>',ConvType(aMed[03]))
	cString += NfeTag('<dtVal>',ConvType(aMed[04]))
	cString += NfeTag('<vPMC>' ,ConvType(aMed[05],15,2))
	cString += '</med>'                            
EndIf 

//Armas de Fogo
If !Empty(aArma) .And. !Empty(aArma[01])
	cString += '<arma>'	
	cString += '<tpArma>'+ConvType(aArma[01])+'</tpArma>'
	cString += NfeTag('<nSerie>',ConvType(aArma[02],9))
	cString += NfeTag('<nCano>' ,ConvType(aArma[02],9))
	cString += NfeTag('<descr>' ,ConvType(aArma[03],256))
	cString += '</arma>'                            
EndIf 


cString += '</prod>'
cString += '<imposto>'
cString += '<codigo>ICMS</codigo>'
If Len(aIcms)>0	
	cString += '<cpl>'
	cString += '<orig>'+ConvType(aICMS[01])+'</orig>'
	cString += '</cpl>'
	cString += '<Tributo>'
	cString += '<CST>'+ConvType(aICMS[02])+'</CST>'	
	cString += '<modBC>'+ConvType(aICMS[03])+'</modBC>'
	cString += '<pRedBC>'+ConvType(aICMS[04],5,2)+'</pRedBC>'
	cString += '<vBC>'+ConvType(aICMS[05],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aICMS[06],5,2)+'</aliquota>'
	cString += '<valor>'+ConvType(aICMS[07],15,2)+'</valor>'
	cString += '<qtrib>'+ConvType(aICMS[09],16,4)+'</qtrib>'
	cString += '<vltrib>'+ConvType(aICMS[10],15,4)+'</vltrib>'
	cString += '</Tributo>'
Else
	cString += '<cpl>'
	cString += '<orig>'+ConvType(aCST[02])+'</orig>'
	cString += '</cpl>'
	cString += '<Tributo>'
	cString += '<CST>'+ConvType(aCST[01])+'</CST>'	
	cString += '<modBC>'+ConvType(3)+'</modBC>'
	cString += '<pRedBC>'+ConvType(0,5,2)+'</pRedBC>'
	cString += '<vBC>'+ConvType(0,15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(0,5,2)+'</aliquota>'
	cString += '<valor>'+ConvType(0,15,2)+'</valor>'
	cString += '<qtrib>'+ConvType(0,16,4)+'</qtrib>'
	cString += '<vltrib>'+ConvType(0,15,4)+'</vltrib>'
	cString += '</Tributo>'
EndIf
cString += '</imposto>'
If Len(aIcmsST)>0	
	Do Case
		Case aICMSST[03] == "0"
			aICMSST[03] := "4"
		Case aICMSST[03] == "1"
			aICMSST[03] := "5"
		OtherWise
			aICMSST[03] := "0"
	EndCase

	cString += '<imposto>'
	cString += '<codigo>ICMSST</codigo>'
	cString += '<cpl>'
	cString += '<pmvast>'+ConvType(aICMSST[08],5,2)+'</pmvast>'
	cString += '</cpl>'
	cString += '<Tributo>'
	cString += '<CST>'+ConvType(aICMSST[02])+'</CST>'	
	cString += '<modBC>'+ConvType(aICMSST[03])+'</modBC>'
	cString += '<pRedBC>'+ConvType(aICMSST[04],5,2)+'</pRedBC>'
	cString += '<vBC>'+ConvType(aICMSST[05],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aICMSST[06],5,2)+'</aliquota>'
	cString += '<valor>'+ConvType(aICMSST[07],15,2)+'</valor>'
	cString += '<qtrib>'+ConvType(aICMSST[09],16,4)+'</qtrib>'
	cString += '<vltrib>'+ConvType(aICMSST[10],15,4)+'</vltrib>'
	cString += '</Tributo>'
	cString += '</imposto>'
ELse
	cString += '<imposto>'
	cString += '<codigo>ICMSST</codigo>'
	cString += '<cpl>'
	cString += '<pmvast>0</pmvast>'
	cString += '</cpl>'
	cString += '<Tributo>'
	cString += '<CST>'+ConvType(aCST[01])+'</CST>'          
	cString += '<modBC>0</modBC>'
	cString += '<pRedBC>'+ConvType(0,5,2)+'</pRedBC>'
	cString += '<vBC>'+ConvType(0,15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(0,5,2)+'</aliquota>'
	cString += '<valor>'+ConvType(0,15,2)+'</valor>'
	cString += '<qtrib>'+ConvType(0,16,4)+'</qtrib>'
	cString += '<vltrib>'+ConvType(0,15,4)+'</vltrib>'
	cString += '</Tributo>'
	cString += '</imposto>'
EndIf
If Len(aIPI)>0 
	cString += '<imposto>'
	cString += '<codigo>IPI</codigo>'
	cString += '<cpl>'
	cString += NfeTag('<clEnq>',ConvType(AIPI[01]))
	cString += NfeTag('<cSelo>',ConvType(AIPI[02]))
	cString += NfeTag('<qSelo>',ConvType(AIPI[03]))
	cString += NfeTag('<cEnq>' ,ConvType(AIPI[04]))
	cString += '</cpl>'
	cString += '<Tributo>'
	cString += '<CST>'+ConvType(AIPI[05])+'</CST>'
	cString += '<modBC>'+ConvType(AIPI[11])+'</modBC>'
	cString += '<pRedBC>'+ConvType(AIPI[12],5,2)+'</pRedBC>'
	cString += '<vBC>'  +ConvType(AIPI[06],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(AIPI[09],5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(AIPI[08],15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(AIPI[07],16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(AIPI[10],15,2)+'</valor>'
	cString += '</Tributo>'
	cString += '</imposto>'
EndIf
cString += '<imposto>'
cString += '<codigo>PIS</codigo>'
If Len(aPIS)>0
	cString += '<Tributo>'
	cString += '<CST>'+aPIS[01]+'</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(aPIS[02],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aPIS[03],5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(aPIS[06],15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(aPIS[05],16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(aPIS[04],15,2)+'</valor>'
	cString += '</Tributo>'
Else
	cString += '<Tributo>'
	cString += '<CST>'+(IIF(Len(aPisAlqZ)>0 .And. aPisAlqZ[01]=="06",aPisAlqZ[01],"08"))+'</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(0,15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(0,5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(0,15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(0,16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(0,15,2)+'</valor>'
	cString += '</Tributo>'
EndIf
cString += '</imposto>'
If Len(aPISST)>0
	cString += '<imposto>'
	cString += '<codigo>PISST</codigo>'
	cString += '<Tributo>'
	cString += '<CST>'+aPISST[01]+'</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(aPISST[02],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aPISST[03],5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(aPISST[06],15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(aPISST[05],16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(aPISST[04],15,2)+'</valor>'
	cString += '</Tributo>'
	cString += '</imposto>'
EndIf
cString += '<imposto>'
cString += '<codigo>COFINS</codigo>'
If Len(aCOFINS)>0
	cString += '<Tributo>'
	cString += '<CST>'+aCOFINS[01]+'</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(aCOFINS[02],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aCOFINS[03],5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(aCOFINS[06],15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(aCOFINS[05],16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(aCOFINS[04],15,2)+'</valor>'
	cString += '</Tributo>'
Else
	cString += '<Tributo>'
	cString += '<CST>'+(IIF(Len(aCofAlqZ)>0 .And. aCofAlqZ[01]=="06",aCofAlqZ[01],"08"))+'</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(0,15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(0,5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(0,15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(0,16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(0,15,2)+'</valor>'
	cString += '</Tributo>'
EndIf
cString += '</imposto>'
If Len(aCOFINSST)>0
	cString += '<imposto>'
	cString += '<codigo>COFINSST</codigo>'	
	cString += '<Tributo>'
	cString += '<CST>'+aCOFINSST[01]+'</CST>'
	cString += '<modBC></modBC>'
	cString += '<pRedBC></pRedBC>'
	cString += '<vBC>'+ConvType(aCOFINSST[02],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aCOFINSST[03],5,2)+'</aliquota>'
	cString += '<vlTrib>'+ConvType(aCOFINSST[06],15,4)+'</vlTrib>'
	cString += '<qTrib>'+ConvType(aCOFINSST[05],16,4)+'</qTrib>'
	cString += '<valor>'+ConvType(aCOFINSST[04],15,2)+'</valor>'
	cString += '</Tributo>'
	cString += '</imposto>'
EndIf

If Len(aISSQN)>0
	cString += '<imposto>'
	cString += '<codigo>ISS</codigo>'
	cString += '<Tributo>'		
	cString += '<vBC>'+ConvType(aISSQN[01],15,2)+'</vBC>'
	cString += '<aliquota>'+ConvType(aISSQN[02],5,2)+'</aliquota>'
	cString += '<Valor>'+ConvType(aISSQN[03],15,4)+'</Valor>'
	cString += '</Tributo>'
	cString += '<cpl>'
	cString += '<cmunfg>'+aISSQN[04]+'</cmunfg>'	
	cString += '<clistserv>'+aISSQN[05]+'</clistserv>'	 	
	cString += '</cpl>'		
	cString += '</imposto>'
EndIf

// Tratamento de imposto de importacao quando 
If Len(aDI)>0 .And. !Empty(aAdi[17][03])
	cString += '<imposto>'
	cString += '<codigo>II</codigo>'
	cString += '<Tributo>'
	cString += '<vBC>'      +ConvType(aDI[17][03],15,2)+'</vBC>'
	cString += '<Valor>'    +ConvType(aDI[19][03],15,2)+'</Valor>'
	cString += '</Tributo>'			
	cString += '<cpl>'
	cString += '<vDespAdu>' +ConvType(aDI[18][03],15,2)+'</vDespAdu>'
	cString += '<vIOF>'     +ConvType(aDI[20][03],15,2)+'</vIOF>'
	cString += '</cpl>'						
	cString += '</imposto>'
EndIf
cString += NfeTag('<infadprod>',ConvType(""))
cString += '</det>'
Return(cString)

Static Function NfeTotal(aTotal,aRet)

Local cString:=""
Local nX     := 0

cString += '<total>'
cString += '<vBcst>1000.00</vBcst>' 
cString += '<vSt>51.00</vSt>' 
cString += '<despesa>'+ConvType(aTotal[01],15,2)+'</despesa>'
cString += '<vNF>'+ConvType(aTotal[02],15,2)+'</vNF>'
If Len(aRet)>0
	For nX := 1 To Len(aRet)
		cString += '<TributoRetido>'
		cString += NfeTag('<codigo>' ,ConvType(aRet[nX,01],15,2))
		cString += NfeTag('<BC>'     ,ConvType(aRet[nX,02],15,2))
		cString += NfeTag('<valor>',ConvType(aRet[nX,03],15,2))
		cString += '</TributoRetido>'
	Next nX
EndIf
cString += '</total>'
Return(cString)

Static Function NfeTransp(cModFrete,aTransp,aImp,aVeiculo,aReboque,aVol)
           
Local nX := 0
Local cString := ""

DEFAULT aTransp := {}
DEFAULT aImp    := {}
DEFAULT aVeiculo:= {}
DEFAULT aReboque:= {}
DEFAULT aVol    := {}

cString += '<transp>'
cString += '<modFrete>'+cModFrete+'</modFrete>'
If Len(aTransp)>0
	cString += '<transporta>'
		If Len(aTransp[01])==14
			cString += NfeTag('<CNPJ>',aTransp[01])
		ElseIf Len(aTransp[01])<>0
			cString += NfeTag('<CPF>',aTransp[01])
		EndIf
		cString += NfeTag('<Nome>' ,ConvType(aTransp[02]))
		cString += NfeTag('<IE>'    ,aTransp[03])
		cString += NfeTag('<Ender>',ConvType(aTransp[04]))
		cString += NfeTag('<Mun>'  ,ConvType(aTransp[05]))
		cString += NfeTag('<UF>'    ,ConvType(aTransp[06]))
	cString += '</transporta>'
	If Len(aImp)>0 //Ver Fisco
		cString += '<retTransp>'
		cString += '<codigo>ICMS<codigo>'
		cString += '<Cpl>'
		cString += '<vServ>'+ConvType(aImp[01],15,2)+'</vServ>'
		cString += '<CFOP>'+ConvType(aImp[02])+'</CFOP>'
		cString += '<cMunFG>'+aImp[03]+'</cMunFG>'		
		cString += '</Cpl>'
		cString += '<CST>'+aImp[04]+'</CST>'
		cString += '<MODBC>'+aImp[05]+'</MODBC>'
		cString += '<PREDBC>'+ConvType(aImp[06],5,2)+'</PREDBC>'
		cString += '<VBC>'+ConvType(aImp[07],15,2)+'</VBC>'
		cString += '<aliquota>'+ConvType(aImp[08],5,2)+'</aliquota>'
		cString += '<vltrib>'+ConvType(aImp[09],15,4)+'</vltrib>'
		cString += '<qtrib>'+ConvType(aImp[10],16,4)+'</qtrib>'
		cString += '<valor>'+ConvType(aImp[11],15,2)+'</valor>'
		cString += '</retTransp>'
	EndIf
	If Len(aVeiculo)>0
		cString += '<veicTransp>'
			cString += '<placa>'+ConvType(aVeiculo[01])+'</placa>'
			cString += '<UF>'   +ConvType(aVeiculo[02])+'</UF>'
			cString += NfeTag('<RNTC>',ConvType(aVeiculo[03]))
		cString += '</veicTransp>'
	EndIf
	If Len(aReboque)>0
		cString += '<reboque>'
			cString += '<placa>'+ConvType(aReboque[01])+'</placa>'
			cString += '<UF>'   +ConvType(aReboque[02])+'</UF>'
			cString += NfeTag('<RNTC>',ConvType(aReboque[03]))
		cString += '</reboque>'
	EndIf	
EndIf
For nX := 1 To Len(aVol)		
	cString += '<vol>'
		cString += NfeTag('<qVol>',ConvType(aVol[nX][02]))
		cString += NfeTag('<esp>' ,ConvType(aVol[nX][01],15,0))
		//cString += '<marca>' +aVol[03]+'</marca>'
		//cString += '<nVol>'  +aVol[04]+'</nVol>'
		cString += NfeTag('<pesoL>' ,ConvType(aVol[nX][03],15,3))
		cString += NfeTag('<pesoB>' ,ConvType(aVol[nX][04],15,3))
		//cString += '<nLacre>'+aVol[07]+'</nLacre>'
	cString += '</vol>
Next nX
cString += '</transp>'
Return(cString)

Static Function NfeCob(aDupl)

Local cString := ""

Local nX := 0                  
If Len(aDupl)>0
	cString += '<cobr>'
	For nX := 1 To Len(aDupl)
		cString += '<dup>'
		cString += '<Dup>'+ConvType(aDupl[nX][01])+'</Dup>'
		cString += '<dtVenc>'+ConvType(aDupl[nX][02])+'</dtVenc>'
		cString += '<vDup>'+ConvType(aDupl[nX][03],15,2)+'</vDup>'
		cString += '</dup>'
	Next nX	
	cString += '</cobr>'
EndIf

Return(cString)

Static Function NfeInfAd(cMsgCli,cMsgFis,aPedido,aExp)

Local cString   := ""
DEFAULT aPedido := {}
DEFAULT aExp	:= {}

cString += '<infAdic>'
cString += '<Cpl>[ContrTSS='+StrZero(Year(ddatabase),4)+'-'+StrZero(Month(ddatabase),2)+'-'+StrZero(Day(ddatabase),2)+'#'+AllTrim(Time())+'#'+AllTrim(SubStr(cUsuario,7,15))+']'
//cString += '<Cpl>'
If Len(cMsgFis)>0 .Or. Len(cMsgCli)>0
	If Len(cMsgFis)>0
		cString += '<Fisco>'+ConvType(cMsgFis,Len(cMsgFis))+'</Fisco>'
	EndIf

	If Len(cMsgCli)>0
		cString += ConvType(cMsgCli,Len(cMsgCli))
	EndIf
EndIf
cString += '</Cpl>'
cString += '</infAdic>'

// Tratamento TAG ExportaÁ„o integraÁ„o com EEC Average 
If Len(aExp)>0 .And. !Empty(aExp[01])
	cString += '<exporta>'
	cString += '<UFEmbarq>'+ConvType(aExp[01][01][03])+ '</UFEmbarq>'
	cString += '<locembarq>'+ConvType(aExp[01][02][03])+ '</locembarq>'
	cString += '</exporta>'	
EndIf

If Len(aPedido)>0
	cString += '<compra>'
	cString += '<nEmp>'+aPedido[01]+'</nEmp>'
	cString += '<Pedido>'+aPedido[02]+'</Pedido>'
	cString += '<Contrato>'+aPedido[03]+'</Contrato>'
	cString += '</compra>'
EndIf	

Return(cString)

Static Function ConvType(xValor,nTam,nDec)

Local cNovo := ""
DEFAULT nDec := 0
Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))	
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 60
		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))
EndCase
Return(cNovo)

Static Function Inverte(uCpo)

Local cCpo	:= uCpo
Local cRet	:= ""
Local cByte	:= ""
Local nAsc	:= 0
Local nI		:= 0
Local aChar	:= {}
Local nDiv	:= 0


Aadd(aChar,	{"0", "9"})
Aadd(aChar,	{"1", "8"})
Aadd(aChar,	{"2", "7"})
Aadd(aChar,	{"3", "6"})
Aadd(aChar,	{"4", "5"})
Aadd(aChar,	{"5", "4"})
Aadd(aChar,	{"6", "3"})
Aadd(aChar,	{"7", "2"})
Aadd(aChar,	{"8", "1"})
Aadd(aChar,	{"9", "0"})

For nI:= 1 to Len(cCpo)
   cByte := Upper(Subs(cCpo,nI,1))
   If (Asc(cByte) >= 48 .And. Asc(cByte) <= 57) .Or. ;	// 0 a 9
   		(Asc(cByte) >= 65 .And. Asc(cByte) <= 90) .Or. ;	// A a Z
   		Empty(cByte)	// " "
	   nAsc	:= Ascan(aChar,{|x| x[1] == cByte})
   	If nAsc > 0
   		cRet := cRet + aChar[nAsc,2]	// Funcao Inverte e chamada pelo rdmake de conversao
	   EndIf
	Else
		// Caracteres <> letras e numeros: mantem o caracter
		cRet := cRet + cByte
	EndIf
Next
Return(cRet)

Static Function NfeTag(cTag,cConteudo)

Local cRetorno := ""
If (!Empty(AllTrim(cConteudo)) .And. IsAlpha(AllTrim(cConteudo))) .Or. Val(AllTrim(cConteudo))<>0
	cRetorno := cTag+AllTrim(cConteudo)+SubStr(cTag,1,1)+"/"+SubStr(cTag,2)
EndIf
Return(cRetorno)

Static Function VldIE(cInsc,lContr)

Local cRet	:=	""
Local nI	:=	1
DEFAULT lContr  :=      .T.
For nI:=1 To Len(cInsc)
	If Isdigit(Subs(cInsc,nI,1)) .Or. IsAlpha(Subs(cInsc,nI,1))
		cRet+=Subs(cInsc,nI,1)
	Endif
Next
cRet := AllTrim(cRet)
If "ISENT"$Upper(cRet)
	cRet := ""
EndIf
If lContr .And. Empty(cRet)
	cRet := "ISENTO"
EndIf
If !lContr
	cRet := ""
EndIf
Return(cRet)


static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "·ÈÌÛ˙"+"¡…Õ”⁄"
Local cCircu := "‚ÍÓÙ˚"+"¬ Œ‘€"
Local cTrema := "‰ÎÔˆ¸"+"ƒÀœ÷‹"
Local cCrase := "‡ËÏÚ˘"+"¿»Ã“Ÿ" 
Local cTio   := "„ı"
Local cCecid := "Á«"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123 .Or. cChar $ '&'
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
cString := _NoTags(cString)
Return cString

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥MyGetEnd  ≥ Autor ≥ Liber De Esteban             ≥ Data ≥ 19/03/09 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Verifica se o participante e do DF, ou se tem um tipo de endereco ≥±±
±±≥          ≥ que nao se enquadra na regra padrao de preenchimento de endereco  ≥±±
±±≥          ≥ por exemplo: Enderecos de Area Rural (essa verificÁ„o e feita     ≥±±
±±≥          ≥ atraves do campo ENDNOT).                                         ≥±±
±±≥          ≥ Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ≥±±
±±≥          ≥ Endereco (sem numero ou complemento). Caso contrario ira retornar ≥±±
±±≥          ≥ o padrao do FisGetEnd                                             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Obs.     ≥ Esta funcao so pode ser usada quando ha um posicionamento de      ≥±±
±±≥          ≥ registro, pois ser· verificado o ENDNOT do registro corrente      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGAFIS                                                           ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function MyGetEnd(cEndereco,cAlias)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}

//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
	aRet[1] := cEndereco
	aRet[3] := "SN"
Else
	aRet := FisGetEnd(cEndereco)
EndIf

Return aRet


Static Function NFSeIde(aNotaServ,cNatOper,cTipoRPS,cModXml)
Local cString  := ""
Local cRegTrib := ""
Local cOptSimp := ""
Local cIncCult := ""

If "1"$cModXml //BH - ABRASF
	cString += '<InfRps>'
	cString += '<IdentificacaoRps>'
	cString += '<Numero>'+ConvType(Val(aNotaServ[02]),15)+'</Numero>'
	cString += '<Serie>'+AllTrim(aNotaServ[01])+'</Serie>'             
	cString += '<Tipo>'+cTipoRPS+'</Tipo>'
	cString += '</IdentificacaoRps>' 
	cString += '<DataEmissao>'+ConvType(aNotaServ[03])+"T"+Time()+'</DataEmissao>
	cString += '<NaturezaOperacao>'+cNatOper+'</NaturezaOperacao>'
	cString += '<RegimeEspecialTributacao>'+cRegTrib+'</RegimeEspecialTributacao>'
	cString += '<OptanteSimplesNacional>'+cOptSimp+'</OptanteSimplesNacional>'
	cString += '<IncentivadorCultural>'+cIncCult+'</IncentivadorCultural>'
	cString += '<Status>'+"1"+'</Status>'
	//cString += '<RpsSubstituido>'
	//cString += '<Numero>'+ConvType(Val(aNotaServ[02]),15)+'</Numero>'
	//cString += '<Serie>'+AllTrim(aNotaServ[01])+'</Serie>'             
	//cString += '<Tipo>'+cTipoRPS+'</Tipo>'
	//cString += '</RpsSubstituido>' 
	
Else//ISSNET
	cString += '<tc:InfRps>'
	cString += '<tc:IdentificacaoRps>'
	cString += '<tc:Numero>'+ConvType(Val(aNotaServ[02]),15)+'</tc:Numero>'
	//cString += '<tc:Serie>'+'8'+'</tc:Serie>'             
	cString += '<tc:Serie>'+AllTrim(aNotaServ[01])+'</tc:Serie>'             
	cString += '<tc:Tipo>'+cTipoRPS+'</tc:Tipo>'
	cString += '</tc:IdentificacaoRps>' 
	cString += '<tc:DataEmissao>'+ConvType(aNotaServ[03])+"T"+Time()+'</tc:DataEmissao>
	cString += '<tc:NaturezaOperacao>'+cNatOper+'</tc:NaturezaOperacao>'
	cString += '<tc:RegimeEspecialTributacao>'+cRegTrib+'</tc:RegimeEspecialTributacao>'
	cString += '<tc:OptanteSimplesNacional>'+cOptSimp+'</tc:OptanteSimplesNacional>'
	cString += '<tc:IncentivadorCultural>'+cIncCult+'</tc:IncentivadorCultural>'
	cString += '<tc:Status>'+"1"+'</tc:Status>'
	//cString += '<tc:RpsSubstituido>'
	//cString += '<tc:Numero>'+ConvType(Val(aNotaServ[02]),15)+'</tc:Numero>'
	//cString += '<tc:Serie>'+AllTrim(aNotaServ[01])+'</tc:Serie>'             
	//cString += '<tc:Tipo>'+cTipoRPS+'</tc:Tipo>'
	//cString += '</tc:RpsSubstituido>' 
EndIf
Return( cString )

Static Function NFSeServ(aISSQN,aRet,nDed,nIssRet,cRetIss,cServ,cMunPres,cModXml)
Local cString    := ""
Local nBase      := 0
Local nValLiq    := 0
Local nOutRet    := 0

//Base de C·lculo 
nBase      := aISSQN[02]-nDed-aISSQN[06]
//Valor LÌquido
nValLiq    := aISSQN[02]-aRet[06]-aISSQN[06]
//Outras retenÁıes
nOutRet    := aRet[06]-aRet[05]-aRet[04]-aRet[03]-aRet[02]-aRet[01]-nIssRet

If "1"$cModXml //BH - ABRASF
	cString += '<Servico>'
	cString += '<Valores>'
	cString += '<ValorServicos>'+ConvType(aISSQN[02],15,2)+'</ValorServicos>'
	cString += NfeTag('<ValorDeducoes>',ConvType(nDed,15,2))
	cString += NfeTag('<ValorPis>',ConvType(aRet[03],15,2))
	cString += NfeTag('<ValorCofins>',ConvType(aRet[04],15,2))
	cString += NfeTag('<ValorInss>',ConvType(aRet[05],15,2))
	cString += NfeTag('<ValorIr>',ConvType(aRet[01],15,2))
	cString += NfeTag('<ValorCsll>',ConvType(aRet[02],15,2))
	cString += '<IssRetido>'+cRetIss+'</IssRetido>'
	cString += NfeTag('<ValorIss>',ConvType((aISSQN[05]),15,2))
	cString += NfeTag('<ValorIssRetido>',ConvType(nIssRet,15,2))
	cString += NfeTag('<OutrasRetencoes>',ConvType(nOutRet,15,2))
	cString += '<BaseCalculo>'+ConvType(nBase,15,2)+'</BaseCalculo>'
	cString += NfeTag('<Aliquota>',ConvType(aISSQN[04],5,2))
	cString += NfeTag('<ValorLiquidoNfse>',ConvType(nValLiq,15,2))
	cString += NfeTag('<DescontoIncondicionado>',ConvType((aISSQN[06]),15,2))
	//cString += '<DescontoCondicionado>'++'</DescontoCondicionado>'
	cString += '</Valores>'
	//cString += '<ItemListaServico>'+ConvType(StrTran(aISSQN[01],".",""),4)+'</ItemListaServico>'
	cString += '<ItemListaServico>'+ConvType(aISSQN[01],5)+'</ItemListaServico>'
	cString += NfeTag('<CodigoCnae>',ConvType(aISSQN[03],7))
	//cString += '<CodigoTributacaoMunicipio>'+'710'+'</CodigoTributacaoMunicipio>'
	cString += '<CodigoTributacaoMunicipio>'+ConvType(aISSQN[07],20)+'</CodigoTributacaoMunicipio>'
	cString += '<Discriminacao>'+ConvType(cServ,2000)+'</Discriminacao>'
	cString += '<CodigoMunicipio>'+ConvType(cMunPres,7)+'</CodigoMunicipio>'
	cString += '</Servico>'
	
Else //ISSNET
	cString += '<tc:Servico>'
	cString += '<tc:Valores>'
	cString += '<tc:ValorServicos>'+ConvType(aISSQN[02],15,2)+'</tc:ValorServicos>'
	cString += NfeTag('<tc:ValorDeducoes>',ConvType(nDed,15,2))
	cString += NfeTag('<tc:ValorPis>',ConvType(aRet[03],15,2))
	cString += NfeTag('<tc:ValorCofins>',ConvType(aRet[04],15,2))
	cString += NfeTag('<tc:ValorInss>',ConvType(aRet[05],15,2))
	cString += NfeTag('<tc:ValorIr>',ConvType(aRet[01],15,2))
	cString += NfeTag('<tc:ValorCsll>',ConvType(aRet[02],15,2))
	cString += '<tc:IssRetido>'+cRetIss+'</tc:IssRetido>'
	cString += NfeTag('<tc:ValorIss>',ConvType((aISSQN[05]),15,2))
	cString += NfeTag('<tc:ValorIssRetido>',ConvType(nIssRet,15,2))
	cString += NfeTag('<tc:OutrasRetencoes>',ConvType(nOutRet,15,2))
	cString += '<tc:BaseCalculo>'+ConvType(nBase,15,2)+'</tc:BaseCalculo>'
	cString += NfeTag('<tc:Aliquota>',ConvType(aISSQN[04],5,2))
	cString += NfeTag('<tc:ValorLiquidoNfse>',ConvType(nValLiq,15,2))
	cString += NfeTag('<tc:DescontoIncondicionado>',ConvType((aISSQN[06]),15,2))
	//cString += '<tc:DescontoCondicionado>'++'</tc:DescontoCondicionado>'
	cString += '</tc:Valores>'
	//cString += '<tc:ItemListaServico>'+ConvType(StrTran(aISSQN[01],".",""),4)+'</tc:ItemListaServico>'
	cString += '<tc:ItemListaServico>'+ConvType(aISSQN[01],5)+'</tc:ItemListaServico>'
	cString += NfeTag('<tc:CodigoCnae>',ConvType(aISSQN[03],7))
	//cString += '<tc:CodigoTributacaoMunicipio>'+'710'+'</tc:CodigoTributacaoMunicipio>'
	cString += '<tc:CodigoTributacaoMunicipio>'+ConvType(aISSQN[07],20)+'</tc:CodigoTributacaoMunicipio>'
	cString += '<tc:Discriminacao>'+ConvType(cServ,2000)+'</tc:Discriminacao>'
	cString += '<tc:MunicipioPrestacaoServico>'+ConvType(cMunPres,7)+'</tc:MunicipioPrestacaoServico>'
	cString += '</tc:Servico>'
EndIf
Return(cString)

Static Function NFSePrest(cModXml)
Local cString    := ""

If "1"$cModXml //BH - ABRASF
	cString +='<Prestador>'
	cString += '<Cnpj>'+SM0->M0_CGC+'</Cnpj>'
	cString += NfeTag('<InscricaoMunicipal>',ConvType(SM0->M0_INSCM))
	cString +='</Prestador>'
Else //ISSNET
	cString +='<tc:Prestador>'
	cString +='<tc:CpfCnpj>'
	cString += '<tc:Cnpj>'+SM0->M0_CGC+'</tc:Cnpj>'
	cString +='</tc:CpfCnpj>'
	cString += NfeTag('<tc:InscricaoMunicipal>',ConvType(SM0->M0_INSCM))
	cString +='</tc:Prestador>'
EndIf
Return(cString)

Static Function NFSeTom(aDest,cModXml)
Local cCPFCNPJ :=""
Local cInscMun :=""
Local cString  :=""

//Identifica Tipo
If RetPessoa(AllTrim(SA2->A2_CGC))=="J"
	cCPFCNPJ:="2"
Else
	cCPFCNPJ:="1"
EndIf
//Identifica Inscricao
If AllTrim(aDest[07])==AllTrim(SM0->M0_CODMUN)
	cInscMun:=aDest[11]
EndIf

If "1"$cModXml //BH - ABRASF
	cString +='<Tomador>'
	cString +='<IdentificacaoTomador>'
	//Estrangeiro n„o manda a tag de CPFCNPJ
	If !"EX"$aDest[08]
		cString +='<CpfCnpj>'
			If "2"$cCPFCNPJ
				cString += NfeTag('<Cnpj>',ConvType(aDest[01]))
			Else
				cString += NfeTag('<Cpf>',ConvType(aDest[01]))
			EndIf
		cString +='</CpfCnpj>'
	EndIf
	cString += NfeTag('<InscricaoMunicipal>',ConvType(cInscMun))
	cString +='</IdentificacaoTomador>'
	cString += NfeTag('<RazaoSocial>',ConvType(aDest[02],115))
	
	cString +='<Endereco>'
	cString += NfeTag('<Endereco>',ConvType(aDest[03],125))
	cString += NfeTag('<Numero>',ConvType(aDest[04],10))
	cString += NfeTag('<Complemento>',ConvType(aDest[05],60))
	cString += NfeTag('<Bairro>',ConvType(aDest[06],60))
	cString += NfeTag('<CodigoMunicipio>',ConvType(aUF[aScan(aUF,{|x| x[1] == aDest[08]})][02]+aDest[07]))
	cString += NfeTag('<Uf>',ConvType(aDest[08]))
	cString += NfeTag('<Cep>',ConvType(aDest[09]))
	cString +='</Endereco>'
	
	cString +='<Contato>'
	cString += NfeTag('<Telefone>',ConvType(aDest[10],11))
	cString += NfeTag('<Email>',ConvType(aDest[12],80))
	cString +='</Contato>'
	cString +='</Tomador>'
	
	//cString +='<Intermediario>'
	//cString += '<RazaoSocial>'+'</RazaoSocial>'
	//cString +='<CpfCnpj>'
	//cString += '<Cpf>'+'</Cpf>'
	//cString += '<Cnpj>'+'</Cnpj>'
	//cString +='</CpfCnpj>'
	//cString += '<InscricaoMunicipal>'+'</InscricaoMunicipal>'
	//cString +='</Intermediario>'
	
	//cString +='<Construcao>'
	//cString += '<CodigoObra>'+'</CodigoObra>'
	//cString += '<Art>'+'</Art>'  
	//cString +='</Construcao>'
	cString +='</InfRps>'
	
Else //ISSNET
	cString +='<tc:Tomador>'
	cString +='<tc:IdentificacaoTomador>'
	//Estrangeiro n„o manda a tag de CPFCNPJ
	If !"EX"$aDest[08]
		cString +='<tc:CpfCnpj>'
			If "2"$cCPFCNPJ
				cString += NfeTag('<tc:Cnpj>',ConvType(aDest[01]))
			Else
				cString += NfeTag('<tc:Cpf>',ConvType(aDest[01]))
			EndIf
		cString +='</tc:CpfCnpj>'
	EndIf
	cString += NfeTag('<tc:InscricaoMunicipal>',ConvType(cInscMun))
	cString +='</tc:IdentificacaoTomador>'
	cString += NfeTag('<tc:RazaoSocial>',ConvType(aDest[02],115))
	
	cString +='<tc:Endereco>'
	cString += NfeTag('<tc:Endereco>',ConvType(aDest[03],125))
	cString += NfeTag('<tc:Numero>',ConvType(aDest[04],10))
	cString += NfeTag('<tc:Complemento>',ConvType(aDest[05],60))
	cString += NfeTag('<tc:Bairro>',ConvType(aDest[06],60))
	//cString += NfeTag('<tc:Cidade>','999')
	cString += NfeTag('<tc:Cidade>',ConvType(aUF[aScan(aUF,{|x| x[1] == aDest[08]})][02]+aDest[07]))
	cString += NfeTag('<tc:Estado>',ConvType(aDest[08]))
	cString += NfeTag('<tc:Cep>',ConvType(aDest[09]))
	cString +='</tc:Endereco>'
	
	cString +='<tc:Contato>'
	cString += NfeTag('<tc:Telefone>',ConvType(aDest[10],11))
	cString += NfeTag('<tc:Email>',ConvType(aDest[12],80))
	cString +='</tc:Contato>'
	cString +='</tc:Tomador>'
	
	//cString +='<tc:Intermediario>'
	//cString += '<tc:RazaoSocial>'+'</tc:RazaoSocial>'
	//cString +='<tc:CpfCnpj>'
	//cString += '<tc:Cpf>'+'</tc:Cpf>'
	//cString += '<tc:Cnpj>'+'</tc:Cnpj>'
	//cString +='</tc:CpfCnpj>'
	//cString += '<tc:InscricaoMunicipal>'+'</tc:InscricaoMunicipal>'
	//cString +='</tc:Intermediario>'
	
	//cString +='<tc:Construcao>'
	//cString += '<tc:CodigoObra>'+'</tc:CodigoObra>'
	//cString += '<tc:Art>'+'</tc:Art>'  
	//cString +='</tc:Construcao>'
	cString +='</tc:InfRps>'
EndIf
Return(cString)


Static Function GetMsgNota(cTpNf,lAddMsg)
*********************************************************************************************
*
*****
Local cRet     := ''
Local cAuxi    := ''
Local nLinAuxi := 0

If cTpNf == 'S' .and. lAddMsg // Nota de saida

   SZ1->(dbSetOrder(1))
   SZ1->(dbSeek(xFilial("SZ1")+SC5->C5_CONTRATO))
	
   SM4->(dbSetOrder(1))
   SM4->(dbSeek(xFilial("SM4")+SC5->C5_MENPAD))
   
   cRet := Padr("Contrato: "+SC5->C5_CONTRATO+"-"+SZ1->Z1_NOME,MAXMENLIN)
   cRet += Padr("Obra: "+SZ1->Z1_CONTA+"-"+SZ1->Z1_NOMCONTA,MAXMENLIN)
   cRet += Padr("Cliente: "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI,MAXMENLIN)
   If !SM4->(eof())
      cAuxi := Alltrim(SM4->M4_FORMULA) // quebrar esta msg em 62 digitos
      If !Empty(cAuxi)
         nLinAuxi := Iif((Len(cAuxi) / MAXMENLIN) -int(Len(cAuxi) / MAXMENLIN) == 0,Len(cAuxi) / MAXMENLIN,INT((Len(cAuxi) / MAXMENLIN))+1)
         For nXi := 1 To nLinAuxi
             cRet += Padr(SubStr(cAuxi,((nXi-1)*MAXMENLIN)+1,MAXMENLIN),MAXMENLIN)
         Next nXi
         
      EndIf
   EndIf
   If !Empty(Alltrim(SC5->C5_REFER))
      cAuxi := Alltrim(SC5->C5_REFER)
      nLinAuxi := Iif((Len(cAuxi) / MAXMENLIN) -int(Len(cAuxi) / MAXMENLIN) == 0,Len(cAuxi) / MAXMENLIN,INT((Len(cAuxi) / MAXMENLIN))+1)
      For nXi := 1 To nLinAuxi
          cRet += Padr(SubStr(cAuxi,((nXi-1)*MAXMENLIN)+1,MAXMENLIN),MAXMENLIN)
      Next nXi
   EndIf
   If !Empty(Alltrim(SC5->C5_MENNOT2))
      cAuxi := Alltrim(SC5->C5_MENNOT2)
      nLinAuxi := Iif((Len(cAuxi) / MAXMENLIN) -int(Len(cAuxi) / MAXMENLIN) == 0,Len(cAuxi) / MAXMENLIN,INT((Len(cAuxi) / MAXMENLIN))+1)
      For nXi := 1 To nLinAuxi
          cRet += Padr(SubStr(cAuxi,((nXi-1)*MAXMENLIN)+1,MAXMENLIN),MAXMENLIN)
      Next nXi
   EndIf
   If !Empty(Alltrim(SC5->C5_MENNOT3))
      cAuxi := Alltrim(SC5->C5_MENNOT3)
      nLinAuxi := Iif((Len(cAuxi) / MAXMENLIN) -int(Len(cAuxi) / MAXMENLIN) == 0,Len(cAuxi) / MAXMENLIN,INT((Len(cAuxi) / MAXMENLIN))+1)
      For nXi := 1 To nLinAuxi
          cRet += Padr(SubStr(cAuxi,((nXi-1)*MAXMENLIN)+1,MAXMENLIN),MAXMENLIN)
      Next nXi
   EndIf
   If !Empty(Alltrim(SC5->C5_MENNOT4))
      cAuxi := Alltrim(SC5->C5_MENNOT4)
      nLinAuxi := Iif((Len(cAuxi) / MAXMENLIN) -int(Len(cAuxi) / MAXMENLIN) == 0,Len(cAuxi) / MAXMENLIN,INT((Len(cAuxi) / MAXMENLIN))+1)
      For nXi := 1 To nLinAuxi
          cRet += Padr(SubStr(cAuxi,((nXi-1)*MAXMENLIN)+1,MAXMENLIN),MAXMENLIN)
      Next nXi
   EndIf




EndIf


If !Empty(cRet)
   lAddMsg := .f.
EndIf

Return(cRet)