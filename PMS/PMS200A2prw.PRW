#include "rwmake.ch"        
#include "TopConn.ch"
#include "Ap5mail.ch"


User Function PMS200A2() 
****************************************************************************************************************
*
*
***** 
Local cQuery1     

dbSelectArea("AF9")                                     
cAF9010:=RetSqlName("AF9")
cQuery1:=" UPDATE "+cAF9010+" SET "+cAF9010+".AF9_REV_BL=AF8_REV_BL,AF9_INICBL=Isnull(AF92.AF9_START,"+cAF9010+".AF9_START),AF9_FINABL=Isnull(AF92.AF9_FINISH,"+cAF9010+".AF9_FINISH) "
cQuery1+=" FROM "+cAF9010+" 
cQuery1+=" INNER JOIN "+RetSqlName("AF8")+" AF8 ON (AF8.AF8_PROJET=AF9010.AF9_PROJET AND AF8.AF8_REVISA=AF9010.AF9_REVISA AND AF8.D_E_L_E_T_<>'*' ) "
cQuery1+=" LEFT OUTER JOIN "+cAF9010+" AF92 ON ("+cAF9010+".AF9_TAREFA=AF92.AF9_TAREFA AND "+cAF9010+".AF9_PROJET=AF92.AF9_PROJET AND AF92.AF9_REVISA=AF8.AF8_REV_BL AND "+cAF9010+".AF9_FILIAL=AF92.AF9_FILIAL AND AF92.D_E_L_E_T_<>'*') "
cQuery1+=" WHERE "+cAF9010+".D_E_L_E_T_<>'*' AND AF9010.AF9_REV_BL <> AF8_REV_BL"  
cQuery1+=" AND "+cAF9010+".AF9_PROJET = '"+AF8->AF8_PROJET+"'"

TCSqlExec(cQuery1)
Return()
