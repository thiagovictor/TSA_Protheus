#include "rwmake.ch"        
#include "TopConn.ch"
#include "Ap5mail.ch"

/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  | GP670CPO  | Autor    | Jane M. Duval           |Data  |08.01.2007 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao | Cadastro de Pedencias                                             |
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
                                                     

User Function AtuaFac()
********************************************************************************************************
*
*
****

SetPrvt("APOS,CCADASTRO,AROTINA,")

aPos:={08,11,11,70}                                        
cCadastro:="Pendencias de PJ"

cPerg :="ATUFAC"
AADD(aPerg,{cPerg,"Ano/Mês(AAAAMM)Ref.?","C",06,0,"G","U_TestPerg(MV_PAR01)","","","","","",""}) 
AADD(aPerg,{cPerg,"Matricula De      ?","C",02,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"Matricula Ate     ?","C",02,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"Novo Turno      ?","C",05,0,"G","","SR6","","","","",""})
AADD(aPerg,{cPerg,"Atualiza FAC ?","N",01,0,"C","","","Sim","Não","","",""}) 
AADD(aPerg,{cPerg,"Dif. horas como Banco    ?","C",01,0,"G","","","Sim","Não","","",""})



If Pergunte(cPerg,.T.)                                                                
	ValidProc()
EndIf

Return() 

User Function ValidProc()
****************************************************************************************************************
* Apresenta a Tela de Inclusão das Pendencias
*
*****

Local cQuery        :=""  
private oDlg 
private dDatbaix
Private cMesRef     := MV_PAR01
Private cMatDe      := MV_PAR02  
Private cMatAt      := MV_PAR03
Private cNovTu      := StrZero(MV_PAR04,1)
Private cHorBa      := StrZero(MV_PAR05,1)


cQuery:= "SELECT ZZ_MAT"
cQuery+= " FROM "+RetSqlName("SZZ")+" SZZ "
cQuery+= " WHERE "   
cQuery+= " SZZ.D_E_L_E_T_<>'*'  "
cQuery+= " AND ZZ_PERIODO  = '"+cMesRef+"'    "
cQuery+= " AND ZZ_MATLIB <>''    "
cQuery+= " AND ZZ_MAT BETWEEN '"+cMatDe+"' AND  '"+cMatDe+  "'"

TCQUERY cQuery Alias QTMP New
dbSelectArea("QTMP")
dbGotop()
While !EOF()
	TCSPExec(xProcedures("sp_AtuaFac"),QTMP->ZZ_MAT)
dbSkip()	
EndDo

dbCloseArea()
Return()

Return()
