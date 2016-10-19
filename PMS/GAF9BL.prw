#include "rwmake.ch"        
#include "TopConn.ch"
#include "Ap5mail.ch"


User Function PM110AF8() 
****************************************************************************************************************
*
*
***** 
Local cQuery1     

dbSelectArea("AF9")                                     

cQuery1:=" UPDATE "+RetSqlName("AF9")+" SET AF9010.AF9_REV_BL=AF8_REV_BL,AF9_INICBL=Isnull(AF92.AF9_START,AF9010.AF9_START),AF9_FINABL=Isnull(AF92.AF9_FINISH,AF9010.AF9_FINISH) "
cQuery1+=" FROM "+RetSqlName("AF9")+" AF9 "
cQuery1+=" INNER JOIN "+RetSqlName("AF8")+" AF8 ON (AF8.AF8_PROJET=AF9010.AF9_PROJET AND AF8.AF8_REVISA=AF9010.AF9_REVISA AND AF8.D_E_L_E_T_<>'*' ) "
cQuery1+=" LEFT OUTER JOIN "+RetSqlName("AF9")+" AF92 ON (AF9010.AF9_TAREFA=AF92.AF9_TAREFA AND AF9010.AF9_PROJET=AF92.AF9_PROJET AND AF92.AF9_REVISA=AF8.AF8_REV_BL AND AF9010.AF9_FILIAL=AF92.AF9_FILIAL AND AF92.D_E_L_E_T_<>'*') "
cQuery1+=" WHERE AF9010.D_E_L_E_T_<>'*' AND AF9010.AF9_REV_BL <> AF8_REV_BL"  
cQuery1+=" AND AF9_PROJET = '"+AF8->AF8_PROJET+"'"

TCSqlExec(cQuery1)
Return()
