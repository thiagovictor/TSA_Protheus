#include "rwmake.ch"
#include "topconn.ch"  
#include "Ap5mail.ch"  

User Function RatFol()       
***************************************************************************************************************
*
*
*****
Private cMens:=""
Private lTestPath:= .F.
Private nLastKey := 0
Private cArq1    := ""
Private cInd1	  := CriaTrab(,.f.)
Private cArq2    := ""
Private cInd2    := ""
Private cArq3    := ""
Private cInd3    := ""
Private cAnoMesFol  := GetMv("MV_FOLMES")
Private cAnoMesAtu  := ""
Private cDireArqu := "\download\"
Private cPerg:="GERFIX"
Private aPerg:={}

AADD(aPerg,{cPerg,"Competencia Ano Mes?","C",06,0,"G","!Empty(MV_PAR01)","","","","","",""})
AADD(aPerg,{cPerg,"Filial de  ?"         ,"C",02,0,"G","","SM0","","","","",""})
AADD(aPerg,{cPerg,"Filial Até ?"         ,"C",02,0,"G","","SM0","","","","",""})



Pergunte(cPerg,.T.)
cMens:="Este programa tem como Objetivo gerar o rateio dos lançamentos da Folha de Pgto"

BatchProcess("Gerar Rateio da Folha de Pgto",cMens,cPerg,{|| Processa({||If(AbreFile(),FGERSZ7(),.t.)},"Aguarde","Processando...")})

OurSpool("SEMFIP")


Return()
 


Static Function AbreFile()
******************************************************************************
* Criacao de arquivos de trabalho
*
*** 
Local cQuery := ""
Local cQueryPAM := ""
Pergunte(cPerg,.f.)

cArquFIP  := "FIP"+cEmpAnt+Right(MV_PAR01,2)+SubsTr(MV_PAR01,3,2)+".DBF"
cArq1     := cDireArqu+cArquFIP
If !File(cArq1) 
   MsgStop( " Arquivo  "+cArquFIP+" nao se encontra no "+Chr(13)+Chr(10)+;
            " diretorio "+cDireArqu)
   Return(.F.)
EndIf

dbUseArea( .T.,,cArq1,"FIP",.F.,.F.)
IndRegua("FIP",cInd1,"Matr_Fi",,,"Selecionando Registros...")

aStru := {}
AADD(aStru, {"NumFunc","C", 06, 0 })
AADD(aStru, {"NomeFunc","C",30, 0 })
AADD(aStru, {"SitFolh","C",3, 0 })
AADD(aStru, {"CentCus","C", 09, 0 })
AADD(aStru, {"TotApro","N", 16, 2 })
AADD(aStru, {"HorParc","N", 10, 2 })
AADD(aStru, {"ContCre","C", 20, 0 })
AADD(aStru, {"ContDeb","C", 20, 0 })
AADD(aStru, {"ContFat","C", 20, 0 })
AADD(aStru, {"VlrDes","N", 15, 2 })
AADD(aStru, {"VlrFat","N", 15, 2 })
AADD(aStru, {"TemFIP","C", 1,0 })

cArq4 := CriaTrab(aStru, .T.)
dbUseArea(.T.,, cArq4, "TRABALHO",.F.)

dbSelectArea("TRABALHO")
IndRegua("TRABALHO",cArq4,"NumFunc+ContDeb+ContCre",,,"Criando Arquivo Trabalho ...")

aStru := {}
AADD(aStru, {"NumFunc","C", 06, 0 })
AADD(aStru, {"CentCus","C", 09, 0 })
AADD(aStru, {"ItemCta","C", 09, 0 })
AADD(aStru, {"HorCCus","N", 06, 2 })

cArq5 := CriaTrab(aStru, .T.)
dbUseArea(.T.,, cArq5, "TRCENCUS",.F.)

dbSelectArea("TRCENCUS")
IndRegua("TRCENCUS",cArq5,"NumFunc+CentCus+ItemCta",,,"Criando Arquivo Trabalho ...")

