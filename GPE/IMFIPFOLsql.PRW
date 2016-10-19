#include "rwmake.ch"
#include "topconn.ch"  

User Function IMFIP()       
***************************************************************************************************************
*
*
*****
Local cMens:="Este programa tem como Objetivo gerar o rateio dos lançamentos da Folha de Pgto Ref ao Mes:"+Left(cMesAtu,2)+'/'+Right(cMesAtu,4)
Private lTestPath:= .F.
Private nLastKey := 0
Private cArq1    := ""
Private cInd1	  := CriaTrab(,.f.)
Private cArq2    := ""
Private cInd2    := ""
Private cArq3    := ""
Private cInd3    := ""
Private cAnoMesAtu  := GetMv("MV_FOLMES")
Private cDireArqu := "\\epcs02_11_9733\D\Protheus8\Protheus_Data\download\"
Private cPerg:="GERFIP"
Private aPerg:={}

cArquFIP  := "FIP.DBF"
cArq1     := cDireArqu+cArquFIP
If !file(cArq1) 
   MsgStop( " Arquivo  "+cArquFIP+" nao se encontra no "+Chr(13)+Chr(10)+;
            " diretorio "+cPathArqu)
   Return()
Else
	//Valida o Mes e Ano do Arquivo com o Mes ATual
	
EndIf

AADD(aPerg,{cPerg,"Competencia Ano Mes?","C",06,0,"G","!Empty(MV_PAR01)","","","","","",""})

ExecBlock("TestaSX1",.F.,.F.,{cPerg,aPerg})
Pergunte(aPerg,.T.)

BatchProcess("Gerar Rateio da Folha de Pgto",cMens,aPerg,{|| Processa({||(FCriaArqSQL(),GeraVR(.T.))},"Aguarde","Processando...")})

Return()

Static Function FCriaArqSQL()
******************************************************************************
* Criacao de arquivos de trabalho
*
*** 
Local cQuery := ""
Local cQueryPAM := ""

dbUseArea( .T.,,cArq1,"FIP",.F.,.F.)
IndRegua("FIP",cInd1,"Matr_Fi",,,"Selecionando Registros...")

aStru := {}
AADD(aStru, {"NumFunc","C", 06, 0 })
AADD(aStru, {"TotApro","N", 16, 2 })
AADD(aStru, {"HorParc","N", 06, 2 })
AADD(aStru, {"ContCre","C", 20, 0 })
AADD(aStru, {"ContDeb","C", 20, 0 })
AADD(aStru, {"VlrDes","N", 15, 2 })
AADD(aStru, {"VlrFat","N", 15, 2 })

cArq4 := CriaTrab(aStru, .T.)
dbUseArea(.T.,, cArq4, "TRABALHO",.F.)

dbSelectArea("TRABALHO")
IndRegua("TRABALHO",cArq4,"NumFunc+ContDeb",,,"Criando Arquivo Trabalho ...")

aStru := {}
AADD(aStru, {"NumFunc","C", 06, 0 })
AADD(aStru, {"CentCus","C", 09, 0 })
AADD(aStru, {"ItemCta","C", 09, 0 })
AADD(aStru, {"HorCCus","N", 06, 2 })

cArq5 := CriaTrab(aStru, .T.)
dbUseArea(.T.,, cArq5, "TRCENCUS",.F.)

dbSelectArea("TRCENCUS")
IndRegua("TRCENCUS",cArq5,"NumFunc+CentCus+ItemCta",,,"Criando Arquivo Trabalho ...")

Return



Static Function FGravArqSQL()
*****************************************************************************
* Gravacao de Arquivo para Exportacao
*
***

Pergunte(aPerg,.f.)

DbSelectArea("FIP")
dbGoTop()           
If FIP->MES_ANO_FI <> Substr(MV_PAR01,5,2)+Substr(MV_PAR01,1,2)
	MsgStop("O arquivo FIP está com data diferente da data de refêrencia!")
	Return
EndIf
dbSelectArea("SRC")
aStruct:=dbStruct()

