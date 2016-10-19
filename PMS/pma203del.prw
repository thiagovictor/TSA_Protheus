/*
+--------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦PMA203DEL ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 10.05.2007¦
+----------+---------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Ponto de Entrada na exclusao da tarefa. Executa funcao que verifica se ja existem ¦ 
¦          ¦ documentos vinculados a tarefa.                                                   ¦ 
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

User function PMA203DEL()

Local lRet := .T.

lRet := U_VldTarefa(M->AF9_PROJET,M->AF9_TAREFA)

Return(lRet)