Return(.T.)



Static Function FGERSZ7()
*****************************************************************************
* Gravacao de Arquivo para Exportacao
*
***

Pergunte(cPerg,.f.)

cAnoMesAtu:=MV_PAR01

cQuery:=" DELETE "+RetSqlName("SZ7")
cQuery+=" WHERE Z7_DTLANC ='"+MV_PAR01+"01' AND Z7_FILIAL BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'"
TcSqlExec(cQuery)


DbSelectArea("FIP")
dbGoTop()           
If Alltrim(FIP->MES_ANO_FI) <> Alltrim(Substr(MV_PAR01,3,2)+Substr(MV_PAR01,5,2))
	MsgStop("O arquivo FIP está com data diferente da data de refêrencia!")
	DbSelectArea("TRCENCUS")
	dbCloseArea()
	DbSelectArea("FIP")
	dbCloseArea()
	DbSelectArea("TRABALHO")
	dbCloseArea()	
	dbSelectArea("SRA")
	Return
EndIf

dbSelectArea("SRC")
aStruct:=dbStruct()

If MV_PAR01==cAnoMesFol
	cQuery:=" SELECT RC_FILIAL,RC_MAT,RC_PD,RC_VALOR,RC_HORAS,RC_CC FROM "+RetSqlName("SRC")
	cQuery+=" WHERE D_E_L_E_T_<>'*' AND RC_FILIAL BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' AND RC_FILIAL<>'97' "
	// cQuery+=" AND RC_MAT='009317'
	cQuery+=" ORDER BY RC_MAT,RC_PD
Else      
	cQuery:=" SELECT RD_FILIAL RC_FILIAL, RD_MAT RC_MAT,RD_PD RC_PD,RD_VALOR RC_VALOR, RD_HORAS RC_HORAS,RD_CC RC_CC FROM "+RetSqlName("SRD")
	cQuery+=" WHERE RD_DATARQ='"+MV_PAR01+"' AND RD_FILIAL BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' AND RD_FILIAL<>'97' "
	// cQuery+=" AND RD_MAT='009317'
	cQuery+="  AND  D_E_L_E_T_<>'*' "
	cQuery+=" ORDER BY RD_MAT,RD_PD  
  
Endif
TcQuery cQuery Alias QSRC New
DbSelectArea("QSRC")
TCSetField('QSRC', "RC_VALOR", "N", 12,3)
cMatAnt:="*"
DbSelectArea("QSRC")
ProcRegua(RecCount())
dbGotop()

