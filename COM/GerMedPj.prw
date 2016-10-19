/*
+-----------------------------------------------------------------------+
¦Programa  ¦ GerMedPJ  ¦ Autor ¦                      ¦ Data ¦29.07.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Rotina para gerar os pedidos de Compra para contratados    ¦
¦          ¦                                                            ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA EPC                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
*/
#INCLUDE "RWMAKE.CH"
#Include "ap5mail.ch"
#INCLUDE "TOPCONN.CH"

User Function GerMedPj()
*******************************************************************************************************************
*    
*
****   

Private cMailCopia:=" "

aPerg := {}
cPerg :="GERMED"
AADD(aPerg,{cPerg,"Ano/Mês(AAAAMM)Ref.?","C",06,0,"G","U_TestPer(MV_PAR01)","","","","","",""}) 
AADD(aPerg,{cPerg,"Matricula De? "      ,"C",06,0,"G","","","","","","",""}) 
AADD(aPerg,{cPerg,"Matricula Até?","C"  ,06,0,"G","","","","","","",""}) 
AADD(aPerg,{cPerg,"Cod. Fornecedor De? ","C",06,0,"G","","SA2","","","","",""}) 
AADD(aPerg,{cPerg,"Cod. Fornecedor Até?","C",06,0,"G","","SA2","","","","",""}) 
AADD(aPerg,{cPerg,"CCusto De? ","C",14,0,"G","","CTT","","","","",""}) 
AADD(aPerg,{cPerg,"CCusto Até?","C",14,0,"G","","CTT","","","","",""}) 
AADD(aPerg,{cPerg,"e-Mail de Criticas ?","C",50,0,"G","","","","","","",""}) 



IF Pergunte(cPerg,.T.) 
	Processa({||ProcMatr()},"Aguarde Processando os Dados","Aguarde")
  	Processa({||EnvMail()},"Enviando e-Mail de Criticas ","Aguarde")
Endif

Return()  

User Function TestPer(MV_PAR01)
****************************************************************************************************************
* Testa se o campo Ano/Mes de Referencia se é valido
*
************ 
Local   lRet      := .t.  
 
If VAL(Left(MV_PAR01,4)) < year(DATE())-1 .or. VAL(Left(MV_PAR01,4)) > year(DATE())+1 .or. VAL(Right(MV_PAR01,2))<=0 .or. VAL(Right(MV_PAR01,2))>=13
	Alert("Ano/Mes de Referencia Invalido") 
	lRet:=.f. 
EndIf	                 

Return(lRet) 


Static Function  ProcMatr()
**************************************************************************************************************
*
*
******* 
Local      lRet  :=.T.
Local     aStru  := {} 
Private cMesRef  := MV_PAR01
Private cMatrDe  := MV_PAR02
Private cMatrAt  := MV_PAR03
Private cFornDe  := MV_PAR04
Private cFornAt  := MV_PAR05
Private cCCusDe  := MV_PAR06
Private cCCusAt  := MV_PAR07
Private cMailCopia:= MV_PAR08
Private cQuery1  := '' 
Private cArqCrit := '' 
Private cMatric  := ''
Private nSeq     :=0



//Cria o Arquivo de Criticas da ImportaçÃo
AADD(aStru, {"MATRIC"  ,"C",06,0})
AADD(aStru, {"NOME"    ,"C",40,0})
AADD(aStru, {"SEQ"     ,"C",01,0}) 
AADD(aStru, {"TIPOCT"  ,"C",02,0})
AADD(aStru, {"CRITICA" ,"C",100,0})
AADD(aStru, {"FORNECE" ,"C",40,0})
AADD(aStru, {"CODFOR"  ,"C",40,0})
AADD(aStru, {"PEDCOMP" ,"C",06,0})
		
cArqCrit := CriaTrab(aStru, .T.)
dbUseArea(.T.,,cArqCrit, "TRBC",.F.)  
IndRegua("TRBC",cArqCrit,"FORNECE+MATRIC+TIPOCT",,,"Criando Arquivo Trabalho ...")


