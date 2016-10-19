/*
+-----------------------------------------------------------------------+
¦Programa  ¦ VldD3CC  ¦ Autor ¦ Crislei de A. Toledo  ¦ Data ¦11.09.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Validacao para o campo D3_CC que ira testar a rotina que   ¦
¦          ¦ esta sendo executada para identificar a variavel utilizada ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA EPC                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 |
+-----------------------------------------------------------------------+
*/

#include "rwmake.ch"

User Function VLDD3CC()

Local cVarSD3 := ""
Local lRet    := .T.

Do Case 
   Case FunName() $ "MATA240"
        cVarSD3 := "M->D3_CC"   
   Case FunName() $ "MATA241/MATA185"
        cVarSD3 := "CCC"        
EndCase

lRet := Posicione("CTT",1,xFilial("CTT")+&cVarSD3,"CTT_SITUAC") <> "3"


Return(lRet)