While !Eof()
	Incproc("Lendo os lançamentos do Mês")
	
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If !dbSeek(xFilial("SZ6")+ALLTRIM(QSRC->RC_PD)) // buscava verba do PAM
		dbSelectArea("QSRC")
		DbSkip()
		Loop
	EndIf
	cNomeFun:=""
	cSitFolh:=""
	cQuery:=" SELECT RA_NOME,RA_SITFOLH FROM "+RetSqlName("SRA")
	cQuery+=" WHERE RA_MAT='"+QSRC->RC_MAT+"' AND D_E_L_E_T_<>'*'"
	TcQuery cQuery Alias QTMP New
	dbSelectArea("QTMP")
	dbGotop()
	If !Eof()
		cNomeFun:=QTMP->RA_NOME
		cSitFolh:=QTMP->RA_SITFOLH
	Endif	
	dbSelectArea("QTMP")
	dbCloseArea()
	
	DbSelectArea("TRABALHO")
	RecLock("TRABALHO",!DbSeek(AllTrim(QSRC->RC_MAT)+SZ6->(Z6_CONTDEB+Z6_CONTCRN)))
	Replace NumFunc With QSRC->RC_MAT
	Replace CentCus With QSRC->RC_CC
	Replace ContCre With SZ6->Z6_CONTCRN
	Replace ContDeb With SZ6->Z6_CONTDEB
   Replace NomeFunc With cNomeFun
   Replace SitFolh  With cSitFolh
   
	If FIP->(dbSeek(QSRC->RC_MAT))
		RecLock("TRABALHO",.F.)
		Replace TemFIP  With "S"
		MsUnLock()	   	
	Endif

	If !SZ6->Z6_VRBDESC$"D/E/F"  
		Replace TotApro With TotApro + QSRC->RC_VALOR  // Total da apropriacao da  verba positiva   
		MsUnLock()
		
	Else
		If SZ6->Z6_VRBDESC=='F' // Fatura dos benefícios
			Replace VlrFat  With QSRC->RC_VALOR
			Replace ContFat With SZ6->Z6_CONTDEB
		Else
			Replace VlrDes With VlrDes + QSRC->RC_VALOR //  Com Desconto		
		EndIf
		MsUnLock()
	EndIf
 	
 	If cMatAnt<>QSRC->RC_MAT
 		cMatAnt:=QSRC->RC_MAT
		nTotHoras:=0
		//Faz o Rateio das Horas
		DbSelectArea("FIP")
		If dbSeek(QSRC->RC_MAT)
			While (! Eof()) .And. Alltrim(FIP->Matr_Fi) == QSRC->RC_MAT
	   	
				/*      
				// As contas Administrativas 9999 será tratado no fluxo gerencial e será contabilizado normalmente o rateio
				
				If Empty(FIP->Cod_STA) .Or. SubStr(FIP->Cod_STA,1,4) == "9999" .Or. (Left(FIP->Cod_STA,1) == "9" .AND. SubStr(FIP->Cod_STA,5,1) == "F")  
					DbSelectArea("FIP")
					DBSkip()
					Loop
				EndIf */
	
				If FIP->Seq_FI == 998 .Or. FIP->Seq_FI == 999
					DbSelectArea("FIP")
					DBSkip()
					Loop
				EndIf
		
		      DbSelectArea("TRABALHO")
		
				RecLock("TRABALHO",.F.)
				Replace HorParc With TRABALHO->HorParc + FIP->THonor_FI  // Total de Horas por func.
				Replace TemFIP  With "S"
				MsUnLock()
				
				//Total de Horas
				nTotHoras:=TRABALHO->HorParc
				
				dbSelectArea("FIP")
				DbSkip()
			EndDo		
		Endif
		
		If nTotHoras==0 
			nTotHoras:=QSRC->RC_HORAS
			If QSRC->RC_HORAS==0
				nTotHoras:=1
			Endif
			RecLock("TRABALHO",.F.)
			Replace HorParc With nTotHoras
			MsUnLock()
		Endif	
	Else
		RecLock("TRABALHO",.F.)
		Replace HorParc With nTotHoras
		MsUnLock()
	Endif  
	dbSelectArea("QSRC")
	DbSkip()
EndDo  
dbSelectArea("QSRC")
dbCloseArea()