cQuery1:=" SELECT DISTINCT RA_FILIAL,RA_DEMISSA,RA_MAT,RA_NOME,RA_FOR,RA_CC,CAST(RA_SALARIO AS DECIMAL(12,2)) RA_SALARIO,ZZ_MATLIB,ZZ_DTLIB"
cQuery1+=" FROM "+RetSqlName("SRA")+" SRA "
cQuery1+=" INNER JOIN "+RetSqlName("SA2")+" SA2 ON (A2_COD=RA_FOR AND SA2.D_E_L_E_T_<>'*') "
cQuery1+=" INNER JOIN "+RetSqlName("CTT")+" CTT ON (SRA.RA_CC=CTT_CUSTO AND CTT.D_E_L_E_T_<>'*')"
cQuery1+=" INNER JOIN "+RetSqlName("SZZ")+" SZZ ON (RA_MAT=ZZ_MAT AND SZZ.D_E_L_E_T_<>'*')"
cQuery1+=" WHERE 
cQuery1+=" 		RA_MAT >='"+cMatrDe+"'AND RA_MAT <= '"+cMatrAt+"'"
cQuery1+=" AND RA_FOR >='"+cFornDe+"'AND RA_FOR <= '"+cFornAt+"'" 
cQuery1+=" AND RA_CC  >='"+cCCusDe+"'AND RA_CC <= '"+cCCusAt+"'"
cQuery1+=" AND RA_FILIAL='97' AND SRA.D_E_L_E_T_<>'*'"  

TCQUERY cQuery1 Alias "QTMP1" New     

dbSelectArea("QTMP1")
dbGotop()
While !Eof()
	nSeq:=0
	lRet:=.T.
	dbSelectArea("SRA")
	dbSeek('97'+QTMP1->RA_MAT)
	
	cMatric:=QTMP1->RA_MAT
	//	
	/*If !SZW->(dbSeek(cMesRef+QTMP1->RA_MAT))
		FGravaCrit(QTMP1->RA_MAT,"Não existe registro de Pendencias para este Colaborador !")
	Else
		If SZW->ZW_DTBAIXA = '' 
			FGravaCrit(QTMP1->RA_MAT,"Existe pendencias para este Colaborador !") 
			lRet:=.F.
		Endif	
	EndIf */
	
   GerMovMes(cMatric)
	
	dbSelectArea("QTMP1")
	dbSkip()	 
EndDo 
dbSelectArea("QTMP1")
dbCloseArea() 

Return()  



Static Function GerMovMes(cMatric)  
**************************************************************************************************************
*
*
******* 
Local cVerbExt:='101'
Local cSemana:="  "
Local cSeq:="0"
Local cQuery:=""
Private cNumPedExist:=""

