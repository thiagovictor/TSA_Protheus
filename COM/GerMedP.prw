
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

User Function GerMedP()
*******************************************************************************************************************
* 
*
**** 	

aPerg := {}
cPerg :="GERMED"
AADD(aPerg,{cPerg,"Ano/Mês(AAAAMM)Ref.?","C",06,0,"G","U_TestPe(MV_PAR01)","","","","","",""}) 
AADD(aPerg,{cPerg,"Matricula De? "      ,"C",06,0,"G","",""       ,"","","","",""}) 
AADD(aPerg,{cPerg,"Matricula Até?","C"  ,06,0,"G","",""       ,"","","","",""}) 
AADD(aPerg,{cPerg,"Cod. Fornecedor De? ","C",06,0,"G","",""       ,"","","","",""}) 
AADD(aPerg,{cPerg,"Cod. Fornecedor Até?","C",06,0,"G","",""       ,"","","","",""}) 
AADD(aPerg,{cPerg,"CCusto De? ","C",06,0,"G","",""       ,"","","","",""}) 
AADD(aPerg,{cPerg,"CCusto Até?","C",06,0,"G","",""       ,"","","","",""}) 

ExecBlock("TestaSX1",.F.,.F.,{cPerg,aPerg}) 

IF Pergunte(cPerg,.T.) 
	U_FVldCri()
	dbCloseArea("QPCOM")	
ENDIF 

Return()  

User Function TestPe(MV_PAR01)
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


User Function  FVldCri()
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
Private cQuery1  := '' 
Private cArqCrit := '' 
Private cMatric  := ''

		//Cria o Arquivo de Criticas da ImportaçÃo
AADD(aStru, {"MATRIC"  ,"C",06, 0 })
AADD(aStru, {"CRITICA" ,"M",10, 0 })
AADD(aStru, {"FORNECE" ,"C",40, 0 })
AADD(aStru, {"CODFOR"  ,"C",40, 0 })
AADD(aStru, {"PEDCOMP" ,"C",6, 0  })
AADD(aStru, {"GERPC"   ,"C",1, 0  })
AADD(aStru, {"VALORPC" ,"N",12,2  })
		
cArqCrit := CriaTrab(aStru, .T.)
dbUseArea(.T.,,cArqCrit, "TRBC",.F.)  


dbSelectArea("SRA")                                     

cQuery1:=" SELECT DISTINCT RA_FILIAL,RA_DEMISSA,RA_MAT,RA_NOME,RA_FOR,RA_CC  "
cQuery1+=" FROM "+RetSqlName("SRA")+" SRA "
cQuery1+=" LEFT OUTER JOIN "+RetSqlName("SA2")+" SA2 ON ( SA2.D_E_L_E_T_<>'*' AND A2_COD=RA_FOR ) "
cQuery1+=" LEFT OUTER JOIN "+RetSqlName("CTT")+" CTT ON (SRA.RA_CC=CTT_CUSTO AND CTT.D_E_L_E_T_<>'*')"
cQuery1+=" INNER JOIN "+RetSqlName("SZZ")+" SZZ ON (SZZ.D_E_L_E_T_<>'*'AND RA_MAT=ZZ_MAT)"
cQuery1+=" WHERE SRA.D_E_L_E_T_<>'*'AND RA_FILIAL='97'"  
cQuery1+=" AND RA_MAT >='"+cMatrDe+"'AND RA_MAT <= '"+cMatrAt+"'"
cQuery1+=" AND RA_FOR >='"+cFornDe+"'AND RA_FOR <= '"+cFornAt+"'" 
cQuery1+=" AND RA_CC  >='"+cCCusDe+"'AND RA_CC <= '"+cCCusAt+"'"

TCQUERY cQuery1 Alias "QTMP1" New     

