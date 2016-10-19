/*
+-----------------------------------------------------------------------+
¦Programa  ¦PRCPMS01  ¦ Autor ¦Crislei de A. Toledo   ¦ Data |20/04/2007¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦Processo para realizar o Avanco Fisico a partir do avanco   ¦
¦          ¦dos Documentos por Projeto e Tarefa                         ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA TSA / EPC                                  ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
|            |        |                                                 |  
+-----------------------------------------------------------------------+
*/

#include "rwmake.ch"
#include "topconn.ch"

User Function PRCPMS01()

Local cPerg     := "PMSAVF" //PMS - AVANCO FISICO
Local aPerg     := {}

Local cProjInic := Space(10)
Local cProjFina := Space(10)
Local cQuery    := ""
//Local cTareInic := Space(30)
//Local cTareFina := Space(30)

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PARAMETROS DO RELATORIO:                                 ³
//³                                                         ³
//³MV_PAR01   Do Projeto                                    ³
//³MV_PAR02   Ate Projeto                                   ³
//³MV_PAR03   Da Tarefa                                     ³
//³MV_PAR04   Ate Tarefa                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

AADD(aPerg,{cPerg,"Do Projeto         ?","C",10,0,"G","","AF8","","","","",""})
AADD(aPerg,{cPerg,"Ate Projeto        ?","C",10,0,"G","","AF8","","","","",""})
//AADD(aPerg,{cPerg,"Da Tarefa          ?","C",30,0,"G","","AF9","","","","",""})
//AADD(aPerg,{cPerg,"Ate Tarefa         ?","C",30,0,"G","","AF9","","","","",""})



If !Pergunte(cPerg,.T.)
	Return
EndIf

cProjInic := MV_PAR01
cProjFina := MV_PAR02
//cTareInic := MV_PAR03
//cTareFina := MV_PAR04


If TcSpExist('EPCPMS001')
   
   cQuery := "SELECT DISTINCT GED_PROJET, GED_TAREFA, GED_DTAVAN, AF8_REVISA "
   cQuery += "FROM GEDPMS TAR INNER JOIN " + RetSqlName("AF8") + " AF8 ON "
   cQuery += "GED_PROJET = AF8_PROJET AND "
   cQuery += "AF8_TPAVAN NOT IN('M') AND "
   cQuery += "AF8.D_E_L_E_T_ <> '*' "
   cQuery += "WHERE GED_DTAVAN <> '' AND "
   cQuery += "GED_PROJET >= '" + cProjInic + "' AND "
   cQuery += "GED_PROJET <= '" + cProjFina + "' "
   cQuery += "ORDER BY GED_PROJET, GED_TAREFA, GED_DTAVAN "
     
   TcQuery cQuery Alias "QPMS" New

   dbSelectArea("QPMS")
   dbGoTop()
   
   While !Eof()
      //Processa({||TcSPExec ('EPCPMS001',cProjInic,cProjFina)},OemToAnsi("Gerando informações do Avanço Físico. Aguarde..."))
      
      Processa({||TcSPExec ('EPCPMS001',QPMS->GED_PROJET,QPMS->GED_TAREFA,QPMS->GED_DTAVAN)},OemToAnsi("Gerando informações do Avanço Físico. Aguarde..."))
      
      //Executa funcao padrao do sistema para atualização dos campos de Realização da Tarefa e EDT's.
      dbSelectArea("AFF")
      dbSetOrder(1)
      dbSeek(xFilial("AFF")+QPMS->GED_PROJET+QPMS->AF8_REVISA+QPMS->GED_TAREFA+QPMS->GED_DTAVAN)
      
      PmsAvalAFF("AFF",1)
      
      dbSelectArea("QPMS")
      dbSkip()
   End
   
   dbSelectArea("QPMS")
   dbCloseArea()  
Else
   MsgBox(OemToAnsi("Não existe a sp 'EPCPMS001', portanto esta rotina não poderá executada!"),"Mensagem do Administrador", "STOP")
EndIf

Return