//Verifica se há Pedido de compras para a Matricula dentro do periodo selecionado.
//	Gera o Pedido de Compras para o PJ  
cQuery:=" SELECT DISTINCT CAST(CASE WHEN ZZ_TIPOREG=2 AND ZZ_UNID='C' THEN '1' ELSE ZZ_TIPOREG END AS INTEGER) AS TIPOREG,ZZ_MATLIB,ZZ_DTLIB "
cQuery+=" FROM "+RetSqlName("SZZ")+" SZZ "
cQuery+=" WHERE ZZ_MAT = '"+cMatric+"' AND ZZ_PERIODO='"+cMesRef+"' AND SZZ.D_E_L_E_T_<>'*' "
TcQuery cQuery Alias "QSZZ" NEW
DbSelectArea("QSZZ")
dbGoTop()
While !Eof()
   lGerPCompras:=.T.
	//Faz a Critica Ref A Medição
	cNumPedExist:=""
	cTpoPedido:=If(QSZZ->TIPOREG=1,'CT','OS')
	nTipoReg:=QSZZ->TIPOREG
	//Verifica se a Medição esta Liberada		
	If Empty(QSZZ->ZZ_MATLIB)
		FGravaCrit(QTMP1->RA_MAT,cTpoPedido, " Medição não liberada !")
		lGerPCompras:=.F.
	Endif
	
	//Critica se Existe Pedido de Compras
	cQuery:=" SELECT C7_NUM FROM "+RetSqlName("SC7")
	cQuery+=" WHERE C7_MAT='"+SRA->RA_MAT+"' AND C7_MESENTR='"+Right(cMesRef,2)+"/"+Left(cMesRef,4)+"'"
	cQuery+=" AND D_E_L_E_T_<>'*' AND C7_TIPREG='"+StrZero(nTipoReg,1)+"'"
			
	TcQuery cQuery Alias "QTMP" NEW
	dbSelectArea("QTMP")		
	dbGotop()
	If !Eof()
		FGravaCrit(QTMP1->RA_MAT,cTpoPedido, " Já Existe o Pedido "+cTpoPedido+" Nro:"+QTMP->C7_NUM+" na Competência "+cMesRef,QTMP->C7_NUM)
		lGerPCompras:=.F.
	Endif                                  
	dbSelectArea("QTMP")		
	dbCloseArea()
	
	// Critica a o Cardastro do Funcionário
	If !Empty(SRA->RA_DEMISSA)
		FGravaCrit(SRA->RA_MAT,cTpoPedido, "Data de demissão/cancelamento dia: "+Dtoc(SRA->RA_DEMISSA))
	Endif	
	
	If lGerPCompras
		If !GerPcom(cMatric, StrZero(nTipoReg,1))
			FGravaCrit(SRA->RA_MAT,cTpoPedido,"Erro ao Gerar Pedido Tipo "+cTpoPedido+". Caso não haja críticas nas linhas acima, contacte o Administrador!")	
		Endif 
	Endif	
	
	DbSelectArea("QSZZ")
	dbSkip()
EndDo
dbSelectArea("QSZZ")
dbCloseArea()
Return()



Static Function GerPcom(cMatric,cTipoReg)
*******************************************************************************************************************
*
*
******
Local  cQuery:=""   
Local lRet:=.F.
Local  nTotalP:=""
Local  cQuery1:="" 
Local  cQuery2:="" 
Local      nXi:=0         
Local   cHORAS:=''
Private lMsErroAuto:=.F. 
Private cNumPed:=0  

aParaPed:={}
aItemPed:={} 
aCabPed:={}

cQuery:="  SELECT CASE WHEN ZZ_TIPOREG=2 AND ZZ_UNID='C' THEN '1' ELSE ZZ_TIPOREG END AS TIPOREG ,ZZ_MAT,ZZ_FPCUSTO, "
cQuery+="	CAST(SUM(ZZ_QHORAS) AS DECIMAL(12,2)) ZZ_QHORAS, "
cQuery+="	CAST(SUM(ZZ_QHRCOMP) AS DECIMAL(12,2)) ZZ_QHRCOMP, "
cQuery+="	CAST(SUM(ZZ_VALOR)  AS DECIMAL(12,2)) ZZ_VALOR, "
cQuery+="	CAST((SELECT SUM(ZZ_VALOR) FROM "+RetSqlName("SZZ")+" SZZB "
cQuery+="         WHERE SZZB.ZZ_MAT=SZZ.ZZ_MAT AND SZZB.ZZ_PERIODO=SZZ.ZZ_PERIODO AND "
cQuery+="         CASE WHEN SZZB.ZZ_TIPOREG=2 AND SZZB.ZZ_UNID='C' THEN '1' ELSE SZZB.ZZ_TIPOREG END = "
cQuery+="         CASE WHEN  SZZ.ZZ_TIPOREG=2  AND SZZ.ZZ_UNID='C' THEN '1' ELSE SZZ.ZZ_TIPOREG END "
cQuery+="         AND D_E_L_E_T_<>'*') AS DECIMAL(12,2)) TOTAL"
cQuery+=" FROM "+RetSqlName("SZZ")+" SZZ "
cQuery+=" WHERE ZZ_MAT = '"+cMatric+"'"
cQuery+=" AND ZZ_PERIODO='"+cMesRef+"' AND SZZ.D_E_L_E_T_<>'*' "
cQuery+=" AND CASE WHEN ZZ_TIPOREG=2 AND ZZ_UNID='C' THEN '1' ELSE ZZ_TIPOREG END = '"+cTipoReg+"'"
cQuery+=" GROUP BY CASE WHEN ZZ_TIPOREG=2 AND ZZ_UNID='C' THEN '1' ELSE ZZ_TIPOREG END,ZZ_MAT,ZZ_FPCUSTO,SZZ.ZZ_PERIODO " 
cQuery+=" ORDER BY TIPOREG,ZZ_FPCUSTO "