dbSelectArea("QTMP1")
dbGotop()
While !Eof()
		cMatric:=QTMP1->RA_MAT
				
   	If SZZ->(dbSeek(cMesRef+QTMP1->RA_MAT))
			If Empty(SZZ->ZZ_MATLIB) .AND. Empty(SZZ->ZZ_DTLIB)
				FGravaCrit(QTMP1->RA_MAT,"MEDIÇÃO não liberada !",,'N')
				lRet:=.F.
			Endif
		EndIf   
		
		If !SZW->(dbSeek(cMesRef+QTMP1->RA_MAT))
			FGravaCrit(QTMP1->RA_MAT,"Não existe registro de Pendencias para este Colaborador !",,'S')
		Else
		  If SZW->ZW_DTBAIXA = '' 
		  	FGravaCrit(QTMP1->RA_MAT,"Existe pendencias para este Colaborador !",,'N') 
		  	lRet:=.F.
			Endif	
		EndIf 
		
		If lRet
			GerMovMes(cMatric)
		EndIf	
			
dbSelectArea("QTMP1")
dbSkip()	 
EndDo 

dbCloseArea("QTMP1")
Return()  



Static Function GerMovMes(cMatric)  
**************************************************************************************************************
*
*
******* 
Local cVerbExt:='101'
Local cSemana:="  "
Local cSeq:="0"
Local cPerRef:=MV_PAR01
Local cEol:="" 
Private cNumPedExist:=""
		
		dbSelectArea("SRA")
		dbSeek('97'+cMatric) 
		 
		dbSelectArea("SC7")
		//Verifica se há Pedido de compras para a Matricula dentro do periodo selecionado.
		cQuery:=" SELECT C7_NUM FROM "+RetSqlName("SC7")
		cQuery+=" WHERE C7_MAT='"+SRA->RA_MAT+"' AND C7_MESENTR='"+Right(cPerRef,2)+"/"+Left(cPerRef,4)+"'"
		cQuery+=" AND D_E_L_E_T_<>'*' "                
		
		TcQuery cQuery Alias "QTMP" NEW
		dbSelectArea("QTMP")		
		dbGotop()
		If !Eof()
			cNumPedExist:=QTMP->C7_NUM
		Endif                                   
	  dbCloseArea("QTMP")
		//Grava as Verbas na Tabela SRC 		
		
	  // dbCloseArea("QPCOM")
	  	If Empty(cNumPedExist)			 
		 //	Gera o Pedido de Compras para o PJ  
		 	If !GerPcom(cMatric)		
				FGravaCrit(SRA->RA_MAT,cEol+"Erro ao Gerar Pedido. Caso não haja críticas nas linhas acima, contacte o Administrador!",,'N')	
			Else
			  	If !Empty(SRA->RA_DEMISSA)
				 	FGravaCrit(SRA->RA_MAT,cEol+"Data de demissão/cancelamento dia: "+Dtoc(SRA->RA_DEMISSA)+cEol)
				Endif
			  	FGravaCrit(SRA->RA_MAT,"Pedido de Compras Nro:"+SRC->RC_PEDCOM+" Gerado Com sucesso",SRC->RC_PEDCOM+cEol)	
			Endif 
		Else
		  	FGravaCrit(SRA->RA_MAT,"Já Existe o Pedido Nro:"+SRC->RC_PEDCOM+" na Competência "+cCompet,,'N')		
		Endif           
		
		//Grava o Código e Nome do fornecedor
	 	cNomeFor:=Posicione("SA2",1,xFilial("SA2")+SRA->RA_FOR,"A2_NOME")
		dbSelectArea("TRBC")		
		Reclock("TRBC",.F.)
		Replace FORNECE With cNomeFor,;
				  CODFOR  With SRA->RA_FOR
		MsUnlock()       
      dbCloseArea("TRBC") 

Return()

Static Function GerPcom(cMatric)
*******************************************************************************************************************
*
*
******
Local cPerRef:=MV_PAR01
Local  cQuery:=""
Local  cQuery1:="" 
Local  nXi:=0  
Local cNumPed:=0         
Local cHORAS:=''
Private lMsErroAuto:=.F.

aParaPed:={}
aItemPed:={} 
aCabPed:={}

dbSelectArea("SRA")
dbSeek('97'+cMatric)
  
dbSelectArea("SZZ") 