//Faz o Rateio Por Centro de Custo
DbSelectArea("FIP")
dbGoTop()
While (! Eof())
	Incproc("Totalizando os lançamentos por Centro de Custo")
   /// FIP->Matr_Fi<>'008265' .Or. 
   /*
   If  Empty(FIP->Cod_STA) .Or. SubStr(FIP->Cod_STA,1,4) == "9999" .Or. (Left(FIP->Cod_STA,1) == "9" .AND. SubStr(FIP->Cod_STA,5,1) == "F")
      DbSelectArea("FIP")
      DBSkip()
      Loop
   EndIf */

   If FIP->Seq_FI == 998 .Or. FIP->Seq_FI == 999
      DbSelectArea("FIP")
      DBSkip()
      Loop
   EndIf  
   cCust:=""
   
   dbSelectArea("TRABALHO")
   If dbSeek(Alltrim(FIP->Matr_Fi))
   	cCust:=TRABALHO->CentCus
   Endif
	If Empty(cCust)
		///MsGbox("Não Encontrou:"+FIP->Matr_Fi)
		cQuery:=" SELECT RA_FILIAL, RA_CC FROM "+RetSqlName("SRA")
		cQuery+=" WHERE RA_MAT='"+Alltrim(FIP->Matr_Fi)+"' AND D_E_L_E_T_<>'*'"
		cQuery+="   AND RA_FILIAL BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'"
		TcQuery cQuery Alias QTMP New
		dbSelectArea("QTMP")
		dbGotop()
		If !Eof()
			cCust:=QTMP->RA_CC
			dbSelectArea("QTMP")
			dbCloseArea()
		Else
			dbSelectArea("QTMP")
			dbCloseArea()
	      DbSelectArea("FIP")
	      DBSkip()
	      Loop		
		Endif	
   Endif
	
	dbSelectArea("FIP")
	
   DbSelectArea("TRCENCUS")
   If !DbSeek(Alltrim(FIP->Matr_Fi)+cCust+FIP->Cod_STA)
      
      RecLock("TRCENCUS",.T.)
      Replace NumFunc With FIP->Matr_Fi  // Codigo do funcionario
      Replace CentCus With cCust         // Centro de Custo
      Replace ItemCta With FIP->Cod_STA  // Centro de Custo
   Else
      RecLock("TRCENCUS",.F.)
   EndIf

   Replace HorCCus With HorCCus + FIP->THonor_FI  // Total de horas por func.
   MsUnLock()                                  // e centro de custo

   dbSelectArea("FIP")
   DbSkip()
EndDo


