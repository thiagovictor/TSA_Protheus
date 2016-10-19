/*
+--------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦EPCPMS06  ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 22.05.2006¦
+----------+---------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Inicializador Padrao do campo Tipo de Projeto que preenchera o mesmo de acordo com¦ 
¦          ¦ a rotina executada                                                                ¦ 
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

User Function EPCPMS06()

Local cRet := ""

Do Case
   Case FunName() $ "EPCPMS01" //PROPOSTA
        cRet := "O"
   Case FunName() $ "EPCPMS02" // PROJETO PADRAO
        cRet := "E"   
   Case FunName() $ "EPCPMS03" //PROJETO
        cRet := "P"   
   Case FunName() $ "EPCPMS04" //OVER HEAD
        cRet := "H"   
   Case FunName() $ "EPCPMS05" //INVESTIMENTO
        cRet := "I"   
EndCase

Return(cRet)