cQuery:=" SELECT  ZZ_MAT,ZZ_FPCUSTO,ZZ_QHORAS,ZZ_VALOR,(SELECT SUM(ZZ_VALOR)FROM SZZ010 SZZ1 WHERE SZZ1.D_E_L_E_T_<>'*' AND SZZ1.ZZ_MAT =SZZ.ZZ_MAT AND SZZ1.ZZ_PERIODO=SZZ.ZZ_PERIODO) AS Total"
cQuery+=" FROM "+RetSqlName("SZZ")+" SZZ "
cQuery+=" WHERE SZZ.D_E_L_E_T_<>'*' AND ZZ_MAT = '"+SRA->RA_MAT+"'"
cQuery+=" AND ZZ_PERIODO='"+cPerRef+"' "

TcQuery cQuery Alias "QPCOM" New 
dbSelectArea("QPCOM")

 If!Eof("QPCOM") 	  

 	dbSelectArea("CNA")
		    
	cQuery1:=" SELECT CNA_FILIAL,CNA_MAT,CNA_CONTRA,CNA_REVISA,CNA_VLTOT,CNA_SALDO FROM CNA010 CNA"
 	cQuery1+=" FROM "+RetSqlName("CNA")+" CNA "
	cQuery1+=" WHERE CNA.D_E_L_E_T_<>'*' AND CNA_MAT = '"+SRA->RA_MAT+"'"  
		   
 	TcQuery cQuery Alias "QSCON" New  
			
	dbSelectArea("QSCON") 
  	dbGotop()
  	
	If !EOF("QSCON")
  		dbSelectArea("CN9")
	 	If dbSeek(QSCON->CNA_FILIAL+QSCON->CNA_CONTRA+QSCON->CNA_REVISA)
			IF QPCOM->Total <=CNA_SALDO
		  		If CN9->CN9_SITUAC='05' .And. Substring(CN9->CN9_DTINIC,1,6)>= cMesRef .And. Substring(CN9->CN9_DTINIC,1,6)<=cMesRef	
								
  					cLojaF=Posicione("SA2",1,Xfilial("SA2")+SRA->RA_FOR,"A2_LOJA")
	  				//Cabeçalho do Pedido de Compras
					aAdd(aCabPed,{"C7_FILIAL"  ,Xfilial("SC7")})// Filial
					aAdd(aCabPed,{"C7_NUM"     ,GetSX8num("SC7")})
					aAdd(aCabPed,{"C7_EMISSAO" ,dDataBase     })// Data de Emissao
  					aAdd(aCabPed,{"C7_FORNECE" ,SRA->RA_FOR   })// Fornecedor
					aAdd(aCabPed,{"C7_LOJA"    ,cLojaF        })// Loja do Fornecedor
  					aAdd(aCabPed,{"C7_CONTATO" ,SRA->RA_NOME  })// Contato
  					aAdd(aCabPed,{"C7_COND"    ,"100"         })// Condicao de pagamento
  					aadd(aCabPed,{"C7_FILENT"  ,cFilAnt       }) 	
	        		Else
	        		FGravaCrit(QSCON->CNA_MAT,"Contrato não esta Vigente e/ou o Periodo referente não esta definido no Contrato",,'N')	
	        		lMsErroAuto:=.t.
		  		EndIf
		 	Else
			  	FGravaCrit(QSCON->CNA_MAT,"Saldo do Contrato insuficiente",,'N')
				lMsErroAuto:=.t.  
 	 	EndIf
 	 	Else
			  	FGravaCrit(QSCON->CNA_MAT,"Contrato não existe",,'N')
				lMsErroAuto:=.t. 	 	
 	 EndIf
 	 EndIf
Else 
	FGravaCrit(SRC->RC_MAT,"Não Existe FAC cadastrada para este Contratado.",,'N')
	lMsErroAuto:=.t.