TcQuery cQuery Alias "QPCOM" New 
dbSelectArea("QPCOM")

//Faz as Criticas do Cabeçalho do Pedido
If !Eof() 

 	dbSelectArea("CNA")
		    
	cQuery1:=" SELECT CNA_FILIAL,CNA_MAT,CNA_CONTRA,CNA_REVISA,CNA_VLTOT,CNA_SALDO "
 	cQuery1+=" FROM "+RetSqlName("CNA")+" CNA " 
 	cQuery1+=" INNER JOIN "+RetSqlName("CN9")+" CN9 ON CN9_NUMERO=CNA_CONTRA AND CN9_FILIAL=CNA_FILIAL AND CN9.D_E_L_E_T_<>'*' AND CN9_TICONT='"+cTipoReg+"'"
	cQuery1+=" WHERE CNA_MAT = '"+cMatric+"' AND CNA.D_E_L_E_T_<>'*' AND CNA_FILIAL='"+Xfilial("CNA")+"'"  
		   
 	TcQuery cQuery1 Alias "QSCON" New  
			
	dbSelectArea("QSCON") 
  	dbGotop() 
	If !EOF()		
  		dbSelectArea("CN9")
		If dbSeek(QSCON->(CNA_FILIAL+CNA_CONTRA+CNA_REVISA))
			IF QPCOM->TOTAL <= QSCON->CNA_SALDO
				If !(CN9->CN9_SITUAC='05' .And. Left(DTOS(CN9->CN9_DTFIM),6)>=cMesRef)	
	        		FGravaCrit(cMatric,cTpoPedido, "Contrato não esta Vigente e/ou o Periodo referente não esta definido no Contrato")
		  		EndIf
			Else
		  		FGravaCrit(cMatric,cTpoPedido, " Saldo do Contrato("+QSCON->(CNA_CONTRA+"/"+CNA_REVISA)+") insuficiente")
			EndIf
		Else
			FGravaCrit(cMatric,cTpoPedido, "Planilha não encontrada para o Contrato:"+CNA->(CNA_CONTRA+"/"+CNA_REVISA))
		EndIf
 	Else
			FGravaCrit(cMatric,cTpoPedido, "Contrato não existe para Matricula:"+SRA->RA_MAT)
	EndIf
	
	
	//Monta o Cabeçalhos 
	aCabPed:={}	
	nTotalP:=QPCOM->Total		
  	cLojaF=Posicione("SA2",1,Xfilial("SA2")+SRA->RA_FOR,"A2_LOJA")
  	
	//Cabeçalho do Pedido de Compras
	aAdd(aCabPed,{"C7_FILIAL"  ,Xfilial("SC7")})// Filial
	aAdd(aCabPed,{"C7_NUM"     ,''})
	aAdd(aCabPed,{"C7_EMISSAO" ,dDataBase     })// Data de Emissao
  	aAdd(aCabPed,{"C7_FORNECE" ,SRA->RA_FOR   })// Fornecedor
	aAdd(aCabPed,{"C7_LOJA"    ,cLojaF        })// Loja do Fornecedor
  	aAdd(aCabPed,{"C7_CONTATO" ,SRA->RA_NOME  })// Contato
  	aAdd(aCabPed,{"C7_COND"    ,"100"         })// Condicao de pagamento
	aAdd(aCabPed,{"C7_TIPREG"  ,cTipoReg      })
  	aadd(aCabPed,{"C7_FILENT"  ,cFilAnt       }) 
	
	//Fecha a Query de Situação do Contrato.
	dbSelectArea("QSCON")
	dbCloseArea()
	
