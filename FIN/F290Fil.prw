/*
+-----------------------------------------------------------------------+
¦Programa  ¦ F290FIL  ¦ Autor ¦ Crislei de A. Toledo  ¦ Data ¦21.06.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Ponto de Entrada na rotina de Faturas a Pagar              ¦
¦          ¦ Filtrar - Data de Vencimento Real                          ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA EPC                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 |
+-----------------------------------------------------------------------+
*/
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function F290Fil()
*******************************************************************************************************************
* Ponto de Entrada para montagem do filtro
*
****
Private nISSD     :=2
Private aOpcao    := {'Sim','Não'}
Private cArqISSD  := Space(60)
Private cRet  		:= ""
Private dDataInic := CTOD("")
Private dDataFIna := CTOD("")
Private cNatInic  := Space(10)
Private cNatFina  := Space(10)
Private oCbx01

//@ 000,000 TO 180,400 DIALOG oDlg TITLE "Filtra data de vencimento dos titulos"
@ 000,000 TO 250,450 DIALOG oDlg TITLE "Filtra data de vencimento dos titulos"
//@ 005,005 TO 070,190 TITLE "Periodo de Vencimento dos titulos"
@ 005,005 TO 120,220 TITLE "Periodo de Vencimento dos titulos"
@ 025,010 SAY "Venc. Inicial: "
@ 025,060 GET dDataInic SIZE 40,70 VALID NaoVazio()
@ 025,110 SAY "Venc. Final: "
@ 025,140 GET dDataFina SIZE 40,70 VALID NaoVazio()
@ 040,010 SAY "Nat. Inicial: "
@ 040,060 GET cNatInic SIZE 40,70 VALID NaoVazio() F3 "SED"
@ 040,110 SAY "Nat. Final: "
@ 040,140 GET cNatFina SIZE 40,70 VALID NaoVazio() F3 "SED"
@ 055,010 SAY "Titulos de ISS"
@ 055,060 COMBOBOX nISSD ITEMS aOpcao SIZE 40,50 OBJECT oCbx01
@ 070,010 SAY 'Arquivo ISS'
@ 070,060 Get cArqISSD When .f. Valid If(oCbx01:Nat==1 .And. File(cArqISSD),.T.,MsgBox('Arquivo não Encontrado')) Object oGet01

@ 090,150 BMPBUTTON Type 01 ACTION Processa({|| FOk()},'Aguarde...','Lendo Arquivo Txt')

oCbx01:BChange:={|| If(oCbx01:Nat==1,GFILEISSD("cArqISSD"),.t.)}

ACTIVATE DIALOG oDlg CENTERED


Return(cRet)



Static Function FOk()
****************************************************************************************************************
* Funcao para montagem do filtro pela data de vencimento real dos titulos
*
****

Close(oDlg)

//cRet := " DTOS(E2_VENCREA) >= '" + DTOS(dDataInic) + "' .AND. DTOS(E2_VENCREA) <= '" + DTOS(dDataFina) + "' .AND. "
cRet := " E2_VENCREA >= '" + DTOS(dDataInic) + "' AND E2_VENCREA <= '" + DTOS(dDataFina) + "' AND "
cRet += " E2_NATUREZ >= '" + cNatInic + "' AND E2_NATUREZ <= '" + cNatFina + "'"


If oCbx01:Nat==1 .And. File(cArqISSD)
	cRet+=ProcISS()
Endif


Return()



Static Function GFILEISSD(cCampo)
****************************************************************************************************************
*
*
****

