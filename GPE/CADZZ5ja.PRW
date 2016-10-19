

#Include "Rwmake.ch"   
#include "TopConn.ch"
#include "Ap5mail.ch"

/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  | GP670CPO  | Autor    | Jane M. Duval           |Data  |24.09.2007 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao |                                            |
+----------+-------------------------------------------------------------------+
| USO      |  Especifico                                                       |
+----------+-------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                         |
+----------+-----------+-------------------------------------------------------+
|Autor     | Data      | Descricao                                             |
+----------+-----------+-------------------------------------------------------+
|          |           |                                                       |
+----------+-----------+-------------------------------------------------------+  
 */ 
                                                     

User Function CADZZ5()
********************************************************************************************************
*
*
**** 


SetPrvt("APOS,CCADASTRO,AROTINA,")

aPos:={08,11,11,70}                                        
cCadastro:="Extrato de Horas "
aRotina:={{"Pesquisar"         ,'AxPesqui'  ,0,1},;    
          {"Visualizar"        ,'AxVisual'  ,0,2},;    
          {"Incluir"           ,'AxInclui'  ,0,3},;    
          {"Alterar"           ,'AxAltera'  ,0,4},;    
          {"Excluir"           ,'AxDeleta'  ,0,5},;   
          {"Calc. Ext Horas "  ,'U_CalcHor' ,0,6}}

                                        
dbSelectArea("ZZ5")         
dbSetOrder(1)               //Filial+Codigo
mBrowse(06,08,22,71,"ZZ5",,) 


                                  
Return() 

User Function TestaPerg()
********************************************************************************************************************
*
*
********

Return()	    

Static Function ZerCam() 
*******************************************************************************************************************
* Função para Zerar Campos
*
***
 
M->ZZ5_NOME   := Space(40)  
M->ZZ5_PERIOD := Space(6)
M->ZZ5_CREDIT := Space(8)
M->ZZ5_DEBITO := Space(8) 
M->ZZ5_STATUS := Space(2)
M->ZZ5_CODFOR := Space(6)
M->ZZ5_FORNEC := Space(40)

Return()

User Function CalcHor()
************************************************************************************************************************
*
*
*******


Private cQuery1   :=""
Private cQuery    :="" 
Private nSaldo    :=0


aPerg := {}          
cPerg :="CADZZ5"
AADD(aPerg,{cPerg,"Ano/Mês(AAAAMM)Ref.?","C",06,0,"G","U_TestPerg(MV_PAR01)","","","","","",""}) 
AADD(aPerg,{cPerg,"Matricula De       ?","C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"Matricula Ate      ?","C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"C.Custo   De       ?","C",06,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"C.Custo   Ate      ?","C",06,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"Refaz saldo Existente ?","N",01,0,"C","","","Sim","Não","","",""}) 


ExecBlock("TestaSX1",.F.,.F.,{cPerg,aPerg}) 

Pergunte(cPerg,.T.)  
                         
Private cPeriodo := MV_PAR01
Private cMatrDe  := MV_PAR02
Private cMatrAt  := MV_PAR03
Private cCustDe  := MV_PAR04
Private cCustAt  := MV_PAR05 
Private nRefSal  := MV_PAR06 
Private cPerAnt  := VAL(cPeriodo)-1  


dbSelectArea("SZZ") 
                                    

cQuery:=" SELECT DISTINCT  ZZ_FILIAL,ZZ_PERIODO,ZZ_MAT,RA_CC,RA_NOME,A2_COD CODFOR,A2_NOME Fornec,"
cQuery+="        (SELECT dbo.MinToHr(SUM(dbo.HrToMin(Z.ZZ_QHRBCO)))
cQuery+="					  FROM SZZ010 Z"
cQuery+="					  WHERE Z.D_E_L_E_T_<>'*'"
cQuery+="					  AND Z.ZZ_PERIODO=SZZ.ZZ_PERIODO"
cQuery+="					  AND Z.ZZ_MAT=SZZ.ZZ_MAT) CREDITO,"
cQuery+="        (SELECT dbo.MinToHr(SUM(dbo.HrToMin(Z.ZZ_QHRCOMP)))
cQuery+="					  FROM SZZ010 Z"
cQuery+="					  WHERE Z.D_E_L_E_T_<>'*'"
cQuery+="					  AND Z.ZZ_PERIODO=SZZ.ZZ_PERIODO"
cQuery+="					  AND Z.ZZ_MAT=SZZ.ZZ_MAT) DEBITO"
cQuery+=" FROM "+RetSqlName("SZZ")+" SZZ "
cQuery+=" LEFT OUTER JOIN "+RetSqlName("SRA")+" SRA ON (SRA.D_E_L_E_T_<>'*' AND RA_DEMISSA='' AND ZZ_MAT=RA_MAT) "
cQuery+=" LEFT OUTER JOIN "+RetSqlName("SA2")+" SA2 ON (SA2.D_E_L_E_T_<>'*' AND RA_FOR=A2_COD ) "
cQuery+=" WHERE SZZ.D_E_L_E_T_<>'*'  "  
cQuery+=" AND ZZ_PERIODO =     '"+cPeriodo+"'" 
cQuery+=" AND ZZ_MAT BETWEEN   '"+cMatrDe+"'AND '"+cMatrAt+"'"
cQuery+=" AND RA_CC BETWEEN    '"+cCustDe+"'AND '"+cCustAt+"'"
	