Endif 
 	 
   dbCloseArea("QSCON")  
  	cNumPed:=aCabPed[2,2]
  	dbGoTop("QPCOM")  
	While !Eof("QPCOM") 
		cProdSC7:=BuscaProd(Substring(QPCOM->ZZ_FPCUSTO,10,5))
		
		If !SB1->(dbSeek(Xfilial("SB1")+cProdSC7))
			FGravaCrit(QPCOM->ZZ_MAT ,cEol+"Produto("+Alltrim(cProdSC7)+") Inválido para a SubConta:"+Alltrim(Substring(QPCOM->ZZ_FPCUSTO,10,5)),,'N')
			lMsErroAuto:=.T.
		endif   
		If QPCOM->ZZ_QHORAS > 0 
								
			nXi:=nXi+1
		 	//Executa a rotina automática
			Aadd(aItemPed,{{"C7_ITEM"    ,StrZero(nXi,4),Nil},; //Numero do Item
								{"C7_PRODUTO" ,cProdSC7,Nil},; //Codigo do Produto
						  		{"C7_QUANT"   ,QPCOM->ZZ_QHORAS        ,Nil},; //Quantidade
						   	{"C7_PRECO"   ,QPCOM->ZZ_VALOR /QPCOM->ZZ_QHORAS ,Nil},; //Valor do Item do Pedido
						   	{"C7_TOTAL"   ,QPCOM->ZZ_VALOR  ,Nil},;
						   	{"C7_DATPRF"  ,Stod(cMesRef+'01')	      ,Nil},; //Data De Entrega
						   	{"C7_FLUXO"   ,"S"			  ,Nil},; //Fluxo de Caixa (S/N)
							   {"C7_CC"      ,Right(QPCOM->ZZ_FPCUSTO,5),Nil},; //Fluxo de Caixa (S/N)
						   	{"C7_ITEMCTA" ,Substring(QPCOM->ZZ_FPCUSTO,10,5),Nil},; // Item contábil
						   	{"C7_MAT"     ,QPCOM->ZZ_MAT     ,Nil  },;
						   	{"C7_LOCAL"   ,'04'            ,Nil}}) //Local Padrão 						   					
						
		  				
		 Endif					
   dbSelectArea("QPCOM") 
 	dbSkip()
 	EndDo  
	
	  nOpc:=3	
	  lHelpAuto:=.T.
	  cOrdCom := Space(06)
	  cNumEpc := Space(19) 
	  if !lMsErroAuto
	   	MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabPed,aItemPed,nOpc)
		
			if lMsErroAuto
				MostraErro()
				else
					ConfirmSX8() 
					
					dbSelectArea("SRC")	
	  				Reclock("SRC",!dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+cVerbExt+SRA->RA_CC))
					Replace RC_FILIAL  With SRA->RA_FILIAL,;
		        		RC_MAT     With SRA->RA_MAT ,;
		        		RC_TIPO1   With "H",;
		        		RC_PD      With cVerbExt,;
			 	  		RC_VALOR   With QPCOM->Total,;
			     		RC_HORAS   With 1         ,;
				  		RC_CC      With SRA->RA_CC,;
				  		RC_PEDCOM  with cNumPed
	  				MsUnlock() 
	  				
	  				nUltRec:=0
		 			nVlrTot:=0
		 		dbSelectArea("SC7")
		 			If dbSeek(Xfilial("SC7")+SRC->RC_PEDCOM)
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
					  					nValorItem:=SC7->C7_TOTAL+(SRC->RC_VALOR+nVlrTot)
							  			nQuant:=(nValorItem/SC7->C7_PRECO)
					  		  			Replace C7_TOTAL With nValorItem,;
							  	        		  C7_QUANT With nQuant
							  			MsUnlock()		
				  					Endif
			  				Endif		
					Endif
			
					aParaPed:={cNumPed,QPCOM->ZZ_MAT,SRA->RA_FOR,cLojaF,cMesRef,'100'}
						   	
					U_AtuCtrPJ(aParaPed)				
			endif
		Else 
			lMsErroAuto:=.t.	
		Endif	

dbCloseArea("QPCOM")

Return(!lMsErroAuto)

Static Function FGravaCrit(cMat,cCritica,cPedComp,CGerPC,nVlrPc)
*******************************************************************************************************************
*
*
******
Local aAreaAnt  :=GetArea()
Local cCritTRBC :=If(cCritica=Nil,"",cCritica)
Local cPedTRBC  :=If(cPedComp=Nil,"",cPedComp)
Local CGerPCTRBC:=If(cGerPC=Nil  ,"",cGerPC)
Local nVlrPCTRBC:=If(nVlrPc=Nil,0,nVlrPc)  