If  MV_PAR01==cAnoMesAtu
	cQuery:=" SELECT RC_MAT,RC_PD,RC_VALOR FROM "+RetSqlName("SRC")
	cQuery+=" WHERE D_E_L_E_T_<>'*' AND RC_FILIAL BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'"
	cQuery+=" ORDER BY RC_MAT,RC_PD
Else      
	cQuery:=" SELECT RD_MAT RC_MAT,RD_PD RC_PD,RC_VALOR RD_VALOR FROM "+RetSqlName("SRD")
	cQuery+=" WHERE D_E_L_E_T_<>'*' AND RD_FILIAL BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'"
	cQuery+="  AND RD_DATARQ='"+MV_PAR01+"'"
	cQuery+=" ORDER BY RD_MAT,RD_PD
Endif
TcQuery cQuery Alias QSRC New
DbSelectArea("QSRC")
TCSetField('QSRC', "RC_VALOR", "N", 12,3)



DbSelectArea("QSRC")
ProcRegua(RecCount())

While !Eof() 
	IncProc()
	
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If !dbSeek(xFilial("SZ6")+ALLTRIM(QSRC->RC_PD)) // buscava verba do PAM
		dbSelectArea("QSRC")
		DbSkip()
		Loop
	EndIf

	DbSelectArea("TRABALHO")
	If !DbSeek(AllTrim(QSRC->RC_MAT)+SZ6->Z6_CONTDEB)

		RecLock("TRABALHO",.T.)
		Replace NumFunc With QSRC->RC_MAT
		Replace ContCre With SZ6->Z6_CONTCRN
		Replace ContDeb With SZ6->Z6_CONTDEB
	Else
		RecLock("TRABALHO",.F.)
	EndIf

	If SZ6->Z6_VRBDESC != "S" .AND. SZ6->Z6_SINAL == "-"
		Replace TotApro With TotApro - QSRC->RC_VALOR // Total da apropriacao da verba negativa
	Else
		If SZ6->Z6_VRBDESC != "S" .AND. SZ6->Z6_SINAL == "+"
			Replace TotApro With TotApro + QSRC->RC_VALOR  // Total da apropriacao da  verba positiva   
		EndIf                                          
	EndIf
 
	If SZ6->Z6_VRBDESC == "S" .AND. SZ6->Z6_SINAL == "-"
		Replace VlrDes With VlrDes - QSRC->RC_VALOR //  Com Desconto
	EndIf                     
  
	If SZ6->Z6_VRBDESC == "S" .AND. SZ6->Z6_SINAL == "+" 
	   If  alltrim(Substr(SZ6->Z6_CONTDEB,1,4)) == '3191' .or. alltrim(Substr(SZ6->Z6_CONTDEB,1,4)) == '3192'
	     	Replace VlrFat With VlrFat + QSRC->RC_VALOR - VlrDes
	   Else
	     	Replace VlrFat With VlrFat + QSRC->RC_VALOR
	   Endif  	 
	EndIf
	
	MsUnLock()

	If QSRC->RC_PD$'280/281/101'
		nTotHoras:=0
		If QSRC->RC_PD$'280/281'
			nTotHoras:=QSRC->RC_HORAS
		Else  
			nTotHoras:=RC_HORAS*(SRA->(RA_HRSMES)/30)
		Endif
		//Faz o Rateio das Horas
		DbSelectArea("FIP")
		dbSeek(Substr(QSRC->RC_MAT,2))

		While (! Eof()) .And. Alltrim(SubStr(FIP->Matr_Fi,1,5)) == Substr(QSRC->RC_MAT,2)
   	
			If Empty(FIP->Cod_STA) .Or. SubStr(FIP->Cod_STA,1,4) == "9999" .Or. (SubStr(FIP->Cod_STA,1,1) == "9" .AND. SubStr(FIP->Cod_STA,5,1) == "F")  
				DbSelectArea("FIP")
				DBSkip()
				Loop
			EndIf

			If FIP->Seq_FI == 998 .Or. FIP->Seq_FI == 999
				DbSelectArea("FIP")
				DBSkip()
				Loop
			EndIf
	
	      DbSelectArea("TRABALHO")
	
			RecLock("TRABALHO",.F.)
			Replace HorParc With TRABALHO->HorParc + FIP->THonor_FI  // Total de Horas por func.
			MsUnLock()
			dbSelectArea("FIP")
			DbSkip()
		EndDo		
	Endif  
	dbSelectArea("SRC")
	DbSkip()
