/*
+-----------------------------------------------------------------------------+
| Programa  | PMSREVISA| Desenvolvedor |                  | Data | 25/04/2006 |
|-----------------------------------------------------------------------------|
| Descricao |Acerta a Descrição das Tarefas retornando os acentos             |
|-----------------------------------------------------------------------------|
| Uso       | Especifico EPC Engenharia                                       |
|-----------------------------------------------------------------------------|
|                  Modificacoes desde a construcao inicial                    |
|-----------------------------------------------------------------------------|
| Responsavel  | Data      | Motivo                                           |
|-----------------------------------------------------------------------------|
|              |           |                                                  |
+--------------+-----------+--------------------------------------------------+
*/

#Include "TopConn.ch"
User Function PMSREVISA()
**************************************************************************************************************
*
*
*******
Local cCodProj:=AF8->AF8_PROJET
Local cVerAtu:=Paramixb[2]
Local cCodRev:=Paramixb[3]
// Esta rotina não será executado
/*
cQuery:=" UPDATE "+RetSqlName("AF9")+" SET "
cQuery+=" AF9_TAREFA=(SELECT AF9D.AF9_TAREFA "
cQuery+="	    FROM "+RetSqlName("AF9")+" AF9D "
cQuery+="            WHERE AF9D.AF9_PROJET='"+cCodProj+"'       AND "
cQuery+="                  '"+cVerAtu+"'=AF9D.AF9_REVISA        AND "
cQuery+="                  SUBSTRING(AF9D.AF9_TAREFA,4,30)=SUBSTRING(AF9.AF9_TAREFA,4,30)  AND "
cQuery+="                  AF9D.AF9_FILIAL='"+Xfilial("AF9")+"' AND  "
cQuery+="                  AF9D.D_E_L_E_T_<>'*') "
cQuery+=" FROM "+RetSqlName("AF9")+" AF9 "
cQuery+=" WHERE AF9.AF9_PROJET='"+cCodProj+"' AND AF9_REVISA='"+cCodRev+"'"
cQuery+="  AND AF9D.AF9_FILIAL='"+Xfilial("AF9")+"' AND AF9.D_E_L_E_T_<>'*'"   
TCSqlExec(cQuery)
*/

Return