Else 
	FGravaCrit(cMatric,cTpoPedido, "Medição FAC Não cadastrada para este Contratado.")
Endif 

If Len(aCabPed)>0
	If cTipoReg='1' .And. (QPCOM->TOTAL<>SRA->RA_SALARIO)
		FGravaCrit(cMatric,cTpoPedido, "Valor Medição( "+Alltrim(Str(QPCOM->TOTAL,12,2))+" ) Diferente do Valor Mensal( "+Alltrim(Str(QTMP1->RA_SALARIO,12,2))+" )")
		If (QTMP1->RA_SALARIO-QPCOM->TOTAL) < -0.10
			lMsErroAuto:=.T.
		Endif 
	Endif      

	dbSelectArea("QPCOM")
  	dbGoTop("QPCOM")  
	While !Eof()   
	   //VALIDA O PRODUTO
	   If cTipoReg='1'
			cProdSC7:=BuscaProd(Substring(QPCOM->ZZ_FPCUSTO,10,5))		
		Else 
			cProdSC7:='FI0001'
		Endif
		If !SB1->(dbSeek(Xfilial("SB1")+cProdSC7))
			FGravaCrit(cMatric,cTpoPedido, "Produto("+Alltrim(cProdSC7)+") Inválido para a SubConta:"+Alltrim(Substring(QPCOM->ZZ_FPCUSTO,10,5)))
			lMsErroAuto:=.T. 
		Endif                                    
		nVlrItem:=(QPCOM->ZZ_VALOR/(QPCOM->ZZ_QHORAS+QPCOM->ZZ_QHRCOMP))
		If nVlrItem > 0
			nXi:=nXi+1
		 	//Executa a rotina automática
			Aadd(aItemPed,{{"C7_ITEM"    ,StrZero(nXi,4)      ,Nil},; //Numero do Item
							{"C7_PRODUTO" ,cProdSC7           ,Nil},; //Codigo do Produto
							{"C7_QUANT"   ,(QPCOM->ZZ_QHORAS+QPCOM->ZZ_QHRCOMP),Nil},; //Quantidade
							{"C7_PRECO"   ,nVlrItem ,Nil}     ,; //Valor do Item do Pedido
						   {"C7_DATPRF"  ,Stod(cMesRef+'01') ,Nil},; //Data De Entrega
						   {"C7_FLUXO"   ,"N"			       ,Nil},;  //Fluxo de Caixa (S/N)
							{"C7_CC"      ,Right(QPCOM->ZZ_FPCUSTO,5),Nil},; //Fluxo de Caixa (S/N)
						   {"C7_ITEMCTA" ,Substring(QPCOM->ZZ_FPCUSTO,10,5),Nil},; // Item contábil
						   {"C7_MAT"     ,QPCOM->ZZ_MAT      ,Nil  },;
						   {"C7_TIPREG"  ,cTipoReg           ,Nil  },;
						   {"C7_LOCAL"   ,'04'               ,Nil}}) //Local Padrão 						   					
												   //{"C7_TOTAL"   ,QPCOM->ZZ_VALOR    ,Nil},;
		  				
		Endif 
		dbSelectArea("QPCOM") 
		dbSkip()                              
	EndDo  
	
	nOpc:=3	
	lHelpAuto:=.T.
	cOrdCom := Space(06)
	cNumEpc := Space(19) 
	If !lMsErroAuto .And. Len(aItemPed) > 0
	
		MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabPed,aItemPed,nOpc)   
		if !lMsErroAuto	  
			dbSelectArea("SC7")
			cQuery2:=" SELECT C7_NUM FROM "+RetSqlName("SC7")
			cQuery2+=" WHERE C7_MAT='"+cMatric+"' AND C7_MESENTR='"+Right(cMesRef,2)+"/"+Left(cMesRef,4)+"'"
			cQuery2+=" AND C7_TIPREG='"+cTipoReg+"' "
			cQuery2+=" AND D_E_L_E_T_<>'*' AND C7_FILIAL='"+Xfilial("SC7")+"'"
		  		             		
		  TcQuery cQuery2 Alias "QTMP2" NEW
		  dbSelectArea("QTMP2")		
		  dbGotop()
		  If !Eof()
				cNumPed:=QTMP2->C7_NUM
				FGravaCrit(cMatric,cTpoPedido, " Pedido de Compras: "+QTMP2->C7_NUM+" Gerado Com sucesso !",QTMP2->C7_NUM)
		  Endif                                   
		  dbSelectArea("QTMP2")		
		  dbCloseArea()
		
			dbSelectArea("SRC")	
			Reclock("SRC",!dbSeek(SRA->RA_FILIAL+cMatric+"101"+SRA->RA_CC))
			Replace RC_FILIAL  With SRA->RA_FILIAL,;
					RC_MAT     With cMatric ,;
					RC_TIPO1   With "H"         ,;                                                                           
			      RC_PD      With "101"       ,;
					RC_VALOR   With nTotalP     ,;
					RC_HORAS   With 1           ,;
					RC_CC      With SRA->RA_CC  ,;
					RC_PEDCOM  with cNumPed
			MsUnlock()
	   	//Atualiza a Medição com o Numero do pedido gerado	   	  		 
			dbSelectArea("QPCOM")
	  		dbGoTop("QPCOM")  
			While !Eof() 
				DbSelectArea("SZZ")
				dbSeek(Xfilial("SZZ")+cMesRef+QPCOM->ZZ_MAT)
				While !Eof() .And. ZZ_FILIAL+ZZ_PERIODO+ZZ_MAT=Xfilial("SZZ")+cMesRef+QPCOM->ZZ_MAT
					If (QPCOM->ZZ_FPCUSTO=SZZ->ZZ_FPCUSTO) .And. If(SZZ->ZZ_UNID='C','1',SZZ->ZZ_TIPOREG)=cTipoReg
						cMatLib:=ZZ_MATLIB
						dDtaLib:=ZZ_DTLIB
					   If Empty(ZZ_MATLIB)	
							cMatLib:='AUTO'
							dDtaLib:=Date()
					   Endif
						Reclock("SZZ",.F.)
						Replace ZZ_PEDIDO With cNumPed,;
								  ZZ_MATLIB With cMatLib,;
								  ZZ_DTLIB  With dDtaLib
						MsUnlock()
					Endif
					dbSelectArea("SZZ")
					dbSkip()
				EndDo
				dbSelectArea("QPCOM")
				dbSkip()
			EndDo
			nUltRec:=0
			nVlrTot:=0
			dbSelectArea("SC7")
			If .f. .And. dbSeek(Xfilial("SC7")+SRC->RC_PEDCOM)
		  		While !Eof() .And. SC7->C7_FILIAL=Xfilial("SC7") .And. SRC->RC_PEDCOM=SC7->C7_NUM
					 nVlrTot:=nVlrTot + SC7->C7_TOTAL
					 nUltRec:=Recno()
					 dbSelectArea("SC7")
				    dbSkip()
				EndDo
				If nVlrTot<>0
					dbSelectArea("SC7")
					dbGoto(nUltRec)
					If Reclock("SC7",.F.)
						nValorItem:=(nTotalP-nVlrTot)
						nQuant:=(nValorItem/SC7->C7_PRECO)
						Replace C7_TOTAL With nValorItem,;
				                C7_QUANT With nQuant
				      MsUnlock()		
			      Endif
				Endif
			Endif	
		Endif			
 	EndIf