EndDo  
dbSelectArea("QSRC")
dbCloseArea()

//Faz o Rateio Por Centro de Custo
DbSelectArea("FIP")
dbGoTop()
While (! Eof())
   If Empty(FIP->Cod_STA) .Or. SubStr(FIP->Cod_STA,1,4) == "9999"
      DbSelectArea("FIP")
      DBSkip()
      Loop
   EndIf

   If FIP->Seq_FI == 998 .Or. FIP->Seq_FI == 999
      DbSelectArea("FIP")
      DBSkip()
      Loop
   EndIf
	SRA->(dbSeek(Xfilail("SRA")+'0'+SubStr(FIP->Matr_Fi,1,5)))
   DbSelectArea("TRCENCUS")
   If !DbSeek('0'+SubStr(FIP->Matr_Fi,1,5)+SRA->RA_CC+FIP->Cod_STA)
      
      RecLock("TRCENCUS",.T.)
      Replace NumFunc With '0'+SubStr(FIP->Matr_Fi,1,5)  // Codigo do funcionario
      Replace CentCus With SRA->RA_CC                    // Centro de Custo
      Replace ItemCta With FIP->Cod_STA                  // Centro de Custo
   Else
      RecLock("TRCENCUS",.F.)
   EndIf

   Replace HorCCus With HorCCus + FIP->THonor_FI  // Total de horas por func.
   MsUnLock()                                  // e centro de custo

   dbSelectArea("FIP")
   DbSkip()
EndDo

DbSelectArea("TRCENCUS")
DbGoTop()

ProcRegua(lastrec())

While (! Eof())

   IncProc()          

   dbSelectArea("TRABALHO")
   DbSeek(TRCENCUS->NumFunc)

   While ! Eof() .And. (alltrim(TRABALHO->NumFunc) == alltrim(TRCENCUS->NumFunc))

      nTotaSala := (TRABALHO->TotApro*TRCENCUS->HorCCus)/TRABALHO->HorParc
      nVlrDes := (TRABALHO->VlrDes*TRCENCUS->HorCCus)/TRABALHO->HorParc
      nVlrFat := (TRABALHO->VlrFat*TRCENCUS->HorCCus)/TRABALHO->HorParc

      dbSelectArea("SZ7")
      dbSetOrder(4)
      If !DbSeek(xFilial("SZ7")+TRCENCUS->NumFunc+alltrim(SubStr(TRCENCUS->CentCus,1,5))+TRCENCUS->ITEMCTA+TRABALHO->ContDeb)
			
			dDtBase := CToD("01/"+SubStr(cMesBase,1,2)+"/"+SubStr(cMesBase,3,4))
         RecLock("SZ7",.T.)
			Replace  Z7_Filial	With xFilial("SZ7"),;
         			Z7_CCusto	With SubStr(TRCENCUS->CentCus,1,5),; // Centro de Custo
         			Z7_ITEMCTA	With TRCENCUS->ITEMCTA,;
						Z7_NUMFU	   With TRCENCUS->NumFunc,;     // Codigo do Funcionario
						Z7_ContCre	With TRABALHO->ContCre,;  // Conta contabil credito  
						Z7_ContDeb	With TRABALHO->ContDeb,;  // Conta contabil debito
	        			Z7_DtLanc With dDtBase              // DataBase
      Else
         RecLock("SZ7",.F.)
      EndIf
     	Replace  Z7_VlHoPer	With Z7_VlHoPer + nTotaSala,; // Total de horas no periodo
			      Z7_VLRDES	With Z7_VLRDES + nVlrDes,;    // valor Desconto 
			      Z7_VLRFAT	With Z7_VLRFAT + nVlrFat    // valor Faturado    
                 
      MsUnLock()
   
      DbSelectArea("TRABALHO")
      DbSkip()
   EndDo
   
   DbSelectArea("TRCENCUS")
  	DbSkip()   
     
EndDo
MsgBox("Processo Finalizado!")
Return()