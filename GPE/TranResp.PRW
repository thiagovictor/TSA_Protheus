#include "rwmake.ch"        
#include "TopConn.ch"
#include "Ap5mail.ch"

/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  | GP670CPO  | Autor    | Jane M. Duval           |Data  |12.09.2007 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao |Transfencia de Responsável Direto                                  |
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
                                                     

User Function TRANSRESP()
********************************************************************************************************
*
*
****

SetPrvt("APOS,CCADASTRO,AROTINA,")

aPos:={08,11,11,70}                                        
cCadastro:="Transfência de Responsavel Direto"
aPerg := {}
cPerg :="TRARES" 
AADD(aPerg,{cPerg,"Mat. Responsavel  De      ?","C",06,0,"G","U_TestMAT(MV_PAR01)","SRA","","","","",""})
AADD(aPerg,{cPerg,"Mat. Responsavel  Para     ?","C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"C. Custo De     ?","C",06,0,"C","","CTT","","","","",""})
AADD(aPerg,{cPerg,"C. Custo Ate    ?","C",06,0,"C","","CTT","","","","",""}) 



If Pergunte(cPerg,.T.) 
	ValidResp()
Endif  

dbCloseArea("QTMP") 
Return() 

User Function TestMat(MV_PAR01)
****************************************************************************************************************
* Testa se a matricula digitada e de algum responsavel cadastrado no sistema
*
************ 
Local   lRet   := .t.
Local   cQuery :="" 
Local   cMat   :=MV_PAR01


cQuery:= " SELECT RA_MAT,RA_CC"
cQuery+= " FROM "+RetSqlName("SRA")+" SRA "
cQuery+= " INNER JOIN "+RetSqlName("CTT")+" CTT ON (CTT.D_E_L_E_T_<>'*' AND CTT.CTT_CUSTO=SRA.RA_CC  ) "   
cQuery+= " WHERE  SRA.D_E_L_E_T_<>'*' AND RA_DEMISSA='' "
cQuery+= " AND CTT_MATRES = '"+cMat+"'    "


TCQUERY cQuery Alias QTMP New
dbSelectArea("QTMP")
dbGotop()
If EOF()
	Alert("Matricula digitada não existe no cadastro de Responsavel por Setor") 
	lRet:=.f.
EndIf
dbCloseArea() 
Return(lRet) 
 
Static Function ValidResp()
****************************************************************************************************************
* Faz a transferencia  de responsabilidade
*
*****

Local   cQuery1     :=""  
Private cMatDe      := MV_PAR01  
Private cMatAt      := MV_PAR02 
Private cCusDe      := MV_PAR03  
Private cCusAt      := MV_PAR04


cQuery1:= " SELECT RA_MAT,RA_CC"
cQuery1+= " FROM "+RetSqlName("SRA")+" SRA "
cQuery1+= " INNER JOIN "+RetSqlName("CTT")+" CTT ON (CTT.D_E_L_E_T_<>'*' AND CTT.CTT_CUSTO=SRA.RA_CC  ) "   
cQuery1+= " WHERE  SRA.D_E_L_E_T_<>'*' AND RA_DEMISSA='' AND  "
cQuery1+= " RA_CC BETWEEN '"+cCusDe+"' AND  '"+cCusAt+  "'"


TCQUERY cQuery1 Alias QTRES New
dbSelectArea("QTRES")
dbGotop()

While !EOF() 

	dbSelectArea("CTT")
	RecLock('CTT',!dbSeek(Xfilial("CTT")+QTRES->RA_CC))
	Replace CTT_MATRES With cMatAt
	MsUnlock()
	
	dbSelectArea("QTRES")
	dbSkip()	
EndDo  

dbSelectArea("QTRES")
dbCloseArea()   

Return()                                                                                                      