Else
	lMsErroAuto:=.T. 	
Endif	 
dbSelectArea("QPCOM")
dbCloseArea()

Return(!lMsErroAuto)


Static Function FGravaCrit(cMat,cTipCT,cCritica,cPedComp)
*******************************************************************************************************************
*
*
******
Local aAreaAnt  :=GetArea()
Local cCritTRBC :=If(cCritica=Nil,"",cCritica)
Local cPedTRBC  :=If(cPedComp=Nil,"",cPedComp)
Local cNomeForn :=""

If SA2->(dbSeek(Xfilial("SA2")+SRA->RA_FOR))
	cNomeForn :=Padc(Left(SA2->A2_NOME,30),30)
	cCodFor:=SRA->RA_FOR
Else 
	cNomeForn :='Fornecedor Não Cadastrado para Matricula:'+TRBC->MATRIC
	cCodFor:=""
Endif
		
dbSelectArea("TRBC") 
Reclock("TRBC",.t.)
Replace MATRIC  With cMat,;
		  TIPOCT  With cTipCT,;
		  FORNECE With cNomeForn,;
	     CRITICA With cCritTRBC,;
	     NOME    With SRA->RA_NOME,;
	     CODFOR  With cCodFor,;
        PEDCOMP With If(Empty(cPedTRBC),PEDCOMP,cPedTRBC)
		