dbSelectArea("TRBC") 
	Reclock("TRBC",.t.)
	Replace MATRIC  With cMat,;
		     CRITICA With CRITICA+cCritTRBC,;
	        PEDCOMP With If(Empty(cPedTRBC),PEDCOMP,cPedTRBC),;
	        GERPC   with If(Empty(CGerPCTRBC),GERPC,CGerPCTRBC),;
	        VALORPC With nVlrPCTRBC
		
	MsUnlock() 

RestArea(aAreaAnt) 
 //dbCloseArea("TRBC")
Return()

Static Function BuscaProd(cCustoFIP)
*******************************************************************************************************************
*
*
*****
Local cProd:=" "
Local cCodPesq:=" "
dbSelectArea("CTD")
dbSetOrder(1)
If CTD->(dbSeek(Xfilial("CTD")+Alltrim(cCustoFIP)))

	If CTT->CTT_BLOQ='1'
		FGravaCrit(SRC->RC_MAT,cEol+"Item de Custo:"+Alltrim(cCustoFIP)+"Bloqueado para lançamentos",,'N')
		lMsErroAuto:=.T.
	Endif	 
	If Posicione("SZ2",3,Xfilial("SZ2")+Alltrim(cCustoFIP),"Z2_SITUAC")='3'
		FGravaCrit(SRC->RC_MAT,cEol+"Subconta:"+Alltrim(cCustoFIP)+" Esta encerrada contabilmente e não pode receber lançamentos",,'N')
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
Local cMens     := "CRITICA DE IMPORTAÇÃO DOS PEDIDOS DE COMPRA"+cEol
Local cCtaMail  := ""
Local cAccount  := GetMv("MV_WFACC") 
Local cCtaPass  := GetMv("MV_WFPASSW")
Local cCtaSmpt  := GetMv("MV_WFSMTP") 
Local cSendBy   := GetMv("MV_MAILPJS",,'wrfernandes@epcbh.com.br;rfsantos@epc.com.br')
Local cArqCrit  :=CriaTrab("",.F.)

cCtaMail:=cSendBy
cMat:="*"
dbSelectArea("TRBC")
IndRegua("TRBC",cArqCrit,"FORNECE",,,"Criando Arquivo Trabalho ...")
dbGotop()
While !Eof()
	If SRA->(dbSeek('97'+TRBC->MATRIC))
		SA2->(dbSeek(Xfilial("SA2")+SRA->RA_FOR))
		cMens+=""+SA2->A2_COD+"-"+Padc(Left(SA2->A2_NOME,30),30)+":"+TRBC->CRITICA+cEol
		If !Empty(TRBC->PEDCOMP)
			//Monta a Lista de Itens e Totaliza o Pedido de Compras
			nVlrTot:=0
			dbSelectArea("SC7")
			dbSeek(Xfilial("SC7")+TRBC->PEDCOMP)
			While !Eof() .And. SC7->C7_FILIAL=Xfilial("SC7") .And. TRBC->PEDCOMP=SC7->C7_NUM
				cMens+="Item: "+Alltrim(SC7->C7_PRODUTO)+'-'+Alltrim(Str(SC7->C7_TOTAL,12,2))+cEol
				nVlrTot+=SC7->C7_TOTAL
				dbSelectArea("SC7")				
				dbSkip()
			EndDo
			cMens+="Total do Pedido:"+Alltrim(Str(nVlrTot,12,2))+cEol+cEol
		Endif
		
	Else 
		cMens+=+TRBC->MATRIC+" :"+TRBC->CRITICA+cEol
	Endif
	dbSelectArea("TRBC")
	dbSkip()
EndDo


CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
SEND MAIL FROM  cSendBy TO  cCtaMail ; 
SUBJECT 'Importação do Pedido de Compras para PJ' ;
BODY cMens

DISCONNECT SMTP SERVER

Return