&cCampo:=cGetFile("Arquivo TXT| *.TXT|","Selecione o Arquivo",0,"C:\ISS\",.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
oGet01:Refresh()

Return(.T.)


Static Function ProcISS()
****************************************************************************************************************
*
*
*****
Local nFile:=Fopen(cArqISSD)
Local cRet:=""
Local nTamFile:=0
Local cBuffer:=""
Local cNFiscal:=""
Local cSerieNF:=""
Local cAliqIss:=""
Local cValIss:=""
Local cValNF :=0
Local cQuery:=" UPDATE "+RetSqlName("SE2")+" SET E2_TITISS='' WHERE E2_TITISS='X' "
Private cTipoReg :="*"
Private nbLidos:=0
Private cBuffer:=""

//Limpa os Flags dos Titulos
TcSqlExec(cQuery)

Close(oDlg)



If nFile>=0
   nTamFile:=Fseek(nFile,0,2)
   Fseek(nFile,0,0)
   While nBLidos<nTamFile .And. cTipoReg<>''
   	IncProc()
   	//lê o tipo de Registro
   	nBLidos++
   	FRead(nFile,@cBuffer,1)
   	cTipoReg:=Alltrim(@cBuffer)
   	Do Case 
			Case cTipoReg=='R'
				// Lê os demais Registros de Recolhimento
				cRegAtu:=cTipoReg
				While	cTipoReg==cRegAtu	.And. nBLidos<nTamFile
					FRead(nFile,@cBuffer,437)
					cBuffer:=cTipoReg+cBuffer
					nBLidos+=387
					//Data de Pagamento
					dDtPgto:=ctod(SubStr(@cBuffer,2,10))
					dDtEmissao:=ctod(SubStr(@cBuffer,12,10))
					cNFiscal:=SubStr(@cBuffer,29,6)
					cSerieNF:=SubStr(@cBuffer,29,6)
					cAliqIss:=SubStr(@cBuffer,56,5)
					cValNF  :=Val(SubStr(@cBuffer,35,15))
					cValIss :=cValNF*(Val(cAliqIss)/100)
					cCNPJ   :=SubStr(@cBuffer,85,14)
					If dDtPgto >=dDataDe .And. dDtPgto <=dDataAte .And. cValIss>0 .And. Substr(cBuffer,70,1)=='P';
					   .And. Substr(cBuffer,384,1)=='1' 
						//Marca os Titulos
					   FMarcaTit(cNfiscal,cCNPJ,cValIss,cValNF,'R',dDtEmissao)
					Endif					
					FRead(nFile,@cBuffer,1)
					cRegAtu:=Alltrim(@cBuffer)
					nBLidos++
				EndDo
			Case cTipoReg=='T'
				FRead(nFile,@cBuffer,361)
			Case cTipoReg=='E'
				// Lê os demais Registros de Recolhimento
				cRegAtu:=cTipoReg
				While	cTipoReg==cRegAtu	.And. nBLidos<nTamFile
					FRead(nFile,@cBuffer,386)
					cBuffer:=cTipoReg+cBuffer
					nBLidos+=386
					//Data de Pagamento
					dDtPgto:=ctod(SubStr(@cBuffer,2,10))
					dDtEmissao:=ctod(SubStr(@cBuffer,2,10))
					cNFiscal:=SubStr(@cBuffer,19,6)
					cAliqIss:=SubStr(@cBuffer,56,5)
					cValNF  :=Val(SubStr(@cBuffer,25,15))
					cValIss :=cValNF*(Val(cAliqIss)/100)
					cCNPJ   :=SubStr(@cBuffer,85,14)
					If dDtPgto >=dDataDe .And. dDtPgto <=dDataAte .And. cValIss>0 .And. Substr(cBuffer,15,1)=='A' ;
					   .And. Substr(cBuffer,61,1)=='P' 
						//Marca os Titulos
						FMarcaTit(cNfiscal,cCNPJ,cValIss,cValNF,'E',dDtEmissao)
					Endif					
					FRead(nFile,@cBuffer,1)
					cRegAtu:=Alltrim(@cBuffer)
					nBLidos++
				EndDo			   
			Case cTipoReg=='H'
				FRead(nFile,@cBuffer,593)
		EndCase	
   EndDo
   cRet:=" AND E2_TITISS='X' "
Else
	MsgBox("Erro ao abrir Arquivo:"+cArqISSD)
Endif

Return(cRet)   



Static Function FMarcaTit(cNfiscal,cCNPJ,cValIss,cValNF,cTipo,dDtEmissao)
*******************************************************************************************************************
*
*
****
Local aAreaFil:=GetArea()

If cTipo=='R'
	//Pesquisa os titulos a Pagar
	cQuery:=" SELECT SE2.R_E_C_N_O_ RECSE2 FROM "+RetSqlName("SF1")+" SF1 "
	cQuery+=" INNER JOIN "+RetSqlName("SA2")+" SA2 ON (A2_COD=F1_FORNECE AND A2_CGC='"+cCNPJ+"' AND "
	cQuery+=" SA2.D_E_L_E_T_<>'*' AND A2_FILIAL='"+Xfilial("SA2")+"') "
	cQuery+=" INNER JOIN "+RetSqlName("SE2")+" SE2 ON (E2_NUM=F1_DUPL AND E2_TIPO='ISS' AND E2_PREFIXO=F1_SERIE "
	cQuery+=" AND E2_EMISSAO=F1_EMISSAO AND SE2.D_E_L_E_T_<>'*' AND E2_FILIAL='"+Xfilial("SE2")+"') "
	cQuery+=" AND F1_EMISSAO='"+Dtos(dDtEmissao)+"'"
	cQuery+=" WHERE F1_DOC='"+cNfiscal+"' AND SF1.D_E_L_E_T_<>'*' "
Else 
	cQuery:=" SELECT SE2.R_E_C_N_O_ RECSE2 FROM "+RetSqlName("SF2")+" SF2 "
	cQuery+=" INNER JOIN "+RetSqlName("SE2")+" SE2 ON (E2_NUM=F2_DUPL AND E2_EMISSAO=F2_EMISSAO AND "
	cQuery+="   E2_PREFIXO=F2_PREFIXO AND E2_TIPO='TX' AND SE2.D_E_L_E_T_<>'*' AND E2_FILIAL='"+Xfilial("SE2")+"') "
	cQuery+=" AND F2_EMISSAO='"+Dtos(dDtEmissao)+"'"
	cQuery+=" WHERE F2_DOC='"+cNfiscal+"' AND SF2.D_E_L_E_T_<>'*' AND F2_FILIAL='"+Xfilial("SE2")+"'"
Endif	

Tcquery cQuery Alias QTMP New
dbSelectArea("QTMP")
dbGotop()
If !Eof()
	While !Eof()
		dbSelectArea("SE2")
		dbGoto(QTMP->RECSE2)
		If Empty(SE2->E2_BAIXA)
			RecLock("SE2",.F.)
			Replace E2_TITISS With 'X'
			MsUnlock()  
		Else
			MsgBox("Titulo com Baixa, "+If(cTipo='R','NF Entrada:','NF Faturamento:')+cNfiscal+" CNPJ:"+cCNPJ)
		Endif	
		dbSelectArea("QTMP")
		dbSkip()
	EndDo
Else
	MsgBox("Titulo não encontrado "+If(cTipo='R','NF Entrada:','NF Faturamento:')+cNfiscal+" CNPJ:"+cCNPJ)
Endif
dbSelectArea("QTMP")
dbCloseArea()
RestArea(aAreaFil)

Return()