TCQUERY cQuery Alias QTMP1 New

dbSelectArea("QTMP1")
dbGotop() 
While !Eof() 

		dbSelectArea("ZZ5")      	
		Reclock("ZZ5",!dbSeek(Xfilial("ZZ5")+QTMP1->ZZ_PERIODO+QTMP1->ZZ_MAT))
					Replace ZZ5_FILIAL    With Xfilial("SZZ"),;
						ZZ5_MAT       With QTMP1->ZZ_MAT,;
		        		ZZ5_PERIODO   With QTMP1->ZZ_PERIODO,;
		        		ZZ5_NOME      With QTMP1->RA_NOME,;
		        		ZZ5_CREDIT    With QTMP1->CREDITO,;
			 	  		ZZ5_DEBITO    With QTMP1->DEBITO,;
		       		ZZ5_CODFOR    With QTMP1->CODFOR,;
			 	  		ZZ5_FORNEC    With QTMP1->FORNEC ,;			 	  		
			     		ZZ5_STATUS    With ''     
	  				MsUnlock()
	  				
		nSaldoAtual:=(QTMP1->CREDITO - QTMP1->DEBITO) - nSaldo  
		

			 
	dbSelectArea("QTMP1")
	dbSkip()
EndDo 

Return()
User Function ConvtHoras()
********************************************************************************************************************
*
*
*************** 
lRet:=.t.  

Private cDebi:= (LEFT(ALLTRIM(STR(M->ZZ5_DEBITO)),2)+'.'+ ALLTRIM(RIGHT(Str(M->ZZ5_DEBITO),2))) 
Private cCred:= (LEFT(ALLTRIM(STR(M->ZZ5_CREDIT)),2)+'.'+ ALLTRIM(RIGHT(Str(M->ZZ5_CREDIT),2))) 

      /*If VAL(ALLTRIM(RIGHT(Str(M->ZZ5_CREDIT),2)))> 60
          Alert('Hora lançada Inválida.')
          lRet:=.f.
      Else      	
      	dbSelectArea("ZZ5")      	
	  		Reclock("ZZ5",!dbSeek(Xfilial("ZZ5")+M->ZZ5_PERIODO+ M->ZZ5_MAT))
					Replace ZZ5_CREDIT    With cCred ,;
			 	           ZZ5_DEBITO    With cDebi
	  		MsUnlock()
		EndIf  */

Return()

User Function ValidMat()
********************************************************************************************************************
*
*
******** 
Local cQuery2:=""
Local lRet:=.t.

Private cMatr:=M->ZZ5_MAT  

dbSelectArea("SRA") 
                                    

cQuery2:=" SELECT DISTINCT  RA_FILIAL,RA_MAT,RA_CC,RA_NOME,ISNULL(A2_COD,'') CODFOR,ISNULL(A2_NOME,'') Fornec"
cQuery2+=" FROM "+RetSqlName("SRA")+" SRA "
cQuery2+=" LEFT OUTER JOIN "+RetSqlName("SA2")+" SA2 ON (SA2.D_E_L_E_T_<>'*' AND RA_FOR=A2_COD ) "
cQuery2+=" WHERE SRA.D_E_L_E_T_<>'*' AND RA_DEMISSA='' "  
cQuery2+=" AND RA_MAT =   '"+cMatr+"'
	
TCQUERY cQuery2 Alias QTMAT New 
 
dbSelectArea("QTMAT")
If !Eof()
   ZerCam()
	M->ZZ5_NOME:=QTMAT->RA_NOME
	If !Empty(QTMAT->CODFOR)
		M->ZZ5_CODFOR:=QTMAT->CODFOR
		M->ZZ5_FORNEC:=QTMAT->Fornec 
	End
Else
	Alert("Matricula não Cadastrada" ) 
	lRet:=.f.
EndIf  


//dbSelectArea("QTMP1")
//dbCloseArea()

Return(lRet)


Return()
            