#include "RWMAKE.CH"
/*
+-----------------------------------------------------------------------------+
| Programa  |          | Desenvolvedor |                  | Data | 25/04/2006 |
|-----------------------------------------------------------------------------|
| Descricao |Ponto de entrada utilizado para informar os campos CCusto,       |
|-----------------------------------------------------------------------------|
|                                             						  |
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


User Function PMA001FIM()
******************************************************************************************************************************
* Este ponto de entrada Atualiza o cadastro do tarefas do projeto
*
*****

Local cTeste := ""

/*
//Acerto no código da EDT
cQuery:=" UPDATE "+RetSqlName("AFC")+" SET "
cQuery+=" AFC_EDT='01'+SUBSTRING(AFC_EDT,3,30), "
cQuery+=" AFC_EDTPAI=CASE WHEN AFC_EDTPAI='"+AF8->AF8_PROJET+"' THEN AFC_EDTPAI ELSE '01'+SUBSTRING(AFC_EDTPAI,3,30) END"
cQuery+=" FROM "+RetSqlName("AFC")+" AFC "
cQuery+=" WHERE AFC.AFC_PROJET='"+AF8->AF8_PROJET+"' AND AFC_REVISA='"+AF8->AF8_REVISA+"'"
cQuery+="  AND AFC_NIVEL<>'001' "
cQuery+="  AND AFC.AFC_FILIAL='"+Xfilial("AFC")+"' AND AFC.D_E_L_E_T_<>'*'"   
TCSqlExec(cQuery)


//Acerto no código da Tarefa
cQuery:=" UPDATE "+RetSqlName("AF9")+" SET "
cQuery+=" AF9_TAREFA='01'+SUBSTRING(AF9_TAREFA,3,30), "
cQuery+=" AF9_EDTPAI=CASE WHEN AF9_EDTPAI='"+AF8->AF8_PROJET+"' THEN AF9_EDTPAI ELSE '01'+SUBSTRING(AF9_EDTPAI,3,30) END"
cQuery+=" FROM "+RetSqlName("AF9")+" AF9 "
cQuery+=" WHERE AF9.AF9_PROJET='"+AF8->AF8_PROJET+"' AND AF9_REVISA='"+AF8->AF8_REVISA+"'"
cQuery+="  AND AF9.D_E_L_E_T_<>'*'"   
TCSqlExec(cQuery)

aResult:=TCSPExec("AF9_Triguer",AF8->AF8_PROJET)
*/

//Atualiza o campo GED_IDEXC da tabela GEDPMS quando a descricao da tarefa for igual ao numero do documento
cQuery:= "UPDATE GEDPMS 
cQuery += "SET GED_IDEXC=CASE WHEN LEN(GED_NUMDOC) = 18 OR RIGHT(GED_NUMDOC,4) IN('F001') THEN AF9_ID ELSE '' END "
cQuery+= "FROM GEDPMS GED "
cQuery+= "INNER JOIN AF9010 ON RTRIM(AF9_DESCRI) = GED_NUMDOCEPC AND 
cQuery +=                      "AF9_PROJET = '" +AF8->AF8_PROJET  + "' AND "
cQuery+=                       "AF9_REVISA = '" + AF8->AF8_REVISA + "' AND "
cQuery +=                      "AF9_ID <> '' AND D_E_L_E_T_<>'*'"
cQuery+=" WHERE GED_PROJET = '"+AF8->AF8_PROJET+"' "
TcSQLExec(cQuery) 


//Atualiza o campo GED_TAREFA da Tabela GEDPMS utilizando como base O campo AF9_IDEXC.
cQuery:=" UPDATE GEDPMS SET GED_TAREFA=AF9_TAREFA "
cQuery+=" FROM GEDPMS "
cQuery+=" INNER JOIN "+RetSqlName("AF9")+" AF9 ON (AF9_PROJET=GED_PROJET AND AF9_ID=GED_IDEXC AND"
cQuery+="       AF9_REVISA='"+AF8->AF8_REVISA+"' AND D_E_L_E_T_!='*' AND AF9_FILIAL='"+xFilial("AF9")+"')"
cQuery+=" WHERE GED_PROJET='"+AF8->AF8_PROJET+"'"
TcSQLExec(cQuery) 