MsUnlock()
//Grava o numero do Pedido Gerado nos registros  da tabela
If PEDCOMP<>''
	dbSelectArea("TRBC")
	dbgotop()
	While !Eof() .and. MATRIC=cMat .AND. TIPOCT=cTipCT
		Reclock("TRBC",.F.)
		Replace PEDCOMP With cPedTRBC
		MsUnlock()
		dbSkip()
	EndDo
Endif


RestArea(aAreaAnt) 

Return()

Static Function BuscaProd(cCustoFIP)
*******************************************************************************************************************
*
*
*****
Local cProd:=" "
Local cCodPesq:=" "

dbSelectArea("CTT")
If CTT->(dbSeek(Xfilial("CTT")+Alltrim(cCustoFIP))) .And. CTT->CTT_BLOQ='1'
	FGravaCrit(SRC->RC_MAT,cTpoPedido, "C.Custo: "+Alltrim(cCustoFIP)+" Bloqueado para lançamentos")
	lMsErroAuto:=.T.
Endif

dbSelectArea("CTD")
dbSetOrder(1)
If CTD->(dbSeek(Xfilial("CTD")+Alltrim(cCustoFIP)))

	If CTD->CTD_BLOQ='1'
		FGravaCrit(SRC->RC_MAT,cTpoPedido, "Item contábil: "+Alltrim(cCustoFIP)+" Bloqueado para lançamentos")
		lMsErroAuto:=.T.
	Endif	 
	If Posicione("SZ2",3,Xfilial("SZ2")+Alltrim(cCustoFIP),"Z2_SITUAC")='3'
		FGravaCrit(SRC->RC_MAT,cTpoPedido, "Subconta:"+Alltrim(cCustoFIP)+" Esta encerrada contabilmente e não pode receber lançamentos")
		lMsErroAuto:=.T.
	Endif	
	cProd:=CTD->CTD_PRODPJ
Endif 

Return(cProd)



Static Function EnvMail()
************************************************************************************************************************
*
*
*******
Local cCabec    := ""
Local cTexto    := ""
Local cRoda     := ""
Local cCtaMail  := ""  
Local cAccount  := GetMv("MV_WFACC") 
Local cCtaPass  := GetMv("MV_WFPASSW")
Local cCtaSmpt  := GetMv("MV_WFSMTP") 
Local cSendBy   := GetMv("MV_MAILPJS",,''+cMailCopia)
Local cArqCrit  :=CriaTrab("",.F.)

cCtaMail:=cSendBy
cMat:="*"
/*
dbSelectArea("TRBC")
dbGotop()
While !Eof()
	If SRA->(dbSeek('97'+TRBC->MATRIC)) .And. SA2->(dbSeek(Xfilial("SA2")+SRA->RA_FOR))
		Replace FORNECE With Alltrim(SA2->A2_NOME),;
				  
	Endif	
	dbSkip()
EndDo
*/

cMensMail:=" <HTML><HEAD><TITLE>EPC--Lista de Funcionários Sem FIP</TITLE></HEAD> "
cMensMail+=" <BODY> "
cMensMail+= "<TABLE borderColor=black cellSpacing=0 width=700 border=2> "
cMensMail+= "  <TBODY> "
cMensMail+= "  <TR> "
cMensMail+= "    <TD align=left bgColor=silver colSpan=2> <B> Critica de Geração dos Pedidos de Compras </B> </TD> "
cMensMail+= "  <TR>                                             "
cMensMail+= "    <TD bgColor=silver width=350 >Prestador </TD>  "
cMensMail+= "    <TD bgColor=silver width=450 >Ocorrência </TD> "
cMensMail+= "  </TR> "