//Grava os Funcionários SEM FIP
dbSelectArea("TRABALHO")
dbGoTop()
While (!Eof())
	If Empty(TRABALHO->TemFip)
		cCust:=TRABALHO->CentCus
		cItemCta:=""
		If Left(cCust,2)<>'31' .Or. Alltrim(cCust)=='31001'
			/// Busca o Item contábil da conta
	    	cQuery:=" SELECT Z2_SUBC FROM "+RetSqlName("SZ2")
			cQuery+=" WHERE Z2_SETOR='"+cCust+"' AND Z2_SITUAC='0' AND D_E_L_E_T_<>'*'" 
			cQuery+="   AND Left(Z2_SUBC,1)='9' And SubsTring(Z2_SUBC,5,1)='A' "
			cQuery+="   AND Z2_FILIAL='"+Xfilial("SZ2")+"'"
			TcQuery cQuery Alias QTMP New
			dbSelectArea("QTMP")
			dbGotop()
			If !Eof()
				cItemCta:=QTMP->Z2_SUBC
			Endif	             
			
			//Centro de Custo para os escritótios Externos
			If Empty(cItemCta) .And. Left(cCust,3)='389'
				dbSelectArea("QTMP")
				dbCloseArea()
		    	cQuery:=" SELECT Z2_SUBC FROM "+RetSqlName("SZ2")
				cQuery+=" WHERE Z2_SETOR='38901' AND Z2_SITUAC='0' AND D_E_L_E_T_<>'*'" 
				cQuery+="   AND Left(Z2_SUBC,1)='9' And SubsTring(Z2_SUBC,5,1)='A' "
				cQuery+="   AND Z2_FILIAL='"+Xfilial("SZ2")+"'"
				TcQuery cQuery Alias QTMP New
				dbSelectArea("QTMP")
				dbGotop()
				If !Eof()
					cItemCta:=QTMP->Z2_SUBC
				Endif								
			Endif
			
			// Verifica se é Escritório Externo
			If Empty(cItemCta) 
				dbSelectArea("QTMP")
				dbCloseArea()
				/// Busca o Item contábil da conta
		    	cQuery:=" SELECT Z2_SUBC FROM "+RetSqlName("SZ2")
		    	If Alltrim(cCust)=='38165'
					cQuery+=" WHERE Z2_SETOR='38160' AND Z2_SITUAC='0' AND D_E_L_E_T_<>'*'" 
				Else 
					cQuery+=" WHERE Z2_SETOR='"+cCust+"' AND Z2_SITUAC='0' AND D_E_L_E_T_<>'*'" 
				Endif
				cQuery+="   AND SubsTring(Z2_SUBC,5,1)='A' "
				cQuery+="   AND Z2_FILIAL='"+Xfilial("SZ2")+"'"
				TcQuery cQuery Alias QTMP New
				dbSelectArea("QTMP")
				dbGotop()
				If !Eof()
					cItemCta:=QTMP->Z2_SUBC
				Endif				
			
			Endif
				
		Else  
			//Busca o pessoal do Setor de gerenciamento as contas
			cQuery:=" SELECT Z2_SUBC FROM  "+RetSqlName("SZ2")+" SZ2 "
			cQuery+=" WHERE Z2_SETOR='"+AllTrim(cCust)+"'"
			cQuery+="   AND Left(Z2_SUBC,1)<>'9' AND Z2_LETRA='B' AND Z2_SITUAC='0' AND D_E_L_E_T_<>'*'"
			TcQuery cQuery Alias QTMP New
			dbSelectArea("QTMP")
			dbGotop()
			If !Eof()
				cItemCta:=QTMP->Z2_SUBC
			Else
				dbSelectArea("QTMP")
				dbCloseArea()
				cQuery:=" SELECT Z2_SUBC FROM  "+RetSqlName("SZ2")+" SZ2"
				cQuery+=" WHERE Z2_SETOR='"+AllTrim(cCust)+"'"
				cQuery+="  AND Z2_SITUAC='0' AND D_E_L_E_T_<>'*'"
				TcQuery cQuery Alias QTMP New
				dbSelectArea("QTMP")
				dbGotop()
				If !Eof()
					cItemCta:=QTMP->Z2_SUBC				
				Endif	
			Endif		
		Endif
		dbSelectArea("QTMP")
		dbCloseArea()
	   
	   DbSelectArea("TRCENCUS")
	   If !DbSeek(Alltrim(TRABALHO->NumFunc)+cCust)
	      RecLock("TRCENCUS",.T.)
	      Replace NumFunc With TRABALHO->NumFunc  // Codigo do funcionario
	      Replace CentCus With cCust              // Centro de Custo
	   	Replace HorCCus With TRABALHO->HorParc  // Total de horas por func.
	   	Replace ItemCta With  cItemCta  // Total de horas por func.
	   Endif	
	   MsUnLock()
	   
	Endif                                  // e centro de custo
	dbSelectArea("TRABALHO")
   dbSkip()
EndDo
DbSelectArea("TRCENCUS")
DbGoTop()

ProcRegua(lastrec())

While (! Eof())

   IncProc("Gravando lançamentos por Centro de Custo")          

   dbSelectArea("TRABALHO")
   DbSeek(TRCENCUS->NumFunc)

   While ! Eof() .And. (Alltrim(TRABALHO->NumFunc) == Alltrim(TRCENCUS->NumFunc))

      nTotaSala := (TRABALHO->TotApro*TRCENCUS->HorCCus)/TRABALHO->HorParc
      nVlrDes   := (TRABALHO->VlrDes*TRCENCUS->HorCCus)/TRABALHO->HorParc
      nVlrFat   := (TRABALHO->VlrFat*TRCENCUS->HorCCus)/TRABALHO->HorParc
      
      If nTotaSala > 0 .Or. nVlrDes>0 .Or. nVlrFat > 0
	      dbSelectArea("SZ7")
	      dbSetOrder(5)
			dDtBase := CToD("01/"+SubStr(cAnoMesAtu,5,2)+"/"+Left(cAnoMesAtu,4))
         RecLock("SZ7",.T.)
			Replace Z7_FILIAL	With xFilial("SZ7"),;
         			Z7_CCUSTO	With TRCENCUS->CentCus,; // Centro de Custo
         			Z7_ITEMCTA	With TRCENCUS->ITEMCTA,;
			        Z7_NUMFU	With TRCENCUS->NumFunc,;     // Codigo do Funcionario
					Z7_CONTCRE	With TRABALHO->ContCre,;     // Conta contabil credito  
					Z7_CONTDEB	With TRABALHO->ContDeb,;     // Conta contabil debito
	        		Z7_CONTFAT	With TRABALHO->ContFat,;     // Conta contabil debito							
	        		Z7_DTLANC   With dDtBase,;               // DataBase
	     			Z7_VLHOPER	With Z7_VLHOPER + nTotaSala,; // Total de horas no periodo
				    Z7_VLRDES	With Z7_VLRDES  + nVlrDes,;   // valor Desconto
				    Z7_VLRFAT	With Z7_VLRFAT  + nVlrFat     // valor Faturado
	                 
	      MsUnLock()
      Endif 
      DbSelectArea("TRABALHO")
      DbSkip()
   EndDo
   
   DbSelectArea("TRCENCUS")
  	DbSkip()   
     