/*
//Atualiza o campo GED_TAREFA da Tabela GEDPMS utilizando como base O campo AF9_TARCLI.
cQuery:=" UPDATE GEDPMS SET GED_TAREFA=AF9_TAREFA "
cQuery+=" FROM GEDPMS "
cQuery+=" INNER JOIN "+RetSqlName("AF9")+" AF9 ON (AF9_PROJET=GED_PROJET AND AF9_TARCLI=GED_ITEMCRONOG AND"
cQuery+="       AF9_REVISA='"+AF8->AF8_REVISA+"' AND D_E_L_E_T_!='*' AND AF9_FILIAL='"+Xfilial("AF9")+"')"
cQuery+=" WHERE GED_PROJET='"+AF8->AF8_PROJET+"'"
TcSQLExec(cQuery) 
*/

// Limpa o Campo AF9_TARCLI apenas das tarefas que foram atualizadas no GEDPMS
/*cQuery:=" UPDATE "+RetSqlName("AF9")+" SET AF9_TARCLI='' "
cQuery+=" FROM "+RetSqlName("AF9")       
cQuery+=" INNER JOIN GEDPMS ON (AF9_PROJET=GED_PROJET AND AF9_TAREFA=GED_TAREFA ) "
cQuery+=" WHERE AF9_PROJET='"+AF8->AF8_PROJET+"' AND AF9_REVISA='"+AF8->AF8_REVISA+"' AND D_E_L_E_T_!='*' "
cQuery+="   AND AF9_FILIAL='"+Xfilial("AF9")+"' "
*/
//TcSQLExec(cQuery) 

/*
cQuery:=" UPDATE GEDPMS SET GED_TAREFA=AF9_TAREFA "
cQuery+=" FROM GEDPMS "
cQuery+=" INNER JOIN "+RetSqlName("AF9")+" AF9 ON (AF9_PROJET=GED_PROJET AND AF9_TARCLI=GED_TAREFA AND"
cQuery+="       AF9_REVISA='"+AF8->AF8_REVISA+"' AND D_E_L_E_T_!='*' AND AF9_FILIAL='"+Xfilial("AF9")+"')"
cQuery+=" WHERE GED_PROJET='"+AF8->AF8_PROJET+"'"
*/

/*
dbSelectArea("AF9")
dbSetOrder(1)
dbSeek(xFilial("AF9")+AF8->AF8_PROJET+AF8->AF8_REVISA)

While !Eof()                             .And. ;
      AF8->AF8_PROJET == AF9->AF9_PROJET .And. ;
      AF8->AF8_REVISA == AF9->AF9_REVISA 
   
   If AF9->AF9_PERCON > 0
        FGerAvanc()
   EndIf
   
   dbSelectArea("AF9")
   dbSkip()
End
*/

dbSelectArea("AF8")
nRecno:=Recno()
dbGotop()
dbGoto(nRecno)

Return()


Static Function FGerAvanc()
*******************************************************************************************************
*
*
****

dbSelectArea("AFF")
dbSetOrder(1)
dbSeek(xFilial("AFF")+AF9->AF9_PROJET+AF9->AF9_REVISA+AF9->AF9_TAREFA+DTOS(AF9->AF9_START))

If Eof()
   RecLock("AFF",.T.)
   Replace AFF_FILIAL With xFilial("AFF")
   Replace AFF_PROJET With AF9->AF9_PROJET
   Replace AFF_REVISA With AF9->AF9_REVISA
   Replace AFF_TAREFA With AF9->AF9_TAREFA
   Replace AFF_DATA   With AF9->AF9_START
   Replace AFF_USER   With RetCodUsr()
   Replace AFF_CONFIR With "2"
   Replace AFF_QUANT  With AF9->AF9_QUANT * (AF9->AF9_PERCON/ 100)
   MsUnlock()
EndIf
//Executa funcao padrao do sistema para atualização dos campos de Realização da Tarefa e EDT's.
PmsAvalAFF("AFF",1)

Return