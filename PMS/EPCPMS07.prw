/*
+--------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦EPCPMS07  ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 23.05.2006¦
+----------+---------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Inicializador Padrao do campo Cod. do Projeto que será preenchido automaticamente ¦ 
¦          ¦ de acordo com o tipo do projeto                                                   ¦ 
+----------+-----------------------------------------------------------------------------------+
¦ Uso      ¦ ESPECIFICO PARA EPC                                                               ¦
+----------+-----------------------------------------------------------------------------------+
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                                   ¦
+------------+--------+------------------------------------------------------------------------+
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                                                    ¦
+------------+--------+------------------------------------------------------------------------+
¦            ¦        ¦                                                                        ¦
+------------+--------+------------------------------------------------------------------------+
*/

#include "rwmake.ch"
#include "topconn.ch"

User Function EPCPMS07()

Local cRet := ""
Local cOpc := ""
Local cQuery := "" 

Do Case
   Case FunName() $ "EPCPMS01" //PROPOSTA
        cOpc := "O"
   Case FunName() $ "EPCPMS02" //PROJETO PADRAO
        cOpc := "E"
   Case FunName() $ "EPCPMS03" //PROJETO 
        cOpc := "P"
   Case FunName() $ "EPCPMS04" //OVER HEAD
        cOpc := "H"
   Case FunName() $ "EPCPMS05" //INVESTIMENTO
        cOpc := "I"
EndCase

cQuery := "SELECT MAX(AF8_PROJET) AS MAXIMO FROM "+RetSqlName("AF8")+ " WHERE AF8_TIPOPJ = '"+ cOpc +"' AND D_E_L_E_T_ <> '*'"

TCQUERY cQuery ALIAS "QAF8" NEW

dbSelectArea("QAF8")
dbGoTop()

cRet := cOpc + StrZero(Val(Substr(QAF8->MAXIMO,2,4)) + 1,4) + "00"

dbCloseArea("QAF8")

Return(cRet)