/*
+--------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦EPCPMS01  ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 22.05.2006¦
+----------+---------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Encapsula a rotina PMSA410 (Projetos Mod. 2) para inclusao de propostas           ¦ 
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

User Function EPCPMS01()

dbSelectArea("AF8")
Set Filter to AF8->AF8_TIPOPJ $ "O" //PROPOSTA

//Chamada do Programa
PMSA410()

dbSelectArea("AF8")
Set Filter To

Return