EndDo  
//
MailSemFip()


DbSelectArea("TRCENCUS")
dbCloseArea()
DbSelectArea("FIP")
dbCloseArea()
DbSelectArea("TRABALHO")
dbCloseArea()

dbSelectArea("SRA")
MsgBox("Processo Finalizado!")
Return()



Static Function MailSemFip()
*********************************************************************************************************************
*
*
*****
Local cEol:=Chr(13)+Chr(10)
Local nFile:=FCreate(__RELDIR +'SEMFIP.##R')
Local cMat:='*'
Local cCabMail :=""
Local cCorpMail:=""
Local cCust:="*"
Local cArq5 := CriaTrab("",.F.)
Local cAccount  := GetMv("MV_WFACC") 
Local cCtaPass  := GetMv("MV_WFPASSW")
Local cCtaSmpt  := GetMv("MV_WFSMTP") 
Local cSendBy   := GetMv("MV_RESFIP",,'giovanapereira@tsamg.com.br')

cCtaMail:=cSendBy

cCabMail :="  Prezado usuário,
cCabMail +="  O processo de rateio da FIP foi realizado, porem existem  "+cEol
cCabMail +="  funcionários sem FIP.Segue abaixo a lista para que seja   "+cEol
cCabMail +="  tomada as devidas providências."+cEol
cCabMail +=" ==========================================================="+cEol
cCabMail +="    RELAÇÃO DE FUNCIONÁRIOS SEM FIP POR CENTRO DE CUSTO     "+cEol
cCabMail +=" -----------------------------------------------------------"+cEol

dbSelectArea("TRABALHO")
IndRegua("TRABALHO",cArq5,"CentCus+NomeFunc",,,"Reordenando os Registros ...")
dbGoTop()
While !Eof()
	If Empty(TemFip)
		If cCust<>CentCus
			cCorpMail+=cEol+'Setor:'+CentCus+' - '+Posicione("CTT",1,Xfilial("CTT")+CentCus,"CTT_DESC01")+cEol
         cCorpMail+=" -----------------------------------------------------------"+cEol
			cMAt:='*'     
			cCust:=CentCus
		Endif
		If cMat<>TRABALHO->NumFunc
			cMat:=TRABALHO->NumFunc
			cCorpMail+='  '+TRABALHO->NumFunc+' - '+TRABALHO->NomeFunc+' Sit:'+TRABALHO->SitFolh+cEol
		Endif
   EndIf
   dbSelectArea("TRABALHO")
   dbSkip()
EndDo
cCorpMail+=" ==========================================================="+cEol+cEol


FWrite(nFile,cCabMail+cCorpMail)
FClose(nFile)

CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
SEND MAIL FROM  cSendBy TO  cCtaMail ; 
SUBJECT 'Processo de Rateio da FIP' ;
BODY cCabMail+cCorpMail

DISCONNECT SMTP SERVER