dbSelectArea("TRBC")
dbGotop()
While !Eof()
	cMensMail+=" <TR>  "
   cMensMail+=" <TD colSpan=3 > "
	cMensMail+="Fornecedor: "+CODFOR+'-'+FORNECE+"<br>"
   cMensMail+="Matricula: "+TRBC->MATRIC+"-"+NOME+"<br>"
   cMensMail+="Tipo de Medição:"+TIPOCT
   cMensMail+="Valor Mensal:"
   cMensMail+=" </TD>"
   //Linha Inicial de Critica
   cMensMail+=" </TR> "
	cMensMail+=" <TR>  "
	cMensMail+=" <TD></TD>"
	cMensMail+=" <TD>"
	dbSelectArea("TRBC")
	cForMail:=TRBC->FORNECE+TIPOCT+MATRIC   
	While !Eof() .And. cForMail=TRBC->FORNECE+TIPOCT+MATRIC
		cMensMail+=TRBC->CRITICA+"<br>"
		dbSkip()
	EndDo 
	dbSkip(-1)
	//Monta a Lista de Itens e Totaliza o Pedido de Compras	
	If !Empty(TRBC->PEDCOMP)     
		cMensMail+=" <TABLE cellSpacing=0 width=450 border=1> "
	   cMensMail+=" <TD colSpan=4  bgColor=silver >Pedido Compras: "+TRBC->PEDCOMP+" </TD>
		cMensMail+=" <TR> "
		cMensMail+="    	<TD>Item </TD> "
		cMensMail+="    	<TD>Produto </TD> "
		cMensMail+="    	<TD>Item Contabil </TD>"
		cMensMail+="    	<TD>Valor</TD>
		cMensMail+=" </TR>
		nVlrTot:=0
		dbSelectArea("SC7")
		dbSeek(Xfilial("SC7")+TRBC->PEDCOMP)
		While !Eof() .And. SC7->C7_FILIAL=Xfilial("SC7") .And. TRBC->PEDCOMP=SC7->C7_NUM
			cMensMail+=" <TR>"
			cMensMail+="    	<TD>"+SC7->C7_ITEM+"</TD> "
			cMensMail+="    	<TD>"+SC7->C7_PRODUTO+"</TD> "
			cMensMail+="      <TD>"+SC7->C7_ITEMCTA+"</TD>"
			cMensMail+="    	<TD>"+Alltrim(Str(SC7->C7_TOTAL,12,2))+"</TD> "
			cMensMail+=" </TR>"
			nVlrTot+=SC7->C7_TOTAL
			dbSelectArea("SC7")				
			dbSkip()
		EndDo
		cMensMail+=" </TD>
		cMensMail+=" </TR>
		cMensMail+=" <TD CelSpan=4> Total do Pedido:"+Alltrim(Str(nVlrTot,12,2))+"</TD>"
	   cMensMail+=" </TABLE>
	Endif
	cMensMail+="</TR> 
	dbSelectArea("TRBC")
	dbSkip()
EndDo 
cMensMail+="  </TBODY>"
cMensMail+="  </TABLE>"
cMensMail+=" </BODY>"
cMensMail+="</HTML>"

dbSelectArea("TRBC")
dbCloseArea()

CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
SEND MAIL FROM  cSendBy TO  cCtaMail ; 
SUBJECT 'Importação do Pedido de Compras para PJ' ;
BODY cMensMail

DISCONNECT SMTP SERVER

//Cria o Arquivo no Servidor Protheus 
cHTMPage:="\\EPCS02\Protheus8\Protheus8Help\epc\germedpj\GERMEDPJ.HTML"
nFile:=FCreate(cHTMPage)
FWrite(nFile,cMensMail)
FClose(nFile)
//Chama o Arquivo Criado
///cHTMPage:="http://EPCS02/epc/germedpj/GERMEDPJ.html"
///ShellExecute("open", cHTMPage, "", "", 1)

Return
